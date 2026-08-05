"""exp022 (S4b): pattern-mine missed optimizations — numba vs clang -O3
on semantically identical loops, both MEASURED (not just asm-diffed).

Six kernels (kernels.c mirrors the numba builders exactly, constants
included). clang-18 -O3 -march=native -ffast-math via ctypes; numba
njit(fastmath=True). Same arrays, same 5-rep timing, fp_arith-verified
probe on BOTH implementations (PerfGroup counts the whole process, so
ctypes calls are covered). Asm features from clang -S and inspect_asm
with the same regex. Version caveat recorded: clang 18.1.3 vs llvmlite's
bundled LLVM (older) — deltas may be version, pipeline config, or IR
shape; the FINDINGS are the measured deltas, attribution needs exp017-
style knob tests per case.

Run: taskset -c 2 .venv/bin/python exp022-asmdiff/bench.py
"""

import csv
import ctypes
import re
import subprocess
import sys
import time
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / "exp013-costmodel"))
sys.path.insert(0, str(HERE.parent))
from bench import make_kernel, asm_features  # noqa: E402
from numba import njit  # noqa: E402
from perfcnt import PerfGroup  # noqa: E402

CLANG = "clang-18"
REPS = 5
N = 1024 * 1024
D = ctypes.POINTER(ctypes.c_double)
L = ctypes.POINTER(ctypes.c_long)

rng = np.random.default_rng(7)
B = rng.random(N)
W = rng.random(256)
IDX = rng.integers(0, N - 8, 256).astype(np.int64)
A = np.zeros(N)


def c_asm_features(asm_text, fname):
    m = re.search(rf"^{fname}:[^\n]*\n(.*?)(?:^\s*\.cfi_endproc)", asm_text,
                  re.S | re.M)
    body = m.group(1)
    return {"packed_fma": len(re.findall(r"vfmadd\d+p[sd]", body)),
            "scalar_fma": len(re.findall(r"vfmadd\d+s[sd]", body)),
            "simd_regs": len(set(re.findall(r"[xy]mm\d+", body))),
            "asm_lines": body.count("\n")}


def build_c():
    so = HERE / "kernels.so"
    asm = HERE / "kernels.s"
    subprocess.run([CLANG, "-O3", "-march=native", "-ffast-math", "-shared",
                    "-fPIC", str(HERE / "kernels.c"), "-o", str(so)],
                   check=True)
    subprocess.run([CLANG, "-O3", "-march=native", "-ffast-math", "-S",
                    str(HERE / "kernels.c"), "-o", str(asm)], check=True)
    return ctypes.CDLL(str(so)), asm.read_text()


def numba_kernels():
    ns = {}
    exec("def red(b):\n"
         "    s = 0.0\n"
         "    for i in range(b.size):\n"
         "        x = b[i]\n"
         "        acc = 0.3\n"
         "        for _ in range(64):\n"
         "            acc = acc * x + 1.0001\n"
         "        s += acc\n"
         "    return s\n"
         "def sten(a, b, w):\n"
         "    for i in range(a.size - 64):\n"
         "        acc = 0.0\n"
         "        for k in range(64):\n"
         "            acc = acc + b[i + k] * w[k]\n"
         "        a[i] = acc\n"
         "def gath(a, b, idx, w):\n"
         "    for i in range(a.size):\n"
         "        acc = 0.0\n"
         "        for k in range(64):\n"
         "            acc = acc + b[idx[k] + (i & 7)] * w[k]\n"
         "        a[i] = acc\n"
         "def sax(a, b):\n"
         "    for i in range(a.size):\n"
         "        a[i] = 2.0 * b[i] + a[i]\n", ns)
    j = lambda f: njit(fastmath=True)(f)  # noqa: E731
    return {"saxpy": (j(ns["sax"]), (A, B), 2 * N),
            "poly96": (make_kernel(96, 1, np.float64), (A, B), 2 * 96 * N),
            "poly112": (make_kernel(112, 1, np.float64), (A, B), 2 * 112 * N),
            "reduction64": (j(ns["red"]), (B,), (2 * 64 + 1) * N),
            "stencil64": (j(ns["sten"]), (A, B, W), 2 * 64 * (N - 64)),
            "gather64": (j(ns["gath"]), (A, B, IDX, W), 2 * 64 * N)}


def c_callables(lib):
    p = lambda a: a.ctypes.data_as(D)  # noqa: E731
    pl = lambda a: a.ctypes.data_as(L)  # noqa: E731
    lib.reduction64.restype = ctypes.c_double
    n = ctypes.c_long(N)
    return {"saxpy": lambda: lib.saxpy(p(A), p(B), n),
            "poly96": lambda: lib.poly96(p(A), p(B), n),
            "poly112": lambda: lib.poly112(p(A), p(B), n),
            "reduction64": lambda: lib.reduction64(p(B), n),
            "stencil64": lambda: lib.stencil64(p(A), p(B), p(W), n),
            "gather64": lambda: lib.gather64(p(A), p(B), pl(IDX), p(W), n)}


def measure(call, useful):
    call()  # warmup / compile
    g = PerfGroup(fp=True)
    with g:
        call()
    g.close()
    ratio = g.flops() / useful
    times = []
    for _ in range(REPS):
        t0 = time.perf_counter()
        call()
        times.append(time.perf_counter() - t0)
    t = np.array(times)
    return (round(useful / t.mean() / 1e9, 2),
            round(t.std() / t.mean(), 4), round(ratio, 3))


def main():
    lib, casm = build_c()
    ck = c_callables(lib)
    rows = []
    for name, (jf, args, useful) in numba_kernels().items():
        gn, sn, rn = measure(lambda: jf(*args), useful)
        fn = asm_features(jf)
        gc, sc, rc = measure(ck[name], useful)
        fc = c_asm_features(casm, name)
        rows.append({"kernel": name, "numba_gflops": gn, "clang_gflops": gc,
                     "clang_over_numba": round(gc / gn, 3),
                     "numba_packed": fn["packed_fma"],
                     "clang_packed": fc["packed_fma"],
                     "numba_scalar": fn["scalar_fma"],
                     "clang_scalar": fc["scalar_fma"],
                     "numba_ratio": rn, "clang_ratio": rc})
        print(f"{name:<12} numba {gn:7.2f} ({fn['packed_fma']:3d}p/"
              f"{fn['scalar_fma']:3d}s, r={rn})  clang {gc:7.2f} "
              f"({fc['packed_fma']:3d}p/{fc['scalar_fma']:3d}s, r={rc})  "
              f"clang/numba {gc / gn:5.2f}x")
    with open(HERE / "results.csv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    print(f"wrote {HERE / 'results.csv'}")


if __name__ == "__main__":
    main()

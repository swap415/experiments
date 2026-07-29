"""exp020 (S3 phase 3): benefit-per-millisecond of LLVM opt levels.

What does numba's default O3 buy over O2/O1/O0 on real kernels, and at
what compile-time cost? NUMBA_OPT={3,2,1,0} in fresh subprocesses (env
is read at numba import). Kernels: map/poly (incl. one cliff row),
reduction, stencil (exp018 builders), each fp_arith-verified, 5 timing
reps, compile wall per kernel.

Run: .venv/bin/python exp020-optlevel/bench.py   (~4min)
"""

import csv
import json
import os
import subprocess
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPS = 5
N = 1024 * 1024
OPTS = ("3", "2", "1", "0")

KERNELS = [["map", [32, 1]], ["map", [96, 1]], ["map", [112, 1]],
           ["reduction", 64], ["reduction", 112],
           ["stencil", 64], ["stencil", 128]]


def child():
    import numpy as np
    from numba import njit
    sys.path.insert(0, str(HERE.parent / "exp013-costmodel"))
    sys.path.insert(0, str(HERE.parent))
    from bench import make_kernel, asm_features
    from perfcnt import PerfGroup

    rng = np.random.default_rng(7)
    B = rng.random(N)
    W = rng.random(256)

    def build(family, d):
        if family == "map":
            chain, accs = d
            return (make_kernel(chain, accs, np.float64),
                    (np.zeros(N), B), (2 * chain + accs - 1) * N,
                    2 * chain * N)
        if family == "reduction":
            src = (f"def f(b):\n"
                   f"    s = 0.0\n"
                   f"    for i in range(b.size):\n"
                   f"        x = b[i]\n"
                   f"        acc = 0.3\n"
                   f"        for _ in range({d}):\n"
                   f"            acc = acc * x + 1.0001\n"
                   f"        s += acc\n"
                   f"    return s\n")
            ns = {}
            exec(src, ns)
            useful = (2 * d + 1) * N
            return njit(fastmath=True)(ns["f"]), (B,), useful, useful
        if family == "stencil":
            src = (f"def f(a, b, w):\n"
                   f"    for i in range(a.size - {d}):\n"
                   f"        acc = 0.0\n"
                   f"        for k in range({d}):\n"
                   f"            acc = acc + b[i + k] * w[k]\n"
                   f"        a[i] = acc\n")
            ns = {}
            exec(src, ns)
            useful = 2 * d * (N - d)
            return (njit(fastmath=True)(ns["f"]), (np.zeros(N), B, W),
                    useful, useful)

    out = []
    for family, d in KERNELS:
        t0 = time.perf_counter()
        f, args, nominal, useful = build(family, d)
        f(*args)
        t_compile = (time.perf_counter() - t0) * 1e3
        feat = asm_features(f)
        g = PerfGroup(fp=True)
        with g:
            f(*args)
        g.close()
        times = []
        for _ in range(REPS):
            t0 = time.perf_counter()
            f(*args)
            times.append(time.perf_counter() - t0)
        times = np.array(times)
        out.append({"family": family, "d": str(d),
                    "compile_ms": round(t_compile, 1),
                    "time_ms": round(times.mean() * 1e3, 3),
                    "time_std_ms": round(times.std() * 1e3, 3),
                    "gflops": round(useful / times.mean() / 1e9, 2),
                    "flops_ratio": round(g.flops() / nominal, 4), **feat})
    print(json.dumps(out))


def main():
    rows = []
    for opt in OPTS:
        env = dict(os.environ, NUMBA_OPT=opt)
        r = subprocess.run(["taskset", "-c", "2", sys.executable, __file__,
                            "--child"], capture_output=True, text=True,
                           cwd=HERE.parent, env=env)
        assert r.returncode == 0, f"O{opt}: {r.stderr[-1200:]}"
        for d in json.loads(r.stdout):
            d["opt"] = opt
            rows.append(d)
            flag = " ELISION" if abs(d["flops_ratio"] - 1) > 0.05 else ""
            print(f"O{opt} {d['family']:<9} d={d['d']:<9} "
                  f"{d['gflops']:7.2f} GF/s  {d['packed_fma']:3d}p/"
                  f"{d['scalar_fma']:3d}s  {d['compile_ms']:6.1f}ms" + flag)
    with open(HERE / "results.csv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    print(f"wrote {HERE / 'results.csv'}")


if __name__ == "__main__":
    if "--child" in sys.argv:
        child()
    else:
        main()

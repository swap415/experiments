"""exp017 (S2): can the unroll cliff be fixed at the llvmlite layer?

exp013 measured: LLVM stops fully unrolling the inner chain loop past an
accs-dependent trip count (96/112/128 for accs 1/2/4 f64), the outer
element loop then fails to vectorize, throughput collapses ~4x. Candidate
fix at the cheapest layer: raise LLVM's unroll limits through llvmlite's
cl-opt interface (binding.set_option) — no fork of numba, usable by any
numba program today. If cl-opts are dead under numba's pass setup, that
is the layer decision made for us (numba-IR pass required).

Fresh subprocess per config (cl-opts are process-sticky, set before any
compile). Per kernel: compile wall time, packed/scalar fma from asm,
5 timing reps, one fp_arith-verified probe (elision check, exp013
discipline). Cliff rows f64 + last-vectorized controls.

Run: .venv/bin/python exp017-unroll/bench.py
"""

import csv
import json
import re
import subprocess
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPS = 5
N = 4 * 1024 * 1024

CONFIGS = {
    "default": [],
    "thresh2k": ["--unroll-threshold=2000"],
    "thresh16k": ["--unroll-threshold=16000",
                  "--unroll-full-max-count=4096"],
}
# (chain, accs, dtype): cliff rows + last-vectorized controls (f64)
KERNELS = [(c, a, "float64") for c, a in
           [(96, 1), (104, 1), (112, 1), (128, 1), (160, 1),
            (112, 2), (128, 2), (160, 2), (128, 4), (160, 4)]]
# --corpus: full exp013 grid, default vs thresh2k only
CORPUS = [(c, a, d) for d in ("float64", "float32") for a in (1, 2, 4)
          for c in (8, 16, 32, 48, 64, 80, 96, 104, 112, 128, 160)]

CHILD = r"""
import json, sys, time
sys.path.insert(0, {exp13!r})
sys.path.insert(0, {root!r})
from llvmlite import binding as llb
for opt in {opts!r}:
    llb.set_option("", opt)
import numpy as np
from bench import make_kernel, asm_features
from perfcnt import PerfGroup

out = []
for chain, accs, dname in {kernels!r}:
    dt = getattr(np, dname)
    t0 = time.perf_counter()
    f = make_kernel(chain, accs, dt)
    a, b = np.zeros({n}, dt), np.random.rand({n}).astype(dt)
    f(a, b)  # compile + warmup
    t_compile = time.perf_counter() - t0
    feat = asm_features(f)
    g = PerfGroup(fp=True)
    with g:
        f(a, b)
    g.close()
    nominal = (2 * chain + accs - 1) * {n}
    ratio = g.flops() / nominal
    times = []
    for _ in range({reps}):
        t0 = time.perf_counter()
        f(a, b)
        times.append(time.perf_counter() - t0)
    times = np.array(times)
    out.append({{"chain": chain, "accs": accs, "dtype": dname,
                 "compile_ms": round(t_compile * 1e3, 1),
                 "time_ms": round(times.mean() * 1e3, 3),
                 "time_std_ms": round(times.std() * 1e3, 3),
                 "gflops": round(2 * chain * {n} / times.mean() / 1e9, 2),
                 "flops_ratio": round(ratio, 4), **feat}})
print(json.dumps(out))
"""


def main():
    corpus = "--corpus" in sys.argv
    kernels = CORPUS if corpus else KERNELS
    configs = {k: CONFIGS[k] for k in
               (("default", "thresh2k") if corpus else CONFIGS)}
    rows = []
    for cname, opts in configs.items():
        code = CHILD.format(exp13=str(HERE.parent / "exp013-costmodel"),
                            root=str(HERE.parent), opts=opts,
                            kernels=kernels, n=N, reps=REPS)
        r = subprocess.run(["taskset", "-c", "2", sys.executable, "-c", code],
                           capture_output=True, text=True, cwd=HERE.parent)
        assert r.returncode == 0, f"{cname}: {r.stderr[-1500:]}"
        for d in json.loads(r.stdout):
            d["config"] = cname
            rows.append(d)
            flag = " ELISION" if abs(d["flops_ratio"] - 1) > 0.05 else ""
            print(f"{cname:<10} chain={d['chain']:3d} accs={d['accs']}  "
                  f"{d['gflops']:6.1f} GF/s  {d['packed_fma']:3d}p/"
                  f"{d['scalar_fma']:3d}s  compile {d['compile_ms']:6.1f}ms"
                  + flag)
    out = HERE / ("corpus.csv" if corpus else "results.csv")
    with open(out, "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    print(f"wrote {out}")


if __name__ == "__main__":
    main()

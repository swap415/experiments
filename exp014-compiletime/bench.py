"""exp014 phase 1: where do numba cold-start milliseconds go?

Eight representative kernels, each compiled in a FRESH subprocess (true
cold start, no on-disk cache), REPS reps. Child measures: numba import,
explicit compile (dispatcher.compile(sig), no execution), first exec
(pool spawn for parfors), second exec; and reads numba's own per-pass
timings (metadata pipeline_times) plus compiler_lock/llvm_lock timers.

Children are pinned to one P-core for timing stability, except the
parallel kernel (pool spawn on one core would be pathological).

Outputs: results.csv (one row per kernel x rep, totals) and passes.csv
(one row per kernel x rep x compiler pass, long format).

Run:  .venv/bin/python exp014-compiletime/bench.py
"""

import csv
import json
import os
import subprocess
import sys
import time
from pathlib import Path

REPS = 5
PIN_CORE = "2"

KERNELS = {
    "saxpy": ("""
def f(a, b):
    for i in range(a.size):
        a[i] = 2.0 * b[i] + a[i]
""", "np.zeros(64), np.ones(64)", {}),
    "reduce": ("""
def f(a):
    s = 0.0
    for i in range(a.size):
        s += a[i]
    return s
""", "np.ones(64),", {}),
    "stencil2d": ("""
def f(a, b):
    for i in range(1, a.shape[0] - 1):
        for j in range(1, a.shape[1] - 1):
            b[i, j] = 0.25 * (a[i-1, j] + a[i+1, j] + a[i, j-1] + a[i, j+1])
""", "np.ones((8, 8)), np.zeros((8, 8))", {}),
    "arrayexpr": ("""
def f(a, b, c):
    return a * b + c * 2.0 - a / (b + 1.0)
""", "np.ones(64), np.ones(64), np.ones(64)", {}),
    "poly16": ("""
def f(a, b):
    for i in range(a.size):
        x = b[i]
        acc = 0.1
        for _ in range(16):
            acc = acc * x + 1.0001
        a[i] = acc
""", "np.zeros(64), np.ones(64)", {}),
    "matmul3": ("""
def f(a, b, c):
    n = a.shape[0]
    for i in range(n):
        for j in range(n):
            s = 0.0
            for k in range(n):
                s += a[i, k] * b[k, j]
            c[i, j] = s
""", "np.ones((4, 4)), np.ones((4, 4)), np.zeros((4, 4))", {}),
    "branchy": ("""
def f(a):
    s = 0.0
    for i in range(a.size):
        x = a[i]
        if x > 0.5:
            s += math.sin(x)
        elif x > 0.25:
            s += math.sqrt(x)
        else:
            s -= x * x
    return s
""", "np.linspace(0, 1, 64),", {}),
    "prange_saxpy": ("""
def f(a, b):
    for i in prange(a.size):
        a[i] = 2.0 * b[i] + a[i]
""", "np.zeros(64), np.ones(64)", {"parallel": True}),
}


def child(name):
    t0 = time.perf_counter()
    import numba
    t_import = time.perf_counter() - t0
    import math  # noqa: F401  (branchy kernel)
    import numpy as np
    from numba import njit, prange  # noqa: F401

    src, argsrc, jitkw = KERNELS[name]
    ns = {"math": math, "np": np, "prange": prange}
    exec(src, ns)
    jf = njit(**jitkw)(ns["f"])
    args = eval(f"({argsrc})", ns)

    sig = tuple(numba.typeof(a) for a in args)
    t0 = time.perf_counter()
    jf.compile(sig)
    t_compile = time.perf_counter() - t0
    t0 = time.perf_counter()
    jf(*args)
    t_first = time.perf_counter() - t0
    t0 = time.perf_counter()
    jf(*args)
    t_second = time.perf_counter() - t0

    md = jf.get_metadata(jf.signatures[0])
    passes = {pl: {p: t.run for p, t in d.items()}
              for pl, d in md["pipeline_times"].items()}
    print(json.dumps({"import_s": t_import, "compile_s": t_compile,
                      "first_exec_s": t_first, "second_exec_s": t_second,
                      "timers": md["timers"], "passes": passes}))


def main():
    here = Path(__file__).resolve().parent
    rows, prows = [], []
    for name, (_, _, jitkw) in KERNELS.items():
        for rep in range(REPS):
            cmd = [sys.executable, __file__, "--child", name]
            if not jitkw.get("parallel"):
                cmd = ["taskset", "-c", PIN_CORE] + cmd
            r = subprocess.run(cmd, capture_output=True, text=True,
                               cwd=here.parent, env=os.environ)
            assert r.returncode == 0, f"{name}: {r.stderr[-2000:]}"
            d = json.loads(r.stdout)
            rows.append({"kernel": name, "rep": rep,
                         "import_s": round(d["import_s"], 4),
                         "compile_s": round(d["compile_s"], 4),
                         "first_exec_s": round(d["first_exec_s"], 4),
                         "second_exec_s": round(d["second_exec_s"], 6),
                         "compiler_lock_s": round(d["timers"]["compiler_lock"], 4),
                         "llvm_lock_s": round(d["timers"]["llvm_lock"], 4)})
            for pl, d2 in d["passes"].items():
                prows.extend({"kernel": name, "rep": rep, "pipeline": pl,
                              "pass": p, "run_s": round(t, 6)}
                             for p, t in d2.items())
            print(f"{name:12s} rep{rep}  import {d['import_s']*1e3:6.0f}ms  "
                  f"compile {d['compile_s']*1e3:6.0f}ms  "
                  f"llvm_lock {d['timers']['llvm_lock']*1e3:6.0f}ms")
    for fname, data in (("results.csv", rows), ("passes.csv", prows)):
        with open(here / fname, "w", newline="") as fh:
            w = csv.DictWriter(fh, fieldnames=list(data[0]))
            w.writeheader()
            w.writerows(data)
        print(f"wrote {here / fname}")


if __name__ == "__main__":
    if "--child" in sys.argv:
        child(sys.argv[sys.argv.index("--child") + 1])
    else:
        main()

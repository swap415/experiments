"""exp014 phase 3c: what does cache=True actually buy? (measured)

Phase 1 predicted a ceiling: a cache hit can skip only the pipeline
(35ms of saxpy's 193ms cold start = 18%) because import (94ms) and
first-compile init (64ms) are untouched. Here it is measured: per
kernel, fresh subprocess, three conditions —
  nocache : plain njit, cold (baseline)
  miss    : cache=True, empty cache dir (compile + serialize)
  hit     : cache=True, warm cache dir (load path)
Each child reports import time and time-to-first-result. n=REPS fresh
processes per condition; cache dir purged before each miss.

Run: .venv/bin/python exp014-compiletime/cache_eval.py
"""

import csv
import json
import os
import shutil
import statistics as st
import subprocess
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPS = 5
KERNELS = ("saxpy", "reduction", "stencil", "prange_saxpy")
CACHE_DIR = HERE / "_numba_cache"


def child(name, variant):
    t0 = time.perf_counter()
    import numpy as np
    sys.path.insert(0, str(HERE))
    import cachekernels  # noqa: F401  (imports numba + compiles nothing)
    t_import = time.perf_counter() - t0
    f = getattr(cachekernels, f"{name}_{variant}")
    args = {"saxpy": lambda: (np.zeros(64), np.ones(64)),
            "reduction": lambda: (np.ones(64),),
            "stencil": lambda: (np.zeros(256), np.ones(256), np.ones(64)),
            "prange_saxpy": lambda: (np.zeros(64), np.ones(64))}[name]()
    t0 = time.perf_counter()
    f(*args)
    t_first = time.perf_counter() - t0
    print(json.dumps({"import_s": t_import, "first_result_s": t_first}))


def run_child(name, variant, env):
    r = subprocess.run(["taskset", "-c", "2", sys.executable, __file__,
                        "--child", name, variant],
                       capture_output=True, text=True, cwd=HERE.parent,
                       env=env)
    assert r.returncode == 0, f"{name}/{variant}: {r.stderr[-800:]}"
    return json.loads(r.stdout)


def main():
    env = dict(os.environ, NUMBA_CACHE_DIR=str(CACHE_DIR))
    rows = []
    for name in KERNELS:
        conds = []
        for _ in range(REPS):
            shutil.rmtree(CACHE_DIR, ignore_errors=True)
            nc = run_child(name, "nc", env)
            shutil.rmtree(CACHE_DIR, ignore_errors=True)
            miss = run_child(name, "c", env)
            hit = run_child(name, "c", env)  # cache now warm
            conds.append((nc, miss, hit))
        for label, idx in (("nocache", 0), ("miss", 1), ("hit", 2)):
            imp = [c[idx]["import_s"] * 1e3 for c in conds]
            fst = [c[idx]["first_result_s"] * 1e3 for c in conds]
            tot = [a + b for a, b in zip(imp, fst)]
            rows.append({"kernel": name, "cond": label,
                         "import_ms": round(st.mean(imp), 1),
                         "first_ms": round(st.mean(fst), 1),
                         "first_std": round(st.stdev(fst), 1),
                         "total_ms": round(st.mean(tot), 1)})
            print(f"{name:<13} {label:<8} import {st.mean(imp):6.1f}  "
                  f"first {st.mean(fst):7.1f}±{st.stdev(fst):4.1f}  "
                  f"total {st.mean(tot):7.1f}ms")
    shutil.rmtree(CACHE_DIR, ignore_errors=True)
    with open(HERE / "cache_eval.csv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    print(f"wrote {HERE / 'cache_eval.csv'}")


if __name__ == "__main__":
    if "--child" in sys.argv:
        i = sys.argv.index("--child")
        child(sys.argv[i + 1], sys.argv[i + 2])
    else:
        main()

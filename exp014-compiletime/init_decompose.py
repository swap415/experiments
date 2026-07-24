"""exp014 phase 2b: decompose the ~64ms one-time first-compile init.

Fresh subprocess (n=REPS): import numba, then force the lazy pieces one
at a time — typing_context (typing registries), target_context (CPU
codegen, LLVM engine), context refresh — then compile a saxpy kernel.
If the named pieces account for the init, the final compile's overhead
(compile wall minus pass sum) collapses to ~1ms.

Run: .venv/bin/python exp014-compiletime/init_decompose.py
"""

import statistics as st
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPS = 5

CHILD = r"""
import time

def t(label, fn):
    t0 = time.perf_counter()
    fn()
    print(f"{label} {(time.perf_counter()-t0)*1e3:.2f}")

import numba
import numpy as np
from numba import njit
from numba.core.registry import cpu_target

t("typing_context", lambda: cpu_target.typing_context)
t("typing_refresh", lambda: cpu_target.typing_context.refresh())
t("target_context", lambda: cpu_target.target_context)
t("target_refresh", lambda: cpu_target.target_context.refresh())

@njit
def f(a, b):
    for i in range(a.size):
        a[i] = 2.0 * b[i] + a[i]
a, b = np.zeros(64), np.ones(64)
t0 = time.perf_counter()
f.compile((numba.typeof(a), numba.typeof(b)))
dt = (time.perf_counter() - t0) * 1e3
md = f.get_metadata(f.signatures[0])
psum = sum(x.run for d in md["pipeline_times"].values()
           for x in d.values()) * 1e3
print(f"compile_total {dt:.2f}")
print(f"compile_passes {psum:.2f}")
print(f"compile_overhead {dt - psum:.2f}")
"""


def main():
    acc = {}
    for _ in range(REPS):
        r = subprocess.run(["taskset", "-c", "2", sys.executable, "-c", CHILD],
                           capture_output=True, text=True, cwd=HERE.parent)
        assert r.returncode == 0, r.stderr[-800:]
        for line in r.stdout.splitlines():
            k, v = line.split()
            acc.setdefault(k, []).append(float(v))
    for k, v in acc.items():
        print(f"{k:<18} {st.mean(v):7.2f}±{st.stdev(v):.2f}ms")


if __name__ == "__main__":
    main()

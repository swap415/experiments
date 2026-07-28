"""exp014 phase 3a: measured floor for a warm-process (fork-server) strategy.

Parent pays the 190ms once (import numba + first compile), then forks.
Child measures, from the moment the parent initiates the fork:
  (a) time to execute the ALREADY-COMPILED kernel (serve-cached case)
  (b) time to compile+run a NEW kernel (warm-compile case)
perf_counter is monotonic and survives fork, so parent-side t0 is
directly comparable in the child. n=REPS forks each.

Run: taskset -c 2 .venv/bin/python exp014-compiletime/fork_floor.py
"""

import os
import statistics as st
import sys
import time

import numpy as np
import numba
from numba import njit

REPS = 10


def mk(c):
    def f(a):
        s = 0.0
        for i in range(a.size):
            s += a[i] * c
        return s
    return f


def timed_fork(work):
    t0 = time.perf_counter()
    r, w = os.pipe()
    pid = os.fork()
    if pid == 0:
        work()
        os.write(w, f"{(time.perf_counter() - t0) * 1e3:.3f}".encode())
        os._exit(0)
    os.waitpid(pid, 0)
    val = float(os.read(r, 64))
    os.close(r), os.close(w)
    return val


def main():
    a = np.ones(1024)
    f0 = njit(mk(1.0))
    t0 = time.perf_counter()
    f0(a)  # parent warmup: import already done, first compile here
    warm_ms = (time.perf_counter() - t0) * 1e3
    print(f"parent first compile+call: {warm_ms:.1f}ms (the cost paid once)")

    served = [timed_fork(lambda: f0(a)) for _ in range(REPS)]
    print(f"fork + cached kernel call:  "
          f"{st.mean(served):6.2f}±{st.stdev(served):.2f}ms (n={REPS})")

    i = [2.0]

    def compile_new():
        i[0] += 1.0
        jf = njit(mk(i[0]))
        jf(a)

    fresh = [timed_fork(compile_new) for _ in range(REPS)]
    print(f"fork + NEW kernel compile:  "
          f"{st.mean(fresh):6.2f}±{st.stdev(fresh):.2f}ms (n={REPS})")
    print(f"cold-start baseline (exp014 phase 1): ~193ms simple kernel")


if __name__ == "__main__":
    main()

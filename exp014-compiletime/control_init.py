"""exp014 control: is the ~64ms compiler_lock residue one-time or per-compile?

Compiles three distinct functions sequentially in one process; overhead =
compile wall minus pipeline-pass sum. One-time init predicts: large on
compile 0, ~1ms after.

Run: taskset -c 2 .venv/bin/python exp014-compiletime/control_init.py
"""

import time

import numpy as np
import numba
from numba import njit


def mk(c):
    def f(a):
        s = 0.0
        for i in range(a.size):
            s += a[i] * c
        return s
    return f


a = np.ones(64)
for i in range(3):
    jf = njit(mk(float(i + 1)))
    t0 = time.perf_counter()
    jf.compile((numba.typeof(a),))
    dt = (time.perf_counter() - t0) * 1e3
    md = jf.get_metadata(jf.signatures[0])
    psum = sum(t.run for d in md["pipeline_times"].values()
               for t in d.values()) * 1e3
    print(f"compile {i}: total {dt:6.1f}ms  passes {psum:5.1f}ms  "
          f"overhead {dt - psum:5.1f}ms")

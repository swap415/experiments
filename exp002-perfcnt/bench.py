"""exp002: validate the in-process perf counter harness (perfcnt.py).

Two checks:
1. ground truth — a serial numba loop with a known instruction count
   should read back within a few percent.
2. hybrid split — re-measure exp001's poly kernel with counters
   bracketing ONLY the kernel region (no JIT), splitting P vs E cycles.

Run: uv run python exp002-perfcnt/bench.py
"""

import sys
import time
from pathlib import Path

import numpy as np
from numba import njit, prange, set_num_threads

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from perfcnt import PerfGroup

N = 64 * 1024 * 1024
FMA_CHAIN = 64


@njit
def spin(n):
    # xorshift64: sequential dependency that instcombine can't compose
    # (an LCG here gets affine-folded under unrolling — measured, exp002)
    s = np.uint64(88172645463325252)
    for _ in range(n):
        s ^= s << np.uint64(13)
        s ^= s >> np.uint64(7)
        s ^= s << np.uint64(17)
    return s


@njit(parallel=True, fastmath=True)
def poly(a, b):
    for i in prange(a.size):
        x = b[i]
        acc = 0.0
        for _ in range(FMA_CHAIN):
            acc = acc * x + 1.000000001
        a[i] = acc


def main():
    pg = PerfGroup()  # open BEFORE numba spawns threads, so they inherit

    # check 1: xorshift64 is ~7 insn/iter (3 shift + 3 xor + loop); expect ~7e8
    spin(1000)
    with pg:
        spin(100_000_000)
    total = pg.counts["cpu_core/instructions"] + pg.counts["cpu_atom/instructions"]
    print(f"spin(1e8): {total/1e9:.2f} Ginsn total (expect ~0.7, serial loop)")
    print(pg.report(), "\n")

    # check 2: poly kernel only, per-PMU split
    a, b = np.zeros(N), np.random.rand(N)
    for nt in (4, 8, 12, 20, 28):
        set_num_threads(nt)
        poly(a, b)  # compile + warm + spawn pool
        t0 = time.perf_counter()
        with pg:
            for _ in range(5):
                poly(a, b)
        dt = (time.perf_counter() - t0) / 5
        gf = 2 * FMA_CHAIN * N / dt / 1e9
        print(f"poly threads={nt:2d}  {dt*1e3:6.1f}ms  {gf:6.1f} GFLOP/s")
        print(pg.report(), "\n")
    pg.close()


if __name__ == "__main__":
    main()

"""exp005: LLVM full-unroll cliff in numba fma kernels.

Sweeps the inner-loop trip count (fmas per element) on one pinned P-core and
counts packed-fma instructions in the generated asm. The per-flop rate drops
4.5x between chain=96 and chain=112 because LLVM stops fully unrolling the
inner loop, which in turn prevents outer-loop vectorization.

Run: taskset -c 2 uv run python exp005-unroll-cliff/bench.py
"""

import re
import time

import numpy as np
from numba import njit

N = 4 * 1024 * 1024


def make(chain):
    @njit(fastmath=True)
    def poly1(a, b):
        for i in range(a.size):
            x = b[i]
            acc = 0.0
            for _ in range(chain):
                acc = acc * x + 1.000000001
            a[i] = acc
    return poly1


def main():
    a, b = np.zeros(N), np.random.rand(N)
    for chain in (32, 64, 80, 96, 100, 104, 108, 112, 128):
        f = make(chain)
        f(a, b)
        times = []
        for _ in range(5):
            t0 = time.perf_counter()
            f(a, b)
            times.append(time.perf_counter() - t0)
        t = np.array(times)
        asm = next(iter(f.inspect_asm().values()))
        packed = len(re.findall(r"vfmadd\d+pd", asm))
        scalar = len(re.findall(r"vfmadd\d+sd", asm))
        gf = 2 * chain * N / 1e9
        print(f"chain={chain:3d}  {t.mean()*1e3:6.1f}ms (std {t.std()*1e3:4.1f})  "
              f"{gf/t.mean():5.1f} GFLOP/s  asm: {packed:3d} packed / {scalar:2d} scalar fma")


if __name__ == "__main__":
    main()

"""exp001: roofline baseline for numba kernels on i7-14700.

Establishes the two physics limits every later experiment is measured against:
memory bandwidth (triad) and compute throughput (fma chain).

Run:  uv run python exp001-roofline/bench.py
Perf: perf stat -D 5000 -e cycles,instructions,LLC-load-misses \
        uv run python exp001-roofline/bench.py --kernel triad --threads 8
"""

import argparse
import time

import numpy as np
from numba import njit, prange, set_num_threads

N = 64 * 1024 * 1024  # 64M float64 = 512 MB per array, far beyond 33 MB LLC
FMA_CHAIN = 64  # fmas per element in compute kernel


@njit(parallel=True, fastmath=True)
def triad(a, b, c, s):
    for i in prange(a.size):
        a[i] = b[i] + s * c[i]


@njit(parallel=True, fastmath=True)
def poly(a, b):
    for i in prange(a.size):
        x = b[i]
        acc = 0.0
        for _ in range(FMA_CHAIN):
            acc = acc * x + 1.000000001
        a[i] = acc


def bench(fn, args, reps):
    fn(*args)  # jit compile + warm
    times = []
    for _ in range(reps):
        t0 = time.perf_counter()
        fn(*args)
        times.append(time.perf_counter() - t0)
    t = np.array(times)
    return t.mean(), t.std()


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--kernel", choices=["triad", "poly", "both"], default="both")
    p.add_argument("--threads", type=int, default=0, help="0 = sweep")
    p.add_argument("--reps", type=int, default=10)
    args = p.parse_args()

    a = np.zeros(N)
    b = np.random.rand(N)
    c = np.random.rand(N)

    kernels = {
        "triad": (triad, (a, b, c, 3.0), 3 * N * 8 / 1e9, "GB/s"),  # rd b,c + wr a
        "poly": (poly, (a, b), 2 * FMA_CHAIN * N / 1e9, "GFLOP/s"),
    }
    todo = ["triad", "poly"] if args.kernel == "both" else [args.kernel]
    sweep = [args.threads] if args.threads else [1, 2, 4, 8, 12, 16, 20, 28]

    for name in todo:
        fn, fargs, work, unit = kernels[name]
        for nt in sweep:
            set_num_threads(nt)
            mean, std = bench(fn, fargs, args.reps)
            print(f"{name:5s} threads={nt:2d}  {mean*1e3:7.1f}ms (std {std*1e3:4.1f})  "
                  f"{work/mean:7.1f} {unit}")


if __name__ == "__main__":
    main()

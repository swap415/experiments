"""exp003: thread affinity x chunk size on hybrid P/E cores.

One configuration per process (affinity must precede pool spawn):
    taskset -c <cpus> uv run python exp003-hybrid-sched/bench.py \
        --threads N --chunksize C --label NAME
Driver: ./exp003-hybrid-sched/run.sh
"""

import argparse
import time

import numpy as np
from numba import njit, prange, set_num_threads, set_parallel_chunksize

N = 64 * 1024 * 1024
FMA_CHAIN = 64


@njit(parallel=True, fastmath=True)
def poly(a, b):
    for i in prange(a.size):
        x = b[i]
        acc = 0.0
        for _ in range(FMA_CHAIN):
            acc = acc * x + 1.000000001
        a[i] = acc


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--threads", type=int, required=True)
    p.add_argument("--chunksize", type=int, default=0, help="0 = static")
    p.add_argument("--label", default="")
    p.add_argument("--reps", type=int, default=10)
    p.add_argument("--chain", type=int, default=64, help="fmas per element")
    p.add_argument("--n", type=int, default=N, help="elements (small = cache-resident)")
    args = p.parse_args()

    global FMA_CHAIN
    FMA_CHAIN = args.chain  # numba binds globals at compile time, so set first

    set_num_threads(args.threads)
    set_parallel_chunksize(args.chunksize)
    a, b = np.zeros(args.n), np.random.rand(args.n)
    poly(a, b)  # compile + spawn pool + warm
    poly(a, b)

    times = []
    for _ in range(args.reps):
        t0 = time.perf_counter()
        poly(a, b)
        times.append(time.perf_counter() - t0)
    t = np.array(times)
    gf = 2 * FMA_CHAIN * args.n / 1e9
    print(f"{args.label:14s} nt={args.threads:2d} chunk={args.chunksize:>8d}  "
          f"{t.mean()*1e3:6.1f}ms (std {t.std()*1e3:4.1f})  "
          f"{gf/t.mean():6.1f} GFLOP/s")


if __name__ == "__main__":
    main()

"""exp006: user-level guided scheduling for hybrid cores (no numba patch).

Mechanism (verified in tbbpool.cpp:163): under the TBB layer, a prange over
K range-indices is dispatched dynamically by work-stealing. So we can feed
numba UNEQUAL ranges — guided (geometrically shrinking) sizes — from user
code: big ranges amortize per-division dispatch, small tail ranges bound
the E-core straggler. OpenMP has schedule(guided); numba does not — this
emulates it in ~15 lines on top of prange.

Schedulers compared (28 threads, all cores):
  static      plain prange, chunk=0        (numba default)
  chunk16K    set_parallel_chunksize(16384) (exp003 fix)
  chunk2K     set_parallel_chunksize(2048)  (fine grain, high dispatch cost)
  equalK      range-array machinery, K equal ranges = same count as guided
              (isolates machinery overhead from the guided sizing)
  guided      geometric range sizes, min chunk 2048

Run: uv run python exp006-guided/bench.py
"""

import argparse
import re
import time

import numpy as np
from numba import njit, prange, set_num_threads, set_parallel_chunksize

FMA_CHAIN = 64


@njit(parallel=True, fastmath=True)
def poly(a, b):
    for i in prange(a.size):
        x = b[i]
        acc = 0.0
        for _ in range(FMA_CHAIN):
            acc = acc * x + 1.000000001
        a[i] = acc


@njit(parallel=True, fastmath=True)
def poly_ranges(a, b, starts, ends):
    for k in prange(starts.size):
        for i in range(starts[k], ends[k]):
            x = b[i]
            acc = 0.0
            for _ in range(FMA_CHAIN):
                acc = acc * x + 1.000000001
            a[i] = acc


def guided_ranges(n, nthreads, min_chunk=2048, factor=2):
    starts, ends, pos, remain = [], [], 0, n
    while remain > 0:
        c = max(min_chunk, remain // (factor * nthreads))
        c = min(c, remain)
        starts.append(pos)
        ends.append(pos + c)
        pos += c
        remain -= c
    return np.array(starts, dtype=np.int64), np.array(ends, dtype=np.int64)


def equal_ranges(n, k):
    b = np.linspace(0, n, k + 1).astype(np.int64)
    return b[:-1].copy(), b[1:].copy()


def bench(fn, call, reps):
    fn(*call)
    fn(*call)
    times = []
    for _ in range(reps):
        t0 = time.perf_counter()
        fn(*call)
        times.append(time.perf_counter() - t0)
    return np.array(times)


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--threads", type=int, default=28)
    args = p.parse_args()
    set_num_threads(args.threads)

    # vectorization check: the hand-rolled inner loop must still emit packed fma
    a0, b0 = np.zeros(4096), np.random.rand(4096)
    s0, e0 = equal_ranges(4096, 4)
    poly_ranges(a0, b0, s0, e0)
    asm = next(iter(poly_ranges.inspect_asm().values()))
    packed = len(re.findall(r"vfmadd\d+pd", asm))
    print(f"poly_ranges asm: {packed} packed fma (0 would invalidate comparison)")

    for n in (262144, 1048576, 4194304, 67108864):
        a, b = np.zeros(n), np.random.rand(n)
        gs, ge = guided_ranges(n, args.threads)
        es, ee = equal_ranges(n, len(gs))
        reps = 200 if n <= 4194304 else 10
        gf = 2 * FMA_CHAIN * n / 1e9

        configs = [
            ("static", poly, (a, b), 0),
            ("chunk16K", poly, (a, b), 16384),
            ("chunk2K", poly, (a, b), 2048),
            ("equalK", poly_ranges, (a, b, es, ee), 0),
            ("guided", poly_ranges, (a, b, gs, ge), 0),
        ]
        print(f"--- n={n} ({n*8/1e6:.0f} MB/array, K={len(gs)} ranges) ---")
        for label, fn, call, chunk in configs:
            set_parallel_chunksize(chunk)
            t = bench(fn, call, reps)
            print(f"{label:9s} {t.mean()*1e3:7.3f}ms (std {t.std()*1e3:6.3f})  "
                  f"{gf/t.mean():6.1f} GFLOP/s")
        set_parallel_chunksize(0)


if __name__ == "__main__":
    main()

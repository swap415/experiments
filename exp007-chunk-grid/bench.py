"""exp007: does the ~16K chunk sweet spot (exp003) generalize?

Grid over kernel x n x chunksize x threads in one process: unlike thread
affinity (exp003, one process per config), set_num_threads and
set_parallel_chunksize are both runtime-settable per call. One CSV line
per config appended to --out as it completes.

Work accounting per element:
  triad    32 B      load b + load c + store a; the store costs 16 B
                     physically because write-allocate (RFO) reads the
                     line before writing it
  poly32   64 flops  32 fmas (Horner chain, 2 flops each)
  poly96   192 flops 96 fmas; below the chain=112 unroll cliff (exp005)
  stencil5 5 flops   4 add + 1 mul, interior i in [2, n-2) only -> n-4
  sumred   2 flops   mul + add reduction; value is returned and checked
                     so the region cannot be elided
  expk     1 op      one libm exp per element; "GFLOP/s" is nominal

Run:   cd experiments && uv run python exp007-chunk-grid/bench.py
Smoke: uv run python exp007-chunk-grid/bench.py --smoke --out /tmp/smoke.csv
"""

import argparse
import math
import time

import numpy as np
from numba import njit, prange, set_num_threads, set_parallel_chunksize

NS = (262144, 1048576, 4194304, 16777216, 67108864)
CHUNKS = (0, 4096, 16384, 65536, 262144)  # 0 = static schedule
THREADS = (16, 28)


@njit(parallel=True, fastmath=True)
def triad(a, b, c):
    for i in prange(a.size):
        a[i] = b[i] + 3.0 * c[i]


def make_poly(chain):
    @njit(parallel=True, fastmath=True)
    def poly(a, b):
        for i in prange(a.size):
            x = b[i]
            acc = 0.0
            for _ in range(chain):
                acc = acc * x + 1.000000001
            a[i] = acc
    return poly


@njit(parallel=True, fastmath=True)
def stencil5(a, b):
    for i in prange(2, a.size - 2):  # interior only: b[i-2]..b[i+2] in bounds
        a[i] = 0.2 * (b[i - 2] + b[i - 1] + b[i] + b[i + 1] + b[i + 2])


@njit(parallel=True, fastmath=True)
def sumred(b):
    s = 0.0
    for i in prange(b.size):
        s += b[i] * b[i]
    return s


@njit(parallel=True, fastmath=True)
def expk(a, b):
    for i in prange(a.size):
        a[i] = math.exp(b[i])


# name -> (fn, buffers it takes, work(n) -> (amount / 1e9, unit))
KERNELS = {
    "triad":    (triad,         "abc", lambda n: (32 * n / 1e9, "GB/s")),
    "poly32":   (make_poly(32), "ab",  lambda n: (64 * n / 1e9, "GFLOP/s")),
    "poly96":   (make_poly(96), "ab",  lambda n: (192 * n / 1e9, "GFLOP/s")),
    "stencil5": (stencil5,      "ab",  lambda n: (5 * (n - 4) / 1e9, "GFLOP/s")),
    "sumred":   (sumred,        "b",   lambda n: (2 * n / 1e9, "GFLOP/s")),
    "expk":     (expk,          "ab",  lambda n: (n / 1e9, "GFLOP/s")),
}


def measure(fn, call, min_time, max_reps, min_reps):
    """Repeat until >= min_time total or max_reps, never fewer than min_reps."""
    times, r = [], None
    while len(times) < min_reps or (sum(times) < min_time and len(times) < max_reps):
        t0 = time.perf_counter()
        r = fn(*call)
        times.append(time.perf_counter() - t0)
    assert r is None or np.isfinite(r)  # keep reduction result live
    return np.array(times)


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--kernel", default="", help="comma-separated subset of "
                   + ",".join(KERNELS))
    p.add_argument("--out", default="exp007-chunk-grid/results.csv")
    p.add_argument("--smoke", action="store_true", help="tiny grid, prove it runs")
    args = p.parse_args()

    names = args.kernel.split(",") if args.kernel else list(KERNELS)
    ns, chunks, threads = NS, CHUNKS, THREADS
    min_time, max_reps, min_reps = 0.3, 400, 3  # big n stops at min_time
    if args.smoke:
        names = names[:2] if args.kernel else ["triad", "sumred"]
        ns, chunks, threads = (65536,), (0, 16384), (4,)
        min_time, max_reps, min_reps = 0.0, 2, 1

    with open(args.out, "w") as out:
        out.write("kernel,n,threads,chunk,reps,mean_s,std_s,metric,unit\n")
        for name in names:
            fn, bufnames, work = KERNELS[name]
            for n in ns:
                bufs = {x: np.zeros(n) if x == "a" else np.random.rand(n)
                        for x in bufnames}
                call = [bufs[x] for x in bufnames]
                for nt in threads:
                    for chunk in chunks:
                        set_num_threads(nt)  # both runtime-settable per call
                        set_parallel_chunksize(chunk)
                        fn(*call)  # compile (first n only) + warm
                        t = measure(fn, call, min_time, max_reps, min_reps)
                        amount, unit = work(n)
                        line = (f"{name},{n},{nt},{chunk},{t.size},"
                                f"{t.mean():.6e},{t.std():.6e},"
                                f"{amount / t.mean():.4f},{unit}")
                        print(line)
                        out.write(line + "\n")
                        out.flush()


if __name__ == "__main__":
    main()

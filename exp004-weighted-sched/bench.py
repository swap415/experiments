"""exp004: self-calibrating weighted static partitioning on hybrid cores.

Bypasses numba's parallel scheduler: a persistent pool of pinned Python
threads, each running a serial @njit(nogil=True) slice between barriers.
Weights come from each thread's measured rate on an equal split, then the
array is repartitioned proportionally. Oracle comparison for exp003's
finding that numba's chunked scheduler can't exploit E-cores.

Run: uv run python exp004-weighted-sched/bench.py [--n 67108864]
"""

import argparse
import os
import threading
import time

import numpy as np
from numba import njit

FMA_CHAIN = 64
PCPUS = list(range(16))       # 8 P-cores x 2 HT
ECPUS = list(range(16, 28))   # 12 E-cores


@njit(nogil=True, fastmath=True)
def poly_slice(a, b, lo, hi):
    for i in range(lo, hi):
        x = b[i]
        acc = 0.0
        for _ in range(FMA_CHAIN):
            acc = acc * x + 1.000000001
        a[i] = acc


class Pool:
    """Persistent pinned threads; each rep executes bounds[k]..bounds[k+1]."""

    def __init__(self, cpus):
        self.cpus = cpus
        n = len(cpus)
        self.bounds = np.zeros(n + 1, dtype=np.int64)
        self.rates = np.zeros(n)
        self.go = threading.Barrier(n + 1)
        self.done = threading.Barrier(n + 1)
        self.stop = False
        self.a = self.b = None
        self.threads = [threading.Thread(target=self._worker, args=(k,), daemon=True)
                        for k in range(n)]
        for t in self.threads:
            t.start()

    def _worker(self, k):
        os.sched_setaffinity(0, {self.cpus[k]})
        while True:
            self.go.wait()
            if self.stop:
                return
            lo, hi = self.bounds[k], self.bounds[k + 1]
            t0 = time.perf_counter()
            poly_slice(self.a, self.b, lo, hi)
            self.rates[k] = (hi - lo) / (time.perf_counter() - t0)
            self.done.wait()

    def run(self, a, b, weights, reps):
        self.a, self.b = a, b
        n = a.size
        self.bounds[:] = np.concatenate(
            ([0], np.cumsum(weights / weights.sum() * n))).astype(np.int64)
        self.bounds[-1] = n
        times = []
        for _ in range(reps):
            t0 = time.perf_counter()
            self.go.wait()
            self.done.wait()
            times.append(time.perf_counter() - t0)
        t = np.array(times)
        return t.mean(), t.std(), self.rates.copy()

    def shutdown(self):
        self.stop = True
        self.go.wait()


def report(label, n, mean, std):
    gf = 2 * FMA_CHAIN * n / 1e9
    print(f"{label:22s} {mean*1e3:7.2f}ms (std {std*1e3:5.2f})  {gf/mean:6.1f} GFLOP/s")


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--n", type=int, default=64 * 1024 * 1024)
    p.add_argument("--reps", type=int, default=10)
    args = p.parse_args()
    a, b = np.zeros(args.n), np.random.rand(args.n)
    poly_slice(a, b, 0, 1024)  # compile

    pool_p = Pool(PCPUS)
    m, s, _ = pool_p.run(a, b, np.ones(16), args.reps)
    report("P-only-16 equal", args.n, m, s)
    # dispatch overhead: zero-length slices
    m, s, _ = pool_p.run(a[:16], b[:16], np.ones(16), args.reps)
    print(f"  dispatch overhead: {m*1e6:.0f}us")
    pool_p.shutdown()

    pool = Pool(PCPUS + ECPUS)
    m, s, rates = pool.run(a, b, np.ones(28), args.reps)
    report("P+E-28 equal", args.n, m, s)
    m, s, _ = pool.run(a, b, rates, args.reps)
    report("P+E-28 calibrated", args.n, m, s)
    w = rates / rates[:16].mean()
    print(f"  weights: P 1.00 (std {w[:16].std():.2f})  "
          f"E {w[16:].mean():.2f} (std {w[16:].std():.2f})")
    pool.shutdown()


if __name__ == "__main__":
    main()

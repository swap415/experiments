"""exp009 harness: weighted static scheduling in the (patched) workqueue layer.

Run via run.sh, which swaps the patched .so in and restores the original.
Order matters: the unpinned baseline runs before threads are pinned.

Configs (28 threads, poly chain=64):
  wq-static       stock behavior (no pin, no weights)
  wq-pinned-equal pinned 1:1 to cpus 0-27, weights unset (isolates pinning)
  wq-weighted     pinned + weights [1.0]*16 P + [0.34]*12 E (exp004 calib)
"""

import ctypes
import os
import time

os.environ["NUMBA_THREADING_LAYER"] = "workqueue"

import llvmlite.binding as ll
import numpy as np

_libc = ctypes.CDLL(None)
ll.add_symbol("ext_gettid", ctypes.cast(_libc.gettid, ctypes.c_void_p).value)

from numba import njit, prange, set_num_threads, threading_layer, types

ext_gettid = types.ExternalFunction("ext_gettid", types.int32())


@njit(parallel=True)
def who(tid):
    for i in prange(tid.shape[0]):
        tid[i] = ext_gettid()

FMA_CHAIN = 64
NT = 28


@njit(parallel=True, fastmath=True)
def poly(a, b):
    for i in prange(a.size):
        x = b[i]
        acc = 0.0
        for _ in range(FMA_CHAIN):
            acc = acc * x + 1.000000001
        a[i] = acc


def bench(a, b, reps):
    times = []
    for _ in range(reps):
        t0 = time.perf_counter()
        poly(a, b)
        times.append(time.perf_counter() - t0)
    t = np.array(times)
    gf = 2 * FMA_CHAIN * a.size / 1e9
    return t.mean(), t.std(), gf / t.mean()


def main():
    set_num_threads(NT)
    # measure division i -> executor TID directly (workqueue: static, stable)
    t = np.zeros(NT, dtype=np.int32)
    who(t)
    who(t)
    assert threading_layer() == "workqueue"
    tids = list(t)
    assert len(set(tids)) == NT, f"divisions share threads: {tids}"

    from numba.np.ufunc import workqueue as wq
    setter = ctypes.CFUNCTYPE(None, ctypes.POINTER(ctypes.c_double),
                              ctypes.c_int)(wq.set_thread_weights)

    def set_weights(w):
        arr = (ctypes.c_double * len(w))(*w)
        setter(arr, len(w))

    def clear_weights():
        setter(None, 0)

    sizes = ((262144, 400), (1048576, 400), (4194304, 100), (67108864, 10))
    data = {n: (np.zeros(n), np.random.rand(n)) for n, _ in sizes}
    for n, _ in sizes:
        poly(*data[n])  # warm each size before any timed config

    def run(label, n, reps):
        m, s, g = bench(*data[n], reps)
        print(f"n={n:>9d} {label:16s} {m*1e3:7.3f}ms (std {s*1e3:6.3f})  {g:6.1f} GFLOP/s")

    for n, reps in sizes:
        run("wq-static", n, reps)

    # pin worker i -> cpu i (0-15 P-cores incl HT, 16-27 E-cores)
    for i, tid in enumerate(tids):
        os.sched_setaffinity(tid, {i})
    for n, reps in sizes:
        run("wq-pinned-equal", n, reps)

    set_weights([1.0] * 16 + [0.34] * 12)
    for n, reps in sizes:
        run("wq-weighted", n, reps)

    # weight sensitivity: is the calibrated 0.34 special?
    for ew in (0.20, 0.27, 0.41, 0.50):
        set_weights([1.0] * 16 + [ew] * 12)
        for n, reps in ((1048576, 400), (4194304, 100)):
            run(f"wq-w-E{ew:.2f}", n, reps)
    clear_weights()


if __name__ == "__main__":
    main()

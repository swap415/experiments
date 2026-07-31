"""Kernels for cache_eval.py — top-level defs in a real source file
(numba's cache=True requires a locatable source; exec-built kernels
cannot cache). _c variants cache, _nc are the controls.
"""

from numba import njit, prange


def _saxpy(a, b):
    for i in range(a.size):
        a[i] = 2.0 * b[i] + a[i]


def _reduction(b):
    s = 0.0
    for i in range(b.size):
        x = b[i]
        acc = 0.3
        for _ in range(64):
            acc = acc * x + 1.0001
        s += acc
    return s


def _stencil(a, b, w):
    for i in range(a.size - 64):
        acc = 0.0
        for k in range(64):
            acc = acc + b[i + k] * w[k]
        a[i] = acc


def _prange_saxpy(a, b):
    for i in prange(a.size):
        a[i] = 2.0 * b[i] + a[i]


saxpy_nc = njit(fastmath=True)(_saxpy)
saxpy_c = njit(fastmath=True, cache=True)(_saxpy)
reduction_nc = njit(fastmath=True)(_reduction)
reduction_c = njit(fastmath=True, cache=True)(_reduction)
stencil_nc = njit(fastmath=True)(_stencil)
stencil_c = njit(fastmath=True, cache=True)(_stencil)
prange_saxpy_nc = njit(fastmath=True, parallel=True)(_prange_saxpy)
prange_saxpy_c = njit(fastmath=True, parallel=True, cache=True)(_prange_saxpy)

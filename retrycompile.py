"""retry_compile: fix the LLVM full-unroll cliff for numba kernels.

The measured policy from exp017/exp018 (oracle-0.1%, zero regressions on
87 variants, 4 families): compile normally; if the emitted asm has ZERO
packed fma (the inner loop collapsed to scalar — the cliff), recompile
once with --unroll-threshold=2000 and keep the retry iff it vectorizes.

The threshold is process-global while set (llvmlite cl-opt) but is
restored immediately after the retry compile; llvmlite honors the toggle
per-compile (verified exp017). verify=True additionally times both
variants on the provided args and keeps the measured winner — turns an
oracle-0.1% heuristic into the oracle at the cost of two timed calls.

    from retrycompile import retry_compile
    f = retry_compile(kernel, args)          # args: example invocation
    f(*args)
"""

import re
import time

from llvmlite import binding as llb
from numba import njit

# LLVM's BASE -unroll-threshold is 150, but O3 boosts the effective value
# to 300; the cl-opt overrides the boost, so restoring 150 would PIN the
# process below numba's true default and silently break kernels that need
# 150<t<=300 (measured: reduction d=96 loses 6.8x). Verified 2026-07-30.
DEFAULT_THRESHOLD = 300
RAISED_THRESHOLD = 2000   # exp017: fixes every measured cliff row

_packed = re.compile(r"vfmadd\d+p[sd]")


def _packed_fma(disp):
    return len(_packed.findall(next(iter(disp.inspect_asm().values()))))


def _time(disp, args):
    disp(*args)
    t0 = time.perf_counter()
    disp(*args)
    return time.perf_counter() - t0


def retry_compile(pyfunc, args, jit_kwargs=None, verify=False):
    """Compile pyfunc with njit; retry across the unroll cliff if the
    default compile failed to vectorize. Returns the chosen dispatcher."""
    kw = dict(fastmath=True)
    kw.update(jit_kwargs or {})
    base = njit(**kw)(pyfunc)
    base(*args)
    if _packed_fma(base) > 0:
        return base
    llb.set_option("", f"--unroll-threshold={RAISED_THRESHOLD}")
    try:
        retry = njit(**kw)(pyfunc)
        retry(*args)
    finally:
        llb.set_option("", f"--unroll-threshold={DEFAULT_THRESHOLD}")
    if _packed_fma(retry) == 0:
        return base
    if verify and _time(retry, args) >= _time(base, args):
        return base
    return retry

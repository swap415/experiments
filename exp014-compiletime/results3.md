# exp014 phase 3b: the parfors tracking gap, closed (2026-07-30)

Every llvm_lock hold timed via numba's event system and attributed to
its call site (parfors_gap.py, n=5 fresh subprocesses,
NUMBA_LLVM_PASS_TIMINGS=1 for the recorded-side comparison). Raw:
parfors_gap.csv. Note: pass-timing instrumentation inflates lock time
~30% vs phase 1's uninstrumented numbers (saxpy 40 vs 28ms, prange 108
vs 82ms); shares and deltas are the robust readings.

## attribution (mean ms under the lock, n=5)

| call site | saxpy | prange | delta |
|---|---:|---:|---:|
| executionengine:finalize_object (codegen+link) | 15.8 | 38.2 | +22.5 |
| newpassmanagers:run <- _optimize_final_module  |  8.8 | 35.6 | +26.8 |
| newpassmanagers:run <- _optimize_functions     |  7.8 | 15.6 |  +7.8 |
| everything else (11 sites < 5ms each)          |  9.8 | 23.6 | |
| TOTAL holds                                    | 42.2 | 113.0 | +70.8 |
| recorded by NUMBA_LLVM_PASS_TIMINGS            | 28.1 | 38.0 | |

(2026-08-02 audit: table synced to parfors_gap.csv — the original prose
quoted a pre-CSV console run, 0.1-0.6ms drift.)

## claims (recomputed from parfors_gap.csv)

1. Gap explained: parfors compiles EXTRA LLVM modules (gufunc body +
   parallel launcher) through the same codegen entry points but OUTSIDE
   the pass-timing recording context — the +57ms of extra optimize+
   finalize work is invisible to NUMBA_LLVM_PASS_TIMINGS, which only
   wraps the main module. Any per-pass account of parfors compile time
   built on that env var alone under-reports by ~3x.
2. The parfors compile-time premium is module-count, not pass-cost:
   optimize_final_module 4.0x saxpy's, finalize_object 2.4x. The
   attack surface (if ever needed) is compiling/caching FEWER modules
   (launcher reuse), not tuning passes — consistent with exp020's
   phase-3-negative verdict.
3. The llvm_lock is acquired 1502 (saxpy) / 3388 (prange) times per
   compile at ~28us mean hold — chatty but individually cheap; lock
   acquisition overhead is not a compile-time factor at this scale.

S3 measurement infrastructure is now complete: every millisecond of
cold start has a named owner (import graph -> registry imports ->
pipeline passes -> per-module LLVM work incl. untracked modules).
Remaining S3 thread: structural import surgery scoping (the 56ms
lazification budget) — a design task against numba internals, flagged
for a dedicated session.

Repro: `.venv/bin/python exp014-compiletime/parfors_gap.py`

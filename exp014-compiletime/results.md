# exp014 phase 1: anatomy of numba cold start (2026-07-23)

8 representative kernels, each compiled in a fresh subprocess (true cold
start), 5 reps, pinned P-core (except parfors). Raw: results.csv (totals),
passes.csv (per compiler pass). numba 0.66, n=5, std sub-ms throughout.

## per-kernel totals (ms, mean±std)

| kernel | import | compile | llvm_lock | llvm% |
|---|---:|---:|---:|---:|
| saxpy        |  94.2±0.3 |  98.7±0.9 | 28.1±0.3 | 28% |
| reduce       |  93.7±0.2 |  90.9±0.6 | 22.9±0.1 | 25% |
| stencil2d    |  94.2±0.3 | 126.6±0.8 | 45.3±0.3 | 36% |
| arrayexpr    |  94.2±0.7 | 192.9±1.1 | 83.5±0.8 | 43% |
| poly16       |  94.3±0.3 | 100.3±0.6 | 26.8±0.2 | 27% |
| matmul3      |  94.0±0.8 | 113.1±0.5 | 33.4±0.2 | 30% |
| branchy      |  94.1±0.1 | 100.4±0.7 | 25.7±0.1 | 26% |
| prange_saxpy | 122.5±0.4 | 176.6±1.2 | 82.0±0.6 | 46% |

## where compile time goes

compiler_lock == compile wall (0.0-0.1ms gap; nothing outside the lock).
Inside the lock, pass-pipeline sum vs lock leaves a constant residue:

    lock - passes = 63.3-64.2ms on ALL 8 kernels (kernel-INdependent)

Same-process control (3 sequential compiles of distinct functions):
95.2/28.7/66.5 ms (total/passes/overhead) on the first compile, then
25.7/24.6/1.1 and 26.0/25.0/1.0 — the ~64ms is ONE-TIME target/typing
context initialization, not per-compile cost.

Pass pipeline (mean ms summed over 8 kernels, 490ms total):
native_lowering 331.1 (67.6%) — of which llvm_lock is the bulk;
native_parfor_lowering 105.6 (21.6%, parfors kernel only);
nopython_type_inference 17.5 (3.6%); everything else < 1.5% each.

numba-side lowering (native_lowering minus llvm_lock) is 0.7-7.4ms for
plain kernels but 42.6ms for arrayexpr and 23.6ms for parfors.

## claims (recomputed from CSVs)

1. Cold-start anatomy, simple kernel (saxpy, 193ms import+compile):
   import 94ms (49%) + one-time init 64ms (33%) + pipeline 35ms (18%).
   82% of a simple kernel's cold start is FIXED process overhead that has
   nothing to do with the kernel being compiled.
2. Type inference is 3.6% of pipeline time — the folk theory that typing
   dominates numba compile time is false on this corpus. Lowering+LLVM is
   67.6%.
3. LLVM (llvm_lock) is 25-46% of per-kernel compile; the share grows with
   kernel complexity (arrayexpr 43%, parfors 46%). Pass-pruning can only
   touch this slice — bounded at ~28ms for simple kernels.
4. parallel=True costs +28ms import (threading layer) and +78ms compile
   (176.6 vs 98.7 saxpy): parfor lowering 105.6ms total is the single
   most expensive pass after native_lowering.
5. Implication for attack order (benefit-per-ms): (a) import + one-time
   init = 158ms fixed tax, hits every user, first target; (b) LLVM pass
   pruning helps complex kernels (80+ms) but is capped at ~25ms for
   simple ones; (c) on-disk caching skips the pipeline but NOT import
   or init — its ceiling for simple kernels is 35ms of 193 (18%).

## next (phase 2)

- import-time profile (python -X importtime): which numba submodules cost
  the 94ms; what's lazily deferrable.
- decompose the 64ms init (targets.registry refresh vs typing context).
- NUMBA_LLVM_PASS_TIMINGS=1 per-LLVM-pass table for arrayexpr/parfors,
  feeding phase 3 benefit-per-ms pruning (needs S1 cost model, ROADMAP gate).

Repro: `.venv/bin/python exp014-compiletime/bench.py` then `analyze.py`.

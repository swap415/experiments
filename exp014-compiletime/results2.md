# exp014 phase 2: the fixed tax is imports all the way down (2026-07-24)

Phase 1 found 158ms fixed cold-start overhead (import 94 + init 64).
Phase 2 decomposes both, plus the per-LLVM-pass table. n=5 throughout.
Raw: import_profile.csv, deferral.csv, llvm_passes.csv.

## 2a. import numba (94-101ms): a flat profile, structurally entangled

- 468 modules, largest single self-time 2.8ms (llvmlite.binding.dylib);
  no hotspot. By subsystem: numba.core 29.6ms, numpy 23.5ms, stdlib/misc
  32.7ms, llvmlite 9.5ms, everything else < 4ms each.
- importtime cumulatives mislead: numba.stencils "costs" 40.5ms
  cumulative but 0.4ms self — the subtree is shared deps.
- Causal deferral probe: stubbing ANY of the four candidates
  (stencils.stencil, np.types.datetime, experimental.jitclass,
  misc.special) BREAKS import numba outright (circular-import
  entanglement). Zero spot-lazification wins available.
- Floor: numpy 29.6ms, numpy+llvmlite.binding 44.4ms. Theoretical
  lazification budget ~56ms, reachable only by structural refactor
  (lazy registries / PEP-690-style), not spot fixes.

## 2b. the 64ms "init" is 91% MORE imports

Fresh-process decomposition (init_decompose.py):

| step | ms |
|---|---:|
| typing_context create | 0.01±0.00 |
| typing refresh        | 3.11±0.02 |
| target_context create | 1.18±0.04 |
| target_context.refresh| 58.38±0.20 |
| compile overhead after | 4.44±0.02 |

target_context.refresh -> cpu.load_additional_registries imports ~31
lowering/typing modules on first compile (cProfile: ~54 of 58ms inside
importlib; 251 recursive refresh calls). So of the 158ms fixed tax,
~150ms is Python module import + registry installation — split between
eager import (94ms) and imports hidden behind the first compile (58ms).

## 2c. inside llvm_lock (NUMBA_LLVM_PASS_TIMINGS=1, shares)

| kernel | recorded | module full-opt | finalize obj | function passes |
|---|---:|---:|---:|---:|
| saxpy     |  29.7ms (lock 28.1) | 33% | 31% | 33% |
| arrayexpr | 101.7ms (lock 83.5) | 40% | 36% | 19% |
| prange    |  41.9ms (lock 82.0) | 43% | 32% | 19% |

Top named passes everywhere: InstCombine (2.0-8.9ms), X86 DAG ISel
(2.0-6.9ms per module), LoopVectorize, SROA, LoopUnroll. Caveats:
instrumentation inflates arrayexpr ~20%; prange records only HALF its
llvm_lock — the parallel-region/gufunc wrapper compiles outside the
tracked pipeline (untracked 40ms, worth its own look).

## claims

1. The dominant cold-start cost is not compilation — it is ~150ms of
   module importing and registry building (79% of a 190ms simple-kernel
   cold start), confirmed causally: forcing the lazy contexts collapses
   first-compile overhead 64 -> 4.4ms.
2. No spot fix exists: the import graph breaks under any single-module
   stub, and the self-time profile is flat. Fixes are structural (lazy
   registries, import-graph surgery) or process-level (fork-server /
   warm daemon — which skips ALL 190ms, where on-disk caching skips
   only the 35ms pipeline).
3. Pass pruning upper bound (zero-risk): module full-opt is 33-43% of
   llvm_lock => <=10ms on saxpy-class kernels, ~33ms on arrayexpr-class.
   Real but second-order vs claim 1. Benefit-per-ms ranking for phase 3
   should weight InstCombine/ISel/vectorizer, informed by exp016's
   finding that dep-blind cost models mis-rank (prune opt, keep what
   the measured cost model justifies).
4. prange's untracked 40ms of llvm_lock (parallel wrapper path) is a
   measurement gap to close before pruning parfors pipelines.

Repro: `.venv/bin/python exp014-compiletime/import_profile.py`,
`init_decompose.py`, `llvm_passes.py`.

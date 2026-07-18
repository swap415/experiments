# research roadmap

Goal: publishable results in compiler/inference efficiency, produced on one
i7-14700 with numba/LLVM/perf. Every claim gets a rerunnable script and
measured numbers. Literature context in `research/scout-*.md`; our own
measurements outrank literature when they disagree.

## machine physics (measured, exp001/exp002)

- Memory wall: ~81 GB/s physical (90% of DDR5 peak; RFO-corrected, exp001),
  saturated by 4 threads. Any memory-bound kernel is done there.
- P-cores: ~5 IPC capable, ~0.9-0.95 on vectorized FMA chains.
  E-cores: flat 0.23 IPC on the same kernel — a 4x per-cycle gap.
- numba prange static chunking + OS thread placement leave ~2x compute
  throughput on the table on hybrid CPUs (28-thread poly hits 194 GFLOP/s;
  P-core math suggests ~400 obtainable).

## thread 1 — hybrid-aware scheduling & counter-driven autotuning (ACTIVE)

Our own finding; scout-compilers confirms no autotuning literature covers
P/E-core scheduling, and counter-guided autotuning has no CPU successor
since JPDC 2022 (arXiv:2102.05297). Deliverable: characterization + a
scheduling/chunking policy for JIT-compiled data-parallel loops on hybrid
CPUs, evidence-first.

- exp003 DONE: numba defaults lose 1.8x on hybrid (placement lottery +
  static chunking); set_parallel_chunksize(16K) recovers it; chunked
  scheduler reaches 98% of P+E sum when compute-bound. Three falsified
  hypotheses documented (bandwidth, fork/join, power).
- exp004 DONE (negative): Python-thread weighted dispatch fails below ~1ms
  regions (GIL wakeup stagger). Policy is sound (calibrated weights track
  physics); mechanism must live in the numba runtime.
- exp005 DONE: LLVM full-unroll cliff at trip count 96->100: 4.1x, asm-
  confirmed (4.5x by chain 112). Cost-model exhibit for thread 2.
- exp006 DONE: guided scheduling is anti-optimal on hybrid (head chunks
  are E-core traps, 2.8x worse); hybrid-safe rule c* ~ eps*N*(r_slow/
  r_total) predicts mid-size optima; sub-ms works down to ~0.15ms with
  fine uniform chunks. User-level unequal decomposition needs chunksize=1.
- exp007 DONE: 300-config grid; chunking beats static 60/60 cells (to
  2.5x); 16K default worst-case -24.6% at nt=28; unpinned+chunked beats
  pinned+static (396.8 vs 364 GFLOP/s).
- exp008 DONE: full fix is TBB-only; omp/workqueue dispatch pre-assigns
  divisions (verified in source, then measured): omp flat-to-negative,
  workqueue +13% max vs TBB's +44%. Layer fallback is silent.
- exp009 DONE: 30-line gufunc_scheduler patch (weighted static divisions
  + measured division->TID pinning): workqueue beats TBB best — 409.9
  GFLOP/s at 4M (93% of P+E sum, project record), 255.7 at 0.13ms region.
  Loses only at bandwidth-bound 64M (stealing adapts, static can't).
  Sub-ms regime RESOLVED. Three methodology scars documented.
- exp010 DONE: guided pathology confirmed on real OpenMP/libgomp — at 64M
  guided 82.7 ~ static 79.7 vs dynamic 123.8; onset tracks absolute
  head-chunk time as the exp006 mechanism predicts.
- NEXT: weight auto-calibration; weight-sensitivity sweep; upstream API
  proposal (set_thread_weights); counter-based chunk auto-tuner.
- paper target: "static chunking considered harmful on hybrid CPUs" —
  workshop-length. Evidence in hand through exp010; draft + figures in paper/.

## thread 2 — perf-grounded cost models for e-graph extraction

Numba v2 (SealIR/egglog, SciPy 2025) reframes optimization as cost
modeling + extraction, and nobody has hardware-validated CPU cost models.
We have the measurement infrastructure (perfcnt). Entry: build a corpus of
numba kernel variants (unroll/tile/fastmath/layout), measure counters,
fit/learn a cost model, test extraction quality. Feeds upstream numba
directly (local checkouts: ~/dev/numba, ~/dev/numbacc).

## thread 3 — KernelBench-for-CPU (roofline-scored)

kernelbench.com scores GPU kernels against hardware ceilings; no CPU
equivalent exists. We already produce the ceilings (exp001). Deliverable:
a small suite of numerical kernels + reference numba implementations,
scored as %-of-roofline, then use it as the fitness function for
LLM-generated/e-graph-extracted kernel variants (thread 2 synergy).

## thread 4 — agent-harness x local-inference efficiency

Scout-harness: no published token-efficiency measurements for Kilo-class
harnesses; prefix-cache hit rate is the dominant local lever; KV-quant
stability has zero rigorous data. Requires llama.cpp + a Qwen3-Coder-class
model on this box (CPU decode ~10-15 tok/s for 8B Q4 — slow but measurable).
- exp011: llama.cpp server instrumentation — per-turn n_past reuse, prefill
  tokens recomputed, RAPL joules/turn, while a harness solves fixed tasks.
- exp012: KV-cache quantization stability across multi-turn agent sessions.
- metrics: tokens-per-resolved-task, prefix-cache hit rate, joules/task.

## priority

1 now (evidence in hand, cheap iterations), 2 next (infrastructure reuse),
3 opportunistic (falls out of 1+2), 4 after a model is downloaded (network
and disk permitting).

## rules

- constraints: physics or assumption — label which before optimizing.
- ground-truth every counter with a known-instruction-count loop; watch for
  compiler elision (two traps documented in exp002).
- mean/std/n on every number; before/after tables; rerunnable commands.
- write to swap415/experiments only.

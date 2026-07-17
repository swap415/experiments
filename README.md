# experiments

Research sandbox: compilers (numba/LLVM), hardware counters, and inference
efficiency on commodity CPUs. Each `expNNN-*/` directory is one self-contained
experiment: a script that reproduces it and a `results.md` with measured
numbers. Claims require evidence; evidence requires a rerunnable command.

Hardware: Intel i7-14700 (8 P-cores + 12 E-cores), DDR5, Linux 6.8.

- `exp001-roofline/` — machine physics baseline: ~81 GB/s physical memory
  wall (90% of DDR5 peak), P/E-core IPC gap, static-chunking loss.
- `exp002-perfcnt/` — in-process perf_event_open harness (hybrid-PMU aware,
  JIT-excluding); two compiler-elision traps documented.
- `exp003-hybrid-sched/` — placement x chunk-size study: numba defaults
  lose 1.8x on hybrid cores; `set_parallel_chunksize(16K)` fixes it;
  chunked scheduler hits 98% of the P+E sum when compute-bound.
- `exp004-weighted-sched/` — calibrated weighted partitioning oracle;
  negative result: the GIL bars Python-thread dispatch below ~1ms regions.
- `exp005-unroll-cliff/` — LLVM full-unroll cliff: 4.1x throughput from a
  4-iteration trip-count change, asm-confirmed; cost-model exhibit.
- `exp006-guided/` — guided scheduling is ANTI-optimal on hybrid cores
  (head chunks are E-core traps, up to 2.8x worse); hybrid-safe chunk rule.
- `exp007-chunk-grid/` — 300-config generalization grid: chunking beats
  static in 60/60 cells; chunk=16K default worst-case -24.6% at nt=28.
- `exp008-layers/` — the chunking fix is TBB-only; omp flat, workqueue +13% max under
  the fallback layers (predicted from source, then measured).

Roadmap: `RESEARCH.md`. Literature: `research/scout-*.md`.
Shared tool: `perfcnt.py` (per-PMU in-process counters).

Setup: `uv sync`, then `uv run python expNNN-*/bench.py`.

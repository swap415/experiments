# exp007: chunk-size generalization grid

6 kernels x 5 sizes x 5 chunk settings x {16, 28} threads = 300 configs,
unpinned (the user-default scenario), TBB layer (the default when present).
Raw data: results.csv. Analysis: analyze.py.

## headline

Chunking beats static in 58/60 (kernel, n, threads) cells — up to 2.5x
(poly96 n=1M nt=16). The two exceptions are sumred at 256K (reduction-tree
sync dominates). This generalizes exp003 beyond one kernel: the static
default loses on every kernel class tested (streaming, fma-chain, stencil,
reduction, libm).

Best single default at nt=28: chunk=16384 — worst-case regression 24.6%
vs per-config best (poly96 n=1M, which wants 4K); typical gain 1.1-2.2x
vs static. At nt=16 the same default's worst case is 46.9% (poly96 256K).
Best chunk band is 4K-64K everywhere; a size-scaled rule is derived and
validated in exp006-guided/results.md.

## notable numbers

- poly32 n=1M nt=28 chunk4K: 396.8 GFLOP/s — beats every pinned config
  from exp003 (364 max). Unpinned + fine chunks > pinned + static.
- Cache-resident triad n=1M nt=16 chunk16K: 456 GB/s LLC bandwidth
  (5.6x the DRAM wall).
- DRAM triad rows: 76-83 GB/s physical == the exp001-corrected ~81 GB/s
  wall, independent of schedule (chunking gains here are only 1.02-1.15x).
- poly32 at 64M is bandwidth-capped: 2.67 flops/byte x 81 GB/s ~ 216
  GFLOP/s ceiling; measured 193-195. Matches roofline, not scheduling.
- expk (libm exp): only 2.6-3.7 GFLOP/s (nominal G-exp/s ~ 2.8-3.7) —
  latency-bound in libm; chunking still gives 1.03-2.5x.

## reading the grid

Best chunk shifts with n roughly as the hybrid-safe rule predicts
(smaller n -> smaller chunk): 256K wants 4K, 1M wants 4-16K, >=4M wants
16-64K. nt=16 unpinned benefits MORE from chunking than nt=28 (2-2.5x vs
1.1-2.2x): with fewer threads than cores the placement lottery is worse,
and stealing compensates.

Repro: `uv run python exp007-chunk-grid/bench.py` then `analyze.py`.

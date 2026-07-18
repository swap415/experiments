# exp003: thread placement x chunk size on hybrid P/E cores

poly kernel (chain=64, intensity ~5.3 flops/byte with RFO), N=64M unless
noted. P-cores: cpus 0-15 (8 phys x HT), E-cores: 16-27.

## placement (static chunking, DRAM-resident)

| config | GFLOP/s | note |
|---|---:|---|
| unpinned 4t | 138.5 | |
| Pphys 4t | 146.0 | |
| Pphys 8t | 288.2 | clean 2x of 4t — exp002's "8t anomaly" was placement |
| P+HT 16t | **363.9** | HT adds +26% |
| E-only 12t | 90.1 | |
| unpinned 8t | 264.5 (std 8.3ms) | placement lottery, high variance |
| unpinned 20t | 154.0 | static chunking + random placement |
| unpinned 28t | 198.0 | numba default: **1.8x worse than one-line fix** |

## chunk size (dynamic scheduling via set_parallel_chunksize)

28 threads, all cores: chunk 16384 → **356.9** GFLOP/s (vs 198 static).
Sweet spot is broad (4K-64K all ≥347); ≥1M degrades toward static.

## why no config beats P-only 364 here (three falsified hypotheses)

1. ~~Memory bandwidth~~ — cache-resident (N=1M, 8 MB/array, LLC-resident)
   shows the same cap: P+HT 16t 350.8, E-only 12t 87.7, all-28 chunk16K
   364.9 GFLOP/s. (350.8 + 87.7 = 438.5 ~ 439 is the compute-regime P+E
   sum used as the denominator in exp009.)
2. ~~Fork/join overhead~~ — measured 4.5us (16t P) vs 7.0us (28t): 0.6% of region.
3. ~~Power/frequency throttling~~ — P-cores hold 5300 MHz with E-cores loaded.

The real explanation is two regimes:
- **DRAM-resident, chain=64**: with RFO the kernel moves 24 B/element, so
  P+E's combined ~430 GFLOP/s would demand ~81 GB/s — the physical wall
  (see exp001 correction). Bandwidth co-limit; E-cores can't add.
- **Cache-resident, N=1M**: 64 chunks of 16384 are too coarse (one E-chunk
  = 0.29ms ~ the whole region gates the barrier); chunks fine enough to fix
  the tail (2048-8192) cost more in dispatch than they save: 330 GFLOP/s,
  *below* the coarse setting. Granularity has no good answer at sub-ms scale.

## compute-bound control (chain=128, latency-bound codegen — see exp005)

| config | GFLOP/s |
|---|---:|
| P+HT 16t | 68.2 |
| E-only 12t | 23.0 |
| all 28t, chunk 16384 | **89.6 = 98% of the 91.2 P+E sum** |

**numba's chunked scheduler is near-optimal on hybrid cores** when the
kernel is compute-bound and the region is long enough for coarse chunks.
The defaults are what's broken: static chunking + no pinning loses 1.8x.

## takeaways

1. On hybrid CPUs, `set_parallel_chunksize(~16K)` should be the default,
   not opt-in. One line, 1.8x on the standard config.
2. Placement variance makes unpinned numba runs a lottery (std up to 25%).
3. The only regime where no existing mechanism works: sub-ms parallel
   regions (tail-vs-dispatch dilemma). exp004 explores an oracle.

Repro: `./exp003-hybrid-sched/run.sh`

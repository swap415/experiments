# exp006: guided scheduling is ANTI-optimal on hybrid cores

Attempted a no-patch guided scheduler: prange over K unequal ranges
(geometric taper, big first, min 2048), each range its own stealable TBB
division via set_parallel_chunksize(1). Vectorization parity confirmed
(63 packed fma in poly_ranges asm).

## results (poly chain=64, 28 threads, GFLOP/s)

| n | static | chunk16K | chunk2K | equalK (control) | guided |
|---|---:|---:|---:|---:|---:|
| 256K | 165 | 166 | **245** | 199 | 198 |
| 1M   | 200 | **371** | 346 | 284 | 199 |
| 4M   | 183 | 345 | **382** | 283 | 136 |
| 64M  | 197 | **357** | 331 | 316 | 208 (std 8.1ms!) |

Two lessons, one per bug:

1. First run (chunk=0 on the ranges kernel): numba re-chunks the K-loop
   into 28 equal divisions, so the big head ranges land together in one
   thread's division — guided dropped to 55-106 GFLOP/s. Any user-level
   unequal decomposition MUST pin one range per division (chunksize=1).
2. Even fixed, guided loses up to 1.9x vs uniform chunking, with huge
   variance. Mechanism: guided's head ranges are N/(2*nt) elements; if an
   E-core steals one (it is exactly as likely to as a P-core), that range
   alone takes ~20ms at the E-core's ~7 GFLOP/s — comparable to the whole
   24ms region. Guided's taper assumes homogeneous consumers; on hybrid
   cores the head chunks are E-core traps. OpenMP schedule(guided) has the
   same structure and should inherit the same pathology (untested here).

## the hybrid-safe rule

The winning policy is uniform chunks small enough that the SLOWEST core
finishes any one chunk in a small fraction of the region:
c* ~ eps * N * (r_slowcore / r_total), eps ~ 0.1-0.2, r_E/r_total ~ 1/60
here. This predicts exp007's measured optima for mid sizes (1M -> ~4K,
4M -> ~16K) and the broad 4K-64K plateau; at 64M the plateau is wide
enough that anything in 16K-256K is within ~10%.

Also revises exp003's "sub-ms has no answer": chunk2K at n=256K (0.14ms
region) gives 245 GFLOP/s = 1.5x static. TBB + fine uniform chunks work
down to ~0.15ms; below that, per-division dispatch (~microseconds x
hundreds of divisions) dominates.

equalK control: uniform ranges through the same range-array machinery sit
within ~10-15% of equivalent plain chunking — machinery overhead is real
but secondary.

Repro: `uv run python exp006-guided/bench.py`

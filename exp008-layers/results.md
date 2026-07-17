# exp008: the chunking fix is TBB-only

Source-based predictions (verified in numba 0.66 source before running):
- tbbpool.cpp:163: tbb::parallel_for over division indices -> work-stealing
  dispatch -> chunking should help.
- workqueue.c:410: count = total/num_threads over division indices ->
  equal pre-assigned groups, no stealing -> chunking should not help.
- omppool.cpp: per-division `#pragma omp for` with default (static)
  schedule -> pre-assigned -> chunking should not help.

## measured (poly32, nt=28, GFLOP/s)

n=1M (compute-bound regime):
| layer | static | 4K | 16K | 64K | 256K |
|---|---:|---:|---:|---:|---:|
| tbb       | 275 | **396** | 321 | 276 | 275 |
| omp       | 280 | 272 | 229 | 286 | 289 |
| workqueue | 238 | 257 | 222 | 269 | 269 |

n=64M is bandwidth-capped for poly32 (~216 GFLOP/s roofline): all layers
167-193, chunking moves <=8% — physics, not scheduling.

All three predictions hold: +44% under TBB at n=1M, flat (or negative:
omp 16K = -18%) elsewhere. set_parallel_chunksize is a silent no-op on
the fallback layers.

## implication

numba's layer selection is silent (tbb -> omp -> workqueue by
availability). A user without TBB installed gets zero benefit from the
chunking fix and no warning. Any "chunked by default" recommendation must
be paired with layer awareness; conversely, every published numba
benchmark result is a function of an invisible environment detail.

exp003/exp007 numbers were all measured under TBB (verified via
threading_layer()).

Repro: `./exp008-layers/run.sh`

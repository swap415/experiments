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

Predictions hold in direction: +44% under TBB at n=1M; omp flat-to-negative
(16K = -18%); workqueue at most +13% (238 -> 269). The full fix is
TBB-only; on the fallback layers set_parallel_chunksize is silent and
mostly ineffective (omp) or captures under a third of the gain (workqueue).

## implication

numba's layer selection is silent (tbb -> omp -> workqueue by
availability). A user without TBB installed loses most of the chunking
fix's benefit (at best +13% under workqueue vs +44% under TBB) with no
warning. Any "chunked by default" recommendation must
be paired with layer awareness; conversely, every published numba
benchmark result is a function of an invisible environment detail.

exp003/exp007 numbers were all measured under TBB (verified via
threading_layer()).

Repro: `./exp008-layers/run.sh`

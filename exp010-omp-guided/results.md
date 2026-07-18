# exp010: guided-scheduling pathology confirmed on real OpenMP

Pure C + libgomp (gcc 13.3, -O3 -march=native -ffast-math -fopenmp), poly
chain=64, schedule(runtime), 28 threads. Full log: results.txt. GCC's
codegen is ~3x below numba's on this kernel (no multi-accumulator
interleave), so compare schedules within this table only.

## pass 2 (OMP_PROC_BIND=spread OMP_PLACES=cores), GFLOP/s

| n | static | dynamic,2048 | dynamic,16384 | guided | guided,2048 |
|---|---:|---:|---:|---:|---:|
| 256K | 30.1 | 78.8 | 40.2 | **79.8** | 41.6 |
| 1M   | 32.6 | 61.1 | 76.4 | **81.8** | 36.6 |
| 4M   | 60.5 | **109.0** | 110.1 | 69.1 | 53.5 |
| 64M  | 79.7 | **123.8** | 123.4 | 82.7 | 81.0 |

The onset matches the exp006 mechanism exactly: guided's first chunks are
~N/nthreads. At 256K-1M those are absolutely small (an E-core finishes one
in well under the region time), so guided is fine — even best. At 4M and
64M a head chunk on an E-core becomes comparable to the whole region and
guided collapses to static (82.7 vs 79.7 at 64M) while dynamic wins 1.5x.
Cross-runtime confirmation: the E-core-trap is a property of the guided
algorithm on hybrid cores, not a numba artifact — and it is invisible in
small-problem benchmarks.

Repro: `./exp010-omp-guided/run.sh`

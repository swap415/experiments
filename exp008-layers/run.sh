#!/bin/bash
# exp008: is the chunking fix TBB-specific?
# Source-based predictions (tbbpool.cpp:163 vs workqueue.c:410 vs omppool.cpp):
#   tbb       dispatches divisions via work-stealing  -> chunking helps
#   workqueue pre-assigns equal division groups       -> chunking no help
#   omp       distributes divisions with its own      -> chunking no help
#             (default static) schedule
# Reuses exp007's bench with a one-kernel subset per layer.
set -e
cd "$(dirname "$0")/.."
for layer in tbb omp workqueue; do
  echo "--- layer: $layer ---"
  NUMBA_THREADING_LAYER=$layer uv run python exp007-chunk-grid/bench.py \
    --kernel poly32 --out exp008-layers/results-$layer.csv
done

#!/bin/bash
# build: gcc -O3 -march=native -ffast-math -fopenmp -o poly poly.c -lm
set -e
cd "$(dirname "$0")"
gcc -O3 -march=native -ffast-math -fopenmp -o poly poly.c -lm

sweep() {
  for sched in static dynamic,2048 dynamic,16384 guided guided,2048; do
    for n in 262144 1048576 4194304 67108864; do
      OMP_SCHEDULE=$sched ./poly $n 10
    done
  done
}

export OMP_NUM_THREADS=28
echo "# pass 1: unpinned"
sweep
echo "# pass 2: OMP_PROC_BIND=spread OMP_PLACES=cores"
export OMP_PROC_BIND=spread OMP_PLACES=cores
sweep

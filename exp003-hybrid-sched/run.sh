#!/bin/bash
# exp003 driver: affinity x threads x chunksize sweep on i7-14700
# P-cores: cpus 0-15 (8 phys x 2 HT), E-cores: cpus 16-27
set -e
cd "$(dirname "$0")/.."
B="uv run python exp003-hybrid-sched/bench.py"
PPHYS=0,2,4,6,8,10,12,14

echo "--- placement (static chunking) ---"
$B --threads 4  --label unpinned-4
taskset -c $PPHYS $B --threads 4  --label Pphys-4
taskset -c $PPHYS $B --threads 8  --label Pphys-8
taskset -c 0-15   $B --threads 16 --label PallHT-16
taskset -c 16-27  $B --threads 12 --label Eonly-12
$B --threads 8  --label unpinned-8
$B --threads 20 --label unpinned-20
$B --threads 28 --label unpinned-28

echo "--- chunk size (28 threads, all cores) ---"
for c in 16384 65536 262144 1048576 4194304; do
  $B --threads 28 --chunksize $c --label all-28
done

echo "--- chunk size (20 threads: 8 Pphys + 12 E) ---"
for c in 65536 262144 1048576; do
  taskset -c $PPHYS,16-27 $B --threads 20 --chunksize $c --label Pphys+E-20
done
taskset -c $PPHYS,16-27 $B --threads 20 --label Pphys+E-20

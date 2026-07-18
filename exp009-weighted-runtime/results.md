# exp009: weighted static scheduling inside the numba runtime

A ~30-line patch to gufunc_scheduler.cpp (compiled into workqueue.so, ABI
preserved, sha-verified drop-in/restore): new `set_thread_weights(double*,
int)` export + a weighted split in create_schedule's 1D path, active only
when weight count == division count. Division i is pre-assigned to worker
i (verified property of the workqueue layer), workers pinned 1:1 to CPUs
via measured division->TID mapping (in-kernel gettid through
ll.add_symbol/ExternalFunction), weights = [1.0]x16 P + [0.34]x12 E
(exp004 calibration).

## results (poly chain=64, 28 threads, GFLOP/s)

| n | wq-static | wq-pinned-equal | wq-weighted | TBB best (exp006) |
|---|---:|---:|---:|---:|
| 256K | 107.6 | 147.2 | **255.7** | 245 (chunk2K) |
| 1M   | 172.0 | 192.6 | 358.8 | 371 (chunk16K) |
| 4M   | 196.1 | 195.9 | **409.9** | 382 (chunk2K) |
| 64M  | 194.9 | 199.0 | 331.2 | **357** (chunk16K) |

- 409.9 GFLOP/s at 4M is the highest throughput measured in this project
  (previous best 396.8, TBB chunk4K at 1M) — 93% of the 439 P+E compute
  sum, from 28 divisions, no stealing, on the layer that exp008 showed
  gains at most +13% from chunking.
- Sub-ms regime win: 255.7 at a 0.13ms region (vs 245 for TBB's best fine
  chunking, 107.6 for stock workqueue static). The residual gap to the
  compute sum (~58% of 439) is cond-var wakeup cost — the floor of this
  approach.
- Pinning alone (equal weights) is worth +12-37% at n<=1M (~0% at >=4M);
  the weights add +74-109% over pinned-equal in the compute regime
  (256K-4M) and +66% at bandwidth-bound 64M.
- Denominator provenance: 439 = 350.8 (P+HT 16t) + 87.7 (E-only 12t)
  GFLOP/s, cache-resident, exp003-hybrid-sched/results.md.
- Honest loss at 64M: bandwidth-bound, TBB's fine-grained stealing adapts
  to DRAM-contention jitter; no static split (equal or compute-weighted)
  can. Weighted static is a compute-regime tool.

## methodology scars (all cost real debugging time)

1. uv hardlinks venv files to its cache: `cp` over a .so writes through
   the shared inode and corrupts the cache copy; `uv run` may re-sync and
   re-link mid-experiment. Always rm-then-cp; invoke .venv/bin/python.
2. A relative path in a bash EXIT trap resolved after a `cd` and silently
   "restored" a DIFFERENT venv (overwrote numba 0.64's workqueue.so in
   ~/dev/.venv with 0.66's; repaired by force-reinstall). Absolute paths
   in traps, always.
3. The workqueue pool spawns at parfor COMPILE time (lowering registers
   threading symbols), and numpy/OpenBLAS adds ~27 threads of its own —
   /proc/self/task snapshot diffs are the wrong tool. Measure the
   division->TID map in-kernel instead (ext_gettid per division).

## weight sensitivity (second run; run-to-run ~3-5%)

| E-weight | 1M | 4M |
|---:|---:|---:|
| 0.20 | 359.6 | 397.9 |
| 0.27 | 371.4 | **418.1** |
| 0.34 (calib) | 369.3 | 397.8 |
| 0.41 | 329.3 | 343.6 |
| 0.50 | 290.6 | 313.3 |

418.1 GFLOP/s at E=0.27 is the new project record (95% of the 439 sum).
The curve is asymmetric: under-weighting E is nearly free (0.20-0.34
within ~5% of best — P-cores absorb the slack cheaply) while
over-weighting costs 15-25% (excess E-share gates the region at ~3x).
Calibration precision is not critical; round it DOWN.

## next

- auto-calibration (equal-split probe -> rates -> weights, exp004 loop)
  instead of hand-set values.
- upstream shape: a `set_thread_weights` API next to
  set_parallel_chunksize, or scheduler-internal calibration.

Repro: `./exp009-weighted-runtime/run.sh` (builds from patched copies in
src/, never touches the numba checkout; restores the venv on exit).

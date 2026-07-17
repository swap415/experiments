# exp004: self-calibrating weighted static partitioning (oracle attempt)

Idea: bypass numba's scheduler — persistent Python threads pinned 1:1 to
CPUs, each running a serial @njit(nogil=True) slice; measure per-thread
rates on an equal split, repartition proportionally (P:E ~ 3:1).

## results (poly chain=64)

DRAM (N=64M):
| config | GFLOP/s |
|---|---:|
| P-only 16t equal | 298.5 |
| P+E 28t equal | 166.9 (E-slices gate) |
| P+E 28t calibrated | 299.8 |

Calibrated weighting recovers exactly P-only throughput — consistent with
exp003's bandwidth co-limit: at the wall, redistributing work can't help,
and the calibration discovers that on its own (E weight 0.34).

Cache (N=1M): unusable. Dispatch overhead 204us on a 370us region, plus
GIL-staggered wakeup of 28 Python threads (~50us each to re-acquire the GIL
between barrier release and entering nogil code) inflate the region 4-6x.

## findings

1. **Python threads cannot drive sub-ms parallel regions at 28 threads** —
   the GIL serializes thread wakeup even when compute is nogil. The
   fine-grain scheduling fix has to live inside the numba runtime
   (or any single GIL-free dispatch layer), not above it.
2. Measured calibration weights are stable and physically meaningful
   (E/P = 0.34 DRAM-resident), so the *policy* is sound; only the
   dispatch mechanism is wrong.
3. Also: prange iteration->worker mapping is not 1:1 (observed a worker
   taking two slots) and thread->CPU placement is random per run, so
   weighted partitioning cannot be expressed with prange indices alone.
   A numba-runtime patch would need per-thread CPU identity.

Next (thread 1): prototype weighted chunking inside numba's workqueue
scheduler (local checkout at ~/dev/numba) — per-worker chunk-size scaling
by a calibration vector.

Repro: `uv run python exp004-weighted-sched/bench.py [--n 1048576]`

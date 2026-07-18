# RFC: `set_thread_weights` — weighted static divisions for hybrid CPUs

Status: draft (not yet submitted)
Target: numba GitHub issue / NBEP discussion
Scope: `parfor` 1D scheduling; `workqueue` threading layer first

## Summary

`create_schedule` divides a parallel region into equal-sized divisions. On
hybrid CPUs (Intel P/E cores) equal divisions make the whole region wait on
the slowest core class. `set_parallel_chunksize` fixes this, but (measured
below) only on the TBB layer; `workqueue` and `omp` users recover little or
nothing. This proposes a small opt-in API, `set_thread_weights(seq)`, beside
`set_parallel_chunksize`: a per-division weight vector applied in
`create_schedule`'s 1D path when the division count equals the weight count.
Default is unset — a strict no-op, byte-identical scheduling to today.

The core change is ~30 lines in `gufunc_scheduler.cpp` plus one exported
module attribute. Measured on an i7-14700 (8 P-cores + HT, 12 E-cores, 28
hardware threads, numba 0.66): weighted workqueue reaches 409.9 GFLOP/s
where stock static scheduling gets 196.1 and TBB's best chunk setting gets
382, and it is the only mechanism we found that works in the sub-ms region
regime.

## 1. Problem

Three measurements, all rerunnable (repro at the end). Kernel is a `prange`
polynomial-evaluation loop (64 FMAs/element, compute-bound at cache-resident
sizes), 28 threads.

**a. Defaults lose 1.8x on hybrid CPUs.** Equal static divisions + OS thread
placement: the region gates on whichever divisions land on E-cores (~4x
slower per cycle on this kernel). At N=64M the out-of-the-box configuration
delivers 198 GFLOP/s; adding one line, `set_parallel_chunksize(16384)`,
delivers 356.9 — 1.8x. (P-cores alone, pinned: 363.9.)

**b. The chunking fix is TBB-only.** The reason is visible in the source and
confirms under measurement. `tbbpool.cpp` runs `tbb::parallel_for` over
division indices — stealing rebalances fine divisions. `workqueue.c` assigns
`count = total/num_threads` divisions to each worker queue up front — no
stealing, so finer divisions mostly add dispatch cost. `omppool.cpp`
distributes divisions with a default-schedule `#pragma omp for` — same
story. Measured at N=1M (GFLOP/s):

| layer | static | chunk 4K | chunk 16K | best gain |
|---|---:|---:|---:|---:|
| tbb | 275 | **396** | 321 | +44% |
| omp | 280 | 272 | 229 | ~0 (often negative) |
| workqueue | 238 | 257 | 222 | +13% (at 64K) |

**c. Layer fallback is silent.** numba picks tbb → omp → workqueue by
availability. A user without TBB installed silently loses most of the
chunking fix with no warning. Hybrid CPUs are now the mainstream desktop
default; the fallback layers are exactly where an alternative mechanism is
needed — and workqueue's determinism (division *i* is pre-assigned to
worker *i*) turns out to be an asset rather than a limitation.

## 2. Proposal

```python
from numba import set_parallel_chunksize, set_thread_weights

# one weight per worker; e.g. 16 P-threads at 1.0, 12 E-threads at 0.27
set_thread_weights([1.0] * 16 + [0.27] * 12)
set_thread_weights(None)   # clear; back to equal divisions
```

Semantics:

- The weight vector is consulted in `create_schedule`'s 1D path **only when
  the division count equals the weight count** — i.e. the default
  chunksize-unset path where divisions == threads. If
  `set_parallel_chunksize` is active (division count derived from chunk
  size) the weights do not apply; the two APIs compose by never overlapping.
- Division *i* receives `round(N * w_i / sum(w))` iterations (cumulative
  split, last division absorbs rounding).
- Unset (default) or cleared: behavior is bit-identical to current numba.
- Per-layer behavior:
  - **workqueue**: division *i* is deterministically executed by worker *i*
    (existing property of `workqueue.c`, unchanged). Weights therefore
    directly control per-worker share. This is the supported target.
  - **tbb**: stealing makes the division→thread mapping dynamic; weighted
    division *sizes* are then only advisory granularity hints. Proposed:
    document as unsupported/unspecified on tbb initially (tbb users already
    have `set_parallel_chunksize`, which works well there).
  - **omp**: out of scope for this proposal.
- Calibration is the user's responsibility initially (see Open questions
  for auto-calibration). Measured sensitivity below shows precision is not
  critical.

The API is deliberately shaped like `set_parallel_chunksize`: a small
scheduling knob with a no-op default, not a new scheduler.

## 3. Evidence

Setup: i7-14700, Linux 6.8, numba 0.66, python 3.12. Kernel: `prange` poly,
chain=64 FMAs/element, 28 threads pinned 1:1 to hardware threads, weights
`[1.0]×16` (P) + `[0.34]×12` (E) calibrated from single-core-class runs.
A/B by swapping the patched `workqueue.so` into an otherwise stock wheel
(sha256-verified restore), so both sides run identical Python and LLVM
codegen. 5 runs per cell; run-to-run spread ~3-5%.

| N | wq static (stock) | wq pinned, equal | wq pinned, weighted | TBB best chunk |
|---|---:|---:|---:|---:|
| 256K | 107.6 | 147.2 | **255.7** | 245 (2K) |
| 1M | 172.0 | 192.6 | 358.8 | 371 (16K) |
| 4M | 196.1 | 195.9 | **409.9** | 382 (2K) |
| 64M | 194.9 | 199.0 | 331.2 | **357** (16K) |

GFLOP/s throughout. Observations:

- **4M: 409.9 GFLOP/s = 93% of the machine's 439 P+E compute sum** (439 =
  350.8 for P+HT 16t + 87.7 for E-only 12t, cache-resident, measured
  independently). This is from 28 divisions and no stealing, on the layer
  where chunking gains at most +13%. It exceeds the best TBB configuration
  we found across a 300-config chunk grid.
- **Sub-ms regions: 255.7 vs 245 (TBB best) vs 107.6 (stock).** The 256K
  region is ~0.13ms. Fine chunking pays per-division dispatch there; coarse
  chunking pays the E-core tail; nthreads weighted divisions pay one
  wakeup per worker and have no tail. This regime previously had no good
  answer under any layer/chunksize combination we measured.
- **Decomposition of the gain:** pinning alone (equal weights) is worth
  +12-37% at N≤1M and ~0% above; the weights add a further +74-109% in the
  compute-bound regime. The weights, not the pinning, carry the result.
- **Honest loss at 64M** (bandwidth-bound for this kernel): 331.2 vs TBB's
  357. Fine-grained stealing adapts to DRAM-contention jitter; no static
  split can. Weighted static is a compute-regime tool, and the docs should
  say so.

Weight sensitivity (E-weight sweep, P fixed at 1.0):

| E-weight | 1M | 4M |
|---:|---:|---:|
| 0.20 | 359.6 | 397.9 |
| 0.27 | 371.4 | **418.1** |
| 0.34 (calibrated) | 369.3 | 397.8 |
| 0.41 | 329.3 | 343.6 |
| 0.50 | 290.6 | 313.3 |

The curve is asymmetric: under-weighting E-cores is nearly free (0.20-0.34
all within ~5% of best — P-cores absorb slack cheaply), over-weighting
costs 15-25% (excess E-share gates the region). Practical guidance for
users: round weights **down**. Calibration precision is not critical, which
is what makes a user-supplied-weights v1 viable.

Repro (builds a patched `workqueue.so` from copied sources, swaps it in,
benches, restores the venv with sha verification; never touches a numba
checkout):

```
git clone https://github.com/swap415/experiments && cd experiments
uv sync
./exp009-weighted-runtime/run.sh
```

## 4. Implementation sketch

Complete diff of the scheduling change against numba main
(`numba/np/ufunc/gufunc_scheduler.cpp`):

```diff
--- a/numba/np/ufunc/gufunc_scheduler.cpp
+++ b/numba/np/ufunc/gufunc_scheduler.cpp
@@ -318,6 +318,15 @@
  * full_space is the iteration space in each dimension.
  * num_sched is the number of worker threads.
  */
+// Optional per-division weights for heterogeneous (P/E) cores.
+// Applies only when division count == weight count (chunksize==0 path).
+static std::vector<double> thread_weights;
+
+extern "C" void set_thread_weights(double *w, int n) {
+    if (n <= 0) { thread_weights.clear(); return; }
+    thread_weights.assign(w, w + n);
+}
+
 std::vector<RangeActual> create_schedule(const RangeActual &full_space, uintp num_sched) {
     // Compute the number of iterations to be run for each dimension.
     std::vector<intp> ipd = full_space.iters_per_dim();
@@ -343,6 +352,27 @@
         } else {
             // There are more iterations than threads.
             std::vector<RangeActual> ret;
+            if (thread_weights.size() == num_sched) {
+                double wsum = 0.0;
+                for (uintp i = 0; i < num_sched; ++i) wsum += thread_weights[i];
+                double acc = 0.0;
+                intp cur = 0;
+                for (uintp i = 0; i < num_sched; ++i) {
+                    acc += thread_weights[i];
+                    intp split = (i == num_sched - 1) ? ra_len
+                               : (intp)((double)ra_len * (acc / wsum) + 0.5);
+                    if (split < cur) split = cur;
+                    if (split > ra_len) split = ra_len;
+                    if (split > cur) {
+                        ret.push_back(RangeActual(full_space.start[0] + cur,
+                                                  full_space.start[0] + split - 1));
+                    } else {
+                        ret.push_back(RangeActual((intp)1, (intp)0));
+                    }
+                    cur = split;
+                }
+                return ret;
+            }
             // cur holds the next unallocated iteration.
             intp cur = 0;
             // For each thread...
```

Plus the export in `numba/np/ufunc/workqueue.c` (same
`SetAttrStringFromVoidPointer` pattern as the existing scheduling symbols):

```diff
--- a/numba/np/ufunc/workqueue.c
+++ b/numba/np/ufunc/workqueue.c
@@ -638,6 +638,9 @@
     _nesting_level = 0;
 }
 
+/* defined in gufunc_scheduler.cpp */
+extern void set_thread_weights(double *w, int n);
+
 MOD_INIT(workqueue)
 {
     PyObject *m;
@@ -660,6 +663,7 @@
     SetAttrStringFromVoidPointer(m, get_sched_size);
     SetAttrStringFromVoidPointer(m, allocate_sched);
     SetAttrStringFromVoidPointer(m, deallocate_sched);
+    SetAttrStringFromVoidPointer(m, set_thread_weights);
 
     return MOD_SUCCESS_VAL(m);
 }
```

Notes:

- **ABI**: the only addition is one new module attribute on the workqueue
  extension module. No existing exported symbol, struct layout, or the
  sched buffer format changes. The patched `workqueue.so` above was used
  as a drop-in replacement inside the published 0.66 wheel for all
  measurements.
- **Python glue** (not shown, ~15 lines): a `set_thread_weights(seq)`
  wrapper in `numba/np/ufunc/parallel.py` following the
  `set_parallel_chunksize` pattern — validate the sequence, pass a
  `double*` via ctypes to the active layer's symbol, no-op with a
  documented warning on layers that don't export it.
- The multi-dimensional path and the `sched_size`-based chunked path are
  untouched; the weighted branch is entered only from the 1D
  divisions==threads path, which is what makes the "composes with
  chunksize by never overlapping" semantics fall out for free.
- Tests: (1) weights unset → schedules identical to current output for a
  sweep of (N, nthreads); (2) weights set → division sizes match the
  cumulative formula, cover [0, N) exactly, monotone, empty divisions
  well-formed; (3) clear restores equal split.

## 5. Open questions

1. **Auto-calibration.** Weights could be measured by the runtime itself:
   run one equal-split region, read per-worker completion times (or a
   cycles counter), set weights from the rates. The sensitivity table
   suggests a single coarse probe is enough. Should this live in numba, or
   stay a documented user recipe? v1 proposes user-supplied weights only.
2. **Interaction with `set_num_threads`.** If the thread count changes
   after weights are set, the division count no longer matches the weight
   count and weights silently stop applying (safe, but surprising). Options:
   rescale, warn, or clear on `set_num_threads`. Silent-deactivate matches
   the C-level check but likely deserves at least a warning.
3. **Thread pinning portability.** The measured gains rely on a stable
   worker→core-class mapping. The workqueue division→worker mapping is
   deterministic on all platforms, but the worker→CPU mapping is the OS's
   choice; our measurements pinned via `sched_setaffinity` (Linux). Without
   pinning, weights still help on average but with placement variance.
   Windows/macOS behavior needs measurement; numba currently has no
   official pinning API and this proposal does not add one.
4. **Per-call vs global.** `set_parallel_chunksize` is thread-local with a
   context-manager form. Weights are more naturally process-global (they
   describe the machine, not the call site), but parity with chunksize may
   be less surprising. Proposed: global in v1, revisit if a use case for
   per-region weights appears.
5. **Whether tbb should ever honor weights.** Probably not — stealing
   already solves the problem there, better in the bandwidth-bound regime
   (357 vs 331 at 64M above). Keeping tbb out avoids promising semantics
   the layer cannot deliver.

# workshop paper skeleton — thread 1 (hybrid-aware scheduling)

Target: LCTES/CGO-workshop length (~6 pages). Evidence sources: exp001-010
results.md; literature anchors: research/scout-compilers.md. Every number
below is copied from a results.md; nothing is invented.

## candidate titles

1. **One Line Loses 2x, Thirty Lines Win It Back: Parallel-Loop
   Scheduling on Hybrid CPUs** (new leading candidate — foregrounds the
   exp009 headline)
2. Static Chunking Considered Harmful on Hybrid CPUs (previous working
   title)
3. One Line, 1.8x: Measuring and Fixing JIT Parallel-Loop Defaults on
   Hybrid x86
4. Equal Chunks, Unequal Cores: A Counter-Grounded Characterization of
   numba Parallel Loops on P/E-Core CPUs
5. Guided Scheduling Considered Harmful on Hybrid CPUs (alternative —
   foregrounds the exp006 negative result)

## abstract (~250 words)

Intel's hybrid CPUs pair performance and efficiency cores with a measured
3-4x per-cycle throughput gap, yet JIT compilers still split parallel loops
into equal static chunks. On an i7-14700, numba's defaults deliver 198
GFLOP/s on a compute-heavy kernel where pinned P-cores alone reach 364 — a
1.8x loss from defaults, before any code change. Using an in-process
perf_event_open harness with per-PMU (cpu_core/cpu_atom) counters that
bracket only the measured region, we test and falsify three plausible
explanations — memory bandwidth, fork/join overhead, and frequency
throttling — isolating static chunking plus placement as the cause. A
one-line fix, `set_parallel_chunksize(16384)`, recovers the loss, and a
300-config grid shows it generalizes: chunking beats static in 60/60
kernel/size/thread cells, up to 2.5x. But the one-line fix is TBB-only —
flat-to-negative under numba's omp fallback layer, at most +13% under
workqueue, all three behaviors predicted from dispatch source before
measurement — and the textbook alternative fails in the opposite
direction: guided scheduling is anti-optimal on hybrid cores — its
geometric head chunks are E-core traps, up to 2.8x worse than uniform
chunking — a pathology we confirm on pure C + libgomp, where guided
collapses to static at 64M (82.7 vs 79.7 GFLOP/s) while dynamic wins
1.5x. So we patch the runtime: ~30 lines in numba's gufunc_scheduler —
weighted static division sizing (weights calibrated P=1.0/E=0.34) plus
1:1 pinning via a measured division->TID mapping — make the workqueue
fallback outperform TBB's work-stealing best: 409.9 GFLOP/s at n=4M (93%
of the 439 P+E compute sum) and 255.7 at a 0.13 ms region where TBB
manages 245 and stock workqueue 107.6, resolving the sub-ms regime down
to a cond-var wakeup floor. The honest scope: at bandwidth-bound n=64M
stealing still wins (357 vs 331) — weighted static is a compute-regime
tool, and an 81 GB/s physical wall (90% of DDR5 peak) caps every
schedule.

## outline

### 1. introduction

The pitch: hybrid P/E cores are now the default desktop x86 topology, but
the parallel-runtime layer of Python's dominant JIT (numba parfors) still
assumes homogeneous cores. We show the defaults cost 1.8x, a one-line
setting recovers it — but only under one of numba's three threading
layers — the textbook alternative (guided) makes hybrid worse, and
thirty lines of weighted static scheduling inside the runtime make the
weakest layer beat the best.
Contributions list: (a) headline — a ~30-line gufunc_scheduler patch
(weighted static division sizing + 1:1 pinning via a measured
division->TID mapping, weights calibrated P=1.0/E=0.34) that makes the
workqueue fallback layer outperform TBB's work-stealing best: 409.9
GFLOP/s at n=4M (93% of the 439 P+E compute sum, project record) and
255.7 at a 0.13 ms region, resolving the sub-ms regime; honest scope:
loses bandwidth-bound at 64M (331 vs 357) — weighted static is a
compute-regime tool (exp009), (b) counter-grounded characterization
across three regimes, (c) falsification of three folk explanations, (d)
a methodology for trustworthy in-process per-PMU measurement of JIT
code, (e) the one-line fix generalizes: chunking beats static in 60/60
kernel/size/thread cells, up to 2.5x, across streaming, fma-chain,
stencil, reduction, and libm kernels (exp007), (f) the fix is
layer-dependent — +44% under TBB vs flat-to-negative under the omp
fallback layer and at most +13% under workqueue, all three behaviors
predicted from dispatch source before measurement (exp008), (g) a novel negative result: guided
scheduling is anti-optimal on hybrid cores — geometric head chunks are
E-core traps, up to 2.8x worse than uniform with high variance (exp006)
— confirmed cross-runtime on pure C + libgomp, where the onset tracks
absolute head-chunk time (exp010).

- **Table 1** (headline): unpinned 28t static 198 GFLOP/s vs P+HT 16t
  pinned 363.9 vs 28t chunk-16384 356.9 — from exp003-hybrid-sched/results.md.

### 2. background

#### 2.1 hybrid x86

Raptor Lake i7-14700: 8 P-cores (cpus 0-15 with HT) + 12 E-cores (cpus
16-27). On the same AVX2 FMA kernel, P-cores sustain 0.89-0.95 IPC at
4-12 threads (dropping to 0.69 at 20 and 0.51 at 28) while E-cores are
flat at 0.23-0.24 IPC in every thread configuration — Gracemont
cracks 256b ops and the kernel is latency-chained. The OS scheduler places
unpinned threads effectively at random, making equal-chunk parallel loops a
lottery.

- **Table 2**: per-PMU cycle/instruction/IPC split by thread count (the
  4/8/12/20/28-thread table) — from exp002-perfcnt/results.md.

#### 2.2 numba parfors, chunking, and threading layers

How prange lowers to a threading layer. The layer under study here is TBB
— numba's default when present, selected silently in the order tbb → omp
→ workqueue by availability. Equal static chunks by default;
`set_parallel_chunksize(n)` splits the iteration space into divisions.
Dispatch semantics over those divisions are layer-specific and determine
whether chunking can help at all: TBB runs tbb::parallel_for over division
indices, so idle workers steal divisions (tbbpool.cpp:163); workqueue
pre-assigns equal groups of divisions per thread (count =
total/num_threads, workqueue.c:410); omp runs a per-division `#pragma omp
for` under its own default (static) schedule (omppool.cpp). Only the first
can rebalance across unequal cores — source-line predictions verified
before measurement in exp008-layers/results.md. All exp003/exp007 numbers
were measured under TBB (verified via threading_layer()). Note also the
observed obstacles to user-level workarounds: prange iteration-to-worker
mapping is not 1:1 and thread-to-CPU placement is random per run, so
weighted partitioning cannot be expressed with prange indices alone — from
exp004-weighted-sched/results.md. This is exactly the obstacle the
section 7 runtime patch removes.

### 3. measurement methodology (contribution)

In-process perf_event_open via ctypes (`perfcnt.PerfGroup`): inherit=1 so
all pool threads are counted, events opened per-PMU (cpu_core / cpu_atom
via extended config encoding), enable/disable brackets exactly the measured
region so JIT compilation is excluded. Ground-truthed against a
known-instruction-count loop: xorshift64, measured 9.3 insn/iter vs 9
expected (within 4%). We present compiler elision as a first-class
methodology trap: two "ground truth" loops were silently destroyed by LLVM
(`s += i` folded to closed form, 0 instructions retired; LCG affine updates
composed under unrolling, ~6x fewer instructions than written) — counters
caught both; wall-clock alone would not have. Also documents the
exec-time counter-attribution failure (20-80% PMU multiplexing coverage
through `uv run` + thread pools) that motivates the in-process design.

Hot-swapping a patched extension into a live venv has its own traps
(exp009's three methodology scars, each of which cost real debugging
time): (1) uv hardlinks venv files to its cache, so `cp` over a .so
writes through the shared inode and corrupts the cache copy, and `uv
run` may re-sync mid-experiment — rm-then-cp, and invoke .venv/bin/python
directly; (2) a relative path in a bash EXIT trap resolved after a `cd`
and silently "restored" a different venv's workqueue.so — absolute paths
in traps, always; (3) the workqueue pool spawns at parfor compile time
(lowering registers threading symbols) and OpenBLAS adds ~27 threads of
its own, so /proc/self/task snapshot diffs cannot identify workers —
measure the division->TID mapping in-kernel (gettid per division)
instead. Reusable warnings for anyone hot-swapping patched extensions —
from exp009-weighted-runtime/results.md.

- **Table 3**: validation — expected vs measured insn/iter, plus the two
  elision traps — from exp002-perfcnt/results.md.
- Attribution caveat — from exp001-roofline/results.md (methodology
  caveats section).

### 4. characterization: three regimes

#### 4.1 bandwidth-bound

Triad saturates at 4 threads; more threads slightly hurt. With
write-allocate (RFO) accounted, physical traffic is 32 B/element and the
measured wall is ~81 GB/s physical = 90% of dual-channel DDR5-5600 peak —
numba's codegen is near-optimal here and no schedule can help. This regime
also explains why DRAM-resident poly caps at P-only throughput: the P+E
sum measured DRAM-resident (P+HT 363.9 + E-only 90.1 = 454 GFLOP/s,
Table 6) would demand ~85 GB/s at poly's ~5.3 flops/byte — above the
wall. (This DRAM-co-limited 454 is distinct from the 439 compute-regime
sum used in sections 6-7; exp003's prose rounds it to "~430 demands
~81".)

- **Table 4**: triad threads-vs-GB/s (1t 31.1 → 4t 60.6, flat after) —
  from exp001-roofline/results.md, including the RFO correction.

#### 4.2 compute-bound

Poly with chain=128 (a genuinely latency-bound scalar chain, see 4.4):
P+HT 16t = 68.2 GFLOP/s, E-only 12t = 23.0, all 28t with chunk 16384 =
89.6 = 98% of the 91.2 P+E sum. Chunked scheduling is near-optimal on
hybrid cores when the region is long enough for coarse chunks; E-cores
contribute their full (small) share.

- **Table 5**: compute-bound control table — from
  exp003-hybrid-sched/results.md.
- Supporting: at 28 threads E-cores burn 8.7 Gcycles to retire 2.0 Ginsn
  (~35% of the work: 2.03 of 5.83 Ginsn retired) — from
  exp002-perfcnt/results.md.

#### 4.3 the placement lottery and three falsified hypotheses

The full placement-by-pinning matrix (unpinned 4t 138.5 → Pphys 8t 288.2 →
P+HT 16t 363.9; unpinned 8t std 8.3 ms). exp002's "8 threads no faster
than 4" anomaly resolves as placement (HT siblings), not hardware. Then the
falsifications, each with its measurement: (1) not memory bandwidth —
cache-resident N=1M shows the same cap; (2) not fork/join — measured
4.5 us (16t) vs 7.0 us (28t), 0.6% of region; (3) not power/frequency —
P-cores hold 5300 MHz with E-cores loaded.

- **Table 6**: placement matrix — from exp003-hybrid-sched/results.md.
- **Table 7**: hypothesis / test / verdict (3 rows) — from
  exp003-hybrid-sched/results.md.

#### 4.4 aside: know your kernel — the 4.1x unroll cliff

Choosing the compute-bound control exposed a codegen discontinuity: at
inner trip count <= 96 LLVM fully unrolls and vectorizes the outer loop
4-wide; at >= 100 the unroll threshold trips and throughput drops 31.8 →
7.8 GFLOP/s (chain 96 → 100), a 4.1x cliff (4.5x by chain 112, 31.8 →
7.1), asm-confirmed (packed-fma
count is a perfect regime predictor via inspect_asm). This matters twice:
as a methodology warning (a "compute-bound" kernel can silently be a
different kernel), and as evidence that scheduler/autotuner cost models
must capture discontinuities.

- **Table 8** (or figure): chain vs GFLOP/s vs packed/scalar fma counts —
  from exp005-unroll-cliff/results.md.

### 5. the defaults problem and a one-line fix

numba's default (static chunking, no pinning) yields 198 GFLOP/s at 28
threads; `set_parallel_chunksize(16384)` yields 356.9 — the 1.8x headline.
The sweet spot is broad (4K-64K all >= 347 GFLOP/s; >= 1M degrades back
toward static), so the fix is robust, not a fragile tuning point. Argument:
on hybrid CPUs chunked scheduling should be the default, not opt-in;
placement variance (std up to 25% unpinned) is a reproducibility hazard for
every published numba benchmark.

- **Figure 1**: chunk-size sweep at 28 threads (broad plateau) — from
  exp003-hybrid-sched/results.md.

#### 5.1 the fix generalizes

A 6-kernel x 5-size x 5-chunk x {16, 28}-thread grid (300 configs,
unpinned, TBB): chunking beats static in 60/60 (kernel, n, threads) cells
— up to 2.5x (poly96 n=1M nt=16). The narrowest wins are at nt=28: triad
n=64M (1.02x — the bandwidth wall leaves little for any schedule) and,
among compute kernels, sumred n=1M (1.02x), where reduction-tree sync
limits the gain.
The static default loses on every
kernel class tested: streaming, fma-chain, stencil, reduction, libm.
Recommended single default: chunk=16384 at nt=28 has worst-case regression
24.6% vs the per-config best (poly96 n=1M, which wants 4K), with typical
gain 1.1-2.2x over static; at nt=16 the same default's worst case is 46.9%
(poly96 256K), so a size-scaled default (section 6) is preferable. One
number worth foregrounding: poly32 n=1M nt=28 chunk4K reaches 396.8
GFLOP/s — beating every pinned exp003 config (364 max). Unpinned + chunked
> pinned + static.

- **Table 11**: grid summary (best chunk per cell, gain vs static) — from
  exp007-chunk-grid/results.md (raw: results.csv).

#### 5.2 the fix is layer-dependent

Measured (poly32, nt=28, n=1M, GFLOP/s): tbb 275 static → 396 at chunk 4K
(+44%); omp is flat-to-negative (16K = -18%); workqueue gains at most +13%
(238 → 269). At n=64M
poly32 is bandwidth-capped (~216 GFLOP/s roofline): all layers 166-193 and
chunking moves <=8% — physics, not scheduling. All three layer behaviors
were predicted from dispatch source before running (section 2.2).
Implication: layer selection is silent, so a user without TBB installed
loses most of the chunking fix's benefit (at best +13% under workqueue vs
+44% under TBB) with no warning; any "chunked by
default" recommendation must be paired with layer awareness. Section 7
inverts this ranking: the same workqueue layer, patched with weighted
divisions, beats TBB outright — the +13% cap is a property of stock
equal division groups, not of the layer.

- **Table 12**: layer x chunk matrix — from exp008-layers/results.md.

#### 5.3 guided scheduling is anti-optimal (negative result)

The textbook alternative — guided scheduling, geometric taper, big chunks
first — makes hybrid worse. Implemented with no runtime patch: prange over
K unequal ranges, each range pinned to its own stealable TBB division via
set_parallel_chunksize(1), vectorization parity asm-confirmed (63 packed
fma). Guided loses up to 2.8x vs uniform chunking (4M: 136 GFLOP/s vs 382 for
chunk2K), with huge variance
(64M: 208 GFLOP/s, std 8.1 ms, vs 357 for chunk16K). Mechanism: guided's
head ranges are N/(2*nt) elements; an E-core is exactly as likely to steal
one as a P-core, and that one range then takes ~20 ms at the E-core's ~7
GFLOP/s — comparable to the whole 24 ms region. Guided's taper assumes
homogeneous consumers; on hybrid cores the head chunks are E-core traps.
A secondary trap: with chunk=0
numba re-chunks the K-loop into 28 equal divisions, landing the big head
ranges in one thread's division (guided drops to 55-106 GFLOP/s) — any
user-level unequal decomposition must pin one range per division.

OpenMP schedule(guided) has the same structure, and exp010 confirms it
inherits the pathology on real OpenMP: pure C + libgomp (gcc 13.3, -O3
-march=native -ffast-math -fopenmp), poly chain=64, 28 threads pinned
(OMP_PROC_BIND=spread OMP_PLACES=cores). At 64M guided collapses to
static (82.7 vs 79.7 GFLOP/s) while dynamic,2048 wins 1.5x (123.8). At
256K-1M guided is fine — even best (79.8 at 256K, 81.8 at 1M) — because
the head chunks (~N/nthreads) are absolutely small: an E-core finishes
one in well under the region time. The onset tracks absolute head-chunk
time exactly as the exp006 mechanism predicts. Cross-runtime
confirmation: the E-core trap is a property of the guided algorithm on
hybrid cores, not a numba artifact — and it is invisible in
small-problem benchmarks. Caveat: GCC's codegen is ~3x below numba's on
this kernel (no multi-accumulator interleave), so schedules are compared
within-runtime only.

- **Table 13**: static / chunk16K / chunk2K / equalK / guided across sizes
  — from exp006-guided/results.md.
- **Table 14**: libgomp static / dynamic,2048 / dynamic,16384 / guided /
  guided,2048 across sizes — from exp010-omp-guided/results.md.

### 6. the sub-ms regime, revisited — and resolved

exp003 framed sub-ms as a dilemma with no answer. exp006 revises that:
TBB + fine uniform chunks work down to ~0.15 ms regions — chunk2K at
n=256K (a 0.14 ms region) gives 245 GFLOP/s = 1.5x static. Below that,
per-division dispatch (~microseconds x hundreds of divisions) dominates
and no user-level mechanism helps — the opening the exp009 runtime patch
walks through with 28 weighted divisions (section 7).

The winning policy compresses into a hybrid-safe chunk rule: uniform
chunks small enough that the slowest core finishes any one chunk in a
small fraction of the region, c* ~ eps * N * (r_slowcore / r_total), with
eps ~ 0.1-0.2 (r_E/r_total ~ 1/60 here). Validation status: the rule
predicts exp007's measured mid-size optima (1M → ~4K, 4M → ~16K) and the
broad 4K-64K plateau; caveat at 64M, where the plateau is wide enough that
anything in 16K-256K is within ~10%, so the rule is not discriminating
there.

The user-level escape hatch still fails below the TBB floor — the exp004
negative result stands: persistent pinned Python threads with calibrated
weighted partitioning (P:E weight, measured E/P = 0.34) recover exactly
P-only throughput DRAM-resident (299.8 vs 298.5 GFLOP/s — confirming the
policy is sound and the bandwidth co-limit is real), but are unusable
cache-resident: 204 us dispatch on a 370 us region plus ~50 us/thread
GIL-staggered wakeup inflate the region 4-6x. Conclusion: anything finer
than ~0.15 ms must live inside the GIL-free runtime — no longer a
conjecture. Section 7's exp009 patch does exactly that and wins the
regime: 255.7 GFLOP/s at a 0.13 ms region, vs 245 for TBB's best fine
chunking and 107.6 for stock workqueue static. The residual floor is
cond-var wakeup cost — the achieved 255.7 is ~58% of the 439 P+E compute
sum at 0.13 ms, and no amount of weighting recovers the wakeup latency.

- **Table 9**: equal vs calibrated weighted partitioning (166.9 → 299.8
  GFLOP/s, DRAM) — from exp004-weighted-sched/results.md.
- **Table 10**: sub-ms boundary — chunk2K at 256K (245 GFLOP/s, 0.14 ms)
  vs dispatch-dominated below — from exp006-guided/results.md; dispatch/
  GIL overheads from exp004-weighted-sched/results.md.

### 7. thirty lines in the runtime: weighted static beats work stealing

The headline result (exp009). A ~30-line patch to numba's
gufunc_scheduler.cpp (compiled into workqueue.so, ABI preserved,
sha-verified drop-in/restore): a new `set_thread_weights(double*, int)`
export plus a weighted split in create_schedule's 1D path, active only
when weight count == division count. Division i is pre-assigned to
worker i — a verified property of the workqueue layer (section 2.2) — so
workers are pinned 1:1 to CPUs via a measured division->TID mapping
(in-kernel gettid through ll.add_symbol/ExternalFunction), with weights
[1.0]x16 P + [0.34]x12 E from the exp004 calibration. This turns the
layer that exp008 showed gains at most +13% from chunking into the
fastest configuration in the project:

- 409.9 GFLOP/s at n=4M — the highest throughput measured in this
  project (previous best 396.8, TBB chunk4K at 1M) — 93% of the 439 P+E
  compute sum, from 28 divisions, no stealing. (439 = 350.8 P+HT-16 +
  87.7 E-only-12 GFLOP/s measured cache-resident, now tabulated in
  exp003-hybrid-sched/results.md. The DRAM-resident sum 363.9 + 90.1 =
  454 is the bandwidth-co-limited variant; under it this figure is 90%
  and section 6's 58% becomes 56%.)
- Sub-ms regime win: 255.7 at a 0.13 ms region, vs 245 for TBB's best
  fine chunking and 107.6 for stock workqueue static (section 6).
- Decomposition: pinning alone (equal weights) is worth +12-37% at
  n<=1M (~0% at n>=4M); the weights add +74-109% over pinned-equal in
  the compute regime (256K-4M), and +66% at bandwidth-bound 64M.
- Honest loss at n=64M: 331.2 vs TBB's 357 — bandwidth-bound, TBB's
  fine-grained stealing adapts to DRAM-contention jitter and no static
  split (equal or compute-weighted) can. Weighted static is a
  compute-regime tool.

The result inverts the exp008 layer ranking: once the regime is
compute-bound and the split matches the silicon, the mechanism (weighted
sizing + placement) matters more than the dispatch machinery (stealing).

- **Table 15**: wq-static / wq-pinned-equal / wq-weighted / TBB best
  across sizes — from exp009-weighted-runtime/results.md.

### 8. related work

Anchors from research/scout-compilers.md:

- **Counter-driven autotuning**: the counters-to-autotuning convergence
  line (arXiv:2102.05297, JPDC 2022) showed counter models cut empirical
  search dramatically; there is very little CPU follow-up since — most
  autotuners remain wall-clock-only. We are a direct successor with a
  hybrid-topology twist.
- **Hybrid P/E scheduling gap**: no autotuning literature covers P/E-core
  scheduling for JIT-compiled data-parallel loops (scout survey,
  2026-07-17). OS-level hybrid scheduling (Intel Thread Director) operates
  below the chunking layer and cannot fix equal static chunks.
- **Cost-model gap in Numba v2/SealIR**: equality saturation reframes
  optimization as cost modeling + extraction (SciPy 2025), and no CPU cost
  models are validated against real hardware; our unroll-cliff and IPC
  measurements are exactly the missing evidence class.
- **PMU methodology**: BOLT (perf-sample post-link layout) and
  roofline/PMU lines continue; our in-process per-PMU bracketing for JIT
  code is a small methodological addition there.

### 9. future work

- **auto-calibration of weights**: equal-split probe -> per-worker rates
  -> weights, closing the exp004 calibration loop inside the runtime
  instead of the hand-set 0.34; weight-sensitivity sweep.
- **upstream API shape**: a `set_thread_weights` beside
  set_parallel_chunksize, or scheduler-internal calibration.
- **bandwidth-regime adaptive hybrid**: stealing + weights — the 64M
  loss (331 vs TBB's 357) shows no static split absorbs DRAM-contention
  jitter; a weighted-stealing hybrid could cover both regimes.
- **second hybrid SKU**: different P:E ratios (Meteor/Arrow Lake) to test
  whether the 1.8x figure, the chunk rule, and the 0.34 weight transfer.
- **energy measurements**: joules/task for E-core participation; power was
  measured only as a frequency non-throttling check.

## claims we can defend (measured, rerunnable)

- [x] numba defaults lose 1.8x vs a one-line fix on this machine
      (198 vs 356.9/363.9 GFLOP/s) — exp003, `run.sh`.
- [x] chunked scheduling reaches 98% of the P+E sum when compute-bound
      (89.6 of 91.2 GFLOP/s) — exp003.
- [x] bandwidth wall is 81 GB/s physical = 90% of DDR5-5600 peak once RFO
      is accounted; no schedule helps there — exp001 (+ correction).
- [x] E-core IPC is flat 0.23-0.24 on this AVX2 FMA kernel in every
      config; P-cores 0.89-0.95 at 4-12 threads (0.69 at 20, 0.51 at 28)
      — exp002 (per-PMU counters).
- [x] three explanations falsified with direct measurements (bandwidth,
      fork/join 4.5-7.0 us = 0.6% of region, frequency 5300 MHz held) —
      exp003.
- [x] Python-thread weighted dispatch cannot drive sub-ms regions
      (204 us dispatch on 370 us region; ~50 us/thread GIL wakeup);
      calibrated weights are physically meaningful (E/P = 0.34) — exp004.
- [x] LLVM full-unroll cliff at trip 96→100 is 4.1x (31.8 → 7.8 GFLOP/s;
      4.5x by trip 112), asm-confirmed; packed-fma count predicts the
      regime — exp005.
- [x] counter harness is ground-truthed within 4% and catches compiler
      elision that wall-clock misses — exp002.
- [x] the one-line fix generalizes: chunking beats static in 60/60
      (kernel, n, threads) cells, up to 2.5x (poly96 n=1M nt=16), across
      streaming/fma/stencil/reduction/libm; the narrowest wins are triad
      n=64M nt=28 (1.02x, bandwidth-bound) and sumred n=1M nt=28 (1.02x)
      — exp007, results.csv.
- [x] chunk=16384 at nt=28 is a sound single default: worst-case
      regression 24.6% vs per-config best, typical gain 1.1-2.2x over
      static; at nt=16 worst case is 46.9%, favoring a size-scaled
      default — exp007.
- [x] unpinned + chunked beats pinned + static: poly32 n=1M nt=28 chunk4K
      = 396.8 GFLOP/s vs 364 pinned max — exp007 (vs exp003).
- [x] the fix is layer-dependent: +44% under TBB at n=1M,
      flat-to-negative under omp (16K = -18%), at most +13% under
      workqueue; all three behaviors predicted from dispatch source
      before measurement — exp008, `run.sh`.
- [x] guided scheduling is anti-optimal on hybrid cores: up to 2.8x worse
      than uniform chunking (4M: 136 vs 382 GFLOP/s), with high variance
      (64M std 8.1 ms); head chunks are E-core traps — exp006, `bench.py`.
- [x] fine uniform chunks work down to ~0.15 ms regions: chunk2K at
      n=256K (0.14 ms region) = 245 GFLOP/s = 1.5x static — exp006.
- [x] the hybrid-safe chunk rule c* ~ eps * N * (r_slowcore / r_total)
      predicts the measured mid-size optima (1M → ~4K, 4M → ~16K) —
      exp006 + exp007; at 64M the 16K-256K plateau is within ~10%, so
      the rule is not discriminating there.
- [x] a ~30-line gufunc_scheduler patch (weighted static division sizing
      + 1:1 pinning via measured division->TID mapping, weights
      P=1.0/E=0.34) makes workqueue beat TBB's work-stealing best:
      409.9 GFLOP/s at 4M (93% of the 439 P+E sum; project record,
      prior best 396.8) and 255.7 at a 0.13 ms region (vs 245 for TBB's
      best fine chunking, 107.6 for stock static) — exp009, `run.sh`.
- [x] the exp009 gain decomposes: pinning alone (equal weights) is worth
      +12-37% at n<=1M (~0% at n>=4M); the weights add +74-109% over
      pinned-equal at 256K-4M, +66% at bandwidth-bound 64M — exp009.
- [x] weighted static loses bandwidth-bound: 331.2 vs TBB's 357 at 64M —
      stealing adapts to DRAM-contention jitter, no static split can;
      compute-regime tool — exp009.
- [x] the sub-ms residual floor is cond-var wakeup cost: 255.7 is ~58%
      of the 439 compute sum at 0.13 ms — exp009.
- [x] OpenMP schedule(guided) exhibits the E-core trap on real libgomp:
      at 64M pinned, guided 82.7 ~ static 79.7 while dynamic,2048 gets
      123.8 (1.5x); at 256K-1M guided is fine (even best: 79.8 at 256K,
      81.8 at 1M); onset tracks absolute head-chunk time as the exp006
      mechanism predicts; within-runtime comparison only (GCC codegen
      ~3x below numba's here) — exp010, `run.sh`.

## claims needing more data

- [ ] Auto-calibrated weights (equal-split probe -> rates -> weights)
      match or beat the hand-set 0.34 — the calibration loop exists
      (exp004) but is not yet wired into the runtime; needs a
      weight-sensitivity sweep.
- [ ] A stealing + weights hybrid recovers the bandwidth-regime loss
      (331.2 vs 357 at 64M) — proposed, unbuilt.
- [ ] The 1.8x figure and the 0.34 weight generalize to other hybrid
      SKUs (different P:E ratios, Meteor/Arrow Lake) — single-machine
      study; state as a limitation, or borrow a second box.
- [ ] "Should be the numba default" — exp007 covers kernel/size/thread
      generality on this machine, but a PR-strength claim still needs
      no-regression evidence on non-hybrid CPUs plus layer-aware
      handling of the exp008 finding; same bar applies to a
      `set_thread_weights` upstream API.
- [ ] Any energy/efficiency claim about E-cores — power was measured only
      as a frequency non-throttling check, not joules/task.

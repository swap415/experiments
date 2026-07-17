# workshop paper skeleton — thread 1 (hybrid-aware scheduling)

Target: LCTES/CGO-workshop length (~6 pages). Evidence sources: exp001-008
results.md; literature anchors: research/scout-compilers.md. Every number
below is copied from a results.md; nothing is invented.

## candidate titles

1. **Static Chunking Considered Harmful on Hybrid CPUs** (working title)
2. One Line, 1.8x: Measuring and Fixing JIT Parallel-Loop Defaults on
   Hybrid x86
3. Equal Chunks, Unequal Cores: A Counter-Grounded Characterization of
   numba Parallel Loops on P/E-Core CPUs
4. **Guided Scheduling Considered Harmful on Hybrid CPUs** (alternative —
   foregrounds the exp006 negative result)

## abstract (~200 words)

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
kernel/size/thread cells, up to 2.5x, across streaming, fma-chain,
stencil, reduction, and libm kernels. The full fix is TBB-only —
set_parallel_chunksize is flat-to-negative under numba's omp fallback
layer and gains at most +13% (vs TBB's +44%) under workqueue, all three
behaviors predicted from dispatch source before measurement. The textbook alternative fails in the opposite
direction: guided scheduling is anti-optimal on hybrid cores — its
geometric head chunks are E-core traps, up to 2.8x worse than uniform
chunking with high variance, a structure OpenMP schedule(guided) shares.
When bandwidth-bound, an 81 GB/s physical wall (90% of DDR5 peak) caps
every schedule; fine uniform chunks extend the fix down to ~0.15 ms
regions, below which per-division dispatch dominates.

## outline

### 1. introduction

The pitch: hybrid P/E cores are now the default desktop x86 topology, but
the parallel-runtime layer of Python's dominant JIT (numba parfors) still
assumes homogeneous cores. We show the defaults cost 1.8x, a one-line
setting recovers it — but only under one of numba's three threading
layers — and the textbook alternative (guided) makes hybrid worse.
Contributions list: (a) counter-grounded characterization across three
regimes, (b) falsification of three folk explanations, (c) a methodology
for trustworthy in-process per-PMU measurement of JIT code, (d) the
one-line fix generalizes: chunking beats static in 60/60
kernel/size/thread cells, up to 2.5x, across streaming, fma-chain,
stencil, reduction, and libm kernels (exp007), (e) the fix is
layer-dependent — +44% under TBB vs flat-to-negative under the omp
fallback layer and at most +13% under workqueue, all three behaviors
predicted from dispatch source before measurement (exp008), (f) a novel negative result: guided
scheduling is anti-optimal on hybrid cores — geometric head chunks are
E-core traps, up to 2.8x worse than uniform with high variance, and
OpenMP schedule(guided) shares the structure (exp006).

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
exp004-weighted-sched/results.md.

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
also explains why DRAM-resident poly caps at P-only throughput: P+E's
combined ~430 GFLOP/s would demand ~81 GB/s, the wall.

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
  (17% of the work) — from exp002-perfcnt/results.md.

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
— up to 2.5x (poly96 n=1M nt=16). The narrowest wins are sumred at 256K
(1.05x at both thread counts), where reduction-tree sync limits the gain.
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
poly32 is bandwidth-capped (~216 GFLOP/s roofline): all layers 167-193 and
chunking moves <=8% — physics, not scheduling. All three layer behaviors
were predicted from dispatch source before running (section 2.2).
Implication: layer selection is silent, so a user without TBB installed
loses most of the chunking fix's benefit (at best +13% under workqueue vs
+44% under TBB) with no warning; any "chunked by
default" recommendation must be paired with layer awareness.

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
OpenMP schedule(guided) has the same structure and should inherit the same
pathology (untested here — future work). A secondary trap: with chunk=0
numba re-chunks the K-loop into 28 equal divisions, landing the big head
ranges in one thread's division (guided drops to 55-106 GFLOP/s) — any
user-level unequal decomposition must pin one range per division.

- **Table 13**: static / chunk16K / chunk2K / equalK / guided across sizes
  — from exp006-guided/results.md.

### 6. the sub-ms regime, revisited

exp003 framed sub-ms as a dilemma with no answer. exp006 revises that:
TBB + fine uniform chunks work down to ~0.15 ms regions — chunk2K at
n=256K (a 0.14 ms region) gives 245 GFLOP/s = 1.5x static. Below that,
per-division dispatch (~microseconds x hundreds of divisions) dominates
and no current mechanism helps.

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
than ~0.15 ms must live inside the GIL-free runtime.

- **Table 9**: equal vs calibrated weighted partitioning (166.9 → 299.8
  GFLOP/s, DRAM) — from exp004-weighted-sched/results.md.
- **Table 10**: sub-ms boundary — chunk2K at 256K (245 GFLOP/s, 0.14 ms)
  vs dispatch-dominated below — from exp006-guided/results.md; dispatch/
  GIL overheads from exp004-weighted-sched/results.md.

### 7. related work

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

### 8. future work

- **in-runtime weighted scheduling**: per-worker chunk-size scaling by a
  calibration vector (P:E ~ 3:1) as a C++ gufunc_scheduler patch,
  targeting the <0.15 ms regime where no current mechanism works.
  Requires per-thread CPU identity in the runtime (exp004 finding).
- **OpenMP schedule(guided) validation on hybrid**: exp006 predicts the
  same E-core-trap pathology from shared structure; untested.
- **second hybrid SKU**: different P:E ratios (Meteor/Arrow Lake) to test
  whether the 1.8x figure and the chunk rule transfer.
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
      streaming/fma/stencil/reduction/libm; the narrowest wins are sumred
      at 256K (1.05x at both thread counts) — exp007, results.csv.
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

## claims needing more data

- [ ] Weighted per-worker chunking beats uniform chunking below ~0.15 ms
      — the in-runtime gufunc_scheduler patch has not been run; currently
      only the exp004 negative result and a policy argument.
- [ ] OpenMP schedule(guided) exhibits the same E-core-trap pathology —
      predicted from shared structure (exp006), untested.
- [ ] The 1.8x figure generalizes to other hybrid SKUs (different P:E
      ratios, Meteor/Arrow Lake) — single-machine study; state as a
      limitation, or borrow a second box.
- [ ] "Should be the numba default" — exp007 covers kernel/size/thread
      generality on this machine, but a PR-strength claim still needs
      no-regression evidence on non-hybrid CPUs plus layer-aware
      handling of the exp008 finding.
- [ ] Any energy/efficiency claim about E-cores — power was measured only
      as a frequency non-throttling check, not joules/task.

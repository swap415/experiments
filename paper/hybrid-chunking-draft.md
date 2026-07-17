# workshop paper skeleton — thread 1 (hybrid-aware scheduling)

Target: LCTES/CGO-workshop length (~6 pages). Evidence sources: exp001-005
results.md; literature anchors: research/scout-compilers.md. Every number
below is copied from a results.md; nothing is invented. Sections marked
[PENDING DATA] await exp006/exp007.

## candidate titles

1. **Static Chunking Considered Harmful on Hybrid CPUs** (working title)
2. One Line, 1.8x: Measuring and Fixing JIT Parallel-Loop Defaults on
   Hybrid x86
3. Equal Chunks, Unequal Cores: A Counter-Grounded Characterization of
   numba Parallel Loops on P/E-Core CPUs

## abstract (~150 words)

Intel's hybrid CPUs pair performance and efficiency cores with a measured
3-4x per-cycle throughput gap, yet JIT compilers still split parallel loops
into equal static chunks. On an i7-14700, numba's defaults deliver 198
GFLOP/s on a compute-heavy kernel where pinned P-cores alone reach 364 — a
1.8x loss from defaults, before any code change. Using an in-process
perf_event_open harness with per-PMU (cpu_core/cpu_atom) counters that
bracket only the measured region, we test and falsify three plausible
explanations — memory bandwidth, fork/join overhead, and frequency
throttling — isolating static chunking plus placement as the cause. A
one-line fix, `set_parallel_chunksize(16384)`, recovers the loss and
reaches 98% of the summed P+E throughput when compute-bound; when
bandwidth-bound, an 81 GB/s physical wall (90% of DDR5 peak) caps every
schedule. Sub-millisecond regions remain open — no existing mechanism
escapes the chunk-tail versus dispatch-overhead dilemma — and a 4.5x LLVM
unroll cliff shows why cost models must be measured, not assumed.

## outline

### 1. introduction

The pitch: hybrid P/E cores are now the default desktop x86 topology, but
the parallel-runtime layer of Python's dominant JIT (numba parfors) still
assumes homogeneous cores. We show the defaults cost 1.8x, a one-line
setting recovers it, and one regime (sub-ms regions) has no working
mechanism at all. Contributions list: (a) counter-grounded characterization
across three regimes, (b) falsification of three folk explanations, (c) a
methodology for trustworthy in-process per-PMU measurement of JIT code,
(d) identification of the open sub-ms scheduling problem.

- **Table 1** (headline): unpinned 28t static 198 GFLOP/s vs P+HT 16t
  pinned 363.9 vs 28t chunk-16384 356.9 — from exp003-hybrid-sched/results.md.

### 2. background

#### 2.1 hybrid x86

Raptor Lake i7-14700: 8 P-cores (cpus 0-15 with HT) + 12 E-cores (cpus
16-27). On the same AVX2 FMA kernel, P-cores sustain 0.89-0.95 IPC while
E-cores are flat at 0.23-0.24 IPC in every thread configuration — Gracemont
cracks 256b ops and the kernel is latency-chained. The OS scheduler places
unpinned threads effectively at random, making equal-chunk parallel loops a
lottery.

- **Table 2**: per-PMU cycle/instruction/IPC split by thread count (the
  4/8/12/20/28-thread table) — from exp002-perfcnt/results.md.

#### 2.2 numba parfors and chunking

How prange lowers to the workqueue backend: equal static chunks by default;
`set_parallel_chunksize(n)` opts into dynamic chunked scheduling. Note the
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

#### 4.4 aside: know your kernel — the 4.5x unroll cliff

Choosing the compute-bound control exposed a codegen discontinuity: at
inner trip count <= 96 LLVM fully unrolls and vectorizes the outer loop
4-wide; at >= 100 the unroll threshold trips and throughput drops 31.8 →
7.8 GFLOP/s (chain 96 → 100), a 4.5x cliff, asm-confirmed (packed-fma
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

### 6. the open sub-ms regime

Cache-resident N=1M: coarse chunks (16384) make one E-core chunk 0.29 ms —
comparable to the whole region — which gates the barrier; chunks fine
enough to fix the tail (2048-8192) cost more in dispatch than they save
(330 GFLOP/s, below the coarse setting). Granularity has no good answer at
sub-ms scale. The user-level escape hatch also fails: persistent pinned
Python threads with calibrated weighted partitioning (P:E weight, measured
E/P = 0.34) recover exactly P-only throughput DRAM-resident (299.8 vs
298.5 GFLOP/s — confirming the policy is sound and the bandwidth co-limit
is real), but are unusable cache-resident: 204 us dispatch on a 370 us
region plus ~50 us/thread GIL-staggered wakeup inflate the region 4-6x.
Conclusion: the mechanism must live inside the GIL-free runtime.

- **Table 9**: equal vs calibrated weighted partitioning (166.9 → 299.8
  GFLOP/s, DRAM) — from exp004-weighted-sched/results.md.
- **Table 10**: cache-resident chunk-size dilemma — from
  exp003-hybrid-sched/results.md (cache-resident bullet) and
  exp004-weighted-sched/results.md (dispatch/GIL overheads).

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

### 8. future work [PENDING DATA]

- **exp006 — weighted chunk scheduling in the numba runtime**: per-worker
  chunk-size scaling by a calibration vector (P:E ~ 3:1) inside the
  workqueue/parfor scheduler (local checkout, upstream_main), targeting
  the sub-ms regime where no current mechanism works. Requires per-thread
  CPU identity in the runtime (exp004 finding). [PENDING DATA — no numbers
  yet; do not promise speedups.]
- **exp007 — generalization grid**: does the 16K sweet spot hold across
  kernel x size x arithmetic-intensity? Counter-verified grid producing the
  "recommended defaults" table a numba PR would need. [PENDING DATA]

## claims we can defend (measured, rerunnable)

- [x] numba defaults lose 1.8x vs a one-line fix on this machine
      (198 vs 356.9/363.9 GFLOP/s) — exp003, `run.sh`.
- [x] chunked scheduling reaches 98% of the P+E sum when compute-bound
      (89.6 of 91.2 GFLOP/s) — exp003.
- [x] bandwidth wall is 81 GB/s physical = 90% of DDR5-5600 peak once RFO
      is accounted; no schedule helps there — exp001 (+ correction).
- [x] E-core IPC is flat 0.23-0.24 on this AVX2 FMA kernel in every
      config; P-cores 0.89-0.95 — exp002 (per-PMU counters).
- [x] three explanations falsified with direct measurements (bandwidth,
      fork/join 4.5-7.0 us = 0.6% of region, frequency 5300 MHz held) —
      exp003.
- [x] Python-thread weighted dispatch cannot drive sub-ms regions
      (204 us dispatch on 370 us region; ~50 us/thread GIL wakeup);
      calibrated weights are physically meaningful (E/P = 0.34) — exp004.
- [x] LLVM full-unroll cliff at trip 96→100 is 4.5x, asm-confirmed;
      packed-fma count predicts the regime — exp005.
- [x] counter harness is ground-truthed within 4% and catches compiler
      elision that wall-clock misses — exp002.

## claims needing more data

- [ ] Weighted per-worker chunking beats uniform chunking in the sub-ms
      regime — exp006 not run; currently only a negative result (exp004)
      and a policy argument.
- [ ] chunk ~16K is the right default *in general* (beyond poly at these
      sizes) — needs the exp007 kernel x size x intensity grid.
- [ ] The 1.8x figure generalizes to other hybrid SKUs (different P:E
      ratios, Meteor/Arrow Lake) — single-machine study; state as a
      limitation, or borrow a second box.
- [ ] "Should be the numba default" — needs exp007's no-regression
      evidence on non-hybrid CPUs and small-N cases before a PR-strength
      claim.
- [ ] Any energy/efficiency claim about E-cores — power was measured only
      as a frequency non-throttling check, not joules/task.

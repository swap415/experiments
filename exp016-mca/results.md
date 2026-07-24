# exp016: llvm-mca vs measured on numba-emitted shapes (2026-07-24)

Hot loop block of each exp013 v2 variant (66) fed to llvm-mca 18.1.3
-mcpu=raptorlake, two modes: timeline with dependency simulation
("dep", Total Cycles/iterations) and Block RThroughput ("rt", pure port
pressure). Predictions and ground truth are both flops/cycle (probe-
measured), so absolute error needs no scale fit. Raw: mca.csv.

## scores (same rubric as exp013/exp015)

| predictor | abs-geo | abs-max | rho | grp-rho | top1 | geo-regret | max-reg | cliff |
|---|---:|---:|---:|---:|---:|---:|---:|---|
| mca dep | 1.68x | 3.38x | 0.953 | 0.824 | 86% | 1.001x | 1.014x | PASS |
| mca rt  | 2.01x | 3.77x | 0.916 | 0.236 | 14% | 1.482x | 2.753x | PASS |

Context (exp013/exp015 on same corpus): hand asm-heuristic grp 0.760 /
top1 23% / regret 1.217x; learned params+asm 0.795 / 82% / 1.011x;
one-probe 0.977 / 95% / 1.000x.

## claims (recomputed from mca.csv)

1. As a RANKER, llvm-mca with dependency simulation is the best static
   model we have measured: regret 1.001x geo / 1.014x max — beats the
   learned model (1.011x) and crushes the hand asm heuristic (1.217x).
   Still below the probe (0.977 grp-rho vs 0.824). Selection quality
   comes almost free with mca — but only in dep mode.
2. Dependency-blind throughput (rt mode — the assumption TTI-style
   per-op cost models make) is WORTHLESS for selection: grp-rho 0.236,
   top1 14%, regret 1.482x geo / 2.75x max. The entire selection signal
   lives in the latency/dependency modeling, none in port counts.
3. As an ABSOLUTE predictor, mca is off 1.68x geo / 3.38x max on real
   JIT-emitted loops — far from the ~10-25% basic-block errors reported
   in the uiCA literature. Three regimes (dep mode):
   - vectorized, chain>=16 (46 rows): geo 1.42x, overpredicts on ALL 46
     (mean 1.43x) — systematic optimism about sustained FMA throughput.
   - vectorized, chain=8 (6 rows): geo 3.13x over — short bodies where
     per-element load/store/branch overhead dominates; mca's steady-state
     loop assumption is maximally wrong.
   - scalar collapsed (14 rows): geo 2.25x, direction FLIPS (12/14
     underpredict, worst 0.37x) — mca sees the inner chain loop's
     loop-carried dependency and predicts serial latency (0.50 f/cyc);
     real hardware overlaps chains from ADJACENT outer-loop elements
     through the OOO window (measured 1.34). Block-level simulation
     structurally cannot see nested-loop ILP.
4. Methodology: block extraction matters — picking the block with most
   fma INSTRUCTIONS selects scalar epilogues over vector bodies (a
   16-scalar-fma epilogue outcounts an 8-packed-fma body); rank by
   packed count first. Wrong blocks shifted rho 0.940->0.953 and
   relabeled the chain=8 miss from artifact to real.

## implications

- S2 gate opens: numba variant selection could use mca-dep-style ranking
  (or the exp015 hybrid) — but any TTI/throughput-based static cost is
  disqualified by claim 2.
- Paper 2 exhibit: "LLVM's own model ranks well but only with deps on;
  its absolute numbers are 1.4-3x off on JIT loop shapes, with a sign
  flip between vectorized (over) and scalar-nested (under) regimes."

Repro: `taskset -c 2 .venv/bin/python exp016-mca/mca.py` then
`.venv/bin/python exp016-mca/score.py` (needs llvm-mca-18, exp013 CSV).

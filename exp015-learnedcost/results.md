# exp015: learned cost models on cheap features (S4a scoping, 2026-07-23)

S4a scoped by experiment, not by document. Decision to learn: variant
selection within one computation (the e-graph-extraction / autotune pick).
Training/eval loop: implemented (learn.py) — ridge on standardized
features -> log(gflops), leave-one-(chain,dtype)-group-out over exp013's
clean 66-variant corpus, so every ranking is out-of-sample. Data: exp013
v2 results.csv. n=66, 22 folds.

## measured results

Out-of-sample ranking (baselines: exp013 hand-built models):

| model | global-rho | grp-rho | top1 | geo-regret | max-regret |
|---|---:|---:|---:|---:|---:|
| hand static-op (a)       | 0.517 | 0.000 |  5% | 2.725x | 16.56x |
| hand latency-analytic (b)| 0.631 | 0.795 | 82% | 1.011x | 1.194x |
| hand asm-feature (c)     | 0.938 | 0.760 | 23% | 1.217x | 1.706x |
| one-probe (d)            | 0.988 | 0.977 | 95% | 1.000x | 1.006x |
| learned params           | 0.906 | 0.795 | 82% | | |
| learned asm              | 0.525 | 0.795 | 82% | | |
| learned params+asm       | 0.975 | 0.795 | 82% | 1.011x | 1.194x |

(regret = measured best / measured pick, geometric mean / max over 22
groups; learned rows are LOGO out-of-sample.)

1. Learning helps globally: params-only goes 0.517 (hand) -> 0.906
   (learned); params+asm reaches 0.975 out-of-sample — within 0.013 of
   the probe, from features costing microseconds.
2. Within-group there is a FEATURE INFORMATION CEILING at 0.795/82%:
   pointwise ridge, pairwise rank learning, and every feature set land on
   identical numbers. Diagnostic: the 4 missed groups (chain 8/16) have
   IDENTICAL asm signatures across accs (e.g. packed_fma 8/8/8) with
   2-4% measured spread — no static feature can separate them, only
   measurement can. The cliff groups, by contrast, are ranked correctly
   (packed_fma>0 carries the signal).
3. Learning FIXES the hand asm-heuristic's expensive failure: hand-c
   breaks ties badly in cliff groups (max regret 1.706x); learned
   params+asm has geo-regret 1.011x / max 1.194x. The probe remains the
   only near-zero-regret selector (1.006x worst case).
4. Measured JIT-context costs: ridge inference 2.1us/variant, asm feature
   extraction 5.50ms/variant (inspect_asm + regex), one probe rep
   ~25-100ms/variant (exp013). Cost ladder: 4 orders of magnitude
   between learned-static and probe.

## S4a design verdict (grounded in the numbers above)

Hybrid selector: learned model on params+asm shortlists variants
(microseconds, regret within 1.1% geo), then spend probes ONLY where the
predicted margin is inside the model's error band (~20%); measured
worst-case regret of the pure learned model is 1.194x, of the probe
1.006x. Pure learned-static is information-limited, pure probing is
50-100ms per candidate — the budget goes to disagreement resolution.

## measured vs speculative

Measured: everything in the table; costs; the ceiling diagnostic.
Speculative: generalization beyond this kernel family (one family, one
machine, n=66 — the honest blocker for S4a proper); the ~20% margin
threshold (derived from max-regret, not swept); any RL formulation.
Next gate for S4a: corpus expansion to >=3 kernel families (stencils,
reductions, gathers) with the same counter-verification discipline.

Repro: `taskset -c 2 .venv/bin/python exp015-learnedcost/learn.py`

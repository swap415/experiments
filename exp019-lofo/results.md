# exp019 (S4a): leave-one-family-out — learned models DON'T transfer (2026-07-29)

The honest generalization test the S4a gate demanded. Data: exp018
corpus v3 clean families (map/reduction/stencil), 34 samples (17 kernels
x 2 configs), asm features + measured probe per sample. Ridge trained on
2 families, evaluated on the third. Raw: exp018-corpusv3/results.csv;
script: learn.py.

## measured results

Held-out ranking (Spearman, learned-asm / learned-asm+d):
map 0.982/0.982 - reduction 0.254/0.269 - stencil 0.401/0.426.
Transfer only works map<->reduction (structurally similar chains).

Config-selection regret on held-out families (geo over d-groups):

| selector | map | reduction | stencil | aggregate | worst |
|---|---:|---:|---:|---:|---:|
| learned-asm (LOFO)   | 1.000 | 1.001 | 1.243 | 1.066x | 1.569x |
| learned-asm+d (LOFO) | 1.000 | 1.001 | 1.243 | 1.066x | 1.569x |
| hand rule (exp017)   | 1.000 | 1.001 | 1.000 | 1.000x | 1.004x |
| probe                | 1.000 | 1.001 | 1.000 | 1.000x | 1.005x |

Failure mode (from the data, not speculation): trained on map+reduction
the model learns packed-fma-count as a positive gradient; stencil under
thresh2k has MORE packed fmas (63-103 vs 15-31) and is SLOWER (-19% to
-83%). The learned model prefers exactly the catastrophic variants. The
hand rule survives because it encodes a binary causal invariant
("collapse to scalar = bad") instead of a correlational gradient.

## S4a verdict (evidence-based demotion)

The JIT-deployment premise of S4a — a learned policy meets unseen code —
is exactly the family-transfer axis, and family transfer is where
learning fails on this evidence. The measured hierarchy for unseen
families: causal structural check (free) = probe (25-100ms) >> learned
models. S4a's supported niche shrinks to within-family interpolation
(exp015: matches analytic, beats hand-asm), which is NOT the deployment
story. Recommend score demotion; revisit only if the corpus reaches
family diversity that plausibly covers deployment (orders of magnitude
beyond 4 families — speculative whether that converges at all).

## measured vs speculative

Measured: everything above (n=34, one machine, f64, ridge+LOFO).
Speculative: whether richer models (trees, GNNs over asm) fix transfer —
untested here, but the packed-count inversion is a feature-information
problem, not a model-capacity problem: no function of these features
separates stencil's regime without stencil-like training data.

## evidence versioning (2026-08-02 audit)

The exp018 CSV this experiment ran on was overwritten by the v3.1 rerun
(gather fix). The original is archived as data-2026-07-29.csv and
reproduces the table above exactly:
`learn.py exp019-lofo/data-2026-07-29.csv`. On the CURRENT v3.1 CSV the
conclusion is unchanged and slightly stronger in contrast: learned
1.086x/1.594x vs hand rule 1.017x/1.246x vs probe 1.001x/1.010x. The
hand rule's new 1.246x entry is stencil d=16 — IDENTICAL asm both
configs (15p/15s), 24.6% run-to-run placement/alignment variance: the
statically-indistinguishable case exp015's information ceiling already
covers (only measurement can see it; the probe does, 1.010x).

Repro: `taskset -c 2 .venv/bin/python exp019-lofo/learn.py`

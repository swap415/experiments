# roadmap — seeded directions, scored 2026-07-23

Four seeds evaluated. Verdict: phased single bet, S1 spine. Arc holds:
counters → cost model → justifies passes (S2) + benefit-per-ms compile cuts (S3)
→ corpus becomes training/eval substrate for learned heuristics (S4a).

## scores (re-scored 2026-07-23 evening audit; original in parens)

| seed | score | basis |
|------|-------|-------|
| S1 counter-driven cost models | 8.5 (8.5) | v2 clean corpus confirms thesis: one-probe 0.988/0.977, params 0.52 + cliff FAIL. mca/TTI validation next. |
| S3 compile-time attack | 8.0 (7.5) | exp014: 82% of simple-kernel cold start is fixed import+init overhead — tractable, high-impact target found day 1. BUT the S1-coupled pass-pruning sub-bet is demoted: LLVM is only 25-46% of compile, 18% ceiling for caching simple kernels. |
| S2 ship passes | 8.5 (8.0) | complete arc: policy generalized 4 families (98.6% of oracle), retry_compile() shipped + live-validated (2026-08-02 audit). |
| S4b LLM agents on core | 6.0 (6.0) | unexercised this week. |
| S4a learned JIT heuristics | 4.0 (5.5→demoted 2026-07-29) | exp019 LOFO: learned models FAIL family transfer (regret 1.24x on held-out stencil, prefer the catastrophic variants; hand rule 1.000x). Niche = within-family only. |

Arc status: demonstrated in miniature on day 1 — exp015 (S4a) trained and
evaluated directly on exp013's (S1) corpus. One seeded coupling weakened:
S3's benefit-per-ms pass pruning is capped by measurement (pipeline is a
minority of simple-kernel cold start), so S3's main line is now import/init
reduction, independent of S1.

## phases

1. **S1 corpus v2 — DONE 2026-07-23** (exp013): clean 66-variant corpus, all
   rows counter-verified within 5% executed-vs-nominal; one-probe 0.988/0.977
   grp/95% top1; params 0.52 + cliff-FAIL. Distinct constants were NOT enough
   (shared-base recurrence CSE, exact 0.5 ratio) — distinct multipliers fixed
   it. **mca validation DONE 2026-07-24** (exp016): mca-dep ranks nearly as
   well as the probe (regret 1.001x, top1 86%) but is 1.68x geo off absolute
   (over 1.4x vectorized, UNDER 2.7x scalar-nested — block sim can't see
   outer-loop ILP); dependency-blind rt/TTI-style is worthless for selection
   (top1 14%, regret 1.48x). S1 phase complete.
2. **S3 phase 1 — DONE 2026-07-23** (exp014): cold start = import 94ms +
   one-time init 64ms + pipeline (35ms simple → 130ms arrayexpr/parfors).
   82% of simple-kernel cold start is fixed overhead; typing is 3.6% of
   pipeline (folk theory false); LLVM 25-46%. Caching ceiling for simple
   kernels is 18%. **phase 2 DONE 2026-07-24**: the fixed tax is ~150ms of
   imports+registries (import graph flat across 468 modules AND entangled —
   all spot-stubs break it; init = 58ms of deferred imports inside
   target_context.refresh, collapses to 4.4ms once forced). Floor
   numpy+llvmlite 44.4ms. LLVM lock: full-opt 33-43%, finalize 31-37%;
   prange has 40ms untracked. Fork floor measured 2026-07-28: 0.66ms
   cached / 34.5ms warm-compile vs 193ms cold. **phase 3 CLOSED NEGATIVE
   2026-07-30** (exp020): O3->O2 saves 1.3ms mean but risks 5.6x runtime;
   O0 is 100x slower AND compiles 1.9-17.5x LONGER — the whole optimizer
   axis is bounded by ~1-9ms against the 158ms import tax. Wrinkle: O2
   beats O3 on stencil d=64 (+15%, candidate for retry_compile()).
   **parfors gap CLOSED 2026-07-30** (phase 3b): the untracked half is
   extra-module compilation (gufunc+launcher) outside the pass-timing
   context — parfors premium is module-count (finalize 2.4x, final-opt
   4.0x saxpy), not pass cost; lock is chatty (1502-3388 holds/compile)
   but cheap (~28us). S3 measurement infra complete: every cold-start ms
   has a named owner. **cache=True measured 2026-07-31** (phase 3c):
   ceiling prediction confirmed (saxpy hit saves 18.4%, predicted 18%);
   hit floor uniform at import+init (~161ms, load itself ~2ms); parfors
   caches fully, saves 40.8%; miss overhead 0.5-4ms. Strategy ladder
   complete: cold 197-276 / hit ~161 / warm-fork-compile 34.5 /
   warm-fork-cached 0.66ms. **now**: structural import surgery scoping
   (56ms budget) — dedicated design session.
3. **S2 first result SHIPPED 2026-07-28** (exp017): unroll cliff fixed at
   the llvmlite cl-opt layer (set_option toggles mid-process, verified) —
   3.2-3.9x on all cliff rows at NEGATIVE compile cost (-40-50%);
   corpus-wide geo 1.418x but 12 regressions, fixed by the exp013 asm-rule
   (recompile-on-collapsed): geo 1.427x of 1.452x oracle, zero regressions.
   Layer decision recorded: cl-opt wins; numba-IR pass only if NPM breaks
   cl-opts or sub-function granularity needed. **generalized 2026-07-29**
   (exp018, corpus v3): rule = oracle-0.1% across 4 families (geo 1.775x,
   zero regressions on 21 variants; 87 total with exp017); reduction cliff
   6.8-8.3x fixed; stencil shows raw knob catastrophic (-83%) but rule
   never fires there. **retry_compile() SHIPPED 2026-07-30** (exp021,
   retrycompile.py): live single-process validation — 7 cliff rows fire
   3.85-8.49x, non-cliff 1.00-1.02x, +3-7ms silent overhead, no state
   leak. Found+fixed a restore bug (LLVM O3 effective threshold is 300,
   not the documented base 150) via cross-experiment consistency.
   **gather v3.1 DONE 2026-07-31**: corpus v3 complete, 4 clean families,
   42 rows zero elision. Gather: default vectorizes at d>=64, knob
   full-unrolls to scalar (-35-49%) — third knob-backfire family, rule
   still zero-regression (geo 1.782x, 98.6% of oracle 1.807x).
   **next**: in-repo RFC; optional O2-stencil extension; exp019 LOFO
   rerun with 4th family now possible.
   gate(S1+S3) → benefit-per-ms pass pruning (demoted, see S3 note).
4. **S4a scoping — DONE 2026-07-23** (exp015, gate opened by corpus v2):
   learned ridge on params+asm hits 0.975 global out-of-sample but a feature
   information ceiling within-group (0.795/82% — identical for pointwise,
   pairwise, all feature sets; missed groups have identical asm, 2-4% spread).
   Regret: learned 1.011x geo / 1.194x max; probe 1.000/1.006. Design verdict:
   hybrid learned-shortlist + probe-on-disagreement (costs 2.1us vs 5.5ms vs
   25-100ms measured). **S4a LOFO test DONE 2026-07-29 (exp019) —
   NEGATIVE**: learned models fail family transfer (held-out rho
   0.25-0.43; regret 1.243x on stencil where the hand rule = 1.000x —
   they prefer the catastrophic variants). S4a demoted to within-family
   niche; deployment selector remains causal-structural check +
   probe-on-disagreement. Revisit only with deployment-scale family
   diversity. S4b runs weekly regardless.

## constraints (every session)

- local machine only; push only to swap415/experiments; no external PRs/issues/links.
- never `import numba` with cwd=/home/claude/dev (source checkout shadows wheel).
- uv only; .venv/bin/python not `uv run` for measured runs.
- quiet machine before PMU runs; mean/std/n on every claim; rerunnable script per result.
- recompute summary claims from raw CSVs, never from memory of the run.

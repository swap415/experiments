# roadmap — seeded directions, scored 2026-07-23

Four seeds evaluated. Verdict: phased single bet, S1 spine. Arc holds:
counters → cost model → justifies passes (S2) + benefit-per-ms compile cuts (S3)
→ corpus becomes training/eval substrate for learned heuristics (S4a).

## scores

| seed | score | basis |
|------|-------|-------|
| S1 counter-driven cost models | 8.5 | exp013: param-only Spearman 0.29 vs one-IPC-probe 0.994. Harness + PMU access exist. Gap vs Ithemal/uiCA: kernel-level, parfors context. |
| S3 compile-time attack | 7.5 | fresh, cheap to start, measurable. Differentiator = benefit-per-ms pruning (needs S1 for "benefit"). |
| S2 ship passes | 7.0 | exp009 proves the muscle (409.9 GFLOP/s patch). Gated: pass choice without cost model = guessing. Layer decision pending. |
| S4b LLM agents on core | 6.0 | asm-diff pattern mining + bug repro credible today; superopt search speculative. Weekly side-thread. |
| S4a learned JIT heuristics | 4.0 → rises | no training substrate until S1 corpus v2. Gate: corpus v2 landed + cost model validated. |

## phases

1. **S1 corpus v2 — DONE 2026-07-23** (exp013): clean 66-variant corpus, all
   rows counter-verified within 5% executed-vs-nominal; one-probe 0.988/0.977
   grp/95% top1; params 0.52 + cliff-FAIL. Distinct constants were NOT enough
   (shared-base recurrence CSE, exact 0.5 ratio) — distinct multipliers fixed
   it. **now**: llvm-mca / TTI predictions vs measured for numba-emitted code
   shapes — quantify where static assumptions break (cliff rows first).
2. **S3 phase 1 — DONE 2026-07-23** (exp014): cold start = import 94ms +
   one-time init 64ms + pipeline (35ms simple → 130ms arrayexpr/parfors).
   82% of simple-kernel cold start is fixed overhead; typing is 3.6% of
   pipeline (folk theory false); LLVM 25-46%. Caching ceiling for simple
   kernels is 18%. **now**: import-time profile, decompose the 64ms init,
   NUMBA_LLVM_PASS_TIMINGS per-pass table for the big kernels.
3. **gate(S1 mca-validation) → S2**: pick layer (numba IR vs llvmlite new-PM
   plugin) from evidence, ship one pass justified by measured cost deltas.
   gate(S1+S3) → benefit-per-ms pass pruning.
4. **S4a scoping — DONE 2026-07-23** (exp015, gate opened by corpus v2):
   learned ridge on params+asm hits 0.975 global out-of-sample but a feature
   information ceiling within-group (0.795/82% — identical for pointwise,
   pairwise, all feature sets; missed groups have identical asm, 2-4% spread).
   Regret: learned 1.011x geo / 1.194x max; probe 1.000/1.006. Design verdict:
   hybrid learned-shortlist + probe-on-disagreement (costs 2.1us vs 5.5ms vs
   25-100ms measured). Next S4a gate: >=3 kernel families in the corpus.
   S4b runs weekly regardless.

## constraints (every session)

- local machine only; push only to swap415/experiments; no external PRs/issues/links.
- never `import numba` with cwd=/home/claude/dev (source checkout shadows wheel).
- uv only; .venv/bin/python not `uv run` for measured runs.
- quiet machine before PMU runs; mean/std/n on every claim; rerunnable script per result.
- recompute summary claims from raw CSVs, never from memory of the run.

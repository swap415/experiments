# exp021 (S2): retry_compile() shipped and validated live (2026-07-30)

retrycompile.py (repo root) packages the exp017/exp018 policy: compile,
check packed fma in the emitted asm, recompile once across the unroll
cliff iff collapsed, restore the threshold, keep the retry iff it
vectorizes. This experiment runs all 16 corpus v3 kernels through the
utility in ONE process — the deployment scenario exp018 never tested
(its configs lived in separate subprocesses). Raw: results.csv, n=5
timing reps per measurement.

## results (single process, in order, toggling inline)

- The 7 genuine cliff rows fire and recover 3.85-8.49x (reduction d=160:
  5.69 -> 48.32 GF/s). All 9 non-cliff rows: 1.00-1.02x, rule silent.
- Utility overhead when silent: +3-7ms (one inspect_asm regex pass).
  When fired: retry_total ~2.1-3.0x the plain compile (two compiles +
  check) — 133-269ms total, against 4-8x runtime forever after.
- Leak check: a threshold-SENSITIVE control (reduction d=96, needs
  effective t=300) compiled after the sweep: 480 packed fma, 53.5 GF/s —
  pristine behavior, no leaked state.

## the bug this session caught (and how)

First run restored the threshold to 150 — LLVM's documented BASE default.
Wrong: O3 boosts the effective threshold to 300, and the cl-opt override
pins past the boost, so restore=150 silently broke every subsequent
default compile needing 150<t<=300. Detected because reduction d=96
FIRED here but was clean in exp018 — a cross-experiment consistency
contradiction. Verified empirically (pristine 480 packed; restore=300 ->
480; restore=150 -> 0) and fixed: DEFAULT_THRESHOLD=300 with the
explanation in the module. Lesson recorded: restore-to-default logic
must restore the EFFECTIVE default, and every toggle needs a
threshold-sensitive post-condition, not an insensitive one (the first
leak check used stencil d=64, which can't feel the difference).

## status

S2 deliverable #1 complete: mechanism (cl-opt toggle) + policy (asm
rule) + packaging (retry_compile) + live validation. Remaining S2 queue:
in-repo RFC note; optional per-kernel opt-level extension (exp020 found
O2>O3 on stencil d=64 by 15%).

Repro: `taskset -c 2 .venv/bin/python exp021-retrycompile/bench.py`

# exp018: corpus v3 — the asm-rule policy generalizes (2026-07-29)

Four families x depth sweep, default vs --unroll-threshold=2000, fresh
subprocess per config, fp_arith-verified probe per sample, 5 timing reps.
Raw: results.csv. Scoring: analyze.py. 21 variants (map anchors 5,
reduction 7, stencil 5, gather 4).

## per-family findings

- reduction (s += chain_d(x)): the collapse cliff EXISTS here too —
  d=104 drops to 7.4 GF/s exactly like map — and the knob fixes it
  bigger than in map: 6.8x/7.1x/7.6x/8.3x at d=104/112/128/160
  (e.g. 7.37 -> 50.07 GF/s). Controls d<=96 unchanged.
- stencil (d-tap dot with coefficient array): the raw knob is
  CATASTROPHIC: -19% (d=64), -37% (d=96), -83% (d=128, 28.63 -> 4.81
  GF/s — full unroll of the tap loop destroys the outer-loop
  vectorization that LLVM's default heuristic gets right). The default
  emits packed fmas on every stencil row, so the asm rule never fires
  and dodges every regression.
- gather: corpus-design flaw, counter-caught (again): a single shared
  multiplier lets reassociation factor sum(b*C) = C*sum(b) — ELISION
  flagged on all rows; nominal-flops labels invalid. Config-relative
  speedups remain valid: knob regresses gather -11/-21/-14% and never
  vectorizes it, so the rule never fires. v3.1 fix: per-tap w[k]
  multiplier (like stencil).

## policy scorecard (21 variants, from results.csv)

| selector | geo | worst | regressions>3% |
|---|---:|---:|---:|
| raw knob (global thresh2k) | 1.515x | 0.168x | 7 |
| asm rule (exp017)          | 1.775x | 1.000x | 0 |
| oracle best-of-two         | 1.777x | 1.000x | 0 |

The rule fired on exactly the 7 genuine cliff rows (3 map + 4 reduction)
and skipped all 7 rows the knob regresses. On this corpus the
conservative rule IS the oracle to within 0.1%. Combined with exp017's
66-variant corpus: rule = zero regressions on 87 variants across 4
families, capturing 98-100% of oracle gains.

## corpus v3 status (S4a gate)

Three families clean and counter-verified (map, reduction, stencil);
gather needs the v3.1 multiplier fix before its flop labels are usable.
S4a gate (>=3 families) is OPEN on the clean subset.

Repro: `.venv/bin/python exp018-corpusv3/bench.py` then `analyze.py`.

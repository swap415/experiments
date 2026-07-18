# exp013: cost signals for kernel-variant ranking (v1 — partial)

66 variants (chain x accumulators x dtype), single pinned P-core, asm
features + one perfcnt calibration rep each. Raw: results.csv.

## model comparison (predicting measured per-variant performance)

| model | spearman | geo-err | max-err | cliff 96>112 |
|---|---:|---:|---:|---|
| a. static-op (params only)     | 0.289 | 2.74 | 17.2x | FAIL |
| b. latency-analytic (params)   | 0.689 | 2.34 | 10.7x | FAIL |
| c. asm-feature (zero timing)   | 0.806 | 1.59 |  4.8x | PASS |
| d. one-probe (1 IPC calib rep) | 0.994 | 1.08 |  1.42x | PASS |

Thesis result: parameter-only cost models — what naive e-graph extraction
would use — are near-uninformative on real hardware (rank corr 0.29, 17x
errors) and cannot see codegen discontinuities. Reading the emitted asm is
free and fixes the ranking; a single measured probe per variant is
near-exact. Cheap hardware grounding >> static modeling.

## CAVEAT (hardware-counter verified): v1 corpus is contaminated

Physics check: chain=96 accs=4 float32 reads 539 "GFLOP/s" on one core —
above the 169.6 GFLOP/s f32 FMA peak (5.3 GHz x 2 ports x 8 lanes x 2).
fp_arith_inst_retired counters on a repro confirm the compiler ELIDES
work for accs>1: ~296M packed ops executed vs ~604M expected (~2-4x
eliminated — CSE of identical accumulator chains; all accs start at the
same value with the same constant, so they compute identical results).
Also, f64 literals silently promote f32 chains to double (repro retired
0 single-precision ops) — the corpus generator casts constants via numpy
scalars, which should prevent this, but >peak f32 rows mean nominal-flops
accounting is wrong for accs>1 either way.

Consequences: the table above is valid as "predicting measured runtime of
the emitted code" (elision is part of what model c sees and models a/b
miss — arguably strengthening the thesis), but nominal-GFLOP/s labels are
wrong for accs>1, and per-element work is not constant across accs as
designed.

## v2 tasks

1. Distinct per-accumulator init values and constants (defeat CSE).
2. Extend perfcnt with fp_arith_inst_retired events (cpu_core PMU) and
   record executed vs nominal flops per variant; assert within 5%.
3. Re-verify f32 rows retire packed_single, not promoted double.
4. Rank-within-computation evaluation: extraction compares implementations
   of the SAME computation — evaluate model ranking within each
   (chain, dtype) group across accs, not across the whole corpus.

Repro: `taskset -c 2 uv run python exp013-costmodel/bench.py` then
`uv run python exp013-costmodel/analyze.py`.

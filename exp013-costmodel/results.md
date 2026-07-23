# exp013: cost signals for kernel-variant ranking (v2 — clean corpus)

66 variants (chain 8-160 x accs 1/2/4 x f32/f64), single pinned P-core,
asm features + one perfcnt calibration rep each. Raw: results.csv.
v1 numbers are superseded: that corpus was CSE-contaminated (see below).

## corpus verification (every sample, hardware counters)

fp_arith_inst_retired.* wired into perfcnt (fp=True): executed flops match
nominal 2*chain+(accs-1) per element within 5% on all 66 rows (worst
1.0093, chain=160 accs=4 f64); zero wrong-precision retirement (f32 rows
retire packed_single only); zero counter multiplexing. Peaks respected:
max f32 138.9 GFLOP/s = 82% of 169.6 peak, max f64 65.0 = 77% of 84.8.

Getting the corpus clean took two fixes, both counter-caught:
1. Distinct per-acc constants are NOT enough. With a shared multiplier x,
   acc_j(n) = Z_j*x^n + C_j*S(x) — LLVM computes the shared powers once:
   exactly 0.500 executed/nominal at accs=2. Fix: distinct multipliers
   x_j = x + D_j (distinct bases kill the shared structure).
2. The x_j adds vanish from the counts: first unrolled iteration has
   acc = Z_j (constant), so Z_j*(x+D_j)+C_j folds to one fma. Measured
   deficit = accs-1 exactly on all six flagged rows; nominal accounts it.

## model comparison

global = rank all 66; group = rank accs within each (chain,dtype) — the
extraction scenario: same computation, competing implementations. 22 groups.

| model | spearman | geo-err | max-err | grp-rho | top1 | cliff |
|---|---:|---:|---:|---:|---:|---|
| a. static-op (params)          | 0.517 | 2.03 | 10.4x | 0.000 |  5% | FAIL |
| b. latency-analytic (params)   | 0.631 | 1.91 |  7.5x | 0.795 | 82% | FAIL |
| c. asm-feature (zero timing)   | 0.938 | 1.24 |  2.3x | 0.760 | 23% | PASS |
| d. one-probe (1 IPC calib rep) | 0.988 | 1.04 |  1.3x | 0.977 | 95% | PASS |

## claims (recomputed from results.csv)

1. Parameter-only cost models stay weak on a clean corpus: 0.52 rank corr,
   10x errors, and they cannot see codegen discontinuities (cliff FAIL).
   v1's headline survives decontamination.
2. NEW: the full-unroll cliff position is variant-dependent — collapse to
   scalar at chain 96->104 (accs=1), 112->128 (accs=2), 128->160 (accs=4);
   4.2x throughput at the accs=1 edge (30.98 vs 7.44 GFLOP/s). A static
   threshold cannot encode this; asm/probe see it for free.
3. NEW (within-group): asm features saturate for fine-grained choices —
   grp-rho 0.760, top1 23% (simd_regs caps at the in-flight bound, ties
   break wrong), while the latency-analytic model does fine within groups
   (0.795/82%) until a cliff row enters. Only the one-probe model is
   uniformly strong: 0.988 global / 0.977 group / 95% top1 / 1.33x max.
4. Methodology: executed-vs-nominal flops verification on every sample is
   cheap (6 extra counters, one rep) and caught two distinct compiler
   elision mechanisms that silently invalidated v1. Corpus generators for
   cost-model work should treat "compiler computed something else" as the
   default hypothesis, not the exception.

## next (thread 2)

llvm-mca / TTI static predictions vs this measured corpus — where do
LLVM's own models break for numba-emitted shapes (cliff rows first).

Repro: `taskset -c 2 .venv/bin/python exp013-costmodel/bench.py` then
`.venv/bin/python exp013-costmodel/analyze.py`.

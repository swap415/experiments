# exp017 (S2): the unroll cliff is fixable at the llvmlite layer (2026-07-28)

Layer question answered by experiment: LLVM cl-opts set through
llvmlite.binding.set_option ARE respected by numba 0.66's pass pipeline,
toggle mid-process in both directions (verified: packed_fma 0 -> 112 ->
0 on recompiles of the same kernel shape), and fix the exp013 cliff.
Raw: results.csv (cliff rows, 3 configs), corpus.csv (66 variants,
default vs --unroll-threshold=2000).

## cliff rows (f64, n=5 reps each)

--unroll-threshold=2000 recovers every collapsed row; controls unchanged:

| kernel | default | thresh2k | speedup | compile default -> 2k |
|---|---:|---:|---:|---|
| 104/1 |  7.5 | 28.1 | 3.7x | 179 -> 106ms |
| 112/1 |  7.1 | 26.7 | 3.8x | 192 -> 111ms |
| 128/1 |  6.5 | 25.1 | 3.9x | 226 -> 122ms |
| 160/1 |  5.7 | 22.5 | 3.9x | 295 -> 147ms |
| 128/2 | 10.3 | 39.5 | 3.8x | 167 -> 102ms |
| 160/2 |  9.3 | 36.1 | 3.9x | 208 -> 119ms |
| 160/4 | 15.6 | 49.7 | 3.2x | 152 -> 111ms |

Compile time DROPS 40-50% on fixed rows: refusing to full-unroll costs
LLVM more downstream work (scalar path churn) than unrolling. The fix
has NEGATIVE compile-time cost on affected kernels. thresh16k adds
nothing over thresh2k (and costs ~5% on two controls).

## corpus-wide (66 variants, from corpus.csv)

- geo speedup 1.418x; 21 variants improve >5% (max 8.07x, f32 cliff
  rows); compile time mean -19.7ms (min -179, max +6.2).
- NOT free: 12 variants regress >3%, worst -22% (chain 8-64, where the
  raised threshold changes unroll shapes that were already good).
- 0 elision flags (fp_arith-verified on every sample).

## the shipped policy (S1 machinery closes the loop)

Selection rule from exp013's asm features: use thresh2k ONLY when the
default compile failed to vectorize (packed_fma == 0) and thresh2k
vectorizes it. Measured on the corpus: geo 1.427x of the 1.452x oracle,
worst case 1.000x — ZERO regressions, switches 14/66 variants. Cost: one
inspect_asm regex (5.5ms, exp015) + one recompile on collapsed kernels
only — which is 40-50% cheaper than their default compile anyway.

Deployable today, no numba fork:
    compile -> inspect_asm -> if no packed fma:
    set_option --unroll-threshold=2000 -> recompile -> restore option.

## layer decision (recorded)

llvmlite cl-opt layer WINS for this class: effective, toggleable
per-compile, zero maintenance surface. A numba-IR unroll pass is only
justified if (a) cl-opts break under a future NPM change, or (b) the
policy needs sub-function granularity. Next S2 candidates: wrap the
recipe as a reusable retry_compile() utility; test the rule on other
kernel families (multi-family corpus, shared gate with S4a); RFC draft
update (in-repo only).

Repro: `.venv/bin/python exp017-unroll/bench.py` (cliff),
`--corpus` (66 variants), both pinned taskset -c 2 internally.

# exp022 (S4b): numba vs clang -O3 asm-diff mining (2026-08-05)

Six kernels, C mirrors semantically identical to the numba builders
(kernels.c), clang-18 -O3 -march=native -ffast-math via ctypes vs
njit(fastmath=True). Both sides measured identically (5 reps, pinned,
fp_arith-verified probe each). Raw: results.csv, fix_variants.csv.
Version caveat: clang 18.1.3 vs llvmlite's older bundled LLVM — parity
results make this mostly moot; the one delta was attributed to
semantics, not version.

## headline: parity on 5/6, one real find on the 6th

| kernel | numba | clang | ratio | asm shapes |
|---|---:|---:|---:|---|
| saxpy       |  7.65 |  7.70 | 1.01x | memory-bound, equivalent |
| poly96      | 30.15 | 30.13 | 1.00x | identical 96p/96s |
| poly112     |  7.09 |  7.08 | 1.00x | BOTH collapse 0p/16s |
| reduction64 | 61.69 | 62.08 | 1.01x | 320p vs 256p, same speed |
| stencil64   | 37.32 | 36.97 | 0.99x | identical 15p |
| gather64    |  8.71 | 13.40 | 1.54x | same 16x vgatherqpd, SAME 15p |

1. numba's codegen quality EQUALS clang-18 on map/chain/reduction/
   stencil shapes — no missed-optimization backlog there. (Good news
   worth stating: the folk belief that JIT codegen trails AOT does not
   hold on this corpus.)
2. poly112: clang hits the SAME cliff at the same place with the same
   collapsed asm — exp017's unroll cliff is generic LLVM heuristic
   behavior, independently confirmed. retry_compile()'s threshold
   would help clang users too.

## the find: negative-index wraparound tax on gathered loads (1.4-1.6x)

numba's gather hot block: 188 instructions, of which 128 are integer
index manipulation — 48 vpaddq, 32 vpsllq, 16 each vpcmpgtq/vpand/
vpcmpeqd — against 16 gathers + 9 fmas of actual work. The vpcmpgtq
pattern is Python negative-index wraparound (if x<0: x+=n), vectorized
per element per iteration; clang's C loop has ZERO index arithmetic in
the body (indices hoisted; no wraparound semantics to honor).

Fix, measured (fix_variants.py; gather rows carry ~10% placement
variance, ratios are same-run):
- int64 idx (numpy default): 7.8-8.8 GF/s, 16 vpcmpgtq / 48 vpaddq.
- uint64 idx, int64 offset: NO improvement — u64+i64 promotion
  re-poisons the expression (the sharp edge; docs-worthy).
- fully unsigned (uint64 idx AND np.uint64 offset): 12.6-12.7 GF/s,
  0 wraparound instructions, 1.44-1.63x, ~95% of clang.

## measured vs speculative

Measured: everything above. Speculative (upstream-actionable, in-repo
RFC candidate): numba could eliminate the wraparound automatically —
`i & 7` is provably non-negative, and range analysis on induction
variables would cover most real gather patterns; today the typing stays
int64 and the guard is emitted unconditionally. Not verified against
numba internals; the observable is the emitted guard.

Repro: `taskset -c 2 .venv/bin/python exp022-asmdiff/bench.py` then
`fix_variants.py`.

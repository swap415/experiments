# exp005: LLVM full-unroll cliff — 4.5x from a 4-iteration change

Single pinned P-core, poly kernel, inner loop = `chain` sequential fmas on
a loop-invariant x. Trip count is a compile-time constant.

| chain | GFLOP/s | packed fma in asm | scalar fma |
|---:|---:|---:|---:|
| 32 | 48.4 | 31 | 31 |
| 64 | 37.2 | 63 | 63 |
| 96 | 31.8 | 95 | 95 |
| **100** | **7.8** | **0** | 20 |
| 112 | 7.1 | 0 | 16 |
| 128 | 6.5 | 0 | 16 |

Mechanism, confirmed by inspect_asm(): at chain <= 96 LLVM fully unrolls the
inner loop, which lets it vectorize the *outer* loop 4-wide (ymm packed
fmas). At chain >= 100 the full-unroll threshold trips, the inner loop stays
rolled, outer-loop vectorization becomes impossible, and the kernel drops to
a scalar latency-bound fma chain. 96 -> 100 fmas per element: 4.5x
throughput cliff.

Even in the "good" regime throughput decays smoothly (48 -> 32 GFLOP/s from
32 to 96) as the sequential chain grows relative to the OoO window's ability
to overlap outer iterations.

## why this matters (thread 2)

Cost models for e-graph extraction (Numba v2/SealIR) and autotuners must
capture *discontinuities* like this: the cost of a loop nest is not smooth
in its parameters. A static per-instruction cost model gets this wrong by
4.5x; a counter-validated model (or one that consults the emitted asm, as
here: packed-fma count is a perfect predictor) gets it right. Cheap signal:
`inspect_asm` + regex beats wall-clock measurement for detecting the regime.

Also a practical numba gotcha: splitting one long fma chain into two
back-to-back loops of 64 would be ~5x faster than one loop of 128.

Repro: `taskset -c 2 uv run python exp005-unroll-cliff/bench.py`

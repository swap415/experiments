# exp002: in-process perf counter harness

`perfcnt.PerfGroup`: perf_event_open via ctypes, inherit=1, per-PMU events
(cpu_core / cpu_atom) using the extended config encoding (pmu_type << 32).
Open before numba spawns its pool; enable/disable brackets exactly the
measured region — JIT compile excluded, all pool threads counted.

## validation

xorshift64 loop, 1e8 iters, serial: measured 0.93 Ginsn = 9.3 insn/iter
vs 9 expected (3 shift + 3 xor + inc + cmp + branch). Within 4%.

Two compiler-elision traps found on the way (both caught by the counters):
1. `s += i` loop — LLVM folds to closed form, 0 instructions retired.
2. LCG `s = a*s + c` — instcombine composes affine updates under unrolling,
   ~6x fewer instructions than written. Ground truth loops must be
   non-composable (xorshift works).

Also: perf_event_attr flags are bitfields — inherit is bit 1. Getting bit 5
(exclude_kernel) instead silently counts only the main thread.

## poly kernel, counters bracket kernel-only region (5 reps)

| threads | GFLOP/s | P: Gcyc / Ginsn / IPC | E: Gcyc / Ginsn / IPC |
|--------:|--------:|----------------------|----------------------|
| 4  | 144 | 6.12 / 5.80 / 0.95 | 0 / 0 / — |
| 8  | 154 | 6.07 / 5.68 / 0.94 | 0.54 / 0.13 / 0.24 |
| 12 | 161 | 5.99 / 5.34 / 0.89 | 1.93 / 0.47 / 0.24 |
| 20 | 158 | 6.48 / 4.46 / 0.69 | 5.61 / 1.37 / 0.24 |
| 28 | 194 | 7.41 / 3.80 / 0.51 | 8.68 / 2.03 / 0.23 |

Total retired instructions are constant (~5.8G = the work), so the split is
clean. Findings:

1. **E-core IPC is a flat 0.23-0.24** on this AVX2 FMA kernel in every
   config — Gracemont cracks 256b ops and this kernel is latency-chained.
   At 28 threads E-cores burn 8.7 Gcycles to retire 2.0 Ginsn (~35% of the
   work: 2.03 of 5.83 Ginsn) — 12 cores contributing ~25% speedup.
2. **Anomaly: 8 threads ≈ 4 threads** (154 vs 144 GFLOP/s) despite 8
   P-cores being available. Cycle accounting shows per-thread effective
   clock dropping from ~5.1 GHz (4t) to ~2.7 GHz (8t). Same total insn.
   Hypotheses: (a) OS placing threads on HT siblings of the same physical
   core, (b) all-core AVX frequency drop, (c) pool threads sleeping in
   barriers. exp003 tests these with explicit affinity (taskset).

Repro: `uv run python exp002-perfcnt/bench.py`

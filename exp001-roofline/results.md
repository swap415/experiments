# exp001: roofline baseline

i7-14700 (8 P + 12 E cores, 28 threads), DDR5, numba 0.66.0, numpy 2.4.6, python 3.12.
Arrays: 64M float64 (512 MB each — 15x the 33 MB LLC, so DRAM-resident).

## triad — memory bound

`a[i] = b[i] + s*c[i]`, 24 bytes/element traffic.

| threads | time (ms, n=5) | GB/s |
|--------:|---------------:|-----:|
| 1  | 51.8 (std 0.2) | 31.1 |
| 2  | 37.4 (std 0.6) | 43.0 |
| 4  | 26.6 (std 0.7) | **60.6** |
| 8  | 27.2 (std 0.7) | 59.1 |
| 28 | 28.2 (std 0.1) | 57.1 |

Memory bandwidth saturates at ~60 GB/s with 4 threads. More threads slightly
*hurt* (contention). This is the physics wall: any memory-bound kernel on this
box is done optimizing at 60 GB/s, regardless of compiler.

## poly — compute bound

64-deep fma chain per element, 128 flops/element.

| threads | time (ms, n=5) | GFLOP/s |
|--------:|---------------:|--------:|
| 1  | 211.2 (std 0.1) |  40.7 |
| 4  |  58.5 (std 0.0) | 146.8 |
| 8  |  57.5 (std 0.7) | 149.3 |
| 12 |  42.6 (std 3.9) | 201.4 |
| 16 |  56.0 (std 1.6) | 153.4 |
| 28 |  44.4 (std 2.5) | 193.3 |

8 threads is no faster than 4, and the sweep past 8 is noisy (std up to 9%).

## finding: static chunking loses on hybrid cores

perf stat shows P-cores retiring 4.5–5.1 insn/cycle on this kernel while
E-cores retire 1.1–1.6 — a 3–4x per-cycle gap. numba's prange divides work
into equal static chunks, so whenever a chunk lands on an E-core the whole
kernel waits for it. That explains both the 8-thread plateau (OS scheduler
spills onto E-cores) and the high variance.

Estimated headroom: with work-stealing or P/E-aware chunk sizing, the 12-28
thread configs should reach ~1.4x the 4-thread P-core-only number instead of
oscillating around 1.0-1.35x.

## methodology caveats

- perf counter attribution through `uv run` (exec) + numba's thread pool
  multiplexes cpu_core/cpu_atom PMUs badly (20-80% coverage). exp002 should
  build an in-process perf_event_open harness so counters bracket exactly the
  measured region, excluding JIT compile.
- theoretical DDR5 peak here is ~80-90 GB/s; sustained 60 GB/s (~70%) is
  typical. Worth one STREAM run to confirm numba isn't leaving bandwidth on
  the table.

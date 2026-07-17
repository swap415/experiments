# experiments

Research sandbox: compilers (numba/LLVM), hardware counters, and inference
efficiency on commodity CPUs. Each `expNNN-*/` directory is one self-contained
experiment: a script that reproduces it and a `results.md` with measured
numbers. Claims require evidence; evidence requires a rerunnable command.

Hardware: Intel i7-14700 (8 P-cores + 12 E-cores), DDR5, Linux 6.8.

- `exp001-roofline/` — machine physics baseline: 60 GB/s memory wall,
  P/E-core IPC gap, numba prange static-chunking loss on hybrid cores.

Setup: `uv sync`, then `uv run python expNNN-*/bench.py`.

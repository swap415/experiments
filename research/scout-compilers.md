# scout notes: compilers for numerical computing & ML, 2025-2026

Web survey, 2026-07-17. Literature context, not our results.

## 1. Numba's current state and new infrastructure

- **Numba v2 / SealIR** — SciPy 2025 paper "Numba v2: Towards a SuperOptimizing Python Compiler" (Siu Kwan Lam, Anaconda). Python → structured IR → **RVSDG** in functional form, encoded as an **e-graph**, optimized via **equality saturation with egglog**. Optimization becomes cost-modeling + extraction; kills phase-ordering. Targets: user-written rewrite rules, FP approximation beyond -ffast-math, auto GPU offload. Prototypes: https://numba.pydata.org/numba-prototypes/sealir_tutorials/ch08_gpu_offload.html. Paper: https://proceedings.scipy.org/articles/fncj2446
- **numbacc** (https://github.com/numba/numbacc) — "the Numba ahead-of-time compiler", Python + MLIR 20/21. Targets cold-start JIT latency, distributable binaries, caching fragility.
- **PIXIE** (https://github.com/numba/pixie) — AOT extension modules embedding LLVM bitcode + CPU dispatch, so AOT libraries can be *inlined into JIT compilation* (LTO-style across precompiled and @njit code). Unique in the Python space.
- **numba-cuda split**: numba.cuda deprecated as of 0.61 → NVIDIA's numba-cuda, itself in maintenance, new work in **numba-cuda-mlir**. Intel's numba-mlir dormant. NVIDIA owns GPU; Anaconda core team owns CPU/e-graph.

## 2. MLIR for CPU numerical computing

- **Transform dialect** (https://arxiv.org/html/2409.03864v2) — pass composition as first-class IR, schedules as data, designed for autotuning. Canonical CPU pipeline: linalg (tile/fuse/pack) → vector → LLVM; tuned MLIR reaches ~82-90%+ of AVX2 DGEMM peak.
- **PEAK** — schedule search on transform dialect (https://users.cs.utah.edu/~tavak/assets/pdf/Peak_LCPC.pdf); MLIR autotuning literature is thin.
- **IREE** — production MLIR compiler; x86 CPU perf not its center of gravity.
- **Scheduling languages taxonomy** (https://arxiv.org/pdf/2410.19927) — Halide→TVM→Exo→transform-dialect map.

## 3. Kernel compilation frontier

- **Triton-CPU** (https://github.com/triton-lang/triton-cpu) — experimental, active, immature. A real gap.
- **Mojo** — MAX kernels open-sourced 2025; compiler open-sourcing planned fall 2026, Mojo 1.0 H1 2026. HPC eval: https://arxiv.org/html/2509.21039v1
- **Exo 2** (ASPLOS'25, https://arxiv.org/pdf/2411.07211) — user-definable scheduling operators. TVM MetaSchedule remains reference autotuner; TVM momentum fading.
- **Finch** (https://dl.acm.org/doi/10.1145/3720473) — sparse compilation with control flow + structured formats.
- **LLM kernel generation** is the loudest frontier: KernelBench (+2026 "hard" split scored against hardware ceilings, kernelbench.com), AutoTriton (RL, https://arxiv.org/pdf/2507.05687), TritonRL, EvoEngineer, KForge. Survey: https://github.com/flagos-ai/awesome-LLM-driven-kernel-generation. Nearly all GPU-only.

## 4. Hardware-counter-driven compilation

- **BOLT** — perf-sample post-link layout, +5-20%, mature, still active.
- **Counters→autotuning convergence** (https://arxiv.org/abs/2102.05297, JPDC 2022) — counter models cut empirical search dramatically. *Very little* recent CPU follow-up; most autotuners still wall-clock-only. Underpopulated relative to leverage.
- Roofline/PMU methodology continues (RISC-V PMU roofline: https://arxiv.org/html/2507.22451v1).

## 5. Superoptimization / search-based

- **egg**/**egglog** are the substrate; **DialEgg** (CGO 2025) makes MLIR dialects egglog-optimizable. https://github.com/philzook58/awesome-egraphs
- STOKE-style stochastic search absorbed into **LLM+evolution hybrids**: AlphaEvolve (May 2025), ShinkaEvolve, CodeEvolve.

## Where numba sits

Being unbundled: GPUs → NVIDIA, CPU future → SealIR/egglog/numbacc/PIXIE. That stack is genuinely differentiated (nobody else e-graph-superoptimizes imperative Python) but early-prototype: **no cost models validated against real hardware**, no autotuning loop. Numba's moat: "existing NumPy code, zero rewrite, CPU-first." The open question is precisely *cost extraction* — equality saturation reframes optimization as cost modeling, and nobody has good CPU cost models.

## Publishable niches (small team, Python + numba + LLVM + perf counters, i7-14700)

1. **Perf-counter-grounded cost models for e-graph extraction** — learning extraction costs from measured counters on real x86; unclaimed, feeds Numba v2 directly.
2. **Counter-driven autotuning loop for numba kernels** — @tune-decorated njit searched over unroll/tile/vectorize/fastmath using roofline position + counters to prune. **Hybrid P/E-core scheduling adds a twist nobody in the autotuning literature covers.**
3. **KernelBench-for-CPU** — numba/C/Triton-CPU kernels scored against perf-measured roofline ceilings on commodity hardware; obvious hole, cheap to run.
4. **LLM + equality-saturation hybrid** — LLM proposes rewrites, e-graph verifies equivalence, extraction by measured cost; verifiable-by-construction beats "did the test pass."
5. **PIXIE-style JIT/AOT blending study** — cold-start/steady-state tradeoffs; low-risk systems paper adjacent to numbacc.

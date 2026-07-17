# scout notes: LLM inference optimization, 2025-2026

Web survey, 2026-07-17. Literature context, not our results.

## 1. Metrics, ranked by workload

**(a) Interactive chat:** TTFT first (sub-second p99 is the norm), then ITL/TPOT (must beat reading speed, ~20-50ms/token), then goodput — the rate of requests meeting *both* TTFT and TPOT SLOs simultaneously. TTFT and TPOT are driven by different phases (compute-bound prefill vs memory-bound decode) and respond oppositely to batching, so raw throughput is misleading — goodput under heterogeneous SLOs is the metric ([SLO surveys](https://arxiv.org/pdf/2410.14257), [SCORPIO](https://arxiv.org/pdf/2505.23022), [AdaServe, EuroSys'26](https://www.cs.cmu.edu/~zhihaoj2/papers/AdaServe_EuroSys26.pdf)).

**(b) Agentic workloads:** dominant metrics are **prefix-cache hit rate** and **end-to-end job completion time across tool-call round-trips**, plus KV-cache memory efficiency. Each turn resends a long, mostly-static context; recomputing prefill dominates cost. 75-95% cache hit rates achievable with radix-tree caching; eviction during tool-call idle windows is the failure mode ([Continuum, ICLR'26](https://arxiv.org/abs/2511.02230)).

**(c) Batch/offline:** tokens/sec/dollar and tokens/joule. SOTA ~0.39 J/output token (Llama3-70B FP8 on H100), ~10x better than 2023 ([TokenPowerBench](https://arxiv.org/html/2512.03024v1), [Joule 2026](https://www.cell.com/joule/fulltext/S2542-4351(26)00114-5)).

## 2. Engines and their current battles

- **vLLM**: PagedAttention + chunked prefill are table stakes; current work is disaggregated prefill/decode, EAGLE-3 spec decode (up to 2.5x), KV-connector ecosystems (LMCache). Gap: chunked prefill fixes compute scheduling but not memory provisioning.
- **SGLang**: RadixAttention makes it the default for agentic/multi-turn; attacking cache-aware scheduling and hierarchical (GPU/CPU/disk) cache tiers.
- **TensorRT-LLM**: pivoted to PyTorch-first backend; attacking Blackwell NVFP4, wide expert parallelism for MoE, disaggregated serving.
- **llama.cpp / local**: GGUF K-quants; decode is memory-bandwidth-bound, battles are quantization quality at 2-4 bit, prompt-processing speed (compute-bound, where AVX-512/AMX give 3-10x), NUMA/offload heuristics.

## 3. Key papers/systems

1. **EAGLE-3** — draft head with multi-layer feature fusion; 3.3-6.5x, production default in vLLM/SGLang. https://arxiv.org/abs/2503.01840
2. **Continuum (ICLR'26)** — KV cache pinned with TTL during tool calls; fixes agent-loop eviction. https://arxiv.org/abs/2511.02230
3. **KVFlow** — workflow-aware prefix caching for multi-agent systems (eviction by agent-step graph, not LRU). https://arxiv.org/pdf/2507.07400
4. **TurboQuant (ICLR'26)** — calibration-free KV quantization near rate-distortion limit via random rotations; ~6x memory at 3-bit.
5. **System-aware KV-cache optimization survey (ACL'26)** — best current map of eviction/quantization/offload trade-offs. https://arxiv.org/pdf/2607.08057
6. **FlashAttention-3 → 4** — asynchrony + FP8; FA4 co-designs for Blackwell, backs FlexAttention. https://arxiv.org/pdf/2407.08608
7. **SageAttention3** — microscaling FP4 attention. https://arxiv.org/pdf/2505.11594
8. **Sarathi-Serve** — origin of chunked prefill / stall-free batching. https://arxiv.org/pdf/2403.02310
9. **"Beyond the Buzz"** — when P/D disaggregation actually wins. https://arxiv.org/pdf/2506.05508
10. **T-MAC (EuroSys'25)** — bit-wise lookup-table mpGEMM on CPU, no dequantization; 4-5x over llama.cpp; basis of bitnet.cpp. https://arxiv.org/abs/2407.00088
11. **Four Over Six** — adaptive block scaling for NVFP4. https://arxiv.org/html/2512.02010v5
12. **TokenPowerBench** — per-phase power benchmarking; tokens/joule first-class. https://arxiv.org/html/2512.03024v1

## 4. CPU/local inference

Decode is **memory-bandwidth-bound, full stop**: ~10-15 tok/s for 8B Q4 on dual-channel DDR5 desktops regardless of core count; AVX-512 accelerates prompt processing 2.8-10x but barely moves generation. AMX/AVX512-VNNI make INT8 competitive with 4-bit on Xeon. The research lever is **less memory traffic per token**: LUT-based mpGEMM (T-MAC, [Vec-LUT](https://arxiv.org/pdf/2512.06443)), ternary models (bitnet.cpp), compiler-generated CPU GEMM ([CGO'25](https://dl.acm.org/doi/pdf/10.1145/3696443.3708953)).

## 5. Compilers

torch.compile lowers to Triton, production-default, but gap to hand-written kernels remains **2-10x on critical fused ops**. FlexAttention narrows it for attention variants. MLC-LLM/TVM near-hand-tuned across backends at 10-30min compile cost. Hot direction: **LLM-driven kernel generation** (KernelBench, Meta's KernelEvolve: 1.25-17x over torch.compile, 8000+ Triton kernels in production) — almost entirely GPU-focused.

## Open problems for a small CPU + compiler team

1. **LUT-based mpGEMM codegen** — T-MAC's tables are hand-designed per bit-width/ISA; an autotuner (numba/LLVM) searching table layout/tiling/registers per CPU is unclaimed. "TVM for lookup-table GEMM."
2. **CPU-side speculative decoding** — accept/latency trade-off differs on CPU (verification bandwidth-bound); no published characterization for llama.cpp-class engines.
3. **Agent-loop-aware local serving** — radix prefix caching + tool-call-aware KV pinning + KV quantization in a CPU/local engine; fastest-growing workload, weakest local support. Eval data: TraceLab coding-agent traces (https://arxiv.org/pdf/2606.30560).
4. **KV-cache quantization kernels for CPU** — rotation-based 2-3 bit KV quant evaluated only on GPUs; on CPU, KV reads are THE decode bottleneck, compression → near-linear tokens/sec. Clean systems paper.
5. **Tokens/joule on client hardware** — TokenPowerBench covers datacenter; rigorous per-phase energy characterization of CPU/NPU local inference (RAPL) is cheap, unclaimed.

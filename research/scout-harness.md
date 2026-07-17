# scout notes: coding-agent harnesses + local-model agentic efficiency, 2026-07

Web survey, 2026-07-17. Literature context, not our results.

## 1. Kilo Code and the harness landscape

**Kilo Code** (kilocode.ai): Apache-licensed VS Code agent, fork merging Roo Code + Cline lineage; rebuilt April 2026; Roo Code archived May 2026. Modes (Code/Plan/Debug/Ask), subagents, MCP marketplace, 500+ models. Local models first-class via Ollama (11434), LM Studio (1234, OpenAI-compatible), generic endpoints. Docs warn local models "often do not support advanced features such as prompt caching" — the harness assumes cloud caching semantics and degrades on local backends. **No published Kilo-specific token-efficiency measurements — a gap.**

- **Cline**: recommends Qwen3-Coder-30B via LM Studio, 262k ctx, 4-bit; "compact prompt" mode ~10% smaller; warns KV-cache quantization causes erratic behavior (anecdote, no data).
- **OpenHands**: requires OLLAMA_CONTEXT_LENGTH ≥ 22000 (4096 default silently breaks agents). Context condenser: quadratic → linear context cost, no accuracy loss (54% vs 53%). OpenHands LM 32B: 37.2% SWE-bench Verified locally.
- **Aider**: repo-map + diff edits, lowest cost/task among open harnesses; Aider polyglot is the standard local coding eval.
- **Claude Code**: "Prompt caching is everything" (https://claude.com/blog/lessons-from-building-claude-code-prompt-caching-is-everything) — the best public harness-design doc: append-only layered context, never mutate cached prefix, mode switches as tools, deferred tool-schema loading. Rules translate directly to local prefix caches.

## 2. What makes harnesses slow on local models

Workload shape: **long shared prefixes + append-only growth + bursty short decodes per tool call** ([UltraQuant](https://arxiv.org/html/2606.20474)). [KVFlow](https://arxiv.org/abs/2507.07400): LRU eviction thrashes multi-agent workflows. [RelayCaching](https://arxiv.org/html/2603.13289v1): "cascading context redundancy." Local-stack failure modes: context truncation silently invalidating prefix, KV-quant instability, tool-parse retry loops; tool parsing/validation/exec latency often *exceeds* generation time when tools chain ([speculative tool calls](https://arxiv.org/pdf/2512.15834)).

## 3. Metrics

- **Tokens per resolved task** — "the only honest cost metric"; 500K to 8M tokens / 150+ turns per SWE-bench issue; cost/latency vary 10x across agents with no strong correlation to pass rate ([HAL, arXiv:2510.11977](https://arxiv.org/pdf/2510.11977)).
- **Cost per resolved issue** — $1.26/issue at 79.2% Verified (Sonar) vs $32.5 GPT-4-era.
- **Prefix-cache hit rate** — the dominant local-CPU lever (CPU prefill is compute-bound).
- **Tokens/joule** — TokenPowerBench.

## 4. Local serving for agents

llama.cpp: per-slot longest-common-prefix reuse. vLLM: hash-based automatic prefix caching. SGLang: RadixAttention, strongest for agentic sharing. Ollama: llama.cpp + dangerous 4k default context. Model capability no longer the bottleneck: Qwen3-Coder-30B-A3B runs agentic loops locally (Q4 dynamic: 60.9 vs 61.8 bf16 Aider polyglot); SWE-TRACE-30B: 63.5% SWE-bench Verified in mini-SWE-agent.

## 5. Harness–engine co-design (active 2025-26 thread)

[AgentInfer](https://arxiv.org/abs/2512.18337): cache-aware scheduling + big/small collab + spec decode from semantic memory + async compression — 50% fewer wasted tokens, 1.8-2.5x; argues optimize *task completion*, not tokens/s. [Sutradhara](https://arxiv.org/html/2601.12967): orchestrator–engine co-design. [Speculative tool calls](https://arxiv.org/pdf/2512.15834): 2-3x by executing predicted tools during decode. [SAGA](https://arxiv.org/html/2605.00528v1): workflow-atomic scheduling.

## Most worth optimizing (harness + local model, CPU)

1. Prefill tokens re-computed per turn (prefix-cache hit rate) — CPU prefill is the wall.
2. Tokens per resolved task (context growth per tool call; condensation policy).
3. Harness-induced cache invalidations (prompt mutations, tool-set changes, truncation).
4. Tool-call latency overlap (parsing/exec serialized behind decode).
5. Joules per resolved task (RAPL-measurable on i7-14700).

## Experiment ideas for this box

1. **Prefix-cache audit of harnesses**: instrument llama.cpp-server (n_past reuse logs) while Kilo/Cline/Aider/mini-SWE-agent solve identical tasks; per-turn cache hit rate + joules/task (RAPL). Hypothesis: harnesses violating append-only rules waste 30-70% of prefill.
2. **Cache-safe harness patch**: apply Claude Code's rules to Kilo Code's local path; measure latency + tokens/task before/after on 20 tasks.
3. **Condensation vs truncation vs llama.cpp context-shift**: resolve rate + prefill tokens on CPU where re-prefill is catastrophic.
4. **Speculative tool execution on CPU**: grammar-constrained early tool-name detection during streaming, launch tool concurrent with remaining decode.
5. **KV-cache quantization stability study**: quantify Cline's anecdote — task success/divergence with q8_0/q4_0 KV across multi-turn sessions; zero rigorous data exists, clean result either way.

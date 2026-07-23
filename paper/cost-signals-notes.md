# paper 2 notes: cheap hardware grounding beats static cost models

Working thesis: for JIT kernel-variant selection, static cost models are
structurally unable to see codegen discontinuities; reading the emitted
asm is free and closes most of the gap; one measured probe closes nearly
all of it; a learned model on cheap features quantifies the exact
information ceiling between them. Evidence-first, all numbers rerunnable.

## evidence inventory (as of 2026-07-23; all counter-verified)

1. The discontinuity exists and is large (exp005, exp013 v2): LLVM
   full-unroll cliff = 4.2x throughput at trip 96->104 (accs=1 f64,
   30.98 vs 7.44 GFLOP/s), and the cliff POSITION moves with accumulator
   count (96/112/128 for accs 1/2/4) — a static threshold cannot encode
   it even if tuned.
2. Model ladder on a clean 66-variant corpus (exp013 v2): params-only
   0.517 Spearman / 10.4x max err / cliff FAIL; asm-features 0.938 /
   2.3x / PASS; one-probe 0.988 / 1.33x / PASS. Within-group (the
   extraction decision): 0.000 / 0.760 / 0.977 grp-rho respectively.
3. Selection regret (exp015): static-op picks cost 2.73x geo (16.6x
   worst); learned-on-cheap-features 1.011x geo / 1.194x max; one-probe
   1.000x / 1.006x. Cost ladder: 2.1us (ridge) / 5.5ms (asm extraction)
   / 25-100ms (probe) per variant.
4. Feature information ceiling (exp015): every learner and feature set
   lands on 0.795/82% within-group — the missed groups are statically
   indistinguishable (identical asm, 2-4% measured spread). This bounds
   ALL static approaches, learned or hand-built, on this corpus.
5. Methodology contribution: corpus generators must counter-verify
   executed-vs-nominal flops per sample — two silent elision mechanisms
   (shared-base recurrence CSE at exactly 0.5 ratio; constant-fold
   absorption, deficit exactly accs-1) invalidated corpus v1 while
   producing plausible-looking timings. fp_arith_inst_retired
   verification is 6 counters + one rep.

## gaps before draftable

- Single kernel family (poly chains). Need >=3 families (stencil,
  reduction, gather) through the same pipeline — also the S4a gate.
- llvm-mca / TTI head-to-head on the same corpus (S1 next step): does
  LLVM's own model rank better than params-only? Expected key exhibit.
- Prior-art table: Ithemal/uiCA/llvm-mca accuracy studies are
  basic-block-level; position this as variant-selection-level.

## framing note

Not "ML for compilers" — the punchline is the opposite: the cheapest
HARDWARE signal (one probe) beats every static model including learned
ones, and the learned model's value is knowing when to spend the probe.

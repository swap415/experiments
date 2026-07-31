# exp014 phase 3c: cache=True, measured against its ceiling (2026-07-31)

Fresh-subprocess A/B/C per kernel (nocache / cache miss / cache hit),
n=5 each, NUMBA_CACHE_DIR purged before every miss. Kernels live in a
real module (cachekernels.py) because exec-built functions cannot cache.
Raw: cache_eval.csv.

## totals (import + time-to-first-result, ms)

| kernel | nocache | miss | hit | hit saves |
|---|---:|---:|---:|---:|
| saxpy        | 196.9 | 197.4 | 160.6 | 18.4% |
| reduction    | 216.2 | 218.0 | 161.0 | 25.5% |
| stencil      | 201.3 | 204.7 | 161.0 | 20.0% |
| prange_saxpy | 276.3 | 280.0 | 163.6 | 40.8% |

## claims (recomputed from cache_eval.csv)

1. The phase-1 ceiling prediction is CONFIRMED: saxpy hit saves 18.4%
   (predicted 18% — pipeline share of cold start). Measurement closes
   the loop on the decomposition arithmetic.
2. The hit floor is uniform and diagnostic: every kernel converges to
   import ~95ms + first-result ~66ms. The 66ms = one-time context init
   (64ms, phase 2) + ~2ms actual cache load. Deserialization is nearly
   free; a warm cache leaves EXACTLY the fixed import+init tax standing.
3. Parfors caches correctly and benefits most: 40.8% saved (276 -> 164ms)
   — the heavy parfor pipeline including the extra modules (phase 3b)
   serializes. cache=True is the right default advice for parallel
   kernels; it is still 250x above the fork floor (0.66ms).
4. Cache-miss overhead (serialize + write) is 0.5-4.1ms — enabling
   cache=True is near-free insurance even for cold-only workloads.

S3 ledger after this session, all measured: cold 197-276ms; cache hit
161-164ms (floor = import+init); warm-fork new-kernel 34.5ms; warm-fork
cached-kernel 0.66ms. The strategy ladder is complete and every rung is
a number.

Repro: `.venv/bin/python exp014-compiletime/cache_eval.py`

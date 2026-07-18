# exp009 design: weighted static scheduling inside the numba runtime

Target: the sub-ms regime (exp003/exp006: no mechanism wins below ~0.15ms
— fine chunks pay per-division dispatch, coarse chunks pay the E-core
tail; exp004: the policy works but Python dispatch can't deliver it).

## approach

Patch ONLY gufunc_scheduler.cpp (compiled into workqueue.so):

1. New exported setter `numba_set_thread_weights(double *w, int n)`
   storing a static weight vector (P-thread ~3, E-thread ~1, calibrated).
2. `create_schedule` 1D path: replace equal split with cumulative weighted
   split — division i gets round(N * w_i / sum(w)) iterations.
3. workqueue.c is untouched: it already pre-assigns division i to queue i
   (verified exp008), so weighted division sizes land on known threads.
4. Thread<->CPU identity from outside: pin the pool's TIDs
   (/proc/self/task) via sched_setaffinity after warmup, then set weights
   to match the pinned CPU class.

Why workqueue, not TBB: stealing makes division->thread mapping dynamic,
so weighted sizes are meaningless there; workqueue's determinism is the
feature. TBB remains the comparison baseline (its best chunk setting).

## measurement plan

Sizes 256K, 1M, 4M, 64M x {workqueue-static (stock .so),
workqueue-weighted (patched .so), tbb-chunk-best, tbb-static}, poly
chain=64, 28 threads pinned 1:1. Same-binary A/B by swapping the .so
(sha256-verified restore). Success criterion: weighted-workqueue >= TBB
best at 64M AND wins at 256K where dispatch overhead dominates
(prediction: nthreads divisions = one cond-var wakeup per thread, no
tail, no GIL — should approach the P+E sum floor for a 0.14ms region).

Risks: (a) workqueue wakeup latency may exceed TBB's spinning at sub-ms —
measure empty-region cost per layer first; (b) ABI drift between checkout
and 0.66 wheel — build agent verifies with a no-op rebuild.

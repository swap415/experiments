# exp020 (S3 phase 3): opt-level pruning is dead on arrival (2026-07-30)

NUMBA_OPT={3,2,1,0} in fresh subprocesses, 7 kernels across 3 families,
compile wall + 5 timing reps + fp verification each. Raw: results.csv,
scored by analyze.py. This was the benefit-per-millisecond question the
phase plan reserved for after S1 validation; answer below.

## claims (recomputed from results.csv)

1. O3 -> O2 saves 1.3ms mean compile time (of 50-111ms) and risks up to
   5.6x runtime: reduction d=64 drops 56.6 -> 10.1 GF/s, map chain=96
   drops 30.2 -> 7.9 (the full-unroll+vectorize interaction needs O3).
   Generic opt-level pruning: DEAD — the compile savings are noise, the
   runtime downside is catastrophic.
2. O0 is a trap on BOTH axes: runtime 0.010-0.092x of O3 (up to 100x
   slower) AND compile time 1.9-17.5x LONGER (stencil d=128: 882ms vs
   50ms) — unoptimized IR is enormous and codegen pays for it. Third
   instance of the week's pattern: skipping optimizer work RAISES total
   compile cost (exp017 cliff rows, O2 on map/96 at +5.6ms AND 4x slower,
   O0 everywhere).
3. Wrinkle worth keeping: O2 BEATS O3 on stencil d=64 by 15% runtime at
   -2.8ms compile — opt level is itself a per-kernel selection knob, same
   shape as exp017's threshold (the win is narrow but real; candidate to
   fold into the retry_compile() utility as a measured option).
4. Together with exp014 phase 2: the entire pass/opt axis is bounded by
   ~1-9ms of realistic savings against a 158ms import/init tax. S3's
   attack order is settled by measurement: warm-process (0.66ms floor)
   >> structural import surgery (~56ms budget) >> anything in the
   optimizer. Phase 3 closes NEGATIVE for pruning; remaining S3 threads
   are the parfors tracking gap and the import-graph work.

Repro: `.venv/bin/python exp020-optlevel/bench.py` then `analyze.py`.

"""exp014 phase 3b: where are prange's untracked llvm_lock milliseconds?

Phase 2 found prange records only ~half its llvm_lock in pass timings.
Here every individual lock hold is timed via numba's event system and
attributed to its call site (nearest numba frame below the lock
machinery). Comparing hold-site totals against the NamedTimings records
identifies which compilation paths run under the lock without pass
tracking. saxpy compiled as control. n=REPS fresh subprocesses.

Run: .venv/bin/python exp014-compiletime/parfors_gap.py
"""

import json
import statistics as st
import subprocess
import sys
import time
import traceback
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPS = 5


def child(name):
    import numba.core.event as ev
    import numpy as np
    from numba import njit, prange  # noqa: F401

    holds = []

    class LockTimer(ev.Listener):
        def on_start(self, event):
            stack = traceback.extract_stack()
            idx = next((i for i, fr in enumerate(stack)
                        if fr.name == "enter_fn"), len(stack))
            callers = []
            for fr in reversed(stack[:idx]):
                stem = Path(fr.filename).stem
                if "contextlib" in fr.filename or stem == "ffi":
                    continue
                callers.append(f"{stem}:{fr.name}")
                if len(callers) == 2:
                    break
            self._t0 = time.perf_counter()
            self._site = "<-".join(callers) or "?"

        def on_end(self, event):
            holds.append((self._site,
                          (time.perf_counter() - self._t0) * 1e3))

    ev.register("numba:llvm_lock", LockTimer())

    if name == "prange":
        def f(a, b):
            for i in prange(a.size):
                a[i] = 2.0 * b[i] + a[i]
        jf = njit(parallel=True, fastmath=True)(f)
    else:
        def f(a, b):
            for i in range(a.size):
                a[i] = 2.0 * b[i] + a[i]
        jf = njit(fastmath=True)(f)
    a, b = np.zeros(64), np.ones(64)
    import numba
    jf.compile((numba.typeof(a), numba.typeof(b)))
    md = jf.get_metadata(jf.signatures[0])
    recorded = sum(rec.timings.get_total_time()
                   for rec in md["llvm_pass_timings"].list_longest_first()) \
        * 1e3 if md.get("llvm_pass_timings") else 0.0
    print(json.dumps({"holds": holds, "recorded_ms": recorded,
                      "llvm_lock_ms": md["timers"]["llvm_lock"] * 1e3}))


def main():
    import csv
    import os
    env = dict(os.environ, NUMBA_LLVM_PASS_TIMINGS="1")
    csv_rows = []
    for name in ("saxpy", "prange"):
        agg = defaultdict(list)
        totals, recs, locks, nholds = [], [], [], []
        for _ in range(REPS):
            r = subprocess.run(["taskset", "-c", "2", sys.executable,
                                __file__, "--child", name],
                               capture_output=True, text=True,
                               cwd=HERE.parent, env=env)
            assert r.returncode == 0, r.stderr[-800:]
            d = json.loads(r.stdout)
            per_site = defaultdict(float)
            for site, ms in d["holds"]:
                per_site[site] += ms
            for site, ms in per_site.items():
                agg[site].append(ms)
            totals.append(sum(ms for _, ms in d["holds"]))
            recs.append(d["recorded_ms"])
            locks.append(d["llvm_lock_ms"])
            nholds.append(len(d["holds"]))
        print(f"\n{name}: lock timer {st.mean(locks):.1f}ms, "
              f"sum of {st.mean(nholds):.0f} holds {st.mean(totals):.1f}ms, "
              f"pass-timings recorded {st.mean(recs):.1f}ms")
        for site, v in sorted(agg.items(), key=lambda x: -st.mean(x[1])):
            m = st.mean(v)
            csv_rows.append({"kernel": name, "site": site,
                             "ms": round(m, 2),
                             "std": round(st.stdev(v), 2) if len(v) > 1
                             else 0.0})
            if m > 0.5:
                print(f"  {site:<55} {m:7.1f}ms")
        csv_rows.append({"kernel": name, "site": "TOTAL_holds",
                         "ms": round(st.mean(totals), 2),
                         "std": round(st.stdev(totals), 2)})
        csv_rows.append({"kernel": name, "site": "RECORDED_pass_timings",
                         "ms": round(st.mean(recs), 2),
                         "std": round(st.stdev(recs), 2)})
    with open(HERE / "parfors_gap.csv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(csv_rows[0]))
        w.writeheader()
        w.writerows(csv_rows)
    print(f"\nwrote {HERE / 'parfors_gap.csv'}")


if __name__ == "__main__":
    if "--child" in sys.argv:
        child(sys.argv[sys.argv.index("--child") + 1])
    else:
        main()

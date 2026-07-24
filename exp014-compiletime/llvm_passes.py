"""exp014 phase 2c: per-LLVM-pass timing inside llvm_lock.

NUMBA_LLVM_PASS_TIMINGS=1 in fresh subprocesses; parses the recorded
pass timings from dispatcher metadata for three kernels spanning the
llvm_lock range (saxpy 28ms, arrayexpr 84ms, prange 82ms). Writes
llvm_passes.csv (kernel, phase, pass, ms — n=REPS means).

Run: .venv/bin/python exp014-compiletime/llvm_passes.py
"""

import csv
import json
import os
import statistics as st
import subprocess
import sys
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPS = 5
KERNELS = ("saxpy", "arrayexpr", "prange_saxpy")

CHILD = r"""
import json, sys
sys.path.insert(0, {here!r})
from bench import KERNELS
import numba, math
import numpy as np
from numba import njit, prange

name = {name!r}
src, argsrc, jitkw = KERNELS[name]
ns = {{"math": math, "np": np, "prange": prange}}
exec(src, ns)
jf = njit(**jitkw)(ns["f"])
args = eval("({{}})".format(argsrc), ns)
jf.compile(tuple(numba.typeof(a) for a in args))
md = jf.get_metadata(jf.signatures[0])
out = []
for rec in md["llvm_pass_timings"].list_longest_first():
    for p in rec.timings.list_records():
        if p.pass_name != "Total":  # per-report aggregate row, not a pass
            out.append([rec.name, p.pass_name, p.wall_time])
print(json.dumps(out))
"""


def main():
    env = dict(os.environ, NUMBA_LLVM_PASS_TIMINGS="1")
    acc = defaultdict(list)  # (kernel, phase, pass) -> [s]
    for name in KERNELS:
        for _ in range(REPS):
            r = subprocess.run(
                ["taskset", "-c", "2", sys.executable, "-c",
                 CHILD.format(here=str(HERE), name=name)],
                capture_output=True, text=True, cwd=HERE.parent, env=env)
            assert r.returncode == 0, r.stderr[-800:]
            per = defaultdict(float)
            for phase, pname, wall in json.loads(r.stdout):
                per[(name, phase, pname)] += wall
            for k, v in per.items():
                acc[k].append(v)

    rows = [{"kernel": k, "phase": ph, "pass": pn,
             "ms": round(st.mean(v) * 1e3, 3)}
            for (k, ph, pn), v in acc.items()]
    rows.sort(key=lambda r: (r["kernel"], -r["ms"]))
    with open(HERE / "llvm_passes.csv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)

    for name in KERNELS:
        sub = [r for r in rows if r["kernel"] == name]
        phases = defaultdict(float)
        for r in sub:
            phases[r["phase"]] += r["ms"]
        total = sum(phases.values())
        print(f"\n{name}: {total:.1f}ms recorded LLVM time; phases:")
        for ph, v in sorted(phases.items(), key=lambda x: -x[1]):
            print(f"  {ph:<40} {v:7.1f}ms {v / total:5.1%}")
        print("  top passes:")
        for r in sub[:6]:
            print(f"    {r['pass']:<45} {r['ms']:7.2f}ms")


if __name__ == "__main__":
    main()

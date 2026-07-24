"""exp014 phase 2a: where do the 94ms of `import numba` go, and what is
causally deferrable?

Part 1: parse -X importtime (SELF time per module, n=REPS fresh
processes), aggregate by subsystem. Written to import_profile.csv.

Part 2: causal deferral probe — stub a candidate module in sys.modules
BEFORE importing numba, measure the import-time saving, then compile and
run a saxpy njit kernel to prove the stub didn't break the njit path.
Cumulative importtime numbers over-attribute shared deps; only the stub
experiment gives a real saving. Written to deferral.csv.

Run: .venv/bin/python exp014-compiletime/import_profile.py
"""

import csv
import statistics as st
import subprocess
import sys
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPS = 5

GROUPS = ("llvmlite", "numpy", "numba.core", "numba.np", "numba.stencils",
          "numba.cpython", "numba.parfors", "numba.misc", "numba.experimental")

# candidate: sys.modules stub inserted pre-import; attrs the importer needs
CANDIDATES = {
    "numba.stencils.stencil": ["stencil", "StencilFunc"],
    "numba.np.types.datetime": [],
    "numba.experimental.jitclass": [],
    "numba.misc.special": ["typeof", "prange", "pndindex", "literally",
                           "literal_unroll"],
}

CHILD_TMPL = r"""
import sys, time, types
stub_name = {stub!r}
if stub_name:
    m = types.ModuleType(stub_name)
    for a in {attrs!r}:
        setattr(m, a, object())
    sys.modules[stub_name] = m
t0 = time.perf_counter()
import numba
t_imp = time.perf_counter() - t0
import numpy as np
from numba import njit
@njit
def f(a, b):
    for i in range(a.size):
        a[i] = 2.0 * b[i] + a[i]
a, b = np.zeros(64), np.ones(64)
try:
    f(a, b)
    ok = abs(a[0] - 2.0) < 1e-12
except Exception:
    ok = False
print(f"{{t_imp*1e3:.2f}} {{int(ok)}}")
"""


def importtime_profile():
    self_us = defaultdict(list)
    for _ in range(REPS):
        r = subprocess.run([sys.executable, "-X", "importtime", "-c",
                            "import numba"], capture_output=True, text=True,
                           cwd=HERE.parent)
        for line in r.stderr.splitlines():
            if not line.startswith("import time:"):
                continue
            parts = line.split("|")
            if len(parts) != 3 or "self" in parts[0]:
                continue
            self_us[parts[2].strip()].append(int(parts[0].split(":")[1]))
    rows = [{"module": m, "self_ms": round(st.mean(v) / 1e3, 3),
             "self_std": round(st.stdev(v) / 1e3, 3) if len(v) > 1 else 0.0}
            for m, v in self_us.items()]
    rows.sort(key=lambda r: -r["self_ms"])
    with open(HERE / "import_profile.csv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)

    total = sum(r["self_ms"] for r in rows)
    by_group = defaultdict(float)
    for r in rows:
        g = next((g for g in GROUPS if r["module"].startswith(g)), "other")
        by_group[g] += r["self_ms"]
    print(f"import numba: {total:.1f}ms total self time ({len(rows)} modules)")
    for g, v in sorted(by_group.items(), key=lambda x: -x[1]):
        print(f"  {g:<20} {v:7.1f}ms {v / total:6.1%}")
    print("top modules by self time:")
    for r in rows[:10]:
        print(f"  {r['module']:<45} {r['self_ms']:6.2f}ms")
    return total


def deferral_probe():
    def run(stub, attrs):
        vals, oks = [], []
        for _ in range(REPS):
            r = subprocess.run([sys.executable, "-c",
                                CHILD_TMPL.format(stub=stub, attrs=attrs)],
                               capture_output=True, text=True, cwd=HERE.parent)
            out = r.stdout.split()
            if len(out) != 2:  # stub broke `import numba` itself
                return float("nan"), 0.0, False
            vals.append(float(out[0]))
            oks.append(out[1] == "1")
        return st.mean(vals), st.stdev(vals), all(oks)

    base, base_sd, ok = run(None, [])
    assert ok
    print(f"\nbaseline import {base:.1f}±{base_sd:.1f}ms (njit works)")
    rows = [{"stub": "none", "import_ms": round(base, 2),
             "std": round(base_sd, 2), "saving_ms": 0.0, "njit_ok": 1}]
    for stub, attrs in CANDIDATES.items():
        m, sd, ok = run(stub, attrs)
        rows.append({"stub": stub, "import_ms": round(m, 2),
                     "std": round(sd, 2), "saving_ms": round(base - m, 2),
                     "njit_ok": int(ok)})
        print(f"stub {stub:<28} import {m:6.1f}±{sd:3.1f}ms  "
              f"saving {base - m:6.1f}ms  njit {'OK' if ok else 'BROKEN'}")
    # floor: numba's mandatory deps alone (best case for any lazification)
    for name, code in (("numpy", "import numpy"),
                       ("numpy+llvmlite", "import numpy, llvmlite.binding")):
        vals = []
        for _ in range(REPS):
            r = subprocess.run(
                [sys.executable, "-c",
                 f"import time; t0=time.perf_counter(); {code}; "
                 f"print((time.perf_counter()-t0)*1e3)"],
                capture_output=True, text=True, cwd=HERE.parent)
            vals.append(float(r.stdout))
        print(f"floor {name:<16} {st.mean(vals):6.1f}±{st.stdev(vals):3.1f}ms")
        rows.append({"stub": f"floor:{name}", "import_ms": round(st.mean(vals), 2),
                     "std": round(st.stdev(vals), 2), "saving_ms": "",
                     "njit_ok": ""})
    with open(HERE / "deferral.csv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)


if __name__ == "__main__":
    importtime_profile()
    deferral_probe()

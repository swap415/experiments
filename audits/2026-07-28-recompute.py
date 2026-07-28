"""Audit 2026-07-28: recompute the week's prose claims from raw CSVs.

Covers exp016 (mca), exp014 phase 2 CSV-backed claims, exp017 (unroll).
Prints ok/MISMATCH per claim.

Run: .venv/bin/python audits/2026-07-28-recompute.py
"""

import csv
import math
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def check(name, claim, got, tol=0.0):
    ok = abs(claim - got) <= tol
    print(f"{'ok ' if ok else 'MISMATCH'} {name}: claimed {claim} got {got:g}")


def load(p):
    with open(ROOT / p, newline="") as fh:
        return list(csv.DictReader(fh))


def geo(v):
    return math.exp(sum(math.log(x) for x in v) / len(v))


def exp016():
    print("== exp016 ==")
    rows = load("exp016-mca/mca.csv")
    check("n", 66, len(rows))
    errs = [max(float(r["pred_fpc_dep"]) / float(r["meas_fpc"]),
                float(r["meas_fpc"]) / float(r["pred_fpc_dep"])) for r in rows]
    check("dep abs-geo", 1.68, geo(errs), 0.005)
    check("dep abs-max", 3.38, max(errs), 0.005)
    vec = [r for r in rows if int(r["block_flops"]) > 50]
    mid = [r for r in vec if int(r["chain"]) >= 16]
    over = [float(r["pred_fpc_dep"]) / float(r["meas_fpc"]) for r in mid]
    check("mid-vec rows", 46, len(mid))
    check("mid-vec all overpredict", 1, int(all(x > 1 for x in over)))
    check("mid-vec mean over", 1.43, sum(over) / len(over), 0.005)
    sc = [r for r in rows if int(r["block_flops"]) <= 50]
    under = [r for r in sc
             if float(r["pred_fpc_dep"]) < float(r["meas_fpc"])]
    check("scalar rows", 14, len(sc))
    check("scalar underpredicted", 12, len(under))


def exp014p2():
    print("== exp014 phase 2 ==")
    rows = load("exp014-compiletime/import_profile.csv")
    check("modules", 468, len(rows))
    check("max self ms", 2.8, max(float(r["self_ms"]) for r in rows), 0.15)
    dfr = load("exp014-compiletime/deferral.csv")
    floor = next(r for r in dfr if r["stub"] == "floor:numpy+llvmlite")
    check("floor numpy+llvmlite", 44.4, float(floor["import_ms"]), 0.15)
    broken = [r for r in dfr if r["njit_ok"] == "0"]
    check("broken stubs", 4, len(broken))


def exp017():
    print("== exp017 ==")
    rows = load("exp017-unroll/corpus.csv")
    by = defaultdict(dict)
    for r in rows:
        by[(int(r["chain"]), int(r["accs"]), r["dtype"])][r["config"]] = r
    check("variants", 66, len(by))
    sp, ct, oracle, asmsel, regr = [], [], [], [], 0
    for d in by.values():
        a, b = d["default"], d["thresh2k"]
        s = float(b["gflops"]) / float(a["gflops"])
        sp.append(s)
        ct.append(float(b["compile_ms"]) - float(a["compile_ms"]))
        oracle.append(max(s, 1.0))
        vecfix = int(b["packed_fma"]) > 0 and int(a["packed_fma"]) == 0
        asmsel.append(s if vecfix else 1.0)
        regr += s < 0.97
    check("geo speedup", 1.418, geo(sp), 0.005)
    check("regressions >3%", 12, regr)
    check("mean compile delta ms", -19.7, sum(ct) / len(ct), 0.15)
    check("oracle geo", 1.452, geo(oracle), 0.005)
    check("asm-rule geo", 1.427, geo(asmsel), 0.005)
    check("asm-rule worst", 1.0, min(asmsel), 1e-9)
    check("asm-rule switches", 14, sum(1 for x in asmsel if x != 1.0))
    # physics: nothing above peak under thresh2k
    f32 = max(float(r["gflops"]) for r in rows if r["dtype"] == "float32")
    f64 = max(float(r["gflops"]) for r in rows if r["dtype"] == "float64")
    check("f32 <= 169.6", 1, int(f32 <= 169.6))
    check("f64 <= 84.8", 1, int(f64 <= 84.8))
    elis = sum(abs(float(r["flops_ratio"]) - 1) > 0.05 for r in rows)
    check("elision rows", 0, elis)


if __name__ == "__main__":
    exp016()
    exp014p2()
    exp017()

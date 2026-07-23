"""Audit 2026-07-23: recompute today's prose claims from raw CSVs.

Checks exp013 v2 and exp014 results.md numbers (exp015 is fully
reproduced by rerunning learn.py, done separately). Prints CLAIM/GOT
pairs; any MISMATCH line is a finding.

Run: .venv/bin/python audits/2026-07-23-recompute.py
"""

import csv
import statistics as st
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def rows13():
    with open(ROOT / "exp013-costmodel" / "results.csv", newline="") as fh:
        return list(csv.DictReader(fh))


def check(name, claim, got, tol=0.0):
    ok = abs(claim - got) <= tol
    print(f"{'ok ' if ok else 'MISMATCH'} {name}: claimed {claim} got {got:g}")


def exp013():
    print("== exp013 v2 ==")
    rs = rows13()
    check("n variants", 66, len(rs))
    ratios = [float(r["flops_ratio"]) for r in rs]
    check("worst flops_ratio", 1.0093, max(ratios, key=lambda x: abs(x - 1)))
    check("rows >5% dev", 0, sum(abs(x - 1) > 0.05 for x in ratios))
    check("wrong-precision rows", 0,
          sum(float(r["wrong_prec_frac"]) > 0.01 for r in rs))
    check("multiplexed rows", 0, sum(r["multiplexed"] == "1" for r in rs))
    f32 = max(float(r["gflops"]) for r in rs if r["dtype"] == "float32")
    f64 = max(float(r["gflops"]) for r in rs if r["dtype"] == "float64")
    check("max f32 GFLOP/s", 138.9, f32, 0.05)
    check("f32 <= 169.6 peak", 1, int(f32 <= 169.6))
    check("max f64 GFLOP/s", 65.0, f64, 0.05)
    check("f64 <= 84.8 peak", 1, int(f64 <= 84.8))
    for accs, last_vec, first_scalar in ((1, 96, 104), (2, 112, 128),
                                         (4, 128, 160)):
        g = {int(r["chain"]): (float(r["gflops"]), int(r["packed_fma"]))
             for r in rs if int(r["accs"]) == accs and r["dtype"] == "float64"}
        lv = max(c for c in g if g[c][1] > 0)
        fs = min(c for c in g if g[c][1] == 0)
        check(f"accs={accs} last vectorized", last_vec, lv)
        check(f"accs={accs} first collapsed", first_scalar, fs)
    g1 = {int(r["chain"]): float(r["gflops"]) for r in rs
          if int(r["accs"]) == 1 and r["dtype"] == "float64"}
    check("cliff ratio 96/104 accs=1 f64", 4.2, g1[96] / g1[104], 0.05)


def exp014():
    print("== exp014 phase 1 ==")
    d = ROOT / "exp014-compiletime"
    with open(d / "results.csv", newline="") as fh:
        rs = list(csv.DictReader(fh))
    with open(d / "passes.csv", newline="") as fh:
        ps = list(csv.DictReader(fh))
    perk = defaultdict(list)
    for r in rs:
        perk[r["kernel"]].append(r)
    claimed = {  # kernel: (import, compile, llvm_lock) means from results.md
        "saxpy": (94.2, 98.7, 28.1), "reduce": (93.7, 90.9, 22.9),
        "stencil2d": (94.2, 126.6, 45.3), "arrayexpr": (94.2, 192.9, 83.5),
        "poly16": (94.3, 100.3, 26.8), "matmul3": (94.0, 113.1, 33.4),
        "branchy": (94.1, 100.4, 25.7), "prange_saxpy": (122.5, 176.6, 82.0)}
    for k, (ci, cc, cl) in claimed.items():
        v = perk[k]
        for field, cval in (("import_s", ci), ("compile_s", cc),
                            ("llvm_lock_s", cl)):
            check(f"{k} {field} mean ms", cval,
                  st.mean(float(x[field]) for x in v) * 1e3, 0.05)
    psum = defaultdict(float)
    for p in ps:
        psum[(p["kernel"], p["rep"])] += float(p["run_s"])
    resid = [float(r["compiler_lock_s"]) - psum[(r["kernel"], r["rep"])]
             for r in rs]
    check("init residue min ms", 63.3,
          min(st.mean([x * 1e3 for x in resid[i::5]] and
                      [(float(r["compiler_lock_s"]) - psum[(r["kernel"], r["rep"])]) * 1e3
                       for r in perk[k]]) for i, k in enumerate(perk)), 0.15)
    check("init residue max ms", 64.2,
          max(st.mean([(float(r["compiler_lock_s"]) - psum[(r["kernel"], r["rep"])]) * 1e3
                       for r in perk[k]]) for k in perk), 0.15)
    gap = max(abs(float(r["compile_s"]) - float(r["compiler_lock_s"]))
              for r in rs)
    check("compile-lock gap <= 0.1ms", 1, int(gap * 1e3 <= 0.15))
    bp = defaultdict(list)
    for p in ps:
        bp[(p["kernel"], p["pass"])].append(float(p["run_s"]) * 1e3)
    tot = defaultdict(float)
    for (k, pn), v in bp.items():
        tot[pn] += st.mean(v)
    total = sum(tot.values())
    check("pipeline total ms", 490, total, 2)
    check("native_lowering ms", 331.1, tot["24_native_lowering"], 0.5)
    check("native_lowering share", 0.676, tot["24_native_lowering"] / total, 0.002)
    check("parfor_lowering ms", 105.6, tot["28_native_parfor_lowering"], 0.5)
    check("type_inference share", 0.036,
          tot["17_nopython_type_inference"] / total, 0.002)
    # anatomy: saxpy fixed share
    sx = perk["saxpy"]
    imp = st.mean(float(r["import_s"]) for r in sx) * 1e3
    comp = st.mean(float(r["compile_s"]) for r in sx) * 1e3
    pipe = st.mean(psum[("saxpy", r["rep"])] for r in sx) * 1e3
    check("saxpy fixed share of cold start", 0.82,
          (imp + (comp - pipe)) / (imp + comp), 0.005)
    check("caching ceiling (pipeline share)", 0.18,
          pipe / (imp + comp), 0.005)
    # parallel deltas
    check("+import ms parallel", 28.3,
          st.mean(float(r["import_s"]) for r in perk["prange_saxpy"]) * 1e3 - imp, 0.3)
    check("+compile ms parallel", 77.9,
          st.mean(float(r["compile_s"]) for r in perk["prange_saxpy"]) * 1e3 - comp, 0.3)


if __name__ == "__main__":
    exp013()
    exp014()

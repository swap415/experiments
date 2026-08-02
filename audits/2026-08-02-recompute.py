"""Audit 2026-08-02: recompute the week's prose claims from raw CSVs.

Covers exp018 v3.1, exp020, exp021, exp014 phase 3b (parfors_gap) and
3c (cache_eval). exp019 is handled separately in the audit notes (its
evidence CSV was overwritten by the v3.1 rerun — versioning finding).

Run: .venv/bin/python audits/2026-08-02-recompute.py
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


def exp018_v31():
    print("== exp018 v3.1 ==")
    rows = load("exp018-corpusv3/results.csv")
    check("rows", 42, len(rows))
    check("elision rows", 0, sum(abs(float(r["flops_ratio"]) - 1) > 0.05
                                 for r in rows))
    by = defaultdict(dict)
    for r in rows:
        by[(r["family"], r["d"])][r["config"]] = r
    knob, rule, oracle = [], [], []
    for cfg in by.values():
        a, b = cfg["default"], cfg["thresh2k"]
        s = float(b["gflops"]) / float(a["gflops"])
        fire = int(a["packed_fma"]) == 0 and int(b["packed_fma"]) > 0
        knob.append(s)
        rule.append(s if fire else 1.0)
        oracle.append(max(s, 1.0))
    check("knob geo", 1.430, geo(knob), 0.005)
    check("knob regressions", 8, sum(s < 0.97 for s in knob))
    check("rule geo", 1.782, geo(rule), 0.005)
    check("rule worst", 1.0, min(rule), 1e-9)
    check("oracle geo", 1.807, geo(oracle), 0.005)
    check("rule/oracle", 0.986, geo(rule) / geo(oracle), 0.002)
    g64 = by[("gather", "64")]
    check("gather d64 default vectorized", 1,
          int(int(g64["default"]["packed_fma"]) > 0))
    check("gather d64 knob loss", 0.54,
          float(g64["thresh2k"]["gflops"]) / float(g64["default"]["gflops"]),
          0.01)
    f64 = max(float(r["gflops"]) for r in rows)
    check("all <= f64 peak 84.8", 1, int(f64 <= 84.8))


def exp020():
    print("== exp020 ==")
    rows = load("exp020-optlevel/results.csv")
    by = defaultdict(dict)
    for r in rows:
        by[(r["family"], r["d"])][r["opt"]] = r
    saves = [float(c["3"]["compile_ms"]) - float(c["2"]["compile_ms"])
             for c in by.values()]
    check("O3->O2 mean saving ms", 1.3, sum(saves) / len(saves), 0.05)
    worst = min(float(c["2"]["gflops"]) / float(c["3"]["gflops"])
                for c in by.values())
    check("O2 worst runtime cost x", 5.6, 1 / worst, 0.05)
    blow = [float(c["0"]["compile_ms"]) / float(c["3"]["compile_ms"])
            for c in by.values()]
    check("O0 blowup min", 1.9, min(blow), 0.05)
    check("O0 blowup max", 17.5, max(blow), 0.1)
    st64 = by[("stencil", "64")]
    check("O2/O3 stencil d64", 1.15,
          float(st64["2"]["gflops"]) / float(st64["3"]["gflops"]), 0.005)


def exp021():
    print("== exp021 ==")
    rows = load("exp021-retrycompile/results.csv")
    fired = [r for r in rows if r["fired"] == "1"]
    quiet = [r for r in rows if r["fired"] == "0"]
    check("fired count", 7, len(fired))
    sp = [float(r["speedup"]) for r in fired]
    check("fired min speedup", 3.85, min(sp), 0.01)
    check("fired max speedup", 8.49, max(sp), 0.01)
    qs = [float(r["speedup"]) for r in quiet]
    check("quiet min", 1.00, min(qs), 0.005)
    check("quiet max", 1.02, max(qs), 0.015)


def parfors_gap():
    print("== exp014 phase 3b ==")
    rows = {(r["kernel"], r["site"]): float(r["ms"])
            for r in load("exp014-compiletime/parfors_gap.csv")}
    check("saxpy total", 42.1, rows[("saxpy", "TOTAL_holds")], 0.15)
    check("prange total", 113.0, rows[("prange", "TOTAL_holds")], 0.15)
    check("saxpy recorded", 28.0,
          rows[("saxpy", "RECORDED_pass_timings")], 0.15)
    check("prange recorded", 38.0,
          rows[("prange", "RECORDED_pass_timings")], 0.15)
    fin = "executionengine:finalize_object<-codegen:wrapper"
    opt = "newpassmanagers:run<-codegen:_optimize_final_module"
    check("finalize delta", 22.5,
          rows[("prange", fin)] - rows[("saxpy", fin)], 0.15)
    check("final-opt delta", 26.7,
          rows[("prange", opt)] - rows[("saxpy", opt)], 0.15)
    check("final-opt ratio", 4.0,
          rows[("prange", opt)] / rows[("saxpy", opt)], 0.05)


def cache_eval():
    print("== exp014 phase 3c ==")
    rows = {(r["kernel"], r["cond"]): r
            for r in load("exp014-compiletime/cache_eval.csv")}
    for k, save in (("saxpy", 0.184), ("reduction", 0.255),
                    ("stencil", 0.200), ("prange_saxpy", 0.408)):
        nc = float(rows[(k, "nocache")]["total_ms"])
        hit = float(rows[(k, "hit")]["total_ms"])
        check(f"{k} hit saving", save, 1 - hit / nc, 0.003)
        miss = float(rows[(k, "miss")]["total_ms"])
        assert -1 <= miss - nc <= 4.5, f"{k} miss overhead {miss - nc}"
    hits = [float(rows[(k, "hit")]["total_ms"])
            for k in ("saxpy", "reduction", "stencil", "prange_saxpy")]
    check("hit floor min", 160.6, min(hits), 0.15)
    check("hit floor max", 163.6, max(hits), 0.15)


if __name__ == "__main__":
    exp018_v31()
    exp020()
    exp021()
    parfors_gap()
    cache_eval()

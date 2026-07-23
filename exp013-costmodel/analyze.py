"""exp013 analysis: rank the variant corpus with four cost models.

Reads results.csv from bench.py (no re-measurement). Each model produces a
relative throughput prediction per variant; we score Spearman rank
correlation vs measured GFLOP/s, max and geo-mean ratio error (after a
least-squares scale fit in log space, since predictions are relative), and
the cliff test: does the model rank chain=96 above chain=112 for accs=1
float64 (measured 4.5x apart, exp005)?

Models:
  a. static-op        per-instruction cost model: vector_width * ports.
                      Assumes vectorization, ignores latency — what a naive
                      per-op e-graph cost model gives you.
  b. latency-analytic vw * accs / fma_latency from PARAMETERS only.
                      Latency-aware but assumes the compiler always
                      vectorizes — misses the unroll cliff by construction.
  c. asm-feature      same analytic form, but vector width (packed vs
                      scalar fma) and in-flight interleave (distinct simd
                      regs) read from the MEASURED asm. Zero timing needed.
  d. one-probe        flops/cycle from ONE perf-counter calibration rep
                      (flops * IPC / instructions). The ceiling for cheap
                      signals: one 25-100ms probe, no full timing sweep.

Run: uv run python exp013-costmodel/analyze.py [results.csv]
"""

import csv
import math
import sys
from pathlib import Path

FMA_LAT = 4    # Raptor Cove FP fma latency, cycles
FMA_PORTS = 2  # fma issue ports
VW = {"float64": 4, "float32": 8}  # ymm lanes


def load(path):
    rows = []
    with open(path, newline="") as fh:
        for r in csv.DictReader(fh):
            for k in ("chain", "accs", "n", "packed_fma", "scalar_fma",
                      "simd_regs", "asm_lines"):
                r[k] = int(r[k])
            for k in ("gflops", "ipc", "ginsn"):
                r[k] = float(r[k]) if r[k] else None
            rows.append(r)
    return rows


def model_static(r):
    return VW[r["dtype"]] * FMA_PORTS * 2


def model_analytic(r):
    return VW[r["dtype"]] * 2 * min(r["accs"] / FMA_LAT, FMA_PORTS)


def model_asm(r):
    vw = VW[r["dtype"]] if r["packed_fma"] > 0 else 1
    inflight = min(max(r["simd_regs"] - 2, 1), FMA_LAT * FMA_PORTS)
    return vw * 2 * min(inflight / FMA_LAT, FMA_PORTS)


def model_probe(r):
    if r["ginsn"] is None or r["ipc"] is None:
        return None
    cycles = r["ginsn"] * 1e9 / r["ipc"]
    return 2 * r["chain"] * r["n"] / cycles  # flops/cycle, measured once


MODELS = [("a. static-op", model_static), ("b. latency-analytic", model_analytic),
          ("c. asm-feature", model_asm), ("d. one-probe", model_probe)]


def spearman(x, y):
    def rank(v):
        order = sorted(range(len(v)), key=lambda i: v[i])
        r = [0.0] * len(v)
        i = 0
        while i < len(order):  # average ties
            j = i
            while j + 1 < len(order) and v[order[j + 1]] == v[order[i]]:
                j += 1
            for k in range(i, j + 1):
                r[order[k]] = (i + j) / 2
            i = j + 1
        return r
    rx, ry = rank(x), rank(y)
    mx, my = sum(rx) / len(rx), sum(ry) / len(ry)
    cov = sum((a - mx) * (b - my) for a, b in zip(rx, ry))
    sx = math.sqrt(sum((a - mx) ** 2 for a in rx))
    sy = math.sqrt(sum((b - my) ** 2 for b in ry))
    return cov / (sx * sy) if sx and sy else 0.0


def ratio_errors(pred, meas):
    logs = [math.log(p / m) for p, m in zip(pred, meas)]
    shift = sum(logs) / len(logs)  # least-squares relative scale
    errs = [math.exp(abs(l - shift)) for l in logs]
    gmean = math.exp(sum(math.log(e) for e in errs) / len(errs))
    return gmean, max(errs)


def cliff(rows, model):
    pick = {r["chain"]: model(r) for r in rows
            if r["accs"] == 1 and r["dtype"] == "float64"
            and r["chain"] in (96, 112)}
    if len(pick) < 2 or None in pick.values():
        return "-"
    return "PASS" if pick[96] > pick[112] else "FAIL"


def within_groups(rows, model):
    """Rank accs variants within each (chain, dtype) group — the extraction
    scenario: same computation, competing implementations. Returns mean
    Spearman across groups and top-1 hit rate (model picks measured best)."""
    groups = {}
    for r in rows:
        groups.setdefault((r["chain"], r["dtype"]), []).append(r)
    rhos, hits, n = [], 0, 0
    for g in groups.values():
        pred = [model(r) for r in g]
        meas = [r["gflops"] for r in g]
        if len(g) < 2 or None in pred:
            continue
        rhos.append(spearman(pred, meas))
        hits += pred.index(max(pred)) == meas.index(max(meas))
        n += 1
    if not n:
        return None, None, 0
    return sum(rhos) / n, hits / n, n


def main():
    path = Path(sys.argv[1]) if len(sys.argv) > 1 else \
        Path(__file__).resolve().parent / "results.csv"
    rows = load(path)
    meas = [r["gflops"] for r in rows]
    print(f"{len(rows)} variants from {path.name}")
    bad = [r for r in rows if r.get("flops_ratio")
           and abs(float(r["flops_ratio"]) - 1.0) > 0.05]
    if bad:
        print(f"WARNING: {len(bad)} rows with >5% executed-vs-nominal flops "
              f"deviation (corpus contaminated)")
    elif any(r.get("flops_ratio") for r in rows):
        print("corpus clean: all rows within 5% executed-vs-nominal flops")
    print(f"{'model':<20} {'spearman':>8} {'geo-err':>8} {'max-err':>8}  "
          f"{'grp-rho':>7} {'top1':>5}  cliff 96>112 (accs=1 f64)")
    for name, model in MODELS:
        pred = [model(r) for r in rows]
        if None in pred:
            print(f"{name:<20} {'-':>8} {'-':>8} {'-':>8}  -  (no perf data)")
            continue
        rho = spearman(pred, meas)
        gerr, merr = ratio_errors(pred, meas)
        grho, top1, ngrp = within_groups(rows, model)
        print(f"{name:<20} {rho:8.3f} {gerr:8.2f} {merr:8.2f}  "
              f"{grho:7.3f} {top1:5.0%}  {cliff(rows, model)}")


if __name__ == "__main__":
    main()

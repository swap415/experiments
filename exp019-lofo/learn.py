"""exp019 (S4a): leave-one-FAMILY-out — do learned cost models transfer
to kernel families they never saw?

Data: exp018 corpus v3, clean families only (map/reduction/stencil;
gather excluded — invalid flop labels). 34 samples = 17 kernels x 2
configs (default / thresh2k), each with asm features + one measured
probe. Train ridge on 2 families, predict the third. The deployment
decision scored: per (family, d) pick the better config; regret =
measured best / measured pick.

Selectors compared on each held-out family:
  learned-asm   ridge on family-agnostic asm features (LOFO)
  learned-asm+d ridge on asm features + depth (LOFO)
  hand-rule     exp017 asm rule (thresh2k iff default has 0 packed fma)
  probe         pick by measured probe_fpc (upper bound for cheap signals)

Run: .venv/bin/python exp019-lofo/learn.py
"""

import csv
import math
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / "exp013-costmodel"))
from analyze import spearman  # noqa: E402

RIDGE_LAMBDA = 1.0
CLEAN = ("map", "reduction", "stencil")


def depth(r):
    d = r["d"]
    return float(d.strip("[]").split(",")[0]) if "[" in d else float(d)


def load():
    rows = []
    with open(HERE.parent / "exp018-corpusv3" / "results.csv",
              newline="") as fh:
        for r in csv.DictReader(fh):
            if r["family"] not in CLEAN:
                continue
            rows.append({
                "family": r["family"], "d": r["d"], "config": r["config"],
                "depth": depth(r), "gflops": float(r["gflops"]),
                "probe_fpc": float(r["probe_fpc"]),
                "packed_fma": int(r["packed_fma"]),
                "scalar_fma": int(r["scalar_fma"]),
                "simd_regs": int(r["simd_regs"]),
                "asm_lines": int(r["asm_lines"])})
    return rows


FEATS = {
    "asm": lambda r: [r["packed_fma"], r["scalar_fma"], r["simd_regs"],
                      r["asm_lines"], 1.0 if r["packed_fma"] else 0.0],
}
FEATS["asm+d"] = lambda r: FEATS["asm"](r) + [r["depth"],
                                              math.log(r["depth"])]


def fit_predict(train, test, feat):
    Xt = np.array([feat(r) for r in train])
    mu, sd = Xt.mean(0), Xt.std(0) + 1e-12
    Xt = (Xt - mu) / sd
    yt = np.log(np.array([r["gflops"] for r in train]))
    Xb = np.hstack([Xt, np.ones((len(Xt), 1))])
    w = np.linalg.solve(Xb.T @ Xb + RIDGE_LAMBDA * np.eye(Xb.shape[1]),
                        Xb.T @ yt)
    Xs = (np.array([feat(r) for r in test]) - mu) / sd
    return np.hstack([Xs, np.ones((len(Xs), 1))]) @ w


def geo(v):
    return math.exp(sum(math.log(x) for x in v) / len(v))


def main():
    rows = load()
    fams = sorted({r["family"] for r in rows})
    print(f"{len(rows)} samples, families: {fams}")
    selectors = ["learned-asm", "learned-asm+d", "hand-rule", "probe"]
    regs = {s: [] for s in selectors}
    print(f"{'held-out':<10} {'rho asm':>8} {'rho asm+d':>9}  "
          f"per-selector regret (geo over d-groups)")
    for fam in fams:
        train = [r for r in rows if r["family"] != fam]
        test = [r for r in rows if r["family"] == fam]
        preds = {k: fit_predict(train, test, FEATS[k.split("-")[1]])
                 for k in ("learned-asm", "learned-asm+d")}
        rhos = {k: spearman(list(p), [r["gflops"] for r in test])
                for k, p in preds.items()}
        groups = {}
        for i, r in enumerate(test):
            groups.setdefault(r["d"], []).append(i)
        famreg = {s: [] for s in selectors}
        for idx in groups.values():
            g = [test[i] for i in idx]
            meas = [r["gflops"] for r in g]
            best = max(meas)
            dflt = next(j for j, r in enumerate(g)
                        if r["config"] == "default")
            th2k = next(j for j, r in enumerate(g)
                        if r["config"] == "thresh2k")
            picks = {
                "learned-asm": int(np.argmax(preds["learned-asm"][idx])),
                "learned-asm+d": int(np.argmax(preds["learned-asm+d"][idx])),
                "hand-rule": (th2k if g[dflt]["packed_fma"] == 0
                              and g[th2k]["packed_fma"] > 0 else dflt),
                "probe": max(range(len(g)),
                             key=lambda j: g[j]["probe_fpc"]),
            }
            for s, j in picks.items():
                famreg[s].append(best / meas[j])
        for s in selectors:
            regs[s].extend(famreg[s])
        line = "  ".join(f"{s} {geo(famreg[s]):.3f}" for s in selectors)
        print(f"{fam:<10} {rhos['learned-asm']:8.3f} "
              f"{rhos['learned-asm+d']:9.3f}  {line}")
    print("\naggregate regret over all held-out d-groups:")
    for s in selectors:
        print(f"  {s:<14} geo {geo(regs[s]):.3f}x  worst {max(regs[s]):.3f}x")


if __name__ == "__main__":
    main()

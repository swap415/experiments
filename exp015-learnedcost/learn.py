"""exp015: can a LEARNED cost model on cheap features beat hand-built
heuristics for kernel-variant ranking? (S4a scoping experiment)

Data: exp013 v2 corpus (66 clean variants). Decision to learn: rank
competing implementations of the same computation — the e-graph
extraction / autotuning choice. Policy: ridge regression on standardized
features -> log(gflops). Evaluation: leave-one-(chain,dtype)-group-out,
so every within-group ranking is predicted by a model that never saw
that group. Feature sets: params-only (what static extraction has),
asm-only, params+asm.

Baselines from exp013 analyze.py (hand-built): model c asm-heuristic
grp-rho 0.760 / top1 23%; model d one-probe 0.977 / 95% (costs a ~25ms+
measured rep per variant at JIT time).

Run: .venv/bin/python exp015-learnedcost/learn.py
"""

import csv
import math
import sys
import time
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / "exp013-costmodel"))
from analyze import spearman  # noqa: E402

RIDGE_LAMBDA = 1.0


def load():
    rows = []
    with open(HERE.parent / "exp013-costmodel" / "results.csv", newline="") as fh:
        for r in csv.DictReader(fh):
            rows.append({"chain": int(r["chain"]), "accs": int(r["accs"]),
                         "f32": 1.0 if r["dtype"] == "float32" else 0.0,
                         "dtype": r["dtype"],
                         "packed_fma": int(r["packed_fma"]),
                         "scalar_fma": int(r["scalar_fma"]),
                         "simd_regs": int(r["simd_regs"]),
                         "asm_lines": int(r["asm_lines"]),
                         "gflops": float(r["gflops"])})
    return rows


FEATURES = {
    "params": lambda r: [r["chain"], math.log(r["chain"]), r["accs"],
                         r["f32"], r["chain"] / r["accs"]],
    "asm": lambda r: [r["packed_fma"], r["scalar_fma"], r["simd_regs"],
                      r["asm_lines"], 1.0 if r["packed_fma"] else 0.0],
}
FEATURES["params+asm"] = lambda r: FEATURES["params"](r) + FEATURES["asm"](r)


def ridge_fit(X, y):
    Xb = np.hstack([X, np.ones((len(X), 1))])
    A = Xb.T @ Xb + RIDGE_LAMBDA * np.eye(Xb.shape[1])
    return np.linalg.solve(A, Xb.T @ y)


def ridge_predict(w, X):
    return np.hstack([X, np.ones((len(X), 1))]) @ w


def logo_eval(rows, feat):
    X = np.array([feat(r) for r in rows])
    mu, sd = X.mean(0), X.std(0) + 1e-12
    X = (X - mu) / sd
    y = np.log(np.array([r["gflops"] for r in rows]))
    groups = {}
    for i, r in enumerate(rows):
        groups.setdefault((r["chain"], r["dtype"]), []).append(i)
    rhos, hits, pooled_pred = [], 0, np.zeros(len(rows))
    for idx in groups.values():
        mask = np.ones(len(rows), bool)
        mask[idx] = False
        w = ridge_fit(X[mask], y[mask])
        p = ridge_predict(w, X[idx])
        pooled_pred[idx] = p
        meas = [rows[i]["gflops"] for i in idx]
        rhos.append(spearman(list(p), meas))
        hits += int(np.argmax(p) == int(np.argmax(meas)))
    grho = sum(rhos) / len(rhos)
    top1 = hits / len(groups)
    glob = spearman(list(pooled_pred), [r["gflops"] for r in rows])
    return glob, grho, top1


def predict_cost(rows):
    """Measured inference cost of the learned model (features + predict)."""
    feat = FEATURES["params+asm"]
    X = np.array([feat(r) for r in rows])
    w = ridge_fit(X, np.log(np.array([r["gflops"] for r in rows])))
    t0 = time.perf_counter()
    n = 1000
    for _ in range(n):
        ridge_predict(w, X[:1])
    return (time.perf_counter() - t0) / n * 1e6


def asm_feature_cost():
    """Measured cost of extracting asm features from a compiled kernel."""
    from bench import make_kernel, asm_features
    f = make_kernel(32, 2, np.float64)
    f(np.zeros(1024), np.ones(1024))
    t0 = time.perf_counter()
    n = 50
    for _ in range(n):
        asm_features(f)
    return (time.perf_counter() - t0) / n * 1e3


def regret_eval(rows):
    """Selection regret (measured best / measured pick) per group, for the
    hand models of exp013 and the LOGO out-of-sample learned model."""
    from analyze import MODELS, load as load13
    r13 = load13(HERE.parent / "exp013-costmodel" / "results.csv")
    feat = FEATURES["params+asm"]
    X = np.array([feat(r) for r in rows])
    X = (X - X.mean(0)) / (X.std(0) + 1e-12)
    y = np.log(np.array([r["gflops"] for r in rows]))
    groups = {}
    for i, r in enumerate(rows):
        groups.setdefault((r["chain"], r["dtype"]), []).append(i)

    def learned_pick(idx):
        mask = np.ones(len(rows), bool)
        mask[idx] = False
        p = ridge_predict(ridge_fit(X[mask], y[mask]), X[idx])
        return int(np.argmax(p))

    picks = [(n, lambda idx, m=m: max(range(len(idx)),
                                      key=lambda k: m(r13[idx[k]])))
             for n, m in MODELS] + [("e. learned params+asm", learned_pick)]
    for name, pick in picks:
        regs = []
        for idx in groups.values():
            meas = [rows[i]["gflops"] for i in idx]
            regs.append(max(meas) / meas[pick(idx)])
        geo = math.exp(sum(math.log(g) for g in regs) / len(regs))
        misses = [k for k, idx in groups.items()
                  if pick(idx) != max(range(len(idx)),
                                      key=lambda j: rows[idx[j]]["gflops"])]
        print(f"{name:<22} geo-regret {geo:6.3f}x  max {max(regs):6.3f}x  "
              f"missed {misses if len(misses) <= 5 else len(misses)}")


def main():
    rows = load()
    print(f"{len(rows)} variants, 22 leave-one-group-out folds")
    print(f"{'features':<12} {'global-rho':>10} {'grp-rho':>8} {'top1':>6}")
    for name, feat in FEATURES.items():
        glob, grho, top1 = logo_eval(rows, feat)
        print(f"{name:<12} {glob:10.3f} {grho:8.3f} {top1:6.0%}")
    print()
    regret_eval(rows)
    print(f"\nmeasured costs: ridge predict {predict_cost(rows):.1f}us/variant, "
          f"asm feature extraction {asm_feature_cost():.2f}ms/variant")


if __name__ == "__main__":
    main()

"""exp016 scoring: llvm-mca predictions vs measured, exp013 metrics.

Predictions and measurements are both flops/cycle, so absolute error is
reported WITHOUT scale fitting (mca claims absolute cycle counts), plus
the scale-fitted metrics for comparability with exp013's model table.

Run: .venv/bin/python exp016-mca/score.py
"""

import csv
import math
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / "exp013-costmodel"))
from analyze import ratio_errors, spearman  # noqa: E402


def load():
    rows = []
    with open(HERE / "mca.csv", newline="") as fh:
        for r in csv.DictReader(fh):
            for k in ("chain", "accs"):
                r[k] = int(r[k])
            for k in ("pred_fpc_dep", "pred_fpc_rt", "meas_fpc", "gflops"):
                r[k] = float(r[k])
            rows.append(r)
    return rows


def within_groups(rows, key):
    groups = {}
    for r in rows:
        groups.setdefault((r["chain"], r["dtype"]), []).append(r)
    rhos, hits, regs = [], 0, []
    for g in groups.values():
        pred = [r[key] for r in g]
        meas = [r["gflops"] for r in g]
        rhos.append(spearman(pred, meas))
        pick = pred.index(max(pred))
        hits += pick == meas.index(max(meas))
        regs.append(max(meas) / meas[pick])
    geo_reg = math.exp(sum(math.log(x) for x in regs) / len(regs))
    return (sum(rhos) / len(rhos), hits / len(groups), geo_reg, max(regs),
            len(groups))


def cliff(rows, key):
    p = {r["chain"]: r[key] for r in rows
         if r["accs"] == 1 and r["dtype"] == "float64"
         and r["chain"] in (96, 112)}
    return "PASS" if p[96] > p[112] else "FAIL"


def main():
    rows = load()
    print(f"{len(rows)} variants")
    print(f"{'predictor':<16} {'abs-geo':>7} {'abs-max':>7} {'fit-geo':>7} "
          f"{'fit-max':>7} {'rho':>6} {'grp-rho':>7} {'top1':>5} "
          f"{'regret':>6} {'max-reg':>7}  cliff")
    meas_fpc = [r["meas_fpc"] for r in rows]
    meas_gf = [r["gflops"] for r in rows]
    for key in ("pred_fpc_dep", "pred_fpc_rt"):
        pred = [r[key] for r in rows]
        # absolute (no scale fit): pred/meas ratio errors
        errs = [max(p / m, m / p) for p, m in zip(pred, meas_fpc)]
        ageo = math.exp(sum(math.log(e) for e in errs) / len(errs))
        fgeo, fmax = ratio_errors(pred, meas_fpc)
        rho = spearman(pred, meas_gf)
        grho, top1, greg, mreg, _ = within_groups(rows, key)
        print(f"{key:<16} {ageo:7.2f} {max(errs):7.2f} {fgeo:7.2f} "
              f"{fmax:7.2f} {rho:6.3f} {grho:7.3f} {top1:5.0%} "
              f"{greg:6.3f} {mreg:7.3f}  {cliff(rows, key)}")

    # where does mca break worst? top absolute misses (dep model)
    print("\nworst absolute misses (dep model):")
    for r in sorted(rows, key=lambda r: -max(
            r["pred_fpc_dep"] / r["meas_fpc"],
            r["meas_fpc"] / r["pred_fpc_dep"]))[:8]:
        e = r["pred_fpc_dep"] / r["meas_fpc"]
        print(f"  chain={r['chain']:3d} accs={r['accs']} {r['dtype']:7s} "
              f"pred {r['pred_fpc_dep']:6.2f} meas {r['meas_fpc']:6.2f} "
              f"({e:5.2f}x) packed={'y' if int(r['block_flops']) > 50 else 'n'}")


if __name__ == "__main__":
    main()

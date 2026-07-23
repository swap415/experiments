"""exp014 analysis: aggregate results.csv + passes.csv into the breakdown.

Run: .venv/bin/python exp014-compiletime/analyze.py
"""

import csv
import statistics as st
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent


def load(name):
    with open(HERE / name, newline="") as fh:
        return list(csv.DictReader(fh))


def main():
    rows = load("results.csv")
    prows = load("passes.csv")

    print(f"{'kernel':<13} {'import':>11} {'compile':>11} {'llvm_lock':>11} "
          f"{'llvm%':>6} {'first_exec':>11}")
    per_kernel = defaultdict(list)
    for r in rows:
        per_kernel[r["kernel"]].append(r)
    for k, rs in per_kernel.items():
        def ms(field):
            v = [float(x[field]) * 1e3 for x in rs]
            return st.mean(v), st.stdev(v)
        imp, imps = ms("import_s")
        comp, comps = ms("compile_s")
        llvm, llvms = ms("llvm_lock_s")
        fx, fxs = ms("first_exec_s")
        print(f"{k:<13} {imp:7.1f}±{imps:3.1f} {comp:7.1f}±{comps:3.1f} "
              f"{llvm:7.1f}±{llvms:3.1f} {llvm/comp:6.0%} {fx:7.1f}±{fxs:3.1f}")

    # top passes by mean run time (mean over reps, summed over kernels)
    acc = defaultdict(list)
    for p in prows:
        acc[(p["kernel"], p["pass"])].append(float(p["run_s"]) * 1e3)
    by_pass = defaultdict(float)
    for (k, pname), v in acc.items():
        by_pass[pname] += st.mean(v)
    total = sum(by_pass.values())
    print(f"\ntop passes (mean ms summed over {len(per_kernel)} kernels; "
          f"pipeline total {total:.0f}ms):")
    for pname, t in sorted(by_pass.items(), key=lambda x: -x[1])[:12]:
        print(f"  {pname:<40} {t:7.1f}ms {t/total:6.1%}")


if __name__ == "__main__":
    main()

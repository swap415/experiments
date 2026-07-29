"""exp018 analysis: raw knob vs asm-rule policy across families.

Rule (exp017): use thresh2k ONLY if default emitted zero packed fmas AND
thresh2k vectorizes. Gather rows carry an elision flag (factorable
constant — corpus flaw, see results.md); their nominal-flops labels are
wrong but config-relative speedups remain valid.

Run: .venv/bin/python exp018-corpusv3/analyze.py
"""

import csv
import math
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent


def geo(v):
    return math.exp(sum(math.log(x) for x in v) / len(v))


def main():
    by = defaultdict(dict)
    with open(HERE / "results.csv", newline="") as fh:
        for r in csv.DictReader(fh):
            by[(r["family"], r["d"])][r["config"]] = r

    print(f"{'family':<10} {'d':<9} {'knob':>7} {'rule':>7}  fired")
    knob, rule, oracle = [], [], []
    fired = regress_avoided = 0
    for (fam, d), cfg in sorted(by.items()):
        a, b = cfg["default"], cfg["thresh2k"]
        s = float(b["gflops"]) / float(a["gflops"])
        fire = int(a["packed_fma"]) == 0 and int(b["packed_fma"]) > 0
        rs = s if fire else 1.0
        knob.append(s)
        rule.append(rs)
        oracle.append(max(s, 1.0))
        fired += fire
        regress_avoided += (not fire) and s < 0.97
        print(f"{fam:<10} {d:<9} {s:7.2f} {rs:7.2f}  {'*' if fire else ''}")
    print(f"\nvariants: {len(by)}  rule fired: {fired}  "
          f"knob-regressions avoided by rule: {regress_avoided}")
    print(f"raw knob : geo {geo(knob):.3f}x  worst {min(knob):.3f}x  "
          f"regressions>3% {sum(s < 0.97 for s in knob)}")
    print(f"asm rule : geo {geo(rule):.3f}x  worst {min(rule):.3f}x  "
          f"regressions>3% {sum(s < 0.97 for s in rule)}")
    print(f"oracle   : geo {geo(oracle):.3f}x")


if __name__ == "__main__":
    main()

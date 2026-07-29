"""exp020 analysis: benefit-per-ms of opt levels, from results.csv.

Run: .venv/bin/python exp020-optlevel/analyze.py
"""

import csv
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent


def main():
    by = defaultdict(dict)
    with open(HERE / "results.csv", newline="") as fh:
        for r in csv.DictReader(fh):
            by[(r["family"], r["d"])][r["opt"]] = r

    print(f"{'kernel':<22} {'O3 GF/s':>8} {'O2/O3':>6} {'O1/O3':>6} "
          f"{'O0/O3':>7} {'cmp O3':>7} {'d(O2)':>6} {'d(O0)':>7}")
    for key, cfg in by.items():
        o3, o2, o1, o0 = (cfg[o] for o in ("3", "2", "1", "0"))
        g3 = float(o3["gflops"])
        c3 = float(o3["compile_ms"])
        print(f"{key[0]}/{key[1]:<15} {g3:8.2f} "
              f"{float(o2['gflops']) / g3:6.2f} "
              f"{float(o1['gflops']) / g3:6.2f} "
              f"{float(o0['gflops']) / g3:7.3f} {c3:6.1f}ms "
              f"{float(o2['compile_ms']) - c3:+6.1f} "
              f"{float(o0['compile_ms']) - c3:+7.1f}")

    saves = [float(c["3"]["compile_ms"]) - float(c["2"]["compile_ms"])
             for c in by.values()]
    worst = min(float(c["2"]["gflops"]) / float(c["3"]["gflops"])
                for c in by.values())
    o0_compile = [float(c["0"]["compile_ms"]) / float(c["3"]["compile_ms"])
                  for c in by.values()]
    print(f"\nO3->O2 compile saving: {sum(saves) / len(saves):.1f}ms mean; "
          f"worst runtime cost {1 / worst:.1f}x")
    print(f"O0 compile blowup vs O3: {min(o0_compile):.1f}-"
          f"{max(o0_compile):.1f}x LONGER")


if __name__ == "__main__":
    main()

"""exp007 analysis: best chunk per config, kernel x size heatmap, and the
worst-case cost of adopting one global default chunk (16384).

Run: uv run python exp007-chunk-grid/analyze.py [--csv PATH]
"""

import argparse
import csv
from collections import defaultdict

DEFAULT_CHUNK = 16384


def fmt_chunk(c):
    return "static" if c == 0 else f"{c // 1024}K"


def fmt_n(n):
    return f"{n // 2**20}M" if n >= 2**20 else f"{n // 2**10}K"


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--csv", default="exp007-chunk-grid/results.csv")
    args = p.parse_args()

    perf = defaultdict(dict)  # (kernel, n, threads) -> {chunk: metric}
    unit = {}
    with open(args.csv) as f:
        for r in csv.DictReader(f):
            key = (r["kernel"], int(r["n"]), int(r["threads"]))
            perf[key][int(r["chunk"])] = float(r["metric"])
            unit[r["kernel"]] = r["unit"]

    print("== best chunk per (kernel, n, threads) ==")
    for (k, n, t), by in sorted(perf.items()):
        best = max(by, key=by.get)
        vs = f"{by[best] / by[0]:5.2f}x vs static" if 0 in by else "no static row"
        print(f"{k:9s} n={fmt_n(n):>4s} nt={t:2d}  best {fmt_chunk(best):>6s}  "
              f"{by[best]:9.2f} {unit[k]:7s} {vs}")

    kernels = sorted({k for k, _, _ in perf})
    ns = sorted({n for _, n, _ in perf})
    for t in sorted({t for _, _, t in perf}):
        print(f"\n== best chunk, nt={t} (kernel x n) ==")
        print(" " * 9 + "".join(f"{fmt_n(n):>8s}" for n in ns))
        for k in kernels:
            by_n = [perf.get((k, n, t), {}) for n in ns]
            cells = [fmt_chunk(max(by, key=by.get)) if by else "-" for by in by_n]
            print(f"{k:9s}" + "".join(f"{c:>8s}" for c in cells))

    worst, wkey = 1.0, None
    for key, by in perf.items():
        if DEFAULT_CHUNK in by:
            rel = by[DEFAULT_CHUNK] / max(by.values())
            if rel < worst:
                worst, wkey = rel, key
    print(f"\n== one global default chunk={DEFAULT_CHUNK} vs per-config best ==")
    if wkey:
        k, n, t = wkey
        print(f"worst regression {(1 - worst) * 100:.1f}%: {k} n={fmt_n(n)} nt={t}")
    else:
        print("no regression: 16K matches per-config best in every measured config")


if __name__ == "__main__":
    main()

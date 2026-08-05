"""exp022 follow-up: the gather wraparound fix, three index-type variants.

int64 (numpy default), uint64 array with int64 offset (promotion
re-poisons — numba/numpy type rules promote mixed u64+i64), and fully
unsigned. Writes fix_variants.csv.

Run: taskset -c 2 .venv/bin/python exp022-asmdiff/fix_variants.py
"""

import csv
import re
import sys
import time
from pathlib import Path

import numpy as np
from numba import njit

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
N = 1024 * 1024
REPS = 5

SRC_I = ("def gath(a, b, idx, w):\n"
         "    for i in range(a.size):\n"
         "        acc = 0.0\n"
         "        for k in range(64):\n"
         "            acc = acc + b[idx[k] + (i & 7)] * w[k]\n"
         "        a[i] = acc\n")
SRC_U = ("def gath(a, b, idx, w):\n"
         "    for i in range(a.size):\n"
         "        off = np.uint64(i & 7)\n"
         "        acc = 0.0\n"
         "        for k in range(64):\n"
         "            acc = acc + b[idx[k] + off] * w[k]\n"
         "        a[i] = acc\n")


def run(label, src, idx_dtype):
    rng = np.random.default_rng(7)
    B, W, A = rng.random(N), rng.random(256), np.zeros(N)
    idx = rng.integers(0, N - 8, 256).astype(idx_dtype)
    ns = {"np": np}
    exec(src, ns)
    f = njit(fastmath=True)(ns["gath"])
    f(A, B, idx, W)
    asm = next(iter(f.inspect_asm().values()))
    times = []
    for _ in range(REPS):
        t0 = time.perf_counter()
        f(A, B, idx, W)
        times.append(time.perf_counter() - t0)
    t = np.array(times)
    return {"variant": label,
            "gflops": round(2 * 64 * N / t.mean() / 1e9, 2),
            "rel_std": round(t.std() / t.mean(), 4),
            "vpcmpgtq": len(re.findall(r"vpcmpgtq", asm)),
            "vpaddq": len(re.findall(r"vpaddq", asm))}


def main():
    rows = [run("int64", SRC_I, np.int64),
            run("uint64_mixed", SRC_I, np.uint64),
            run("uint64_full", SRC_U, np.uint64)]
    for r in rows:
        print(f"{r['variant']:<13} {r['gflops']:6.2f} GF/s  "
              f"vpcmpgtq={r['vpcmpgtq']:2d} vpaddq={r['vpaddq']:2d}")
    with open(HERE / "fix_variants.csv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    print(f"wrote {HERE / 'fix_variants.csv'}")


if __name__ == "__main__":
    main()

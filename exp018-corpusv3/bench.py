"""exp018 (S2+S4a): corpus v3 — does the collapse cliff and the exp017
asm-rule policy generalize beyond the poly-chain family?

Families (inner constant-trip loop depth d as the unroll pressure knob):
  reduction: s += polychain_d(x) per element (cross-element reduction dep)
  stencil:   d-tap weighted window from a coefficient array
  gather:    d indirect loads via an index array (i-dependent offset so
             the inner loop cannot be hoisted)
Plus map (poly-chain) cliff rows from exp013 as anchors.

Two configs per variant in fresh subprocesses (default vs
--unroll-threshold=2000, the exp017 knob). Per sample: compile wall,
asm features, one fp_arith-verified probe (executed-vs-nominal within
5% or flagged), 5 timing reps. The asm-rule policy is scored offline
(analyze.py): use thresh2k only where default emitted zero packed fmas
and thresh2k vectorizes.

The child is invoked as: bench.py --child '<json params>'.

Run: .venv/bin/python exp018-corpusv3/bench.py   (~5min)
"""

import csv
import json
import subprocess
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPS = 5
N = 1024 * 1024

DEPTHS = {
    "map": [[96, 1], [104, 1], [112, 1], [32, 2], [128, 2]],  # (chain, accs)
    "reduction": [16, 64, 96, 104, 112, 128, 160],
    "stencil": [16, 64, 96, 104, 128],
    "gather": [16, 64, 96, 128],
}
CONFIGS = {"default": [], "thresh2k": ["--unroll-threshold=2000"]}


def child(params):
    from llvmlite import binding as llb
    for opt in params["opts"]:
        llb.set_option("", opt)
    import numpy as np
    from numba import njit
    sys.path.insert(0, str(HERE.parent / "exp013-costmodel"))
    sys.path.insert(0, str(HERE.parent))
    from bench import make_kernel, asm_features
    from perfcnt import PerfGroup

    rng = np.random.default_rng(7)
    B = rng.random(N)
    W = rng.random(256)
    IDX = rng.integers(0, N - 8, 256).astype(np.int64)

    def build(family, d):
        if family == "map":
            chain, accs = d
            f = make_kernel(chain, accs, np.float64)
            return (f, (np.zeros(N), B),
                    (2 * chain + accs - 1) * N, 2 * chain * N)
        if family == "reduction":
            src = (f"def f(b):\n"
                   f"    s = 0.0\n"
                   f"    for i in range(b.size):\n"
                   f"        x = b[i]\n"
                   f"        acc = 0.3\n"
                   f"        for _ in range({d}):\n"
                   f"            acc = acc * x + 1.0001\n"
                   f"        s += acc\n"
                   f"    return s\n")
            ns = {}
            exec(src, ns)
            useful = (2 * d + 1) * N
            return njit(fastmath=True)(ns["f"]), (B,), useful, useful
        if family == "stencil":
            src = (f"def f(a, b, w):\n"
                   f"    for i in range(a.size - {d}):\n"
                   f"        acc = 0.0\n"
                   f"        for k in range({d}):\n"
                   f"            acc = acc + b[i + k] * w[k]\n"
                   f"        a[i] = acc\n")
            ns = {}
            exec(src, ns)
            useful = 2 * d * (N - d)
            return (njit(fastmath=True)(ns["f"]), (np.zeros(N), B, W),
                    useful, useful)
        if family == "gather":
            # v3.1: per-tap multiplier w[k] — a single shared constant let
            # reassociation factor sum(b*C)=C*sum(b), eliding the multiplies
            # (counter-caught in v3; third elision mechanism documented).
            src = (f"def f(a, b, idx, w):\n"
                   f"    for i in range(a.size):\n"
                   f"        acc = 0.0\n"
                   f"        for k in range({d}):\n"
                   f"            acc = acc + b[idx[k] + (i & 7)] * w[k]\n"
                   f"        a[i] = acc\n")
            ns = {}
            exec(src, ns)
            useful = 2 * d * N
            return (njit(fastmath=True)(ns["f"]), (np.zeros(N), B, IDX, W),
                    useful, useful)

    out = []
    for family, ds in DEPTHS.items():
        for d in ds:
            t0 = time.perf_counter()
            f, args, nominal, useful = build(family, d)
            f(*args)
            t_compile = (time.perf_counter() - t0) * 1e3
            feat = asm_features(f)
            g = PerfGroup(fp=True)
            with g:
                f(*args)
            g.close()
            ratio = g.flops() / nominal
            cyc = g.counts["cpu_core/cycles"]
            ins = g.counts["cpu_core/instructions"]
            times = []
            for _ in range(REPS):
                t0 = time.perf_counter()
                f(*args)
                times.append(time.perf_counter() - t0)
            times = np.array(times)
            out.append({"family": family, "d": str(d),
                        "compile_ms": round(t_compile, 1),
                        "time_ms": round(times.mean() * 1e3, 3),
                        "time_std_ms": round(times.std() * 1e3, 3),
                        "gflops": round(useful / times.mean() / 1e9, 2),
                        "flops_ratio": round(ratio, 4),
                        "ipc": round(ins / cyc, 3) if cyc else 0.0,
                        "ginsn": round(ins / 1e9, 4),
                        "probe_fpc": round(useful / cyc, 4) if cyc else 0.0,
                        **feat})
    print(json.dumps(out))


def main():
    rows = []
    for cname, opts in CONFIGS.items():
        r = subprocess.run(
            ["taskset", "-c", "2", sys.executable, __file__, "--child",
             json.dumps({"opts": opts})],
            capture_output=True, text=True, cwd=HERE.parent)
        assert r.returncode == 0, f"{cname}: {r.stderr[-1500:]}"
        for d in json.loads(r.stdout):
            d["config"] = cname
            rows.append(d)
            flag = " ELISION" if abs(d["flops_ratio"] - 1) > 0.05 else ""
            print(f"{cname:<9} {d['family']:<9} d={d['d']:<9} "
                  f"{d['gflops']:7.2f} GF/s  {d['packed_fma']:3d}p/"
                  f"{d['scalar_fma']:3d}s  {d['compile_ms']:6.1f}ms" + flag)
    with open(HERE / "results.csv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    print(f"wrote {HERE / 'results.csv'}")


if __name__ == "__main__":
    if "--child" in sys.argv:
        child(json.loads(sys.argv[sys.argv.index("--child") + 1]))
    else:
        main()

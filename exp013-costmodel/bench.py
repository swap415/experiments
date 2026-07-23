"""exp013: can cheap cost signals rank numba kernel variants across the
unroll cliff?

Corpus: poly kernels on one pinned P-core — `chain` total fmas per element,
round-robined over `accs` independent accumulators (manual interleave,
summed at the end), float64/float32. 11 chains x 3 accs x 2 dtypes = 66
variants spanning the exp005 full-unroll cliff (96 -> 104).

Per variant we record: wall-clock GFLOP/s (ground truth, 5 reps after
warmup), asm features from inspect_asm() (packed/scalar fma count, distinct
xmm/ymm regs, asm lines), and ONE perf-counter calibration rep (IPC, Ginsn
on the P-core PMU). analyze.py ranks the corpus with four cost models
against the measurement; results.csv makes analysis rerunnable without
re-measuring.

v2: distinct per-accumulator constants (v1's identical chains were CSE'd,
2-4x elision), fp_arith executed-vs-nominal flops check and f32 precision
check on every sample.

The run MUST be pinned to one P-core (full corpus is serialized elsewhere):
    taskset -c 2 .venv/bin/python exp013-costmodel/bench.py
Smoke test (3 variants, writes results-smoke.csv):
    taskset -c 2 .venv/bin/python exp013-costmodel/bench.py --smoke
"""

import csv
import re
import sys
import time
from pathlib import Path

import numpy as np
from numba import njit

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from perfcnt import PerfGroup

N = 4 * 1024 * 1024
CHAINS = (8, 16, 32, 48, 64, 80, 96, 104, 112, 128, 160)
ACCS = (1, 2, 4)
DTYPES = {"float64": np.float64, "float32": np.float32}
REPS = 5
SMOKE = [(96, 1, "float64"), (112, 1, "float64"), (64, 2, "float32")]


def make_kernel(chain, accs, dtype):
    """`chain` fmas per element, round-robin over `accs` accumulators.

    exec a generated def so numba compiles a plain function (numba works
    from bytecode; inspect_asm() on the dispatcher is unaffected). Zj/Cj are
    numpy scalars in the function's globals so the accumulator dtype — and
    thus the vector width — follows the parameter instead of float64.
    v2: each accumulator gets a DISTINCT init, constant AND multiplier.
    Identical chains were CSE'd in v1 (2-4x elision, counter-verified);
    distinct constants alone are NOT enough — with a shared multiplier x
    the recurrences stay linear in (x^n, sum x^k), so the compiler can
    compute the shared powers once (smoke-tested: exactly 0.5 ratio at
    accs=2). Distinct bases x_j = x + D_j kill the shared structure.
    """
    assert chain % accs == 0
    init = "\n".join(f"        acc{j} = Z{j}" for j in range(accs))
    xs = "\n".join(f"        x{j} = x + D{j}" for j in range(1, accs))
    fmas = "\n".join(f"            acc{j} = acc{j} * {f'x{j}' if j else 'x'}"
                     f" + C{j}" for j in range(accs))
    total = " + ".join(f"acc{j}" for j in range(accs))
    src = (f"def kern(a, b):\n"
           f"    for i in range(a.size):\n"
           f"        x = b[i]\n"
           f"{init}\n{xs}\n"
           f"        for _ in range({chain // accs}):\n"
           f"{fmas}\n"
           f"        a[i] = {total}\n")
    ns = {}
    for j in range(accs):
        ns[f"Z{j}"] = dtype(0.1 * (j + 1))
        ns[f"C{j}"] = dtype(1.0001 + 0.0001 * j)
        if j:
            ns[f"D{j}"] = dtype(0.01 * j)
    exec(src, ns)
    return njit(fastmath=True)(ns["kern"])


def asm_features(f):
    asm = next(iter(f.inspect_asm().values()))
    return {"packed_fma": len(re.findall(r"vfmadd\d+p[sd]", asm)),
            "scalar_fma": len(re.findall(r"vfmadd\d+s[sd]", asm)),
            "simd_regs": len(set(re.findall(r"[xy]mm\d+", asm))),
            "asm_lines": asm.count("\n")}


def perf_probe(f, a, b, chain, accs, dname):
    """One calibration rep on the P-core PMU (pinned, so cpu_atom stays ~0).

    v2: fp_arith counters give executed flops — the elision check that
    caught v1's CSE contamination, now run on every sample. Also verifies
    f32 kernels retire single-precision ops (no silent double promotion).
    """
    g = PerfGroup(fp=True)
    with g:
        f(a, b)
    g.close()
    cyc = g.counts["cpu_core/cycles"]
    ins = g.counts["cpu_core/instructions"]
    executed = g.flops()
    # per element: chain fmas (2 flops each, counter increments 2x/fma)
    # + (accs-1) reduction adds. The (accs-1) x_j adds are absorbed by
    # constant folding: first unrolled iteration has acc=Z_j (constant),
    # so Z_j*(x+D_j)+C_j collapses to one fma (measured deficit = accs-1
    # exactly, all six >5% rows in the 2026-07-23 run).
    nominal = (2 * chain + (accs - 1)) * a.size
    wrong_prec = sum(g.counts[f"cpu_core/{ev}"] * lanes
                     for ev, lanes in PerfGroup.FP_LANES.items()
                     if ("single" if dname == "float64" else "double") in ev)
    return {"ipc": round(ins / cyc, 3) if cyc else 0.0,
            "ginsn": round(ins / 1e9, 4),
            "flops_ratio": round(executed / nominal, 4),
            "wrong_prec_frac": round(wrong_prec / max(executed, 1), 4),
            "multiplexed": int(g.multiplexed)}


def main():
    smoke = "--smoke" in sys.argv
    variants = SMOKE if smoke else [(c, a, d) for d in DTYPES for a in ACCS
                                    for c in CHAINS]
    arrays = {name: (np.zeros(N, dt), np.random.rand(N).astype(dt))
              for name, dt in DTYPES.items()}
    try:
        PerfGroup().close()
        have_perf = True
    except OSError as e:
        have_perf = False
        print(f"perfcnt unavailable ({e}); ipc/ginsn left blank", file=sys.stderr)

    rows = []
    for chain, accs, dname in variants:
        f = make_kernel(chain, accs, DTYPES[dname])
        a, b = arrays[dname]
        f(a, b)  # compile + warmup
        feat = asm_features(f)
        perf = perf_probe(f, a, b, chain, accs, dname) if have_perf else \
            {"ipc": "", "ginsn": "", "flops_ratio": "", "wrong_prec_frac": "",
             "multiplexed": ""}
        times = []
        for _ in range(REPS):
            t0 = time.perf_counter()
            f(a, b)
            times.append(time.perf_counter() - t0)
        t = np.array(times)
        gflops = 2 * chain * N / t.mean() / 1e9  # flops independent of accs
        rows.append({"chain": chain, "accs": accs, "dtype": dname, "n": N,
                     "time_ms": round(t.mean() * 1e3, 3),
                     "time_std_ms": round(t.std() * 1e3, 3),
                     "gflops": round(gflops, 2), **feat, **perf})
        flag = ""
        if have_perf:
            if abs(perf["flops_ratio"] - 1.0) > 0.05:
                flag += f"  ELISION ratio={perf['flops_ratio']:.3f}"
            if perf["wrong_prec_frac"] > 0.01:
                flag += f"  WRONG-PREC {perf['wrong_prec_frac']:.2f}"
            if perf["multiplexed"]:
                flag += "  MUXED"
        print(f"chain={chain:3d} accs={accs} {dname:7s}  {gflops:6.1f} GFLOP/s  "
              f"asm: {feat['packed_fma']:3d}p/{feat['scalar_fma']:3d}s fma  "
              f"{feat['simd_regs']:2d} regs  {feat['asm_lines']:4d} lines"
              + (f"  ipc {perf['ipc']:.2f}" if have_perf else "") + flag)

    out = Path(__file__).resolve().parent / (
        "results-smoke.csv" if smoke else "results.csv")
    with open(out, "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    print(f"wrote {out}")


if __name__ == "__main__":
    main()

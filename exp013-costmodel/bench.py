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

The run MUST be pinned to one P-core (full corpus is serialized elsewhere):
    taskset -c 2 uv run python exp013-costmodel/bench.py
Smoke test (3 variants, writes results-smoke.csv):
    taskset -c 2 uv run python exp013-costmodel/bench.py --smoke
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
    from bytecode; inspect_asm() on the dispatcher is unaffected). Z/C are
    numpy scalars in the function's globals so the accumulator dtype — and
    thus the vector width — follows the parameter instead of float64.
    """
    assert chain % accs == 0
    init = "\n".join(f"        acc{j} = Z" for j in range(accs))
    fmas = "\n".join(f"            acc{j} = acc{j} * x + C" for j in range(accs))
    total = " + ".join(f"acc{j}" for j in range(accs))
    src = (f"def kern(a, b):\n"
           f"    for i in range(a.size):\n"
           f"        x = b[i]\n"
           f"{init}\n"
           f"        for _ in range({chain // accs}):\n"
           f"{fmas}\n"
           f"        a[i] = {total}\n")
    ns = {"Z": dtype(0.0), "C": dtype(1.000000001)}
    exec(src, ns)
    return njit(fastmath=True)(ns["kern"])


def asm_features(f):
    asm = next(iter(f.inspect_asm().values()))
    return {"packed_fma": len(re.findall(r"vfmadd\d+p[sd]", asm)),
            "scalar_fma": len(re.findall(r"vfmadd\d+s[sd]", asm)),
            "simd_regs": len(set(re.findall(r"[xy]mm\d+", asm))),
            "asm_lines": asm.count("\n")}


def perf_probe(f, a, b):
    """One calibration rep on the P-core PMU (pinned, so cpu_atom stays ~0)."""
    g = PerfGroup()
    with g:
        f(a, b)
    g.close()
    cyc = g.counts["cpu_core/cycles"]
    ins = g.counts["cpu_core/instructions"]
    return {"ipc": round(ins / cyc, 3) if cyc else 0.0,
            "ginsn": round(ins / 1e9, 4)}


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
        perf = perf_probe(f, a, b) if have_perf else {"ipc": "", "ginsn": ""}
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
        print(f"chain={chain:3d} accs={accs} {dname:7s}  {gflops:6.1f} GFLOP/s  "
              f"asm: {feat['packed_fma']:3d}p/{feat['scalar_fma']:3d}s fma  "
              f"{feat['simd_regs']:2d} regs  {feat['asm_lines']:4d} lines"
              + (f"  ipc {perf['ipc']:.2f}" if have_perf else ""))

    out = Path(__file__).resolve().parent / (
        "results-smoke.csv" if smoke else "results.csv")
    with open(out, "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    print(f"wrote {out}")


if __name__ == "__main__":
    main()

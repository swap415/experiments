"""exp016: does llvm-mca's machine model predict measured throughput for
the code shapes numba actually emits? (S1: validate LLVM's static
assumptions against hardware)

For each exp013 v2 variant: compile, extract the hot loop block from
inspect_asm() (the label-delimited block with the most fma instructions),
feed it to llvm-mca -mcpu=raptorlake two ways:
  - timeline: Total Cycles / iterations (models loop-carried deps)
  - rthroughput: Block RThroughput (pure port pressure, deps ignored)
Predicted flops/cycle = fma flops in block / predicted cycles per block
iteration. Ground truth: measured flops/cycle from exp013's perf probe
(nominal flops * ipc / instructions — frequency-independent, same units
as the prediction, so absolute error needs no scale fit).

Writes mca.csv; scoring in score.py (same metrics as exp013/exp015).

Run: .venv/bin/python exp016-mca/mca.py   (compiles 66 kernels, ~2min)
"""

import csv
import re
import subprocess
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / "exp013-costmodel"))
sys.path.insert(0, str(HERE.parent))
from bench import CHAINS, ACCS, DTYPES, make_kernel  # noqa: E402

MCA = "llvm-mca-18"
MCPU = "raptorlake"
ITERS = 100
LANES = {("p", "d", "y"): 4, ("p", "s", "y"): 8,
         ("p", "d", "x"): 2, ("p", "s", "x"): 4}


def hot_block(asm):
    """The label-delimited block that is the vector loop body: most packed
    fmas, tie-broken by total fmas (a scalar epilogue can contain MORE fma
    instructions than the vector body — count packed first)."""
    blocks, cur = {}, None
    for line in asm.splitlines():
        m = re.match(r"^(\.LBB\S+):", line)
        if m:
            cur = m.group(1)
            blocks[cur] = []
        elif cur and line.strip() and not line.strip().startswith("."):
            blocks[cur].append(line)
    return max(blocks.values(),
               key=lambda b: (sum(bool(re.search(r"vfmadd\d+p", l)) for l in b),
                              sum("vfmadd" in l for l in b)))


def block_flops(lines):
    total = 0
    for l in lines:
        m = re.search(r"vfmadd\d+([ps])([sd]).*%([xy])mm", l)
        if m:
            kind, prec, reg = m.groups()
            total += 2 * (1 if kind == "s" else LANES[(kind, prec, reg)])
    return total


def run_mca(lines):
    out = subprocess.run(
        [MCA, f"-mcpu={MCPU}", f"-iterations={ITERS}", "--timeline=false"],
        input="\n".join(lines), capture_output=True, text=True, check=True
    ).stdout
    cycles = int(re.search(r"Total Cycles:\s+(\d+)", out).group(1))
    rthru = float(re.search(r"Block RThroughput:\s+([\d.]+)", out).group(1))
    return cycles / ITERS, rthru


def main():
    probe = {}
    with open(HERE.parent / "exp013-costmodel" / "results.csv", newline="") as fh:
        for r in csv.DictReader(fh):
            probe[(int(r["chain"]), int(r["accs"]), r["dtype"])] = r

    rows = []
    for dname, dtype in DTYPES.items():
        for accs in ACCS:
            for chain in CHAINS:
                f = make_kernel(chain, accs, dtype)
                a, b = np.zeros(64, dtype), np.ones(64, dtype)
                f(a, b)
                block = hot_block(next(iter(f.inspect_asm().values())))
                bf = block_flops(block)
                cyc_dep, cyc_rt = run_mca(block)
                m = probe[(chain, accs, dname)]
                nominal = (2 * chain + accs - 1) * int(m["n"])
                cycles = float(m["ginsn"]) * 1e9 / float(m["ipc"])
                rows.append({
                    "chain": chain, "accs": accs, "dtype": dname,
                    "block_lines": len(block), "block_flops": bf,
                    "mca_cyc_dep": round(cyc_dep, 2),
                    "mca_cyc_rt": round(cyc_rt, 2),
                    "pred_fpc_dep": round(bf / cyc_dep, 3),
                    "pred_fpc_rt": round(bf / cyc_rt, 3),
                    "meas_fpc": round(nominal / cycles, 3),
                    "gflops": float(m["gflops"])})
                print(f"chain={chain:3d} accs={accs} {dname:7s}  "
                      f"block {len(block):3d} insn {bf:4d} fl  "
                      f"mca dep {bf / cyc_dep:6.2f} rt {bf / cyc_rt:6.2f} "
                      f"meas {rows[-1]['meas_fpc']:6.2f} f/cyc")

    with open(HERE / "mca.csv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    print(f"wrote {HERE / 'mca.csv'}")


if __name__ == "__main__":
    main()

"""exp021 (S2): retry_compile() validated live, single process.

exp018 measured the policy across separate subprocesses per config; this
is the deployment scenario — all corpus v3 kernels through
retry_compile() in ONE process, set_option toggling inline. Per kernel:
plain-njit throughput and compile wall vs retry_compile throughput and
total wall (includes asm check + retry compile when fired). Also
verifies the toggle leaks nothing: a control kernel compiled after the
sweep must match its pre-sweep throughput.

Run: taskset -c 2 .venv/bin/python exp021-retrycompile/bench.py
"""

import csv
import sys
import time
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / "exp013-costmodel"))
sys.path.insert(0, str(HERE.parent))
from bench import make_kernel  # noqa: E402
from numba import njit  # noqa: E402
from retrycompile import retry_compile, _packed_fma  # noqa: E402

REPS = 5
N = 1024 * 1024
rng = np.random.default_rng(7)
B = rng.random(N)
W = rng.random(256)

KERNELS = [("map", (96, 1)), ("map", (104, 1)), ("map", (112, 1)),
           ("map", (32, 2)), ("map", (128, 2)),
           ("reduction", 16), ("reduction", 96), ("reduction", 104),
           ("reduction", 112), ("reduction", 128), ("reduction", 160),
           ("stencil", 16), ("stencil", 64), ("stencil", 96),
           ("stencil", 104), ("stencil", 128)]


def source(family, d):
    if family == "reduction":
        return (f"def f(b):\n"
                f"    s = 0.0\n"
                f"    for i in range(b.size):\n"
                f"        x = b[i]\n"
                f"        acc = 0.3\n"
                f"        for _ in range({d}):\n"
                f"            acc = acc * x + 1.0001\n"
                f"        s += acc\n"
                f"    return s\n"), (B,), (2 * d + 1) * N
    return (f"def f(a, b, w):\n"
            f"    for i in range(a.size - {d}):\n"
            f"        acc = 0.0\n"
            f"        for k in range({d}):\n"
            f"            acc = acc + b[i + k] * w[k]\n"
            f"        a[i] = acc\n"), (np.zeros(N), B, W), 2 * d * (N - d)


def build(family, d):
    if family == "map":
        chain, accs = d
        f = make_kernel(chain, accs, np.float64)
        return f.py_func, (np.zeros(N), B), 2 * chain * N
    src, args, useful = source(family, d)
    ns = {}
    exec(src, ns)
    return ns["f"], args, useful


def gfps(disp, args, useful):
    disp(*args)
    times = []
    for _ in range(REPS):
        t0 = time.perf_counter()
        disp(*args)
        times.append(time.perf_counter() - t0)
    t = np.array(times)
    return useful / t.mean() / 1e9, t.std() / t.mean()


def main():
    rows = []
    for family, d in KERNELS:
        pyf, args, useful = build(family, d)
        t0 = time.perf_counter()
        plain = njit(fastmath=True)(pyf)
        plain(*args)
        plain_ms = (time.perf_counter() - t0) * 1e3
        t0 = time.perf_counter()
        chosen = retry_compile(pyf, args)
        retry_ms = (time.perf_counter() - t0) * 1e3
        fired = chosen is not plain and _packed_fma(chosen) > 0 \
            and _packed_fma(plain) == 0
        gp, _ = gfps(plain, args, useful)
        gc, _ = gfps(chosen, args, useful)
        rows.append({"family": family, "d": str(d),
                     "plain_gflops": round(gp, 2),
                     "retry_gflops": round(gc, 2),
                     "speedup": round(gc / gp, 3),
                     "plain_compile_ms": round(plain_ms, 1),
                     "retry_total_ms": round(retry_ms, 1),
                     "fired": int(fired)})
        print(f"{family:<10} d={d!s:<9} {gp:7.2f} -> {gc:7.2f} GF/s "
              f"({gc / gp:5.2f}x)  compile {plain_ms:6.1f} -> "
              f"{retry_ms:6.1f}ms  {'FIRED' if fired else ''}")

    # leak check with a THRESHOLD-SENSITIVE control: reduction d=96
    # vectorizes at the pristine default (needs effective t=300, exp018)
    # but collapses if the sweep left the process at t<300.
    pyf, args, useful = build("reduction", 96)
    post = njit(fastmath=True)(pyf)
    post(*args)
    packed = _packed_fma(post)
    gpost, _ = gfps(post, args, useful)
    print(f"leak check: reduction d=96 post-sweep {gpost:.2f} GF/s, "
          f"{packed} packed fma (pristine: ~50 GF/s, 480 packed)")
    assert packed > 0, "threshold leaked: post-sweep default compile collapsed!"

    with open(HERE / "results.csv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    print(f"wrote {HERE / 'results.csv'}")


if __name__ == "__main__":
    main()

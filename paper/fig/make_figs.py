"""Generate paper figures from measured data (exp007, exp008)."""
import csv
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

ROOT = Path(__file__).resolve().parents[2]
FIG = Path(__file__).resolve().parent

CHUNKS = [0, 4096, 16384, 65536, 262144]
CHUNK_LABELS = ["static", "4K", "16K", "64K", "256K"]
# Okabe-Ito colorblind-safe palette
COLORS = ["#0072B2", "#D55E00", "#009E73"]

plt.rcParams.update({
  "font.size": 8, "axes.labelsize": 8, "axes.titlesize": 8,
  "xtick.labelsize": 7, "ytick.labelsize": 7, "legend.fontsize": 7,
  "axes.spines.top": False, "axes.spines.right": False,
  "figure.dpi": 300, "savefig.dpi": 300,
})


def load(path):
  return list(csv.DictReader(open(path)))


def pick(rows, **kw):
  """Rows matching all key=value (string compare), keyed by chunk."""
  sel = {int(r["chunk"]): r for r in rows
         if all(r[k] == str(v) for k, v in kw.items())}
  return ([float(sel[c]["metric"]) for c in CHUNKS],
          [float(sel[c]["metric"]) * float(sel[c]["std_s"]) / float(sel[c]["mean_s"])
           for c in CHUNKS])


def save(fig, name):
  fig.savefig(FIG / f"{name}.pdf")
  fig.savefig(FIG / f"{name}.png")
  plt.close(fig)


def fig_chunk_sweep(rows):
  fig, ax = plt.subplots(figsize=(3.5, 2.4))
  x = np.arange(len(CHUNKS))
  w = 0.38
  for i, kernel in enumerate(["poly32", "poly96"]):
    y, err = pick(rows, kernel=kernel, n=1048576, threads=28)
    off = (i - 0.5) * w
    ax.bar(x + off, y, w, yerr=err, capsize=2, color=COLORS[i], label=kernel,
           error_kw={"lw": 0.8})
    ax.axhline(y[0], color=COLORS[i], lw=0.8, ls="--", alpha=0.6)
  ax.set_xticks(x, CHUNK_LABELS)
  ax.set_xlabel("chunk size (elements)")
  ax.set_ylabel("GFLOP/s")
  handles, labels = ax.get_legend_handles_labels()
  handles.append(plt.Line2D([], [], color="gray", lw=0.8, ls="--"))
  labels.append("static baseline")
  ax.legend(handles, labels, frameon=False, loc="upper right")
  fig.tight_layout()
  save(fig, "fig-chunk-sweep")


def fig_layers():
  fig, ax = plt.subplots(figsize=(3.5, 2.4))
  x = np.arange(len(CHUNKS))
  for i, layer in enumerate(["tbb", "omp", "workqueue"]):
    rows = load(ROOT / "exp008-layers" / f"results-{layer}.csv")
    y, err = pick(rows, kernel="poly32", n=1048576, threads=28)
    ax.errorbar(x, y, yerr=err, color=COLORS[i], marker="o", ms=3, lw=1.2,
                capsize=2, elinewidth=0.8, label={"omp": "OpenMP"}.get(layer, layer))
  ax.set_xticks(x, CHUNK_LABELS)
  ax.set_xlabel("chunk size (elements)")
  ax.set_ylabel("GFLOP/s")
  ax.legend(frameon=False)
  fig.tight_layout()
  save(fig, "fig-layers")


def fig_heatmap(rows):
  kernels = sorted({r["kernel"] for r in rows})
  sizes = sorted({int(r["n"]) for r in rows})
  grid = np.empty((len(kernels), len(sizes)))
  for i, k in enumerate(kernels):
    for j, n in enumerate(sizes):
      y, _ = pick(rows, kernel=k, n=n, threads=28)
      grid[i, j] = max(y[1:]) / y[0]  # best chunked vs static
  fig, ax = plt.subplots(figsize=(5.2, 3.2))
  im = ax.imshow(grid, cmap="viridis", aspect="auto")
  ax.set_xticks(range(len(sizes)), [f"{n // 1024 // 1024}M" if n >= 1 << 20
                                    else f"{n // 1024}K" for n in sizes])
  ax.set_yticks(range(len(kernels)), kernels)
  ax.set_xlabel("array size (elements)")
  mid = (grid.min() + grid.max()) / 2
  for i in range(len(kernels)):
    for j in range(len(sizes)):
      ax.text(j, i, f"{grid[i, j]:.2f}", ha="center", va="center", fontsize=7,
              color="black" if grid[i, j] > mid else "white")
  fig.colorbar(im, ax=ax, label="best-chunk speedup over static", shrink=0.85)
  fig.tight_layout()
  save(fig, "fig-heatmap")


if __name__ == "__main__":
  rows7 = load(ROOT / "exp007-chunk-grid" / "results.csv")
  fig_chunk_sweep(rows7)
  fig_layers()
  fig_heatmap(rows7)

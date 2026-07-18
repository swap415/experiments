#!/bin/bash
# swaps the patched workqueue.so into the venv, runs the bench, restores.
# NOTE: uv hardlinks venv files to its cache — always rm before cp (never
# write through the inode) and call .venv/bin/python directly (uv run may
# re-sync and re-link mid-experiment). Learned the hard way.
set -e
cd "$(dirname "$0")"
# ABSOLUTE path: the EXIT trap fires after a later `cd ..`; a relative path
# here silently "restored" a different venv's numba install. Learned twice.
SO=$(cd ../.venv && pwd)/lib/python3.12/site-packages/numba/np/ufunc/workqueue.cpython-312-x86_64-linux-gnu.so
ORIG_SHA=602bd87809fcaaa3f32b12ea4b551387cba323428e5b0864ad85c11843c764a1

echo "$ORIG_SHA  $SO" | sha256sum -c --quiet  # refuse to run on a dirty venv
cp "$SO" /tmp/workqueue.orig.so
restore() {
  rm -f "$SO" && cp /tmp/workqueue.orig.so "$SO"
  echo "$ORIG_SHA  $SO" | sha256sum -c --quiet && echo "venv restored (sha verified)"
}
trap restore EXIT

./build.sh
rm -f "$SO" && cp build/workqueue.cpython-312-x86_64-linux-gnu.so "$SO"
cd .. && .venv/bin/python exp009-weighted-runtime/bench.py

#!/bin/sh
# WS-CONF-3 standing control: compile and run the
# differentiation battery (gate/grad.id) against the
# staged homes (lib/wsp/agent.id, lib/wsp/numeric.id,
# lib/wsp/grad.id). Shape copied from gate/numeric.sh.
# IDOL_BIN overrides the compiler; the default is the
# standing tree's binary.
set -u
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT=$(dirname "$HERE")
BIN=${IDOL_BIN:-$ROOT/../../../idol-wsp-build/tree/zig-out/bin/idol}
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
"$BIN" compile "$HERE/grad.id" --backend=c --emit=exe --libc -o "$WORK/grad" || exit 1
"$WORK/grad"

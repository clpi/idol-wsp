#!/bin/sh
# WS-CONF-2 standing control: compile and run the numeric
# battery (gate/numeric.id) against the staged homes
# (lib/wsp/agent.id, lib/wsp/numeric.id). Shape copied from
# gate/retract.sh. IDOL_BIN overrides the compiler; the
# default is the standing tree's binary.
set -u
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT=$(dirname "$HERE")
BIN=${IDOL_BIN:-$ROOT/../../../idol-wsp-build/tree/zig-out/bin/idol}
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
"$BIN" compile "$HERE/numeric.id" --backend=c --emit=exe --libc -o "$WORK/numeric" || exit 1
"$WORK/numeric"

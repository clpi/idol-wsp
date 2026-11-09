#!/bin/sh
# WS-CONF-4 standing control: compile and run the revision
# battery (gate/revision.id) against the staged homes
# (lib/wsp/agent.id, lib/wsp/numeric.id). Shape copied from
# gate/numeric.sh. IDOL_BIN overrides the compiler; the
# default is the standing tree's binary.
set -u
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT=$(dirname "$HERE")
BIN=${IDOL_BIN:-$ROOT/../../../idol-wsp-build/tree/zig-out/bin/idol}
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
"$BIN" compile "$HERE/revision.id" --backend=c --emit=exe --libc -o "$WORK/revision" || exit 1
"$WORK/revision"

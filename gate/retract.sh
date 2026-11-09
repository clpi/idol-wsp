#!/bin/sh
# gate/retract.sh — standing control for the weight semantics
# conformance fixes (record:
# research/weight-semantics-conformance-2026-11-08.md in the
# main tree's workspace). Compiles the two battery programs
# with the compiler from the tree under test and runs both:
# gate/retract.id (the retraction cluster, chapter examples
# 14-24, plus the cone depth case) and gate/retract-faces.id
# (the three-state standing face, seating identity, and the
# same / content / numeric predicates).
#
# Usage: IDOL_BIN=/path/to/idol sh gate/retract.sh
# IDOL_BIN defaults to the workspace staged tree's binary.
# Exit: 0 = both batteries pass; 1 = a named battery failed.

set -u
BIN=${IDOL_BIN:-"$HOME/workspace/idol-wsp-build/tree/zig-out/bin/idol"}
[ -x "$BIN" ] || { echo "retract gate: FAIL - no compiler at $BIN" >&2; exit 1; }
D=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
WORK=$(mktemp -d "${TMPDIR:-/tmp}/retractgate.XXXXXX")
trap 'rm -rf "$WORK"' EXIT

runone() {
    name=$1
    "$BIN" compile "$D/$name.id" --backend=c --emit=exe --libc \
        -o "$WORK/$name" > "$WORK/$name.compile.log" 2>&1 ||
        { echo "retract gate: FAIL - $name did not compile" >&2
          tail -5 "$WORK/$name.compile.log" >&2; exit 1; }
    "$WORK/$name" || { echo "retract gate: FAIL - $name" >&2; exit 1; }
}

runone retract
runone retract-faces
runone retract-predicates
echo "retract gate: PASS"

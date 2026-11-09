#!/bin/sh
set -eu

HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT=$(dirname "$HERE")
: "${IDOL_ROOT:?Set IDOL_ROOT to the compiler root containing lib and tools}"
BIN=${IDOL_BIN:-$IDOL_ROOT/zig-out/bin/idol}
ARTIFACTS=${WSP_ARTIFACTS:-${TMPDIR:-/tmp}}
mkdir -p "$ARTIFACTS"
STAGE=$(mktemp -d "$ARTIFACTS/wsp-core.XXXXXX")
mkdir -p "$STAGE/zig-out/bin" "$STAGE/lib/wsp" "$STAGE/tools/node/dev" "$STAGE/gate" "$STAGE/wsp/src" "$STAGE/wsp/gate" "$STAGE/learned" "$STAGE/results"
cp "$BIN" "$STAGE/zig-out/bin/idol"
cp -R "$IDOL_ROOT/lib/." "$STAGE/lib/"
cp -R "$IDOL_ROOT/tools/node/dev/grammar" "$STAGE/tools/node/dev/"
cp "$IDOL_ROOT/gate/d1-hash-runtime.c" "$STAGE/gate/"
cp "$ROOT/src/agent.id" "$ROOT/src/numeric.id" "$ROOT/src/grad.id" "$STAGE/lib/wsp/"
cp "$ROOT/src/agent.id" "$ROOT/src/numeric.id" "$ROOT/src/grad.id" "$STAGE/wsp/src/"
cp "$ROOT/learned/bundle.txt" "$STAGE/learned/bundle.txt"
for name in agent withdrawal identity intent numeric revision grad retract additive standing bundle
do
    cp "$HERE/$name.id" "$STAGE/wsp/gate/"
done

if command -v sha256sum >/dev/null 2>&1
then
    (cd "$STAGE" && sha256sum zig-out/bin/idol lib/wsp/*.id wsp/src/*.id wsp/gate/*.id learned/bundle.txt) > "$STAGE/inputs.sha256"
else
    (cd "$STAGE" && shasum -a 256 zig-out/bin/idol lib/wsp/*.id wsp/src/*.id wsp/gate/*.id learned/bundle.txt) > "$STAGE/inputs.sha256"
fi

cat > "$STAGE/run.sh" <<'RUN'
#!/bin/sh
set -eu
STAGE=$1
cd "$STAGE"
for name in agent withdrawal identity intent numeric revision grad retract additive standing bundle
do
    printf 'Compiling %s\n' "$name"
    if ! "$STAGE/zig-out/bin/idol" compile --no-cache --backend=c --emit=exe --libc "$STAGE/wsp/gate/$name.id" -o "$STAGE/results/$name" > "results/$name.compile.stdout" 2> "results/$name.compile.stderr"
    then
        cat "results/$name.compile.stderr"
        exit 1
    fi
    if ! "results/$name" > "results/$name.stdout" 2> "results/$name.stderr"
    then
        cat "results/$name.stdout" "results/$name.stderr"
        exit 1
    fi
    tail -n 3 "results/$name.stdout"
done
RUN

printf 'Artifacts: %s\n' "$STAGE"
sh "$IDOL_ROOT/tools/node/dev/idol-lock" --timeout "${IDOL_LOCK_TIMEOUT:-60}" -- sh "$STAGE/run.sh" "$STAGE"

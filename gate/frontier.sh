#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
: "${IDOL_ROOT:?Set IDOL_ROOT to the compiler source root}"
idol=${IDOL_BIN:-$IDOL_ROOT/zig-out/bin/idol}
artifacts=${WSP_ARTIFACTS:-${TMPDIR:-/tmp}}
mkdir -p "$artifacts"
stage=$(mktemp -d "$artifacts/wsp-frontier.XXXXXX")
mkdir -p "$stage/zig-out/bin" "$stage/lib/wsp" "$stage/gate" "$stage/result" "$stage/tools/node/dev"
ln "$idol" "$stage/zig-out/bin/idol"
cp -R "$IDOL_ROOT/lib/." "$stage/lib/"
cp -R "$IDOL_ROOT/tools/node/dev/grammar" "$stage/tools/node/dev/"
cp "$IDOL_ROOT/gate/d1-hash-runtime.c" "$stage/gate/"
cp "$root/src/agent.id" "$root/src/numeric.id" "$root/src/grad.id" "$stage/lib/wsp/"
cp "$root/gate/merge.id" "$root/gate/ridge.id" "$root/gate/revision.id" "$root/gate/additive.id" "$stage/gate/"
printf 'Artifacts: %s\n' "$stage"
cat > "$stage/run.sh" <<'RUN'
#!/bin/sh
set -eu
stage=$1
cd "$stage"
sha256sum zig-out/bin/idol lib/wsp/*.id gate/*.id > result/input.sha256
for name in merge ridge revision additive
do
    "$stage/zig-out/bin/idol" check "gate/$name.id" > "result/$name.check" 2>&1
    if ! "$stage/zig-out/bin/idol" compile --no-cache --backend=c --emit=exe --libc "gate/$name.id" -o "result/$name" > "result/$name.compile" 2>&1; then
        cat "result/$name.compile"
        exit 1
    fi
    if ! "result/$name" > "result/$name.stdout" 2> "result/$name.stderr"; then
        cat "result/$name.stdout" "result/$name.stderr"
        exit 1
    fi
    tail -n 3 "result/$name.stdout"
done
for name in merge ridge
do
    if ! "$stage/zig-out/bin/idol" compile --no-cache "gate/$name.id" -o "result/native-$name" > "result/native-$name.compile" 2>&1; then
        cat "result/native-$name.compile"
        exit 1
    fi
    if ! "result/native-$name" > "result/native-$name.stdout" 2> "result/native-$name.stderr"; then
        cat "result/native-$name.stdout" "result/native-$name.stderr"
        exit 1
    fi
    tail -n 3 "result/native-$name.stdout"
done
cp lib/wsp/numeric.id result/numeric.id
sed 's/support = joined(selection(a), selection(b))/support = ""/' result/numeric.id > lib/wsp/numeric.id
if cmp -s result/numeric.id lib/wsp/numeric.id; then
    printf '%s\n' 'Selection-loss mutation did not change the producer.' >&2
    exit 1
fi
cp lib/wsp/numeric.id result/mutant.id
if ! "$stage/zig-out/bin/idol" compile --no-cache gate/merge.id -o result/mutant > result/mutant.compile 2>&1; then
    cat result/mutant.compile
    exit 1
fi
if result/mutant > result/mutant.stdout 2> result/mutant.stderr; then
    printf '%s\n' 'Selection-loss mutation escaped the independent oracle.' >&2
    exit 1
fi
cp result/numeric.id lib/wsp/numeric.id
sha256sum result/merge result/ridge result/revision result/additive result/native-merge result/native-ridge result/mutant result/*.stdout > result/output.sha256
printf '%s\n' 'Native merge/ridge and selection-loss mutation passed; hosted C regressions passed.'
RUN
sh "$IDOL_ROOT/tools/node/dev/idol-lock" --timeout "${IDOL_LOCK_TIMEOUT:-60}" -- sh "$stage/run.sh" "$stage"

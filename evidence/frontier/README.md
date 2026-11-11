# Exact revision and ridge qualification

Executed 2026-11-11 on Linux x86-64 from the source bytes in
[input.sha256](input.sha256). The compiler binary SHA-256 was
`0554c68da361cdf34fafa0fd6e9fc1a524b29fbf86980e33f2cc056a412902db`.
The producing compiler was the shared current Idol worktree build; that
binary hash identifies the measured input and does not assert an upstream
release tag. The runner checked these input hashes again after execution.

`gate/frontier.sh` exited 0. It compiled `merge` and `ridge` with the
native route (`compile --no-cache`) and executed both. Separately it
compiled `merge`, `ridge`, `revision`, and `additive` with
`--no-cache --backend=c --emit=exe --libc` and executed them. The C runtime
is only the explicitly named hosted regression route.

| Gate | Native assertions | Hosted C assertions |
|---|---:|---:|
| Merge | 27 passed / 0 failed | 27 passed / 0 failed |
| Ridge | 137 passed / 0 failed | 137 passed / 0 failed |
| Existing revision | Not rerun on this route | 227 passed / 0 failed |
| Existing additive | Not rerun on this route | 106 passed / 0 failed |

The runner then replaced `merge`'s selection union with empty support in
an isolated staged copy. That native program compiled and failed five
independent assertions: both selection premises were lost, withdrawn
selection admitted a merge, an old result remained usable, and unknown
selection was silently erased. Its output is [mutant.txt](mutant.txt).
A failed compile would not have counted as this mutation control.

The recorded outputs and [output.sha256](output.sha256) identify the
executed binaries and their stdout. Binaries and temporary dependency
copies are retained outside the repository in the printed stage directory.
No timing, memory, model-quality, concurrent-publication, or global
cross-process event-identity claim follows from this run.

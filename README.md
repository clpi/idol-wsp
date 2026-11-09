# Idol WSP — Idol Weight Space Programming

This repo is an instantiation of Idol's weight space: on-the-fly rewriting
and reweighting experiments. It serves only that. Its end deliverable is an
as-compact-as-possible proof of concept for a live-rewriting coding agent —
highly sophisticated tool use, integrated with Idol Eyes and the MCP
surfaces, extraordinarily compact — that learns on the repos it works in by
rewriting and reweighting its own weight space, in pure Idol throughout.

This repo is the canonical live source of truth for what Idol WSP is and
what exists. If it is not in this repo, it is not canonical. The status
document is updated in the same commit as any landing it describes.

## The three proofs

The deliverable is a proof of concept for three things at once, tracked
separately in [status.md](status.md):

1. **The Idol language** — that it can express and run this, end to end.
2. **The model** — that a model this compact, built this way, does
   sophisticated tool-using coding work.
3. **Weight space programming** — that programming by live rewriting and
   reweighting of first-class weights is a real way to build and teach such
   an agent.

## The bar

Against similar-size models, this agent must outperform by far — beat by
far at equal size, size measured as parameter count plus bits per weight.
The comparison cell, its same-contract terms, and its state (UNMEASURED —
no margin is claimed without a same-contract run) live in
[status.md](status.md). Speed is a deliverable the same way: every landing
carries measurements at a named pin, or states UNMEASURED.

## Documents

- [founding.md](founding.md) — the founding directive and its amendments,
  in Chris's own words.
- [weight-space.md](weight-space.md) — what Idol's weight space is today,
  from the landed record in clpi/idol.
- [status.md](status.md) — what exists and what does not, the three proofs,
  the bar, and every named dependency with its state.
- [spec-slice-one.md](spec-slice-one.md) — the executable spec for slice
  one, the deliverable in miniature.
- [work.md](work.md) — the open work this repo carries.
- [spec-additive-example.md](spec-additive-example.md) — the restricted
  fixed-schema learner and its retained-data rebuild reference.

## Execute the current regression cohort

Supply an Idol compiler root containing its matching `lib/`, runtime
sources and `tools/node/dev/idol-lock`:

```sh
IDOL_ROOT=/absolute/path/to/idol sh gate/core.sh
```

`IDOL_BIN` can select a specific compiler binary. `WSP_ARTIFACTS` can
select the parent directory for retained results. The runner copies
the binary, dependency files and WSP homes into an isolated root,
records input hashes, and compiles each gate with
`--no-cache --backend=c --emit=exe --libc` under the shared compiler
lock. It retains compiler output, executable output and the generated
executables in the printed artifact directory.

This is the hosted C qualification route. Its regression results do
not assert native dependency-free execution or full core-profile
conformance. The dated execution record in [status.md](status.md)
names the exact binary, dependency tree, executed checks and open
boundaries.

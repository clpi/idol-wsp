# Status

The state of Idol WSP, stated plainly. This document is updated in the
same commit as any landing it describes. Claims here carry their
evidence or are marked UNMEASURED / UNVERIFIED / OPEN.

## The three proofs, tracked separately

### 1. The language — OPEN, with landed evidence at the weight layer

The upstream weight-space slice runs end to end in Idol and its battery
is green at its pin (see [weight-space.md](weight-space.md)): the
language today expresses weight tables as checked values and as
premises, premise digests, and fall-and-stand derivations. The WSP agent
now exists in this repo (`src/agent.id`, home `wsp.agent`): the whole
slice-one loop — seatings, derivations, the tool surface, learning,
retraction — is expressed in Idol over the landed faces, against the
spec. Its battery (`gate/agent.id`, cases B1–B15) is implemented; its
execution is staged, not yet run (see W1 in [work.md](work.md): the
build VM's prebuilt compiler currently dies with an illegal instruction
inside its own sha2 on the sandbox's present CPU placement — an
environment fault, reproduced on the known-good control program; the
substrate control battery itself ran green at the pin in this staging,
36 ok / 0 fail). The language proof for the deliverable stays OPEN
until slice one's battery runs green in this repo.

### 2. The model — OPEN, does not exist

No model in this repo exists yet. Nothing has been measured. The model
proof closes only when the slice-one agent performs its fixture coding
task through the specified loop and the comparison cell below has a
same-contract run.

### 3. Weight space programming — OPEN, mechanism landed upstream

Programming by premise-bound weights is landed and batteried upstream
(a read weight's change invalidates exactly its dependents; an unread
weight's change leaves derivations standing). Programming and *teaching
an agent* by live reweighting — the claim this repo exists to test — is
implemented in this repo: the learning rule publishes a learned seating
citing the outcomes it was learned from, and the battery carries the
cone-retraction cases (B5, B10), the persistence case (B11), and the
lookup-count case (B13). The claim is unproven until that battery runs
green; its execution is staged on the same condition as the language
proof above.

## The bar — comparison cell WSP-BF1

- **Claim under test:** at equal size, the WSP agent outperforms
  similar-size models by far on tool-using coding work.
- **Same-contract terms:** same tasks (the slice battery task set, held
  fixed for the run); same tool surface (the fixture surface of
  [spec-slice-one.md](spec-slice-one.md), or its live successor when
  both sides run against it); size = parameter count plus bits per
  weight, the bits stated in the three-number accounting below.
- **Incumbent class:** models in the same parameter band as the WSP
  agent's measured parameter count at the run's pin.
- **State: UNMEASURED.** No same-contract run exists. No margin is
  claimed, implied, or forecast anywhere in this repo. The run is work
  order W2 in [work.md](work.md).

## Compactness accounting

Compactness is a measured property, reported in three numbers that are
never mixed (the accounting rule adopted from the Idiom program's
record): **payload** bits per weight; **wire** bits per weight (payload
plus metadata); **carrier** bits per weight, for any form that carries
codes inside a wider value. Alongside them: the parameter count. Slice
one's battery asserts the fixture's three numbers against hand-computed
values; every landing restates them at its pin in this document.

At this landing (by the fixture's definition, before the staged
battery run): parameter count **14** (choice 6 + caution 6 + spare 2,
spec section 9); payload **32** bits per weight (the seated f32 word);
carrier **32** (no wider carrier is used); wire is the one number
that must come from the executed battery — the accounting face
computes 8 × seating bytes / values per table and case B12 asserts it
against the same formula computed in the battery — so wire reads
**staged, not yet measured** until W1's run.

## What exists today (2026-11-07)

- This repo's founding documents and the slice-one spec.
- Slice one's implementation, landed in this repo in the same commit
  as this status: the agent (`src/agent.id`), its battery
  (`gate/agent.id`, cases B1–B15), and the section 10 speed program
  (`gate/measure.id`). Execution of the battery and the speed program
  is staged (W1); no executed verdict is claimed for them yet.
- Upstream in clpi/idol, landed: the weight-space surface and its green
  battery (PR #1911), the digest face, the premise machinery, the
  substrate admission and resident producers — all as recorded in
  [weight-space.md](weight-space.md). The substrate control battery
  was re-executed in this slice's staging at the pin
  (clpi/idol 7ad63393, the compiler build of record): 36 ok / 0 fail /
  exit 0, closing line as recorded upstream; the link required the
  tree's own hash-runtime supplement (`gate/d1-hash-runtime.c`,
  upstream gap G-hashrt-c99) beside the C runtime shim.

## What does not exist

- An executed verdict for this repo's battery or speed program:
  both are implemented and staged to run (W1). Speed UNMEASURED;
  the bar cell UNMEASURED.
- The learned bundle artifact (`learned/bundle.txt`): it is produced
  by the battery's case B11 print and lands with the execution
  commit, not before — no bundle is claimed from an unrun battery.
- The compiler integration of Idiom (spec-only upstream; see below).
- A live MCP binding and a live Idol Eyes feed binding for this
  program (slice one specifies a fixture surface and a recorded
  observation stream; live bindings are later work, W3).

## Named dependencies, with their state

**Landed, consumed by slice one (in clpi/idol):**

- The weight-space surface — `lib/ml/space.id`: seat, tensors, digest,
  derive, records, stands (PR #1911, merged 9cc4d731).
- The digest face — `lib/compiler/digest.id` (sha256 over zero-free
  canonical forms).
- The premise machinery — witness, tally, derive in `lib/compiler`;
  withdrawal invalidates exactly the premise cone.
- The substrate producers — `lib/ml/model.id` (admission; the landed
  face of idol-model consumed here) and `lib/ml/resident.id`.
- The one derivation machinery's premise format — weight-space facts
  citable and retractable in the shared format.

**Landed upstream, consumed as mechanism and law:**

- The state-machines world kernel's premise and withdrawal machinery
  (stages landed in clpi/idol per its program record). Slice one's
  learning safety property — a corrected premise retracts exactly what
  was learned from it — is this machinery's withdrawal law. The kernel
  handler port is staged upstream, not landed, and is NOT consumed.

**Spec-only upstream, consumed as law or contract, never as code:**

- **Idiom** — spec complete and registered spec-complete (2026-10-30);
  its compiler integration is not built. Consumed here as law: learned
  proposals enter as premises under the checker, never as facts.
- **idol-model beyond admission** — the fuller model-building surface
  is spec-only; slice one consumes only the landed admission producer.
- **Idol Eyes** — the product surface is landed in clpi/idol-eyes;
  slice one consumes observations as premises through a recorded
  stream, per its spec. The live binding is W3.
- **The MCP surfaces** — slice one specifies and builds against a
  fixture tool surface defined in its spec. The live binding is W3.

## Host seams

One, named at this landing: slice one's execution route at its pin is
the compiler's C route — the same route the upstream weight-space
battery ran on — with the tree's C runtime shim and the tree's own
hash-runtime supplement at the link. No foreign code is in this repo;
the route is upstream scaffolding whose elimination is the upstream
pure-Idol program's standing work, and this repo's claims are stated
for the route actually run, never upgraded past it. Standing rule,
from the founding directive: any unavoidable host seam is named in
this section as a defect with its elimination path, in the same
commit that introduces it. A seam that appears in code without
appearing here is a defect in this document, and the landing that
introduced it is not complete until both are fixed.

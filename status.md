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
itself does not exist yet, so the language proof for the deliverable —
Idol expressing and running the whole agent — is OPEN. It closes only
when slice one's battery runs green in this repo.

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
unproven until slice one's learning battery (its cone-retraction cases)
runs green.

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

## What exists today (2026-11-07)

- This repo's founding documents and the slice-one spec.
- Upstream in clpi/idol, landed: the weight-space surface and its green
  battery (PR #1911), the digest face, the premise machinery, the
  substrate admission and resident producers — all as recorded in
  [weight-space.md](weight-space.md).

## What does not exist

- Any code in this repo. The agent, the model, the tool-use loop, and
  the learning loop are specified, not built.
- Any measurement of this program: speed UNMEASURED, compactness
  UNMEASURED, the bar cell UNMEASURED.
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

None in this repo: there is no code here yet, and no seam has been
admitted. Standing rule, from the founding directive: any unavoidable
host seam is named in this section as a defect with its elimination
path, in the same commit that introduces it. A seam that appears in
code without appearing here is a defect in this document, and the
landing that introduced it is not complete until both are fixed.

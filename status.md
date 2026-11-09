# Status

The state of Idol WSP, stated plainly. This document is updated in the
same commit as any landing it describes. Claims here carry their
evidence or are marked UNMEASURED / UNVERIFIED / OPEN.

## The three proofs, tracked separately

### 1. The language — slice-one battery green at the pin

The upstream weight-space slice runs end to end in Idol and its battery
is green at its pin (see [weight-space.md](weight-space.md)): the
language today expresses weight tables as checked values and as
premises, premise digests, and fall-and-stand derivations. The WSP agent
now exists in this repo (`src/agent.id`, home `wsp.agent`): the whole
slice-one loop — seatings, derivations, the tool surface, learning,
retraction — is expressed in Idol over the landed faces, against the
spec. Its battery (`gate/agent.id`, cases B1–B15) has been executed at
the pin, on bytes identical to the ones landed in this repo: **pass 126
/ skip 0 / fail 0 / total 126, exit 0, closing line "battery: OK"** —
pin clpi/idol 7ad63393f2748a24b907182ce8820c785e79915c, the clean pin
compiler (C route), run on the Mac mini. The landed home and gate match
the executed candidate byte for byte (home md5
9b2d7bf02ed67e9c0b7f698d90516c92, gate md5
e1029698964ee4ec8ab4d2a25a1dab89; landed in commit
61197dfe783f5ae733b2cc280fe278c0d6b8cc68). The measure gate
(`gate/measure.id`) also compiles and runs at the pin, exit 0; no
timing was taken in that run, so slice speed stays UNMEASURED.

That first execution did real work on both sides of the boundary. It
convicted two defects in the home, both fixed in the landed bytes: a
reweight fell records beyond its readers (case B3; the fix carries two
tiers — the full check for a record's own standing, and existence-only
falls through derivation citations), and load appended a generation
instead of replacing the instance, so caller handles addressed the
stale generation (case B11; the fix allocates by generation ordinal
and records each book entry's own offset, with sealed marks). It also
convicted three defects in the compiler at the pin — open compiler
work orders in clpi/idol, not defects of this home — around which the
landed bytes carry semantics-preserving accommodations, named under
"Named dependencies" below. The substrate control battery itself ran
green at the pin in this staging, 36 ok / 0 fail. This proof's stated
condition — slice one's battery runs green in this repo — is met at
the pin, on the landed bytes.

### 2. The model — OPEN, does not exist

No model in this repo exists yet. Nothing has been measured. The model
proof closes only when the slice-one agent performs its fixture coding
task through the specified loop and the comparison cell below has a
same-contract run.

### 3. Weight space programming — mechanism executed at the pin

Programming by premise-bound weights is landed and batteried upstream
(a read weight's change invalidates exactly its dependents; an unread
weight's change leaves derivations standing). Programming and *teaching
an agent* by live reweighting — the claim this repo exists to test — is
implemented in this repo: the learning rule publishes a learned seating
citing the outcomes it was learned from, and the battery carries the
cone-retraction cases (B5, B10), the persistence case (B11), and the
lookup-count case (B13). That battery has now run green at the pin (the
execution recorded under proof 1): the cone-retraction cases retract
exactly their cones, the persistence case reproduces every standings
answer after a reload, and the lookup-count case reads the specified
counts (5, 6, 5, 9). The mechanism claim is therefore executed evidence
at the pin. What remains unproven is the comparison: whether the agent
so taught outperforms similar-size models is proof 2's cell, and it
stays UNMEASURED.

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

At this landing (values as executed in case B12 of the green run at
the pin): parameter count **14** (choice 6 + caution 6 + spare 2, spec
section 9); payload **32** bits per weight (the seated f32 word);
carrier **32** (no wider carrier is used); wire — case B12 asserts, per
table, that the accounting face's wire figure equals 8 × seating bytes
/ values in the table, computed independently in the battery from the
fixture's own seating bytes, and that payload is at or under wire;
every assertion passed in the executed run.

## What exists today (2026-11-08)

- This repo's founding documents and the slice-one spec.
- The weight-semantics chapter
  ([weight-semantics.md](weight-semantics.md)) — a candidate
  specification, received by relay on 2026-11-08 and landed the
  same day: the core model, typing and evaluation rules, learning
  and retraction by reconstruction, differentiation, and the
  serialization contract the machinery is reconciled against. The
  author's own correction of 2026-11-08 states that the chapter's
  strongest guarantee — every learned change premise-tracked and
  exactly retractable — is an obligation the design states, not
  yet a consequence the design establishes: dependency
  completeness is unspecified, and several contracts the author
  named are not fully specified. The received text carries the
  governing semantics with examples 1 to 24 in full; the exact
  transport record forms, examples 25 to 42 in full, and 6 of the
  16 decision entries were not in the relay and are named as
  outstanding in the chapter file itself. The author's corrected
  chapter file, including its adversarial review, has likewise not
  been received as a file. Every Idol implementation and
  performance claim in the chapter is UNMEASURED, as the chapter
  itself states.
- Slice one, landed in this repo (commit
  61197dfe783f5ae733b2cc280fe278c0d6b8cc68): the agent
  (`src/agent.id`), its battery (`gate/agent.id`, cases B1–B15), and
  the section 10 speed program (`gate/measure.id`).
- The executed battery verdict at the pin (clpi/idol
  7ad63393f2748a24b907182ce8820c785e79915c, the clean pin compiler, C
  route, run on the Mac mini): pass 126 / skip 0 / fail 0 / total 126,
  exit 0, closing line "battery: OK", on bytes identical to the landed
  commit. The measure gate compiles and runs at the pin, exit 0; it
  was run as a compile-and-run check only — no wall times were taken.
- The learned bundle artifact (`learned/bundle.txt`), extracted from
  the B11 print of a green re-run of the battery at the pin on bytes
  identical to the landed commit (the re-run arm of W5 in
  [work.md](work.md)): the print states bundle bytes 11030, and the
  landed file is 11030 bytes.
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

- A conformance battery for the chapter's 42 stated-outcome
  examples: the set is registered as the weight machinery's
  conformance target, no example has been run in Idol, and building
  the battery is a recorded work order on the fleet side.

- A timing measurement for slice one: the speed program has been
  compiled and run at the pin but never timed. Speed UNMEASURED; the
  bar cell UNMEASURED.
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

**Open upstream — compiler work orders in clpi/idol, accommodated in
the landed bytes:**

Slice one's first execution convicted three defects in the compiler
at the pin. Each is a compiler defect, not a defect of this home:
each was convicted with a standalone control program carrying no WSP
code, and each carries its own fix lane upstream. The landed bytes
accommodate each with a semantics-preserving form; when an upstream
fix lands, its accommodation comes out and the battery re-runs at the
new pin.

- **Work order 3 — two-form table seating.** The C realizer seats a
  module table in one of two forms: a hash form whose absent reads
  yield nil, or a bounded inline-array form whose reads abort ahead of
  the realizer's own nil path. Which form a table gets follows the
  module survey's whole-graph classification, so a source-preserving
  restructure silently flips a table between running and trapping.
  Accommodation: init pre-seeds the role tables and the parts lengths
  over their full index ranges, so no absent read of them is taken.
- **Work order 4 — table values in record fields.** A table stored
  into a module record field does not read back: the split and the
  store survive, and the first read through the field faults. The same
  shape is refused outright in a root gate — admitted in library mode,
  refused in root mode, broken in both. Accommodation: split's four
  parts tables live in module tables, not record fields.
- **Work order 5 — concatenation truncates at a zero byte.** The C
  realizer's string concatenation copies each operand under a
  NUL-terminated discipline while lengths are tracked separately, so
  concatenating binary strings silently drops everything after the
  first zero byte (measured byte for byte against a control: the
  corruption differed at 80 positions, the target byte unchanged).
  This defect, not the battery's expectation, is what first failed
  case B7. Accommodation: the gate builds its one-byte-corrupted
  fixture through the byte-table idiom, so B7 measures the intended
  read-back refusal; the defect keeps its own control upstream.

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

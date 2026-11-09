# Spec — slice one: the deliverable in miniature

Status: written before code, per the standing spec-first law. A spec is
agent-proof when two implementers given only this document agree on every
battery case; a disagreement is a defect in this spec, recorded here,
never settled by an implementer's taste. Nothing in this repo claims the
agent exists until this spec's battery runs green at a named pin.

## 1. Purpose

Slice one is the smallest end-to-end loop that is honestly the end
deliverable in miniature: a pure-Idol agent whose behavior is derived
from a live weight space, which performs a small coding task by issuing
tool calls, whose every choice is a premise-tracked derivation, which
learns from the task by reweighting — and whose learning is exactly
retractable when a premise it learned from is corrected. It runs against
a fixture tool surface and a recorded observation stream, so the battery
is deterministic. Live surfaces are slice two (work order W3).

## 2. Definitions

- **Weight table.** Contents plus a shape descriptor, as the landed
  upstream surface defines it (see [weight-space.md](weight-space.md)).
- **Seating.** A weight table admitted into the pool through the
  upstream surface's seat face. There is no mutation face: a changed
  table is a new seating. **Reweighting means re-seating.**
- **Premise.** A fact a derivation depends on, with an immutable
  occurrence identity. In this fixture, premise and seating occurrences
  use their generation-local registration rows, rendered as fixed-width
  tagged identities. A content digest describes the statement or table;
  it does not merge separate occurrences. For a repo fact or observation,
  the statement form is its text. The original slice requirement to
  refuse zero-byte statement text is not implemented by the current
  premise face and is not a delivered guarantee. A rule is named by its rule version word. These are
  the slice's explicit faces, not a claim that its local row handles
  implement the chapter's complete authoritative identity contract.
- **Premise record.** What a derivation publishes: { the identities of the
  weight seatings read, the rule version word, the identities of the other
  premises cited, the output digest }. The upstream record shape,
  extended by the citation table of section 5 — never a private format.
- **Derivation.** A published choice together with its premise record.
  A derivation **stands** when the standing face validates its complete
  recorded support and required table rows. A changed row or shape can
  invalidate its readers; explicit withdrawal invalidates every reader
  of that exact occurrence, even after identical content is re-seated.
  Unresolved citations block current use.
- **Result premise.** The outcome of an executed tool call. Its premise
  set contains the output digest of the derivation that chose the call,
  plus the identities of any observation rows the citation table names
  as corroborating it.
- **Learned seating.** A new seating of a weight table published by the
  learning rule (section 7), whose premise record cites the outcomes it
  was learned from. Learned state persists as the bundle of seatings
  plus their premise records, tied to a repo by the digests of the repo
  premises in its cone.
- **Fixture surface.** The three-tool surface of section 6. **Recorded
  stream.** The Idol Eyes observation rows of section 6, supplied as
  data.

## 3. Substrate consumed, by name

Landed in clpi/idol, consumed as code (states per
[status.md](status.md)): the weight-space surface `lib/ml/space.id`
(faces: seat, tensors, digest, derive, records, stands); the digest face
`lib/compiler/digest.id`; the premise machinery (witness, tally,
derive) including its law that withdrawal invalidates exactly the
premise cone; the substrate admission and resident producers
(`lib/ml/model.id`, `lib/ml/resident.id`). Consumed as law, not code:
Idiom's rule that learned proposals enter as premises under the checker,
never as facts; the world kernel's withdrawal law as the learning
loop's safety property. Not consumed: the kernel handler port (staged
upstream, not landed); any live MCP binding; any live Idol Eyes feed.

## 4. The fixture

All battery cases start from this fixture state unless a case states a
sequence. Fixture weights are integers 0–9, so every sum below is exact.

**Tables** (shape, then values in row order):

- `choice`, shape [3, 2] — one row per task kind (read, write, run),
  one value per candidate, in the candidate order of section 5:
  read [5, 3]; write [4, 4]; run [2, 6].
- `caution`, shape [3, 2], same layout: read [0, 0]; write [0, 0];
  run [0, 1].
- `spare`, shape [2]: [7, 7]. No derivation in the fixture cites it.

**Repo facts** (premises; identities by section 2):

- P1: "the target file is f"
- P2: "the check command is c"
- P3: "the tree has one file" — cited by nothing; it exists to prove a
  withdrawal can retract the empty set.

**Observation row** (from the recorded stream):

- Q1: "the read of f returned the expected digest" — corroborates the
  first result premise, per the citation table.

**Rules.** Step derivations run under rule version word `derive-1`.
Learning runs under rule version word `learn-1`. Rule version words are
premises in every record they govern.

Seatings are produced by the slice's builder face from the value tables
above, through the substrate admission route. The battery asserts
behavior, standings, and record contents by recomputation — never
literal seating bytes, which are the substrate's business.

## 5. The step derivation

The fixture task is three steps, in order, of kinds read, write, run.
Each kind has two candidates, in this fixed order:

- read: **read-a** "read file f"; **read-b** "read the whole tree".
- write: **write-a** "write file f"; **write-b** "write file g".
- run: **run-a** "run check c on file f"; **run-b** "run check c on the
  whole tree".

For a step of a given kind, the derivation computes, for each candidate,
its **score** (the `choice` row value for that candidate) and its
**caution sum** (the `caution` row value). A candidate with caution sum
greater than 0 is vetoed. The chosen candidate is the non-vetoed
candidate with the highest score; ties go to the earliest candidate in
the order above. If every candidate is vetoed, or the chosen candidate
names a tool not on the fixture surface, the step publishes UNKNOWN for
that step and the loop halts by name — never a guessed call. A step
whose cited result premise has fallen likewise publishes UNKNOWN and
halts by name.

Expected fixture choices: **read-a** (5 over 3), **write-a** (tie 4–4,
earliest wins), **run-a** (run-b scores 6 but its caution sum 1 vetoes
it; run-a stands at 2). Expected executed sequence: read-a, write-a,
run-a.

**Citation table** — each step derivation and result cites exactly:

| record | weight tables | facts | results | observations |
|---|---|---|---|---|
| step 1 (read) derivation | choice, caution | P1 | — | — |
| result O1 | (via step 1) | — | — | Q1 |
| step 2 (write) derivation | choice, caution | P1 | O1 | — |
| result O2 | (via step 2) | — | — | — |
| step 3 (run) derivation | choice, caution | P2 | — | — |
| result O3 | (via step 3) | — | — | — |
| learned `choice` seating | choice (original) | — | O1, O2, O3 | — |

A result premise's own premise set is { the choosing derivation's
output digest } plus the observations its row names. Cones are computed
over exactly these citations; nothing else is a premise of anything in
the fixture.

## 6. Tool surface and observation stream

The fixture surface carries three tools: read, write, run. A tool call
is the envelope { tool name, argument statement, result statement };
its identity is the sha256 of its argument statement form. The surface
executes the fixture calls deterministically: read-a returns "the
contents of f"; write-a returns "f written"; run-a returns "check c
passed". Calls to read-b, write-b, run-b, if ever chosen, return their
own stated results — the battery's interest in them is which call was
chosen, not the payload. A call naming a tool outside the surface is
the UNKNOWN case of section 5.

The recorded stream supplies exactly Q1 (section 4), delivered with
result O1. A later contradicting row withdraws an earlier observation
premise by name (battery case B10 supplies the contradicting row
"the read of f returned a different digest", identity Q2).

## 7. Learning

When the fixture task completes, the learning rule `learn-1` publishes
a learned seating of `choice`: for each kind, the chosen candidate's
value increases by 1, capped at 9; unchosen values are unchanged. From
the fixture: read [6, 3]; write [5, 4]; run [3, 6]. The learned
seating's premise record cites exactly { the original `choice` digest,
O1, O2, O3 } under rule version `learn-1`. Under the learned seating,
re-derived steps choose the same sequence (run-b remains vetoed) with
scores 6, 5, 3.

Learning is reweighting under premises — nothing else in this slice is
called learning. There is no gradient, no training set, no hidden
state: the learned bundle is seatings plus premise records, and every
element of it stands or falls by the stands face.

**The safety property.** Withdrawing any premise retracts exactly the
learned seatings and derivations in its cone — no more (unrelated
learning stands), no less (nothing learned from a corrected fact
survives it). This is the upstream withdrawal law, inherited, and
battery cases B5 and B10 exist to prove it holds in this slice.

## 8. Representation law

Identity-keyed from the first commit (the state-machines kernel's
measured defect — cost a high power of object count under a text-rescan
mechanism — is this program's standing warning, and is designed out
here, not measured later):

- Tables, premises, and records are held in tables keyed by identity.
  Content digests are separate from occurrence references. Premise sets
  are identity sets. No operation in the loop
  rescans a text representation to answer a membership, standing, or
  cone question.
- The slice exposes a **lookup counter**: one count for each
  identity-keyed read performed by a derivation or by learning. By the
  definitions above, a step derivation performs
  2 × (candidates in its kind) + (premises it cites) lookups, and
  learning performs (values in `choice`) + (outcomes cited) lookups.
  Fixture expectations: step 1 = 2×2 + 1 = 5; step 2 = 2×2 + 2 = 6;
  step 3 = 2×2 + 1 = 5; learning = 6 + 3 = 9. The battery asserts these
  counts exactly (case B13). Wall-clock time is never asserted in the
  battery; it is measured under section 10.

### 8.1 Occurrences across the bundle boundary

New table-row citations and the bundle's active/current `A` pointers
use exact seating occurrence identities. A fresh seating of identical
bytes does not revive readers of an explicitly withdrawn occurrence.
Withdrawing the old occurrence again leaves the new one unchanged.
Both premise and seating occurrence spellings must be canonical;
a numeric prefix followed by malformed text is not an identity alias.

Legacy content-digest seating references remain readable only when
exactly one seating in that bundle resolves the digest. A repeated
digest is ambiguous: validation reports unknown, withdrawal refuses
to choose a target, and bundle admission refuses referenced ambiguity
with code -10. The loader does not rewrite old record identities to
retarget their citations.

Before changing the WSP generation, load validates seating admission
and digests, resolves active/current pointers to the declared role,
and checks the incoming seating, premise, derivation and call inventories
against the current ones. Known occurrences and histories must retain
identical immutable content in their ordinal prefixes, including ordered
citation kind, row and identity, and call name and result. No current
inventory may be truncated. A currently known permanent withdrawal cannot
become live in an incoming bundle. Known unsealed derivations refuse
reload because the wire format cannot preserve their incomplete status.
Violations refuse before WSP books and pointers change. A corrupt seating
keeps the existing admission or digest
refusal code. The existing CSV faces handle seatings with more than six
values, and the parsed count must equal the admitted shape's cardinality;
extra trailing values cannot hide behind a digest of a shorter tensor.

An explicitly reset fixture may import a different inventory. Reset
is a fixture-generation boundary; it is not a privacy deletion, a
global authority operation, or a way to satisfy permanent revocation
across authorities. The import preflight itself uses `ml.space.seat`
for substrate validation and can change that substrate's staging
state. The preserved-state claim covers WSP books and current/active
pointers on refusal; it does not establish atomic adoption across
the substrate, complete numeric capsules, global authority resolution,
or arbitrary concurrent publication. `gate/identity.id` binds these
specific guarantees and limits.

## 9. Compactness accounting

Reported in the three numbers of [status.md](status.md), never mixed:

- **Parameter count**: total weight values across the slice's tables.
  Fixture: 6 + 6 + 2 = **14**, asserted exactly (case B12).
- **Wire bits per weight**: 8 × (seating bytes) / (values in the
  table), per table, from the byte counts the battery itself seated —
  asserted exactly by that formula.
- **Payload bits per weight**: the bits of the values' keys in the
  upstream canonical form, as that form defines them, reported by the
  slice's accounting face. **Carrier bits per weight**: payload, when
  no wider carrier is used; otherwise the carrier's bits per weight,
  reported the same way. The battery asserts payload ≤ wire and
  records all three numbers; the landing commit restates them in
  [status.md](status.md).

## 10. Speed — landing requirement

Not battery-asserted; measured and recorded in [status.md](status.md)
in the landing commit, at the build pin, on a named venue, medians of
5 runs: (a) one step derivation; (b) a stands check over all fixture
records; (c) re-derivation after one reweighting. Each is measured at
the fixture size and at the 10× extension (the fixture tables extended
by the stated generator: every row repeated ten times under distinct
argument identities, candidate count per kind 20, values repeating the
fixture pattern). Both sizes and the growth ratio are reported. A
growth ratio of 100 or more for a 10× size increase on (a) or (b) is
the text-rescan defect signature and is recorded in
[status.md](status.md) as a defect, not a result; the design target is
near-linear growth. No speed figure is ever stated in this repo
without its pin, venue, and method.

## 11. Battery

Every case starts from the fixture state (section 4) unless it states
a sequence. "Falls" and "stands" are the stands face's answers,
recomputed, never cached from the run that published the record.

- **B1 — seat and derive.** Seat the three tables; run the three step
  derivations. Expect the choices read-a, write-a, run-a, and each
  premise record's cited identity set equal to the citation table.
- **B2 — clean-room equality.** An isolated clean derivation of the
  same full inputs (same seatings, facts, rule version), computed with
  no caching or carrying, chooses the same calls with the same scores.
- **B3 — a reweight falls its reader, with the exact delta.** Re-seat
  `choice` with read row [1, 3]. The step-1 derivation falls;
  re-derivation chooses read-b; steps 2 and 3 standings are unchanged.
- **B4 — an unread reweight leaves everything standing.** Re-seat
  `spare` as [1, 2]. Every published record still stands; no record is
  republished.
- **B5 — a corrected fact retracts exactly its cone.** Sequence: run
  the task; learn. Withdraw P3: the retracted set is empty; everything
  stands. Then withdraw P1: the retracted set is exactly { step-1
  derivation, O1, step-2 derivation, O2, the learned `choice` seating
  }; standing throughout: { step-3 derivation, O3, all original
  seatings }.
- **B6 — a shape-only change moves identity.** Re-seat `choice` with
  the same six values in the same order under shape [2, 3]. Its
  identity differs from the [3, 2] seating's; every derivation citing
  it falls.
- **B7 — same-length corruption is caught.** Flip one byte in the
  `choice` seating bytes, length unchanged, before seating completes:
  the seat's read-back digest check fails and the seat refuses by
  name; nothing seats and nothing publishes.
- **B8 — failure publishes nothing.** Seat a table carrying a
  non-finite value: refused at seat (the upstream resident behavior);
  nothing seats, nothing publishes.
- **B9 — the loop, end to end.** Run the fixture task on the fixture
  surface. The executed sequence is exactly read-a, write-a, run-a;
  O1, O2, O3 exist with the premise sets of section 5; the run ends
  with a task-complete record citing O3.
- **B10 — a contradicted observation retracts its cone.** Sequence:
  run the task; learn; deliver Q2, withdrawing Q1. The retracted set
  is exactly { O1, step-2 derivation, O2, the learned `choice`
  seating }; step 1 and step 3 stand. Re-deriving step 2 publishes
  UNKNOWN and the loop halts by name (no write on an uncorroborated
  read).
- **B11 — learning persists.** After B9's sequence plus learning,
  store the learned bundle; load it into a fresh instance; every
  standings answer over the enumerated records is identical before and
  after the reload.
- **B12 — compactness accounting.** The accounting face reports
  parameter count 14; wire bits per weight equal to the section 9
  formula per table; payload ≤ wire; all three numbers printed.
- **B13 — lookup counts.** The counter reads exactly 5, 6, 5 for the
  three step derivations and 9 for learning.
- **B14 — an unknown tool is never guessed.** A variant kind whose
  winning candidate names a tool outside the fixture surface: the step
  publishes UNKNOWN and the loop halts by name; no call executes.
- **B15 — the rule version is a premise.** Re-derive step 1 under rule
  version `derive-2` with weights fixed: both versions' records
  publish and stand side by side.

## 12. Landing discipline

Slice one lands only on: this battery green at the landing pin; a clean
suite pair in clpi/idol terms for any upstream change it needs (head
failing set within base failing set) — slice one is expected to need
none; the naming gate over its diff; [status.md](status.md) updated in
the same commit with the battery vector, the three compactness numbers,
and the section 10 speed measurements at that pin. Landings are stated
as pass / skip / fail / total, never collapsed.

## 13. Non-goals

No live MCP binding; no live Idol Eyes feed; no gradient training; no
claim on cell WSP-BF1; no second task; no persistence beyond the
learned bundle. Each is later work with its own spec, or it does not
happen.

# Work

The open work this repo carries, in the repo, per the founding law: a
gap lives where the project's truth lives. Each item carries its state,
its next action, and its condition. Items close only on executed
evidence recorded in [status.md](status.md).

## W1 — Build slice one

- **State:** EXECUTED AND LANDED. The agent, its battery
  (B1–B15), and the section 10 speed program are landed in this repo
  (`src/agent.id`, `gate/agent.id`, `gate/measure.id`), execution
  commit 61197dfe783f5ae733b2cc280fe278c0d6b8cc68. The battery was
  executed at the pin on bytes identical to the landed ones (the Mac
  mini, the clean pin compiler, C route): pin clpi/idol
  7ad63393f2748a24b907182ce8820c785e79915c; **pass 126 / skip 0 /
  fail 0 / total 126, exit 0, "battery: OK"**. The measure gate
  compiles and runs at the pin, exit 0; no timing was taken, so no
  speed medians exist and none are recorded here — slice speed remains
  UNMEASURED. The execution convicted two defects in the home, both
  fixed in the landed bytes (standing over-propagation, case B3;
  reload generation addressing, case B11), and three defects in the
  compiler, which stand as open compiler work orders in clpi/idol with
  their own lanes (work orders 3, 4, and 5 in [status.md](status.md),
  under Named dependencies); the landed bytes carry
  semantics-preserving accommodations around each. No upstream change
  to clpi/idol was needed for this landing.
- **Scope:** the loop, fixture surface, recorded stream, learning rule,
  accounting face, and lookup counter of the spec, in pure Idol,
  consuming the landed upstream faces the spec names. No upstream
  change to clpi/idol is expected; if one proves necessary, it lands
  upstream first, on its own clean pair, and this item names it here.
- **Next action:** none for the build or the battery — this item
  closes on the executed evidence recorded in [status.md](status.md).
  Two tails live elsewhere: the learned bundle artifact is W5, and
  when any of compiler work orders 3, 4, or 5 lands upstream, its
  accommodation here comes out and the battery re-runs at the new pin.
- **Condition:** met. The pin's compiler ran on the Mac mini. (The
  build VM's two failure phases seen earlier in this item's staging —
  an intermittent write fault, and a CPU placement whose flags lack
  the SHA extension the prebuilt binary was built for — were venue
  facts, reproduced on the known-good control program; the full
  history is in the slice-one record.)

## W2 — The same-contract run for cell WSP-BF1

- **State:** UNMEASURED. No run exists; no margin is claimed.
- **Scope:** run the WSP agent and at least one similar-size incumbent
  under the cell's same-contract terms (same tasks, same tool surface,
  size = parameter count + bits per weight in the three-number
  accounting) and record the outcome in [status.md](status.md),
  whatever it is.
- **Next action:** on W1's landing, fix the run's task set and
  incumbent, and state both here before any run.
- **Condition:** W1 landed (met); a qualifying venue for both sides of
  the contract.

## W3 — Live surfaces (slice two)

- **State:** OPEN, unspec'd beyond slice one's non-goals. Spec-first
  applies: no build before its spec lands here.
- **Scope:** the live MCP binding and the live Idol Eyes feed binding,
  replacing slice one's fixture surface and recorded stream without
  changing the loop's premise discipline; the Idol Eyes binding under
  Idol's own auth, per the standing door law.
- **Next action:** write the slice-two spec against slice one's landed
  battery, naming every host seam it expects, before any code.
- **Condition:** W1 landed (met).

## W4 — Upstream watch: the kernel handler port

- **State:** OPEN, watch only. The port is staged upstream, not
  landed, and slice one does not consume it.
- **Next action:** none unless a later slice's spec names a need for
  it; then its upstream landing, verified at its pin, is the
  precondition, recorded here.

## W5 — Extract the learned bundle artifact

- **State:** CLOSED. `learned/bundle.txt` is landed in this repo in
  this commit. The executed green run's print was not preserved as a
  file, so under this item's condition the battery was re-run at the
  pin from the landed bytes (the Mac mini, the clean pin compiler,
  C route; home and gate byte-identical to the landed commit) and
  the bundle was extracted from the fresh run's B11 print. The fresh
  run is green: pass 126 / skip 0 / fail 0 / total 126, exit 0,
  "battery: OK". The print states bundle bytes 11030; the extracted
  file is 11030 bytes — the bundle itself, ending in its own final
  newline, with the print's one trailing newline removed.
- **Next action:** none — closed on this evidence.
- **Condition:** met (the re-run arm).

## WS-SEM-10 — Complete standing traversal

- **State:** MERGED AND QUALIFIED AT THE FIXED PIN. Pull request 1
  merged at ce1b88448f98c7886dfa1e75e69028d4fd7657d6 (2026-11-09
  08:59 UTC); the source replaces the depth-10 false-live exit with an
  explicit DFS path and per-read visiting/completed marks. The merged
  bytes themselves have no green execution (QUALIFICATION OPEN at
  ce1b8844: emission refused at the retained compiler binary). The
  file-scope emission fix landed as
  1c0d179f4c2ccebed6eab90e3a9c93e016fb35d1 with `gate/agent.id`
  executed 126/0 there; the withdrawal-versus-replacement distinction
  that the same audit round opened landed as
  262b2fb6c7d7a2ee263d11d0b492de0f222d4fb9 with `gate/withdrawal.id`
  executed 22/0 and `gate/agent.id` still 126/0, both at the resident
  run-tree binary (md5 08be8c7325c3aeefaeff7f60f171aefe, C route).
- **Owner/scope:** WSP slice, `src/agent.id`. The companion regression
  is `gate/standing.id`; the existing B1–B15 behavior contract is retained. No
  upstream compiler or graph identity changes are part of this
  correction.
- **Evidence:** status.md (the WS-SEM-10 and withdrawal sections) and
  [evidence/standing.md](evidence/standing.md) for the pre-merge
  history. The conformance pack's deep-chain case (its retraction
  battery, case R11) executed green at the same configuration, at
  each of the pack's exports, R3 and R5/R6 stages.
- **Next action:** none for correctness qualification. The current-evidence
  landing replaces only the fixture's mutable string record field with a
  byte book and executes `gate/standing.id` **27 / 0**, including depth 128
  and shared diamonds, through the named hosted C compiler. See
  [evidence/core-2026-11-09](evidence/core-2026-11-09/README.md).
  Standing cost remains UNMEASURED.
- **Condition:** met. The surviving standalone qualification is closed;
  the previously merged traversal was not replaced.

## WS-INT-1 — One vocabulary, stated in the chapter

- **State:** LANDED AND EXECUTED. The chapter
  (`Idol-Weights-Semantics.md`) now carries the intent-space
  correspondence as its section 13 expression discipline, naming
  the 2026-11-09 design directive addendum as its source; no
  capability claim changed state by the writing. The derived
  battery `gate/intent.id` executed 25 / 0 at the resident
  run-tree binary (md5 08be8c7325c3aeefaeff7f60f171aefe, C
  route), with `gate/agent.id` 126 / 0 and `gate/withdrawal.id`
  22 / 0 at the same configuration. Evidence: status.md, the
  expression discipline section.
- **Next action:** none — closed on this evidence.

## WS-INT-2 — Representative-graph census

- **State:** OPEN, not started. This repo carries the readiness
  statement; the owner is the conformance successor lane,
  sequenced with rank 1 of the premise-weights audit's revised
  execution order (the dependency-completeness step).
- **Scope:** a mechanical census over the graph facts the agent
  machinery emits (its bundle form): every emitted edge is one
  of the lawful kinds the chapter's section 13.7 names, every
  event entry carries the lawful fields, and no entry carries a
  refused form. The census reports violations by kind at a
  named pin; a clean run is evidence about emitted facts only.
- **Readiness:** the instrument can be built now — the emitted
  bundle grammar is fixed by the landed machinery, the lawful
  and refused forms are now stated in the chapter itself
  (section 13.7), and a compiler configuration that emits the
  agent home exists (the resident run-tree binary above). What
  it still needs before firing: the dependency-completeness
  oracle specification on paper from the amendment lane
  (source-demanded support against emitted graph facts), which
  the census runs against and must not re-file as a second
  oracle.
- **Trigger:** the oracle specification filed, at a pin where
  the agent home emits. Fires as the conformance successor
  lane's next slice after rank 1's remaining pack legs.

## WS-INT-3 — The shared store consequence for Wide

- **State:** OPEN, gated on its trigger; no work is lawful
  before it. Until the trigger, Wide's books and this repo's
  store stay separate session state, and no surface presents
  them as joined.
- **Scope:** when the machinery declaration producer lands,
  intents declare into the same store that weight events learn
  into — one store, one graph, two books reading it. No
  Wide-side translation layer is built in the meantime.
- **Owner:** Wide and the derivation machinery program jointly.
- **Trigger:** the declaration producer (gap WIDE-GAP-INTENT in
  the Wide program) lands in clpi/idol. On that landing this
  item's spec slice is written first, against the landed
  producer's actual faces, before any store code.

## WS-CONF-5 — Occurrence and current-evidence boundaries

- **State:** EXECUTED AND LANDED in the current-evidence landing.
- **Scope:** exact seating citations/pointers, canonical occurrence
  spelling, conservative legacy seating resolution, S/P/R/C import validation
  and withdrawal/history preservation, revision identity-set membership, whole-query
  selection/inventory validation, and constant-gradient input support.
  Existing homes own all changes; no second graph or registry was added.
- **Evidence:** the published `gate/core.sh` completed the eleven-gate
  cohort with 883 printed successful assertions and the retraction battery
  PASS. Expanded gates discriminate the baseline by runtime failures.
  [The evidence record](evidence/core-2026-11-09/README.md) contains exact
  inputs, compiler identity and outputs. `learned/bundle.txt` is actual
  producer output, verified by a fresh-process consumer.
- **Next action:** none for this scoped correction. Full authoritative
  identity/capsule integration, producer-discovered support and concurrent
  publication remain separate open obligations; fixture execution does
  not close them. The slice's unimplemented zero-byte premise-text refusal
  is recorded in its spec and status, not silently claimed as delivered.

## WS-ADD-1 — Restricted additive learner demonstration

- **State:** EXECUTED, semantics demonstration only.
- **Scope:** ordinary composition of existing event/revision/numeric faces
  for a fixed-schema intercept learner; exact sum/count reconstruction and
  deletion compared with a fresh same-learner retained-data rebuild.
- **Evidence:** `gate/additive.id` executes 106 / 0 under the declared
  [example contract](spec-additive-example.md), including support,
  historical/current, schema withdrawal and empty-data refusal checks.
- **Next action:** task selection, quality floor and complete lifecycle
  measurements must precede any product-model or performance claim. W2's
  matched comparison remains UNMEASURED; this fixture does not close it.

# What Idol's weight space is today

Everything in this document is from the landed record in clpi/idol, read
firsthand by the lane that founded this repo on 2026-11-07. Where a claim
rests on a run, the run and its pin are named. Where something is not
proven, this document says so.

## The definition

A weight tensor is a table plus a shape descriptor. In the landed surface
a weight table is, exactly: the canonical pool contents plus the shape
descriptor. Weights are first-class program values — a derivation can read
a weight table the way it reads any checked value, and, the point of the
landed slice, a weight table can be a **premise** of a derivation.

## The landed surface

- Repo: clpi/idol. Pull request #1911, "weight space: first slice —
  weight tables as premises", MERGED 2026-11-07T09:21:32Z, merge commit
  9cc4d731d9bebe4e8339eaaf6e3c40ed07176833.
- Files: `lib/ml/space.id` (the surface) and `gate/space.id` (its
  battery). Spec: `spec-weight-space-2026-11-06.md` in the fleet's
  research record; lane record: `weight-space-2026-11-06.md` in the same
  record.
- The surface's faces: seat, tensors, digest, derive, records, stands.
  A model's tensors are seated through the substrate's admission and
  resident producers (`lib/ml/model.id`, `lib/ml/resident.id`, landed on
  main before the run); the seat cross-checks the admission tensor count
  against the resident count.
- The premise digest is the tree's own sha256 (`lib/compiler/digest.id`,
  recomputable in Idol, standard vectors pinned by its battery) over a
  canonical byte form: a kind byte, the dims, then each value's key — an
  exact integer computed in integer arithmetic from the value's sign,
  53-bit mantissa, and exponent. The form's field-boundary bytes are
  nonzero by construction, because the digest face's inputs are
  zero-free text by construction.
- A derivation publishes a premise record: { table digest, rule version
  word, output digest }. The stands face recomputes both digests and
  answers whether the derivation still stands.
- The premise machinery it binds into — witness (replay admission;
  retraction recomputes every dependent before any consumer is answered),
  tally (per-derivation premise sets, named retraction), derive
  (withdrawn laws invalidate dependents) — is built in the compiler's
  self-hosted layer. The slice's premise-format integration afterwards
  put weight-space facts into the one derivation machinery's shared
  format: citable and retractable like everything else, one premise
  closure, one retraction path.

## What is proven, and at what pin

The battery `gate/space.id` (36 expect rows) executed end to end and
passed — 36 ok / 0 fail / exit 0, closing line "battery: OK - weight
tables are premises, derivations fall and stand by their premises" — on a
compiler built from clpi/idol main at
7ad63393f2748a24b907182ce8820c785e79915c. The substrate control battery
ran in the same staging: 193 ok rows, exit 0. Proven behaviors:

- **Clean-room equality first.** The derivation equals an isolated clean
  derivation of the same full inputs — contents, shape, rule version —
  computed with no caching or carrying (and equals the hand sum, 2.75,
  on the fixture).
- **A read weight's change falls the derivation.** Mutating the read
  table (a sign-byte flip) moved the derived sum 2.75 to -1.25 — the
  exact -4.0 delta of the flipped value — and re-derivation restored
  standing under the new premise record.
- **An unread weight's change leaves it standing.** Mutating a tensor
  the derivation never read changed nothing.
- **The rule version is itself a premise.** Changing the rule version
  with weights fixed re-derived; both versions publish and stand side
  by side.
- **The shape is itself a premise.** A shape-only change, contents
  fixed, moved the table's identity.
- **Same-length corruption is caught.** Read-back digest integrity
  holds against a corruption that changes no length.
- **Failure publishes nothing.** Executed on the refusal side: a
  non-finite tensor is refused at seat by the resident producer, and
  the refused seat publishes nothing and seats nothing.

## Honest limits

- **There is no mutation face.** The pool is append-only and
  producer-owned. A weight update is a new seating of changed bytes —
  which is also the honest consumer shape, and the shape slice one of
  this repo is specified against: reweighting means re-seating.
- **Speed is UNMEASURED** at the upstream slice, every leg. No speed
  claim is made for it anywhere in this repo.
- **One path stands unexecuted.** The digest's key-failure path exists
  in the code for a future producer that seats non-finite values; no
  unkeyable value can enter the pool through the landed load route, so
  that path is not claimed as executed.
- The battery at its pin ran over the C route. That is the upstream
  record's fact about its own run, stated here so no reader upgrades it
  into a claim about this repo.

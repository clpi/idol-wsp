# Executable spec: revision query faces, whole-support learn
validation, and the relearning and transaction protocols

Work order WS-CONF-4. Governing semantics: the weights
chapter as landed in this repo (Idol-Weights-Semantics.md)
sections 2, 5 and 7. This spec covers the chapter faces
and protocols that conformance examples E15, E18, E21, E22,
E23, E24, E25, E28, E29 and E31 bind. It builds on
spec-numeric-faces.md (work order WS-CONF-2), whose
representations, refusal table and faces are unchanged
except where section 2 of this spec completes one.

Venue and names: the faces live in the home wsp.numeric
(src/numeric.id), staged into the compiler tree as
lib/wsp/numeric.id beside lib/wsp/agent.id. Premise
standing is read through the agent home's premstate face;
withdrawal through the agent home remains the one
retraction path. Standing is never cached: every face in
this spec resolves premise state at call time.

## 1. What this spec adds

Four faces and one completion:

- members, excluded, receipt: the fixed-inventory query
  faces of chapter section 5.3 (section 3 below).
- equivalent: the revision comparison of chapter
  section 7 (section 4 below).
- The completion of event: Learn validates every member
  of the event's whole support at commit, as chapter
  section 5.2 requires and as spec-numeric-faces.md
  section 7 already states (section 2 below). Before
  this completion the face validated only the declared
  premise set and its premise-over closure; the anchor's
  and the delta's carried support were merged into the
  event's support unchecked, so an event could be
  recorded whose carried support was already withdrawn
  — dead on arrival at query, but recorded. No standing
  battery exercised that path; E24 and E29 bind it.

The occurrence and selection correction also completes
revision construction and Query: repeated references to
one event are a set member once, and every current query
requires live transitive selection support. An unconditional
fixed inventory uses empty selection support; the premises
of its candidate events are checked when those events are
applied, not added to selection support by mere reference.

Two consumer protocols are specified over the faces, in
section 5: relearning after correction (E18) and the
learn/withdraw transaction discipline (E29). They add
no faces; they fix the order of face calls and the
outcomes each order must produce, so a consumer case is
checkable exactly as staged.

## 2. Learn validates its whole support

event: (anchor, delta, premises: str) -> handle or code.
Unchanged from spec-numeric-faces.md section 7 except
for the validation rule, restated here in full.

The event's support is

  T(e) = closure(declared premises
                 union support(anchor)
                 union support(delta))

where closure expands premise dependencies recorded by
premiseover (a premise admitted over a computation
carries that computation's support; chapter section
2.2: giving a derived value a fresh premise name does
not clear its earlier dependencies).

Validation rule: before the event row is written, every
member of T(e) is resolved through premstate, in support
book order. The first member that does not resolve live
refuses the learn: unresolved refuses -12 (unknown);
withdrawn refuses -17 (withdrawn). The declared-premise
checks of the earlier face form (empty set -16,
per-premise -12 / -17) are subsumed: a declared premise
is a member of T(e), and book order places the declared
set first, so a declared-premise refusal is reported
exactly as before.

Consequences, all required by chapter section 5.2
("Learning atomically validates every member of T(e)
against the committing configuration"):

- A delta computed from a snapshot whose premise has
  since been withdrawn cannot be learned under a fresh
  unrelated premise. The refusal is -17. This is the
  E24 arm (a cancelled scalar retains its support, and
  learning from it rejects) and the computed-delta arm
  of E29.
- An anchor copied from a learned snapshot retains that
  snapshot's support (chapter section 5.4); learning on
  such an anchor after its premise withdraws refuses at
  commit instead of recording an unusable event. The
  query-side refusal for revisions rooted in such an
  anchor is unchanged (livewalk, -13; the E25 arm).
- Nothing about live events changes: an event recorded
  while its whole support was live is unaffected by
  this rule, and later withdrawals act on it through
  the query faces exactly as before.

## 3. The fixed-inventory query faces

Chapter section 5.3: Query(C, R) resolves the fixed
inventory E recorded at the revision's construction.
The inventory cannot grow afterwards: a later event,
however live, is not a member of an earlier revision.
livecount already returns the size of the live set
L(C, R); the three faces here expose the inventory and
the per-event exclusion evidence the chapter requires
("For an excluded event, at least one permanent
withdrawal receipt justifies exclusion").

members: (rev) -> i64. The size of the revision's
recorded inventory: the number of candidate event
identities fixed at construction, after deduplicating
references to the same event. Separate equal events each
count. It never changes for
a given revision, whatever is learned or withdrawn
afterwards.

excluded: (rev, ev) -> i64 or code. Answers about one
event's standing in one revision's query:

- ev is not a member of rev's inventory: refuses -11
  (contract). A query cannot justify the exclusion of
  an event it does not hold.
- The anchor is withdrawn: refuses -13 (anchor). An
  unresolved anchor premise refuses -12 (unknown).
- The revision's selection support contains a withdrawn
  premise: refuses -17 (withdrawn). An unresolved selection
  premise refuses -12 (unknown).
- Some member of any candidate event's support is unresolved: refuses
  -12 (unknown). As with livecount, an unresolved
  required premise blocks the query; the event is not
  silently excluded (chapter section 5.3).
- ev is a member and at least one member of its support
  is withdrawn: returns 1. Support is conjunctive
  (chapter section 5.5): one withdrawn premise excludes
  the event however many others survive.
- ev is a member and every member of its support is
  known and unwithdrawn: returns 0.

After confirming membership, the face validates the same
whole query as livecount, total and observe. An unresolved
member of any candidate's support refuses even when the
requested event has a known withdrawal. Only after that
validation does it inspect the requested event's whole
support in book order. A per-event answer cannot bypass an
invalid recipe or an unresolved fixed inventory.

receipt: (rev, ev) -> str. The identity text of the
premise whose permanent withdrawal receipt justifies
ev's exclusion from rev: the first withdrawn member of
ev's support, in support book order, spelled as its
occurrence identity (the same spelling supporthas
resolves). Returns the empty text when ev is a member
and live (no receipt is needed), and the empty text
with the refusal state set (-11 not a member, -12 unknown,
-13 anchor, or -17 withdrawn selection) in the cases where excluded
refuses. Withdrawal receipts themselves live in the
agent home and are not re-recorded here (status is
derived from receipts and support, chapter section
13.7 of the WS-INT-1 discipline as carried by
spec-numeric-faces.md section 7): premstate of the
returned identity reads 0, permanently.

Together the three faces make the E28 verdict
executable: a revision whose inventory is {eP}, after P
withdraws, has members 1, livecount 0, excluded 1 for
eP, and a receipt naming P. Creating eQ afterwards
leaves every one of those answers unchanged; eQ is a
member only of revisions constructed after it exists.
A learner may use that fixed-scope observation. What
it may not do is learn from an untracked assertion of
absence: an assertion that was never admitted as a
premise has no identity in the machinery, resolves
unresolved through premstate, and an event declaring
it refuses -12 under the section 2 rule — the chapter's
"learning from an untracked absence claim rejects in
this core", as a consequence of the identity discipline
rather than a special case.

## 4. Revision equivalence

equivalent: (ra, rb) -> i64. The Equivalent comparison
of chapter section 7, in face form: 1 exactly when the
two revisions name the same exact anchor (Same — handle
equality of the anchor weight) and hold the same
event-identity set; 0 otherwise. Membership is a set
(chapter section 5.3 well-formedness: distinct event
identities); the comparison checks equal inventory
sizes and that every member of each inventory appears
in the other. It does not compare rounded snapshots,
does not erase selection support, and does not assert
that the two revision objects have the same occurrence
identity: two separately constructed revisions with the
same anchor and the same members are equivalent and
distinct. The result is a plain verdict over recorded
rows; unlike the weight comparisons it carries no
support, because both inventories and both anchors are
already recorded facts the caller named directly.

E21 is the discriminating case: over an F32 anchor of
2^24, the empty revision and the revision holding one
+1 event have numerically equal snapshots (both observe
2^24) and equal snapshot digests, different exact totals
(2^24 and 2^24+1), and equivalent answers 0. Extending
each with a distinct second +1 event separates the
observations (2^24 and 2^24+2): snapshot equality never
established revision equivalence.

## 5. The consumer protocols

### 5.1 Relearning after correction (E18)

Chapter section 5.4: correction creates a new premise
identity; relearning creates a new event with newly
checked dependencies; the earlier premise does not
reactivate. The protocol, over the faces:

1. Run the E13 case: anchor [10, 20] over Q; eP with
   delta [1, 0] under P; eQ with delta [0, 2] under Qp;
   the revision observes [11, 22].
2. Withdraw P. The revision's live set is {eQ}; it
   observes [10, 22].
3. Admit the correction: a premise over a fresh
   statement (a different text, hence a fresh identity
   P'), never the withdrawn statement re-admitted.
   premstate reads 1 for P' and still 0 for P.
4. Learn the fresh event eP' with delta [3, 0] under
   P'. It constructs: its whole support is live.
5. Form the mixed revision {eP, eQ, eP'}. Its inventory
   holds all three events (eP remains a historical
   member); its live set is {eQ, eP'}; it observes
   [13, 22]. Old eP stays withdrawn throughout.
6. Any attempt to learn under the withdrawn P instead
   of P' refuses -17 (withdrawn), at the declared
   premise already.

### 5.2 The learn/withdraw transaction protocol (E29)

Chapter section 5.6: learning and retraction have
atomic commit points; a computation may use a pinned
configuration, but before a new current effect commits
it must validate the required support against the
current authority state. In this machinery the commit
point of a learn is the event call itself, and standing
is resolved at call time, never cached, so the protocol
stages the two commit orders as call orders:

- Learn commits first: event under live P constructs.
  A later withdrawal of P then excludes the committed
  event at query: the live set loses it and observation
  falls back to the surviving total. The event record
  is unchanged; its standing is derived.
- Withdrawal commits first: with P already withdrawn,
  the same event call refuses -17. This holds for both
  ways a delta can require P: declared in the premise
  set, and carried in the delta's own support because
  the delta was computed from a P-dependent snapshot
  while P was live (the pinned computation). The commit
  revalidates against current state, not against the
  configuration the computation read.
- Invariant: after both operations, in either order,
  no live P-dependent event exists. There is no allowed
  outcome in which a post-withdrawal commit publishes a
  live P-dependent event.

True parallel execution is not staged: these faces execute
in one thread. The battery checks both sequential commit
orders and the invariant. It does not establish that an
actual concurrent implementation admits only those orders,
or that a model and its evidence publish atomically. Those
remain separate integration obligations of chapter 5.6.

## 6. The battery contract

gate/revision.id executes the examples below through
the faces and asserts each stated outcome, including
every refusal by its code and its name through the
refusal face. gate/revision.sh is its standing control,
shaped on gate/numeric.sh. Every check prints one line;
the closing lines give the vector in ok / FAIL form and
a PASS or FAIL word; the program exits 1 on any
failure. Cases run in one process in the order written;
each example admits its own premises through wsp.agent
after wsp.agent.init, so no case disturbs another and
no fixture premise is relied on.

E15: repeated references to one event produce one member
and one contribution. Two distinct equal events produce
two members and two contributions. Permuting or repeating
the same identity set preserves the exact total and
equivalence. A withdrawn candidate can remain a historical
member without becoming live.

E18: the section 5.1 protocol, in order. P and Qp live
at admission; eP and eQ construct; the revision
observes 11 and 22 elementwise. Withdrawal of P lands;
the live count is 1; observation is 10 and 22. The
corrected premise's identity differs from P's text,
reads live, and P still reads withdrawn. eP' with delta
[3, 0] constructs; the mixed revision's members are 3,
its live count 2, its observation 13 and 22. Learning
delta [3, 0] under the withdrawn P refuses -17, named
withdrawn.

E21: F32 anchor 16777216. e1 is a +1 event under one
live premise. The empty revision and the {e1} revision
both construct; members read 0 and 1; equivalent
answers 0 across, 1 for the {e1} revision against
itself and against a separately constructed revision
with the same anchor and members, whose handle differs.
Both observations are the rational 16777216; the two
snapshots are numeric-equal with equal digests. The
exact totals are 16777216 and 16777217 and are not
numeric-equal. Two further distinct +1 events e2 and e3
construct; extending the empty revision with e2
observes 16777216; extending the {e1} revision with e3
observes 16777218; the extended snapshots are not
numeric-equal.

E22: I(8) anchor 100; eP with delta -100 under P; eQ
with delta +100 under Qp; both construct; the revision
observes 100. Withdrawal of P lands; the live count is
1; the exact total is 200 (the surviving event's record
is unchanged); observe refuses -3, named range. The
withdrawal is not reversed and no stale 100 is
returned.

E23: I(8) anchor 127; one event with rational delta
-255 under a live premise constructs (no range
obligation binds the delta at learn). The exact total
is -128; observation succeeds and reads -128. Casting
the delta weight itself to I(8) refuses -3, named
range: the range obligation binds the materialized
total, not the delta.

E24: the E13 case over Q; its snapshot observes 11 and
22 and carries support count 2. Reading coordinate 0
gives a rank-zero scalar reading 11 with support count
2. Multiplying it by a zero scalar gives a scalar
reading 0 whose support count is 2, with both premises
present by supporthas, and usable 1. After P withdraws:
the scalar still reads 0 (historical inspection), its
support still contains P, and usable reads 0. Learning
a current event on a rank-zero anchor with that scalar
as delta under a fresh live premise refuses -17, named
withdrawn. Control: a zero scalar with empty support
learns under the same premise and anchor without
refusal — the refusal follows the retained support,
not the zero payload.

E25: the E13 case over Q again, under its own premises.
The snapshot [11, 22] is copied by adding a zero weight:
a new handle, numeric-equal to the snapshot, support
count 2 with both premises present. A revision rooted
in the copy with no events observes 11 and 22 while the
support is live. After P withdraws, observing that
revision refuses -13, named anchor, and total refuses
-13 as well; the source revision still observes 10 and
22. Discarding the event list did not remove P.

E28: anchor 5 over Q; eP with delta 7 under P; the
revision {eP} has members 1, live count 1, excluded 0
for eP, and an empty receipt for eP. Withdrawal of P
lands. The query answers: members still 1, live count
0, excluded 1 for eP, receipt equal to P's occurrence
identity (premiseid of the admitted statement), and
premstate of P reads 0. A later event eQ under Qp
constructs; the old revision's members stay 1 and its
live count stays 0; excluded for eQ in the old revision
refuses -11, named contract. A new revision {eP, eQ}
has members 2 and live count 1. A digest of a statement
never admitted reads premstate -1, and learning under
it refuses -12, named unknown.

E29: the section 5.2 protocol, in order. Under premise
P (live), an event with delta 4 constructs; its revision
has live count 1 and observes 4. Withdrawal of P lands;
the live count is 0 and observation is the anchor alone
(0). Under a second premise P2, withdrawn before any
learn, the same learn refuses -17, named withdrawn.
Pinned arm: under a third premise P3 (live), an event
is learned and its revision observed; the snapshot
carries P3 (support count 1, supporthas P3); a delta
computed as that snapshot minus the anchor reads 4 and
carries P3. P3 is withdrawn. Learning that delta under
a fresh live premise refuses -17, named withdrawn. The
P3 revision's live count is 0 at the end, as is the
first revision's: no live P-dependent event remains in
either order.

E31: direct and transitive selection support is required
at construction and at every current query, even for an
empty inventory. Withdrawing a selector blocks livecount,
total, observe, excluded and receipt; retained snapshots
remain inspectable and become unusable. Structural members
and equivalent remain historical inspections. An independent
recipe with the same fixed event inventory stays usable,
and its reconstruction agrees with a fresh recipe. Unknown
selection and unknown fixed-inventory evidence block query
instead of supplying an exclusion receipt.

## 7. What this spec does not settle

Differentiation (E09 to E12, the gradient arm of E30)
is WS-CONF-3's. The capsule arms of E27 are WS-CAP-1's.
Confidence values on event records (chapter section
5.1) remain as spec-numeric-faces.md section 10 leaves
them. Compiler-discovered control dependencies, support-bearing
ordinary scalar results, complete capsules, and concurrent
publication are not established by these explicit handle
and support-text faces.
Speed is UNMEASURED, here and everywhere in this work
order.

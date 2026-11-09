# Executable spec: the weights chapter's numeric and shape faces

Work order WS-CONF-2 — the named blocker for chapter examples
E01–E08, the F32 payload arm of E19, and the rank-zero and
zero-division arms of E30 (verdict table: section 5 of the
fleet record wsp-remainder-successor-2026-11-09.md). This file
is the executable spec for the faces, written before the
implementation, at the resolution the standing spec-first law
requires: an implementer who follows it produces the faces
without further design decisions. The normative source is the
chapter as landed in this repo (Idol-Weights-Semantics.md,
core profile 1): section 3 (dtypes, shapes, literals),
section 4 (typing and evaluation rules), section 5 (learning,
revisions, observation), section 7 (equality), section 13
(expression discipline). Where this spec fixes a choice the
chapter leaves open, the choice is stated as a choice.

Scope. The faces specified here are exactly the ones E01–E08,
the E19 payload arm, and the two named E30 arms exercise:
literal construction, Add, Sub, Mul, Div, Cast, Read, Replace,
Broadcast, Contract, the chapter's Numeric comparison, and
the revision faces (event, revision, total, observe) the
E19 arm needs. The remaining section 4 operations (Scale,
Reshape, Permute, Concat, Sum, Compose) and Grad
(WS-CONF-3) are not specified here and are not implemented by
this work order; their chapter semantics stand as written,
and no example in this work order's set needs them.

Homes and landing. The faces live in a new home file,
src/numeric.id, home wsp.numeric, staged into the compiler
tree as lib/wsp/numeric.id beside lib/wsp/agent.id. One
additive face is added to the agent home (premstate,
section 8 below); no existing face changes meaning. The
consumer battery is gate/numeric.id, with the standing
control gate/numeric.sh, following gate/retract.sh's shape.

Configuration of record for execution: the compiler built
from the staged tree (C route, --backend=c), the substrate
lib/ml/space.id of that tree, and this repo's homes staged
into that tree's lib/wsp. Speed: UNMEASURED, every leg.

## 1. Representations

All state lives in file-scope tables and byte books in the
idiom of src/agent.id: integer handles, one growing book per
kind of content, no string-keyed tables anywhere, no strings
stored in records. Strings cross faces as parameters or as
freshly built results of a named face (piece), and every
string comparison goes through a face whose two operands are
parameters (the streq pattern), because this realizer's
lowering of a string operation flips on the construct form
that produced the operands (defect class D-FORM, filed in
the predecessor record, section 6). A comparison or append
that reads a string out of a book always passes it as an
argument first.

### 1.1 Factored rationals

An exact rational is stored as a triple (n, d, s) of i64 in
three parallel books, meaning the value n * 2^s / d.
Canonical form, enforced by the single constructor face
rat3: d is odd and positive; gcd(|n|, d) is 1; n is odd,
or n is 0, in which case the triple is exactly (0, 1, 0).
Every rational the home produces passes through rat3, so
two rationals are equal exactly when their triples are
equal componentwise. A rational handle is its row in the
books, counting from 1. The factored form exists because
the finite profiles' exact values are dyadic with shifts
far outside an i64 denominator (an F32 subnormal is
m * 2^-149; an F64 subnormal reaches 2^-1074), while
general rationals (1/10) need an odd denominator part.
Both fit the one form; no second representation exists.

Representation bound: |n| and d must fit an i64 with the
top bit spare — each is at most 2^62 - 1 in magnitude after
canonicalisation. A computation whose canonical parts or
whose guarded intermediates exceed the bound refuses with
the resource code (section 2). Refusal is the chapter's
resource obligation failure (chapter section 3.1: a resource
limit may prevent evaluating a large exact value; it never
permits approximating one).

### 1.2 Dtypes

A dtype is two i64: a profile code and a width.
Codes: 0 = Q, 1 = I, 2 = U, 3 = F32, 4 = F64.
Width is the n of I(n) / U(n); it is 0 for Q, F32, F64 and
is part of dtype identity there only as 0. Two dtypes match
exactly when code and width both match. Ranges: I(n) is
[-2^(n-1), 2^(n-1) - 1], U(n) is [0, 2^n - 1], with
1 <= n <= 62 (the bound of section 1.1). F32 parameters:
p 24, emin -126, emax 127, bias 127. F64: p 53, emin -1022,
emax 1023, bias 1023. The maximum magnitude is
M = (2 - 2^(1-p)) * 2^emax, held as the exact rational
(2^p - 1) * 2^(emax - p + 1) in factored form.

### 1.3 Shapes

A shape is a row in a dims book: an offset and a rank;
rank 0 is the empty shape (). Cardinality is the product
of extents, computed with overflow guard; any extent is a
nonnegative i64. Coordinates are 0-based positions; the
canonical order is lexicographic with the last axis varying
fastest, and a weight's payload is stored in that order.
Shapes are equal exactly when rank and every extent match;
equal cardinality never implies equal shape (E03, E06).

### 1.4 Weights

A weight is a row holding: dtype code, width, shape row,
payload offset and count (factored-rational handles in
canonical coordinate order; count equals the shape's
cardinality), and a support reference (section 1.5).
A weight handle is its row, counting from 1; Same(a, b)
is handle equality (chapter section 7: occurrence
identity). The weight's identity text, when a consumer
needs one, is the letter w followed by the row number
zero-padded to the 64-character citation width, exactly
the agent home's idtext discipline; events use e and
revisions use v. A weight's digest is sha256 (the tree's
compiler.digest.sha256 — the shared premise digest) over
its canonical form text: dtype code, width, the extents,
then each payload rational as num/den/shift digits in
coordinate order. The digest is an index and a derivation
binding, never the identity (the machinery ruling the
agent home records: identity is provenance identity).

### 1.5 Support

A support is a set of premise identities, held as one
64-character identity text after another in a byte book;
a support reference is an offset and a count. Premise
identities are the agent home's: an occurrence identity
from wsp.agent.premiseid, or a statement digest — both are
resolved by the agent home's own resolution (premrow)
through the premstate face of section 8. A weight's
support is always closed: closed means that whenever a
member premise was admitted over a tracked computation
(premiseover, section 6), that computation's support is
also a member, transitively. Closure is computed at the
moment a set is formed, by expansion through the
premise-over book; unions of closed sets are closed, and
every face below forms its result's support as a union of
closed sets or a closure, so the invariant holds by
construction. Support is recomputed state at every read
(chapter section 13.3): no face caches a standing answer;
usable and the revision faces consult the agent home's
withdrawal state at call time, so wsp.agent.withdraw
changes their answers with no other act — the one
retraction path.

## 2. Refusals

A face that cannot fulfil its contract produces no result;
it returns a negative code. Every face sets the home's why
code — 0 on entry, the refusal's code on refusal — and
two faces expose it: why() returns the current code, and
refusal() returns the current code's name (the agent
home's seatfile/refusal pattern, carried as a code).
Codes and names are fixed:

 -1 shape: the operands' shapes do not match, or a shape
    argument is not the shape the contract requires
 -2 dtype: the operands' dtypes do not match, or a value
    offered for a dtype-gated role carries the wrong dtype
 -3 range: an exact value falls outside the target
    dtype's range (integer range, or |q| > M for a finite
    profile, checked before any rounding)
 -4 integral: a value offered to I(n) or U(n) is not an
    integer
 -5 zero: a division's divisor coordinate is zero, or a
    rational is constructed with denominator zero
 -6 count: a literal's element count differs from its
    shape's cardinality
 -7 extent: a shape extent is negative, or a width is
    outside 1..62
 -8 coordinate: a coordinate is outside its axis extent
 -9 axis: an axis position is outside the rank
 -10 broadcast: the broadcast law fails (map not
    injective, a mapped extent neither equal nor one, a
    zero source extent mapped to a nonzero target extent)
 -11 contract: the contraction law fails (an axis list
    has a duplicate or an out-of-range position, the two
    lists differ in length, or paired extents differ)
 -12 unknown: a required premise is unresolved in the
    current generation; the query that demands it blocks
 -13 anchor: a revision's anchor is not usable, or an
    event names a different anchor than the revision's
 -14 resource: an exact value or intermediate exceeds
    the representation bound of section 1.1
 -15 text: a numeric text offered to a constructor does
    not parse (bad digits, a ragged or empty token, a
    fraction with denominator zero)
 -16 premises: an event's declared premise set is empty
 -17 withdrawn: a learn or a current use names support
    that stands withdrawn in the current configuration

Faces that return a weight, event, or revision handle
return the handle (1 or more) on success and a code above
on refusal. Faces that return a count or a value return
the value on success; where a refusal is possible they
return the code and the caller distinguishes by sign only
where the spec says the value cannot be negative.

## 3. Rational faces

rat: (n: i64, d: i64) -> handle. The plain constructor:
d = 0 refuses -5; the pair is factored (powers of two move
between d and the shift, d made odd and positive) and
reduced by gcd, then rat3's canonical checks apply; parts
beyond the bound refuse -14.

decimal: (text: str) -> handle. Parses one numeric token
exactly (chapter section 3.3: decimal literal meaning is
exact — 0.1 is 1/10). Grammar: an optional minus sign,
digits, optionally a point and more digits; or digits, a
slash, digits (a fraction; the denominator digits are
unsigned and nonzero). Anything else refuses -15. The
result is the exact rational, canonicalised by rat3.

rnum, rden, rshift: (r: handle) -> i64. The canonical
parts. req: (a, b) -> i64, 1 exactly when the triples are
componentwise equal. rtext: (r) -> str, the canonical
text: if d is 1 and s is 0, the digits of n; if s is 0,
n/d as digits over digits; otherwise n*2^s/d spelled as
digits, the marker "e" and the shift when s is nonzero —
the exact spelling is the home's own and is used only for
printing and digests, never parsed back.

Arithmetic on rationals (internal, always through rat3):
neg, add, sub, mul, div. Each guards its multiplications
(a product of two parts beyond the bound refuses -14),
aligns factored forms by the odd denominators' least
common multiple and the smaller shift, and refuses -14
whenever an alignment shift difference above 62 would
have to be materialised. Comparisons are exact
subtractions read by sign (the finite range check of
section 3.2 is the one comparison the faces need).
Division by a zero rational is refused by the
caller-facing face (Div, section 5) with -5 before any
internal division runs.

Rounding to the finite grid (internal, exact): the face
roundgrid(q, p, emin, emax) returns the canonical rational
of the representable value the chapter's convert selects,
or a refusal. Steps, all in integer arithmetic:
 1. If q is 0, the result is 0 (the single positive zero).
 2. Let a = |numerator form| of q. Find e, the integer
    with 2^e <= |q| < 2^(e+1), from bit lengths corrected
    by one exact comparison.
 3. If e >= emin (normal range): the significand is
    m = roundhalf(q / 2^(e-p+1)), computed by the doubling
    remainder loop of step 5. If m = 2^p, set m = 2^(p-1)
    and e = e + 1. The value is m * 2^(e-p+1); the word
    fields are sign, exponent field e + bias, fraction
    m - 2^(p-1).
 4. If e < emin (subnormal range): m = roundhalf(q /
    2^(emin-p+1)) by the same loop. m = 0 gives zero;
    m = 2^(p-1) gives the smallest normal (exponent field
    1, fraction 0); otherwise exponent field 0, fraction
    m. The value is m * 2^(emin-p+1).
 5. roundhalf of a nonnegative factored rational x: the
    integer nearest to x, ties to the even neighbour.
    Computed without forming any product beyond the bound:
    write x = A/B in factored parts; if the shift is
    nonnegative, double a remainder register (kept below
    B, so each doubling stays inside i64 because payload
    denominators are at most 2^62 - 1) once per shift bit,
    extracting quotient bits into an accumulator that
    never exceeds the final quotient; if the shift is
    negative, compare by bit lengths and form the scaled
    denominator only when its bit length fits, else the
    quotient is 0 and the remainder comparison decides.
    The final tie comparison compares the remainder
    against B - remainder, never 2 * remainder.
The word of a converted value is assembled from the same
fields, so the payload rational and the canonical bytes
can never disagree.

## 4. Conversion — the dtype law

convert: (dt: i64, width: i64, r: handle) -> handle or a
refusal code. This is the chapter's convert(D, q), the one
conversion every face uses; no face converts any other way.
 - Q: the rational itself (already canonical).
 - I(n), U(n): the value must be an integer (d = 1 and
   s = 0 after canonicalisation, or an integral value in
   factored form: s >= 0, or d divides n * 2^s exactly —
   tested by reduction, never by approximation), else -4;
   and inside the profile's range, else -3. The result is
   that integer as a rational.
 - F32, F64: first |q| <= M as an exact comparison, else
   -3 (range is checked before rounding, chapter section
   3.1); then roundgrid with the profile's parameters.
   The comparison never materialises an alignment the
   section 3 guard refuses: the exponent e of |q| (step 2
   of roundgrid) decides it outright when e differs from
   emax (e > emax is out of range; e < emax is in range,
   since |q| < 2^emax <= M), and the exact subtraction
   against M runs only when e = emax, where the two
   operands' shifts are close.
A weight's stored payload is always the converted value,
held as its exact rational (for a finite profile, the
exact value the encoding denotes — its lift). Reading a
payload back therefore never re-rounds.

wordof: (w: handle, i: i64) -> i64. For an F32 or F64
weight, the canonical encoding bits of payload element i
(0-based flat index), assembled from the same rounding
fields conversion computed: sign bit, exponent field,
fraction. For F32 the bits are the low 32 bits of the
returned word. Other dtypes refuse -2. i outside the
payload refuses -8.

## 5. Weight faces

Text conventions: bulk arguments cross as text in the
tree's idiom (comma-separated, parsed by the home's own
split faces into file-scope tables, as the agent home
parses its bundles). A dims text is the extents in axis
order, empty text for rank 0. A vals text is one numeric
token per element (each as decimal parses), in canonical
coordinate order. A coords text is one integer per axis.
An axes text is comma-separated 0-based axis positions,
possibly empty.

lit: (dt, width, dims: str, vals: str) -> handle or code.
Constructs a weight with empty support. Refusals: a bad
extent -7; element count != cardinality -6 (this is also
the ragged case: a nested presentation that does not
rectangularise arrives as a count mismatch); a bad token
-15; any element's conversion, its code (-3 or -4). The
shape () with exactly one element is the rank-zero
literal; shape () with zero elements refuses -6 (E30).

dtypeof, widthof, rankof, cardof: (w) -> i64. dimof:
(w, axis) -> extent, axis out of range refuses -9.
at: (w, i) -> rational handle of payload element i
(0-based flat, canonical order); i out of range refuses
-8. shapematch: (a, b) -> 1 exactly when the shapes are
equal. supportcount: (w) -> i64. supporthas: (w, p: str)
-> 1 exactly when the premise identity p (occurrence
identity or statement digest, resolved as premstate
resolves) is a member of w's support.

binop faces add, sub, mul, div: (a, b) -> handle or code.
Contracts (chapter section 4): dtypes must match exactly,
else -2; shapes must match exactly, else -1. Per
coordinate, in canonical order: the named exact rational
operation over the lifted payloads, then convert once to
the operands' dtype; a conversion refusal is the face's
refusal (-3; for div a zero divisor coordinate refuses
-5 before conversion). The result's support is the union
of the operands' supports (chapter section 2.2 — demanded
inputs; a zero operand erases nothing, E24's rule at the
face level). Result identity is fresh; the operands are
unchanged.

cast: (dt, width, a) -> handle or code. Per coordinate,
convert(dt, width, lift) with its refusals. Shape and
support are the operand's; dtype is the target's. No
implicit conversion exists anywhere else (E02, E08).

read: (a, coords: str) -> handle or code. The result is
a rank-zero weight of a's dtype whose one element is the
payload at the coordinate, converted already (payloads
are stored converted), with a's support. A coordinate
outside its extent refuses -8; a coords text of the
wrong length refuses -1.

replace: (a, coords: str, x: handle) -> handle or code.
x must be a rank-zero weight, else -1. The new weight is
a's shape and dtype, a's payload with the one coordinate
replaced by convert(a's dtype, x's element) — its
refusal is the face's — and support the union of a's and
x's supports: the replaced value is a demanded input, so
its evidence is retained (chapter sections 2.2 and 4;
E07's evidence clause). The operand is unchanged; the
result's identity is fresh. Coordinate refusals as read.

broadcast: (a, dims: str, map: str) -> handle or code.
map carries one target axis position per source axis, in
source axis order (0-based positions into the target
shape). The law (chapter section 4): the map is
injective, else -10; each mapped source extent equals
the target extent at its image or is 1, else -10; a zero
source extent maps only to a zero target extent, else
-10. Unmapped target axes repeat the projected value.
The payload at a target coordinate is the payload at the
projected source coordinate (the mapped coordinate, or 0
on a singleton source axis). Support and dtype are a's.
An add of mismatched shapes is not rescued by any
implicit broadcast: without this face it refuses -1
(E04's second clause).

contract: (a, b, axes: str, axes2: str) -> handle or
code. Dtypes must match, else -2. The two axis lists must
have equal length, distinct in-range positions, and
equal paired extents, else -11. The result's axes are
a's uncontracted axes in order, then b's. Each result
coordinate sums, over every combination of the contracted
coordinates, the exact product of the two payloads, then
converts once to the shared dtype (chapter section 4:
exact contraction, one conversion; Contract with two
empty lists is the outer product; a contracted extent of
zero makes every sum empty, hence zero — E05, E06).

numeric: (a, b) -> i64. The chapter's Numeric: 1 exactly
when dtypes match, shapes match, and every canonical
payload coordinate is equal as exact rationals; 0
otherwise — different dtype or shape is false, never a
refusal (E02's second clause). same: (a, b) -> 1 exactly
when a and b are the same handle.

usable: (w) -> i64. Three-state, the chapter's usable
against the current configuration, recomputed at the
call: 1 when every premise in w's support resolves known
and unwithdrawn (premstate 1 for each); 0 when any member
stands withdrawn (premstate 0 — false dominates, the
author's correction the retract battery records); -1
when any member is unresolved and none is withdrawn.

digestof: (w) -> str. The canonical form's sha256
(section 1.4).

## 6. Premise admission over a computation

premiseover: (text: str, w: handle) -> str. Admits the
statement through the agent home (wsp.agent.premise,
kind 1) and records, in the premise-over book, that this
premise's support includes w's support — a premise
created from a tracked computation retains that
computation's support (chapter section 2.2). Returns the
statement digest, as wsp.agent.premise does. The book is
keyed by the premise's occurrence identity; closure
(section 1.5) expands through it. This is the one place
premise-assertion dependency edges are recorded for the
numeric home; the agent home's records remain the
machinery for derivation citations, and nothing here
duplicates them.

## 7. Events, revisions, observation (the E19 arm)

event: (anchor, delta, premises: str) -> handle or code.
Chapter section 5.2 in face form. anchor and delta are
weight handles. delta's dtype must be Q, else -2; its
shape must equal anchor's, else -1. premises is a
comma-separated text of premise identities (occurrence
identities or statement digests); empty refuses -16.
Every declared premise must resolve: unknown refuses
-12; withdrawn refuses -17 — learning validates its
whole support against the committing configuration.
The event's support is the closure of the declared set
unioned with anchor's support and delta's support
(section 1.5). The event row holds: anchor handle, delta
handle, the closed support. Its identity text is e with
its row. Two events with equal deltas are two events
(occurrence identity, chapter section 5.5); there is no
deduplication by payload.

revision: (anchor, events: str, sel: str) -> handle or
code. events is a comma-separated text of event handles
(possibly empty — the empty revision of E21). Every
event must name this exact anchor (Same — handle
equality), else -13. sel is a comma-separated text of
premise identities forming the selection support U(R):
the premises of the computations that selected this
anchor and membership (chapter section 5.3); it may be
empty. Unknown selection premises refuse -12, withdrawn
refuse -17. The revision's own support is the closure of
U(R) unioned with anchor's support. Candidate events are
historical references: their live-premise requirements
are not imported into the revision's support (chapter
section 5.3's distinction, section 13.7's edge list).

livecount: (rev) -> i64 or code. The size of the live
set L(C, R) at the call: an event is live exactly when
every premise of its support resolves known and
unwithdrawn. If any candidate event's support contains
an unresolved premise, the query blocks: -12 (chapter
section 5.3: an unresolved required premise blocks the
query; it is not silently excluded). If the anchor is
not usable (usable(anchor) is 0), -13; if unresolved,
-12. Withdrawn events are excluded, each justified by
its withdrawal receipt in the agent home; no receipt is
re-recorded here (section 13.7: status is derived from
receipts and support).

total: (rev) -> handle or code. The exact total
Total(C, R) as a Q weight of the anchor's shape: the
anchor's lifted payload plus, coordinate by coordinate,
the deltas of exactly the live events — all addition
exact, no conversion. The result's support is the
revision's support unioned with the anchor's support and
every included event's support (chapter section 5.3:
Total and Observe have the same support). Refusals as
livecount.

observe: (rev) -> handle or code. Observe(C, R) =
cast(anchor's dtype and width, total(rev)) with cast's
refusals — in particular -3 when the reconstructed total
falls outside the anchor dtype's range (the E22 shape of
refusal, whose example itself is WS-CONF-4's). The
result's support is total's support. Nothing is ever
subtracted from a rounded snapshot: observe recomputes
from the surviving event set at every call, which is
what the E19 arm executes — retract the premise and the
same revision observes the reconstructed total.

## 8. The agent home addition: premstate

premstate: (x: str) -> i64, exported by wsp.agent.
Resolves x exactly as the agent home resolves a citation
(premrow: a 64-character occurrence identity names its
row; anything else is a statement digest resolved through
the index to the statement's current occurrence) and
answers the premise's state in the current generation:
1 known and unwithdrawn, 0 known and withdrawn,
-1 unresolved (no such premise in this generation).
It reads pwd and the generation tables only; it records
nothing and counts no lookup. It is the per-premise
projection of the same three-state discipline the
standing face (vfalls) computes over records, and it is
the only agent-home change this work order makes.

## 9. The battery contract

gate/numeric.id executes the examples below through the
faces and asserts each stated outcome, including every
refusal by its code and its name through the refusal
face. Every check prints one line; the closing lines give
the vector in ok / FAIL form and a PASS or FAIL word;
the program exits 1 on any failure. Cases run in one
process in the order written; premise cases use premises
the battery itself admits through wsp.agent after
wsp.agent.init, so no fixture premise is disturbed.

E01: decimal 0.1 and 0.2 as Q rank-zero weights; add;
read back 3/10 in canonical parts (num 3, den 5, shift -1:
the section 1.1 law makes the denominator odd, so the
factor 2 of 10 lives in the shift); numeric against
a literal 0.3 weight is 1.
E02: cast F32 of the Q weight 0.1; its element's rational
is 13421773/134217728; wordof is 1036831949 (3d cc cc cd);
numeric against the Q weight 0.1 is 0 (dtypes differ);
numeric against an F32 literal built from 13421773 over
134217728 is 1.
E03: lit (2) of [1, 2] and lit (1,2) of [3, 4]; add
refuses -1 with name shape.
E04: lit (3) of [10, 20, 30]; broadcast to (2,3) with map
"1" (the single source axis maps to target axis 1); add
to [[1,2,3],[4,5,6]] gives [[11,22,33],[14,25,36]], read
back elementwise; and add of the unbroadcast (3) weight
to the (2,3) weight refuses -1.
E05: contract [[1,2],[3,4]] with [5,6], axes "1" and "0":
shape (2), payload [17, 39].
E06: contract a (2,0) weight with a (0,3) weight, axes
"1" and "0": shape (2,3), six elements all zero; add of
(0,3) and (0,4) weights refuses -1.
E07: a = lit Q (2) [1, 2]; b is the same handle; c =
replace(a, "0", rank-zero 9): payload [9, 2]; a still
reads [1, 2]; same(a, b) is 1; same(a, c) is 0;
supportcount(c) equals supportcount(a).
E08: add of Q 1 and F32 1 refuses -2 (dtype); cast I(8)
of Q 1/2 refuses -4 (integral); add of I(8) 127 and
I(8) 1 refuses -3 (range).
E19 payload arm: premises P and Qp admitted; anchor the
F32 rank-zero 0; event eP with delta Q 16777216 under P;
event eQ with delta Q 1 under Qp; revision over both;
observe reads 16777216 (the exact total 16777217 rounded
once, ties to even) and wordof reads 1266679808
(4b 80 00 00); withdraw P through wsp.agent.withdraw;
livecount is 1; observe reads exactly 1 — reconstruction,
not subtraction from the rounded snapshot.
E30 arms: lit Q () with one element 5 succeeds and reads
5; lit Q () with zero elements refuses -6 (count); div
of Q weights 5 and 0 refuses -5 (zero). The empty
gradient arm belongs to WS-CONF-3 and is not executed
here.
Support spot checks (section 2.2 at the faces): a delta
built by mul of a supported weight by a rank-zero zero
keeps the support (supporthas finds the premise); an
event learned over it falls when the premise withdraws
(livecount and observe answer accordingly, in the E19
case's own sequence).

Standing batteries re-run at the landing pin, vectors
reported in the lane record: the agent battery
(gate/agent.id), the withdrawal battery
(gate/withdrawal.id), the intent battery (gate/intent.id),
the retract cluster (gate/retract.sh: retract,
retract-faces, retract-predicates), and the slice
batteries of the conformance slices — s1, s2, s3 agent
batteries, the s2 bundle control, the s3 basis control —
whose sources this work order does not touch, re-run as
the configuration control.

## 10. What this spec does not settle

Differentiation (WS-CONF-3), the capsule format
(WS-CAP-1), the relearn and concurrency consumer cases
(WS-CONF-4), and the section 4 faces named in the scope
paragraph remain open under their own orders; nothing
here claims them. E21–E25 and E28–E29 stay blocked on
WS-CONF-4, now standing on these faces where their
blocker said "on top of WS-CONF-2". E30's rank-zero and
zero-division arms unblock with this landing; its empty
gradient arm stays on WS-CONF-3. All speed claims
UNMEASURED.

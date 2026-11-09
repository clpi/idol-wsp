# Executable spec: the weights chapter's differentiation faces

Work order WS-CONF-3 — the named blocker for chapter
examples E09–E12 and the empty-gradient arm of E30 (verdict
table: section 5 of the fleet record
wsp-remainder-successor-2026-11-09.md). This file is the
executable spec for the faces, written before the
implementation, at the resolution the standing spec-first
law requires: an implementer who follows it produces the
faces without further design decisions. The normative
source is the chapter as landed in this repo
(Idol-Weights-Semantics.md, core profile 1): section 6
(differentiation and update construction), with section
4's typing and evaluation rules, section 5's Learn, and
section 7's support discipline. Where this spec fixes a
choice the chapter leaves open, the choice is stated as a
choice.

Scope. The faces specified here are exactly the ones
E09–E12 and the E30 gradient arm exercise: presentation
of a function as an expression over the chapter's
differentiable fragment, its primal evaluation, its ideal
interpretation, and Grad over both, with the update
construction of section 6 of the chapter carried by the
numeric home's existing event, revision, and observe
faces (no new learning machinery). The remaining section
4 operations (Reshape, Permute, Concat, Sum) are not
presented here: their numeric faces are not landed, so no
expression node denotes them yet; they join the fragment
when those faces land, under their own order — a named
remainder, not a silent omission. Explicit Cast inside a
presented function is excluded by the chapter itself
(section 6): there is no cast node; a value is converted
before presentation and enters as a captured constant.

Homes and landing. The faces live in a new home file,
src/grad.id, home wsp.grad, staged into the compiler
tree as lib/wsp/grad.id beside lib/wsp/agent.id and
lib/wsp/numeric.id. No existing home changes: the numeric
home's exported faces are the only arithmetic this home
performs, and premise state is read through the agent
home exactly as the numeric home reads it. The consumer
battery is gate/grad.id, with the standing control
gate/grad.sh, following gate/numeric.sh's shape.

Configuration of record for execution: the compiler
built from the staged tree (C route, --backend=c), the
substrate lib/ml/space.id of that tree, and this repo's
homes staged into that tree's lib/wsp. Speed:
UNMEASURED, every leg.

## 1. Representations

All state lives in file-scope tables and one byte book
in the idiom of src/numeric.id: integer handles, no
string-keyed tables, no strings stored in records.
Strings cross faces as parameters or as freshly built
results of a named face (piece), and every string
comparison goes through a face whose two operands are
parameters (the streq pattern), for the reason the
numeric home's header records (defect class D-FORM).

### 1.1 Expression nodes

A presented function is an immutable expression DAG
whose nodes are rows in the home's books. A node handle
is its row, counting from 1. A constructor accepts only
existing node handles as children, so a child's handle
is always smaller than its parent's: handle order is a
topological order of every expression, and evaluation is
two ascending walks, never a recursion. A node may be
the child of many parents (the presented function may
share a subexpression; E11's constant is the battery's
case).

A node row holds: a kind code; a first and a second
child handle (0 when the kind has none); for a constant
node, the handle of a numeric-home weight; and up to
two texts in the byte book, as an offset and a length
each. Kinds:

 1 input: the differentiated weight. The weight itself
    is not stored; an input node denotes whichever
    weight a primal, ideal, or grad call supplies.
    Several input nodes may appear in one expression;
    all denote the same weight.
 2 constant: a captured weight (a frozen ordinary input
    or a captured observation, chapter section 6). Its
    dtype, payload, and support are the weight's.
 3 add, 4 sub, 5 mul, 6 div: two children, the chapter's
    binary operations.
 7 scale: two children — the value child and the scalar
    child. The scalar child's value must be rank zero
    (chapter section 4: Scale(a, s) with s : W(D, ())).
 8 read: one child and a coords text — a fixed
    coordinate read. The coordinate is fixed at
    construction, independent of any differentiated
    value, as the chapter requires.
 9 replace: the base child, the value child, and a
    coords text — replacement at a fixed position.
 10 broadcast: one child, a dims text, and a map text —
    the chapter's explicit Broadcast.
 11 contract: two children and the two axis texts —
    the chapter's Contract.
 12 branch: one child. Denotes a function that branches
    on a value-dependent condition (the canonical case
    is a branch on whether a differentiated coordinate
    is positive). Constructible so that a presented
    function containing one can be refused by name; it
    is not in the admitted fragment and no evaluation
    in this home performs it.
 13 draw: no children. Denotes a fresh random draw —
    an effect. Constructible for the same reason; not
    in the admitted fragment.

There is no cast node (the chapter excludes explicit
Cast inside the differentiated function) and no node
for Reshape, Permute, Concat, or Sum (scope note
above). A weight-dependent index cannot be expressed:
every coordinate, axis, and map in a node is a fixed
text fixed at construction.

### 1.2 Evaluation state

Each call walks only the nodes reachable from the
presented root; unreachable nodes are not evaluated and
cannot refuse the call. Per call, the home keeps three
handle-indexed tables: the primal value and the ideal
value of each reached node (numeric-home weight
handles), and, inside grad, each reached node's adjoint
(a Q weight of the node's ideal shape). Nothing is
cached across calls: a later call re-evaluates against
the weights it is given.

## 2. Refusals

A face that cannot fulfil its contract produces no
result; it returns a negative code. Every face sets the
home's why code — 0 on entry, the refusal's code on
refusal — and two faces expose it: why() returns the
current code, and refusal() returns the current code's
name. Codes -1 to -17 are the numeric home's, with the
same names, and are propagated unchanged from the
numeric faces that raise them during an evaluation:

 -1 shape, -2 dtype, -3 range, -4 integral, -5 zero,
 -6 count, -7 extent, -8 coordinate, -9 axis,
 -10 broadcast, -11 contract, -12 unknown,
 -13 anchor, -14 resource, -15 text, -16 premises,
 -17 withdrawn (meanings as in spec-numeric-faces.md
 section 2).

This home adds:

 -18 integer: the weight offered for differentiation
    has an integer dtype, I(n) or U(n) (chapter
    section 6: integer inputs reject).
 -19 branch: the presented expression contains a
    branch node (chapter section 6: weight-dependent
    branches reject; no derivative rule for a
    conditional has been admitted). The refusal is
    structural: it does not depend on the values at
    the point (E10 binds the case of a point away
    from the branch).
 -20 effect: the presented expression contains a draw
    node (chapter section 6: fresh randomness
    rejects, as an effect).
 -21 scalar: the presented expression's value at the
    supplied weight is not rank zero (chapter
    section 6: a non-scalar output rejects).

Faces that return a weight or a node handle return the
handle (1 or more) on success and a code above on
refusal.

## 3. Constructors

input: () -> node. A fresh input node.

constant: (w: i64) -> node. w is a live numeric-home
weight handle; the node captures that weight. (The home
cannot count the numeric home's weights, so a handle
that names no weight is the caller's error, exactly as
a bad weight handle is anywhere in this machinery.)

add, sub, mul, div: (a: node, b: node) -> node.

scale: (a: node, s: node) -> node. At evaluation the
scalar child's value must be rank zero, else -1.

read: (a: node, coords: str) -> node. replace:
(a: node, coords: str, x: node) -> node. broadcast:
(a: node, dims: str, map: str) -> node. contract:
(a: node, b: node, axes: str, axes2: str) -> node.
The texts are the numeric home's text conventions
(spec-numeric-faces.md section 5): the same texts the
corresponding numeric faces take, stored in the byte
book at construction and handed to those faces at
evaluation, so a malformed coordinate, axis, or map
refuses at evaluation with the numeric face's own code
(-8, -9, -10, -11, -15 as the case is).

branch: (a: node) -> node. draw: () -> node.

A constructor whose child argument is not an existing
node handle returns -1 and appends nothing.

## 4. The two evaluations

primal: (e: node, w: i64) -> weight handle or code.
The chapter's primal computation: the original function
evaluation under section 4's rules. Leaves: an input
node evaluates to w; a constant node to its captured
weight. Interior nodes evaluate through the numeric
home's faces on the children's primal values: add, sub,
mul, div by their faces (per-coordinate exact operation
over lifted operands, one conversion to the shared
dtype; division refuses -5 on a zero divisor
coordinate); scale by broadcasting the scalar child's
primal value to the value child's shape and multiplying
(the chapter's coordinatewise product with s, converted
once per coordinate — the mul face is that conversion);
read, replace, broadcast, contract by their faces. Any
refusal of any face is the evaluation's refusal,
propagated unchanged and in evaluation order (ascending
handles: the lowest refusing node decides). A branch
node reachable from e refuses -19 and a draw node -20:
this home evaluates only the admitted fragment (a
stated choice — the refusal E10 binds is grad's, and it
is the same code). Any dtype may be evaluated: primal
is ordinary evaluation, and the integer refusal belongs
to differentiation, not to it.

ideal: (e: node, w: i64) -> weight handle or code. The
chapter's ideal interpretation at lift(w): every leaf
is lifted to Q (the numeric cast to Q of w, and of each
captured constant — a floating constant contributes the
value it actually represents, never a lost
pre-conversion literal), and every interior node is
evaluated with the numeric faces at dtype Q, which is
exact rational arithmetic with no rounding boundary.
Division refuses -5 exactly when an ideal divisor
coordinate is zero at the point: the interpretation is
evaluated at the point, not symbolically, so symbolic
cancellation cannot remove a domain obligation
(chapter section 6). For an integer-dtype w the ideal
interpretation is not defined by the chapter and ideal
refuses -18. Branch and draw refuse as in primal.

Neither evaluation mutates anything: expressions,
weights, and premises are unchanged, and a repeated
call at the same weight yields a numerically equal
result under a fresh handle.

## 5. Grad

grad: (e: node, w: i64) -> weight handle or code.
Requires, in this order: w's dtype is Q, F32, or F64
(an integer dtype refuses -18); no branch node is
reachable from e (-19) and no draw node is (-20); the
primal evaluation of e at w succeeds (a refusal is
grad's refusal — E12's first direction, where the
primal denominator is zero, refuses -5 here); the
ideal evaluation succeeds (a refusal is grad's — E12's
second direction, where the primal succeeds but an
ideal denominator is identically zero at the point,
refuses -5 here); and the primal value is rank zero
(else -21).

The result is the Q weight of w's shape whose
coordinates are the exact rational partial derivatives
of the ideal interpretation at lift(w), computed by
the adjoint pass over the ideal values. The root's
adjoint is the rank-zero rational 1. Nodes distribute
their adjoints to their children in descending handle
order (every parent before its children, by section
1.1), accumulating by exact addition:

 - input: the node's adjoint is a gradient
   contribution. The gradient is the sum of the
   adjoints of all input nodes; an expression that
   never mentions its input has the zero gradient of
   the input's shape. That zero still carries the
   supplied input's support, even for an empty input.
   The input is demanded by Grad's contract independently
   of whether an expression input node is reached.
 - constant: nothing. Captured values are not
   differentiated; their support still flows
   (section 6).
 - add: both children receive the adjoint.
 - sub: the left child receives the adjoint; the
   right receives its negation.
 - mul: the left child receives adjoint times the
   right child's ideal value; the right receives
   adjoint times the left child's ideal value.
 - div (u over v): the left child receives adjoint
   divided by v; the right receives the negation of
   adjoint times (u divided by v) divided by v — the
   chapter's (u'v - uv')/v^2 distributed to its two
   arguments, with u and v the children's ideal
   values (v is nonzero: the ideal evaluation has
   already required it).
 - scale: the value child receives adjoint times the
   scalar child's ideal value broadcast to the value
   child's shape; the scalar child receives the sum,
   over the value child's coordinates, of adjoint
   times the value child's ideal value at that
   coordinate (a scalar's adjoint is the contraction
   of the two).
 - read (a, i): a receives the adjoint placed at
   coordinate i in a zero weight of a's ideal shape.
 - replace (a, i, x): x receives the adjoint read at
   coordinate i; a receives the adjoint with
   coordinate i replaced by the rank-zero zero.
 - broadcast (a, T, m): a receives, at each source
   coordinate, the sum of the adjoint over every
   target coordinate that projects to it under the
   broadcast law — the transpose of the broadcast's
   linear map (chapter section 6: the same linear
   mapping applied to derivatives, read in reverse).
 - contract (a, b, K, L): a receives, at each of its
   coordinates, the sum over every coordinate of b
   whose contracted coordinates agree with it, of the
   adjoint at the combined output coordinate times
   b's ideal value at its coordinate; b receives the
   symmetric sum over a's coordinates with a's ideal
   values (the chapter's contraction rule: exact
   product-rule terms summed over paired
   coordinates).

All adjoint arithmetic is the numeric home's faces at
dtype Q — exact, with no rounding boundary anywhere in
the pass. An adjoint computation can refuse only with
a numeric face's code (in practice -14, the resource
bound); such a refusal is grad's.

Empty input: when w's shape has cardinality zero, the
gradient is the empty Q weight of w's shape. The
mechanism needs no special case: the adjoint pass
accumulates into a zero weight of w's shape, which has
no coordinates to accumulate into, and section 6's
support step preserves the shape. E30's constant
function on a (0,3) input is the battery's binding
case.

## 6. Support

The gradient's support is the closed set: the union of
the differentiated weight's support and the support of
every captured constant (chapter section 6: the output
carries input, captured-value, rule, and required
control support, even when the derivative simplifies
to zero). Mechanism: the primal value's support is
exactly that union, because every numeric face forms
its result's support as the union of its demanded
operands' supports and the primal evaluation demands
every leaf of the expression. The implementation forms
the returned weight as the adjoint sum plus a zero
weight of the input's shape carrying the primal
value's support — a value minus itself, whose payload
is zero and whose support is retained (chapter
section 7: numeric cancellation is not evidence
removal; the E24 principle at the face level). The
adjoint sum's own support is a subset of the same
union, so the returned support is the stated one
exactly.

Rule and control support enters the same way it does
for every tracked computation in this machinery: a
caller that needs the differentiation itself
premise-tracked admits a premise over the gradient
through the numeric home's premiseover, which records
that premise's support as including the gradient's.
No second tracking mechanism exists.

Consequence, bound by the battery: an event learned
from a gradient delta under a fresh declared premise
still falls when a premise of the differentiated
weight's support is withdrawn (chapter section 6:
declaring a new training premise cannot remove
dependence on the model used for differentiation).

## 7. Update construction

There are no update faces in this home. A gradient
step is ordinary numeric computation followed by the
numeric home's Learn: the delta is -eta times the
gradient, built with the numeric faces (broadcast of
the rank-zero rational eta to the gradient's shape,
mul, negation by sub from a zero weight), and learned
through the numeric home's event face against the
anchor, under premises the learner declares; revision
and observe are its revision faces. The event's
support is the closure of the declared set unioned
with the anchor's and the delta's supports — the
delta's support is the gradient's (section 6), which
is what makes the section 6 consequence hold
mechanically rather than by assertion.

## 8. The battery contract

gate/grad.id executes the cases below through the
faces and asserts each stated outcome, including every
refusal by its code and its name through the refusal
face. Every check prints one line; the closing lines
give the vector in ok / FAIL form and a PASS or FAIL
word; the program exits 1 on any failure. Cases run in
one process in the order written; premise cases use
premises the battery itself admits through wsp.agent
after wsp.agent.init, so no fixture premise is
disturbed.

E09: w is the Q weight of shape (2) with payload
[2, 3]. The expression is add(mul(r0, r0), scale(r1,
constant 3)) with r0 and r1 the reads of the input at
"0" and "1" and the constant the rank-zero Q weight 3.
primal is rank zero with value 13. grad constructs
with dtype Q and shape (2); its cells are exactly 4
and 3. The delta built as in section 7 with eta the
rank-zero Q weight 0.1 (delta = -(1/10) times grad)
has cells exactly -2/5 and -3/10. Learned through the
numeric faces against a fresh anchor [2, 3] under one
declared premise, the revision observes exactly
[8/5, 27/10].

E09 support arm: a model weight is built as the total
of a revision over an event whose delta is [2, 3]
under a premise P admitted over that delta, so the
model's support is exactly {P} (checked through
supporthas). grad of the same expression at the model
carries P (supporthas). The zero-derivative expression
sub(input, input) — one input node used twice — has
gradient cells exactly 0 and 0 at the model and still
carries P. A delta built from that gradient, learned
against the plain anchor under a second fresh premise,
is live (livecount 1); after P is withdrawn through
wsp.agent.withdraw the event falls (livecount 0).

E10: with wi the rank-zero I(8) weight 5 and f the
expression mul(input, input): grad(f, wi) refuses -18
with name integer; ideal(f, wi) refuses -18. With wq
the E09 weight (a point away from zero): grad of
branch(input) refuses -19 with name branch; grad of
draw() refuses -20 with name effect; grad of
add(draw(), constant 1) refuses -20 — the effect is
found anywhere in the tree.

E11: x is the rank-zero F32 weight 1; c is one
constant node holding the rank-zero F32 weight
16777216, used twice; f is sub(add(input, c), c).
primal(f, x) is the F32 value 0 (its element is the
rational 0 and its word is 0): the primal composition
is not replaced by the identity. ideal(f, x) is
exactly 1. grad(f, x) has dtype Q and value exactly 1.
Contrast at F64: the same construction with F64
weights has primal exactly 1 (16777217 is
representable) and grad exactly 1 — the primal is
genuinely evaluated under each dtype's own law.

E12: one is a constant node holding the rank-zero F32
weight 1 and f is E11's expression. f1 is div(one, f):
primal(f1, x) refuses -5 with name zero, and grad(f1,
x) refuses -5. f2 is div(one, sub(f, input)): primal
(f2, x) is exactly -1, and grad(f2, x) refuses -5
with name zero — both directions of the
differentiation-domain failure.

E30 gradient arm: w03 is the Q weight of shape (0,3)
with no elements; fc is a constant node holding the
rank-zero Q weight 5. primal(fc, w03) is exactly 5.
grad(fc, w03) constructs with dtype Q, rank 2,
extents 0 and 3, and cardinality 0.

Adjoint spot checks (this work order's own, binding
the section 5 distribution rules at the faces; w is
the E09 weight unless stated):
 - div: div(read(input, "0"), read(input, "1")) at w
   has gradient cells exactly 1/3 and -2/9.
 - replace: read(replace(input, "0", constant 5),
   "1") at w has gradient cells exactly 0 and 1.
 - contract: read(contract(input, constant [5, 6],
   "1", "0"), "0") at the Q weight of shape (2,2)
   with payload [1, 2, 3, 4] has gradient cells
   exactly 5, 6, 0, 0 in coordinate order.
 - broadcast: contract(broadcast(input, "2,2", "0"),
   constant ones of shape (2,2), "0,1", "0,1") at w
   has gradient cells exactly 2 and 2 (each source
   coordinate receives the adjoint of both target
   coordinates that project to it).
 - scale: read(scale(constant [4, 5], input), "0")
   at the rank-zero Q weight 3 has primal exactly 12
   and gradient exactly 4 (the scalar child's adjoint
   is the contraction of adjoint with the value
   child's ideal value).
 - scalar: grad of the bare input node at w refuses
   -21 with name scalar.

Standing batteries re-run at the landing pin, vectors
reported in the lane record: the agent battery
(gate/agent.id), the withdrawal battery
(gate/withdrawal.id), the intent battery
(gate/intent.id), the numeric battery (gate/numeric.id
under gate/numeric.sh), the retract cluster
(gate/retract.sh), and the slice batteries of the
conformance slices — s1, s2, s3 agent batteries, the
s2 bundle control, the s3 basis control — whose
sources this work order does not touch, re-run as the
configuration control.

## 9. What this spec does not settle

Reshape, Permute, Concat, and Sum as presented
operations (they arrive with their numeric faces);
differentiation of any function containing a Cast
(the chapter's exclusion, not an omission);
derivative rules for conditionals, transcendental
functions, or any primitive beyond the fragment (the
chapter's extension boundary: verified rules first,
no surrogate gradients); the capsule format
(WS-CAP-1); the relearn and concurrency consumer
cases (WS-CONF-4). E09–E12 and the empty-gradient arm
of E30 unblock with this landing; E27's capsule arms
stay on WS-CAP-1 and the WS-CONF-4 examples stay on
WS-CONF-4. All speed claims UNMEASURED.

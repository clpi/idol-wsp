# Weight semantics — the normative chapter

Received text, landed 2026-11-08. This is the normative chapter for
Idol's weight semantics: the core model, typing and evaluation rules,
learning and exact retraction, differentiation, and the
serialization contract. The weight machinery — the upstream faces
in clpi/idol and this repo's slice — is reconciled against it; the
reconciliation record, with per-rule verdicts and the work orders
the divergences opened, is the fleet-side record
research/idol-weight-semantics-relay-2026-11-08.md in the Idol
workspace.

Provenance: authored by the ChatGPT seat Chris keeps on design duty;
relayed by Chris into the main chat on 2026-11-08; landed here the
same day from that relay, because a normative chapter that lives
only in a chat relay is not in the source of truth.

Received via relay, with a named remainder. What follows is the
received governing text: the core model, the typing and numerical
rules, observations and validity, learning and exact retraction,
aliasing and equality, differentiation, the serialization contract,
examples 1 to 24 in full, the decision table as received, and the
author's evidence section. Not received in the relay, and
outstanding:

- the exact transport record forms (the concrete serialization
  schema the chapter specifies for descriptors, graph applications,
  functions, bound function instances, events, observations, traces,
  and world projections);
- examples 25 to 42 in full text (their topics are named in the
  received text: numerical versus content equality, exact
  conversions, floating function composition, reverse-gradient
  rounding, independent replacement, publication races, module
  forwarding, incomplete bundles, raw checkpoints, writable foreign
  buffers, irreversible exports);
- 6 of the 16 decision entries (the received text shows 10 and
  names the remaining topics).

When the complete chapter file arrives, it replaces this copy and
the replacement is recorded in status.md. Until then this copy is
the normative text of record, gaps named rather than papered over.

Every Idol implementation and performance claim in the chapter is
UNMEASURED, as the chapter itself states; the author's checks ran
outside Idol.

---

It contains a one-page core model, typing and evaluation rules, a concrete serialization schema, 42 examples with stated outcomes, and 16 decisions with alternatives and recommendations.

The central ruling is:

A weight version is immutable. Retraction changes which derivation is valid in a world, then reconstructs the resulting version. It never means subtracting an old floating-point update or silently rerunning training.

All Idol implementation and performance claims are marked UNMEASURED. I checked the numerical examples and a bounded reference model of the retraction rules outside Idol, and checked the serialization framing. Those checks support the design; they do not establish an Idol implementation.

The governing semantics follow below. The file contains the complete chapter, including the exact transport records and all 42 examples.

1. Core model

An ordinary value is a value in Idol's existing semantic system. A scalar is a single number. A descriptor specifies the laws a value obeys. A numeric descriptor, or dtype, specifies its scalar domain, arithmetic, conversions, comparisons, and encoding.

An extent is a nonnegative integer count. A shape is an ordered list of extents. A tensor is a rectangular collection of numbers with one dtype and a shape. A parameter is an explicit function input.

A semantic graph records values, operations, and their dependencies. A node is a record in that graph. An identity distinguishes an authoritative semantic entity; it is neither a memory address nor a hash of its coefficients. A derivation explains how a value was obtained. Provenance retains that derivation, its inputs, and its justification.

A weight is an ordinary tensor marked for parameter use and carrying its derivation. It can be created, passed, returned, captured, inspected, composed, serialized, and learned. It uses Idol's existing graph, arithmetic, descriptors, and identity authority.

A premise is an identified immutable assertion whose acceptance can be withdrawn. A world is an immutable account of accepted and withdrawn premises. Missing premise information is unknown, which is distinct from withdrawal.

A version is an immutable result together with its effective derivation. An observation records a version obtained by evaluating a node in a world. A trace records that evaluation's demanded semantic dependencies. A witness is an observation retained for exact later comparison.

A proposal is a pure computation producing a candidate change. Pure means it reads explicit immutable inputs and performs no external state change. A capture is an input retained by the proposal. Its basis is the base observation on which it depends.

A learning event records one accepted change: its identity, base, proposed payload, justification premises, captured witnesses, and basis requirement. The payload is frozen after creation. Applying the event creates a new version.

An alias is another reference to the same version. A place is separately observable storage that can hold a reference to a current version. Updating a place changes that reference; it does not mutate historical values.

Retraction withdraws a premise and reevaluates the existing derivation in the resulting world. An event with withdrawn justification or invalidated observations is skipped. An event that merely followed another event may survive its removal; an event that read the earlier version must retain and validate that dependence.

Exact retraction means precisely the result of this reconstruction under the recorded numerical laws. Historical aliases remain historical evidence. They cannot silently become current evidence after their witnesses stop matching.

2. Types, shapes, literals, and numerical laws

Write:

* T(d,S) for an ordinary tensor with dtype d and shape S.
* W(d,S) for a tensor qualified as a weight.

These are specification notation, not proposed Idol syntax.

Shape rules

For S=(s_0,\ldots,s_{r-1}), its rank is r, and its cardinality is \prod_j s_j. The empty product is one.

Shape	Meaning
()	Scalar: one coefficient
(0)	Empty vector
(2,0,3)	Rank-three tensor with no coefficients

All extents and cardinality calculations use mathematical integers. They cannot overflow into smaller allocations.

Every evaluated tensor has a concrete shape. A concrete application records its result descriptor, including shape. Reevaluation must preserve that descriptor; a changed structural requirement invalidates the old application. Generic code can explicitly instantiate another application with a different shape.

There is no implicit broadcasting, flattening, dtype promotion, or scalar extraction.

Mandatory numerical profiles

A profile is a fully specified selection of laws.

Profile	Meaning
Z	Exact, unbounded integers
Q	Exact rational numbers in reduced numerator/denominator form
F_{32}	Portable binary32 arithmetic with the chapter's complete floating-point law
F_{64}	Portable binary64 arithmetic with the same explicitly selected law

The floating profiles specify rounding to nearest with ties to even, gradual subnormal behavior, signed zeros, infinities, canonical NaN, conversion rules, and operation order. NaN is the designated nonnumeric result of an invalid floating operation.

Reassociation, wider hidden accumulators, and replacing a multiply followed by an add with a single fused operation are prohibited unless equivalence is proved under the selected law.

A literal initially preserves its exact numeric meaning:

0.1=\frac{1}{10}.

Demanding a floating profile converts that exact value according to the profile. Runtime dtype changes require explicit conversion.

Consequently:

\frac{1}{10}+\frac{2}{10}=\frac{3}{10}

under Q, while the separately specified binary64 operation has its usual rounded result. The language must preserve the selected distinction.

Principal typing rules

Let \Gamma be the environment of known types and facts.

Elementwise addition requires matching dtype and shape:

\frac{\Gamma\vdash a:W(d,S)\qquad\Gamma\vdash b:W(d,S)}
{\Gamma\vdash add(a,b):W(d,S)}.

Multiplication and division use the same shape and dtype requirement, with the numerical domain conditions of d.

Reshape requires equal cardinality:

\frac{\Gamma\vdash w:W(d,S)\qquad \#S=\#S'}
{\Gamma\vdash reshape(S',w):W(d,S')}.

It preserves the coefficient sequence in lexicographic index order, with the last axis varying fastest.

An explicit read produces an ordinary tensor view of a weight. An explicit weight qualifies an ordinary tensor. Each preserves its source observation as a dependency. Neither changes numbers or discards provenance.

Mixed ordinary-tensor and weight operands require one of these explicit conversions to a common qualification.

Composition

A contraction multiplies paired coefficients and sums over explicitly paired axes. Matrix multiplication and vector dot products are instances of contraction.

Contraction has a fixed reference order: enumerate the contracted indices lexicographically, multiply each pair, and add each product to an accumulator initialized to positive zero. Empty contracted domains produce zero.

Three different meanings remain distinct:

Operation	Meaning
Arithmetic composition	Combine numerical values, preserving every use
Function composition	Execute g(f(x)), preserving intermediate rounding and failures
Graph union	Combine compatible records by identity, without adding coefficients or repeating learning

In particular, the compiler cannot assume that sequential B(Ax) equals a materialized (BA)x under a floating profile.

3. Observations and current validity

A general observation is:

o=(n,t,v,\tau),

where n is its producer identity, t its complete descriptor, v its payload, and \tau its trace.

For tensors, this expands to:

o=(n,d,S,A,\tau),

where A contains the coefficients.

The general form matters: Booleans, indices, closures, bytes, and ordinary aggregates need witnesses too. Tracking only tensor reads would allow a learned branch condition to lose its dependency.

Unrelated changes elsewhere in the world do not invalidate a witness. Its comparison excludes unrelated world entries, physical scheduling, memory addresses, and implementation cache details.

Write resolve(n,\Omega) for evaluation of node n in world \Omega.

An old observation is current in \Omega exactly when resolving its producer there returns the same descriptor, payload, and effective trace. Comparing only numbers or premise sets is insufficient.

Three unsuccessful outcomes are distinct:

Outcome	Meaning
Invalid	A known withdrawal or fully determined semantic contract failure
Unavailable	Required evidence, authority information, records, or resources are missing
Unsupported	The required operation or profile has no admitted implementation

These are contract outcomes, not numeric sentinels or a prescribed error-object hierarchy.

A known invalid observation can disable an event that depended on it. Missing evidence cannot be treated as proof that the event should disappear.

4. Learning and exact retraction

Event contents

Every learning event records:

Field	Required meaning
Identity	One fresh authoritative learning occurrence
Base	The node being extended
Mode	Add a payload, or replace with a payload
Payload	Frozen proposed values matching the base's descriptor
Premises	Nonempty explicit justification
Reads	Automatically retained observation witnesses
Basis	Exact base witness, or verified independence
Proposal	Its derivation, captures, creation control, and admission guards
Creation world	The world in which admission was validated

The read set includes the surrounding control that decides whether learning occurs, even when that control is outside the proposal function.

For example, if a learned Boolean controls whether a constant update of 7 is created, the update depends on that Boolean. The constant payload does not make the event independent.

The base must resolve successfully before admission, even for an independent proposal. All checks and the resulting observation must succeed before the event is committed.

Exact basis versus independence

Exact basis is the default.

A proposal that reads its target through coefficients, an extracted scalar, a comparison, a closure, or a gradient requires the version it actually read.

An independent proposal must establish that its payload, selected mode, surrounding control, and admission conditions do not read the target's numerical value or contributing history.

An unchecked annotation cannot establish independence.

This distinction permits:

root = 0
event p: add 1
event q: add 10, independently of the preceding numerical value

to resolve to 10 after withdrawing p.

But a gradient computed at the version containing p cannot survive merely because its own justification q remains accepted.

Evaluation procedure

For an event in a new world:

1. Resolve its base. If the base has no valid result, neither does the event.
2. Check its own premises. A known withdrawn premise disables the event. If none is withdrawn but one is unknown, the result is unavailable.
3. Check its basis and captured witnesses. A known mismatch disables the event. An unresolved check does not by itself establish a mismatch.
4. Apply the frozen payload once if all requirements match.

The eligibility condition is conjunction with three states:

* True when every requirement is true.
* False when at least one is known false.
* Unknown otherwise.

A false condition is sufficient to skip the event without resolving other irrelevant conditions. This does not permit malformed graph records or identity conflicts to hide behind a false condition.

The proposal is not rerun during retraction. Recomputing a gradient or optimizer proposal creates a new learning event, with new witnesses and a new occurrence identity.

Retraction equation

For authorized premise withdrawals R, write \Omega\setminus R for the new world with those premises withdrawn.

Then:

\boxed{retract(n,\Omega,R)=resolve(n,\Omega\setminus R)}.

This is the required result. Incremental implementations may reuse unaffected work, but they must produce the same coefficients and effective trace.

For a fixed graph with no intervening new learning:

(\Omega\setminus P)\setminus Q
=
\Omega\setminus(P\cup Q).

Repeating a withdrawal is idempotent. Withdrawal order does not change the result.

A withdrawn imported root becomes invalid; the system does not invent a zero root. A newly exposed domain failure is reported. Retraction must never preserve revoked content merely to avoid a failure.

5. Aliasing, equality, shared updates, and effects

Aliasing and versioning

An alias to an old weight keeps its old coefficients and trace.

A managed place can later point to a repaired version. The alias does not change with it. Current use validates against the requested world; historical inspection explicitly uses the retained historical context.

Physical in-place optimization is allowed only when no permitted observer—including aliases and historical observers—can distinguish it.

Equality

The chapter defines three separate predicates:

Predicate	Meaning
same(a,b)	Same immutable version: producer, descriptor, coefficients, and effective trace
content(a,b)	Same dtype, shape, and canonical coefficient encodings
numeric(a,b)	Same dtype and shape, with elementwise numerical equality

Default weight equality is same.

For floating weights:

* Positive and negative zero are numerically equal but have different content encodings.
* Canonical NaNs have equal content encodings but compare numerically unequal.
* Identical coefficients with different learned provenance need not be the same weight.

Storage sharing can exploit equal content. It cannot collapse distinct learning occurrences.

Shared updates

One event identity can be referenced by many consumers. Retraction affects every dependent use resolved in that world.

However:

add(w, w)

still uses the numerical value twice.

Graph union deduplicates a repeated event record. Arithmetic does not deduplicate operand positions.

Conversely, two independently created events with identical payloads remain two events.

Publication and external effects

An effect accesses external state or changes observable state. Publication atomically changes a managed place from an expected version to a new current version.

Publication checks the expected place revision and authoritative world revision together. Concurrent writers cannot silently overwrite one another or invent a numerical merge.

Effectful withdrawal and repair are separate operations:

1. Validate and atomically publish the new world.
2. Attempt reconstruction under that world.

Failure of reconstruction cannot undo a successfully published withdrawal or make a stale cached value current.

An external export is also an effect. Retraction cannot unsend a message or erase a result already observed outside Idol. Any compensation is another explicit effect.

6. Differentiation

Automatic differentiation constructs a sensitivity computation from a numerical program. A primal is the original computation. A gradient contains sensitivities for designated input coefficients. An adjoint is the accumulated sensitivity of the final scalar result to an intermediate scalar.

The core selects an ordered reverse transformation.

For d\in\{Q,F_{32},F_{64}\}, a pure function from T(d,S) to a scalar T(d,()) can produce a gradient of type T(d,S).

Computing that gradient does not create a learning event.

Parameter identity

A differentiated coefficient is identified by its explicit input slot and coefficient index.

Therefore:

* Supplying the same weight to two input slots leaves two independent parameter slots.
* Reusing one slot twice ties those uses to the same parameter.
* Sharing storage does not decide parameter identity.

Differentiation starts at these parameter boundaries. It does not accidentally differentiate the entire history that produced a weight.

Reference order

The profile fixes:

1. Scalar expansion of tensor operations.
2. Sharing of repeated uses.
3. Depth-first traversal visiting operands in their declared order.
4. Reverse traversal of that order.
5. Separate contribution accumulation for every operand port.

Reshape, gather, broadcast, and copying rewire coefficients; they do not introduce arbitrary extra accumulation nodes.

Let \lambda be an operation's output adjoint and y its stored primal result. The principal contributions are:

Operation	First input contribution	Second input contribution
y=a+b	\lambda	\lambda
y=-a	-\lambda	—
y=ab	\lambda b	\lambda a
y=a/b	\lambda/b	-((\lambda y)/b)

Each expression follows its written operation order under the selected dtype.

This specifies rounded derivative arithmetic. It does not claim that every algebraically equivalent derivative program produces the same floating-point bits.

Rejections

The core rejects differentiation involving:

* Integer parameters.
* A nonscalar loss without an explicit scalar reduction.
* External effects inside the differentiated function.
* Demanded nonfinite primal or derivative values.
* Unsupported derivative rules.
* Coefficient-dependent indexing, shape choices, or branches.
* abs(0) without another explicitly admitted derivative profile.
* Higher-order differentiation or custom derivative rules without an additional profile.

Independent recorded captures are permitted and retain provenance. A missing derivative is never silently treated as zero.

7. Serialization and module boundaries

A module boundary separates compiled or packaged code. It does not establish a new identity space or grant authority.

Passing a weight across that boundary preserves its descriptor, shape, identity, version, and derivation.

Full serialization includes the observation and the complete information required to validate it and reconstruct it after withdrawal. A numeric projection contains numerical data without claiming that complete contract.

The full bundle contains:

* The exact semantic and wire revisions.
* The observation and its source world.
* Complete graph records and identities.
* Learning events and frozen payloads.
* Original proposal derivations and surrounding control.
* Captured witnesses and creation worlds.
* Numerical and differentiation laws.
* Earlier roots and alternative branches needed after withdrawal.

The chapter specifies canonical framing and exact record forms for descriptors, graph applications, functions, bound function instances, events, observations, traces, and world projections.

A decoder validates the records, authenticates the relevant authority information, checks event admission in the original creation worlds, and reevaluates the serialized observation's producer.

A checksum alone cannot establish complete provenance.

Successful decoding establishes historical validity. Current use still requires validation in the receiving world. An authentic old file cannot revive a premise withdrawn there.

A raw external checkpoint can be admitted as a new root under a new import premise. Withdrawing that premise invalidates the root. It cannot selectively remove unknown training contributions from before the import.

A zero-copy import shares external storage. It is legal only with enforceable ownership or a lifetime guarantee preventing writes. A read-only language view is insufficient if foreign code can still modify its backing memory.

8. Representative conformance examples

These are specification examples, not Idol syntax. Unless stated otherwise, numeric learning and differentiation examples use Q. Idol execution of every example remains UNMEASURED.

#	Example	Required outcome
1	Exact scalar 0.1 + 0.2	Exactly 3/10, numerically equal to exact 0.3.
2	F_{64} 0.1 + 0.2 compared with F_{64} 0.3	Different encodings: 3fd3333333333334 and 3fd3333333333333.
3	Add weights [1,2] and [3,4], both shape (2)	[4,6], retaining both derivations.
4	Add shapes (2) and (1,2)	REJECT: shape mismatch; no implicit broadcasting.
5	Add matching-shape F_{32} and F_{64} weights	REJECT: explicit conversion required.
6	Construct [[1],[2,3]]	REJECT: ragged literal.
7	Reshape empty shape (0) to (2,0,3)	Success: rank three, zero coefficients.
8	Multiply shapes (2,0) and (0,3) by contraction	Shape (2,3) containing six zeros, retaining both input traces.
9	Ordered F_{64} sum of [2^{53},1,-2^{53}]	Positive zero. Reassociation producing 1 is forbidden.
10	f(x)=x_0^2+x_1^2, at [2,3]	Primal 13; gradient [4,6]; no learning event.
11	Shared y=x*x; result y+y; x=2	Primal 8; gradient 8. Every use contributes.
12	f(a,b)=ab, same weight containing 3 supplied to both slots	Gradient pack [3,3]. One-slot h(x)=x^2 instead gives 6.
13	Differentiate abs(x) at zero	REJECT: no admitted derivative at zero.
14	Root 0; independent +1 under p, followed by independent +10 under q	Initially 11; withdraw p → 10; withdraw both → 0.
15	Root 2; two gradient steps for x^2 with step size 1/4, respectively under p and q	Initially 1/2. Withdraw p → 2, because the second step read an invalidated basis.
16	F_{64} root 1; add 2^{53} under p	Initially 2^{53}. Withdraw p → exactly 1. Subtracting the delta from the old result gives 0 and is incorrect.
17	Shared event adds 1 to root 0; evaluate w+w	Initially 2; explicitly resolve after withdrawal → 0.
18	Two distinct events each add 1, under different premises	Initially 2; withdrawing one leaves 1. Equal payloads do not collapse identities.
19	Retain an old alias after withdrawal	Historical inspection preserves its old coefficients; current use rejects it as stale.
20	A zero-valued event is withdrawn, leaving identical coefficients	Its trace changes. A later event requiring that exact version is disabled.
21	A learned condition selects a literal delta 7	The condition's witness remains a dependency. Withdrawing its support disables the update.
22	A required premise is unknown, with no known-false eligibility condition	UNAVAILABLE: the implementation cannot guess whether the event applies.
23	Same serialized event identity appears with different payloads	REJECT: identity conflict.
24	Import an authentic old bundle whose premise is now withdrawn	Historical validation may succeed; current use rejects. Explicit resolution produces the repaired result.

The complete chapter adds examples for numerical versus content equality, exact conversions, floating function composition, reverse-gradient rounding, independent replacement, publication races, module forwarding, incomplete bundles, raw checkpoints, writable foreign buffers, and irreversible exports.

9. Explicit decisions and remaining extensions

The chapter makes its core choices binding. Extensions are not left to backend discretion.

Decision	Options	Selected recommendation
Retraction	Inverse arithmetic; reconstruct; automatically retrain	Reconstruct the fixed derivation. Retraining creates new events.
Weight representation	Mutable object; separate weight system; ordinary immutable value	Ordinary immutable value in the existing graph.
Numerical defaults	Machine float; unspecified real; exact numbers until demand	Exact integers/rationals until a profile is demanded.
Basis dependence	Always exact; always reusable; verified distinction	Exact by default; independence requires verification.
Differentiation	Backend-selected algorithm; fixed forward; fixed reverse; exact accumulation	Specified ordered reverse profile. Other profiles require explicit admission.
Serialization	Payload only; opaque provenance; complete validated derivation	Complete validated derivation for faithful interchange.
Distributed update merging	Last writer wins; sort identities; assume commutation; explicit conflict	Reject conflicting publication. Future merges need explicit order and basis validation, or a proof of commutation under the exact law.
Additional dtypes	Infer behavior from storage; specify complete descriptor laws	Defer quantized, complex, stochastic, and approximate profiles until their laws are specified.
Provenance compaction	Discard history; trust a digest; retain reconstruction or check a proof	Retain reconstruction now. Proof-based replacement requires an admitted exact verifier.
Remote withdrawal freshness	Assume current; promise instantaneous propagation; explicit world knowledge	Explicit world snapshots and authority checks. No freshness claim without a synchronization protocol.

The file contains the full 16-entry register, including portable graph extensions, ordinary optimizer state, external effects, and custom derivative rules.

10. Correctness and implementation evidence

The specification's retraction result follows from a finite, acyclic dependency graph: each root has a defined result or failure; each pure application follows its ordered inputs and law; each learning event has a defined eligibility condition and either applies its payload or resolves to its base. Evaluating that same definition under a changed premise map defines the exact repaired result.

That is a construction argument for the semantics. It is not proof that an existing compiler implements them.

The verification performed for this chapter was:

* 17 bounded numerical and retraction checks, including floating rounding, invalid inverse arithmetic, shared-use multiplicity, changed-basis invalidation, and withdrawal order.
* 12 canonical wire-framing round trips.
* 8 malformed wire encodings rejected.
* Independent reviews of numerical rules, retraction semantics, ordinary-value dependencies, and serialization.

All were outside Idol. Self-hosting, target conformance, compiler correctness, and comparative performance remain UNMEASURED.

The stronger contractual goal is deliberate. PyTorch's documentation limits reproducibility across versions and platforms, while StableHLO documents current gaps in numerical accuracy guarantees and underspecified precision settings. This chapter selects exact laws instead of inheriting such choices implicitly. That establishes a specification target; it does not establish a performance victory.

A conforming implementation must preserve these semantics while exploiting shared immutable data, reuse of unaffected derivations, known shapes, compact identities, and elimination of unnecessary materialization. Benchmark claims require executed evidence against equivalent numerical and retraction contracts.

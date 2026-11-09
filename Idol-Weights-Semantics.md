# Idol: weights as first-class values — normative chapter, core profile 1

Landed 2026-11-08. This file is the normative specification for
Idol's weight semantics, core profile 1. It supersedes
[weight-semantics.md](weight-semantics.md) (the earlier relayed
chapter, a candidate specification), which remains in place
marked superseded.

Provenance: authored by the ChatGPT seat Chris keeps on design
duty; relayed by Chris into the main chat on 2026-11-08 as the
completed chapter (the file Idol-Weights-Semantics.md); landed
here the same day from that relay, because a normative chapter
that lives only in a chat relay is not in the source of truth.
The chapter file itself has not been received as a file; the
text below is the relayed text of record, verbatim. When the
file itself arrives, it is diffed against this copy and any
difference is recorded in status.md.

Transmission defect, recorded not repaired: in the relayed
text, the Contract row of the section 4 operations table is
truncated mid-cell (it ends "Equal dtype; `" followed by a
fragment). The text below reproduces it exactly as received.
The operative Contract rule is the chapter's own section 4
prose after the table (equal-length axis lists of distinct
valid positions with equal corresponding extents; result axes
are the uncontracted left axes followed by the uncontracted
right axes; Contract(a,b,[],[]) is the outer product; a
contracted axis of extent zero gives a zero-element sum)
together with worked examples E05 and E06.

Every Idol implementation and performance claim in the chapter
is UNMEASURED, as the chapter itself states.

---

C Idol: weights as first-class values

Normative chapter, core profile 1 — November 8, 2026

Status. This chapter defines required behavior. It does not report an implementation: compiler conformance, native execution, performance, and comparison with other languages are UNMEASURED. MUST states a conformance requirement; MAY permits an implementation choice. Operation names and mathematical notation below are specification notation, not proposed Idol syntax, namespaces, or newly admitted source spellings. A profile is a named, versioned selection of semantic rules; this chapter fixes its core profile rather than leaving its choices to implementations.

The chapter uses the ordinary meanings of integers, finite sets, ordered tuples, functions, and exact rational arithmetic. An exact rational is a ratio of integers with a nonzero denominator. Canonical means the unique form prescribed by the relevant rule. All other specialized terms are defined before their normative use.

1. Core model — one page

A descriptor is a set of semantic facts constraining a value. A dtype is a numeric descriptor: it specifies the mathematical domain and all observable arithmetic and conversion laws. A shape is an ordered finite tuple of nonnegative integer extents; an axis is a position in that tuple, and a coordinate selects one in-range index on each axis. A weight is an ordinary Idol value whose descriptor says that its payload, its numeric content, maps every coordinate of a shape to a value of one dtype. We write its type as W(D,S), meaning dtype D and shape S. Being first-class means that weights can be bound, passed, returned, captured by functions, stored in ordinary aggregates, and inspected under the same rules as other values. Weight meaning does not prescribe storage, layout, device, or allocation.

A relation is an admitted operation meaning. The semantic graph is Idol’s existing authoritative representation of values, relations, and the facts connecting them. An identity is an exact identity in that graph; a name, storage address, or content hash is not a substitute. A derivation records the inputs, rules, and observations required to produce a fact. A required dependency edge records that producing an output required an input fact. A premise is an explicitly admitted assertion with an immutable identity and content. Its admitting authority is the right to introduce or withdraw that assertion. A configuration is one consistent state of admitted assertions, their validity, and committed graph records. A support is the finite set of premise identities reached by following required dependency edges transitively. Every member is required: a support set means conjunction.

A learned event is one immutable learning occurrence: it associates a base weight, an exact rational delta or additive change, its support, and its derivation. The base is called its anchor. A revision is an immutable anchor plus a finite set of learned-event identities. A snapshot is a weight obtained by evaluating a revision in a configuration. An event is live when all its required premises remain admitted and unwithdrawn. To evaluate a revision, add its anchor and live deltas exactly, coordinate by coordinate, then convert each total once to the anchor’s dtype.

Retraction permanently withdraws a premise identity. It excludes precisely the learned events whose support contains that premise, including dependencies acquired through earlier learning. It does not subtract from an already rounded snapshot, mutate historical payloads, or recompute a different training history. Corrected evidence receives a new premise identity; learning from it creates a new event. Independently supported events keep their identities, deltas, and metadata unchanged.

An effect observes or changes authority-controlled state. Learning, reading the current configuration, and retraction are effects. Arithmetic on a specified snapshot is a pure computation: its result is determined by its inputs and numeric laws. A retained snapshot is immutable, but it is usable as current knowledge only while its support is live. Historical inspection may report withdrawn records; it produces explicitly historical results, which cannot silently enter current computation.

An atomic effect has one indivisible commit point. Rejection means that a required contract cannot be fulfilled: no ordinary result is produced, and a rejected atomic effect commits no change. It is a configuration with an unmet obligation, not a zero weight, missing-value sentinel, or special error object. A known contradiction MUST reject; an optimization MUST preserve payload, failure behavior, and support. All rules use Idol’s existing graph, descriptor, derivation, and effect machinery.

2. Identity, support, and observation

2.1 Identity is not numeric equality

An application is an occurrence of a relation with specified operands. Two applications can have the same operands and numerical result while remaining distinct occurrences. Likewise, two learning occurrences with identical deltas are not automatically the same event.

Weights, descriptors, premises, derivations, events, and revisions MUST use the existing authoritative identity system. Internal compact identifiers MUST resolve exactly and reversibly to that identity. Hashes MAY accelerate lookup; collision resolution MUST compare authoritative identity or content as appropriate. This chapter does not create another identity registry.

2.2 Required dependencies

Provenance is the retained record of required dependency edges and their origins. Support is their transitive premise closure. For a pure application with demanded inputs a₁ … aₙ and required control or rule facts F:

support(result) = support(a₁) ∪ … ∪ support(aₙ) ∪ support(F).

Here demanded means actually required by the relation’s evaluation rules, rather than every record that happens to share a storage location. A condition controlling an output is demanded even when it is not an arithmetic operand. Captured function values, shape and dtype selections, source versions, learner rules, random observations, and optimizer state MUST participate when required. Optimizer state means ordinary values retained by a learning algorithm between updates, such as previous gradients or running averages.

The explicit premises supplied to learning are additional support. They MUST NOT replace support already carried by the computation. Extracting an ordinary number, converting dtype, copying a value, performing arithmetic, comparing values, or folding a result to a constant MUST NOT remove required support. In this core, a multiplication that demands a premise-dependent operand retains that dependence even if another operand is zero. Compiler simplification preserves that semantic lineage.

The graph MUST contain all required edges and MUST NOT add unrelated premises merely because they belong to the same store or configuration. The core defines exactness relative to these specified dependencies; it does not require discovering the mathematically smallest sufficient evidence set for arbitrary programs. A learned event is atomic at its declared delta granularity. A programmer requiring independently retractable pieces MUST produce independently supported events.

Premise assertions created from tracked computations also retain those computations’ support. Giving an old derived value a fresh premise name cannot clear its earlier dependencies. Premise content and dependency records are immutable. Their dependency graph MUST be acyclic; imported or jointly committed records require a valid order in which every dependency precedes its dependent record.

2.3 Current use and historical use

Write usable(C,v) when every premise in support(v) is known and unwithdrawn in configuration C, and the value’s structural and authority obligations have been discharged. Known means that identity, assertion content, authority, and recorded withdrawal state have been resolved. Unresolved evidence is not treated as either live or withdrawn.

Archive(T) denotes historical information about a value of type T; it is a descriptor qualification, not a second object system. Historical inspection can produce an Archive(T) whether or not the original value remains usable. There is no implicit conversion from Archive(T) to T. Recovery for current use MUST validate the retained evidence against a selected configuration and fails if it is withdrawn. Reading archived numeric contents into an ordinary scalar is not a support-erasing escape hatch.

A revision records candidate event identities, including withdrawn events, so it is a reconstruction recipe rather than a snapshot. Its historical references do not require all its candidate events to be live. Applying a candidate requires its support; merely retaining the historical record does not revive it. This distinction uses different dependency facts in the same graph.

An older snapshot can remain usable without being the newest revision. Validity concerns evidence; freshness concerns which revision a caller requested. Neither implies the other. A mutable place is ordinary addressable storage; a place containing a current revision reference can change while all previously referenced values remain immutable.

Evaluation deliberately using an older configuration can reproduce its historical computation. At a boundary requesting current knowledge, that result is historical until its retained support has been revalidated against the current authority state. Naming an older configuration is not permission to undo a later withdrawal.

3. Numeric types, shapes, and literals

3.1 Core dtype profiles

Q denotes exact rational numbers. Their canonical form is a/b, where b>0, numerator and denominator have greatest common divisor one, and zero is 0/1.

For positive integer width n, I(n) denotes integers in [-2^(n−1), 2^(n−1)−1]; U(n) denotes integers in [0,2^n−1]. These profiles use checked arithmetic. They do not wrap, saturate, or truncate.

F32 and F64 denote the finite binary profiles fixed here. They are descriptor projections, not new primitive semantic kingdoms. Their parameters are significand precision p, the number of significant binary digits; emin and emax, the allowed exponent bounds for normal values; and the unit for subnormal values. A normal positive value has form (1+k/2^(p−1))·2^e, with integer 0≤k<2^(p−1) and emin≤e≤emax. A subnormal positive value is k·2^(emin−p+1) with integer 0<k<2^(p−1). Their negatives and a single zero complete the domain:

|Profile|Significand precision `p`|Minimum normal exponent `emin`|Maximum normal exponent `emax`|Subnormal unit|
|-------|------------------------:|-----------------------------:|-----------------------------:|-------------:|
|F32    |24                       |−126                          |127                           |`2^−149`      |
|F64    |53                       |−1022                         |1023                          |`2^−1074`     |

The maximum magnitude is M=(2−2^(1−p))·2^emax.

Define lift(x) as the exact rational number denoted by an existing numeric value. Define convert(D,q) for exact rational q:

1. For Q, return the normalized rational.
2. For I(n) or U(n), require exact integrality and range, otherwise reject.
3. For F32 or F64, first require |q|≤M. Then round to the nearest representable number; an exact tie chooses the value with an even integer significand. At the zero/subnormal boundary the integer coefficient of the subnormal unit supplies the parity. Preserve subnormals and canonicalize every zero to the single positive-zero representation.

The finite profiles exclude NaN, infinity, signed negative zero as a distinct value, flushing subnormals to zero, implicit reassociation, and unspecified rounding. In particular, checking the exact range before rounding is the chosen law; it is not an implicit claim of full IEEE interchange compatibility. A foreign floating law that differs MUST be represented as different facts and explicitly converted or rejected.

A resource limit MAY prevent evaluating a large exact value. That is a resource obligation failure, never permission to wrap an integer, approximate Q, or silently change dtype. Mathematical arithmetic is independent of the host machine used to compile Idol.

3.2 Shape and coordinate laws

For S=(s₀,…,sᵣ₋₁), rank is r; cardinality is N(S)=∏sᵢ; valid coordinates are tuples (i₀,…,iᵣ₋₁) with 0≤iⱼ<sⱼ. The empty shape () has cardinality one and its sole coordinate is (). It denotes a scalar. Any zero extent gives cardinality zero. Negative, fractional, or missing runtime extents reject.

Coordinates have canonical lexicographic order with the last axis varying fastest. This specifies enumeration, reshape, and serialization, not physical layout. Shapes remain distinct even when their cardinalities agree. In particular, (0,3) and (0,4) are different shapes.

A symbolic extent is a compile-time variable standing for an extent. Static checking MAY preserve equations between symbolic extents. At evaluation, each extent MUST have one concrete value and all required equations MUST hold. An implementation unable to prove a static obligation MAY emit its runtime check. It MUST NOT assume an unresolved equality.

3.3 Literal construction and ordinary values

Literal(D,S,[q₀,…,qₙ₋₁]) constructs a weight when n=N(S) and every convert(D,qᵢ) succeeds. Integer and finite-decimal literal meanings are exact: 0.1 denotes 1/10 before a descriptor demands conversion. Without an explicit dtype demand, a weight literal uses Q. A nested presentation MUST describe a rectangular array; ragged input rejects. An empty nested presentation must supply enough shape information to distinguish empty shapes.

An ordinary numeric scalar can become a rank-zero weight by explicit descriptor qualification; a rank-zero weight can expose its scalar value with support intact. An ordinary finite numeric sequence can become a weight through checked shape and dtype construction. There is no implicit tensor-to-Boolean rule, scalar expansion, dtype promotion, or conversion of a learned value into an unconditional literal.

4. Typing and evaluation rules

A typing environment Γ records known value types and shape equations. Write Γ ⊢ e : T for “expression e has type T.” Write C ⊢ e ⇓ v for successful evaluation to v in configuration C; rejection means that this judgment has no successful result. The symbol → in a type denotes a function from its left-hand type to its right-hand type. The term pure function means a function whose evaluation has no effects. All ordinary input values MUST be usable in C; support propagates as specified in Section 2, even where abbreviated below.

|Operation notation                            |Typing obligation                                                                                                   |Payload rule                                                                                                                                                               |
|----------------------------------------------|--------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`Add(a,b)`, `Sub(a,b)`, `Mul(a,b)`, `Div(a,b)`|`a,b : W(D,S)` with exactly matching dtype laws and shape                                                           |At each coordinate apply the named rational operation to lifted operands, then `convert(D,…)`; division requires a nonzero divisor. `Mul` is coordinatewise multiplication.|
|`Scale(a,s)`                                  |`a:W(D,S)`, `s:W(D,())`                                                                                             |Coordinatewise product with `s`, converted once per coordinate.                                                                                                            |
|`Cast(D′,a)`                                  |`a:W(D,S)`                                                                                                          |Result `W(D′,S)` with `convert(D′,lift(a[i]))`; conversion is explicit.                                                                                                    |
|`Read(a,i)`                                   |`a:W(D,S)` and a valid coordinate `i`                                                                               |Ordinary scalar of dtype `D`, retaining input and index support.                                                                                                           |
|`Replace(a,i,x)`                              |Valid coordinate and scalar `x:D`                                                                                   |New `W(D,S)` with one coordinate replaced. The old value is unchanged; required support is retained.                                                                       |
|`Reshape(a,S′)`                               |`N(S)=N(S′)`                                                                                                        |Same canonical element sequence with shape `S′`. No inferred `−1` axis.                                                                                                    |
|`Permute(a,π)`                                |`π` is a bijection on axis positions                                                                                |Output shape has `S′[j]=S[π(j)]`; for output coordinate `o`, read input coordinate `i` with `i[π(j)]=o[j]`. No arithmetic.                                                 |
|`Broadcast(a,T,m)`                            |`m` injectively maps each source axis into target axes; each mapped source extent equals the target extent or is one|Target coordinates project to corresponding source coordinates, using zero on singleton source axes; unmapped target axes repeat.                                          |
|`Concat(a,b,k)`                               |Same dtype, equal rank, valid axis `k`, equal other extents                                                         |Concatenate on axis `k`; result extent there is the exact sum.                                                                                                             |
|`Sum(a,K)`                                    |`K` is a set of distinct valid axis positions                                                                       |Remove axes `K`; for each remaining coordinate sum the lifted operands exactly and convert once. A reduction with zero participating elements sums to zero.                |
|`Contract(a,b,K,L)`                           |Equal dtype; `                                                                                                      |K                                                                                                                                                                          |
|`Compose(g,f)`                                |Pure `f:A→B`, `g:B→T`, with matching intermediate descriptor                                                        |Function `x ↦ g(f(x))`, preserving both evaluations and their rounding boundaries.                                                                                         |

For example, the addition type rule is:

Γ ⊢ a:W(D,S), Γ ⊢ b:W(D,S)  ⇒  Γ ⊢ Add(a,b):W(D,S).

Its evaluation rule is:

usable(C,a) ∧ usable(C,b) ∧ ∀i, c[i]=convert(D,lift(a[i])+lift(b[i])) succeeds

⇒ C ⊢ Add(a,b) ⇓ W(D,S,c).

An empty result does not waive descriptor, shape, authority, or support obligations. Operations with no payload coordinates still retain support from their demanded inputs. Broadcast cannot map a zero-length source axis to a nonzero target extent. Broadcasting a singleton axis to zero is valid and produces no coordinates. Axis lists with duplicates or invalid positions reject.

Selecting no reduction axes is different from reducing a zero-length axis: Sum(a,∅)=a in numeric value, while a reduced axis of extent zero produces correctly shaped zeros. Contract(a,b,[],[]) pairs no axes and is the outer product, with one exact product per output coordinate. A contracted axis of extent zero gives a zero-element sum instead.

Matrix multiplication is Contract pairing the last axis of a rank-two left operand with the first axis of a rank-two right operand. Thus (m,k) contracted with (k,n) produces (m,n). In particular, (m,0) with (0,n) gives an (m,n) weight of zeros.

Composition of weights is explicit: coordinatewise combination uses the arithmetic relations, structural combination uses shape relations, and linear-map combination uses contraction. A weight is callable only when an ordinary function or descriptor supplies an application rule. A matrix does not acquire an implicit model architecture merely from being a weight.

Exact contraction differs observably from separately rounded products followed by a reduction. Likewise, composing two floating functions is not automatically equivalent to multiplying their coefficient matrices or removing intermediate rounding. Such transformations require equivalence under the actual descriptors, including rejection and provenance behavior.

The same rules apply at compile time and runtime. Sparse, dense, tiled, packed, vectorized, or device-resident representations MAY implement the same coordinate function. A representation change MUST NOT change descriptor laws, support, or required failure behavior.

5. Learning, revisions, and exact retraction

5.1 Logical records

The following are logical facts in the existing graph/tables, not a prescribed database or second intermediate representation. A receipt is an immutable record of a committed effect or validated observation. A confidence is an exact rational in [0,1] supplied by a learner; it is metadata, not proof of truth or correctness.

|Record       |Required facts                                                                                                                                                           |
|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|Premise      |Identity, immutable assertion, admitting authority, required dependencies, and admission receipt; withdrawal is a separate immutable receipt referenced by configurations|
|Weight       |Identity, dtype facts, shape, payload or equivalent derivation, required dependencies                                                                                    |
|Learned event|Occurrence identity, anchor identity, delta `W(Q,S)`, explicit nonempty premise set, required input/rule dependencies, confidence, creation receipt                      |
|Revision     |Identity, one anchor `W(D,S)`, finite set of candidate event identities with that exact anchor, and the support of the computation that selected its recipe              |
|Snapshot     |Weight result, revision identity, observation receipt, included event identities, retained required support                                                              |

A pattern in an Idiom store is the retained learned-event record. Its created and retracted status is derived from receipts and support, rather than a second independently mutable truth flag. An index storing that status MUST agree with the derivation.

Event deltas always have Q dtype, even when the anchor has integer or floating dtype. This is an additive change represented using ordinary weight values, not a special numeric domain. A delta MAY exceed the anchor dtype’s range; the materialized total determines representability.

5.2 Learn

Learn(C,b,δ,P,c) requires anchor b:W(D,S), delta δ:W(Q,S), a nonempty declared premise set P, confidence c∈Q∩[0,1], admitted learner rules, and authority to commit. The event’s support is:

T(e) = closure(P ∪ support(b) ∪ support(δ) ∪ support(c) ∪ support(required observations and rules)).

Here closure expands premise assertion dependencies as well as dependencies through values. Learning atomically validates every member of T(e) against the committing configuration and records the complete event. It returns its event reference and receipt. It does not automatically change a current model or add the event to every revision.

Event creation does not require any chosen aggregate to fit the anchor dtype: no aggregate has yet been selected. Shape, delta, support, confidence, identity, and authority checks still apply. An application wanting “publish only a representable revision” can atomically combine event creation, revision construction, observation, and a current-place update; any failed obligation then aborts that combined publication.

A retry using an already committed occurrence identity and an identical body is idempotent. It reports the existing record and its current status; it does not create a contribution or revive withdrawn support. The same identity with a different body rejects. A separate learning occurrence receives a separate identity even if its numeric delta and premises match an earlier occurrence.

5.3 Revision construction and observation

Revision(b,E) is well formed when E is a finite set of distinct, resolvable event identities and every event names b as its exact anchor. Its selection support, U(R), records required premises of computations that selected its anchor or membership, including conditional decisions. Candidate event references are historical identities: unconditionally including a known event reference does not add that event’s live-premise requirements to U(R). Reading event contents or testing live status to choose membership does acquire the required support. This distinction prevents both evidence loss and invalidation of an entire recipe merely because a candidate event retracts.

Extend(R,e) adds one event identity to the set and retains U(R) plus support required to choose the addition. Merge(R₁,R₂) requires the same exact anchor, returns the union of their event sets, and retains both selection supports plus required merge-control support. Thus merge is associative, commutative, and idempotent on membership; these laws do not erase provenance from the merge computation. Equal anchor payloads do not establish equal anchor identities or support.

Query(C,R) requires a usable anchor, live selection support U(R), and resolved records for the fixed inventory E. It returns the live subset:

L(C,R) = {e∈E | every p∈T(e) is known and unwithdrawn in C}.

It also records the inventory and decisions that determined this subset. For an excluded event, at least one permanent withdrawal receipt justifies exclusion. An unresolved required premise blocks the query; it is not silently excluded. The query result acquires U(R), the support of included events, and the anchor’s support. Permanent withdrawal receipts and immutable inventory membership justify exclusions without pretending that a withdrawn premise is live.

The fixed inventory is essential. A later event insertion elsewhere cannot change the earlier query. The core does not admit learning from an unrecorded query such as “no matching event exists anywhere in the changing store.” Such a query requires separately specified membership and absence evidence. An event MUST NOT depend on a query scope whose result changes merely because that same event is being created.

Define the exact total Total(C,R):W(Q,S) by:

Total(C,R)[i] = lift(b[i]) + Σ(e∈L(C,R)) δe[i].

Define materialization by:

Observe(C,R) = Cast(D,Total(C,R)).

All addition inside Total is exact. Conversion occurs once per result coordinate. No iteration order, device scheduling, or merge order changes the answer. A zero delta still retains its event identity and support; it is not silently forgotten. A snapshot requires the anchor and every included event, even if rounding or cancellation hides a numeric contribution.

Total and Observe have the same support: U(R), the anchor, all included events, and required observation facts. An implementation MAY maintain a cached exact total or an index of reverse dependencies, but cache reuse requires matching recipe, numeric laws, and validity decisions. A cached rounded snapshot alone is insufficient to continue a revision or undo a contribution.

5.4 Retraction

Retract(C,p) requires a known premise identity and authority to withdraw it. It commits a permanent withdrawal receipt and a new configuration C′. For the previously live event set L(C) in the affected store:

L(C′) = {e∈L(C) | p∉T(e)}.

This equation includes indirect dependencies because T is transitive. Every surviving event’s identity, delta, confidence, and derivation remain unchanged. Withdrawn event records remain available historically.

Retracting a known premise with no dependents succeeds and affects zero events; it still records withdrawal, preventing a racing learner or old import from using it later. Retracting an already withdrawn premise is an idempotent no-op. An unknown identity or missing authority rejects rather than fabricating a premise.

Retraction MUST commit even if removing a cancelling delta makes a revision’s new total unrepresentable. Subsequent Observe then rejects. It MUST NOT return the previous snapshot as current, drop a surviving event, saturate the result, or reverse the withdrawal to retain a usable model.

Correction creates a new premise identity. Relearning creates a new event with newly checked dependencies. The earlier premise does not reactivate. If a base’s own support is withdrawn, observing its revision rejects; the base is not silently replaced with zero. A base copied from a learned snapshot retains that snapshot’s support.

5.5 What exact retraction does and does not mean

If an event declared under a premise Qp was computed from a snapshot that depended on another premise P, its support includes both. Withdrawing P retracts that event too. The same applies to optimizer state, control decisions, cached features, and ordinary scalars derived from the snapshot.

Counterfactual retraining means running a learner again as though withdrawn evidence had never entered its training history. It may produce different surviving deltas, orders, and state. This chapter specifies exact dependency retraction, not automatic counterfactual retraining. An explicit replay can perform the latter using retained inputs, learner identity, update order, and random observations; replay creates new events. It cannot be reported as unchanged survival of old events.

One event with support {P,Qp} requires both premises. Two distinct events with equal deltas under independent supports each contribute once. One shared event identity contributes once in any revision, however many branches referenced it. Alternative evidence meaning “P or Qp is sufficient for the same event” is not implicit in any of these cases.

5.6 Concurrent effects

Learning and retraction have atomic commit points. A computation may use a pinned configuration, meaning a fixed configuration selected for that evaluation. Before a new current effect commits, it MUST validate the required support against the current authority state. Therefore learning either commits before a competing retraction and is then invalidated, or observes the retraction and fails validation.

Replacing a place that holds the current revision MUST validate the expected old revision or explicitly create a branch. It MUST NOT silently overwrite a newer revision. A read of a changing place records the version actually observed. Numerical validity does not promise that the place still contains that version.

Retraction cannot undo an external action already committed, such as bytes already sent to an uncooperative receiver. End-to-end current validity requires the receiver to retain and validate the same evidence. A disconnected receiver may claim validity only relative to an explicitly named configuration, not that it knows the latest withdrawal state.

6. Differentiation and update construction

A partial derivative is the rate of change of a scalar function when one coordinate varies and the others remain fixed. A gradient is the tuple of partial derivatives with respect to a weight’s coordinates. The primal computation is the original function evaluation. The core defines one differentiable fragment: finite pure expressions built from weight inputs, constants, Add, Sub, Mul, Div, Scale, fixed-coordinate reads, fixed replacement positions, and the linear shape/reduction/contraction operations of Section 4. Functions may compose within this fragment. Shapes and index choices MUST be fixed independently of the differentiated coordinates.

For inputs of dtype Q, F32, or F64, define the function’s ideal interpretation by lifting represented numeric inputs and constants to exact rationals and replacing each admitted arithmetic operation and its numeric rounding boundary with its rational operation. This gives a rational expression, which has an ordinary real-valued extension wherever every denominator in the original ideal graph is nonzero. Symbolic cancellation MUST NOT remove such a domain obligation. Floating constants use the values they actually represent, not a lost preconversion source literal. Explicit Cast operations inside the differentiated function are excluded from this core; conversions can be performed before entering the function and their results treated as captured constants.

Grad(f,w) requires w:W(D,S), a pure scalar-output function f, successful primal evaluation, and a well-defined ideal interpretation at lift(w). It returns W(Q,S) whose coordinates are the exact rational partial derivatives of that ideal interpretation at lift(w). It does not claim to differentiate the discrete mapping between floating encodings. Its output carries input, captured-value, rule, and required control support, even when the derivative simplifies to zero.

For one differentiated coordinate, write u′ for its derivative. The required rules are:

|Ideal expression                                                        |Derivative                                                                  |
|------------------------------------------------------------------------|----------------------------------------------------------------------------|
|Constant independent of the coordinate                                  |`0`                                                                         |
|The selected input coordinate                                           |`1`                                                                         |
|A different input coordinate                                            |`0`                                                                         |
|`u+v`                                                                   |`u′+v′`                                                                     |
|`u−v`                                                                   |`u′−v′`                                                                     |
|`uv`                                                                    |`u′v+uv′`                                                                   |
|`u/v`, with `v≠0`                                                       |`(u′v−uv′)/v²`                                                              |
|Fixed projection, reshape, permutation, broadcast, concatenation, or sum|Apply the same linear mapping to derivatives                                |
|`Replace(a,i,x)` at fixed `i`                                           |`Replace(a′,i,x′)`                                                          |
|Contraction                                                             |Sum exact product-rule terms over paired coordinates                        |
|Composition                                                             |Substitute using these rules; preserve the primal’s separate evaluation laws|

Forward, reverse, symbolic, or mixed evaluation MAY implement these rules using the same derivation machinery. A correctness witness is checkable evidence that a required rule or obligation holds; a user-supplied unverified derivative is not such evidence. Integer inputs, weight-dependent branches or indices, mutation, live-store reads during differentiation, fresh randomness, unknown primitive rules, and a non-scalar output reject in this core. Frozen ordinary inputs and captured observations are allowed when their support is retained. An empty input weight has an empty gradient with that input shape, provided the scalar function meets the other requirements.

For exact learning rate η:Q, an ordinary gradient step can construct δ=−η·Grad(f,w) and submit that W(Q,S) to Learn. This records the gradient’s acquired dependencies; declaring a new training premise cannot remove dependence on the model used for differentiation. No optimizer or hidden mutable training state is built into the language rule.

If a caller wants the next observed revision to equal a specific target weight t:W(D,S), it can compute δ=Cast(Q,t)−Total(C,R) and learn that delta against the same anchor. With all other contributing events unchanged and a valid commit, extending R by that event yields t. The event depends on the total it read. Computing a correction from only the rounded snapshot can lose the revision’s retained exact residual and does not establish this replacement contract.

7. Equality and sharing across compiled code

Three comparisons are distinct:

|Comparison         |Definition and use                                                                                                                                                                                                                                                                                                                                         |
|-------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`Numeric(a,b)`     |Boolean result for weight snapshots: true exactly when dtype laws and shape match and all canonical numeric coordinates are equal. Different dtype or shape returns false. It retains both inputs’ support.                                                                                                                                                |
|`Same(a,b)`        |Exact authoritative value or occurrence identity. Equal numbers do not establish this relation. Inspecting historical identity remains explicitly historical where required.                                                                                                                                                                               |
|`Equivalent(R₁,R₂)`|Revision membership equivalence: same exact anchor identity and the same event-identity set. The Boolean result retains required evidence from both inputs. It does not compare only rounded snapshots, erase selection support, or assert that the revision objects have the same occurrence identity. Substitution must separately preserve all evidence.|

Cross-dtype numeric comparison requires an explicit conversion or a separately expressed mathematical comparison. Q equality compares normalized rationals; finite floats have no NaN anomaly or negative-zero distinction in this profile. Approximate comparison, if wanted, is ordinary computation with an explicit tolerance and retained support; it is not weight equality.

Two aliases, meaning references to the same immutable weight, continue to denote the same value. Functional replacement or learning produces a new value or event. Assignment to a place changes only the reference stored there. An implementation MAY share buffers, eliminate copies, or reuse storage when no supported observation can distinguish the result. It MUST preserve the payload and evidence of any still-observable alias or historical snapshot.

Numeric equality permits sharing physical bytes; it does not permit merging different evidence, forgetting an event, or substituting one revision for another. In particular, equal floating snapshots can have different exact totals and diverge after the same later update.

A compilation boundary is a boundary between separately compiled producers and consumers; the term does not introduce a language module or namespace. Crossing it MUST preserve dtype laws, shape obligations, value identity where exposed, and required support. A callable interface MUST describe required effects and authority as well as value descriptors. An import path grants no authority.

There is no implicit detach operation. A foreign numerical buffer is neither proof of dependency completeness nor proof that its numeric laws match. Adopting external raw data as a new base requires a newly admitted source premise and explicit numeric conversion. It is an opaque imported assertion, not restoration of an earlier learning history. Known evidence attached to a native value MUST NOT be discarded through raw export/import. A receiver cannot claim retraction of upstream facts it never received or resolved.

8. Serialization and restoration

A capsule is a serialized graph closure sufficient to restore one declared root and its required facts. A closure here means the root and all transitively referenced records necessary to validate its meaning. Serialization into a byte sequence is pure; external file or network access is an effect. Two native capsule kinds are defined:

1. A value capsule preserves one weight’s exact descriptor, shape, canonical payload, identity, and provenance. If the weight is a snapshot, it additionally preserves its revision reference, included-event set, and observation evidence. Plain literal and composed weights serialize directly; serialization does not fabricate a revision or change their identity.
2. A revision capsule preserves the anchor and its support, every candidate event and exact rational delta, premise assertions and authority references, required derivation closure, confidence values, revision membership, and relevant admission/withdrawal receipts. It preserves the exact total needed for future continuation; storing only a rounded snapshot is insufficient.

The capsule MUST distinguish historical withdrawal evidence from claims of current validity. A bare numeric array is a third, external input case governed by Section 7, not a native capsule with inferred empty support.

8.1 Canonical structural encoding

The native envelope begins with bytes 49 44 57 01 in hexadecimal, followed by one canonical unsigned length and that many bytes of one encoded root map. The root map MUST consume exactly that declared length. A standalone capsule has no bytes after its envelope: incomplete input, unused bytes within the declared body, and trailing bytes reject. The following structural encoding is part of profile 1 and requires no external serialization runtime:

• An unsigned length uses little-endian groups of seven value bits, most significant bit indicating continuation. The shortest encoding is required; zero is the single byte 00.
• Tag 00: absent optional field value. Tag 01: false. Tag 02: true.
• Tag 03: integer, followed by sign byte 00 for nonnegative or 01 for negative, an unsigned byte length, and a big-endian magnitude. Zero has sign 00 and length zero; other magnitudes have no leading zero byte.
• Tag 04: byte string, followed by unsigned length and exact bytes.
• Tag 05: list, followed by unsigned element count and consecutively encoded elements.
• Tag 06: map, followed by unsigned entry count and encoded key/value pairs. Keys are byte strings in strictly increasing lexicographic byte order; duplicate keys reject.

The graph codec is the existing graph’s versioned interface for exact identity and record encoding. Define these schema types: I is a byte string containing one authoritative identity encoded by that codec; Refs is a list of distinct I values sorted in strictly increasing lexicographic byte order; Shape is a list of nonnegative integers; Qvalue is a normalized two-integer list [a,b]; Absent is tag 00. Refs represents a set, not an evaluation order. Every map below has exactly the listed keys. An unused optional value is explicitly Absent; its key is not omitted. Role names are interchange fields, not native operation vocabulary.

The envelope has this closed schema:

|Key            |Exact value type and meaning                                                                                            |
|---------------|------------------------------------------------------------------------------------------------------------------------|
|`codec`        |Byte string identifying the existing graph codec and exact version; the receiver must recognize this complete identifier|
|`configuration`|`I` referencing the configuration whose observation/admission evidence the capsule records                              |
|`kind`         |Byte string `value` or `revision`                                                                                       |
|`records`      |List of record maps in increasing encoded `id` order                                                                    |
|`root`         |`I` referencing a `weight` or `snapshot` for a value capsule, or a `revision` for a revision capsule                    |

Each record map has exactly body, id, and kind; id:I, and kind is one of the byte strings in the following table. For compact notation only, ValueBody means the six fields descriptor, shape, payload, dependencies, derivation, and support specified in the weight row. It is not another wire tag or semantic class.

|Record `kind`|Exact `body` fields, with types and reference roles                                                                                                                                                                                                                         |
|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`descriptor` |`profile`: bytes `q`, `i`, `u`, `f32`, or `f64`; `width`: positive integer for `i`/`u`, otherwise `Absent`. These names select exactly the laws of Section 3.                                                                                                               |
|`weight`     |`descriptor:I` to a descriptor; `shape:Shape`; `payload`: list of scalar encodings for that descriptor; `dependencies:Refs`; `derivation:I` to a graph derivation; `support:Refs` to premises.                                                                              |
|`premise`    |`assertion:I` to a graph assertion; `authority:I` to a graph authority; `dependencies:Refs`; `derivation:I`; `support:Refs`; `receipt:I` to its admission receipt. Support records dependencies of the assertion, excluding its own identity.                               |
|`event`      |`anchor:I` to a weight or snapshot; `delta:I` to a Q weight or snapshot of matching shape; nonempty `premises:Refs`; `dependencies:Refs`; `derivation:I`; `support:Refs`; `confidence:Qvalue` in `[0,1]`; `receipt:I` to its creation receipt.                              |
|`revision`   |`anchor:I` to a weight or snapshot; `events:Refs` to events naming that exact anchor; `dependencies:Refs` for selecting the recipe; `derivation:I`; `support:Refs` equal to selection support `U(R)`. Candidate `events` are historical references, not required-live edges.|
|`snapshot`   |All six ValueBody fields, plus `revision:I`; `events:Refs` containing exactly the included events; `receipt:I` to the observation receipt.                                                                                                                                  |
|`graph`      |`encoding`: byte string containing one canonical complete record of the existing graph codec.                                                                                                                                                                               |

In every row, dependencies are direct required edges, not an arbitrary caller-supplied list. The derivation specifies the governing rule, operand roles, and validation evidence. support is a checked cache of the transitive premise requirements, never authority to omit dependencies. The graph codec validates the reference roles. It MUST NOT hide or redefine weight descriptors, payloads, shapes, event deltas, confidence, premise membership, or revision membership inside opaque graph records. Opaque records carry only existing substrate facts: assertions, authorities, ordinary non-weight values when required, derivations, configurations, and receipts.

The graph codec MUST supply canonical identity encoding/decoding, canonical substrate-record encoding/decoding, exact identity resolution, semantic role inspection, derivation-rule validation, and authority/receipt validation. Each record is bound to its exact authoritative identity and immutable content. Mere decoding does not establish validity. A receiver without the named exact codec or a required verifier rejects adoption. The codec MUST preserve identity across participants; a hash or file-local counter is insufficient. These are explicit interfaces to Idol’s existing graph substrate, not a second weight identity authority.

Every core capsule carries its full validation closure, or refers to records already identically resolved in the receiving authoritative graph. A portable self-contained capsule MUST include every such record that is not a fixed, admitted substrate fact of the named codec. A value capsule rooted at a snapshot therefore includes its revision and required event history. Profile 1 admits no abbreviated snapshot certificate that substitutes an unchecked claimed support list for that closure. Dependency-closed export does not require copying unrelated store records.

configuration references an immutable graph record identifying the relevant admitted assertions, withdrawal receipts, and observation state. It does not assert current receiving authority. A withdrawal is a separate immutable graph receipt identifying its target premise and authorized action. Premise and event bodies never change to store a new live/retracted flag.

Q payload elements and confidence values encode as Qvalue. Integer payloads use integer encoding and descriptor range checks. F32/F64 payload elements encode as four/eight-byte big-endian strings with sign, exponent, and fraction fields of lengths 1/8/23 and 1/11/52, exponent biases 127 and 1023, respectively. For nonzero exponent field e and fraction integer f, the value is (-1)^sign·(1+f/2^fractionbits)·2^(e−bias); for zero exponent it is (-1)^sign·f·2^(1−bias−fractionbits). All-one exponent fields and negative-zero encodings reject. Payload list length is exactly the shape cardinality, with elements in canonical coordinate order.

The reader rejects noncanonical integers or lengths, non-normalized rationals, incompatible profiles, malformed payload cardinality, duplicate identity records, conflicting bodies, cycles in required dependencies, unresolved required records, unknown schema fields or versions, and inconsistent cached support. Length and cardinality computations MUST be checked before allocation; exhausting resources rejects without a partial import. A future version can extend the format; an old reader MUST NOT guess its meaning.

8.2 Validation and authority

Decoding produces an unadopted historical candidate. Adoption is the effect that validates identities, schemas, numeric laws, derivation completeness, and authority and then integrates accepted records atomically into the receiving graph. Required support MUST be recomputed or verified from admitted derivation rules and exact bound receipts; an arbitrary serialized list of premises is not proof that no dependency was omitted. Unknown operation meanings or unverifiable dependency claims block adoption.

Identical existing immutable records are reused. Reusing an existing identity with different immutable content rejects. Withdrawal receipts are separate immutable records; importing new valid receipts augments the known history without rewriting the premise’s body. A local withdrawal cannot be overwritten by an older capsule’s “active” claim. A pinned configuration establishes validity only in that named configuration. Adoption may retain its records historically, but activating an assertion or authorizing a current effect requires validation against the current admitted authority state under Section 5.6. A pinned configuration cannot override a later withdrawal. Unresolved external authority leaves the candidate available only historically.

Successful value round-trip preserves numeric payload, descriptor laws, shape, identity, and support. Successful revision round-trip additionally preserves event membership, selection support, and exact continuation behavior. Round-trip equality is claimed under the same resolved configuration; it does not assert that withdrawn premises remained live during transit.

9. Worked examples and required outcomes

The following are semantic examples, not claims that this syntax is accepted by Idol. They are independent unless stated otherwise. W_D[S](…) abbreviates literal construction; Q is the rational dtype and P,Qp,Rp are distinct live premise identities. A statement that an event is “under P” means an independently constructed event whose support is {P} unless additional dependencies are stated. All unstated authorities and structural obligations are satisfied. Expected results below are specification-derived; native execution is UNMEASURED.

E01 — exact decimal intent

Add(W_Q[()](0.1), W_Q[()](0.2)) produces scalar 3/10, numerically equal to W_Q[()](0.3). No binary floating conversion has been demanded.

E02 — finite binary conversion

Cast(F32,W_Q[()](0.1)) is exactly 13421773/134217728 when lifted back to Q. Its canonical F32 bytes are 3d cc cc cd. It is not numerically equal to a Q weight without explicit conversion because dtypes differ.

E03 — shape mismatch: rejected

Adding shape (2) payload [1,2] to shape (1,2) payload [[3,4]] rejects. Equal element count does not satisfy equal shape.

E04 — explicit broadcasting

Broadcast [10,20,30] of shape (3) to (2,3), mapping source axis zero to target axis one. Adding it to [[1,2,3],[4,5,6]] yields [[11,22,33],[14,25,36]]. Omitting the broadcast rejects.

E05 — contraction and application

Contract [[1,2],[3,4]] of shape (2,2) with [5,6] of shape (2) across the matrix’s last axis and the vector’s only axis. The result has shape (2) and payload [17,39].

E06 — empty dimensions

Contract a (2,0) weight with a (0,3) weight. The result is shape (2,3) with six zeros. By contrast, adding (0,3) and (0,4) rejects despite both inputs having zero elements.

E07 — aliases and functional replacement

Let a and b alias the same W_Q[(2)]([1,2]). c=Replace(a,(0),9) has payload [9,2]; both a and b remain [1,2]. Their original identities and evidence are unchanged.

E08 — dtype and conversion checks: rejected

Adding W_Q[()](1) to W_F32[()](1) rejects for incompatible dtypes. Cast(I(8),W_Q[()](1/2)) rejects for nonintegrality. Checked Add of I(8) values 127 and 1 rejects for range overflow.

E09 — rational gradient

For w=[2,3]:W(Q,(2)) and scalar f(w)=w₀²+3w₁, the primal is 13 and Grad(f,w)=[4,3]:W(Q,(2)). With η=1/10, the delta is [-2/5,-3/10]. Learning that delta against anchor [2,3] and observing the resulting revision yields [8/5,27/10].

E10 — unsupported differentiation: rejected

Differentiating an integer-typed weight rejects. Differentiating a function that branches on whether its differentiated coordinate is positive also rejects in this core, even at a point away from zero: no derivative rule for that conditional has been admitted. A fresh random draw inside the function rejects for an effect.

E11 — floating primal and ideal gradient

Let f(x)=(x+2^24)−2^24 under F32 and x=1. The primal result is 0 because the first addition rounds. The ideal interpretation is x, so Grad(f,x) is rational 1. Replacing the primal composition with identity would incorrectly change its result to 1 and is forbidden.

E12 — differentiation requires both domains: rejected

At the same F32 x=1, 1/((x+2^24)−2^24) has a zero primal denominator and rejects. Conversely, 1/(((x+2^24)−2^24)−x) has primal result −1 but an identically zero ideal denominator; its gradient rejects too.

E13 — independent learning and precise survival

Use rational anchor [10,20]. Learn eP with delta [1,0] under P and independently learn eQ with delta [0,2] under Qp. Revision {eP,eQ} observes [11,22]. Retract P: the live set is exactly {eQ} and observation is [10,22]. The complete eQ record is unchanged.

E14 — transitive learning

Use scalar anchor 0. Event eP contributes 2 under P. A new event eQ declares Qp but computes its delta as three times the snapshot containing eP; its delta is 6 and its actual support is {P,Qp}. The combined revision observes 8. Retracting P retracts both events and observes 0. Claiming that eQ survives because its caller mentioned only Qp is invalid.

E15 — shared events and distinct occurrences

With scalar anchor 0, let eP contribute 1. Merging two revisions each containing that same identity gives 1, not 2. A second independent event eP2 with delta 1 is a different occurrence; a revision containing both gives 2. Retracting a premise required by both excludes both.

E16 — conjunctive support

An event with delta 7 and support {P,Qp} is withdrawn when either premise is withdrawn. It does not remain live merely because the other premise survives. Alternative justification is not implicit.

E17 — no dependents and repeated retraction

Retract known premise Rp with no dependent events. The affected count is 0, and Rp becomes permanently withdrawn. Repeating the retraction changes nothing and again affects 0 events. Learning from Rp afterward rejects.

E18 — relearning after correction

After E13, admit corrected premise P′ with a fresh identity and learn a fresh independent event eP′ with delta [3,0]. A revision containing old eP, live eQ, and new eP′ observes [13,22]; old eP stays withdrawn. Reusing withdrawn P instead of P′ rejects.

E19 — floating retraction must reconstruct

Use F32 anchor 0, event eP with rational delta 2^24 under P, and independent eQ with rational delta 1 under Qp. Observation rounds exact total 2^24+1 to 2^24. Retract P: reconstruction gives 1. Subtracting 2^24 from the old rounded snapshot would give 0; that rollback is wrong.

E20 — identical numbers do not restore validity

Start again from E19 but retract Qp. The new observation is still 2^24. The old snapshot nevertheless remains dependent on withdrawn Qp and cannot be used as current knowledge. A freshly observed value has different valid evidence despite identical payload.

E21 — equal snapshots, different revisions

Use F32 anchor 2^24. Revision R₀ has no events; R₁ contains one rational +1 event. Both snapshots equal 2^24. Adding a distinct second +1 event to each gives 2^24 for R₀ and 2^24+2 for R₁. Numeric snapshot equality does not establish revision equivalence.

E22 — withdrawal can expose overflow

Use I(8) anchor 100, independent delta −100 under P, and delta +100 under Qp. Both live observe 100. Retract P: the withdrawal succeeds, the Qp event survives unchanged, and the new exact total is 200. Observe rejects the I(8) range obligation. It does not return stale 100.

E23 — rational delta can exceed target range

Use I(8) anchor 127 and rational delta −255. The observed total is −128, which is representable and succeeds. Requiring the delta itself to fit I(8) would incorrectly exclude this valid revision.

E24 — pure numeric replacement preserves support

Extract scalar 11 from the E13 snapshot, multiply it by zero, and retain the resulting scalar 0. It still carries {P,Qp} because those operands were demanded. After retracting P, historical inspection can show 0, but using it to learn a current event without retained validation rejects. Numeric cancellation is not evidence removal.

E25 — opaque dependent base

Copy E13’s [11,22] snapshot into a proposed new anchor. The copy retains {P,Qp}. After P retracts, observing a revision rooted in that copied anchor rejects, even with no new events. It cannot claim to have removed P by discarding the earlier event list.

E26 — boundary and capsule round-trip

Serialize the full E13 revision, then restore it into an authority-consistent receiver after P has been withdrawn. Identity and support validation succeeds, eP remains withdrawn, and observing gives [10,22]. The saved earlier snapshot [11,22] is available historically but fails current validation. An old “P active” field cannot overwrite the receiver’s withdrawal.

E27 — malformed or unsupported import: rejected

Restoring an event identity whose delta differs from the existing record rejects an identity conflict. A snapshot whose support authority cannot be resolved remains historical and is rejected for current use. A capsule omitting necessary derivation records or claiming a cyclic dependency rejects. No fake empty-support weight is returned.

E28 — fixed-scope absence

Take a revision whose fixed inventory is {eP}, and withdraw P. Query returns an empty live set with the permanent withdrawal receipt. A learner can use that fixed-scope observation; later creation of eQ does not add it to the old inventory. Learning from an untracked assertion that “the entire changing store contains no event” rejects in this core.

E29 — concurrency

A learner computes a delta requiring P; another operation withdraws P. If learning commits first, retraction subsequently excludes it. If withdrawal commits first, learning fails validation. There is no allowed outcome in which a post-withdrawal commit publishes a live P-dependent event.

E30 — rank-zero, empty gradient, and zero division

W_Q[()](5) contains one scalar. A constant scalar function f(w)=5 on an input with shape (0,3) has an empty Q gradient of shape (0,3). Constructing a literal of shape () with zero payload elements rejects. Dividing any nonempty scalar weight by zero rejects rather than yielding infinity or a sentinel.

E31 — selecting a recipe carries evidence

Suppose a Boolean derived under P chooses between including independent event eQ and an empty inventory. The chosen recipe has selection support containing P, even though eQ itself requires only Qp. After retracting P, observing that selected recipe rejects for invalid selection evidence. The eQ event survives untouched, and a separately, unconditionally constructed recipe containing it remains usable. Membership comparison with that independent recipe does not erase the earlier selection dependence.

10. Decisions and extension boundary

The core decisions below are closed by this chapter. They are not implementation preferences.

|Decision            |Options considered                                                                                  |Core choice and reason                                                                                                      |
|--------------------|----------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|
|Value updates       |Observable in-place mutation; immutable values with explicit places                                 |Immutable values; this preserves aliasing, provenance, and historical meaning while allowing physical storage reuse.        |
|Delta domain        |Anchor dtype; exact rational dtype                                                                  |Exact rational deltas; avoids premature rounding and permits changes larger than the target range when their total is valid.|
|Revision aggregation|Device-dependent reduction; fixed rounded fold; exact sum then one conversion                       |Exact sum and one conversion; supports deterministic set-union merging and removal without relying on floating inverses.    |
|Default literal     |Machine float; exact source numeric meaning                                                         |Exact rational default; numeric conversion is demanded explicitly.                                                          |
|Shape compatibility |Implicit broadcasting/promotion; explicit shape operations                                          |Explicit operations; shape and numeric law changes are inspectable obligations.                                             |
|Learned support     |Caller-supplied labels only; complete required derivation                                           |Complete derivation plus declared premises; prevents dependency omission.                                                   |
|Shared updates      |Deduplicate equal deltas; deduplicate event identity                                                |Identity; equal payloads can represent distinct contributions.                                                              |
|Retraction          |Subtract rounded result; replay surviving event set; automatically retrain                          |Reconstruct exact surviving total; replay of the learner is a separate operation producing new events.                      |
|Floating gradient   |Derivative of finite encoding map; unstated straight-through behavior; explicit ideal interpretation|Explicit rational ideal derivative, with both domains checked and Q output.                                                 |
|Serialization       |Numeric bytes only; identity and derivation capsule                                                 |Capsule for native knowledge; raw imports are new explicitly supported external assertions.                                 |
|Withdrawal state    |Reactivate the same identity; terminal withdrawal                                                   |Terminal withdrawal; corrected evidence gets a new identity, making old evidence and absence receipts unambiguous.          |

The following are explicit open extension decisions. They are not admitted core behavior. Until an extension is selected and specified, an implementation MUST reject a request requiring it.

|Decision                                        |Options                                                                                    |Recommendation and required next contract                                                                                                                                                                                                                      |
|------------------------------------------------|-------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|Multiple sufficient justifications for one event|Duplicate contributions; one event with alternative proof sets                             |Choose explicit alternative proof sets if needed. Define identity, one-contribution counting, and liveness under surviving alternatives before admission. Do not reinterpret conjunctive support.                                                              |
|Full floating and quantized domains             |Widen existing finite laws; separate descriptor profiles                                   |Add distinct profiles. Specify NaN, infinity, signed zero, saturation, scales, zero points, and every conversion; preserve existing meaning.                                                                                                                   |
|More differentiation                            |Automatic guesses; verified rules for more primitives; generalized derivatives             |Add verified primitive rules first. State domains and exact or bounded-approximation results for transcendental functions and explicit rules for nondifferentiable points. No silent surrogate gradients.                                                      |
|Distributed freshness protocol                  |Shared authority commit point; coordinated replication; explicitly pinned offline operation|Preserve the core distinction between current validation and pinned evaluation. Recommend a shared authority commit point initially. Specify replication/revocation guarantees before extending the meaning of current validity across independent authorities.|
|Learning from mutable global queries            |Store-generation dependency; exact membership/absence evidence; fixed inventory only       |Retain fixed inventories in core. Add exact scoped membership/absence evidence when justified, with acyclicity and invalidation rules.                                                                                                                         |
|Imported code and opaque learners               |Trust serialized claims; verified graph derivation; explicitly trusted authority receipt   |Prefer verified derivations. Permit a trusted receipt only when its authority and exact dependency contract are explicit; it must not acquire trust merely through an import path.                                                                             |

The selected graph codec must be the repository’s existing authoritative graph codec; if that codec lacks the portable encoding, role inspection, or verification interfaces specified in Section 8, native capsule interoperability is blocked until those interfaces exist. Substituting hashes is not a permitted fallback. This is an explicit integration obligation, not a claim that a current codec has been inspected. Core weight-specific schemas and numeric laws are fully specified here; the existing graph substrate remains the explicit integration parameter.

11. Conformance and performance obligations

A conforming implementation MUST establish:

1. Type preservation: successful operations produce the declared dtype and exact shape; every required check is either established or performed.
2. Numeric determinacy: identical operands and descriptors produce the specified result or rejection, including compile-time evaluation, empty axes, conversion, and contraction boundaries.
3. Support preservation: all required data, control, rule, and observation dependencies survive optimization, ordinary-value projection, boundaries, and persistence.
4. Exact retraction: the Section 5 set equation holds; surviving records are unchanged; repeated withdrawals and identical-event retries are idempotent.
5. Alias preservation: learning and retraction do not mutate old payloads; invalid evidence cannot become current by copying or conversion.
6. Transactional validity: races have only the specified atomic outcomes; cache reuse and current effects revalidate required support.
7. Restoration integrity: native round-trip preserves identity, numeric meaning, provenance, and continuation semantics; unknown or contradictory claims fail closed.
8. Native closure: all admitted arithmetic, derivation, differentiation, record operations, validation, and serialization can execute in pure Idol without depending on a foreign numerical runtime, host solver, tensor library, or separate learning engine.

The examples are acceptance obligations, not a passing test report. An implementation should exercise each valid example and rejection, repeat them across serialization and compilation boundaries, and compare indexed retraction against the defining event-set equation. A source-only test or external arithmetic oracle does not establish native compiler correctness.

The architecture permits sharing exact dependency records, indexing premise-to-event edges, maintaining exact accumulator components, specializing shapes, fusing kernels under the declared numeric laws, and eliminating unused materialization. These are opportunities for less duplicated work. None is a measured claim of superior runtime, compile time, startup, memory use, or binary size.

|Claim                                                      |Status in this deliverable                     |
|-----------------------------------------------------------|-----------------------------------------------|
|Semantic and rejection rules specified                     |Defined by this chapter                        |
|Worked examples have stated outcomes                       |31 examples, including explicit rejection cases|
|Existing compiler conforms                                 |**UNMEASURED**                                 |
|Native dependency-free implementation executes the examples|**UNMEASURED**                                 |
|Incremental invalidation is faster than rebuilding         |**UNMEASURED**                                 |
|Performance beats comparable languages                     |**UNMEASURED**                                 |

12. Architectural basis and scope of evidence

The chapter’s weight-specific rules are new normative decisions made here. The supplied project documents establish the architectural constraints used to make them; they do not establish an existing implementation of this chapter.

• Semantic Reconciliation, pass 2.19: one semantic identity; separation of value from storage; world-based authority; foreign law preservation; transformation lineage.
• Semantic Unification, pass 2.26: preserve one semantic meaning while factoring qualifications and avoiding parallel operation vocabularies.
• Primitive Decomposition, pass 2.30: dtype decomposition, observable numeric laws, exact literal meaning before demanded representation. Its historical numeric proposals do not already settle the finite profiles selected here.
• FTCFTW, pass 2.29: preserve realization freedom, compact identity, demand-driven materialization, and the distinction between architectural potential and measured performance.

The current request’s name, Idol, controls this chapter. Historical project names and syntax in the supplied passes do not establish additional syntax requirements here.

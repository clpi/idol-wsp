# Exact revision merge and fixed-feature ridge

This slice extends the existing `wsp.numeric` producer. It adds no second
rational, support, event, or revision store. All coefficient arithmetic
uses the existing exact Q weight operations and their resource refusals.

## Revision algebra

`extend(revision, additional_event_text, additional_selection_text)`
retains the original exact anchor, event identities, and transitive
selection support. `merge(left, right)` requires the same exact anchor
handle. Each delegates to the existing `revision` constructor, which
validates the whole recipe and deduplicates repeated event identities.
Distinct events with equal payloads remain distinct. A rounded observation
is a new weight and cannot stand in for the original anchor.

`inventory(revision)` and `selection(revision)` expose the historical
candidate handles and retained selection identity texts. They do not
claim the candidates are currently usable. A withdrawn event remains a
valid historical candidate and is excluded by the existing live walk;
withdrawn or unknown selection refuses current construction and use.
`equivalent` keeps its existing historical membership contract and is not
an equality of selection recipes or provenance identities.

Membership merge is associative, commutative, and idempotent where the
constructors admit their inputs. Those laws concern event identity sets;
they neither identify equal-valued events nor merge distinct anchors.
Selection support is unioned, so the laws cannot erase an obligation.
The explicit F32 control starts at 2^24: either +1 singleton observation
rounds to the anchor, while merging the two distinct exact +1 events and
observing once produces 2^24+2.

## Fixed-feature model

An example has exactly one scalar Q feature `x` and scalar Q label `y`.
The fixed model predicts `intercept + slope*x`. The intercept is not
penalized, and the scalar Q slope penalty must be nonnegative.

`example(anchor, x, y, support)` constructs an ordinary event whose delta
is `[1, x, y, x*x, x*y]`. The anchor is a Q vector of length five. The
example therefore uses the same event identity, support validation, and
withdrawal mechanism as every other numeric event. The fixed model/schema
and learning rule belong in the revision's selection support. Examples in
the gate use a zero anchor; nonzero anchors are caller-supplied exact prior
sufficient statistics and are not silently interpreted as new examples.

For the current retained-data total `[n, sx, sy, sxx, sxy]`, define

```
d = n * (sxx + penalty) - sx * sx
slope = (n * sxy - sx * sy) / d
intercept = (sy - slope * sx) / n
```

`fit(revision, penalty)` returns a Q vector `[intercept, slope]`. An empty
system or zero determinant refuses with `-18` / `singular`; a negative
count or determinant refuses `contract` before either singularity check.
This precedence also applies to `condition` and to caller-supplied priors.
Shape, dtype, withdrawn support,
unknown support and exact arithmetic resource refusals propagate from the
existing producers. Every derived coefficient retains all demanded data,
schema, rule and penalty support even when its numeric payload is zero.

`condition(revision, penalty)` reports the exact infinity-norm condition
number of the positive definite 2-by-2 normal matrix:

```
kappa = (max(n, sxx + penalty) + abs(sx))^2 / d
```

It is a diagnostic exact Q value, not a tolerance-dependent rejection.
The gate separately classifies a system with features 1000 and 1001 and
zero penalty as ill-conditioned (`kappa = 4016024016004`) while its exact
solution remains `[0, 1]`. Repeated features and zero penalty are singular;
a positive slope penalty makes the nonempty rank-deficient case invertible.

## Independent controls

The bounded dataset is `(1,1), (2,3), (3,8)` with slope penalty one.
The gate enumerates every subset withdrawal and independently creates new
events from retained original inputs under a fresh zero anchor. It compares
all exact sufficient statistics, rebuilt coefficients, independently
specified rational coefficient and condition-number oracles, live support
membership, and historical invalidity. The full solution is `[-2/3, 7/3]`.
All eight subsets are covered, including the empty singular case.

Run:

```sh
IDOL_ROOT=/absolute/path/to/idol sh gate/frontier.sh
```

`IDOL_BIN` selects the binary, `IDOL_BUILD_LOCK` selects the shared build
lock, and `WSP_ARTIFACTS` selects the parent of isolated evidence stages.
The gate requires native `merge` and `ridge` success, reruns the related
hosted C regressions, and proves that omitting selection propagation makes
the native merge oracle fail with exactly the named selection-loss assertions,
their complete summary, and their expected exit status. An unrelated crash
does not qualify the mutation. Python 3 supplies hashing and result-admission
transport; the numerical decisions still execute in the named Idol routes.
The compiler is copied into the stage so a different artifact filesystem is
supported. The runner hashes every staged compiler-library, grammar, runtime,
gate, driver and compiler input, and compares both bytes and file roster after
restoring its declared mutant. It prints check diagnostics before refusing.
The executed record is
[evidence/frontier/README.md](evidence/frontier/README.md).

## Boundary

This is a bounded exact learner for one fixed feature with an intercept.
It does not establish general model unlearning, path-dependent optimizer
retraction, privacy, generalization quality, or a performance advantage.
The underlying Q implementation is exact within its declared bounded
resource profile and may refuse instead of approximating.

Event handles retain the existing WSP fixture-generation-local identity
contract. `inventory` text is not a self-authenticating persistent event
capsule. Native numerical execution is qualified here; fresh-process event
serialization, compiler-discovered implicit support, concurrent publication,
and global revocation remain separately tracked work.

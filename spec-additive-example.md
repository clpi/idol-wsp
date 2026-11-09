# Executable example: a fixed-schema additive learner

This example exercises the existing `wsp.agent` and `wsp.numeric`
faces. It adds no model registry, graph, optimizer, or public face.
Its source is `gate/additive.id`. Its result is a semantic
demonstration; quality, performance, privacy, and full core-profile
conformance remain UNMEASURED.

## Learner and reference

The fixed representation has one feature, identically 1. For a
nonempty collection of scalar rational labels, the head minimizes
the sum of squared errors over an intercept. Its sufficient
statistics are `[sum of labels, number of labels]`, and its exact
coefficient is their quotient. There is no trained encoder,
codebook, randomized update, or optimizer state.

Each admitted example contributes one independent Q-delta
`[label, 1]` against the same zero anchor. Its event declares the
example premise and the schema and learner-rule facts it consumes.
The fixed-inventory recipe explicitly retains schema and rule
selection support. Merely referencing a candidate event does not
import that example's support into recipe selection.

The deletion comparator is a fresh run of this same learner over
explicitly retained examples, constructing new events from their
original inputs. Compare exact statistics first, then the exact
coefficient, prediction, and support. Comparing a revision with
itself or using its cached total as the rebuild input is insufficient.
This reference does not represent arbitrary gradient training.

## Required observations

Use independent labels 1, 3, and 8. Initially the statistics are
`[12, 3]` and the head is 4. Withdraw the example with label 3.
The same fixed inventory must retain all three event identities;
the live set has two members, the statistics become `[9, 2]`, and
the head becomes `9/2`. The known withdrawal receipt names the
deleted example. The retained events retain their identities and
their contributions. A fresh retained-data rebuild must agree
exactly and must not carry the deleted premise.

A snapshot of the earlier coefficient remains historically 4,
retains the deleted premise, and fails `usable`; it cannot be
learned under a fresh unrelated premise. The rebuilt coefficient
remains usable and carries both surviving example premises plus
the schema and rule facts. A fixed prediction computed from it
preserves those supports.

The example also checks repeated references to one event versus
separate equal occurrences, a zero-valued label that still
contributes count and support, and reconstruction after all
examples withdraw. An empty retained set has statistics `[0, 0]`;
head reconstruction refuses zero division. Withdrawing the schema
or learner-rule selector blocks the recipe's current query even
when its inventory is empty. Missing evidence blocks validation
instead of supplying an exclusion receipt.

## Boundary

The input/support associations in this example are explicit. A
green run does not establish that the compiler discovers all
dependencies in arbitrary source programs. `usable` and current
revision queries exercise consumer validation, not a concurrent
model-publication transaction. Agent bundles are not complete
numeric event/revision capsules. There is no claim that a mean
predictor is a useful coding model, or that its deletion cost
outperforms retraining at any scale.

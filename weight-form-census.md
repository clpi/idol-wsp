# Weight-form census — weight-form-census-1

Identifier: weight-form-census-1. This file is byte-identical in
clpi/idol-wsp and clpi/idol-wide. Both repos' README indexes carry
the same entry line with this identifier and the link
`weight-form-census.md`, so dispatching from either product
reaches this same census artifact. The check
`tools/check-weight-form-census.py` (byte-identical in both
repos) fails if either index entry or this table is missing or
diverges.

## Question

For every weight represented in weight space programming (WSP)
and in Wide, which deterministic program input form does it map
to — ordinary graph representation, ordinary syntax and grammar,
or intent — how much weight falls in each form, and what is
still unmapped? Weights are first-class program values in the
one derivation machinery (a weight is a table plus a shape
descriptor; learning is premise-tracked reweighting), never a
lookup table between systems; the forms below are the forms in
which those program values are expressed.

## Method and pins

A row is one weight-bearing home or artifact as it exists at the
census pins: clpi/idol-wsp 87e31a2f5d83993295982cf13e075c306a37a0f5
and clpi/idol-wide 2c27cdc1acd400cbc6696fd0cc00b4f8686f35b7.
Each row carries exactly one primary form. Shares are shares of
rows, counted from the table below. Shares by weight mass
(parameter count, bits per weight) are UNMEASURED.

## Census table

| Row | Weight-bearing surface | Form | Evidence |
|---|---|---|---|
| 1 | WSP agent seatings as bundle graph facts (seating, premise, record, call lines citing by digest) | graph | learned/bundle.txt at the WSP pin: 75 lines, 24 of them seating lines (counted 2026-11-10) |
| 2 | WSP differentiation weights as an immutable expression DAG (node rows, children older than parents) | graph | src/grad.id header at the WSP pin |
| 3 | Wide census book cells and members over the graph census | graph | src/census.id header at the Wide pin |
| 4 | WSP numeric weights as factored rationals built through source faces in Idol syntax | syntax | src/numeric.id header at the WSP pin |
| 5 | Wide session weights: a weight-space program opened as a program file, reweighted as a replacement seat | syntax | src/wide.id header at the Wide pin |
| 6 | WSP expression discipline: weight space as intent space, commit before selection | intent | Idol-Weights-Semantics.md section 13 at the WSP pin; its derived battery gate/intent.id is recorded 25 / 0 in status.md at an earlier pin (recorded, not rerun for this census) |
| 7 | Wide intent book: intents declared as derivations-to-be with rule word and premise citations | intent | src/intent.id header at the Wide pin |
| 8 | Wide blueprint learned slots: named in statements, no face seats a learned filling | unmapped | src/blueprint.id header at the Wide pin (learned half DIB-261 unbuilt) |

## Totals

| Form | Rows |
|---|---|
| graph | 3 |
| syntax | 2 |
| intent | 2 |
| unmapped | 1 |
| total | 8 |

Row shares: graph 3 of 8, syntax 2 of 8, intent 2 of 8,
unmapped 1 of 8. Weight-mass shares: UNMEASURED.

## What is still unmapped

Row 8 is the unmapped remainder at these pins: blueprint learned
slots have a name in syntax but no deterministic input form that
seats their weight — no graph fact, no grammar production, and
no intent declaration produces them, because the learned half
that would fill them is unbuilt. The live census fold over the
semantic graph (Wide gap WIDE-GAP-CENSUS remainder) and the
machinery declaration producer (gap WIDE-GAP-INTENT) are also
unlanded; when either lands, this census is re-run at the new
pins and rows move out of unmapped only on executed evidence.

## Check

Run from either repo, naming both repo roots:

```sh
python3 tools/check-weight-form-census.py <idol-wsp root> <idol-wide root>
```

It verifies: this file exists in both repos and is byte-identical;
the identical README entry line with identifier
weight-form-census-1 and link weight-form-census.md exists in
both repos; the check script itself is byte-identical in both
repos; and the totals above equal a recount of the census table,
with every form present. Exit 0 is a pass; exit 1 names the
divergence.

# Current-evidence qualification — 9 November 2026

This record covers the source and artifact hashes in [manifest.json](manifest.json).
The actual published [gate/core.sh](../../gate/core.sh) completed with exit 0.
All eleven gates compiled through the real Idol hosted C route and their
executables exited 0. This is executed evidence for this cohort, not a
full core-profile, native-route, privacy, model-quality, or speed claim.

## Results

| Gate | Successful printed assertions | Output |
|---|---:|---|
| Agent | 126 | [agent](output/agent.txt) |
| Withdrawal | 22 | [withdrawal](output/withdrawal.txt) |
| Occurrence identity and admission | 134 | [identity](output/identity.txt) |
| Intent | 25 | [intent](output/intent.txt) |
| Numeric | 98 | [numeric](output/numeric.txt) |
| Revision | 227 | [revision](output/revision.txt) |
| Differentiation | 92 | [grad](output/grad.txt) |
| Additive learner | 106 | [additive](output/additive.txt) |
| Deep standing | 27 | [standing](output/standing.txt) |
| Serialized artifact consumer | 26 | [bundle](output/bundle.txt) |
| Existing retraction battery | Aggregate PASS | [retract](output/retract.txt) |

Total: **883 explicitly printed successful assertions**, plus the existing
retraction battery. No failure was printed in the final cohort. The manifest
records each source, executable and output hash, and both process exit codes.

## Baseline discrimination

The initial expanded gates were also executed against WSP main
`e5abd8bc8eb743ae5bca432da0151882a0cecfb9`. All three compiled successfully
and exited 1 because assertions failed:

| Expanded gate against baseline modules | Passed | Failed | Output |
|---|---:|---:|---|
| Revision | 199 | 28 | [revision](baseline/revision.txt) |
| Differentiation | 82 | 10 | [grad](baseline/grad.txt) |
| Identity, initial 98-case gate | 43 | 55 | [identity](baseline/identity.txt) |

These are failing assertions, not counts of independent defects. Those exact
gate hashes passed against the first delivered candidate. The final revision
and differentiation gate hashes are unchanged; the identity gate was then
extended to cover a record/call-history gap identified during review.

The final 134-case identity gate was executed against the prior accepted
agent source, local commit `6c94879c8dbfcc0e03e1f8b8f2e512bbd5a90fc2`
(the same tree as remote PR head `9252c858fe2d8a782a3c4d69f54bc1cbb1d6c6e9`).
It compiled successfully, then exited 1 with **105 passed / 29 failed**
assertions. [The review discriminator](baseline/identity-history.txt) records
stale history truncation, conflicting derivation/citation fields, and changed
call names/results. The manifest retains separate source and gate hashes for
both phases; it does not attribute the earlier 98-case run to the final gate.
No cache is used as the correctness reference.

## Compiler and route

The recovered successful compiler build is identified by:

- Binary SHA-256: `c0c39b04c2368ee919c3fa456766d5f87bb60a761ccd3118e602282fc5a2f6f1`.
- Recorded source HEAD: `d2fd7095724556d56a24e81d6c1c3df222a27d6e`.
- Recorded index tree and clean dependency archive:
  `5795bf3b34b93bc628bf51b02205a22d5af15a14`.
- Source-manifest SHA-256:
  `b1951f58d4cfc169fca7c7ff29b076b822cf9de17ad8ba8a77a58fed356aaa3f`.

[compiler.json](compiler.json) preserves the build receipt and host tool
versions. This qualification reused that recorded binary; it did not rebuild
the compiler and does not identify it as a pristine HEAD or latest-main build.
[dependencies.json](dependencies.json) records the initial isolated staging
and dependency hashes. [inputs.sha256](inputs.sha256) records the final staged
WSP source, gates, binary and artifact.

Each gate was compiled with `--no-cache --backend=c --emit=exe --libc` and
executed under the shared `idol-lock`. The product homes remain Idol source;
the hosted C compiler/runtime is the explicitly retained execution seam.
Native-route qualification is its elimination condition.

The runner preserves both `wsp/src/` and `wsp/gate/`. An earlier staging
attempt omitted `wsp/src/`, changed the compiler's project-root/home
qualification, and refused with `ReachedDuplicateFunction`. Adding only the
exact source directory to that otherwise unchanged stage restored execution.
Matched controls also showed that both cardinality-check variants passed
with the correct layout: no separate `ml.resident.count` compiler defect
was established. The final runner itself was executed successfully.

## Produced artifact and consumer

[learned/bundle.txt](../../learned/bundle.txt) contains exactly **11,030 bytes**,
SHA-256 `9af8a01d5f47655eb70cff346c9174ce21e6acf5e928d2a33e36e7b781a370dd`.
It was copied from the actual passing agent's stdout using its reported
length, excluding the additional newline inserted by `print`.
[bundle-extraction.json](bundle-extraction.json) records the offset, length
and hashes. The final producer independently emitted identical bytes.

The previous committed artifact was read and refused as an ambiguous legacy
seating reference. It was replaced by produced bytes, not by guessing the
occurrence targets of old digest references. The fresh-process consumer then
verified exact serialization, every record's standing verdict, active/current
occurrences, withdrawal propagation, stale replay refusal, and restoration of
the withdrawn evidence in an explicitly fresh fixture generation.

This artifact contains both live and fallen historical fixture records. It
is not published as a universally usable current model or as a complete
numeric event/revision capsule.

## Boundaries and separately red controls

The new bundle preflight preserves WSP seating/premise books, derivation/call
histories and pointers on
the exercised refusals. It still calls `ml.space.seat` during validation, so
it does not prove atomic adoption across upstream resident staging. Local
occurrence IDs remain generation-scoped; explicit reset replaces the fixture
authority context. Prefix validation does not establish global authority
resolution or complete capsule admission.

The exact additive example is an intercept-only sum/count learner with an
independent fixed schema. Its retained-data rebuild check is not an arbitrary
SGD/Adam retraining theorem, a quality comparison, or a privacy certificate.

The pinned dependency tree lacks the requested substrate faces in
`gate/retract-faces.id` and `gate/retract-predicates.id`; both baseline
compiles refused, as recorded in [diagnostics](diagnostics). They are outside
the green cohort. The earlier standalone standing fixture also refused
lowering; its recorded baseline diagnostic remains there, and the revised
byte-book fixture now executes all 27 checks, including depth 128 and shared
diamonds. The previously merged DFS algorithm was not replaced.

Full E01–E31 compiler conformance, compiler-discovered dependency completeness,
complete native capsules, concurrent publication, timing, memory comparisons,
model quality, and privacy guarantees remain UNMEASURED or OPEN.

# WS-SEM-10: standing traversal review evidence

## Status

**Draft correction, not qualified for merge. Neither Idol execution gate
has run successfully on these candidate bytes.** The historical green
battery in status.md is not evidence for this correction.

Baseline: clpi/idol-wsp
`adc765c66640816acda163a75850428c075bad1b`.
Baseline `src/agent.id` Git blob:
`a7ec27fd3a70dce16506786914a42fe949c48f3e`.

Candidate source SHA-256:
`42a596314e46db94c8ae2f658d690b41506eaa8f7d4451d6757ca5e7a798fde9`.
New `gate/standing.id` SHA-256:
`d6b07abbebbe0a55461adce6c01e1284cae1786b8e2f4807f4e01f9774b6c9b9`.

## Defect and correction

Both old standing faces return success when depth exceeds ten. A record
with twelve derivation edges can therefore stand without reading its
withdrawn leaf premise. The current normative chapter requires complete
transitive support and acyclic required-dependency graphs (section 2.2).

The candidate removes recursion and the depth cutoff. An explicit path
visits the reachable cone. Visiting marks reject a back edge; completed
marks reuse only a fully checked cone within that call. Every call creates
fresh marks. No previous live answer survives withdrawal or reload.

Only the queried root checks table-row values against the current seating.
Descendant row citations check existence, as before; descendant premise
and seating withdrawals still propagate. This retains the B3/B5/B10
separation rather than falling every reader after a harmless reweight.

The mark table is initialized across the current record-handle range. No
performance improvement is claimed; time and allocation costs remain to
be measured. Missing evidence is not certified live, but this change does
not implement the separate three-state eligibility work order.

## Executed checks and their limits

The retained official bootstrap used for development was built from
clpi/idol `884dbafcae6a2e2aee34f21f118952f8e43db506` for Linux x86-64.
Executable SHA-256:
`19066e68e0c25989c0b61c2a6e327036d4bbbe475c873955458f0e3781370efa`.
Its recorded build uses Zig 0.17.0, not the repository CI development pin.
It is **not** the compiler of the historical WSP green execution.

With the candidate staged as `lib/wsp/agent.id`, the following front-end
commands returned exit zero and `checked — no errors`:

```
idol check gate/agent.id
idol check gate/standing.id
```

These checks do not establish a complete library closure or executable
behavior. The available staging contains `compiler.digest`, `ml.model`
and `ml.resident` from the historical WSP pin `7ad63393`, and `ml.space`
from `2ca89216`, where that home exists. It is not a reconstructed clean
qualified compiler tree.

Emission used the explicit C route:

```
idol compile --backend=c --emit=c gate/agent.id -o agent.c
idol compile --backend=c --emit=c gate/standing.id -o standing.c
```

The unchanged baseline battery and candidate battery both refuse before
execution with `GraphFactsInvalid`, `missing-application-id`, relation
`concat`. The new standing gate refuses with `UnsupportedConstruct`,
`binop-not-lowered:concat`, relation `record`. Raw outputs and source-bound
exit receipts are retained beside this file in `standing-compiler.json`
and the named stdout/stderr files. No emitted program was executed.

An external development-only Python check of the exact standing source
span, translated only for syntax and supplied identity-table adapters,
reproduced the baseline false-live answer and passed its candidate checks.
That is corroboration of the algorithm, not Idol execution: it does not
test the actual table runtime, digest lookup, bundle loading, or native
compiler. It is deliberately not added as a product implementation or
replacement for the pure Idol gate. Synthetic cycle checks in that model
are not a claim that a hash-cycle bundle can be constructed through the
public loader.

Independent source review found no concrete semantic defect in the DFS
or new gate, and confirmed the same qualification boundary.

## Required before merge

1. Stage the exact candidate source in a verified, supported compiler
   tree using the existing WSP home arrangement.
2. Execute the unchanged `gate/agent.id` and new `gate/standing.id`,
   preserving exact compiler/source/runtime/input/output hashes and exits.
3. Confirm the regression fails against the old standing implementation
   and passes against the candidate under the same execution route.
4. Retain the row-only reweight and full-cone withdrawal contracts, and
   measure standing cost at the named pin before closing WS-SEM-10.
5. Recheck main and review the exact proposed merge bytes. Keep this PR
   draft until the execution evidence exists. No merge is authorized by
   this evidence file itself.

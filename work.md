# Work

The open work this repo carries, in the repo, per the founding law: a
gap lives where the project's truth lives. Each item carries its state,
its next action, and its condition. Items close only on executed
evidence recorded in [status.md](status.md).

## W1 — Build slice one

- **State:** IMPLEMENTED, STAGED TO RUN. The agent, its battery
  (B1–B15), and the section 10 speed program are landed in this repo
  (`src/agent.id`, `gate/agent.id`, `gate/measure.id`) in the same
  commit as this state. No upstream change to clpi/idol was needed.
  The compiler's own checks were exercised as far as the venue
  allowed: the substrate control battery ran green at the pin in
  this staging (36 ok / 0 fail); the agent home initially refused in
  the C99 realizer (an index-assignment lowering bail at a book-
  surgery construct in the retool face), the construct was removed
  (candidate tools now live in a string table; retool is a
  single-slot overwrite), and five minimal probe homes covering
  every state shape the slice uses compile clean — but the final
  agent compile has not yet been observed, because the venue's
  compiler then began dying before analysis (below).
- **Scope:** the loop, fixture surface, recorded stream, learning rule,
  accounting face, and lookup counter of the spec, in pure Idol,
  consuming the landed upstream faces the spec names. No upstream
  change to clpi/idol is expected; if one proves necessary, it lands
  upstream first, on its own clean pair, and this item names it here.
- **Next action:** execute the staged runbook on the first venue
  where the pin's compiler runs: compile the agent home, the
  battery, and the speed program (phases 1–3 × sizes 1 and 10, five
  wall times each, medians reported); link with the C runtime shim
  plus `gate/d1-hash-runtime.c`. On a green battery, land the
  execution commit the same day: status updated with the battery
  vector (pass / skip / fail / total), the three compactness
  numbers as measured (wire from case B12), the section 10 speed
  medians at the pin, and `learned/bundle.txt` extracted from the
  battery's B11 print. On any FAIL row or refusal, the verdict
  lands here verbatim instead — never softened.
- **Condition:** a venue where the prebuilt compiler at the pin
  executes. The current build VM fails this in two phases seen so
  far: a write fault that denies the compiler's output writes
  (intermittent), and a CPU-placement phase in which the compiler
  dies with an illegal instruction inside its own sha2 (the
  sandbox's exposed CPU flags lack the SHA extension the binary
  was built for; reproduced on the known-good control program, so
  it is the venue, not the pin and not this code). The runbook
  retries through both; it fires unattended on the first window.

## W2 — The same-contract run for cell WSP-BF1

- **State:** UNMEASURED. No run exists; no margin is claimed.
- **Scope:** run the WSP agent and at least one similar-size incumbent
  under the cell's same-contract terms (same tasks, same tool surface,
  size = parameter count + bits per weight in the three-number
  accounting) and record the outcome in [status.md](status.md),
  whatever it is.
- **Next action:** on W1's landing, fix the run's task set and
  incumbent, and state both here before any run.
- **Condition:** W1 landed; a qualifying venue for both sides of the
  contract.

## W3 — Live surfaces (slice two)

- **State:** OPEN, unspec'd beyond slice one's non-goals. Spec-first
  applies: no build before its spec lands here.
- **Scope:** the live MCP binding and the live Idol Eyes feed binding,
  replacing slice one's fixture surface and recorded stream without
  changing the loop's premise discipline; the Idol Eyes binding under
  Idol's own auth, per the standing door law.
- **Next action:** write the slice-two spec against slice one's landed
  battery, naming every host seam it expects, before any code.
- **Condition:** W1 landed.

## W4 — Upstream watch: the kernel handler port

- **State:** OPEN, watch only. The port is staged upstream, not
  landed, and slice one does not consume it.
- **Next action:** none unless a later slice's spec names a need for
  it; then its upstream landing, verified at its pin, is the
  precondition, recorded here.

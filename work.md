# Work

The open work this repo carries, in the repo, per the founding law: a
gap lives where the project's truth lives. Each item carries its state,
its next action, and its condition. Items close only on executed
evidence recorded in [status.md](status.md).

## W1 — Build slice one

- **State:** EXECUTED AND LANDED. The agent, its battery
  (B1–B15), and the section 10 speed program are landed in this repo
  (`src/agent.id`, `gate/agent.id`, `gate/measure.id`), execution
  commit 61197dfe783f5ae733b2cc280fe278c0d6b8cc68. The battery was
  executed at the pin on bytes identical to the landed ones (the Mac
  mini, the clean pin compiler, C route): pin clpi/idol
  7ad63393f2748a24b907182ce8820c785e79915c; **pass 126 / skip 0 /
  fail 0 / total 126, exit 0, "battery: OK"**. The measure gate
  compiles and runs at the pin, exit 0; no timing was taken, so no
  speed medians exist and none are recorded here — slice speed remains
  UNMEASURED. The execution convicted two defects in the home, both
  fixed in the landed bytes (standing over-propagation, case B3;
  reload generation addressing, case B11), and three defects in the
  compiler, which stand as open compiler work orders in clpi/idol with
  their own lanes (work orders 3, 4, and 5 in [status.md](status.md),
  under Named dependencies); the landed bytes carry
  semantics-preserving accommodations around each. No upstream change
  to clpi/idol was needed for this landing.
- **Scope:** the loop, fixture surface, recorded stream, learning rule,
  accounting face, and lookup counter of the spec, in pure Idol,
  consuming the landed upstream faces the spec names. No upstream
  change to clpi/idol is expected; if one proves necessary, it lands
  upstream first, on its own clean pair, and this item names it here.
- **Next action:** none for the build or the battery — this item
  closes on the executed evidence recorded in [status.md](status.md).
  Two tails live elsewhere: the learned bundle artifact is W5, and
  when any of compiler work orders 3, 4, or 5 lands upstream, its
  accommodation here comes out and the battery re-runs at the new pin.
- **Condition:** met. The pin's compiler ran on the Mac mini. (The
  build VM's two failure phases seen earlier in this item's staging —
  an intermittent write fault, and a CPU placement whose flags lack
  the SHA extension the prebuilt binary was built for — were venue
  facts, reproduced on the known-good control program; the full
  history is in the slice-one record.)

## W2 — The same-contract run for cell WSP-BF1

- **State:** UNMEASURED. No run exists; no margin is claimed.
- **Scope:** run the WSP agent and at least one similar-size incumbent
  under the cell's same-contract terms (same tasks, same tool surface,
  size = parameter count + bits per weight in the three-number
  accounting) and record the outcome in [status.md](status.md),
  whatever it is.
- **Next action:** on W1's landing, fix the run's task set and
  incumbent, and state both here before any run.
- **Condition:** W1 landed (met); a qualifying venue for both sides of
  the contract.

## W3 — Live surfaces (slice two)

- **State:** OPEN, unspec'd beyond slice one's non-goals. Spec-first
  applies: no build before its spec lands here.
- **Scope:** the live MCP binding and the live Idol Eyes feed binding,
  replacing slice one's fixture surface and recorded stream without
  changing the loop's premise discipline; the Idol Eyes binding under
  Idol's own auth, per the standing door law.
- **Next action:** write the slice-two spec against slice one's landed
  battery, naming every host seam it expects, before any code.
- **Condition:** W1 landed (met).

## W4 — Upstream watch: the kernel handler port

- **State:** OPEN, watch only. The port is staged upstream, not
  landed, and slice one does not consume it.
- **Next action:** none unless a later slice's spec names a need for
  it; then its upstream landing, verified at its pin, is the
  precondition, recorded here.

## W5 — Extract the learned bundle artifact

- **State:** OPEN. Case B11 of the battery ran and passed in the
  executed green run at the pin; its print is the learned bundle. The
  artifact file itself is not yet in this repo.
- **Next action:** extract the bundle from the executed run's B11
  print and land it as `learned/bundle.txt`, checking the extracted
  byte count against the print's stated bundle byte count before
  landing.
- **Condition:** none beyond access to the executed run's recorded
  print; if that print cannot be produced, re-run the battery at the
  pin and extract from the fresh run.

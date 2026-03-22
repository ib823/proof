# B_EFFECT_SYSTEMS R3 To R5 Worklist v1.0.0

This worklist is gate-driven. `B_EFFECT_SYSTEMS` has strong formal foundations but moves upward only when executable evidence, adversarial coverage, and documentation gaps are closed.

## Current Baseline

- Conservative rating: `R3`
- Blocker gates: G3, G4, G8, G9

## R3 -> R4

### Task B-R4-1: Wire .rii examples into integration tests
- **Gate:** G8
- **Priority:** High
- **Action:** Create integration test in `03_PROTO/crates/riinac/tests/` that dynamically loads each `.rii` file in `07_EXAMPLES/02_effects/` and runs parse + typecheck.
- **Acceptance:** `cargo test` loads and validates all 17 effect examples without failure.
- **Estimated effort:** Small (1 session)

### Task B-R4-2: Expand adversarial test coverage
- **Gate:** G9
- **Priority:** High
- **Action:** Add at least 10 new negative test cases:
  1. Effect escalation: `kesan Tulis` function calling `kesan Rangkaian` function
  2. Join of two non-pure effects
  3. Malformed handler dispatch
  4. Grant idempotence (granting an already-in-scope effect)
  5. Effect not in grant set (boundary violation)
  6. Package escalation with nested dependencies
  7. Effect ceiling bypass (body exceeds declared effect)
  8. Empty handler table for required effect
  9. Double-handle of same effect in nested scope
  10. Pure function performing impure operation
- **Where:** `03_PROTO/crates/riina-typechecker/src/program.rs` (tests) and `03_PROTO/crates/riina-codegen/src/interp.rs` (tests)
- **Acceptance:** All 10+ tests pass and exercise distinct failure modes.
- **Estimated effort:** Medium (1-2 sessions)

### Task B-R4-3: Write canonical workflow inventory
- **Gate:** G3
- **Priority:** Medium
- **Action:** Create `04_SPECS/effect_gate/WORKFLOW_INVENTORY.md` mapping each valid and forbidden workflow to its proof, enforcement mechanism, and test evidence.
- **Acceptance:** Every workflow in the audit matrix has a traceable link.
- **Estimated effort:** Small (1 session)

### Task B-R4-4: Write explicit threat/adversary model
- **Gate:** G4
- **Priority:** Medium
- **Action:** Create `04_SPECS/effect_gate/THREAT_MODEL.md` covering effect escalation, capability bypass, handler abuse, pure-context violation, and ceiling bypass.
- **Acceptance:** Each threat has a corresponding formal property, enforcement mechanism, and test.
- **Estimated effort:** Small (1 session)

Do not claim R4 if:
- Any `.rii` example fails parse + typecheck
- Fewer than 10 adversarial test cases exist
- Workflow inventory or threat model is missing

## R4 -> R5

### Task B-R5-1: CI pipeline enforcement
- **Gate:** G14
- **Action:** Move from hook-gated to CI-gated regression prevention.
- **Acceptance:** Automated pipeline runs all Coq, Rust, and example tests on every commit.

### Task B-R5-2: Public claim audit
- **Gate:** G13
- **Action:** Ensure all public-facing claims about effect systems match audited evidence.
- **Acceptance:** No public claim exceeds the audited rating.

### Task B-R5-3: Independent reproduction
- **Gate:** G12
- **Action:** A third party can reproduce the full audit from a clean clone.
- **Acceptance:** Documented reproduction steps; external reviewer confirms.

Do not claim R5 if:
- CI is not automated
- Public claims exceed audited state
- Reproduction has not been externally confirmed

## Execution Order

1. B-R4-1 (examples) and B-R4-2 (adversarial) — parallel, no dependencies
2. B-R4-3 (workflow) and B-R4-4 (threat model) — parallel, can use test results as inputs
3. Re-audit for R4
4. B-R5-1 through B-R5-3 — sequential after R4 confirmed
5. Re-audit for R5

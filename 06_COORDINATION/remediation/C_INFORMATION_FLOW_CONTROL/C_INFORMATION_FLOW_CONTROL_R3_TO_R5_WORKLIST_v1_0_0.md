# C_INFORMATION_FLOW_CONTROL R3 To R5 Worklist v1.0.0

This worklist is gate-driven. `C_INFORMATION_FLOW_CONTROL` has strong formal and enforcement foundations but moves upward only when documentation consolidation and executable evidence gaps are closed.

## Current Baseline

- Conservative rating: `R3`
- Blocker gates: G2, G4, G8, G14 (G14 deferred to R5)

## R3 -> R4

### Task C-R4-1: Wire .rii security examples into integration tests
- **Gate:** G8
- **Priority:** High
- **Action:** Add integration test that loads each `.rii` file in `07_EXAMPLES/01_security/` and runs parse + typecheck.
- **Where:** `03_PROTO/crates/riinac/tests/end_to_end.rs` or new test module
- **Acceptance:** `cargo test` loads and validates all 4 IFC examples.
- **Estimated effort:** Small (1 session)

### Task C-R4-2: Write consolidated threat model
- **Gate:** G4
- **Priority:** High
- **Action:** Create `04_SPECS/scope/IFC_THREAT_MODEL.md` documenting the 14 attack patterns already covered:
  1. SQL injection
  2. CSRF
  3. Path traversal
  4. Command injection
  5. Email injection
  6. Implicit flow leaks
  7. Constant-time bypass
  8. Deserialization attacks
  9. Wrong sanitizer selection
  10. Wrong declassification proof
  11. Bell-LaPadula read-up violation
  12. Bell-LaPadula write-down violation
  13. Taint propagation through arithmetic
  14. Budget-based declassification abuse
- **Acceptance:** Each attack maps to formal property, enforcement mechanism, and test.
- **Estimated effort:** Small (1 session)

### Task C-R4-3: Write consolidated boundary document
- **Gate:** G2
- **Priority:** Medium
- **Action:** Create `04_SPECS/scope/IFC_BOUNDARY.md` consolidating scope from the 3 research decisions and audit into one document.
- **Contents required:**
  - Covered problems (lattice-based IFC, taint tracking, declassification)
  - Excluded problems (dynamic IFC, distributed IFC, network boundaries)
  - Trust assumptions (compiler is trusted, runtime is trusted)
  - Actor model (developer, attacker, package author)
- **Acceptance:** Single self-contained boundary document.
- **Estimated effort:** Small (1 session)

Do not claim R4 if:
- Any `.rii` example fails parse + typecheck
- Threat model document is missing or incomplete
- Boundary document is missing or still fragmented

## R4 -> R5

### Task C-R5-1: CI pipeline enforcement
- **Gate:** G14
- **Action:** Move from hook-gated to CI-gated regression prevention.
- **Acceptance:** Automated pipeline runs all Coq + Rust + example tests.

### Task C-R5-2: Budget-based declassification enforcement
- **Gate:** G7
- **Action:** Implement budget-based declassification in the Rust typechecker (currently proven in Coq only).
- **Acceptance:** Budget enforcement passes positive and negative tests in the typechecker.

### Task C-R5-3: Public claim audit
- **Gate:** G13
- **Action:** Ensure all public claims match audited evidence.
- **Acceptance:** No claim exceeds audited state.

Do not claim R5 if:
- CI is not automated
- Budget-based declassification is claimed but not enforced
- Public claims exceed audited state

## Execution Order

1. C-R4-1 (examples), C-R4-2 (threat model), C-R4-3 (boundary) — all parallel
2. Re-audit for R4
3. C-R5-1 through C-R5-3 — sequential after R4
4. Re-audit for R5

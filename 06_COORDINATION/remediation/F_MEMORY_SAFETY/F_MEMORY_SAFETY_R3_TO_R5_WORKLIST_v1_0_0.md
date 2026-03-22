# F_MEMORY_SAFETY R3 To R5 Worklist v1.0.0

This worklist is gate-driven. `F_MEMORY_SAFETY` has deep formal coverage but moves upward only when the scope-enforcement mismatch is resolved and executable evidence gaps are closed.

## Current Baseline

- Conservative rating: `R3`
- Blocker gates: G2, G4, G8, G9
- Critical decision: enforcement scope must be resolved before other tasks

## R3 -> R4

### Task F-R4-1: Scope clarification decision (BLOCKING)
- **Gate:** G2
- **Priority:** Critical — all other tasks depend on this decision
- **Action:** Create `04_SPECS/scope/MEMORY_SAFETY_BOUNDARY.md` with an explicit decision:
  - **Option A (expand enforcement):** Implement spatial safety enforcement in the typechecker. Document what is enforced vs. formal-only.
  - **Option B (narrow claims):** Explicitly scope enforcement claims to linearity only. Document spatial, temporal, bounds, ROP, and data race freedom as formal-model-only properties.
- **Acceptance:** Document exists with unambiguous decision and rationale.
- **Estimated effort:** Small for Option B (1 session), Large for Option A (3-5 sessions)

### Task F-R4-2: Wire .rii examples into integration tests
- **Gate:** G8
- **Priority:** High
- **Action:** Add integration test that loads `07_EXAMPLES/01_security/linear_types.rii` and `linear_enforcement.rii` and runs parse + typecheck.
- **Where:** `03_PROTO/crates/riinac/tests/end_to_end.rs` or new test module
- **Acceptance:** `cargo test` validates both linearity examples.
- **Estimated effort:** Small (1 session)

### Task F-R4-3: Add adversarial tests for resolved scope
- **Gate:** G9
- **Priority:** High (after F-R4-1)
- **Action (if Option A — spatial enforcement):**
  1. Bounds overflow rejection test
  2. Use-after-free rejection test
  3. Double-free rejection test
  4. Dangling pointer rejection test
  5. Buffer overread rejection test
- **Action (if Option B — linearity only):**
  1. Double-use of linear resource
  2. Unused linear resource (leak)
  3. Linear resource escaping scope
  4. Linear resource in conditional branch (one branch drops)
  5. Linear resource aliased through reference
- **Acceptance:** At least 5 new adversarial tests matching the resolved scope.
- **Estimated effort:** Medium (1-2 sessions)

### Task F-R4-4: Write threat model
- **Gate:** G4
- **Priority:** Medium (after F-R4-1)
- **Action:** Create `04_SPECS/scope/MEMORY_SAFETY_THREAT_MODEL.md` covering threats appropriate to the resolved scope.
- **If Option A:** Include spatial attacks (buffer overflow, use-after-free, type confusion).
- **If Option B:** Focus on linearity attacks (resource leak, double-use, aliasing bypass).
- **Acceptance:** Each threat maps to property, enforcement mechanism, and test.
- **Estimated effort:** Small (1 session)

Do not claim R4 if:
- Scope clarification decision has not been made
- `.rii` examples fail parse + typecheck
- Adversarial tests do not match the resolved scope
- Threat model is missing

## R4 -> R5

### Task F-R5-1: CI pipeline enforcement
- **Gate:** G14
- **Action:** Automated pipeline runs linearity tests + any spatial tests on every commit.
- **Acceptance:** No regression possible without CI failure.

### Task F-R5-2: Spatial enforcement (if Option B was chosen at R4)
- **Gate:** G7
- **Action:** Revisit whether spatial safety enforcement should be added for R5.
- **Acceptance:** If added, full positive + negative test suite. If not, explicit justification.

### Task F-R5-3: Public claim audit
- **Gate:** G13
- **Action:** Ensure public claims match the resolved scope and audited evidence.
- **Acceptance:** No claim exceeds audited state.

Do not claim R5 if:
- CI is not automated
- Public claims imply spatial enforcement when only linearity is enforced
- Scope decision has been reversed without re-audit

## Execution Order

1. F-R4-1 (scope decision) — MUST be first, everything else depends on it
2. F-R4-2 (examples) — can start in parallel with F-R4-1
3. F-R4-3 (adversarial tests) and F-R4-4 (threat model) — after F-R4-1 resolves
4. Re-audit for R4
5. F-R5-1 through F-R5-3 — sequential after R4
6. Re-audit for R5

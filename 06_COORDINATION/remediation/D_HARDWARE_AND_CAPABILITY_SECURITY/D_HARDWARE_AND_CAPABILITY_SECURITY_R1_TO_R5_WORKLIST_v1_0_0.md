# D_HARDWARE_AND_CAPABILITY_SECURITY R1 To R5 Worklist v1.0.0

This worklist is gate-driven. `D_HARDWARE_AND_CAPABILITY_SECURITY` starts from R1 due to vacuous proofs discovered by hostile review. Every level requires fundamental new work, not patching.

## Current Baseline

- Conservative rating: `R1`
- ALL gates below G1 are effectively failed due to vacuous formal foundation
- Methodology lesson: this domain's collapse established vacuity detection as a cross-program priority

## R1 -> R2

### Task D-R2-1: Bound scope to implementable subset
- **Gate:** G2
- **Priority:** Critical — must be decided before any proof work
- **Action:** Choose one bounded scope:
  - **Option A (recommended):** Software capability enforcement — unforgability, monotonicity, delegation, revocation
  - **Option B:** Microarchitectural attack mitigation properties
  - **Option C:** CHERI-style hardware capability model
- **Artifact:** Scope document with explicit inclusions, exclusions, and rationale
- **Acceptance:** Single bounded scope statement. Hardware attacks, CHERI, and TERAS OS are explicitly excluded unless chosen.
- **Estimated effort:** Small (1 session)

### Task D-R2-2: Rewrite Coq proofs with nontrivial properties
- **Gate:** G6
- **Priority:** Critical
- **Action:** Replace vacuous theorems in the bounded scope with real properties:
  - **If Option A (capabilities):**
    1. Capability unforgability: creation requires authority token
    2. Capability monotonicity: derived permissions are subset of source
    3. Delegation transitivity: delegated capability respects chain of trust
    4. Revocation completeness: revoked capability is unreachable from all holders
    5. Capability separation: disjoint capability sets cannot interfere
  - Each theorem must reference hypothesis variables in its conclusion
  - Each theorem must be falsifiable (changing a definition should break the proof)
- **Validation:** Run vacuity detection tool (E-R4-1) against rewritten files; zero flags expected.
- **Acceptance:** No theorem concludes with `True` or proves `reflexivity` on hardcoded fields.
- **Estimated effort:** Large (3-5 sessions)

### Task D-R2-3: Write workflow inventory
- **Gate:** G3
- **Priority:** Medium (after D-R2-1)
- **Action:** Define valid and forbidden workflows for the bounded scope.
- **Acceptance:** Each workflow maps to at least one formal property.
- **Estimated effort:** Small (1 session)

Do not claim R2 if:
- Scope is still the full umbrella (hardware + software + CHERI + TERAS)
- Any vacuous theorem remains
- Vacuity detection tool flags any theorem in the rewritten files

## R2 -> R3

### Task D-R3-1: Implement enforcement in typechecker or runtime
- **Gate:** G7
- **Priority:** High
- **Action:** Implement at least the core capability properties (unforgability, monotonicity) as typechecker rules or runtime checks in the Rust prototype.
- **Where:** `03_PROTO/crates/riina-typechecker/` or `03_PROTO/crates/riina-runtime/`
- **Acceptance:** Positive and negative tests demonstrate enforcement.
- **Estimated effort:** Large (3-5 sessions)

### Task D-R3-2: Create .rii capability examples
- **Gate:** G8
- **Priority:** Medium
- **Action:** Write `.rii` example files demonstrating capability creation, delegation, and revocation. Wire into integration tests.
- **Acceptance:** `cargo test` validates all capability examples.
- **Estimated effort:** Medium (1-2 sessions)

### Task D-R3-3: Add adversarial tests
- **Gate:** G9
- **Priority:** Medium
- **Action:** Add negative tests:
  1. Forge a capability without authority
  2. Escalate permissions beyond source capability
  3. Use a revoked capability
  4. Delegate beyond allowed depth
  5. Cross-domain capability injection
- **Acceptance:** All 5 adversarial scenarios are rejected by the typechecker or runtime.
- **Estimated effort:** Medium (1-2 sessions)

Do not claim R3 if:
- No enforcement exists in the toolchain
- `.rii` examples are not toolchain-tested
- Adversarial coverage is absent

## R3 -> R4

### Task D-R4-1: Write threat model
- **Gate:** G4
- **Action:** Document capability-specific threats and their mitigations.
- **Estimated effort:** Small (1 session)

### Task D-R4-2: Complete workflow coverage
- **Gate:** G3
- **Action:** Ensure every workflow has test + formal + enforcement evidence.
- **Estimated effort:** Small (1 session)

## R4 -> R5

### Task D-R5-1: CI pipeline enforcement
- **Gate:** G14
- **Action:** Automated pipeline with vacuity detection, Coq builds, Rust tests.

### Task D-R5-2: Public claim audit
- **Gate:** G13
- **Action:** Ensure no public claim exceeds audited state.

### Task D-R5-3: Independent reproduction
- **Gate:** G12
- **Action:** External reviewer can reproduce from clean clone.

Do not claim R5 if:
- CI is not automated
- Public claims exceed audited state
- No external reproduction has occurred

## Execution Order

1. D-R2-1 (scope) — MUST be first
2. D-R2-2 (nontrivial proofs) — after scope decision
3. D-R2-3 (workflow) — after proofs exist
4. Re-audit for R2
5. D-R3-1 (enforcement) — after R2 confirmed
6. D-R3-2 (examples) and D-R3-3 (adversarial) — after enforcement exists
7. Re-audit for R3
8. D-R4-1 and D-R4-2 — after R3
9. Re-audit for R4
10. D-R5-1 through D-R5-3 — after R4
11. Re-audit for R5

## Critical Dependency

Task D-R2-2 (rewriting proofs) depends on E-R4-1 (vacuity detection tool) for validation. If the vacuity tool does not yet exist, proof rewriting can proceed but validation must be deferred.

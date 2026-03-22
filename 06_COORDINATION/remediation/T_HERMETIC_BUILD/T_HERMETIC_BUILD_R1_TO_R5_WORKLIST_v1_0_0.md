# T_HERMETIC_BUILD R1 To R5 Worklist v1.0.0

This worklist is gate-driven. `T_HERMETIC_BUILD` has identity-function formal models and no hermeticity enforcement. It needs fundamental rebuilding.

## Current Baseline

- Conservative rating: `R1`
- Blocker gates: G5 (tautological properties), G6 (identity definitions), G7 (no enforcement), G8 (no domain tests), G10 (auto-generated Alloy), G13 (overclaimed)

## R1 -> R2

### Task T-R2-1: Rewrite Coq definitions with real semantics
- **Gate:** G5, G6
- **Priority:** Critical
- **Action:** Replace identity functions with a real build model:
  1. `source_semantics` must map source + dependencies to an abstract semantics (not identity)
  2. `compile` must model a transformation from source to binary (not identity)
  3. `executes` must model runtime behavior distinct from compile-time representation
  4. Define `hermetic_build` as: same inputs produce same outputs regardless of environment
- **Where:** `02_FORMAL/coq/domains/T001_HermeticBuild.v`
- **Acceptance:** No identity functions. At least 3 proofs require reasoning about the build transformation.
- **Estimated effort:** Large (2-3 sessions)

### Task T-R2-2: Add hermeticity enforcement to riina-pkg
- **Gate:** G7
- **Priority:** High
- **Action:** Add at least one hermetic build enforcement mechanism:
  1. Deterministic output hashing (content-addressed build artifacts)
  2. Dependency pinning with hash verification
  3. Timestamp normalization in build outputs
- **Where:** `03_PROTO/crates/riina-pkg/`
- **Acceptance:** The word "hermetic" appears in implementation code with actual enforcement logic.
- **Estimated effort:** Medium (1-2 sessions)

### Task T-R2-3: Add hermetic-specific tests
- **Gate:** G8, G9
- **Priority:** Medium
- **Action:** Add tests that exercise hermetic properties:
  1. Same source produces same build output hash (determinism)
  2. Build with tampered dependency is rejected (integrity)
  3. Build output does not contain environment-specific timestamps (isolation)
- **Where:** riina-pkg test module
- **Acceptance:** At least 3 tests pass exercising distinct hermetic properties.
- **Estimated effort:** Small (1 session)

### Task T-R2-4: Correct public claims
- **Gate:** G13
- **Priority:** Low
- **Action:** Update safe claim to: "Hermetic build is in the research and design phase with a basic package manager but no hermeticity enforcement."
- **Acceptance:** No claim implies R2-level evidence.
- **Estimated effort:** Trivial

Do not claim R2 if:
- Coq definitions are still identity functions
- No hermeticity enforcement exists in riina-pkg
- Fewer than 3 hermetic-specific tests exist

## R2 -> R3

### Task T-R3-1: Prove hermetic preservation
- **Gate:** G6
- **Action:** Prove that the build pipeline preserves hermeticity: if all inputs are identical and the build process follows the model, then outputs are identical.
- **Acceptance:** Forward simulation theorem for deterministic build.

### Task T-R3-2: Rewrite Alloy independently
- **Gate:** G10
- **Action:** Create an independent Alloy model (not auto-generated from Coq) that models build hermeticity.
- **Acceptance:** Alloy file does not contain `// Derived from` comments. Model is independently formulated.

### Task T-R3-3: Add adversarial build tests
- **Gate:** G9
- **Action:** Add tests for build tampering, dependency substitution, and environment manipulation.
- **Acceptance:** At least 5 adversarial tests covering distinct attack vectors.

## R3 -> R5

### Task T-R5-1: Reproducible build verification
- **Gate:** G12
- **Action:** Third party can reproduce identical build outputs from the same inputs.
- **Acceptance:** External reviewer confirms bitwise-identical outputs.

## Execution Order

1. T-R2-1 (Coq rewrite) — foundation for everything
2. T-R2-2 (enforcement) — can start in parallel with Coq work
3. T-R2-3 (tests) — after enforcement exists
4. T-R2-4 (claims) — trivial, do anytime
5. Re-audit for R2
6. T-R3-1 through T-R3-3 — sequential after R2 confirmed

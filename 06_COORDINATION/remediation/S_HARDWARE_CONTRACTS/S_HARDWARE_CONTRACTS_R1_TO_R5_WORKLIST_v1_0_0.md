# S_HARDWARE_CONTRACTS R1 To R5 Worklist v1.0.0

This worklist is gate-driven. `S_HARDWARE_CONTRACTS` has a vacuous formal model and no implementation enforcement. It needs fundamental rebuilding.

## Current Baseline

- Conservative rating: `R1`
- Blocker gates: G3 (no implementation), G6 (vacuous leakage model), G9 (no negative tests), G10 (vacuous proofs), G12 (overclaimed public wording)

## R1 -> R2

### Task S-R2-1: Rewrite leakage model in Coq
- **Gate:** G6, G10
- **Priority:** Critical
- **Action:** Replace `leakage ms ms' := []` with a model that:
  1. Takes memory state pairs and returns observable timing differences
  2. Distinguishes constant-time operations (e.g., fixed-iteration loops) from variable-time operations (e.g., branching on secrets)
  3. Models cache-line access patterns at minimum
- **Where:** `02_FORMAL/coq/domains/S001_HardwareContracts.v`
- **Acceptance:** Leakage function is nontrivial. At least 3 proofs require reasoning about leakage content.
- **Estimated effort:** Large (2-3 sessions)

### Task S-R2-2: Add hardware contract enforcement
- **Gate:** G3, G7
- **Priority:** High
- **Action:** Add a hardware contract annotation system and enforcement logic:
  1. Define a `@constant_time` annotation (or Malay equivalent `@masa_tetap`)
  2. Check that annotated functions do not call variable-time operations
  3. Reject programs that violate timing contracts
- **Where:** `03_PROTO/crates/riina-typechecker/` or `03_PROTO/crates/riina-compliance/`
- **Acceptance:** At least one contract property is enforced at compile time.
- **Estimated effort:** Large (2-3 sessions)

### Task S-R2-3: Add negative tests for contract violations
- **Gate:** G9
- **Priority:** Medium
- **Action:** Add tests that verify hardware contract violations are caught:
  1. Constant-time function calling variable-time function (rejected)
  2. Function with timing annotation containing data-dependent branch (rejected)
  3. Contract escalation across module boundaries (rejected)
- **Where:** Typechecker or compliance test modules
- **Acceptance:** At least 3 negative tests pass.
- **Estimated effort:** Small (1 session)

### Task S-R2-4: Correct public claims
- **Gate:** G12
- **Priority:** Medium
- **Action:** Update safe claim to: "Hardware contracts are in the research phase with preliminary formal modeling but no implementation enforcement."
- **Acceptance:** No public claim implies R2-level evidence.
- **Estimated effort:** Trivial

Do not claim R2 if:
- Leakage model is still constant `[]`
- No implementation enforcement exists
- Fewer than 3 negative tests exist

## R2 -> R3

### Task S-R3-1: Full constant-time verification pipeline
- **Gate:** G6
- **Action:** Prove that the compiler preserves constant-time properties from source to compiled output.
- **Acceptance:** End-to-end timing preservation theorem exists.

### Task S-R3-2: Cache model integration
- **Gate:** G6
- **Action:** Extend the leakage model to include cache hierarchy effects.
- **Acceptance:** Cache-line-level reasoning is formalized.

## R3 -> R5

### Task S-R5-1: Hardware-in-the-loop testing
- **Gate:** G8
- **Action:** Validate timing models against actual hardware measurements.
- **Acceptance:** Empirical timing data confirms formal predictions.

## Execution Order

1. S-R2-1 (leakage rewrite) — must come first, foundation for everything
2. S-R2-2 (enforcement) — parallel with or after S-R2-1
3. S-R2-3 (negative tests) — after enforcement exists
4. S-R2-4 (claims) — trivial, do anytime
5. Re-audit for R2

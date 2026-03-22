# P_STANDARD_LIBRARY R2 To R5 Worklist v1.0.0

This worklist is gate-driven. `P_STANDARD_LIBRARY` has real implementation evidence but shallow formal models and a naming gap between Coq and Rust layers.

## Current Baseline

- Conservative rating: `R2`
- Blocker gates: G4, G5, G13

## R2 -> R3

### Task P-R3-1: Create Coq-to-Rust translation mapping
- **Gate:** G4, G13
- **Priority:** High
- **Action:** Create an explicit mapping document or code artifact linking Coq English models to Rust Malay builtins (e.g., `Vec` -> `senarai`, `HashMap` -> `peta`).
- **Where:** `04_SPECS/stdlib/TRANSLATION_MAP.md` or inline in `StandardLibrary.v`
- **Acceptance:** Every Coq type model has a documented link to its Rust counterpart.
- **Estimated effort:** Small (1 session)

### Task P-R3-2: Add inductive Coq proofs
- **Gate:** G5
- **Priority:** High
- **Action:** Add at least 5 nontrivial proofs requiring induction or case analysis:
  1. List append associativity
  2. List length append distributivity
  3. Map insert/lookup round-trip
  4. Option bind associativity
  5. Result map composition
- **Where:** `02_FORMAL/coq/domains/StandardLibrary.v`
- **Acceptance:** At least 5 proofs use `induction` or multi-step `destruct`, not just `reflexivity`.
- **Estimated effort:** Medium (1-2 sessions)

### Task P-R3-3: Correct implementation references
- **Gate:** G13
- **Priority:** Low
- **Action:** Update audit to reference `riina-codegen/src/builtins/` instead of `riina-types`.
- **Acceptance:** All references are accurate.
- **Estimated effort:** Trivial

Do not claim R3 if:
- Formal-to-implementation mapping is missing
- Fewer than 5 inductive proofs exist

## R3 -> R4

### Task P-R4-1: Kani/Verus harnesses
- **Gate:** G4
- **Action:** Create formal verification harnesses linking Coq models to Rust builtins.
- **Acceptance:** Automated verification confirms equivalence for core types.

### Task P-R4-2: Adversarial stdlib tests
- **Gate:** G9
- **Action:** Add boundary and overflow tests for all stdlib builtins.
- **Acceptance:** At least 10 adversarial tests covering edge cases.

## R4 -> R5

### Task P-R5-1: Independent reproduction
- **Gate:** G12
- **Action:** Third-party reproduction of the full stdlib audit from a clean clone.
- **Acceptance:** External reviewer confirms.

## Execution Order

1. P-R3-1 (mapping) and P-R3-3 (references) — parallel, trivial
2. P-R3-2 (inductive proofs) — depends on mapping for context
3. Re-audit for R3
4. P-R4-1 and P-R4-2 — parallel after R3 confirmed
5. Re-audit for R4, then R5 items

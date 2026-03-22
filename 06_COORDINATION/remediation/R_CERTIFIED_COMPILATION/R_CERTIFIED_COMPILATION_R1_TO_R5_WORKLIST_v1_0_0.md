# R_CERTIFIED_COMPILATION R1 To R5 Worklist v1.0.0

This worklist is gate-driven. `R_CERTIFIED_COMPILATION` was downgraded to R1 due to cosmetic formal models that actively misrepresent compilation semantics.

## Current Baseline

- Conservative rating: `R1`
- Blocker gates: G6 (toy formal models), G7 (no formal-impl link), G10 (vacuous proofs), G11 (no traceability), G14 (no regression coupling)

## R1 -> R2

### Task R-R2-1: Rewrite WasmBackendVerification.v
- **Gate:** G6, G10
- **Priority:** Critical
- **Action:** Replace the toy IR compilation model. Specifically:
  1. `IRIf c t f` must compile BOTH branches (not just `compile_ir t`)
  2. `IRCall` must evaluate arguments (not return `0`)
  3. `IRLet` must properly scope bindings (not drop to `WDrop`)
- **Where:** `02_FORMAL/coq/domains/WasmBackendVerification.v`
- **Acceptance:** No branch-dropping, no constant-zero stubs. Coq compiles cleanly.
- **Estimated effort:** Large (2-3 sessions)

### Task R-R2-2: Replace BackendTraitVerification.v tautologies
- **Gate:** G6, G10
- **Priority:** Critical
- **Action:** Replace every `Definition preserves ... := true` with meaningful preservation properties relating source to compiled semantics.
- **Where:** `02_FORMAL/coq/domains/BackendTraitVerification.v`
- **Acceptance:** Zero `Definition ... := true` patterns remain.
- **Estimated effort:** Medium (1-2 sessions)

### Task R-R2-3: Extend CompilerCorrectness.v IR
- **Gate:** G6
- **Priority:** High
- **Action:** Add variables (`IRVar`), let-bindings (`IRLet`), and function application (`IRApp`) to the formal IR.
- **Where:** `02_FORMAL/coq/domains/CompilerCorrectness.v`
- **Acceptance:** IR has at least 5 constructors beyond constants and arithmetic.
- **Estimated effort:** Medium (1-2 sessions)

### Task R-R2-4: Create formal-to-implementation traceability
- **Gate:** G7, G11
- **Priority:** Medium
- **Action:** Map at least 5 Coq theorems to corresponding riina-codegen test suites.
- **Where:** `04_SPECS/compiler/TRACEABILITY.md`
- **Acceptance:** Explicit mapping document exists with verifiable links.
- **Estimated effort:** Small (1 session)

Do not claim R2 if:
- Any branch-dropping or boolean tautologies remain in Coq
- IR lacks variables or functions

## R2 -> R3

### Task R-R3-1: Prove semantic preservation for full IR
- **Gate:** G6
- **Action:** Prove forward simulation for the extended IR including all control flow.
- **Acceptance:** Simulation proof covers conditionals, let-bindings, and function calls.

### Task R-R3-2: Negative compilation tests
- **Gate:** G9
- **Action:** Add adversarial tests for malformed IR, type-unsafe inputs, and optimization edge cases.
- **Acceptance:** At least 10 adversarial compilation test cases.

## R3 -> R5

### Task R-R5-1: End-to-end certified pipeline
- **Gate:** G5
- **Action:** Full formal pipeline from source through IR to Wasm with proven preservation at each step.

## Execution Order

1. R-R2-1 (Wasm rewrite) — highest priority, most impactful
2. R-R2-2 (backend tautologies) — parallel with R-R2-1
3. R-R2-3 (IR extension) — depends on R-R2-1 patterns
4. R-R2-4 (traceability) — after Coq rewrites stabilize
5. Re-audit for R2

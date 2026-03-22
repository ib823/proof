# Q_COMPILER_ARCHITECTURE R2 To R5 Worklist v1.0.0

This worklist is gate-driven. `Q_COMPILER_ARCHITECTURE` has strong implementation evidence but disputed formal depth and missing documentation.

## Current Baseline

- Conservative rating: `R2`
- Blocker gates: G1-G5 (documentation), G6 (disputed formal depth), G11 (incomplete audit), G13 (safe claim)

## R2 -> R3

### Task Q-R3-1: Full re-audit of CompilerCorrectness.v
- **Gate:** G6, G11
- **Priority:** Critical
- **Action:** Re-read CompilerCorrectness.v in its entirety. Document every section (including Sections 5-20 that Gemini claims contain deep proofs). For each theorem, record whether the proof body uses reflexivity, induction, case analysis, or other tactics.
- **Acceptance:** Per-section analysis exists. Rating adjusted if deep proofs are confirmed.
- **Estimated effort:** Medium (1 session)

### Task Q-R3-2: Create G1-G5 documentation
- **Gate:** G1-G5
- **Priority:** High
- **Action:** Create canonical identity, boundary precision, workflow inventory, threat model, and property set documents for compiler architecture.
- **Where:** `04_SPECS/compiler/`
- **Acceptance:** All five structural documentation gates pass.
- **Estimated effort:** Medium (1-2 sessions)

### Task Q-R3-3: Establish formal-to-implementation link
- **Gate:** G7
- **Priority:** High
- **Action:** Document the mapping between the Coq IR model and the live riina-codegen implementation. Identify which Coq theorems correspond to which Rust test suites.
- **Acceptance:** Traceable link document exists.
- **Estimated effort:** Small (1 session)

### Task Q-R3-4: Rewrite safe claim
- **Gate:** G13
- **Priority:** Medium
- **Action:** Update safe claim based on re-audit findings from Q-R3-1.
- **Acceptance:** Safe claim matches verified evidence.
- **Estimated effort:** Trivial

Do not claim R3 if:
- CompilerCorrectness.v re-audit has not been completed
- G1-G5 documentation is missing

## R3 -> R4

### Task Q-R4-1: Adversarial compiler tests
- **Gate:** G9
- **Action:** Add adversarial test cases targeting malformed IR, type-unsafe inputs, and optimization edge cases.
- **Acceptance:** At least 10 adversarial test cases covering distinct failure modes.

### Task Q-R4-2: End-to-end formal-to-test traceability
- **Gate:** G3
- **Action:** Map every formal theorem to at least one executable test.
- **Acceptance:** Full traceability matrix exists.

## R4 -> R5

### Task Q-R5-1: Independent reproduction
- **Gate:** G12
- **Action:** Third-party reproduction from clean clone.
- **Acceptance:** External reviewer confirms.

## Execution Order

1. Q-R3-1 (re-audit) — must come first, determines ceiling
2. Q-R3-2 (documentation) and Q-R3-3 (mapping) — parallel after re-audit
3. Q-R3-4 (safe claim) — depends on re-audit results
4. Re-audit for R3
5. R4 and R5 items sequential

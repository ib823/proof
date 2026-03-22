# Remediation Package: T_HERMETIC_BUILD

## Domain

- Domain ID: `T_HERMETIC_BUILD`
- Domain name: Hermetic Build
- Current honest rating: `R1`
- Target rating: `R2`
- Audit: [T_HERMETIC_BUILD_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/T_HERMETIC_BUILD_R5_AUDIT.md)
- Hostile review: [T_HERMETIC_BUILD_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/T_HERMETIC_BUILD_R5_REVIEW.md)
- Hostile review verdict: reject (downgraded from R2 to R1, accepted)
- Created: 2026-03-21

## Why R1

The hostile review exposed that the "35% reflexivity" metric was misleading:

- Coq definitions are identity functions (`Definition source_semantics src := src`, `Definition compile binary src := src`)
- All proofs are tautologies over identity functions, regardless of the reflexivity percentage
- "hermetic" does not appear once in the `03_PROTO` implementation
- riina-pkg has 54 tests but none test hermetic build properties
- Alloy model is auto-generated from the vacuous Coq (`// Derived from ...`)

R1 is warranted because research exists and riina-pkg provides basic packaging infrastructure.

## Remediation Items to Reach R2

### R2-1: Rewrite Coq definitions with real semantics

**Gate:** G5, G6
**What:** Replace identity-function definitions with models that distinguish source, compiled, and environment states.
**Acceptance:** `source_semantics`, `compile`, and `executes` are not identity functions.

### R2-2: Add hermeticity enforcement to riina-pkg

**Gate:** G7, G8
**What:** Add explicit hermeticity checks (e.g., network isolation, deterministic timestamps, reproducible output hashing).
**Acceptance:** The word "hermetic" appears in implementation code with actual enforcement logic.

### R2-3: Add hermetic-specific tests

**Gate:** G9
**What:** Add tests that verify builds are hermetic (deterministic output, no network access, no timestamp leakage).
**Acceptance:** At least 3 tests exercise hermetic build properties specifically.

## Re-audit Trigger

Re-audit after R2-1 replaces identity definitions and R2-2 adds enforcement logic.

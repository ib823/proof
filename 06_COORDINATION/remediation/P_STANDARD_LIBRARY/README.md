# Remediation Package: P_STANDARD_LIBRARY

## Domain

- Domain ID: `P_STANDARD_LIBRARY`
- Domain name: Standard Library
- Current honest rating: `R2`
- Target rating: `R3`
- Audit: [P_STANDARD_LIBRARY_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/P_STANDARD_LIBRARY_R5_AUDIT.md)
- Hostile review: [P_STANDARD_LIBRARY_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/P_STANDARD_LIBRARY_R5_REVIEW.md)
- Hostile review verdict: accept with reductions (R2 confirmed)
- Created: 2026-03-21

## Why R2

The domain has shallow Coq proofs (reflexivity over functional models) and real Rust builtins in `riina-codegen/src/builtins/`, but:

- G4 fail: no formal linkage between Coq English models (`Vec`, `HashMap`) and Rust Malay builtins (`senarai`, `peta`)
- G13 fail: disconnect between formal and implementation layers
- Implementation location was miscredited to `riina-types` (actually in `riina-codegen/src/builtins/`)

## Remediation Items to Reach R3

### R3-1: Create formal-to-implementation mapping

**Gate:** G4, G13
**What:** Create explicit mapping between Coq models and Rust Malay builtins, or add Kani/Verus harnesses linking them.
**Acceptance:** Every Coq type model has a documented or verified link to its Rust implementation.

### R3-2: Deepen Coq proofs beyond reflexivity

**Gate:** G5
**What:** Add nontrivial proofs (e.g., List append associativity, Map insert/lookup consistency) that go beyond definitional equality.
**Acceptance:** At least 5 proofs require induction or case analysis, not just reflexivity.

## Re-audit Trigger

Re-audit after R3-1 and R3-2 are completed and verified.

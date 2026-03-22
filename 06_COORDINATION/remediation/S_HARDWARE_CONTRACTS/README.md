# Remediation Package: S_HARDWARE_CONTRACTS

## Domain

- Domain ID: `S_HARDWARE_CONTRACTS`
- Domain name: Hardware Contracts
- Current honest rating: `R1`
- Target rating: `R2`
- Audit: [S_HARDWARE_CONTRACTS_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/S_HARDWARE_CONTRACTS_R5_AUDIT.md)
- Hostile review: [S_HARDWARE_CONTRACTS_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/S_HARDWARE_CONTRACTS_R5_REVIEW.md)
- Hostile review verdict: reject (downgraded to R0, partially accepted to R1)
- Created: 2026-03-21

## Why R1

The hostile review found critical defects but R0 is too harsh:

- `leakage ms ms' := []` makes all constant-time proofs trivially vacuous (Gemini correct)
- riina-compliance has zero hardware contract logic (Gemini correct)
- No typechecker enforcement for hardware contracts (Gemini correct)
- However: research folder exists with domain-specific research, and the Coq file compiles, warranting R1 over R0

## Remediation Items to Reach R2

### R2-1: Replace vacuous leakage model

**Gate:** G6, G10
**What:** Define `leakage` as a nontrivial function that actually models timing or cache side-channel behavior.
**Acceptance:** `leakage` is not a constant. Proofs require reasoning about leakage differences.

### R2-2: Add hardware contract logic to implementation

**Gate:** G3, G7
**What:** Add domain-specific code paths in riina-compliance or riina-typechecker for hardware contract checks.
**Acceptance:** At least one hardware contract property is enforced at compile time.

### R2-3: Add negative tests

**Gate:** G9
**What:** Add tests that verify hardware contract violations are rejected.
**Acceptance:** At least 3 negative tests for contract violation scenarios.

## Re-audit Trigger

Re-audit after R2-1 provides a nontrivial leakage model and R2-2 adds implementation logic.

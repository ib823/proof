# Remediation Package: E_FORMAL_VERIFICATION

## Domain

- Domain ID: `E_FORMAL_VERIFICATION`
- Domain name: Formal Verification
- Current honest rating: `R3`
- Target rating: `R4`
- Audit: [E_FORMAL_VERIFICATION_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/E_FORMAL_VERIFICATION_R5_AUDIT.md)
- Hostile review: [E_FORMAL_VERIFICATION_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/E_FORMAL_VERIFICATION_R5_REVIEW.md)
- Hostile review verdict: accept (no reductions)
- Created: 2026-03-20

## Why R3

Core type safety proofs (Progress, Preservation, TypeSafety) are nontrivial and mechanized. Multi-prover pipeline is operational. R3 cap comes from:

- G9 partial: no vacuity detection tool (D_HARDWARE lesson)
- G3 partial: transpiler validation workflow undocumented
- G4 partial: no explicit threat model for pipeline integrity

## Remediation Items to Reach R4

### R4-1: Build vacuity detection tool (CROSS-PROGRAM PRIORITY)

**Gate:** G9
**Severity:** High — affects every future domain audit
**What:** Script that scans all .v files and flags:
- Theorems with conclusion `True`
- Proofs consisting solely of `trivial.` or `exact I.`
- Theorems proving `true = true` or `reflexivity` on hardcoded boolean fields
**Where:** `scripts/detect-vacuous-proofs.sh` or Python equivalent
**Acceptance:** Running the tool against D_HARDWARE files flags all 255 theorems. Running against core type_system files flags zero.

### R4-2: Document transpiler validation workflow

**Gate:** G3
**Severity:** Medium
**What:** Write documentation explaining how generate-multiprover.py and generate-full-stack.py are validated.
**Where:** `04_SPECS/cross-cutting/PROVER_PIPELINE_WORKFLOW.md` or similar
**Acceptance:** Document covers: input validation, output structure checks, correspondence table verification.

### R4-3: Write pipeline threat model

**Gate:** G4
**Severity:** Medium
**What:** Model threats: corrupted transpiler, stale generation, proof drift between Coq source and generated lanes.
**Where:** `04_SPECS/cross-cutting/PROVER_PIPELINE_THREAT_MODEL.md` or similar
**Acceptance:** Each threat maps to a mitigation.

## Re-audit Trigger

Re-audit after R4-1 (vacuity detection) is completed. This is the highest-impact single remediation item in the program.

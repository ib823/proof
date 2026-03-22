# Remediation Package: Q_COMPILER_ARCHITECTURE

## Domain

- Domain ID: `Q_COMPILER_ARCHITECTURE`
- Domain name: Compiler Architecture
- Current honest rating: `R2`
- Target rating: `R3`
- Audit: [Q_COMPILER_ARCHITECTURE_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/Q_COMPILER_ARCHITECTURE_R5_AUDIT.md)
- Hostile review: [Q_COMPILER_ARCHITECTURE_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/Q_COMPILER_ARCHITECTURE_R5_REVIEW.md)
- Hostile review verdict: reject (upgraded to R3 — rejected as overclaim)
- Created: 2026-03-21

## Why R2

The domain has strong implementation evidence (493 tests in riina-codegen) but disputed formal depth:

- Audit says: Coq proofs are vacuous boolean stubs (CC_001 to CC_010 are `field = true` by reflexivity)
- Gemini says: CompilerCorrectness.v Sections 5-20 contain rigorous semantic preservation proofs
- Conservative rule: when hostile review argues UP, the lower rating prevails pending verification
- G1-G5: missing documentation matrices (workflow, threat model, property set)
- G11: auditor may not have read the full Coq file

## Remediation Items to Reach R3

### R3-1: Independent re-audit of CompilerCorrectness.v

**Gate:** G6, G11
**What:** A full re-read of CompilerCorrectness.v beyond the CC_001-CC_010 stubs to determine if Sections 5-20 contain real proofs.
**Acceptance:** Audit explicitly documents every section of the file with proof-body analysis.

### R3-2: Complete G1-G5 documentation

**Gate:** G1-G5
**What:** Add workflow inventory, threat model, property set, and boundary precision documents.
**Acceptance:** All structural documentation gates pass.

### R3-3: Rewrite safe claim

**Gate:** G13
**What:** Update safe claim based on re-audit findings.
**Acceptance:** Safe claim matches the verified evidence.

## Re-audit Trigger

Re-audit after R3-1 determines the true depth of CompilerCorrectness.v.

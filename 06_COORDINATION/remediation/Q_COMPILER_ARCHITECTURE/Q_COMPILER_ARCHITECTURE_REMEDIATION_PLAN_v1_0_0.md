# Q_COMPILER_ARCHITECTURE Remediation Plan v1.0.0

## Purpose

Resolve the disputed formal evidence depth in CompilerCorrectness.v and close documentation gaps to establish the true rating ceiling for this domain.

## Current Truth

As of [Q_COMPILER_ARCHITECTURE_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/Q_COMPILER_ARCHITECTURE_R5_AUDIT.md) and [Q_COMPILER_ARCHITECTURE_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/Q_COMPILER_ARCHITECTURE_R5_REVIEW.md):
- `Q_COMPILER_ARCHITECTURE` is `R2` (conservative)
- Primary audit: CC_001 to CC_010 are `field = true` by reflexivity, VACUOUS
- Hostile review: CompilerCorrectness.v Sections 5-20 contain 800+ lines of rigorous proofs (type preservation, forward/backward simulation, determinism)
- 493 tests in riina-codegen provide strong implementation evidence
- 41 wasm_e2e integration tests provide executable evidence
- G1-G5 documentation matrices are missing
- Gemini flagged the auditor stopped reading at line 90

## Governing Rules

1. When the hostile reviewer argues UP (R3), the conservative audit rating (R2) prevails.
2. A disputed Coq file must be re-audited in full before any upgrade.
3. Implementation evidence (493 tests) is strong but cannot substitute for verified formal depth.
4. Gemini's claim about deep proofs follows the same pattern seen in O_RUNTIME where it did not verify proof bodies.

## Required Structural Changes

### 1. Full re-audit of CompilerCorrectness.v

The core dispute is whether CompilerCorrectness.v contains real proofs beyond the CC_001-CC_010 stubs. A re-audit must read every section and document each proof's body (reflexivity vs induction vs case analysis).

### 2. Complete structural documentation

G1-G5 documentation matrices (canonical identity, boundary precision, workflow inventory, threat model, property set) are entirely missing.

### 3. Establish formal-to-implementation link

Even if CompilerCorrectness.v has deep proofs, there must be a traceable link between the formal IR model and the live riina-codegen implementation.

## Per-Gate Remediation Steps

| Gate | Status | Remediation | Artifact | Exit Criterion |
|------|--------|-------------|----------|----------------|
| G1-G5 | Missing | Create all structural documentation | `04_SPECS/compiler/` | All five gates documented |
| G6 | Disputed | Full re-audit of CompilerCorrectness.v | Updated audit section | Every section documented with proof body analysis |
| G11 | Fail | Read entire file, not just first 90 lines | Re-audit | Auditor confirms full-file review |
| G13 | Fail | Rewrite safe claim based on re-audit | Audit update | Claim matches verified evidence |

## Exit Criteria

`Q_COMPILER_ARCHITECTURE` may not claim R3 until:
- CompilerCorrectness.v has been fully re-audited with per-section proof body analysis
- All G1-G5 documentation exists
- Safe claim reflects the verified state
- Formal-to-implementation link is documented

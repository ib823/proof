# E_FORMAL_VERIFICATION Remediation Plan v1.0.0

## Purpose

Close the tooling, documentation, and threat modeling gaps that cap `E_FORMAL_VERIFICATION` at R3. The highest-impact item — vacuity detection — is a cross-program priority that improves every future domain audit.

## Current Truth

As of [E_FORMAL_VERIFICATION_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/E_FORMAL_VERIFICATION_R5_AUDIT.md) and [E_FORMAL_VERIFICATION_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/E_FORMAL_VERIFICATION_R5_REVIEW.md):
- `E_FORMAL_VERIFICATION` is `R3`
- Core type safety proofs (Progress, Preservation, TypeSafety) are nontrivial and mechanized
- Multi-prover pipeline (Coq, Lean, Isabelle, F*, TLA+, Alloy) is operational
- No vacuity detection tool exists — the D_HARDWARE disaster proved this is critical
- Transpiler validation workflow (generate-multiprover.py, generate-full-stack.py) is undocumented
- No explicit threat model for pipeline integrity

## Governing Rules

1. A formal verification domain without vacuity detection is inherently fragile — one vacuous proof file can silently inflate an entire domain's rating.
2. Pipeline tools that generate formal artifacts must have documented validation workflows; undocumented generation is a trust gap.
3. Pipeline integrity threats (corrupted transpiler, stale generation, proof drift) must be explicitly modeled, not assumed away.

## Required Structural Changes

### 1. Build vacuity detection tool (CROSS-PROGRAM PRIORITY)

This is the single highest-impact remediation item in the entire audit program. The D_HARDWARE domain's collapse from R2 to R1 was caused by 255 vacuous theorems that passed all syntactic checks. A vacuity detection script prevents this class of failure across all domains.

### 2. Document transpiler validation workflow

The multi-prover pipeline relies on Python scripts that transform Coq sources into other prover formats. The validation process for these scripts is undocumented, creating an implicit trust assumption.

### 3. Write pipeline threat model

Model threats to pipeline integrity: corrupted transpiler output, stale generation (Coq changes without regeneration), proof drift between source and generated lanes.

## Per-Gate Remediation Steps

| Gate | Status | Remediation | Artifact | Exit Criterion |
|------|--------|-------------|----------|----------------|
| G9 | Partial | Build vacuity detection tool | `scripts/detect-vacuous-proofs.sh` | Flags all 255 D_HARDWARE theorems; flags zero core type_system theorems |
| G3 | Partial | Document transpiler validation workflow | `04_SPECS/cross-cutting/PROVER_PIPELINE_WORKFLOW.md` | Covers input validation, output checks, correspondence verification |
| G4 | Partial | Write pipeline threat model | `04_SPECS/cross-cutting/PROVER_PIPELINE_THREAT_MODEL.md` | Each threat maps to a mitigation |

## Exit Criteria

`E_FORMAL_VERIFICATION` may not claim R4 until:
- Vacuity detection tool exists and is validated against known-vacuous and known-nontrivial files
- Transpiler validation workflow is documented
- Pipeline threat model exists with threat-to-mitigation mapping
- Re-audit confirms G3, G4, and G9 pass

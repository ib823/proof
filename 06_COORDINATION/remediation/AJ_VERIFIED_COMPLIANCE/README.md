# AJ_VERIFIED_COMPLIANCE Remediation

Current truth:
- Audit: [AJ_VERIFIED_COMPLIANCE_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AJ_VERIFIED_COMPLIANCE_R5_AUDIT.md)
- Review: [AJ_VERIFIED_COMPLIANCE_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AJ_VERIFIED_COMPLIANCE_R5_REVIEW.md)
- Current honest rating: `R1`

This package exists because the domain is not a live compile-time compliance regime yet. The current implementation is a substantial opt-in post-typecheck rule and report engine, not a first-class verified-compliance subsystem in the language frontend.

Core remediation documents:
- [AJ_VERIFIED_COMPLIANCE_REMEDIATION_PLAN_v1_0_0.md](/workspaces/proof/06_COORDINATION/remediation/AJ_VERIFIED_COMPLIANCE/AJ_VERIFIED_COMPLIANCE_REMEDIATION_PLAN_v1_0_0.md)
- [AJ_VERIFIED_COMPLIANCE_R1_TO_R5_WORKLIST_v1_0_0.md](/workspaces/proof/06_COORDINATION/remediation/AJ_VERIFIED_COMPLIANCE/AJ_VERIFIED_COMPLIANCE_R1_TO_R5_WORKLIST_v1_0_0.md)
- [AJ_VERIFIED_COMPLIANCE_CHILD_DOMAIN_BREAKDOWN_v1_0_0.md](/workspaces/proof/06_COORDINATION/remediation/AJ_VERIFIED_COMPLIANCE/AJ_VERIFIED_COMPLIANCE_CHILD_DOMAIN_BREAKDOWN_v1_0_0.md)

Immediate direction:
- introduce a bounded first-class compliance effect/type regime in the live frontend
- make canonical compliance examples parse/typecheck/run through the actual toolchain
- demote or replace vacuous derived prover lanes
- reduce public/business wording until compile-time compliance is real

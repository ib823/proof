# AK_VERIFIED_PROCUREMENT Remediation

Current truth:
- Audit: [AK_VERIFIED_PROCUREMENT_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AK_VERIFIED_PROCUREMENT_R5_AUDIT.md)
- Review: [AK_VERIFIED_PROCUREMENT_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AK_VERIFIED_PROCUREMENT_R5_REVIEW.md)
- Current honest rating: `R1`

This package exists because the domain is still a research-heavy procurement umbrella with bounded smoke models, not a live verified procurement subsystem in the language.

Core remediation documents:
- [AK_VERIFIED_PROCUREMENT_REMEDIATION_PLAN_v1_0_0.md](/workspaces/proof/06_COORDINATION/remediation/AK_VERIFIED_PROCUREMENT/AK_VERIFIED_PROCUREMENT_REMEDIATION_PLAN_v1_0_0.md)
- [AK_VERIFIED_PROCUREMENT_R1_TO_R5_WORKLIST_v1_0_0.md](/workspaces/proof/06_COORDINATION/remediation/AK_VERIFIED_PROCUREMENT/AK_VERIFIED_PROCUREMENT_R1_TO_R5_WORKLIST_v1_0_0.md)
- [AK_VERIFIED_PROCUREMENT_CHILD_DOMAIN_BREAKDOWN_v1_0_0.md](/workspaces/proof/06_COORDINATION/remediation/AK_VERIFIED_PROCUREMENT/AK_VERIFIED_PROCUREMENT_CHILD_DOMAIN_BREAKDOWN_v1_0_0.md)

Immediate direction:
- introduce one bounded procurement slice in the live frontend so canonical examples parse and execute
- build a real Coq lane for that same bounded slice
- keep TLA+/Alloy smoke models honestly scoped as partial evidence, not full procurement proof
- reduce procurement wording until the live toolchain and formal lane match the claim

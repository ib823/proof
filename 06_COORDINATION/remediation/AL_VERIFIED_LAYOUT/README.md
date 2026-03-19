# AL_VERIFIED_LAYOUT Remediation

Current truth:
- Audit: [AL_VERIFIED_LAYOUT_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AL_VERIFIED_LAYOUT_R5_AUDIT.md)
- Review: [AL_VERIFIED_LAYOUT_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/AL_VERIFIED_LAYOUT_R5_REVIEW.md)
- Current honest rating: `R2`

This package exists because the domain is formally modeled and partially executable, but still far below the repo's research thesis of perfect verified UI/UX.

Core remediation documents:
- [AL_VERIFIED_LAYOUT_REMEDIATION_PLAN_v1_0_0.md](/workspaces/proof/06_COORDINATION/remediation/AL_VERIFIED_LAYOUT/AL_VERIFIED_LAYOUT_REMEDIATION_PLAN_v1_0_0.md)
- [AL_VERIFIED_LAYOUT_R2_TO_R5_WORKLIST_v1_0_0.md](/workspaces/proof/06_COORDINATION/remediation/AL_VERIFIED_LAYOUT/AL_VERIFIED_LAYOUT_R2_TO_R5_WORKLIST_v1_0_0.md)
- [AL_VERIFIED_LAYOUT_CHILD_DOMAIN_BREAKDOWN_v1_0_0.md](/workspaces/proof/06_COORDINATION/remediation/AL_VERIFIED_LAYOUT/AL_VERIFIED_LAYOUT_CHILD_DOMAIN_BREAKDOWN_v1_0_0.md)

Immediate direction:
- reduce the thesis-level wording to the bounded live slice
- wire the standalone `riina-ui` crate into real compiler targets or replace it with a real integrated backend path
- repair the broken canonical `hello_ui.rii` path
- stop implying flexbox/grid/responsive verification until those are live

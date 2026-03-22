# Domain Audit Record

## 1. Identity
- Domain name: Hermetic Build
- Domain identifier: `T_HERMETIC_BUILD`
- Audit date: `2026-03-21`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Coq: T001_HermeticBuild.v — 35% reflexivity, REAL
- Implementation: riina-pkg 54 tests (shared)
- Research: Yes

## 2. Rating
- Current rating: **R2**
- Justification: Coq has real proofs (35% reflexivity). riina-pkg provides 54 tests with build/packaging support. However, no domain-specific hermetic build enforcement exists in the typechecker. Close to R3 but needs specific enforcement with negative cases.

## 3. Safe Public Wording
- Safe claim: "Hermetic build has nontrivial formal models and a tested package system, but lacks specific build hermeticity enforcement."
- Unsafe claim: "RIINA guarantees hermetic builds through formal verification."

## 4. Sign-Off
- Final verdict: **R2**

## 5. Hostile Review Reconciliation

- Hostile review: [T_HERMETIC_BUILD_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/T_HERMETIC_BUILD_R5_REVIEW.md)
- Hostile reviewer: Gemini CLI
- Hostile review verdict: **reject** (downgraded to R1)
- Hostile review maximum honest rating: **R1**
- Hostile review findings:
  - G6 critical: Coq definitions are identity functions (`Definition source_semantics src := src`, `Definition compile binary src := src`) making all proofs tautological despite 35% reflexivity metric
  - G10 critical: Alloy model is auto-generated from vacuous Coq (`// Derived from 02_FORMAL/coq/domains/T001_HermeticBuild.v`)
  - G7/G8: "hermetic" does not appear once in `03_PROTO`; riina-pkg is a standard package manager with no hermeticity enforcement
  - G13: claiming "Close to R3" and "Coq has real proofs" is not supported by the evidence
- Accepted corrections: Downgrade accepted. Gemini's evidence is specific and damning.
  - Identity-function definitions (`compile binary src := src`) render the 35% reflexivity metric meaningless
  - riina-pkg tests do not test hermetic build properties
  - Auto-generated Alloy from vacuous Coq does not count as independent evidence
- Rejected corrections: None. All findings are well-evidenced.
- Final reconciled rating: **R1**
- Remediation package: [README.md](/workspaces/proof/06_COORDINATION/remediation/T_HERMETIC_BUILD/README.md)
- Domain status: **CLOSED** at R1 until remediation items are addressed

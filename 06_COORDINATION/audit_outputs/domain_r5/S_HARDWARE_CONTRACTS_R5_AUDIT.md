# Domain Audit Record

## 1. Identity
- Domain name: Hardware Contracts
- Domain identifier: `S_HARDWARE_CONTRACTS`
- Audit date: `2026-03-21`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Coq: S001_HardwareContracts.v — 56% reflexivity, MIXED
- Implementation: riina-compliance (shared)
- Research: Yes

## 2. Rating
- Current rating: **R2**
- Justification: Coq is mixed (56% reflexivity). riina-compliance provides shared implementation. No domain-specific hardware contract enforcement in the typechecker.

## 3. Safe Public Wording
- Safe claim: "Hardware contracts have partial formal modeling and shared compliance infrastructure, but no domain-specific enforcement."
- Unsafe claim: "RIINA provides formally verified hardware contract guarantees."

## 4. Sign-Off
- Final verdict: **R2**

## 5. Hostile Review Reconciliation

- Hostile review: [S_HARDWARE_CONTRACTS_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/S_HARDWARE_CONTRACTS_R5_REVIEW.md)
- Hostile reviewer: Gemini CLI
- Hostile review verdict: **reject** (downgraded to R0)
- Hostile review maximum honest rating: **R0**
- Hostile review findings:
  - G10 critical: `leakage ms ms' := []` makes all constant-time proofs trivially vacuous
  - G3 critical: riina-compliance has zero hardware contract logic; only a string literal `hardware_input` for DO178C
  - G12 critical: R2 rating is overclaimed given no formal enforcement and no typechecker implementation
  - G9 fail: no negative tests for the domain
- Partially accepted corrections: Gemini's evidence about vacuous leakage model and absent implementation is accurate. However:
  - R0 is too harsh: research folder exists with domain-specific research documents, which satisfies R1 minimum ("research exists")
  - The Coq file exists and compiles even if proofs are vacuous, which is structural evidence above R0
- Rejected corrections: R0 downgrade rejected. R1 minimum is warranted by research existence.
- Accepted corrections: R2 was overclaimed. Vacuous leakage model and absent implementation confirm the domain lacks R2-level evidence.
- Final reconciled rating: **R1**
- Remediation package: [README.md](/workspaces/proof/06_COORDINATION/remediation/S_HARDWARE_CONTRACTS/README.md)
- Domain status: **CLOSED** at R1 until remediation items are addressed

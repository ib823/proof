# Domain Audit Record

## 1. Identity
- Domain name: Certified Compilation
- Domain identifier: `R_CERTIFIED_COMPILATION`
- Audit date: `2026-03-21`
- Auditor: Claude Code (Opus 4.6)
- Current repo commit: `2d436b083b56005b101f18718a7bd0f0aab722e9`
- Coq: Shares CompilerCorrectness.v — VACUOUS (same as Q)
- Implementation: riina-codegen (shared with Q)
- Research: Yes

## 2. Rating
- Current rating: **R2**
- Justification: Shares vacuous CompilerCorrectness.v with Q_COMPILER_ARCHITECTURE. Real implementation exists via riina-codegen but Coq certification proofs are boolean stubs. No independent certified compilation evidence beyond Q.

## 3. Safe Public Wording
- Safe claim: "Certified compilation shares the compiler implementation with tested codegen, but formal certification proofs are vacuous."
- Unsafe claim: "RIINA provides certified compilation with proven correctness guarantees."

## 4. Sign-Off
- Final verdict: **R2**

## 5. Hostile Review Reconciliation

- Hostile review: [R_CERTIFIED_COMPILATION_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/R_CERTIFIED_COMPILATION_R5_REVIEW.md)
- Hostile reviewer: Gemini CLI
- Hostile review verdict: **reject** (downgraded to R1)
- Hostile review maximum honest rating: **R1**
- Hostile review findings:
  - G6 critical: CompilerCorrectness.v models an AST lacking functions or variables; WasmBackendVerification.v drops false branches of conditionals (`IRIf c t f => compile_ir t`); BackendTraitVerification.v uses `Definition preserves ... := true`
  - G10 critical: formal models are disconnected toy representations, worse than the "boolean stubs" characterization
  - G7 partial: riina-codegen exists but has zero connection to the formal model
  - G14 fail: changes to formal model have no impact on implementation
- Accepted corrections: Downgrade accepted. Gemini's evidence is specific and verifiable.
  - The formal models are indeed toy representations disconnected from real compilation semantics
  - WasmBackendVerification.v dropping the false branch of conditionals is a disqualifying defect
  - R1 is appropriate: research exists, implementation exists, but formal certification is cosmetic
- Rejected corrections: None. Gemini's findings are well-evidenced.
- Final reconciled rating: **R1**
- Remediation package: [README.md](/workspaces/proof/06_COORDINATION/remediation/R_CERTIFIED_COMPILATION/README.md)
- Domain status: **CLOSED** at R1 until remediation items are addressed

# Remediation Package: R_CERTIFIED_COMPILATION

## Domain

- Domain ID: `R_CERTIFIED_COMPILATION`
- Domain name: Certified Compilation
- Current honest rating: `R1`
- Target rating: `R2`
- Audit: [R_CERTIFIED_COMPILATION_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/R_CERTIFIED_COMPILATION_R5_AUDIT.md)
- Hostile review: [R_CERTIFIED_COMPILATION_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/R_CERTIFIED_COMPILATION_R5_REVIEW.md)
- Hostile review verdict: reject (downgraded from R2 to R1, accepted)
- Created: 2026-03-21

## Why R1

The hostile review identified disqualifying defects in the formal models:

- WasmBackendVerification.v drops the false branch of conditionals (`IRIf c t f => compile_ir t`)
- BackendTraitVerification.v uses `Definition preserves ... := true` (boolean tautology)
- CompilerCorrectness.v models an AST lacking functions or variables
- Formal models are disconnected toy representations with no link to riina-codegen
- riina-codegen has 451 passing tests but zero connection to formal certification

R1 is warranted because research and a real implementation exist, but formal certification is cosmetic.

## Remediation Items to Reach R2

### R2-1: Rewrite WasmBackendVerification.v with faithful IR model

**Gate:** G6
**What:** Replace the toy IR with one that includes variables, functions, and correct conditional compilation (both branches).
**Acceptance:** `IRIf` compiles both true and false branches. IR includes `IRLet`, `IRLam`, `IRVar`.

### R2-2: Replace boolean tautologies in BackendTraitVerification.v

**Gate:** G6
**What:** Replace `Definition preserves ... := true` with meaningful preservation properties.
**Acceptance:** No `Definition ... := true` patterns remain.

### R2-3: Link formal model to riina-codegen

**Gate:** G7, G11
**What:** Document which Coq theorems correspond to which riina-codegen test suites.
**Acceptance:** At least 5 formal properties have traceable links to executable tests.

## Re-audit Trigger

Re-audit after R2-1 and R2-2 are completed and the Coq file compiles cleanly.

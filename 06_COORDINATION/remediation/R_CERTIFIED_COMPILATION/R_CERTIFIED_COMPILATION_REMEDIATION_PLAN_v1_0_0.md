# R_CERTIFIED_COMPILATION Remediation Plan v1.0.0

## Purpose

Replace the cosmetic formal models with faithful IR representations that actually model certified compilation, bridging the gap from R1 to R2.

## Current Truth

As of [R_CERTIFIED_COMPILATION_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/R_CERTIFIED_COMPILATION_R5_AUDIT.md) and [R_CERTIFIED_COMPILATION_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/R_CERTIFIED_COMPILATION_R5_REVIEW.md):
- `R_CERTIFIED_COMPILATION` is `R1` (downgraded from R2 by hostile review)
- WasmBackendVerification.v drops false branches: `IRIf c t f => compile_ir t`
- BackendTraitVerification.v uses boolean tautologies: `Definition preserves ... := true`
- CompilerCorrectness.v models an AST without functions or variables
- riina-codegen has 451 passing unit tests with real implementation evidence
- Zero formal-to-implementation connection exists

## Governing Rules

1. A formal model that drops control flow branches is worse than having no model (it is actively misleading).
2. Boolean tautologies (`preserves := true`) do not count as formal evidence at any level.
3. Implementation tests are strong but cannot substitute for formal certification.
4. The domain shares CompilerCorrectness.v with Q_COMPILER_ARCHITECTURE; changes affect both domains.

## Required Structural Changes

### 1. Rewrite WasmBackendVerification.v

The current model drops the false branch of conditionals and stubs out function calls. A faithful model must compile both branches of `IRIf` and handle `IRCall` with argument evaluation.

### 2. Replace BackendTraitVerification.v tautologies

Every `Definition ... := true` must be replaced with a property that can actually be falsified. Preservation properties should relate source semantics to compiled output semantics.

### 3. Extend CompilerCorrectness.v IR

The IR must include at minimum: variables, let-bindings, and function application. A compiler correctness proof for an IR without these constructs proves nothing about the real compiler.

### 4. Establish formal-to-implementation traceability

Document which Coq theorems correspond to which riina-codegen test suites. At minimum, 5 formal properties should have traceable links.

## Per-Gate Remediation Steps

| Gate | Status | Remediation | Artifact | Exit Criterion |
|------|--------|-------------|----------|----------------|
| G6 | Fail | Rewrite all three Coq files | `WasmBackendVerification.v`, `BackendTraitVerification.v`, `CompilerCorrectness.v` | No tautologies, no dropped branches, IR includes variables and functions |
| G7 | Partial | Link formal model to implementation | Traceability document | At least 5 properties linked to tests |
| G10 | Fail | Ensure proofs are non-vacuous | Proof body analysis | No `reflexivity`-only proofs on trivial definitions |
| G11 | Fail | Document formal-to-implementation gap | Audit update | Gap is explicit and bounded |
| G14 | Fail | Ensure formal model changes affect tests | Regression check | Coq and Rust are coupled |

## Exit Criteria

`R_CERTIFIED_COMPILATION` may not claim R2 until:
- WasmBackendVerification.v compiles both branches of conditionals
- No `Definition ... := true` patterns remain in BackendTraitVerification.v
- CompilerCorrectness.v IR includes variables, let-bindings, and functions
- At least 5 formal properties have traceable links to executable tests
- Re-audit confirms all remediated gates pass

# Domain Audit Review: R_CERTIFIED_COMPILATION

## Verdict
reject

## Snapshot validation
- Branch: main
- Commit: 2d436b083b56005b101f18718a7bd0f0aab722e9
- Valid for this snapshot: yes
- Drift: materially harmless

## Maximum honest rating
R1 (downgraded from R2)

## Gate review table
| Gate | Audit Score | Reviewer Score | Disposition | Evidence | Consequence |
|---|---|---|---|---|---|
| G1 Canonical Identity | N/A | pass | agree | Domain name and ID exist. | Baseline identity established. |
| G2 Boundary Precision | N/A | fail | disagree | No clear boundary separating the toy formal model from the real implementation. | Boundary is misleading. |
| G3 Workflow Inventory | N/A | fail | disagree | Formal proofs are strictly limited to toy IR expressions (no functions, loops, or variables). | Workflows are not formally modeled. |
| G4 Threat and Failure Model | N/A | fail | disagree | Missing failure model for compilation. | No adversarial compilation analysis. |
| G5 Property Set | N/A | fail | disagree | Properties in formal models are generic or boolean tautologies. | Inadequate properties. |
| G6 Formal Model Depth | N/A | fail | disagree | `BackendTraitVerification.v` uses `Definition preserves ... := true`. `WasmBackendVerification.v` compiles `IRIf c t f` strictly to `compile_ir t` (dropping the false branch entirely). `CompilerCorrectness.v` models a language without lambdas or variables. | Formal model is vacuous and cosmetic. Fails R2 requirement. |
| G7 Toolchain Enforcement | N/A | partial | agree | `riina-codegen` exists and passes tests, but has zero connection to the formal model. | Enforcement is unverified. |
| G8 Executable Evidence | N/A | pass | agree | `riina-codegen` has comprehensive unit tests passing. | Good implementation evidence. |
| G9 Adversarial Coverage | N/A | partial | disagree | Tests exist but lack adversarial focus on compilation errors. | Needs deeper adversarial tests. |
| G10 Evidence Honesty | N/A | fail | disagree | Audit missed the extreme level of simplification in `WasmBackendVerification.v` and `CompilerCorrectness.v` where core control flow and functions are stubbed out entirely. | Major evidence misrepresentation. |
| G11 Observability | N/A | fail | disagree | No trace between the toy proofs and the real codegen. | Cannot audit the connection. |
| G12 Freshness | N/A | pass | agree | Metrics and builds run successfully. | Environment is fresh. |
| G13 Public Claim | N/A | fail | disagree | Even the "safe claim" implies formal certification proofs exist as "boolean stubs" when they also include deceptive toy models. | Claim must be corrected to R1. |
| G14 Regression | N/A | fail | disagree | Changes to the formal model have no impact on the implementation. | No regression immunity. |

## Findings table
| Severity | Gate | Claim under dispute | Counter-evidence | Required downgrade or correction |
|---|---|---|---|---|
| Critical | G6 | Rating of R2. | `CompilerCorrectness.v` proves properties on an AST lacking functions or variables. `WasmBackendVerification.v` explicitly ignores false branches of `if`. `BackendTraitVerification.v` uses boolean `true = true` stubs. | Downgrade to R1. The formal model is the wrong abstraction layer and entirely cosmetic. |
| High | G10 | Audit characterization of evidence. | Audit claims "Coq certification proofs are boolean stubs" but missed that the IR translations exist but are drastically simplified/stubbed out (e.g., `IRIf c t f => compile_ir t`). | Update audit to explicitly state the formal models are toy ASTs with missing control flow. |

## Overclaim lines
- "Shares vacuous CompilerCorrectness.v with Q_COMPILER_ARCHITECTURE." (It's worse than vacuous boolean stubs; it's a deceptive toy model).
- The rating of R2 is an overclaim because a model that intentionally drops the false branch of conditionals and lacks variables/functions cannot be considered a "formal model" of the domain in any serious capacity.

## Missed evidence lines
- `02_FORMAL/coq/domains/WasmBackendVerification.v` exists but is highly stubbed (e.g., `IRCall _ _ => 0`, `IRLet ... => ... WDrop ...`).
- `02_FORMAL/coq/domains/BackendTraitVerification.v` exists but uses `Definition preserves ... := true`.
- `03_PROTO/crates/riina-codegen` has 451 passing unit tests.

## Safe claim
"Certified compilation is currently a specified concept; while a functioning implementation exists in `riina-codegen`, all formal models are completely disconnected toy representations or vacuous stubs."

## Unsafe claim
"RIINA formally models certified compilation." (The models are too disconnected and trivial to count as a model of the real system).

## Release condition
Must establish a faithful formal model of the actual RIINA IR and prove preservation against it, or completely decouple the live implementation from the "certified" claim.

## Next review advice
Inspect whether the formal models have been rewritten to reflect actual language semantics (variables, effects, loops, control flow) rather than toy examples. Ensure the codegen tests include adversarial/malformed input rejection.
# Hermetic Build (T_HERMETIC_BUILD) R5 Adversarial Review

## Verdict
**reject**

## Snapshot validation
- **Branch:** main
- **Commit:** 2d436b083b56005b101f18718a7bd0f0aab722e9
- **Review Validity:** The review remains materially valid for this snapshot.
- **Drift Assessment:** Drift from the original audit snapshot is materially harmless (only audit/tracker files have changed).

## Maximum honest rating
**R1** (The domain possesses a basic research outline and a package manager, but the formal models are completely vacuous and deceptive, and the implementation does not enforce hermeticity. "R2" is not justified.)

## Gate review table

| Gate | Audit Score | Reviewer Score | Disposition | Evidence | Consequence |
|------|-------------|----------------|-------------|----------|-------------|
| `G1` Canonical Identity | Pass | Partial | Downgrade | The domain has an identifier and some research but fails to map to real domain artifacts. | Needs actual domain definition. |
| `G2` Boundary Precision | Pass | Fail | Downgrade | No real threat boundaries defined in the vacuous model. | Fails isolation requirements. |
| `G3` Workflow Inventory | Pass | Fail | Downgrade | No workflows exist that enforce hermeticity. | Fails workflow mapping. |
| `G4` Threat and Failure Model | Pass | Fail | Downgrade | Model is completely unanchored to real threats. | Blocks R2. |
| `G5` Property Set | Partial | Fail | Downgrade | The properties defined in Coq map inputs directly to outputs (e.g., `Definition compile binary src := src`). | Not real properties. |
| `G6` Formal Model Depth | Partial | Fail | Downgrade | The Coq proofs are 100% vacuous tautologies. Definitions are identity functions (`Definition source_semantics src := src`). | Blocks R2. Model must be rewritten. |
| `G7` Toolchain Enforcement | Partial | Fail | Downgrade | The string "hermetic" does not appear once in the `03_PROTO` implementation. | Blocks R3. |
| `G8` Executable Evidence | Partial | Fail | Downgrade | `riina-pkg` has 54 tests but none test hermetic build properties. | Blocks R3. |
| `G9` Adversarial Coverage | Fail | Fail | Agree | No negative or adversarial tests exist. | Blocks R4. |
| `G10` Evidence Honesty Across Prover Lanes | Pass | Fail | Downgrade | Alloy model is an auto-generated translation of the vacuous Coq model (`// Derived from 02_FORMAL/coq/domains/T001_HermeticBuild.v`). | Major defect; violates honesty requirements. |
| `G11` Observability and Auditability | Partial | Fail | Downgrade | No observable enforcement of hermeticity. | Blocks R3. |
| `G12` Freshness and Reproducibility | Pass | Fail | Downgrade | The formal proofs reproduce but are meaningless. | Blocks R5. |
| `G13` Public Claim Discipline | Partial | Fail | Downgrade | Claiming "Close to R3" and "Coq has real proofs" is dangerously deceptive. | Blocks public claims. |
| `G14` Regression Immunity | Fail | Fail | Agree | No domain-specific regressions are prevented. | Blocks R5. |

## Findings table

| Severity | Gate | Claim under dispute | Counter-evidence | Required downgrade or correction |
|----------|------|---------------------|------------------|----------------------------------|
| CRITICAL | G6 | "Coq has real proofs (35% reflexivity)" | All Coq proofs are tautologies over identity functions (e.g., `Definition compile binary src := src`). 100% vacuous. | Downgrade to Fail. The model must be rewritten to represent a real semantic boundary. |
| CRITICAL | G10 | Implied independent multi-prover evidence | Alloy file explicitly states `// Derived from 02_FORMAL/coq/domains/T001_HermeticBuild.v`. | Downgrade G10 to Fail. Remove claims of independent multi-prover support. |
| HIGH | G7/G8 | "riina-pkg provides 54 tests with build/packaging support" | Zero occurrences of "hermetic" in `03_PROTO`. `riina-pkg` is just a standard package manager with no domain-specific hermeticity enforcement. | Downgrade implementation claims. Do not conflate basic packaging with hermetic build properties. |
| HIGH | G13 | Rating "R2" and "Close to R3" | The domain lacks both a nontrivial formal model and any implementation enforcement of the domain properties. | Downgrade rating to R1. Correct public wording. |

## Overclaim lines
- "Coq has real proofs (35% reflexivity)." (The proofs are entirely vacuous tautologies and identity functions).
- "Close to R3 but needs specific enforcement with negative cases." (It is not close to R3; it barely qualifies for R1 since the formal model is deceptive).

## Missed evidence lines
- The audit missed that `02_FORMAL/alloy/RIINA/Domains/T001_HermeticBuild.als` is purely auto-generated and contains vacuous assertions (`all c: Stage | some c.f_stage_id`).
- The audit missed that the Coq definitions are trivial (`Definition source_semantics src := src`, `Definition executes ... := output = input`).

## Safe claim
"Hermetic build (T_HERMETIC_BUILD) is in the research and design phase. Currently, no formal or executable enforcement of hermeticity exists."

## Unsafe claim
"RIINA guarantees hermetic builds through formal verification, supported by real proofs in Coq and an integrated package manager."

## Release condition
- Rewrite the Coq formal model so that it defines an actual semantic gap between source, binary, and environment, rather than using identity functions.
- Implement explicit hermeticity controls (e.g., network namespace isolation, deterministic clock wrappers) in `riina-pkg` or the compiler toolchain.
- Provide independent, non-generated evidence in a second prover lane.

## Next review advice
Inspect the fundamental definitions in Coq (like `source_semantics` and `compile`) before counting theorems or looking at proof tactics. Do not accept generated files (`// Derived from...`) in other prover lanes as independent verification. Search the implementation specifically for the domain's core concepts (e.g., "hermetic", "sandbox") rather than accepting generic package manager tests as evidence.
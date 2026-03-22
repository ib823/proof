# Domain Audit Review

## Verdict
reject

## Snapshot validation
- **Branch:** main
- **Commit:** 2d436b083b56005b101f18718a7bd0f0aab722e9
- **Review Valid for Snapshot:** Yes
- **Drift:** Materially harmless (only unrelated tracking files and audit documents modified since snapshot).

## Maximum honest rating
**R3** (Enforced Subsystem)
The domain possesses rigorous formal models for semantic preservation on a simplified IR and substantial live compiler implementation evidence (493 tests in `riina-codegen`). It exceeds R2, but lacks the end-to-end exact formal-to-live mapping for the full unrestricted language required for R4.

## Gate review table

| Gate | Audit Score | Reviewer Score | Disposition | Evidence | Consequence |
|---|---|---|---|---|---|
| G1: Canonical Identity | Pass | Fail | Downgrade | Missing proper scoping/assumption documentation in the audit. | Prevents R5. |
| G2: Boundary Precision | Ignore | Fail | Downgrade | No strict domain exit/entry criteria defined. | Prevents R5. |
| G3: Workflow Inventory | Ignore | Fail | Downgrade | No workflow matrix provided. | Prevents R5. |
| G4: Threat and Failure Model | Ignore | Fail | Downgrade | Missing adversary and abuse case modeling. | Prevents R5. |
| G5: Property Set | Ignore | Fail | Downgrade | No rigorous property definitions provided in the audit. | Prevents R5. |
| G6: Formal Model Depth | Fail | Pass | Upgrade | `CompilerCorrectness.v` contains robust semantic preservation, type safety, and optimization proofs (Sections 5-20) for a simplified IR. No admits/axioms. | The audit's claim that the Coq file is "vacuous" is factually incorrect. |
| G7: Toolchain Enforcement | Pass | Pass | Agree | `riina-codegen` crate demonstrates strong enforcement (493 tests). | Supports R3. |
| G8: Executable Evidence | Pass | Pass | Agree | Rust tests run and pass, including 41 `wasm_e2e` tests. | Supports R3. |
| G9: Adversarial Coverage | Pass | Pass | Agree | Unit tests cover both success and failure cases. | Supports R3. |
| G10: Evidence Honesty Across Prover Lanes | Pass | Pass | Agree | The audit did not rely on the auto-generated multi-prover lanes (`fstar`, `lean`, etc.). | Supports R3. |
| G11: Observability and Auditability | Fail | Fail | Agree | The auditor failed to properly observe the primary Coq artifact, stopping their review at line 90. | Audit is untrustworthy. |
| G12: Freshness and Reproducibility | Pass | Pass | Agree | Code compiles and tests run deterministically. | Supports R3. |
| G13: Public Claim Discipline | Fail | Fail | Agree | The audit recommended a self-sabotaging public claim based on flawed analysis. | Must rewrite safe claim. |
| G14: Regression Immunity | Pass | Pass | Agree | Extensive Rust tests and zero-admit Coq file enforce regression immunity. | Supports R3. |

## Findings table

| Severity | Gate | Claim under dispute | Counter-evidence | Required downgrade or correction |
|---|---|---|---|---|
| Critical | G6 | "Coq proofs are vacuous boolean stubs... Vacuous Coq prevents R3." | `CompilerCorrectness.v` Sections 5-20 contain over 800 lines of mathematically rigorous proofs without `Axiom` or `Admitted`, establishing forward/backward simulation, determinism, and type preservation for an Intermediate Representation. | Acknowledge the substantive formal proofs and stop claiming the formal model is vacuous. Upgrade the rating cap from R2 to R3. |
| Major | G13 | Safe claim: "...but Coq compiler correctness proofs are vacuous boolean stubs." | The Coq proofs are not vacuous. They rigorously prove semantic preservation for a simplified subset of the language. | Rewrite the safe claim to accurately reflect the existence of the formal semantic preservation proofs. |
| Major | G1-G5 | The audit entirely skipped workflow, threat, and property matrices. | The audit only focuses on a high-level file check and fails to build the standard evidence pack required by the `DOMAIN_R5_CHECKLIST`. | Complete the G1-G5 documentation before re-auditing for R4/R5. |

## Overclaim lines
None. The audit committed a severe *underclaim* by falsely asserting that the formal evidence was completely vacuous, missing the deep formal semantics proven in the very file it cited.

## Missed evidence lines
- `02_FORMAL/coq/domains/CompilerCorrectness.v` Sections 5 through 20: Comprehensive formal proofs of type preservation, progress, optimization soundness, and full semantic bisimulation for a simplified Intermediate Representation.
- `tests/wasm_e2e.rs` in `03_PROTO/crates/riina-codegen`: 41 end-to-end integration tests proving executable functionality.

## Safe claim
"RIINA's compiler features a heavily tested Rust implementation (`riina-codegen`) and is supported by formally verified Coq proofs demonstrating semantic preservation and type safety for a core Intermediate Representation."

## Unsafe claim
"RIINA's compiler is fully verified end-to-end without any assumptions, and the formal model maps 1:1 to every feature of the live implementation."

## Release condition
Reject the audit. The auditor must re-evaluate `CompilerCorrectness.v` past the legacy stubs at the top of the file, acknowledge the rigorous semantic preservation proofs, raise the maximum rating to R3, and complete the missing G1-G5 structural documentation.

## Next review advice
A hostile reviewer must read the *entirety* of a formal artifact before declaring it vacuous. A file may contain legacy configuration stubs at the top for backward compatibility, while containing hundreds of lines of mathematically deep, un-admitted proofs immediately below them.

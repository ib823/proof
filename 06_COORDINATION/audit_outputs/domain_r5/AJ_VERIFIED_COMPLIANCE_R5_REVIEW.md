# Domain Audit Review

## 1. Verdict

**Verdict: accept**

The primary audit accurately identifies the mismatch between the high-level business/research claims and the reality of the implementation. It correctly zeroes in on the fact that compliance checks are implemented as an opt-in post-typechecking AST linter, while public and business documentation claim these checks are intrinsic "type errors." It also correctly identifies the vacuity of derived secondary formal lanes and the duplication of the Coq specification.

## 2. Snapshot Validation

- **Branch:** `main`
- **Commit:** `0293b678480d19c92843c34b2a25306bca54eb60`
- **Review Valid:** Yes
- **Drift:** Materially harmless. Drift consists solely of new audit output documents, review prompts, and orchestration scripts. No domain implementation, formal proofs, or functional code have changed since the snapshot.

## 3. Maximum Honest Rating

- **Maximum honest rating:** `R1`
- **Rationale:** The domain possesses a canonical research file and a functioning heuristic tool (`riina-compliance`) that passes unit tests. However, the lack of core language frontend semantics (no `Compliance` effect or types) and the failure of canonical examples to parse restrict this domain from reaching `R2` or `R3`.

## 4. Gate Review Table

| Gate | Audit Score | Reviewer Score | Disposition | Evidence | Consequence |
|------|-------------|----------------|-------------|----------|-------------|
| `G1` Canonical Identity | Partial | Partial | Accept | Canonical source set can be reconstructed, but the formal lane has duplicate files (`02_FORMAL/coq/compliance/VerifiedCompliance.v` vs `02_FORMAL/coq/domains/VerifiedCompliance.v`). | Rating ceiling held |
| `G2` Boundary Precision | Fail | Fail | Accept | `04_SPECS/business/RIINA_BUSINESS_MODEL_v1_0_0.md` explicitly claims compliance violations are "type errors", but enforcement is via post-typecheck AST linter. | Blocker for higher ratings |
| `G3` Workflow Inventory | Partial | Partial | Accept | Tooling `riina-compliance` executes AST validations and report generation, but end-to-end frontend enforcement fails. | Accurately scored |
| `G4` Threat and Failure Model | Fail | Fail | Accept | No live failure model enforced for evidence tampering, runtime blind spots, or rule decay. | Accurately scored |
| `G5` Property Set | Partial | Partial | Accept | Properties mapped in Coq and heuristic AST checks exist, but lack type-level safety bounds. | Accurately scored |
| `G6` Formal Model Depth | Fail | Fail | Accept | Coq file acts as a shallow definitional wrapper; other lanes (SMT, Alloy, TLA+) are derived and mechanically vacuous (`= 0 0`, `== TRUE`, `some store`). | Blocks `R2` |
| `G7` Toolchain Enforcement | Fail | Fail | Accept | Compliance isn't in core typing/effect system; `grep -RIn "Compliance"` on parser/typechecker yields nothing. | Critical blocker |
| `G8` Executable Evidence | Fail | Fail | Accept | Canonical example `07_EXAMPLES/04_compliance/gdpr_consent.rii` fails to parse (`Unexpected token: KwType`). | Blocks workflow claims |
| `G9` Adversarial Coverage | Fail | Fail | Accept | Rule tests exist (1087 tests pass) but they test the heuristic AST linter against predictable patterns, not adversarial workflows. | Accurately scored |
| `G10` Evidence Honesty Across Prover Lanes | Fail | Fail | Accept | Severe inflation from `Derived from` lanes and duplicate Coq files outruns actual formal depth. | Requires formal cleanup |
| `G11` Observability and Auditability | Partial | Partial | Accept | JSON/text reports are generated with profile coverage, but no verifiable runtime evidence chain exists. | Accurately scored |
| `G12` Freshness and Reproducibility | Pass | Pass | Accept | Audit commands cleanly reproduce current reality at snapshot `0293b678480d19c92843c34b2a25306bca54eb60`. | Validates audit |
| `G13` Public Claim Discipline | Fail | Fail | Accept | Clear boundary breach in `RIINA_BUSINESS_MODEL_v1_0_0.md` claiming compliance properties as intrinsic "type errors" backed by proofs. | Safety risk |
| `G14` Regression Immunity | Fail | Fail | Accept | No domain-specific CI/regression checks to enforce alignment between research claims and live system. | Accurately scored |

## 5. Findings Table

| Severity | Gate | Claim under dispute | Counter-evidence | Required downgrade or correction |
|----------|------|---------------------|------------------|----------------------------------|
| High | `G7`, `G13` | "Compliance violations are type errors" | Core typechecker has zero knowledge of compliance types/effects. AST rules apply only after standard typechecking via CLI flags. | Accept audit finding; business docs and public claims must be downgraded to "post-compilation static analysis rule validation" until core semantics exist. |
| Critical | `G10` | Evidence Honesty across Prover Lanes | Alloy generates 35 vacuous `some store` checks; SMT reduces 35 tests to `= 0 0`; TLA+ maps to `== TRUE`. | Accept audit finding; all derived formal artifacts must be demoted or explicitly excluded from deep evidence counts. |
| High | `G8` | Executable Evidence | Running `cargo run ... check --compliance gdpr 07_EXAMPLES/04_compliance/gdpr_consent.rii` fails in parser with `Unexpected token: KwType`. | Accept audit finding; fix the example to parse correctly or stop counting it as evidence. |

## 6. Overclaim Lines

- None identified in the primary audit. The auditor was appropriately harsh, identifying and properly downgrading the overblown compile-time claims.

## 7. Missed Evidence Lines

- None. The audit accurately captured the positive heuristic rule tests (1087 passing tests in `riina-compliance`) while recognizing they represent AST linting rather than type-level evidence.

## 8. Safe Claim

`RIINA provides an opt-in, post-typecheck compliance rule engine for multiple regulatory profiles that generates coverage reports, but it does not yet guarantee compliance as an enforced compile-time type property or provide continuous runtime monitoring.`

## 9. Unsafe Claim

`RIINA guarantees regulatory compliance at compile time through its type system, turning compliance violations into type errors, backed by formal proofs for every rule.`

## 10. Release Condition

- Remove "compliance violations are type errors" and similar claims from `04_SPECS/business/RIINA_BUSINESS_MODEL_v1_0_0.md` and any website copy.
- Fix canonical compliance examples (like `gdpr_consent.rii`) so they cleanly pass the live parser and typechecker.
- Remove duplicate Coq files and clearly label or delete vacuous automated artifacts in non-Coq prover lanes to eliminate "Evidence Honesty" failures.
- Introduce actual core frontend compliance semantics (a bounded compliance effect/type regime) before claiming compile-time compliance.

## 11. Next Review Advice

Proceed to `AK_VERIFIED_PROCUREMENT` as recommended. Apply the same adversarial filter against derived/vacuous TLA+/SMT lanes and check strictly whether "procurement" features leak into the core frontend or remain superficial AST checks/linting features like the compliance domain. Use the `04_SPECS/business` documents as a primary target for finding overstatements.
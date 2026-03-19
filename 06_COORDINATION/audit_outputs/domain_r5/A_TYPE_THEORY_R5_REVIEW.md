# RIINA Domain Adversarial Review

## Verdict
- **Verdict:** `REJECT`
- **Reason:** The provisional `R3` rating is not justified for the `A_TYPE_THEORY` umbrella domain as a whole. While a core subset of the domain shows `R3`-level properties, the audit's own findings, confirmed by this review, reveal critical failures in boundary precision (G2), evidence honesty (G10), and public claim discipline (G13). The formal model is significantly broader than the live implementation, and non-Coq prover lanes are overwhelmingly generated, derived, or vacuous, providing no meaningful independent confirmation.

## 1. Identity & Snapshot Validation

- **Domain Name:** Type Theory Foundations
- **Domain ID:** `A_TYPE_THEORY`
- **Audit Date:** 2026-03-19
- **Reviewer:** Gemini Adversarial Agent
- **Branch:** `main`
- **Commit:** `5e861d69924fd904619cc56f2a6734d571ccbb06`
- **Snapshot Validity:** The current `HEAD` commit matches the target commit. There are no materialized code changes since the audit snapshot. This review is **materially valid** for the domain evidence surface.

## 2. Maximum Honest Rating

- **Auditor's Rating:** `R3` (provisional)
- **Reviewer's Maximum Honest Rating:** `R2`
- **Justification:** The domain has a strong formal model in Coq (passing G6) but fails on too many other fronts to warrant an `R3` rating for the umbrella.
    - **G2 (Boundary Precision):** Fails. The research umbrella (`20` type theory branches) massively overstates the live implementation subset.
    - **G7 (Toolchain Enforcement):** Partial. Enforcement exists but only for a small, bounded core subset (no dependent, refinement, gradual, etc.).
    - **G8 (Executable Evidence):** Partial/Fail. Ad-hoc tests pass, but the canonical example corpus is stale and fails to build, undermining claims of end-to-end validity.
    - **G10 (Evidence Honesty):** Critical Failure. Non-Coq prover lanes (Lean, Isabelle, F*, SMT, Alloy, TLA+) are almost entirely auto-generated from Coq or contain vacuous placeholders (`admit ()`, `= 0 0`, `== TRUE`). They offer no independent evidence and counting them is a major inflation risk.
    
A domain where the formal model is real but the implementation is partial, the examples are broken, and the cross-validation evidence is cosmetic is definitionally `R2` ("Formally Modeled"), not `R3` ("Enforced Subsystem").

## 3. Gate Review Table

| Gate | Audit Score | Reviewer Score | Disposition | Counter-Evidence / Consequence |
|------|-------------|----------------|-------------|--------------------------------|
| `G1` Canonical Identity | Partial | **Partial** | AGREE | The domain identity is a sprawling 20-branch research umbrella, while the live domain is a small subset. This ambiguity is a recurring problem. |
| `G2` Boundary Precision | Fail | **FAIL** | DISAGREE | The gap between the 20 research branches and the handful of live features is a critical boundary failure. The audit notes this but `Fail` is the only honest score. |
| `G3` Workflow Inventory | Partial | **Fail** | DISAGREE | The canonical example corpus, which should demonstrate the workflows, is broken. `riinac check` fails on `hello.rii`, `linear_types.rii`, etc. This invalidates the workflow evidence. |
| `G4` Threat Model | Partial | **Partial** | AGREE | The audit correctly notes that the threat model is incomplete for the full umbrella. The live subset has tests for type/memory safety, but not for advanced logic bugs. |
| `G5` Property Set | Partial | **Partial** | AGREE | Core properties (Progress, Preservation) are proven in Coq, but properties for most of the 20 research branches are not implemented or enforced. |
| `G6` Formal Model Depth | Pass | **Pass** | AGREE | Independent check confirms the active Coq proofs for the core metatheory are real, non-trivial, and free of `Axiom` or `Admitted`. |
| `G7` Toolchain Enforcement| Partial | **Partial** | AGREE | `cargo test` confirms a real typechecker exists and rejects invalid programs. However, it only enforces a small subset of the formally modeled features. |
| `G8` Executable Evidence | Partial | **FAIL** | DISAGREE | The failure of canonical examples under `riinac check` is a critical defect. An `R3` domain cannot have broken examples for its core workflows. |
| `G9` Adversarial Coverage | Partial | **Partial** | AGREE | The Rust unit tests include many negative cases. However, without working end-to-end examples, adversarial coverage for full workflows is weak. |
| `G10` Evidence Honesty | Fail | **CRITICAL FAIL** | DISAGREE (Severity) | This is the most severe finding. The non-Coq evidence is a facade. Grep results confirm mass auto-generation, `admit ()` in F*, `= 0 0` in SMT, `== TRUE` in TLA+, and `some st` in Alloy. This is not independent confirmation. |
| `G11` Observability | Pass | **Pass** | AGREE | It is possible to trace claims back to artifacts, even if those artifacts are weak. The audit itself demonstrates this. |
| `G12` Freshness | Pass | **Pass** | AGREE | `git rev-parse HEAD` and `audit-docs.sh` confirm the state is as described. The evidence is fresh. |
| `G13` Public Claim | Fail | **FAIL** | AGREE | Claiming `A_TYPE_THEORY` is supported at any level is misleading. Only a "core type subsystem" is supported. The audit's proposed "safe claim" is still too broad. |
| `G14` Regression Immunity| Partial | **Partial** | AGREE | `cargo test` provides regression immunity for the implementation subset, but there is no gate that checks the umbrella claim against the implemented reality. |

## 4. Findings

| Severity | Gate | Claim Under Dispute | Counter-Evidence | Required Correction |
|----------|------|-----------------------|------------------|---------------------|
| CRITICAL | G10 | Independent multi-prover verification | `grep -RIn "Auto-generated from" 02_FORMAL`, `grep -RIn "admit ()" 02_FORMAL/fstar`, `grep -RIn "= 0 0" 02_FORMAL/smt`. The vast majority of non-Coq evidence is generated, derived, or vacuous. | Immediately downgrade domain to `R2`. Cease all claims of multi-prover confirmation for this domain until artifacts are manually and independently re-written. |
| HIGH | G2, G13 | The `A_TYPE_THEORY` domain is `R3` | The live toolchain does not implement the majority of the 20 research branches (e.g., dependent, refinement, gradual types). | The audit must be for the "Core Type Subsystem" only, not the umbrella. Public claims must be scoped down accordingly. |
| HIGH | G8 | Covered workflows are end-to-end valid. | `riinac check 07_EXAMPLES/00_basics/hello.rii` fails with `Unexpected token: RBrace`. Other core examples also fail. | Fix or remove all failing canonical examples. An `R3` claim is impossible without working end-to-end evidence for the covered subset. |
| MEDIUM | G3 | Workflow inventory is robust. | The failure of the example corpus means the claimed workflows are not demonstrably executable, even if they are tested at the unit level. | The workflow inventory must be rebuilt based on examples that provably pass `riinac check`. |

## 5. Overclaims and Missed Evidence

- **Overclaim:** The entire concept of an `R3` rating for the `A_TYPE_THEORY` umbrella is an overclaim.
- **Missed Evidence:** The primary audit correctly identified most weaknesses but failed to connect them to a sufficient rating downgrade. The sheer scale of vacuity in the non-Coq lanes, revealed by the `grep` commands, justifies a harsher judgment on Gate G10 than the audit provided.

## 6. Recommended Release Engineering

- **Safe Claim:** "RIINA's compiler implements and tests a core type subsystem with formal proofs of type safety in Coq. This subsystem includes enforcement of effects, security labels, linearity, and basic session-type constructs. Advanced features like dependent or refinement types are formally modeled but not yet implemented."
- **Unsafe Claim:** "RIINA features a verified `R3` type theory foundation."
- **Release Condition:** Do not release. The domain is not `R3`.
- **Next Review Advice:**
    1.  Re-scope the audit to **`A_TYPE_THEORY_CORE`** and re-evaluate against the gates.
    2.  Create separate `R0` or `R1` audit stubs for the other research branches (e.g., `A_DEPENDENT_TYPES`, `A_REFINEMENT_TYPES`).
    3.  Create a dedicated remediation ticket to fix all failing files in `07_EXAMPLES`.
    4.  Create a dedicated remediation ticket to either remove or manually rewrite the generated non-Coq formal artifacts to provide real evidence.
    5.  The next review of this domain must not proceed until the scope is reduced and the examples are fixed.

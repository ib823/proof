# Syariah Compliance Domain R5 Review

## 1. Verdict
**accept with reductions**

## 2. Snapshot validation
- **Branch:** `main`
- **Commit:** `2005b8471995f6610bd9c841569154e3343ab247`
- **Review Valid:** Yes. The snapshot perfectly matches the pinned expectation.

## 3. Maximum honest rating
**R1** (Downgraded from R2)

The domain fails to meet the R2 requirement for a "nontrivial" theorem set because the formal model relies on boolean flag decomposition and definition unfolding. Furthermore, the claimed implementation fragments are merely type wrappers (`SyariahCompliant<T>`) or rudimentary division (`zakat`), violating toolchain enforcement minimums.

## 4. Gate review table

| Gate | Audit Score | Reviewer Score | Disposition | Evidence | Consequence |
|------|-------------|----------------|-------------|----------|-------------|
| G1 Canonical Identity | Partial | Partial | Agree | Authority split between research, Coq, and minor compiler fragments. | Caps rating below R5. |
| G2 Boundary Precision | Partial | Partial | Agree | Research scope outruns live implementation scope. | Caps rating below R5. |
| G3 Workflow Inventory | Partial | Partial | Agree | Broad research intent, but no implemented complete workflows. | Caps rating below R4. |
| G4 Threat/Failure Model | Partial | Fail | Downgrade | Threat models are purely conceptual; no state machine abuse or invalid sequencing modeled. | Hard cap below R4. |
| G5 Property Set | Partial | Partial | Agree | Many critical domain properties (screening, purification) missing entirely. | Caps rating below R4. |
| G6 Formal Model Depth | Partial | Fail | Downgrade | Audit admits proofs are "mostly boolean decomposition" and "definition unfolding". This violates the G6 requirement for a nontrivial theorem set. | Caps rating at R1. |
| G7 Toolchain Enforcement | Partial | Fail | Downgrade | `SyariahCompliant` is just a type wrapper tested in `riina-parser/src/tests.rs:1805`. `KwMudarabah`, etc., do not even exist in the typechecker source. | Invalidates R3 claim potential. |
| G8 Executable Evidence | Partial | Fail | Downgrade | `syariah_escrow.rii` is an untested conceptual example. R5 rules strictly state: "Fail if: Examples are untested." | Rejects any executable evidence claims. |
| G9 Adversarial Coverage | Partial | Fail | Downgrade | No tests exist proving a dangerous Syariah case is rejected; token/zakat tests are generic type mismatches. | Caps rating below R4. |
| G10 Evidence Honesty | Fail | Fail | Agree | SMT, Alloy, TLA+, F*, Kani, Verus lanes are demonstrably vacuous or auto-generated. | Fatal to R5. |
| G11 Observability | Partial | Partial | Agree | Traceability possible but manual. | Caps rating below R5. |
| G12 Freshness | Pass | Pass | Agree | Current commit is captured and metrics reproduce. | None. |
| G13 Public Claim | Fail | Fail | Agree | Audit correctly identified overclaims in research documents. | Fatal to R5. |
| G14 Regression Immunity| Fail | Fail | Agree | No domain-specific gates prevent drift. | Fatal to R5. |

## 5. Findings table

| Severity | Gate | Claim under dispute | Counter-evidence | Required downgrade or correction |
|----------|------|---------------------|------------------|----------------------------------|
| Critical | G6 | "Partial" score / "Enough for R2" | Coq proofs are boolean flag decomposition and definition unfolding, which is trivial. | Downgrade gate to Fail. Cap rating at R1. |
| High | G7 | "Partial" score | Missing parser keywords (`KwMudarabah`, etc. absent from Rust parsing/typechecking). `SyariahCompliant` is merely a type wrapper. | Downgrade gate to Fail. Explicitly note lack of semantic enforcement. |
| High | G8 | "Partial" score | Audit acknowledges `syariah_escrow.rii` is conceptual only and not run. The checklist dictates this is a Fail. | Downgrade gate to Fail. |
| High | G4 | "Partial" score | Threat models exist in text but are entirely missing from executable/formal state-machine abuse models. | Downgrade gate to Fail. |

## 6. Overclaim lines

- **Audit line:** "Current rating: R2"
- **Audit line:** "Enough for R2, not enough for stronger claims" (Regarding G6)
- **Audit line:** "The domain is not R3 because the live toolchain does not enforce the majority of claimed Syariah workflows or properties." (Implies it's close or solidly R2, but lacks nontrivial formal proofs or non-vacuous enforcement for R2).

## 7. Missed evidence lines

- The audit missed that keywords like `mudarabah`, `musharakah`, `sukuk`, `takaful`, `wakaf`, `tathir` are not only lacking semantics, but do not even exist as tokens in the parser/typechecker/codegen source (`grep` for `KwMudarabah` etc. returned 0 results).
- The audit missed that `SyariahCompliant` is explicitly tested as nothing more than a wrapper over a boolean in the parser tests (`assert_eq!(ty, Ty::SyariahCompliant(Box::new(Ty::Bool)));`), proving it has zero enforcement power.

## 8. Safe claim

The Syariah Compliance domain is currently a specified research topic (R1) with superficial formal definitions and no meaningful compile-time or runtime enforcement.

## 9. Unsafe claim

The domain is formally modeled (R2) with live compiler support for Islamic finance primitives.

## 10. Release condition

The domain rating cannot exceed R1 until the formal model implements actual state transitions rather than trivial boolean flags, and the toolchain demonstrates end-to-end, tested enforcement of at least one complete Islamic finance workflow (e.g., mudarabah or full zakat lifecycle with nisab/haul).

## 11. Next review advice

The auditor must revise the audit, downgrade the rating to R1, and mark G4, G6, G7, G8, and G9 as Fail. The current audit is too generous regarding the depth of the formal model and the existence of toolchain enforcement.

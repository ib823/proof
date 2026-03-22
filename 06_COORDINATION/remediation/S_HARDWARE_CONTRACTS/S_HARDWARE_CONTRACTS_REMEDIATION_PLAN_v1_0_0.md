# S_HARDWARE_CONTRACTS Remediation Plan v1.0.0

## Purpose

Replace the vacuous formal model with a meaningful hardware contract framework and add implementation-level enforcement to reach R2.

## Current Truth

As of [S_HARDWARE_CONTRACTS_R5_AUDIT.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/S_HARDWARE_CONTRACTS_R5_AUDIT.md) and [S_HARDWARE_CONTRACTS_R5_REVIEW.md](/workspaces/proof/06_COORDINATION/audit_outputs/domain_r5/S_HARDWARE_CONTRACTS_R5_REVIEW.md):
- `S_HARDWARE_CONTRACTS` is `R1` (downgraded from R2 by hostile review, R0 rejected as too harsh)
- Coq: `leakage ms ms' := []` renders all constant-time proofs vacuous
- riina-compliance contains zero hardware contract logic (only a string literal `hardware_input`)
- No typechecker enforcement for hardware contracts
- Research folder exists with domain-specific research documents
- Coq file compiles and has structural definitions (even if proofs are vacuous)
- Original audit overclaimed at R2 with "56% reflexivity, MIXED"

## Governing Rules

1. A leakage model defined as constant `[]` makes all proofs that depend on it trivially true.
2. A string literal mentioning hardware is not implementation evidence.
3. Research existence alone warrants R1 but nothing higher.
4. The "56% reflexivity" metric was misleading because the remaining proofs were also vacuous (just using `exact H` instead of `reflexivity`).

## Required Structural Changes

### 1. Rewrite the leakage model

`leakage ms ms' := []` must be replaced with a function that actually models observable timing or cache behavior. The model should distinguish between constant-time and variable-time operations.

### 2. Add implementation code paths

riina-compliance or riina-typechecker must contain actual hardware contract logic. At minimum: a check that functions annotated with a timing contract do not call variable-time operations.

### 3. Add domain-specific tests

Zero negative tests exist for hardware contracts. Add tests that verify contract violations are caught.

### 4. Correct public claims

The safe claim "partial formal modeling and shared compliance infrastructure" must be corrected. There is no shared compliance infrastructure for this domain.

## Per-Gate Remediation Steps

| Gate | Status | Remediation | Artifact | Exit Criterion |
|------|--------|-------------|----------|----------------|
| G6 | Fail | Rewrite leakage model | `S001_HardwareContracts.v` | `leakage` is nontrivial; proofs require reasoning about differences |
| G3 | Fail | Add implementation logic | `riina-compliance` or `riina-typechecker` | At least one hardware contract enforced at compile time |
| G9 | Fail | Add negative tests | Test modules | At least 3 negative tests for contract violations |
| G10 | Fail | Ensure proofs are non-vacuous | Proof body analysis | No proofs are trivially true due to constant leakage |
| G12 | Fail | Correct public claims | Audit and public wording | No claim implies R2-level evidence |

## Exit Criteria

`S_HARDWARE_CONTRACTS` may not claim R2 until:
- `leakage` is a nontrivial function that models real behavior
- At least one hardware contract property is enforced in the compiler
- At least 3 negative tests exist for contract violations
- Public claims are corrected to reflect R1 state
- Re-audit confirms all remediated gates pass

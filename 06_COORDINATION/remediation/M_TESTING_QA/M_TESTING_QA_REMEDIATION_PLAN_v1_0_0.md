# M_TESTING_QA — Remediation Plan v1.0.0

**Domain:** M_TESTING_QA
**Current Rating:** R3 | **Target:** R4
**Created:** 2026-03-21 | **Authority:** RIINA_MASTER_PLAN.md

---

## 1. Purpose

Remediate Domain M from R3 to R4. This is the highest-rated domain. The core gaps: the "500+ regulatory rules" claim is unverified, no mutation testing exists, and the Coq layer is lightweight helpers rather than formal compliance proofs. R4 requires verified claims, systematic testing methodology, and formal backing.

## 2. Current Truth (Verified)

| Asset | Status | Evidence |
|-------|--------|----------|
| Compliance validator | Real | 17,752 lines |
| Compliance validator tests | Real | 1,087 tests |
| Total Rust tests | Real | 2,476 tests |
| Pre-commit hooks | Real | Enforce test gates |
| "500+ regulatory rules" claim | Unverified | Actual count not confirmed by grep |
| Mutation testing | Not implemented | No cargo-mutants or equivalent |
| Coq compliance proofs | Lightweight | Helper lemmas, not compliance rule correctness |
| Workflow inventory | Not documented | No systematic list of CI-equivalent workflows |

## 3. Governing Rules

- Claims about counts ("500+ rules") must be verified by actual grep/count commands
- R4 requires mutation testing to demonstrate test suite quality
- R4 requires at least some formal proofs about compliance rule correctness
- Workflow inventory is needed to demonstrate systematic QA process

## 4. Required Structural Changes

### 4.1 Claim Verification
Run actual counts:
- `grep -c "rule\|Rule" riina-compliance/src/**/*.rs` or equivalent
- Document the real number. If less than 500, correct all references.

### 4.2 Mutation Testing
Integrate `cargo-mutants` or equivalent:
- Run on at least riina-compliance and riina-typechecker
- Establish baseline mutation score
- Identify undertested code paths

### 4.3 Formal Compliance Proofs
Write Coq proofs that compliance rules are correct:
- At minimum: prove that a subset of rules (e.g., SQL injection prevention rules) correctly classify known-bad inputs
- This bridges the gap between "tests pass" (R3) and "rules are formally correct" (R4)

### 4.4 Workflow Inventory
Document all CI-equivalent workflows:
- Pre-commit hooks (what they check)
- Pre-push hooks (what they check)
- Manual verification steps
- `riinac verify` scope

## 5. Per-Gate Remediation

### Gate R3 (Current — verified hold)
- Comprehensive test suite: confirmed (2,476 tests)
- Pre-commit enforcement: confirmed
- Claims: unverified

### Gate R4 (Target)
Requires ALL of:
1. "500+ rules" claim verified or corrected
2. Mutation testing baseline established (target: >70% mutation score for critical crates)
3. At least 5 formal compliance rule correctness proofs in Coq
4. Workflow inventory document
5. Test coverage metrics for compliance validator

### Gate R5 (Future)
- Full formal compliance framework
- Mutation score >90% for all crates
- Property-based testing integration
- Formal proof that test suite is complete relative to specification

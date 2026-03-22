# Remediation Package: M_TESTING_QA

- Domain ID: `M_TESTING_QA`
- Current: `R3` | Target: `R4`
- Hostile review: accept with corrections at R3

## Why R3
Real compliance validator (17,752 lines, 1,087 tests). Pre-commit hooks enforce test gates. 2,476 total Rust tests. Coq layer is lightweight helpers.

## To R4
1. Verify and correct "500+ regulatory rules" claim with actual count
2. Add mutation testing
3. Formalize compliance rule correctness in Coq
4. Write workflow inventory

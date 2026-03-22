# M_TESTING_QA — Remediation Worklist v1.0.0

**Current:** R3 | **Target:** R4
**Created:** 2026-03-21

---

## R3 → R4 Tasks

### Critical (Blocks R4)

- [ ] **M-R4-01:** Verify "500+ regulatory rules" claim — Count actual rules in riina-compliance source. Methods:
  - Count unique rule identifiers (e.g., `RuleId`, rule enum variants)
  - Count regulatory check functions
  - If actual count < 500, update all documentation to reflect true count
- [ ] **M-R4-02:** Mutation testing setup — Install and configure `cargo-mutants`. Run on:
  - riina-compliance (primary)
  - riina-typechecker (secondary)
  - Record baseline mutation score
- [ ] **M-R4-03:** Mutation testing baseline — Achieve >70% mutation kill rate for riina-compliance. Identify and fix undertested paths.

### High Priority

- [ ] **M-R4-04:** Formal compliance proofs — Write 5+ Coq proofs that compliance rules are correct. Candidates:
  - SQL injection rule correctly rejects known-bad patterns
  - XSS prevention rule correctly classifies tainted/untainted
  - Buffer size rule correctly bounds allocations
  - Integer overflow rule correctly flags unchecked arithmetic
  - Path traversal rule correctly rejects `../` patterns
- [ ] **M-R4-05:** Workflow inventory — Document all CI-equivalent workflows:
  - Pre-commit: what hooks run, what they check
  - Pre-push: what hooks run, what they check
  - Manual: `riinac verify` scope and invocation
  - Test pyramid: unit / integration / property-based / formal

### Medium Priority

- [ ] **M-R4-06:** Test coverage metrics — Run `cargo tarpaulin` or equivalent on riina-compliance, record line/branch coverage
- [ ] **M-R4-07:** Property-based testing — Add `proptest` or `quickcheck` for at least 3 compliance rules
- [ ] **M-R4-08:** Test categorization — Tag all 1,087 compliance tests by category (injection, overflow, memory, format, etc.)

---

## R4 → R5 Tasks (Future)

- [ ] **M-R5-01:** Full compliance formalization — Every regulatory rule has a corresponding Coq proof
- [ ] **M-R5-02:** Mutation score >90% — All crates achieve high mutation kill rate
- [ ] **M-R5-03:** Test completeness proof — Formal argument that test suite covers all specification requirements
- [ ] **M-R5-04:** Regression oracle — Automated detection of untested specification changes
- [ ] **M-R5-05:** Continuous property testing — Property-based tests run on every commit

---

## Verification Commands

```bash
# Count regulatory rules (adjust grep pattern to actual rule format)
grep -rn "RuleId\|fn check_\|fn validate_" 03_PROTO/riina-compliance/src/ | wc -l

# Run compliance tests
cargo test -p riina-compliance 2>&1 | grep "test result"

# Run all tests
cargo test --all --manifest-path 03_PROTO/Cargo.toml 2>&1 | grep "test result"

# Mutation testing (after setup)
cargo mutants -p riina-compliance -- --test-threads=1 2>&1 | tail -20
```

# U_RUNTIME_GUARDIAN Remediation Worklist

## Status Key
- [ ] Not started
- [x] Complete

## Immediate (audit cleanup)
- [ ] Remove riina-runtime tests from U-domain evidence in audit
- [ ] Add generated-lane disclaimer to audit for non-Coq U001 files
- [ ] Rewrite safe claim: "research materials and shallow Coq concept sketch"
- [ ] Update DOMAIN_COVERAGE_MATRIX.md to reflect R1

## Phase 2 (formal model repair)
- [ ] Replace `complete_mediation` with real policy-checking predicate
- [ ] Replace `tamper_evident` with real state-change detection model
- [ ] Replace `variants_independent` with real isolation property
- [ ] Reprove core theorems over non-vacuous definitions
- [ ] Map research theorem sketches to active Coq proof bodies
- [ ] Verify 0 Admitted / 0 Axiom after changes

## Phase 3 (implementation)
- [ ] Create riina-hypervisor crate skeleton
- [ ] Implement at least one guardian workflow (e.g., CFI check)
- [ ] Add positive .rii example for guardian-protected execution
- [ ] Add negative .rii example for rejected unauthorized access
- [ ] Add adversarial tests (tamper, invalid sequencing, watchdog)
- [ ] Wire guardian into live toolchain codegen path

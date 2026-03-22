# TOTAL_STACK Remediation Worklist

## Immediate (audit cleanup)
- [ ] Rewrite audit to R1 rating
- [ ] Remove "aggregates from other domains" justification
- [ ] Add canonical scope/assumptions/not-in-scope blocks
- [ ] Reconcile DOMAIN_COVERAGE_MATRIX.md ~90% claim with reality
- [ ] Add generated-lane disclaimers for non-Coq files
- [ ] Update DOMAIN_COVERAGE_MATRIX.md to reflect R1

## Phase 2 (formal model)
- [ ] Replace `interface_secure` vacuous True definition
- [ ] Replace `exact Hprop` preservation theorems with real proofs
- [ ] Make `total_stack_security` use `Hintf` premise
- [ ] Replace `attack_blocked` fixed-enum model with real adversary
- [ ] Add workflow inventory (valid/invalid cross-layer scenarios)
- [ ] Add threat/failure model with real adversary capabilities
- [ ] Verify 0 Admitted / 0 Axiom after changes

## Phase 3 (implementation)
- [ ] Define TOTAL_STACK toolchain surface
- [ ] Add positive cross-layer workflow example
- [ ] Add negative cross-layer workflow (rejected)
- [ ] Add regression tests for cross-layer properties
- [ ] Track progress toward 5,050+ theorem research target

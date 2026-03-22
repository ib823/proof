# SIGMA_VERIFIED_STORAGE Remediation Worklist

## Immediate (audit cleanup)
- [ ] Rewrite audit to R1 rating
- [ ] Remove riina-receipt as Sigma implementation evidence
- [ ] Add canonical Sigma spec to 04_SPECS
- [ ] Add generated-lane disclaimers for non-Coq files
- [ ] Retire OLD_RESEARCH_SIGMA01_FOUNDATION.md
- [ ] Update DOMAIN_COVERAGE_MATRIX.md to reflect R1

## Phase 2 (formal model)
- [ ] Replace `query_contains_raw_string := False` with real check
- [ ] Replace identity `apply_op` with real state transition
- [ ] Replace hardcoded `audit_chain_valid` with real validation
- [ ] Replace hardcoded `query_well_typed` with real typing
- [ ] Replace hardcoded `pred_well_typed` with real typing
- [ ] Replace hardcoded isolation predicates with real logic
- [ ] Add transaction semantics (begin, commit, rollback)
- [ ] Reprove storage properties over non-vacuous definitions

## Phase 3 (implementation)
- [ ] Create Sigma-specific crate or module
- [ ] Add query validation in parser/typechecker
- [ ] Add transaction enforcement in runtime
- [ ] Add positive .rii storage workflow example
- [ ] Add negative .rii example (invalid query rejected)
- [ ] Add adversarial test: dirty read scenario
- [ ] Add adversarial test: phantom read scenario
- [ ] Add adversarial test: recovery abuse scenario

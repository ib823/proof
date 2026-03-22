# SIGMA_VERIFIED_STORAGE Remediation Plan

## Phase 1: Foundation Repair (R1 stabilization)
1. Add canonical Sigma spec to 04_SPECS with scope/assumptions/exclusions
2. Remove riina-receipt as Sigma implementation evidence
3. Rewrite audit as R1 assessment
4. Add generated-lane disclaimers for non-Coq SIGMA001 files
5. Retire or demote OLD_RESEARCH_SIGMA01_FOUNDATION.md

## Phase 2: Formal Model (R1 -> R2)
1. Replace `query_contains_raw_string := False` with real SQL injection check
2. Replace identity `apply_op` with real database state transition
3. Replace hardcoded `audit_chain_valid` with real chain validation
4. Replace hardcoded typing/isolation predicates with real logic
5. Reprove storage properties over non-vacuous definitions
6. Add real transaction semantics (begin, commit, rollback)

## Phase 3: Implementation (R2 -> R3)
1. Create Sigma-specific crate or extend existing crate
2. Implement query validation in parser/typechecker
3. Implement transaction enforcement in runtime
4. Add positive example: valid query/transaction workflow
5. Add negative example: rejected invalid query/FK violation
6. Add adversarial tests: dirty reads, phantom reads, recovery abuse

## Dependencies
- JALINAN content hashing is adjacent but separate evidence

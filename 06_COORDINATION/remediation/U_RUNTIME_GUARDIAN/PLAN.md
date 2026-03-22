# U_RUNTIME_GUARDIAN Remediation Plan

## Phase 1: Foundation Repair (R1 stabilization)
1. Reconcile competing domain identities (Runtime Guardian vs RIINA-SENTINEL vs micro-hypervisor)
2. Write canonical assumptions/not-in-scope block
3. Add generated-lane disclaimers to all non-Coq U001 files
4. Update repo scope docs to reflect actual state

## Phase 2: Formal Model (R1 -> R2)
1. Replace vacuous predicates in U001_RuntimeGuardian.v:
   - `complete_mediation`: must actually check operation against policy
   - `tamper_evident`: must model detection of unauthorized state changes
   - `variants_independent`: must model real isolation property
2. Prove nontrivial properties over these real definitions
3. Map research theorem sketches to active Coq theorems with honest correspondence

## Phase 3: Implementation (R2 -> R3)
1. Create `riina-hypervisor` crate with guardian workflows
2. Add parser/typechecker support for guardian annotations
3. Create positive example: valid guardian-protected execution
4. Create negative example: rejected unauthorized access attempt
5. Add regression tests for guardian-specific rejection behavior

## Dependencies
- None (U is independent of other active remediation tracks)

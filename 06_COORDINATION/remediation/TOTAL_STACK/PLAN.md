# TOTAL_STACK Remediation Plan

## Phase 1: Foundation Repair (R1 stabilization)
1. Rewrite audit as R1 assessment
2. Remove "aggregates from other domains" justification
3. Add canonical scope/assumptions/not-in-scope blocks
4. Reconcile repo metadata (~90% coverage claim) with reality
5. Add generated-lane disclaimers for non-Coq files

## Phase 2: Formal Model (R1 -> R2)
1. Replace `interface_secure ... -> True` with meaningful property
2. Replace `exact Hprop` preservation theorems with real proofs
3. Make `total_stack_security` actually use `Hintf` premise
4. Replace `attack_blocked` existsb-over-fixed-defenders with real model
5. Add workflow inventory: valid/invalid cross-layer scenarios
6. Add threat/failure model with real adversary

## Phase 3: Implementation (R2 -> R3)
1. Define TOTAL_STACK toolchain surface (cross-layer integration checks)
2. Create at least one executable cross-layer workflow
3. Create at least one rejected invalid cross-layer scenario
4. Add regression tests tied to cross-layer properties
5. Work toward research completion criteria (5,050+ theorems is long-term)

## Dependencies
- Depends on maturity of constituent domains (A through Sigma)
- Cross-cutting: cannot promote until sub-domains are honest

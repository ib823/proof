# V_TERMINATION_GUARANTEES Remediation Package

## Reconciliation Summary
- **Original audit rating**: R2
- **Hostile review rating**: R2 (ceiling, under narrower claim; reject audit as written)
- **Reconciled rating**: R2 (keep; narrow claim; remove R3 speculation)
- **Review date**: 2026-03-22

## Root Cause
The audit cited wrong-layer evidence (WCETBounds.v/WCETTypes.v instead of canonical
V001_TerminationGuarantees.v), speculated about R3 without verification, and missed
critical issues in the strongest theorem and the live toolchain.

## Critical Defects
1. `well_typed_SN` and `SN_app` export with 3 unresolved premises
2. `check_termination` in V001 always returns `true` (vacuous checker)
3. Live parser/spec contradict documented bounded-or-Sistem loop policy
4. No termination enforcement in typechecker at all
5. Public examples and training data overclaim Bersih termination
6. Non-Coq lanes are generated/derived

## Promotion Path: R2 -> R3
- Close the 3 unresolved premises in ReducibilityFull.v
- Implement bounded-or-Sistem loop policy in parser/typechecker
- Add negative tests for rejected recursion, `had:` bounds, `kesan Sistem` restriction
- Fix or remove stale public examples that overclaim termination

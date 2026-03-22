# Z_DECLASSIFICATION_POLICY Remediation Package

## Reconciliation Summary
- **Original audit rating**: R2 (with R3 speculation)
- **Hostile review rating**: R2 (ceiling, narrow claim; reject audit as written)
- **Reconciled rating**: R2 (keep; remove R3 speculation; narrow claim scope)
- **Review date**: 2026-03-22

## Root Cause
The audit blurred generic `declass_ok` support with declassification policy enforcement.
The live toolchain only enforces the narrow syntactic witness, not the policy dimensions
(principals, guards, budgets, audit logs, DP) that Track Z is supposed to cover.

## Critical Defects
1. `acts_for` is vacuous (equality or `exists authority > 0`, always satisfiable)
2. `Step_Declass` is a state no-op in operational semantics
3. Live toolchain only enforces `declass_ok` same-value proof checking
4. No principal, guard, budget, logging, or DP enforcement in runtime/codegen
5. Shipped domain example `declassify.rii` fails to parse at pinned snapshot
6. Docs claim proof-string audit logging that code does not implement
7. QuantitativeDeclassification.v was missed by original audit

## Promotion Path: R2 -> R3
- Bind at least one policy workflow end-to-end (principal + guard + budget + receipt)
- Fix stale example to supported syntax
- Add adversarial tests for authorization bypass, budget exhaustion

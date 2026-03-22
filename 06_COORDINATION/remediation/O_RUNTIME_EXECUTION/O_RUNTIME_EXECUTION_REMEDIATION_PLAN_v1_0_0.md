# O_RUNTIME_EXECUTION Remediation Plan v1.0.0

## Current Truth
- R2: 542 real tests, 304 vacuous Coq theorems
- All domain Coq files use boolean-stub pattern
- Hostile review overrated at R4 (didn't check proof bodies)

## Required Changes
1. Rewrite Coq with operational semantics models (stepping, store mutation, effect tracking)
2. Prove semantic preservation: lowering preserves type safety
3. Add adversarial runtime tests
4. Write explicit threat model for runtime boundaries

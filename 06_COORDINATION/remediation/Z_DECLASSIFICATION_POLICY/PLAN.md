# Z_DECLASSIFICATION_POLICY Remediation Plan

## Phase 1: Audit Repair (immediate)
1. Remove all R3 speculation from audit
2. Include QuantitativeDeclassification.v in evidence review
3. Narrow safe claim to: "basic IFC declassification primitive with narrow structural witness"
4. Write canonical scope/assumptions/not-in-scope block for Track Z
5. Add generated-lane disclaimers for non-Coq Z001 files

## Phase 2: Formal Model Strengthening
1. Replace vacuous `acts_for` with real authority/delegation model
2. Replace no-op `Step_Declass` with real state-changing semantics
3. Strengthen authorization theorems beyond `exists 1`
4. Prove non-interference preservation over real declassification steps
5. Connect QuantitativeDeclassification.v concepts to main model

## Phase 3: Toolchain Enforcement (R2 -> R3)
1. Add principal-based authorization to declassification path
2. Add guard condition checking to declassification
3. Add budget consumption tracking for declassification events
4. Add observable audit receipt for declassification decisions
5. Fix 07_EXAMPLES/01_security/declassify.rii to supported syntax
6. Fix 07_EXAMPLES/06_ai_context/COMMON_MISTAKES.md stale claims
7. Add adversarial tests: auth bypass, budget exhaustion, guard manipulation

## Dependencies
- Coordinate with C_INFORMATION_FLOW_CONTROL for shared declass_ok path

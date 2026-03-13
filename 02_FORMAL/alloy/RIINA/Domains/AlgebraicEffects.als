// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for algebraic effects
// Bounded verification of key properties
module riina/Domains/AlgebraicEffects

abstract sig SecurityLevel {}
one sig Low extends SecurityLevel {}
one sig Medium extends SecurityLevel {}
one sig High extends SecurityLevel {}

sig Component {
  secLevel: one SecurityLevel,
  verified: one Int,
  integrity: one Int
}

sig Operation {
  component: one Component,
  permitted: one Int,
  audited: one Int
}

// Only verified components allow operations
fact VerifiedRequired {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}

// High security requires audit
fact HighSecAudited {
  all op: Operation |
    (op.component.secLevel = High and op.permitted = 1) implies op.audited = 1
}

// Integrity required for permission
fact IntegrityRequired {
  all op: Operation | op.permitted = 1 implies op.component.integrity = 1
}

assert effectOp_eqb_eq {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check effectOp_eqb_eq for 6

assert effectOp_eqb_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check effectOp_eqb_refl for 6

assert in_row_In {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check in_row_In for 6

assert row_subset_incl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check row_subset_incl for 6

assert row_minus_spec {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check row_minus_spec for 6

assert EFF_001_01_effect_signature_wellformedness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check EFF_001_01_effect_signature_wellformedness for 6

assert EFF_001_02_operation_typing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check EFF_001_02_operation_typing for 6

assert EFF_001_03_handler_typing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check EFF_001_03_handler_typing for 6

assert EFF_001_04_effect_row_combination {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check EFF_001_04_effect_row_combination for 6

assert EFF_001_05_effect_subsumption {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check EFF_001_05_effect_subsumption for 6

assert EFF_001_06_pure_computation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check EFF_001_06_pure_computation for 6

assert compose_handlers_effects {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compose_handlers_effects for 6

assert EFF_001_07_handler_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check EFF_001_07_handler_composition for 6

assert EFF_001_08_effect_polymorphism {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check EFF_001_08_effect_polymorphism for 6

assert EFF_001_09_deep_handler_semantics {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check EFF_001_09_deep_handler_semantics for 6

assert EFF_001_10_shallow_handler_semantics {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check EFF_001_10_shallow_handler_semantics for 6

assert EFF_001_11_effect_masking {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check EFF_001_11_effect_masking for 6

assert EFF_001_12_resumption_linearity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check EFF_001_12_resumption_linearity for 6

assert EFF_001_13_effect_safety {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check EFF_001_13_effect_safety for 6

assert EFF_001_14_effect_parametricity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check EFF_001_14_effect_parametricity for 6

assert eval_pure_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check eval_pure_deterministic for 6

assert EFF_001_15_effect_coherence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check EFF_001_15_effect_coherence for 6

pred ExampleAlgebraicEffects {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleAlgebraicEffects for 6

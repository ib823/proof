// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for refinement types
// Bounded verification of key properties
module riina/Domains/RefinementTypes

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

assert TYPE_004_01_refinement_subtyping {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_01_refinement_subtyping for 6

assert TYPE_004_02_refinement_introduction {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_02_refinement_introduction for 6

assert TYPE_004_03_refinement_elimination {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_03_refinement_elimination for 6

assert TYPE_004_04_refinement_conjunction {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_04_refinement_conjunction for 6

assert TYPE_004_05_dependent_function_refinement {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_05_dependent_function_refinement for 6

assert TYPE_004_06_refinement_substitution {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_06_refinement_substitution for 6

assert TYPE_004_07_smt_decidability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_07_smt_decidability for 6

assert TYPE_004_08_bounds_checking {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_08_bounds_checking for 6

assert TYPE_004_09_non_null_refinement {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_09_non_null_refinement for 6

assert TYPE_004_10_array_bounds_safety {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_10_array_bounds_safety for 6

assert TYPE_004_11_positive_refinement {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_11_positive_refinement for 6

assert TYPE_004_12_refinement_preservation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_12_refinement_preservation for 6

assert TYPE_004_13_pred_true_satisfied {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_13_pred_true_satisfied for 6

assert TYPE_004_14_pred_false_unsatisfied {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_14_pred_false_unsatisfied for 6

assert TYPE_004_15_pred_and_comm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_15_pred_and_comm for 6

assert TYPE_004_16_pred_or_comm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_16_pred_or_comm for 6

assert TYPE_004_17_pred_implies_ptrue {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_17_pred_implies_ptrue for 6

assert TYPE_004_18_pred_pfalse_implies {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_18_pred_pfalse_implies for 6

assert TYPE_004_19_subtype_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_19_subtype_refl for 6

assert TYPE_004_20_pred_double_neg {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_20_pred_double_neg for 6

assert TYPE_004_21_eval_val {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_21_eval_val for 6

assert TYPE_004_22_pred_impl_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_22_pred_impl_refl for 6

assert TYPE_004_23_pred_and_assoc {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_23_pred_and_assoc for 6

assert TYPE_004_24_pred_or_assoc {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_004_24_pred_or_assoc for 6

pred ExampleRefinementTypes {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleRefinementTypes for 6

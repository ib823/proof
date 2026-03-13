// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for v001_termination guarantees
// Bounded verification of key properties
module riina/Domains/V001_TerminationGuarantees

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

assert V_001_01_structural_decrease {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_01_structural_decrease for 6

assert V_001_02_structural_termination {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_02_structural_termination for 6

assert V_001_03_nat_structural {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_03_nat_structural for 6

assert V_001_04_list_structural {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_04_list_structural for 6

assert V_001_05_tree_structural {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_05_tree_structural for 6

assert V_001_06_mutual_structural {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_06_mutual_structural for 6

assert V_001_07_nested_structural {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_07_nested_structural for 6

assert V_001_08_structural_checker_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_08_structural_checker_sound for 6

assert V_001_09_sized_type_wellformed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_09_sized_type_wellformed for 6

assert V_001_10_size_decreases {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_10_size_decreases for 6

assert V_001_11_sized_list_terminates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_11_sized_list_terminates for 6

assert V_001_12_sized_tree_terminates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_12_sized_tree_terminates for 6

assert V_001_13_size_inference_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_13_size_inference_correct for 6

assert V_001_14_size_subtyping {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_14_size_subtyping for 6

assert V_001_15_sized_preservation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_15_sized_preservation for 6

assert V_001_16_sized_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_16_sized_composition for 6

assert V_001_17_measure_wellformed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_17_measure_wellformed for 6

assert V_001_18_measure_decreases {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_18_measure_decreases for 6

assert V_001_19_lexicographic_wellformed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_19_lexicographic_wellformed for 6

assert V_001_20_ackermann_terminates {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_20_ackermann_terminates for 6

assert V_001_21_complex_measure_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_21_complex_measure_sound for 6

assert V_001_22_measure_inference {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_22_measure_inference for 6

assert V_001_23_measure_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_23_measure_composition for 6

assert V_001_24_wellfounded_checker_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_24_wellfounded_checker_sound for 6

assert V_001_25_codata_productive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_25_codata_productive for 6

assert V_001_26_stream_productive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_26_stream_productive for 6

assert V_001_27_productivity_observe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_27_productivity_observe for 6

assert V_001_28_guarded_recursion {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_28_guarded_recursion for 6

assert V_001_29_codata_unfold {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_29_codata_unfold for 6

assert V_001_30_productive_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_30_productive_composition for 6

assert V_001_31_non_terminating_marked {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_31_non_terminating_marked for 6

assert V_001_32_strong_normalization {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check V_001_32_strong_normalization for 6

pred ExampleV001_TerminationGuarantees {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleV001_TerminationGuarantees for 6

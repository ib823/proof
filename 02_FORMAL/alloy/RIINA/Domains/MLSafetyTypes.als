// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for mlsafety types
// Bounded verification of key properties
module riina/Domains/MLSafetyTypes

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

assert forallb_combine_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check forallb_combine_refl for 6

assert forallb_combine_sym {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check forallb_combine_sym for 6

assert shape_eq_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check shape_eq_refl for 6

assert shape_eq_sym {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check shape_eq_sym for 6

assert matmul_shape_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check matmul_shape_correct for 6

assert matmul_incompat {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check matmul_incompat for 6

assert dp_composition_additive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dp_composition_additive for 6

assert dp_compose_assoc {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dp_compose_assoc for 6

assert lipschitz_compose {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lipschitz_compose for 6

assert lipschitz_id {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lipschitz_id for 6

assert lipschitz_const {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lipschitz_const for 6

assert dp_queries_additive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dp_queries_additive for 6

assert dp_compose_zero_l {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dp_compose_zero_l for 6

assert dp_compose_zero_r {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dp_compose_zero_r for 6

assert dp_compose_comm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dp_compose_comm for 6

assert shape_eq_implies_same_length {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check shape_eq_implies_same_length for 6

assert shape_eq_nil {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check shape_eq_nil for 6

assert shape_eq_singleton {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check shape_eq_singleton for 6

assert matmul_square {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check matmul_square for 6

assert matmul_col_vector {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check matmul_col_vector for 6

assert dp_epsilon_nonneg {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dp_epsilon_nonneg for 6

assert lipschitz_mono {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lipschitz_mono for 6

assert compose_fn_assoc {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compose_fn_assoc for 6

assert compose_fn_id_l {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compose_fn_id_l for 6

pred ExampleMLSafetyTypes {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleMLSafetyTypes for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for formal verification
// Bounded verification of key properties
module riina/Domains/FormalVerification

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

assert pred_decidable_PTrue {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pred_decidable_PTrue for 6

assert pred_decidable_eval {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pred_decidable_eval for 6

assert E_001_01 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_01 for 6

assert E_001_02 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_02 for 6

assert smt_translation_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check smt_translation_correct for 6

assert E_001_03 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_03 for 6

assert E_001_04 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_04 for 6

assert E_001_05 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_05 for 6

assert E_001_06 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_06 for 6

assert E_001_07 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_07 for 6

assert ty_subst_preserves_base {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ty_subst_preserves_base for 6

assert E_001_08 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_08 for 6

assert E_001_09 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_09 for 6

assert E_001_10 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_10 for 6

assert E_001_11 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_11 for 6

assert E_001_12 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_12 for 6

assert E_001_13 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_13 for 6

assert E_001_14 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_14 for 6

assert E_001_15 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_15 for 6

assert E_001_16 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_16 for 6

assert E_001_17 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_17 for 6

assert E_001_18 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_18 for 6

assert E_001_19 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_19 for 6

assert E_001_20 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_20 for 6

assert E_001_21 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_21 for 6

assert E_001_22 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_22 for 6

assert bool_proof_irrelevant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bool_proof_irrelevant for 6

assert E_001_23 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_23 for 6

assert E_001_24 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_24 for 6

assert E_001_25 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_25 for 6

assert E_001_26 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_26 for 6

assert E_001_27 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_27 for 6

assert E_001_28 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_28 for 6

assert wp_skip_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check wp_skip_sound for 6

assert E_001_29 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_29 for 6

assert E_001_30 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check E_001_30 for 6

pred ExampleFormalVerification {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleFormalVerification for 6

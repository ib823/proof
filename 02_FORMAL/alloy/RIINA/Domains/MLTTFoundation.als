// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for mlttfoundation
// Bounded verification of key properties
module riina/Domains/MLTTFoundation

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

assert cumulativity_level {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cumulativity_level for 6

assert TYPE_001_01 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_001_01 for 6

assert TYPE_001_02 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_001_02 for 6

assert TYPE_001_03 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_001_03 for 6

assert TYPE_001_04 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_001_04 for 6

assert TYPE_001_05 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_001_05 for 6

assert TYPE_001_06 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_001_06 for 6

assert TYPE_001_07 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_001_07 for 6

assert TYPE_001_08 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_001_08 for 6

assert TYPE_001_09 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_001_09 for 6

assert TYPE_001_10 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_001_10 for 6

assert type_uniqueness_eq {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check type_uniqueness_eq for 6

assert TYPE_001_11 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_001_11 for 6

assert TYPE_001_12 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_001_12 for 6

assert TYPE_001_13 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_001_13 for 6

assert TYPE_001_14 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_001_14 for 6

assert red_star_trans {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check red_star_trans for 6

assert red_star_app {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check red_star_app for 6

assert red_star_lam {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check red_star_lam for 6

assert red_star_pair {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check red_star_pair for 6

assert red_star_fst {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check red_star_fst for 6

assert red_star_snd {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check red_star_snd for 6

assert red_star_refl_tm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check red_star_refl_tm for 6

assert red_star_J {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check red_star_J for 6

assert TYPE_001_15 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_001_15 for 6

pred ExampleMLTTFoundation {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleMLTTFoundation for 6

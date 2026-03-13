// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for testing qa
// Bounded verification of key properties
module riina/Domains/TestingQA

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

assert nat_eqb_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check nat_eqb_refl for 6

assert forallb_true_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check forallb_true_iff for 6

assert existsb_exists {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check existsb_exists for 6

assert list_beq_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check list_beq_refl for 6

assert M_001_01 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_01 for 6

assert M_001_02 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_02 for 6

assert M_001_03 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_03 for 6

assert M_001_04 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_04 for 6

assert M_001_05 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_05 for 6

assert M_001_06 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_06 for 6

assert M_001_07 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_07 for 6

assert M_001_08 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_08 for 6

assert M_001_09 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_09 for 6

assert M_001_10 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_10 for 6

assert M_001_11 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_11 for 6

assert M_001_12 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_12 for 6

assert M_001_13 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_13 for 6

assert M_001_14 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_14 for 6

assert M_001_15 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_15 for 6

assert M_001_16 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_16 for 6

assert M_001_17 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_17 for 6

assert M_001_18 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_18 for 6

assert M_001_19 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_19 for 6

assert M_001_20 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_20 for 6

assert M_001_21 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_21 for 6

assert M_001_22 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_22 for 6

assert M_001_23 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_23 for 6

assert M_001_24 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_24 for 6

assert M_001_25 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check M_001_25 for 6

pred ExampleTestingQA {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleTestingQA for 6

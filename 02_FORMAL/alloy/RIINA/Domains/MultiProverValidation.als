// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for multi prover validation
// Bounded verification of key properties
module riina/Domains/MultiProverValidation

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

assert formula_eqb_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check formula_eqb_refl for 6

assert formula_eqb_eq {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check formula_eqb_eq for 6

assert 1 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 1 for 6

assert 2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 2 for 6

assert 3 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 3 for 6

assert 4 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 4 for 6

assert 5 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 5 for 6

assert 6 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 6 for 6

assert 7 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 7 for 6

assert 8 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 8 for 6

assert 9 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 9 for 6

assert 10 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 10 for 6

assert 11 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 11 for 6

assert 12 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 12 for 6

assert 13 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 13 for 6

assert 14 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 14 for 6

assert 15 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 15 for 6

assert 16 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 16 for 6

assert 17 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 17 for 6

assert 18 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 18 for 6

assert 19 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 19 for 6

assert 20 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 20 for 6

assert 21 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 21 for 6

assert 22 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 22 for 6

pred ExampleMultiProverValidation {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleMultiProverValidation for 6

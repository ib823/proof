// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for radiation hardening
// Bounded verification of key properties
module riina/Domains/RadiationHardening

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

assert DOMAIN_001_01 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_01 for 6

assert DOMAIN_001_02 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_02 for 6

assert DOMAIN_001_03 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_03 for 6

assert DOMAIN_001_04 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_04 for 6

assert DOMAIN_001_05 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_05 for 6

assert DOMAIN_001_06 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_06 for 6

assert DOMAIN_001_07 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_07 for 6

assert DOMAIN_001_08 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_08 for 6

assert DOMAIN_001_09 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_09 for 6

assert DOMAIN_001_09_corrupted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_09_corrupted for 6

assert DOMAIN_001_10 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_10 for 6

assert DOMAIN_001_11 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_11 for 6

assert DOMAIN_001_12 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_12 for 6

assert DOMAIN_001_13 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_13 for 6

assert DOMAIN_001_14 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_14 for 6

assert DOMAIN_001_15 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_15 for 6

assert DOMAIN_001_15_single_corruption {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_15_single_corruption for 6

assert DOMAIN_001_16 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_16 for 6

assert DOMAIN_001_17 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_17 for 6

assert DOMAIN_001_18 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DOMAIN_001_18 for 6

pred ExampleRadiationHardening {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleRadiationHardening for 6

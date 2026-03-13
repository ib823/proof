// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for standard library
// Bounded verification of key properties
module riina/Domains/StandardLibrary

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

assert P_001_01 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_01 for 6

assert P_001_02 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_02 for 6

assert P_001_03 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_03 for 6

assert rev_app_single {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check rev_app_single for 6

assert P_001_04 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_04 for 6

assert P_001_05 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_05 for 6

assert P_001_06 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_06 for 6

assert P_001_07 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_07 for 6

assert P_001_08 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_08 for 6

assert P_001_09 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_09 for 6

assert P_001_10 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_10 for 6

assert P_001_11 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_11 for 6

assert P_001_12 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_12 for 6

assert P_001_13 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_13 for 6

assert P_001_14 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_14 for 6

assert P_001_15 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_15 for 6

assert P_001_16 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_16 for 6

assert P_001_17 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_17 for 6

assert P_001_18 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_18 for 6

assert P_001_19 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_19 for 6

assert P_001_20 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_20 for 6

assert P_001_21 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_21 for 6

assert P_001_22 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_22 for 6

assert P_001_23 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_23 for 6

assert P_001_24 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_24 for 6

assert P_001_25 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_25 for 6

assert P_001_26 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_26 for 6

assert P_001_27 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_27 for 6

assert P_001_28 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_28 for 6

assert P_001_29 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_29 for 6

assert P_001_30 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_30 for 6

assert P_001_31 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_31 for 6

assert P_001_32 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_32 for 6

assert P_001_33 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_33 for 6

assert P_001_34 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_34 for 6

assert P_001_35 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_35 for 6

assert P_001_36 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_36 for 6

assert P_001_37 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_37 for 6

assert level_leq_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check level_leq_refl for 6

assert compartments_subset_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compartments_subset_refl for 6

assert P_001_38 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_38 for 6

assert level_leq_trans {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check level_leq_trans for 6

assert compartments_subset_trans {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compartments_subset_trans for 6

assert P_001_39 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_39 for 6

assert P_001_40 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check P_001_40 for 6

pred ExampleStandardLibrary {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleStandardLibrary for 6

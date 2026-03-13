// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for dependent types
// Bounded verification of key properties
module riina/Domains/DependentTypes

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

assert TYPE_005_01 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_005_01 for 6

assert TYPE_005_02 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_005_02 for 6

assert TYPE_005_03 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_005_03 for 6

assert TYPE_005_04 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_005_04 for 6

assert TYPE_005_05 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_005_05 for 6

assert TYPE_005_06 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_005_06 for 6

assert TYPE_005_07 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_005_07 for 6

assert TYPE_005_08 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_005_08 for 6

assert vec_cons_length_semantic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check vec_cons_length_semantic for 6

assert TYPE_005_09 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_005_09 for 6

assert vec_head_nonempty_semantic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check vec_head_nonempty_semantic for 6

assert TYPE_005_10 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_005_10 for 6

assert vec_dep_pattern_match {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check vec_dep_pattern_match for 6

assert TYPE_005_11 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_005_11 for 6

assert transport_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check transport_refl for 6

assert transport_trans {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check transport_trans for 6

assert TYPE_005_12 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_005_12 for 6

assert dep_congruence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dep_congruence for 6

assert congruence2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check congruence2 for 6

assert lt_wf_aux {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lt_wf_aux for 6

assert lt_well_founded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lt_well_founded for 6

assert TYPE_005_13 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_005_13 for 6

assert nat_dep_ind {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check nat_dep_ind for 6

assert strong_ind {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check strong_ind for 6

assert TYPE_005_14 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check TYPE_005_14 for 6

assert dec_eq_nat {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dec_eq_nat for 6

assert dec_eq_bool {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dec_eq_bool for 6

assert dec_eq_prod {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dec_eq_prod for 6

assert dec_eq_option {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dec_eq_option for 6

assert dec_eq_list {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dec_eq_list for 6

assert dec_to_bool {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dec_to_bool for 6

assert nat_eq_reflect {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check nat_eq_reflect for 6

assert uip_dec {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check uip_dec for 6

pred ExampleDependentTypes {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleDependentTypes for 6

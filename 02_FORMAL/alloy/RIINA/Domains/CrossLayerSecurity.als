// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for cross layer security
// Bounded verification of key properties
module riina/Domains/CrossLayerSecurity

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

assert label_eqb_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check label_eqb_refl for 6

assert label_leb_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check label_leb_refl for 6

assert label_leb_trans {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check label_leb_trans for 6

assert label_join_low_r {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check label_join_low_r for 6

assert label_join_comm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check label_join_comm for 6

assert 1 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 1 for 6

assert source_noninterference {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check source_noninterference for 6

assert 2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 2 for 6

assert 3 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 3 for 6

assert target_noninterference {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check target_noninterference for 6

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

assert label_lattice_join_least {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check label_lattice_join_least for 6

assert label_eqb_refl2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check label_eqb_refl2 for 6

assert label_join_comm2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check label_join_comm2 for 6

assert label_join_idem2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check label_join_idem2 for 6

pred ExampleCrossLayerSecurity {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleCrossLayerSecurity for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for speculative execution
// Bounded verification of key properties
module riina/Domains/SpeculativeExecution

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

assert eff_join_pure_l {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check eff_join_pure_l for 6

assert eff_join_pure_r {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check eff_join_pure_r for 6

assert eff_le_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check eff_le_refl for 6

assert eff_le_trans {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check eff_le_trans for 6

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

assert spec_safe_no_secret_branch_aux {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check spec_safe_no_secret_branch_aux for 6

assert spec_safe_implies_no_secret_leakage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check spec_safe_implies_no_secret_leakage for 6

assert 4 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 4 for 6

assert effect_preorder_trans {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check effect_preorder_trans for 6

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

assert binop_preserves_ct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check binop_preserves_ct for 6

assert pure_implies_spec_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pure_implies_spec_safe for 6

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

pred ExampleSpeculativeExecution {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleSpeculativeExecution for 6

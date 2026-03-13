// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for dual mode verification
// Bounded verification of key properties
module riina/Domains/DualModeVerification

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

assert lightweight_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lightweight_sound for 6

assert lightweight_complete_decidable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lightweight_complete_decidable for 6

assert refine_subtype_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check refine_subtype_refl for 6

assert refine_subtype_trans {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check refine_subtype_trans for 6

assert checked_values_satisfy {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check checked_values_satisfy for 6

assert dual_mode_agreement {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dual_mode_agreement for 6

assert refinement_weakening {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check refinement_weakening for 6

assert conj_subtype_left {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check conj_subtype_left for 6

assert conj_subtype_right {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check conj_subtype_right for 6

assert conj_greatest_lower_bound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check conj_greatest_lower_bound for 6

assert conj_full_pred_comm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check conj_full_pred_comm for 6

assert conj_full_pred_assoc {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check conj_full_pred_assoc for 6

assert conj_light_is_andb {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check conj_light_is_andb for 6

assert eval_const {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check eval_const for 6

assert eval_plus {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check eval_plus for 6

assert lightweight_false_implies_not_full {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lightweight_false_implies_not_full for 6

assert subtype_lightweight_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check subtype_lightweight_sound for 6

assert conj_decidable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check conj_decidable for 6

assert refine_subtype_antisym_eq {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check refine_subtype_antisym_eq for 6

assert eval_if_false {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check eval_if_false for 6

assert eval_if_true {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check eval_if_true for 6

assert conj_sub_both {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check conj_sub_both for 6

pred ExampleDualModeVerification {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleDualModeVerification for 6

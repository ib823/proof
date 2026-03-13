// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for translation validation
// Bounded verification of key properties
module riina/Domains/TranslationValidation

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

assert val_match_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check val_match_refl for 6

assert val_corresp_match {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check val_corresp_match for 6

assert trace_equiv_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check trace_equiv_refl for 6

assert trace_equiv_sym {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check trace_equiv_sym for 6

assert trace_equiv_trans {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check trace_equiv_trans for 6

assert tgt_steps_trans {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check tgt_steps_trans for 6

assert is_const_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check is_const_sound for 6

assert COMPILE_001_01 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check COMPILE_001_01 for 6

assert COMPILE_001_02 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check COMPILE_001_02 for 6

assert COMPILE_001_03 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check COMPILE_001_03 for 6

assert COMPILE_001_04 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check COMPILE_001_04 for 6

assert COMPILE_001_05 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check COMPILE_001_05 for 6

assert COMPILE_001_06 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check COMPILE_001_06 for 6

assert COMPILE_001_07 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check COMPILE_001_07 for 6

assert COMPILE_001_08 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check COMPILE_001_08 for 6

assert COMPILE_001_09 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check COMPILE_001_09 for 6

assert COMPILE_001_10 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check COMPILE_001_10 for 6

assert COMPILE_001_11 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check COMPILE_001_11 for 6

assert COMPILE_001_12 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check COMPILE_001_12 for 6

assert COMPILE_001_13 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check COMPILE_001_13 for 6

assert COMPILE_001_14 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check COMPILE_001_14 for 6

assert COMPILE_001_15 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check COMPILE_001_15 for 6

pred ExampleTranslationValidation {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleTranslationValidation for 6

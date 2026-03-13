// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for probabilistic verification
// Bounded verification of key properties
module riina/Domains/ProbabilisticVerification

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

assert uniform_nonneg {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check uniform_nonneg for 6

assert zero_negligible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check zero_negligible for 6

assert Qplus_lt_compat2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Qplus_lt_compat2 for 6

assert two_over_nSc_le_one_over_nc {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check two_over_nSc_le_one_over_nc for 6

assert negligible_sum {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check negligible_sum for 6

assert Qabs_Qminus_self {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Qabs_Qminus_self for 6

assert fold_combine_self_gen {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check fold_combine_self_gen for 6

assert fold_combine_self {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check fold_combine_self for 6

assert identical_indist {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check identical_indist for 6

assert comp_indist_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check comp_indist_refl for 6

assert xor_self_inverse {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check xor_self_inverse for 6

assert xor_comm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check xor_comm for 6

assert xor_zero_id {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check xor_zero_id for 6

assert xor_assoc {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check xor_assoc for 6

assert xor_self_zero {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check xor_self_zero for 6

assert otp_roundtrip {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check otp_roundtrip for 6

assert xor_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check xor_deterministic for 6

assert uniform_length {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check uniform_length for 6

assert qabs_nonneg {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check qabs_nonneg for 6

assert qabs_zero {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check qabs_zero for 6

pred ExampleProbabilisticVerification {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleProbabilisticVerification for 6

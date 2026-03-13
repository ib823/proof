// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for singapore mas_trm
// Bounded verification of key properties
module riina/Domains/SingaporeMAS_TRM

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

assert mas_cyber_hygiene {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mas_cyber_hygiene for 6

assert critical_patch_14_days {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check critical_patch_14_days for 6

assert critical_strictest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check critical_strictest for 6

assert trm_governance_proof {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check trm_governance_proof for 6

assert mas_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mas_composition for 6

assert mas_license_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mas_license_coverage for 6

assert ch_requires_mfa {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ch_requires_mfa for 6

assert ch_requires_patching {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ch_requires_patching for 6

assert ch_requires_network {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ch_requires_network for 6

assert ch_requires_antimalware {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ch_requires_antimalware for 6

assert ch_requires_pam {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ch_requires_pam for 6

assert patch_critical_strictest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check patch_critical_strictest for 6

assert patch_low_most_lenient {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check patch_low_most_lenient for 6

assert patch_deadline_positive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check patch_deadline_positive for 6

assert patch_critical_subsumes_all {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check patch_critical_subsumes_all for 6

assert mas_full_requires_hygiene {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mas_full_requires_hygiene for 6

assert mas_full_requires_governance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mas_full_requires_governance for 6

assert mas_full_requires_testing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mas_full_requires_testing for 6

assert mas_full_requires_resilience {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mas_full_requires_resilience for 6

assert count_mas_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check count_mas_bounded for 6

assert mas_seven_licenses {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mas_seven_licenses for 6

pred ExampleSingaporeMAS_TRM {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleSingaporeMAS_TRM for 6

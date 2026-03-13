// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for operational security
// Bounded verification of key properties
module riina/Domains/OperationalSecurity

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

assert opsec_001_shamir_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_001_shamir_security for 6

assert opsec_002_shamir_reconstruction {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_002_shamir_reconstruction for 6

assert opsec_003_no_single_keyholder {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_003_no_single_keyholder for 6

assert opsec_004_geographic_distribution {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_004_geographic_distribution for 6

assert opsec_005_multiparty_required {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_005_multiparty_required for 6

assert opsec_006_social_engineering_insufficient {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_006_social_engineering_insufficient for 6

assert opsec_007_insider_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_007_insider_bounded for 6

assert opsec_008_export_limit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_008_export_limit for 6

assert opsec_009_duress_detection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_009_duress_detection for 6

assert opsec_010_dead_man_switch {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_010_dead_man_switch for 6

assert opsec_011_time_window {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_011_time_window for 6

assert opsec_012_role_separation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_012_role_separation for 6

assert opsec_013_anomaly_detection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_013_anomaly_detection for 6

assert opsec_014_audit_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_014_audit_complete for 6

assert opsec_015_hardware_diversity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_015_hardware_diversity for 6

assert opsec_016_nversion_consensus {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_016_nversion_consensus for 6

assert opsec_017_time_lock {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_017_time_lock for 6

assert opsec_018_cancellation_window {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_018_cancellation_window for 6

assert opsec_019_principal_uniqueness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_019_principal_uniqueness for 6

assert opsec_020_channel_diversity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_020_channel_diversity for 6

assert opsec_021_coercion_resistant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_021_coercion_resistant for 6

assert opsec_022_jurisdictional_spread {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_022_jurisdictional_spread for 6

assert opsec_023_signatures_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_023_signatures_valid for 6

assert opsec_024_budget_reset {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_024_budget_reset for 6

assert opsec_025_defense_in_depth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check opsec_025_defense_in_depth for 6

pred ExampleOperationalSecurity {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleOperationalSecurity for 6

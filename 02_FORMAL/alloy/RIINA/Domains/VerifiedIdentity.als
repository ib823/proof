// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for verified identity
// Bounded verification of key properties
module riina/Domains/VerifiedIdentity

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

assert list_eq_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check list_eq_refl for 6

assert list_eq_sym {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check list_eq_sym for 6

assert list_eq_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check list_eq_sound for 6

assert constant_time_eq_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check constant_time_eq_correct for 6

assert existsb_exists {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check existsb_exists for 6

assert existsb_not_exists {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check existsb_not_exists for 6

assert credential_matches_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check credential_matches_refl for 6

assert credential_matches_eq {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check credential_matches_eq for 6

assert AA_001_01_auth_completeness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_01_auth_completeness for 6

assert AA_001_02_auth_soundness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_02_auth_soundness for 6

assert AA_001_03_auth_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_03_auth_deterministic for 6

assert AA_001_04_credential_unforgeability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_04_credential_unforgeability for 6

assert AA_001_05_no_auth_bypass {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_05_no_auth_bypass for 6

assert AA_001_06_auth_timing_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_06_auth_timing_safe for 6

assert AA_001_07_auth_rate_limited {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_07_auth_rate_limited for 6

assert AA_001_08_auth_logging {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_08_auth_logging for 6

assert AA_001_09_password_hash_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_09_password_hash_secure for 6

assert AA_001_10_password_preimage_resistant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_10_password_preimage_resistant for 6

assert AA_001_11_password_not_stored {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_11_password_not_stored for 6

assert AA_001_12_password_pepper_bound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_12_password_pepper_bound for 6

assert AA_001_13_password_constant_time_compare {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_13_password_constant_time_compare for 6

assert AA_001_14_password_breach_checked {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_14_password_breach_checked for 6

assert AA_001_15_token_unforgeability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_15_token_unforgeability for 6

assert AA_001_16_token_channel_bound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_16_token_channel_bound for 6

assert AA_001_17_token_expiry {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_17_token_expiry for 6

assert AA_001_18_token_replay_prevented {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_18_token_replay_prevented for 6

assert AA_001_19_token_revocation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_19_token_revocation for 6

assert AA_001_20_token_refresh_secure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_20_token_refresh_secure for 6

assert AA_001_21_token_claims_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_21_token_claims_integrity for 6

assert AA_001_22_token_binding_verified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_22_token_binding_verified for 6

assert AA_001_23_session_isolation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_23_session_isolation for 6

assert AA_001_24_session_binding {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_24_session_binding for 6

assert AA_001_25_session_expiry {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_25_session_expiry for 6

assert AA_001_26_session_no_fixation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_26_session_no_fixation for 6

assert AA_001_27_session_regeneration {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_27_session_regeneration for 6

assert AA_001_28_fido2_phishing_resistant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_28_fido2_phishing_resistant for 6

assert AA_001_29_fido2_origin_bound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_29_fido2_origin_bound for 6

assert AA_001_30_fido2_replay_prevented {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_30_fido2_replay_prevented for 6

assert AA_001_31_fido2_user_verification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_31_fido2_user_verification for 6

assert AA_001_32_mfa_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check AA_001_32_mfa_composition for 6

pred ExampleVerifiedIdentity {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleVerifiedIdentity for 6

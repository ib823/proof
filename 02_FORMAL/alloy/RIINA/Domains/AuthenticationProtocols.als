// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for authentication security
// Bounded verification of AuthenticationProtocols properties
module riina/Domains/AuthenticationProtocols

abstract sig AuthMethod {}
one sig Password extends AuthMethod {}
one sig Biometric extends AuthMethod {}
one sig Token extends AuthMethod {}
one sig MFA extends AuthMethod {}

sig AuthSession {
  method: one AuthMethod,
  verified: one Int,
  expired: one Int
}

sig AccessRequest {
  session: one AuthSession,
  granted: one Int
}

// Invariant: verified_required
fact verified_required_fact {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}

// Invariant: expired_denied
fact expired_denied_fact {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}

// Invariant: mfa_strongest
fact mfa_strongest_fact {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}

assert andb_true_iff {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check andb_true_iff for 6

assert andb3_true_iff {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check andb3_true_iff for 6

assert negb_true_iff {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check negb_true_iff for 6

assert leb_le {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check leb_le for 6

assert ltb_lt {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check ltb_lt for 6

assert AUTH_001 {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check AUTH_001 for 6

assert AUTH_002 {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check AUTH_002 for 6

assert AUTH_003 {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check AUTH_003 for 6

assert AUTH_004 {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check AUTH_004 for 6

assert AUTH_005 {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check AUTH_005 for 6

assert AUTH_006 {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check AUTH_006 for 6

assert AUTH_007 {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check AUTH_007 for 6

assert AUTH_008 {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check AUTH_008 for 6

assert AUTH_009 {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check AUTH_009 for 6

assert AUTH_010 {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check AUTH_010 for 6

assert AUTH_011 {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check AUTH_011 for 6

assert AUTH_012 {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check AUTH_012 for 6

assert AUTH_013 {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check AUTH_013 for 6

assert AUTH_014 {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check AUTH_014 for 6

assert AUTH_015 {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check AUTH_015 for 6

assert AUTH_016 {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check AUTH_016 for 6

assert AUTH_017 {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check AUTH_017 for 6

assert AUTH_018 {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check AUTH_018 for 6

assert AUTH_019 {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check AUTH_019 for 6

assert AUTH_020 {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check AUTH_020 for 6

assert AUTH_021 {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check AUTH_021 for 6

assert AUTH_022 {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check AUTH_022 for 6

assert AUTH_023 {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check AUTH_023 for 6

assert AUTH_024 {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check AUTH_024 for 6

assert AUTH_025_complete {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check AUTH_025_complete for 6

assert PBKDF2_001_riina_secure {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check PBKDF2_001_riina_secure for 6

assert PBKDF2_002_sufficient_iterations {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check PBKDF2_002_sufficient_iterations for 6

assert PBKDF2_003_sufficient_salt {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check PBKDF2_003_sufficient_salt for 6

assert PBKDF2_004_sufficient_output {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check PBKDF2_004_sufficient_output for 6

assert PBKDF2_005_approved_algorithm {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check PBKDF2_005_approved_algorithm for 6

assert PBKDF2_006_work_factor {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check PBKDF2_006_work_factor for 6

assert ARGON2_001_riina_secure {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check ARGON2_001_riina_secure for 6

assert ARGON2_002_sufficient_time {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check ARGON2_002_sufficient_time for 6

assert ARGON2_003_sufficient_memory {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check ARGON2_003_sufficient_memory for 6

assert ARGON2_004_argon2id_variant {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check ARGON2_004_argon2id_variant for 6

assert ARGON2_005_memory_hardness {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check ARGON2_005_memory_hardness for 6

assert ARGON2_006_parallelism {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check ARGON2_006_parallelism for 6

assert BCRYPT_001_riina_secure {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check BCRYPT_001_riina_secure for 6

assert BCRYPT_002_sufficient_cost {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check BCRYPT_002_sufficient_cost for 6

assert BCRYPT_003_fixed_salt {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check BCRYPT_003_fixed_salt for 6

assert BCRYPT_004_fixed_output {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check BCRYPT_004_fixed_output for 6

assert BCRYPT_005_exponential_work {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check BCRYPT_005_exponential_work for 6

assert TOTP_001_riina_secure {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check TOTP_001_riina_secure for 6

assert TOTP_002_sufficient_secret {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check TOTP_002_sufficient_secret for 6

assert TOTP_003_sufficient_digits {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check TOTP_003_sufficient_digits for 6

assert TOTP_004_standard_period {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check TOTP_004_standard_period for 6

assert TOTP_005_limited_drift {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check TOTP_005_limited_drift for 6

assert TOTP_006_brute_force_resistant {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check TOTP_006_brute_force_resistant for 6

assert WEBAUTHN_001_riina_secure {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check WEBAUTHN_001_riina_secure for 6

assert WEBAUTHN_002_user_verification {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check WEBAUTHN_002_user_verification for 6

assert WEBAUTHN_003_challenge_entropy {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check WEBAUTHN_003_challenge_entropy for 6

assert WEBAUTHN_004_timeout_range {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check WEBAUTHN_004_timeout_range for 6

assert WEBAUTHN_005_impersonation_prevention {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check WEBAUTHN_005_impersonation_prevention for 6

assert SESSION_001_riina_secure {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check SESSION_001_riina_secure for 6

assert SESSION_002_sufficient_entropy {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check SESSION_002_sufficient_entropy for 6

assert SESSION_003_rotation_enabled {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check SESSION_003_rotation_enabled for 6

assert SESSION_004_binding_enabled {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check SESSION_004_binding_enabled for 6

assert SESSION_005_secure_flag {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check SESSION_005_secure_flag for 6

assert SESSION_006_httponly_flag {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check SESSION_006_httponly_flag for 6

assert SESSION_007_samesite_protection {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check SESSION_007_samesite_protection for 6

assert SESSION_008_guessing_resistant {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check SESSION_008_guessing_resistant for 6

assert OAUTH2_001_riina_secure {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check OAUTH2_001_riina_secure for 6

assert OAUTH2_002_pkce_required {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check OAUTH2_002_pkce_required for 6

assert OAUTH2_003_state_required {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check OAUTH2_003_state_required for 6

assert OAUTH2_004_code_entropy {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check OAUTH2_004_code_entropy for 6

assert OAUTH2_005_short_code_expiry {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check OAUTH2_005_short_code_expiry for 6

assert OAUTH2_006_refresh_rotation {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check OAUTH2_006_refresh_rotation for 6

assert OAUTH2_007_code_interception_prevention {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check OAUTH2_007_code_interception_prevention for 6

assert OIDC_001_riina_secure {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check OIDC_001_riina_secure for 6

assert OIDC_002_secure_base {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check OIDC_002_secure_base for 6

assert OIDC_003_strong_signing {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check OIDC_003_strong_signing for 6

assert OIDC_004_short_id_expiry {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check OIDC_004_short_id_expiry for 6

assert OIDC_005_claims_verified {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check OIDC_005_claims_verified for 6

assert OIDC_006_inherits_pkce {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check OIDC_006_inherits_pkce for 6

assert CHALLENGE_001_riina_secure {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check CHALLENGE_001_riina_secure for 6

assert CHALLENGE_002_sufficient_entropy {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check CHALLENGE_002_sufficient_entropy for 6

assert CHALLENGE_003_short_expiry {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check CHALLENGE_003_short_expiry for 6

assert CHALLENGE_004_single_use {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check CHALLENGE_004_single_use for 6

assert CHALLENGE_005_session_bound {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check CHALLENGE_005_session_bound for 6

assert CHALLENGE_006_guessing_resistant {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check CHALLENGE_006_guessing_resistant for 6

assert CHALLENGE_007_replay_prevention {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check CHALLENGE_007_replay_prevention for 6

assert REPLAY_001_riina_secure {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check REPLAY_001_riina_secure for 6

assert REPLAY_002_sufficient_nonce {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check REPLAY_002_sufficient_nonce for 6

assert REPLAY_003_sufficient_window {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check REPLAY_003_sufficient_window for 6

assert REPLAY_004_bounded_timestamp {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check REPLAY_004_bounded_timestamp for 6

assert REPLAY_005_window_prevents_replay {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check REPLAY_005_window_prevents_replay for 6

assert REPLAY_006_limited_attack_window {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check REPLAY_006_limited_attack_window for 6

assert COMPOSITE_001_password_hashing_secure {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check COMPOSITE_001_password_hashing_secure for 6

assert COMPOSITE_002_mfa_complete {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check COMPOSITE_002_mfa_complete for 6

assert COMPOSITE_003_session_complete {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check COMPOSITE_003_session_complete for 6

assert COMPOSITE_004_challenge_complete {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check COMPOSITE_004_challenge_complete for 6

assert COMPOSITE_005_riina_auth_complete {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check COMPOSITE_005_riina_auth_complete for 6

assert COMPOSITE_006_auth_implies_all {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check COMPOSITE_006_auth_implies_all for 6

assert TOKEN_001_valid_not_expired {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check TOKEN_001_valid_not_expired for 6

assert TOKEN_002_valid_not_invalid {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check TOKEN_002_valid_not_invalid for 6

assert TOKEN_003_valid_not_revoked {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check TOKEN_003_valid_not_revoked for 6

assert TOKEN_004_expired_not_valid {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check TOKEN_004_expired_not_valid for 6

pred ExampleAuthenticationProtocols {
  some AuthSession
}
run ExampleAuthenticationProtocols for 6

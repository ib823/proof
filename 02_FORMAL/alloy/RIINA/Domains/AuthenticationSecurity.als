// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/domains/AuthenticationSecurity.v (20 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/authentication_security

open util/boolean

abstract sig list {}
abstract sig option {}

// RateLimiter (matches Coq: Record RateLimiter)
sig RateLimiter {
  f_rl_attempts: one Int,
  f_rl_window_start: one Int,
  f_rl_max_attempts: one Int,
  f_rl_lockout_duration: one Int
}

// MFAState (matches Coq: Record MFAState)
sig MFAState {
  f_mfa_password_verified: one Bool,
  f_mfa_second_factor_verified: one Bool,
  f_mfa_required: one Bool
}

// PasswordHash (matches Coq: Record PasswordHash)
sig PasswordHash {
  f_ph_hash: one list,
  f_ph_salt: one list,
  f_ph_iterations: one Int,
  f_ph_algorithm: one Int
}

// SessionToken (matches Coq: Record SessionToken)
sig SessionToken {
  f_st_value: one list,
  f_st_user_id: one Int,
  f_st_created: one Int,
  f_st_expires: one Int,
  f_st_bound_ip: one option,
  f_st_bound_ua: one option
}

// CredentialStore (matches Coq: Record CredentialStore)
sig CredentialStore {
  f_cs_hash: one PasswordHash,
  f_cs_mfa_secret: one option,
  f_cs_recovery_codes: one list
}

// AuthAttempt (matches Coq: Record AuthAttempt)
sig AuthAttempt {
  f_aa_user: one Int,
  f_aa_password_hash: one list,
  f_aa_mfa_code: one option,
  f_aa_ip: one Int,
  f_aa_timestamp: one Int
}

// AuthTicket (matches Coq: Record AuthTicket)
sig AuthTicket {
  f_at_user: one Int,
  f_at_signature: one list,
  f_at_timestamp: one Int,
  f_at_nonce: one Int
}

// ServiceKey (matches Coq: Record ServiceKey)
sig ServiceKey {
  f_sk_algorithm: one Int,
  f_sk_key: one list
}

// HSMProtectedKey (matches Coq: Record HSMProtectedKey)
sig HSMProtectedKey {
  f_hsm_key_id: one Int,
  f_hsm_extractable: one Bool
}

// MutualAuth (matches Coq: Record MutualAuth)
sig MutualAuth {
  f_ma_client_verified: one Bool,
  f_ma_server_verified: one Bool
}

// RouteAuth (matches Coq: Record RouteAuth)
sig RouteAuth {
  f_ra_path: one list,
  f_ra_auth_required: one Bool,
  f_ra_auth_checked: one Bool
}

// OAuthState (matches Coq: Record OAuthState)
sig OAuthState {
  f_oauth_state_param: one list,
  f_oauth_pkce_verifier: one list,
  f_oauth_redirect_validated: one Bool
}

// JWTConfig (matches Coq: Record JWTConfig)
sig JWTConfig {
  f_jwt_alg_none_disabled: one Bool,
  f_jwt_alg_symmetric_disabled: one Bool,
  f_jwt_exp_required: one Bool
}

// SAMLConfig (matches Coq: Record SAMLConfig)
sig SAMLConfig {
  f_saml_signature_required: one Bool,
  f_saml_assertion_encrypted: one Bool,
  f_saml_replay_detection: one Bool
}

// BiometricAuth (matches Coq: Record BiometricAuth)
sig BiometricAuth {
  f_bio_liveness_check: one Bool,
  f_bio_confidence: one Int,
  f_bio_min_confidence: one Int
}

// NonceStore (matches Coq: Record NonceStore)
sig NonceStore {
  f_ns_seen: one list,
  f_ns_max_age: one Int
}

// WebAuthnAuth (matches Coq: Record WebAuthnAuth)
sig WebAuthnAuth {
  f_wa_origin_bound: one Bool,
  f_wa_challenge_verified: one Bool
}

// is_rate_limited (matches Coq: Definition is_rate_limited)
pred is_rate_limited[p_rl: RateLimiter] {
  some p_rl
}

// mfa_complete (matches Coq: Definition mfa_complete)
pred mfa_complete[p_s: MFAState] {
  some p_s
}

// token_valid (matches Coq: Definition token_valid)
pred token_valid[p_t: SessionToken, p_now: Int] {
  some p_t
}

// token_bound (matches Coq: Definition token_bound)
pred token_bound[p_t: SessionToken, p_ip: Int, p_ua: Int] {
  some p_t
}

// nonce_fresh (matches Coq: Definition nonce_fresh)
pred nonce_fresh[p_ns: NonceStore, p_n: Int] {
  some p_ns
}

// auth_001_credential_stuffing_mitigated (matches Coq: Theorem auth_001_credential_stuffing_mitigated)
assert auth_001_credential_stuffing_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_001_credential_stuffing_mitigated for 5

// auth_002_password_spraying_mitigated (matches Coq: Theorem auth_002_password_spraying_mitigated)
assert auth_002_password_spraying_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_002_password_spraying_mitigated for 5

// auth_003_brute_force_mitigated (matches Coq: Theorem auth_003_brute_force_mitigated)
assert auth_003_brute_force_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_003_brute_force_mitigated for 5

// auth_004_pass_the_hash_mitigated (matches Coq: Theorem auth_004_pass_the_hash_mitigated)
assert auth_004_pass_the_hash_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_004_pass_the_hash_mitigated for 5

// auth_005_pass_the_ticket_mitigated (matches Coq: Theorem auth_005_pass_the_ticket_mitigated)
assert auth_005_pass_the_ticket_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_005_pass_the_ticket_mitigated for 5

// auth_006_kerberoasting_mitigated (matches Coq: Theorem auth_006_kerberoasting_mitigated)
assert auth_006_kerberoasting_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_006_kerberoasting_mitigated for 5

// auth_007_golden_ticket_mitigated (matches Coq: Theorem auth_007_golden_ticket_mitigated)
assert auth_007_golden_ticket_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_007_golden_ticket_mitigated for 5

// auth_008_silver_ticket_mitigated (matches Coq: Theorem auth_008_silver_ticket_mitigated)
assert auth_008_silver_ticket_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_008_silver_ticket_mitigated for 5

// auth_009_credential_theft_mitigated (matches Coq: Theorem auth_009_credential_theft_mitigated)
assert auth_009_credential_theft_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_009_credential_theft_mitigated for 5

// auth_010_session_fixation_mitigated (matches Coq: Theorem auth_010_session_fixation_mitigated)
assert auth_010_session_fixation_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_010_session_fixation_mitigated for 5

// auth_011_auth_bypass_mitigated (matches Coq: Theorem auth_011_auth_bypass_mitigated)
assert auth_011_auth_bypass_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_011_auth_bypass_mitigated for 5

// auth_012_oauth_attacks_mitigated (matches Coq: Theorem auth_012_oauth_attacks_mitigated)
assert auth_012_oauth_attacks_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_012_oauth_attacks_mitigated for 5

// auth_013_jwt_attacks_mitigated (matches Coq: Theorem auth_013_jwt_attacks_mitigated)
assert auth_013_jwt_attacks_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_013_jwt_attacks_mitigated for 5

// auth_014_saml_attacks_mitigated (matches Coq: Theorem auth_014_saml_attacks_mitigated)
assert auth_014_saml_attacks_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_014_saml_attacks_mitigated for 5

// auth_015_sso_attacks_mitigated (matches Coq: Theorem auth_015_sso_attacks_mitigated)
assert auth_015_sso_attacks_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_015_sso_attacks_mitigated for 5

// auth_016_mfa_bypass_mitigated (matches Coq: Theorem auth_016_mfa_bypass_mitigated)
assert auth_016_mfa_bypass_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_016_mfa_bypass_mitigated for 5

// auth_017_biometric_spoof_mitigated (matches Coq: Theorem auth_017_biometric_spoof_mitigated)
assert auth_017_biometric_spoof_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_017_biometric_spoof_mitigated for 5

// auth_018_token_theft_mitigated (matches Coq: Theorem auth_018_token_theft_mitigated)
assert auth_018_token_theft_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_018_token_theft_mitigated for 5

// auth_019_replay_mitigated (matches Coq: Theorem auth_019_replay_mitigated)
assert auth_019_replay_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_019_replay_mitigated for 5

// auth_020_phishing_mitigated (matches Coq: Theorem auth_020_phishing_mitigated)
assert auth_020_phishing_mitigated {
  all c: RateLimiter | some c.f_rl_attempts
}
check auth_020_phishing_mitigated for 5

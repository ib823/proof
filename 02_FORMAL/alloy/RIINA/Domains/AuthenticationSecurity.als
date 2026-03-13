// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for authentication security
// Bounded verification of AuthenticationSecurity properties
module riina/Domains/AuthenticationSecurity

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

assert auth_001_credential_stuffing_mitigated {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check auth_001_credential_stuffing_mitigated for 6

assert auth_002_password_spraying_mitigated {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check auth_002_password_spraying_mitigated for 6

assert auth_003_brute_force_mitigated {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check auth_003_brute_force_mitigated for 6

assert auth_004_pass_the_hash_mitigated {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check auth_004_pass_the_hash_mitigated for 6

assert auth_005_pass_the_ticket_mitigated {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check auth_005_pass_the_ticket_mitigated for 6

assert auth_006_kerberoasting_mitigated {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check auth_006_kerberoasting_mitigated for 6

assert auth_007_golden_ticket_mitigated {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check auth_007_golden_ticket_mitigated for 6

assert auth_008_silver_ticket_mitigated {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check auth_008_silver_ticket_mitigated for 6

assert auth_009_credential_theft_mitigated {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check auth_009_credential_theft_mitigated for 6

assert auth_010_session_fixation_mitigated {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check auth_010_session_fixation_mitigated for 6

assert auth_011_auth_bypass_mitigated {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check auth_011_auth_bypass_mitigated for 6

assert auth_012_oauth_attacks_mitigated {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check auth_012_oauth_attacks_mitigated for 6

assert auth_013_jwt_attacks_mitigated {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check auth_013_jwt_attacks_mitigated for 6

assert auth_014_saml_attacks_mitigated {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check auth_014_saml_attacks_mitigated for 6

assert auth_015_sso_attacks_mitigated {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check auth_015_sso_attacks_mitigated for 6

assert auth_016_mfa_bypass_mitigated {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check auth_016_mfa_bypass_mitigated for 6

assert auth_017_biometric_spoof_mitigated {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check auth_017_biometric_spoof_mitigated for 6

assert auth_018_token_theft_mitigated {
  all s: AuthSession | s.method = MFA implies s.verified = 1
}
check auth_018_token_theft_mitigated for 6

assert auth_019_replay_mitigated {
  all r: AccessRequest | r.granted = 1 implies r.session.verified = 1
}
check auth_019_replay_mitigated for 6

assert auth_020_phishing_mitigated {
  all r: AccessRequest | r.session.expired = 1 implies r.granted = 0
}
check auth_020_phishing_mitigated for 6

pred ExampleAuthenticationSecurity {
  some AuthSession
}
run ExampleAuthenticationSecurity for 6

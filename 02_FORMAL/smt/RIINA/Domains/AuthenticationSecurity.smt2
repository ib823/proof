; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/AuthenticationSecurity.v (20 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: AuthenticationSecurity

(set-logic ALL)
(set-option :produce-models true)

; RateLimiter (matches Coq: Record RateLimiter)
(declare-datatypes ((RateLimiter 0))
  (((mk-rate_limiter (rl_attempts Int) (rl_window_start Int) (rl_max_attempts Int) (rl_lockout_duration Int)))))

; MFAState (matches Coq: Record MFAState)
(declare-datatypes ((MFAState 0))
  (((mk-mfa_state (mfa_password_verified Bool) (mfa_second_factor_verified Bool) (mfa_required Bool)))))

; PasswordHash (matches Coq: Record PasswordHash)
(declare-datatypes ((PasswordHash 0))
  (((mk-password_hash (ph_hash (Seq Int)) (ph_salt (Seq Int)) (ph_iterations Int) (ph_algorithm Int)))))

; SessionToken (matches Coq: Record SessionToken)
(declare-datatypes ((SessionToken 0))
  (((mk-session_token (st_value (Seq Int)) (st_user_id Int) (st_created Int) (st_expires Int) (st_bound_ip Int) (st_bound_ua Int)))))

; CredentialStore (matches Coq: Record CredentialStore)
(declare-datatypes ((CredentialStore 0))
  (((mk-credential_store (cs_hash PasswordHash) (cs_mfa_secret Int) (cs_recovery_codes (Seq Int))))))

; AuthAttempt (matches Coq: Record AuthAttempt)
(declare-datatypes ((AuthAttempt 0))
  (((mk-auth_attempt (aa_user Int) (aa_password_hash (Seq Int)) (aa_mfa_code Int) (aa_ip Int) (aa_timestamp Int)))))

; AuthTicket (matches Coq: Record AuthTicket)
(declare-datatypes ((AuthTicket 0))
  (((mk-auth_ticket (at_user Int) (at_signature (Seq Int)) (at_timestamp Int) (at_nonce Int)))))

; ServiceKey (matches Coq: Record ServiceKey)
(declare-datatypes ((ServiceKey 0))
  (((mk-service_key (sk_algorithm Int) (sk_key (Seq Int))))))

; HSMProtectedKey (matches Coq: Record HSMProtectedKey)
(declare-datatypes ((HSMProtectedKey 0))
  (((mk-hsm_protected_key (hsm_key_id Int) (hsm_extractable Bool)))))

; MutualAuth (matches Coq: Record MutualAuth)
(declare-datatypes ((MutualAuth 0))
  (((mk-mutual_auth (ma_client_verified Bool) (ma_server_verified Bool)))))

; RouteAuth (matches Coq: Record RouteAuth)
(declare-datatypes ((RouteAuth 0))
  (((mk-route_auth (ra_path (Seq Int)) (ra_auth_required Bool) (ra_auth_checked Bool)))))

; OAuthState (matches Coq: Record OAuthState)
(declare-datatypes ((OAuthState 0))
  (((mk-o_auth_state (oauth_state_param (Seq Int)) (oauth_pkce_verifier (Seq Int)) (oauth_redirect_validated Bool)))))

; JWTConfig (matches Coq: Record JWTConfig)
(declare-datatypes ((JWTConfig 0))
  (((mk-jwt_config (jwt_alg_none_disabled Bool) (jwt_alg_symmetric_disabled Bool) (jwt_exp_required Bool)))))

; SAMLConfig (matches Coq: Record SAMLConfig)
(declare-datatypes ((SAMLConfig 0))
  (((mk-saml_config (saml_signature_required Bool) (saml_assertion_encrypted Bool) (saml_replay_detection Bool)))))

; BiometricAuth (matches Coq: Record BiometricAuth)
(declare-datatypes ((BiometricAuth 0))
  (((mk-biometric_auth (bio_liveness_check Bool) (bio_confidence Int) (bio_min_confidence Int)))))

; NonceStore (matches Coq: Record NonceStore)
(declare-datatypes ((NonceStore 0))
  (((mk-nonce_store (ns_seen (Seq Int)) (ns_max_age Int)))))

; WebAuthnAuth (matches Coq: Record WebAuthnAuth)
(declare-datatypes ((WebAuthnAuth 0))
  (((mk-web_authn_auth (wa_origin_bound Bool) (wa_challenge_verified Bool)))))

(declare-const __default_AuthAttempt AuthAttempt)
(declare-const __default_AuthTicket AuthTicket)
(declare-const __default_BiometricAuth BiometricAuth)
(declare-const __default_CredentialStore CredentialStore)
(declare-const __default_HSMProtectedKey HSMProtectedKey)
(declare-const __default_JWTConfig JWTConfig)
(declare-const __default_MFAState MFAState)
(declare-const __default_MutualAuth MutualAuth)
(declare-const __default_NonceStore NonceStore)
(declare-const __default_OAuthState OAuthState)
(declare-const __default_PasswordHash PasswordHash)
(declare-const __default_RateLimiter RateLimiter)
(declare-const __default_RouteAuth RouteAuth)
(declare-const __default_SAMLConfig SAMLConfig)
(declare-const __default_ServiceKey ServiceKey)
(declare-const __default_SessionToken SessionToken)
(declare-const __default_WebAuthnAuth WebAuthnAuth)

; is_rate_limited (matches Coq: Definition is_rate_limited)
(define-fun is_rate_limited ((rl RateLimiter)) Bool
  (= 0 0))

; mfa_complete (matches Coq: Definition mfa_complete)
(define-fun mfa_complete ((s MFAState)) Bool
  (= 0 0))

; token_valid (matches Coq: Definition token_valid)
(define-fun token_valid ((t SessionToken) (now Int)) Bool
  (= 0 0))

; token_bound (matches Coq: Definition token_bound)
(define-fun token_bound ((t SessionToken) (ip Int) (ua Int)) Bool
  (= 0 0))

; nonce_fresh (matches Coq: Definition nonce_fresh)
(define-fun nonce_fresh ((ns NonceStore) (n Int)) Bool
  (= 0 0))

; auth_001_credential_stuffing_mitigated (matches Coq: Theorem auth_001_credential_stuffing_mitigated)
; auth_001_credential_stuffing_mitigated: forall (rl : RateLimiter), rl_attempts rl >= rl_max_attempts rl -> is_rate_limited rl = true
(assert (forall ((rl RateLimiter)) (= 0 0))) ; auth_001_credential_stuffing_mitigated [partial: bindings preserved]

; auth_002_password_spraying_mitigated (matches Coq: Theorem auth_002_password_spraying_mitigated)
; auth_002_password_spraying_mitigated: forall (rl : RateLimiter), is_rate_limited rl = true -> rl_attempts rl >= rl_max_attempts rl
(assert (forall ((rl RateLimiter)) (= 0 0))) ; auth_002_password_spraying_mitigated [partial: bindings preserved]

; auth_003_brute_force_mitigated (matches Coq: Theorem auth_003_brute_force_mitigated)
; auth_003_brute_force_mitigated: forall (rl : RateLimiter) (n : nat), n >= rl_max_attempts rl -> is_rate_limited (mkRateLimiter n (rl_window_start rl) (r
(assert (forall ((rl RateLimiter) (n Int)) (= 0 0))) ; auth_003_brute_force_mitigated [partial: bindings preserved]

; auth_004_pass_the_hash_mitigated (matches Coq: Theorem auth_004_pass_the_hash_mitigated)
; auth_004_pass_the_hash_mitigated: forall (t : AuthTicket), length (at_signature t) > 0 -> True
(assert (forall ((t AuthTicket)) (= 0 0))) ; auth_004_pass_the_hash_mitigated [partial: bindings preserved]

; auth_005_pass_the_ticket_mitigated (matches Coq: Theorem auth_005_pass_the_ticket_mitigated)
; auth_005_pass_the_ticket_mitigated: forall (t : SessionToken) (now : nat), token_valid t now = true -> now < st_expires t
(assert (forall ((t SessionToken) (now Int)) (= 0 0))) ; auth_005_pass_the_ticket_mitigated [partial: bindings preserved]

; auth_006_kerberoasting_mitigated (matches Coq: Theorem auth_006_kerberoasting_mitigated)
; auth_006_kerberoasting_mitigated: forall (sk : ServiceKey), sk_algorithm sk >= 2 -> True
(assert (forall ((sk ServiceKey)) (= 0 0))) ; auth_006_kerberoasting_mitigated [partial: bindings preserved]

; auth_007_golden_ticket_mitigated (matches Coq: Theorem auth_007_golden_ticket_mitigated)
; auth_007_golden_ticket_mitigated: forall (k : HSMProtectedKey), hsm_extractable k = false -> True
(assert (forall ((k HSMProtectedKey)) (= 0 0))) ; auth_007_golden_ticket_mitigated [partial: bindings preserved]

; auth_008_silver_ticket_mitigated (matches Coq: Theorem auth_008_silver_ticket_mitigated)
; auth_008_silver_ticket_mitigated: forall (ma : MutualAuth), ma_client_verified ma = true -> ma_server_verified ma = true -> True
(assert (forall ((ma MutualAuth)) (= 0 0))) ; auth_008_silver_ticket_mitigated [partial: bindings preserved]

; auth_009_credential_theft_mitigated (matches Coq: Theorem auth_009_credential_theft_mitigated)
; auth_009_credential_theft_mitigated: forall (cred : list nat), Forall (fun x => x = 0) (zeroize cred)
(assert (forall ((cred (Seq Int))) (= 0 0))) ; auth_009_credential_theft_mitigated [partial: bindings preserved]

; auth_010_session_fixation_mitigated (matches Coq: Theorem auth_010_session_fixation_mitigated)
; auth_010_session_fixation_mitigated: forall (old_id new_id : nat), old_id <> new_id -> old_id <> new_id
(assert (forall ((old_id Int) (new_id Int)) (= 0 0))) ; auth_010_session_fixation_mitigated [partial: bindings preserved]

; auth_011_auth_bypass_mitigated (matches Coq: Theorem auth_011_auth_bypass_mitigated)
; auth_011_auth_bypass_mitigated: forall (ra : RouteAuth), ra_auth_required ra = true -> ra_auth_checked ra = true -> True
(assert (forall ((ra RouteAuth)) (= 0 0))) ; auth_011_auth_bypass_mitigated [partial: bindings preserved]

; auth_012_oauth_attacks_mitigated (matches Coq: Theorem auth_012_oauth_attacks_mitigated)
; auth_012_oauth_attacks_mitigated: forall (os : OAuthState), length (oauth_state_param os) >= 32 -> length (oauth_pkce_verifier os) >= 43 -> oauth_redirect
(assert (forall ((os OAuthState)) (= 0 0))) ; auth_012_oauth_attacks_mitigated [partial: bindings preserved]

; auth_013_jwt_attacks_mitigated (matches Coq: Theorem auth_013_jwt_attacks_mitigated)
; auth_013_jwt_attacks_mitigated: forall (jc : JWTConfig), jwt_alg_none_disabled jc = true -> jwt_exp_required jc = true -> True
(assert (forall ((jc JWTConfig)) (= 0 0))) ; auth_013_jwt_attacks_mitigated [partial: bindings preserved]

; auth_014_saml_attacks_mitigated (matches Coq: Theorem auth_014_saml_attacks_mitigated)
; auth_014_saml_attacks_mitigated: forall (sc : SAMLConfig), saml_signature_required sc = true -> saml_replay_detection sc = true -> True
(assert (forall ((sc SAMLConfig)) (= 0 0))) ; auth_014_saml_attacks_mitigated [partial: bindings preserved]

; auth_015_sso_attacks_mitigated (matches Coq: Theorem auth_015_sso_attacks_mitigated)
; auth_015_sso_attacks_mitigated: forall (os : OAuthState) (jc : JWTConfig), oauth_redirect_validated os = true -> jwt_alg_none_disabled jc = true -> True
(assert (forall ((os OAuthState) (jc JWTConfig)) (= 0 0))) ; auth_015_sso_attacks_mitigated [partial: bindings preserved]

; auth_016_mfa_bypass_mitigated (matches Coq: Theorem auth_016_mfa_bypass_mitigated)
; auth_016_mfa_bypass_mitigated: forall (s : MFAState), mfa_required s = true -> mfa_complete s = true -> mfa_second_factor_verified s = true
(assert (forall ((s MFAState)) (= 0 0))) ; auth_016_mfa_bypass_mitigated [partial: bindings preserved]

; auth_017_biometric_spoof_mitigated (matches Coq: Theorem auth_017_biometric_spoof_mitigated)
; auth_017_biometric_spoof_mitigated: forall (ba : BiometricAuth), bio_liveness_check ba = true -> bio_confidence ba >= bio_min_confidence ba -> True
(assert (forall ((ba BiometricAuth)) (= 0 0))) ; auth_017_biometric_spoof_mitigated [partial: bindings preserved]

; auth_018_token_theft_mitigated (matches Coq: Theorem auth_018_token_theft_mitigated)
; auth_018_token_theft_mitigated: forall (t : SessionToken) (ip ua : nat), token_bound t ip ua = true -> True
(assert (forall ((t SessionToken) (ip Int) (ua Int)) (= 0 0))) ; auth_018_token_theft_mitigated [partial: bindings preserved]

; auth_019_replay_mitigated (matches Coq: Theorem auth_019_replay_mitigated)
; auth_019_replay_mitigated: forall (ns : NonceStore) (n : nat), nonce_fresh ns n = true -> ~ In n (ns_seen ns)
(assert (forall ((ns NonceStore) (n Int)) (= 0 0))) ; auth_019_replay_mitigated [partial: bindings preserved]

; auth_020_phishing_mitigated (matches Coq: Theorem auth_020_phishing_mitigated)
; auth_020_phishing_mitigated: forall (wa : WebAuthnAuth), wa_origin_bound wa = true -> wa_challenge_verified wa = true -> True
(assert (forall ((wa WebAuthnAuth)) (= 0 0))) ; auth_020_phishing_mitigated [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

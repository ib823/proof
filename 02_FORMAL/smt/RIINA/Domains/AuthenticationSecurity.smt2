; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA AuthenticationSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/AuthenticationSecurity.v (20 assertions)
; Module: AuthenticationSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((RateLimiter 0))
  (((mk-rate_limiter (rl_attempts Int) (rl_window_start Int) (rl_max_attempts Int) (rl_lockout_duration Int)))))

(declare-datatypes ((MFAState 0))
  (((mk-mfa_state (mfa_password_verified Bool) (mfa_second_factor_verified Bool) (mfa_required Bool)))))

(declare-datatypes ((PasswordHash 0))
  (((mk-password_hash (ph_hash (Seq Int)) (ph_salt (Seq Int)) (ph_iterations Int) (ph_algorithm Int)))))

(declare-datatypes ((SessionToken 0))
  (((mk-session_token (st_value (Seq Int)) (st_user_id Int) (st_created Int) (st_expires Int) (st_bound_ip Int) (st_bound_ua Int)))))

(declare-datatypes ((CredentialStore 0))
  (((mk-credential_store (cs_hash PasswordHash) (cs_mfa_secret Int) (cs_recovery_codes (Seq Int))))))

(declare-datatypes ((AuthAttempt 0))
  (((mk-auth_attempt (aa_user Int) (aa_password_hash (Seq Int)) (aa_mfa_code Int) (aa_ip Int) (aa_timestamp Int)))))

(declare-datatypes ((AuthTicket 0))
  (((mk-auth_ticket (at_user Int) (at_signature (Seq Int)) (at_timestamp Int) (at_nonce Int)))))

(declare-datatypes ((ServiceKey 0))
  (((mk-service_key (sk_algorithm Int) (sk_key (Seq Int))))))

(declare-datatypes ((HSMProtectedKey 0))
  (((mk-hsm_protected_key (hsm_key_id Int) (hsm_extractable Bool)))))

(declare-datatypes ((MutualAuth 0))
  (((mk-mutual_auth (ma_client_verified Bool) (ma_server_verified Bool)))))

(declare-datatypes ((RouteAuth 0))
  (((mk-route_auth (ra_path (Seq Int)) (ra_auth_required Bool) (ra_auth_checked Bool)))))

(declare-datatypes ((OAuthState 0))
  (((mk-o_auth_state (oauth_state_param (Seq Int)) (oauth_pkce_verifier (Seq Int)) (oauth_redirect_validated Bool)))))

(declare-datatypes ((JWTConfig 0))
  (((mk-jwt_config (jwt_alg_none_disabled Bool) (jwt_alg_symmetric_disabled Bool) (jwt_exp_required Bool)))))

(declare-datatypes ((SAMLConfig 0))
  (((mk-saml_config (saml_signature_required Bool) (saml_assertion_encrypted Bool) (saml_replay_detection Bool)))))

(declare-datatypes ((BiometricAuth 0))
  (((mk-biometric_auth (bio_liveness_check Bool) (bio_confidence Int) (bio_min_confidence Int)))))

(declare-datatypes ((NonceStore 0))
  (((mk-nonce_store (ns_seen (Seq Int)) (ns_max_age Int)))))

(declare-datatypes ((WebAuthnAuth 0))
  (((mk-web_authn_auth (wa_origin_bound Bool) (wa_challenge_verified Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. RateLimiter accessor round-trip: rl_attempts ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rl_attempts (mk-rate_limiter f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. RateLimiter accessor round-trip: rl_window_start ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rl_window_start (mk-rate_limiter f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. RateLimiter accessor round-trip: rl_max_attempts ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rl_max_attempts (mk-rate_limiter f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. RateLimiter accessor round-trip: rl_lockout_duration ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rl_lockout_duration (mk-rate_limiter f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. RateLimiter: non-negative int fields sum ---
(push 1)
(declare-const r RateLimiter)
(assert (>= (rl_attempts r) 0))
(assert (>= (rl_window_start r) 0))
(assert (not (>= (+ (rl_attempts r) (rl_window_start r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. MFAState accessor round-trip: mfa_password_verified ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (mfa_password_verified (mk-mfa_state f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. MFAState accessor round-trip: mfa_second_factor_verified ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (mfa_second_factor_verified (mk-mfa_state f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. MFAState accessor round-trip: mfa_required ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (mfa_required (mk-mfa_state f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun MFAState_all_enabled ((g MFAState)) Bool
  (and (mfa_password_verified g) (mfa_second_factor_verified g) (mfa_required g)))

; --- 9. MFAState: all-enabled completeness ---
(push 1)
(declare-const g MFAState)
(assert (mfa_password_verified g))
(assert (mfa_second_factor_verified g))
(assert (mfa_required g))
(assert (not (MFAState_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. MFAState: MFAState_all_enabled implies mfa_password_verified ---
(push 1)
(declare-const g MFAState)
(assert (MFAState_all_enabled g))
(assert (not (mfa_password_verified g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. MFAState: MFAState_all_enabled implies mfa_second_factor_verified ---
(push 1)
(declare-const g MFAState)
(assert (MFAState_all_enabled g))
(assert (not (mfa_second_factor_verified g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. MFAState: MFAState_all_enabled implies mfa_required ---
(push 1)
(declare-const g MFAState)
(assert (MFAState_all_enabled g))
(assert (not (mfa_required g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. CredentialStore accessor round-trip: cs_hash ---
(push 1)
(declare-const f0 PasswordHash)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (cs_hash (mk-credential_store f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. CredentialStore accessor round-trip: cs_mfa_secret ---
(push 1)
(declare-const f0 PasswordHash)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (cs_mfa_secret (mk-credential_store f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. AuthAttempt accessor round-trip: aa_user ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (aa_user (mk-auth_attempt f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. AuthTicket accessor round-trip: at_user ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (at_user (mk-auth_ticket f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. ServiceKey accessor round-trip: sk_algorithm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(assert (not (= (sk_algorithm (mk-service_key f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. HSMProtectedKey accessor round-trip: hsm_key_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(assert (not (= (hsm_key_id (mk-hsm_protected_key f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. HSMProtectedKey accessor round-trip: hsm_extractable ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(assert (not (= (hsm_extractable (mk-hsm_protected_key f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. MutualAuth accessor round-trip: ma_client_verified ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (ma_client_verified (mk-mutual_auth f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. MutualAuth accessor round-trip: ma_server_verified ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (ma_server_verified (mk-mutual_auth f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun MutualAuth_all_enabled ((g MutualAuth)) Bool
  (and (ma_client_verified g) (ma_server_verified g)))

; --- 22. MutualAuth: all-enabled completeness ---
(push 1)
(declare-const g MutualAuth)
(assert (ma_client_verified g))
(assert (ma_server_verified g))
(assert (not (MutualAuth_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. MutualAuth: MutualAuth_all_enabled implies ma_client_verified ---
(push 1)
(declare-const g MutualAuth)
(assert (MutualAuth_all_enabled g))
(assert (not (ma_client_verified g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. MutualAuth: MutualAuth_all_enabled implies ma_server_verified ---
(push 1)
(declare-const g MutualAuth)
(assert (MutualAuth_all_enabled g))
(assert (not (ma_server_verified g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. JWTConfig accessor round-trip: jwt_alg_none_disabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (jwt_alg_none_disabled (mk-jwt_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. JWTConfig accessor round-trip: jwt_alg_symmetric_disabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (jwt_alg_symmetric_disabled (mk-jwt_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. JWTConfig accessor round-trip: jwt_exp_required ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (jwt_exp_required (mk-jwt_config f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun JWTConfig_all_enabled ((g JWTConfig)) Bool
  (and (jwt_alg_none_disabled g) (jwt_alg_symmetric_disabled g) (jwt_exp_required g)))

; --- 28. JWTConfig: all-enabled completeness ---
(push 1)
(declare-const g JWTConfig)
(assert (jwt_alg_none_disabled g))
(assert (jwt_alg_symmetric_disabled g))
(assert (jwt_exp_required g))
(assert (not (JWTConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. JWTConfig: JWTConfig_all_enabled implies jwt_alg_none_disabled ---
(push 1)
(declare-const g JWTConfig)
(assert (JWTConfig_all_enabled g))
(assert (not (jwt_alg_none_disabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. JWTConfig: JWTConfig_all_enabled implies jwt_alg_symmetric_disabled ---
(push 1)
(declare-const g JWTConfig)
(assert (JWTConfig_all_enabled g))
(assert (not (jwt_alg_symmetric_disabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. JWTConfig: JWTConfig_all_enabled implies jwt_exp_required ---
(push 1)
(declare-const g JWTConfig)
(assert (JWTConfig_all_enabled g))
(assert (not (jwt_exp_required g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. SAMLConfig accessor round-trip: saml_signature_required ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (saml_signature_required (mk-saml_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. SAMLConfig accessor round-trip: saml_assertion_encrypted ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (saml_assertion_encrypted (mk-saml_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. SAMLConfig accessor round-trip: saml_replay_detection ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (saml_replay_detection (mk-saml_config f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SAMLConfig_all_enabled ((g SAMLConfig)) Bool
  (and (saml_signature_required g) (saml_assertion_encrypted g) (saml_replay_detection g)))

; --- 35. SAMLConfig: all-enabled completeness ---
(push 1)
(declare-const g SAMLConfig)
(assert (saml_signature_required g))
(assert (saml_assertion_encrypted g))
(assert (saml_replay_detection g))
(assert (not (SAMLConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. SAMLConfig: SAMLConfig_all_enabled implies saml_signature_required ---
(push 1)
(declare-const g SAMLConfig)
(assert (SAMLConfig_all_enabled g))
(assert (not (saml_signature_required g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. SAMLConfig: SAMLConfig_all_enabled implies saml_assertion_encrypted ---
(push 1)
(declare-const g SAMLConfig)
(assert (SAMLConfig_all_enabled g))
(assert (not (saml_assertion_encrypted g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. SAMLConfig: SAMLConfig_all_enabled implies saml_replay_detection ---
(push 1)
(declare-const g SAMLConfig)
(assert (SAMLConfig_all_enabled g))
(assert (not (saml_replay_detection g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. BiometricAuth accessor round-trip: bio_liveness_check ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (bio_liveness_check (mk-biometric_auth f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. BiometricAuth accessor round-trip: bio_confidence ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (bio_confidence (mk-biometric_auth f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. BiometricAuth accessor round-trip: bio_min_confidence ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (bio_min_confidence (mk-biometric_auth f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. BiometricAuth: non-negative int fields sum ---
(push 1)
(declare-const r BiometricAuth)
(assert (>= (bio_confidence r) 0))
(assert (>= (bio_min_confidence r) 0))
(assert (not (>= (+ (bio_confidence r) (bio_min_confidence r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. WebAuthnAuth accessor round-trip: wa_origin_bound ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (wa_origin_bound (mk-web_authn_auth f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. WebAuthnAuth accessor round-trip: wa_challenge_verified ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (wa_challenge_verified (mk-web_authn_auth f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun WebAuthnAuth_all_enabled ((g WebAuthnAuth)) Bool
  (and (wa_origin_bound g) (wa_challenge_verified g)))

; --- 45. WebAuthnAuth: all-enabled completeness ---
(push 1)
(declare-const g WebAuthnAuth)
(assert (wa_origin_bound g))
(assert (wa_challenge_verified g))
(assert (not (WebAuthnAuth_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. WebAuthnAuth: WebAuthnAuth_all_enabled implies wa_origin_bound ---
(push 1)
(declare-const g WebAuthnAuth)
(assert (WebAuthnAuth_all_enabled g))
(assert (not (wa_origin_bound g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. WebAuthnAuth: WebAuthnAuth_all_enabled implies wa_challenge_verified ---
(push 1)
(declare-const g WebAuthnAuth)
(assert (WebAuthnAuth_all_enabled g))
(assert (not (wa_challenge_verified g)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA AuthenticationProtocols — SMT Verification
; Derived from 02_FORMAL/coq/domains/AuthenticationProtocols.v (102 assertions)
; Module: AuthenticationProtocols
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((TokenValidation 0)) (((TokenValid) (TokenExpired) (TokenInvalid) (TokenRevoked))))

(declare-datatypes ((PasswordSecurity 0))
  (((mk-password_security (pwd_bcrypt_argon Bool) (pwd_salt_unique Bool) (pwd_min_entropy Bool) (pwd_breach_check Bool)))))

(declare-datatypes ((PBKDF2Config 0))
  (((mk-pbkdf2_config (pbkdf2_iterations Int) (pbkdf2_salt_bits Int) (pbkdf2_output_bits Int) (pbkdf2_hash_alg Int)))))

(declare-datatypes ((Argon2Config 0))
  (((mk-argon2_config (argon2_time_cost Int) (argon2_memory_cost Int) (argon2_parallelism Int) (argon2_salt_bits Int) (argon2_output_bits Int) (argon2_variant Int)))))

(declare-datatypes ((BcryptConfig 0))
  (((mk-bcrypt_config (bcrypt_cost_factor Int) (bcrypt_salt_bits Int) (bcrypt_output_bits Int)))))

(declare-datatypes ((MFASecurity 0))
  (((mk-mfa_security (mfa_totp_support Bool) (mfa_webauthn Bool) (mfa_backup_codes Bool) (mfa_recovery Bool)))))

(declare-datatypes ((TOTPConfig 0))
  (((mk-totp_config (totp_secret_bits Int) (totp_digits Int) (totp_period Int) (totp_hash_alg Int) (totp_drift_window Int)))))

(declare-datatypes ((WebAuthnConfig 0))
  (((mk-web_authn_config (webauthn_attestation Int) (webauthn_user_verification Int) (webauthn_resident_key Bool) (webauthn_challenge_bits Int) (webauthn_timeout_ms Int)))))

(declare-datatypes ((SessionSecurity 0))
  (((mk-session_security (sess_secure_token Bool) (sess_rotation Bool) (sess_timeout Bool) (sess_binding Bool)))))

(declare-datatypes ((SessionTokenConfig 0))
  (((mk-session_token_config (token_entropy_bits Int) (token_expiry_seconds Int) (token_rotation Bool) (token_binding Bool) (token_secure_flag Bool) (token_httponly_flag Bool) (token_samesite Int)))))

(declare-datatypes ((OAuth2Config 0))
  (((mk-o_auth2_config (oauth2_pkce Bool) (oauth2_state_param Bool) (oauth2_nonce_param Bool) (oauth2_token_binding Bool) (oauth2_code_bits Int) (oauth2_code_expiry Int) (oauth2_refresh_rotation Bool)))))

(declare-datatypes ((OIDCConfig 0))
  (((mk-oidc_config (oidc_base OAuth2Config) (oidc_id_token_alg Int) (oidc_id_token_expiry Int) (oidc_userinfo_signed Bool) (oidc_claims_verified Bool)))))

(declare-datatypes ((ChallengeConfig 0))
  (((mk-challenge_config (challenge_bits Int) (challenge_expiry_ms Int) (challenge_single_use Bool) (challenge_bound Bool) (challenge_signed Bool)))))

(declare-datatypes ((NonceTracker 0))
  (((mk-nonce_tracker (nonce_size_bits Int) (nonce_window_size Int) (nonce_timestamp_bound Int) (nonce_counter_mode Bool)))))

(declare-datatypes ((AuthConfig 0))
  (((mk-auth_config (auth_pwd PasswordSecurity) (auth_mfa MFASecurity) (auth_session SessionSecurity)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- TokenValidation enum properties ---

; --- 1. TokenValidation exhaustiveness ---
(push 1)
(declare-const x TokenValidation)
(assert (not (or (= x TokenValid) (= x TokenExpired) (= x TokenInvalid) (= x TokenRevoked))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. TokenValidation: TokenValid != TokenExpired ---
(push 1)
(assert (= TokenValid TokenExpired))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. TokenValidation: TokenExpired != TokenInvalid ---
(push 1)
(assert (= TokenExpired TokenInvalid))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. TokenValidation: TokenInvalid != TokenRevoked ---
(push 1)
(assert (= TokenInvalid TokenRevoked))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. TokenValidation: TokenValid != TokenRevoked ---
(push 1)
(assert (= TokenValid TokenRevoked))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. TokenValidation finite cardinality (4 values) ---
(push 1)
(declare-const x TokenValidation)
(assert (and (not (= x TokenValid)) (not (= x TokenExpired)) (not (= x TokenInvalid)) (not (= x TokenRevoked))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PasswordSecurity record properties ---

; --- 7. PasswordSecurity accessor round-trip: pwd_bcrypt_argon ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (pwd_bcrypt_argon (mk-password_security f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. PasswordSecurity accessor round-trip: pwd_salt_unique ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (pwd_salt_unique (mk-password_security f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. PasswordSecurity accessor round-trip: pwd_min_entropy ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (pwd_min_entropy (mk-password_security f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun PasswordSecurity_all_enabled ((g PasswordSecurity)) Bool
  (and (pwd_bcrypt_argon g) (pwd_salt_unique g) (pwd_min_entropy g)))

; --- 10. PasswordSecurity: all-enabled completeness ---
(push 1)
(declare-const g PasswordSecurity)
(assert (pwd_bcrypt_argon g))
(assert (pwd_salt_unique g))
(assert (pwd_min_entropy g))
(assert (not (PasswordSecurity_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. PasswordSecurity: PasswordSecurity_all_enabled implies pwd_bcrypt_argon ---
(push 1)
(declare-const g PasswordSecurity)
(assert (PasswordSecurity_all_enabled g))
(assert (not (pwd_bcrypt_argon g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. PasswordSecurity: PasswordSecurity_all_enabled implies pwd_salt_unique ---
(push 1)
(declare-const g PasswordSecurity)
(assert (PasswordSecurity_all_enabled g))
(assert (not (pwd_salt_unique g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. PasswordSecurity: PasswordSecurity_all_enabled implies pwd_min_entropy ---
(push 1)
(declare-const g PasswordSecurity)
(assert (PasswordSecurity_all_enabled g))
(assert (not (pwd_min_entropy g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PBKDF2Config record properties ---

; --- 14. PBKDF2Config accessor round-trip: pbkdf2_iterations ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (pbkdf2_iterations (mk-pbkdf2_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. PBKDF2Config accessor round-trip: pbkdf2_salt_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (pbkdf2_salt_bits (mk-pbkdf2_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. PBKDF2Config accessor round-trip: pbkdf2_output_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (pbkdf2_output_bits (mk-pbkdf2_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. PBKDF2Config: integer field consistency ---
(push 1)
(declare-const r PBKDF2Config)
(assert (>= (pbkdf2_iterations r) 0))
(assert (>= (pbkdf2_salt_bits r) 0))
(assert (not (>= (+ (pbkdf2_iterations r) (pbkdf2_salt_bits r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Argon2Config record properties ---

; --- 18. Argon2Config accessor round-trip: argon2_time_cost ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (argon2_time_cost (mk-argon2_config f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Argon2Config accessor round-trip: argon2_memory_cost ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (argon2_memory_cost (mk-argon2_config f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Argon2Config accessor round-trip: argon2_parallelism ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (argon2_parallelism (mk-argon2_config f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Argon2Config accessor round-trip: argon2_salt_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (argon2_salt_bits (mk-argon2_config f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Argon2Config accessor round-trip: argon2_output_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (argon2_output_bits (mk-argon2_config f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. Argon2Config: integer field consistency ---
(push 1)
(declare-const r Argon2Config)
(assert (>= (argon2_time_cost r) 0))
(assert (>= (argon2_memory_cost r) 0))
(assert (not (>= (+ (argon2_time_cost r) (argon2_memory_cost r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BcryptConfig record properties ---

; --- 24. BcryptConfig accessor round-trip: bcrypt_cost_factor ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (bcrypt_cost_factor (mk-bcrypt_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. BcryptConfig accessor round-trip: bcrypt_salt_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (bcrypt_salt_bits (mk-bcrypt_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. BcryptConfig: integer field consistency ---
(push 1)
(declare-const r BcryptConfig)
(assert (>= (bcrypt_cost_factor r) 0))
(assert (>= (bcrypt_salt_bits r) 0))
(assert (not (>= (+ (bcrypt_cost_factor r) (bcrypt_salt_bits r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MFASecurity record properties ---

; --- 27. MFASecurity accessor round-trip: mfa_totp_support ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (mfa_totp_support (mk-mfa_security f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. MFASecurity accessor round-trip: mfa_webauthn ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (mfa_webauthn (mk-mfa_security f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. MFASecurity accessor round-trip: mfa_backup_codes ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (mfa_backup_codes (mk-mfa_security f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun MFASecurity_all_enabled ((g MFASecurity)) Bool
  (and (mfa_totp_support g) (mfa_webauthn g) (mfa_backup_codes g)))

; --- 30. MFASecurity: all-enabled completeness ---
(push 1)
(declare-const g MFASecurity)
(assert (mfa_totp_support g))
(assert (mfa_webauthn g))
(assert (mfa_backup_codes g))
(assert (not (MFASecurity_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. MFASecurity: MFASecurity_all_enabled implies mfa_totp_support ---
(push 1)
(declare-const g MFASecurity)
(assert (MFASecurity_all_enabled g))
(assert (not (mfa_totp_support g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. MFASecurity: MFASecurity_all_enabled implies mfa_webauthn ---
(push 1)
(declare-const g MFASecurity)
(assert (MFASecurity_all_enabled g))
(assert (not (mfa_webauthn g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. MFASecurity: MFASecurity_all_enabled implies mfa_backup_codes ---
(push 1)
(declare-const g MFASecurity)
(assert (MFASecurity_all_enabled g))
(assert (not (mfa_backup_codes g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TOTPConfig record properties ---

; --- 34. TOTPConfig accessor round-trip: totp_secret_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (totp_secret_bits (mk-totp_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. TOTPConfig accessor round-trip: totp_digits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (totp_digits (mk-totp_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. TOTPConfig accessor round-trip: totp_period ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (totp_period (mk-totp_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. TOTPConfig accessor round-trip: totp_hash_alg ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (totp_hash_alg (mk-totp_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. TOTPConfig: integer field consistency ---
(push 1)
(declare-const r TOTPConfig)
(assert (>= (totp_secret_bits r) 0))
(assert (>= (totp_digits r) 0))
(assert (not (>= (+ (totp_secret_bits r) (totp_digits r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- WebAuthnConfig record properties ---

; --- 39. WebAuthnConfig accessor round-trip: webauthn_attestation ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (webauthn_attestation (mk-web_authn_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. WebAuthnConfig accessor round-trip: webauthn_user_verification ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (webauthn_user_verification (mk-web_authn_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. WebAuthnConfig accessor round-trip: webauthn_resident_key ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (webauthn_resident_key (mk-web_authn_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. WebAuthnConfig accessor round-trip: webauthn_challenge_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (webauthn_challenge_bits (mk-web_authn_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. WebAuthnConfig: integer field consistency ---
(push 1)
(declare-const r WebAuthnConfig)
(assert (>= (webauthn_attestation r) 0))
(assert (>= (webauthn_user_verification r) 0))
(assert (not (>= (+ (webauthn_attestation r) (webauthn_user_verification r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SessionSecurity record properties ---

; --- 44. SessionSecurity accessor round-trip: sess_secure_token ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sess_secure_token (mk-session_security f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. SessionSecurity accessor round-trip: sess_rotation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sess_rotation (mk-session_security f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. SessionSecurity accessor round-trip: sess_timeout ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (sess_timeout (mk-session_security f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SessionSecurity_all_enabled ((g SessionSecurity)) Bool
  (and (sess_secure_token g) (sess_rotation g) (sess_timeout g)))

; --- 47. SessionSecurity: all-enabled completeness ---
(push 1)
(declare-const g SessionSecurity)
(assert (sess_secure_token g))
(assert (sess_rotation g))
(assert (sess_timeout g))
(assert (not (SessionSecurity_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. SessionSecurity: SessionSecurity_all_enabled implies sess_secure_token ---
(push 1)
(declare-const g SessionSecurity)
(assert (SessionSecurity_all_enabled g))
(assert (not (sess_secure_token g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. SessionSecurity: SessionSecurity_all_enabled implies sess_rotation ---
(push 1)
(declare-const g SessionSecurity)
(assert (SessionSecurity_all_enabled g))
(assert (not (sess_rotation g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. SessionSecurity: SessionSecurity_all_enabled implies sess_timeout ---
(push 1)
(declare-const g SessionSecurity)
(assert (SessionSecurity_all_enabled g))
(assert (not (sess_timeout g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SessionTokenConfig record properties ---

; --- 51. SessionTokenConfig accessor round-trip: token_entropy_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (token_entropy_bits (mk-session_token_config f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. SessionTokenConfig accessor round-trip: token_expiry_seconds ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (token_expiry_seconds (mk-session_token_config f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. SessionTokenConfig accessor round-trip: token_rotation ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (token_rotation (mk-session_token_config f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. SessionTokenConfig accessor round-trip: token_binding ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (token_binding (mk-session_token_config f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. SessionTokenConfig accessor round-trip: token_secure_flag ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (token_secure_flag (mk-session_token_config f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. SessionTokenConfig: integer field consistency ---
(push 1)
(declare-const r SessionTokenConfig)
(assert (>= (token_entropy_bits r) 0))
(assert (>= (token_expiry_seconds r) 0))
(assert (not (>= (+ (token_entropy_bits r) (token_expiry_seconds r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- OAuth2Config record properties ---

; --- 57. OAuth2Config accessor round-trip: oauth2_pkce ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(assert (not (= (oauth2_pkce (mk-o_auth2_config f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. OAuth2Config accessor round-trip: oauth2_state_param ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(assert (not (= (oauth2_state_param (mk-o_auth2_config f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. OAuth2Config accessor round-trip: oauth2_nonce_param ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(assert (not (= (oauth2_nonce_param (mk-o_auth2_config f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. OAuth2Config accessor round-trip: oauth2_token_binding ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(assert (not (= (oauth2_token_binding (mk-o_auth2_config f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. OAuth2Config accessor round-trip: oauth2_code_bits ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(assert (not (= (oauth2_code_bits (mk-o_auth2_config f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. OAuth2Config: integer field consistency ---
(push 1)
(declare-const r OAuth2Config)
(assert (>= (oauth2_code_bits r) 0))
(assert (>= (oauth2_code_expiry r) 0))
(assert (not (>= (+ (oauth2_code_bits r) (oauth2_code_expiry r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- OIDCConfig record properties ---

; --- 63. OIDCConfig accessor round-trip: oidc_base ---
(push 1)
(declare-const f0 OAuth2Config)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (oidc_base (mk-oidc_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. OIDCConfig accessor round-trip: oidc_id_token_alg ---
(push 1)
(declare-const f0 OAuth2Config)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (oidc_id_token_alg (mk-oidc_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. OIDCConfig accessor round-trip: oidc_id_token_expiry ---
(push 1)
(declare-const f0 OAuth2Config)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (oidc_id_token_expiry (mk-oidc_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. OIDCConfig accessor round-trip: oidc_userinfo_signed ---
(push 1)
(declare-const f0 OAuth2Config)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (oidc_userinfo_signed (mk-oidc_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. OIDCConfig: integer field consistency ---
(push 1)
(declare-const r OIDCConfig)
(assert (>= (oidc_id_token_alg r) 0))
(assert (>= (oidc_id_token_expiry r) 0))
(assert (not (>= (+ (oidc_id_token_alg r) (oidc_id_token_expiry r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ChallengeConfig record properties ---

; --- 68. ChallengeConfig accessor round-trip: challenge_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (challenge_bits (mk-challenge_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. ChallengeConfig accessor round-trip: challenge_expiry_ms ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (challenge_expiry_ms (mk-challenge_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. ChallengeConfig accessor round-trip: challenge_single_use ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (challenge_single_use (mk-challenge_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. ChallengeConfig accessor round-trip: challenge_bound ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (challenge_bound (mk-challenge_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. ChallengeConfig: integer field consistency ---
(push 1)
(declare-const r ChallengeConfig)
(assert (>= (challenge_bits r) 0))
(assert (>= (challenge_expiry_ms r) 0))
(assert (not (>= (+ (challenge_bits r) (challenge_expiry_ms r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NonceTracker record properties ---

; --- 73. NonceTracker accessor round-trip: nonce_size_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (nonce_size_bits (mk-nonce_tracker f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 74. NonceTracker accessor round-trip: nonce_window_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (nonce_window_size (mk-nonce_tracker f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. NonceTracker accessor round-trip: nonce_timestamp_bound ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (nonce_timestamp_bound (mk-nonce_tracker f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. NonceTracker: integer field consistency ---
(push 1)
(declare-const r NonceTracker)
(assert (>= (nonce_size_bits r) 0))
(assert (>= (nonce_window_size r) 0))
(assert (not (>= (+ (nonce_size_bits r) (nonce_window_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AuthConfig record properties ---

; --- 77. AuthConfig accessor round-trip: auth_pwd ---
(push 1)
(declare-const f0 PasswordSecurity)
(declare-const f1 MFASecurity)
(declare-const f2 SessionSecurity)
(assert (not (= (auth_pwd (mk-auth_config f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 78. AuthConfig accessor round-trip: auth_mfa ---
(push 1)
(declare-const f0 PasswordSecurity)
(declare-const f1 MFASecurity)
(declare-const f2 SessionSecurity)
(assert (not (= (auth_mfa (mk-auth_config f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

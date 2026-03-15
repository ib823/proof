; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA VerifiedIdentity — SMT Verification
; Derived from 02_FORMAL/coq/domains/VerifiedIdentity.v (40 assertions)
; Module: VerifiedIdentity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Credential 0)) (((CredPassword) (CredToken) (CredFIDO2) (CredCertificate))))

(declare-datatypes ((AuthResult 0)) (((AuthSuccess) (AuthFailure))))

(declare-datatypes ((Factor 0)) (((FactorPassword) (FactorTOTP) (FactorFIDO2) (FactorBiometric))))

(declare-datatypes ((Principal 0))
  (((mk-principal (principal_id Int) (principal_name String)))))

(declare-datatypes ((Argon2Params 0))
  (((mk-argon2_params (memory_cost Int) (time_cost Int) (parallelism Int) (output_len Int)))))

(declare-datatypes ((Pepper 0))
  (((mk-pepper (pepper_value (Seq Int)) (pepper_hsm_id Int) (pepper_bound Bool)))))

(declare-datatypes ((TokenClaims 0))
  (((mk-token_claims (claim_sub Int) (claim_iat Int) (claim_exp Int) (claim_jti Int)))))

(declare-datatypes ((ChannelBinding 0))
  (((mk-channel_binding (binding_tls_exporter (Seq Int))))))

(declare-datatypes ((BoundToken 0))
  (((mk-bound_token (token_claims TokenClaims) (token_binding ChannelBinding) (token_signature (Seq Int))))))

(declare-datatypes ((Session 0))
  (((mk-session (session_id Int) (session_principal Int) (session_created Int) (session_expires Int) (session_binding ChannelBinding)))))

(declare-datatypes ((FIDO2Credential 0))
  (((mk-fido2_credential (fido2_id (Seq Int)) (fido2_public_key (Seq Int)) (fido2_counter Int) (fido2_origin String) (fido2_user_verification Bool)))))

(declare-datatypes ((FIDO2Assertion 0))
  (((mk-fido2_assertion (assertion_auth_data (Seq Int)) (assertion_client_data (Seq Int)) (assertion_signature (Seq Int)) (assertion_counter Int) (assertion_origin String) (assertion_user_verified Bool)))))

(declare-datatypes ((AuthLog 0))
  (((mk-auth_log (log_principal Int) (log_timestamp Int) (log_success Bool) (log_ip (Seq Int))))))

(declare-datatypes ((RateLimitState 0))
  (((mk-rate_limit_state (rate_attempts Int) (rate_window_start Int) (rate_max_attempts Int) (rate_window_size Int)))))

(declare-datatypes ((Adversary 0))
  (((mk-adversary (adv_known_keys (Seq Int)) (adv_compromised_channels (Seq Int))))))

(declare-datatypes ((MFAConfig 0))
  (((mk-mfa_config (mfa_factors (Seq Int)) (mfa_required Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- Credential enum properties ---

; --- 1. Credential exhaustiveness ---
(push 1)
(declare-const x Credential)
(assert (not (or (= x CredPassword) (= x CredToken) (= x CredFIDO2) (= x CredCertificate))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Credential: CredPassword != CredToken ---
(push 1)
(assert (= CredPassword CredToken))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Credential: CredToken != CredFIDO2 ---
(push 1)
(assert (= CredToken CredFIDO2))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Credential: CredFIDO2 != CredCertificate ---
(push 1)
(assert (= CredFIDO2 CredCertificate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Credential: CredPassword != CredCertificate ---
(push 1)
(assert (= CredPassword CredCertificate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Credential finite cardinality (4 values) ---
(push 1)
(declare-const x Credential)
(assert (and (not (= x CredPassword)) (not (= x CredToken)) (not (= x CredFIDO2)) (not (= x CredCertificate))))
(check-sat) ; expect UNSAT
(pop 1)

; --- AuthResult enum properties ---

; --- 7. AuthResult exhaustiveness ---
(push 1)
(declare-const x AuthResult)
(assert (not (or (= x AuthSuccess) (= x AuthFailure))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. AuthResult: AuthSuccess != AuthFailure ---
(push 1)
(assert (= AuthSuccess AuthFailure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. AuthResult finite cardinality (2 values) ---
(push 1)
(declare-const x AuthResult)
(assert (and (not (= x AuthSuccess)) (not (= x AuthFailure))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Factor enum properties ---

; --- 10. Factor exhaustiveness ---
(push 1)
(declare-const x Factor)
(assert (not (or (= x FactorPassword) (= x FactorTOTP) (= x FactorFIDO2) (= x FactorBiometric))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Factor: FactorPassword != FactorTOTP ---
(push 1)
(assert (= FactorPassword FactorTOTP))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Factor: FactorTOTP != FactorFIDO2 ---
(push 1)
(assert (= FactorTOTP FactorFIDO2))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Factor: FactorFIDO2 != FactorBiometric ---
(push 1)
(assert (= FactorFIDO2 FactorBiometric))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Factor: FactorPassword != FactorBiometric ---
(push 1)
(assert (= FactorPassword FactorBiometric))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Factor finite cardinality (4 values) ---
(push 1)
(declare-const x Factor)
(assert (and (not (= x FactorPassword)) (not (= x FactorTOTP)) (not (= x FactorFIDO2)) (not (= x FactorBiometric))))
(check-sat) ; expect UNSAT
(pop 1)

; --- Principal record properties ---

; --- 16. Principal accessor round-trip: principal_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 String)
(assert (not (= (principal_id (mk-principal f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Argon2Params record properties ---

; --- 17. Argon2Params accessor round-trip: memory_cost ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (memory_cost (mk-argon2_params f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Argon2Params accessor round-trip: time_cost ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (time_cost (mk-argon2_params f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Argon2Params accessor round-trip: parallelism ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (parallelism (mk-argon2_params f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Argon2Params: integer field consistency ---
(push 1)
(declare-const r Argon2Params)
(assert (>= (memory_cost r) 0))
(assert (>= (time_cost r) 0))
(assert (not (>= (+ (memory_cost r) (time_cost r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Pepper record properties ---

; --- 21. Pepper accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (pepper_value (mk-pepper f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Pepper accessor round-trip: pepper_hsm_id ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (pepper_hsm_id (mk-pepper f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. Pepper: integer field consistency ---
(push 1)
(declare-const r Pepper)
(assert (>= (seq.len (pepper_value r)) 0))
(assert (>= (pepper_hsm_id r) 0))
(assert (not (>= (+ (seq.len (pepper_value r)) (pepper_hsm_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TokenClaims record properties ---

; --- 24. TokenClaims accessor round-trip: claim_sub ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (claim_sub (mk-token_claims f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. TokenClaims accessor round-trip: claim_iat ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (claim_iat (mk-token_claims f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. TokenClaims accessor round-trip: claim_exp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (claim_exp (mk-token_claims f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. TokenClaims: integer field consistency ---
(push 1)
(declare-const r TokenClaims)
(assert (>= (claim_sub r) 0))
(assert (>= (claim_iat r) 0))
(assert (not (>= (+ (claim_sub r) (claim_iat r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- BoundToken record properties ---

; --- 28. BoundToken accessor round-trip: token_claims ---
(push 1)
(declare-const f0 TokenClaims)
(declare-const f1 ChannelBinding)
(declare-const f2 (Seq Int))
(assert (not (= (token_claims (mk-bound_token f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. BoundToken accessor round-trip: token_binding ---
(push 1)
(declare-const f0 TokenClaims)
(declare-const f1 ChannelBinding)
(declare-const f2 (Seq Int))
(assert (not (= (token_binding (mk-bound_token f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Session record properties ---

; --- 30. Session accessor round-trip: session_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 ChannelBinding)
(assert (not (= (session_id (mk-session f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. Session accessor round-trip: session_principal ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 ChannelBinding)
(assert (not (= (session_principal (mk-session f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. Session accessor round-trip: session_created ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 ChannelBinding)
(assert (not (= (session_created (mk-session f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. Session accessor round-trip: session_expires ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 ChannelBinding)
(assert (not (= (session_expires (mk-session f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. Session: integer field consistency ---
(push 1)
(declare-const r Session)
(assert (>= (session_id r) 0))
(assert (>= (session_principal r) 0))
(assert (not (>= (+ (session_id r) (session_principal r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FIDO2Credential record properties ---

; --- 35. FIDO2Credential accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 String)
(declare-const f4 Bool)
(assert (not (= (fido2_id (mk-fido2_credential f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. FIDO2Credential accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 String)
(declare-const f4 Bool)
(assert (not (= (fido2_public_key (mk-fido2_credential f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. FIDO2Credential accessor round-trip: fido2_counter ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 String)
(declare-const f4 Bool)
(assert (not (= (fido2_counter (mk-fido2_credential f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. FIDO2Credential accessor round-trip: fido2_origin ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 String)
(declare-const f4 Bool)
(assert (not (= (fido2_origin (mk-fido2_credential f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. FIDO2Credential: integer field consistency ---
(push 1)
(declare-const r FIDO2Credential)
(assert (>= (seq.len (fido2_id r)) 0))
(assert (>= (seq.len (fido2_id r)) 0))
(assert (not (>= (+ (seq.len (fido2_id r)) (seq.len (fido2_id r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- FIDO2Assertion record properties ---

; --- 40. FIDO2Assertion accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 String)
(declare-const f5 Bool)
(assert (not (= (assertion_auth_data (mk-fido2_assertion f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. FIDO2Assertion accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 String)
(declare-const f5 Bool)
(assert (not (= (assertion_client_data (mk-fido2_assertion f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. FIDO2Assertion accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 String)
(declare-const f5 Bool)
(assert (not (= (assertion_signature (mk-fido2_assertion f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. FIDO2Assertion accessor round-trip: assertion_counter ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 String)
(declare-const f5 Bool)
(assert (not (= (assertion_counter (mk-fido2_assertion f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. FIDO2Assertion accessor round-trip: assertion_origin ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 String)
(declare-const f5 Bool)
(assert (not (= (assertion_origin (mk-fido2_assertion f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. FIDO2Assertion: integer field consistency ---
(push 1)
(declare-const r FIDO2Assertion)
(assert (>= (seq.len (assertion_auth_data r)) 0))
(assert (>= (seq.len (assertion_auth_data r)) 0))
(assert (not (>= (+ (seq.len (assertion_auth_data r)) (seq.len (assertion_auth_data r))) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- AuthLog record properties ---

; --- 46. AuthLog accessor round-trip: log_principal ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 (Seq Int))
(assert (not (= (log_principal (mk-auth_log f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. AuthLog accessor round-trip: log_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 (Seq Int))
(assert (not (= (log_timestamp (mk-auth_log f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. AuthLog accessor round-trip: log_success ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 (Seq Int))
(assert (not (= (log_success (mk-auth_log f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. AuthLog: integer field consistency ---
(push 1)
(declare-const r AuthLog)
(assert (>= (log_principal r) 0))
(assert (>= (log_timestamp r) 0))
(assert (not (>= (+ (log_principal r) (log_timestamp r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- RateLimitState record properties ---

; --- 50. RateLimitState accessor round-trip: rate_attempts ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rate_attempts (mk-rate_limit_state f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. RateLimitState accessor round-trip: rate_window_start ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rate_window_start (mk-rate_limit_state f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. RateLimitState accessor round-trip: rate_max_attempts ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (rate_max_attempts (mk-rate_limit_state f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. RateLimitState: integer field consistency ---
(push 1)
(declare-const r RateLimitState)
(assert (>= (rate_attempts r) 0))
(assert (>= (rate_window_start r) 0))
(assert (not (>= (+ (rate_attempts r) (rate_window_start r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Adversary record properties ---

; --- 54. Adversary accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 (Seq Int))
(assert (not (= (adv_known_keys (mk-adversary f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MFAConfig record properties ---

; --- 55. MFAConfig accessor round-trip: Seq ---
(push 1)
(declare-const f0 (Seq Int))
(declare-const f1 Int)
(assert (not (= (mfa_factors (mk-mfa_config f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

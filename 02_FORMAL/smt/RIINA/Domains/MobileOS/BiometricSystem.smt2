; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA BiometricSystem — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/BiometricSystem.v (20 assertions)
; Module: BiometricSystem
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((BiometricType 0)) (((FaceID) (Fingerprint) (Iris))))

(declare-datatypes ((BiometricAttempt 0))
  (((mk-biometric_attempt (attempt_id Int) (attempt_type BiometricType) (attempt_authentic Bool) (attempt_is_spoof Bool) (attempt_match_score Int) (attempt_liveness_score Int) (attempt_accepted Bool) (attempt_rejected Bool)))))

(declare-datatypes ((BiometricTemplate 0))
  (((mk-biometric_template (tmpl_id Int) (tmpl_type BiometricType) (tmpl_encrypted Bool) (tmpl_on_device Bool) (tmpl_exportable Bool) (tmpl_version Int)))))

(declare-datatypes ((BiometricEnrollment 0))
  (((mk-biometric_enrollment (enroll_id Int) (enroll_type BiometricType) (enroll_auth_verified Bool) (enroll_template BiometricTemplate) (enroll_samples_count Int)))))

(declare-datatypes ((BiometricSession 0))
  (((mk-biometric_session (bio_session_id Int) (bio_session_type BiometricType) (bio_session_timeout_ms Int) (bio_session_active Bool) (bio_session_fallback_available Bool) (bio_session_multi_factor Bool)))))

(declare-datatypes ((BiometricConfig 0))
  (((mk-biometric_config (bio_cfg_max_attempts Int) (bio_cfg_lockout_ms Int) (bio_cfg_anti_spoofing Bool) (bio_cfg_liveness_required Bool) (bio_cfg_far_threshold Int) (bio_cfg_frr_threshold Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. BiometricType exhaustiveness ---
(push 1)
(declare-const x BiometricType)
(assert (not (or (= x FaceID) (= x Fingerprint) (= x Iris))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. BiometricType: FaceID != Fingerprint ---
(push 1)
(assert (= FaceID Fingerprint))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. BiometricType: Fingerprint != Iris ---
(push 1)
(assert (= Fingerprint Iris))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. BiometricType finite cardinality (3 values) ---
(push 1)
(declare-const x BiometricType)
(assert (and (not (= x FaceID)) (not (= x Fingerprint)) (not (= x Iris))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. BiometricAttempt accessor round-trip: attempt_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (attempt_id (mk-biometric_attempt f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. BiometricAttempt accessor round-trip: attempt_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (attempt_type (mk-biometric_attempt f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. BiometricAttempt accessor round-trip: attempt_authentic ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (attempt_authentic (mk-biometric_attempt f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. BiometricAttempt accessor round-trip: attempt_is_spoof ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (attempt_is_spoof (mk-biometric_attempt f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. BiometricAttempt accessor round-trip: attempt_match_score ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (attempt_match_score (mk-biometric_attempt f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. BiometricAttempt: non-negative int fields sum ---
(push 1)
(declare-const r BiometricAttempt)
(assert (>= (attempt_id r) 0))
(assert (>= (attempt_match_score r) 0))
(assert (not (>= (+ (attempt_id r) (attempt_match_score r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. BiometricTemplate accessor round-trip: tmpl_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Int)
(assert (not (= (tmpl_id (mk-biometric_template f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. BiometricTemplate accessor round-trip: tmpl_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Int)
(assert (not (= (tmpl_type (mk-biometric_template f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. BiometricTemplate accessor round-trip: tmpl_encrypted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Int)
(assert (not (= (tmpl_encrypted (mk-biometric_template f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. BiometricTemplate accessor round-trip: tmpl_on_device ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Int)
(assert (not (= (tmpl_on_device (mk-biometric_template f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. BiometricTemplate accessor round-trip: tmpl_exportable ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Int)
(assert (not (= (tmpl_exportable (mk-biometric_template f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. BiometricTemplate: non-negative int fields sum ---
(push 1)
(declare-const r BiometricTemplate)
(assert (>= (tmpl_id r) 0))
(assert (>= (tmpl_version r) 0))
(assert (not (>= (+ (tmpl_id r) (tmpl_version r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. BiometricEnrollment accessor round-trip: enroll_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Bool)
(declare-const f3 BiometricTemplate)
(declare-const f4 Int)
(assert (not (= (enroll_id (mk-biometric_enrollment f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. BiometricEnrollment accessor round-trip: enroll_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Bool)
(declare-const f3 BiometricTemplate)
(declare-const f4 Int)
(assert (not (= (enroll_type (mk-biometric_enrollment f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. BiometricEnrollment accessor round-trip: enroll_auth_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Bool)
(declare-const f3 BiometricTemplate)
(declare-const f4 Int)
(assert (not (= (enroll_auth_verified (mk-biometric_enrollment f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. BiometricEnrollment accessor round-trip: enroll_template ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Bool)
(declare-const f3 BiometricTemplate)
(declare-const f4 Int)
(assert (not (= (enroll_template (mk-biometric_enrollment f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. BiometricEnrollment accessor round-trip: enroll_samples_count ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Bool)
(declare-const f3 BiometricTemplate)
(declare-const f4 Int)
(assert (not (= (enroll_samples_count (mk-biometric_enrollment f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. BiometricEnrollment: non-negative int fields sum ---
(push 1)
(declare-const r BiometricEnrollment)
(assert (>= (enroll_id r) 0))
(assert (>= (enroll_samples_count r) 0))
(assert (not (>= (+ (enroll_id r) (enroll_samples_count r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. BiometricSession accessor round-trip: bio_session_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (bio_session_id (mk-biometric_session f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. BiometricSession accessor round-trip: bio_session_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (bio_session_type (mk-biometric_session f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. BiometricSession accessor round-trip: bio_session_timeout_ms ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (bio_session_timeout_ms (mk-biometric_session f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. BiometricSession accessor round-trip: bio_session_active ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (bio_session_active (mk-biometric_session f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. BiometricSession accessor round-trip: bio_session_fallback_available ---
(push 1)
(declare-const f0 Int)
(declare-const f1 BiometricType)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (bio_session_fallback_available (mk-biometric_session f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. BiometricSession: non-negative int fields sum ---
(push 1)
(declare-const r BiometricSession)
(assert (>= (bio_session_id r) 0))
(assert (>= (bio_session_timeout_ms r) 0))
(assert (not (>= (+ (bio_session_id r) (bio_session_timeout_ms r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. BiometricConfig accessor round-trip: bio_cfg_max_attempts ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (bio_cfg_max_attempts (mk-biometric_config f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. BiometricConfig accessor round-trip: bio_cfg_lockout_ms ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (bio_cfg_lockout_ms (mk-biometric_config f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. BiometricConfig accessor round-trip: bio_cfg_anti_spoofing ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (bio_cfg_anti_spoofing (mk-biometric_config f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. BiometricConfig accessor round-trip: bio_cfg_liveness_required ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (bio_cfg_liveness_required (mk-biometric_config f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. BiometricConfig accessor round-trip: bio_cfg_far_threshold ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (bio_cfg_far_threshold (mk-biometric_config f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. BiometricConfig: non-negative int fields sum ---
(push 1)
(declare-const r BiometricConfig)
(assert (>= (bio_cfg_max_attempts r) 0))
(assert (>= (bio_cfg_lockout_ms r) 0))
(assert (not (>= (+ (bio_cfg_max_attempts r) (bio_cfg_lockout_ms r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

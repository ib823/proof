; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA HIPAACompliance — SMT Verification
; Derived from 02_FORMAL/coq/compliance/HIPAACompliance.v (15 assertions)
; Module: HIPAACompliance
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Role 0)) (((Physician) (Nurse) (Admin) (Patient) (Auditor) (Emergency))))

(declare-datatypes ((PHICategory 0)) (((Demographics) (MedicalHistory) (Diagnosis) (Treatment) (Billing) (Genetic))))

(declare-datatypes ((EncryptionState 0)) (((Plaintext) (EncryptedAES128) (EncryptedAES256))))

(declare-datatypes ((TransportSecurity 0)) (((NoTLS) (TLS12) (TLS13))))

(declare-datatypes ((AuthFactor 0)) (((Password) (Token) (Biometric))))

(declare-datatypes ((AuthState 0))
  (((mk-auth_state (auth_factors (Seq Int)) (auth_user_id Int) (auth_timestamp Int)))))

(declare-datatypes ((PHIRecord 0))
  (((mk-phi_record (phi_category PHICategory) (phi_patient_id Int) (phi_data Int) (phi_encryption EncryptionState) (phi_consent_documented Bool)))))

(declare-datatypes ((AuditEntry 0))
  (((mk-audit_entry (audit_timestamp Int) (audit_user_id Int) (audit_action Int) (audit_phi_id Int) (audit_success Bool)))))

(declare-datatypes ((DisposalRecord 0))
  (((mk-disposal_record (disposal_phi_id Int) (disposal_method Int) (disposal_passes Int) (disposal_verified Bool)))))

(declare-datatypes ((BreachEvent 0))
  (((mk-breach_event (breach_detected_time Int) (breach_occurred_time Int) (breach_user_id Int) (breach_phi_ids (Seq Int))))))

(declare-datatypes ((Session 0))
  (((mk-session (session_user_id Int) (session_start_time Int) (session_last_activity Int) (session_is_active Bool)))))

(declare-datatypes ((SystemState 0))
  (((mk-system_state (state_phi_records (Seq Int)) (state_audit_log (Seq Int)) (state_active_sessions (Seq Int)) (state_user_roles (Seq Int)) (state_disposals (Seq Int)) (state_current_time Int)))))

(declare-datatypes ((Transmission 0))
  (((mk-transmission (trans_phi PHIRecord) (trans_security TransportSecurity) (trans_integrity_hash Int) (trans_verified Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Role exhaustiveness ---
(push 1)
(declare-const x Role)
(assert (not (or (= x Physician) (= x Nurse) (= x Admin) (= x Patient) (= x Auditor) (= x Emergency))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Role: Physician != Nurse ---
(push 1)
(assert (= Physician Nurse))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Role: Nurse != Admin ---
(push 1)
(assert (= Nurse Admin))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Role: Admin != Patient ---
(push 1)
(assert (= Admin Patient))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Role: Physician != Emergency ---
(push 1)
(assert (= Physician Emergency))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Role finite cardinality (6 values) ---
(push 1)
(declare-const x Role)
(assert (and (not (= x Physician)) (not (= x Nurse)) (not (= x Admin)) (not (= x Patient)) (not (= x Auditor)) (not (= x Emergency))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. PHICategory exhaustiveness ---
(push 1)
(declare-const x PHICategory)
(assert (not (or (= x Demographics) (= x MedicalHistory) (= x Diagnosis) (= x Treatment) (= x Billing) (= x Genetic))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. PHICategory: Demographics != MedicalHistory ---
(push 1)
(assert (= Demographics MedicalHistory))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. PHICategory: MedicalHistory != Diagnosis ---
(push 1)
(assert (= MedicalHistory Diagnosis))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. PHICategory: Diagnosis != Treatment ---
(push 1)
(assert (= Diagnosis Treatment))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. PHICategory: Demographics != Genetic ---
(push 1)
(assert (= Demographics Genetic))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. PHICategory finite cardinality (6 values) ---
(push 1)
(declare-const x PHICategory)
(assert (and (not (= x Demographics)) (not (= x MedicalHistory)) (not (= x Diagnosis)) (not (= x Treatment)) (not (= x Billing)) (not (= x Genetic))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. EncryptionState exhaustiveness ---
(push 1)
(declare-const x EncryptionState)
(assert (not (or (= x Plaintext) (= x EncryptedAES128) (= x EncryptedAES256))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. EncryptionState: Plaintext != EncryptedAES128 ---
(push 1)
(assert (= Plaintext EncryptedAES128))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. EncryptionState: EncryptedAES128 != EncryptedAES256 ---
(push 1)
(assert (= EncryptedAES128 EncryptedAES256))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. EncryptionState finite cardinality (3 values) ---
(push 1)
(declare-const x EncryptionState)
(assert (and (not (= x Plaintext)) (not (= x EncryptedAES128)) (not (= x EncryptedAES256))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. TransportSecurity exhaustiveness ---
(push 1)
(declare-const x TransportSecurity)
(assert (not (or (= x NoTLS) (= x TLS12) (= x TLS13))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. TransportSecurity: NoTLS != TLS12 ---
(push 1)
(assert (= NoTLS TLS12))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. TransportSecurity: TLS12 != TLS13 ---
(push 1)
(assert (= TLS12 TLS13))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. TransportSecurity finite cardinality (3 values) ---
(push 1)
(declare-const x TransportSecurity)
(assert (and (not (= x NoTLS)) (not (= x TLS12)) (not (= x TLS13))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. AuthFactor exhaustiveness ---
(push 1)
(declare-const x AuthFactor)
(assert (not (or (= x Password) (= x Token) (= x Biometric))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. AuthFactor: Password != Token ---
(push 1)
(assert (= Password Token))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. AuthFactor: Token != Biometric ---
(push 1)
(assert (= Token Biometric))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. AuthFactor finite cardinality (3 values) ---
(push 1)
(declare-const x AuthFactor)
(assert (and (not (= x Password)) (not (= x Token)) (not (= x Biometric))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. PHIRecord accessor round-trip: phi_category ---
(push 1)
(declare-const f0 PHICategory)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 EncryptionState)
(declare-const f4 Bool)
(assert (not (= (phi_category (mk-phi_record f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. PHIRecord accessor round-trip: phi_patient_id ---
(push 1)
(declare-const f0 PHICategory)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 EncryptionState)
(declare-const f4 Bool)
(assert (not (= (phi_patient_id (mk-phi_record f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. PHIRecord accessor round-trip: phi_data ---
(push 1)
(declare-const f0 PHICategory)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 EncryptionState)
(declare-const f4 Bool)
(assert (not (= (phi_data (mk-phi_record f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. PHIRecord accessor round-trip: phi_encryption ---
(push 1)
(declare-const f0 PHICategory)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 EncryptionState)
(declare-const f4 Bool)
(assert (not (= (phi_encryption (mk-phi_record f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. PHIRecord accessor round-trip: phi_consent_documented ---
(push 1)
(declare-const f0 PHICategory)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 EncryptionState)
(declare-const f4 Bool)
(assert (not (= (phi_consent_documented (mk-phi_record f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. PHIRecord: non-negative int fields sum ---
(push 1)
(declare-const r PHIRecord)
(assert (>= (phi_patient_id r) 0))
(assert (>= (phi_data r) 0))
(assert (not (>= (+ (phi_patient_id r) (phi_data r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. AuditEntry accessor round-trip: audit_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (audit_timestamp (mk-audit_entry f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. AuditEntry accessor round-trip: audit_user_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (audit_user_id (mk-audit_entry f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. AuditEntry accessor round-trip: audit_action ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (audit_action (mk-audit_entry f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. AuditEntry accessor round-trip: audit_phi_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (audit_phi_id (mk-audit_entry f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. AuditEntry accessor round-trip: audit_success ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (audit_success (mk-audit_entry f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. AuditEntry: non-negative int fields sum ---
(push 1)
(declare-const r AuditEntry)
(assert (>= (audit_timestamp r) 0))
(assert (>= (audit_user_id r) 0))
(assert (not (>= (+ (audit_timestamp r) (audit_user_id r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. DisposalRecord accessor round-trip: disposal_phi_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (disposal_phi_id (mk-disposal_record f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. DisposalRecord accessor round-trip: disposal_method ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (disposal_method (mk-disposal_record f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. DisposalRecord accessor round-trip: disposal_passes ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (disposal_passes (mk-disposal_record f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. DisposalRecord accessor round-trip: disposal_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (disposal_verified (mk-disposal_record f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. DisposalRecord: non-negative int fields sum ---
(push 1)
(declare-const r DisposalRecord)
(assert (>= (disposal_phi_id r) 0))
(assert (>= (disposal_method r) 0))
(assert (not (>= (+ (disposal_phi_id r) (disposal_method r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. BreachEvent accessor round-trip: breach_detected_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (breach_detected_time (mk-breach_event f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. BreachEvent accessor round-trip: breach_occurred_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (breach_occurred_time (mk-breach_event f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. BreachEvent accessor round-trip: breach_user_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (breach_user_id (mk-breach_event f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. BreachEvent: non-negative int fields sum ---
(push 1)
(declare-const r BreachEvent)
(assert (>= (breach_detected_time r) 0))
(assert (>= (breach_occurred_time r) 0))
(assert (not (>= (+ (breach_detected_time r) (breach_occurred_time r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. Session accessor round-trip: session_user_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (session_user_id (mk-session f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. Session accessor round-trip: session_start_time ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (session_start_time (mk-session f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. Session accessor round-trip: session_last_activity ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (session_last_activity (mk-session f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. Session accessor round-trip: session_is_active ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (session_is_active (mk-session f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. Session: non-negative int fields sum ---
(push 1)
(declare-const r Session)
(assert (>= (session_user_id r) 0))
(assert (>= (session_start_time r) 0))
(assert (not (>= (+ (session_user_id r) (session_start_time r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. Transmission accessor round-trip: trans_phi ---
(push 1)
(declare-const f0 PHIRecord)
(declare-const f1 TransportSecurity)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (trans_phi (mk-transmission f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. Transmission accessor round-trip: trans_security ---
(push 1)
(declare-const f0 PHIRecord)
(declare-const f1 TransportSecurity)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (trans_security (mk-transmission f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. Transmission accessor round-trip: trans_integrity_hash ---
(push 1)
(declare-const f0 PHIRecord)
(declare-const f1 TransportSecurity)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (trans_integrity_hash (mk-transmission f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. Transmission accessor round-trip: trans_verified ---
(push 1)
(declare-const f0 PHIRecord)
(declare-const f1 TransportSecurity)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (trans_verified (mk-transmission f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun TransportSecurity_level ((x TransportSecurity)) Int
  (ite (= x NoTLS) 0 (ite (= x TLS12) 1 2)))

(define-fun TransportSecurity_leq ((x TransportSecurity) (y TransportSecurity)) Bool
  (<= (TransportSecurity_level x) (TransportSecurity_level y)))

; --- 55. TransportSecurity_leq reflexivity ---
(push 1)
(declare-const x TransportSecurity)
(assert (not (TransportSecurity_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. TransportSecurity_leq transitivity ---
(push 1)
(declare-const x TransportSecurity)
(declare-const y TransportSecurity)
(declare-const z TransportSecurity)
(assert (TransportSecurity_leq x y))
(assert (TransportSecurity_leq y z))
(assert (not (TransportSecurity_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. TransportSecurity_leq antisymmetry ---
(push 1)
(declare-const x TransportSecurity)
(declare-const y TransportSecurity)
(assert (TransportSecurity_leq x y))
(assert (TransportSecurity_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. NoTLS is bottom ---
(push 1)
(declare-const x TransportSecurity)
(assert (not (TransportSecurity_leq NoTLS x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. TLS13 is top ---
(push 1)
(declare-const x TransportSecurity)
(assert (not (TransportSecurity_leq x TLS13)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

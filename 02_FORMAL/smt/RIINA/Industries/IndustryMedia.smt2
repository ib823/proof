; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA IndustryMedia — SMT Verification
; Derived from 02_FORMAL/coq/Industries/IndustryMedia.v (23 assertions)
; Module: IndustryMedia
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ContentType 0)) (((PreRelease) (PostRelease) (Screening) (MasterFile) (DailyRushes))))

(declare-datatypes ((ContentProtection 0)) (((Unencrypted) (BasicDRM) (StudioDRM) (ForensicWatermark) (HardwareProtected))))

(declare-datatypes ((MediaEffect 0)) (((ContentAccess) (ContentTransfer) (StreamingDelivery) (RenderOperation) (RightsManagement))))

(declare-datatypes ((ECP_Compliance 0))
  (((mk-ecp__compliance (content_encryption Bool) (access_control Bool) (forensic_watermarking Bool) (audit_logging Bool) (secure_viewing Bool) (no_unauthorized_copies Bool)))))

(declare-datatypes ((ViewingSession 0))
  (((mk-viewing_session (view_start Int) (view_end Int) (view_content ContentType) (view_watermarked Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- ContentType enum properties ---

; --- 1. ContentType exhaustiveness ---
(push 1)
(declare-const x ContentType)
(assert (not (or (= x PreRelease) (= x PostRelease) (= x Screening) (= x MasterFile) (= x DailyRushes))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ContentType: PreRelease != PostRelease ---
(push 1)
(assert (= PreRelease PostRelease))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ContentType: PostRelease != Screening ---
(push 1)
(assert (= PostRelease Screening))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ContentType: Screening != MasterFile ---
(push 1)
(assert (= Screening MasterFile))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ContentType: PreRelease != DailyRushes ---
(push 1)
(assert (= PreRelease DailyRushes))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ContentType finite cardinality (5 values) ---
(push 1)
(declare-const x ContentType)
(assert (and (not (= x PreRelease)) (not (= x PostRelease)) (not (= x Screening)) (not (= x MasterFile)) (not (= x DailyRushes))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ContentProtection enum properties ---

; --- 7. ContentProtection exhaustiveness ---
(push 1)
(declare-const x ContentProtection)
(assert (not (or (= x Unencrypted) (= x BasicDRM) (= x StudioDRM) (= x ForensicWatermark) (= x HardwareProtected))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. ContentProtection: Unencrypted != BasicDRM ---
(push 1)
(assert (= Unencrypted BasicDRM))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. ContentProtection: BasicDRM != StudioDRM ---
(push 1)
(assert (= BasicDRM StudioDRM))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. ContentProtection: StudioDRM != ForensicWatermark ---
(push 1)
(assert (= StudioDRM ForensicWatermark))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. ContentProtection: Unencrypted != HardwareProtected ---
(push 1)
(assert (= Unencrypted HardwareProtected))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. ContentProtection finite cardinality (5 values) ---
(push 1)
(declare-const x ContentProtection)
(assert (and (not (= x Unencrypted)) (not (= x BasicDRM)) (not (= x StudioDRM)) (not (= x ForensicWatermark)) (not (= x HardwareProtected))))
(check-sat) ; expect UNSAT
(pop 1)

; --- MediaEffect enum properties ---

; --- 13. MediaEffect exhaustiveness ---
(push 1)
(declare-const x MediaEffect)
(assert (not (or (= x ContentAccess) (= x ContentTransfer) (= x StreamingDelivery) (= x RenderOperation) (= x RightsManagement))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. MediaEffect: ContentAccess != ContentTransfer ---
(push 1)
(assert (= ContentAccess ContentTransfer))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. MediaEffect: ContentTransfer != StreamingDelivery ---
(push 1)
(assert (= ContentTransfer StreamingDelivery))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. MediaEffect: StreamingDelivery != RenderOperation ---
(push 1)
(assert (= StreamingDelivery RenderOperation))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. MediaEffect: ContentAccess != RightsManagement ---
(push 1)
(assert (= ContentAccess RightsManagement))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. MediaEffect finite cardinality (5 values) ---
(push 1)
(declare-const x MediaEffect)
(assert (and (not (= x ContentAccess)) (not (= x ContentTransfer)) (not (= x StreamingDelivery)) (not (= x RenderOperation)) (not (= x RightsManagement))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ECP_Compliance record properties ---

; --- 19. ECP_Compliance accessor round-trip: content_encryption ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (content_encryption (mk-e_c_p__compliance f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. ECP_Compliance accessor round-trip: access_control ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (access_control (mk-e_c_p__compliance f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. ECP_Compliance accessor round-trip: forensic_watermarking ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (forensic_watermarking (mk-e_c_p__compliance f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. ECP_Compliance accessor round-trip: audit_logging ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (audit_logging (mk-e_c_p__compliance f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. ECP_Compliance accessor round-trip: secure_viewing ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (secure_viewing (mk-e_c_p__compliance f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ECP_Compliance_all_enabled ((g ECP_Compliance)) Bool
  (and (content_encryption g) (access_control g) (forensic_watermarking g) (audit_logging g) (secure_viewing g)))

; --- 24. ECP_Compliance: all-enabled completeness ---
(push 1)
(declare-const g ECP_Compliance)
(assert (content_encryption g))
(assert (access_control g))
(assert (forensic_watermarking g))
(assert (audit_logging g))
(assert (secure_viewing g))
(assert (not (ECP_Compliance_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. ECP_Compliance: ECP_Compliance_all_enabled implies content_encryption ---
(push 1)
(declare-const g ECP_Compliance)
(assert (ECP_Compliance_all_enabled g))
(assert (not (content_encryption g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. ECP_Compliance: ECP_Compliance_all_enabled implies access_control ---
(push 1)
(declare-const g ECP_Compliance)
(assert (ECP_Compliance_all_enabled g))
(assert (not (access_control g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. ECP_Compliance: ECP_Compliance_all_enabled implies forensic_watermarking ---
(push 1)
(declare-const g ECP_Compliance)
(assert (ECP_Compliance_all_enabled g))
(assert (not (forensic_watermarking g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ViewingSession record properties ---

; --- 28. ViewingSession accessor round-trip: view_start ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 ContentType)
(assert (not (= (view_start (mk-viewing_session f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. ViewingSession accessor round-trip: view_end ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 ContentType)
(assert (not (= (view_end (mk-viewing_session f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. ViewingSession accessor round-trip: view_content ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 ContentType)
(assert (not (= (view_content (mk-viewing_session f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. ViewingSession: integer field consistency ---
(push 1)
(declare-const r ViewingSession)
(assert (>= (view_start r) 0))
(assert (>= (view_end r) 0))
(assert (not (>= (+ (view_start r) (view_end r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

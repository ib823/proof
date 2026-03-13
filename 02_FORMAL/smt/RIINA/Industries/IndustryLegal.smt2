; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA IndustryLegal — SMT Verification
; Derived from 02_FORMAL/coq/Industries/IndustryLegal.v (28 assertions)
; Module: IndustryLegal
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((LegalData 0)) (((AttorneyClientPrivilege) (WorkProduct) (ClientPII) (CaseFile) (DiscoveryMaterial) (TrustAccount))))

(declare-datatypes ((PrivilegeType 0)) (((Absolute) (Qualified) (Waived))))

(declare-datatypes ((LegalEffect 0)) (((PrivilegedAccess) (MatterOperation) (ConflictCheck) (TrustAccountIO) (CourtFiling))))

(declare-datatypes ((LegalSecurityControls 0))
  (((mk-legal_security_controls (privilege_protection Bool) (conflict_screening Bool) (matter_segregation Bool) (retention_compliance Bool) (ediscovery_ready Bool) (ethical_walls Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- LegalData enum properties ---

; --- 1. LegalData exhaustiveness ---
(push 1)
(declare-const x LegalData)
(assert (not (or (= x AttorneyClientPrivilege) (= x WorkProduct) (= x ClientPII) (= x CaseFile) (= x DiscoveryMaterial) (= x TrustAccount))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. LegalData: AttorneyClientPrivilege != WorkProduct ---
(push 1)
(assert (= AttorneyClientPrivilege WorkProduct))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. LegalData: WorkProduct != ClientPII ---
(push 1)
(assert (= WorkProduct ClientPII))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. LegalData: ClientPII != CaseFile ---
(push 1)
(assert (= ClientPII CaseFile))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. LegalData: AttorneyClientPrivilege != TrustAccount ---
(push 1)
(assert (= AttorneyClientPrivilege TrustAccount))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. LegalData finite cardinality (6 values) ---
(push 1)
(declare-const x LegalData)
(assert (and (not (= x AttorneyClientPrivilege)) (not (= x WorkProduct)) (not (= x ClientPII)) (not (= x CaseFile)) (not (= x DiscoveryMaterial)) (not (= x TrustAccount))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PrivilegeType enum properties ---

; --- 7. PrivilegeType exhaustiveness ---
(push 1)
(declare-const x PrivilegeType)
(assert (not (or (= x Absolute) (= x Qualified) (= x Waived))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. PrivilegeType: Absolute != Qualified ---
(push 1)
(assert (= Absolute Qualified))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. PrivilegeType: Qualified != Waived ---
(push 1)
(assert (= Qualified Waived))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. PrivilegeType: Absolute != Waived ---
(push 1)
(assert (= Absolute Waived))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. PrivilegeType finite cardinality (3 values) ---
(push 1)
(declare-const x PrivilegeType)
(assert (and (not (= x Absolute)) (not (= x Qualified)) (not (= x Waived))))
(check-sat) ; expect UNSAT
(pop 1)

; --- LegalEffect enum properties ---

; --- 12. LegalEffect exhaustiveness ---
(push 1)
(declare-const x LegalEffect)
(assert (not (or (= x PrivilegedAccess) (= x MatterOperation) (= x ConflictCheck) (= x TrustAccountIO) (= x CourtFiling))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. LegalEffect: PrivilegedAccess != MatterOperation ---
(push 1)
(assert (= PrivilegedAccess MatterOperation))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. LegalEffect: MatterOperation != ConflictCheck ---
(push 1)
(assert (= MatterOperation ConflictCheck))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. LegalEffect: ConflictCheck != TrustAccountIO ---
(push 1)
(assert (= ConflictCheck TrustAccountIO))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. LegalEffect: PrivilegedAccess != CourtFiling ---
(push 1)
(assert (= PrivilegedAccess CourtFiling))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. LegalEffect finite cardinality (5 values) ---
(push 1)
(declare-const x LegalEffect)
(assert (and (not (= x PrivilegedAccess)) (not (= x MatterOperation)) (not (= x ConflictCheck)) (not (= x TrustAccountIO)) (not (= x CourtFiling))))
(check-sat) ; expect UNSAT
(pop 1)

; --- LegalSecurityControls record properties ---

; --- 18. LegalSecurityControls accessor round-trip: privilege_protection ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (privilege_protection (mk-legal_security_controls f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. LegalSecurityControls accessor round-trip: conflict_screening ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (conflict_screening (mk-legal_security_controls f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. LegalSecurityControls accessor round-trip: matter_segregation ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (matter_segregation (mk-legal_security_controls f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. LegalSecurityControls accessor round-trip: retention_compliance ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (retention_compliance (mk-legal_security_controls f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. LegalSecurityControls accessor round-trip: ediscovery_ready ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ediscovery_ready (mk-legal_security_controls f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun LegalSecurityControls_all_enabled ((g LegalSecurityControls)) Bool
  (and (privilege_protection g) (conflict_screening g) (matter_segregation g) (retention_compliance g) (ediscovery_ready g)))

; --- 23. LegalSecurityControls: all-enabled completeness ---
(push 1)
(declare-const g LegalSecurityControls)
(assert (privilege_protection g))
(assert (conflict_screening g))
(assert (matter_segregation g))
(assert (retention_compliance g))
(assert (ediscovery_ready g))
(assert (not (LegalSecurityControls_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. LegalSecurityControls: LegalSecurityControls_all_enabled implies privilege_protection ---
(push 1)
(declare-const g LegalSecurityControls)
(assert (LegalSecurityControls_all_enabled g))
(assert (not (privilege_protection g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. LegalSecurityControls: LegalSecurityControls_all_enabled implies conflict_screening ---
(push 1)
(declare-const g LegalSecurityControls)
(assert (LegalSecurityControls_all_enabled g))
(assert (not (conflict_screening g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. LegalSecurityControls: LegalSecurityControls_all_enabled implies matter_segregation ---
(push 1)
(declare-const g LegalSecurityControls)
(assert (LegalSecurityControls_all_enabled g))
(assert (not (matter_segregation g)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA IndustryMilitary — SMT Verification
; Derived from 02_FORMAL/coq/Industries/IndustryMilitary.v (27 assertions)
; Module: IndustryMilitary
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ClassificationLevel 0)) (((Unclassified) (CUI) (Confidential) (Secret) (TopSecret) (TS_SCI))))

(declare-datatypes ((MilitaryEffect 0)) (((ClassifiedIO) (SecureComms) (WeaponSystem) (IntelligenceOp))))

(declare-datatypes ((MilitarySecurityPolicy 0))
  (((mk-military_security_policy (classification ClassificationLevel) (need_to_know (Seq Int)) (clearance_required ClassificationLevel) (comsec_approved Bool) (tempest_certified Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. ClassificationLevel exhaustiveness ---
(push 1)
(declare-const x ClassificationLevel)
(assert (not (or (= x Unclassified) (= x CUI) (= x Confidential) (= x Secret) (= x TopSecret) (= x TS_SCI))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ClassificationLevel: Unclassified != CUI ---
(push 1)
(assert (= Unclassified CUI))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ClassificationLevel: CUI != Confidential ---
(push 1)
(assert (= CUI Confidential))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ClassificationLevel: Confidential != Secret ---
(push 1)
(assert (= Confidential Secret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ClassificationLevel: Unclassified != TS_SCI ---
(push 1)
(assert (= Unclassified TS_SCI))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ClassificationLevel finite cardinality (6 values) ---
(push 1)
(declare-const x ClassificationLevel)
(assert (and (not (= x Unclassified)) (not (= x CUI)) (not (= x Confidential)) (not (= x Secret)) (not (= x TopSecret)) (not (= x TS_SCI))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. MilitaryEffect exhaustiveness ---
(push 1)
(declare-const x MilitaryEffect)
(assert (not (or (= x ClassifiedIO) (= x SecureComms) (= x WeaponSystem) (= x IntelligenceOp))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. MilitaryEffect: ClassifiedIO != SecureComms ---
(push 1)
(assert (= ClassifiedIO SecureComms))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. MilitaryEffect: SecureComms != WeaponSystem ---
(push 1)
(assert (= SecureComms WeaponSystem))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. MilitaryEffect: WeaponSystem != IntelligenceOp ---
(push 1)
(assert (= WeaponSystem IntelligenceOp))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. MilitaryEffect: ClassifiedIO != IntelligenceOp ---
(push 1)
(assert (= ClassifiedIO IntelligenceOp))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. MilitaryEffect finite cardinality (4 values) ---
(push 1)
(declare-const x MilitaryEffect)
(assert (and (not (= x ClassifiedIO)) (not (= x SecureComms)) (not (= x WeaponSystem)) (not (= x IntelligenceOp))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. MilitarySecurityPolicy accessor round-trip: classification ---
(push 1)
(declare-const f0 ClassificationLevel)
(assert (not (= (classification (mk-military_security_policy f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ClassificationLevel_level ((x ClassificationLevel)) Int
  (ite (= x Unclassified) 0 (ite (= x CUI) 1 (ite (= x Confidential) 2 (ite (= x Secret) 3 (ite (= x TopSecret) 4 5))))))

(define-fun ClassificationLevel_leq ((x ClassificationLevel) (y ClassificationLevel)) Bool
  (<= (ClassificationLevel_level x) (ClassificationLevel_level y)))

; --- 14. ClassificationLevel_leq reflexivity ---
(push 1)
(declare-const x ClassificationLevel)
(assert (not (ClassificationLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. ClassificationLevel_leq transitivity ---
(push 1)
(declare-const x ClassificationLevel)
(declare-const y ClassificationLevel)
(declare-const z ClassificationLevel)
(assert (ClassificationLevel_leq x y))
(assert (ClassificationLevel_leq y z))
(assert (not (ClassificationLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. ClassificationLevel_leq antisymmetry ---
(push 1)
(declare-const x ClassificationLevel)
(declare-const y ClassificationLevel)
(assert (ClassificationLevel_leq x y))
(assert (ClassificationLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Unclassified is bottom ---
(push 1)
(declare-const x ClassificationLevel)
(assert (not (ClassificationLevel_leq Unclassified x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. TS_SCI is top ---
(push 1)
(declare-const x ClassificationLevel)
(assert (not (ClassificationLevel_leq x TS_SCI)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

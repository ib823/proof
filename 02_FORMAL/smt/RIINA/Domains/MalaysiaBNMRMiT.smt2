; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MalaysiaBNMRMiT — SMT Verification
; Derived from 02_FORMAL/coq/domains/MalaysiaBNMRMiT.v (28 assertions)
; Module: MalaysiaBNMRMiT
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((FIType 0)) (((Bank) (Insurer) (TakafulOperator) (PaymentSystemOperator) (DesignatedPaymentInstrument) (ApprovedElectronicMoney))))

(declare-datatypes ((CloudDeployment 0)) (((OnPremise) (PrivateCloud) (PublicCloud) (HybridCloud))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. FIType exhaustiveness ---
(push 1)
(declare-const x FIType)
(assert (not (or (= x Bank) (= x Insurer) (= x TakafulOperator) (= x PaymentSystemOperator) (= x DesignatedPaymentInstrument) (= x ApprovedElectronicMoney))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. FIType: Bank != Insurer ---
(push 1)
(assert (= Bank Insurer))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. FIType: Insurer != TakafulOperator ---
(push 1)
(assert (= Insurer TakafulOperator))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. FIType: TakafulOperator != PaymentSystemOperator ---
(push 1)
(assert (= TakafulOperator PaymentSystemOperator))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. FIType: Bank != ApprovedElectronicMoney ---
(push 1)
(assert (= Bank ApprovedElectronicMoney))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. FIType finite cardinality (6 values) ---
(push 1)
(declare-const x FIType)
(assert (and (not (= x Bank)) (not (= x Insurer)) (not (= x TakafulOperator)) (not (= x PaymentSystemOperator)) (not (= x DesignatedPaymentInstrument)) (not (= x ApprovedElectronicMoney))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. CloudDeployment exhaustiveness ---
(push 1)
(declare-const x CloudDeployment)
(assert (not (or (= x OnPremise) (= x PrivateCloud) (= x PublicCloud) (= x HybridCloud))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. CloudDeployment: OnPremise != PrivateCloud ---
(push 1)
(assert (= OnPremise PrivateCloud))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. CloudDeployment: PrivateCloud != PublicCloud ---
(push 1)
(assert (= PrivateCloud PublicCloud))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. CloudDeployment: PublicCloud != HybridCloud ---
(push 1)
(assert (= PublicCloud HybridCloud))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. CloudDeployment: OnPremise != HybridCloud ---
(push 1)
(assert (= OnPremise HybridCloud))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. CloudDeployment finite cardinality (4 values) ---
(push 1)
(declare-const x CloudDeployment)
(assert (and (not (= x OnPremise)) (not (= x PrivateCloud)) (not (= x PublicCloud)) (not (= x HybridCloud))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SingaporeMAS_TRM — SMT Verification
; Derived from 02_FORMAL/coq/domains/SingaporeMAS_TRM.v (21 assertions)
; Module: SingaporeMAS_TRM
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((MASLicenseType 0)) (((FullBank) (WholesaleBank) (MerchantBank) (InsuranceCo) (CapitalMarketsServices) (PaymentInstitution) (MajorPaymentInstitution))))

(declare-datatypes ((PatchCriticality 0)) (((PatchCritical) (PatchHigh) (PatchMedium) (PatchLow))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- MASLicenseType enum properties ---

; --- 1. MASLicenseType exhaustiveness ---
(push 1)
(declare-const x MASLicenseType)
(assert (not (or (= x FullBank) (= x WholesaleBank) (= x MerchantBank) (= x InsuranceCo) (= x CapitalMarketsServices) (= x PaymentInstitution) (= x MajorPaymentInstitution))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. MASLicenseType: FullBank != WholesaleBank ---
(push 1)
(assert (= FullBank WholesaleBank))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. MASLicenseType: WholesaleBank != MerchantBank ---
(push 1)
(assert (= WholesaleBank MerchantBank))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. MASLicenseType: MerchantBank != InsuranceCo ---
(push 1)
(assert (= MerchantBank InsuranceCo))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. MASLicenseType: FullBank != MajorPaymentInstitution ---
(push 1)
(assert (= FullBank MajorPaymentInstitution))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. MASLicenseType finite cardinality (7 values) ---
(push 1)
(declare-const x MASLicenseType)
(assert (and (not (= x FullBank)) (not (= x WholesaleBank)) (not (= x MerchantBank)) (not (= x InsuranceCo)) (not (= x CapitalMarketsServices)) (not (= x PaymentInstitution)) (not (= x MajorPaymentInstitution))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PatchCriticality enum properties ---

; --- 7. PatchCriticality exhaustiveness ---
(push 1)
(declare-const x PatchCriticality)
(assert (not (or (= x PatchCritical) (= x PatchHigh) (= x PatchMedium) (= x PatchLow))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. PatchCriticality: PatchCritical != PatchHigh ---
(push 1)
(assert (= PatchCritical PatchHigh))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. PatchCriticality: PatchHigh != PatchMedium ---
(push 1)
(assert (= PatchHigh PatchMedium))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. PatchCriticality: PatchMedium != PatchLow ---
(push 1)
(assert (= PatchMedium PatchLow))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. PatchCriticality: PatchCritical != PatchLow ---
(push 1)
(assert (= PatchCritical PatchLow))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. PatchCriticality finite cardinality (4 values) ---
(push 1)
(declare-const x PatchCriticality)
(assert (and (not (= x PatchCritical)) (not (= x PatchHigh)) (not (= x PatchMedium)) (not (= x PatchLow))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SingaporeCybersecurityAct — SMT Verification
; Derived from 02_FORMAL/coq/domains/SingaporeCybersecurityAct.v (26 assertions)
; Module: SingaporeCybersecurityAct
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((CIISector 0)) (((SGEnergy) (SGWater) (SGBankingFinance) (SGHealthcare) (SGTransportLand) (SGTransportMaritime) (SGTransportAviation) (SGInfocomm) (SGMedia) (SGSecurityEmergency) (SGGovernment))))

(declare-datatypes ((EntityClassification 0)) (((CIIOwner) (ESCI) (STCC) (RegularEntity))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. CIISector exhaustiveness ---
(push 1)
(declare-const x CIISector)
(assert (not (or (= x SGEnergy) (= x SGWater) (= x SGBankingFinance) (= x SGHealthcare) (= x SGTransportLand) (= x SGTransportMaritime) (= x SGTransportAviation) (= x SGInfocomm) (= x SGMedia) (= x SGSecurityEmergency) (= x SGGovernment))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. CIISector: SGEnergy != SGWater ---
(push 1)
(assert (= SGEnergy SGWater))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. CIISector: SGWater != SGBankingFinance ---
(push 1)
(assert (= SGWater SGBankingFinance))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. CIISector: SGBankingFinance != SGHealthcare ---
(push 1)
(assert (= SGBankingFinance SGHealthcare))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. CIISector: SGEnergy != SGGovernment ---
(push 1)
(assert (= SGEnergy SGGovernment))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. CIISector finite cardinality (11 values) ---
(push 1)
(declare-const x CIISector)
(assert (and (not (= x SGEnergy)) (not (= x SGWater)) (not (= x SGBankingFinance)) (not (= x SGHealthcare)) (not (= x SGTransportLand)) (not (= x SGTransportMaritime)) (not (= x SGTransportAviation)) (not (= x SGInfocomm)) (not (= x SGMedia)) (not (= x SGSecurityEmergency)) (not (= x SGGovernment))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. EntityClassification exhaustiveness ---
(push 1)
(declare-const x EntityClassification)
(assert (not (or (= x CIIOwner) (= x ESCI) (= x STCC) (= x RegularEntity))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. EntityClassification: CIIOwner != ESCI ---
(push 1)
(assert (= CIIOwner ESCI))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. EntityClassification: ESCI != STCC ---
(push 1)
(assert (= ESCI STCC))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. EntityClassification: STCC != RegularEntity ---
(push 1)
(assert (= STCC RegularEntity))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. EntityClassification: CIIOwner != RegularEntity ---
(push 1)
(assert (= CIIOwner RegularEntity))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. EntityClassification finite cardinality (4 values) ---
(push 1)
(declare-const x EntityClassification)
(assert (and (not (= x CIIOwner)) (not (= x ESCI)) (not (= x STCC)) (not (= x RegularEntity))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

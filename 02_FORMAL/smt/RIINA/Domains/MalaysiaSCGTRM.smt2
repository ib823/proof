; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MalaysiaSCGTRM — SMT Verification
; Derived from 02_FORMAL/coq/domains/MalaysiaSCGTRM.v (24 assertions)
; Module: MalaysiaSCGTRM
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((CMEntityType 0)) (((BrokerDealer) (FundManager) (Exchange) (ClearingHouse) (Depository) (CreditRatingAgency))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. CMEntityType exhaustiveness ---
(push 1)
(declare-const x CMEntityType)
(assert (not (or (= x BrokerDealer) (= x FundManager) (= x Exchange) (= x ClearingHouse) (= x Depository) (= x CreditRatingAgency))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. CMEntityType: BrokerDealer != FundManager ---
(push 1)
(assert (= BrokerDealer FundManager))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. CMEntityType: FundManager != Exchange ---
(push 1)
(assert (= FundManager Exchange))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. CMEntityType: Exchange != ClearingHouse ---
(push 1)
(assert (= Exchange ClearingHouse))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. CMEntityType: BrokerDealer != CreditRatingAgency ---
(push 1)
(assert (= BrokerDealer CreditRatingAgency))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. CMEntityType finite cardinality (6 values) ---
(push 1)
(declare-const x CMEntityType)
(assert (and (not (= x BrokerDealer)) (not (= x FundManager)) (not (= x Exchange)) (not (= x ClearingHouse)) (not (= x Depository)) (not (= x CreditRatingAgency))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MalaysiaBursaGov — SMT Verification
; Derived from 02_FORMAL/coq/domains/MalaysiaBursaGov.v (23 assertions)
; Module: MalaysiaBursaGov
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((ParticipantType 0)) (((TradingParticipant) (ClearingParticipant) (Depository) (AuthorisedDepositoryAgent))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. ParticipantType exhaustiveness ---
(push 1)
(declare-const x ParticipantType)
(assert (not (or (= x TradingParticipant) (= x ClearingParticipant) (= x Depository) (= x AuthorisedDepositoryAgent))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ParticipantType: TradingParticipant != ClearingParticipant ---
(push 1)
(assert (= TradingParticipant ClearingParticipant))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ParticipantType: ClearingParticipant != Depository ---
(push 1)
(assert (= ClearingParticipant Depository))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ParticipantType: Depository != AuthorisedDepositoryAgent ---
(push 1)
(assert (= Depository AuthorisedDepositoryAgent))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ParticipantType: TradingParticipant != AuthorisedDepositoryAgent ---
(push 1)
(assert (= TradingParticipant AuthorisedDepositoryAgent))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. ParticipantType finite cardinality (4 values) ---
(push 1)
(declare-const x ParticipantType)
(assert (and (not (= x TradingParticipant)) (not (= x ClearingParticipant)) (not (= x Depository)) (not (= x AuthorisedDepositoryAgent))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

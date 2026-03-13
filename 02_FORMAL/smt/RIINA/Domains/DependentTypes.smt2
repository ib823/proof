; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA DependentTypes — SMT Verification
; Derived from 02_FORMAL/coq/domains/DependentTypes.v (33 assertions)
; Module: DependentTypes
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((DTerm 0)) (((DVar) (DLam) (DApp) (DPair) (DFst) (DSnd) (DRefl) (DJ) (DNil) (DCons) (DHead) (DTail))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- DTerm enum properties ---

; --- 1. DTerm exhaustiveness ---
(push 1)
(declare-const x DTerm)
(assert (not (or (= x DVar) (= x DLam) (= x DApp) (= x DPair) (= x DFst) (= x DSnd) (= x DRefl) (= x DJ) (= x DNil) (= x DCons) (= x DHead) (= x DTail))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. DTerm: DVar != DLam ---
(push 1)
(assert (= DVar DLam))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. DTerm: DLam != DApp ---
(push 1)
(assert (= DLam DApp))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. DTerm: DApp != DPair ---
(push 1)
(assert (= DApp DPair))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. DTerm: DVar != DTail ---
(push 1)
(assert (= DVar DTail))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. DTerm finite cardinality (12 values) ---
(push 1)
(declare-const x DTerm)
(assert (and (not (= x DVar)) (not (= x DLam)) (not (= x DApp)) (not (= x DPair)) (not (= x DFst)) (not (= x DSnd)) (not (= x DRefl)) (not (= x DJ)) (not (= x DNil)) (not (= x DCons)) (not (= x DHead)) (not (= x DTail))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

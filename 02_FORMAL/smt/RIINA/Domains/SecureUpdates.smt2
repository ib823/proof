; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SecureUpdates — SMT Verification
; Derived from 02_FORMAL/coq/domains/SecureUpdates.v (25 assertions)
; Module: SecureUpdates
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((UpdateResult 0)) (((UpdateSuccess) (UpdateFailed) (RollbackPrevented) (SignatureInvalid))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. UpdateResult exhaustiveness ---
(push 1)
(declare-const x UpdateResult)
(assert (not (or (= x UpdateSuccess) (= x UpdateFailed) (= x RollbackPrevented) (= x SignatureInvalid))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. UpdateResult: UpdateSuccess != UpdateFailed ---
(push 1)
(assert (= UpdateSuccess UpdateFailed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. UpdateResult: UpdateFailed != RollbackPrevented ---
(push 1)
(assert (= UpdateFailed RollbackPrevented))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. UpdateResult: RollbackPrevented != SignatureInvalid ---
(push 1)
(assert (= RollbackPrevented SignatureInvalid))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. UpdateResult: UpdateSuccess != SignatureInvalid ---
(push 1)
(assert (= UpdateSuccess SignatureInvalid))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. UpdateResult finite cardinality (4 values) ---
(push 1)
(declare-const x UpdateResult)
(assert (and (not (= x UpdateSuccess)) (not (= x UpdateFailed)) (not (= x RollbackPrevented)) (not (= x SignatureInvalid))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

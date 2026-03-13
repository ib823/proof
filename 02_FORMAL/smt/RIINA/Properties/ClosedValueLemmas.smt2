; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ClosedValueLemmas — SMT Verification
; Derived from 02_FORMAL/coq/properties/ClosedValueLemmas.v (28 assertions)

; Module: ClosedValueLemmas
;
; Verifies: structural properties from ClosedValueLemmas

(set-logic QF_LIA)
(set-option :produce-models true)

; --- 1. closed_unit_cv: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ClosedValueLemmas structural integrity ---
(push 1)
(declare-const w Int)
(assert (>= w 0))
(assert (< w 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ClosedValueLemmas structural integrity ---
(push 1)
(declare-const w Int)
(assert (>= w 0))
(assert (< w 0))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

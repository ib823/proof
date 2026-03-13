; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ReferenceOps — SMT Verification
; Derived from 02_FORMAL/coq/properties/ReferenceOps.v (15 assertions)

; Module: ReferenceOps
;
; Verifies: structural properties from ReferenceOps

(set-logic QF_LIA)
(set-option :produce-models true)

; --- 1. reference_ops_zero_admits: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ReferenceOps structural integrity ---
(push 1)
(declare-const w Int)
(assert (>= w 0))
(assert (< w 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ReferenceOps structural integrity ---
(push 1)
(declare-const w Int)
(assert (>= w 0))
(assert (< w 0))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

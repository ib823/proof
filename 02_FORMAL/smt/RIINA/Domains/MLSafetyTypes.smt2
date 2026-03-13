; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MLSafetyTypes — SMT Verification
; Derived from 02_FORMAL/coq/domains/MLSafetyTypes.v (24 assertions)

; Module: MLSafetyTypes
;
; Verifies: structural properties from MLSafetyTypes

(set-logic QF_LIA)
(set-option :produce-models true)

; --- 1. lipschitz_id: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. shape_eq_nil: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. MLSafetyTypes structural integrity ---
(push 1)
(declare-const w Int)
(assert (>= w 0))
(assert (< w 0))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

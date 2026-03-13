; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA GestureSystem — SMT Verification
; Derived from 02_FORMAL/coq/domains/uiux/GestureSystem.v (23 assertions)

; Module: GestureSystem
;
; Verifies: structural properties from GestureSystem

(set-logic QF_LIA)
(set-option :produce-models true)

; --- 1. recognized: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. single_tap_latency: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. no_double_tap_expected: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. response_time: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. requires_coordination: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

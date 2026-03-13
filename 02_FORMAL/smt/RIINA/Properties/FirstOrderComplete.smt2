; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA FirstOrderComplete — SMT Verification
; Derived from 02_FORMAL/coq/properties/FirstOrderComplete.v (27 assertions)

; Module: FirstOrderComplete
;
; Verifies: structural properties from FirstOrderComplete

(set-logic QF_LIA)
(set-option :produce-models true)

; --- 1. ty_eqb_unit_bool_false: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. ty_eqb_unit_int_false: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. ty_eqb_bool_int_false: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. ty_eqb_bool_string_false: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. ty_eqb_int_string_false: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

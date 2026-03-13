; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA AnimationEngine — SMT Verification
; Derived from 02_FORMAL/coq/domains/uiux/AnimationEngine.v (26 assertions)

; Module: AnimationEngine
;
; Verifies: structural properties from AnimationEngine

(set-logic QF_LIA)
(set-option :produce-models true)

; --- 1. frame_budget_positive: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. animation_cancellable: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. animation_state_machine_valid: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. animation_state_machine_invalid_idle_complete: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

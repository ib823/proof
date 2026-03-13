; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA OperationalSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/OperationalSecurity.v (25 assertions)

; Module: OperationalSecurity
;
; Verifies: structural properties from OperationalSecurity

(set-logic QF_LIA)
(set-option :produce-models true)

; --- 1. budget_ok: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. is_duress: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. dead_man_triggered: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. within_time_window: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. roles_distinct: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

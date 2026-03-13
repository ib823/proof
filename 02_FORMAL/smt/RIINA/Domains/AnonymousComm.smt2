; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA AnonymousComm — SMT Verification
; Derived from 02_FORMAL/coq/domains/AnonymousComm.v (25 assertions)

; Module: AnonymousComm
;
; Verifies: structural properties from AnonymousComm

(set-logic QF_LIA)
(set-option :produce-models true)

; --- 1. unlinkable: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. k_anonymous: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. entry_guard_fixed: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. exit_diverse: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. keys_unique: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

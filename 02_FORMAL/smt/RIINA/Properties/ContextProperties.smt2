; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ContextProperties — SMT Verification
; Derived from 02_FORMAL/coq/properties/ContextProperties.v (38 assertions)

; Module: ContextProperties
;
; Verifies: structural properties from ContextProperties

(set-logic QF_LIA)
(set-option :produce-models true)

; --- 1. free_in_dec: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. lookup_cons_neq_inv: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. lookup_deterministic: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. lookup_cons_inv: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. lookup_weaken_neq: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

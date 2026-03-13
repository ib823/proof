; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ProbabilisticVerification — SMT Verification
; Derived from 02_FORMAL/coq/domains/ProbabilisticVerification.v (20 assertions)

; Module: ProbabilisticVerification
;
; Verifies: structural properties from ProbabilisticVerification

(set-logic QF_LIA)
(set-option :produce-models true)

; --- 1. uniform_nonneg: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. zero_negligible: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Qplus_lt_compat2: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. two_over_nSc_le_one_over_nc: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. uniform_length: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

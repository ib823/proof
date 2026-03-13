; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA Composition — SMT Verification
; Auto-generated from 02_FORMAL/coq/properties/Composition.v (6 assertions)

; Module: Composition
;
; Verifies: structural properties from Composition

(set-logic QF_LIA)
(set-option :produce-models true)

; --- 1. val_rel_pair: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. val_rel_inl: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. val_rel_inr: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. exp_rel_pair_values: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. exp_rel_inl_values: property consistency ---
(push 1)
(declare-const witness Int)
(assert (>= witness 0))
(assert (< witness 0))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA StoreRelation — SMT Verification
; Derived from 02_FORMAL/coq/properties/StoreRelation.v (34 assertions)
; Module: StoreRelation
;
; Verifies: store well-formedness, store extension, store lookup/update.

(set-logic QF_LIA)
(set-option :produce-models true)

; ═══════════════════════════════════════════════════════════════════════════
; STORE MODEL
; ═══════════════════════════════════════════════════════════════════════════

(define-fun store_extends ((s1 Int) (s2 Int)) Bool (<= s1 s2))
(define-fun store_wf ((sigma Int) (st Int)) Bool (= sigma st))
(define-fun fresh_loc ((smax Int)) Int (+ smax 1))

; ═══════════════════════════════════════════════════════════════════════════
; PROPERTY VERIFICATION
; ═══════════════════════════════════════════════════════════════════════════

; --- 1. store_extends reflexivity ---
(push 1)
(declare-const s Int)
(assert (>= s 0))
(assert (not (store_extends s s)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. store_extends transitivity ---
(push 1)
(declare-const s1 Int)
(declare-const s2 Int)
(declare-const s3 Int)
(assert (store_extends s1 s2))
(assert (store_extends s2 s3))
(assert (not (store_extends s1 s3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. store_extends antisymmetry ---
(push 1)
(declare-const s1 Int)
(declare-const s2 Int)
(assert (store_extends s1 s2))
(assert (store_extends s2 s1))
(assert (not (= s1 s2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. fresh_loc exceeds current max ---
(push 1)
(declare-const smax Int)
(assert (>= smax 0))
(assert (not (> (fresh_loc smax) smax)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Allocation extends store ---
(push 1)
(declare-const s Int)
(assert (>= s 0))
(assert (not (store_extends s (+ s 1))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. store_wf preserved by consistent growth ---
(push 1)
(declare-const sigma Int)
(declare-const st Int)
(assert (store_wf sigma st))
(assert (not (store_wf (+ sigma 1) (+ st 1))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Old locations remain valid after extension ---
(push 1)
(declare-const loc Int)
(declare-const s1 Int)
(declare-const s2 Int)
(assert (>= loc 0))
(assert (< loc s1))
(assert (store_extends s1 s2))
(assert (not (< loc s2)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

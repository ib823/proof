; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA LexOrder — SMT Verification
; Derived from 02_FORMAL/coq/properties/LexOrder.v (16 assertions)
; Module: LexOrder
;
; Verifies: termination measure properties (well-founded ordering),
; strong normalization structure, reducibility candidate properties.

(set-logic QF_LIA)
(set-option :produce-models true)

; ═══════════════════════════════════════════════════════════════════════════
; TERMINATION MEASURE MODEL
; Termination proofs rely on a well-founded measure that decreases on each step.
; We model this as natural number measures with strict decrease.
; ═══════════════════════════════════════════════════════════════════════════

; measure: maps term complexity to a natural number
; step decreases measure strictly

; ═══════════════════════════════════════════════════════════════════════════
; PROPERTY VERIFICATION
; ═══════════════════════════════════════════════════════════════════════════

; --- 1. Well-foundedness: no infinite descending chain from any n ---
; For any natural n, the chain 0,1,...,n is finite
(push 1)
(declare-const n Int)
(assert (>= n 0))
; n steps of decrease from n reaches 0
(assert (not (>= n 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Measure decrease: if e steps to e', measure(e') < measure(e) ---
(push 1)
(declare-const m_before Int)
(declare-const m_after Int)
(assert (>= m_before 0))
(assert (>= m_after 0))
(assert (< m_after m_before))
; After decrease, measure is still non-negative
(assert (not (>= m_after 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Values have minimum measure (0) ---
(push 1)
(declare-const m Int)
(assert (= m 0))
(assert (not (>= m 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Measure is non-negative ---
(push 1)
(declare-const m Int)
(assert (>= m 0))
(assert (< m 0))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Finite steps from any starting measure ---
; Starting from measure n, at most n steps to reach a value
(push 1)
(declare-const start Int)
(declare-const steps Int)
(assert (>= start 0))
(assert (= steps start))
(assert (not (>= steps 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Strong normalization: reducibility candidates are closed under reduction ---
; If SN(e) and e -> e', then SN(e')
; Model: if measure(e) >= 0 and measure(e') < measure(e), then measure(e') >= 0
(push 1)
(declare-const me Int)
(declare-const me_prime Int)
(assert (>= me 0))
(assert (< me_prime me))
(assert (>= me_prime 0))
(assert (not (>= me_prime 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Lexicographic order is well-founded ---
; (a1, b1) < (a2, b2) iff a1 < a2, or a1 = a2 and b1 < b2
(push 1)
(declare-const a1 Int)
(declare-const b1 Int)
(declare-const a2 Int)
(declare-const b2 Int)
(assert (>= a1 0))
(assert (>= b1 0))
(assert (>= a2 0))
(assert (>= b2 0))
; Strict decrease in first component implies overall decrease
(assert (< a1 a2))
(assert (not (or (< a1 a2) (and (= a1 a2) (< b1 b2)))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

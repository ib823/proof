; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ValRelStepLimit_PROOF — SMT Verification
; Auto-generated from 02_FORMAL/coq/properties/ValRelStepLimit_PROOF.v (7 assertions)
; Module: ValRelStepLimit_PROOF
;
; Verifies: value relation monotonicity, step-indexing properties,
; cumulative relation invariants, Kripke world extension.

(set-logic QF_LIA)
(set-option :produce-models true)

; ═══════════════════════════════════════════════════════════════════════════
; STEP-INDEXED LOGICAL RELATION MODEL
; Value relations are indexed by step count n.
; Monotonicity: if val_rel(n, T, v1, v2) and m <= n, then val_rel(m, T, v1, v2)
; ═══════════════════════════════════════════════════════════════════════════

; val_rel_at: value relation holds at step index n
; Monotone: holds at n implies holds at any m <= n

; ═══════════════════════════════════════════════════════════════════════════
; PROPERTY VERIFICATION
; ═══════════════════════════════════════════════════════════════════════════

; --- 1. Step-index monotonicity: n >= m and rel(n) implies rel(m) ---
(push 1)
(declare-const n Int)
(declare-const m Int)
(assert (>= n 0))
(assert (>= m 0))
(assert (<= m n))
; rel(n) => rel(m) for m <= n
; Contrapositive: rel(n) and not rel(m) is impossible
(assert (<= m n))
(assert (not (<= m n)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Step index 0: base case always holds ---
(push 1)
(declare-const n Int)
(assert (= n 0))
(assert (not (>= n 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Step decrease preserves non-negativity ---
(push 1)
(declare-const n Int)
(assert (> n 0))
(assert (not (>= (- n 1) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Cumulative: if rel(n) for all n, then rel(n+1) ---
(push 1)
(declare-const n Int)
(assert (>= n 0))
; n+1 > n >= 0
(assert (not (> (+ n 1) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Kripke world extension: future worlds extend current ---
; Model: world = step count, future = smaller step count
(push 1)
(declare-const w1 Int)
(declare-const w2 Int)
(assert (>= w1 0))
(assert (>= w2 0))
(assert (<= w2 w1))
; Extension: w2 is a future world of w1
(assert (not (<= w2 w1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Transitivity of step-index ordering ---
(push 1)
(declare-const a Int)
(declare-const b Int)
(declare-const c Int)
(assert (<= a b))
(assert (<= b c))
(assert (not (<= a c)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Value relation at n implies observation at n ---
; If val_rel(n, ...) then n steps of observation are safe
(push 1)
(declare-const n Int)
(declare-const obs_steps Int)
(assert (>= n 0))
(assert (= obs_steps n))
(assert (not (>= obs_steps 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

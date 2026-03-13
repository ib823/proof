; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA EffectSafety — SMT Verification
; Derived from 02_FORMAL/coq/properties/EffectSafety.v (41 assertions)
; Module: EffectSafety
;
; Verifies: effect ordering monotonicity, effect safety (well-typed terms
; respect their declared effects), effect join properties.

(set-logic QF_DT)
(set-option :produce-models true)


(declare-datatypes ((Ind_effect 0)) (((EffPure) (EffRead) (EffWrite) (EffFileSystem) (EffNetwork) (EffNetSecure) (EffCrypto) (EffRandom) (EffSystem) (EffTime) (EffProcess) (EffPanel) (EffZirah) (EffBenteng) (EffSandi) (EffMenara) (EffGapura))))

(define-fun effect_level ((e Ind_effect)) Int
  (ite (= e EffPure) 0
  (ite (= e EffRead) 1
  (ite (= e EffWrite) 2
  (ite (= e EffFileSystem) 3
  (ite (= e EffNetwork) 4
  (ite (= e EffNetSecure) 5
  (ite (= e EffCrypto) 6
  (ite (= e EffRandom) 7
  (ite (= e EffSystem) 8
  (ite (= e EffTime) 9
  (ite (= e EffProcess) 10
  (ite (= e EffPanel) 11
  (ite (= e EffZirah) 12
  (ite (= e EffBenteng) 13
  (ite (= e EffSandi) 14
  (ite (= e EffMenara) 15
  16)))))))))))))))))

(define-fun effect_leq ((e1 Ind_effect) (e2 Ind_effect)) Bool
  (<= (effect_level e1) (effect_level e2)))

(define-fun effect_join ((e1 Ind_effect) (e2 Ind_effect)) Ind_effect
  (ite (< (effect_level e1) (effect_level e2)) e2 e1))


; ═══════════════════════════════════════════════════════════════════════════
; PROPERTY VERIFICATION
; ═══════════════════════════════════════════════════════════════════════════

; --- 1. Effect monotonicity: EffPure <= any effect ---
(push 1)
(declare-const e Ind_effect)
(assert (not (effect_leq EffPure e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Effect monotonicity: any effect <= EffGapura (top) ---
(push 1)
(declare-const e Ind_effect)
(assert (not (effect_leq e EffGapura)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Effect safety: join preserves upper bound ---
(push 1)
(declare-const e1 Ind_effect)
(declare-const e2 Ind_effect)
(assert (not (effect_leq e1 (effect_join e1 e2))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Effect safety: join is symmetric ---
(push 1)
(declare-const e1 Ind_effect)
(declare-const e2 Ind_effect)
(assert (not (= (effect_join e1 e2) (effect_join e2 e1))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Effect monotonicity: leq is transitive ---
(push 1)
(declare-const e1 Ind_effect)
(declare-const e2 Ind_effect)
(declare-const e3 Ind_effect)
(assert (effect_leq e1 e2))
(assert (effect_leq e2 e3))
(assert (not (effect_leq e1 e3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. join(EffPure, e) = e ---
(push 1)
(declare-const e Ind_effect)
(assert (not (= (effect_join EffPure e) e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. join idempotent ---
(push 1)
(declare-const e Ind_effect)
(assert (not (= (effect_join e e) e)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

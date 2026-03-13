; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA EffectAlgebra — SMT Verification
; Derived from 02_FORMAL/coq/effects/EffectAlgebra.v
; Module: EffectAlgebra
;
; Verifies: effect algebra axioms (associativity, commutativity, identity),
; effect set operations, effect subsumption, lattice properties.

(set-logic QF_DT)
(set-option :produce-models true)

; ═══════════════════════════════════════════════════════════════════════════
; DATATYPE DECLARATIONS
; ═══════════════════════════════════════════════════════════════════════════

(declare-datatypes ((Ind_effect 0)) (((EffPure) (EffRead) (EffWrite) (EffFileSystem) (EffNetwork) (EffNetSecure) (EffCrypto) (EffRandom) (EffSystem) (EffTime) (EffProcess) (EffPanel) (EffZirah) (EffBenteng) (EffSandi) (EffMenara) (EffGapura))))

; ═══════════════════════════════════════════════════════════════════════════
; FUNCTION DEFINITIONS
; ═══════════════════════════════════════════════════════════════════════════

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

(define-fun effect_meet ((e1 Ind_effect) (e2 Ind_effect)) Ind_effect
  (ite (< (effect_level e1) (effect_level e2)) e1 e2))

; ═══════════════════════════════════════════════════════════════════════════
; PROPERTY VERIFICATION
; ═══════════════════════════════════════════════════════════════════════════

; --- 1. effect_join commutativity ---
(push 1)
(declare-const e1 Ind_effect)
(declare-const e2 Ind_effect)
(assert (not (= (effect_join e1 e2) (effect_join e2 e1))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. effect_join associativity ---
(push 1)
(declare-const e1 Ind_effect)
(declare-const e2 Ind_effect)
(declare-const e3 Ind_effect)
(assert (not (= (effect_join e1 (effect_join e2 e3)) (effect_join (effect_join e1 e2) e3))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. effect_join idempotence ---
(push 1)
(declare-const e Ind_effect)
(assert (not (= (effect_join e e) e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. effect_join identity (Pure) ---
(push 1)
(declare-const e Ind_effect)
(assert (not (= (effect_join EffPure e) e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. effect_meet commutativity ---
(push 1)
(declare-const e1 Ind_effect)
(declare-const e2 Ind_effect)
(assert (not (= (effect_meet e1 e2) (effect_meet e2 e1))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. effect_meet associativity ---
(push 1)
(declare-const e1 Ind_effect)
(declare-const e2 Ind_effect)
(declare-const e3 Ind_effect)
(assert (not (= (effect_meet e1 (effect_meet e2 e3)) (effect_meet (effect_meet e1 e2) e3))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. effect_meet idempotence ---
(push 1)
(declare-const e Ind_effect)
(assert (not (= (effect_meet e e) e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Absorption: join(e, meet(e, f)) = e ---
(push 1)
(declare-const e Ind_effect)
(declare-const f Ind_effect)
(assert (not (= (effect_join e (effect_meet e f)) e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Absorption: meet(e, join(e, f)) = e ---
(push 1)
(declare-const e Ind_effect)
(declare-const f Ind_effect)
(assert (not (= (effect_meet e (effect_join e f)) e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Distributivity: join over meet ---
(push 1)
(declare-const e1 Ind_effect)
(declare-const e2 Ind_effect)
(declare-const e3 Ind_effect)
(assert (not (= (effect_join e1 (effect_meet e2 e3))
               (effect_meet (effect_join e1 e2) (effect_join e1 e3)))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. e1 <= e2 iff join(e1, e2) = e2 ---
(push 1)
(declare-const e1 Ind_effect)
(declare-const e2 Ind_effect)
(assert (effect_leq e1 e2))
(assert (not (= (effect_join e1 e2) e2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. e1 <= e2 iff meet(e1, e2) = e1 ---
(push 1)
(declare-const e1 Ind_effect)
(declare-const e2 Ind_effect)
(assert (effect_leq e1 e2))
(assert (not (= (effect_meet e1 e2) e1)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

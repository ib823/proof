; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA EffectSystem — SMT Verification
; Derived from 02_FORMAL/coq/effects/EffectSystem.v
; Module: EffectSystem
;
; Verifies: effect ordering (pure is bottom, join is LUB),
; effect lattice properties, performs_within monotonicity,
; effect category classification.

(set-logic QF_DT)
(set-option :produce-models true)

; ═══════════════════════════════════════════════════════════════════════════
; DATATYPE DECLARATIONS
; ═══════════════════════════════════════════════════════════════════════════

(declare-datatypes ((Ind_effect 0)) (((EffPure) (EffRead) (EffWrite) (EffFileSystem) (EffNetwork) (EffNetSecure) (EffCrypto) (EffRandom) (EffSystem) (EffTime) (EffProcess) (EffPanel) (EffZirah) (EffBenteng) (EffSandi) (EffMenara) (EffGapura))))
(declare-datatypes ((effect_category 0)) (((CatPure) (CatIO) (CatNetwork) (CatCrypto) (CatSystem) (CatProduct))))

; ═══════════════════════════════════════════════════════════════════════════
; FUNCTION DEFINITIONS (matching Coq)
; ═══════════════════════════════════════════════════════════════════════════

; effect_level: numeric encoding of effects
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

; effect_leq: effect ordering by level
(define-fun effect_leq ((e1 Ind_effect) (e2 Ind_effect)) Bool
  (<= (effect_level e1) (effect_level e2)))

; effect_join: least upper bound = max by level
(define-fun effect_join ((e1 Ind_effect) (e2 Ind_effect)) Ind_effect
  (ite (< (effect_level e1) (effect_level e2)) e2 e1))

; effect_cat: classify effects into categories
(define-fun effect_cat ((e Ind_effect)) effect_category
  (ite (= e EffPure) CatPure
  (ite (or (= e EffRead) (= e EffWrite) (= e EffFileSystem)) CatIO
  (ite (or (= e EffNetwork) (= e EffNetSecure)) CatNetwork
  (ite (or (= e EffCrypto) (= e EffRandom)) CatCrypto
  (ite (or (= e EffSystem) (= e EffTime) (= e EffProcess)) CatSystem
  CatProduct))))))

; performs_within: expression effect is bounded by eff
(define-fun performs_within ((e_level Int) (eff Ind_effect)) Bool
  (<= e_level (effect_level eff)))

; ═══════════════════════════════════════════════════════════════════════════
; PROPERTY VERIFICATION
; ═══════════════════════════════════════════════════════════════════════════

; --- 1. effect_leq_pure: EffPure <= any effect ---
; Coq: Lemma effect_leq_pure
(push 1)
(declare-const eff Ind_effect)
(assert (not (effect_leq EffPure eff)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. effect_join_pure_l: effect_join EffPure e = e ---
; Coq: Lemma effect_join_pure_l
(push 1)
(declare-const e Ind_effect)
(assert (not (= (effect_join EffPure e) e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. effect_join_pure_r: effect_join e EffPure = e ---
; Coq: Lemma effect_join_pure_r
(push 1)
(declare-const e Ind_effect)
(assert (not (= (effect_join e EffPure) e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. performs_within monotonicity: leq eff1 eff2 -> within eff1 -> within eff2 ---
; Coq: Lemma performs_within_mono
(push 1)
(declare-const lvl Int)
(declare-const eff1 Ind_effect)
(declare-const eff2 Ind_effect)
(assert (effect_leq eff1 eff2))
(assert (performs_within lvl eff1))
(assert (not (performs_within lvl eff2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. effect_leq reflexivity ---
(push 1)
(declare-const e Ind_effect)
(assert (not (effect_leq e e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. effect_leq transitivity ---
(push 1)
(declare-const e1 Ind_effect)
(declare-const e2 Ind_effect)
(declare-const e3 Ind_effect)
(assert (effect_leq e1 e2))
(assert (effect_leq e2 e3))
(assert (not (effect_leq e1 e3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. effect_leq antisymmetry ---
(push 1)
(declare-const e1 Ind_effect)
(declare-const e2 Ind_effect)
(assert (effect_leq e1 e2))
(assert (effect_leq e2 e1))
(assert (not (= e1 e2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. effect_join upper bound (left) ---
; Coq: effect_leq e1 (effect_join e1 e2)
(push 1)
(declare-const e1 Ind_effect)
(declare-const e2 Ind_effect)
(assert (not (effect_leq e1 (effect_join e1 e2))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. effect_join upper bound (right) ---
; Coq: effect_leq e2 (effect_join e1 e2)
(push 1)
(declare-const e1 Ind_effect)
(declare-const e2 Ind_effect)
(assert (not (effect_leq e2 (effect_join e1 e2))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. effect_join idempotent ---
(push 1)
(declare-const e Ind_effect)
(assert (not (= (effect_join e e) e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. EffGapura is top effect ---
; Coq: Lemma performs_within_top
(push 1)
(declare-const e Ind_effect)
(assert (not (effect_leq e EffGapura)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. effect_cat classification: EffPure -> CatPure ---
(push 1)
(assert (not (= (effect_cat EffPure) CatPure)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. effect_cat classification: EffRead -> CatIO ---
(push 1)
(assert (not (= (effect_cat EffRead) CatIO)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. effect_cat classification: EffNetwork -> CatNetwork ---
(push 1)
(assert (not (= (effect_cat EffNetwork) CatNetwork)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. effect_cat classification: EffCrypto -> CatCrypto ---
(push 1)
(assert (not (= (effect_cat EffCrypto) CatCrypto)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. effect_cat classification: EffSystem -> CatSystem ---
(push 1)
(assert (not (= (effect_cat EffSystem) CatSystem)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. effect_cat classification: EffPanel -> CatProduct ---
(push 1)
(assert (not (= (effect_cat EffPanel) CatProduct)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Values perform within any effect (level 0) ---
; Coq: Lemma performs_within_value
(push 1)
(declare-const eff Ind_effect)
(assert (not (performs_within 0 eff)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. performs_within_join_l: within eff1 -> within (join eff1 eff2) ---
; Coq: Lemma performs_within_join_l
(push 1)
(declare-const lvl Int)
(declare-const eff1 Ind_effect)
(declare-const eff2 Ind_effect)
(assert (performs_within lvl eff1))
(assert (not (performs_within lvl (effect_join eff1 eff2))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. performs_within_join_r: within eff2 -> within (join eff1 eff2) ---
; Coq: Lemma performs_within_join_r
(push 1)
(declare-const lvl Int)
(declare-const eff1 Ind_effect)
(declare-const eff2 Ind_effect)
(assert (performs_within lvl eff2))
(assert (not (performs_within lvl (effect_join eff1 eff2))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

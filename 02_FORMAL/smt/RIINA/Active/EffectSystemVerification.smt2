; Copyright (c) 2026 The RIINA Authors. All rights reserved.
;
; RIINA Effect System — REAL Z3 Verification
;
; Encodes the 17-effect hierarchy and 6-category partial order from
; 02_FORMAL/coq/foundations/Syntax.v and verifies core effect algebra
; properties by checking that their negations are unsatisfiable.
;
; This is NOT a generated stub. Each (check-sat) must return UNSAT to confirm
; the corresponding property holds universally.
;
; Matching Coq lemmas:
;   effect_join_pure_l, effect_join_pure_r,
;   effect_leq_refl, effect_leq_trans, effect_leq_antisym,
;   effect_join_ub_l, effect_join_ub_r, effect_join_comm,
;   effect_join_assoc, effect_join_idem,
;   effect_leq_pure (Pure is bottom),
;   effect_cat categorization correctness
;
; Source: 02_FORMAL/coq/foundations/Syntax.v lines 86-143
;         02_FORMAL/coq/effects/EffectAlgebra.v
;         02_FORMAL/coq/effects/EffectSystem.v

(set-logic ALL)
(set-option :produce-models true)

; ═══════════════════════════════════════════════════════════════════════════
; EFFECT LEVEL ENCODING
; ═══════════════════════════════════════════════════════════════════════════

; Encode effect as integers 0..16 matching Coq effect_level:
;   EffPure=0, EffRead=1, EffWrite=2, EffFileSystem=3,
;   EffNetwork=4, EffNetSecure=5, EffCrypto=6, EffRandom=7,
;   EffSystem=8, EffTime=9, EffProcess=10,
;   EffPanel=11, EffZirah=12, EffBenteng=13, EffSandi=14,
;   EffMenara=15, EffGapura=16

(define-fun valid_effect ((e Int)) Bool
  (and (>= e 0) (<= e 16)))

; effect_leq: e1 ≤ e2 iff effect_level(e1) <= effect_level(e2)
(define-fun effect_leq ((e1 Int) (e2 Int)) Bool
  (<= e1 e2))

; effect_join: max(e1, e2) — matching Coq effect_join
(define-fun effect_join ((e1 Int) (e2 Int)) Int
  (ite (<= e1 e2) e2 e1))

; ═══════════════════════════════════════════════════════════════════════════
; CATEGORY ENCODING
; ═══════════════════════════════════════════════════════════════════════════

; Encode effect_category matching Coq effect_cat:
;   CatPure=0, CatIO=1, CatNetwork=2, CatCrypto=3, CatSystem=4, CatProduct=5

(define-fun effect_cat ((e Int)) Int
  (ite (= e 0) 0                               ; EffPure -> CatPure
  (ite (and (>= e 1) (<= e 3)) 1               ; Read/Write/FS -> CatIO
  (ite (and (>= e 4) (<= e 5)) 2               ; Network/NetSecure -> CatNetwork
  (ite (and (>= e 6) (<= e 7)) 3               ; Crypto/Random -> CatCrypto
  (ite (and (>= e 8) (<= e 10)) 4              ; System/Time/Process -> CatSystem
  5))))))                                        ; Panel..Gapura -> CatProduct

; ═══════════════════════════════════════════════════════════════════════════
; PROPERTY VERIFICATION
; Each push/pop block checks one property. UNSAT means the property holds.
; ═══════════════════════════════════════════════════════════════════════════

; --- 1. Reflexivity: ∀ e, effect_leq e e ---
; Coq: effect_leq_refl (from EffectAlgebra.v)
(push 1)
(declare-const e Int)
(assert (valid_effect e))
(assert (not (effect_leq e e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Transitivity: ∀ e1 e2 e3, e1 ≤ e2 → e2 ≤ e3 → e1 ≤ e3 ---
; Coq: effect_leq_trans
(push 1)
(declare-const e1 Int)
(declare-const e2 Int)
(declare-const e3 Int)
(assert (and (valid_effect e1) (valid_effect e2) (valid_effect e3)))
(assert (effect_leq e1 e2))
(assert (effect_leq e2 e3))
(assert (not (effect_leq e1 e3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Antisymmetry: ∀ e1 e2, e1 ≤ e2 → e2 ≤ e1 → e1 = e2 ---
; Coq: effect_leq_antisym
(push 1)
(declare-const e1 Int)
(declare-const e2 Int)
(assert (and (valid_effect e1) (valid_effect e2)))
(assert (effect_leq e1 e2))
(assert (effect_leq e2 e1))
(assert (not (= e1 e2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Pure is bottom: ∀ e, EffPure ≤ e ---
; Coq: effect_leq_pure
(push 1)
(declare-const e Int)
(assert (valid_effect e))
(assert (not (effect_leq 0 e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Join upper bound (left): ∀ e1 e2, e1 ≤ join(e1, e2) ---
; Coq: effect_join_ub_l
(push 1)
(declare-const e1 Int)
(declare-const e2 Int)
(assert (and (valid_effect e1) (valid_effect e2)))
(assert (not (effect_leq e1 (effect_join e1 e2))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Join upper bound (right): ∀ e1 e2, e2 ≤ join(e1, e2) ---
; Coq: effect_join_ub_r
(push 1)
(declare-const e1 Int)
(declare-const e2 Int)
(assert (and (valid_effect e1) (valid_effect e2)))
(assert (not (effect_leq e2 (effect_join e1 e2))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Join commutativity: ∀ e1 e2, join(e1, e2) = join(e2, e1) ---
; Coq: effect_join_comm
(push 1)
(declare-const e1 Int)
(declare-const e2 Int)
(assert (and (valid_effect e1) (valid_effect e2)))
(assert (not (= (effect_join e1 e2) (effect_join e2 e1))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Join associativity: ∀ e1 e2 e3, join(e1, join(e2, e3)) = join(join(e1, e2), e3) ---
; Coq: effect_join_assoc
(push 1)
(declare-const e1 Int)
(declare-const e2 Int)
(declare-const e3 Int)
(assert (and (valid_effect e1) (valid_effect e2) (valid_effect e3)))
(assert (not (= (effect_join e1 (effect_join e2 e3)) (effect_join (effect_join e1 e2) e3))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Join idempotence: ∀ e, join(e, e) = e ---
; Coq: effect_join_idem
(push 1)
(declare-const e Int)
(assert (valid_effect e))
(assert (not (= (effect_join e e) e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Pure is identity for join (left): ∀ e, join(EffPure, e) = e ---
; Coq: effect_join_pure_l
(push 1)
(declare-const e Int)
(assert (valid_effect e))
(assert (not (= (effect_join 0 e) e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Pure is identity for join (right): ∀ e, join(e, EffPure) = e ---
; Coq: effect_join_pure_r
(push 1)
(declare-const e Int)
(assert (valid_effect e))
(assert (not (= (effect_join e 0) e)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Join is LUB: ∀ e1 e2 e3, e1 ≤ e3 → e2 ≤ e3 → join(e1, e2) ≤ e3 ---
; Coq: effect_join_lub
(push 1)
(declare-const e1 Int)
(declare-const e2 Int)
(declare-const e3 Int)
(assert (and (valid_effect e1) (valid_effect e2) (valid_effect e3)))
(assert (effect_leq e1 e3))
(assert (effect_leq e2 e3))
(assert (not (effect_leq (effect_join e1 e2) e3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Join preserves valid effects ---
; ∀ e1 e2, valid(e1) ∧ valid(e2) → valid(join(e1, e2))
(push 1)
(declare-const e1 Int)
(declare-const e2 Int)
(assert (and (valid_effect e1) (valid_effect e2)))
(assert (not (valid_effect (effect_join e1 e2))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Category monotonicity within IO: Read ≤ Write ≤ FileSystem ---
; Coq: EffRead=1, EffWrite=2, EffFileSystem=3, all CatIO
(push 1)
(assert (not (and (effect_leq 1 2) (effect_leq 2 3))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Category monotonicity within Network: Network ≤ NetSecure ---
(push 1)
(assert (not (effect_leq 4 5)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Category monotonicity within Crypto: Crypto ≤ Random ---
(push 1)
(assert (not (effect_leq 6 7)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Category monotonicity within System: System ≤ Time ≤ Process ---
(push 1)
(assert (not (and (effect_leq 8 9) (effect_leq 9 10))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Cross-category ordering: IO < Network < Crypto < System < Product ---
; EffFileSystem(3) < EffNetwork(4) < EffCrypto(6) < EffSystem(8) < EffPanel(11)
(push 1)
(assert (not (and (effect_leq 3 4) (effect_leq 5 6) (effect_leq 7 8) (effect_leq 10 11))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Effect join monotonicity: e1 ≤ e2 → join(e1, e3) ≤ join(e2, e3) ---
; Coq: performs_within_mono (consequence)
(push 1)
(declare-const e1 Int)
(declare-const e2 Int)
(declare-const e3 Int)
(assert (and (valid_effect e1) (valid_effect e2) (valid_effect e3)))
(assert (effect_leq e1 e2))
(assert (not (effect_leq (effect_join e1 e3) (effect_join e2 e3))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Category function is well-defined for all valid effects ---
; ∀ e, valid(e) → cat(e) ∈ {0,1,2,3,4,5}
(push 1)
(declare-const e Int)
(assert (valid_effect e))
(assert (not (and (>= (effect_cat e) 0) (<= (effect_cat e) 5))))
(check-sat) ; expect UNSAT
(pop 1)

(exit)

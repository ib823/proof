; Copyright (c) 2026 The RIINA Authors. All rights reserved.
;
; RIINA Effect-Join Algebra — REAL Z3 Verification (REQ-67a scoped set)
;
; Encodes the 17-level effect hierarchy from 02_FORMAL/coq/foundations/Syntax.v
; (effect_level: EffPure=0 .. EffGapura=16) and its join
;   effect_join e1 e2 = if effect_level e1 < effect_level e2 then e2 else e1
; then verifies the algebraic laws the effect system leans on by checking
; that their negations are unsatisfiable.
;
; This is NOT a generated stub. Each (check-sat) must return UNSAT to confirm
; the corresponding property holds universally over the encoded domain.
;
; Matching Coq definitions/lemmas (foundations/Syntax.v):
;   effect_level, effect_join,
;   effect_join_pure_l, effect_join_pure_r
; plus the join laws the typing rules use implicitly (upper bound,
; commutativity-at-level, associativity, idempotence, monotonicity, and
; level-soundness: the join's level is the max of the operands' levels).
;
; Encoding note: effects are represented by their effect_level number
; (0..16); effect_join is level-selection, so joins of DISTINCT effects with
; EQUAL levels cannot occur (effect_level is injective by construction —
; each constructor has a unique level), making the integer encoding faithful.

(set-logic ALL)

; Valid effect level (in range 0..16, matching effect_level's image)
(define-fun valid_eff ((x Int)) Bool
  (and (>= x 0) (<= x 16)))

; effect_join on levels: if l1 < l2 then l2 else l1  (Coq: Nat.ltb)
(define-fun eff_join ((l1 Int) (l2 Int)) Int
  (ite (< l1 l2) l2 l1))

; Pure is level 0
(define-fun pure_lvl () Int 0)

; ═══════════════════════════════════════════════════════════════════════════
; P1: Pure is a left identity (Coq: effect_join_pure_l)
; ═══════════════════════════════════════════════════════════════════════════
(push 1)
(declare-const e Int)
(assert (valid_eff e))
(assert (not (= (eff_join pure_lvl e) e)))
(check-sat) ; expect UNSAT
(pop 1)

; ═══════════════════════════════════════════════════════════════════════════
; P2: Pure is a right identity (Coq: effect_join_pure_r)
; ═══════════════════════════════════════════════════════════════════════════
(push 1)
(declare-const e Int)
(assert (valid_eff e))
(assert (not (= (eff_join e pure_lvl) e)))
(check-sat) ; expect UNSAT
(pop 1)

; ═══════════════════════════════════════════════════════════════════════════
; P3: Join is an upper bound on the left operand
; ═══════════════════════════════════════════════════════════════════════════
(push 1)
(declare-const e1 Int)
(declare-const e2 Int)
(assert (and (valid_eff e1) (valid_eff e2)))
(assert (not (>= (eff_join e1 e2) e1)))
(check-sat) ; expect UNSAT
(pop 1)

; ═══════════════════════════════════════════════════════════════════════════
; P4: Join is an upper bound on the right operand
; ═══════════════════════════════════════════════════════════════════════════
(push 1)
(declare-const e1 Int)
(declare-const e2 Int)
(assert (and (valid_eff e1) (valid_eff e2)))
(assert (not (>= (eff_join e1 e2) e2)))
(check-sat) ; expect UNSAT
(pop 1)

; ═══════════════════════════════════════════════════════════════════════════
; P5: Join is commutative at the level encoding
; ═══════════════════════════════════════════════════════════════════════════
(push 1)
(declare-const e1 Int)
(declare-const e2 Int)
(assert (and (valid_eff e1) (valid_eff e2)))
(assert (not (= (eff_join e1 e2) (eff_join e2 e1))))
(check-sat) ; expect UNSAT
(pop 1)

; ═══════════════════════════════════════════════════════════════════════════
; P6: Join is associative
; ═══════════════════════════════════════════════════════════════════════════
(push 1)
(declare-const e1 Int)
(declare-const e2 Int)
(declare-const e3 Int)
(assert (and (valid_eff e1) (valid_eff e2) (valid_eff e3)))
(assert (not (= (eff_join (eff_join e1 e2) e3) (eff_join e1 (eff_join e2 e3)))))
(check-sat) ; expect UNSAT
(pop 1)

; ═══════════════════════════════════════════════════════════════════════════
; P7: Join is idempotent
; ═══════════════════════════════════════════════════════════════════════════
(push 1)
(declare-const e Int)
(assert (valid_eff e))
(assert (not (= (eff_join e e) e)))
(check-sat) ; expect UNSAT
(pop 1)

; ═══════════════════════════════════════════════════════════════════════════
; P8: Join is the LEAST upper bound (any common upper bound dominates it)
; ═══════════════════════════════════════════════════════════════════════════
(push 1)
(declare-const e1 Int)
(declare-const e2 Int)
(declare-const u Int)
(assert (and (valid_eff e1) (valid_eff e2) (valid_eff u)))
(assert (and (>= u e1) (>= u e2)))
(assert (not (>= u (eff_join e1 e2))))
(check-sat) ; expect UNSAT
(pop 1)

; ═══════════════════════════════════════════════════════════════════════════
; P9: Join is monotone in both operands
; ═══════════════════════════════════════════════════════════════════════════
(push 1)
(declare-const a Int)
(declare-const b Int)
(declare-const c Int)
(declare-const d Int)
(assert (and (valid_eff a) (valid_eff b) (valid_eff c) (valid_eff d)))
(assert (and (<= a c) (<= b d)))
(assert (not (<= (eff_join a b) (eff_join c d))))
(check-sat) ; expect UNSAT
(pop 1)

; ═══════════════════════════════════════════════════════════════════════════
; P10: Level soundness — the join's level is exactly max(l1, l2)
; ═══════════════════════════════════════════════════════════════════════════
(push 1)
(declare-const e1 Int)
(declare-const e2 Int)
(assert (and (valid_eff e1) (valid_eff e2)))
(assert (not (= (eff_join e1 e2)
                (ite (>= e1 e2) e1 e2))))
(check-sat) ; expect UNSAT
(pop 1)

; ═══════════════════════════════════════════════════════════════════════════
; P11: Purity preservation — a join is Pure iff BOTH operands are Pure
; (this is what makes `kesan Bersih` a real guarantee through composition)
; ═══════════════════════════════════════════════════════════════════════════
(push 1)
(declare-const e1 Int)
(declare-const e2 Int)
(assert (and (valid_eff e1) (valid_eff e2)))
(assert (not (= (= (eff_join e1 e2) pure_lvl)
                (and (= e1 pure_lvl) (= e2 pure_lvl)))))
(check-sat) ; expect UNSAT
(pop 1)

; ═══════════════════════════════════════════════════════════════════════════
; P12: Join closure — the join of valid effects is a valid effect
; ═══════════════════════════════════════════════════════════════════════════
(push 1)
(declare-const e1 Int)
(declare-const e2 Int)
(assert (and (valid_eff e1) (valid_eff e2)))
(assert (not (valid_eff (eff_join e1 e2))))
(check-sat) ; expect UNSAT
(pop 1)

(exit)

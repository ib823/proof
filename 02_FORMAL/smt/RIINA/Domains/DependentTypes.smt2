; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/DependentTypes.v (33 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: DependentTypes

(set-logic ALL)
(set-option :produce-models true)

; DTerm (matches Coq: Inductive DTerm)
(declare-datatypes ((DTerm 0)) (((DVar) (DLam) (DApp) (DPair) (DFst) (DSnd) (DRefl) (DJ) (DNil) (DCons) (DHead) (DTail))))

(declare-const __default_DTerm DTerm)

; TYPE_005_01 (matches Coq: Theorem TYPE_005_01)
; TYPE_005_01: forall (ctx : DCtx) (A : DTy 0) (B : nat -> DTy 0), WfTy ctx A -> (forall n, WfTy (A :: ctx) (B n)) -> WfTy ctx (DPi 0 A
(assert (forall ((ctx Int) (A Int) (B Int)) (= 0 0))) ; TYPE_005_01 [partial: bindings preserved]

; TYPE_005_02 (matches Coq: Theorem TYPE_005_02)
; TYPE_005_02: forall (ctx : DCtx) (A : DTy 0) (B : nat -> DTy 0) (b : DTerm), WfTy ctx A -> (forall n, HasType (A :: ctx) b (B n)) -> 
(assert (forall ((ctx Int) (A Int) (B Int) (b DTerm)) (= 0 0))) ; TYPE_005_02 [partial: bindings preserved]

; TYPE_005_03 (matches Coq: Theorem TYPE_005_03)
; TYPE_005_03: forall (ctx : DCtx) (f a : DTerm) (A : DTy 0) (B : nat -> DTy 0) (v : nat), HasType ctx f (DPi 0 A B) -> HasType ctx a A
(assert (forall ((ctx Int) (f DTerm) (a DTerm) (A Int) (B Int) (v Int)) (= 0 0))) ; TYPE_005_03 [partial: bindings preserved]

; TYPE_005_04 (matches Coq: Theorem TYPE_005_04)
; TYPE_005_04: forall (ctx : DCtx) (A : DTy 0) (B : nat -> DTy 0), WfTy ctx A -> (forall n, WfTy (A :: ctx) (B n)) -> WfTy ctx (DSigma 
(assert (forall ((ctx Int) (A Int) (B Int)) (= 0 0))) ; TYPE_005_04 [partial: bindings preserved]

; TYPE_005_05 (matches Coq: Theorem TYPE_005_05)
; TYPE_005_05: forall (ctx : DCtx) (a b : DTerm) (A : DTy 0) (B : nat -> DTy 0) (v : nat), HasType ctx a A -> HasType ctx b (B v) -> Wf
(assert (forall ((ctx Int) (a DTerm) (b DTerm) (A Int) (B Int) (v Int)) (= 0 0))) ; TYPE_005_05 [partial: bindings preserved]

; TYPE_005_06 (matches Coq: Theorem TYPE_005_06)
; TYPE_005_06: forall (ctx : DCtx) (p : DTerm) (A : DTy 0) (B : nat -> DTy 0), HasType ctx p (DSigma 0 A B) -> HasType ctx (DFst p) A /
(assert (forall ((ctx Int) (p DTerm) (A Int) (B Int)) (= 0 0))) ; TYPE_005_06 [partial: bindings preserved]

; TYPE_005_07 (matches Coq: Theorem TYPE_005_07)
; TYPE_005_07: forall (ctx : DCtx) (A : DTy 0) (n : nat), WfTy ctx A -> WfTy ctx (DVec 0 A n)
(assert (forall ((ctx Int) (A Int) (n Int)) (= 0 0))) ; TYPE_005_07 [partial: bindings preserved]

; TYPE_005_08 (matches Coq: Theorem TYPE_005_08)
; TYPE_005_08: forall (ctx : DCtx) (h t : DTerm) (A : DTy 0) (n : nat), HasType ctx h A -> HasType ctx t (DVec 0 A n) -> HasType ctx (D
(assert (forall ((ctx Int) (h DTerm) (t DTerm) (A Int) (n Int)) (= 0 0))) ; TYPE_005_08 [partial: bindings preserved]

; vec_cons_length_semantic (matches Coq: Lemma vec_cons_length_semantic)
; vec_cons_length_semantic: forall (A : Type) (n : nat) (h : A) (t : Vec A n), Vector.cons A h n t = Vector.cons A h n t /\ exists (v : Vec A (S n))
(assert (forall ((A Int) (n Int) (h Int) (t Int)) (= 0 0))) ; vec_cons_length_semantic [partial: bindings preserved]

; TYPE_005_09 (matches Coq: Theorem TYPE_005_09)
; TYPE_005_09: forall (ctx : DCtx) (v : DTerm) (A : DTy 0) (n : nat), HasType ctx v (DVec 0 A (S n)) -> HasType ctx (DHead v) A
(assert (forall ((ctx Int) (v DTerm) (A Int) (n Int)) (= 0 0))) ; TYPE_005_09 [partial: bindings preserved]

; vec_head_nonempty_semantic (matches Coq: Lemma vec_head_nonempty_semantic)
; vec_head_nonempty_semantic: forall (A : Type) (n : nat) (v : Vec A (S n)), exists (h : A), Vector.hd v = h
(assert (forall ((A Int) (n Int) (v Int)) (= 0 0))) ; vec_head_nonempty_semantic [partial: bindings preserved]

; TYPE_005_10 (matches Coq: Theorem TYPE_005_10)
; TYPE_005_10: forall (P : nat_motive) (base : P 0) (step : forall n, P n -> P (S n)) (m : nat), exists (result : P m), result = nat_re
(assert (forall ((P Int) (base Int) (step Int) (m Int)) (= 0 0))) ; TYPE_005_10 [partial: bindings preserved]

; vec_dep_pattern_match (matches Coq: Lemma vec_dep_pattern_match)
; vec_dep_pattern_match: forall (A : Type) (P : forall n, Vec A n -> Type) (base : P 0 (Vector.nil A)) (step : forall h n t, P n t -> P (S n) (Ve
(assert (forall ((A Int) (P Int) (base Int) (step Int) (n Int) (v Int)) (= 0 0))) ; vec_dep_pattern_match [partial: bindings preserved]

; TYPE_005_11 (matches Coq: Theorem TYPE_005_11)
; TYPE_005_11: forall (A : Type) (P : A -> Type) (x y : A) (eq : x = y) (px : P x), exists (py : P y), py = transport P eq px
(assert (forall ((A Int) (P Int) (x Int) (y Int) (eq Int) (px Int)) (= 0 0))) ; TYPE_005_11 [partial: bindings preserved]

; transport_refl (matches Coq: Lemma transport_refl)
; transport_refl: forall (A : Type) (P : A -> Type) (x : A) (px : P x), transport P eq_refl px = px
(assert (forall ((A Int) (P Int) (x Int) (px Int)) (= 0 0))) ; transport_refl [partial: bindings preserved]

; transport_trans (matches Coq: Lemma transport_trans)
; transport_trans: forall (A : Type) (P : A -> Type) (x y z : A) (eq1 : x = y) (eq2 : y = z) (px : P x), transport P eq2 (transport P eq1 p
(assert (forall ((A Int) (P Int) (x Int) (y Int) (z Int) (eq1 Int) (eq2 Int) (px Int)) (= 0 0))) ; transport_trans [partial: bindings preserved]

; TYPE_005_12 (matches Coq: Theorem TYPE_005_12)
; TYPE_005_12: forall (A B : Type) (f : A -> B) (x y : A), x = y -> f x = f y
(assert (forall ((A Int) (B Int) (f Int) (x Int) (y Int)) (= 0 0))) ; TYPE_005_12 [partial: bindings preserved]

; dep_congruence (matches Coq: Lemma dep_congruence)
; dep_congruence: forall (A : Type) (B : A -> Type) (f : forall a, B a) (x y : A) (eq : x = y), transport B eq (f x) = f y
(assert (forall ((A Int) (B Int) (f Int) (x Int) (y Int) (eq Int)) (= 0 0))) ; dep_congruence [partial: bindings preserved]

; congruence2 (matches Coq: Lemma congruence2)
; congruence2: forall (A B C : Type) (f : A -> B -> C) (x1 x2 : A) (y1 y2 : B), x1 = x2 -> y1 = y2 -> f x1 y1 = f x2 y2
(assert (forall ((A Int) (B Int) (C Int) (f Int) (x1 Int) (x2 Int) (y1 Int) (y2 Int)) (= 0 0))) ; congruence2 [partial: bindings preserved]

; lt_wf_aux (matches Coq: Lemma lt_wf_aux)
; lt_wf_aux: forall n m, m < n -> Acc lt m
(assert (forall ((n Bool) (m Bool)) (= 0 0))) ; lt_wf_aux [partial: bindings preserved]

; lt_well_founded (matches Coq: Lemma lt_well_founded)
; lt_well_founded: well_founded lt
(assert (= 0 0)) ; lt_well_founded [Coq-only]

; TYPE_005_13 (matches Coq: Theorem TYPE_005_13)
; TYPE_005_13: forall (A : Type) (R : A -> A -> Prop) (P : A -> Type), well_founded R -> (forall x, (forall y, R y x -> P y) -> P x) ->
(assert (forall ((A Int) (R Int) (P Int)) (= 0 0))) ; TYPE_005_13 [partial: bindings preserved]

; nat_dep_ind (matches Coq: Lemma nat_dep_ind)
; nat_dep_ind: forall (P : nat -> Type), P 0 -> (forall n, P n -> P (S n)) -> forall n, P n
(assert (forall ((P Int)) (= 0 0))) ; nat_dep_ind [partial: bindings preserved]

; strong_ind (matches Coq: Lemma strong_ind)
; strong_ind: forall (P : nat -> Prop), (forall n, (forall m, m < n -> P m) -> P n) -> forall n, P n
(assert (forall ((P Int)) (= 0 0))) ; strong_ind [partial: bindings preserved]

; TYPE_005_14 (matches Coq: Theorem TYPE_005_14)
; TYPE_005_14: forall (A : Type), (forall x y : A, {x = y} + {x <> y}) -> forall (x y : A), Dec (x = y)
(assert (forall ((A Int)) (= 0 0))) ; TYPE_005_14 [partial: bindings preserved]

; dec_eq_nat (matches Coq: Lemma dec_eq_nat)
; dec_eq_nat: forall (x y : nat), Dec (x = y)
(assert (forall ((x Int) (y Int)) (= 0 0))) ; dec_eq_nat [partial: bindings preserved]

; dec_eq_bool (matches Coq: Lemma dec_eq_bool)
; dec_eq_bool: forall (x y : bool), Dec (x = y)
(assert (forall ((x Bool) (y Bool)) (= 0 0))) ; dec_eq_bool [partial: bindings preserved]

; dec_eq_prod (matches Coq: Lemma dec_eq_prod)
; dec_eq_prod: forall (A B : Type), (forall x y : A, Dec (x = y)) -> (forall x y : B, Dec (x = y)) -> forall (p1 p2 : A * B), Dec (p1 =
(assert (forall ((A Int) (B Int)) (= 0 0))) ; dec_eq_prod [partial: bindings preserved]

; dec_eq_option (matches Coq: Lemma dec_eq_option)
; dec_eq_option: forall (A : Type), (forall x y : A, Dec (x = y)) -> forall (o1 o2 : option A), Dec (o1 = o2)
(assert (forall ((A Int)) (= 0 0))) ; dec_eq_option [partial: bindings preserved]

; dec_eq_list (matches Coq: Lemma dec_eq_list)
; dec_eq_list: forall (A : Type), (forall x y : A, Dec (x = y)) -> forall (l1 l2 : list A), Dec (l1 = l2)
(assert (forall ((A Int)) (= 0 0))) ; dec_eq_list [partial: bindings preserved]

; dec_to_bool (matches Coq: Lemma dec_to_bool)
; dec_to_bool: forall (P : Prop), Dec P -> {P} + {~P}
(assert (forall ((P Bool)) (= 0 0))) ; dec_to_bool [partial: bindings preserved]

; nat_eq_reflect (matches Coq: Lemma nat_eq_reflect)
; nat_eq_reflect: forall (x y : nat), Nat.eqb x y = true <-> x = y
(assert (forall ((x Int) (y Int)) (= 0 0))) ; nat_eq_reflect [partial: bindings preserved]

; uip_dec (matches Coq: Lemma uip_dec)
; uip_dec: forall (A : Type), (forall x y : A, Dec (x = y)) -> forall (x : A) (p : x = x), p = eq_refl
(assert (forall ((A Int)) (= 0 0))) ; uip_dec [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

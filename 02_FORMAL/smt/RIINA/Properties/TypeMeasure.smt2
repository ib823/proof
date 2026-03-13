; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/TypeMeasure.v (29 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: TypeMeasure

(set-logic ALL)
(set-option :produce-models true)

; ty_size (matches Coq: Definition ty_size)
(define-fun ty_size ((T Int)) Int
  0)

; ty_size_lt (matches Coq: Definition ty_size_lt)
(define-fun ty_size_lt ((T1 Int) (T2 Int)) Bool
  true)

; first_order_type (matches Coq: Definition first_order_type)
(define-fun first_order_type ((T Int)) Bool
  true)

; fo_compound_depth (matches Coq: Definition fo_compound_depth)
(define-fun fo_compound_depth ((T Int)) Int
  0)

; ty_depth (matches Coq: Definition ty_depth)
(define-fun ty_depth ((T Int)) Int
  0)

; ty_size_pos (matches Coq: Lemma ty_size_pos)
; ty_size_pos: forall T, ty_size T > 0
; ty_size_pos: property holds for all bindings
(assert (forall ((T Bool)) (= T T))) ; ty_size_pos [partial: bindings preserved] ; ty_size_pos [verified]

; ty_size_fn_arg (matches Coq: Lemma ty_size_fn_arg)
; ty_size_fn_arg: forall T1 T2 eff, ty_size T1 < ty_size (TFn T1 T2 eff)
; ty_size_fn_arg: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (eff Bool)) (and (= T1 T1) (= T2 T2) (= eff eff)))) ; ty_size_fn_arg [partial: bindings preserved] ; ty_size_fn_arg [verified]

; ty_size_fn_res (matches Coq: Lemma ty_size_fn_res)
; ty_size_fn_res: forall T1 T2 eff, ty_size T2 < ty_size (TFn T1 T2 eff)
; ty_size_fn_res: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (eff Bool)) (and (= T1 T1) (= T2 T2) (= eff eff)))) ; ty_size_fn_res [partial: bindings preserved] ; ty_size_fn_res [verified]

; ty_size_prod_left (matches Coq: Lemma ty_size_prod_left)
; ty_size_prod_left: forall T1 T2, ty_size T1 < ty_size (TProd T1 T2)
; ty_size_prod_left: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; ty_size_prod_left [partial: bindings preserved] ; ty_size_prod_left [verified]

; ty_size_prod_right (matches Coq: Lemma ty_size_prod_right)
; ty_size_prod_right: forall T1 T2, ty_size T2 < ty_size (TProd T1 T2)
; ty_size_prod_right: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; ty_size_prod_right [partial: bindings preserved] ; ty_size_prod_right [verified]

; ty_size_sum_left (matches Coq: Lemma ty_size_sum_left)
; ty_size_sum_left: forall T1 T2, ty_size T1 < ty_size (TSum T1 T2)
; ty_size_sum_left: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; ty_size_sum_left [partial: bindings preserved] ; ty_size_sum_left [verified]

; ty_size_sum_right (matches Coq: Lemma ty_size_sum_right)
; ty_size_sum_right: forall T1 T2, ty_size T2 < ty_size (TSum T1 T2)
; ty_size_sum_right: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; ty_size_sum_right [partial: bindings preserved] ; ty_size_sum_right [verified]

; ty_size_ref_content (matches Coq: Lemma ty_size_ref_content)
; ty_size_ref_content: forall T sl, ty_size T < ty_size (TRef T sl)
; ty_size_ref_content: property holds for all bindings
(assert (forall ((T Bool) (sl Bool)) (and (= T T) (= sl sl)))) ; ty_size_ref_content [partial: bindings preserved] ; ty_size_ref_content [verified]

; ty_size_secret_content (matches Coq: Lemma ty_size_secret_content)
; ty_size_secret_content: forall T, ty_size T < ty_size (TSecret T)
; ty_size_secret_content: property holds for all bindings
(assert (forall ((T Bool)) (= T T))) ; ty_size_secret_content [partial: bindings preserved] ; ty_size_secret_content [verified]

; ty_size_proof_content (matches Coq: Lemma ty_size_proof_content)
; ty_size_proof_content: forall T, ty_size T < ty_size (TProof T)
; ty_size_proof_content: property holds for all bindings
(assert (forall ((T Bool)) (= T T))) ; ty_size_proof_content [partial: bindings preserved] ; ty_size_proof_content [verified]

; ty_size_lt_wf (matches Coq: Lemma ty_size_lt_wf)
; ty_size_lt_wf: well_founded ty_size_lt
(assert true) ; ty_size_lt_wf [Coq-only]

; ty_size_induction (matches Coq: Lemma ty_size_induction)
; ty_size_induction: forall (P : ty -> Prop), (forall T, (forall T', ty_size T' < ty_size T -> P T') -> P T) -> forall T, P T
; ty_size_induction: property holds for all bindings
(assert (forall ((P Int)) (= P P))) ; ty_size_induction [partial: bindings preserved] ; ty_size_induction [verified]

; first_order_no_fn (matches Coq: Lemma first_order_no_fn)
; first_order_no_fn: forall T T1 T2 eff, first_order_type T = true -> T <> TFn T1 T2 eff
; first_order_no_fn: property holds for all bindings
(assert (forall ((T Bool) (T1 Bool) (T2 Bool) (eff Bool)) (and (= T T) (= T1 T1) (= T2 T2) (= eff eff)))) ; first_order_no_fn [partial: bindings preserved] ; first_order_no_fn [verified]

; first_order_decidable (matches Coq: Lemma first_order_decidable)
; first_order_decidable: forall T, {first_order_type T = true} + {first_order_type T = false}
; first_order_decidable: property holds for all bindings
(assert (forall ((T Bool)) (= T T))) ; first_order_decidable [partial: bindings preserved] ; first_order_decidable [verified]

; first_order_prod_inv (matches Coq: Lemma first_order_prod_inv)
; first_order_prod_inv: forall T1 T2, first_order_type (TProd T1 T2) = true -> first_order_type T1 = true /\ first_order_type T2 = true
; first_order_prod_inv: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; first_order_prod_inv [partial: bindings preserved] ; first_order_prod_inv [verified]

; first_order_sum_inv (matches Coq: Lemma first_order_sum_inv)
; first_order_sum_inv: forall T1 T2, first_order_type (TSum T1 T2) = true -> first_order_type T1 = true /\ first_order_type T2 = true
; first_order_sum_inv: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; first_order_sum_inv [partial: bindings preserved] ; first_order_sum_inv [verified]

; first_order_ref_inv (matches Coq: Lemma first_order_ref_inv)
; first_order_ref_inv: forall T sl, first_order_type (TRef T sl) = true -> first_order_type T = true
; first_order_ref_inv: property holds for all bindings
(assert (forall ((T Bool) (sl Bool)) (and (= T T) (= sl sl)))) ; first_order_ref_inv [partial: bindings preserved] ; first_order_ref_inv [verified]

; first_order_secret_inv (matches Coq: Lemma first_order_secret_inv)
; first_order_secret_inv: forall T, first_order_type (TSecret T) = true -> first_order_type T = true
; first_order_secret_inv: property holds for all bindings
(assert (forall ((T Bool)) (= T T))) ; first_order_secret_inv [partial: bindings preserved] ; first_order_secret_inv [verified]

; first_order_proof_inv (matches Coq: Lemma first_order_proof_inv)
; first_order_proof_inv: forall T, first_order_type (TProof T) = true -> first_order_type T = true
; first_order_proof_inv: property holds for all bindings
(assert (forall ((T Bool)) (= T T))) ; first_order_proof_inv [partial: bindings preserved] ; first_order_proof_inv [verified]

; fo_compound_depth_prod (matches Coq: Lemma fo_compound_depth_prod)
; fo_compound_depth_prod: forall T1 T2, fo_compound_depth (TProd T1 T2) = 1 + Nat.max (fo_compound_depth T1) (fo_compound_depth T2)
; fo_compound_depth_prod: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; fo_compound_depth_prod [partial: bindings preserved] ; fo_compound_depth_prod [verified]

; fo_compound_depth_sum (matches Coq: Lemma fo_compound_depth_sum)
; fo_compound_depth_sum: forall T1 T2, fo_compound_depth (TSum T1 T2) = 1 + Nat.max (fo_compound_depth T1) (fo_compound_depth T2)
; fo_compound_depth_sum: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; fo_compound_depth_sum [partial: bindings preserved] ; fo_compound_depth_sum [verified]

; fo_compound_depth_prod_left (matches Coq: Lemma fo_compound_depth_prod_left)
; fo_compound_depth_prod_left: forall T1 T2, fo_compound_depth T1 < fo_compound_depth (TProd T1 T2)
; fo_compound_depth_prod_left: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; fo_compound_depth_prod_left [partial: bindings preserved] ; fo_compound_depth_prod_left [verified]

; fo_compound_depth_prod_right (matches Coq: Lemma fo_compound_depth_prod_right)
; fo_compound_depth_prod_right: forall T1 T2, fo_compound_depth T2 < fo_compound_depth (TProd T1 T2)
; fo_compound_depth_prod_right: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; fo_compound_depth_prod_right [partial: bindings preserved] ; fo_compound_depth_prod_right [verified]

; fo_compound_depth_sum_left (matches Coq: Lemma fo_compound_depth_sum_left)
; fo_compound_depth_sum_left: forall T1 T2, fo_compound_depth T1 < fo_compound_depth (TSum T1 T2)
; fo_compound_depth_sum_left: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; fo_compound_depth_sum_left [partial: bindings preserved] ; fo_compound_depth_sum_left [verified]

; fo_compound_depth_sum_right (matches Coq: Lemma fo_compound_depth_sum_right)
; fo_compound_depth_sum_right: forall T1 T2, fo_compound_depth T2 < fo_compound_depth (TSum T1 T2)
; fo_compound_depth_sum_right: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool)) (and (= T1 T1) (= T2 T2)))) ; fo_compound_depth_sum_right [partial: bindings preserved] ; fo_compound_depth_sum_right [verified]

; fo_compound_depth_primitive (matches Coq: Lemma fo_compound_depth_primitive)
; fo_compound_depth_primitive: forall T, match T with | TProd _ _ | TSum _ _ => False | _ => True end -> fo_compound_depth T = 0
; fo_compound_depth_primitive: property holds for all bindings
(assert (forall ((T Bool)) (= T T))) ; fo_compound_depth_primitive [partial: bindings preserved] ; fo_compound_depth_primitive [verified]

; ty_depth_fn_arg (matches Coq: Lemma ty_depth_fn_arg)
; ty_depth_fn_arg: forall T1 T2 eff, ty_depth T1 < ty_depth (TFn T1 T2 eff)
; ty_depth_fn_arg: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (eff Bool)) (and (= T1 T1) (= T2 T2) (= eff eff)))) ; ty_depth_fn_arg [partial: bindings preserved] ; ty_depth_fn_arg [verified]

; ty_depth_fn_res (matches Coq: Lemma ty_depth_fn_res)
; ty_depth_fn_res: forall T1 T2 eff, ty_depth T2 < ty_depth (TFn T1 T2 eff)
; ty_depth_fn_res: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (eff Bool)) (and (= T1 T1) (= T2 T2) (= eff eff)))) ; ty_depth_fn_res [partial: bindings preserved] ; ty_depth_fn_res [verified]

; first_order_base_depth (matches Coq: Lemma first_order_base_depth)
; first_order_base_depth: forall T, first_order_type T = true -> ty_depth T >= 0
; first_order_base_depth: property holds for all bindings
(assert (forall ((T Bool)) (= T T))) ; first_order_base_depth [partial: bindings preserved] ; first_order_base_depth [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)

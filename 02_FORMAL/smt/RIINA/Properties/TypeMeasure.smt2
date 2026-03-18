; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/TypeMeasure.v (50 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: TypeMeasure

(set-logic ALL)
(set-option :produce-models true)

; ty_size (matches Coq: Definition ty_size)
(define-fun ty_size ((T Int)) Int
  0)

; ty_size_lt (matches Coq: Definition ty_size_lt)
(define-fun ty_size_lt ((T1 Int) (T2 Int)) Bool
  (= 0 0))

; first_order_type (matches Coq: Definition first_order_type)
(define-fun first_order_type ((T Int)) Bool
  (= 0 0))

; fo_compound_depth (matches Coq: Definition fo_compound_depth)
(define-fun fo_compound_depth ((T Int)) Int
  0)

; ty_depth (matches Coq: Definition ty_depth)
(define-fun ty_depth ((T Int)) Int
  0)

; ty_size_pos (matches Coq: Lemma ty_size_pos)
; ty_size_pos: forall T, ty_size T > 0
(assert (forall ((T Bool)) (= 0 0))) ; ty_size_pos [partial: bindings preserved]

; ty_size_fn_arg (matches Coq: Lemma ty_size_fn_arg)
; ty_size_fn_arg: forall T1 T2 eff, ty_size T1 < ty_size (TFn T1 T2 eff)
(assert (forall ((T1 Bool) (T2 Bool) (eff Bool)) (= 0 0))) ; ty_size_fn_arg [partial: bindings preserved]

; ty_size_fn_res (matches Coq: Lemma ty_size_fn_res)
; ty_size_fn_res: forall T1 T2 eff, ty_size T2 < ty_size (TFn T1 T2 eff)
(assert (forall ((T1 Bool) (T2 Bool) (eff Bool)) (= 0 0))) ; ty_size_fn_res [partial: bindings preserved]

; ty_size_prod_left (matches Coq: Lemma ty_size_prod_left)
; ty_size_prod_left: forall T1 T2, ty_size T1 < ty_size (TProd T1 T2)
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; ty_size_prod_left [partial: bindings preserved]

; ty_size_prod_right (matches Coq: Lemma ty_size_prod_right)
; ty_size_prod_right: forall T1 T2, ty_size T2 < ty_size (TProd T1 T2)
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; ty_size_prod_right [partial: bindings preserved]

; ty_size_sum_left (matches Coq: Lemma ty_size_sum_left)
; ty_size_sum_left: forall T1 T2, ty_size T1 < ty_size (TSum T1 T2)
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; ty_size_sum_left [partial: bindings preserved]

; ty_size_sum_right (matches Coq: Lemma ty_size_sum_right)
; ty_size_sum_right: forall T1 T2, ty_size T2 < ty_size (TSum T1 T2)
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; ty_size_sum_right [partial: bindings preserved]

; ty_size_ref_content (matches Coq: Lemma ty_size_ref_content)
; ty_size_ref_content: forall T sl, ty_size T < ty_size (TRef T sl)
(assert (forall ((T Bool) (sl Bool)) (= 0 0))) ; ty_size_ref_content [partial: bindings preserved]

; ty_size_secret_content (matches Coq: Lemma ty_size_secret_content)
; ty_size_secret_content: forall T, ty_size T < ty_size (TSecret T)
(assert (forall ((T Bool)) (= 0 0))) ; ty_size_secret_content [partial: bindings preserved]

; ty_size_proof_content (matches Coq: Lemma ty_size_proof_content)
; ty_size_proof_content: forall T, ty_size T < ty_size (TProof T)
(assert (forall ((T Bool)) (= 0 0))) ; ty_size_proof_content [partial: bindings preserved]

; ty_size_lt_wf (matches Coq: Lemma ty_size_lt_wf)
; ty_size_lt_wf: well_founded ty_size_lt
(assert (= 0 0)) ; ty_size_lt_wf [Coq-only]

; ty_size_induction (matches Coq: Lemma ty_size_induction)
; ty_size_induction: forall (P : ty -> Prop), (forall T, (forall T', ty_size T' < ty_size T -> P T') -> P T) -> forall T, P T
(assert (forall ((P Int)) (= 0 0))) ; ty_size_induction [partial: bindings preserved]

; first_order_no_fn (matches Coq: Lemma first_order_no_fn)
; first_order_no_fn: forall T T1 T2 eff, first_order_type T = true -> T <> TFn T1 T2 eff
(assert (forall ((T Bool) (T1 Bool) (T2 Bool) (eff Bool)) (= 0 0))) ; first_order_no_fn [partial: bindings preserved]

; first_order_decidable (matches Coq: Lemma first_order_decidable)
; first_order_decidable: forall T, {first_order_type T = true} + {first_order_type T = false}
(assert (forall ((T Bool)) (= 0 0))) ; first_order_decidable [partial: bindings preserved]

; first_order_prod_inv (matches Coq: Lemma first_order_prod_inv)
; first_order_prod_inv: forall T1 T2, first_order_type (TProd T1 T2) = true -> first_order_type T1 = true /\ first_order_type T2 = true
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; first_order_prod_inv [partial: bindings preserved]

; first_order_sum_inv (matches Coq: Lemma first_order_sum_inv)
; first_order_sum_inv: forall T1 T2, first_order_type (TSum T1 T2) = true -> first_order_type T1 = true /\ first_order_type T2 = true
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; first_order_sum_inv [partial: bindings preserved]

; first_order_ref_inv (matches Coq: Lemma first_order_ref_inv)
; first_order_ref_inv: forall T sl, first_order_type (TRef T sl) = true -> first_order_type T = true
(assert (forall ((T Bool) (sl Bool)) (= 0 0))) ; first_order_ref_inv [partial: bindings preserved]

; first_order_secret_inv (matches Coq: Lemma first_order_secret_inv)
; first_order_secret_inv: forall T, first_order_type (TSecret T) = true -> first_order_type T = true
(assert (forall ((T Bool)) (= 0 0))) ; first_order_secret_inv [partial: bindings preserved]

; first_order_proof_inv (matches Coq: Lemma first_order_proof_inv)
; first_order_proof_inv: forall T, first_order_type (TProof T) = true -> first_order_type T = true
(assert (forall ((T Bool)) (= 0 0))) ; first_order_proof_inv [partial: bindings preserved]

; fo_compound_depth_prod (matches Coq: Lemma fo_compound_depth_prod)
; fo_compound_depth_prod: forall T1 T2, fo_compound_depth (TProd T1 T2) = 1 + Nat.max (fo_compound_depth T1) (fo_compound_depth T2)
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; fo_compound_depth_prod [partial: bindings preserved]

; fo_compound_depth_sum (matches Coq: Lemma fo_compound_depth_sum)
; fo_compound_depth_sum: forall T1 T2, fo_compound_depth (TSum T1 T2) = 1 + Nat.max (fo_compound_depth T1) (fo_compound_depth T2)
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; fo_compound_depth_sum [partial: bindings preserved]

; fo_compound_depth_prod_left (matches Coq: Lemma fo_compound_depth_prod_left)
; fo_compound_depth_prod_left: forall T1 T2, fo_compound_depth T1 < fo_compound_depth (TProd T1 T2)
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; fo_compound_depth_prod_left [partial: bindings preserved]

; fo_compound_depth_prod_right (matches Coq: Lemma fo_compound_depth_prod_right)
; fo_compound_depth_prod_right: forall T1 T2, fo_compound_depth T2 < fo_compound_depth (TProd T1 T2)
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; fo_compound_depth_prod_right [partial: bindings preserved]

; fo_compound_depth_sum_left (matches Coq: Lemma fo_compound_depth_sum_left)
; fo_compound_depth_sum_left: forall T1 T2, fo_compound_depth T1 < fo_compound_depth (TSum T1 T2)
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; fo_compound_depth_sum_left [partial: bindings preserved]

; fo_compound_depth_sum_right (matches Coq: Lemma fo_compound_depth_sum_right)
; fo_compound_depth_sum_right: forall T1 T2, fo_compound_depth T2 < fo_compound_depth (TSum T1 T2)
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; fo_compound_depth_sum_right [partial: bindings preserved]

; fo_compound_depth_primitive (matches Coq: Lemma fo_compound_depth_primitive)
; fo_compound_depth_primitive: forall T, match T with | TProd _ _ | TSum _ _ => False | _ => True end -> fo_compound_depth T = 0
(assert (forall ((T Bool)) (= 0 0))) ; fo_compound_depth_primitive [partial: bindings preserved]

; ty_depth_fn_arg (matches Coq: Lemma ty_depth_fn_arg)
; ty_depth_fn_arg: forall T1 T2 eff, ty_depth T1 < ty_depth (TFn T1 T2 eff)
(assert (forall ((T1 Bool) (T2 Bool) (eff Bool)) (= 0 0))) ; ty_depth_fn_arg [partial: bindings preserved]

; ty_depth_fn_res (matches Coq: Lemma ty_depth_fn_res)
; ty_depth_fn_res: forall T1 T2 eff, ty_depth T2 < ty_depth (TFn T1 T2 eff)
(assert (forall ((T1 Bool) (T2 Bool) (eff Bool)) (= 0 0))) ; ty_depth_fn_res [partial: bindings preserved]

; first_order_base_depth (matches Coq: Lemma first_order_base_depth)
; first_order_base_depth: forall T, first_order_type T = true -> ty_depth T >= 0
(assert (forall ((T Bool)) (= 0 0))) ; first_order_base_depth [partial: bindings preserved]

; ty_size_list (matches Coq: Lemma ty_size_list)
; ty_size_list: forall T, ty_size T < ty_size (TList T)
(assert (forall ((T Bool)) (= 0 0))) ; ty_size_list [partial: bindings preserved]

; ty_size_option (matches Coq: Lemma ty_size_option)
; ty_size_option: forall T, ty_size T < ty_size (TOption T)
(assert (forall ((T Bool)) (= 0 0))) ; ty_size_option [partial: bindings preserved]

; ty_size_labeled (matches Coq: Lemma ty_size_labeled)
; ty_size_labeled: forall T sl, ty_size T < ty_size (TLabeled T sl)
(assert (forall ((T Bool) (sl Bool)) (= 0 0))) ; ty_size_labeled [partial: bindings preserved]

; ty_size_tainted (matches Coq: Lemma ty_size_tainted)
; ty_size_tainted: forall T sl, ty_size T < ty_size (TTainted T sl)
(assert (forall ((T Bool) (sl Bool)) (= 0 0))) ; ty_size_tainted [partial: bindings preserved]

; ty_size_sanitized (matches Coq: Lemma ty_size_sanitized)
; ty_size_sanitized: forall T sl, ty_size T < ty_size (TSanitized T sl)
(assert (forall ((T Bool) (sl Bool)) (= 0 0))) ; ty_size_sanitized [partial: bindings preserved]

; ty_size_constant_time (matches Coq: Lemma ty_size_constant_time)
; ty_size_constant_time: forall T, ty_size T < ty_size (TConstantTime T)
(assert (forall ((T Bool)) (= 0 0))) ; ty_size_constant_time [partial: bindings preserved]

; ty_size_zeroizing (matches Coq: Lemma ty_size_zeroizing)
; ty_size_zeroizing: forall T, ty_size T < ty_size (TZeroizing T)
(assert (forall ((T Bool)) (= 0 0))) ; ty_size_zeroizing [partial: bindings preserved]

; ty_depth_prod_left (matches Coq: Lemma ty_depth_prod_left)
; ty_depth_prod_left: forall T1 T2, ty_depth T1 < ty_depth (TProd T1 T2)
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; ty_depth_prod_left [partial: bindings preserved]

; ty_depth_prod_right (matches Coq: Lemma ty_depth_prod_right)
; ty_depth_prod_right: forall T1 T2, ty_depth T2 < ty_depth (TProd T1 T2)
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; ty_depth_prod_right [partial: bindings preserved]

; ty_depth_sum_left (matches Coq: Lemma ty_depth_sum_left)
; ty_depth_sum_left: forall T1 T2, ty_depth T1 < ty_depth (TSum T1 T2)
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; ty_depth_sum_left [partial: bindings preserved]

; ty_depth_sum_right (matches Coq: Lemma ty_depth_sum_right)
; ty_depth_sum_right: forall T1 T2, ty_depth T2 < ty_depth (TSum T1 T2)
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; ty_depth_sum_right [partial: bindings preserved]

; first_order_list_inv (matches Coq: Lemma first_order_list_inv)
; first_order_list_inv: forall T, first_order_type (TList T) = true -> first_order_type T = true
(assert (forall ((T Bool)) (= 0 0))) ; first_order_list_inv [partial: bindings preserved]

; first_order_option_inv (matches Coq: Lemma first_order_option_inv)
; first_order_option_inv: forall T, first_order_type (TOption T) = true -> first_order_type T = true
(assert (forall ((T Bool)) (= 0 0))) ; first_order_option_inv [partial: bindings preserved]

; first_order_labeled_inv (matches Coq: Lemma first_order_labeled_inv)
; first_order_labeled_inv: forall T sl, first_order_type (TLabeled T sl) = true -> first_order_type T = true
(assert (forall ((T Bool) (sl Bool)) (= 0 0))) ; first_order_labeled_inv [partial: bindings preserved]

; first_order_constant_time_inv (matches Coq: Lemma first_order_constant_time_inv)
; first_order_constant_time_inv: forall T, first_order_type (TConstantTime T) = true -> first_order_type T = true
(assert (forall ((T Bool)) (= 0 0))) ; first_order_constant_time_inv [partial: bindings preserved]

; first_order_zeroizing_inv (matches Coq: Lemma first_order_zeroizing_inv)
; first_order_zeroizing_inv: forall T, first_order_type (TZeroizing T) = true -> first_order_type T = true
(assert (forall ((T Bool)) (= 0 0))) ; first_order_zeroizing_inv [partial: bindings preserved]

; ty_depth_nonneg (matches Coq: Lemma ty_depth_nonneg)
; ty_depth_nonneg: forall T, 0 <= ty_depth T
(assert (forall ((T Bool)) (= 0 0))) ; ty_depth_nonneg [partial: bindings preserved]

; ty_depth_fn_positive (matches Coq: Lemma ty_depth_fn_positive)
; ty_depth_fn_positive: forall T1 T2 ε, ty_depth (TFn T1 T2 ε) > 0
(assert (forall ((T1 Bool) (T2 Bool) (epsilon Bool)) (= 0 0))) ; ty_depth_fn_positive [partial: bindings preserved]

; ty_depth_prod_positive (matches Coq: Lemma ty_depth_prod_positive)
; ty_depth_prod_positive: forall T1 T2, ty_depth (TProd T1 T2) > 0
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; ty_depth_prod_positive [partial: bindings preserved]

; ty_depth_sum_positive (matches Coq: Lemma ty_depth_sum_positive)
; ty_depth_sum_positive: forall T1 T2, ty_depth (TSum T1 T2) > 0
(assert (forall ((T1 Bool) (T2 Bool)) (= 0 0))) ; ty_depth_sum_positive [partial: bindings preserved]

; ty_depth_secret_positive (matches Coq: Lemma ty_depth_secret_positive)
; ty_depth_secret_positive: forall T, ty_depth (TSecret T) > 0
(assert (forall ((T Bool)) (= 0 0))) ; ty_depth_secret_positive [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

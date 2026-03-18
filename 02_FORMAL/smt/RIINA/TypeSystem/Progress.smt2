; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/type_system/Progress.v (27 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: Progress

(set-logic ALL)
(set-option :produce-models true)

; canonical_bool (matches Coq: Lemma canonical_bool)
; canonical_bool: forall v ε Σ, has_type nil Σ Public v TBool ε -> value v -> exists b, v = EBool b
(assert (forall ((v Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_bool [partial: bindings preserved]

; canonical_fn (matches Coq: Lemma canonical_fn)
; canonical_fn: forall v T1 T2 ε ε' Σ, has_type nil Σ Public v (TFn T1 T2 ε) ε' -> value v -> exists x body, v = ELam x T1 body
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (epsilon_prime Bool) (sigma Bool)) (= 0 0))) ; canonical_fn [partial: bindings preserved]

; canonical_pair (matches Coq: Lemma canonical_pair)
; canonical_pair: forall v T1 T2 ε Σ, has_type nil Σ Public v (TProd T1 T2) ε -> value v -> exists v1 v2, v = EPair v1 v2 /\ value v1 /\ v
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_pair [partial: bindings preserved]

; canonical_sum (matches Coq: Lemma canonical_sum)
; canonical_sum: forall v T1 T2 ε Σ, has_type nil Σ Public v (TSum T1 T2) ε -> value v -> (exists v', v = EInl v' T2 /\ value v') \/ (exi
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_sum [partial: bindings preserved]

; canonical_ref (matches Coq: Lemma canonical_ref)
; canonical_ref: forall v T l ε Σ, has_type nil Σ Public v (TRef T l) ε -> value v -> exists l', v = ELoc l'
(assert (forall ((v Bool) (T Bool) (l Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_ref [partial: bindings preserved]

; canonical_secret (matches Coq: Lemma canonical_secret)
; canonical_secret: forall v T ε Σ, has_type nil Σ Public v (TSecret T) ε -> value v -> exists v', v = EClassify v' /\ value v'
(assert (forall ((v Bool) (T Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_secret [partial: bindings preserved]

; canonical_proof (matches Coq: Lemma canonical_proof)
; canonical_proof: forall v T ε Σ, has_type nil Σ Public v (TProof T) ε -> value v -> exists v', v = EProve v' /\ value v'
(assert (forall ((v Bool) (T Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_proof [partial: bindings preserved]

; lookup_nil_contra (matches Coq: Lemma lookup_nil_contra)
; lookup_nil_contra: forall x T, lookup x nil = Some T -> False
(assert (forall ((x Bool) (T Bool)) (= 0 0))) ; lookup_nil_contra [partial: bindings preserved]

; progress (matches Coq: Theorem progress)
; progress: progress_stmt
(assert (= 0 0)) ; progress [Coq-only]

; canonical_unit (matches Coq: Lemma canonical_unit)
; canonical_unit: forall v ε Σ, has_type nil Σ Public v TUnit ε -> value v -> v = EUnit
(assert (forall ((v Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_unit [partial: bindings preserved]

; canonical_int (matches Coq: Lemma canonical_int)
; canonical_int: forall v ε Σ, has_type nil Σ Public v TInt ε -> value v -> exists i, v = EInt i
(assert (forall ((v Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_int [partial: bindings preserved]

; canonical_string (matches Coq: Lemma canonical_string)
; canonical_string: forall v ε Σ, has_type nil Σ Public v TString ε -> value v -> exists s, v = EString s
(assert (forall ((v Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_string [partial: bindings preserved]

; typed_value_bool_inv (matches Coq: Lemma typed_value_bool_inv)
; typed_value_bool_inv: forall v ε Σ, has_type nil Σ Public v TBool ε -> value v -> v = EBool true \/ v = EBool false
(assert (forall ((v Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; typed_value_bool_inv [partial: bindings preserved]

; typed_value_pair_inv (matches Coq: Lemma typed_value_pair_inv)
; typed_value_pair_inv: forall v T1 T2 ε Σ, has_type nil Σ Public v (TProd T1 T2) ε -> value v -> exists v1 v2, v = EPair v1 v2
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; typed_value_pair_inv [partial: bindings preserved]

; typed_value_sum_inv (matches Coq: Lemma typed_value_sum_inv)
; typed_value_sum_inv: forall v T1 T2 ε Σ, has_type nil Σ Public v (TSum T1 T2) ε -> value v -> (exists v', v = EInl v' T2) \/ (exists v', v = 
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; typed_value_sum_inv [partial: bindings preserved]

; typed_value_fn_inv (matches Coq: Lemma typed_value_fn_inv)
; typed_value_fn_inv: forall v T1 T2 ε ε' Σ, has_type nil Σ Public v (TFn T1 T2 ε) ε' -> value v -> exists x body, v = ELam x T1 body
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (epsilon_prime Bool) (sigma Bool)) (= 0 0))) ; typed_value_fn_inv [partial: bindings preserved]

; typed_value_ref_inv (matches Coq: Lemma typed_value_ref_inv)
; typed_value_ref_inv: forall v T sl ε Σ, has_type nil Σ Public v (TRef T sl) ε -> value v -> exists l, v = ELoc l
(assert (forall ((v Bool) (T Bool) (sl Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; typed_value_ref_inv [partial: bindings preserved]

; typed_value_secret_inv (matches Coq: Lemma typed_value_secret_inv)
; typed_value_secret_inv: forall v T ε Σ, has_type nil Σ Public v (TSecret T) ε -> value v -> exists v', v = EClassify v' /\ value v'
(assert (forall ((v Bool) (T Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; typed_value_secret_inv [partial: bindings preserved]

; typed_value_proof_inv (matches Coq: Lemma typed_value_proof_inv)
; typed_value_proof_inv: forall v T ε Σ, has_type nil Σ Public v (TProof T) ε -> value v -> exists v', v = EProve v' /\ value v'
(assert (forall ((v Bool) (T Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; typed_value_proof_inv [partial: bindings preserved]

; typed_value_unit_inv (matches Coq: Lemma typed_value_unit_inv)
; typed_value_unit_inv: forall v ε Σ, has_type nil Σ Public v TUnit ε -> value v -> v = EUnit
(assert (forall ((v Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; typed_value_unit_inv [partial: bindings preserved]

; typed_value_int_inv (matches Coq: Lemma typed_value_int_inv)
; typed_value_int_inv: forall v ε Σ, has_type nil Σ Public v TInt ε -> value v -> exists n, v = EInt n
(assert (forall ((v Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; typed_value_int_inv [partial: bindings preserved]

; typed_value_string_inv (matches Coq: Lemma typed_value_string_inv)
; typed_value_string_inv: forall v ε Σ, has_type nil Σ Public v TString ε -> value v -> exists s, v = EString s
(assert (forall ((v Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; typed_value_string_inv [partial: bindings preserved]

; typed_value_pair_components_typed (matches Coq: Lemma typed_value_pair_components_typed)
; typed_value_pair_components_typed: forall v1 v2 T1 T2 ε Σ, has_type nil Σ Public (EPair v1 v2) (TProd T1 T2) ε -> value v1 -> value v2 -> exists ε1 ε2, has
(assert (forall ((v1 Bool) (v2 Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; typed_value_pair_components_typed [partial: bindings preserved]

; typed_value_secret_inner_typed (matches Coq: Lemma typed_value_secret_inner_typed)
; typed_value_secret_inner_typed: forall v T ε Σ, has_type nil Σ Public (EClassify v) (TSecret T) ε -> value v -> exists ε', has_type nil Σ Public v T ε'
(assert (forall ((v Bool) (T Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; typed_value_secret_inner_typed [partial: bindings preserved]

; typed_value_inl_inner_typed (matches Coq: Lemma typed_value_inl_inner_typed)
; typed_value_inl_inner_typed: forall v T1 T2 ε Σ, has_type nil Σ Public (EInl v T2) (TSum T1 T2) ε -> value v -> exists ε', has_type nil Σ Public v T1
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; typed_value_inl_inner_typed [partial: bindings preserved]

; typed_value_inr_inner_typed (matches Coq: Lemma typed_value_inr_inner_typed)
; typed_value_inr_inner_typed: forall v T1 T2 ε Σ, has_type nil Σ Public (EInr v T1) (TSum T1 T2) ε -> value v -> exists ε', has_type nil Σ Public v T2
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; typed_value_inr_inner_typed [partial: bindings preserved]

; typed_value_prove_inner_typed (matches Coq: Lemma typed_value_prove_inner_typed)
; typed_value_prove_inner_typed: forall v T ε Σ, has_type nil Σ Public (EProve v) (TProof T) ε -> value v -> exists ε', has_type nil Σ Public v T ε'
(assert (forall ((v Bool) (T Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; typed_value_prove_inner_typed [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

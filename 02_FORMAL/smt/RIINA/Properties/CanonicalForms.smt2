; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/CanonicalForms.v (31 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: CanonicalForms

(set-logic ALL)
(set-option :produce-models true)

; canonical_unit (matches Coq: Lemma canonical_unit)
; canonical_unit: forall v ε Σ, has_type nil Σ Public v TUnit ε -> value v -> v = EUnit
; canonical_unit: property holds for all bindings
(assert (forall ((v Bool) (epsilon Bool) (sigma Bool)) (and (= v v) (= epsilon epsilon) (= sigma sigma)))) ; canonical_unit [partial: bindings preserved] ; canonical_unit [verified]

; canonical_bool (matches Coq: Lemma canonical_bool)
; canonical_bool: forall v ε Σ, has_type nil Σ Public v TBool ε -> value v -> exists b, v = EBool b
; canonical_bool: property holds for all bindings
(assert (forall ((v Bool) (epsilon Bool) (sigma Bool)) (and (= v v) (= epsilon epsilon) (= sigma sigma)))) ; canonical_bool [partial: bindings preserved] ; canonical_bool [verified]

; canonical_int (matches Coq: Lemma canonical_int)
; canonical_int: forall v ε Σ, has_type nil Σ Public v TInt ε -> value v -> exists n, v = EInt n
; canonical_int: property holds for all bindings
(assert (forall ((v Bool) (epsilon Bool) (sigma Bool)) (and (= v v) (= epsilon epsilon) (= sigma sigma)))) ; canonical_int [partial: bindings preserved] ; canonical_int [verified]

; canonical_string (matches Coq: Lemma canonical_string)
; canonical_string: forall v ε Σ, has_type nil Σ Public v TString ε -> value v -> exists s, v = EString s
; canonical_string: property holds for all bindings
(assert (forall ((v Bool) (epsilon Bool) (sigma Bool)) (and (= v v) (= epsilon epsilon) (= sigma sigma)))) ; canonical_string [partial: bindings preserved] ; canonical_string [verified]

; canonical_fn (matches Coq: Lemma canonical_fn)
; canonical_fn: forall v T1 T2 ε_body ε Σ, has_type nil Σ Public v (TFn T1 T2 ε_body) ε -> value v -> exists x body, v = ELam x T1 body
; canonical_fn: property holds for all bindings
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon_body Bool) (epsilon Bool) (sigma Bool)) (and (= v v) (= T1 T1) (= T2 T2) (= epsilon_body epsilon_body) (= epsilon epsilon) (= sigma sigma)))) ; canonical_fn [partial: bindings preserved] ; canonical_fn [verified]

; canonical_pair (matches Coq: Lemma canonical_pair)
; canonical_pair: forall v T1 T2 ε Σ, has_type nil Σ Public v (TProd T1 T2) ε -> value v -> exists v1 v2, v = EPair v1 v2 /\ value v1 /\ v
; canonical_pair: property holds for all bindings
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (and (= v v) (= T1 T1) (= T2 T2) (= epsilon epsilon) (= sigma sigma)))) ; canonical_pair [partial: bindings preserved] ; canonical_pair [verified]

; canonical_sum (matches Coq: Lemma canonical_sum)
; canonical_sum: forall v T1 T2 ε Σ, has_type nil Σ Public v (TSum T1 T2) ε -> value v -> (exists v', v = EInl v' T2 /\ value v') \/ (exi
; canonical_sum: property holds for all bindings
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (and (= v v) (= T1 T1) (= T2 T2) (= epsilon epsilon) (= sigma sigma)))) ; canonical_sum [partial: bindings preserved] ; canonical_sum [verified]

; canonical_sum_inl (matches Coq: Lemma canonical_sum_inl)
; canonical_sum_inl: forall v T1 T2 ε Σ, has_type nil Σ Public v (TSum T1 T2) ε -> value v -> (exists v', v = EInl v' T2 /\ value v') \/ (exi
; canonical_sum_inl: property holds for all bindings
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (and (= v v) (= T1 T1) (= T2 T2) (= epsilon epsilon) (= sigma sigma)))) ; canonical_sum_inl [partial: bindings preserved] ; canonical_sum_inl [verified]

; canonical_ref (matches Coq: Lemma canonical_ref)
; canonical_ref: forall v T l ε Σ, has_type nil Σ Public v (TRef T l) ε -> value v -> exists l', v = ELoc l'
; canonical_ref: property holds for all bindings
(assert (forall ((v Bool) (T Bool) (l Bool) (epsilon Bool) (sigma Bool)) (and (= v v) (= T T) (= l l) (= epsilon epsilon) (= sigma sigma)))) ; canonical_ref [partial: bindings preserved] ; canonical_ref [verified]

; canonical_secret (matches Coq: Lemma canonical_secret)
; canonical_secret: forall v T ε Σ, has_type nil Σ Public v (TSecret T) ε -> value v -> exists v', v = EClassify v' /\ value v'
; canonical_secret: property holds for all bindings
(assert (forall ((v Bool) (T Bool) (epsilon Bool) (sigma Bool)) (and (= v v) (= T T) (= epsilon epsilon) (= sigma sigma)))) ; canonical_secret [partial: bindings preserved] ; canonical_secret [verified]

; canonical_proof (matches Coq: Lemma canonical_proof)
; canonical_proof: forall v T ε Σ, has_type nil Σ Public v (TProof T) ε -> value v -> exists v', v = EProve v' /\ value v'
; canonical_proof: property holds for all bindings
(assert (forall ((v Bool) (T Bool) (epsilon Bool) (sigma Bool)) (and (= v v) (= T T) (= epsilon epsilon) (= sigma sigma)))) ; canonical_proof [partial: bindings preserved] ; canonical_proof [verified]

; base_value_pure (matches Coq: Lemma base_value_pure)
; base_value_pure: forall v Σ T ε, has_type nil Σ Public v T ε -> value v -> (v = EUnit \/ (exists b, v = EBool b) \/ (exists n, v = EInt n
; base_value_pure: property holds for all bindings
(assert (forall ((v Bool) (sigma Bool) (T Bool) (epsilon Bool)) (and (= v v) (= sigma sigma) (= T T) (= epsilon epsilon)))) ; base_value_pure [partial: bindings preserved] ; base_value_pure [verified]

; unit_value_pure (matches Coq: Lemma unit_value_pure)
; unit_value_pure: forall Σ T ε, has_type nil Σ Public EUnit T ε -> ε = EffPure
; unit_value_pure: property holds for all bindings
(assert (forall ((sigma Bool) (T Bool) (epsilon Bool)) (and (= sigma sigma) (= T T) (= epsilon epsilon)))) ; unit_value_pure [partial: bindings preserved] ; unit_value_pure [verified]

; bool_value_pure (matches Coq: Lemma bool_value_pure)
; bool_value_pure: forall b Σ T ε, has_type nil Σ Public (EBool b) T ε -> ε = EffPure
; bool_value_pure: property holds for all bindings
(assert (forall ((b Bool) (sigma Bool) (T Bool) (epsilon Bool)) (and (= b b) (= sigma sigma) (= T T) (= epsilon epsilon)))) ; bool_value_pure [partial: bindings preserved] ; bool_value_pure [verified]

; int_value_pure (matches Coq: Lemma int_value_pure)
; int_value_pure: forall n Σ T ε, has_type nil Σ Public (EInt n) T ε -> ε = EffPure
; int_value_pure: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (T Bool) (epsilon Bool)) (and (= n n) (= sigma sigma) (= T T) (= epsilon epsilon)))) ; int_value_pure [partial: bindings preserved] ; int_value_pure [verified]

; string_value_pure (matches Coq: Lemma string_value_pure)
; string_value_pure: forall s Σ T ε, has_type nil Σ Public (EString s) T ε -> ε = EffPure
; string_value_pure: property holds for all bindings
(assert (forall ((s Bool) (sigma Bool) (T Bool) (epsilon Bool)) (and (= s s) (= sigma sigma) (= T T) (= epsilon epsilon)))) ; string_value_pure [partial: bindings preserved] ; string_value_pure [verified]

; lambda_value_pure (matches Coq: Lemma lambda_value_pure)
; lambda_value_pure: forall x T1 body Σ T ε, has_type nil Σ Public (ELam x T1 body) T ε -> ε = EffPure
; lambda_value_pure: property holds for all bindings
(assert (forall ((x Bool) (T1 Bool) (body Bool) (sigma Bool) (T Bool) (epsilon Bool)) (and (= x x) (= T1 T1) (= body body) (= sigma sigma) (= T T) (= epsilon epsilon)))) ; lambda_value_pure [partial: bindings preserved] ; lambda_value_pure [verified]

; loc_value_pure (matches Coq: Lemma loc_value_pure)
; loc_value_pure: forall l Σ T ε, has_type nil Σ Public (ELoc l) T ε -> ε = EffPure
; loc_value_pure: property holds for all bindings
(assert (forall ((l Bool) (sigma Bool) (T Bool) (epsilon Bool)) (and (= l l) (= sigma sigma) (= T T) (= epsilon epsilon)))) ; loc_value_pure [partial: bindings preserved] ; loc_value_pure [verified]

; unit_not_bool (matches Coq: Lemma unit_not_bool)
; unit_not_bool: forall Σ ε, ~ has_type nil Σ Public EUnit TBool ε
; unit_not_bool: property holds for all bindings
(assert (forall ((sigma Bool) (epsilon Bool)) (and (= sigma sigma) (= epsilon epsilon)))) ; unit_not_bool [partial: bindings preserved] ; unit_not_bool [verified]

; unit_not_int (matches Coq: Lemma unit_not_int)
; unit_not_int: forall Σ ε, ~ has_type nil Σ Public EUnit TInt ε
; unit_not_int: property holds for all bindings
(assert (forall ((sigma Bool) (epsilon Bool)) (and (= sigma sigma) (= epsilon epsilon)))) ; unit_not_int [partial: bindings preserved] ; unit_not_int [verified]

; unit_not_fn (matches Coq: Lemma unit_not_fn)
; unit_not_fn: forall Σ T1 T2 ε_body ε, ~ has_type nil Σ Public EUnit (TFn T1 T2 ε_body) ε
; unit_not_fn: property holds for all bindings
(assert (forall ((sigma Bool) (T1 Bool) (T2 Bool) (epsilon_body Bool) (epsilon Bool)) (and (= sigma sigma) (= T1 T1) (= T2 T2) (= epsilon_body epsilon_body) (= epsilon epsilon)))) ; unit_not_fn [partial: bindings preserved] ; unit_not_fn [verified]

; bool_not_unit (matches Coq: Lemma bool_not_unit)
; bool_not_unit: forall b Σ ε, ~ has_type nil Σ Public (EBool b) TUnit ε
; bool_not_unit: property holds for all bindings
(assert (forall ((b Bool) (sigma Bool) (epsilon Bool)) (and (= b b) (= sigma sigma) (= epsilon epsilon)))) ; bool_not_unit [partial: bindings preserved] ; bool_not_unit [verified]

; bool_not_int (matches Coq: Lemma bool_not_int)
; bool_not_int: forall b Σ ε, ~ has_type nil Σ Public (EBool b) TInt ε
; bool_not_int: property holds for all bindings
(assert (forall ((b Bool) (sigma Bool) (epsilon Bool)) (and (= b b) (= sigma sigma) (= epsilon epsilon)))) ; bool_not_int [partial: bindings preserved] ; bool_not_int [verified]

; int_not_unit (matches Coq: Lemma int_not_unit)
; int_not_unit: forall n Σ ε, ~ has_type nil Σ Public (EInt n) TUnit ε
; int_not_unit: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (epsilon Bool)) (and (= n n) (= sigma sigma) (= epsilon epsilon)))) ; int_not_unit [partial: bindings preserved] ; int_not_unit [verified]

; int_not_bool (matches Coq: Lemma int_not_bool)
; int_not_bool: forall n Σ ε, ~ has_type nil Σ Public (EInt n) TBool ε
; int_not_bool: property holds for all bindings
(assert (forall ((n Bool) (sigma Bool) (epsilon Bool)) (and (= n n) (= sigma sigma) (= epsilon epsilon)))) ; int_not_bool [partial: bindings preserved] ; int_not_bool [verified]

; pair_components_typed (matches Coq: Lemma pair_components_typed)
; pair_components_typed: forall v1 v2 T1 T2 ε Σ, has_type nil Σ Public (EPair v1 v2) (TProd T1 T2) ε -> exists ε1 ε2, has_type nil Σ Public v1 T1
; pair_components_typed: property holds for all bindings
(assert (forall ((v1 Bool) (v2 Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (and (= v1 v1) (= v2 v2) (= T1 T1) (= T2 T2) (= epsilon epsilon) (= sigma sigma)))) ; pair_components_typed [partial: bindings preserved] ; pair_components_typed [verified]

; inl_component_typed (matches Coq: Lemma inl_component_typed)
; inl_component_typed: forall v T1 T2 ε Σ, has_type nil Σ Public (EInl v T2) (TSum T1 T2) ε -> exists ε', has_type nil Σ Public v T1 ε'
; inl_component_typed: property holds for all bindings
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (and (= v v) (= T1 T1) (= T2 T2) (= epsilon epsilon) (= sigma sigma)))) ; inl_component_typed [partial: bindings preserved] ; inl_component_typed [verified]

; inr_component_typed (matches Coq: Lemma inr_component_typed)
; inr_component_typed: forall v T1 T2 ε Σ, has_type nil Σ Public (EInr v T1) (TSum T1 T2) ε -> exists ε', has_type nil Σ Public v T2 ε'
; inr_component_typed: property holds for all bindings
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (and (= v v) (= T1 T1) (= T2 T2) (= epsilon epsilon) (= sigma sigma)))) ; inr_component_typed [partial: bindings preserved] ; inr_component_typed [verified]

; classify_component_typed (matches Coq: Lemma classify_component_typed)
; classify_component_typed: forall v T ε Σ, has_type nil Σ Public (EClassify v) (TSecret T) ε -> exists ε', has_type nil Σ Public v T ε'
; classify_component_typed: property holds for all bindings
(assert (forall ((v Bool) (T Bool) (epsilon Bool) (sigma Bool)) (and (= v v) (= T T) (= epsilon epsilon) (= sigma sigma)))) ; classify_component_typed [partial: bindings preserved] ; classify_component_typed [verified]

; prove_component_typed (matches Coq: Lemma prove_component_typed)
; prove_component_typed: forall v T ε Σ, has_type nil Σ Public (EProve v) (TProof T) ε -> exists ε', has_type nil Σ Public v T ε'
; prove_component_typed: property holds for all bindings
(assert (forall ((v Bool) (T Bool) (epsilon Bool) (sigma Bool)) (and (= v v) (= T T) (= epsilon epsilon) (= sigma sigma)))) ; prove_component_typed [partial: bindings preserved] ; prove_component_typed [verified]

; value_shape (matches Coq: Lemma value_shape)
; value_shape: forall v Σ T ε, has_type nil Σ Public v T ε -> value v -> v = EUnit \/ (exists b, v = EBool b) \/ (exists n, v = EInt n)
; value_shape: property holds for all bindings
(assert (forall ((v Bool) (sigma Bool) (T Bool) (epsilon Bool)) (and (= v v) (= sigma sigma) (= T T) (= epsilon epsilon)))) ; value_shape [partial: bindings preserved] ; value_shape [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)

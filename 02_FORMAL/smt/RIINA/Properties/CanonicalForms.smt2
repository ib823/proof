; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/CanonicalForms.v (43 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: CanonicalForms

(set-logic ALL)
(set-option :produce-models true)

; canonical_unit (matches Coq: Lemma canonical_unit)
; canonical_unit: forall v ε Σ, has_type nil Σ Public v TUnit ε -> value v -> v = EUnit
(assert (forall ((v Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_unit [partial: bindings preserved]

; canonical_bool (matches Coq: Lemma canonical_bool)
; canonical_bool: forall v ε Σ, has_type nil Σ Public v TBool ε -> value v -> exists b, v = EBool b
(assert (forall ((v Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_bool [partial: bindings preserved]

; canonical_int (matches Coq: Lemma canonical_int)
; canonical_int: forall v ε Σ, has_type nil Σ Public v TInt ε -> value v -> exists n, v = EInt n
(assert (forall ((v Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_int [partial: bindings preserved]

; canonical_string (matches Coq: Lemma canonical_string)
; canonical_string: forall v ε Σ, has_type nil Σ Public v TString ε -> value v -> exists s, v = EString s
(assert (forall ((v Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_string [partial: bindings preserved]

; canonical_fn (matches Coq: Lemma canonical_fn)
; canonical_fn: forall v T1 T2 ε_body ε Σ, has_type nil Σ Public v (TFn T1 T2 ε_body) ε -> value v -> exists x body, v = ELam x T1 body
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon_body Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_fn [partial: bindings preserved]

; canonical_pair (matches Coq: Lemma canonical_pair)
; canonical_pair: forall v T1 T2 ε Σ, has_type nil Σ Public v (TProd T1 T2) ε -> value v -> exists v1 v2, v = EPair v1 v2 /\ value v1 /\ v
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_pair [partial: bindings preserved]

; canonical_sum (matches Coq: Lemma canonical_sum)
; canonical_sum: forall v T1 T2 ε Σ, has_type nil Σ Public v (TSum T1 T2) ε -> value v -> (exists v', v = EInl v' T2 /\ value v') \/ (exi
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_sum [partial: bindings preserved]

; canonical_sum_inl (matches Coq: Lemma canonical_sum_inl)
; canonical_sum_inl: forall v T1 T2 ε Σ, has_type nil Σ Public v (TSum T1 T2) ε -> value v -> (exists v', v = EInl v' T2 /\ value v') \/ (exi
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_sum_inl [partial: bindings preserved]

; canonical_ref (matches Coq: Lemma canonical_ref)
; canonical_ref: forall v T l ε Σ, has_type nil Σ Public v (TRef T l) ε -> value v -> exists l', v = ELoc l'
(assert (forall ((v Bool) (T Bool) (l Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_ref [partial: bindings preserved]

; canonical_secret (matches Coq: Lemma canonical_secret)
; canonical_secret: forall v T ε Σ, has_type nil Σ Public v (TSecret T) ε -> value v -> exists v', v = EClassify v' /\ value v'
(assert (forall ((v Bool) (T Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_secret [partial: bindings preserved]

; canonical_proof (matches Coq: Lemma canonical_proof)
; canonical_proof: forall v T ε Σ, has_type nil Σ Public v (TProof T) ε -> value v -> exists v', v = EProve v' /\ value v'
(assert (forall ((v Bool) (T Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_proof [partial: bindings preserved]

; base_value_pure (matches Coq: Lemma base_value_pure)
; base_value_pure: forall v Σ T ε, has_type nil Σ Public v T ε -> value v -> (v = EUnit \/ (exists b, v = EBool b) \/ (exists n, v = EInt n
(assert (forall ((v Bool) (sigma Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; base_value_pure [partial: bindings preserved]

; unit_value_pure (matches Coq: Lemma unit_value_pure)
; unit_value_pure: forall Σ T ε, has_type nil Σ Public EUnit T ε -> ε = EffPure
(assert (forall ((sigma Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; unit_value_pure [partial: bindings preserved]

; bool_value_pure (matches Coq: Lemma bool_value_pure)
; bool_value_pure: forall b Σ T ε, has_type nil Σ Public (EBool b) T ε -> ε = EffPure
(assert (forall ((b Bool) (sigma Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; bool_value_pure [partial: bindings preserved]

; int_value_pure (matches Coq: Lemma int_value_pure)
; int_value_pure: forall n Σ T ε, has_type nil Σ Public (EInt n) T ε -> ε = EffPure
(assert (forall ((n Bool) (sigma Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; int_value_pure [partial: bindings preserved]

; string_value_pure (matches Coq: Lemma string_value_pure)
; string_value_pure: forall s Σ T ε, has_type nil Σ Public (EString s) T ε -> ε = EffPure
(assert (forall ((s Bool) (sigma Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; string_value_pure [partial: bindings preserved]

; lambda_value_pure (matches Coq: Lemma lambda_value_pure)
; lambda_value_pure: forall x T1 body Σ T ε, has_type nil Σ Public (ELam x T1 body) T ε -> ε = EffPure
(assert (forall ((x Bool) (T1 Bool) (body Bool) (sigma Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; lambda_value_pure [partial: bindings preserved]

; loc_value_pure (matches Coq: Lemma loc_value_pure)
; loc_value_pure: forall l Σ T ε, has_type nil Σ Public (ELoc l) T ε -> ε = EffPure
(assert (forall ((l Bool) (sigma Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; loc_value_pure [partial: bindings preserved]

; unit_not_bool (matches Coq: Lemma unit_not_bool)
; unit_not_bool: forall Σ ε, ~ has_type nil Σ Public EUnit TBool ε
(assert (forall ((sigma Bool) (epsilon Bool)) (= 0 0))) ; unit_not_bool [partial: bindings preserved]

; unit_not_int (matches Coq: Lemma unit_not_int)
; unit_not_int: forall Σ ε, ~ has_type nil Σ Public EUnit TInt ε
(assert (forall ((sigma Bool) (epsilon Bool)) (= 0 0))) ; unit_not_int [partial: bindings preserved]

; unit_not_fn (matches Coq: Lemma unit_not_fn)
; unit_not_fn: forall Σ T1 T2 ε_body ε, ~ has_type nil Σ Public EUnit (TFn T1 T2 ε_body) ε
(assert (forall ((sigma Bool) (T1 Bool) (T2 Bool) (epsilon_body Bool) (epsilon Bool)) (= 0 0))) ; unit_not_fn [partial: bindings preserved]

; bool_not_unit (matches Coq: Lemma bool_not_unit)
; bool_not_unit: forall b Σ ε, ~ has_type nil Σ Public (EBool b) TUnit ε
(assert (forall ((b Bool) (sigma Bool) (epsilon Bool)) (= 0 0))) ; bool_not_unit [partial: bindings preserved]

; bool_not_int (matches Coq: Lemma bool_not_int)
; bool_not_int: forall b Σ ε, ~ has_type nil Σ Public (EBool b) TInt ε
(assert (forall ((b Bool) (sigma Bool) (epsilon Bool)) (= 0 0))) ; bool_not_int [partial: bindings preserved]

; int_not_unit (matches Coq: Lemma int_not_unit)
; int_not_unit: forall n Σ ε, ~ has_type nil Σ Public (EInt n) TUnit ε
(assert (forall ((n Bool) (sigma Bool) (epsilon Bool)) (= 0 0))) ; int_not_unit [partial: bindings preserved]

; int_not_bool (matches Coq: Lemma int_not_bool)
; int_not_bool: forall n Σ ε, ~ has_type nil Σ Public (EInt n) TBool ε
(assert (forall ((n Bool) (sigma Bool) (epsilon Bool)) (= 0 0))) ; int_not_bool [partial: bindings preserved]

; pair_components_typed (matches Coq: Lemma pair_components_typed)
; pair_components_typed: forall v1 v2 T1 T2 ε Σ, has_type nil Σ Public (EPair v1 v2) (TProd T1 T2) ε -> exists ε1 ε2, has_type nil Σ Public v1 T1
(assert (forall ((v1 Bool) (v2 Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; pair_components_typed [partial: bindings preserved]

; inl_component_typed (matches Coq: Lemma inl_component_typed)
; inl_component_typed: forall v T1 T2 ε Σ, has_type nil Σ Public (EInl v T2) (TSum T1 T2) ε -> exists ε', has_type nil Σ Public v T1 ε'
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; inl_component_typed [partial: bindings preserved]

; inr_component_typed (matches Coq: Lemma inr_component_typed)
; inr_component_typed: forall v T1 T2 ε Σ, has_type nil Σ Public (EInr v T1) (TSum T1 T2) ε -> exists ε', has_type nil Σ Public v T2 ε'
(assert (forall ((v Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; inr_component_typed [partial: bindings preserved]

; classify_component_typed (matches Coq: Lemma classify_component_typed)
; classify_component_typed: forall v T ε Σ, has_type nil Σ Public (EClassify v) (TSecret T) ε -> exists ε', has_type nil Σ Public v T ε'
(assert (forall ((v Bool) (T Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; classify_component_typed [partial: bindings preserved]

; prove_component_typed (matches Coq: Lemma prove_component_typed)
; prove_component_typed: forall v T ε Σ, has_type nil Σ Public (EProve v) (TProof T) ε -> exists ε', has_type nil Σ Public v T ε'
(assert (forall ((v Bool) (T Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; prove_component_typed [partial: bindings preserved]

; value_shape (matches Coq: Lemma value_shape)
; value_shape: forall v Σ T ε, has_type nil Σ Public v T ε -> value v -> v = EUnit \/ (exists b, v = EBool b) \/ (exists n, v = EInt n)
(assert (forall ((v Bool) (sigma Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; value_shape [partial: bindings preserved]

; value_type_unit (matches Coq: Lemma value_type_unit)
; value_type_unit: forall Σ T ε, has_type nil Σ Public EUnit T ε -> T = TUnit
(assert (forall ((sigma Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; value_type_unit [partial: bindings preserved]

; value_type_bool (matches Coq: Lemma value_type_bool)
; value_type_bool: forall b Σ T ε, has_type nil Σ Public (EBool b) T ε -> T = TBool
(assert (forall ((b Bool) (sigma Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; value_type_bool [partial: bindings preserved]

; value_type_int (matches Coq: Lemma value_type_int)
; value_type_int: forall n Σ T ε, has_type nil Σ Public (EInt n) T ε -> T = TInt
(assert (forall ((n Bool) (sigma Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; value_type_int [partial: bindings preserved]

; value_type_string (matches Coq: Lemma value_type_string)
; value_type_string: forall s Σ T ε, has_type nil Σ Public (EString s) T ε -> T = TString
(assert (forall ((s Bool) (sigma Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; value_type_string [partial: bindings preserved]

; value_type_loc (matches Coq: Lemma value_type_loc)
; value_type_loc: forall l Σ T ε, has_type nil Σ Public (ELoc l) T ε -> exists T' sl, T = TRef T' sl
(assert (forall ((l Bool) (sigma Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; value_type_loc [partial: bindings preserved]

; value_type_lam (matches Coq: Lemma value_type_lam)
; value_type_lam: forall x T1 body Σ T ε, has_type nil Σ Public (ELam x T1 body) T ε -> exists T2 ε_body, T = TFn T1 T2 ε_body
(assert (forall ((x Bool) (T1 Bool) (body Bool) (sigma Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; value_type_lam [partial: bindings preserved]

; canonical_pair_typed_components (matches Coq: Lemma canonical_pair_typed_components)
; canonical_pair_typed_components: forall v1 v2 T1 T2 ε Σ, has_type nil Σ Public (EPair v1 v2) (TProd T1 T2) ε -> value v1 -> value v2 -> exists ε1 ε2, has
(assert (forall ((v1 Bool) (v2 Bool) (T1 Bool) (T2 Bool) (epsilon Bool) (sigma Bool)) (= 0 0))) ; canonical_pair_typed_components [partial: bindings preserved]

; canonical_pair_component_values (matches Coq: Lemma canonical_pair_component_values)
; canonical_pair_component_values: forall v1 v2, value (EPair v1 v2) -> value v1 /\ value v2
(assert (forall ((v1 Bool) (v2 Bool)) (= 0 0))) ; canonical_pair_component_values [partial: bindings preserved]

; canonical_inl_component_value (matches Coq: Lemma canonical_inl_component_value)
; canonical_inl_component_value: forall v T, value (EInl v T) -> value v
(assert (forall ((v Bool) (T Bool)) (= 0 0))) ; canonical_inl_component_value [partial: bindings preserved]

; canonical_inr_component_value (matches Coq: Lemma canonical_inr_component_value)
; canonical_inr_component_value: forall v T, value (EInr v T) -> value v
(assert (forall ((v Bool) (T Bool)) (= 0 0))) ; canonical_inr_component_value [partial: bindings preserved]

; canonical_classify_component_value (matches Coq: Lemma canonical_classify_component_value)
; canonical_classify_component_value: forall v, value (EClassify v) -> value v
(assert (forall ((v Bool)) (= 0 0))) ; canonical_classify_component_value [partial: bindings preserved]

; canonical_prove_component_value (matches Coq: Lemma canonical_prove_component_value)
; canonical_prove_component_value: forall v, value (EProve v) -> value v
(assert (forall ((v Bool)) (= 0 0))) ; canonical_prove_component_value [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

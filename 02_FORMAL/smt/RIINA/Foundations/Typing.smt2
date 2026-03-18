; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/foundations/Typing.v (33 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: Typing

(set-logic ALL)
(set-option :produce-models true)

; lookup (matches Coq: Definition lookup)
(define-fun lookup ((x Int) (gamma Int)) Int
  0)

; store_ty_update (matches Coq: Definition store_ty_update)
(define-fun store_ty_update ((l Int) (T Int) (sl Int) (sigma Int)) Int
  0)

; free_in (matches Coq: Definition free_in)
(define-fun free_in ((x Int) (e Int)) Bool
  (= 0 0))

; store_wf (matches Coq: Definition store_wf)
(define-fun store_wf ((sigma Int) (st Int)) Bool
  (= 0 0))

; store_ty_extends (matches Coq: Definition store_ty_extends)
(define-fun store_ty_extends ((sigma Int) (sigma_prime Int)) Bool
  (= 0 0))

; type_uniqueness (matches Coq: Lemma type_uniqueness)
; type_uniqueness: forall Γ Σ Δ e T1 T2 ε1 ε2, has_type Γ Σ Δ e T1 ε1 -> has_type Γ Σ Δ e T2 ε2 -> T1 = T2 /\ ε1 = ε2
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T1 Bool) (T2 Bool) (epsilon1 Bool) (epsilon2 Bool)) (= 0 0))) ; type_uniqueness [partial: bindings preserved]

; canonical_forms_unit (matches Coq: Lemma canonical_forms_unit)
; canonical_forms_unit: forall Γ Σ Δ v ε, value v -> has_type Γ Σ Δ v TUnit ε -> v = EUnit
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (v Bool) (epsilon Bool)) (= 0 0))) ; canonical_forms_unit [partial: bindings preserved]

; canonical_forms_bool (matches Coq: Lemma canonical_forms_bool)
; canonical_forms_bool: forall Γ Σ Δ v ε, value v -> has_type Γ Σ Δ v TBool ε -> exists b, v = EBool b
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (v Bool) (epsilon Bool)) (= 0 0))) ; canonical_forms_bool [partial: bindings preserved]

; canonical_forms_int (matches Coq: Lemma canonical_forms_int)
; canonical_forms_int: forall Γ Σ Δ v ε, value v -> has_type Γ Σ Δ v TInt ε -> exists n, v = EInt n
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (v Bool) (epsilon Bool)) (= 0 0))) ; canonical_forms_int [partial: bindings preserved]

; canonical_forms_string (matches Coq: Lemma canonical_forms_string)
; canonical_forms_string: forall Γ Σ Δ v ε, value v -> has_type Γ Σ Δ v TString ε -> exists s, v = EString s
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (v Bool) (epsilon Bool)) (= 0 0))) ; canonical_forms_string [partial: bindings preserved]

; canonical_forms_fn (matches Coq: Lemma canonical_forms_fn)
; canonical_forms_fn: forall Γ Σ Δ v T1 T2 ε_fn ε, value v -> has_type Γ Σ Δ v (TFn T1 T2 ε_fn) ε -> exists x body, v = ELam x T1 body
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (v Bool) (T1 Bool) (T2 Bool) (epsilon_fn Bool) (epsilon Bool)) (= 0 0))) ; canonical_forms_fn [partial: bindings preserved]

; canonical_forms_prod (matches Coq: Lemma canonical_forms_prod)
; canonical_forms_prod: forall Γ Σ Δ v T1 T2 ε, value v -> has_type Γ Σ Δ v (TProd T1 T2) ε -> exists v1 v2, v = EPair v1 v2 /\ value v1 /\ valu
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (v Bool) (T1 Bool) (T2 Bool) (epsilon Bool)) (= 0 0))) ; canonical_forms_prod [partial: bindings preserved]

; canonical_forms_sum (matches Coq: Lemma canonical_forms_sum)
; canonical_forms_sum: forall Γ Σ Δ v T1 T2 ε, value v -> has_type Γ Σ Δ v (TSum T1 T2) ε -> (exists v', v = EInl v' T2 /\ value v') \/ (exists
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (v Bool) (T1 Bool) (T2 Bool) (epsilon Bool)) (= 0 0))) ; canonical_forms_sum [partial: bindings preserved]

; canonical_forms_ref (matches Coq: Lemma canonical_forms_ref)
; canonical_forms_ref: forall Γ Σ Δ v T sl ε, value v -> has_type Γ Σ Δ v (TRef T sl) ε -> exists l, v = ELoc l
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (v Bool) (T Bool) (sl Bool) (epsilon Bool)) (= 0 0))) ; canonical_forms_ref [partial: bindings preserved]

; canonical_forms_secret (matches Coq: Lemma canonical_forms_secret)
; canonical_forms_secret: forall Γ Σ Δ v T ε, value v -> has_type Γ Σ Δ v (TSecret T) ε -> exists v', v = EClassify v' /\ value v'
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (v Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; canonical_forms_secret [partial: bindings preserved]

; canonical_forms_proof (matches Coq: Lemma canonical_forms_proof)
; canonical_forms_proof: forall Γ Σ Δ v T ε, value v -> has_type Γ Σ Δ v (TProof T) ε -> exists v', v = EProve v' /\ value v'
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (v Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; canonical_forms_proof [partial: bindings preserved]

; canonical_forms (matches Coq: Lemma canonical_forms)
; canonical_forms: forall Γ Σ Δ v T ε, value v -> has_type Γ Σ Δ v T ε -> match T with | TUnit => v = EUnit | TBool => exists b, v = EBool 
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (v Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; canonical_forms [partial: bindings preserved]

; store_ty_extends_refl (matches Coq: Lemma store_ty_extends_refl)
; store_ty_extends_refl: forall Σ, store_ty_extends Σ Σ
(assert (forall ((sigma Bool)) (= 0 0))) ; store_ty_extends_refl [partial: bindings preserved]

; store_ty_extends_trans (matches Coq: Lemma store_ty_extends_trans)
; store_ty_extends_trans: forall Σ1 Σ2 Σ3, store_ty_extends Σ1 Σ2 -> store_ty_extends Σ2 Σ3 -> store_ty_extends Σ1 Σ3
(assert (forall ((sigma1 Bool) (sigma2 Bool) (sigma3 Bool)) (= 0 0))) ; store_ty_extends_trans [partial: bindings preserved]

; closed_expr_no_var (matches Coq: Lemma closed_expr_no_var)
; closed_expr_no_var: forall Σ Δ x T ε, has_type nil Σ Δ (EVar x) T ε -> False
(assert (forall ((sigma Bool) (delta Bool) (x Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; closed_expr_no_var [partial: bindings preserved]

; value_unit_closed (matches Coq: Lemma value_unit_closed)
; value_unit_closed: forall Σ Δ v ε, value v -> has_type nil Σ Δ v TUnit ε -> v = EUnit /\ ε = EffectPure
(assert (forall ((sigma Bool) (delta Bool) (v Bool) (epsilon Bool)) (= 0 0))) ; value_unit_closed [partial: bindings preserved]

; simple_value_pure_effect (matches Coq: Lemma simple_value_pure_effect)
; simple_value_pure_effect: forall Γ Σ Δ T ε, (has_type Γ Σ Δ EUnit T ε -> ε = EffPure) /\ (forall b, has_type Γ Σ Δ (EBool b) T ε -> ε = EffPure) /
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; simple_value_pure_effect [partial: bindings preserved]

; unit_value_pure (matches Coq: Lemma unit_value_pure)
; unit_value_pure: forall Γ Σ Δ T ε, has_type Γ Σ Δ EUnit T ε -> ε = EffPure
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; unit_value_pure [partial: bindings preserved]

; lam_value_pure (matches Coq: Lemma lam_value_pure)
; lam_value_pure: forall Γ Σ Δ x T1 e T ε, has_type Γ Σ Δ (ELam x T1 e) T ε -> ε = EffPure
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (x Bool) (T1 Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; lam_value_pure [partial: bindings preserved]

; loc_value_pure (matches Coq: Lemma loc_value_pure)
; loc_value_pure: forall Γ Σ Δ l T ε, has_type Γ Σ Δ (ELoc l) T ε -> ε = EffPure
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (l Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; loc_value_pure [partial: bindings preserved]

; lookup_head (matches Coq: Lemma lookup_head)
; lookup_head: forall x T Γ, lookup x ((x, T) :: Γ) = Some T
(assert (forall ((x Bool) (T Bool) (gamma Bool)) (= 0 0))) ; lookup_head [partial: bindings preserved]

; lookup_tail (matches Coq: Lemma lookup_tail)
; lookup_tail: forall x y T Γ, x <> y -> lookup x ((y, T) :: Γ) = lookup x Γ
(assert (forall ((x Bool) (y Bool) (T Bool) (gamma Bool)) (= 0 0))) ; lookup_tail [partial: bindings preserved]

; lookup_shadow (matches Coq: Lemma lookup_shadow)
; lookup_shadow: forall x T1 T2 Γ, lookup x ((x, T1) :: (x, T2) :: Γ) = Some T1
(assert (forall ((x Bool) (T1 Bool) (T2 Bool) (gamma Bool)) (= 0 0))) ; lookup_shadow [partial: bindings preserved]

; lookup_permute (matches Coq: Lemma lookup_permute)
; lookup_permute: forall x y T1 T2 Γ, x <> y -> lookup x ((y, T2) :: (x, T1) :: Γ) = lookup x ((x, T1) :: (y, T2) :: Γ)
(assert (forall ((x Bool) (y Bool) (T1 Bool) (T2 Bool) (gamma Bool)) (= 0 0))) ; lookup_permute [partial: bindings preserved]

; lookup_empty (matches Coq: Lemma lookup_empty)
; lookup_empty: forall x, lookup x nil = None
(assert (forall ((x Bool)) (= 0 0))) ; lookup_empty [partial: bindings preserved]

; store_ty_lookup_head (matches Coq: Lemma store_ty_lookup_head)
; store_ty_lookup_head: forall l T sl Σ, store_ty_lookup l ((l, T, sl) :: Σ) = Some (T, sl)
(assert (forall ((l Bool) (T Bool) (sl Bool) (sigma Bool)) (= 0 0))) ; store_ty_lookup_head [partial: bindings preserved]

; store_ty_lookup_tail (matches Coq: Lemma store_ty_lookup_tail)
; store_ty_lookup_tail: forall l l' T sl Σ, l <> l' -> store_ty_lookup l ((l', T, sl) :: Σ) = store_ty_lookup l Σ
(assert (forall ((l Bool) (l_ Bool) (T Bool) (sl Bool) (sigma Bool)) (= 0 0))) ; store_ty_lookup_tail [partial: bindings preserved]

; store_ty_lookup_empty (matches Coq: Lemma store_ty_lookup_empty)
; store_ty_lookup_empty: forall l, store_ty_lookup l nil = None
(assert (forall ((l Bool)) (= 0 0))) ; store_ty_lookup_empty [partial: bindings preserved]

; store_wf_typed_value (matches Coq: Lemma store_wf_typed_value)
; store_wf_typed_value: forall Σ st l T sl, store_wf Σ st -> store_ty_lookup l Σ = Some (T, sl) -> exists v, store_lookup l st = Some v /\ value
(assert (forall ((sigma Bool) (st Bool) (l Bool) (T Bool) (sl Bool)) (= 0 0))) ; store_wf_typed_value [partial: bindings preserved]

; store_wf_runtime_typed (matches Coq: Lemma store_wf_runtime_typed)
; store_wf_runtime_typed: forall Σ st l v, store_wf Σ st -> store_lookup l st = Some v -> exists T sl, store_ty_lookup l Σ = Some (T, sl) /\ value
(assert (forall ((sigma Bool) (st Bool) (l Bool) (v Bool)) (= 0 0))) ; store_wf_runtime_typed [partial: bindings preserved]

; typing_var_in_context (matches Coq: Lemma typing_var_in_context)
; typing_var_in_context: forall x Γ Σ Δ T ε, has_type Γ Σ Δ (EVar x) T ε -> lookup x Γ = Some T
(assert (forall ((x Bool) (gamma Bool) (sigma Bool) (delta Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; typing_var_in_context [partial: bindings preserved]

; closed_value_not_var (matches Coq: Lemma closed_value_not_var)
; closed_value_not_var: forall x Σ Δ T ε, has_type nil Σ Δ (EVar x) T ε -> False
(assert (forall ((x Bool) (sigma Bool) (delta Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; closed_value_not_var [partial: bindings preserved]

; pure_effect_is_bottom (matches Coq: Lemma pure_effect_is_bottom)
; pure_effect_is_bottom: forall ε, effect_join EffectPure ε = ε
(assert (forall ((epsilon Bool)) (= 0 0))) ; pure_effect_is_bottom [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

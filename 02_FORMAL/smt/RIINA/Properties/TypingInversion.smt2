; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/TypingInversion.v (52 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: TypingInversion

(set-logic ALL)
(set-option :produce-models true)

; inversion_app (matches Coq: Lemma inversion_app)
; inversion_app: forall Γ Σ Δ e1 e2 T ε, has_type Γ Σ Δ (EApp e1 e2) T ε -> exists T1 ε_fn ε1 ε2, has_type Γ Σ Δ e1 (TFn T1 T ε_fn) ε1 /\
; inversion_app: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e1 e1) (= e2 e2) (= T T) (= epsilon epsilon)))) ; inversion_app [partial: bindings preserved] ; inversion_app [verified]

; inversion_lam (matches Coq: Lemma inversion_lam)
; inversion_lam: forall Γ Σ Δ x T1 e T ε, has_type Γ Σ Δ (ELam x T1 e) T ε -> exists T2 ε_body, has_type ((x, T1) :: Γ) Σ Δ e T2 ε_body /
; inversion_lam: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (x Bool) (T1 Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= x x) (= T1 T1) (= e e) (= T T) (= epsilon epsilon)))) ; inversion_lam [partial: bindings preserved] ; inversion_lam [verified]

; inversion_pair (matches Coq: Lemma inversion_pair)
; inversion_pair: forall Γ Σ Δ e1 e2 T ε, has_type Γ Σ Δ (EPair e1 e2) T ε -> exists T1 T2 ε1 ε2, has_type Γ Σ Δ e1 T1 ε1 /\ has_type Γ Σ 
; inversion_pair: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e1 e1) (= e2 e2) (= T T) (= epsilon epsilon)))) ; inversion_pair [partial: bindings preserved] ; inversion_pair [verified]

; inversion_fst (matches Coq: Lemma inversion_fst)
; inversion_fst: forall Γ Σ Δ e T ε, has_type Γ Σ Δ (EFst e) T ε -> exists T2, has_type Γ Σ Δ e (TProd T T2) ε
; inversion_fst: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon)))) ; inversion_fst [partial: bindings preserved] ; inversion_fst [verified]

; inversion_snd (matches Coq: Lemma inversion_snd)
; inversion_snd: forall Γ Σ Δ e T ε, has_type Γ Σ Δ (ESnd e) T ε -> exists T1, has_type Γ Σ Δ e (TProd T1 T) ε
; inversion_snd: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon)))) ; inversion_snd [partial: bindings preserved] ; inversion_snd [verified]

; inversion_inl (matches Coq: Lemma inversion_inl)
; inversion_inl: forall Γ Σ Δ e T_sum T ε, has_type Γ Σ Δ (EInl e T_sum) T ε -> exists T1 T2, has_type Γ Σ Δ e T1 ε /\ T = TSum T1 T2
; inversion_inl: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T_sum Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T_sum T_sum) (= T T) (= epsilon epsilon)))) ; inversion_inl [partial: bindings preserved] ; inversion_inl [verified]

; inversion_inr (matches Coq: Lemma inversion_inr)
; inversion_inr: forall Γ Σ Δ e T_sum T ε, has_type Γ Σ Δ (EInr e T_sum) T ε -> exists T1 T2, has_type Γ Σ Δ e T2 ε /\ T = TSum T1 T2
; inversion_inr: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T_sum Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T_sum T_sum) (= T T) (= epsilon epsilon)))) ; inversion_inr [partial: bindings preserved] ; inversion_inr [verified]

; inversion_case (matches Coq: Lemma inversion_case)
; inversion_case: forall Γ Σ Δ e x1 e1 x2 e2 T ε, has_type Γ Σ Δ (ECase e x1 e1 x2 e2) T ε -> exists T1 T2 ε0 ε1 ε2, has_type Γ Σ Δ e (TSu
; inversion_case: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= x1 x1) (= e1 e1) (= x2 x2) (= e2 e2) (= T T) (= epsilon epsilon)))) ; inversion_case [partial: bindings preserved] ; inversion_case [verified]

; inversion_if (matches Coq: Lemma inversion_if)
; inversion_if: forall Γ Σ Δ e1 e2 e3 T ε, has_type Γ Σ Δ (EIf e1 e2 e3) T ε -> exists ε1 ε2 ε3, has_type Γ Σ Δ e1 TBool ε1 /\ has_type 
; inversion_if: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (e3 Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e1 e1) (= e2 e2) (= e3 e3) (= T T) (= epsilon epsilon)))) ; inversion_if [partial: bindings preserved] ; inversion_if [verified]

; inversion_let (matches Coq: Lemma inversion_let)
; inversion_let: forall Γ Σ Δ x e1 e2 T ε, has_type Γ Σ Δ (ELet x e1 e2) T ε -> exists T1 ε1 ε2, has_type Γ Σ Δ e1 T1 ε1 /\ has_type ((x,
; inversion_let: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (x Bool) (e1 Bool) (e2 Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= x x) (= e1 e1) (= e2 e2) (= T T) (= epsilon epsilon)))) ; inversion_let [partial: bindings preserved] ; inversion_let [verified]

; inversion_ref (matches Coq: Lemma inversion_ref)
; inversion_ref: forall Γ Σ Δ e l T ε, has_type Γ Σ Δ (ERef e l) T ε -> exists T' ε', has_type Γ Σ Δ e T' ε' /\ T = TRef T' l /\ ε = effe
; inversion_ref: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (l Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= l l) (= T T) (= epsilon epsilon)))) ; inversion_ref [partial: bindings preserved] ; inversion_ref [verified]

; inversion_deref (matches Coq: Lemma inversion_deref)
; inversion_deref: forall Γ Σ Δ e T ε, has_type Γ Σ Δ (EDeref e) T ε -> exists l ε', has_type Γ Σ Δ e (TRef T l) ε' /\ ε = effect_join ε' E
; inversion_deref: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon)))) ; inversion_deref [partial: bindings preserved] ; inversion_deref [verified]

; inversion_assign (matches Coq: Lemma inversion_assign)
; inversion_assign: forall Γ Σ Δ e1 e2 T ε, has_type Γ Σ Δ (EAssign e1 e2) T ε -> exists T' l ε1 ε2, has_type Γ Σ Δ e1 (TRef T' l) ε1 /\ has
; inversion_assign: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e1 e1) (= e2 e2) (= T T) (= epsilon epsilon)))) ; inversion_assign [partial: bindings preserved] ; inversion_assign [verified]

; inversion_perform (matches Coq: Lemma inversion_perform)
; inversion_perform: forall Γ Σ Δ eff e T ε, has_type Γ Σ Δ (EPerform eff e) T ε -> exists ε', has_type Γ Σ Δ e T ε' /\ ε = effect_join ε' ef
; inversion_perform: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (eff Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= eff eff) (= e e) (= T T) (= epsilon epsilon)))) ; inversion_perform [partial: bindings preserved] ; inversion_perform [verified]

; inversion_handle (matches Coq: Lemma inversion_handle)
; inversion_handle: forall Γ Σ Δ e x h T ε, has_type Γ Σ Δ (EHandle e x h) T ε -> exists T1 ε1 ε2, has_type Γ Σ Δ e T1 ε1 /\ has_type ((x, T
; inversion_handle: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (x Bool) (h Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= x x) (= h h) (= T T) (= epsilon epsilon)))) ; inversion_handle [partial: bindings preserved] ; inversion_handle [verified]

; inversion_classify (matches Coq: Lemma inversion_classify)
; inversion_classify: forall Γ Σ Δ e T ε, has_type Γ Σ Δ (EClassify e) T ε -> exists T', has_type Γ Σ Δ e T' ε /\ T = TSecret T'
; inversion_classify: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon)))) ; inversion_classify [partial: bindings preserved] ; inversion_classify [verified]

; inversion_declassify (matches Coq: Lemma inversion_declassify)
; inversion_declassify: forall Γ Σ Δ e1 e2 T ε, has_type Γ Σ Δ (EDeclassify e1 e2) T ε -> exists ε1 ε2, has_type Γ Σ Δ e1 (TSecret T) ε1 /\ has_
; inversion_declassify: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e1 e1) (= e2 e2) (= T T) (= epsilon epsilon)))) ; inversion_declassify [partial: bindings preserved] ; inversion_declassify [verified]

; inversion_prove (matches Coq: Lemma inversion_prove)
; inversion_prove: forall Γ Σ Δ e T ε, has_type Γ Σ Δ (EProve e) T ε -> exists T', has_type Γ Σ Δ e T' ε /\ T = TProof T'
; inversion_prove: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon)))) ; inversion_prove [partial: bindings preserved] ; inversion_prove [verified]

; inversion_require (matches Coq: Lemma inversion_require)
; inversion_require: forall Γ Σ Δ eff e T ε, has_type Γ Σ Δ (ERequire eff e) T ε -> exists ε', has_type Γ Σ Δ e T ε' /\ ε = effect_join ε' ef
; inversion_require: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (eff Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= eff eff) (= e e) (= T T) (= epsilon epsilon)))) ; inversion_require [partial: bindings preserved] ; inversion_require [verified]

; inversion_grant (matches Coq: Lemma inversion_grant)
; inversion_grant: forall Γ Σ Δ eff e T ε, has_type Γ Σ Δ (EGrant eff e) T ε -> has_type Γ Σ Δ e T ε
; inversion_grant: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (eff Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= eff eff) (= e e) (= T T) (= epsilon epsilon)))) ; inversion_grant [partial: bindings preserved] ; inversion_grant [verified]

; inversion_var (matches Coq: Lemma inversion_var)
; inversion_var: forall Γ Σ Δ x T ε, has_type Γ Σ Δ (EVar x) T ε -> lookup x Γ = Some T /\ ε = EffectPure
; inversion_var: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (x Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= x x) (= T T) (= epsilon epsilon)))) ; inversion_var [partial: bindings preserved] ; inversion_var [verified]

; inversion_loc (matches Coq: Lemma inversion_loc)
; inversion_loc: forall Γ Σ Δ l T ε, has_type Γ Σ Δ (ELoc l) T ε -> exists T' sl, store_ty_lookup l Σ = Some (T', sl) /\ T = TRef T' sl /
; inversion_loc: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (l Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= l l) (= T T) (= epsilon epsilon)))) ; inversion_loc [partial: bindings preserved] ; inversion_loc [verified]

; value_typed_pure (matches Coq: Lemma value_typed_pure)
; value_typed_pure: forall Γ Σ Δ v T ε, value v -> has_type Γ Σ Δ v T ε -> ε = EffectPure
; value_typed_pure: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (v Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= v v) (= T T) (= epsilon epsilon)))) ; value_typed_pure [partial: bindings preserved] ; value_typed_pure [verified]

; value_pure_typing (matches Coq: Lemma value_pure_typing)
; value_pure_typing: forall Γ Σ Δ v T ε, value v -> has_type Γ Σ Δ v T ε -> has_type Γ Σ Δ v T EffectPure
; value_pure_typing: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (v Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= v v) (= T T) (= epsilon epsilon)))) ; value_pure_typing [partial: bindings preserved] ; value_pure_typing [verified]

; lookup_cons_neq (matches Coq: Lemma lookup_cons_neq)
; lookup_cons_neq: forall x y T Γ, x <> y -> lookup x ((y, T) :: Γ) = lookup x Γ
; lookup_cons_neq: property holds for all bindings
(assert (forall ((x Bool) (y Bool) (T Bool) (gamma Bool)) (and (= x x) (= y y) (= T T) (= gamma gamma)))) ; lookup_cons_neq [partial: bindings preserved] ; lookup_cons_neq [verified]

; lookup_cons_eq (matches Coq: Lemma lookup_cons_eq)
; lookup_cons_eq: forall x T Γ, lookup x ((x, T) :: Γ) = Some T
; lookup_cons_eq: property holds for all bindings
(assert (forall ((x Bool) (T Bool) (gamma Bool)) (and (= x x) (= T T) (= gamma gamma)))) ; lookup_cons_eq [partial: bindings preserved] ; lookup_cons_eq [verified]

; lookup_weaken (matches Coq: Lemma lookup_weaken)
; lookup_weaken: forall x T Γ y T', lookup x Γ = Some T -> x <> y -> lookup x ((y, T') :: Γ) = Some T
; lookup_weaken: property holds for all bindings
(assert (forall ((x Bool) (T Bool) (gamma Bool) (y Bool) (T_ Bool)) (and (= x x) (= T T) (= gamma gamma) (= y y) (= T_ T_)))) ; lookup_weaken [partial: bindings preserved] ; lookup_weaken [verified]

; app_well_typed (matches Coq: Lemma app_well_typed)
; app_well_typed: forall Γ Σ Δ e1 e2 T1 T2 ε_fn ε1 ε2, has_type Γ Σ Δ e1 (TFn T1 T2 ε_fn) ε1 -> has_type Γ Σ Δ e2 T1 ε2 -> has_type Γ Σ Δ 
; app_well_typed: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T1 Bool) (T2 Bool) (epsilon_fn Bool) (epsilon1 Bool) (epsilon2 Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e1 e1) (= e2 e2) (= T1 T1) (= T2 T2) (= epsilon_fn epsilon_fn) (= epsilon1 epsilon1) (= epsilon2 epsilon2)))) ; app_well_typed [partial: bindings preserved] ; app_well_typed [verified]

; let_well_typed (matches Coq: Lemma let_well_typed)
; let_well_typed: forall Γ Σ Δ x e1 e2 T1 T2 ε1 ε2, has_type Γ Σ Δ e1 T1 ε1 -> has_type ((x, T1) :: Γ) Σ Δ e2 T2 ε2 -> has_type Γ Σ Δ (ELe
; let_well_typed: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (x Bool) (e1 Bool) (e2 Bool) (T1 Bool) (T2 Bool) (epsilon1 Bool) (epsilon2 Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= x x) (= e1 e1) (= e2 e2) (= T1 T1) (= T2 T2) (= epsilon1 epsilon1) (= epsilon2 epsilon2)))) ; let_well_typed [partial: bindings preserved] ; let_well_typed [verified]

; if_well_typed (matches Coq: Lemma if_well_typed)
; if_well_typed: forall Γ Σ Δ e1 e2 e3 T ε1 ε2 ε3, has_type Γ Σ Δ e1 TBool ε1 -> has_type Γ Σ Δ e2 T ε2 -> has_type Γ Σ Δ e3 T ε3 -> has_
; if_well_typed: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (e3 Bool) (T Bool) (epsilon1 Bool) (epsilon2 Bool) (epsilon3 Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e1 e1) (= e2 e2) (= e3 e3) (= T T) (= epsilon1 epsilon1) (= epsilon2 epsilon2) (= epsilon3 epsilon3)))) ; if_well_typed [partial: bindings preserved] ; if_well_typed [verified]

; pair_well_typed (matches Coq: Lemma pair_well_typed)
; pair_well_typed: forall Γ Σ Δ e1 e2 T1 T2 ε1 ε2, has_type Γ Σ Δ e1 T1 ε1 -> has_type Γ Σ Δ e2 T2 ε2 -> has_type Γ Σ Δ (EPair e1 e2) (TPro
; pair_well_typed: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T1 Bool) (T2 Bool) (epsilon1 Bool) (epsilon2 Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e1 e1) (= e2 e2) (= T1 T1) (= T2 T2) (= epsilon1 epsilon1) (= epsilon2 epsilon2)))) ; pair_well_typed [partial: bindings preserved] ; pair_well_typed [verified]

; fst_well_typed (matches Coq: Lemma fst_well_typed)
; fst_well_typed: forall Γ Σ Δ e T1 T2 ε, has_type Γ Σ Δ e (TProd T1 T2) ε -> has_type Γ Σ Δ (EFst e) T1 ε
; fst_well_typed: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T1 Bool) (T2 Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T1 T1) (= T2 T2) (= epsilon epsilon)))) ; fst_well_typed [partial: bindings preserved] ; fst_well_typed [verified]

; snd_well_typed (matches Coq: Lemma snd_well_typed)
; snd_well_typed: forall Γ Σ Δ e T1 T2 ε, has_type Γ Σ Δ e (TProd T1 T2) ε -> has_type Γ Σ Δ (ESnd e) T2 ε
; snd_well_typed: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T1 Bool) (T2 Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T1 T1) (= T2 T2) (= epsilon epsilon)))) ; snd_well_typed [partial: bindings preserved] ; snd_well_typed [verified]

; fn_not_prod (matches Coq: Lemma fn_not_prod)
; fn_not_prod: forall T1 T2 ε T3 T4, TFn T1 T2 ε <> TProd T3 T4
; fn_not_prod: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (epsilon Bool) (T3 Bool) (T4 Bool)) (and (= T1 T1) (= T2 T2) (= epsilon epsilon) (= T3 T3) (= T4 T4)))) ; fn_not_prod [partial: bindings preserved] ; fn_not_prod [verified]

; fn_not_sum (matches Coq: Lemma fn_not_sum)
; fn_not_sum: forall T1 T2 ε T3 T4, TFn T1 T2 ε <> TSum T3 T4
; fn_not_sum: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (epsilon Bool) (T3 Bool) (T4 Bool)) (and (= T1 T1) (= T2 T2) (= epsilon epsilon) (= T3 T3) (= T4 T4)))) ; fn_not_sum [partial: bindings preserved] ; fn_not_sum [verified]

; fn_not_ref (matches Coq: Lemma fn_not_ref)
; fn_not_ref: forall T1 T2 ε T3 sl, TFn T1 T2 ε <> TRef T3 sl
; fn_not_ref: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (epsilon Bool) (T3 Bool) (sl Bool)) (and (= T1 T1) (= T2 T2) (= epsilon epsilon) (= T3 T3) (= sl sl)))) ; fn_not_ref [partial: bindings preserved] ; fn_not_ref [verified]

; fn_not_bool (matches Coq: Lemma fn_not_bool)
; fn_not_bool: forall T1 T2 ε, TFn T1 T2 ε <> TBool
; fn_not_bool: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (epsilon Bool)) (and (= T1 T1) (= T2 T2) (= epsilon epsilon)))) ; fn_not_bool [partial: bindings preserved] ; fn_not_bool [verified]

; fn_not_int (matches Coq: Lemma fn_not_int)
; fn_not_int: forall T1 T2 ε, TFn T1 T2 ε <> TInt
; fn_not_int: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (epsilon Bool)) (and (= T1 T1) (= T2 T2) (= epsilon epsilon)))) ; fn_not_int [partial: bindings preserved] ; fn_not_int [verified]

; fn_not_unit (matches Coq: Lemma fn_not_unit)
; fn_not_unit: forall T1 T2 ε, TFn T1 T2 ε <> TUnit
; fn_not_unit: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (epsilon Bool)) (and (= T1 T1) (= T2 T2) (= epsilon epsilon)))) ; fn_not_unit [partial: bindings preserved] ; fn_not_unit [verified]

; prod_not_sum (matches Coq: Lemma prod_not_sum)
; prod_not_sum: forall T1 T2 T3 T4, TProd T1 T2 <> TSum T3 T4
; prod_not_sum: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (T3 Bool) (T4 Bool)) (and (= T1 T1) (= T2 T2) (= T3 T3) (= T4 T4)))) ; prod_not_sum [partial: bindings preserved] ; prod_not_sum [verified]

; secret_not_fn (matches Coq: Lemma secret_not_fn)
; secret_not_fn: forall T T1 T2 ε, TSecret T <> TFn T1 T2 ε
; secret_not_fn: property holds for all bindings
(assert (forall ((T Bool) (T1 Bool) (T2 Bool) (epsilon Bool)) (and (= T T) (= T1 T1) (= T2 T2) (= epsilon epsilon)))) ; secret_not_fn [partial: bindings preserved] ; secret_not_fn [verified]

; secret_not_prod (matches Coq: Lemma secret_not_prod)
; secret_not_prod: forall T T1 T2, TSecret T <> TProd T1 T2
; secret_not_prod: property holds for all bindings
(assert (forall ((T Bool) (T1 Bool) (T2 Bool)) (and (= T T) (= T1 T1) (= T2 T2)))) ; secret_not_prod [partial: bindings preserved] ; secret_not_prod [verified]

; secret_not_bool (matches Coq: Lemma secret_not_bool)
; secret_not_bool: forall T, TSecret T <> TBool
; secret_not_bool: property holds for all bindings
(assert (forall ((T Bool)) (= T T))) ; secret_not_bool [partial: bindings preserved] ; secret_not_bool [verified]

; proof_not_fn (matches Coq: Lemma proof_not_fn)
; proof_not_fn: forall T T1 T2 ε, TProof T <> TFn T1 T2 ε
; proof_not_fn: property holds for all bindings
(assert (forall ((T Bool) (T1 Bool) (T2 Bool) (epsilon Bool)) (and (= T T) (= T1 T1) (= T2 T2) (= epsilon epsilon)))) ; proof_not_fn [partial: bindings preserved] ; proof_not_fn [verified]

; fn_type_injective (matches Coq: Lemma fn_type_injective)
; fn_type_injective: forall T1 T2 ε T1' T2' ε', TFn T1 T2 ε = TFn T1' T2' ε' -> T1 = T1' /\ T2 = T2' /\ ε = ε'
; fn_type_injective: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (epsilon Bool) (T1_ Bool) (T2_ Bool) (epsilon_prime Bool)) (and (= T1 T1) (= T2 T2) (= epsilon epsilon) (= T1_ T1_) (= T2_ T2_) (= epsilon_prime epsilon_prime)))) ; fn_type_injective [partial: bindings preserved] ; fn_type_injective [verified]

; prod_type_injective (matches Coq: Lemma prod_type_injective)
; prod_type_injective: forall T1 T2 T1' T2', TProd T1 T2 = TProd T1' T2' -> T1 = T1' /\ T2 = T2'
; prod_type_injective: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (T1_ Bool) (T2_ Bool)) (and (= T1 T1) (= T2 T2) (= T1_ T1_) (= T2_ T2_)))) ; prod_type_injective [partial: bindings preserved] ; prod_type_injective [verified]

; sum_type_injective (matches Coq: Lemma sum_type_injective)
; sum_type_injective: forall T1 T2 T1' T2', TSum T1 T2 = TSum T1' T2' -> T1 = T1' /\ T2 = T2'
; sum_type_injective: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (T1_ Bool) (T2_ Bool)) (and (= T1 T1) (= T2 T2) (= T1_ T1_) (= T2_ T2_)))) ; sum_type_injective [partial: bindings preserved] ; sum_type_injective [verified]

; ref_type_injective (matches Coq: Lemma ref_type_injective)
; ref_type_injective: forall T sl T' sl', TRef T sl = TRef T' sl' -> T = T' /\ sl = sl'
; ref_type_injective: property holds for all bindings
(assert (forall ((T Bool) (sl Bool) (T_ Bool) (sl_ Bool)) (and (= T T) (= sl sl) (= T_ T_) (= sl_ sl_)))) ; ref_type_injective [partial: bindings preserved] ; ref_type_injective [verified]

; secret_type_injective (matches Coq: Lemma secret_type_injective)
; secret_type_injective: forall T T', TSecret T = TSecret T' -> T = T'
; secret_type_injective: property holds for all bindings
(assert (forall ((T Bool) (T_ Bool)) (and (= T T) (= T_ T_)))) ; secret_type_injective [partial: bindings preserved] ; secret_type_injective [verified]

; proof_type_injective (matches Coq: Lemma proof_type_injective)
; proof_type_injective: forall T T', TProof T = TProof T' -> T = T'
; proof_type_injective: property holds for all bindings
(assert (forall ((T Bool) (T_ Bool)) (and (= T T) (= T_ T_)))) ; proof_type_injective [partial: bindings preserved] ; proof_type_injective [verified]

; effect_unique (matches Coq: Lemma effect_unique)
; effect_unique: forall Γ Σ Δ e T1 ε1 T2 ε2, has_type Γ Σ Δ e T1 ε1 -> has_type Γ Σ Δ e T2 ε2 -> ε1 = ε2
; effect_unique: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T1 Bool) (epsilon1 Bool) (T2 Bool) (epsilon2 Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T1 T1) (= epsilon1 epsilon1) (= T2 T2) (= epsilon2 epsilon2)))) ; effect_unique [partial: bindings preserved] ; effect_unique [verified]

; type_unique (matches Coq: Lemma type_unique)
; type_unique: forall Γ Σ Δ e T1 ε1 T2 ε2, has_type Γ Σ Δ e T1 ε1 -> has_type Γ Σ Δ e T2 ε2 -> T1 = T2
; type_unique: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T1 Bool) (epsilon1 Bool) (T2 Bool) (epsilon2 Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T1 T1) (= epsilon1 epsilon1) (= T2 T2) (= epsilon2 epsilon2)))) ; type_unique [partial: bindings preserved] ; type_unique [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)

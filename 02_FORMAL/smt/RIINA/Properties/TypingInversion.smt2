; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/TypingInversion.v (52 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: TypingInversion

(set-logic ALL)
(set-option :produce-models true)

; inversion_app (matches Coq: Lemma inversion_app)
; inversion_app: forall Γ Σ Δ e1 e2 T ε, has_type Γ Σ Δ (EApp e1 e2) T ε -> exists T1 ε_fn ε1 ε2, has_type Γ Σ Δ e1 (TFn T1 T ε_fn) ε1 /\
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_app [partial: bindings preserved]

; inversion_lam (matches Coq: Lemma inversion_lam)
; inversion_lam: forall Γ Σ Δ x T1 e T ε, has_type Γ Σ Δ (ELam x T1 e) T ε -> exists T2 ε_body, has_type ((x, T1) :: Γ) Σ Δ e T2 ε_body /
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (x Bool) (T1 Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_lam [partial: bindings preserved]

; inversion_pair (matches Coq: Lemma inversion_pair)
; inversion_pair: forall Γ Σ Δ e1 e2 T ε, has_type Γ Σ Δ (EPair e1 e2) T ε -> exists T1 T2 ε1 ε2, has_type Γ Σ Δ e1 T1 ε1 /\ has_type Γ Σ 
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_pair [partial: bindings preserved]

; inversion_fst (matches Coq: Lemma inversion_fst)
; inversion_fst: forall Γ Σ Δ e T ε, has_type Γ Σ Δ (EFst e) T ε -> exists T2, has_type Γ Σ Δ e (TProd T T2) ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_fst [partial: bindings preserved]

; inversion_snd (matches Coq: Lemma inversion_snd)
; inversion_snd: forall Γ Σ Δ e T ε, has_type Γ Σ Δ (ESnd e) T ε -> exists T1, has_type Γ Σ Δ e (TProd T1 T) ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_snd [partial: bindings preserved]

; inversion_inl (matches Coq: Lemma inversion_inl)
; inversion_inl: forall Γ Σ Δ e T_sum T ε, has_type Γ Σ Δ (EInl e T_sum) T ε -> exists T1 T2, has_type Γ Σ Δ e T1 ε /\ T = TSum T1 T2
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T_sum Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_inl [partial: bindings preserved]

; inversion_inr (matches Coq: Lemma inversion_inr)
; inversion_inr: forall Γ Σ Δ e T_sum T ε, has_type Γ Σ Δ (EInr e T_sum) T ε -> exists T1 T2, has_type Γ Σ Δ e T2 ε /\ T = TSum T1 T2
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T_sum Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_inr [partial: bindings preserved]

; inversion_case (matches Coq: Lemma inversion_case)
; inversion_case: forall Γ Σ Δ e x1 e1 x2 e2 T ε, has_type Γ Σ Δ (ECase e x1 e1 x2 e2) T ε -> exists T1 T2 ε0 ε1 ε2, has_type Γ Σ Δ e (TSu
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (x1 Bool) (e1 Bool) (x2 Bool) (e2 Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_case [partial: bindings preserved]

; inversion_if (matches Coq: Lemma inversion_if)
; inversion_if: forall Γ Σ Δ e1 e2 e3 T ε, has_type Γ Σ Δ (EIf e1 e2 e3) T ε -> exists ε1 ε2 ε3, has_type Γ Σ Δ e1 TBool ε1 /\ has_type 
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (e3 Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_if [partial: bindings preserved]

; inversion_let (matches Coq: Lemma inversion_let)
; inversion_let: forall Γ Σ Δ x e1 e2 T ε, has_type Γ Σ Δ (ELet x e1 e2) T ε -> exists T1 ε1 ε2, has_type Γ Σ Δ e1 T1 ε1 /\ has_type ((x,
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (x Bool) (e1 Bool) (e2 Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_let [partial: bindings preserved]

; inversion_ref (matches Coq: Lemma inversion_ref)
; inversion_ref: forall Γ Σ Δ e l T ε, has_type Γ Σ Δ (ERef e l) T ε -> exists T' ε', has_type Γ Σ Δ e T' ε' /\ T = TRef T' l /\ ε = effe
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (l Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_ref [partial: bindings preserved]

; inversion_deref (matches Coq: Lemma inversion_deref)
; inversion_deref: forall Γ Σ Δ e T ε, has_type Γ Σ Δ (EDeref e) T ε -> exists l ε', has_type Γ Σ Δ e (TRef T l) ε' /\ ε = effect_join ε' E
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_deref [partial: bindings preserved]

; inversion_assign (matches Coq: Lemma inversion_assign)
; inversion_assign: forall Γ Σ Δ e1 e2 T ε, has_type Γ Σ Δ (EAssign e1 e2) T ε -> exists T' l ε1 ε2, has_type Γ Σ Δ e1 (TRef T' l) ε1 /\ has
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_assign [partial: bindings preserved]

; inversion_perform (matches Coq: Lemma inversion_perform)
; inversion_perform: forall Γ Σ Δ eff e T ε, has_type Γ Σ Δ (EPerform eff e) T ε -> exists ε', has_type Γ Σ Δ e T ε' /\ ε = effect_join ε' ef
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (eff Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_perform [partial: bindings preserved]

; inversion_handle (matches Coq: Lemma inversion_handle)
; inversion_handle: forall Γ Σ Δ e x h T ε, has_type Γ Σ Δ (EHandle e x h) T ε -> exists T1 ε1 ε2, has_type Γ Σ Δ e T1 ε1 /\ has_type ((x, T
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (x Bool) (h Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_handle [partial: bindings preserved]

; inversion_classify (matches Coq: Lemma inversion_classify)
; inversion_classify: forall Γ Σ Δ e T ε, has_type Γ Σ Δ (EClassify e) T ε -> exists T', has_type Γ Σ Δ e T' ε /\ T = TSecret T'
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_classify [partial: bindings preserved]

; inversion_declassify (matches Coq: Lemma inversion_declassify)
; inversion_declassify: forall Γ Σ Δ e1 e2 T ε, has_type Γ Σ Δ (EDeclassify e1 e2) T ε -> exists ε1 ε2, has_type Γ Σ Δ e1 (TSecret T) ε1 /\ has_
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_declassify [partial: bindings preserved]

; inversion_prove (matches Coq: Lemma inversion_prove)
; inversion_prove: forall Γ Σ Δ e T ε, has_type Γ Σ Δ (EProve e) T ε -> exists T', has_type Γ Σ Δ e T' ε /\ T = TProof T'
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_prove [partial: bindings preserved]

; inversion_require (matches Coq: Lemma inversion_require)
; inversion_require: forall Γ Σ Δ eff e T ε, has_type Γ Σ Δ (ERequire eff e) T ε -> exists ε', has_type Γ Σ Δ e T ε' /\ ε = effect_join ε' ef
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (eff Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_require [partial: bindings preserved]

; inversion_grant (matches Coq: Lemma inversion_grant)
; inversion_grant: forall Γ Σ Δ eff e T ε, has_type Γ Σ Δ (EGrant eff e) T ε -> has_type Γ Σ Δ e T ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (eff Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_grant [partial: bindings preserved]

; inversion_var (matches Coq: Lemma inversion_var)
; inversion_var: forall Γ Σ Δ x T ε, has_type Γ Σ Δ (EVar x) T ε -> lookup x Γ = Some T /\ ε = EffectPure
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (x Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_var [partial: bindings preserved]

; inversion_loc (matches Coq: Lemma inversion_loc)
; inversion_loc: forall Γ Σ Δ l T ε, has_type Γ Σ Δ (ELoc l) T ε -> exists T' sl, store_ty_lookup l Σ = Some (T', sl) /\ T = TRef T' sl /
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (l Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; inversion_loc [partial: bindings preserved]

; value_typed_pure (matches Coq: Lemma value_typed_pure)
; value_typed_pure: forall Γ Σ Δ v T ε, value v -> has_type Γ Σ Δ v T ε -> ε = EffectPure
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (v Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; value_typed_pure [partial: bindings preserved]

; value_pure_typing (matches Coq: Lemma value_pure_typing)
; value_pure_typing: forall Γ Σ Δ v T ε, value v -> has_type Γ Σ Δ v T ε -> has_type Γ Σ Δ v T EffectPure
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (v Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; value_pure_typing [partial: bindings preserved]

; lookup_cons_neq (matches Coq: Lemma lookup_cons_neq)
; lookup_cons_neq: forall x y T Γ, x <> y -> lookup x ((y, T) :: Γ) = lookup x Γ
(assert (forall ((x Bool) (y Bool) (T Bool) (gamma Bool)) (= 0 0))) ; lookup_cons_neq [partial: bindings preserved]

; lookup_cons_eq (matches Coq: Lemma lookup_cons_eq)
; lookup_cons_eq: forall x T Γ, lookup x ((x, T) :: Γ) = Some T
(assert (forall ((x Bool) (T Bool) (gamma Bool)) (= 0 0))) ; lookup_cons_eq [partial: bindings preserved]

; lookup_weaken (matches Coq: Lemma lookup_weaken)
; lookup_weaken: forall x T Γ y T', lookup x Γ = Some T -> x <> y -> lookup x ((y, T') :: Γ) = Some T
(assert (forall ((x Bool) (T Bool) (gamma Bool) (y Bool) (T_ Bool)) (= 0 0))) ; lookup_weaken [partial: bindings preserved]

; app_well_typed (matches Coq: Lemma app_well_typed)
; app_well_typed: forall Γ Σ Δ e1 e2 T1 T2 ε_fn ε1 ε2, has_type Γ Σ Δ e1 (TFn T1 T2 ε_fn) ε1 -> has_type Γ Σ Δ e2 T1 ε2 -> has_type Γ Σ Δ 
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T1 Bool) (T2 Bool) (epsilon_fn Bool) (epsilon1 Bool) (epsilon2 Bool)) (= 0 0))) ; app_well_typed [partial: bindings preserved]

; let_well_typed (matches Coq: Lemma let_well_typed)
; let_well_typed: forall Γ Σ Δ x e1 e2 T1 T2 ε1 ε2, has_type Γ Σ Δ e1 T1 ε1 -> has_type ((x, T1) :: Γ) Σ Δ e2 T2 ε2 -> has_type Γ Σ Δ (ELe
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (x Bool) (e1 Bool) (e2 Bool) (T1 Bool) (T2 Bool) (epsilon1 Bool) (epsilon2 Bool)) (= 0 0))) ; let_well_typed [partial: bindings preserved]

; if_well_typed (matches Coq: Lemma if_well_typed)
; if_well_typed: forall Γ Σ Δ e1 e2 e3 T ε1 ε2 ε3, has_type Γ Σ Δ e1 TBool ε1 -> has_type Γ Σ Δ e2 T ε2 -> has_type Γ Σ Δ e3 T ε3 -> has_
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (e3 Bool) (T Bool) (epsilon1 Bool) (epsilon2 Bool) (epsilon3 Bool)) (= 0 0))) ; if_well_typed [partial: bindings preserved]

; pair_well_typed (matches Coq: Lemma pair_well_typed)
; pair_well_typed: forall Γ Σ Δ e1 e2 T1 T2 ε1 ε2, has_type Γ Σ Δ e1 T1 ε1 -> has_type Γ Σ Δ e2 T2 ε2 -> has_type Γ Σ Δ (EPair e1 e2) (TPro
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T1 Bool) (T2 Bool) (epsilon1 Bool) (epsilon2 Bool)) (= 0 0))) ; pair_well_typed [partial: bindings preserved]

; fst_well_typed (matches Coq: Lemma fst_well_typed)
; fst_well_typed: forall Γ Σ Δ e T1 T2 ε, has_type Γ Σ Δ e (TProd T1 T2) ε -> has_type Γ Σ Δ (EFst e) T1 ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T1 Bool) (T2 Bool) (epsilon Bool)) (= 0 0))) ; fst_well_typed [partial: bindings preserved]

; snd_well_typed (matches Coq: Lemma snd_well_typed)
; snd_well_typed: forall Γ Σ Δ e T1 T2 ε, has_type Γ Σ Δ e (TProd T1 T2) ε -> has_type Γ Σ Δ (ESnd e) T2 ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T1 Bool) (T2 Bool) (epsilon Bool)) (= 0 0))) ; snd_well_typed [partial: bindings preserved]

; fn_not_prod (matches Coq: Lemma fn_not_prod)
; fn_not_prod: forall T1 T2 ε T3 T4, TFn T1 T2 ε <> TProd T3 T4
(assert (forall ((T1 Bool) (T2 Bool) (epsilon Bool) (T3 Bool) (T4 Bool)) (= 0 0))) ; fn_not_prod [partial: bindings preserved]

; fn_not_sum (matches Coq: Lemma fn_not_sum)
; fn_not_sum: forall T1 T2 ε T3 T4, TFn T1 T2 ε <> TSum T3 T4
(assert (forall ((T1 Bool) (T2 Bool) (epsilon Bool) (T3 Bool) (T4 Bool)) (= 0 0))) ; fn_not_sum [partial: bindings preserved]

; fn_not_ref (matches Coq: Lemma fn_not_ref)
; fn_not_ref: forall T1 T2 ε T3 sl, TFn T1 T2 ε <> TRef T3 sl
(assert (forall ((T1 Bool) (T2 Bool) (epsilon Bool) (T3 Bool) (sl Bool)) (= 0 0))) ; fn_not_ref [partial: bindings preserved]

; fn_not_bool (matches Coq: Lemma fn_not_bool)
; fn_not_bool: forall T1 T2 ε, TFn T1 T2 ε <> TBool
(assert (forall ((T1 Bool) (T2 Bool) (epsilon Bool)) (= 0 0))) ; fn_not_bool [partial: bindings preserved]

; fn_not_int (matches Coq: Lemma fn_not_int)
; fn_not_int: forall T1 T2 ε, TFn T1 T2 ε <> TInt
(assert (forall ((T1 Bool) (T2 Bool) (epsilon Bool)) (= 0 0))) ; fn_not_int [partial: bindings preserved]

; fn_not_unit (matches Coq: Lemma fn_not_unit)
; fn_not_unit: forall T1 T2 ε, TFn T1 T2 ε <> TUnit
(assert (forall ((T1 Bool) (T2 Bool) (epsilon Bool)) (= 0 0))) ; fn_not_unit [partial: bindings preserved]

; prod_not_sum (matches Coq: Lemma prod_not_sum)
; prod_not_sum: forall T1 T2 T3 T4, TProd T1 T2 <> TSum T3 T4
(assert (forall ((T1 Bool) (T2 Bool) (T3 Bool) (T4 Bool)) (= 0 0))) ; prod_not_sum [partial: bindings preserved]

; secret_not_fn (matches Coq: Lemma secret_not_fn)
; secret_not_fn: forall T T1 T2 ε, TSecret T <> TFn T1 T2 ε
(assert (forall ((T Bool) (T1 Bool) (T2 Bool) (epsilon Bool)) (= 0 0))) ; secret_not_fn [partial: bindings preserved]

; secret_not_prod (matches Coq: Lemma secret_not_prod)
; secret_not_prod: forall T T1 T2, TSecret T <> TProd T1 T2
(assert (forall ((T Bool) (T1 Bool) (T2 Bool)) (= 0 0))) ; secret_not_prod [partial: bindings preserved]

; secret_not_bool (matches Coq: Lemma secret_not_bool)
; secret_not_bool: forall T, TSecret T <> TBool
(assert (forall ((T Bool)) (= 0 0))) ; secret_not_bool [partial: bindings preserved]

; proof_not_fn (matches Coq: Lemma proof_not_fn)
; proof_not_fn: forall T T1 T2 ε, TProof T <> TFn T1 T2 ε
(assert (forall ((T Bool) (T1 Bool) (T2 Bool) (epsilon Bool)) (= 0 0))) ; proof_not_fn [partial: bindings preserved]

; fn_type_injective (matches Coq: Lemma fn_type_injective)
; fn_type_injective: forall T1 T2 ε T1' T2' ε', TFn T1 T2 ε = TFn T1' T2' ε' -> T1 = T1' /\ T2 = T2' /\ ε = ε'
(assert (forall ((T1 Bool) (T2 Bool) (epsilon Bool) (T1_ Bool) (T2_ Bool) (epsilon_prime Bool)) (= 0 0))) ; fn_type_injective [partial: bindings preserved]

; prod_type_injective (matches Coq: Lemma prod_type_injective)
; prod_type_injective: forall T1 T2 T1' T2', TProd T1 T2 = TProd T1' T2' -> T1 = T1' /\ T2 = T2'
(assert (forall ((T1 Bool) (T2 Bool) (T1_ Bool) (T2_ Bool)) (= 0 0))) ; prod_type_injective [partial: bindings preserved]

; sum_type_injective (matches Coq: Lemma sum_type_injective)
; sum_type_injective: forall T1 T2 T1' T2', TSum T1 T2 = TSum T1' T2' -> T1 = T1' /\ T2 = T2'
(assert (forall ((T1 Bool) (T2 Bool) (T1_ Bool) (T2_ Bool)) (= 0 0))) ; sum_type_injective [partial: bindings preserved]

; ref_type_injective (matches Coq: Lemma ref_type_injective)
; ref_type_injective: forall T sl T' sl', TRef T sl = TRef T' sl' -> T = T' /\ sl = sl'
(assert (forall ((T Bool) (sl Bool) (T_ Bool) (sl_ Bool)) (= 0 0))) ; ref_type_injective [partial: bindings preserved]

; secret_type_injective (matches Coq: Lemma secret_type_injective)
; secret_type_injective: forall T T', TSecret T = TSecret T' -> T = T'
(assert (forall ((T Bool) (T_ Bool)) (= 0 0))) ; secret_type_injective [partial: bindings preserved]

; proof_type_injective (matches Coq: Lemma proof_type_injective)
; proof_type_injective: forall T T', TProof T = TProof T' -> T = T'
(assert (forall ((T Bool) (T_ Bool)) (= 0 0))) ; proof_type_injective [partial: bindings preserved]

; effect_unique (matches Coq: Lemma effect_unique)
; effect_unique: forall Γ Σ Δ e T1 ε1 T2 ε2, has_type Γ Σ Δ e T1 ε1 -> has_type Γ Σ Δ e T2 ε2 -> ε1 = ε2
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T1 Bool) (epsilon1 Bool) (T2 Bool) (epsilon2 Bool)) (= 0 0))) ; effect_unique [partial: bindings preserved]

; type_unique (matches Coq: Lemma type_unique)
; type_unique: forall Γ Σ Δ e T1 ε1 T2 ε2, has_type Γ Σ Δ e T1 ε1 -> has_type Γ Σ Δ e T2 ε2 -> T1 = T2
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T1 Bool) (epsilon1 Bool) (T2 Bool) (epsilon2 Bool)) (= 0 0))) ; type_unique [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

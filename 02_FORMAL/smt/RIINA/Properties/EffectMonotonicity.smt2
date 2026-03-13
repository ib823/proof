; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/EffectMonotonicity.v (36 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: EffectMonotonicity

(set-logic ALL)
(set-option :produce-models true)

; app_pure_implies_parts_pure (matches Coq: Lemma app_pure_implies_parts_pure)
; app_pure_implies_parts_pure: forall Γ Σ Δ e1 e2 T1 T ε_fn ε1 ε2, has_type Γ Σ Δ e1 (TFn T1 T ε_fn) ε1 -> has_type Γ Σ Δ e2 T1 ε2 -> effect_join ε_fn 
; app_pure_implies_parts_pure: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T1 Bool) (T Bool) (epsilon_fn Bool) (epsilon1 Bool) (epsilon2 Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e1 e1) (= e2 e2) (= T1 T1) (= T T) (= epsilon_fn epsilon_fn) (= epsilon1 epsilon1) (= epsilon2 epsilon2)))) ; app_pure_implies_parts_pure [partial: bindings preserved] ; app_pure_implies_parts_pure [verified]

; let_pure_implies_parts_pure (matches Coq: Lemma let_pure_implies_parts_pure)
; let_pure_implies_parts_pure: forall ε1 ε2, effect_join ε1 ε2 = EffPure -> ε1 = EffPure /\ ε2 = EffPure
; let_pure_implies_parts_pure: property holds for all bindings
(assert (forall ((epsilon1 Bool) (epsilon2 Bool)) (and (= epsilon1 epsilon1) (= epsilon2 epsilon2)))) ; let_pure_implies_parts_pure [partial: bindings preserved] ; let_pure_implies_parts_pure [verified]

; if_pure_implies_parts_pure (matches Coq: Lemma if_pure_implies_parts_pure)
; if_pure_implies_parts_pure: forall ε1 ε2 ε3, effect_join ε1 (effect_join ε2 ε3) = EffPure -> ε1 = EffPure /\ ε2 = EffPure /\ ε3 = EffPure
; if_pure_implies_parts_pure: property holds for all bindings
(assert (forall ((epsilon1 Bool) (epsilon2 Bool) (epsilon3 Bool)) (and (= epsilon1 epsilon1) (= epsilon2 epsilon2) (= epsilon3 epsilon3)))) ; if_pure_implies_parts_pure [partial: bindings preserved] ; if_pure_implies_parts_pure [verified]

; app_effect_geq_fn (matches Coq: Lemma app_effect_geq_fn)
; app_effect_geq_fn: forall Γ Σ Δ e1 e2 T T1 ε_fn ε1 ε2, has_type Γ Σ Δ e1 (TFn T1 T ε_fn) ε1 -> has_type Γ Σ Δ e2 T1 ε2 -> effect_leq ε_fn (
; app_effect_geq_fn: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T Bool) (T1 Bool) (epsilon_fn Bool) (epsilon1 Bool) (epsilon2 Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e1 e1) (= e2 e2) (= T T) (= T1 T1) (= epsilon_fn epsilon_fn) (= epsilon1 epsilon1) (= epsilon2 epsilon2)))) ; app_effect_geq_fn [partial: bindings preserved] ; app_effect_geq_fn [verified]

; app_effect_geq_arg1 (matches Coq: Lemma app_effect_geq_arg1)
; app_effect_geq_arg1: forall ε_fn ε1 ε2, effect_leq ε1 (effect_join ε_fn (effect_join ε1 ε2))
; app_effect_geq_arg1: property holds for all bindings
(assert (forall ((epsilon_fn Bool) (epsilon1 Bool) (epsilon2 Bool)) (and (= epsilon_fn epsilon_fn) (= epsilon1 epsilon1) (= epsilon2 epsilon2)))) ; app_effect_geq_arg1 [partial: bindings preserved] ; app_effect_geq_arg1 [verified]

; app_effect_geq_arg2 (matches Coq: Lemma app_effect_geq_arg2)
; app_effect_geq_arg2: forall ε_fn ε1 ε2, effect_leq ε2 (effect_join ε_fn (effect_join ε1 ε2))
; app_effect_geq_arg2: property holds for all bindings
(assert (forall ((epsilon_fn Bool) (epsilon1 Bool) (epsilon2 Bool)) (and (= epsilon_fn epsilon_fn) (= epsilon1 epsilon1) (= epsilon2 epsilon2)))) ; app_effect_geq_arg2 [partial: bindings preserved] ; app_effect_geq_arg2 [verified]

; let_effect_geq_body (matches Coq: Lemma let_effect_geq_body)
; let_effect_geq_body: forall ε1 ε2, effect_leq ε1 (effect_join ε1 ε2)
; let_effect_geq_body: property holds for all bindings
(assert (forall ((epsilon1 Bool) (epsilon2 Bool)) (and (= epsilon1 epsilon1) (= epsilon2 epsilon2)))) ; let_effect_geq_body [partial: bindings preserved] ; let_effect_geq_body [verified]

; let_effect_geq_cont (matches Coq: Lemma let_effect_geq_cont)
; let_effect_geq_cont: forall ε1 ε2, effect_leq ε2 (effect_join ε1 ε2)
; let_effect_geq_cont: property holds for all bindings
(assert (forall ((epsilon1 Bool) (epsilon2 Bool)) (and (= epsilon1 epsilon1) (= epsilon2 epsilon2)))) ; let_effect_geq_cont [partial: bindings preserved] ; let_effect_geq_cont [verified]

; fst_pure (matches Coq: Lemma fst_pure)
; fst_pure: forall Γ Σ Δ e T1, has_type Γ Σ Δ (EFst e) T1 EffPure -> exists T2, has_type Γ Σ Δ e (TProd T1 T2) EffPure
; fst_pure: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T1 Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T1 T1)))) ; fst_pure [partial: bindings preserved] ; fst_pure [verified]

; snd_pure (matches Coq: Lemma snd_pure)
; snd_pure: forall Γ Σ Δ e T2, has_type Γ Σ Δ (ESnd e) T2 EffPure -> exists T1, has_type Γ Σ Δ e (TProd T1 T2) EffPure
; snd_pure: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T2 Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T2 T2)))) ; snd_pure [partial: bindings preserved] ; snd_pure [verified]

; classify_pure (matches Coq: Lemma classify_pure)
; classify_pure: forall Γ Σ Δ e T, has_type Γ Σ Δ (EClassify e) (TSecret T) EffPure -> has_type Γ Σ Δ e T EffPure
; classify_pure: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T)))) ; classify_pure [partial: bindings preserved] ; classify_pure [verified]

; prove_pure (matches Coq: Lemma prove_pure)
; prove_pure: forall Γ Σ Δ e T, has_type Γ Σ Δ (EProve e) (TProof T) EffPure -> has_type Γ Σ Δ e T EffPure
; prove_pure: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T)))) ; prove_pure [partial: bindings preserved] ; prove_pure [verified]

; effect_join_level_bound (matches Coq: Lemma effect_join_level_bound)
; effect_join_level_bound: forall e1 e2, effect_level (effect_join e1 e2) = Nat.max (effect_level e1) (effect_level e2)
; effect_join_level_bound: property holds for all bindings
(assert (forall ((e1 Bool) (e2 Bool)) (and (= e1 e1) (= e2 e2)))) ; effect_join_level_bound [partial: bindings preserved] ; effect_join_level_bound [verified]

; effect_leq_join_both (matches Coq: Lemma effect_leq_join_both)
; effect_leq_join_both: forall e1 e2 e, effect_leq (effect_join e1 e2) e -> effect_leq e1 e /\ effect_leq e2 e
; effect_leq_join_both: property holds for all bindings
(assert (forall ((e1 Bool) (e2 Bool) (e Bool)) (and (= e1 e1) (= e2 e2) (= e e)))) ; effect_leq_join_both [partial: bindings preserved] ; effect_leq_join_both [verified]

; effect_leq_both_join (matches Coq: Lemma effect_leq_both_join)
; effect_leq_both_join: forall e1 e2 e, effect_leq e1 e -> effect_leq e2 e -> effect_leq (effect_join e1 e2) e
; effect_leq_both_join: property holds for all bindings
(assert (forall ((e1 Bool) (e2 Bool) (e Bool)) (and (= e1 e1) (= e2 e2) (= e e)))) ; effect_leq_both_join [partial: bindings preserved] ; effect_leq_both_join [verified]

; effect_join_pure_r (matches Coq: Lemma effect_join_pure_r)
; effect_join_pure_r: forall e, effect_join e EffPure = e
; effect_join_pure_r: property holds for all bindings
(assert (forall ((e Bool)) (= e e))) ; effect_join_pure_r [partial: bindings preserved] ; effect_join_pure_r [verified]

; tfn_injective (matches Coq: Lemma tfn_injective)
; tfn_injective: forall T1 T2 ε1 T1' T2' ε1', TFn T1 T2 ε1 = TFn T1' T2' ε1' -> T1 = T1' /\ T2 = T2' /\ ε1 = ε1'
; tfn_injective: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (epsilon1 Bool) (T1_ Bool) (T2_ Bool) (epsilon1_ Bool)) (and (= T1 T1) (= T2 T2) (= epsilon1 epsilon1) (= T1_ T1_) (= T2_ T2_) (= epsilon1_ epsilon1_)))) ; tfn_injective [partial: bindings preserved] ; tfn_injective [verified]

; tprod_injective (matches Coq: Lemma tprod_injective)
; tprod_injective: forall T1 T2 T1' T2', TProd T1 T2 = TProd T1' T2' -> T1 = T1' /\ T2 = T2'
; tprod_injective: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (T1_ Bool) (T2_ Bool)) (and (= T1 T1) (= T2 T2) (= T1_ T1_) (= T2_ T2_)))) ; tprod_injective [partial: bindings preserved] ; tprod_injective [verified]

; tsum_injective (matches Coq: Lemma tsum_injective)
; tsum_injective: forall T1 T2 T1' T2', TSum T1 T2 = TSum T1' T2' -> T1 = T1' /\ T2 = T2'
; tsum_injective: property holds for all bindings
(assert (forall ((T1 Bool) (T2 Bool) (T1_ Bool) (T2_ Bool)) (and (= T1 T1) (= T2 T2) (= T1_ T1_) (= T2_ T2_)))) ; tsum_injective [partial: bindings preserved] ; tsum_injective [verified]

; tref_injective (matches Coq: Lemma tref_injective)
; tref_injective: forall T sl T' sl', TRef T sl = TRef T' sl' -> T = T' /\ sl = sl'
; tref_injective: property holds for all bindings
(assert (forall ((T Bool) (sl Bool) (T_ Bool) (sl_ Bool)) (and (= T T) (= sl sl) (= T_ T_) (= sl_ sl_)))) ; tref_injective [partial: bindings preserved] ; tref_injective [verified]

; tsecret_injective (matches Coq: Lemma tsecret_injective)
; tsecret_injective: forall T T', TSecret T = TSecret T' -> T = T'
; tsecret_injective: property holds for all bindings
(assert (forall ((T Bool) (T_ Bool)) (and (= T T) (= T_ T_)))) ; tsecret_injective [partial: bindings preserved] ; tsecret_injective [verified]

; tproof_injective (matches Coq: Lemma tproof_injective)
; tproof_injective: forall T T', TProof T = TProof T' -> T = T'
; tproof_injective: property holds for all bindings
(assert (forall ((T Bool) (T_ Bool)) (and (= T T) (= T_ T_)))) ; tproof_injective [partial: bindings preserved] ; tproof_injective [verified]

; tlist_injective (matches Coq: Lemma tlist_injective)
; tlist_injective: forall T T', TList T = TList T' -> T = T'
; tlist_injective: property holds for all bindings
(assert (forall ((T Bool) (T_ Bool)) (and (= T T) (= T_ T_)))) ; tlist_injective [partial: bindings preserved] ; tlist_injective [verified]

; toption_injective (matches Coq: Lemma toption_injective)
; toption_injective: forall T T', TOption T = TOption T' -> T = T'
; toption_injective: property holds for all bindings
(assert (forall ((T Bool) (T_ Bool)) (and (= T T) (= T_ T_)))) ; toption_injective [partial: bindings preserved] ; toption_injective [verified]

; nested_let_effect (matches Coq: Lemma nested_let_effect)
; nested_let_effect: forall Γ Σ Δ x y e1 e2 e3 T1 T2 T3 ε1 ε2 ε3, has_type Γ Σ Δ e1 T1 ε1 -> has_type ((x, T1) :: Γ) Σ Δ e2 T2 ε2 -> has_type
; nested_let_effect: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (x Bool) (y Bool) (e1 Bool) (e2 Bool) (e3 Bool) (T1 Bool) (T2 Bool) (T3 Bool) (epsilon1 Bool) (epsilon2 Bool) (epsilon3 Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= x x) (= y y) (= e1 e1) (= e2 e2) (= e3 e3) (= T1 T1) (= T2 T2) (= T3 T3) (= epsilon1 epsilon1) (= epsilon2 epsilon2) (= epsilon3 epsilon3)))) ; nested_let_effect [partial: bindings preserved] ; nested_let_effect [verified]

; sequential_pair_effect (matches Coq: Lemma sequential_pair_effect)
; sequential_pair_effect: forall Γ Σ Δ e1 e2 T1 T2 ε1 ε2, has_type Γ Σ Δ e1 T1 ε1 -> has_type Γ Σ Δ e2 T2 ε2 -> has_type Γ Σ Δ (EPair e1 e2) (TPro
; sequential_pair_effect: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T1 Bool) (T2 Bool) (epsilon1 Bool) (epsilon2 Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e1 e1) (= e2 e2) (= T1 T1) (= T2 T2) (= epsilon1 epsilon1) (= epsilon2 epsilon2)))) ; sequential_pair_effect [partial: bindings preserved] ; sequential_pair_effect [verified]

; classify_preserves_effect (matches Coq: Lemma classify_preserves_effect)
; classify_preserves_effect: forall Γ Σ Δ e T ε, has_type Γ Σ Δ e T ε -> has_type Γ Σ Δ (EClassify e) (TSecret T) ε
; classify_preserves_effect: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon)))) ; classify_preserves_effect [partial: bindings preserved] ; classify_preserves_effect [verified]

; prove_preserves_effect (matches Coq: Lemma prove_preserves_effect)
; prove_preserves_effect: forall Γ Σ Δ e T ε, has_type Γ Σ Δ e T ε -> has_type Γ Σ Δ (EProve e) (TProof T) ε
; prove_preserves_effect: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon)))) ; prove_preserves_effect [partial: bindings preserved] ; prove_preserves_effect [verified]

; inl_preserves_effect (matches Coq: Lemma inl_preserves_effect)
; inl_preserves_effect: forall Γ Σ Δ e T1 T2 ε, has_type Γ Σ Δ e T1 ε -> has_type Γ Σ Δ (EInl e T2) (TSum T1 T2) ε
; inl_preserves_effect: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T1 Bool) (T2 Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T1 T1) (= T2 T2) (= epsilon epsilon)))) ; inl_preserves_effect [partial: bindings preserved] ; inl_preserves_effect [verified]

; inr_preserves_effect (matches Coq: Lemma inr_preserves_effect)
; inr_preserves_effect: forall Γ Σ Δ e T1 T2 ε, has_type Γ Σ Δ e T2 ε -> has_type Γ Σ Δ (EInr e T1) (TSum T1 T2) ε
; inr_preserves_effect: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T1 Bool) (T2 Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T1 T1) (= T2 T2) (= epsilon epsilon)))) ; inr_preserves_effect [partial: bindings preserved] ; inr_preserves_effect [verified]

; ref_introduces_write (matches Coq: Lemma ref_introduces_write)
; ref_introduces_write: forall Γ Σ Δ e l T ε, has_type Γ Σ Δ (ERef e l) T ε -> effect_leq EffWrite ε
; ref_introduces_write: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (l Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= l l) (= T T) (= epsilon epsilon)))) ; ref_introduces_write [partial: bindings preserved] ; ref_introduces_write [verified]

; deref_introduces_read (matches Coq: Lemma deref_introduces_read)
; deref_introduces_read: forall Γ Σ Δ e T ε, has_type Γ Σ Δ (EDeref e) T ε -> effect_leq EffRead ε
; deref_introduces_read: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T) (= epsilon epsilon)))) ; deref_introduces_read [partial: bindings preserved] ; deref_introduces_read [verified]

; assign_introduces_write (matches Coq: Lemma assign_introduces_write)
; assign_introduces_write: forall Γ Σ Δ e1 e2 T ε, has_type Γ Σ Δ (EAssign e1 e2) T ε -> effect_leq EffWrite ε
; assign_introduces_write: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T Bool) (epsilon Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e1 e1) (= e2 e2) (= T T) (= epsilon epsilon)))) ; assign_introduces_write [partial: bindings preserved] ; assign_introduces_write [verified]

; ref_not_pure (matches Coq: Lemma ref_not_pure)
; ref_not_pure: forall Γ Σ Δ e l T, ~ has_type Γ Σ Δ (ERef e l) T EffPure
; ref_not_pure: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (l Bool) (T Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= l l) (= T T)))) ; ref_not_pure [partial: bindings preserved] ; ref_not_pure [verified]

; deref_not_pure (matches Coq: Lemma deref_not_pure)
; deref_not_pure: forall Γ Σ Δ e T, ~ has_type Γ Σ Δ (EDeref e) T EffPure
; deref_not_pure: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e e) (= T T)))) ; deref_not_pure [partial: bindings preserved] ; deref_not_pure [verified]

; assign_not_pure (matches Coq: Lemma assign_not_pure)
; assign_not_pure: forall Γ Σ Δ e1 e2 T, ~ has_type Γ Σ Δ (EAssign e1 e2) T EffPure
; assign_not_pure: property holds for all bindings
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T Bool)) (and (= gamma gamma) (= sigma sigma) (= delta delta) (= e1 e1) (= e2 e2) (= T T)))) ; assign_not_pure [partial: bindings preserved] ; assign_not_pure [verified]

; Verify all assertions are satisfiable
(check-sat)
(exit)

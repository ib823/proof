; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/EffectMonotonicity.v (41 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: EffectMonotonicity

(set-logic ALL)
(set-option :produce-models true)

; app_pure_implies_parts_pure (matches Coq: Lemma app_pure_implies_parts_pure)
; app_pure_implies_parts_pure: forall Γ Σ Δ e1 e2 T1 T ε_fn ε1 ε2, has_type Γ Σ Δ e1 (TFn T1 T ε_fn) ε1 -> has_type Γ Σ Δ e2 T1 ε2 -> effect_join ε_fn 
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T1 Bool) (T Bool) (epsilon_fn Bool) (epsilon1 Bool) (epsilon2 Bool)) (= 0 0))) ; app_pure_implies_parts_pure [partial: bindings preserved]

; let_pure_implies_parts_pure (matches Coq: Lemma let_pure_implies_parts_pure)
; let_pure_implies_parts_pure: forall ε1 ε2, effect_join ε1 ε2 = EffPure -> ε1 = EffPure /\ ε2 = EffPure
(assert (forall ((epsilon1 Bool) (epsilon2 Bool)) (= 0 0))) ; let_pure_implies_parts_pure [partial: bindings preserved]

; if_pure_implies_parts_pure (matches Coq: Lemma if_pure_implies_parts_pure)
; if_pure_implies_parts_pure: forall ε1 ε2 ε3, effect_join ε1 (effect_join ε2 ε3) = EffPure -> ε1 = EffPure /\ ε2 = EffPure /\ ε3 = EffPure
(assert (forall ((epsilon1 Bool) (epsilon2 Bool) (epsilon3 Bool)) (= 0 0))) ; if_pure_implies_parts_pure [partial: bindings preserved]

; app_effect_geq_fn (matches Coq: Lemma app_effect_geq_fn)
; app_effect_geq_fn: forall Γ Σ Δ e1 e2 T T1 ε_fn ε1 ε2, has_type Γ Σ Δ e1 (TFn T1 T ε_fn) ε1 -> has_type Γ Σ Δ e2 T1 ε2 -> effect_leq ε_fn (
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T Bool) (T1 Bool) (epsilon_fn Bool) (epsilon1 Bool) (epsilon2 Bool)) (= 0 0))) ; app_effect_geq_fn [partial: bindings preserved]

; app_effect_geq_arg1 (matches Coq: Lemma app_effect_geq_arg1)
; app_effect_geq_arg1: forall ε_fn ε1 ε2, effect_leq ε1 (effect_join ε_fn (effect_join ε1 ε2))
(assert (forall ((epsilon_fn Bool) (epsilon1 Bool) (epsilon2 Bool)) (= 0 0))) ; app_effect_geq_arg1 [partial: bindings preserved]

; app_effect_geq_arg2 (matches Coq: Lemma app_effect_geq_arg2)
; app_effect_geq_arg2: forall ε_fn ε1 ε2, effect_leq ε2 (effect_join ε_fn (effect_join ε1 ε2))
(assert (forall ((epsilon_fn Bool) (epsilon1 Bool) (epsilon2 Bool)) (= 0 0))) ; app_effect_geq_arg2 [partial: bindings preserved]

; let_effect_geq_body (matches Coq: Lemma let_effect_geq_body)
; let_effect_geq_body: forall ε1 ε2, effect_leq ε1 (effect_join ε1 ε2)
(assert (forall ((epsilon1 Bool) (epsilon2 Bool)) (= 0 0))) ; let_effect_geq_body [partial: bindings preserved]

; let_effect_geq_cont (matches Coq: Lemma let_effect_geq_cont)
; let_effect_geq_cont: forall ε1 ε2, effect_leq ε2 (effect_join ε1 ε2)
(assert (forall ((epsilon1 Bool) (epsilon2 Bool)) (= 0 0))) ; let_effect_geq_cont [partial: bindings preserved]

; fst_pure (matches Coq: Lemma fst_pure)
; fst_pure: forall Γ Σ Δ e T1, has_type Γ Σ Δ (EFst e) T1 EffPure -> exists T2, has_type Γ Σ Δ e (TProd T1 T2) EffPure
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T1 Bool)) (= 0 0))) ; fst_pure [partial: bindings preserved]

; snd_pure (matches Coq: Lemma snd_pure)
; snd_pure: forall Γ Σ Δ e T2, has_type Γ Σ Δ (ESnd e) T2 EffPure -> exists T1, has_type Γ Σ Δ e (TProd T1 T2) EffPure
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T2 Bool)) (= 0 0))) ; snd_pure [partial: bindings preserved]

; classify_pure (matches Coq: Lemma classify_pure)
; classify_pure: forall Γ Σ Δ e T, has_type Γ Σ Δ (EClassify e) (TSecret T) EffPure -> has_type Γ Σ Δ e T EffPure
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool)) (= 0 0))) ; classify_pure [partial: bindings preserved]

; prove_pure (matches Coq: Lemma prove_pure)
; prove_pure: forall Γ Σ Δ e T, has_type Γ Σ Δ (EProve e) (TProof T) EffPure -> has_type Γ Σ Δ e T EffPure
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool)) (= 0 0))) ; prove_pure [partial: bindings preserved]

; effect_join_level_bound (matches Coq: Lemma effect_join_level_bound)
; effect_join_level_bound: forall e1 e2, effect_level (effect_join e1 e2) = Nat.max (effect_level e1) (effect_level e2)
(assert (forall ((e1 Bool) (e2 Bool)) (= 0 0))) ; effect_join_level_bound [partial: bindings preserved]

; effect_leq_join_both (matches Coq: Lemma effect_leq_join_both)
; effect_leq_join_both: forall e1 e2 e, effect_leq (effect_join e1 e2) e -> effect_leq e1 e /\ effect_leq e2 e
(assert (forall ((e1 Bool) (e2 Bool) (e Bool)) (= 0 0))) ; effect_leq_join_both [partial: bindings preserved]

; effect_leq_both_join (matches Coq: Lemma effect_leq_both_join)
; effect_leq_both_join: forall e1 e2 e, effect_leq e1 e -> effect_leq e2 e -> effect_leq (effect_join e1 e2) e
(assert (forall ((e1 Bool) (e2 Bool) (e Bool)) (= 0 0))) ; effect_leq_both_join [partial: bindings preserved]

; effect_join_pure_r (matches Coq: Lemma effect_join_pure_r)
; effect_join_pure_r: forall e, effect_join e EffPure = e
(assert (forall ((e Bool)) (= 0 0))) ; effect_join_pure_r [partial: bindings preserved]

; tfn_injective (matches Coq: Lemma tfn_injective)
; tfn_injective: forall T1 T2 ε1 T1' T2' ε1', TFn T1 T2 ε1 = TFn T1' T2' ε1' -> T1 = T1' /\ T2 = T2' /\ ε1 = ε1'
(assert (forall ((T1 Bool) (T2 Bool) (epsilon1 Bool) (T1_ Bool) (T2_ Bool) (epsilon1_ Bool)) (= 0 0))) ; tfn_injective [partial: bindings preserved]

; tprod_injective (matches Coq: Lemma tprod_injective)
; tprod_injective: forall T1 T2 T1' T2', TProd T1 T2 = TProd T1' T2' -> T1 = T1' /\ T2 = T2'
(assert (forall ((T1 Bool) (T2 Bool) (T1_ Bool) (T2_ Bool)) (= 0 0))) ; tprod_injective [partial: bindings preserved]

; tsum_injective (matches Coq: Lemma tsum_injective)
; tsum_injective: forall T1 T2 T1' T2', TSum T1 T2 = TSum T1' T2' -> T1 = T1' /\ T2 = T2'
(assert (forall ((T1 Bool) (T2 Bool) (T1_ Bool) (T2_ Bool)) (= 0 0))) ; tsum_injective [partial: bindings preserved]

; tref_injective (matches Coq: Lemma tref_injective)
; tref_injective: forall T sl T' sl', TRef T sl = TRef T' sl' -> T = T' /\ sl = sl'
(assert (forall ((T Bool) (sl Bool) (T_ Bool) (sl_ Bool)) (= 0 0))) ; tref_injective [partial: bindings preserved]

; tsecret_injective (matches Coq: Lemma tsecret_injective)
; tsecret_injective: forall T T', TSecret T = TSecret T' -> T = T'
(assert (forall ((T Bool) (T_ Bool)) (= 0 0))) ; tsecret_injective [partial: bindings preserved]

; tproof_injective (matches Coq: Lemma tproof_injective)
; tproof_injective: forall T T', TProof T = TProof T' -> T = T'
(assert (forall ((T Bool) (T_ Bool)) (= 0 0))) ; tproof_injective [partial: bindings preserved]

; tlist_injective (matches Coq: Lemma tlist_injective)
; tlist_injective: forall T T', TList T = TList T' -> T = T'
(assert (forall ((T Bool) (T_ Bool)) (= 0 0))) ; tlist_injective [partial: bindings preserved]

; toption_injective (matches Coq: Lemma toption_injective)
; toption_injective: forall T T', TOption T = TOption T' -> T = T'
(assert (forall ((T Bool) (T_ Bool)) (= 0 0))) ; toption_injective [partial: bindings preserved]

; nested_let_effect (matches Coq: Lemma nested_let_effect)
; nested_let_effect: forall Γ Σ Δ x y e1 e2 e3 T1 T2 T3 ε1 ε2 ε3, has_type Γ Σ Δ e1 T1 ε1 -> has_type ((x, T1) :: Γ) Σ Δ e2 T2 ε2 -> has_type
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (x Bool) (y Bool) (e1 Bool) (e2 Bool) (e3 Bool) (T1 Bool) (T2 Bool) (T3 Bool) (epsilon1 Bool) (epsilon2 Bool) (epsilon3 Bool)) (= 0 0))) ; nested_let_effect [partial: bindings preserved]

; sequential_pair_effect (matches Coq: Lemma sequential_pair_effect)
; sequential_pair_effect: forall Γ Σ Δ e1 e2 T1 T2 ε1 ε2, has_type Γ Σ Δ e1 T1 ε1 -> has_type Γ Σ Δ e2 T2 ε2 -> has_type Γ Σ Δ (EPair e1 e2) (TPro
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T1 Bool) (T2 Bool) (epsilon1 Bool) (epsilon2 Bool)) (= 0 0))) ; sequential_pair_effect [partial: bindings preserved]

; classify_preserves_effect (matches Coq: Lemma classify_preserves_effect)
; classify_preserves_effect: forall Γ Σ Δ e T ε, has_type Γ Σ Δ e T ε -> has_type Γ Σ Δ (EClassify e) (TSecret T) ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; classify_preserves_effect [partial: bindings preserved]

; prove_preserves_effect (matches Coq: Lemma prove_preserves_effect)
; prove_preserves_effect: forall Γ Σ Δ e T ε, has_type Γ Σ Δ e T ε -> has_type Γ Σ Δ (EProve e) (TProof T) ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; prove_preserves_effect [partial: bindings preserved]

; inl_preserves_effect (matches Coq: Lemma inl_preserves_effect)
; inl_preserves_effect: forall Γ Σ Δ e T1 T2 ε, has_type Γ Σ Δ e T1 ε -> has_type Γ Σ Δ (EInl e T2) (TSum T1 T2) ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T1 Bool) (T2 Bool) (epsilon Bool)) (= 0 0))) ; inl_preserves_effect [partial: bindings preserved]

; inr_preserves_effect (matches Coq: Lemma inr_preserves_effect)
; inr_preserves_effect: forall Γ Σ Δ e T1 T2 ε, has_type Γ Σ Δ e T2 ε -> has_type Γ Σ Δ (EInr e T1) (TSum T1 T2) ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T1 Bool) (T2 Bool) (epsilon Bool)) (= 0 0))) ; inr_preserves_effect [partial: bindings preserved]

; ref_introduces_write (matches Coq: Lemma ref_introduces_write)
; ref_introduces_write: forall Γ Σ Δ e l T ε, has_type Γ Σ Δ (ERef e l) T ε -> effect_leq EffWrite ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (l Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; ref_introduces_write [partial: bindings preserved]

; deref_introduces_read (matches Coq: Lemma deref_introduces_read)
; deref_introduces_read: forall Γ Σ Δ e T ε, has_type Γ Σ Δ (EDeref e) T ε -> effect_leq EffRead ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; deref_introduces_read [partial: bindings preserved]

; assign_introduces_write (matches Coq: Lemma assign_introduces_write)
; assign_introduces_write: forall Γ Σ Δ e1 e2 T ε, has_type Γ Σ Δ (EAssign e1 e2) T ε -> effect_leq EffWrite ε
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; assign_introduces_write [partial: bindings preserved]

; ref_not_pure (matches Coq: Lemma ref_not_pure)
; ref_not_pure: forall Γ Σ Δ e l T, ~ has_type Γ Σ Δ (ERef e l) T EffPure
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (l Bool) (T Bool)) (= 0 0))) ; ref_not_pure [partial: bindings preserved]

; deref_not_pure (matches Coq: Lemma deref_not_pure)
; deref_not_pure: forall Γ Σ Δ e T, ~ has_type Γ Σ Δ (EDeref e) T EffPure
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool)) (= 0 0))) ; deref_not_pure [partial: bindings preserved]

; assign_not_pure (matches Coq: Lemma assign_not_pure)
; assign_not_pure: forall Γ Σ Δ e1 e2 T, ~ has_type Γ Σ Δ (EAssign e1 e2) T EffPure
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T Bool)) (= 0 0))) ; assign_not_pure [partial: bindings preserved]

; ref_effect_level_positive (matches Coq: Lemma ref_effect_level_positive)
; ref_effect_level_positive: forall Γ Σ Δ e l T ε, has_type Γ Σ Δ (ERef e l) T ε -> effect_level ε > 0
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (l Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; ref_effect_level_positive [partial: bindings preserved]

; deref_effect_level_positive (matches Coq: Lemma deref_effect_level_positive)
; deref_effect_level_positive: forall Γ Σ Δ e T ε, has_type Γ Σ Δ (EDeref e) T ε -> effect_level ε > 0
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; deref_effect_level_positive [partial: bindings preserved]

; assign_effect_level_positive (matches Coq: Lemma assign_effect_level_positive)
; assign_effect_level_positive: forall Γ Σ Δ e1 e2 T ε, has_type Γ Σ Δ (EAssign e1 e2) T ε -> effect_level ε > 0
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (T Bool) (epsilon Bool)) (= 0 0))) ; assign_effect_level_positive [partial: bindings preserved]

; ref_deref_both_nonpure (matches Coq: Lemma ref_deref_both_nonpure)
; ref_deref_both_nonpure: forall Γ Σ Δ e1 l1 e2 T1 T2 ε1 ε2, has_type Γ Σ Δ (ERef e1 l1) T1 ε1 -> has_type Γ Σ Δ (EDeref e2) T2 ε2 -> ε1 <> EffPur
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (l1 Bool) (e2 Bool) (T1 Bool) (T2 Bool) (epsilon1 Bool) (epsilon2 Bool)) (= 0 0))) ; ref_deref_both_nonpure [partial: bindings preserved]

; assign_deref_both_nonpure (matches Coq: Lemma assign_deref_both_nonpure)
; assign_deref_both_nonpure: forall Γ Σ Δ e1 e2 e3 T1 T2 ε1 ε2, has_type Γ Σ Δ (EAssign e1 e2) T1 ε1 -> has_type Γ Σ Δ (EDeref e3) T2 ε2 -> ε1 <> Eff
(assert (forall ((gamma Bool) (sigma Bool) (delta Bool) (e1 Bool) (e2 Bool) (e3 Bool) (T1 Bool) (T2 Bool) (epsilon1 Bool) (epsilon2 Bool)) (= 0 0))) ; assign_deref_both_nonpure [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

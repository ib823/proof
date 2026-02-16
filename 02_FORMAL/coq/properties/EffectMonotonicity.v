(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * Effect Monotonicity — Effect-Preserving Transformations

    Lemmas about how effects behave under typing constructions,
    effect joins, and evaluation. These are essential for reasoning
    about effect tracking correctness.

    Dependencies: Syntax.v, Typing.v, EffectAlgebra.v
    Mode: Core Deepening | Zero Trust
*)

Require Import Coq.Strings.String.
Require Import Coq.Lists.List.
Require Import Coq.Arith.PeanoNat.
Require Import Lia.
Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Typing.
Require Import RIINA.effects.EffectAlgebra.
Require Import RIINA.properties.EffectSafety.
Import ListNotations.

(* ================================================================= *)
(** ** Section 1: Effect Join Properties Under Typing *)
(* ================================================================= *)

(** If application has pure effect, function body and arguments are pure. *)
Lemma app_pure_implies_parts_pure : forall Γ Σ Δ e1 e2 T1 T ε_fn ε1 ε2,
  has_type Γ Σ Δ e1 (TFn T1 T ε_fn) ε1 ->
  has_type Γ Σ Δ e2 T1 ε2 ->
  effect_join ε_fn (effect_join ε1 ε2) = EffPure ->
  ε_fn = EffPure /\ ε1 = EffPure /\ ε2 = EffPure.
Proof.
  intros Γ Σ Δ e1 e2 T1 T ε_fn ε1 ε2 _ _ Hjoin.
  apply effect_join_pure_inv in Hjoin. destruct Hjoin as [Hfn Hrest].
  apply effect_join_pure_inv in Hrest. destruct Hrest as [H1 H2].
  auto.
Qed.

(** If let has pure effect, both body and continuation are pure. *)
Lemma let_pure_implies_parts_pure : forall ε1 ε2,
  effect_join ε1 ε2 = EffPure ->
  ε1 = EffPure /\ ε2 = EffPure.
Proof.
  intros ε1 ε2 Hjoin.
  apply effect_join_pure_inv in Hjoin. auto.
Qed.

(** If if-then-else has pure effect, all branches are pure. *)
Lemma if_pure_implies_parts_pure : forall ε1 ε2 ε3,
  effect_join ε1 (effect_join ε2 ε3) = EffPure ->
  ε1 = EffPure /\ ε2 = EffPure /\ ε3 = EffPure.
Proof.
  intros ε1 ε2 ε3 Hjoin.
  apply effect_join_pure_inv in Hjoin. destruct Hjoin as [H1 Hrest].
  apply effect_join_pure_inv in Hrest. destruct Hrest as [H2 H3].
  auto.
Qed.

(* ================================================================= *)
(** ** Section 2: Effect Ordering Under Subexpressions *)
(* ================================================================= *)

(** The effect of an application is at least as large as the function body effect. *)
Lemma app_effect_geq_fn : forall Γ Σ Δ e1 e2 T T1 ε_fn ε1 ε2,
  has_type Γ Σ Δ e1 (TFn T1 T ε_fn) ε1 ->
  has_type Γ Σ Δ e2 T1 ε2 ->
  effect_leq ε_fn (effect_join ε_fn (effect_join ε1 ε2)).
Proof.
  intros. unfold effect_leq. rewrite effect_level_join. apply Nat.le_max_l.
Qed.

(** The effect of an application is at least as large as each argument's effect. *)
Lemma app_effect_geq_arg1 : forall ε_fn ε1 ε2,
  effect_leq ε1 (effect_join ε_fn (effect_join ε1 ε2)).
Proof.
  intros. unfold effect_leq. rewrite effect_level_join, effect_level_join.
  lia.
Qed.

Lemma app_effect_geq_arg2 : forall ε_fn ε1 ε2,
  effect_leq ε2 (effect_join ε_fn (effect_join ε1 ε2)).
Proof.
  intros. unfold effect_leq. rewrite effect_level_join, effect_level_join.
  lia.
Qed.

(** The effect of a let is at least as large as each component. *)
Lemma let_effect_geq_body : forall ε1 ε2,
  effect_leq ε1 (effect_join ε1 ε2).
Proof.
  intros. unfold effect_leq. rewrite effect_level_join. apply Nat.le_max_l.
Qed.

Lemma let_effect_geq_cont : forall ε1 ε2,
  effect_leq ε2 (effect_join ε1 ε2).
Proof.
  intros. unfold effect_leq. rewrite effect_level_join. apply Nat.le_max_r.
Qed.

(* ================================================================= *)
(** ** Section 3: Pure Subexpression Extraction *)
(* ================================================================= *)

(** Fst inversion preserves pure effect. *)
Lemma fst_pure : forall Γ Σ Δ e T1,
  has_type Γ Σ Δ (EFst e) T1 EffPure ->
  exists T2, has_type Γ Σ Δ e (TProd T1 T2) EffPure.
Proof.
  intros Γ Σ Δ e T1 Hty.
  inversion Hty; subst. eexists. eassumption.
Qed.

(** Snd inversion preserves pure effect. *)
Lemma snd_pure : forall Γ Σ Δ e T2,
  has_type Γ Σ Δ (ESnd e) T2 EffPure ->
  exists T1, has_type Γ Σ Δ e (TProd T1 T2) EffPure.
Proof.
  intros Γ Σ Δ e T2 Hty.
  inversion Hty; subst. eexists. eassumption.
Qed.

(** Classify of pure expression gives pure classify. *)
Lemma classify_pure : forall Γ Σ Δ e T,
  has_type Γ Σ Δ (EClassify e) (TSecret T) EffPure ->
  has_type Γ Σ Δ e T EffPure.
Proof.
  intros Γ Σ Δ e T Hty.
  inversion Hty; subst. assumption.
Qed.

(** Prove of pure expression gives pure prove. *)
Lemma prove_pure : forall Γ Σ Δ e T,
  has_type Γ Σ Δ (EProve e) (TProof T) EffPure ->
  has_type Γ Σ Δ e T EffPure.
Proof.
  intros Γ Σ Δ e T Hty.
  inversion Hty; subst. assumption.
Qed.

(* ================================================================= *)
(** ** Section 4: Effect Join Decomposition *)
(* ================================================================= *)

(** Effect join is bounded by the max of individual levels. *)
Lemma effect_join_level_bound : forall e1 e2,
  effect_level (effect_join e1 e2) =
  Nat.max (effect_level e1) (effect_level e2).
Proof.
  intros. apply effect_level_join.
Qed.

(** If an effect is greater than or equal to a join, it's geq both components. *)
Lemma effect_leq_join_both : forall e1 e2 e,
  effect_leq (effect_join e1 e2) e ->
  effect_leq e1 e /\ effect_leq e2 e.
Proof.
  intros e1 e2 e H. unfold effect_leq in *.
  rewrite effect_level_join in H.
  split; lia.
Qed.

(** Conversely, if an effect is geq both, it's geq the join. *)
Lemma effect_leq_both_join : forall e1 e2 e,
  effect_leq e1 e ->
  effect_leq e2 e ->
  effect_leq (effect_join e1 e2) e.
Proof.
  intros e1 e2 e H1 H2. unfold effect_leq in *.
  rewrite effect_level_join. lia.
Qed.

(** Pure is the identity for effect_join. *)
Lemma effect_join_pure_r : forall e,
  effect_join e EffPure = e.
Proof.
  intros e. apply effect_join_pure_r.
Qed.

(* ================================================================= *)
(** ** Section 5: Type Constructor Injectivity *)
(* ================================================================= *)

(** TFn is injective in all arguments. *)
Lemma tfn_injective : forall T1 T2 ε1 T1' T2' ε1',
  TFn T1 T2 ε1 = TFn T1' T2' ε1' ->
  T1 = T1' /\ T2 = T2' /\ ε1 = ε1'.
Proof.
  intros. injection H. auto.
Qed.

(** TProd is injective. *)
Lemma tprod_injective : forall T1 T2 T1' T2',
  TProd T1 T2 = TProd T1' T2' ->
  T1 = T1' /\ T2 = T2'.
Proof.
  intros. injection H. auto.
Qed.

(** TSum is injective. *)
Lemma tsum_injective : forall T1 T2 T1' T2',
  TSum T1 T2 = TSum T1' T2' ->
  T1 = T1' /\ T2 = T2'.
Proof.
  intros. injection H. auto.
Qed.

(** TRef is injective. *)
Lemma tref_injective : forall T sl T' sl',
  TRef T sl = TRef T' sl' ->
  T = T' /\ sl = sl'.
Proof.
  intros. injection H. auto.
Qed.

(** TSecret is injective. *)
Lemma tsecret_injective : forall T T',
  TSecret T = TSecret T' ->
  T = T'.
Proof.
  intros. injection H. auto.
Qed.

(** TProof is injective. *)
Lemma tproof_injective : forall T T',
  TProof T = TProof T' ->
  T = T'.
Proof.
  intros. injection H. auto.
Qed.

(** TList is injective. *)
Lemma tlist_injective : forall T T',
  TList T = TList T' ->
  T = T'.
Proof.
  intros. injection H. auto.
Qed.

(** TOption is injective. *)
Lemma toption_injective : forall T T',
  TOption T = TOption T' ->
  T = T'.
Proof.
  intros. injection H. auto.
Qed.

(* ================================================================= *)
(** ** Section 6: Effect Compositionality *)
(* ================================================================= *)

(** Effect of nested lets is the join of all effects. *)
Lemma nested_let_effect : forall Γ Σ Δ x y e1 e2 e3 T1 T2 T3 ε1 ε2 ε3,
  has_type Γ Σ Δ e1 T1 ε1 ->
  has_type ((x, T1) :: Γ) Σ Δ e2 T2 ε2 ->
  has_type ((y, T2) :: (x, T1) :: Γ) Σ Δ e3 T3 ε3 ->
  has_type Γ Σ Δ (ELet x e1 (ELet y e2 e3)) T3
    (effect_join ε1 (effect_join ε2 ε3)).
Proof.
  intros. econstructor; eauto. econstructor; eauto.
Qed.

(** Effect of sequential pair construction. *)
Lemma sequential_pair_effect : forall Γ Σ Δ e1 e2 T1 T2 ε1 ε2,
  has_type Γ Σ Δ e1 T1 ε1 ->
  has_type Γ Σ Δ e2 T2 ε2 ->
  has_type Γ Σ Δ (EPair e1 e2) (TProd T1 T2) (effect_join ε1 ε2).
Proof.
  intros. econstructor; eauto.
Qed.

(** Classify preserves effect. *)
Lemma classify_preserves_effect : forall Γ Σ Δ e T ε,
  has_type Γ Σ Δ e T ε ->
  has_type Γ Σ Δ (EClassify e) (TSecret T) ε.
Proof.
  intros. econstructor; eauto.
Qed.

(** Prove preserves effect. *)
Lemma prove_preserves_effect : forall Γ Σ Δ e T ε,
  has_type Γ Σ Δ e T ε ->
  has_type Γ Σ Δ (EProve e) (TProof T) ε.
Proof.
  intros. econstructor; eauto.
Qed.

(** Inl preserves effect. *)
Lemma inl_preserves_effect : forall Γ Σ Δ e T1 T2 ε,
  has_type Γ Σ Δ e T1 ε ->
  has_type Γ Σ Δ (EInl e T2) (TSum T1 T2) ε.
Proof.
  intros. econstructor; eauto.
Qed.

(** Inr preserves effect. *)
Lemma inr_preserves_effect : forall Γ Σ Δ e T1 T2 ε,
  has_type Γ Σ Δ e T2 ε ->
  has_type Γ Σ Δ (EInr e T1) (TSum T1 T2) ε.
Proof.
  intros. econstructor; eauto.
Qed.

(* ================================================================= *)
(** ** Section 7: Ref Effect Properties *)
(* ================================================================= *)

(** Ref always introduces at least EffWrite. *)
Lemma ref_introduces_write : forall Γ Σ Δ e l T ε,
  has_type Γ Σ Δ (ERef e l) T ε ->
  effect_leq EffWrite ε.
Proof.
  intros Γ Σ Δ e l T ε Hty.
  inversion Hty; subst.
  unfold effect_leq. rewrite effect_level_join. simpl. lia.
Qed.

(** Deref always introduces at least EffRead. *)
Lemma deref_introduces_read : forall Γ Σ Δ e T ε,
  has_type Γ Σ Δ (EDeref e) T ε ->
  effect_leq EffRead ε.
Proof.
  intros Γ Σ Δ e T ε Hty.
  inversion Hty; subst.
  unfold effect_leq. rewrite effect_level_join. simpl. lia.
Qed.

(** Assign always introduces at least EffWrite. *)
Lemma assign_introduces_write : forall Γ Σ Δ e1 e2 T ε,
  has_type Γ Σ Δ (EAssign e1 e2) T ε ->
  effect_leq EffWrite ε.
Proof.
  intros Γ Σ Δ e1 e2 T ε Hty.
  inversion Hty; subst.
  unfold effect_leq. rewrite effect_level_join, effect_level_join. simpl. lia.
Qed.

(** Ref cannot have pure effect. *)
Lemma ref_not_pure : forall Γ Σ Δ e l T,
  ~ has_type Γ Σ Δ (ERef e l) T EffPure.
Proof.
  intros Γ Σ Δ e l T H.
  assert (Hle := ref_introduces_write _ _ _ _ _ _ _ H).
  unfold effect_leq in Hle. simpl in Hle. lia.
Qed.

(** Deref cannot have pure effect. *)
Lemma deref_not_pure : forall Γ Σ Δ e T,
  ~ has_type Γ Σ Δ (EDeref e) T EffPure.
Proof.
  intros Γ Σ Δ e T H.
  assert (Hle := deref_introduces_read _ _ _ _ _ _ H).
  unfold effect_leq in Hle. simpl in Hle. lia.
Qed.

(** Assign cannot have pure effect. *)
Lemma assign_not_pure : forall Γ Σ Δ e1 e2 T,
  ~ has_type Γ Σ Δ (EAssign e1 e2) T EffPure.
Proof.
  intros Γ Σ Δ e1 e2 T H.
  assert (Hle := assign_introduces_write _ _ _ _ _ _ _ H).
  unfold effect_leq in Hle. simpl in Hle. lia.
Qed.

(** ** Effect Level Positivity for Stateful Operations *)

(** Ref expression always has positive effect level *)
Lemma ref_effect_level_positive : forall Γ Σ Δ e l T ε,
  has_type Γ Σ Δ (ERef e l) T ε ->
  effect_level ε > 0.
Proof.
  intros Γ Σ Δ e l T ε Hty.
  assert (H := ref_introduces_write _ _ _ _ _ _ _ Hty).
  unfold effect_leq in H. simpl in H. lia.
Qed.

(** Deref expression always has positive effect level *)
Lemma deref_effect_level_positive : forall Γ Σ Δ e T ε,
  has_type Γ Σ Δ (EDeref e) T ε ->
  effect_level ε > 0.
Proof.
  intros Γ Σ Δ e T ε Hty.
  assert (H := deref_introduces_read _ _ _ _ _ _ Hty).
  unfold effect_leq in H. simpl in H. lia.
Qed.

(** Assign expression always has positive effect level *)
Lemma assign_effect_level_positive : forall Γ Σ Δ e1 e2 T ε,
  has_type Γ Σ Δ (EAssign e1 e2) T ε ->
  effect_level ε > 0.
Proof.
  intros Γ Σ Δ e1 e2 T ε Hty.
  assert (H := assign_introduces_write _ _ _ _ _ _ _ Hty).
  unfold effect_leq in H. simpl in H. lia.
Qed.

(** Ref and deref are both nonpure *)
Lemma ref_deref_both_nonpure : forall Γ Σ Δ e1 l1 e2 T1 T2 ε1 ε2,
  has_type Γ Σ Δ (ERef e1 l1) T1 ε1 ->
  has_type Γ Σ Δ (EDeref e2) T2 ε2 ->
  ε1 <> EffPure /\ ε2 <> EffPure.
Proof.
  intros. split.
  - intro Heq. subst. eapply ref_not_pure; eauto.
  - intro Heq. subst. eapply deref_not_pure; eauto.
Qed.

(** Assign and deref are both nonpure *)
Lemma assign_deref_both_nonpure : forall Γ Σ Δ e1 e2 e3 T1 T2 ε1 ε2,
  has_type Γ Σ Δ (EAssign e1 e2) T1 ε1 ->
  has_type Γ Σ Δ (EDeref e3) T2 ε2 ->
  ε1 <> EffPure /\ ε2 <> EffPure.
Proof.
  intros. split.
  - intro Heq. subst. eapply assign_not_pure; eauto.
  - intro Heq. subst. eapply deref_not_pure; eauto.
Qed.

(** End of EffectMonotonicity.v *)

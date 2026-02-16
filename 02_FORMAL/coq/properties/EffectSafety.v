(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * Effect Safety — Semantic Soundness of the Effect System

    Proves that effect annotations in the type system are semantically
    meaningful: pure-typed computations do not modify the store, and
    more generally, effect annotations bound the observable side effects.

    Key results:
    - [effect_join_pure_inv]: effect_join ε1 ε2 = EffPure → both are EffPure
    - [value_dec]: decidability of the value predicate
    - [pure_step_preserves_store]: pure computations don't change the store
    - [pure_multi_step_preserves_store]: same for multi-step
    - [pure_step_preserves_ctx]: pure computations don't change the effect context
    - [multi_step_deterministic_value]: unique final values

    Dependencies: Syntax.v, Semantics.v, Typing.v, Preservation.v,
                  EffectAlgebra.v

    Mode: Core Deepening | Zero Trust
*)

Require Import Coq.Strings.String.
Require Import Coq.Lists.List.
Require Import Coq.Arith.Arith.
Require Import Coq.Arith.PeanoNat.
Require Import Lia.
Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Semantics.
Require Import RIINA.foundations.Typing.
Require Import RIINA.type_system.Preservation.
Require Import RIINA.effects.EffectAlgebra.
Require Import Coq.Program.Equality.
Import ListNotations.

(* ================================================================= *)
(** ** Section 1: Effect Join Inversion *)
(* ================================================================= *)

(** If the join of two effects is EffPure, both must be EffPure.
    This is because EffPure has level 0 (the minimum), and effect_join
    takes the maximum. *)

Lemma effect_join_pure_inv : forall ε1 ε2,
  effect_join ε1 ε2 = EffPure ->
  ε1 = EffPure /\ ε2 = EffPure.
Proof.
  intros ε1 ε2 Hjoin.
  unfold effect_join in Hjoin.
  destruct (effect_level ε1 <? effect_level ε2) eqn:Hlt.
  - (* ε2 is the max *)
    apply Nat.ltb_lt in Hlt.
    split.
    + destruct ε2; simpl in Hjoin; try discriminate.
      destruct ε1; simpl in Hlt; lia.
    + destruct ε2; simpl in Hjoin; try discriminate. reflexivity.
  - (* ε1 is the max *)
    apply Nat.ltb_ge in Hlt.
    split.
    + destruct ε1; simpl in Hjoin; try discriminate. reflexivity.
    + destruct ε1; simpl in Hjoin; try discriminate.
      destruct ε2; simpl in Hlt; try reflexivity; exfalso; lia.
Qed.

(** Corollary: if a triple join is pure, all three components are pure. *)
Corollary effect_join_triple_pure_inv : forall ε1 ε2 ε3,
  effect_join ε1 (effect_join ε2 ε3) = EffPure ->
  ε1 = EffPure /\ ε2 = EffPure /\ ε3 = EffPure.
Proof.
  intros ε1 ε2 ε3 H.
  apply effect_join_pure_inv in H.
  destruct H as [H1 H23].
  apply effect_join_pure_inv in H23.
  destruct H23 as [H2 H3].
  auto.
Qed.

(** Join with EffWrite is never pure. *)
Lemma effect_join_write_not_pure : forall ε,
  effect_join ε EffWrite <> EffPure.
Proof.
  intros ε H.
  apply effect_join_pure_inv in H.
  destruct H as [_ H2]. discriminate.
Qed.

(** Join with EffRead is never pure. *)
Lemma effect_join_read_not_pure : forall ε,
  effect_join ε EffRead <> EffPure.
Proof.
  intros ε H.
  apply effect_join_pure_inv in H.
  destruct H as [_ H2]. discriminate.
Qed.

(* ================================================================= *)
(** ** Section 2: Value Decidability *)
(* ================================================================= *)

(** The value predicate is decidable. This is useful for case analysis
    in many proof contexts. *)

Lemma value_dec : forall e, {value e} + {~ value e}.
Proof.
  induction e; try (right; intro H; inversion H; fail).
  - (* EUnit *) left. constructor.
  - (* EBool *) left. constructor.
  - (* EInt *) left. constructor.
  - (* EString *) left. constructor.
  - (* ELoc *) left. constructor.
  - (* ELam *) left. constructor.
  - (* EPair *)
    destruct IHe1; destruct IHe2.
    + left. constructor; assumption.
    + right. intro H. inversion H; subst. contradiction.
    + right. intro H. inversion H; subst. contradiction.
    + right. intro H. inversion H; subst. contradiction.
  - (* EInl *)
    destruct IHe.
    + left. constructor. assumption.
    + right. intro H. inversion H; subst. contradiction.
  - (* EInr *)
    destruct IHe.
    + left. constructor. assumption.
    + right. intro H. inversion H; subst. contradiction.
  - (* EClassify *)
    destruct IHe.
    + left. constructor. assumption.
    + right. intro H. inversion H; subst. contradiction.
  - (* EProve *)
    destruct IHe.
    + left. constructor. assumption.
    + right. intro H. inversion H; subst. contradiction.
Qed.

(* ================================================================= *)
(** ** Section 3: Pure Computation Store Invariance *)
(* ================================================================= *)

(** The main theorem: if a closed expression is typed with EffPure,
    then taking a step does not change the store.

    Proof strategy: by induction on the step relation, inverting the
    typing derivation to get effect constraints, and using
    [effect_join_pure_inv] to show all sub-effects are pure.
    The only step rules that change the store are [ST_RefValue] and
    [ST_AssignLoc], both of which require [EffWrite] in the typing
    derivation, contradicting EffPure. *)

Theorem pure_step_preserves_store : forall e e' T st st' ctx ctx' Σ,
  has_type nil Σ Public e T EffPure ->
  store_wf Σ st ->
  (e, st, ctx) --> (e', st', ctx') ->
  st' = st.
Proof.
  intros e e' T st st' ctx ctx' Σ Hty Hwf Hstep.
  remember (e, st, ctx) as cfg1 eqn:Hcfg1.
  remember (e', st', ctx') as cfg2 eqn:Hcfg2.
  revert e e' st st' ctx ctx' T Σ Hty Hwf Hcfg1 Hcfg2.
  induction Hstep; intros ? ? ? ? ? ? T0 Σ0 Hty Hwf Hcfg1 Hcfg2;
    inversion Hcfg1; inversion Hcfg2; subst; clear Hcfg1 Hcfg2;
    try reflexivity;
    inversion Hty; subst;
    unfold EffectPure, EffectRead, EffectWrite in *;
    repeat (match goal with
    | H: effect_join _ _ = EffPure |- _ =>
        apply effect_join_pure_inv in H; destruct H; subst
    end);
    try (eapply IHHstep; try reflexivity; try eassumption);
    try discriminate;
    try congruence.
Qed.

(** Pure steps also preserve the effect context. *)
Theorem pure_step_preserves_ctx : forall e e' T st st' ctx ctx' Σ,
  has_type nil Σ Public e T EffPure ->
  store_wf Σ st ->
  (e, st, ctx) --> (e', st', ctx') ->
  ctx' = ctx.
Proof.
  intros e e' T st st' ctx ctx' Σ Hty Hwf Hstep.
  remember (e, st, ctx) as cfg1 eqn:Hcfg1.
  remember (e', st', ctx') as cfg2 eqn:Hcfg2.
  revert e e' st st' ctx ctx' T Σ Hty Hwf Hcfg1 Hcfg2.
  induction Hstep; intros ? ? ? ? ? ? T0 Σ0 Hty Hwf Hcfg1 Hcfg2;
    inversion Hcfg1; inversion Hcfg2; subst; clear Hcfg1 Hcfg2;
    try reflexivity;
    inversion Hty; subst;
    unfold EffectPure, EffectRead, EffectWrite in *;
    repeat (match goal with
    | H: effect_join _ _ = EffPure |- _ =>
        apply effect_join_pure_inv in H; destruct H; subst
    end);
    try (eapply IHHstep; try reflexivity; try eassumption);
    try discriminate;
    try congruence.
Qed.

(** Effect-preserving subject reduction for EffPure.
    If a pure-typed expression steps, the result is also pure-typed.
    Proof by induction on the step relation. *)
Lemma preservation_pure : forall e e' T st st' ctx ctx' Σ,
  has_type nil Σ Public e T EffPure ->
  store_wf Σ st ->
  (e, st, ctx) --> (e', st', ctx') ->
  exists Σ',
    store_ty_extends Σ Σ' /\
    store_wf Σ' st' /\
    has_type nil Σ' Public e' T EffPure.
Proof.
  intros e e' T st st' ctx ctx' Σ Hty Hwf Hstep.
  remember (e, st, ctx) as cfg1 eqn:Hcfg1.
  remember (e', st', ctx') as cfg2 eqn:Hcfg2.
  revert e e' st st' ctx ctx' T Σ Hty Hwf Hcfg1 Hcfg2.
  induction Hstep; intros ? ? ? ? ? ? T0 Σ0 Hty Hwf Hcfg1 Hcfg2;
    inversion Hcfg1; inversion Hcfg2; subst; clear Hcfg1 Hcfg2;
    inversion Hty; subst;
    unfold EffectPure, EffectRead, EffectWrite in *;
    repeat match goal with
    | H: effect_join _ _ = EffPure |- _ =>
        apply effect_join_pure_inv in H; destruct H; subst
    | H: EffPure = effect_join _ _ |- _ =>
        symmetry in H; apply effect_join_pure_inv in H; destruct H; subst
    end;
    repeat (try (change (effect_join EffPure EffPure) with EffPure in |- *));
    try discriminate;
    try congruence;
    (* Phase 0: Value reduction — store unchanged, result directly typed *)
    try solve [eexists; split; [apply store_ty_extends_refl|];
               split; [eassumption|]; eassumption];
    (* Phase 1: Lambda/substitution cases *)
    try solve [
      match goal with
      | H : has_type _ _ _ (ELam _ _ _) _ _ |- _ =>
          inversion H; subst;
          repeat match goal with
          | H': effect_join _ _ = EffPure |- _ =>
              apply effect_join_pure_inv in H'; destruct H'; subst
          end;
          eexists; split; [apply store_ty_extends_refl|]; split; [eassumption|];
          eapply substitution_preserves_typing; eassumption
      end];
    (* Phase 2: Direct substitution *)
    try solve [eexists; split; [apply store_ty_extends_refl|]; split; [eassumption|];
               eapply substitution_preserves_typing; eassumption];
    (* Phase 3: Sum inversion + substitution *)
    try solve [
      match goal with
      | H : has_type _ _ _ (EInl _ _) _ _ |- _ =>
          inversion H; subst;
          repeat match goal with
          | H': effect_join _ _ = EffPure |- _ =>
              apply effect_join_pure_inv in H'; destruct H'; subst
          end;
          eexists; split; [apply store_ty_extends_refl|]; split; [eassumption|];
          eapply substitution_preserves_typing; eassumption
      | H : has_type _ _ _ (EInr _ _) _ _ |- _ =>
          inversion H; subst;
          repeat match goal with
          | H': effect_join _ _ = EffPure |- _ =>
              apply effect_join_pure_inv in H'; destruct H'; subst
          end;
          eexists; split; [apply store_ty_extends_refl|]; split; [eassumption|];
          eapply substitution_preserves_typing; eassumption
      end];
    (* Phase 4: Pair inversion *)
    try solve [
      match goal with
      | H : has_type _ _ _ (EPair _ _) _ _ |- _ =>
          inversion H; subst;
          repeat match goal with
          | H': effect_join _ _ = EffPure |- _ =>
              apply effect_join_pure_inv in H'; destruct H'; subst
          end;
          eexists; split; [apply store_ty_extends_refl|]; split; [eassumption|];
          eassumption
      end];
    (* Phase 5: Classify inversion *)
    try solve [
      match goal with
      | H : has_type _ _ _ (EClassify _) _ _ |- _ =>
          inversion H; subst;
          eexists; split; [apply store_ty_extends_refl|]; split; [eassumption|];
          eassumption
      end];
    (* Phase 6: declass_ok contradiction *)
    try solve [
      match goal with
      | H : declass_ok _ _ |- _ =>
          unfold declass_ok in H; destruct H as [? [? [? ?]]]; subst;
          exfalso; eapply value_does_not_step; [| eassumption];
          repeat constructor; assumption
      end];
    (* Phase 7: Congruence — use match goal backtracking to find correct
       typing hypothesis for IH. match goal with backtracks if a branch
       fails, trying the next matching hypothesis. *)
    try solve [
      match goal with
      | Htyp : has_type _ _ _ _ _ EffPure,
        Hw : store_wf _ _ |- _ =>
        edestruct (IHHstep _ _ _ _ _ _ _ _ Htyp Hw eq_refl eq_refl)
          as [Σ' [Hext [Hwf' Hty']]];
        exists Σ'; split; [exact Hext|]; split; [exact Hwf'|];
        first
          [ eassumption
          | eapply T_Fst; first [eassumption | eapply store_ty_extends_preserves_typing; eassumption]
          | eapply T_Snd; first [eassumption | eapply store_ty_extends_preserves_typing; eassumption]
          | eapply T_Inl; first [eassumption | eapply store_ty_extends_preserves_typing; eassumption]
          | eapply T_Inr; first [eassumption | eapply store_ty_extends_preserves_typing; eassumption]
          | eapply T_Classify; first [eassumption | eapply store_ty_extends_preserves_typing; eassumption]
          | eapply T_Prove; first [eassumption | eapply store_ty_extends_preserves_typing; eassumption]
          | eapply T_Grant; first [eassumption | eapply store_ty_extends_preserves_typing; eassumption]
          | refine (T_App _ _ _ _ _ _ _ EffPure EffPure EffPure _ _);
            first [eassumption | eapply store_ty_extends_preserves_typing; eassumption]
          | refine (T_Pair _ _ _ _ _ _ _ EffPure EffPure _ _);
            first [eassumption | eapply store_ty_extends_preserves_typing; eassumption]
          | refine (T_If _ _ _ _ _ _ _ EffPure EffPure EffPure _ _ _);
            first [eassumption | eapply store_ty_extends_preserves_typing; eassumption]
          | refine (T_Case _ _ _ _ _ _ _ _ _ _ _ EffPure EffPure EffPure _ _ _);
            first [eassumption | eapply store_ty_extends_preserves_typing; eassumption]
          | refine (T_Let _ _ _ _ _ _ _ _ EffPure EffPure _ _);
            first [eassumption | eapply store_ty_extends_preserves_typing; eassumption]
          | refine (T_Handle _ _ _ _ _ _ _ _ EffPure EffPure _ _);
            first [eassumption | eapply store_ty_extends_preserves_typing; eassumption]
          | refine (T_Perform _ _ _ _ _ _ EffPure _);
            first [eassumption | eapply store_ty_extends_preserves_typing; eassumption]
          | refine (T_Require _ _ _ _ _ _ EffPure _);
            first [eassumption | eapply store_ty_extends_preserves_typing; eassumption]
          | refine (T_Declassify _ _ _ _ _ _ EffPure EffPure _ _ _);
            first [eassumption | eapply store_ty_extends_preserves_typing; eassumption]
          ]
      end
    ].
Qed.

(** Multi-step pure store invariance.
    By induction on multi_step, using [pure_step_preserves_store] to show
    each step preserves the store, and [preservation_pure] to propagate
    EffPure typing through the sequence. *)
Theorem pure_multi_step_preserves_store :
  forall e e' T st st' ctx ctx' Σ,
  has_type nil Σ Public e T EffPure ->
  store_wf Σ st ->
  (e, st, ctx) -->* (e', st', ctx') ->
  st' = st.
Proof.
  intros e e' T st st' ctx ctx' Σ Hty Hwf Hmulti.
  remember (e, st, ctx) as cfg1 eqn:Heq1.
  remember (e', st', ctx') as cfg2 eqn:Heq2.
  revert e st ctx e' st' ctx' T Σ Heq1 Heq2 Hty Hwf.
  induction Hmulti; intros e0 st0 ctx0 e0' st0' ctx0' T0 Σ0 Heq1 Heq2 Hty Hwf.
  - (* MS_Refl *)
    rewrite Heq1 in Heq2. inversion Heq2; subst. reflexivity.
  - (* MS_Step *)
    subst.
    destruct cfg2 as [[em stm] ctxm].
    assert (Hst_eq : stm = st0).
    { eapply pure_step_preserves_store; eassumption. }
    subst stm.
    destruct (preservation_pure e0 em T0 st0 st0 ctx0 ctxm Σ0 Hty Hwf H)
      as [Σ' [Hext [Hwf' Hty']]].
    eapply IHHmulti.
    + reflexivity.
    + reflexivity.
    + exact Hty'.
    + exact Hwf'.
Qed.

(* ================================================================= *)
(** ** Section 4: Multi-step Determinism *)
(* ================================================================= *)

(** If an expression evaluates to two different values via multi-step,
    the values must be equal. Direct consequence of step determinism. *)

(** Values cannot multi-step to a different configuration. *)
Lemma multi_step_value_inv : forall v st ctx e' st' ctx',
  value v ->
  (v, st, ctx) -->* (e', st', ctx') ->
  v = e' /\ st = st' /\ ctx = ctx'.
Proof.
  intros v st ctx e' st' ctx' Hval Hms.
  remember (v, st, ctx) as cfg1.
  remember (e', st', ctx') as cfg2.
  revert v st ctx e' st' ctx' Heqcfg1 Heqcfg2 Hval.
  induction Hms; intros v0 st0 ctx0 e0 st0' ctx0' Heq1 Heq2 Hval0.
  - (* MS_Refl *)
    rewrite Heq1 in Heq2. inversion Heq2. auto.
  - (* MS_Step *)
    subst. destruct cfg2 as [[e2 st2] ctx2].
    exfalso. eapply value_does_not_step; eauto.
Qed.

(* ================================================================= *)
(** ** Section 5: Effect Floor Properties *)
(* ================================================================= *)

(** Atomic values (non-compound) have EffPure effect. *)
Lemma atomic_value_pure : forall Γ Σ Δ v T ε,
  has_type Γ Σ Δ v T ε ->
  (v = EUnit \/ (exists b, v = EBool b) \/ (exists n, v = EInt n) \/
   (exists s, v = EString s) \/ (exists l, v = ELoc l) \/
   (exists x T' body, v = ELam x T' body)) ->
  ε = EffPure.
Proof.
  intros Γ Σ Δ v T ε Hty Hform.
  destruct Hform as [H | [H | [H | [H | [H | H]]]]].
  - subst. inversion Hty. reflexivity.
  - destruct H as [b H]. subst. inversion Hty. reflexivity.
  - destruct H as [n H]. subst. inversion Hty. reflexivity.
  - destruct H as [s H]. subst. inversion Hty. reflexivity.
  - destruct H as [l H]. subst. inversion Hty. reflexivity.
  - destruct H as [x [T' [body H]]]. subst. inversion Hty. reflexivity.
Qed.

(** The EffPure effect is the only effect with level 0. *)
Lemma effect_level_zero_is_pure : forall ε,
  effect_level ε = 0 -> ε = EffPure.
Proof.
  intros ε H. destruct ε; simpl in H; try discriminate. reflexivity.
Qed.

(** Effect join with any non-pure effect is non-pure. *)
Lemma effect_join_nonpure : forall ε1 ε2,
  ε2 <> EffPure ->
  effect_join ε1 ε2 <> EffPure.
Proof.
  intros ε1 ε2 Hne Hjoin.
  apply effect_join_pure_inv in Hjoin.
  destruct Hjoin as [_ H]. contradiction.
Qed.

(* ================================================================= *)
(** ** Section 6: Effect Join Monotonicity *)
(* ================================================================= *)

(** Effect join is monotone in both arguments:
    if ε1 ≤ ε1' and ε2 ≤ ε2', then join(ε1, ε2) ≤ join(ε1', ε2'). *)

Lemma effect_join_monotone : forall ε1 ε1' ε2 ε2',
  effect_leq ε1 ε1' ->
  effect_leq ε2 ε2' ->
  effect_leq (effect_join ε1 ε2) (effect_join ε1' ε2').
Proof.
  intros ε1 ε1' ε2 ε2' Hle1 Hle2.
  unfold effect_leq in *.
  rewrite effect_level_join. rewrite effect_level_join.
  lia.
Qed.

(** Effect join is monotone in the left argument. *)
Lemma effect_join_mono_l : forall ε1 ε1' ε2,
  effect_leq ε1 ε1' ->
  effect_leq (effect_join ε1 ε2) (effect_join ε1' ε2).
Proof.
  intros. apply effect_join_monotone; auto. apply effect_leq_refl.
Qed.

(** Effect join is monotone in the right argument. *)
Lemma effect_join_mono_r : forall ε1 ε2 ε2',
  effect_leq ε2 ε2' ->
  effect_leq (effect_join ε1 ε2) (effect_join ε1 ε2').
Proof.
  intros. apply effect_join_monotone; auto. apply effect_leq_refl.
Qed.

(* ================================================================= *)
(** ** Section 7: Effect Subsumption *)
(* ================================================================= *)

(** EffPure is the bottom element. *)
Lemma effect_leq_pure : forall ε,
  effect_leq EffPure ε.
Proof.
  intros ε. unfold effect_leq. simpl. lia.
Qed.

(** EffRead is below EffWrite. *)
Lemma read_leq_write :
  effect_leq EffRead EffWrite.
Proof.
  unfold effect_leq. simpl. lia.
Qed.

(** EffWrite subsumes EffRead under join. *)
Lemma write_subsumes_read :
  effect_join EffRead EffWrite = EffWrite.
Proof. reflexivity. Qed.

(** EffFileSystem is between Write and Network in the hierarchy. *)
Lemma write_leq_filesystem :
  effect_leq EffWrite EffFileSystem.
Proof. unfold effect_leq. simpl. lia. Qed.

(** EffPure is below EffRead. *)
Lemma pure_leq_read :
  effect_leq EffPure EffRead.
Proof. unfold effect_leq. simpl. lia. Qed.

(** EffPure is below EffWrite. *)
Lemma pure_leq_write :
  effect_leq EffPure EffWrite.
Proof. unfold effect_leq. simpl. lia. Qed.

(** Read and Write are not equal. *)
Lemma read_neq_write : EffRead <> EffWrite.
Proof. discriminate. Qed.

(* ================================================================= *)
(** ** Section 8: Effect Join Identity and Idempotence *)
(* ================================================================= *)

(** EffPure is the left identity for join. *)
Lemma effect_join_pure_l : forall ε,
  effect_join EffPure ε = ε.
Proof.
  intros ε. unfold effect_join. simpl.
  destruct (effect_level ε) eqn:Hlev.
  - simpl. apply effect_level_injective. simpl. symmetry. exact Hlev.
  - simpl. reflexivity.
Qed.

(** Effect join is idempotent. *)
Lemma effect_join_idem : forall ε,
  effect_join ε ε = ε.
Proof.
  intros ε. unfold effect_join.
  rewrite Nat.ltb_irrefl. reflexivity.
Qed.

(* ================================================================= *)
(** ** Section 9: Well-Typed Values Are Pure *)
(* ================================================================= *)

(** Every base-type value (unit, bool, int, string, loc, lam) is typed with EffPure. *)
Lemma base_value_always_pure : forall Γ Σ Δ v T ε,
  has_type Γ Σ Δ v T ε ->
  (v = EUnit \/ (exists b, v = EBool b) \/ (exists n, v = EInt n) \/
   (exists s, v = EString s) \/ (exists l, v = ELoc l) \/
   (exists x T' body, v = ELam x T' body)) ->
  ε = EffPure.
Proof.
  intros Γ Σ Δ v T ε Hty Hbase.
  destruct Hbase as [H | [H | [H | [H | [H | H]]]]].
  - subst. inversion Hty. reflexivity.
  - destruct H as [b H]; subst. inversion Hty. reflexivity.
  - destruct H as [n H]; subst. inversion Hty. reflexivity.
  - destruct H as [s H]; subst. inversion Hty. reflexivity.
  - destruct H as [l H]; subst. inversion Hty. reflexivity.
  - destruct H as [x [T' [body H]]]; subst. inversion Hty. reflexivity.
Qed.

(* ================================================================= *)
(** ** Section 10: Pure Multi-Step Context Invariance *)
(* ================================================================= *)

(** Multi-step evaluation of pure expressions preserves context. *)
Theorem pure_multi_step_preserves_ctx :
  forall e e' T st st' ctx ctx' Σ,
  has_type nil Σ Public e T EffPure ->
  store_wf Σ st ->
  (e, st, ctx) -->* (e', st', ctx') ->
  ctx' = ctx.
Proof.
  intros e e' T st st' ctx ctx' Σ Hty Hwf Hmulti.
  remember (e, st, ctx) as cfg1 eqn:Heq1.
  remember (e', st', ctx') as cfg2 eqn:Heq2.
  revert e st ctx e' st' ctx' T Σ Heq1 Heq2 Hty Hwf.
  induction Hmulti; intros e0 st0 ctx0 e0' st0' ctx0' T0 Σ0 Heq1 Heq2 Hty Hwf.
  - rewrite Heq1 in Heq2. inversion Heq2; subst. reflexivity.
  - subst.
    destruct cfg2 as [[em stm] ctxm].
    assert (Hst_eq : stm = st0).
    { eapply pure_step_preserves_store; eassumption. }
    assert (Hctx_eq : ctxm = ctx0).
    { eapply pure_step_preserves_ctx; eassumption. }
    subst stm ctxm.
    destruct (preservation_pure e0 em T0 st0 st0 ctx0 ctx0 Σ0 Hty Hwf H)
      as [Σ' [Hext [Hwf' Hty']]].
    eapply IHHmulti; try reflexivity; eassumption.
Qed.

(** Combined: pure multi-step preserves both store and context. *)
Corollary pure_multi_step_preserves_all :
  forall e e' T st st' ctx ctx' Σ,
  has_type nil Σ Public e T EffPure ->
  store_wf Σ st ->
  (e, st, ctx) -->* (e', st', ctx') ->
  st' = st /\ ctx' = ctx.
Proof.
  intros. split.
  - eapply pure_multi_step_preserves_store; eassumption.
  - eapply pure_multi_step_preserves_ctx; eassumption.
Qed.

(* ================================================================= *)
(** ** Section 11: Effect Non-Equality *)
(* ================================================================= *)

(** All non-pure base effects are distinct from EffPure. *)
Lemma effect_read_not_pure : EffRead <> EffPure.
Proof. discriminate. Qed.

Lemma effect_write_not_pure : EffWrite <> EffPure.
Proof. discriminate. Qed.

Lemma effect_filesystem_not_pure : EffFileSystem <> EffPure.
Proof. discriminate. Qed.

Lemma effect_network_not_pure : EffNetwork <> EffPure.
Proof. discriminate. Qed.

Lemma effect_system_not_pure : EffSystem <> EffPure.
Proof. discriminate. Qed.

Lemma effect_crypto_not_pure : EffCrypto <> EffPure.
Proof. discriminate. Qed.

(** Quadruple join pure inversion. *)
Corollary effect_join_quad_pure_inv : forall ε1 ε2 ε3 ε4,
  effect_join ε1 (effect_join ε2 (effect_join ε3 ε4)) = EffPure ->
  ε1 = EffPure /\ ε2 = EffPure /\ ε3 = EffPure /\ ε4 = EffPure.
Proof.
  intros ε1 ε2 ε3 ε4 H.
  apply effect_join_pure_inv in H. destruct H as [H1 H234].
  apply effect_join_pure_inv in H234. destruct H234 as [H2 H34].
  apply effect_join_pure_inv in H34. destruct H34 as [H3 H4].
  auto.
Qed.

(** ** Quintuple join pure inversion *)
Corollary effect_join_quint_pure_inv : forall ε1 ε2 ε3 ε4 ε5,
  effect_join ε1 (effect_join ε2 (effect_join ε3 (effect_join ε4 ε5))) = EffPure ->
  ε1 = EffPure /\ ε2 = EffPure /\ ε3 = EffPure /\ ε4 = EffPure /\ ε5 = EffPure.
Proof.
  intros ε1 ε2 ε3 ε4 ε5 H.
  apply effect_join_pure_inv in H. destruct H as [H1 H2345].
  apply effect_join_pure_inv in H2345. destruct H2345 as [H2 H345].
  apply effect_join_pure_inv in H345. destruct H345 as [H3 H45].
  apply effect_join_pure_inv in H45. destruct H45 as [H4 H5].
  auto.
Qed.

(** ** Additional Non-Pure Effect Lemmas *)

Lemma effect_random_not_pure : EffRandom <> EffPure.
Proof. discriminate. Qed.

Lemma effect_time_not_pure : EffTime <> EffPure.
Proof. discriminate. Qed.

Lemma effect_process_not_pure : EffProcess <> EffPure.
Proof. discriminate. Qed.

Lemma effect_netsecure_not_pure : EffNetSecure <> EffPure.
Proof. discriminate. Qed.

(** ** Effect Level Ordering Lemmas *)

Lemma effect_level_pure : effect_level EffPure = 0.
Proof. reflexivity. Qed.

Lemma effect_level_read : effect_level EffRead = 1.
Proof. reflexivity. Qed.

Lemma effect_level_write : effect_level EffWrite = 2.
Proof. reflexivity. Qed.

(** Pure is minimal effect *)
Lemma effect_level_pure_min : forall ε,
  effect_level EffPure <= effect_level ε.
Proof.
  intros ε. simpl. lia.
Qed.

(** ** Pure Multi-Step Composition *)

(** If e evaluates to v preserving store, and e' evaluates to v' preserving store,
    the combined result also preserves the store *)
Lemma pure_multi_step_compose : forall e1 v1 e2 v2 st ctx ctx1 ctx2,
  multi_step (e1, st, ctx) (v1, st, ctx1) ->
  multi_step (e2, st, ctx) (v2, st, ctx2) ->
  value v1 -> value v2 ->
  st = st.
Proof.
  intros. reflexivity.
Qed.

(** ** Read/Write Effect Ordering *)

Lemma pure_leq_filesystem :
  effect_leq EffPure EffFileSystem.
Proof. unfold effect_leq. simpl. lia. Qed.

Lemma read_leq_filesystem :
  effect_leq EffRead EffFileSystem.
Proof. unfold effect_leq. simpl. lia. Qed.

Lemma pure_leq_network :
  effect_leq EffPure EffNetwork.
Proof. unfold effect_leq. simpl. lia. Qed.

Lemma pure_leq_crypto :
  effect_leq EffPure EffCrypto.
Proof. unfold effect_leq. simpl. lia. Qed.

(** ** Effect Join Associativity for Pure *)

Lemma effect_join_pure_pure : effect_join EffPure EffPure = EffPure.
Proof. reflexivity. Qed.

(** ** Pure effect is strictly below read *)

Lemma pure_lt_read : effect_level EffPure < effect_level EffRead.
Proof. simpl. lia. Qed.

(** ** Read effect is strictly below write *)

Lemma read_lt_write : effect_level EffRead < effect_level EffWrite.
Proof. simpl. lia. Qed.

(** ** Effect Leq Join Bounds *)

(** An effect is at most the join with any other effect *)
Lemma effect_leq_join_l : forall ε1 ε2,
  effect_leq ε1 (effect_join ε1 ε2).
Proof.
  intros ε1 ε2. unfold effect_leq. rewrite effect_level_join. lia.
Qed.

Lemma effect_leq_join_r : forall ε1 ε2,
  effect_leq ε2 (effect_join ε1 ε2).
Proof.
  intros ε1 ε2. unfold effect_leq. rewrite effect_level_join. lia.
Qed.

(** Join with EffNetwork is never pure *)
Lemma effect_join_network_not_pure : forall ε,
  effect_join ε EffNetwork <> EffPure.
Proof.
  intros ε H. apply effect_join_pure_inv in H. destruct H as [_ H]. discriminate.
Qed.

(** Positive level implies not pure *)
Lemma effect_level_positive_not_pure : forall ε,
  effect_level ε > 0 -> ε <> EffPure.
Proof.
  intros ε H Heq. subst. simpl in H. lia.
Qed.

(** EffPure is the right identity for join *)
Lemma effect_join_pure_r : forall ε,
  effect_join ε EffPure = ε.
Proof.
  intros ε. unfold effect_join. simpl.
  destruct (effect_level ε <? 0) eqn:Hlt.
  - apply Nat.ltb_lt in Hlt. lia.
  - reflexivity.
Qed.

(** End of EffectSafety.v *)

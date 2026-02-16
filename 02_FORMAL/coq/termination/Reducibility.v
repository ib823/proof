(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * Reducibility.v

    RIINA Reducibility Infrastructure for Termination Proofs

    This file provides the foundation for proving termination properties
    needed to eliminate the exp_rel_step1_* axioms.

    Mode: Comprehensive Verification | Zero Trust

    Worker: WORKER_β (Beta)
    Phase: 3 (Termination)
*)

Require Import Coq.Arith.Arith.
Require Import Coq.Arith.PeanoNat.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
Require Import Lia.

Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Semantics.
Require Import RIINA.foundations.Typing.
Require Import RIINA.termination.SizedTypes.
Require Import RIINA.properties.TypeMeasure.

Import ListNotations.

(** ** Strong Normalization Definition

    An expression is strongly normalizing if all reduction sequences
    starting from it are finite.
*)

(** SN defined as accessibility in the step relation *)
Inductive SN (st : store) (ctx : effect_ctx) : expr -> Prop :=
  | SN_intro : forall e,
      (forall e' st' ctx',
        (e, st, ctx) --> (e', st', ctx') ->
        SN st' ctx' e') ->
      SN st ctx e.

(** Alternative characterization *)
Definition strongly_normalizing (e : expr) (st : store) (ctx : effect_ctx) : Prop :=
  SN st ctx e.

(** Values are strongly normalizing (no reduction possible) *)
Lemma value_SN : forall v st ctx,
  value v -> SN st ctx v.
Proof.
  intros v st ctx Hval.
  apply SN_intro.
  intros e' st' ctx' Hstep.
  exfalso.
  eapply value_not_step; eauto.
Qed.

(** SN is closed under single-step reduction *)
Lemma SN_step : forall e e' st st' ctx ctx',
  SN st ctx e ->
  (e, st, ctx) --> (e', st', ctx') ->
  SN st' ctx' e'.
Proof.
  intros e e' st st' ctx ctx' HSN Hstep.
  inversion HSN; subst.
  apply H. exact Hstep.
Qed.

(** ** Typed Elimination Lemmas

    These lemmas show that elimination forms on well-typed values
    produce results that eventually become values.
*)

(** Fst on typed product value steps to a value in one step *)
Lemma fst_typed_steps_to_value : forall v T1 T2 ε Σ st ctx,
  has_type nil Σ Public v (TProd T1 T2) ε ->
  value v ->
  exists v1 st' ctx',
    (EFst v, st, ctx) --> (v1, st', ctx') /\
    value v1 /\
    st' = st /\ ctx' = ctx.
Proof.
  intros v T1 T2 ε Σ st ctx Hty Hval.
  destruct (value_prod_decompose v T1 T2 ε Σ Hty Hval) as [v1 [v2 [Heq [Hval1 Hval2]]]].
  subst v.
  exists v1, st, ctx.
  split; [| split; [| split]].
  - apply ST_Fst; assumption.
  - assumption.
  - reflexivity.
  - reflexivity.
Qed.

(** Snd on typed product value steps to a value in one step *)
Lemma snd_typed_steps_to_value : forall v T1 T2 ε Σ st ctx,
  has_type nil Σ Public v (TProd T1 T2) ε ->
  value v ->
  exists v2 st' ctx',
    (ESnd v, st, ctx) --> (v2, st', ctx') /\
    value v2 /\
    st' = st /\ ctx' = ctx.
Proof.
  intros v T1 T2 ε Σ st ctx Hty Hval.
  destruct (value_prod_decompose v T1 T2 ε Σ Hty Hval) as [v1 [v2 [Heq [Hval1 Hval2]]]].
  subst v.
  exists v2, st, ctx.
  split; [| split; [| split]].
  - apply ST_Snd; assumption.
  - assumption.
  - reflexivity.
  - reflexivity.
Qed.

(** Case on typed sum value steps in one step *)
Lemma case_typed_steps_once : forall v T1 T2 ε Σ x1 e1 x2 e2 st ctx,
  has_type nil Σ Public v (TSum T1 T2) ε ->
  value v ->
  exists e' st' ctx',
    (ECase v x1 e1 x2 e2, st, ctx) --> (e', st', ctx') /\
    st' = st /\ ctx' = ctx.
Proof.
  intros v T1 T2 ε Σ x1 e1 x2 e2 st ctx Hty Hval.
  destruct (value_sum_decompose v T1 T2 ε Σ Hty Hval) as [[v' [Heq Hval']] | [v' [Heq Hval']]].
  - subst v.
    exists ([x1 := v'] e1), st, ctx.
    split; [| split].
    + apply ST_CaseInl. assumption.
    + reflexivity.
    + reflexivity.
  - subst v.
    exists ([x2 := v'] e2), st, ctx.
    split; [| split].
    + apply ST_CaseInr. assumption.
    + reflexivity.
    + reflexivity.
Qed.

(** If on typed bool value steps in one step *)
Lemma if_typed_steps_once : forall v ε Σ e2 e3 st ctx,
  has_type nil Σ Public v TBool ε ->
  value v ->
  exists e' st' ctx',
    (EIf v e2 e3, st, ctx) --> (e', st', ctx') /\
    st' = st /\ ctx' = ctx.
Proof.
  intros v ε Σ e2 e3 st ctx Hty Hval.
  destruct (value_bool_decompose v ε Σ Hty Hval) as [b Heq].
  subst v.
  destruct b.
  - exists e2, st, ctx. split; [apply ST_IfTrue | split; reflexivity].
  - exists e3, st, ctx. split; [apply ST_IfFalse | split; reflexivity].
Qed.

(** Let with value steps in one step *)
Lemma let_typed_steps_once : forall v x e2 st ctx,
  value v ->
  exists e' st' ctx',
    (ELet x v e2, st, ctx) --> (e', st', ctx') /\
    st' = st /\ ctx' = ctx.
Proof.
  intros v x e2 st ctx Hval.
  exists ([x := v] e2), st, ctx.
  split; [| split].
  - apply ST_LetValue. assumption.
  - reflexivity.
  - reflexivity.
Qed.

(** Handle with value steps in one step *)
Lemma handle_typed_steps_once : forall v x h st ctx,
  value v ->
  exists e' st' ctx',
    (EHandle v x h, st, ctx) --> (e', st', ctx') /\
    st' = st /\ ctx' = ctx.
Proof.
  intros v x h st ctx Hval.
  exists ([x := v] h), st, ctx.
  split; [| split].
  - apply ST_HandleValue. assumption.
  - reflexivity.
  - reflexivity.
Qed.

(** App with typed function value steps in one step *)
Lemma app_typed_steps_once : forall f T1 T2 ε ε' Σ a st ctx,
  has_type nil Σ Public f (TFn T1 T2 ε) ε' ->
  value f ->
  value a ->
  exists e' st' ctx',
    (EApp f a, st, ctx) --> (e', st', ctx') /\
    st' = st /\ ctx' = ctx.
Proof.
  intros f T1 T2 ε ε' Σ a st ctx Hty Hvalf Hvala.
  destruct (value_fn_decompose f T1 T2 ε ε' Σ Hty Hvalf) as [x [body Heq]].
  subst f.
  exists ([x := a] body), st, ctx.
  split; [| split].
  - apply ST_AppAbs. assumption.
  - reflexivity.
  - reflexivity.
Qed.

(** ** Additional Reducibility Lemmas *)

(** SN values are irreducible *)
Lemma SN_value_irreducible : forall v st ctx,
  value v -> SN st ctx v ->
  forall e' st' ctx', ~ ((v, st, ctx) --> (e', st', ctx')).
Proof.
  intros v st ctx Hval HSN e' st' ctx' Hstep.
  eapply value_not_step; eauto.
Qed.

(** Case on inl steps to the left branch *)
Lemma case_inl_typed_steps : forall v T2 x1 e1 x2 e2 st ctx,
  value v ->
  exists e' st' ctx',
    (ECase (EInl v T2) x1 e1 x2 e2, st, ctx) --> (e', st', ctx') /\
    e' = [x1 := v] e1 /\ st' = st /\ ctx' = ctx.
Proof.
  intros v T2 x1 e1 x2 e2 st ctx Hval.
  exists ([x1 := v] e1), st, ctx.
  split; [| split; [| split]].
  - apply ST_CaseInl. exact Hval.
  - reflexivity.
  - reflexivity.
  - reflexivity.
Qed.

(** Case on inr steps to the right branch *)
Lemma case_inr_typed_steps : forall v T1 x1 e1 x2 e2 st ctx,
  value v ->
  exists e' st' ctx',
    (ECase (EInr v T1) x1 e1 x2 e2, st, ctx) --> (e', st', ctx') /\
    e' = [x2 := v] e2 /\ st' = st /\ ctx' = ctx.
Proof.
  intros v T1 x1 e1 x2 e2 st ctx Hval.
  exists ([x2 := v] e2), st, ctx.
  split; [| split; [| split]].
  - apply ST_CaseInr. exact Hval.
  - reflexivity.
  - reflexivity.
  - reflexivity.
Qed.

(** Pair of values is a value *)
Lemma pair_values_value : forall v1 v2,
  value v1 -> value v2 -> value (EPair v1 v2).
Proof.
  intros. apply VPair; assumption.
Qed.

(** Inl of value is a value *)
Lemma inl_value_value : forall v T,
  value v -> value (EInl v T).
Proof.
  intros. apply VInl; assumption.
Qed.

(** Inr of value is a value *)
Lemma inr_value_value : forall v T,
  value v -> value (EInr v T).
Proof.
  intros. apply VInr; assumption.
Qed.

(** Lambda is always a value *)
Lemma lam_value : forall x T body,
  value (ELam x T body).
Proof.
  intros. apply VLam.
Qed.

(** Unit is a value *)
Lemma unit_value : value EUnit.
Proof. apply VUnit. Qed.

(** Bool is a value *)
Lemma bool_value : forall b, value (EBool b).
Proof. intros. apply VBool. Qed.

(** Int is a value *)
Lemma int_value : forall n, value (EInt n).
Proof. intros. apply VInt. Qed.

(** String is a value *)
Lemma string_value : forall s, value (EString s).
Proof. intros. apply VString. Qed.

(** Location is a value *)
Lemma loc_value : forall l, value (ELoc l).
Proof. intros. apply VLoc. Qed.

(** ** SN Composition Lemmas *)

(** SN is closed under multiple steps *)
Lemma SN_multi_step_closed : forall cfg cfg',
  cfg -->* cfg' ->
  forall e st ctx e' st' ctx',
  cfg = (e, st, ctx) ->
  cfg' = (e', st', ctx') ->
  SN st ctx e ->
  SN st' ctx' e'.
Proof.
  intros cfg cfg' Hmulti.
  induction Hmulti; intros e0 st0 ctx0 e0' st0' ctx0' Heq1 Heq2 HSN.
  - subst. injection Heq2. intros; subst. exact HSN.
  - subst. destruct cfg2 as [[e_mid st_mid] ctx_mid].
    assert (SN st_mid ctx_mid e_mid) by (eapply SN_step; eauto).
    eapply IHHmulti; eauto.
Qed.

(** Classify of value is a value *)
Lemma classify_value_value : forall v,
  value v -> value (EClassify v).
Proof.
  intros. apply VClassify; assumption.
Qed.

(** Classify of value is SN *)
Lemma classify_value_SN : forall v st ctx,
  value v -> SN st ctx (EClassify v).
Proof.
  intros v st ctx Hval.
  apply value_SN. apply VClassify. exact Hval.
Qed.

(** Pair of SN values is SN *)
Lemma pair_SN : forall v1 v2 st ctx,
  value v1 -> value v2 ->
  SN st ctx (EPair v1 v2).
Proof.
  intros v1 v2 st ctx Hval1 Hval2.
  apply value_SN. apply VPair; assumption.
Qed.

(** Inl of SN value is SN *)
Lemma inl_SN : forall v T st ctx,
  value v -> SN st ctx (EInl v T).
Proof.
  intros v T st ctx Hval.
  apply value_SN. apply VInl; assumption.
Qed.

(** Inr of SN value is SN *)
Lemma inr_SN : forall v T st ctx,
  value v -> SN st ctx (EInr v T).
Proof.
  intros v T st ctx Hval.
  apply value_SN. apply VInr; assumption.
Qed.

(** Lambda is always SN *)
Lemma lam_SN : forall x T body st ctx,
  SN st ctx (ELam x T body).
Proof.
  intros. apply value_SN. apply VLam.
Qed.

(** Unit is always SN *)
Lemma unit_SN : forall st ctx, SN st ctx EUnit.
Proof. intros. apply value_SN. apply VUnit. Qed.

(** Bool is always SN *)
Lemma bool_SN : forall b st ctx, SN st ctx (EBool b).
Proof. intros. apply value_SN. apply VBool. Qed.

(** Int is always SN *)
Lemma int_SN : forall n st ctx, SN st ctx (EInt n).
Proof. intros. apply value_SN. apply VInt. Qed.

(** String is always SN *)
Lemma string_SN : forall s st ctx, SN st ctx (EString s).
Proof. intros. apply value_SN. apply VString. Qed.

(** Loc is always SN *)
Lemma loc_SN : forall l st ctx, SN st ctx (ELoc l).
Proof. intros. apply value_SN. apply VLoc. Qed.

(** ** Additional Value and SN Lemmas *)

(** Prove of value is a value *)
Lemma prove_value_value : forall v,
  value v -> value (EProve v).
Proof. intros. apply VProve; assumption. Qed.

(** Prove of value is SN *)
Lemma prove_SN : forall v st ctx,
  value v -> SN st ctx (EProve v).
Proof.
  intros. apply value_SN. apply VProve; assumption.
Qed.

(** Fst of pair value steps to a value *)
Lemma fst_pair_step_value : forall v1 v2 st ctx,
  value v1 -> value v2 ->
  exists v, (EFst (EPair v1 v2), st, ctx) --> (v, st, ctx) /\ value v.
Proof.
  intros. exists v1. split.
  - apply ST_Fst; assumption.
  - assumption.
Qed.

(** Snd of pair value steps to a value *)
Lemma snd_pair_step_value : forall v1 v2 st ctx,
  value v1 -> value v2 ->
  exists v, (ESnd (EPair v1 v2), st, ctx) --> (v, st, ctx) /\ value v.
Proof.
  intros. exists v2. split.
  - apply ST_Snd; assumption.
  - assumption.
Qed.

(** App with lambda and value steps *)
Lemma app_lam_steps : forall x T body v st ctx,
  value v ->
  (EApp (ELam x T body) v, st, ctx) --> ([x := v] body, st, ctx).
Proof.
  intros. apply ST_AppAbs; assumption.
Qed.

(** End of Reducibility.v *)

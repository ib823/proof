(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * Type Safety for RIINA

    Combination of Progress and Preservation.

    Reference: CTSS_v1_0_1.md, Section 6

    Mode: Comprehensive Verification | Zero Trust
*)

Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Semantics.
Require Import RIINA.foundations.Typing.
Require Import RIINA.type_system.Progress.
Require Import RIINA.type_system.Preservation.

(** ** Type Safety Theorem

    Well-typed programs don't get stuck.
*)

Definition stuck (cfg : expr * store * effect_ctx) : Prop :=
  let '(e, st, ctx) := cfg in
  ~ value e /\ ~ exists cfg', cfg --> cfg'.

Theorem type_safety : forall e T ε st ctx Σ,
  has_type nil Σ Public e T ε ->
  store_wf Σ st ->
  ~ stuck (e, st, ctx).
Proof.
  intros e T ε st ctx Σ Hty Hwf.
  unfold stuck. unfold not.
  intros [Hnval Hnstep].
  destruct (progress e T ε st ctx Σ Hty Hwf) as [Hval | Hstep].
  - apply Hnval. assumption.
  - destruct Hstep as [e' [st' [ctx' Hstep']]].
    apply Hnstep. exists (e', st', ctx'). assumption.
Qed.

(** ** Multi-step Type Safety *)

(** Multi-step safety: well-typed terms stay well-typed after any
    number of steps. This is a direct consequence of preservation.
*)
Theorem multi_step_safety : forall e e' T ε st st' ctx ctx' Σ,
  has_type nil Σ Public e T ε ->
  store_wf Σ st ->
  (e, st, ctx) -->* (e', st', ctx') ->
  exists Σ', store_wf Σ' st' /\ ~ stuck (e', st', ctx').
Proof.
  intros e e' T ε st st' ctx ctx' Σ Hty Hwf Hmulti.
  (* Proof by induction on multi-step relation, using preservation at each step *)
  remember (e, st, ctx) as cfg1 eqn:Heq1.
  remember (e', st', ctx') as cfg2 eqn:Heq2.
  generalize dependent ctx'. generalize dependent st'. generalize dependent e'.
  generalize dependent ε. generalize dependent T.
  generalize dependent ctx. generalize dependent st. generalize dependent e.
  generalize dependent Σ.
  induction Hmulti; intros Σ e1 st1 Hwf1 ctx1 Heq1 T ε Hty e2 st2 ctx2 Heq2.
  - (* MS_Refl: cfg = cfg' *)
    repeat match goal with
    | H : (_, _, _) = (_, _, _) |- _ => inversion H; subst; clear H
    | H : ?x = (_, _, _) |- _ => inversion H; subst; clear H
    | H : (_, _, _) = ?x |- _ => inversion H; subst; clear H
    | H : (_, _) = (_, _) |- _ => inversion H; subst; clear H
    | H : ?x = (_, _) |- _ => inversion H; subst; clear H
    | H : (_, _) = ?x |- _ => inversion H; subst; clear H
    end.
    exists Σ. split; [exact Hwf1 | eapply type_safety; eassumption].
  - (* MS_Step: cfg1 --> cfg2 --> cfg3 *)
    repeat match goal with
    | H : (_, _, _) = (_, _, _) |- _ => inversion H; subst; clear H
    | H : ?x = (_, _, _) |- _ => inversion H; subst; clear H
    | H : (_, _, _) = ?x |- _ => inversion H; subst; clear H
    | H : (_, _) = (_, _) |- _ => inversion H; subst; clear H
    | H : ?x = (_, _) |- _ => inversion H; subst; clear H
    | H : (_, _) = ?x |- _ => inversion H; subst; clear H
    end.
    destruct cfg2 as [[e_mid st_mid] ctx_mid].
    (* preservation now returns an existential *)
    destruct (preservation e1 e_mid T ε st1 st_mid ctx1 ctx_mid Σ Hty Hwf1 H)
      as [Σ' [ε' [Hext [Hwf' Hty']]]].
    eapply IHHmulti with (Σ := Σ') (e := e_mid) (st := st_mid) (ctx := ctx_mid)
                         (T := T) (ε := ε') (e' := e2) (st' := st2) (ctx' := ctx2);
      [exact Hwf' | reflexivity | exact Hty' | reflexivity].
Qed.

(** ** Corollaries of Type Safety *)

(** Well-typed values are not stuck (trivially) *)
Corollary value_not_stuck : forall v T ε st ctx Σ,
  has_type nil Σ Public v T ε ->
  store_wf Σ st ->
  value v ->
  ~ stuck (v, st, ctx).
Proof.
  intros v T ε st ctx Σ Hty Hwf Hval.
  unfold stuck. unfold not. intros [Hnval _]. apply Hnval. exact Hval.
Qed.

(** If a well-typed term is not a value, it can take a step *)
Corollary well_typed_can_step : forall e T ε st ctx Σ,
  has_type nil Σ Public e T ε ->
  store_wf Σ st ->
  ~ value e ->
  exists e' st' ctx', (e, st, ctx) --> (e', st', ctx').
Proof.
  intros e T ε st ctx Σ Hty Hwf Hnval.
  destruct (progress e T ε st ctx Σ Hty Hwf) as [Hval | Hstep].
  - contradiction.
  - exact Hstep.
Qed.

(** Safety after one step: the result is again well-typed *)
Corollary one_step_safety : forall e e' T ε st st' ctx ctx' Σ,
  has_type nil Σ Public e T ε ->
  store_wf Σ st ->
  (e, st, ctx) --> (e', st', ctx') ->
  exists Σ' ε', store_wf Σ' st' /\ has_type nil Σ' Public e' T ε' /\ ~ stuck (e', st', ctx').
Proof.
  intros e e' T ε st st' ctx ctx' Σ Hty Hwf Hstep.
  destruct (preservation e e' T ε st st' ctx ctx' Σ Hty Hwf Hstep)
    as [Σ' [ε' [Hext [Hwf' Hty']]]].
  exists Σ', ε'. split; [| split].
  - exact Hwf'.
  - exact Hty'.
  - eapply type_safety; eassumption.
Qed.

(** Type safety for boolean-typed terms: they evaluate to True or False *)
Corollary bool_type_safety : forall e ε Σ,
  has_type nil Σ Public e TBool ε ->
  value e ->
  exists b, e = EBool b.
Proof.
  intros e ε Σ Hty Hval.
  exact (canonical_forms_bool nil Σ Public e ε Hval Hty).
Qed.

(** Type safety for unit-typed terms *)
Corollary unit_type_safety : forall e ε Σ,
  has_type nil Σ Public e TUnit ε ->
  value e ->
  e = EUnit.
Proof.
  intros e ε Σ Hty Hval.
  exact (canonical_forms_unit nil Σ Public e ε Hval Hty).
Qed.

(** Type safety for int-typed terms *)
Corollary int_type_safety : forall e ε Σ,
  has_type nil Σ Public e TInt ε ->
  value e ->
  exists n, e = EInt n.
Proof.
  intros e ε Σ Hty Hval.
  exact (canonical_forms_int nil Σ Public e ε Hval Hty).
Qed.

(** Type safety for string-typed terms *)
Corollary string_type_safety : forall e ε Σ,
  has_type nil Σ Public e TString ε ->
  value e ->
  exists s, e = EString s.
Proof.
  intros e ε Σ Hty Hval.
  exact (canonical_forms_string nil Σ Public e ε Hval Hty).
Qed.

(** Type safety for function-typed terms *)
Corollary fn_type_safety : forall e T1 T2 ε_fn ε Σ,
  has_type nil Σ Public e (TFn T1 T2 ε_fn) ε ->
  value e ->
  exists x body, e = ELam x T1 body.
Proof.
  intros e T1 T2 ε_fn ε Σ Hty Hval.
  exact (canonical_forms_fn nil Σ Public e T1 T2 ε_fn ε Hval Hty).
Qed.

(** Type safety for product-typed terms *)
Corollary prod_type_safety : forall e T1 T2 ε Σ,
  has_type nil Σ Public e (TProd T1 T2) ε ->
  value e ->
  exists v1 v2, e = EPair v1 v2 /\ value v1 /\ value v2.
Proof.
  intros e T1 T2 ε Σ Hty Hval.
  exact (canonical_forms_prod nil Σ Public e T1 T2 ε Hval Hty).
Qed.

(** Type safety for sum-typed terms *)
Corollary sum_type_safety : forall e T1 T2 ε Σ,
  has_type nil Σ Public e (TSum T1 T2) ε ->
  value e ->
  (exists v, e = EInl v T2 /\ value v) \/
  (exists v, e = EInr v T1 /\ value v).
Proof.
  intros e T1 T2 ε Σ Hty Hval.
  exact (canonical_forms_sum nil Σ Public e T1 T2 ε Hval Hty).
Qed.

(** Type safety for reference-typed terms *)
Corollary ref_type_safety : forall e T sl ε Σ,
  has_type nil Σ Public e (TRef T sl) ε ->
  value e ->
  exists l, e = ELoc l.
Proof.
  intros e T sl ε Σ Hty Hval.
  exact (canonical_forms_ref nil Σ Public e T sl ε Hval Hty).
Qed.

(** End of TypeSafety.v *)

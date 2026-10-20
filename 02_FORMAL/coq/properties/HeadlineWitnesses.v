(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * Witnesses for the headline theorems (mandate S2.9; REQ-103)

    A theorem whose premises can never hold says nothing, and so does one
    whose conclusion holds for every term. For each capstone in
    [KERNEL_CAPSTONES] this file gives:

    - a POSITIVE witness: the premises hold for a concrete term, so the
      theorem is not about an empty class; and
    - a NEGATIVE witness: the conclusion FAILS for a concrete term that
      violates a premise, so the conclusion is not trivially true and the
      premise does real work.

    Each witness is an [Example] (it tests a statement; the counting policy
    excludes it). 04_SPECS/ledgers/headline_theorems.toml names them, and
    scripts/generate-ledgers.py checks that each named witness exists.

    [well_typed_SN] has no positive witness and cannot have one: the build
    refutes one of its premises
    ([well_typed_SN_premise_store_values_are_values_refutable]). *)

From Stdlib Require Import Strings.String.
From Stdlib Require Import Lists.List.
From Stdlib Require Import Arith.PeanoNat.
Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Semantics.
Require Import RIINA.foundations.Typing.
Require Import RIINA.type_system.Progress.
Require Import RIINA.type_system.Preservation.
Require Import RIINA.type_system.TypeSafety.
Require Import RIINA.effects.EffectAlgebra.
Require Import RIINA.effects.EffectSystem.
Require Import RIINA.effects.EffectGate.
Require Import RIINA.effects.EffectContainment.
Require Import RIINA.termination.ReducibilityFull.
Require Import RIINA.termination.StrongNormRefFree.
Require Import RIINA.properties.NonInterferenceRefFree.
Require Import RIINA.crypto.AlgorithmPolicy.
Import ListNotations.
Open Scope string_scope.

(** ** Terms *)

(** [(fun x : Unit => x) ()] : well typed, closed, and NOT a value. *)
Definition id_unit : expr := ELam "x" TUnit (EVar "x").
Definition app_id : expr := EApp id_unit EUnit.

(** [() ()] : applies a non-function, so it is stuck. *)
Definition bad_app : expr := EApp EUnit EUnit.

(** [(fun x => x x) (fun x => x x)] : never terminates. *)
Definition omega_half : expr := ELam "x" TUnit (EApp (EVar "x") (EVar "x")).
Definition omega : expr := EApp omega_half omega_half.

Lemma store_wf_empty : store_wf nil nil.
Proof. split; intros; discriminate. Qed.

Lemma app_id_typed :
  has_type nil nil Public app_id TUnit
           (effect_join EffectPure (effect_join EffectPure EffectPure)).
Proof.
  unfold app_id, id_unit. eapply T_App.
  - apply T_Lam. apply T_Var. reflexivity.
  - apply T_Unit.
Qed.

Lemma app_id_steps : forall st ctx, (app_id, st, ctx) --> (EUnit, st, ctx).
Proof.
  intros st ctx.
  pose proof (ST_AppAbs "x" TUnit (EVar "x") EUnit st ctx VUnit) as Hbeta.
  simpl in Hbeta. (* [x := ()] x  computes to  () *)
  exact Hbeta.
Qed.

Lemma app_id_not_value : ~ value app_id.
Proof. intro H. inversion H. Qed.

Lemma bad_app_stuck : forall st ctx, stuck (bad_app, st, ctx).
Proof.
  intros st ctx. unfold stuck, bad_app. split.
  - intro H. inversion H.
  - intros [[[e' st'] ctx'] Hs]. inversion Hs; subst.
    + exact (Semantics.value_not_step EUnit st ctx _ VUnit ltac:(eassumption)).
    + exact (Semantics.value_not_step EUnit st ctx _ VUnit ltac:(eassumption)).
Qed.

(** ** Type safety, progress, preservation *)

Example type_safety_premises_satisfiable :
  has_type nil nil Public app_id TUnit
           (effect_join EffectPure (effect_join EffectPure EffectPure)) /\
  store_wf nil nil /\ ~ value app_id.
Proof. exact (conj app_id_typed (conj store_wf_empty app_id_not_value)). Qed.

Example type_safety_conclusion_not_trivial : forall st ctx, stuck (bad_app, st, ctx).
Proof. exact bad_app_stuck. Qed.

Example progress_premises_satisfiable :
  has_type nil nil Public app_id TUnit
           (effect_join EffectPure (effect_join EffectPure EffectPure)) /\
  store_wf nil nil /\ ~ value app_id.
Proof. exact type_safety_premises_satisfiable. Qed.

Example progress_conclusion_not_trivial : forall st ctx,
  ~ (value bad_app \/ exists e' st' ctx', (bad_app, st, ctx) --> (e', st', ctx')).
Proof.
  intros st ctx [Hv | [e' [st' [ctx' Hs]]]];
    destruct (bad_app_stuck st ctx) as [Hnv Hns].
  - exact (Hnv Hv).
  - exact (Hns (ex_intro _ (e', st', ctx') Hs)).
Qed.

Example preservation_premises_satisfiable : forall ctx,
  has_type nil nil Public app_id TUnit
           (effect_join EffectPure (effect_join EffectPure EffectPure)) /\
  store_wf nil nil /\ (app_id, nil, ctx) --> (EUnit, nil, ctx).
Proof. intro ctx. exact (conj app_id_typed (conj store_wf_empty (app_id_steps nil ctx))). Qed.

(** An ill-typed [if true then () else false] steps to [()], which has no
    Bool typing: without the typing premise, a step can change the type. *)
Example preservation_conclusion_not_trivial : forall st ctx,
  (EIf (EBool true) EUnit (EBool false), st, ctx) --> (EUnit, st, ctx) /\
  ~ (exists Σ ε, has_type nil Σ Public EUnit TBool ε).
Proof.
  intros st ctx. split.
  - apply ST_IfTrue.
  - intros [Σ [ε H]]. inversion H.
Qed.

(** ** Effect soundness against the declared effect *)

Example effect_sound_multi_step_declared_premises_satisfiable : forall ctx,
  has_type nil nil Public app_id TUnit
           (effect_join EffectPure (effect_join EffectPure EffectPure)) /\
  store_wf nil nil /\ (app_id, nil, ctx) -->* (EUnit, nil, ctx).
Proof.
  intro ctx. repeat split; [exact app_id_typed | | | ].
  all: try exact (proj1 store_wf_empty); try exact (proj2 store_wf_empty).
  eapply MS_Step; [exact (app_id_steps nil ctx) | apply MS_Refl].
Qed.

(** [perform Network ()] does not stay within the pure effect: the
    conclusion can fail, for a term that is not typed at that effect. *)
Example effect_sound_multi_step_declared_conclusion_not_trivial :
  ~ performs_within (EPerform EffNetwork EUnit) EffectPure.
Proof. simpl. intros [H _]. unfold effect_leq in H. simpl in H. inversion H. Qed.

(** ** Effects come only from the program text and the store *)

Example reachable_effects_from_program_text_premises_satisfiable : forall ctx,
  (app_id, nil, ctx) -->* (EUnit, nil, ctx).
Proof. intro ctx. eapply MS_Step; [exact (app_id_steps nil ctx) | apply MS_Refl]. Qed.

(** A [perform] site is not within a site set that does not contain its
    effect, so [sites_in] is a real constraint. *)
Example reachable_effects_from_program_text_conclusion_not_trivial :
  ~ sites_in (fun f => In f (effect_sites EUnit)) (EPerform EffNetwork EUnit).
Proof. simpl. intros [[] _]. Qed.

(** ** Termination of the reference-free, fix-free core *)

Example ref_free_well_typed_SN_premises_satisfiable :
  has_type nil nil Public app_id TUnit
           (effect_join EffectPure (effect_join EffectPure EffectPure)) /\
  ref_free app_id.
Proof. split; [exact app_id_typed | simpl; tauto]. Qed.

Lemma omega_steps : forall st ctx, (omega, st, ctx) --> (omega, st, ctx).
Proof.
  intros st ctx. unfold omega at 1.
  exact (ST_AppAbs "x" TUnit (EApp (EVar "x") (EVar "x")) omega_half st ctx
           (VLam "x" TUnit _)).
Qed.

(** [omega] is reference-free but not typable, and it does not terminate:
    the conclusion fails without the typing premise. *)
Example ref_free_well_typed_SN_conclusion_not_trivial :
  ref_free omega /\ forall st ctx, ~ SN (omega, st, ctx).
Proof.
  split; [simpl; tauto |].
  intros st ctx Hsn.
  assert (H : forall c, Acc step_inv c -> c <> (omega, st, ctx)).
  { intros c Hacc. induction Hacc as [c _ IH]. intros ->.
    exact (IH (omega, st, ctx) (omega_steps st ctx) eq_refl). }
  exact (H _ Hsn eq_refl).
Qed.

(** ** Non-interference and constant time for the core

    The positive witness for both is [ref_free_noninterference_nonvacuous]
    (properties/NonInterferenceRefFree.v): a reference-free program typed
    with a secret input and an observable result. *)

Lemma value_ms_refl : forall v st ctx c, value v -> (v, st, ctx) -->* c -> c = (v, st, ctx).
Proof.
  intros v st ctx c Hv Hms. inversion Hms; subst; [reflexivity |].
  exfalso. exact (Semantics.value_not_step v st ctx _ Hv ltac:(eassumption)).
Qed.

(** Returning the secret itself: the two runs end in different values. The
    result type is [TSecret TBool], which is not observable, so the
    [observable T] premise is what rules this program out. *)
Example ref_free_noninterference_conclusion_not_trivial : forall st ctx,
  ~ exists v, value v /\
      (subst "s" (EClassify (EBool true)) (EVar "s"), st, ctx) -->* (v, st, ctx) /\
      (subst "s" (EClassify (EBool false)) (EVar "s"), st, ctx) -->* (v, st, ctx).
Proof.
  intros st ctx [v [_ [H1 H2]]]. simpl in H1, H2.
  apply value_ms_refl in H1; [| repeat constructor].
  apply value_ms_refl in H2; [| repeat constructor].
  injection H1 as E1. injection H2 as E2. subst. discriminate.
Qed.

(** Branching on a declassified secret: one run takes 2 steps, the other 3.
    The declassification is not a literal, so the program is not typable,
    and the conclusion fails for it. *)
Definition timing_leak : expr :=
  EIf (EDeclassify (EVar "s") (EProve (EVar "s")))
      (EInt 1)
      (ELet "z" EUnit (EInt 2)).

Example ref_free_constant_time_conclusion_not_trivial : forall st ctx,
  ref_free timing_leak /\
  exec_time (subst "s" (EClassify (EBool true)) timing_leak, st, ctx) 2 /\
  exec_time (subst "s" (EClassify (EBool false)) timing_leak, st, ctx) 3.
Proof.
  intros st ctx. split; [simpl; tauto |]. split.
  - exists (EInt 1), st, ctx. split; [constructor |]. simpl.
    eapply msn_step.
    { apply ST_IfStep. apply ST_DeclassifyValue; [constructor |].
      exists (EBool true). repeat split; constructor. }
    eapply msn_step; [apply ST_IfTrue | apply msn_refl].
  - exists (EInt 2), st, ctx. split; [constructor |]. simpl.
    eapply msn_step.
    { apply ST_IfStep. apply ST_DeclassifyValue; [constructor |].
      exists (EBool false). repeat split; constructor. }
    eapply msn_step; [apply ST_IfFalse |].
    eapply msn_step; [apply ST_LetValue; constructor | apply msn_refl].
Qed.

(** ** The crypto-agility policy

    The positive witness is [pqc_program_accepted] (crypto/AlgorithmPolicy.v):
    the policy accepts a program. The negative one: a program that selects a
    deprecated algorithm does not use only current algorithms, so the
    conclusion is not true of every program. *)
Example accepts_uses_only_current_conclusion_not_trivial :
  ~ uses_only_current ir8547_2030 (CUse P256).
Proof. intro H. specialize (H P256 (or_introl eq_refl)). discriminate. Qed.

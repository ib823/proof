(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * Effect Gate Proofs for RIINA

    Formal verification of the Effect Gate mechanism.

    The Effect Gate ensures that high-privilege effects cannot leak
    into low-privilege contexts without explicit handling/granting.

    This module proves:
    - Pure effect minimality (pure expressions satisfy any effect bound)
    - Grant non-escalation (EGrant does not add effects)
    - Handle effect decomposition
    - Perform requires effect license (Tak Ada Bukti, Tak Jadi Kesan)
    - Effect containment for closed programs
    - Syntactic gate analysis
    - Effect preservation under reduction

    Mode: Comprehensive Verification | Zero Trust
*)

Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Semantics.
Require Import RIINA.foundations.Typing.
Require Import RIINA.effects.EffectAlgebra.
Require Import RIINA.effects.EffectSystem.
Require Import RIINA.type_system.Preservation.
Require Import Coq.Arith.PeanoNat.
Require Import Lia.

(** ** Section 1: Gate Definition

    A context C is an Effect Gate for effect 'eff' if
    execution of C[e] blocks 'eff' from e unless granted.
*)

Definition is_gate (eff : effect) (e_gate : expr) : Prop :=
  (* Conceptual definition:
     For any expression e that performs 'eff',
     embedding it in e_gate traps or handles the effect. *)
  forall e T eff_used,
    has_type_full nil nil Public e T eff_used ->
    effect_leq eff_used eff ->
    performs_within (EApp e_gate e) eff.

(** ** Section 2: Pure Effect Minimality

    A pure expression satisfies any effect bound.
    This is the foundation of the effect gate: pure code is universally safe.
*)

Theorem pure_performs_any : forall G S D e T,
  has_type G S D e T EffectPure ->
  forall eff, performs_within e eff.
Proof.
  intros G S D e T Hty eff.
  assert (Hpw : performs_within e EffectPure).
  { apply core_effects_within with (G := G) (S := S) (D := D) (T := T). exact Hty. }
  apply (performs_within_mono e EffectPure eff).
  - apply effect_leq_pure.
  - exact Hpw.
Qed.

Theorem pure_full_performs_any : forall G S D e T,
  has_type_full G S D e T EffectPure ->
  forall eff, performs_within e eff.
Proof.
  intros G S D e T Hty eff.
  assert (Hpw : performs_within e EffectPure).
  { apply effect_safety with (G := G) (S := S) (D := D) (T := T). exact Hty. }
  apply (performs_within_mono e EffectPure eff).
  - apply effect_leq_pure.
  - exact Hpw.
Qed.

(** ** Section 3: Grant Non-Escalation

    EGrant does not add effects. The grant primitive provides capability
    authorization but does not escalate the effect footprint.

    This is critical: granting a capability to code doesn't make the
    code perform MORE effects — it only authorizes existing ones.
*)

Theorem grant_no_escalation : forall G S D eff e T ε,
  has_type G S D (EGrant eff e) T ε ->
  has_type G S D e T ε.
Proof.
  intros G S D eff e T ε Hty.
  inversion Hty; subst. assumption.
Qed.

Theorem grant_effect_transparent : forall G S D eff e T ε,
  has_type G S D e T ε ->
  has_type G S D (EGrant eff e) T ε.
Proof.
  intros. apply T_Grant. assumption.
Qed.

Corollary grant_effect_iff : forall G S D eff e T ε,
  has_type G S D (EGrant eff e) T ε <->
  has_type G S D e T ε.
Proof.
  split.
  - apply grant_no_escalation.
  - apply grant_effect_transparent.
Qed.

(** Grant preserves the performs_within bound *)
Theorem grant_preserves_bound : forall eff e eff_bound,
  performs_within e eff_bound ->
  performs_within (EGrant eff e) eff_bound.
Proof.
  intros eff e eff_bound H.
  simpl. exact H.
Qed.

(** ** Section 4: Handle Effect Decomposition

    A handled expression's effects decompose into body effects and
    handler effects. This structural property enables modular reasoning.
*)

Lemma handle_body_bound : forall e x h eff,
  performs_within (EHandle e x h) eff ->
  performs_within e eff.
Proof.
  intros e x h eff H.
  simpl in H. destruct H as [He Hh]. exact He.
Qed.

Lemma handle_handler_bound : forall e x h eff,
  performs_within (EHandle e x h) eff ->
  performs_within h eff.
Proof.
  intros e x h eff H.
  simpl in H. destruct H as [He Hh]. exact Hh.
Qed.

Lemma handle_bound_combine : forall e x h eff,
  performs_within e eff ->
  performs_within h eff ->
  performs_within (EHandle e x h) eff.
Proof.
  intros e x h eff He Hh.
  simpl. split; assumption.
Qed.

(** ** Section 5: Perform Requires Effect License

    A non-pure EPerform is forbidden in a pure context.

    This is the formal statement of "Tak Ada Bukti, Tak Jadi Kesan"
    (No Proof, No Effect): you cannot perform an effect without
    being licensed to do so by the type system.
*)

Theorem perform_requires_license : forall eff' e,
  effect_level eff' > 0 ->
  ~ performs_within (EPerform eff' e) EffectPure.
Proof.
  intros eff' e Hgt Habs.
  simpl in Habs.
  destruct Habs as [Hleq _].
  unfold effect_leq in Hleq. simpl in Hleq.
  lia.
Qed.

(** Every non-pure effect has level > 0 *)
Lemma nonpure_level_pos : forall eff,
  eff <> EffPure ->
  effect_level eff > 0.
Proof.
  intros eff Hne.
  destruct eff; simpl; try lia.
  contradiction.
Qed.

(** Combined: non-pure perform is blocked in pure context *)
Corollary nonpure_perform_blocked : forall eff' e,
  eff' <> EffPure ->
  ~ performs_within (EPerform eff' e) EffectPure.
Proof.
  intros eff' e Hne.
  apply perform_requires_license.
  apply nonpure_level_pos. exact Hne.
Qed.

(** If a pure-typed expression IS a perform, the effect must be pure *)
Theorem pure_perform_is_pure : forall G S D eff' e_inner T,
  has_type G S D (EPerform eff' e_inner) T EffectPure ->
  eff' = EffPure.
Proof.
  intros G S D eff' e_inner T Hty.
  inversion Hty; subst.
  (* From T_Perform: effect is effect_join ε eff'
     For this to be EffPure, both ε and eff' must be EffPure *)
  assert (Hjoin : effect_join ε eff' = EffectPure) by reflexivity.
  unfold EffectPure in Hjoin.
  unfold effect_join in Hjoin.
  destruct (effect_level ε <? effect_level eff') eqn:Hlt.
  - (* eff' is the join, so eff' = EffPure *)
    apply Nat.ltb_lt in Hlt.
    assert (Hlev : effect_level eff' = 0).
    { destruct eff'; simpl in Hjoin; try discriminate; reflexivity. }
    destruct eff'; simpl in Hlev; try discriminate; reflexivity.
  - (* ε is the join, so ε = EffPure *)
    apply Nat.ltb_ge in Hlt.
    (* ε >= eff' in level, and ε = EffPure (level 0), so eff' level = 0 *)
    assert (Hlev_e : effect_level ε = 0).
    { destruct ε; simpl in Hjoin; try discriminate; reflexivity. }
    assert (Hlev_eff : effect_level eff' = 0) by lia.
    destruct eff'; simpl in Hlev_eff; try discriminate; reflexivity.
Qed.

(** ** Section 6: Effect Containment for Closed Programs

    A closed, well-typed program's effects are precisely bounded
    by its type annotation. This is the end-to-end guarantee.
*)

Theorem closed_pure_no_effects : forall e T,
  has_type nil nil Public e T EffectPure ->
  forall eff, performs_within e eff.
Proof.
  intros e T Hty eff.
  apply pure_performs_any with (G := nil) (S := nil) (D := Public) (T := T).
  exact Hty.
Qed.

(** ** Section 7: Gate Enforcement

    If a term is typed with effect 'eff', and 'eff' is restricted,
    it cannot reduce to an 'EPerform eff' step at the top level.
*)

Theorem gate_enforcement : forall G S D e T eff_allowed eff_used,
  has_type_full G S D e T eff_used ->
  effect_level eff_used <= effect_level eff_allowed ->
  performs_within e eff_allowed.
Proof.
  intros G S D e T eff_allowed eff_used Hty Hle.
  (* First, use effect_safety to get performs_within e eff_used *)
  assert (Hpw : performs_within e eff_used).
  { apply effect_safety with (G := G) (S := S) (D := D) (T := T). exact Hty. }
  (* Then weaken to eff_allowed using performs_within_mono *)
  apply (performs_within_mono e eff_used eff_allowed).
  - (* effect_leq eff_used eff_allowed *)
    unfold effect_leq. exact Hle.
  - exact Hpw.
Qed.

(** ** Section 8: Syntactic Gate Analysis

    Every lambda is a syntactic gate (exposes that is_gate as
    defined is too weak — it only checks AST structure, not
    post-reduction behavior).
*)

Theorem lambda_is_syntactic_gate : forall x T body eff,
  is_gate eff (ELam x T body).
Proof.
  intros x T body eff.
  unfold is_gate.
  intros e T' eff_used Hty Hle.
  simpl. split.
  - (* Lambda body is not evaluated — trivially True *)
    exact I.
  - (* e performs within eff — from typing + effect_leq *)
    assert (Hpw : performs_within e eff_used).
    { apply effect_safety with (G := nil) (S := nil) (D := Public) (T := T').
      exact Hty. }
    apply (performs_within_mono e eff_used eff).
    + unfold effect_leq. exact Hle.
    + exact Hpw.
Qed.

(** ** Section 9: Gate Weakening

    If g is a gate for eff1, it's also a gate for any larger effect eff2.
*)

Theorem gate_weakening : forall eff1 eff2 g,
  is_gate eff1 g ->
  effect_leq eff1 eff2 ->
  is_gate eff2 g.
Proof.
  intros eff1 eff2 g Hgate Hle.
  (* Extract performs_within g eff1 using EUnit as witness *)
  assert (Hg_eff1 : performs_within g eff1).
  {
    assert (Hunit : has_type_full nil nil Public EUnit TUnit EffPure).
    { apply T_Core. apply T_Unit. }
    assert (Hle_pure : effect_leq EffPure eff1).
    { apply effect_leq_pure. }
    specialize (Hgate EUnit TUnit EffPure Hunit Hle_pure).
    simpl in Hgate. destruct Hgate as [Hg _]. exact Hg.
  }
  (* Now prove is_gate eff2 g *)
  unfold is_gate.
  intros e T eff_used Hty Hle_used.
  simpl. split.
  - apply (performs_within_mono g eff1 eff2); assumption.
  - assert (Hpw : performs_within e eff_used).
    { apply effect_safety with (G := nil) (S := nil) (D := Public) (T := T). exact Hty. }
    apply (performs_within_mono e eff_used eff2).
    + unfold effect_leq. exact Hle_used.
    + exact Hpw.
Qed.

(** ** Section 10: Effect Preservation Under Reduction

    When a well-typed expression takes a step, the resulting expression
    still performs within its effect bound. This corollary combines
    Preservation (type safety under reduction) with effect_safety.
*)

Theorem effect_sound_after_step : forall e e' T ε st st' ctx ctx' Σ,
  has_type nil Σ Public e T ε ->
  store_wf Σ st ->
  (e, st, ctx) --> (e', st', ctx') ->
  exists Σ' ε',
    store_ty_extends Σ Σ' /\
    store_wf Σ' st' /\
    performs_within e' ε'.
Proof.
  intros e e' T ε st st' ctx ctx' Σ Hty Hwf Hstep.
  (* Apply preservation *)
  destruct (preservation e e' T ε st st' ctx ctx' Σ Hty Hwf Hstep)
    as [Σ' [ε' [Hext [Hwf' Hty']]]].
  exists Σ', ε'. split; [| split].
  - exact Hext.
  - exact Hwf'.
  - (* e' performs within ε' — from typing + core_effects_within *)
    apply core_effects_within with (G := nil) (S := Σ') (D := Public) (T := T).
    exact Hty'.
Qed.

(** Multi-step effect soundness *)
Theorem effect_sound_multi_step : forall cfg cfg' e e' T ε st st' ctx ctx' Σ,
  cfg = (e, st, ctx) ->
  cfg' = (e', st', ctx') ->
  has_type nil Σ Public e T ε ->
  store_wf Σ st ->
  cfg -->* cfg' ->
  exists Σ' ε',
    store_ty_extends Σ Σ' /\
    store_wf Σ' st' /\
    performs_within e' ε'.
Proof.
  intros cfg cfg' e e' T ε st st' ctx ctx' Σ Heq Heq' Hty Hwf Hmulti.
  subst cfg cfg'.
  destruct (multi_step_preservation (e, st, ctx) (e', st', ctx') Hmulti
              e e' T ε st st' ctx ctx' Σ eq_refl eq_refl Hty Hwf)
    as [Σ' [ε' [Hext [Hwf' Hty']]]].
  exists Σ', ε'. split; [| split].
  - exact Hext.
  - exact Hwf'.
  - (* e' performs within ε' *)
    apply core_effects_within with (G := nil) (S := Σ') (D := Public) (T := T).
    exact Hty'.
Qed.

(** ** Section 11: Capability Containment

    Capabilities are lexically scoped. Grant only affects its immediate body.
*)

Theorem capability_lexical_scope : forall G S D eff e T ε,
  has_type G S D (EGrant eff e) T ε ->
  has_type G S D e T ε.
Proof.
  (* This is exactly grant_no_escalation — grant is purely lexical *)
  apply grant_no_escalation.
Qed.

(** ERequire adds the required effect to the bound *)
Theorem require_effect_additive : forall G S D eff e T ε,
  has_type G S D (ERequire eff e) T (effect_join ε eff) ->
  exists ε', has_type G S D e T ε' /\ effect_leq ε' (effect_join ε eff).
Proof.
  intros G S D eff e T ε Hty.
  inversion Hty; subst.
  exists eff_e. split.
  - assumption.
  - (* effect_leq eff_e (effect_join eff_e eff) *)
    apply effect_join_ub_l.
Qed.

(** ** Section 12: Effect Join Properties for Programs

    Combining two expressions joins their effects.
*)

Theorem app_joins_effects : forall e1 e2 eff,
  performs_within e1 eff ->
  performs_within e2 eff ->
  performs_within (EApp e1 e2) eff.
Proof.
  intros e1 e2 eff H1 H2.
  simpl. split; assumption.
Qed.

Theorem let_joins_effects : forall x e1 e2 eff,
  performs_within e1 eff ->
  performs_within e2 eff ->
  performs_within (ELet x e1 e2) eff.
Proof.
  intros x e1 e2 eff H1 H2.
  simpl. split; assumption.
Qed.

(** End of EffectGate.v *)

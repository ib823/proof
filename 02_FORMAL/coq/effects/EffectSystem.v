(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * Effect Type System for RIINA
    
    Extended type system including Effect Handling and Capabilities.
    
    This module defines the FULL typing relation including:
    - Effect Operations (perform, handle)
    - Capabilities (require, grant)
    - Security Operations (classify, declassify)
    
    Note: The core TypeSafety proof uses the restricted 'has_type' from
    foundations/Typing.v. This module defines the complete specification.
    
    Mode: Comprehensive Verification | Zero Trust
*)

Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Typing.
Require Import RIINA.effects.EffectAlgebra.
From Stdlib Require Import Arith.PeanoNat.
From Stdlib Require Import Strings.String.
From Stdlib Require Import Lists.List.
Import ListNotations.

(** ** Effect Occurrence Predicate *)

Lemma effect_leq_pure : forall eff, effect_leq EffectPure eff.
Proof.
  intros eff. unfold effect_leq. simpl. apply Nat.le_0_l.
Qed.

Fixpoint performs_within (e : expr) (eff : effect) : Prop :=
  match e with
  | EUnit => True
  | EBool _ => True
  | EInt _ => True
  | EString _ => True
  | ELoc _ => True
  | EVar _ => True
  | ELam _ _ _ => True  (* Lambda body not evaluated at creation time *)
  | EApp e1 e2 => performs_within e1 eff /\ performs_within e2 eff
  | EPair e1 e2 => performs_within e1 eff /\ performs_within e2 eff
  | EFst e1 => performs_within e1 eff
  | ESnd e1 => performs_within e1 eff
  | EInl e1 _ => performs_within e1 eff
  | EInr e1 _ => performs_within e1 eff
  | ECase e0 _ e1 _ e2 =>
      performs_within e0 eff /\ performs_within e1 eff /\ performs_within e2 eff
  | EIf e1 e2 e3 =>
      performs_within e1 eff /\ performs_within e2 eff /\ performs_within e3 eff
  | ELet _ e1 e2 => performs_within e1 eff /\ performs_within e2 eff
  | EPerform eff' e1 => effect_leq eff' eff /\ performs_within e1 eff
  | EHandle e1 _ h => performs_within e1 eff /\ performs_within h eff
  | ERef e1 _ => performs_within e1 eff
  | EDeref e1 => performs_within e1 eff
  | EAssign e1 e2 => performs_within e1 eff /\ performs_within e2 eff
  | EClassify e1 => performs_within e1 eff
  | EDeclassify e1 e2 => performs_within e1 eff /\ performs_within e2 eff
  | EProve e1 => performs_within e1 eff
  | EFix _ => True  (* a fix VALUE is a thunk; effects occur on unrolling *)
  | ERequire _ e1 => performs_within e1 eff
  | EGrant _ e1 => performs_within e1 eff
  end.

Lemma performs_within_mono : forall e eff1 eff2,
  effect_leq eff1 eff2 ->
  performs_within e eff1 ->
  performs_within e eff2.
Proof.
  intros e eff1 eff2 Hle.
  induction e; simpl; intros Hpw; try assumption.
  (* EApp *)
  - destruct Hpw as [H1 H2]. split; [apply IHe1 | apply IHe2]; assumption.
  - destruct Hpw as [H1 H2]. split; [apply IHe1 | apply IHe2]; assumption.
  - apply IHe. exact Hpw.
  - apply IHe. exact Hpw.
  - apply IHe. exact Hpw.
  - apply IHe. exact Hpw.
  - destruct Hpw as [H0 [H1 H2]]. split; [apply IHe1 | split; [apply IHe2 | apply IHe3]]; assumption.
  - destruct Hpw as [H0 [H1 H2]]. split; [apply IHe1 | split; [apply IHe2 | apply IHe3]]; assumption.
  - destruct Hpw as [H1 H2]. split; [apply IHe1 | apply IHe2]; assumption.
  - destruct Hpw as [Hperf Hinner]. split.
    + eapply effect_leq_trans; eassumption.
    + apply IHe. exact Hinner.
  - destruct Hpw as [H1 H2]. split; [apply IHe1 | apply IHe2]; assumption.
  - apply IHe. exact Hpw.
  - apply IHe. exact Hpw.
  - destruct Hpw as [H1 H2]. split; [apply IHe1 | apply IHe2]; assumption.
  - apply IHe. exact Hpw.
  - destruct Hpw as [H1 H2]. split; [apply IHe1 | apply IHe2]; assumption.
  - apply IHe. exact Hpw.  (* EProve *)
  - apply IHe. exact Hpw.  (* ERequire *)
  - apply IHe. exact Hpw.  (* EGrant case *)
Qed.

(** ** Core Effect Soundness *)

(** Helper lemmas for effect ordering in complex cases *)

Lemma effect_leq_join_ub_l_trans : forall e1 e2 e3,
  effect_leq e1 (effect_join e2 (effect_join e1 e3)).
Proof.
  intros e1 e2 e3.
  eapply effect_leq_trans.
  - apply effect_join_ub_l.
  - apply effect_join_ub_r.
Qed.

Lemma effect_leq_join_ub_r_trans : forall e1 e2 e3,
  effect_leq e3 (effect_join e2 (effect_join e1 e3)).
Proof.
  intros e1 e2 e3.
  eapply effect_leq_trans.
  - apply effect_join_ub_r.
  - apply effect_join_ub_r.
Qed.

Lemma core_effects_within : forall G S D e T eff,
  has_type G S D e T eff ->
  performs_within e eff.
Proof.
  intros G S D e T eff Hty.
  induction Hty; simpl.

  (* T_Unit *) - trivial.
  (* T_Bool *) - trivial.
  (* T_Int *) - trivial.
  (* T_String *) - trivial.
  (* T_Loc *) - trivial.
  (* T_Var *) - trivial.
  (* T_Lam *) - trivial.

  (* T_App: e = EApp e1 e2, eff = effect_join ε (effect_join ε1 ε2) *)
  - split.
    + apply (performs_within_mono e1 ε1); [| exact IHHty1].
      eapply effect_leq_trans; [apply effect_join_ub_l | apply effect_join_ub_r].
    + apply (performs_within_mono e2 ε2); [| exact IHHty2].
      eapply effect_leq_trans; [apply effect_join_ub_r | apply effect_join_ub_r].

  (* T_Pair: e = EPair e1 e2, eff = effect_join ε1 ε2 *)
  - split.
    + apply (performs_within_mono e1 ε1); [apply effect_join_ub_l | exact IHHty1].
    + apply (performs_within_mono e2 ε2); [apply effect_join_ub_r | exact IHHty2].

  (* T_Fst: eff = ε *)
  - exact IHHty.

  (* T_Snd: eff = ε *)
  - exact IHHty.

  (* T_Inl: eff = ε *)
  - exact IHHty.

  (* T_Inr: eff = ε *)
  - exact IHHty.

  (* T_Case: eff = effect_join ε (effect_join ε1 ε2) *)
  - split.
    + apply (performs_within_mono e ε); [apply effect_join_ub_l | exact IHHty1].
    + split.
      * apply (performs_within_mono e1 ε1); [| exact IHHty2].
        eapply effect_leq_trans; [apply effect_join_ub_l | apply effect_join_ub_r].
      * apply (performs_within_mono e2 ε2); [| exact IHHty3].
        eapply effect_leq_trans; [apply effect_join_ub_r | apply effect_join_ub_r].

  (* T_If: eff = effect_join ε1 (effect_join ε2 ε3) *)
  - split.
    + apply (performs_within_mono e1 ε1); [apply effect_join_ub_l | exact IHHty1].
    + split.
      * apply (performs_within_mono e2 ε2); [| exact IHHty2].
        eapply effect_leq_trans; [apply effect_join_ub_l | apply effect_join_ub_r].
      * apply (performs_within_mono e3 ε3); [| exact IHHty3].
        eapply effect_leq_trans; [apply effect_join_ub_r | apply effect_join_ub_r].

  (* T_Let: eff = effect_join ε1 ε2 *)
  - split.
    + apply (performs_within_mono e1 ε1); [apply effect_join_ub_l | exact IHHty1].
    + apply (performs_within_mono e2 ε2); [apply effect_join_ub_r | exact IHHty2].

  (* T_Perform: eff = effect_join ε eff0 *)
  - split.
    + apply effect_join_ub_r.
    + apply (performs_within_mono e ε); [apply effect_join_ub_l | exact IHHty].

  (* T_Handle: eff = effect_join ε1 ε2 *)
  - split.
    + apply (performs_within_mono e ε1); [apply effect_join_ub_l | exact IHHty1].
    + apply (performs_within_mono h ε2); [apply effect_join_ub_r | exact IHHty2].

  (* T_Ref: eff = effect_join ε EffectWrite *)
  - apply (performs_within_mono e ε); [apply effect_join_ub_l | exact IHHty].

  (* T_Deref: eff = effect_join ε EffectRead *)
  - apply (performs_within_mono e ε); [apply effect_join_ub_l | exact IHHty].

  (* T_Assign: eff = effect_join ε1 (effect_join ε2 EffectWrite) *)
  - split.
    + apply (performs_within_mono e1 ε1); [apply effect_join_ub_l | exact IHHty1].
    + apply (performs_within_mono e2 ε2); [| exact IHHty2].
      eapply effect_leq_trans; [apply effect_join_ub_l | apply effect_join_ub_r].

  (* T_Classify: eff = ε *)
  - exact IHHty.

  (* T_Declassify: eff = effect_join ε1 ε2 *)
  - split.
    + apply (performs_within_mono e1 ε1); [apply effect_join_ub_l | exact IHHty1].
    + apply (performs_within_mono e2 ε2); [apply effect_join_ub_r | exact IHHty2].

  (* T_Prove: eff = ε *)
  - exact IHHty.

  (* T_Fix: a recursive function VALUE is a thunk — it performs nothing until
     unrolled at the application site. *)
  - exact I.

  (* T_Require: eff = effect_join ε eff0 *)
  - apply (performs_within_mono e ε); [apply effect_join_ub_l | exact IHHty].

  (* T_Grant: eff = ε *)
  - exact IHHty.
Qed.
(** ** Effect Typing Rules *)

Inductive has_type_full : type_env -> store_ty -> security_level ->
                          expr -> ty -> effect -> Prop :=
  (* Include all core rules *)
  | T_Core : forall G S D e T eff,
      has_type G S D e T eff ->
      has_type_full G S D e T eff

  (* Effect Operations *)
  | T_Perform : forall G S D eff e T ε,
      has_type_full G S D e T ε ->
      has_type_full G S D (EPerform eff e) T (effect_join ε eff)

  | T_Handle : forall G S D e y h T1 T2 ε1 ε2,
      has_type_full G S D e T1 ε1 ->
      has_type_full ((y, T1) :: G) S D h T2 ε2 ->
      has_type_full G S D (EHandle e y h) T2 (effect_join ε1 ε2)

  (* Capabilities *)
  | T_Require : forall G S D eff e T eff_e,
      (* e requires capability for 'eff' *)
      has_type_full G S D e T eff_e ->
      (* The resulting term has effect eff + eff_e *)
      has_type_full G S D (ERequire eff e) T (effect_join eff eff_e)

  | T_Grant : forall G S D eff e T eff_e,
      (* Granting a capability satisfies the requirement in e *)
      has_type_full G S D e T eff_e ->
      (* If e required eff, it is now discharged? 
         Or does it just mean this block has the authority? *)
      has_type_full G S D (EGrant eff e) T eff_e

  (* Security Operations *)
  | T_Classify : forall G S D e T eff,
      has_type_full G S D e T eff ->
      has_type_full G S D (EClassify e) (TSecret T) eff

  | T_Declassify : forall G S D e1 e2 T eff1 eff2,
      has_type_full G S D e1 (TSecret T) eff1 ->
      has_type_full G S D e2 (TProof (TSecret T)) eff2 -> (* Proof of safety *)
      declass_ok e1 e2 ->
      has_type_full G S D (EDeclassify e1 e2) T (effect_join eff1 eff2)

  | T_Prove : forall G S D e T eff,
      has_type_full G S D e T eff ->
      has_type_full G S D (EProve e) (TProof T) eff.

(** ** Effect Safety

    Theorem: If has_type_full G S D e T eff, then executing e
    only produces effects in eff.
*)
Theorem effect_safety : forall G S D e T eff,
  has_type_full G S D e T eff ->
  performs_within e eff.
Proof.
  intros G S D e T eff Hty.
  induction Hty; simpl.

  (* T_Core: use core_effects_within *)
  - apply core_effects_within with (G := G) (S := S) (D := D) (T := T).
    exact H.

  (* T_Perform: e = EPerform eff' e1, eff = effect_join ε eff' *)
  - split.
    + apply effect_join_ub_r.
    + apply (performs_within_mono e ε).
      * apply effect_join_ub_l.
      * exact IHHty.

  (* T_Handle: e = EHandle e1 y h, eff = effect_join ε1 ε2 *)
  - split.
    + apply (performs_within_mono e ε1).
      * apply effect_join_ub_l.
      * exact IHHty1.
    + apply (performs_within_mono h ε2).
      * apply effect_join_ub_r.
      * exact IHHty2.

  (* T_Require: e = ERequire eff' e1, eff = effect_join eff' eff_e *)
  - apply (performs_within_mono e eff_e).
    + apply effect_join_ub_r.
    + exact IHHty.

  (* T_Grant *)
  - exact IHHty.

  (* T_Classify *)
  - exact IHHty.

  (* T_Declassify: e = EDeclassify e1 e2, eff = effect_join eff1 eff2 *)
  - split.
    + apply (performs_within_mono e1 eff1).
      * apply effect_join_ub_l.
      * exact IHHty1.
    + apply (performs_within_mono e2 eff2).
      * apply effect_join_ub_r.
      * exact IHHty2.

  (* T_Prove *)
  - exact IHHty.
Qed.

(* ================================================================= *)
(** ** Values Always Perform Within Any Bound *)
(* ================================================================= *)

(** Values contain no performed effects (they are fully evaluated). *)
Lemma performs_within_value : forall v eff,
  value v ->
  performs_within v eff.
Proof.
  intros v eff Hval.
  induction Hval; simpl; auto.
Qed.

(** Values perform within EffPure. *)
Lemma performs_within_value_pure : forall v,
  value v ->
  performs_within v EffPure.
Proof.
  intros v Hval. apply performs_within_value. exact Hval.
Qed.

(* ================================================================= *)
(** ** Performs-Within Structural Properties *)
(* ================================================================= *)

(** The join of two bounds covers both sub-expressions. *)
Lemma performs_within_join_l : forall e eff1 eff2,
  performs_within e eff1 ->
  performs_within e (effect_join eff1 eff2).
Proof.
  intros e eff1 eff2 Hpw.
  apply performs_within_mono with (eff1 := eff1); auto.
  apply effect_join_ub_l.
Qed.

Lemma performs_within_join_r : forall e eff1 eff2,
  performs_within e eff2 ->
  performs_within e (effect_join eff1 eff2).
Proof.
  intros e eff1 eff2 Hpw.
  apply performs_within_mono with (eff1 := eff2); auto.
  apply effect_join_ub_r.
Qed.

(** Top effect (EffGapura) bounds everything. *)
Lemma performs_within_top : forall e eff,
  performs_within e eff ->
  performs_within e EffGapura.
Proof.
  intros e eff Hpw.
  apply performs_within_mono with (eff1 := eff); auto.
  apply effect_gapura_top.
Qed.

(* ================================================================= *)
(** ** has_type_full Structural Properties *)
(* ================================================================= *)

(** has_type embeds into has_type_full. *)
Lemma has_type_embed : forall G S D e T eff,
  has_type G S D e T eff ->
  has_type_full G S D e T eff.
Proof.
  intros. apply T_Core. exact H.
Qed.

(** has_type_full preserves effect ordering via performs_within. *)
Lemma has_type_full_effect_bound : forall G S D e T eff eff',
  has_type_full G S D e T eff ->
  effect_leq eff eff' ->
  performs_within e eff'.
Proof.
  intros G S D e T eff eff' Hty Hle.
  apply performs_within_mono with (eff1 := eff); auto.
  apply effect_safety with (G := G) (S := S) (D := D) (T := T).
  exact Hty.
Qed.

(** The core typing relation's effect is sound for performs_within. *)
Lemma core_typing_sound : forall G S D e T eff,
  has_type G S D e T eff ->
  forall eff', effect_leq eff eff' -> performs_within e eff'.
Proof.
  intros G S D e T eff Hty eff' Hle.
  apply performs_within_mono with (eff1 := eff); auto.
  apply core_effects_within with (G := G) (S := S) (D := D) (T := T).
  exact Hty.
Qed.

(* ================================================================= *)
(** ** Effect Composition Properties *)
(* ================================================================= *)

(** Application composes effects correctly: the join covers both sub-effects. *)
Lemma app_effect_covers_fn_and_arg : forall ε_fn ε1 ε2,
  effect_leq ε_fn (effect_join ε_fn (effect_join ε1 ε2)) /\
  effect_leq ε1 (effect_join ε_fn (effect_join ε1 ε2)) /\
  effect_leq ε2 (effect_join ε_fn (effect_join ε1 ε2)).
Proof.
  intros. repeat split.
  - apply effect_join_ub_l.
  - eapply effect_leq_trans. apply effect_join_ub_l. apply effect_join_ub_r.
  - eapply effect_leq_trans. apply effect_join_ub_r. apply effect_join_ub_r.
Qed.

(** If-expression effect covers all three branches. *)
Lemma if_effect_covers_branches : forall ε1 ε2 ε3,
  effect_leq ε1 (effect_join ε1 (effect_join ε2 ε3)) /\
  effect_leq ε2 (effect_join ε1 (effect_join ε2 ε3)) /\
  effect_leq ε3 (effect_join ε1 (effect_join ε2 ε3)).
Proof.
  intros. repeat split.
  - apply effect_join_ub_l.
  - eapply effect_leq_trans. apply effect_join_ub_l. apply effect_join_ub_r.
  - eapply effect_leq_trans. apply effect_join_ub_r. apply effect_join_ub_r.
Qed.

(** Let-expression effect covers binding and body. *)
Lemma let_effect_covers_both : forall ε1 ε2,
  effect_leq ε1 (effect_join ε1 ε2) /\
  effect_leq ε2 (effect_join ε1 ε2).
Proof.
  intros. split.
  - apply effect_join_ub_l.
  - apply effect_join_ub_r.
Qed.

(** Pair effect covers both components. *)
Lemma pair_effect_covers_both : forall ε1 ε2,
  effect_leq ε1 (effect_join ε1 ε2) /\
  effect_leq ε2 (effect_join ε1 ε2).
Proof.
  intros. split; [apply effect_join_ub_l | apply effect_join_ub_r].
Qed.

(* ================================================================= *)
(** ** Effect Weakening for Full Typing *)
(* ================================================================= *)

(** If has_type_full gives effect ε, any effect ε' ≥ ε also bounds the expression. *)
Lemma has_type_full_weaken_effect : forall G S D e T ε ε',
  has_type_full G S D e T ε ->
  effect_leq ε ε' ->
  performs_within e ε'.
Proof.
  intros G S D e T ε ε' Hty Hle.
  apply performs_within_mono with (eff1 := ε).
  - exact Hle.
  - apply effect_safety with (G := G) (S := S) (D := D) (T := T). exact Hty.
Qed.

(** The pure effect is always a valid lower bound. *)
Lemma pure_within_any_effect : forall e,
  performs_within e EffPure ->
  forall eff, performs_within e eff.
Proof.
  intros e Hpw eff.
  apply performs_within_mono with (eff1 := EffPure).
  - apply effect_leq_pure.
  - exact Hpw.
Qed.

(* ================================================================= *)
(** ** Effect Composition for Nested Expressions *)
(* ================================================================= *)

(** Assign composes three effects: lhs + rhs + EffWrite. *)
Lemma assign_effect_covers : forall ε1 ε2,
  effect_leq ε1 (effect_join ε1 (effect_join ε2 EffectWrite)) /\
  effect_leq ε2 (effect_join ε1 (effect_join ε2 EffectWrite)) /\
  effect_leq EffectWrite (effect_join ε1 (effect_join ε2 EffectWrite)).
Proof.
  intros. repeat split.
  - apply effect_join_ub_l.
  - eapply effect_leq_trans. apply effect_join_ub_l. apply effect_join_ub_r.
  - eapply effect_leq_trans. apply effect_join_ub_r. apply effect_join_ub_r.
Qed.

(** Case expression effect covers scrutinee and both branches. *)
Lemma case_effect_covers : forall ε ε1 ε2,
  effect_leq ε (effect_join ε (effect_join ε1 ε2)) /\
  effect_leq ε1 (effect_join ε (effect_join ε1 ε2)) /\
  effect_leq ε2 (effect_join ε (effect_join ε1 ε2)).
Proof.
  intros. repeat split.
  - apply effect_join_ub_l.
  - eapply effect_leq_trans. apply effect_join_ub_l. apply effect_join_ub_r.
  - eapply effect_leq_trans. apply effect_join_ub_r. apply effect_join_ub_r.
Qed.

(** Handle combines body and handler effects. *)
Lemma handle_effect_covers : forall ε1 ε2,
  effect_leq ε1 (effect_join ε1 ε2) /\
  effect_leq ε2 (effect_join ε1 ε2).
Proof.
  intros. split; [apply effect_join_ub_l | apply effect_join_ub_r].
Qed.

(** Declassify composes secret and proof effects. *)
Lemma declassify_effect_covers : forall ε1 ε2,
  effect_leq ε1 (effect_join ε1 ε2) /\
  effect_leq ε2 (effect_join ε1 ε2).
Proof.
  intros. split; [apply effect_join_ub_l | apply effect_join_ub_r].
Qed.

(* ================================================================= *)
(** ** Effect Idempotence for Programs *)
(* ================================================================= *)

(** If an expression's effects are bounded by ε, joining with ε is idempotent. *)
Lemma performs_within_join_self : forall e eff,
  performs_within e eff ->
  performs_within e (effect_join eff eff).
Proof.
  intros e eff Hpw.
  rewrite effect_join_idem. exact Hpw.
Qed.

(** Effect bound is preserved under join with pure. *)
Lemma performs_within_join_pure_l : forall e eff,
  performs_within e eff ->
  performs_within e (effect_join EffPure eff).
Proof.
  intros e eff Hpw.
  rewrite effect_join_pure_l. exact Hpw.
Qed.

(** Effect bound is preserved under join with pure (right). *)
Lemma performs_within_join_pure_r : forall e eff,
  performs_within e eff ->
  performs_within e (effect_join eff EffPure).
Proof.
  intros e eff Hpw.
  rewrite effect_join_pure_r. exact Hpw.
Qed.

(** ** Values Always Type With Pure Effect in has_type_full *)

Lemma has_type_full_value_pure : forall v S D T eff,
  value v ->
  has_type_full nil S D v T eff ->
  performs_within v EffPure.
Proof.
  intros v S D T eff Hval Hty.
  apply performs_within_value. exact Hval.
Qed.

(** ** Effect Safety for Values *)

Lemma effect_safety_value : forall v S D T eff,
  value v ->
  has_type_full nil S D v T eff ->
  forall eff', performs_within v eff'.
Proof.
  intros v S D T eff Hval Hty eff'.
  apply performs_within_value. exact Hval.
Qed.

(** ** Performs-Within Reflexivity for Pure *)

Lemma performs_within_pure_refl : forall e,
  performs_within e EffPure ->
  performs_within e EffPure.
Proof.
  intros. exact H.
Qed.

(** ** Double Join Associativity for Effect Bounds *)

Lemma performs_within_double_join : forall e eff1 eff2 eff3,
  performs_within e eff1 ->
  performs_within e (effect_join eff1 (effect_join eff2 eff3)).
Proof.
  intros e eff1 eff2 eff3 Hpw.
  apply performs_within_mono with (eff1 := eff1).
  - apply effect_join_ub_l.
  - exact Hpw.
Qed.

(** ** Structural Decomposition of performs_within *)

(** Pair decomposition: if pair performs within eff, so do both components *)
Lemma performs_within_pair_components : forall e1 e2 eff,
  performs_within (EPair e1 e2) eff ->
  performs_within e1 eff /\ performs_within e2 eff.
Proof.
  intros e1 e2 eff H. simpl in H. exact H.
Qed.

(** App decomposition: if app performs within eff, so do both sub-expressions *)
Lemma performs_within_app_components : forall e1 e2 eff,
  performs_within (EApp e1 e2) eff ->
  performs_within e1 eff /\ performs_within e2 eff.
Proof.
  intros e1 e2 eff H. simpl in H. exact H.
Qed.

(** If decomposition: if-expression components all perform within eff *)
Lemma performs_within_if_components : forall e1 e2 e3 eff,
  performs_within (EIf e1 e2 e3) eff ->
  performs_within e1 eff /\ performs_within e2 eff /\ performs_within e3 eff.
Proof.
  intros e1 e2 e3 eff H. simpl in H. exact H.
Qed.

(** Let decomposition: both binding and body perform within eff *)
Lemma performs_within_let_components : forall x e1 e2 eff,
  performs_within (ELet x e1 e2) eff ->
  performs_within e1 eff /\ performs_within e2 eff.
Proof.
  intros x e1 e2 eff H. simpl in H. exact H.
Qed.

(** Case decomposition: scrutinee and both branches perform within eff *)
Lemma performs_within_case_components : forall e x1 e1 x2 e2 eff,
  performs_within (ECase e x1 e1 x2 e2) eff ->
  performs_within e eff /\ performs_within e1 eff /\ performs_within e2 eff.
Proof.
  intros e x1 e1 x2 e2 eff H. simpl in H. exact H.
Qed.

(** End of EffectSystem.v *)

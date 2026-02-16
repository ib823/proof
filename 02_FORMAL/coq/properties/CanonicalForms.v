(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * Canonical Forms — Systematic Value Characterization

    For every type T, characterize the exact shape of well-typed closed
    values of that type.  These lemmas are essential for progress proofs
    and for reasoning about evaluation results.

    Dependencies: Syntax.v, Typing.v
    Mode: Core Deepening | Zero Trust
*)

Require Import Coq.Strings.String.
Require Import Coq.Lists.List.
Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Typing.
Import ListNotations.

(* ================================================================= *)
(** ** Section 1: Base Type Canonical Forms *)
(* ================================================================= *)

(** A closed value of type TUnit must be EUnit. *)
Lemma canonical_unit : forall v ε Σ,
  has_type nil Σ Public v TUnit ε ->
  value v ->
  v = EUnit.
Proof.
  intros v ε Σ Hty Hval.
  inversion Hval; subst; inversion Hty; subst; reflexivity.
Qed.

(** A closed value of type TBool must be EBool b for some b. *)
Lemma canonical_bool : forall v ε Σ,
  has_type nil Σ Public v TBool ε ->
  value v ->
  exists b, v = EBool b.
Proof.
  intros v ε Σ Hty Hval.
  inversion Hval; subst; inversion Hty; subst.
  exists b. reflexivity.
Qed.

(** A closed value of type TInt must be EInt n for some n. *)
Lemma canonical_int : forall v ε Σ,
  has_type nil Σ Public v TInt ε ->
  value v ->
  exists n, v = EInt n.
Proof.
  intros v ε Σ Hty Hval.
  inversion Hval; subst; inversion Hty; subst.
  exists n. reflexivity.
Qed.

(** A closed value of type TString must be EString s for some s. *)
Lemma canonical_string : forall v ε Σ,
  has_type nil Σ Public v TString ε ->
  value v ->
  exists s, v = EString s.
Proof.
  intros v ε Σ Hty Hval.
  inversion Hval; subst; inversion Hty; subst.
  exists s. reflexivity.
Qed.

(* ================================================================= *)
(** ** Section 2: Compound Type Canonical Forms *)
(* ================================================================= *)

(** A closed value of function type must be a lambda. *)
Lemma canonical_fn : forall v T1 T2 ε_body ε Σ,
  has_type nil Σ Public v (TFn T1 T2 ε_body) ε ->
  value v ->
  exists x body, v = ELam x T1 body.
Proof.
  intros v T1 T2 ε_body ε Σ Hty Hval.
  inversion Hval; subst; inversion Hty; subst.
  exists x, e. reflexivity.
Qed.

(** A closed value of product type must be a pair of values. *)
Lemma canonical_pair : forall v T1 T2 ε Σ,
  has_type nil Σ Public v (TProd T1 T2) ε ->
  value v ->
  exists v1 v2, v = EPair v1 v2 /\ value v1 /\ value v2.
Proof.
  intros v T1 T2 ε Σ Hty Hval.
  inversion Hval; subst; inversion Hty; subst.
  exists v1, v2. auto.
Qed.

(** A closed value of sum type must be an injection of a value. *)
Lemma canonical_sum : forall v T1 T2 ε Σ,
  has_type nil Σ Public v (TSum T1 T2) ε ->
  value v ->
  (exists v', v = EInl v' T2 /\ value v') \/
  (exists v', v = EInr v' T1 /\ value v').
Proof.
  intros v T1 T2 ε Σ Hty Hval.
  inversion Hval; subst; inversion Hty; subst.
  - left. exists v0. auto.
  - right. exists v0. auto.
Qed.

(** Refined: left injection value. *)
Lemma canonical_sum_inl : forall v T1 T2 ε Σ,
  has_type nil Σ Public v (TSum T1 T2) ε ->
  value v ->
  (exists v', v = EInl v' T2 /\ value v') \/
  (exists v', v = EInr v' T1 /\ value v').
Proof.
  exact canonical_sum.
Qed.

(** A closed value of reference type must be a location. *)
Lemma canonical_ref : forall v T l ε Σ,
  has_type nil Σ Public v (TRef T l) ε ->
  value v ->
  exists l', v = ELoc l'.
Proof.
  intros v T l ε Σ Hty Hval.
  inversion Hval; subst; inversion Hty; subst.
  exists l0. reflexivity.
Qed.

(* ================================================================= *)
(** ** Section 3: Security Type Canonical Forms *)
(* ================================================================= *)

(** A closed value of secret type must be EClassify v'. *)
Lemma canonical_secret : forall v T ε Σ,
  has_type nil Σ Public v (TSecret T) ε ->
  value v ->
  exists v', v = EClassify v' /\ value v'.
Proof.
  intros v T ε Σ Hty Hval.
  inversion Hval; subst; inversion Hty; subst.
  exists v0. auto.
Qed.

(** A closed value of proof type must be EProve v'. *)
Lemma canonical_proof : forall v T ε Σ,
  has_type nil Σ Public v (TProof T) ε ->
  value v ->
  exists v', v = EProve v' /\ value v'.
Proof.
  intros v T ε Σ Hty Hval.
  inversion Hval; subst; inversion Hty; subst.
  exists v0. auto.
Qed.

(* ================================================================= *)
(** ** Section 4: Value Effect Properties *)
(* ================================================================= *)

(** All base values (unit, bool, int, string, loc, lambda) are typed
    with EffPure. *)
Lemma base_value_pure : forall v Σ T ε,
  has_type nil Σ Public v T ε ->
  value v ->
  (v = EUnit \/ (exists b, v = EBool b) \/ (exists n, v = EInt n) \/
   (exists s, v = EString s) \/ (exists l, v = ELoc l) \/
   (exists x T' body, v = ELam x T' body)) ->
  ε = EffPure.
Proof.
  intros v Σ T ε Hty Hval Hform.
  destruct Hform as [H | [H | [H | [H | [H | H]]]]].
  - subst. inversion Hty. reflexivity.
  - destruct H as [b H]. subst. inversion Hty. reflexivity.
  - destruct H as [n H]. subst. inversion Hty. reflexivity.
  - destruct H as [s H]. subst. inversion Hty. reflexivity.
  - destruct H as [l H]. subst. inversion Hty. reflexivity.
  - destruct H as [x [T' [body H]]]. subst. inversion Hty. reflexivity.
Qed.

(** Unit value is always typed with EffPure. *)
Lemma unit_value_pure : forall Σ T ε,
  has_type nil Σ Public EUnit T ε ->
  ε = EffPure.
Proof.
  intros Σ T ε Hty. inversion Hty. reflexivity.
Qed.

(** Bool values are always typed with EffPure. *)
Lemma bool_value_pure : forall b Σ T ε,
  has_type nil Σ Public (EBool b) T ε ->
  ε = EffPure.
Proof.
  intros b Σ T ε Hty. inversion Hty. reflexivity.
Qed.

(** Int values are always typed with EffPure. *)
Lemma int_value_pure : forall n Σ T ε,
  has_type nil Σ Public (EInt n) T ε ->
  ε = EffPure.
Proof.
  intros n Σ T ε Hty. inversion Hty. reflexivity.
Qed.

(** String values are always typed with EffPure. *)
Lemma string_value_pure : forall s Σ T ε,
  has_type nil Σ Public (EString s) T ε ->
  ε = EffPure.
Proof.
  intros s Σ T ε Hty. inversion Hty. reflexivity.
Qed.

(** Lambda values are always typed with EffPure. *)
Lemma lambda_value_pure : forall x T1 body Σ T ε,
  has_type nil Σ Public (ELam x T1 body) T ε ->
  ε = EffPure.
Proof.
  intros x T1 body Σ T ε Hty. inversion Hty. reflexivity.
Qed.

(** Location values are always typed with EffPure. *)
Lemma loc_value_pure : forall l Σ T ε,
  has_type nil Σ Public (ELoc l) T ε ->
  ε = EffPure.
Proof.
  intros l Σ T ε Hty. inversion Hty. reflexivity.
Qed.

(* ================================================================= *)
(** ** Section 5: Value Type Determinism *)
(* ================================================================= *)

(** A closed value uniquely determines a type "shape":
    different type constructors cannot type the same value. *)

Lemma unit_not_bool : forall Σ ε,
  ~ has_type nil Σ Public EUnit TBool ε.
Proof.
  intros Σ ε H. inversion H.
Qed.

Lemma unit_not_int : forall Σ ε,
  ~ has_type nil Σ Public EUnit TInt ε.
Proof.
  intros Σ ε H. inversion H.
Qed.

Lemma unit_not_fn : forall Σ T1 T2 ε_body ε,
  ~ has_type nil Σ Public EUnit (TFn T1 T2 ε_body) ε.
Proof.
  intros Σ T1 T2 ε_body ε H. inversion H.
Qed.

Lemma bool_not_unit : forall b Σ ε,
  ~ has_type nil Σ Public (EBool b) TUnit ε.
Proof.
  intros b Σ ε H. inversion H.
Qed.

Lemma bool_not_int : forall b Σ ε,
  ~ has_type nil Σ Public (EBool b) TInt ε.
Proof.
  intros b Σ ε H. inversion H.
Qed.

Lemma int_not_unit : forall n Σ ε,
  ~ has_type nil Σ Public (EInt n) TUnit ε.
Proof.
  intros n Σ ε H. inversion H.
Qed.

Lemma int_not_bool : forall n Σ ε,
  ~ has_type nil Σ Public (EInt n) TBool ε.
Proof.
  intros n Σ ε H. inversion H.
Qed.

(* ================================================================= *)
(** ** Section 6: Pair Component Typing *)
(* ================================================================= *)

(** Pair value components are well-typed at the component types. *)
Lemma pair_components_typed : forall v1 v2 T1 T2 ε Σ,
  has_type nil Σ Public (EPair v1 v2) (TProd T1 T2) ε ->
  exists ε1 ε2,
    has_type nil Σ Public v1 T1 ε1 /\
    has_type nil Σ Public v2 T2 ε2.
Proof.
  intros v1 v2 T1 T2 ε Σ Hty.
  inversion Hty; subst.
  eexists. eexists. split; eassumption.
Qed.

(** Inl value component is well-typed at the left type. *)
Lemma inl_component_typed : forall v T1 T2 ε Σ,
  has_type nil Σ Public (EInl v T2) (TSum T1 T2) ε ->
  exists ε',
    has_type nil Σ Public v T1 ε'.
Proof.
  intros v T1 T2 ε Σ Hty.
  inversion Hty; subst.
  eexists. eassumption.
Qed.

(** Inr value component is well-typed at the right type. *)
Lemma inr_component_typed : forall v T1 T2 ε Σ,
  has_type nil Σ Public (EInr v T1) (TSum T1 T2) ε ->
  exists ε',
    has_type nil Σ Public v T2 ε'.
Proof.
  intros v T1 T2 ε Σ Hty.
  inversion Hty; subst.
  eexists. eassumption.
Qed.

(** Classify value component is well-typed at the inner type. *)
Lemma classify_component_typed : forall v T ε Σ,
  has_type nil Σ Public (EClassify v) (TSecret T) ε ->
  exists ε',
    has_type nil Σ Public v T ε'.
Proof.
  intros v T ε Σ Hty.
  inversion Hty; subst.
  eexists. eassumption.
Qed.

(** Prove value component is well-typed at the inner type. *)
Lemma prove_component_typed : forall v T ε Σ,
  has_type nil Σ Public (EProve v) (TProof T) ε ->
  exists ε',
    has_type nil Σ Public v T ε'.
Proof.
  intros v T ε Σ Hty.
  inversion Hty; subst.
  eexists. eassumption.
Qed.

(* ================================================================= *)
(** ** Section 7: Value Decidability for Types *)
(* ================================================================= *)

(** If v is a well-typed closed value, we can characterize its shape. *)
Lemma value_shape : forall v Σ T ε,
  has_type nil Σ Public v T ε ->
  value v ->
  v = EUnit \/
  (exists b, v = EBool b) \/
  (exists n, v = EInt n) \/
  (exists s, v = EString s) \/
  (exists l, v = ELoc l) \/
  (exists x T1 body, v = ELam x T1 body) \/
  (exists v1 v2, v = EPair v1 v2) \/
  (exists v' T2, v = EInl v' T2) \/
  (exists v' T1, v = EInr v' T1) \/
  (exists v', v = EClassify v') \/
  (exists v', v = EProve v').
Proof.
  intros v Σ T ε Hty Hval.
  inversion Hval; subst; eauto 10.
  - right. right. right. right. right. right. right. left. eauto.
  - right. right. right. right. right. right. right. right. left. eauto.
  - right. right. right. right. right. right. right. right. right. left. eauto.
  - right. right. right. right. right. right. right. right. right. right. eauto.
Qed.

(* ================================================================= *)
(** ** Section 8: Type Determination Lemmas *)
(* ================================================================= *)

(** EUnit typed in empty context must have type TUnit. *)
Lemma value_type_unit : forall Σ T ε,
  has_type nil Σ Public EUnit T ε ->
  T = TUnit.
Proof.
  intros Σ T ε Hty. inversion Hty. reflexivity.
Qed.

(** EBool typed in empty context must have type TBool. *)
Lemma value_type_bool : forall b Σ T ε,
  has_type nil Σ Public (EBool b) T ε ->
  T = TBool.
Proof.
  intros b Σ T ε Hty. inversion Hty. reflexivity.
Qed.

(** EInt typed in empty context must have type TInt. *)
Lemma value_type_int : forall n Σ T ε,
  has_type nil Σ Public (EInt n) T ε ->
  T = TInt.
Proof.
  intros n Σ T ε Hty. inversion Hty. reflexivity.
Qed.

(** EString typed in empty context must have type TString. *)
Lemma value_type_string : forall s Σ T ε,
  has_type nil Σ Public (EString s) T ε ->
  T = TString.
Proof.
  intros s Σ T ε Hty. inversion Hty. reflexivity.
Qed.

(** ELoc typed in empty context must have reference type. *)
Lemma value_type_loc : forall l Σ T ε,
  has_type nil Σ Public (ELoc l) T ε ->
  exists T' sl, T = TRef T' sl.
Proof.
  intros l Σ T ε Hty. inversion Hty; subst.
  eexists. eexists. reflexivity.
Qed.

(** ELam typed in empty context must have function type. *)
Lemma value_type_lam : forall x T1 body Σ T ε,
  has_type nil Σ Public (ELam x T1 body) T ε ->
  exists T2 ε_body, T = TFn T1 T2 ε_body.
Proof.
  intros x T1 body Σ T ε Hty. inversion Hty; subst.
  eexists. eexists. reflexivity.
Qed.

(** ** Section 9: Typed Value Component Extraction *)

(** A well-typed pair value has well-typed components at the component types. *)
Lemma canonical_pair_typed_components : forall v1 v2 T1 T2 ε Σ,
  has_type nil Σ Public (EPair v1 v2) (TProd T1 T2) ε ->
  value v1 -> value v2 ->
  exists ε1 ε2,
    has_type nil Σ Public v1 T1 ε1 /\
    has_type nil Σ Public v2 T2 ε2.
Proof.
  intros v1 v2 T1 T2 ε Σ Hty Hval1 Hval2.
  inversion Hty; subst.
  eexists. eexists. split; eassumption.
Qed.

(** End of CanonicalForms.v *)

(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * ClosedValueLemmas.v

    Lemmas about closed expressions and values.

    Key theorem: Values typed in empty context have no free variables.

    Mode: Comprehensive Verification | Zero Admits
*)

Require Import String.
Require Import List.
Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Typing.
Require Import RIINA.type_system.Preservation.
Import ListNotations.

(** Closed expression: no free variables *)
Definition closed_expr_cv (e : expr) : Prop := forall x, ~ free_in x e.

(** Values are closed under empty context typing *)
Lemma value_typed_closed : forall Σ Δ v T ε,
  value v ->
  has_type nil Σ Δ v T ε ->
  closed_expr_cv v.
Proof.
  intros Σ Δ v T ε Hval Hty.
  unfold closed_expr_cv. intros x Hfree.
  destruct (free_in_context x v nil Σ Δ T ε Hfree Hty) as [T' Hlook].
  simpl in Hlook. discriminate.
Qed.

(** Closed expressions for compound types - decomposition *)
Lemma closed_pair_cv : forall e1 e2,
  closed_expr_cv (EPair e1 e2) <-> closed_expr_cv e1 /\ closed_expr_cv e2.
Proof.
  intros e1 e2. split.
  - intros Hc. split; unfold closed_expr_cv in *; intros x Hfree;
    apply (Hc x); simpl; [left | right]; exact Hfree.
  - intros [Hc1 Hc2]. unfold closed_expr_cv in *. intros x Hfree.
    simpl in Hfree. destruct Hfree as [H | H]; [apply (Hc1 x H) | apply (Hc2 x H)].
Qed.

Lemma closed_inl_cv : forall e T,
  closed_expr_cv (EInl e T) <-> closed_expr_cv e.
Proof.
  intros e T. split; unfold closed_expr_cv; intros Hc x Hfree.
  - apply (Hc x). simpl. exact Hfree.
  - simpl in Hfree. apply (Hc x). exact Hfree.
Qed.

Lemma closed_inr_cv : forall e T,
  closed_expr_cv (EInr e T) <-> closed_expr_cv e.
Proof.
  intros e T. split; unfold closed_expr_cv; intros Hc x Hfree.
  - apply (Hc x). simpl. exact Hfree.
  - simpl in Hfree. apply (Hc x). exact Hfree.
Qed.

Lemma closed_app_cv : forall e1 e2,
  closed_expr_cv (EApp e1 e2) <-> closed_expr_cv e1 /\ closed_expr_cv e2.
Proof.
  intros e1 e2. split.
  - intros Hc. split; unfold closed_expr_cv in *; intros x Hfree;
    apply (Hc x); simpl; [left | right]; exact Hfree.
  - intros [Hc1 Hc2]. unfold closed_expr_cv in *. intros x Hfree.
    simpl in Hfree. destruct Hfree as [H | H]; [apply (Hc1 x H) | apply (Hc2 x H)].
Qed.

(** Values: specific closed lemmas *)
Lemma closed_unit_cv : closed_expr_cv EUnit.
Proof. unfold closed_expr_cv. intros x Hfree. simpl in Hfree. exact Hfree. Qed.

Lemma closed_bool_cv : forall b, closed_expr_cv (EBool b).
Proof. intros b. unfold closed_expr_cv. intros x Hfree. simpl in Hfree. exact Hfree. Qed.

Lemma closed_int_cv : forall n, closed_expr_cv (EInt n).
Proof. intros n. unfold closed_expr_cv. intros x Hfree. simpl in Hfree. exact Hfree. Qed.

Lemma closed_string_cv : forall s, closed_expr_cv (EString s).
Proof. intros s. unfold closed_expr_cv. intros x Hfree. simpl in Hfree. exact Hfree. Qed.

Lemma closed_loc_cv : forall l, closed_expr_cv (ELoc l).
Proof. intros l. unfold closed_expr_cv. intros x Hfree. simpl in Hfree. exact Hfree. Qed.

(** Lambda: bound variable can be free in body but not in lambda *)
Lemma closed_lam_body_cv : forall x T body y,
  closed_expr_cv (ELam x T body) ->
  free_in y body ->
  y = x.
Proof.
  intros x T body y Hclosed Hfree.
  unfold closed_expr_cv in Hclosed.
  destruct (String.eqb_spec y x) as [Heq | Hneq].
  - exact Heq.
  - exfalso. apply (Hclosed y). simpl. split; assumption.
Qed.

(** ** Section 5: Closedness for More Expression Forms *)

Lemma closed_if_cv : forall e1 e2 e3,
  closed_expr_cv (EIf e1 e2 e3) <-> closed_expr_cv e1 /\ closed_expr_cv e2 /\ closed_expr_cv e3.
Proof.
  intros e1 e2 e3. split.
  - intros Hc. split; [| split]; unfold closed_expr_cv in *; intros x Hfree;
    apply (Hc x); simpl;
    [left | right; left | right; right]; exact Hfree.
  - intros [Hc1 [Hc2 Hc3]]. unfold closed_expr_cv in *. intros x Hfree.
    simpl in Hfree. destruct Hfree as [H | [H | H]].
    + apply (Hc1 x H).
    + apply (Hc2 x H).
    + apply (Hc3 x H).
Qed.

Lemma closed_let_cv : forall y e1 e2,
  closed_expr_cv (ELet y e1 e2) <->
  closed_expr_cv e1 /\ (forall x, x <> y -> free_in x e2 -> False).
Proof.
  intros y e1 e2. split.
  - intros Hc. split.
    + unfold closed_expr_cv in *. intros x Hfree.
      apply (Hc x). simpl. left. exact Hfree.
    + intros x Hneq Hfree. apply (Hc x). simpl. right. split; assumption.
  - intros [Hc1 Hc2]. unfold closed_expr_cv. intros x Hfree.
    simpl in Hfree. destruct Hfree as [H | [Hneq H]].
    + apply (Hc1 x H).
    + exact (Hc2 x Hneq H).
Qed.

Lemma closed_ref_cv : forall e sl,
  closed_expr_cv (ERef e sl) <-> closed_expr_cv e.
Proof.
  intros e sl. split; unfold closed_expr_cv; intros Hc x Hfree.
  - apply (Hc x). simpl. exact Hfree.
  - simpl in Hfree. apply (Hc x). exact Hfree.
Qed.

Lemma closed_deref_cv : forall e,
  closed_expr_cv (EDeref e) <-> closed_expr_cv e.
Proof.
  intros e. split; unfold closed_expr_cv; intros Hc x Hfree.
  - apply (Hc x). simpl. exact Hfree.
  - simpl in Hfree. apply (Hc x). exact Hfree.
Qed.

Lemma closed_assign_cv : forall e1 e2,
  closed_expr_cv (EAssign e1 e2) <-> closed_expr_cv e1 /\ closed_expr_cv e2.
Proof.
  intros e1 e2. split.
  - intros Hc. split; unfold closed_expr_cv in *; intros x Hfree;
    apply (Hc x); simpl; [left | right]; exact Hfree.
  - intros [Hc1 Hc2]. unfold closed_expr_cv in *. intros x Hfree.
    simpl in Hfree. destruct Hfree as [H | H]; [apply (Hc1 x H) | apply (Hc2 x H)].
Qed.

Lemma closed_classify_cv : forall e,
  closed_expr_cv (EClassify e) <-> closed_expr_cv e.
Proof.
  intros e. split; unfold closed_expr_cv; intros Hc x Hfree.
  - apply (Hc x). simpl. exact Hfree.
  - simpl in Hfree. apply (Hc x). exact Hfree.
Qed.

Lemma closed_prove_cv : forall e,
  closed_expr_cv (EProve e) <-> closed_expr_cv e.
Proof.
  intros e. split; unfold closed_expr_cv; intros Hc x Hfree.
  - apply (Hc x). simpl. exact Hfree.
  - simpl in Hfree. apply (Hc x). exact Hfree.
Qed.

Lemma closed_fst_cv : forall e,
  closed_expr_cv (EFst e) <-> closed_expr_cv e.
Proof.
  intros e. split; unfold closed_expr_cv; intros Hc x Hfree.
  - apply (Hc x). simpl. exact Hfree.
  - simpl in Hfree. apply (Hc x). exact Hfree.
Qed.

Lemma closed_snd_cv : forall e,
  closed_expr_cv (ESnd e) <-> closed_expr_cv e.
Proof.
  intros e. split; unfold closed_expr_cv; intros Hc x Hfree.
  - apply (Hc x). simpl. exact Hfree.
  - simpl in Hfree. apply (Hc x). exact Hfree.
Qed.

(** ** Section 6: Value Closedness Properties *)

Require Import RIINA.foundations.Semantics.

(** Values of simple base types are always closed *)
Lemma value_closed_simple : forall v Σ Δ T ε,
  value v ->
  has_type nil Σ Δ v T ε ->
  match v with
  | EUnit | EBool _ | EInt _ | EString _ | ELoc _ => True
  | _ => True
  end ->
  closed_expr_cv v.
Proof.
  intros v Σ Δ T ε Hval Hty _.
  exact (value_typed_closed Σ Δ v T ε Hval Hty).
Qed.

(** Closed expressions under weakening *)
Lemma closed_weaken_ctx : forall e Σ1 Σ2 Δ T ε,
  has_type nil Σ1 Δ e T ε ->
  store_ty_extends Σ1 Σ2 ->
  closed_expr_cv e.
Proof.
  intros e Σ1 Σ2 Δ T ε Hty Hext.
  unfold closed_expr_cv. intros x Hfree.
  destruct (free_in_context x e nil Σ1 Δ T ε Hfree Hty) as [T' Hlook].
  simpl in Hlook. discriminate.
Qed.

(** Any expression typed in nil context is closed *)
Lemma nil_ctx_is_closed : forall e Σ Δ T ε,
  has_type nil Σ Δ e T ε ->
  closed_expr_cv e.
Proof.
  intros e Σ Δ T ε Hty.
  unfold closed_expr_cv. intros x Hfree.
  destruct (free_in_context x e nil Σ Δ T ε Hfree Hty) as [T' Hlook].
  simpl in Hlook. discriminate.
Qed.

(** Closedness is preserved by EGrant wrapper *)
Lemma closed_grant_cv : forall eff e,
  closed_expr_cv (EGrant eff e) <-> closed_expr_cv e.
Proof.
  intros eff e. split; unfold closed_expr_cv; intros Hc x Hfree.
  - apply (Hc x). simpl. exact Hfree.
  - simpl in Hfree. apply (Hc x). exact Hfree.
Qed.

(** Closedness is preserved by ERequire wrapper *)
Lemma closed_require_cv : forall eff e,
  closed_expr_cv (ERequire eff e) <-> closed_expr_cv e.
Proof.
  intros eff e. split; unfold closed_expr_cv; intros Hc x Hfree.
  - apply (Hc x). simpl. exact Hfree.
  - simpl in Hfree. apply (Hc x). exact Hfree.
Qed.

(** Closedness is preserved by EPerform wrapper *)
Lemma closed_perform_cv : forall eff e,
  closed_expr_cv (EPerform eff e) <-> closed_expr_cv e.
Proof.
  intros eff e. split; unfold closed_expr_cv; intros Hc x Hfree.
  - apply (Hc x). simpl. exact Hfree.
  - simpl in Hfree. apply (Hc x). exact Hfree.
Qed.

(** Closedness for handle expressions *)
Lemma closed_handle_cv : forall e y h,
  closed_expr_cv (EHandle e y h) <->
  closed_expr_cv e /\ (forall x, x <> y -> ~ free_in x h).
Proof.
  intros e y h. split.
  - intros Hc. split.
    + unfold closed_expr_cv in *. intros x Hfree.
      apply (Hc x). simpl. left. exact Hfree.
    + intros x Hneq Hfree. apply (Hc x). simpl. right. split; assumption.
  - intros [Hce Hch]. unfold closed_expr_cv. intros x Hfree.
    simpl in Hfree. destruct Hfree as [H | [Hneq H]].
    + apply (Hce x H).
    + exact (Hch x Hneq H).
Qed.

(** Closedness for declassify *)
Lemma closed_declassify_cv : forall e1 e2,
  closed_expr_cv (EDeclassify e1 e2) <-> closed_expr_cv e1 /\ closed_expr_cv e2.
Proof.
  intros e1 e2. split.
  - intros Hc. split; unfold closed_expr_cv in *; intros x Hfree;
    apply (Hc x); simpl; [left | right]; exact Hfree.
  - intros [Hc1 Hc2]. unfold closed_expr_cv in *. intros x Hfree.
    simpl in Hfree. destruct Hfree as [H | H]; [apply (Hc1 x H) | apply (Hc2 x H)].
Qed.

(** End of file - ZERO ADMITS *)

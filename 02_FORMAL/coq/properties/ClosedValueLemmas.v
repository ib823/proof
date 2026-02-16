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

(** ** Section 7: More Expression Form Decompositions *)

(** Closedness for case expressions *)
Lemma closed_case_cv : forall e y1 e1 y2 e2,
  closed_expr_cv (ECase e y1 e1 y2 e2) <->
  closed_expr_cv e /\
  (forall x, x <> y1 -> ~ free_in x e1) /\
  (forall x, x <> y2 -> ~ free_in x e2).
Proof.
  intros e y1 e1 y2 e2. split.
  - intros Hc. repeat split.
    + unfold closed_expr_cv in *. intros x Hfree.
      apply (Hc x). simpl. left. exact Hfree.
    + intros x Hneq Hfree. apply (Hc x). simpl. right. left. split; assumption.
    + intros x Hneq Hfree. apply (Hc x). simpl. right. right. split; assumption.
  - intros [Hce [Hc1 Hc2]]. unfold closed_expr_cv. intros x Hfree.
    simpl in Hfree. destruct Hfree as [H | [[Hneq H] | [Hneq H]]].
    + apply (Hce x H).
    + exact (Hc1 x Hneq H).
    + exact (Hc2 x Hneq H).
Qed.

(** Closedness for lambda (full iff decomposition) *)
Lemma closed_lam_cv : forall x T body,
  closed_expr_cv (ELam x T body) <->
  (forall y, y <> x -> ~ free_in y body).
Proof.
  intros x T body. split.
  - intros Hc y Hneq Hfree. apply (Hc y). simpl. split; assumption.
  - intros Hbody. unfold closed_expr_cv. intros y Hfree.
    simpl in Hfree. destruct Hfree as [Hneq Hfb].
    exact (Hbody y Hneq Hfb).
Qed.

(** Components of closed pair value are closed *)
Lemma closed_pair_value_components : forall a b,
  value (EPair a b) ->
  closed_expr_cv (EPair a b) ->
  closed_expr_cv a /\ closed_expr_cv b.
Proof.
  intros a b Hval Hclosed.
  apply closed_pair_cv. exact Hclosed.
Qed.

(** Inner value of closed inl is closed *)
Lemma closed_inl_value_inner : forall a T,
  value (EInl a T) ->
  closed_expr_cv (EInl a T) ->
  closed_expr_cv a.
Proof.
  intros a T Hval Hclosed.
  apply closed_inl_cv in Hclosed. exact Hclosed.
Qed.

(** Inner value of closed inr is closed *)
Lemma closed_inr_value_inner : forall b T,
  value (EInr b T) ->
  closed_expr_cv (EInr b T) ->
  closed_expr_cv b.
Proof.
  intros b T Hval Hclosed.
  apply closed_inr_cv in Hclosed. exact Hclosed.
Qed.

(** Closed expression is stable under store extension *)
Lemma closed_store_extension : forall e Σ1 Σ2 Δ T ε,
  has_type nil Σ1 Δ e T ε ->
  store_ty_extends Σ1 Σ2 ->
  closed_expr_cv e.
Proof.
  intros e Σ1 Σ2 Δ T ε Hty _.
  apply nil_ctx_is_closed with (Σ := Σ1) (Δ := Δ) (T := T) (ε := ε). exact Hty.
Qed.

(** ** Section 8: Typed Closedness Corollaries *)

(** Typed pair in nil context has closed components *)
Lemma nil_ctx_pair_closed : forall Σ Δ a b T ε,
  has_type nil Σ Δ (EPair a b) T ε ->
  closed_expr_cv a /\ closed_expr_cv b.
Proof.
  intros. apply (proj1 (closed_pair_cv a b)).
  eapply nil_ctx_is_closed; eauto.
Qed.

(** Typed inl in nil context has closed inner expression *)
Lemma nil_ctx_inl_closed : forall Σ Δ e T' T ε,
  has_type nil Σ Δ (EInl e T') T ε ->
  closed_expr_cv e.
Proof.
  intros. apply (proj1 (closed_inl_cv e T')).
  eapply nil_ctx_is_closed; eauto.
Qed.

(** Typed inr in nil context has closed inner expression *)
Lemma nil_ctx_inr_closed : forall Σ Δ e T' T ε,
  has_type nil Σ Δ (EInr e T') T ε ->
  closed_expr_cv e.
Proof.
  intros. apply (proj1 (closed_inr_cv e T')).
  eapply nil_ctx_is_closed; eauto.
Qed.

(** Classify of closed is closed — direct forward lemma *)
Lemma closed_classify_value_inner : forall v,
  closed_expr_cv (EClassify v) -> closed_expr_cv v.
Proof.
  intros v H. apply closed_classify_cv in H. exact H.
Qed.

(** Prove of closed is closed — direct forward lemma *)
Lemma closed_prove_value_inner : forall v,
  closed_expr_cv (EProve v) -> closed_expr_cv v.
Proof.
  intros v H. apply closed_prove_cv in H. exact H.
Qed.

(** End of file - ZERO ADMITS *)

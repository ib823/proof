(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * SubstitutionCommute.v

    Substitution environment definitions and SAFE lemmas.
    
    Mode: Comprehensive Verification | Zero Admits
*)

From Stdlib Require Import String.
From Stdlib Require Import Bool.
From Stdlib Require Import List.
From Stdlib Require Import Logic.FunctionalExtensionality.
Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Typing.
Import ListNotations.

(** ----------------------------------------------------------------- *)
(** * Substitution Environment Definitions (Function-Based)           *)
(** ----------------------------------------------------------------- *)

Definition subst_rho_sc := ident -> expr.
Definition id_rho_sc : subst_rho_sc := fun x => EVar x.
Definition extend_rho_sc (ρ : subst_rho_sc) (x : ident) (v : expr) : subst_rho_sc :=
  fun y => if String.eqb y x then v else ρ y.

(** ----------------------------------------------------------------- *)
(** * Basic Lemmas about extend_rho                                   *)
(** ----------------------------------------------------------------- *)

Lemma extend_rho_sc_same : forall ρ x v,
  extend_rho_sc ρ x v x = v.
Proof.
  intros ρ x v. unfold extend_rho_sc.
  rewrite String.eqb_refl. reflexivity.
Qed.

Lemma extend_rho_sc_diff : forall ρ x y v,
  x <> y -> extend_rho_sc ρ x v y = ρ y.
Proof.
  intros ρ x y v Hneq. unfold extend_rho_sc.
  destruct (String.eqb y x) eqn:Heq.
  - apply String.eqb_eq in Heq. symmetry in Heq. contradiction.
  - reflexivity.
Qed.

Lemma extend_rho_sc_shadow : forall ρ x v1 v2,
  extend_rho_sc (extend_rho_sc ρ x v1) x v2 = extend_rho_sc ρ x v2.
Proof.
  intros ρ x v1 v2. extensionality y.
  unfold extend_rho_sc. destruct (String.eqb y x); reflexivity.
Qed.

Lemma extend_rho_sc_comm : forall ρ x y vx vy,
  x <> y ->
  extend_rho_sc (extend_rho_sc ρ x vx) y vy = extend_rho_sc (extend_rho_sc ρ y vy) x vx.
Proof.
  intros ρ x y vx vy Hneq. extensionality z.
  unfold extend_rho_sc.
  destruct (String.eqb z y) eqn:Heqy; destruct (String.eqb z x) eqn:Heqx;
  try reflexivity.
  apply String.eqb_eq in Heqy. apply String.eqb_eq in Heqx.
  subst. contradiction.
Qed.

(** ----------------------------------------------------------------- *)
(** * Closed Range Definition                                         *)
(** ----------------------------------------------------------------- *)

Definition closed_expr_sc (e : expr) : Prop := forall x, ~ free_in x e.
Definition closed_rho_sc (ρ : subst_rho_sc) : Prop := forall x, closed_expr_sc (ρ x).

(** ----------------------------------------------------------------- *)
(** * Substitution Lemmas                                             *)
(** ----------------------------------------------------------------- *)

Lemma subst_not_free_sc : forall x v e,
  ~ free_in x e -> subst[x := v] e = e.
Proof.
  intros x v e Hnotfree.
  induction e; simpl; try reflexivity.
  - (* EVar i *)
    destruct (String.eqb x i) eqn:Heq.
    + apply String.eqb_eq in Heq. subst.
      exfalso. apply Hnotfree. simpl. reflexivity.
    + reflexivity.
  - (* ELam i t e *)
    destruct (String.eqb x i) eqn:Heq.
    + reflexivity.
    + f_equal. apply IHe.
      intro Hfree. apply Hnotfree. simpl. split.
      * intro Heq'. subst. rewrite String.eqb_refl in Heq. discriminate.
      * exact Hfree.
  - (* EApp *) f_equal; [apply IHe1 | apply IHe2];
      intro Hfree; apply Hnotfree; simpl; [left | right]; exact Hfree.
  - (* EPair *) f_equal; [apply IHe1 | apply IHe2];
      intro Hfree; apply Hnotfree; simpl; [left | right]; exact Hfree.
  - (* EFst *) f_equal. apply IHe. exact Hnotfree.
  - (* ESnd *) f_equal. apply IHe. exact Hnotfree.
  - (* EInl *) f_equal. apply IHe. intro Hfree. apply Hnotfree. simpl. exact Hfree.
  - (* EInr *) f_equal. apply IHe. intro Hfree. apply Hnotfree. simpl. exact Hfree.
  - (* ECase *)
    f_equal.
    + apply IHe1. intro Hfree. apply Hnotfree. simpl. left. exact Hfree.
    + destruct (String.eqb x i) eqn:Heq1; [reflexivity|].
      apply IHe2. intro Hfree. apply Hnotfree. simpl. right. left. split.
      * intro Heq'. subst. rewrite String.eqb_refl in Heq1. discriminate.
      * exact Hfree.
    + destruct (String.eqb x i0) eqn:Heq2; [reflexivity|].
      apply IHe3. intro Hfree. apply Hnotfree. simpl. right. right. split.
      * intro Heq'. subst. rewrite String.eqb_refl in Heq2. discriminate.
      * exact Hfree.
  - (* EIf *) f_equal; [apply IHe1 | apply IHe2 | apply IHe3];
      intro Hfree; apply Hnotfree; simpl; [left | right; left | right; right]; exact Hfree.
  - (* ELet *)
    f_equal.
    + apply IHe1. intro Hfree. apply Hnotfree. simpl. left. exact Hfree.
    + destruct (String.eqb x i) eqn:Heq; [reflexivity|].
      apply IHe2. intro Hfree. apply Hnotfree. simpl. right. split.
      * intro Heq'. subst. rewrite String.eqb_refl in Heq. discriminate.
      * exact Hfree.
  - (* EPerform *) f_equal. apply IHe. intro Hfree. apply Hnotfree. simpl. exact Hfree.
  - (* EHandle *)
    f_equal.
    + apply IHe1. intro Hfree. apply Hnotfree. simpl. left. exact Hfree.
    + destruct (String.eqb x i) eqn:Heq; [reflexivity|].
      apply IHe2. intro Hfree. apply Hnotfree. simpl. right. split.
      * intro Heq'. subst. rewrite String.eqb_refl in Heq. discriminate.
      * exact Hfree.
  - (* ERef *) f_equal. apply IHe. intro Hfree. apply Hnotfree. simpl. exact Hfree.
  - (* EDeref *) f_equal. apply IHe. exact Hnotfree.
  - (* EAssign *) f_equal; [apply IHe1 | apply IHe2];
      intro Hfree; apply Hnotfree; simpl; [left | right]; exact Hfree.
  - (* EClassify *) f_equal. apply IHe. intro Hfree. apply Hnotfree. simpl. exact Hfree.
  - (* EDeclassify *) f_equal; [apply IHe1 | apply IHe2];
      intro Hfree; apply Hnotfree; simpl; [left | right]; exact Hfree.
  - (* EProve *) f_equal. apply IHe. intro Hfree. apply Hnotfree. simpl. exact Hfree.
  - (* ERequire *) f_equal. apply IHe. intro Hfree. apply Hnotfree. simpl. exact Hfree.
  - (* EGrant *) f_equal. apply IHe. intro Hfree. apply Hnotfree. simpl. exact Hfree.
Qed.

Lemma subst_closed_sc : forall x v e,
  closed_expr_sc e -> subst[x := v] e = e.
Proof.
  intros x v e Hclosed. apply subst_not_free_sc. apply Hclosed.
Qed.

(** Base type closed lemmas *)
Lemma closed_unit_sub : closed_expr_sc EUnit.
Proof. unfold closed_expr_sc. intros x Hfree. simpl in Hfree. exact Hfree. Qed.

Lemma closed_bool_sub : forall b, closed_expr_sc (EBool b).
Proof. intros b. unfold closed_expr_sc. intros x Hfree. simpl in Hfree. exact Hfree. Qed.

Lemma closed_int_sub : forall n, closed_expr_sc (EInt n).
Proof. intros n. unfold closed_expr_sc. intros x Hfree. simpl in Hfree. exact Hfree. Qed.

Lemma closed_string_sub : forall s, closed_expr_sc (EString s).
Proof. intros s. unfold closed_expr_sc. intros x Hfree. simpl in Hfree. exact Hfree. Qed.

Lemma closed_loc_sub : forall l, closed_expr_sc (ELoc l).
Proof. intros l. unfold closed_expr_sc. intros x Hfree. simpl in Hfree. exact Hfree. Qed.

(** ----------------------------------------------------------------- *)
(** * Substitution on Variables                                       *)
(** ----------------------------------------------------------------- *)

(** Substituting into the same variable yields the replacement. *)
Lemma subst_var_same : forall x v,
  subst[x := v] (EVar x) = v.
Proof.
  intros x v. simpl. rewrite String.eqb_refl. reflexivity.
Qed.

(** Substituting into a different variable is the identity. *)
Lemma subst_var_diff : forall x y v,
  x <> y -> subst[x := v] (EVar y) = EVar y.
Proof.
  intros x y v Hneq. simpl.
  destruct (String.eqb x y) eqn:Heq.
  - apply String.eqb_eq in Heq. contradiction.
  - reflexivity.
Qed.

(** Substitution into base values is always the identity. *)
Lemma subst_unit : forall x v, subst[x := v] EUnit = EUnit.
Proof. intros. reflexivity. Qed.

Lemma subst_bool : forall x v b, subst[x := v] (EBool b) = EBool b.
Proof. intros. reflexivity. Qed.

Lemma subst_int : forall x v n, subst[x := v] (EInt n) = EInt n.
Proof. intros. reflexivity. Qed.

Lemma subst_string : forall x v s, subst[x := v] (EString s) = EString s.
Proof. intros. reflexivity. Qed.

Lemma subst_loc : forall x v l, subst[x := v] (ELoc l) = ELoc l.
Proof. intros. reflexivity. Qed.

(** ----------------------------------------------------------------- *)
(** * Substitution Identity                                           *)
(** ----------------------------------------------------------------- *)

(** Substituting x := EVar x is the identity on all expressions. *)
Lemma subst_id : forall x e, subst[x := EVar x] e = e.
Proof.
  intros x e. induction e; simpl; try reflexivity;
  try (f_equal; assumption);
  try (f_equal; [assumption | assumption]);
  try (f_equal; [assumption | assumption | assumption]).
  - (* EVar *) destruct (String.eqb x i) eqn:Heq.
    + apply String.eqb_eq in Heq. subst. reflexivity.
    + reflexivity.
  - (* ELam *) destruct (String.eqb x i) eqn:Heq.
    + reflexivity.
    + f_equal. exact IHe.
  - (* ECase *) f_equal; [exact IHe1 | |].
    + destruct (String.eqb x i); [reflexivity | exact IHe2].
    + destruct (String.eqb x i0); [reflexivity | exact IHe3].
  - (* ELet *) f_equal; [exact IHe1 |].
    destruct (String.eqb x i); [reflexivity | exact IHe2].
  - (* EHandle *) f_equal; [exact IHe1 |].
    destruct (String.eqb x i); [reflexivity | exact IHe2].
Qed.

(** ----------------------------------------------------------------- *)
(** * Values are Closed under Substitution                            *)
(** ----------------------------------------------------------------- *)

(** Substitution preserves the value predicate. *)
Lemma subst_value : forall x v e,
  value e -> value v -> value (subst[x := v] e).
Proof.
  intros x v e Hval_e Hval_v.
  induction Hval_e; simpl.
  - (* VUnit *) constructor.
  - (* VBool *) constructor.
  - (* VInt *) constructor.
  - (* VString *) constructor.
  - (* VLoc *) constructor.
  - (* VLam *) destruct (String.eqb x x0); constructor.
  - (* VPair *) constructor; auto.
  - (* VInl *) constructor. auto.
  - (* VInr *) constructor. auto.
  - (* VClassify *) constructor. auto.
  - (* VProve *) constructor. auto.
Qed.

(** ----------------------------------------------------------------- *)
(** * Structural Substitution Lemmas                                 *)
(** ----------------------------------------------------------------- *)

(** Substitution distributes over application. *)
Lemma subst_app : forall x v e1 e2,
  subst[x := v] (EApp e1 e2) = EApp (subst[x := v] e1) (subst[x := v] e2).
Proof. intros. reflexivity. Qed.

(** Substitution distributes over pair. *)
Lemma subst_pair : forall x v e1 e2,
  subst[x := v] (EPair e1 e2) = EPair (subst[x := v] e1) (subst[x := v] e2).
Proof. intros. reflexivity. Qed.

(** Substitution distributes over fst/snd. *)
Lemma subst_fst : forall x v e,
  subst[x := v] (EFst e) = EFst (subst[x := v] e).
Proof. intros. reflexivity. Qed.

Lemma subst_snd : forall x v e,
  subst[x := v] (ESnd e) = ESnd (subst[x := v] e).
Proof. intros. reflexivity. Qed.

(** Substitution distributes over injection. *)
Lemma subst_inl : forall x v e T,
  subst[x := v] (EInl e T) = EInl (subst[x := v] e) T.
Proof. intros. reflexivity. Qed.

Lemma subst_inr : forall x v e T,
  subst[x := v] (EInr e T) = EInr (subst[x := v] e) T.
Proof. intros. reflexivity. Qed.

(** Substitution distributes over if. *)
Lemma subst_if : forall x v e1 e2 e3,
  subst[x := v] (EIf e1 e2 e3) = EIf (subst[x := v] e1) (subst[x := v] e2) (subst[x := v] e3).
Proof. intros. reflexivity. Qed.

(** Substitution distributes over ref/deref/assign. *)
Lemma subst_ref : forall x v e sl,
  subst[x := v] (ERef e sl) = ERef (subst[x := v] e) sl.
Proof. intros. reflexivity. Qed.

Lemma subst_deref : forall x v e,
  subst[x := v] (EDeref e) = EDeref (subst[x := v] e).
Proof. intros. reflexivity. Qed.

Lemma subst_assign : forall x v e1 e2,
  subst[x := v] (EAssign e1 e2) = EAssign (subst[x := v] e1) (subst[x := v] e2).
Proof. intros. reflexivity. Qed.

(** Substitution distributes over classify/prove. *)
Lemma subst_classify : forall x v e,
  subst[x := v] (EClassify e) = EClassify (subst[x := v] e).
Proof. intros. reflexivity. Qed.

Lemma subst_prove : forall x v e,
  subst[x := v] (EProve e) = EProve (subst[x := v] e).
Proof. intros. reflexivity. Qed.

(** Substitution distributes over declassify. *)
Lemma subst_declassify : forall x v e1 e2,
  subst[x := v] (EDeclassify e1 e2) = EDeclassify (subst[x := v] e1) (subst[x := v] e2).
Proof. intros. reflexivity. Qed.

(** Substitution distributes over effect operations. *)
Lemma subst_perform : forall x v eff e,
  subst[x := v] (EPerform eff e) = EPerform eff (subst[x := v] e).
Proof. intros. reflexivity. Qed.

Lemma subst_require : forall x v eff e,
  subst[x := v] (ERequire eff e) = ERequire eff (subst[x := v] e).
Proof. intros. reflexivity. Qed.

Lemma subst_grant : forall x v eff e,
  subst[x := v] (EGrant eff e) = EGrant eff (subst[x := v] e).
Proof. intros. reflexivity. Qed.

(** ----------------------------------------------------------------- *)
(** * Lambda Substitution Properties                                  *)
(** ----------------------------------------------------------------- *)

(** Substituting into a lambda with the same binder is the identity. *)
Lemma subst_lam_same : forall x T body v,
  subst[x := v] (ELam x T body) = ELam x T body.
Proof.
  intros x T body v. simpl. rewrite String.eqb_refl. reflexivity.
Qed.

(** Substituting into a lambda with a different binder descends into the body. *)
Lemma subst_lam_diff : forall x y T body v,
  x <> y ->
  subst[x := v] (ELam y T body) = ELam y T (subst[x := v] body).
Proof.
  intros x y T body v Hneq. simpl.
  destruct (String.eqb x y) eqn:Heq.
  - apply String.eqb_eq in Heq. contradiction.
  - reflexivity.
Qed.

(** Substituting into a let with the same binder only affects the binding. *)
Lemma subst_let_same : forall x e1 e2 v,
  subst[x := v] (ELet x e1 e2) = ELet x (subst[x := v] e1) e2.
Proof.
  intros x e1 e2 v. simpl. rewrite String.eqb_refl. reflexivity.
Qed.

(** Substituting into a let with a different binder descends into both. *)
Lemma subst_let_diff : forall x y e1 e2 v,
  x <> y ->
  subst[x := v] (ELet y e1 e2) = ELet y (subst[x := v] e1) (subst[x := v] e2).
Proof.
  intros x y e1 e2 v Hneq. simpl.
  destruct (String.eqb x y) eqn:Heq.
  - apply String.eqb_eq in Heq. contradiction.
  - reflexivity.
Qed.

(** ----------------------------------------------------------------- *)
(** * Handle Substitution Properties                                 *)
(** ----------------------------------------------------------------- *)

(** Substituting into a handle with the same binder only affects the body. *)
Lemma subst_handle_same : forall x e h v,
  subst[x := v] (EHandle e x h) = EHandle (subst[x := v] e) x h.
Proof.
  intros x e h v. simpl. rewrite String.eqb_refl. reflexivity.
Qed.

(** Substituting into a handle with a different binder descends into both. *)
Lemma subst_handle_diff : forall x y e h v,
  x <> y ->
  subst[x := v] (EHandle e y h) = EHandle (subst[x := v] e) y (subst[x := v] h).
Proof.
  intros x y e h v Hneq. simpl.
  destruct (String.eqb x y) eqn:Heq.
  - apply String.eqb_eq in Heq. contradiction.
  - reflexivity.
Qed.

(** ----------------------------------------------------------------- *)
(** * Case Substitution Properties                                   *)
(** ----------------------------------------------------------------- *)

(** Substituting into a case with the same binder for left branch. *)
Lemma subst_case_same_left : forall x e y e2 e3 v,
  subst[x := v] (ECase e x e2 y e3) = ECase (subst[x := v] e) x e2 y (if String.eqb x y then e3 else subst[x := v] e3).
Proof.
  intros x e y e2 e3 v. simpl. rewrite String.eqb_refl. reflexivity.
Qed.

(** ----------------------------------------------------------------- *)
(** * id_rho Properties                                               *)
(** ----------------------------------------------------------------- *)

(** Identity rho is closed iff all variables are closed (trivially false for open vars) *)
Lemma id_rho_sc_identity : forall x, id_rho_sc x = EVar x.
Proof. intros x. unfold id_rho_sc. reflexivity. Qed.

(** Extending id_rho with a value gives the value at that point *)
Lemma extend_id_rho_sc_at : forall x v,
  extend_rho_sc id_rho_sc x v x = v.
Proof. intros. apply extend_rho_sc_same. Qed.

(** Extending id_rho with a value leaves other variables unchanged *)
Lemma extend_id_rho_sc_other : forall x y v,
  x <> y -> extend_rho_sc id_rho_sc x v y = EVar y.
Proof.
  intros x y v Hneq. unfold extend_rho_sc.
  destruct (String.eqb y x) eqn:Heq.
  - apply String.eqb_eq in Heq. symmetry in Heq. contradiction.
  - unfold id_rho_sc. reflexivity.
Qed.

(** ----------------------------------------------------------------- *)
(** * Double Substitution Properties                                 *)
(** ----------------------------------------------------------------- *)

(** Substituting into a value-variable pair *)
Lemma subst_var_eqb : forall x y v,
  subst[x := v] (EVar y) = if String.eqb x y then v else EVar y.
Proof.
  intros. simpl. reflexivity.
Qed.

(** ----------------------------------------------------------------- *)
(** * Closedness for Compound Values                                 *)
(** ----------------------------------------------------------------- *)

Lemma closed_pair_sub : forall e1 e2,
  closed_expr_sc e1 -> closed_expr_sc e2 -> closed_expr_sc (EPair e1 e2).
Proof.
  intros e1 e2 H1 H2 x Hfree. simpl in Hfree.
  destruct Hfree as [Hf | Hf]; [apply (H1 x) | apply (H2 x)]; exact Hf.
Qed.

Lemma closed_inl_sub : forall e T,
  closed_expr_sc e -> closed_expr_sc (EInl e T).
Proof.
  intros e T H x Hfree. simpl in Hfree. apply (H x). exact Hfree.
Qed.

Lemma closed_inr_sub : forall e T,
  closed_expr_sc e -> closed_expr_sc (EInr e T).
Proof.
  intros e T H x Hfree. simpl in Hfree. apply (H x). exact Hfree.
Qed.

Lemma closed_classify_sub : forall e,
  closed_expr_sc e -> closed_expr_sc (EClassify e).
Proof.
  intros e H x Hfree. simpl in Hfree. apply (H x). exact Hfree.
Qed.

Lemma closed_prove_sub : forall e,
  closed_expr_sc e -> closed_expr_sc (EProve e).
Proof.
  intros e H x Hfree. simpl in Hfree. apply (H x). exact Hfree.
Qed.

Lemma closed_fst_sub : forall e,
  closed_expr_sc e -> closed_expr_sc (EFst e).
Proof.
  intros e H x Hfree. simpl in Hfree. apply (H x). exact Hfree.
Qed.

(** End of file - ZERO ADMITS *)

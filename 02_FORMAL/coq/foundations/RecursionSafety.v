(* ========================================================================= *)
(* RecursionSafety.v — type safety of general recursion (fix)                *)
(*                                                                           *)
(* REQ-44 (recursion / forward-reference parity gap).                        *)
(*                                                                           *)
(* The core RIINA calculus in foundations/Syntax.v has NO primitive          *)
(* recursion construct (ELam/EApp/ELet only), yet the Rust implementation    *)
(* desugars every `fungsi` to `Expr::LetRec` — so the recursion typing rule  *)
(* was not individually mechanized. This file closes the *typing-rule*       *)
(* half of that gap in a focused, self-contained call-by-value STLC extended *)
(* with a general fixpoint `fix`, proving the two safety theorems the        *)
(* implementation's recursion relies on:                                     *)
(*                                                                           *)
(*   - progress     : a well-typed closed term is a value or steps           *)
(*   - preservation : a step preserves the type                              *)
(*                                                                           *)
(* `LetRec f = lam in cont` desugars to `let f = fix (\f. lam) in cont`, so  *)
(* proving `fix` sound mechanizes the rule the implementation uses.          *)
(*                                                                           *)
(* SCOPE (honest, per Zero-Trust). This is a REPRESENTATIVE calculus, not    *)
(* the full RIINA effect/IFC/ref core. It does NOT:                          *)
(*   (a) integrate `fix` into foundations/Syntax.v (a ~47-file ripple), nor  *)
(*   (b) touch strong normalization — general recursion is INCOMPATIBLE with *)
(*       termination/ReducibilityFull.v's SN theorem; re-scoping SN to the   *)
(*       recursion-free fragment is an owner claims-decision (REQ-44), not   *)
(*       made here, nor                                                      *)
(*   (c) migrate non-interference to a step-indexed relation.                *)
(* It mechanizes "the recursion typing rule is type-safe" — the bounded,     *)
(* decision-free first step of REQ-44's Coq-first sequence.                  *)
(* ========================================================================= *)

From Stdlib Require Import Strings.String.

(* ----- Types ----- *)
Inductive ty : Type :=
  | Ty_Bool : ty
  | Ty_Arrow : ty -> ty -> ty.

(* ----- Terms ----- *)
Inductive tm : Type :=
  | tm_var : string -> tm
  | tm_app : tm -> tm -> tm
  | tm_abs : string -> ty -> tm -> tm
  | tm_true : tm
  | tm_false : tm
  | tm_if : tm -> tm -> tm -> tm
  | tm_fix : tm -> tm.

(* ----- Values ----- *)
Inductive value : tm -> Prop :=
  | v_abs : forall x T t, value (tm_abs x T t)
  | v_true : value tm_true
  | v_false : value tm_false.

#[local] Hint Constructors value : core.

(* ----- Capture-avoiding-enough substitution -----
   We only ever substitute closed values (in the preservation proof), so the
   naive structural substitution does not capture. *)
Fixpoint subst (x : string) (s : tm) (t : tm) : tm :=
  match t with
  | tm_var y => if String.eqb x y then s else t
  | tm_abs y T t1 => tm_abs y T (if String.eqb x y then t1 else subst x s t1)
  | tm_app t1 t2 => tm_app (subst x s t1) (subst x s t2)
  | tm_true => tm_true
  | tm_false => tm_false
  | tm_if c t1 t2 => tm_if (subst x s c) (subst x s t1) (subst x s t2)
  | tm_fix t1 => tm_fix (subst x s t1)
  end.

Notation "'[' x ':=' s ']' t" := (subst x s t) (at level 20).

(* ----- Small-step call-by-value semantics ----- *)
Reserved Notation "t '-->' t'" (at level 40).
Inductive step : tm -> tm -> Prop :=
  | ST_AppAbs : forall x T t12 v2,
      value v2 ->
      tm_app (tm_abs x T t12) v2 --> [x := v2] t12
  | ST_App1 : forall t1 t1' t2,
      t1 --> t1' ->
      tm_app t1 t2 --> tm_app t1' t2
  | ST_App2 : forall v1 t2 t2',
      value v1 ->
      t2 --> t2' ->
      tm_app v1 t2 --> tm_app v1 t2'
  | ST_IfTrue : forall t1 t2,
      tm_if tm_true t1 t2 --> t1
  | ST_IfFalse : forall t1 t2,
      tm_if tm_false t1 t2 --> t2
  | ST_If : forall c c' t1 t2,
      c --> c' ->
      tm_if c t1 t2 --> tm_if c' t1 t2
  (* fix of a lambda unrolls by substituting the whole fix for the rec var *)
  | ST_FixAbs : forall x T t1,
      tm_fix (tm_abs x T t1) --> [x := tm_fix (tm_abs x T t1)] t1
  | ST_Fix : forall t1 t1',
      t1 --> t1' ->
      tm_fix t1 --> tm_fix t1'
where "t '-->' t'" := (step t t').

#[local] Hint Constructors step : core.

(* ----- Typing context: a function-based partial map ----- *)
Definition context := string -> option ty.
Definition empty : context := fun _ => None.
Definition update (Gamma : context) (x : string) (T : ty) : context :=
  fun y => if String.eqb x y then Some T else Gamma y.

(* Map lemmas. *)
Lemma update_eq : forall Gamma x T, (update Gamma x T) x = Some T.
Proof. intros. unfold update. rewrite String.eqb_refl. reflexivity. Qed.

Lemma update_neq : forall Gamma x1 x2 T,
  x1 <> x2 -> (update Gamma x2 T) x1 = Gamma x1.
Proof.
  intros Gamma x1 x2 T H. unfold update.
  destruct (String.eqb x2 x1) eqn:E.
  - apply String.eqb_eq in E. subst. contradiction.
  - reflexivity.
Qed.

Lemma update_shadow : forall Gamma x T1 T2 y,
  (update (update Gamma x T1) x T2) y = (update Gamma x T2) y.
Proof.
  intros. unfold update. destruct (String.eqb x y); reflexivity.
Qed.

Lemma update_permute : forall Gamma x1 x2 T1 T2 y,
  x1 <> x2 ->
  (update (update Gamma x1 T1) x2 T2) y = (update (update Gamma x2 T2) x1 T1) y.
Proof.
  intros Gamma x1 x2 T1 T2 y Hneq. unfold update.
  destruct (String.eqb x2 y) eqn:E2; destruct (String.eqb x1 y) eqn:E1; try reflexivity.
  apply String.eqb_eq in E2. apply String.eqb_eq in E1. subst. contradiction.
Qed.

(* ----- Typing relation ----- *)
Inductive has_type : context -> tm -> ty -> Prop :=
  | T_Var : forall Gamma x T,
      Gamma x = Some T ->
      has_type Gamma (tm_var x) T
  | T_Abs : forall Gamma x T1 T2 t1,
      has_type (update Gamma x T1) t1 T2 ->
      has_type Gamma (tm_abs x T1 t1) (Ty_Arrow T1 T2)
  | T_App : forall Gamma T1 T2 t1 t2,
      has_type Gamma t1 (Ty_Arrow T1 T2) ->
      has_type Gamma t2 T1 ->
      has_type Gamma (tm_app t1 t2) T2
  | T_True : forall Gamma, has_type Gamma tm_true Ty_Bool
  | T_False : forall Gamma, has_type Gamma tm_false Ty_Bool
  | T_If : forall Gamma c t1 t2 T,
      has_type Gamma c Ty_Bool ->
      has_type Gamma t1 T ->
      has_type Gamma t2 T ->
      has_type Gamma (tm_if c t1 t2) T
  (* THE recursion rule: fix of a self-map T->T has type T. *)
  | T_Fix : forall Gamma t1 T,
      has_type Gamma t1 (Ty_Arrow T T) ->
      has_type Gamma (tm_fix t1) T.

#[local] Hint Constructors has_type : core.

(* ----- Canonical forms ----- *)
Lemma canonical_forms_bool : forall t,
  has_type empty t Ty_Bool -> value t -> (t = tm_true) \/ (t = tm_false).
Proof.
  intros t HT HV. destruct HV; auto; inversion HT.
Qed.

Lemma canonical_forms_fun : forall t T1 T2,
  has_type empty t (Ty_Arrow T1 T2) -> value t ->
  exists x u, t = tm_abs x T1 u.
Proof.
  intros t T1 T2 HT HV. destruct HV as [x T body | | ]; inversion HT; subst.
  exists x, body. reflexivity.
Qed.

(* ----- Progress ----- *)
Theorem progress : forall t T,
  has_type empty t T ->
  value t \/ exists t', t --> t'.
Proof.
  intros t T HT.
  remember empty as Gamma.
  induction HT; subst.
  - (* T_Var: impossible in empty *) discriminate H.
  - (* T_Abs *) left. apply v_abs.
  - (* T_App *)
    right. destruct IHHT1 as [Hv1 | [t1' Hs1]]; auto.
    + destruct IHHT2 as [Hv2 | [t2' Hs2]]; auto.
      * destruct (canonical_forms_fun t1 T1 T2 HT1 Hv1) as [x [u Heq]].
        subst. exists ([x := t2] u). apply ST_AppAbs. assumption.
      * exists (tm_app t1 t2'). apply ST_App2; assumption.
    + exists (tm_app t1' t2). apply ST_App1; assumption.
  - (* T_True *) left. apply v_true.
  - (* T_False *) left. apply v_false.
  - (* T_If *)
    right. destruct IHHT1 as [Hv | [c' Hs]]; auto.
    + destruct (canonical_forms_bool c HT1 Hv) as [Ht | Hf]; subst.
      * exists t1. apply ST_IfTrue.
      * exists t2. apply ST_IfFalse.
    + exists (tm_if c' t1 t2). apply ST_If; assumption.
  - (* T_Fix *)
    right. destruct IHHT as [Hv | [t1' Hs]]; auto.
    + destruct (canonical_forms_fun t1 T T HT Hv) as [x [u Heq]]. subst.
      exists ([x := tm_fix (tm_abs x T u)] u). apply ST_FixAbs.
    + exists (tm_fix t1'). apply ST_Fix; assumption.
Qed.

(* ----- Weakening / context invariance ----- *)
(* Free-variable occurrence, to state context_invariance. *)
Inductive appears_free_in : string -> tm -> Prop :=
  | afi_var : forall x, appears_free_in x (tm_var x)
  | afi_app1 : forall x t1 t2, appears_free_in x t1 -> appears_free_in x (tm_app t1 t2)
  | afi_app2 : forall x t1 t2, appears_free_in x t2 -> appears_free_in x (tm_app t1 t2)
  | afi_abs : forall x y S t, y <> x -> appears_free_in x t -> appears_free_in x (tm_abs y S t)
  | afi_if1 : forall x c t1 t2, appears_free_in x c -> appears_free_in x (tm_if c t1 t2)
  | afi_if2 : forall x c t1 t2, appears_free_in x t1 -> appears_free_in x (tm_if c t1 t2)
  | afi_if3 : forall x c t1 t2, appears_free_in x t2 -> appears_free_in x (tm_if c t1 t2)
  | afi_fix : forall x t1, appears_free_in x t1 -> appears_free_in x (tm_fix t1).

#[local] Hint Constructors appears_free_in : core.

Lemma context_invariance : forall Gamma Gamma' t T,
  has_type Gamma t T ->
  (forall x, appears_free_in x t -> Gamma x = Gamma' x) ->
  has_type Gamma' t T.
Proof.
  intros Gamma Gamma' t T HT. generalize dependent Gamma'.
  induction HT; intros Gamma' Hfree.
  - apply T_Var. rewrite <- Hfree; auto.
  - apply T_Abs. apply IHHT. intros y Hafi.
    unfold update. destruct (String.eqb x y) eqn:E.
    + reflexivity.
    + apply Hfree. apply afi_abs.
      * apply String.eqb_neq. exact E.
      * exact Hafi.
  - eapply T_App; [apply IHHT1 | apply IHHT2]; intros; apply Hfree; auto.
  - apply T_True.
  - apply T_False.
  - apply T_If; [apply IHHT1 | apply IHHT2 | apply IHHT3]; intros; apply Hfree; auto.
  - apply T_Fix. apply IHHT. intros; apply Hfree; auto.
Qed.

Lemma free_in_context : forall x t T Gamma,
  appears_free_in x t -> has_type Gamma t T -> exists T', Gamma x = Some T'.
Proof.
  intros x t T Gamma Hafi. generalize dependent T. generalize dependent Gamma.
  induction Hafi; intros Gamma T HT; inversion HT; subst.
  - (* afi_var *) exists T. assumption.
  - (* afi_app1 *) eapply IHHafi; eauto.
  - (* afi_app2 *) eapply IHHafi; eauto.
  - (* afi_abs *)
    edestruct IHHafi as [T' HT']; eauto.
    rewrite update_neq in HT'.
    + exists T'. exact HT'.
    + intro Heq. subst. congruence.
  - (* afi_if1 *) eapply IHHafi; eauto.
  - (* afi_if2 *) eapply IHHafi; eauto.
  - (* afi_if3 *) eapply IHHafi; eauto.
  - (* afi_fix *) eapply IHHafi; eauto.
Qed.

(* Typing under empty is closed. *)
Corollary typable_empty_closed : forall t T,
  has_type empty t T -> forall x, ~ appears_free_in x t.
Proof.
  intros t T HT x Hcontra.
  destruct (free_in_context x t T empty Hcontra HT) as [T' HT'].
  discriminate HT'.
Qed.

(* ----- Substitution preserves typing ----- *)
Lemma substitution_preserves_typing : forall Gamma x U t v T,
  has_type (update Gamma x U) t T ->
  has_type empty v U ->
  has_type Gamma ([x := v] t) T.
Proof.
  intros Gamma x U t v T Ht Hv.
  generalize dependent Gamma. generalize dependent T.
  induction t; intros T Gamma Ht; simpl; inversion Ht; subst.
  - (* tm_var s *)
    destruct (String.eqb x s) eqn:E.
    + apply String.eqb_eq in E. subst.
      rewrite update_eq in H1. injection H1 as Heq. subst.
      eapply context_invariance; [apply Hv|].
      intros x0 Hcontra. exfalso. exact (typable_empty_closed v _ Hv x0 Hcontra).
    + apply String.eqb_neq in E. apply T_Var. rewrite update_neq in H1; auto.
  - (* tm_app *) eapply T_App; eauto.
  - (* tm_abs s t0 *)
    rename s into y. apply T_Abs.
    destruct (String.eqb x y) eqn:E.
    + apply String.eqb_eq in E. subst.
      eapply context_invariance; [apply H4|].
      intros z Hafi. rewrite update_shadow. reflexivity.
    + apply String.eqb_neq in E. apply IHt.
      eapply context_invariance; [apply H4|].
      intros z Hafi. apply update_permute. auto.
  - (* tm_true *) apply T_True.
  - (* tm_false *) apply T_False.
  - (* tm_if *) apply T_If; eauto.
  - (* tm_fix *) apply T_Fix. eauto.
Qed.

(* ----- Preservation ----- *)
Theorem preservation : forall t t' T,
  has_type empty t T ->
  t --> t' ->
  has_type empty t' T.
Proof.
  intros t t' T HT. generalize dependent t'.
  remember empty as Gamma.
  induction HT; subst; intros t' Hstep; inversion Hstep; subst.
  - (* T_App / ST_AppAbs *)
    inversion HT1; subst.
    eapply substitution_preserves_typing; eauto.
  - (* T_App / ST_App1 *) eapply T_App; eauto.
  - (* T_App / ST_App2 *) eapply T_App; eauto.
  - (* T_If / ST_IfTrue *) assumption.
  - (* T_If / ST_IfFalse *) assumption.
  - (* T_If / ST_If *) apply T_If; eauto.
  - (* T_Fix / ST_FixAbs *)
    inversion HT; subst.
    eapply substitution_preserves_typing; eauto.
  - (* T_Fix / ST_Fix *) apply T_Fix; eauto.
Qed.

(* ----- Type safety capstone: a well-typed term never gets stuck ----- *)
Reserved Notation "t '-->*' t'" (at level 40).
Inductive multistep : tm -> tm -> Prop :=
  | multi_refl : forall t, t -->* t
  | multi_step : forall t1 t2 t3, t1 --> t2 -> t2 -->* t3 -> t1 -->* t3
where "t '-->*' t'" := (multistep t t').

Definition stuck (t : tm) : Prop := (~ exists t', t --> t') /\ ~ value t.

Theorem type_safety : forall t t' T,
  has_type empty t T ->
  t -->* t' ->
  ~ stuck t'.
Proof.
  intros t t' T HT Hms. induction Hms.
  - (* refl *) intros [Hnf Hnv].
    destruct (progress t T HT) as [Hv | Hs]; auto.
  - (* step *) apply IHHms. eapply preservation; eauto.
Qed.

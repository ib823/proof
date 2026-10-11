(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * Strong normalization for the reference-free core (REQ-84)

    [termination/ReducibilityFull.v]'s [well_typed_SN] cannot be repaired by
    weakening its premises: its CONCLUSION is false for the calculus
    ([well_typed_SN_conclusion_is_false], Landin's knot through a higher-order
    reference). This file proves the strongest honest statement in its place,
    with NO premises beyond the fragment: every well-typed term of the
    reference-free, fixpoint-free core terminates — in every store and effect
    context it evaluates to a value without touching the store — and is
    therefore strongly normalizing.

    Method: a unary Tait-style logical relation on closed values ([RV]),
    indexed by type, with closed-term multi-substitution (the Software
    Foundations [Norm.v] recipe). Evaluation is deterministic
    ([step_deterministic_cfg]), so reaching a value implies [Acc step_inv].

    Mode: Zero Trust — 0 Admitted, 0 Axiom, no Section Hypotheses. *)

From Stdlib Require Import Strings.String.
From Stdlib Require Import Lists.List.
From Stdlib Require Import Bool.Bool.
From Stdlib Require Import Arith.PeanoNat.
Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Semantics.
Require Import RIINA.foundations.Typing.
Require Import RIINA.type_system.Preservation.
Require Import RIINA.termination.ReducibilityFull.
Import ListNotations.

(** ** 1. The fragment: no references, no locations, no fixpoints *)

Fixpoint ref_free (e : expr) : Prop :=
  match e with
  | EUnit | EBool _ | EInt _ | EString _ | EVar _ => True
  | ELoc _ => False
  | ELam _ _ b => ref_free b
  | EApp a b => ref_free a /\ ref_free b
  | EPair a b => ref_free a /\ ref_free b
  | EFst a => ref_free a
  | ESnd a => ref_free a
  | EInl a _ => ref_free a
  | EInr a _ => ref_free a
  | ECase a _ b _ c => ref_free a /\ ref_free b /\ ref_free c
  | EIf a b c => ref_free a /\ ref_free b /\ ref_free c
  | ELet _ a b => ref_free a /\ ref_free b
  | EPerform _ a => ref_free a
  | EHandle a _ b => ref_free a /\ ref_free b
  | ERef _ _ => False
  | EDeref _ => False
  | EAssign _ _ => False
  | EClassify a => ref_free a
  | EDeclassify a b => ref_free a /\ ref_free b
  | EProve a => ref_free a
  | EFix _ => False
  | ERequire _ a => ref_free a
  | EGrant _ a => ref_free a
  end.

(** ** 2. Closed terms and single substitution *)

Definition closed_e (e : expr) : Prop := forall x, ~ free_in x e.

Ltac eqb_cases :=
  repeat match goal with
         | |- context [String.eqb ?a ?b] =>
             let E := fresh "E" in
             destruct (String.eqb a b) eqn:E;
             [apply String.eqb_eq in E; subst | apply String.eqb_neq in E]
         end.

Lemma subst_not_free : forall x v e, ~ free_in x e -> subst x v e = e.
Proof.
  intros x v e. induction e; simpl; intros Hnf; eqb_cases;
    try reflexivity; try (exfalso; apply Hnf; reflexivity);
    f_equal; try (first [apply IHe | apply IHe1 | apply IHe2 | apply IHe3]);
    intro Hf; apply Hnf; tauto.
Qed.

(** With a closed value, substitution creates no new free variables and
    removes the substituted one. *)
Lemma free_in_subst_closed : forall x v e y,
  closed_e v -> free_in y (subst x v e) -> free_in y e /\ y <> x.
Proof.
  intros x v e y Hv. induction e; simpl; eqb_cases; simpl; intros Hf;
    try (exfalso; exact (Hv y Hf)); try tauto;
    try (subst; split; [reflexivity | intro; subst; contradiction]);
    try (match goal with
         | IH : free_in _ (subst _ _ ?e0) -> _ |- _ => idtac
         end);
    firstorder.
Qed.

Lemma subst_removes : forall x v e, closed_e v -> ~ free_in x (subst x v e).
Proof.
  intros x v e Hv Hf. destruct (free_in_subst_closed x v e x Hv Hf) as [_ H].
  apply H. reflexivity.
Qed.

Lemma duplicate_subst : forall x v w e,
  closed_e v -> subst x w (subst x v e) = subst x v e.
Proof.
  intros x v w e Hv. apply subst_not_free. apply subst_removes. exact Hv.
Qed.

Lemma closed_subst_id : forall x v e, closed_e e -> subst x v e = e.
Proof. intros x v e He. apply subst_not_free. apply He. Qed.

Lemma swap_subst : forall x y v w e,
  x <> y -> closed_e v -> closed_e w ->
  subst x v (subst y w e) = subst y w (subst x v e).
Proof.
  intros x y v w e Hxy Hv Hw. induction e; simpl; eqb_cases; simpl; eqb_cases;
    try reflexivity; try congruence;
    try (rewrite closed_subst_id by assumption; reflexivity);
    f_equal; assumption.
Qed.

(** ** 3. Multi-substitution by closed values *)

Definition env := list (ident * expr).

Fixpoint msubst (ss : env) (e : expr) : expr :=
  match ss with
  | nil => e
  | (x, v) :: ss' => msubst ss' (subst x v e)
  end.

Definition drop (x : ident) (ss : env) : env :=
  filter (fun p => negb (String.eqb (fst p) x)) ss.

Fixpoint lookup_env (x : ident) (ss : env) : option expr :=
  match ss with
  | nil => None
  | (y, v) :: ss' => if String.eqb x y then Some v else lookup_env x ss'
  end.

Definition closed_env (ss : env) : Prop := forall x v, In (x, v) ss -> closed_e v.

Lemma closed_env_cons : forall x v ss,
  closed_env ((x, v) :: ss) -> closed_e v /\ closed_env ss.
Proof.
  intros x v ss H. split.
  - apply (H x v). left. reflexivity.
  - intros y w Hin. apply (H y w). right. exact Hin.
Qed.

Lemma closed_env_drop : forall x ss, closed_env ss -> closed_env (drop x ss).
Proof.
  intros x ss H y w Hin. unfold drop in Hin. apply filter_In in Hin.
  apply (H y w). tauto.
Qed.

Lemma msubst_closed : forall ss e, closed_e e -> msubst ss e = e.
Proof.
  induction ss as [| [x v] ss IH]; intros e He; simpl.
  - reflexivity.
  - rewrite closed_subst_id by exact He. apply IH. exact He.
Qed.

(** Structural equations. *)
Ltac msubst_struct :=
  let ss := fresh "ss" in let x := fresh "x" in let v := fresh "v" in
  let IH := fresh "IH" in
  intro ss; induction ss as [| [x v] ss IH]; intros; simpl; [reflexivity | ];
  rewrite IH; reflexivity.

Lemma msubst_unit : forall ss, msubst ss EUnit = EUnit.
Proof. induction ss as [| [x v] ss IH]; simpl; auto. Qed.
Lemma msubst_bool : forall ss b, msubst ss (EBool b) = EBool b.
Proof. induction ss as [| [x v] ss IH]; simpl; auto. Qed.
Lemma msubst_int : forall ss n, msubst ss (EInt n) = EInt n.
Proof. induction ss as [| [x v] ss IH]; simpl; auto. Qed.
Lemma msubst_string : forall ss s, msubst ss (EString s) = EString s.
Proof. induction ss as [| [x v] ss IH]; simpl; auto. Qed.
Lemma msubst_app : forall ss a b, msubst ss (EApp a b) = EApp (msubst ss a) (msubst ss b).
Proof. msubst_struct. Qed.
Lemma msubst_pair : forall ss a b, msubst ss (EPair a b) = EPair (msubst ss a) (msubst ss b).
Proof. msubst_struct. Qed.
Lemma msubst_fst : forall ss a, msubst ss (EFst a) = EFst (msubst ss a).
Proof. msubst_struct. Qed.
Lemma msubst_snd : forall ss a, msubst ss (ESnd a) = ESnd (msubst ss a).
Proof. msubst_struct. Qed.
Lemma msubst_inl : forall ss a T, msubst ss (EInl a T) = EInl (msubst ss a) T.
Proof. msubst_struct. Qed.
Lemma msubst_inr : forall ss a T, msubst ss (EInr a T) = EInr (msubst ss a) T.
Proof. msubst_struct. Qed.
Lemma msubst_if : forall ss a b c, msubst ss (EIf a b c) = EIf (msubst ss a) (msubst ss b) (msubst ss c).
Proof. msubst_struct. Qed.
Lemma msubst_perform : forall ss f a, msubst ss (EPerform f a) = EPerform f (msubst ss a).
Proof. msubst_struct. Qed.
Lemma msubst_classify : forall ss a, msubst ss (EClassify a) = EClassify (msubst ss a).
Proof. msubst_struct. Qed.
Lemma msubst_declassify : forall ss a b, msubst ss (EDeclassify a b) = EDeclassify (msubst ss a) (msubst ss b).
Proof. msubst_struct. Qed.
Lemma msubst_prove : forall ss a, msubst ss (EProve a) = EProve (msubst ss a).
Proof. msubst_struct. Qed.
Lemma msubst_require : forall ss f a, msubst ss (ERequire f a) = ERequire f (msubst ss a).
Proof. msubst_struct. Qed.
Lemma msubst_grant : forall ss f a, msubst ss (EGrant f a) = EGrant f (msubst ss a).
Proof. msubst_struct. Qed.

Lemma msubst_lam : forall ss y T b,
  msubst ss (ELam y T b) = ELam y T (msubst (drop y ss) b).
Proof.
  induction ss as [| [x v] ss IH]; intros y T b; simpl; [reflexivity |].
  unfold drop at 1; simpl. eqb_cases; simpl; rewrite IH; reflexivity.
Qed.

Lemma msubst_let : forall ss y a b,
  msubst ss (ELet y a b) = ELet y (msubst ss a) (msubst (drop y ss) b).
Proof.
  induction ss as [| [x v] ss IH]; intros y a b; simpl; [reflexivity |].
  unfold drop at 1; simpl. eqb_cases; simpl; rewrite IH; reflexivity.
Qed.

Lemma msubst_handle : forall ss a y h,
  msubst ss (EHandle a y h) = EHandle (msubst ss a) y (msubst (drop y ss) h).
Proof.
  induction ss as [| [x v] ss IH]; intros a y h; simpl; [reflexivity |].
  unfold drop at 1; simpl. eqb_cases; simpl; rewrite IH; reflexivity.
Qed.

Lemma msubst_case : forall ss a y1 b y2 c,
  msubst ss (ECase a y1 b y2 c) =
  ECase (msubst ss a) y1 (msubst (drop y1 ss) b) y2 (msubst (drop y2 ss) c).
Proof.
  induction ss as [| [x v] ss IH]; intros a y1 b y2 c; simpl; [reflexivity |].
  unfold drop at 1 2; simpl. eqb_cases; simpl; rewrite IH; reflexivity.
Qed.

Lemma msubst_var : forall ss x,
  closed_env ss ->
  msubst ss (EVar x) = match lookup_env x ss with Some v => v | None => EVar x end.
Proof.
  induction ss as [| [y v] ss IH]; intros x Hc; simpl; [reflexivity |].
  apply closed_env_cons in Hc as [Hv Hc].
  destruct (String.eqb y x) eqn:E1; destruct (String.eqb x y) eqn:E2.
  - apply msubst_closed. exact Hv.
  - apply String.eqb_eq in E1. apply String.eqb_neq in E2. congruence.
  - apply String.eqb_neq in E1. apply String.eqb_eq in E2. congruence.
  - apply IH. exact Hc.
Qed.

(** The commutation that makes binders work: substituting a closed value
    under a closed environment. *)
Lemma subst_msubst : forall ss x v e,
  closed_env ss -> closed_e v ->
  msubst ss (subst x v e) = subst x v (msubst (drop x ss) e).
Proof.
  induction ss as [| [y w] ss IH]; intros x v e Hc Hv; simpl; [reflexivity |].
  apply closed_env_cons in Hc as [Hw Hc].
  unfold drop at 1; simpl. eqb_cases; simpl.
  - rewrite duplicate_subst by exact Hv. apply IH; assumption.
  - rewrite <- swap_subst by (auto). apply IH.
    + exact Hc.
    + exact Hv.
Qed.

Lemma free_in_msubst : forall ss e y,
  closed_env ss -> free_in y (msubst ss e) -> free_in y e /\ lookup_env y ss = None.
Proof.
  induction ss as [| [x v] ss IH]; intros e y Hc Hf; simpl in *.
  - split; [exact Hf | reflexivity].
  - apply closed_env_cons in Hc as [Hv Hc].
    destruct (IH _ _ Hc Hf) as [Hf' Hl].
    destruct (free_in_subst_closed x v e y Hv Hf') as [Hfe Hyx].
    split; [exact Hfe |].
    eqb_cases; [contradiction | exact Hl].
Qed.

(** ** 4. The logical relation

    [RV T v]: [v] is a closed value that behaves at type [T]. A function value
    must, applied to any related argument, EVALUATE (in every store and effect
    context, leaving both untouched) to a related value. Types with no values in
    this fragment (references, channels, capabilities, ...) relate nothing. *)

Fixpoint RV (T : ty) (v : expr) {struct T} : Prop :=
  closed_e v /\ value v /\
  match T with
  | TUnit => v = EUnit
  | TBool => exists b, v = EBool b
  | TInt => exists n, v = EInt n
  | TString => exists s, v = EString s
  | TFn T1 T2 _ =>
      exists x Tx body, v = ELam x Tx body /\
        forall a, RV T1 a -> forall st ctx, exists w,
          RV T2 w /\ (subst x a body, st, ctx) -->* (w, st, ctx)
  | TProd T1 T2 => exists v1 v2, v = EPair v1 v2 /\ RV T1 v1 /\ RV T2 v2
  | TSum T1 T2 =>
      (exists v1 T', v = EInl v1 T' /\ RV T1 v1) \/
      (exists v2 T', v = EInr v2 T' /\ RV T2 v2)
  | TSecret T1 => exists v1, v = EClassify v1 /\ RV T1 v1
  | TProof T1 => exists v1, v = EProve v1 /\ RV T1 v1
  | _ => False
  end.

(** [RE T e]: in every store and effect context, [e] evaluates — without
    changing either — to a value related at [T]. *)
Definition RE (T : ty) (e : expr) : Prop :=
  forall st ctx, exists v, RV T v /\ (e, st, ctx) -->* (v, st, ctx).

Lemma RV_closed : forall T v, RV T v -> closed_e v.
Proof. intros T v H. destruct T; simpl in H; tauto. Qed.

Lemma RV_value : forall T v, RV T v -> value v.
Proof. intros T v H. destruct T; simpl in H; tauto. Qed.

Lemma RV_RE : forall T v, RV T v -> RE T v.
Proof. intros T v H st ctx. exists v. split; [exact H | apply MS_Refl]. Qed.

(** ** 5. Instantiations of a typing context *)

Definition inst (Γ : type_env) (ss : env) : Prop :=
  closed_env ss /\
  forall x T, lookup x Γ = Some T -> exists v, lookup_env x ss = Some v /\ RV T v.

Lemma inst_nil : inst nil nil.
Proof.
  split.
  - intros x v Hin. inversion Hin.
  - intros x T Hl. discriminate Hl.
Qed.

Lemma inst_cons : forall Γ ss x T v,
  inst Γ ss -> RV T v -> inst ((x, T) :: Γ) ((x, v) :: ss).
Proof.
  intros Γ ss x T v [Hc Hl] Hv. split.
  - intros y w [Heq | Hin].
    + injection Heq as <- <-. exact (RV_closed _ _ Hv).
    + exact (Hc y w Hin).
  - intros y Ty Hy. simpl in *. destruct (String.eqb y x).
    + injection Hy as <-. exists v. split; [reflexivity | exact Hv].
    + exact (Hl y Ty Hy).
Qed.

Lemma msubst_closed_typed : forall Γ Σ Δ e T ε ss,
  has_type Γ Σ Δ e T ε -> inst Γ ss -> closed_e (msubst ss e).
Proof.
  intros Γ Σ Δ e T ε ss Hty [Hc Hl] y Hf.
  destruct (free_in_msubst ss e y Hc Hf) as [Hfe Hnone].
  destruct (free_in_context y e Γ Σ Δ T ε Hfe Hty) as [T' Hlook].
  destruct (Hl y T' Hlook) as [v [Hv _]]. congruence.
Qed.

(** ** 6. Multi-step evaluation *)

Lemma ms_trans : forall c1 c2 c3, c1 -->* c2 -> c2 -->* c3 -> c1 -->* c3.
Proof.
  intros c1 c2 c3 H12 H23. induction H12 as [c | a b c Hab Hbc IH].
  - exact H23.
  - eapply MS_Step; [exact Hab | apply IH; exact H23].
Qed.

Lemma ms_one : forall c1 c2, c1 --> c2 -> c1 -->* c2.
Proof. intros c1 c2 H. eapply MS_Step; [exact H | apply MS_Refl]. Qed.

(** Evaluation inside an evaluation context. *)
Lemma ms_lift_cfg : forall (K : expr -> expr),
  (forall e e' st st' ctx ctx',
     (e, st, ctx) --> (e', st', ctx') -> (K e, st, ctx) --> (K e', st', ctx')) ->
  forall c c', c -->* c' ->
  forall e st ctx e' st' ctx',
    c = (e, st, ctx) -> c' = (e', st', ctx') -> (K e, st, ctx) -->* (K e', st', ctx').
Proof.
  intros K HK c c' H.
  induction H as [c | c1 c2 c3 H12 H23 IH]; intros e st ctx e' st' ctx' Hc Hc'.
  - subst c. injection Hc' as -> -> ->. apply MS_Refl.
  - subst c1 c3. destruct c2 as [[e2 st2] ctx2].
    eapply MS_Step; [apply HK; exact H12 | eapply IH; reflexivity].
Qed.

Lemma ms_lift : forall (K : expr -> expr),
  (forall e e' st st' ctx ctx',
     (e, st, ctx) --> (e', st', ctx') -> (K e, st, ctx) --> (K e', st', ctx')) ->
  forall e e' st st' ctx ctx',
    (e, st, ctx) -->* (e', st', ctx') -> (K e, st, ctx) -->* (K e', st', ctx').
Proof.
  intros K HK e e' st st' ctx ctx' H. eapply ms_lift_cfg; [exact HK | exact H | reflexivity | reflexivity].
Qed.

Lemma value_ms_eq : forall v st ctx w st' ctx',
  value v -> (v, st, ctx) -->* (w, st', ctx') -> w = v.
Proof.
  intros v st ctx w st' ctx' Hv H. inversion H as [c Hc | c1 c2 c3 Hs Hrest Hc1 Hc3].
  - reflexivity.
  - exfalso. exact (Semantics.value_not_step v st ctx c2 Hv Hs).
Qed.

(** Determinism turns "evaluates to a value" into strong normalization. *)
Lemma ms_irreducible_Acc : forall c c',
  c -->* c' -> (forall c'', ~ (c' --> c'')) -> Acc step_inv c.
Proof.
  intros c c' H. induction H as [c | c1 c2 c3 H12 H23 IH]; intros Hirr.
  - constructor. intros y Hy. exfalso.
    destruct c as [[ce cst] cctx]. destruct y as [[ye yst] yctx].
    exact (Hirr _ Hy).
  - constructor. intros y Hy.
    destruct c1 as [[e1 s1] x1]. destruct y as [[ye yst] yctx].
    assert (Hy' : (ye, yst, yctx) = c2) by (eapply step_deterministic_cfg; [exact Hy | exact H12]).
    rewrite Hy'. apply IH. exact Hirr.
Qed.

(** Evaluation-context lifts used by the fundamental lemma. *)
Lemma ms_app1 : forall e1 e1' e2 st ctx st' ctx',
  (e1, st, ctx) -->* (e1', st', ctx') -> (EApp e1 e2, st, ctx) -->* (EApp e1' e2, st', ctx').
Proof. intros. apply (ms_lift (fun e => EApp e e2)); [intros; apply ST_App1; assumption | assumption]. Qed.
Lemma ms_app2 : forall v1 e2 e2' st ctx st' ctx', value v1 ->
  (e2, st, ctx) -->* (e2', st', ctx') -> (EApp v1 e2, st, ctx) -->* (EApp v1 e2', st', ctx').
Proof. intros. apply (ms_lift (fun e => EApp v1 e)); [intros; apply ST_App2; assumption | assumption]. Qed.
Lemma ms_pair1 : forall e1 e1' e2 st ctx st' ctx',
  (e1, st, ctx) -->* (e1', st', ctx') -> (EPair e1 e2, st, ctx) -->* (EPair e1' e2, st', ctx').
Proof. intros. apply (ms_lift (fun e => EPair e e2)); [intros; apply ST_Pair1; assumption | assumption]. Qed.
Lemma ms_pair2 : forall v1 e2 e2' st ctx st' ctx', value v1 ->
  (e2, st, ctx) -->* (e2', st', ctx') -> (EPair v1 e2, st, ctx) -->* (EPair v1 e2', st', ctx').
Proof. intros. apply (ms_lift (fun e => EPair v1 e)); [intros; apply ST_Pair2; assumption | assumption]. Qed.
Lemma ms_fst : forall e e' st ctx st' ctx',
  (e, st, ctx) -->* (e', st', ctx') -> (EFst e, st, ctx) -->* (EFst e', st', ctx').
Proof. intros. apply (ms_lift EFst); [intros; apply ST_FstStep; assumption | assumption]. Qed.
Lemma ms_snd : forall e e' st ctx st' ctx',
  (e, st, ctx) -->* (e', st', ctx') -> (ESnd e, st, ctx) -->* (ESnd e', st', ctx').
Proof. intros. apply (ms_lift ESnd); [intros; apply ST_SndStep; assumption | assumption]. Qed.
Lemma ms_inl : forall e e' T st ctx st' ctx',
  (e, st, ctx) -->* (e', st', ctx') -> (EInl e T, st, ctx) -->* (EInl e' T, st', ctx').
Proof. intros. apply (ms_lift (fun e0 => EInl e0 T)); [intros; apply ST_InlStep; assumption | assumption]. Qed.
Lemma ms_inr : forall e e' T st ctx st' ctx',
  (e, st, ctx) -->* (e', st', ctx') -> (EInr e T, st, ctx) -->* (EInr e' T, st', ctx').
Proof. intros. apply (ms_lift (fun e0 => EInr e0 T)); [intros; apply ST_InrStep; assumption | assumption]. Qed.
Lemma ms_case : forall e e' x1 e1 x2 e2 st ctx st' ctx',
  (e, st, ctx) -->* (e', st', ctx') ->
  (ECase e x1 e1 x2 e2, st, ctx) -->* (ECase e' x1 e1 x2 e2, st', ctx').
Proof. intros. apply (ms_lift (fun e0 => ECase e0 x1 e1 x2 e2)); [intros; apply ST_CaseStep; assumption | assumption]. Qed.
Lemma ms_if : forall e e' e2 e3 st ctx st' ctx',
  (e, st, ctx) -->* (e', st', ctx') -> (EIf e e2 e3, st, ctx) -->* (EIf e' e2 e3, st', ctx').
Proof. intros. apply (ms_lift (fun e0 => EIf e0 e2 e3)); [intros; apply ST_IfStep; assumption | assumption]. Qed.
Lemma ms_let : forall x e e' e2 st ctx st' ctx',
  (e, st, ctx) -->* (e', st', ctx') -> (ELet x e e2, st, ctx) -->* (ELet x e' e2, st', ctx').
Proof. intros. apply (ms_lift (fun e0 => ELet x e0 e2)); [intros; apply ST_LetStep; assumption | assumption]. Qed.
Lemma ms_perform : forall f e e' st ctx st' ctx',
  (e, st, ctx) -->* (e', st', ctx') -> (EPerform f e, st, ctx) -->* (EPerform f e', st', ctx').
Proof. intros. apply (ms_lift (EPerform f)); [intros; apply ST_PerformStep; assumption | assumption]. Qed.
Lemma ms_handle : forall e e' x h st ctx st' ctx',
  (e, st, ctx) -->* (e', st', ctx') -> (EHandle e x h, st, ctx) -->* (EHandle e' x h, st', ctx').
Proof. intros. apply (ms_lift (fun e0 => EHandle e0 x h)); [intros; apply ST_HandleStep; assumption | assumption]. Qed.
Lemma ms_classify : forall e e' st ctx st' ctx',
  (e, st, ctx) -->* (e', st', ctx') -> (EClassify e, st, ctx) -->* (EClassify e', st', ctx').
Proof. intros. apply (ms_lift EClassify); [intros; apply ST_ClassifyStep; assumption | assumption]. Qed.
Lemma ms_prove : forall e e' st ctx st' ctx',
  (e, st, ctx) -->* (e', st', ctx') -> (EProve e, st, ctx) -->* (EProve e', st', ctx').
Proof. intros. apply (ms_lift EProve); [intros; apply ST_ProveStep; assumption | assumption]. Qed.
Lemma ms_declassify1 : forall e1 e1' e2 st ctx st' ctx',
  (e1, st, ctx) -->* (e1', st', ctx') ->
  (EDeclassify e1 e2, st, ctx) -->* (EDeclassify e1' e2, st', ctx').
Proof. intros. apply (ms_lift (fun e0 => EDeclassify e0 e2)); [intros; apply ST_Declassify1; assumption | assumption]. Qed.
Lemma ms_declassify_proof : forall v1 e e' st ctx st' ctx', value v1 ->
  (e, st, ctx) -->* (e', st', ctx') ->
  (EDeclassify v1 (EProve e), st, ctx) -->* (EDeclassify v1 (EProve e'), st', ctx').
Proof.
  intros. apply (ms_lift (fun e0 => EDeclassify v1 (EProve e0)));
    [intros; apply ST_Declassify2; [assumption | apply ST_ProveStep; assumption] | assumption].
Qed.
Lemma ms_require : forall f e e' st ctx st' ctx',
  (e, st, ctx) -->* (e', st', ctx') -> (ERequire f e, st, ctx) -->* (ERequire f e', st', ctx').
Proof. intros. apply (ms_lift (ERequire f)); [intros; apply ST_RequireStep; assumption | assumption]. Qed.
Lemma ms_grant : forall f e e' st ctx st' ctx',
  (e, st, ctx) -->* (e', st', ctx') -> (EGrant f e, st, ctx) -->* (EGrant f e', st', ctx').
Proof. intros. apply (ms_lift (EGrant f)); [intros; apply ST_GrantStep; assumption | assumption]. Qed.

(** One step followed by an evaluation. *)
Lemma ms_step_then : forall c1 c2 c3, c1 --> c2 -> c2 -->* c3 -> c1 -->* c3.
Proof. intros c1 c2 c3 H12 H23. eapply MS_Step; eassumption. Qed.

(** Binder instantiation: [subst x v] under the remaining environment. *)
Lemma RE_bind : forall Γ ss x T1 v e T2,
  inst Γ ss -> RV T1 v ->
  (forall ss', inst ((x, T1) :: Γ) ss' -> RE T2 (msubst ss' e)) ->
  RE T2 (subst x v (msubst (drop x ss) e)).
Proof.
  intros Γ ss x T1 v e T2 Hinst Hv IH.
  pose proof (IH ((x, v) :: ss) (inst_cons Γ ss x T1 v Hinst Hv)) as H.
  simpl in H. rewrite subst_msubst in H.
  - exact H.
  - exact (proj1 Hinst).
  - exact (RV_closed _ _ Hv).
Qed.

(** ** 7. The fundamental lemma *)

Theorem fundamental : forall Γ Σ Δ e T ε,
  has_type Γ Σ Δ e T ε -> ref_free e ->
  forall ss, inst Γ ss -> RE T (msubst ss e).
Proof.
  intros Γ Σ Δ e T ε Hty.
  induction Hty as
    [ G S D
    | G S D b
    | G S D n
    | G S D s
    | G S D l T sl Hlookup
    | G S D x T Hlookup
    | G S D x T1 T2 e ε Ht IHt
    | G S D e1 e2 T1 T2 ε ε1 ε2 Ht1 IHt1 Ht2 IHt2
    | G S D e1 e2 T1 T2 ε1 ε2 Ht1 IHt1 Ht2 IHt2
    | G S D e T1 T2 ε Ht IHt
    | G S D e T1 T2 ε Ht IHt
    | G S D e T1 T2 ε Ht IHt
    | G S D e T1 T2 ε Ht IHt
    | G S D e x1 e1 x2 e2 T1 T2 T ε ε1 ε2 Ht1 IHt1 Ht2 IHt2 Ht3 IHt3
    | G S D e1 e2 e3 T ε1 ε2 ε3 Ht1 IHt1 Ht2 IHt2 Ht3 IHt3
    | G S D x e1 e2 T1 T2 ε1 ε2 Ht1 IHt1 Ht2 IHt2
    | G S D eff e T ε Ht IHt
    | G S D e x h T1 T2 ε1 ε2 Ht1 IHt1 Ht2 IHt2
    | G S D e T l ε Ht IHt
    | G S D e T l ε Ht IHt Hread
    | G S D e1 e2 T l ε1 ε2 Ht1 IHt1 Ht2 IHt2 Hwrite
    | G S D e T ε Ht IHt
    | G S D e1 e2 T ε1 ε2 Ht1 IHt1 Ht2 IHt2 Hok
    | G S D e T ε Ht IHt
    | G S D e A B eb Ht IHt
    | G S D eff e T ε Ht IHt
    | G S D eff e T ε Ht IHt
    ]; intros Hrf ss Hinst; simpl in Hrf.
  - (* T_Unit *)
    rewrite msubst_unit. apply RV_RE. simpl.
    split; [intros y Hy; exact Hy | split; [constructor | reflexivity]].
  - (* T_Bool *)
    rewrite msubst_bool. apply RV_RE. simpl.
    split; [intros y Hy; exact Hy | split; [constructor | exists b; reflexivity]].
  - (* T_Int *)
    rewrite msubst_int. apply RV_RE. simpl.
    split; [intros y Hy; exact Hy | split; [constructor | exists n; reflexivity]].
  - (* T_String *)
    rewrite msubst_string. apply RV_RE. simpl.
    split; [intros y Hy; exact Hy | split; [constructor | exists s; reflexivity]].
  - (* T_Loc: excluded *) contradiction.
  - (* T_Var *)
    destruct Hinst as [Hc Hl]. destruct (Hl x T Hlookup) as [v [Hlk Hv]].
    rewrite (msubst_var ss x Hc), Hlk. apply RV_RE. exact Hv.
  - (* T_Lam *)
    assert (Hcl : closed_e (msubst ss (ELam x T1 e)))
      by exact (msubst_closed_typed _ _ _ _ _ _ ss (T_Lam G S D x T1 T2 e ε Ht) Hinst).
    rewrite msubst_lam in *. apply RV_RE. simpl.
    split; [exact Hcl | split; [constructor |]].
    exists x, T1, (msubst (drop x ss) e). split; [reflexivity |].
    intros a Ha st ctx.
    exact (RE_bind G ss x T1 a e T2 Hinst Ha (IHt Hrf) st ctx).
  - (* T_App *)
    destruct Hrf as [Hrf1 Hrf2]. rewrite msubst_app. intros st ctx.
    destruct (IHt1 Hrf1 ss Hinst st ctx) as [f [Hf Hsf]].
    destruct (IHt2 Hrf2 ss Hinst st ctx) as [a [Ha Hsa]].
    destruct Hf as [_ [_ [x [Tx [body [-> Hbody]]]]]].
    destruct (Hbody a Ha st ctx) as [w [Hw Hsw]].
    exists w. split; [exact Hw |].
    eapply ms_trans; [apply ms_app1; exact Hsf |].
    eapply ms_trans; [apply ms_app2; [constructor | exact Hsa] |].
    eapply ms_step_then; [apply ST_AppAbs; exact (RV_value _ _ Ha) | exact Hsw].
  - (* T_Pair *)
    destruct Hrf as [Hrf1 Hrf2]. rewrite msubst_pair. intros st ctx.
    destruct (IHt1 Hrf1 ss Hinst st ctx) as [v1 [Hv1 Hs1]].
    destruct (IHt2 Hrf2 ss Hinst st ctx) as [v2 [Hv2 Hs2]].
    exists (EPair v1 v2). split.
    + simpl. split; [| split; [constructor; eapply RV_value; eassumption |
                                exists v1, v2; auto]].
      intros y [Hy | Hy]; [exact (RV_closed _ _ Hv1 y Hy) | exact (RV_closed _ _ Hv2 y Hy)].
    + eapply ms_trans; [apply ms_pair1; exact Hs1 |].
      apply ms_pair2; [exact (RV_value _ _ Hv1) | exact Hs2].
  - (* T_Fst *)
    rewrite msubst_fst. intros st ctx.
    destruct (IHt Hrf ss Hinst st ctx) as [p [Hp Hsp]].
    destruct Hp as [_ [_ [v1 [v2 [-> [Hv1 Hv2]]]]]].
    exists v1. split; [exact Hv1 |].
    eapply ms_trans; [apply ms_fst; exact Hsp |].
    apply ms_one. apply ST_Fst; eapply RV_value; eassumption.
  - (* T_Snd *)
    rewrite msubst_snd. intros st ctx.
    destruct (IHt Hrf ss Hinst st ctx) as [p [Hp Hsp]].
    destruct Hp as [_ [_ [v1 [v2 [-> [Hv1 Hv2]]]]]].
    exists v2. split; [exact Hv2 |].
    eapply ms_trans; [apply ms_snd; exact Hsp |].
    apply ms_one. apply ST_Snd; eapply RV_value; eassumption.
  - (* T_Inl *)
    rewrite msubst_inl. intros st ctx.
    destruct (IHt Hrf ss Hinst st ctx) as [v [Hv Hsv]].
    exists (EInl v T2). split.
    + simpl. split; [exact (RV_closed _ _ Hv) |
                     split; [constructor; exact (RV_value _ _ Hv) | left; exists v, T2; auto]].
    + apply ms_inl. exact Hsv.
  - (* T_Inr *)
    rewrite msubst_inr. intros st ctx.
    destruct (IHt Hrf ss Hinst st ctx) as [v [Hv Hsv]].
    exists (EInr v T1). split.
    + simpl. split; [exact (RV_closed _ _ Hv) |
                     split; [constructor; exact (RV_value _ _ Hv) | right; exists v, T1; auto]].
    + apply ms_inr. exact Hsv.
  - (* T_Case *)
    destruct Hrf as [Hrf0 [Hrf1 Hrf2]]. rewrite msubst_case. intros st ctx.
    destruct (IHt1 Hrf0 ss Hinst st ctx) as [w [Hw Hsw]].
    destruct Hw as [_ [_ [[v [T' [-> Hv]]] | [v [T' [-> Hv]]]]]].
    + destruct (RE_bind G ss x1 T1 v e1 T Hinst Hv (IHt2 Hrf1) st ctx) as [r [Hr Hsr]].
      exists r. split; [exact Hr |].
      eapply ms_trans; [apply ms_case; exact Hsw |].
      eapply ms_step_then; [apply ST_CaseInl; exact (RV_value _ _ Hv) | exact Hsr].
    + destruct (RE_bind G ss x2 T2 v e2 T Hinst Hv (IHt3 Hrf2) st ctx) as [r [Hr Hsr]].
      exists r. split; [exact Hr |].
      eapply ms_trans; [apply ms_case; exact Hsw |].
      eapply ms_step_then; [apply ST_CaseInr; exact (RV_value _ _ Hv) | exact Hsr].
  - (* T_If *)
    destruct Hrf as [Hrf1 [Hrf2 Hrf3]]. rewrite msubst_if. intros st ctx.
    destruct (IHt1 Hrf1 ss Hinst st ctx) as [c [Hc Hsc]].
    destruct Hc as [_ [_ [b ->]]].
    destruct b.
    + destruct (IHt2 Hrf2 ss Hinst st ctx) as [r [Hr Hsr]].
      exists r. split; [exact Hr |].
      eapply ms_trans; [apply ms_if; exact Hsc |].
      eapply ms_step_then; [apply ST_IfTrue | exact Hsr].
    + destruct (IHt3 Hrf3 ss Hinst st ctx) as [r [Hr Hsr]].
      exists r. split; [exact Hr |].
      eapply ms_trans; [apply ms_if; exact Hsc |].
      eapply ms_step_then; [apply ST_IfFalse | exact Hsr].
  - (* T_Let *)
    destruct Hrf as [Hrf1 Hrf2]. rewrite msubst_let. intros st ctx.
    destruct (IHt1 Hrf1 ss Hinst st ctx) as [v [Hv Hsv]].
    destruct (RE_bind G ss x T1 v e2 T2 Hinst Hv (IHt2 Hrf2) st ctx) as [r [Hr Hsr]].
    exists r. split; [exact Hr |].
    eapply ms_trans; [apply ms_let; exact Hsv |].
    eapply ms_step_then; [apply ST_LetValue; exact (RV_value _ _ Hv) | exact Hsr].
  - (* T_Perform *)
    rewrite msubst_perform. intros st ctx.
    destruct (IHt Hrf ss Hinst st ctx) as [v [Hv Hsv]].
    exists v. split; [exact Hv |].
    eapply ms_trans; [apply ms_perform; exact Hsv |].
    apply ms_one. apply ST_PerformValue. exact (RV_value _ _ Hv).
  - (* T_Handle *)
    destruct Hrf as [Hrf1 Hrf2]. rewrite msubst_handle. intros st ctx.
    destruct (IHt1 Hrf1 ss Hinst st ctx) as [v [Hv Hsv]].
    destruct (RE_bind G ss x T1 v h T2 Hinst Hv (IHt2 Hrf2) st ctx) as [r [Hr Hsr]].
    exists r. split; [exact Hr |].
    eapply ms_trans; [apply ms_handle; exact Hsv |].
    eapply ms_step_then; [apply ST_HandleValue; exact (RV_value _ _ Hv) | exact Hsr].
  - (* T_Ref: excluded *) contradiction.
  - (* T_Deref: excluded *) contradiction.
  - (* T_Assign: excluded *) contradiction.
  - (* T_Classify *)
    rewrite msubst_classify. intros st ctx.
    destruct (IHt Hrf ss Hinst st ctx) as [v [Hv Hsv]].
    exists (EClassify v). split.
    + simpl. split; [exact (RV_closed _ _ Hv) |
                     split; [constructor; exact (RV_value _ _ Hv) | exists v; auto]].
    + apply ms_classify. exact Hsv.
  - (* T_Declassify: the guard fixes the proof term to [EProve e1] *)
    destruct Hok as [v0 [Hv0 [-> ->]]].
    destruct Hrf as [Hrf1 _].
    rewrite msubst_declassify, msubst_prove. intros st ctx.
    destruct (IHt1 Hrf1 ss Hinst st ctx) as [w [Hw Hsw]].
    assert (Hwv : value w) by exact (RV_value _ _ Hw).
    destruct Hw as [_ [_ [v1 [-> Hv1]]]].
    exists v1. split; [exact Hv1 |].
    eapply ms_trans; [apply ms_declassify1; exact Hsw |].
    eapply ms_trans; [apply ms_declassify_proof; [exact Hwv | exact Hsw] |].
    apply ms_one. apply ST_DeclassifyValue; [exact (RV_value _ _ Hv1) |].
    exists v1. split; [exact (RV_value _ _ Hv1) | split; reflexivity].
  - (* T_Prove *)
    rewrite msubst_prove. intros st ctx.
    destruct (IHt Hrf ss Hinst st ctx) as [v [Hv Hsv]].
    exists (EProve v). split.
    + simpl. split; [exact (RV_closed _ _ Hv) |
                     split; [constructor; exact (RV_value _ _ Hv) | exists v; auto]].
    + apply ms_prove. exact Hsv.
  - (* T_Fix: excluded *) contradiction.
  - (* T_Require *)
    rewrite msubst_require. intros st ctx.
    destruct (IHt Hrf ss Hinst st ctx) as [v [Hv Hsv]].
    exists v. split; [exact Hv |].
    eapply ms_trans; [apply ms_require; exact Hsv |].
    apply ms_one. apply ST_RequireValue. exact (RV_value _ _ Hv).
  - (* T_Grant *)
    rewrite msubst_grant. intros st ctx.
    destruct (IHt Hrf ss Hinst st ctx) as [v [Hv Hsv]].
    exists v. split; [exact Hv |].
    eapply ms_trans; [apply ms_grant; exact Hsv |].
    apply ms_one. apply ST_GrantValue. exact (RV_value _ _ Hv).
Qed.

(** ** 8. Termination and strong normalization, premise-free *)

(** Every closed, well-typed, reference-free and fixpoint-free program
    evaluates to a value in ANY store and effect context, leaving both
    unchanged. *)
Theorem ref_free_terminates : forall Σ Δ e T ε,
  has_type nil Σ Δ e T ε -> ref_free e ->
  forall st ctx, exists v, value v /\ (e, st, ctx) -->* (v, st, ctx).
Proof.
  intros Σ Δ e T ε Hty Hrf st ctx.
  destruct (fundamental nil Σ Δ e T ε Hty Hrf nil inst_nil st ctx) as [v [Hv Hs]].
  exists v. split; [exact (RV_value _ _ Hv) | exact Hs].
Qed.

(** The repaired REQ-84 capstone: strong normalization with NO premises
    beyond membership in the fragment. Contrast
    [well_typed_SN_conclusion_is_false]: once references are admitted the
    same conclusion is false. *)
Theorem ref_free_well_typed_SN : forall Σ Δ e T ε,
  has_type nil Σ Δ e T ε -> ref_free e -> SN_expr e.
Proof.
  intros Σ Δ e T ε Hty Hrf st ctx.
  destruct (ref_free_terminates Σ Δ e T ε Hty Hrf st ctx) as [v [Hv Hs]].
  eapply ms_irreducible_Acc; [exact Hs |].
  intros c Hc. exact (Semantics.value_not_step v st ctx c Hv Hc).
Qed.

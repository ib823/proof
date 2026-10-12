(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * Non-interference and constant time for the reference-free core
      (REQ-85, REQ-86)

    Premise-free, kernel-closed theorems for the reference-free,
    fixpoint-free fragment of the ACTIVE calculus
    ([termination/StrongNormRefFree.v]'s [ref_free]). Run a well-typed program
    on two environments that agree on every public input and differ
    arbitrarily on secret ([TSecret]) inputs:

    - NON-INTERFERENCE ([ref_free_noninterference]): an observable result
      ([observable] — first-order data) is the SAME value in both runs.
      Because the fragment terminates this is termination-sensitive.
    - CONSTANT TIME ([ref_free_constant_time]): both runs take EXACTLY the
      same number of reduction steps. Leakage contract (in the sense of
      Guarnieri et al., "Hardware-Software Contracts for Secure Speculation",
      S&P 2021): the [timing] observer, which sees the length of the
      evaluation in the small-step semantics — one time unit per reduction.
      [exec_time_unique] shows this "execution time" is a well-defined
      function of the configuration (evaluation is deterministic).

    Method: a binary logical relation [RV2] over closed values, indexed by
    type, whose function clause and expression closure [RE2] demand equal
    reduction counts on both sides. At [TSecret T] it relates ANY two
    classified values; observable types relate only equal values. The one
    eliminator of secrets, [EDeclassify], is guarded by [declass_ok], which
    fixes the classified payload SYNTACTICALLY in the program text; the
    fundamental lemma therefore also carries, for every [EClassify v], the
    relation of [v] at the unlabelled type, and uses it at the declassify
    site.

    Scope (honest): references, locations and [fix] are outside the fragment
    (REQ-60 extends towards [EFix]; store-based NI needs a Kripke store
    relation). The cost model is the reduction count of the formal
    semantics, not cycles of compiled code — the compiled-code side remains
    the typechecker CT rule plus the codegen structural pass and the
    valgrind ct-structural gate. Mode: Zero Trust — 0 Admitted, 0 Axiom,
    no Section Hypotheses. *)

From Stdlib Require Import Strings.String.
From Stdlib Require Import Lists.List.
From Stdlib Require Import Arith.PeanoNat.
Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Semantics.
Require Import RIINA.foundations.Typing.
Require Import RIINA.type_system.Preservation.
Require Import RIINA.termination.StrongNormRefFree.
Import ListNotations.

(** ** 1. Counted evaluation *)

Inductive msn : nat -> (expr * store * effect_ctx) -> (expr * store * effect_ctx) -> Prop :=
  | msn_refl : forall c, msn 0 c c
  | msn_step : forall n c1 c2 c3, c1 --> c2 -> msn n c2 c3 -> msn (S n) c1 c3.

Lemma msn_ms : forall n c1 c2, msn n c1 c2 -> c1 -->* c2.
Proof.
  intros n c1 c2 H. induction H as [c | n a b c Hab Hbc IH].
  - apply MS_Refl.
  - eapply MS_Step; eassumption.
Qed.

Lemma msn_trans : forall n m c1 c2 c3, msn n c1 c2 -> msn m c2 c3 -> msn (n + m) c1 c3.
Proof.
  intros n m c1 c2 c3 H12 H23. induction H12 as [c | k a b c Hab Hbc IH].
  - exact H23.
  - simpl. eapply msn_step; [exact Hab | apply IH; exact H23].
Qed.

Lemma msn_one : forall c1 c2, c1 --> c2 -> msn 1 c1 c2.
Proof. intros c1 c2 H. eapply msn_step; [exact H | apply msn_refl]. Qed.

Lemma msn_lift_cfg : forall (K : expr -> expr),
  (forall e e' st st' ctx ctx',
     (e, st, ctx) --> (e', st', ctx') -> (K e, st, ctx) --> (K e', st', ctx')) ->
  forall n c c', msn n c c' ->
  forall e st ctx e' st' ctx',
    c = (e, st, ctx) -> c' = (e', st', ctx') -> msn n (K e, st, ctx) (K e', st', ctx').
Proof.
  intros K HK n c c' H.
  induction H as [c | k c1 c2 c3 H12 H23 IH]; intros e st ctx e' st' ctx' Hc Hc'.
  - subst c. injection Hc' as -> -> ->. apply msn_refl.
  - subst c1 c3. destruct c2 as [[e2 st2] ctx2].
    eapply msn_step; [apply HK; exact H12 | eapply IH; reflexivity].
Qed.

Lemma msn_lift : forall (K : expr -> expr),
  (forall e e' st st' ctx ctx',
     (e, st, ctx) --> (e', st', ctx') -> (K e, st, ctx) --> (K e', st', ctx')) ->
  forall n e e' st st' ctx ctx',
    msn n (e, st, ctx) (e', st', ctx') -> msn n (K e, st, ctx) (K e', st', ctx').
Proof.
  intros K HK n e e' st st' ctx ctx' H.
  eapply msn_lift_cfg; [exact HK | exact H | reflexivity | reflexivity].
Qed.

(** Execution time is well defined: evaluation is deterministic, so a
    configuration reaches a value in at most one number of steps. *)
Definition exec_time (c : expr * store * effect_ctx) (n : nat) : Prop :=
  exists v st ctx, value v /\ msn n c (v, st, ctx).

Lemma exec_time_unique : forall c n m, exec_time c n -> exec_time c m -> n = m.
Proof.
  intros c n m [v [st [ctx [Hv Hn]]]] [v' [st' [ctx' [Hv' Hm]]]].
  remember (v, st, ctx) as cv eqn:Ecv.
  revert m Hm. induction Hn as [c | k c1 c2 c3 H12 H23 IH]; intros m Hm.
  - subst c. inversion Hm as [d Hd | k' a b d Hab Hbd]; [reflexivity |].
    exfalso. exact (Semantics.value_not_step v st ctx b Hv Hab).
  - inversion Hm as [d Hd | k' a b d Hab Hbd].
    + subst. exfalso. exact (Semantics.value_not_step v' st' ctx' c2 Hv' H12).
    + subst. assert (c2 = b) by (eapply step_deterministic_cfg; eassumption). subst b.
      f_equal. apply IH; [reflexivity | exact Hbd].
Qed.

(** Counted evaluation-context lifts. *)
Lemma msn_app1 : forall n e1 e1' e2 st ctx st' ctx',
  msn n (e1, st, ctx) (e1', st', ctx') -> msn n (EApp e1 e2, st, ctx) (EApp e1' e2, st', ctx').
Proof. intros. apply (msn_lift (fun e => EApp e e2)); [intros; apply ST_App1; assumption | assumption]. Qed.
Lemma msn_app2 : forall n v1 e2 e2' st ctx st' ctx', value v1 ->
  msn n (e2, st, ctx) (e2', st', ctx') -> msn n (EApp v1 e2, st, ctx) (EApp v1 e2', st', ctx').
Proof. intros. apply (msn_lift (fun e => EApp v1 e)); [intros; apply ST_App2; assumption | assumption]. Qed.
Lemma msn_pair1 : forall n e1 e1' e2 st ctx st' ctx',
  msn n (e1, st, ctx) (e1', st', ctx') -> msn n (EPair e1 e2, st, ctx) (EPair e1' e2, st', ctx').
Proof. intros. apply (msn_lift (fun e => EPair e e2)); [intros; apply ST_Pair1; assumption | assumption]. Qed.
Lemma msn_pair2 : forall n v1 e2 e2' st ctx st' ctx', value v1 ->
  msn n (e2, st, ctx) (e2', st', ctx') -> msn n (EPair v1 e2, st, ctx) (EPair v1 e2', st', ctx').
Proof. intros. apply (msn_lift (fun e => EPair v1 e)); [intros; apply ST_Pair2; assumption | assumption]. Qed.
Lemma msn_fst : forall n e e' st ctx st' ctx',
  msn n (e, st, ctx) (e', st', ctx') -> msn n (EFst e, st, ctx) (EFst e', st', ctx').
Proof. intros. apply (msn_lift EFst); [intros; apply ST_FstStep; assumption | assumption]. Qed.
Lemma msn_snd : forall n e e' st ctx st' ctx',
  msn n (e, st, ctx) (e', st', ctx') -> msn n (ESnd e, st, ctx) (ESnd e', st', ctx').
Proof. intros. apply (msn_lift ESnd); [intros; apply ST_SndStep; assumption | assumption]. Qed.
Lemma msn_inl : forall n e e' T st ctx st' ctx',
  msn n (e, st, ctx) (e', st', ctx') -> msn n (EInl e T, st, ctx) (EInl e' T, st', ctx').
Proof. intros. apply (msn_lift (fun e0 => EInl e0 T)); [intros; apply ST_InlStep; assumption | assumption]. Qed.
Lemma msn_inr : forall n e e' T st ctx st' ctx',
  msn n (e, st, ctx) (e', st', ctx') -> msn n (EInr e T, st, ctx) (EInr e' T, st', ctx').
Proof. intros. apply (msn_lift (fun e0 => EInr e0 T)); [intros; apply ST_InrStep; assumption | assumption]. Qed.
Lemma msn_case : forall n e e' x1 e1 x2 e2 st ctx st' ctx',
  msn n (e, st, ctx) (e', st', ctx') ->
  msn n (ECase e x1 e1 x2 e2, st, ctx) (ECase e' x1 e1 x2 e2, st', ctx').
Proof. intros. apply (msn_lift (fun e0 => ECase e0 x1 e1 x2 e2)); [intros; apply ST_CaseStep; assumption | assumption]. Qed.
Lemma msn_if : forall n e e' e2 e3 st ctx st' ctx',
  msn n (e, st, ctx) (e', st', ctx') -> msn n (EIf e e2 e3, st, ctx) (EIf e' e2 e3, st', ctx').
Proof. intros. apply (msn_lift (fun e0 => EIf e0 e2 e3)); [intros; apply ST_IfStep; assumption | assumption]. Qed.
Lemma msn_let : forall n x e e' e2 st ctx st' ctx',
  msn n (e, st, ctx) (e', st', ctx') -> msn n (ELet x e e2, st, ctx) (ELet x e' e2, st', ctx').
Proof. intros. apply (msn_lift (fun e0 => ELet x e0 e2)); [intros; apply ST_LetStep; assumption | assumption]. Qed.
Lemma msn_perform : forall n f e e' st ctx st' ctx',
  msn n (e, st, ctx) (e', st', ctx') -> msn n (EPerform f e, st, ctx) (EPerform f e', st', ctx').
Proof. intros. apply (msn_lift (EPerform f)); [intros; apply ST_PerformStep; assumption | assumption]. Qed.
Lemma msn_handle : forall n e e' x h st ctx st' ctx',
  msn n (e, st, ctx) (e', st', ctx') -> msn n (EHandle e x h, st, ctx) (EHandle e' x h, st', ctx').
Proof. intros. apply (msn_lift (fun e0 => EHandle e0 x h)); [intros; apply ST_HandleStep; assumption | assumption]. Qed.
Lemma msn_classify : forall n e e' st ctx st' ctx',
  msn n (e, st, ctx) (e', st', ctx') -> msn n (EClassify e, st, ctx) (EClassify e', st', ctx').
Proof. intros. apply (msn_lift EClassify); [intros; apply ST_ClassifyStep; assumption | assumption]. Qed.
Lemma msn_prove : forall n e e' st ctx st' ctx',
  msn n (e, st, ctx) (e', st', ctx') -> msn n (EProve e, st, ctx) (EProve e', st', ctx').
Proof. intros. apply (msn_lift EProve); [intros; apply ST_ProveStep; assumption | assumption]. Qed.
Lemma msn_declassify1 : forall n e1 e1' e2 st ctx st' ctx',
  msn n (e1, st, ctx) (e1', st', ctx') ->
  msn n (EDeclassify e1 e2, st, ctx) (EDeclassify e1' e2, st', ctx').
Proof. intros. apply (msn_lift (fun e0 => EDeclassify e0 e2)); [intros; apply ST_Declassify1; assumption | assumption]. Qed.
Lemma msn_declassify_proof : forall n v1 e e' st ctx st' ctx', value v1 ->
  msn n (e, st, ctx) (e', st', ctx') ->
  msn n (EDeclassify v1 (EProve e), st, ctx) (EDeclassify v1 (EProve e'), st', ctx').
Proof.
  intros. apply (msn_lift (fun e0 => EDeclassify v1 (EProve e0)));
    [intros; apply ST_Declassify2; [assumption | apply ST_ProveStep; assumption] | assumption].
Qed.
Lemma msn_require : forall n f e e' st ctx st' ctx',
  msn n (e, st, ctx) (e', st', ctx') -> msn n (ERequire f e, st, ctx) (ERequire f e', st', ctx').
Proof. intros. apply (msn_lift (ERequire f)); [intros; apply ST_RequireStep; assumption | assumption]. Qed.
Lemma msn_grant : forall n f e e' st ctx st' ctx',
  msn n (e, st, ctx) (e', st', ctx') -> msn n (EGrant f e, st, ctx) (EGrant f e', st', ctx').
Proof. intros. apply (msn_lift (EGrant f)); [intros; apply ST_GrantStep; assumption | assumption]. Qed.

(** ** 2. The binary relation, with equal reduction counts *)

Fixpoint RV2 (T : ty) (v1 v2 : expr) {struct T} : Prop :=
  closed_e v1 /\ closed_e v2 /\ value v1 /\ value v2 /\
  match T with
  | TUnit => v1 = EUnit /\ v2 = EUnit
  | TBool => exists b, v1 = EBool b /\ v2 = EBool b
  | TInt => exists n, v1 = EInt n /\ v2 = EInt n
  | TString => exists s, v1 = EString s /\ v2 = EString s
  | TFn T1 T2 _ =>
      exists x Tx b1 b2, v1 = ELam x Tx b1 /\ v2 = ELam x Tx b2 /\
        forall a1 a2, RV2 T1 a1 a2 -> forall st ctx, exists w1 w2 n,
          RV2 T2 w1 w2 /\
          msn n (subst x a1 b1, st, ctx) (w1, st, ctx) /\
          msn n (subst x a2 b2, st, ctx) (w2, st, ctx)
  | TProd T1 T2 =>
      exists a1 a2 c1 c2, v1 = EPair a1 c1 /\ v2 = EPair a2 c2 /\
        RV2 T1 a1 a2 /\ RV2 T2 c1 c2
  | TSum T1 T2 =>
      (exists u1 u2 T', v1 = EInl u1 T' /\ v2 = EInl u2 T' /\ RV2 T1 u1 u2) \/
      (exists u1 u2 T', v1 = EInr u1 T' /\ v2 = EInr u2 T' /\ RV2 T2 u1 u2)
  | TSecret _ => exists u1 u2, v1 = EClassify u1 /\ v2 = EClassify u2
  | TProof T1 => exists u1 u2, v1 = EProve u1 /\ v2 = EProve u2 /\ RV2 T1 u1 u2
  | _ => False
  end.

(** Both sides evaluate, in the same store and effect context, without
    changing either, in the SAME number of steps, to related values. *)
Definition RE2 (T : ty) (e1 e2 : expr) : Prop :=
  forall st ctx, exists v1 v2 n, RV2 T v1 v2 /\
    msn n (e1, st, ctx) (v1, st, ctx) /\ msn n (e2, st, ctx) (v2, st, ctx).

Lemma RV2_closed1 : forall T v1 v2, RV2 T v1 v2 -> closed_e v1.
Proof. intros T v1 v2 H. destruct T; simpl in H; tauto. Qed.
Lemma RV2_closed2 : forall T v1 v2, RV2 T v1 v2 -> closed_e v2.
Proof. intros T v1 v2 H. destruct T; simpl in H; tauto. Qed.
Lemma RV2_value1 : forall T v1 v2, RV2 T v1 v2 -> value v1.
Proof. intros T v1 v2 H. destruct T; simpl in H; tauto. Qed.
Lemma RV2_value2 : forall T v1 v2, RV2 T v1 v2 -> value v2.
Proof. intros T v1 v2 H. destruct T; simpl in H; tauto. Qed.

Lemma RV2_RE2 : forall T v1 v2, RV2 T v1 v2 -> RE2 T v1 v2.
Proof.
  intros T v1 v2 H st ctx. exists v1, v2, 0. split; [exact H | split; apply msn_refl].
Qed.

(** Observable result types: first-order data with no secret, function or
    store component. Related observable values are EQUAL. *)
Fixpoint observable (T : ty) : Prop :=
  match T with
  | TUnit | TBool | TInt | TString => True
  | TProd T1 T2 => observable T1 /\ observable T2
  | TSum T1 T2 => observable T1 /\ observable T2
  | _ => False
  end.

Lemma RV2_observable_eq : forall T v1 v2,
  observable T -> RV2 T v1 v2 -> v1 = v2.
Proof.
  induction T; intros v1 v2 Hobs H; simpl in Hobs; try contradiction;
    simpl in H; destruct H as [_ [_ [_ [_ H]]]].
  - destruct H as [-> ->]. reflexivity.
  - destruct H as [b [-> ->]]. reflexivity.
  - destruct H as [n [-> ->]]. reflexivity.
  - destruct H as [s [-> ->]]. reflexivity.
  - destruct H as [a1 [a2 [c1 [c2 [-> [-> [Ha Hc]]]]]]].
    destruct Hobs as [H1 H2].
    rewrite (IHT1 a1 a2 H1 Ha), (IHT2 c1 c2 H2 Hc). reflexivity.
  - destruct Hobs as [H1 H2].
    destruct H as [[u1 [u2 [T' [-> [-> Hu]]]]] | [u1 [u2 [T' [-> [-> Hu]]]]]].
    + rewrite (IHT1 u1 u2 H1 Hu). reflexivity.
    + rewrite (IHT2 u1 u2 H2 Hu). reflexivity.
Qed.

(** ** 3. Related instantiations *)

Definition inst2 (Γ : type_env) (ss1 ss2 : env) : Prop :=
  closed_env ss1 /\ closed_env ss2 /\
  forall x T, lookup x Γ = Some T ->
    exists v1 v2, lookup_env x ss1 = Some v1 /\ lookup_env x ss2 = Some v2 /\
                  RV2 T v1 v2.

Lemma inst2_nil : inst2 nil nil nil.
Proof.
  split; [| split].
  - intros x v Hin. inversion Hin.
  - intros x v Hin. inversion Hin.
  - intros x T Hl. discriminate Hl.
Qed.

Lemma closed_env_cons_intro : forall x v ss,
  closed_e v -> closed_env ss -> closed_env ((x, v) :: ss).
Proof.
  intros x v ss Hv Hc y w [Heq | Hin].
  - injection Heq as <- <-. exact Hv.
  - exact (Hc y w Hin).
Qed.

Lemma inst2_cons : forall Γ ss1 ss2 x T v1 v2,
  inst2 Γ ss1 ss2 -> RV2 T v1 v2 ->
  inst2 ((x, T) :: Γ) ((x, v1) :: ss1) ((x, v2) :: ss2).
Proof.
  intros Γ ss1 ss2 x T v1 v2 [Hc1 [Hc2 Hl]] Hv. split; [| split].
  - apply closed_env_cons_intro; [exact (RV2_closed1 _ _ _ Hv) | exact Hc1].
  - apply closed_env_cons_intro; [exact (RV2_closed2 _ _ _ Hv) | exact Hc2].
  - intros y Ty Hy. simpl in *. destruct (String.eqb y x).
    + injection Hy as <-. exists v1, v2. auto.
    + exact (Hl y Ty Hy).
Qed.

Lemma msubst_closed_typed_gen : forall Γ Σ Δ e T ε ss,
  has_type Γ Σ Δ e T ε -> closed_env ss ->
  (forall x T', lookup x Γ = Some T' -> exists v, lookup_env x ss = Some v) ->
  closed_e (msubst ss e).
Proof.
  intros Γ Σ Δ e T ε ss Hty Hc Hl y Hf.
  destruct (free_in_msubst ss e y Hc Hf) as [Hfe Hnone].
  destruct (free_in_context y e Γ Σ Δ T ε Hfe Hty) as [T' Hlook].
  destruct (Hl y T' Hlook) as [v Hv]. congruence.
Qed.

Lemma RE2_bind : forall Γ ss1 ss2 x T1 v1 v2 e T2,
  inst2 Γ ss1 ss2 -> RV2 T1 v1 v2 ->
  (forall ss1' ss2', inst2 ((x, T1) :: Γ) ss1' ss2' ->
     RE2 T2 (msubst ss1' e) (msubst ss2' e)) ->
  RE2 T2 (subst x v1 (msubst (drop x ss1) e)) (subst x v2 (msubst (drop x ss2) e)).
Proof.
  intros Γ ss1 ss2 x T1 v1 v2 e T2 Hinst Hv IH.
  pose proof (IH _ _ (inst2_cons Γ ss1 ss2 x T1 v1 v2 Hinst Hv)) as H.
  simpl in H. destruct Hinst as [Hc1 [Hc2 _]].
  rewrite (subst_msubst ss1 x v1 e Hc1 (RV2_closed1 _ _ _ Hv)) in H.
  rewrite (subst_msubst ss2 x v2 e Hc2 (RV2_closed2 _ _ _ Hv)) in H.
  exact H.
Qed.

(** ** 4. The fundamental lemma

    The second conjunct records, for a classification [EClassify v], that
    the payload is related at its UNLABELLED type. Only the declassify case
    consumes it — exactly the release the [declass_ok] guard authorises, of a
    payload written in the program text. *)

Theorem fundamental2 : forall Γ Σ Δ e T ε,
  has_type Γ Σ Δ e T ε -> ref_free e ->
  forall ss1 ss2, inst2 Γ ss1 ss2 ->
    RE2 T (msubst ss1 e) (msubst ss2 e) /\
    (forall v T', e = EClassify v -> T = TSecret T' ->
                  RE2 T' (msubst ss1 v) (msubst ss2 v)).
Proof.
  intros Γ Σ Δ e T ε Hty.
  induction Hty as
    [ G Sg D
    | G Sg D b
    | G Sg D n
    | G Sg D s
    | G Sg D l T sl Hlookup
    | G Sg D x T Hlookup
    | G Sg D x T1 T2 e ε Ht IHt
    | G Sg D e1 e2 T1 T2 ε ε1 ε2 Ht1 IHt1 Ht2 IHt2
    | G Sg D e1 e2 T1 T2 ε1 ε2 Ht1 IHt1 Ht2 IHt2
    | G Sg D e T1 T2 ε Ht IHt
    | G Sg D e T1 T2 ε Ht IHt
    | G Sg D e T1 T2 ε Ht IHt
    | G Sg D e T1 T2 ε Ht IHt
    | G Sg D e x1 e1 x2 e2 T1 T2 T ε ε1 ε2 Ht1 IHt1 Ht2 IHt2 Ht3 IHt3
    | G Sg D e1 e2 e3 T ε1 ε2 ε3 Ht1 IHt1 Ht2 IHt2 Ht3 IHt3
    | G Sg D x e1 e2 T1 T2 ε1 ε2 Ht1 IHt1 Ht2 IHt2
    | G Sg D eff e T ε Ht IHt
    | G Sg D e x h T1 T2 ε1 ε2 Ht1 IHt1 Ht2 IHt2
    | G Sg D e T l ε Ht IHt
    | G Sg D e T l ε Ht IHt Hread
    | G Sg D e1 e2 T l ε1 ε2 Ht1 IHt1 Ht2 IHt2 Hwrite
    | G Sg D e T ε Ht IHt
    | G Sg D e1 e2 T ε1 ε2 Ht1 IHt1 Ht2 IHt2 Hok
    | G Sg D e T ε Ht IHt
    | G Sg D e A B eb Ht IHt
    | G Sg D eff e T ε Ht IHt
    | G Sg D eff e T ε Ht IHt
    ]; intros Hrf ss1 ss2 Hinst; simpl in Hrf;
    (split; [| try (intros ? ? Hcl; discriminate Hcl)]).
  - (* T_Unit *)
    rewrite !msubst_unit. apply RV2_RE2. simpl.
    repeat split; try (intros y Hy; exact Hy); constructor.
  - (* T_Bool *)
    rewrite !msubst_bool. apply RV2_RE2. simpl.
    split; [intros y Hy; exact Hy | split; [intros y Hy; exact Hy |]].
    split; [constructor | split; [constructor | exists b; auto]].
  - (* T_Int *)
    rewrite !msubst_int. apply RV2_RE2. simpl.
    split; [intros y Hy; exact Hy | split; [intros y Hy; exact Hy |]].
    split; [constructor | split; [constructor | exists n; auto]].
  - (* T_String *)
    rewrite !msubst_string. apply RV2_RE2. simpl.
    split; [intros y Hy; exact Hy | split; [intros y Hy; exact Hy |]].
    split; [constructor | split; [constructor | exists s; auto]].
  - (* T_Loc *) contradiction.
  - (* T_Var *)
    destruct Hinst as [Hc1 [Hc2 Hl]].
    destruct (Hl x T Hlookup) as [v1 [v2 [Hl1 [Hl2 Hv]]]].
    rewrite (msubst_var ss1 x Hc1), (msubst_var ss2 x Hc2), Hl1, Hl2.
    apply RV2_RE2. exact Hv.
  - (* T_Lam *)
    pose proof Hinst as [Hc1 [Hc2 Hl]].
    assert (Hl1 : forall y T', lookup y G = Some T' -> exists v, lookup_env y ss1 = Some v).
    { intros y T' Hy. destruct (Hl y T' Hy) as [v1 [v2 [H1 _]]]. eauto. }
    assert (Hl2 : forall y T', lookup y G = Some T' -> exists v, lookup_env y ss2 = Some v).
    { intros y T' Hy. destruct (Hl y T' Hy) as [v1 [v2 [_ [H2 _]]]]. eauto. }
    assert (Hcl1 : closed_e (msubst ss1 (ELam x T1 e)))
      by exact (msubst_closed_typed_gen _ _ _ _ _ _ ss1 (T_Lam G Sg D x T1 T2 e ε Ht) Hc1 Hl1).
    assert (Hcl2 : closed_e (msubst ss2 (ELam x T1 e)))
      by exact (msubst_closed_typed_gen _ _ _ _ _ _ ss2 (T_Lam G Sg D x T1 T2 e ε Ht) Hc2 Hl2).
    rewrite (msubst_lam ss1) in Hcl1 |- *. rewrite (msubst_lam ss2) in Hcl2 |- *.
    apply RV2_RE2. simpl.
    split; [exact Hcl1 | split; [exact Hcl2 | split; [constructor | split; [constructor |]]]].
    exists x, T1, (msubst (drop x ss1) e), (msubst (drop x ss2) e).
    split; [reflexivity | split; [reflexivity |]].
    intros a1 a2 Ha st ctx.
    exact (RE2_bind G ss1 ss2 x T1 a1 a2 e T2 Hinst Ha
             (fun s1 s2 H => proj1 (IHt Hrf s1 s2 H)) st ctx).
  - (* T_App *)
    destruct Hrf as [Hrf1 Hrf2]. rewrite !msubst_app. intros st ctx.
    destruct (proj1 (IHt1 Hrf1 ss1 ss2 Hinst) st ctx) as [f1 [f2 [nf [Hf [Hsf1 Hsf2]]]]].
    destruct (proj1 (IHt2 Hrf2 ss1 ss2 Hinst) st ctx) as [a1 [a2 [na [Ha [Hsa1 Hsa2]]]]].
    destruct Hf as [_ [_ [_ [_ [x [Tx [b1 [b2 [-> [-> Hb]]]]]]]]]].
    destruct (Hb a1 a2 Ha st ctx) as [w1 [w2 [nw [Hw [Hsw1 Hsw2]]]]].
    exists w1, w2, (nf + (na + S nw)). split; [exact Hw | split].
    + apply (msn_trans nf (na + S nw)) with (c2 := (EApp (ELam x Tx b1) (msubst ss1 e2), st, ctx));
        [apply msn_app1; exact Hsf1 |].
      apply (msn_trans na (S nw)) with (c2 := (EApp (ELam x Tx b1) a1, st, ctx));
        [apply msn_app2; [constructor | exact Hsa1] |].
      eapply msn_step; [apply ST_AppAbs; exact (RV2_value1 _ _ _ Ha) | exact Hsw1].
    + apply (msn_trans nf (na + S nw)) with (c2 := (EApp (ELam x Tx b2) (msubst ss2 e2), st, ctx));
        [apply msn_app1; exact Hsf2 |].
      apply (msn_trans na (S nw)) with (c2 := (EApp (ELam x Tx b2) a2, st, ctx));
        [apply msn_app2; [constructor | exact Hsa2] |].
      eapply msn_step; [apply ST_AppAbs; exact (RV2_value2 _ _ _ Ha) | exact Hsw2].
  - (* T_Pair *)
    destruct Hrf as [Hrf1 Hrf2]. rewrite !msubst_pair. intros st ctx.
    destruct (proj1 (IHt1 Hrf1 ss1 ss2 Hinst) st ctx) as [a1 [a2 [na [Ha [Hsa1 Hsa2]]]]].
    destruct (proj1 (IHt2 Hrf2 ss1 ss2 Hinst) st ctx) as [c1 [c2 [nc [Hc [Hsc1 Hsc2]]]]].
    exists (EPair a1 c1), (EPair a2 c2), (na + nc). split; [| split].
    + simpl. split; [| split; [| split; [| split]]].
      * intros y [Hy | Hy]; [exact (RV2_closed1 _ _ _ Ha y Hy) | exact (RV2_closed1 _ _ _ Hc y Hy)].
      * intros y [Hy | Hy]; [exact (RV2_closed2 _ _ _ Ha y Hy) | exact (RV2_closed2 _ _ _ Hc y Hy)].
      * constructor; [exact (RV2_value1 _ _ _ Ha) | exact (RV2_value1 _ _ _ Hc)].
      * constructor; [exact (RV2_value2 _ _ _ Ha) | exact (RV2_value2 _ _ _ Hc)].
      * exists a1, a2, c1, c2. auto.
    + apply (msn_trans na nc) with (c2 := (EPair a1 (msubst ss1 e2), st, ctx));
        [apply msn_pair1; exact Hsa1 |].
      apply msn_pair2; [exact (RV2_value1 _ _ _ Ha) | exact Hsc1].
    + apply (msn_trans na nc) with (c2 := (EPair a2 (msubst ss2 e2), st, ctx));
        [apply msn_pair1; exact Hsa2 |].
      apply msn_pair2; [exact (RV2_value2 _ _ _ Ha) | exact Hsc2].
  - (* T_Fst *)
    rewrite !msubst_fst. intros st ctx.
    destruct (proj1 (IHt Hrf ss1 ss2 Hinst) st ctx) as [p1 [p2 [np [Hp [Hs1 Hs2]]]]].
    destruct Hp as [_ [_ [_ [_ [a1 [a2 [c1 [c2 [-> [-> [Ha Hc]]]]]]]]]]].
    exists a1, a2, (np + 1). split; [exact Ha | split].
    + apply (msn_trans np 1) with (c2 := (EFst (EPair a1 c1), st, ctx)); [apply msn_fst; exact Hs1 |].
      apply msn_one. apply ST_Fst; [exact (RV2_value1 _ _ _ Ha) | exact (RV2_value1 _ _ _ Hc)].
    + apply (msn_trans np 1) with (c2 := (EFst (EPair a2 c2), st, ctx)); [apply msn_fst; exact Hs2 |].
      apply msn_one. apply ST_Fst; [exact (RV2_value2 _ _ _ Ha) | exact (RV2_value2 _ _ _ Hc)].
  - (* T_Snd *)
    rewrite !msubst_snd. intros st ctx.
    destruct (proj1 (IHt Hrf ss1 ss2 Hinst) st ctx) as [p1 [p2 [np [Hp [Hs1 Hs2]]]]].
    destruct Hp as [_ [_ [_ [_ [a1 [a2 [c1 [c2 [-> [-> [Ha Hc]]]]]]]]]]].
    exists c1, c2, (np + 1). split; [exact Hc | split].
    + apply (msn_trans np 1) with (c2 := (ESnd (EPair a1 c1), st, ctx)); [apply msn_snd; exact Hs1 |].
      apply msn_one. apply ST_Snd; [exact (RV2_value1 _ _ _ Ha) | exact (RV2_value1 _ _ _ Hc)].
    + apply (msn_trans np 1) with (c2 := (ESnd (EPair a2 c2), st, ctx)); [apply msn_snd; exact Hs2 |].
      apply msn_one. apply ST_Snd; [exact (RV2_value2 _ _ _ Ha) | exact (RV2_value2 _ _ _ Hc)].
  - (* T_Inl *)
    rewrite !msubst_inl. intros st ctx.
    destruct (proj1 (IHt Hrf ss1 ss2 Hinst) st ctx) as [u1 [u2 [nu [Hu [Hs1 Hs2]]]]].
    exists (EInl u1 T2), (EInl u2 T2), nu. split; [| split].
    + simpl. split; [exact (RV2_closed1 _ _ _ Hu) | split; [exact (RV2_closed2 _ _ _ Hu) |]].
      split; [constructor; exact (RV2_value1 _ _ _ Hu) |
              split; [constructor; exact (RV2_value2 _ _ _ Hu) |]].
      left. exists u1, u2, T2. auto.
    + apply msn_inl. exact Hs1.
    + apply msn_inl. exact Hs2.
  - (* T_Inr *)
    rewrite !msubst_inr. intros st ctx.
    destruct (proj1 (IHt Hrf ss1 ss2 Hinst) st ctx) as [u1 [u2 [nu [Hu [Hs1 Hs2]]]]].
    exists (EInr u1 T1), (EInr u2 T1), nu. split; [| split].
    + simpl. split; [exact (RV2_closed1 _ _ _ Hu) | split; [exact (RV2_closed2 _ _ _ Hu) |]].
      split; [constructor; exact (RV2_value1 _ _ _ Hu) |
              split; [constructor; exact (RV2_value2 _ _ _ Hu) |]].
      right. exists u1, u2, T1. auto.
    + apply msn_inr. exact Hs1.
    + apply msn_inr. exact Hs2.
  - (* T_Case: the scrutinee is PUBLIC data, so both runs take the same arm *)
    destruct Hrf as [Hrf0 [Hrf1 Hrf2]]. rewrite !msubst_case. intros st ctx.
    destruct (proj1 (IHt1 Hrf0 ss1 ss2 Hinst) st ctx) as [w1 [w2 [nw [Hw [Hs1 Hs2]]]]].
    destruct Hw as [_ [_ [_ [_ [[u1 [u2 [T' [-> [-> Hu]]]]] | [u1 [u2 [T' [-> [-> Hu]]]]]]]]]].
    + destruct (RE2_bind G ss1 ss2 x1 T1 u1 u2 e1 T Hinst Hu
                  (fun s1 s2 H => proj1 (IHt2 Hrf1 s1 s2 H)) st ctx)
        as [r1 [r2 [nr [Hr [Hr1 Hr2]]]]].
      exists r1, r2, (nw + S nr). split; [exact Hr | split].
      * apply (msn_trans nw (S nr)) with
          (c2 := (ECase (EInl u1 T') x1 (msubst (drop x1 ss1) e1) x2 (msubst (drop x2 ss1) e2), st, ctx));
          [apply msn_case; exact Hs1 |].
        eapply msn_step; [apply ST_CaseInl; exact (RV2_value1 _ _ _ Hu) | exact Hr1].
      * apply (msn_trans nw (S nr)) with
          (c2 := (ECase (EInl u2 T') x1 (msubst (drop x1 ss2) e1) x2 (msubst (drop x2 ss2) e2), st, ctx));
          [apply msn_case; exact Hs2 |].
        eapply msn_step; [apply ST_CaseInl; exact (RV2_value2 _ _ _ Hu) | exact Hr2].
    + destruct (RE2_bind G ss1 ss2 x2 T2 u1 u2 e2 T Hinst Hu
                  (fun s1 s2 H => proj1 (IHt3 Hrf2 s1 s2 H)) st ctx)
        as [r1 [r2 [nr [Hr [Hr1 Hr2]]]]].
      exists r1, r2, (nw + S nr). split; [exact Hr | split].
      * apply (msn_trans nw (S nr)) with
          (c2 := (ECase (EInr u1 T') x1 (msubst (drop x1 ss1) e1) x2 (msubst (drop x2 ss1) e2), st, ctx));
          [apply msn_case; exact Hs1 |].
        eapply msn_step; [apply ST_CaseInr; exact (RV2_value1 _ _ _ Hu) | exact Hr1].
      * apply (msn_trans nw (S nr)) with
          (c2 := (ECase (EInr u2 T') x1 (msubst (drop x1 ss2) e1) x2 (msubst (drop x2 ss2) e2), st, ctx));
          [apply msn_case; exact Hs2 |].
        eapply msn_step; [apply ST_CaseInr; exact (RV2_value2 _ _ _ Hu) | exact Hr2].
  - (* T_If: the guard is a PUBLIC boolean, so both runs take the same branch *)
    destruct Hrf as [Hrf1 [Hrf2 Hrf3]]. rewrite !msubst_if. intros st ctx.
    destruct (proj1 (IHt1 Hrf1 ss1 ss2 Hinst) st ctx) as [c1 [c2 [nc [Hc [Hs1 Hs2]]]]].
    destruct Hc as [_ [_ [_ [_ [b [-> ->]]]]]].
    destruct b.
    + destruct (proj1 (IHt2 Hrf2 ss1 ss2 Hinst) st ctx) as [r1 [r2 [nr [Hr [Hr1 Hr2]]]]].
      exists r1, r2, (nc + S nr). split; [exact Hr | split].
      * apply (msn_trans nc (S nr)) with (c2 := (EIf (EBool true) (msubst ss1 e2) (msubst ss1 e3), st, ctx));
          [apply msn_if; exact Hs1 |].
        eapply msn_step; [apply ST_IfTrue | exact Hr1].
      * apply (msn_trans nc (S nr)) with (c2 := (EIf (EBool true) (msubst ss2 e2) (msubst ss2 e3), st, ctx));
          [apply msn_if; exact Hs2 |].
        eapply msn_step; [apply ST_IfTrue | exact Hr2].
    + destruct (proj1 (IHt3 Hrf3 ss1 ss2 Hinst) st ctx) as [r1 [r2 [nr [Hr [Hr1 Hr2]]]]].
      exists r1, r2, (nc + S nr). split; [exact Hr | split].
      * apply (msn_trans nc (S nr)) with (c2 := (EIf (EBool false) (msubst ss1 e2) (msubst ss1 e3), st, ctx));
          [apply msn_if; exact Hs1 |].
        eapply msn_step; [apply ST_IfFalse | exact Hr1].
      * apply (msn_trans nc (S nr)) with (c2 := (EIf (EBool false) (msubst ss2 e2) (msubst ss2 e3), st, ctx));
          [apply msn_if; exact Hs2 |].
        eapply msn_step; [apply ST_IfFalse | exact Hr2].
  - (* T_Let *)
    destruct Hrf as [Hrf1 Hrf2]. rewrite !msubst_let. intros st ctx.
    destruct (proj1 (IHt1 Hrf1 ss1 ss2 Hinst) st ctx) as [v1 [v2 [nv [Hv [Hs1 Hs2]]]]].
    destruct (RE2_bind G ss1 ss2 x T1 v1 v2 e2 T2 Hinst Hv
                (fun s1 s2 H => proj1 (IHt2 Hrf2 s1 s2 H)) st ctx)
      as [r1 [r2 [nr [Hr [Hr1 Hr2]]]]].
    exists r1, r2, (nv + S nr). split; [exact Hr | split].
    + apply (msn_trans nv (S nr)) with (c2 := (ELet x v1 (msubst (drop x ss1) e2), st, ctx));
        [apply msn_let; exact Hs1 |].
      eapply msn_step; [apply ST_LetValue; exact (RV2_value1 _ _ _ Hv) | exact Hr1].
    + apply (msn_trans nv (S nr)) with (c2 := (ELet x v2 (msubst (drop x ss2) e2), st, ctx));
        [apply msn_let; exact Hs2 |].
      eapply msn_step; [apply ST_LetValue; exact (RV2_value2 _ _ _ Hv) | exact Hr2].
  - (* T_Perform *)
    rewrite !msubst_perform. intros st ctx.
    destruct (proj1 (IHt Hrf ss1 ss2 Hinst) st ctx) as [v1 [v2 [nv [Hv [Hs1 Hs2]]]]].
    exists v1, v2, (nv + 1). split; [exact Hv | split].
    + apply (msn_trans nv 1) with (c2 := (EPerform eff v1, st, ctx)); [apply msn_perform; exact Hs1 |].
      apply msn_one. apply ST_PerformValue. exact (RV2_value1 _ _ _ Hv).
    + apply (msn_trans nv 1) with (c2 := (EPerform eff v2, st, ctx)); [apply msn_perform; exact Hs2 |].
      apply msn_one. apply ST_PerformValue. exact (RV2_value2 _ _ _ Hv).
  - (* T_Handle *)
    destruct Hrf as [Hrf1 Hrf2]. rewrite !msubst_handle. intros st ctx.
    destruct (proj1 (IHt1 Hrf1 ss1 ss2 Hinst) st ctx) as [v1 [v2 [nv [Hv [Hs1 Hs2]]]]].
    destruct (RE2_bind G ss1 ss2 x T1 v1 v2 h T2 Hinst Hv
                (fun s1 s2 H => proj1 (IHt2 Hrf2 s1 s2 H)) st ctx)
      as [r1 [r2 [nr [Hr [Hr1 Hr2]]]]].
    exists r1, r2, (nv + S nr). split; [exact Hr | split].
    + apply (msn_trans nv (S nr)) with (c2 := (EHandle v1 x (msubst (drop x ss1) h), st, ctx));
        [apply msn_handle; exact Hs1 |].
      eapply msn_step; [apply ST_HandleValue; exact (RV2_value1 _ _ _ Hv) | exact Hr1].
    + apply (msn_trans nv (S nr)) with (c2 := (EHandle v2 x (msubst (drop x ss2) h), st, ctx));
        [apply msn_handle; exact Hs2 |].
      eapply msn_step; [apply ST_HandleValue; exact (RV2_value2 _ _ _ Hv) | exact Hr2].
  - (* T_Ref *) contradiction.
  - (* T_Deref *) contradiction.
  - (* T_Assign *) contradiction.
  - (* T_Classify: secrets relate unconditionally *)
    rewrite !msubst_classify. intros st ctx.
    destruct (proj1 (IHt Hrf ss1 ss2 Hinst) st ctx) as [v1 [v2 [nv [Hv [Hs1 Hs2]]]]].
    exists (EClassify v1), (EClassify v2), nv. split; [| split].
    + simpl. split; [exact (RV2_closed1 _ _ _ Hv) | split; [exact (RV2_closed2 _ _ _ Hv) |]].
      split; [constructor; exact (RV2_value1 _ _ _ Hv) |
              split; [constructor; exact (RV2_value2 _ _ _ Hv) |]].
      exists v1, v2. auto.
    + apply msn_classify. exact Hs1.
    + apply msn_classify. exact Hs2.
  - (* T_Classify, payload conjunct *)
    intros v T' Heq HT. injection Heq as <-. injection HT as <-.
    exact (proj1 (IHt Hrf ss1 ss2 Hinst)).
  - (* T_Declassify: release exactly the payload fixed in the program text *)
    destruct Hok as [v0 [Hv0 [-> ->]]].
    destruct Hrf as [Hrf1 _].
    rewrite !msubst_declassify, !msubst_prove, !msubst_classify. intros st ctx.
    destruct (proj2 (IHt1 Hrf1 ss1 ss2 Hinst) v0 T eq_refl eq_refl st ctx)
      as [w1 [w2 [nw [Hw [Hs1 Hs2]]]]].
    exists w1, w2, (nw + (nw + 1)). split; [exact Hw | split].
    + apply (msn_trans nw (nw + 1)) with
        (c2 := (EDeclassify (EClassify w1) (EProve (EClassify (msubst ss1 v0))), st, ctx));
        [apply msn_declassify1; apply msn_classify; exact Hs1 |].
      apply (msn_trans nw 1) with
        (c2 := (EDeclassify (EClassify w1) (EProve (EClassify w1)), st, ctx));
        [apply msn_declassify_proof; [constructor; exact (RV2_value1 _ _ _ Hw) |
                                      apply msn_classify; exact Hs1] |].
      apply msn_one. apply ST_DeclassifyValue; [exact (RV2_value1 _ _ _ Hw) |].
      exists w1. split; [exact (RV2_value1 _ _ _ Hw) | split; reflexivity].
    + apply (msn_trans nw (nw + 1)) with
        (c2 := (EDeclassify (EClassify w2) (EProve (EClassify (msubst ss2 v0))), st, ctx));
        [apply msn_declassify1; apply msn_classify; exact Hs2 |].
      apply (msn_trans nw 1) with
        (c2 := (EDeclassify (EClassify w2) (EProve (EClassify w2)), st, ctx));
        [apply msn_declassify_proof; [constructor; exact (RV2_value2 _ _ _ Hw) |
                                      apply msn_classify; exact Hs2] |].
      apply msn_one. apply ST_DeclassifyValue; [exact (RV2_value2 _ _ _ Hw) |].
      exists w2. split; [exact (RV2_value2 _ _ _ Hw) | split; reflexivity].
  - (* T_Prove *)
    rewrite !msubst_prove. intros st ctx.
    destruct (proj1 (IHt Hrf ss1 ss2 Hinst) st ctx) as [v1 [v2 [nv [Hv [Hs1 Hs2]]]]].
    exists (EProve v1), (EProve v2), nv. split; [| split].
    + simpl. split; [exact (RV2_closed1 _ _ _ Hv) | split; [exact (RV2_closed2 _ _ _ Hv) |]].
      split; [constructor; exact (RV2_value1 _ _ _ Hv) |
              split; [constructor; exact (RV2_value2 _ _ _ Hv) |]].
      exists v1, v2. auto.
    + apply msn_prove. exact Hs1.
    + apply msn_prove. exact Hs2.
  - (* T_Fix *) contradiction.
  - (* T_Require *)
    rewrite !msubst_require. intros st ctx.
    destruct (proj1 (IHt Hrf ss1 ss2 Hinst) st ctx) as [v1 [v2 [nv [Hv [Hs1 Hs2]]]]].
    exists v1, v2, (nv + 1). split; [exact Hv | split].
    + apply (msn_trans nv 1) with (c2 := (ERequire eff v1, st, ctx)); [apply msn_require; exact Hs1 |].
      apply msn_one. apply ST_RequireValue. exact (RV2_value1 _ _ _ Hv).
    + apply (msn_trans nv 1) with (c2 := (ERequire eff v2, st, ctx)); [apply msn_require; exact Hs2 |].
      apply msn_one. apply ST_RequireValue. exact (RV2_value2 _ _ _ Hv).
  - (* T_Grant *)
    rewrite !msubst_grant. intros st ctx.
    destruct (proj1 (IHt Hrf ss1 ss2 Hinst) st ctx) as [v1 [v2 [nv [Hv [Hs1 Hs2]]]]].
    exists v1, v2, (nv + 1). split; [exact Hv | split].
    + apply (msn_trans nv 1) with (c2 := (EGrant eff v1, st, ctx)); [apply msn_grant; exact Hs1 |].
      apply msn_one. apply ST_GrantValue. exact (RV2_value1 _ _ _ Hv).
    + apply (msn_trans nv 1) with (c2 := (EGrant eff v2, st, ctx)); [apply msn_grant; exact Hs2 |].
      apply msn_one. apply ST_GrantValue. exact (RV2_value2 _ _ _ Hv).
Qed.

(** ** 5. Non-interference *)

(** General form: related environments — equal on public inputs, arbitrary
    on [TSecret] inputs — yield the SAME observable result. *)
Theorem ref_free_noninterference_env : forall Γ Σ Δ e T ε ss1 ss2,
  has_type Γ Σ Δ e T ε -> ref_free e -> observable T -> inst2 Γ ss1 ss2 ->
  forall st ctx, exists v, value v /\
    (msubst ss1 e, st, ctx) -->* (v, st, ctx) /\
    (msubst ss2 e, st, ctx) -->* (v, st, ctx).
Proof.
  intros Γ Σ Δ e T ε ss1 ss2 Hty Hrf Hobs Hinst st ctx.
  destruct (proj1 (fundamental2 Γ Σ Δ e T ε Hty Hrf ss1 ss2 Hinst) st ctx)
    as [v1 [v2 [n [Hv [Hs1 Hs2]]]]].
  pose proof (RV2_observable_eq T v1 v2 Hobs Hv) as <-.
  exists v1. split; [exact (RV2_value1 _ _ _ Hv) |].
  split; eapply msn_ms; eassumption.
Qed.

Lemma secret_inputs_related : forall Ts w1 w2,
  value w1 -> value w2 -> closed_e w1 -> closed_e w2 ->
  RV2 (TSecret Ts) (EClassify w1) (EClassify w2).
Proof.
  intros Ts w1 w2 Hw1 Hw2 Hc1 Hc2. simpl.
  split; [exact Hc1 | split; [exact Hc2 |]].
  split; [constructor; exact Hw1 | split; [constructor; exact Hw2 |]].
  exists w1, w2. auto.
Qed.

(** The headline instance: a program with one secret input [x : TSecret Ts]
    and an observable result returns the same value whatever classified
    closed values are supplied for [x]. *)
Theorem ref_free_noninterference : forall x Ts Σ Δ e T ε w1 w2,
  has_type [(x, TSecret Ts)] Σ Δ e T ε -> ref_free e -> observable T ->
  value w1 -> value w2 -> closed_e w1 -> closed_e w2 ->
  forall st ctx, exists v, value v /\
    (subst x (EClassify w1) e, st, ctx) -->* (v, st, ctx) /\
    (subst x (EClassify w2) e, st, ctx) -->* (v, st, ctx).
Proof.
  intros x Ts Σ Δ e T ε w1 w2 Hty Hrf Hobs Hw1 Hw2 Hc1 Hc2 st ctx.
  pose proof (inst2_cons nil nil nil x (TSecret Ts) _ _ inst2_nil
                (secret_inputs_related Ts w1 w2 Hw1 Hw2 Hc1 Hc2)) as Hinst.
  exact (ref_free_noninterference_env _ Σ Δ e T ε _ _ Hty Hrf Hobs Hinst st ctx).
Qed.

(** ** 6. Constant time (timing leakage contract) *)

(** General form: on related environments the two runs take the same number
    of reduction steps — for EVERY result type, not only observable ones. *)
Theorem ref_free_constant_time_env : forall Γ Σ Δ e T ε ss1 ss2,
  has_type Γ Σ Δ e T ε -> ref_free e -> inst2 Γ ss1 ss2 ->
  forall st ctx, exists n,
    exec_time (msubst ss1 e, st, ctx) n /\ exec_time (msubst ss2 e, st, ctx) n.
Proof.
  intros Γ Σ Δ e T ε ss1 ss2 Hty Hrf Hinst st ctx.
  destruct (proj1 (fundamental2 Γ Σ Δ e T ε Hty Hrf ss1 ss2 Hinst) st ctx)
    as [v1 [v2 [n [Hv [Hs1 Hs2]]]]].
  exists n. split.
  - exists v1, st, ctx. split; [exact (RV2_value1 _ _ _ Hv) | exact Hs1].
  - exists v2, st, ctx. split; [exact (RV2_value2 _ _ _ Hv) | exact Hs2].
Qed.

(** The headline instance: execution time is a function of the public
    inputs only. Whatever classified closed values are supplied for the
    secret input, the program terminates, and ANY two measured execution
    times are equal. *)
Theorem ref_free_constant_time : forall x Ts Σ Δ e T ε w1 w2 st ctx,
  has_type [(x, TSecret Ts)] Σ Δ e T ε -> ref_free e ->
  value w1 -> value w2 -> closed_e w1 -> closed_e w2 ->
  (exists n, exec_time (subst x (EClassify w1) e, st, ctx) n) /\
  (forall n1 n2,
     exec_time (subst x (EClassify w1) e, st, ctx) n1 ->
     exec_time (subst x (EClassify w2) e, st, ctx) n2 -> n1 = n2).
Proof.
  intros x Ts Σ Δ e T ε w1 w2 st ctx Hty Hrf Hw1 Hw2 Hc1 Hc2.
  pose proof (inst2_cons nil nil nil x (TSecret Ts) _ _ inst2_nil
                (secret_inputs_related Ts w1 w2 Hw1 Hw2 Hc1 Hc2)) as Hinst.
  destruct (ref_free_constant_time_env _ Σ Δ e T ε _ _ Hty Hrf Hinst st ctx)
    as [n [Ht1 Ht2]].
  simpl in Ht1, Ht2. split.
  - exists n. exact Ht1.
  - intros n1 n2 H1 H2.
    rewrite (exec_time_unique _ n1 n H1 Ht1), (exec_time_unique _ n2 n H2 Ht2).
    reflexivity.
Qed.

(** Non-vacuity: the hypotheses are satisfiable by a program that USES its
    secret input and declassifies a literal — so the theorems above are not
    statements about an empty class. *)
Example ref_free_noninterference_nonvacuous :
  let x := "s"%string in
  let e := ELet "y"%string (EVar x)
             (EIf (EDeclassify (EClassify (EBool true)) (EProve (EClassify (EBool true))))
                  (EInt 1) (EInt 2)) in
  has_type [(x, TSecret TInt)] nil Public e TInt
           (effect_join EffectPure (effect_join (effect_join EffectPure EffectPure)
                                                (effect_join EffectPure EffectPure))) /\
  ref_free e /\ observable TInt.
Proof.
  simpl. split; [| split; [repeat split | exact I]].
  eapply T_Let.
  - apply T_Var. reflexivity.
  - eapply T_If.
    + eapply T_Declassify.
      * apply T_Classify. apply T_Bool.
      * apply T_Prove. apply T_Classify. apply T_Bool.
      * exists (EBool true). split; [constructor | split; reflexivity].
    + apply T_Int.
    + apply T_Int.
Qed.

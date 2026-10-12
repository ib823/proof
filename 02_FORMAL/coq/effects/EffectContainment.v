(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * Set-based effect containment (2026-10-11 audit, model-level limitation)

    The typing judgment orders effects by a single level ([effect_level], a
    total order): a term typed at [EffTime] may contain a [perform
    EffFileSystem], because FileSystem's level is lower. That ordering is a
    property of the TYPE SYSTEM's bound, not of what evaluation can do. This
    file proves a SET-based statement that does not depend on any ordering:

      evaluation never introduces a [perform] / [require] / [grant] site
      whose effect label is not already in the program or the store.

    For ANY set of effects [D] (a predicate, so it may be any subset — no
    lattice, no levels): if every effect site of the program and of every
    stored value lies in [D], then every effect site of every reachable
    configuration lies in [D]. Hence a program (and initial store) that
    contains no [EffNetwork] site can never perform, require or grant
    Network, whatever effect it is TYPED at. Untyped: it holds for every
    configuration, well-typed or not.

    Mode: Zero Trust — 0 Admitted, 0 Axiom, no Section Hypotheses. *)

From Stdlib Require Import Strings.String.
From Stdlib Require Import Lists.List.
From Stdlib Require Import Arith.PeanoNat.
Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Semantics.
Import ListNotations.

(** ** 1. Effect sites *)

(** [sites_in D e]: every [perform] / [require] / [grant] label in [e] is in
    [D]. *)
Fixpoint sites_in (D : effect -> Prop) (e : expr) : Prop :=
  match e with
  | EUnit | EBool _ | EInt _ | EString _ | ELoc _ | EVar _ => True
  | ELam _ _ b => sites_in D b
  | EApp a b | EPair a b | EAssign a b | EDeclassify a b => sites_in D a /\ sites_in D b
  | EFst a | ESnd a | EInl a _ | EInr a _ | ERef a _ | EDeref a
  | EClassify a | EProve a | EFix a => sites_in D a
  | ECase a _ b _ c | EIf a b c => sites_in D a /\ sites_in D b /\ sites_in D c
  | ELet _ a b | EHandle a _ b => sites_in D a /\ sites_in D b
  | EPerform f a | ERequire f a | EGrant f a => D f /\ sites_in D a
  end.

Definition store_sites_in (D : effect -> Prop) (st : store) : Prop :=
  forall l v, store_lookup l st = Some v -> sites_in D v.

(** The effect labels occurring in a term, as a list (for the canonical
    choice of [D] in the corollary). *)
Fixpoint effect_sites (e : expr) : list effect :=
  match e with
  | EUnit | EBool _ | EInt _ | EString _ | ELoc _ | EVar _ => []
  | ELam _ _ b => effect_sites b
  | EApp a b | EPair a b | EAssign a b | EDeclassify a b => effect_sites a ++ effect_sites b
  | EFst a | ESnd a | EInl a _ | EInr a _ | ERef a _ | EDeref a
  | EClassify a | EProve a | EFix a => effect_sites a
  | ECase a _ b _ c | EIf a b c => effect_sites a ++ effect_sites b ++ effect_sites c
  | ELet _ a b | EHandle a _ b => effect_sites a ++ effect_sites b
  | EPerform f a | ERequire f a | EGrant f a => f :: effect_sites a
  end.

Lemma sites_in_effect_sites : forall D e,
  (forall f, In f (effect_sites e) -> D f) -> sites_in D e.
Proof.
  intros D e. induction e; simpl; intros H;
    repeat split;
    try (apply H; left; reflexivity);
    repeat match goal with
           | IH : (forall f, In f (effect_sites ?a) -> D f) -> sites_in D ?a
             |- sites_in D ?a =>
               apply IH; intros f Hf; apply H;
               repeat (first [ assumption
                             | right; assumption
                             | apply in_or_app; first [left; assumption | right] ])
           end.
Qed.

(** ** 2. Substitution and the store add no sites *)

Lemma subst_sites_in : forall D x v e,
  sites_in D v -> sites_in D e -> sites_in D (subst x v e).
Proof.
  intros D x v e Hv. induction e; simpl; intros He;
    repeat match goal with
           | |- context [String.eqb ?a ?b] => destruct (String.eqb a b)
           end;
    simpl; intuition.
Qed.

(** [store_update] is easier to reason about through membership: every
    binding of the updated store is the new one or an old one. *)
Lemma store_lookup_in : forall l st v,
  store_lookup l st = Some v -> In (l, v) st.
Proof.
  intros l st. induction st as [| [l' v'] st' IH]; intros v H; simpl in H.
  - discriminate.
  - destruct (Nat.eqb l l') eqn:E.
    + injection H as <-. apply Nat.eqb_eq in E. subst. left. reflexivity.
    + right. apply IH. exact H.
Qed.

Lemma in_store_update : forall l v st l' v',
  In (l', v') (store_update l v st) -> (l', v') = (l, v) \/ In (l', v') st.
Proof.
  intros l v st. induction st as [| [l0 v0] st IH]; intros l' v' H; simpl in H.
  - destruct H as [H | []]. left. symmetry. exact H.
  - destruct (Nat.eqb l l0).
    + destruct H as [H | H]; [left; symmetry; exact H | right; right; exact H].
    + destruct H as [H | H]; [right; left; exact H |].
      destruct (IH l' v' H) as [H' | H']; [left; exact H' | right; right; exact H'].
Qed.

Definition store_all_sites_in (D : effect -> Prop) (st : store) : Prop :=
  forall l v, In (l, v) st -> sites_in D v.

Lemma store_all_sites_in_lookup : forall D st,
  store_all_sites_in D st -> store_sites_in D st.
Proof. intros D st H l v Hl. exact (H l v (store_lookup_in l st v Hl)). Qed.

Lemma store_update_all_sites_in : forall D st l v,
  store_all_sites_in D st -> sites_in D v -> store_all_sites_in D (store_update l v st).
Proof.
  intros D st l v Hst Hv l' v' Hin.
  destruct (in_store_update l v st l' v' Hin) as [Heq | Hold].
  - injection Heq as -> ->. exact Hv.
  - exact (Hst l' v' Hold).
Qed.

(** ** 3. One step and many steps preserve containment *)

Theorem step_sites_in : forall D e st ctx e' st' ctx',
  (e, st, ctx) --> (e', st', ctx') ->
  sites_in D e -> store_all_sites_in D st ->
  sites_in D e' /\ store_all_sites_in D st'.
Proof.
  intros D e st ctx e' st' ctx' Hstep.
  remember (e, st, ctx) as c1 eqn:E1. remember (e', st', ctx') as c2 eqn:E2.
  revert e st ctx e' st' ctx' E1 E2.
  induction Hstep; intros e0 st0 ctx0 e0' st0' ctx0' E1 E2 He Hst;
    injection E1 as <- <- <-; injection E2 as <- <- <-; simpl in *;
    (* congruence rules: recurse on the stepping subterm *)
    try (match goal with
         | IH : forall e st ctx e' st' ctx', (?a, ?s, ?c) = _ -> (?a', ?s', ?c') = _ ->
                  sites_in D e -> store_all_sites_in D st ->
                  sites_in D e' /\ store_all_sites_in D st' |- _ =>
             let H := fresh "H" in
             let Hs := fresh "Hs" in
             edestruct IH as [H Hs]; [reflexivity | reflexivity | tauto | exact Hst |];
             split; [tauto | exact Hs]
         end).
  - (* ST_AppAbs *) split; [apply subst_sites_in; tauto | exact Hst].
  - (* ST_Fst *) split; [tauto | exact Hst].
  - (* ST_Snd *) split; [tauto | exact Hst].
  - (* ST_CaseInl *) split; [apply subst_sites_in; tauto | exact Hst].
  - (* ST_CaseInr *) split; [apply subst_sites_in; tauto | exact Hst].
  - (* ST_IfTrue *) split; [tauto | exact Hst].
  - (* ST_IfFalse *) split; [tauto | exact Hst].
  - (* ST_LetValue *) split; [apply subst_sites_in; tauto | exact Hst].
  - (* ST_PerformValue *) split; [tauto | exact Hst].
  - (* ST_HandleValue *) split; [apply subst_sites_in; tauto | exact Hst].
  - (* ST_RefValue *) split; [exact I | apply store_update_all_sites_in; tauto].
  - (* ST_DerefLoc *) split; [exact (Hst l v (store_lookup_in l st v H)) | exact Hst].
  - (* ST_AssignLoc *) split; [exact I | apply store_update_all_sites_in; tauto].
  - (* ST_DeclassifyValue *) split; [tauto | exact Hst].
  - (* ST_AppFix *) split; [tauto | exact Hst].
  - (* ST_RequireValue *) split; [tauto | exact Hst].
  - (* ST_GrantValue *) split; [tauto | exact Hst].
Qed.

Theorem multi_step_sites_in : forall D c c',
  c -->* c' ->
  forall e st ctx e' st' ctx',
    c = (e, st, ctx) -> c' = (e', st', ctx') ->
    sites_in D e -> store_all_sites_in D st ->
    sites_in D e' /\ store_all_sites_in D st'.
Proof.
  intros D c c' H. induction H as [c | c1 c2 c3 H12 H23 IH];
    intros e st ctx e' st' ctx' E1 E3 He Hst.
  - subst c. injection E3 as <- <- <-. split; assumption.
  - subst c1 c3. destruct c2 as [[e2 st2] ctx2].
    destruct (step_sites_in D e st ctx e2 st2 ctx2 H12 He Hst) as [He2 Hst2].
    eapply IH; [reflexivity | reflexivity | exact He2 | exact Hst2].
Qed.

(** ** 4. Headline: no effect outside the program's own sites *)

(** Take [D] to be the effect labels written in the program and its initial
    store. Every [perform] / [require] / [grant] site of every reachable
    configuration carries one of those labels. In particular, an effect that
    appears nowhere in the program text or the store is never performed,
    required or granted — independent of [effect_level] and of the effect
    the program is typed at. *)
Theorem reachable_effects_from_program_text : forall e st ctx e' st' ctx',
  (e, st, ctx) -->* (e', st', ctx') ->
  let D := fun f => In f (effect_sites e) \/
                    exists l v, In (l, v) st /\ In f (effect_sites v) in
  sites_in D e' /\ store_all_sites_in D st'.
Proof.
  intros e st ctx e' st' ctx' H D.
  eapply multi_step_sites_in; [exact H | reflexivity | reflexivity | |].
  - apply sites_in_effect_sites. intros f Hf. left. exact Hf.
  - intros l v Hin. apply sites_in_effect_sites. intros f Hf. right. exists l, v. auto.
Qed.

(** Specialisation to one effect: if [f] occurs nowhere in the program or
    the store, no reachable configuration contains an [f] site. *)
Corollary absent_effect_never_reachable : forall f e st ctx e' st' ctx',
  ~ In f (effect_sites e) ->
  (forall l v, In (l, v) st -> ~ In f (effect_sites v)) ->
  (e, st, ctx) -->* (e', st', ctx') ->
  sites_in (fun g => g <> f) e'.
Proof.
  intros f e st ctx e' st' ctx' Hnot Hst H.
  destruct (multi_step_sites_in (fun g => g <> f) _ _ H e st ctx e' st' ctx'
              eq_refl eq_refl) as [He' _].
  - apply sites_in_effect_sites. intros g Hg Heq. subst g. exact (Hnot Hg).
  - intros l v Hin. apply sites_in_effect_sites. intros g Hg Heq. subst g.
    exact (Hst l v Hin Hg).
  - exact He'.
Qed.

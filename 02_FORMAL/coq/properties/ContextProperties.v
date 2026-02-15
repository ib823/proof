(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * Context Properties — Structural Metatheory for RIINA Type System

    Provides structural lemmas about type environments (Γ), store typings (Σ),
    and security contexts (Δ) that are essential for metatheory development.

    Key results:
    - Free variable decidability
    - Context weakening (adding unused bindings)
    - Context strengthening (removing unused bindings)
    - Context exchange (swapping non-conflicting bindings)
    - Security context irrelevance for closed terms
    - Lookup algebra

    Dependencies: Syntax.v, Typing.v, Preservation.v (for context_invariance)

    Mode: Core Deepening | Zero Trust
*)

Require Import Coq.Strings.String.
Require Import Coq.Lists.List.
Require Import Coq.Arith.Arith.
Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Semantics.
Require Import RIINA.foundations.Typing.
Require Import RIINA.type_system.Preservation.
Require Import RIINA.properties.SubstitutionCommute.
Import ListNotations.

(* ================================================================= *)
(** ** Section 1: Free Variable Decidability *)
(* ================================================================= *)

(** Decidability of [free_in]: for any variable [x] and expression [e],
    we can decide whether [x] occurs free in [e]. This is essential for
    automation and case analysis in proofs about weakening/strengthening. *)

Lemma free_in_dec : forall x e, {free_in x e} + {~ free_in x e}.
Proof.
  intros x.
  induction e; simpl.
  - (* EUnit *) right. auto.
  - (* EBool *) right. auto.
  - (* EInt *) right. auto.
  - (* EString *) right. auto.
  - (* ELoc *) right. auto.
  - (* EVar *)
    destruct (String.eqb_spec x i).
    + left. exact e.
    + right. exact n.
  - (* ELam *)
    destruct (String.eqb_spec x i).
    + (* x = binder: not free *)
      right. intros [Hneq _]. subst. apply Hneq. reflexivity.
    + (* x ≠ binder: depends on body *)
      destruct IHe.
      * left. split; assumption.
      * right. intros [_ Hfree]. contradiction.
  - (* EApp *)
    destruct IHe1; destruct IHe2.
    + left. left. assumption.
    + left. left. assumption.
    + left. right. assumption.
    + right. intros [H | H]; contradiction.
  - (* EPair *)
    destruct IHe1; destruct IHe2.
    + left. left. assumption.
    + left. left. assumption.
    + left. right. assumption.
    + right. intros [H | H]; contradiction.
  - (* EFst *)
    destruct IHe.
    + left. assumption.
    + right. assumption.
  - (* ESnd *)
    destruct IHe.
    + left. assumption.
    + right. assumption.
  - (* EInl *)
    destruct IHe.
    + left. assumption.
    + right. assumption.
  - (* EInr *)
    destruct IHe.
    + left. assumption.
    + right. assumption.
  - (* ECase *)
    destruct IHe1.
    + left. left. assumption.
    + destruct (String.eqb_spec x i).
      * destruct (String.eqb_spec x i0).
        -- right. intros [H | [[Hneq _] | [Hneq _]]].
           ++ contradiction.
           ++ subst. apply Hneq. reflexivity.
           ++ subst. apply Hneq. reflexivity.
        -- destruct IHe3.
           ++ left. right. right. split; assumption.
           ++ right. intros [H | [[Hneq _] | [_ Hfr]]].
              ** contradiction.
              ** subst. apply Hneq. reflexivity.
              ** contradiction.
      * destruct IHe2.
        -- left. right. left. split; assumption.
        -- destruct (String.eqb_spec x i0).
           ++ right. intros [H | [[_ Hfr] | [Hneq _]]].
              ** contradiction.
              ** contradiction.
              ** subst. apply Hneq. reflexivity.
           ++ destruct IHe3.
              ** left. right. right. split; assumption.
              ** right. intros [H | [[_ Hfr] | [_ Hfr]]]; contradiction.
  - (* EIf *)
    destruct IHe1; destruct IHe2; destruct IHe3.
    + left. left. assumption.
    + left. left. assumption.
    + left. left. assumption.
    + left. left. assumption.
    + left. right. left. assumption.
    + left. right. left. assumption.
    + left. right. right. assumption.
    + right. intros [H | [H | H]]; contradiction.
  - (* ELet *)
    destruct IHe1.
    + left. left. assumption.
    + destruct (String.eqb_spec x i).
      * right. intros [H | [Hneq _]].
        -- contradiction.
        -- subst. apply Hneq. reflexivity.
      * destruct IHe2.
        -- left. right. split; assumption.
        -- right. intros [H | [_ Hfr]]; contradiction.
  - (* EPerform *)
    destruct IHe.
    + left. assumption.
    + right. assumption.
  - (* EHandle *)
    destruct IHe1.
    + left. left. assumption.
    + destruct (String.eqb_spec x i).
      * right. intros [H | [Hneq _]].
        -- contradiction.
        -- subst. apply Hneq. reflexivity.
      * destruct IHe2.
        -- left. right. split; assumption.
        -- right. intros [H | [_ Hfr]]; contradiction.
  - (* ERef *)
    destruct IHe.
    + left. assumption.
    + right. assumption.
  - (* EDeref *)
    destruct IHe.
    + left. assumption.
    + right. assumption.
  - (* EAssign *)
    destruct IHe1; destruct IHe2.
    + left. left. assumption.
    + left. left. assumption.
    + left. right. assumption.
    + right. intros [H | H]; contradiction.
  - (* EClassify *)
    destruct IHe.
    + left. assumption.
    + right. assumption.
  - (* EDeclassify *)
    destruct IHe1; destruct IHe2.
    + left. left. assumption.
    + left. left. assumption.
    + left. right. assumption.
    + right. intros [H | H]; contradiction.
  - (* EProve *)
    destruct IHe.
    + left. assumption.
    + right. assumption.
  - (* ERequire *)
    destruct IHe.
    + left. assumption.
    + right. assumption.
  - (* EGrant *)
    destruct IHe.
    + left. assumption.
    + right. assumption.
Qed.

(* ================================================================= *)
(** ** Section 2: Lookup Algebra *)
(* ================================================================= *)

(** If lookup finds a binding through a non-matching head, the binding is in the tail. *)
Lemma lookup_cons_neq_inv : forall x y U Γ T,
  lookup x ((y, U) :: Γ) = Some T ->
  x <> y ->
  lookup x Γ = Some T.
Proof.
  intros x y U Γ T Hlook Hneq.
  simpl in Hlook.
  destruct (String.eqb_spec x y).
  - contradiction.
  - exact Hlook.
Qed.

(** Lookup is deterministic (functional). *)
Lemma lookup_deterministic : forall x Γ T1 T2,
  lookup x Γ = Some T1 ->
  lookup x Γ = Some T2 ->
  T1 = T2.
Proof.
  intros x Γ T1 T2 H1 H2.
  rewrite H1 in H2. inversion H2. reflexivity.
Qed.

(** Lookup in an extended context: either the head matches or it's in the tail. *)
Lemma lookup_cons_inv : forall x y U Γ T,
  lookup x ((y, U) :: Γ) = Some T ->
  (x = y /\ T = U) \/ (x <> y /\ lookup x Γ = Some T).
Proof.
  intros x y U Γ T Hlook.
  simpl in Hlook.
  destruct (String.eqb_spec x y).
  - left. split.
    + exact e.
    + inversion Hlook. reflexivity.
  - right. split; assumption.
Qed.

(** Weakening lookup: if x is found in Γ and x ≠ y, x is still found after prepending (y,U). *)
Lemma lookup_weaken_neq : forall x Γ T y U,
  lookup x Γ = Some T ->
  x <> y ->
  lookup x ((y, U) :: Γ) = Some T.
Proof.
  intros x Γ T y U Hlook Hneq.
  simpl. destruct (String.eqb_spec x y).
  - contradiction.
  - exact Hlook.
Qed.

(* ================================================================= *)
(** ** Section 3: Context Weakening *)
(* ================================================================= *)

(** Adding an unused binding to the head of Γ preserves typing.
    This is a direct corollary of [context_invariance] from Preservation.v. *)

Lemma typing_weaken_head : forall Γ Σ Δ e T ε y U,
  has_type Γ Σ Δ e T ε ->
  ~ free_in y e ->
  has_type ((y, U) :: Γ) Σ Δ e T ε.
Proof.
  intros Γ Σ Δ e T ε y U Hty Hnfree.
  eapply context_invariance.
  - exact Hty.
  - intros x Hfree.
    simpl. destruct (String.eqb_spec x y).
    + subst. contradiction.
    + reflexivity.
Qed.

(** Unconditional weakening when the new binding's name is fresh
    (not in the domain of Γ and not free in e).
    Convenience wrapper combining free_in_context with typing_weaken_head. *)

Lemma typing_weaken_fresh : forall Γ Σ Δ e T ε y U,
  has_type Γ Σ Δ e T ε ->
  lookup y Γ = None ->
  has_type ((y, U) :: Γ) Σ Δ e T ε.
Proof.
  intros Γ Σ Δ e T ε y U Hty Hfresh.
  apply typing_weaken_head; auto.
  intro Hfree.
  destruct (free_in_context _ _ _ _ _ _ _ Hfree Hty) as [T' Hlook].
  rewrite Hfresh in Hlook. discriminate.
Qed.

(* ================================================================= *)
(** ** Section 4: Context Strengthening *)
(* ================================================================= *)

(** Removing an unused head binding preserves typing.
    Dual of [typing_weaken_head]. *)

Lemma typing_strengthen_head : forall Γ Σ Δ e T ε y U,
  has_type ((y, U) :: Γ) Σ Δ e T ε ->
  ~ free_in y e ->
  has_type Γ Σ Δ e T ε.
Proof.
  intros Γ Σ Δ e T ε y U Hty Hnfree.
  eapply context_invariance.
  - exact Hty.
  - intros x Hfree.
    simpl. destruct (String.eqb_spec x y).
    + subst. contradiction.
    + reflexivity.
Qed.

(* ================================================================= *)
(** ** Section 5: Context Exchange *)
(* ================================================================= *)

(** Swapping two non-conflicting adjacent bindings preserves typing. *)

Lemma typing_exchange : forall Γ Σ Δ e T ε x Tx y Ty,
  has_type ((x, Tx) :: (y, Ty) :: Γ) Σ Δ e T ε ->
  x <> y ->
  has_type ((y, Ty) :: (x, Tx) :: Γ) Σ Δ e T ε.
Proof.
  intros Γ Σ Δ e T ε x Tx y Ty Hty Hneq.
  eapply context_invariance.
  - exact Hty.
  - intros z Hfree.
    simpl.
    destruct (String.eqb_spec z x); destruct (String.eqb_spec z y);
      subst; try contradiction; reflexivity.
Qed.

(* ================================================================= *)
(** ** Section 6: Security Context Irrelevance *)
(* ================================================================= *)

(** The security context Δ does not affect typing derivations.
    This is because no typing rule discriminates on the value of Δ;
    it is threaded uniformly through all rules. *)

Lemma typing_delta_irrelevance : forall Γ Σ Δ1 Δ2 e T ε,
  has_type Γ Σ Δ1 e T ε ->
  has_type Γ Σ Δ2 e T ε.
Proof.
  intros Γ Σ Δ1 Δ2 e T ε Hty.
  induction Hty.
  - (* T_Unit *) constructor.
  - (* T_Bool *) constructor.
  - (* T_Int *) constructor.
  - (* T_String *) constructor.
  - (* T_Loc *) econstructor. eassumption.
  - (* T_Var *) constructor. assumption.
  - (* T_Lam *) constructor. apply IHHty.
  - (* T_App *) eapply T_App; eauto.
  - (* T_Pair *) eapply T_Pair; eauto.
  - (* T_Fst *) eapply T_Fst; eauto.
  - (* T_Snd *) eapply T_Snd; eauto.
  - (* T_Inl *) eapply T_Inl; eauto.
  - (* T_Inr *) eapply T_Inr; eauto.
  - (* T_Case *) eapply T_Case; eauto.
  - (* T_If *) eapply T_If; eauto.
  - (* T_Let *) eapply T_Let; eauto.
  - (* T_Perform *) eapply T_Perform; eauto.
  - (* T_Handle *) eapply T_Handle; eauto.
  - (* T_Ref *) eapply T_Ref; eauto.
  - (* T_Deref *) eapply T_Deref; eauto.
  - (* T_Assign *) eapply T_Assign; eauto.
  - (* T_Classify *) eapply T_Classify; eauto.
  - (* T_Declassify *)
    eapply T_Declassify; eauto.
  - (* T_Prove *) eapply T_Prove; eauto.
  - (* T_Require *) eapply T_Require; eauto.
  - (* T_Grant *) eapply T_Grant; eauto.
Qed.

(* ================================================================= *)
(** ** Section 7: Shadow Elimination *)
(* ================================================================= *)

(** If a binding (x, T1) shadows an earlier (x, T2), the earlier is irrelevant. *)

Lemma typing_shadow : forall Γ Σ Δ e T ε x T1 T2,
  has_type ((x, T1) :: (x, T2) :: Γ) Σ Δ e T ε ->
  has_type ((x, T1) :: Γ) Σ Δ e T ε.
Proof.
  intros Γ Σ Δ e T ε x T1 T2 Hty.
  eapply context_invariance.
  - exact Hty.
  - intros z Hfree.
    simpl. destruct (String.eqb_spec z x).
    + reflexivity.
    + reflexivity.
Qed.

(* ================================================================= *)
(** ** Section 8: Closed Term Properties *)
(* ================================================================= *)

(** A well-typed closed term has no free variables.
    This is a direct consequence of [free_in_context]. *)

Lemma closed_no_free_vars : forall Σ Δ e T ε x,
  has_type nil Σ Δ e T ε ->
  ~ free_in x e.
Proof.
  intros Σ Δ e T ε x Hty Hfree.
  destruct (free_in_context _ _ _ _ _ _ _ Hfree Hty) as [T' Hlook].
  simpl in Hlook. discriminate.
Qed.

(** Closed terms can be typed in any type environment.
    This re-exports [closed_typing_weakening] under a more discoverable name. *)

Lemma typing_weaken_closed : forall Γ Σ Δ e T ε,
  has_type nil Σ Δ e T ε ->
  has_type Γ Σ Δ e T ε.
Proof.
  intros. apply closed_typing_weakening. assumption.
Qed.

(* ================================================================= *)
(** ** Section 9: Multi-Binding Weakening *)
(* ================================================================= *)

(** Weakening by an entire list of bindings, when the expression is closed. *)

Lemma typing_weaken_multi_closed : forall Γ1 Γ2 Σ Δ e T ε,
  has_type nil Σ Δ e T ε ->
  has_type (Γ1 ++ Γ2) Σ Δ e T ε.
Proof.
  intros. apply typing_weaken_closed. assumption.
Qed.

(** Weakening by prepending a list of bindings when none shadow free variables. *)

Lemma typing_weaken_prefix : forall Γ1 Γ2 Σ Δ e T ε,
  has_type Γ2 Σ Δ e T ε ->
  (forall x, free_in x e -> lookup x Γ2 = lookup x (Γ1 ++ Γ2)) ->
  has_type (Γ1 ++ Γ2) Σ Δ e T ε.
Proof.
  intros Γ1 Γ2 Σ Δ e T ε Hty Hlook.
  eapply context_invariance.
  - exact Hty.
  - exact Hlook.
Qed.

(* ================================================================= *)
(** ** Section 10: Store Typing Extension Composition *)
(* ================================================================= *)

(** Store typing extension is reflexive.
    Re-exported from StrongNorm.v for discoverability. *)

Lemma store_extends_refl : forall Σ,
  store_ty_extends Σ Σ.
Proof.
  intros Σ l T sl H. exact H.
Qed.

(** Store typing extension is transitive.
    Re-exported from Typing.v for discoverability. *)

Lemma store_extends_trans : forall Σ1 Σ2 Σ3,
  store_ty_extends Σ1 Σ2 ->
  store_ty_extends Σ2 Σ3 ->
  store_ty_extends Σ1 Σ3.
Proof.
  intros Σ1 Σ2 Σ3 H12 H23.
  intros l T sl Hlook.
  apply H23. apply H12. exact Hlook.
Qed.

(** Store extension preserves well-typedness (lifts store_ty_extends_preserves_typing
    to a more discoverable name). *)

Lemma typing_weaken_store : forall Γ Σ Σ' Δ e T ε,
  has_type Γ Σ Δ e T ε ->
  store_ty_extends Σ Σ' ->
  has_type Γ Σ' Δ e T ε.
Proof.
  intros. eapply store_ty_extends_preserves_typing; eassumption.
Qed.

(* ================================================================= *)
(** ** Section 11: Combined Structural Lemmas *)
(* ================================================================= *)

(** Weaken both context and security level simultaneously. *)

Lemma typing_weaken_head_delta : forall Γ Σ Δ1 Δ2 e T ε y U,
  has_type Γ Σ Δ1 e T ε ->
  ~ free_in y e ->
  has_type ((y, U) :: Γ) Σ Δ2 e T ε.
Proof.
  intros.
  apply typing_delta_irrelevance with (Δ1 := Δ1).
  apply typing_weaken_head; assumption.
Qed.

(** Weakening after exchange: if we have typing in Γ and x ≠ y,
    we can add both bindings in either order. *)

Lemma typing_weaken_two : forall Γ Σ Δ e T ε x Tx y Ty,
  has_type Γ Σ Δ e T ε ->
  ~ free_in x e ->
  ~ free_in y e ->
  has_type ((x, Tx) :: (y, Ty) :: Γ) Σ Δ e T ε.
Proof.
  intros.
  apply typing_weaken_head; auto.
  apply typing_weaken_head; auto.
Qed.

(** Weakening + store extension simultaneously. *)

Lemma typing_weaken_head_store : forall Γ Σ Σ' Δ e T ε y U,
  has_type Γ Σ Δ e T ε ->
  ~ free_in y e ->
  store_ty_extends Σ Σ' ->
  has_type ((y, U) :: Γ) Σ' Δ e T ε.
Proof.
  intros.
  apply typing_weaken_store with (Σ := Σ); auto.
  apply typing_weaken_head; assumption.
Qed.

(* ================================================================= *)
(** ** Section 12: Lookup Append Properties *)
(* ================================================================= *)

(** If x is found in the first context, it's found in the append. *)
Lemma lookup_app_l : forall x Γ1 Γ2 T,
  lookup x Γ1 = Some T ->
  lookup x (Γ1 ++ Γ2) = Some T.
Proof.
  intros x Γ1. induction Γ1 as [| [y U] Γ1' IH]; intros Γ2 T Hlook.
  - simpl in Hlook. discriminate.
  - simpl in *. destruct (String.eqb x y).
    + exact Hlook.
    + apply IH. exact Hlook.
Qed.

(** If x is not in the first context, lookup in append depends on the tail. *)
Lemma lookup_app_r : forall x Γ1 Γ2,
  lookup x Γ1 = None ->
  lookup x (Γ1 ++ Γ2) = lookup x Γ2.
Proof.
  intros x Γ1. induction Γ1 as [| [y U] Γ1' IH]; intros Γ2 Hlook.
  - simpl. reflexivity.
  - simpl in *. destruct (String.eqb x y).
    + discriminate.
    + apply IH. exact Hlook.
Qed.

(** Lookup in nil is always None. *)
Lemma lookup_nil : forall x, lookup x nil = None.
Proof. intros. reflexivity. Qed.

(** If lookup succeeds in the head, x equals the head's name. *)
Lemma lookup_head_eq : forall x T Γ,
  lookup x ((x, T) :: Γ) = Some T.
Proof.
  intros. simpl. rewrite String.eqb_refl. reflexivity.
Qed.

(* ================================================================= *)
(** ** Section 13: Context Contraction *)
(* ================================================================= *)

(** Duplicate adjacent bindings can be contracted.
    (x,T)::(x,T)::Γ ≡ (x,T)::Γ *)

Lemma typing_contract : forall Γ Σ Δ e T ε x Tx,
  has_type ((x, Tx) :: (x, Tx) :: Γ) Σ Δ e T ε ->
  has_type ((x, Tx) :: Γ) Σ Δ e T ε.
Proof.
  intros. apply typing_shadow with (T2 := Tx). assumption.
Qed.

(* ================================================================= *)
(** ** Section 14: Store Typing Well-Formedness *)
(* ================================================================= *)

(** If store is well-formed, every runtime value has a store typing entry. *)
Lemma store_wf_runtime_entry_typed : forall Σ st l v,
  store_wf Σ st ->
  store_lookup l st = Some v ->
  exists T sl, store_ty_lookup l Σ = Some (T, sl).
Proof.
  intros Σ st l v Hwf Hst.
  destruct Hwf as [_ Hrev].
  specialize (Hrev l v Hst).
  destruct Hrev as [T [sl [Hty _]]].
  exists T, sl. exact Hty.
Qed.

(** Store well-formedness implies typed and runtime stores agree on domain. *)
Lemma store_wf_bidirectional : forall Σ st l,
  store_wf Σ st ->
  (exists T sl, store_ty_lookup l Σ = Some (T, sl)) <->
  (exists v, store_lookup l st = Some v).
Proof.
  intros Σ st l Hwf. split.
  - intros [T [sl Hlook]].
    destruct Hwf as [Hfwd _].
    specialize (Hfwd l T sl Hlook).
    destruct Hfwd as [v [Hst _]].
    exists v. exact Hst.
  - intros [v Hst].
    destruct Hwf as [_ Hrev].
    specialize (Hrev l v Hst).
    destruct Hrev as [T [sl [Hty _]]].
    exists T, sl. exact Hty.
Qed.

(* ================================================================= *)
(** ** Section 15: Typing Substitution Invariance *)
(* ================================================================= *)

(** Substitution into closed (well-typed in empty context) terms is the identity. *)
Lemma subst_closed_typing : forall Σ Δ e T ε x v,
  has_type nil Σ Δ e T ε ->
  [x := v] e = e.
Proof.
  intros Σ Δ e T ε x v Hty.
  apply subst_not_free_sc.
  intros Hfree.
  destruct (free_in_context _ _ _ _ _ _ _ Hfree Hty) as [T' Hlook].
  simpl in Hlook. discriminate.
Qed.

(** Weakening by a list of fresh bindings preserves typing for open terms. *)
Lemma typing_weaken_fresh_list : forall Γ1 Γ2 Σ Δ e T ε,
  has_type Γ2 Σ Δ e T ε ->
  (forall x, free_in x e -> lookup x Γ1 = None) ->
  has_type (Γ1 ++ Γ2) Σ Δ e T ε.
Proof.
  intros Γ1 Γ2 Σ Δ e T ε Hty Hfresh.
  eapply context_invariance.
  - exact Hty.
  - intros x Hfree.
    specialize (Hfresh x Hfree).
    symmetry. apply lookup_app_r. exact Hfresh.
Qed.

(* ================================================================= *)
(** ** Section 16: Lookup Domain Properties *)
(* ================================================================= *)

(** Lookup in a singleton context. *)
Lemma lookup_singleton : forall x T,
  lookup x ((x, T) :: nil) = Some T.
Proof.
  intros. simpl. rewrite String.eqb_refl. reflexivity.
Qed.

(** If lookup in (y,U)::Γ returns T and x ≠ y, then T comes from Γ.
    (Same as lookup_cons_inv above but with reordered args for ergonomics.) *)
Lemma lookup_cons_tail : forall x y U T Γ,
  x <> y ->
  lookup x ((y, U) :: Γ) = Some T ->
  lookup x Γ = Some T.
Proof.
  intros x y U T Γ Hneq Hlook.
  simpl in Hlook. destruct (String.eqb_spec x y).
  - contradiction.
  - exact Hlook.
Qed.

(** Lookup is decidable. *)
Lemma lookup_dec : forall x Γ,
  {exists T, lookup x Γ = Some T} + {lookup x Γ = None}.
Proof.
  intros x Γ. destruct (lookup x Γ) eqn:Hlook.
  - left. exists t. reflexivity.
  - right. reflexivity.
Defined.

(* ================================================================= *)
(** ** Section 17: Typing and Free Variables *)
(* ================================================================= *)

(** If a variable x has a binding in Γ and e is typed in Γ, then either
    x is free in e or the binding is unused. This is the contrapositive
    of free_in_context. *)
Lemma typed_var_bound : forall x Γ Σ Δ T ε,
  has_type Γ Σ Δ (EVar x) T ε ->
  lookup x Γ = Some T.
Proof.
  intros x Γ Σ Δ T ε Hty.
  inversion Hty; subst. assumption.
Qed.

(** Closed terms are invariant under any context and security level change. *)
Lemma closed_typing_any_ctx : forall Γ Σ Δ1 Δ2 e T ε,
  has_type nil Σ Δ1 e T ε ->
  has_type Γ Σ Δ2 e T ε.
Proof.
  intros.
  apply typing_delta_irrelevance with (Δ1 := Δ1).
  apply typing_weaken_closed. assumption.
Qed.

(** Weakening commutes with exchange: can weaken and exchange simultaneously. *)
Lemma typing_weaken_exchange : forall Γ Σ Δ e T ε x Tx y Ty,
  has_type Γ Σ Δ e T ε ->
  ~ free_in x e ->
  ~ free_in y e ->
  x <> y ->
  has_type ((y, Ty) :: (x, Tx) :: Γ) Σ Δ e T ε.
Proof.
  intros Γ Σ Δ e T ε x Tx y Ty Hty Hx Hy Hneq.
  apply typing_exchange with (x := x) (y := y); auto.
  apply typing_weaken_two; assumption.
Qed.

(* ================================================================= *)
(** ** Section 18: Context Length and Induction Helpers *)
(* ================================================================= *)

(** Weakening by appending: lookup agreement on free vars gives typing. *)
Lemma typing_weaken_append : forall Γ1 Γ2 Σ Δ e T ε,
  has_type Γ1 Σ Δ e T ε ->
  has_type (Γ1 ++ Γ2) Σ Δ e T ε.
Proof.
  intros Γ1 Γ2 Σ Δ e T ε Hty.
  eapply context_invariance.
  - exact Hty.
  - intros x Hfree.
    destruct (free_in_context _ _ _ _ _ _ _ Hfree Hty) as [T' Hlook].
    rewrite Hlook. symmetry. apply lookup_app_l. exact Hlook.
Qed.

(** Removing a suffix from Γ preserves typing if all free variables
    are bound in the prefix. *)
Lemma typing_prefix_sufficient : forall Γ1 Γ2 Σ Δ e T ε,
  has_type (Γ1 ++ Γ2) Σ Δ e T ε ->
  (forall x, free_in x e -> lookup x Γ1 = lookup x (Γ1 ++ Γ2)) ->
  has_type Γ1 Σ Δ e T ε.
Proof.
  intros Γ1 Γ2 Σ Δ e T ε Hty Hagree.
  eapply context_invariance.
  - exact Hty.
  - intros x Hfree. symmetry. apply Hagree. exact Hfree.
Qed.

(** Typing in singleton context: a variable is well-typed with pure effect. *)
Lemma typing_singleton_var : forall x T Σ Δ,
  has_type ((x, T) :: nil) Σ Δ (EVar x) T EffectPure.
Proof.
  intros. apply T_Var. simpl. rewrite String.eqb_refl. reflexivity.
Qed.

(** End of ContextProperties.v *)

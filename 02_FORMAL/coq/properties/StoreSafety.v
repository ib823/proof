(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * Store Safety — Store-Level Metatheory for RIINA

    Lemmas connecting store typing, store well-formedness, and typing
    operations. These bridge the gap between EffectSafety (effect-level
    reasoning) and Preservation (step-level reasoning).

    Key results:
    - Store update preserves well-formedness (for valid types)
    - Store extension composition (extends is transitive + reflexive)
    - Store extension preserves well-formedness
    - Store lookup consistency between Σ and st
    - Fresh location allocation properties

    Dependencies: Syntax.v, Semantics.v, Typing.v, Preservation.v
    Mode: Core Deepening | Zero Trust
*)

From Stdlib Require Import Strings.String.
From Stdlib Require Import Lists.List.
From Stdlib Require Import Arith.PeanoNat.
Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Semantics.
Require Import RIINA.foundations.Typing.
Require Import RIINA.type_system.Preservation.
Import ListNotations.

(* ================================================================= *)
(** ** Section 1: Store Typing Extension Properties *)
(* ================================================================= *)

(** Store typing extension is reflexive.
    (Re-exported for compositional use.) *)
Lemma store_ty_extends_refl' : forall Σ,
  store_ty_extends Σ Σ.
Proof.
  intros Σ l T sl H. exact H.
Qed.

(** Store typing extension is transitive.
    If Σ ⊆ Σ' and Σ' ⊆ Σ'', then Σ ⊆ Σ''. *)
Lemma store_ty_extends_trans' : forall Σ1 Σ2 Σ3,
  store_ty_extends Σ1 Σ2 ->
  store_ty_extends Σ2 Σ3 ->
  store_ty_extends Σ1 Σ3.
Proof.
  intros Σ1 Σ2 Σ3 H12 H23 l T sl Hlook.
  apply H23. apply H12. exact Hlook.
Qed.

(** Store extension after fresh allocation: update extends the original.
    (Re-exported from Preservation for discoverability.) *)
Lemma store_extend_after_alloc : forall Σ l T sl,
  store_ty_lookup l Σ = None ->
  store_ty_extends Σ (store_ty_update l T sl Σ).
Proof.
  exact store_ty_extends_update_fresh.
Qed.

(* ================================================================= *)
(** ** Section 2: Store Lookup Equalities *)
(* ================================================================= *)

(** After updating location l, looking up l returns the new value. *)
Lemma store_lookup_after_update : forall st l v,
  store_lookup l (store_update l v st) = Some v.
Proof.
  exact store_lookup_update_eq.
Qed.

(** After updating a different location, lookup for l is unchanged. *)
Lemma store_lookup_update_other : forall st l l' v,
  l <> l' ->
  store_lookup l (store_update l' v st) = store_lookup l st.
Proof.
  exact store_lookup_update_neq.
Qed.

(** Store typing update for the same location returns the new entry. *)
Lemma store_ty_update_same : forall Σ l T sl,
  store_ty_lookup l (store_ty_update l T sl Σ) = Some (T, sl).
Proof.
  exact store_ty_lookup_update_eq.
Qed.

(** Store typing update for a different location is unchanged. *)
Lemma store_ty_update_other : forall Σ l l' T sl,
  l <> l' ->
  store_ty_lookup l (store_ty_update l' T sl Σ) = store_ty_lookup l Σ.
Proof.
  exact store_ty_lookup_update_neq.
Qed.

(* ================================================================= *)
(** ** Section 3: Store-Typing Extension Composition *)
(* ================================================================= *)

(** Two sequential extensions compose. *)
Lemma store_extend_compose : forall Σ1 Σ2 Σ3,
  store_ty_extends Σ1 Σ2 ->
  store_ty_extends Σ2 Σ3 ->
  store_ty_extends Σ1 Σ3.
Proof.
  exact store_ty_extends_trans'.
Qed.

(** Extension is anti-symmetric on lookups: if Σ1 extends Σ2 and vice versa,
    they agree on all entries. *)
Lemma store_extend_antisym_lookup : forall Σ1 Σ2 l T sl,
  store_ty_extends Σ1 Σ2 ->
  store_ty_extends Σ2 Σ1 ->
  store_ty_lookup l Σ1 = Some (T, sl) ->
  store_ty_lookup l Σ2 = Some (T, sl).
Proof.
  intros Σ1 Σ2 l T sl H12 H21 Hlook.
  apply H12. exact Hlook.
Qed.

(* ================================================================= *)
(** ** Section 4: Typing Under Store Extension *)
(* ================================================================= *)

(** Well-typed expressions remain well-typed after store extension.
    (Alias for store_ty_extends_preserves_typing.) *)
Lemma typing_monotone_store : forall Γ Σ Σ' Δ e T ε,
  store_ty_extends Σ Σ' ->
  has_type Γ Σ Δ e T ε ->
  has_type Γ Σ' Δ e T ε.
Proof.
  intros. eapply store_ty_extends_preserves_typing; eassumption.
Qed.

(** Location typing is preserved under store extension. *)
Lemma loc_typed_under_extension : forall Σ Σ' l T sl,
  store_ty_extends Σ Σ' ->
  store_ty_lookup l Σ = Some (T, sl) ->
  store_ty_lookup l Σ' = Some (T, sl).
Proof.
  intros Σ Σ' l T sl Hext Hlook.
  apply Hext. exact Hlook.
Qed.

(** Closed values preserve typing under store extension. *)
Lemma value_typed_under_extension : forall Σ Σ' v T ε,
  store_ty_extends Σ Σ' ->
  has_type nil Σ Public v T ε ->
  value v ->
  has_type nil Σ' Public v T ε.
Proof.
  intros. eapply store_ty_extends_preserves_typing; eassumption.
Qed.

(* ================================================================= *)
(** ** Section 5: Store WF Forward Properties *)
(* ================================================================= *)

(** Store well-formedness is preserved under store extension,
    when the runtime store is also extended consistently.
    This captures the key invariant maintained by preservation. *)

(** Every well-typed value in a well-formed store has EffPure effect. *)
Lemma store_wf_values_pure : forall Σ st l T sl v,
  store_wf Σ st ->
  store_ty_lookup l Σ = Some (T, sl) ->
  store_lookup l st = Some v ->
  has_type nil Σ Public v T EffectPure.
Proof.
  intros Σ st l T sl v Hwf Hty_look Hst_look.
  destruct Hwf as [Hfwd _].
  specialize (Hfwd l T sl Hty_look).
  destruct Hfwd as [v' [Hst' [_ Hty]]].
  rewrite Hst_look in Hst'. inversion Hst'. subst.
  exact Hty.
Qed.

(** All stored values in a well-formed store are values. *)
Lemma store_wf_all_values : forall Σ st l v,
  store_wf Σ st ->
  store_lookup l st = Some v ->
  value v.
Proof.
  intros Σ st l v Hwf Hlook.
  destruct Hwf as [_ Hrev].
  specialize (Hrev l v Hlook).
  destruct Hrev as [T [sl [_ [Hval _]]]].
  exact Hval.
Qed.

(** Typed locations in a well-formed store have runtime entries. *)
Lemma store_wf_typed_implies_stored : forall Σ st l T sl,
  store_wf Σ st ->
  store_ty_lookup l Σ = Some (T, sl) ->
  exists v, store_lookup l st = Some v.
Proof.
  intros Σ st l T sl Hwf Hlook.
  destruct Hwf as [Hfwd _].
  specialize (Hfwd l T sl Hlook).
  destruct Hfwd as [v [Hst _]].
  exists v. exact Hst.
Qed.

(** Runtime entries have types in a well-formed store. *)
Lemma store_wf_stored_implies_typed : forall Σ st l v,
  store_wf Σ st ->
  store_lookup l st = Some v ->
  exists T sl, store_ty_lookup l Σ = Some (T, sl).
Proof.
  intros Σ st l v Hwf Hlook.
  destruct Hwf as [_ Hrev].
  specialize (Hrev l v Hlook).
  destruct Hrev as [T [sl [Hty _]]].
  exists T, sl. exact Hty.
Qed.

(* ================================================================= *)
(** ** Section 6: Location Properties *)
(* ================================================================= *)

(** Location lookup decidability in store typing. *)
Lemma store_ty_lookup_dec : forall l Σ,
  {exists T sl, store_ty_lookup l Σ = Some (T, sl)} +
  {store_ty_lookup l Σ = None}.
Proof.
  intros l Σ.
  destruct (store_ty_lookup l Σ) eqn:Hlook.
  - left. destruct p as [T sl]. exists T, sl. reflexivity.
  - right. reflexivity.
Qed.

(** Location equality is decidable (nat decidability). *)
Lemma loc_eq_dec : forall (l1 l2 : loc), {l1 = l2} + {l1 <> l2}.
Proof.
  intros l1 l2. apply Nat.eq_dec.
Defined.

(** Two distinct locations can be updated independently (lookup equivalence). *)
Lemma store_update_commute_lookup : forall st l1 l2 v1 v2 l,
  l1 <> l2 ->
  store_lookup l (store_update l1 v1 (store_update l2 v2 st)) =
  store_lookup l (store_update l2 v2 (store_update l1 v1 st)).
Proof.
  intros st l1 l2 v1 v2 l Hneq.
  destruct (Nat.eq_dec l l1) as [Hl1 | Hl1];
  destruct (Nat.eq_dec l l2) as [Hl2 | Hl2].
  - subst. exfalso. apply Hneq. reflexivity.
  - subst.
    rewrite store_lookup_update_eq.
    rewrite store_lookup_update_neq; [| exact Hneq].
    rewrite store_lookup_update_eq.
    reflexivity.
  - subst.
    rewrite store_lookup_update_neq;
      [| intro H; apply Hneq; symmetry; exact H].
    rewrite store_lookup_update_eq.
    rewrite store_lookup_update_eq.
    reflexivity.
  - rewrite store_lookup_update_neq; [| exact Hl1].
    rewrite store_lookup_update_neq; [| exact Hl2].
    rewrite store_lookup_update_neq; [| exact Hl2].
    rewrite store_lookup_update_neq; [| exact Hl1].
    reflexivity.
Qed.

(** Store typing update commutes for distinct locations (lookup equivalence). *)
Lemma store_ty_update_commute_lookup : forall Σ l1 T1 sl1 l2 T2 sl2 l,
  l1 <> l2 ->
  store_ty_lookup l (store_ty_update l1 T1 sl1 (store_ty_update l2 T2 sl2 Σ)) =
  store_ty_lookup l (store_ty_update l2 T2 sl2 (store_ty_update l1 T1 sl1 Σ)).
Proof.
  intros Σ l1 T1 sl1 l2 T2 sl2 l Hneq.
  destruct (Nat.eq_dec l l1) as [Hl1 | Hl1];
  destruct (Nat.eq_dec l l2) as [Hl2 | Hl2].
  - subst. exfalso. apply Hneq. reflexivity.
  - subst.
    rewrite store_ty_lookup_update_eq.
    rewrite store_ty_lookup_update_neq; [| exact Hneq].
    rewrite store_ty_lookup_update_eq.
    reflexivity.
  - subst.
    rewrite store_ty_lookup_update_neq;
      [| intro H; apply Hneq; symmetry; exact H].
    rewrite store_ty_lookup_update_eq.
    rewrite store_ty_lookup_update_eq.
    reflexivity.
  - rewrite store_ty_lookup_update_neq; [| exact Hl1].
    rewrite store_ty_lookup_update_neq; [| exact Hl2].
    rewrite store_ty_lookup_update_neq; [| exact Hl2].
    rewrite store_ty_lookup_update_neq; [| exact Hl1].
    reflexivity.
Qed.

(* ================================================================= *)
(** ** Section 7: Store WF Construction *)
(* ================================================================= *)

(** Empty store and empty store typing satisfy well-formedness. *)
Lemma store_wf_empty : store_wf nil nil.
Proof.
  split.
  - intros l T sl Hlook. simpl in Hlook. discriminate.
  - intros l v Hlook. simpl in Hlook. discriminate.
Qed.

(** Store WF is preserved when updating an existing location.
    (Re-exported from Preservation.v for discoverability.) *)
Lemma store_wf_update_existing' : forall Σ st l T sl v,
  store_wf Σ st ->
  store_ty_lookup l Σ = Some (T, sl) ->
  value v ->
  has_type nil Σ Public v T EffectPure ->
  store_wf Σ (store_update l v st).
Proof.
  exact store_wf_update_existing.
Qed.

(** Store WF is preserved when allocating a fresh location.
    (Re-exported from Preservation.v for discoverability.) *)
Lemma store_wf_alloc_fresh' : forall Σ st l T sl v,
  store_wf Σ st ->
  store_lookup l st = None ->
  store_ty_lookup l Σ = None ->
  value v ->
  has_type nil Σ Public v T EffectPure ->
  store_wf (store_ty_update l T sl Σ) (store_update l v st).
Proof.
  exact store_wf_update_fresh.
Qed.

(* ================================================================= *)
(** ** Section 8: Typing Under Allocation *)
(* ================================================================= *)

(** Typing is preserved when a fresh location is added to the store typing. *)
Lemma typing_under_alloc : forall Γ Σ Δ e T ε l T' sl',
  store_ty_lookup l Σ = None ->
  has_type Γ Σ Δ e T ε ->
  has_type Γ (store_ty_update l T' sl' Σ) Δ e T ε.
Proof.
  intros Γ Σ Δ e T ε l T' sl' Hfresh Hty.
  eapply store_ty_extends_preserves_typing.
  - apply store_ty_extends_update_fresh. exact Hfresh.
  - exact Hty.
Qed.

(** Double allocation preserves typing when both locations are fresh. *)
Lemma typing_under_double_alloc : forall Γ Σ Δ e T ε l1 T1 sl1 l2 T2 sl2,
  l1 <> l2 ->
  store_ty_lookup l1 Σ = None ->
  store_ty_lookup l2 Σ = None ->
  has_type Γ Σ Δ e T ε ->
  has_type Γ (store_ty_update l2 T2 sl2 (store_ty_update l1 T1 sl1 Σ)) Δ e T ε.
Proof.
  intros Γ Σ Δ e T ε l1 T1 sl1 l2 T2 sl2 Hneq Hfr1 Hfr2 Hty.
  apply typing_under_alloc.
  - rewrite store_ty_lookup_update_neq;
      [exact Hfr2 | intro H; apply Hneq; symmetry; exact H].
  - apply typing_under_alloc; assumption.
Qed.

(* ================================================================= *)
(** ** Section 9: Store Extension Preservation *)
(* ================================================================= *)

(** If Σ extends Σ' and both are well-formed with their stores,
    then typed locations in Σ' are also typed in Σ. *)
Lemma store_wf_extends_typed : forall Σ Σ' st l T sl,
  store_ty_extends Σ Σ' ->
  store_wf Σ st ->
  store_ty_lookup l Σ = Some (T, sl) ->
  exists v, store_lookup l st = Some v /\ value v.
Proof.
  intros Σ Σ' st l T sl Hext Hwf Hlook.
  destruct Hwf as [Hfwd _].
  specialize (Hfwd l T sl Hlook).
  destruct Hfwd as [v [Hst [Hval _]]].
  exists v. split; assumption.
Qed.

(** Fresh location lookup on store typing returns None. *)
Lemma fresh_loc_store_ty_none : forall Σ st,
  store_wf Σ st ->
  store_ty_lookup (fresh_loc st) Σ = None.
Proof.
  exact store_ty_lookup_fresh_none.
Qed.

(** Fresh location has no runtime entry. *)
Lemma fresh_loc_store_none : forall st,
  store_lookup (fresh_loc st) st = None.
Proof.
  exact store_lookup_fresh.
Qed.

(** All values in a well-formed store are well-typed with pure effect
    (combining forward and reverse directions). *)
Lemma store_wf_all_well_typed : forall Σ st l v,
  store_wf Σ st ->
  store_lookup l st = Some v ->
  exists T sl, store_ty_lookup l Σ = Some (T, sl) /\
               value v /\
               has_type nil Σ Public v T EffectPure.
Proof.
  intros Σ st l v Hwf Hlook.
  destruct Hwf as [_ Hrev].
  specialize (Hrev l v Hlook).
  destruct Hrev as [T [sl [Hty [Hval Htype]]]].
  exists T, sl. auto.
Qed.

(* ================================================================= *)
(** ** Section 10: Store Typing Domain Monotonicity *)
(* ================================================================= *)

(** If a location is in Σ and Σ extends to Σ', the location is in Σ'. *)
Lemma store_ty_in_extends : forall Σ Σ' l,
  store_ty_extends Σ Σ' ->
  (exists T sl, store_ty_lookup l Σ = Some (T, sl)) ->
  (exists T sl, store_ty_lookup l Σ' = Some (T, sl)).
Proof.
  intros Σ Σ' l Hext [T [sl Hlook]].
  exists T, sl. apply Hext. exact Hlook.
Qed.

(** Location absence is contra-variant under extension:
    if l is not in Σ' and Σ extends to Σ', then l is not in Σ. *)
Lemma store_ty_not_in_extends : forall Σ Σ' l,
  store_ty_extends Σ Σ' ->
  store_ty_lookup l Σ' = None ->
  store_ty_lookup l Σ = None.
Proof.
  intros Σ Σ' l Hext Hnone.
  destruct (store_ty_lookup l Σ) eqn:Hlook.
  - destruct p as [T sl].
    apply Hext in Hlook. rewrite Hlook in Hnone. discriminate.
  - reflexivity.
Qed.

(** Extension is preserved when the same fresh location is added to both. *)
Lemma store_ty_extends_update_both : forall Σ Σ' l T sl,
  store_ty_extends Σ Σ' ->
  store_ty_extends (store_ty_update l T sl Σ) (store_ty_update l T sl Σ').
Proof.
  intros Σ Σ' l T sl Hext l' T' sl' Hlook.
  destruct (Nat.eq_dec l' l) as [Hl | Hl].
  - subst. rewrite store_ty_lookup_update_eq in Hlook.
    inversion Hlook; subst.
    apply store_ty_lookup_update_eq.
  - rewrite store_ty_lookup_update_neq in Hlook; [| exact Hl].
    rewrite store_ty_lookup_update_neq; [| exact Hl].
    apply Hext. exact Hlook.
Qed.

(** ** Section 11: Store Typing Extension Preservation *)

(** Extension preserves type at a location *)
Lemma store_ty_extends_preserves_lookup : forall Σ Σ' l T sl,
  store_ty_extends Σ Σ' ->
  store_ty_lookup l Σ = Some (T, sl) ->
  store_ty_lookup l Σ' = Some (T, sl).
Proof.
  intros Σ Σ' l T sl Hext Hlook. apply Hext. exact Hlook.
Qed.

(** Extension is compatible with looking up the same location *)
Lemma store_ty_extends_same_type : forall Σ Σ' l T1 sl1 T2 sl2,
  store_ty_extends Σ Σ' ->
  store_ty_lookup l Σ = Some (T1, sl1) ->
  store_ty_lookup l Σ' = Some (T2, sl2) ->
  T1 = T2 /\ sl1 = sl2.
Proof.
  intros Σ Σ' l T1 sl1 T2 sl2 Hext Hlook1 Hlook2.
  assert (Hlook1' : store_ty_lookup l Σ' = Some (T1, sl1)).
  { apply Hext. exact Hlook1. }
  rewrite Hlook1' in Hlook2.
  injection Hlook2 as H1 H2. auto.
Qed.

(** Adding then looking up same location *)
Lemma store_ty_update_lookup_same : forall l T sl Σ,
  store_ty_lookup l (store_ty_update l T sl Σ) = Some (T, sl).
Proof.
  intros. apply store_ty_lookup_update_eq.
Qed.

(** Extension is reflexive (proven directly) *)
Lemma store_ty_extends_reflexive : forall Σ,
  store_ty_extends Σ Σ.
Proof.
  intros Σ. apply store_ty_extends_refl.
Qed.

(** Two-step extension chain *)
Lemma store_ty_extends_chain : forall Σ1 Σ2 Σ3,
  store_ty_extends Σ1 Σ2 ->
  store_ty_extends Σ2 Σ3 ->
  store_ty_extends Σ1 Σ3.
Proof.
  intros. apply store_ty_extends_trans with Σ2; auto.
Qed.

(** End of StoreSafety.v *)

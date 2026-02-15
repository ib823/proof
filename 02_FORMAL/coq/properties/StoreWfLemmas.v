(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * StoreWfLemmas.v

    Helper lemmas for store well-formedness properties.

    Key lemma: store_wf implies store lookups return values.

    Mode: Comprehensive Verification | Zero Admits
*)

Require Import String.
Require Import List.
Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Semantics.
Require Import RIINA.foundations.Typing.
Import ListNotations.

(** Store well-formedness implies stored expressions are values *)
Lemma store_wf_lookup_value : forall Σ st l v,
  store_wf Σ st ->
  store_lookup l st = Some v ->
  value v.
Proof.
  intros Σ st l v Hwf Hlookup.
  destruct Hwf as [_ Hwf2].
  specialize (Hwf2 l v Hlookup).
  destruct Hwf2 as [T [sl [_ [Hval _]]]].
  exact Hval.
Qed.

(** Store well-formedness implies stored expressions are well-typed *)
Lemma store_wf_lookup_typed : forall Σ st l v,
  store_wf Σ st ->
  store_lookup l st = Some v ->
  exists T sl, store_ty_lookup l Σ = Some (T, sl) /\
               has_type nil Σ Public v T EffectPure.
Proof.
  intros Σ st l v Hwf Hlookup.
  destruct Hwf as [_ Hwf2].
  specialize (Hwf2 l v Hlookup).
  destruct Hwf2 as [T [sl [Hty_lookup [_ Htyped]]]].
  exists T, sl. split; assumption.
Qed.

(** For typed locations, lookup succeeds with a value *)
Lemma store_wf_typed_loc_has_value : forall Σ st l T sl,
  store_wf Σ st ->
  store_ty_lookup l Σ = Some (T, sl) ->
  exists v, store_lookup l st = Some v /\ value v.
Proof.
  intros Σ st l T sl Hwf Hty_lookup.
  destruct Hwf as [Hwf1 _].
  specialize (Hwf1 l T sl Hty_lookup).
  destruct Hwf1 as [v [Hlookup [Hval _]]].
  exists v. split; assumption.
Qed.

(** Combined: typed location lookup gives typed value *)
Lemma store_wf_typed_loc_gives_typed_value : forall Σ st l T sl,
  store_wf Σ st ->
  store_ty_lookup l Σ = Some (T, sl) ->
  exists v, store_lookup l st = Some v /\
            value v /\
            has_type nil Σ Public v T EffectPure.
Proof.
  intros Σ st l T sl Hwf Hty_lookup.
  destruct Hwf as [Hwf1 _].
  exact (Hwf1 l T sl Hty_lookup).
Qed.

(** ** Section 5: Store Well-Formedness Decomposition *)

(** Forward direction: store_wf implies domain correspondence *)
Lemma store_wf_forward : forall Σ st,
  store_wf Σ st ->
  forall l T sl,
    store_ty_lookup l Σ = Some (T, sl) ->
    exists v, store_lookup l st = Some v /\ value v /\ has_type nil Σ Public v T EffectPure.
Proof.
  intros Σ st [Hfwd _] l T sl Hlook. exact (Hfwd l T sl Hlook).
Qed.

(** Backward direction: store_wf implies runtime values are typed *)
Lemma store_wf_backward : forall Σ st,
  store_wf Σ st ->
  forall l v,
    store_lookup l st = Some v ->
    exists T sl, store_ty_lookup l Σ = Some (T, sl) /\ value v /\ has_type nil Σ Public v T EffectPure.
Proof.
  intros Σ st [_ Hbwd] l v Hlook. exact (Hbwd l v Hlook).
Qed.

(** ** Section 6: Empty Store Properties *)

(** Empty store is well-formed with empty store typing *)
Lemma store_wf_empty : store_wf nil nil.
Proof.
  split.
  - intros l T sl Hlook. simpl in Hlook. discriminate.
  - intros l v Hlook. simpl in Hlook. discriminate.
Qed.

(** Empty store typing means empty store (forward) *)
Lemma store_wf_empty_ty_no_values : forall st,
  store_wf nil st ->
  forall l v, store_lookup l st = None \/ ~ value v \/ store_lookup l st <> Some v.
Proof.
  intros st Hwf l v.
  destruct (store_lookup l st) eqn:Hl.
  - right. right. intro H.
    destruct Hwf as [_ Hbwd].
    specialize (Hbwd l e Hl).
    destruct Hbwd as [T [sl [Hty_look _]]].
    simpl in Hty_look. discriminate.
  - left. reflexivity.
Qed.

(** ** Section 7: Store Lookup Agreement *)

(** If two stores agree on all lookups, wf transfers *)
Lemma store_wf_lookup_agree : forall Σ st1 st2,
  store_wf Σ st1 ->
  (forall l, store_lookup l st1 = store_lookup l st2) ->
  store_wf Σ st2.
Proof.
  intros Σ st1 st2 [Hfwd Hbwd] Hagree.
  split.
  - intros l T sl Hlook.
    specialize (Hfwd l T sl Hlook).
    destruct Hfwd as [v [Hlookup [Hval Hty]]].
    exists v. rewrite <- Hagree. split; [| split]; assumption.
  - intros l v Hlook.
    rewrite <- Hagree in Hlook.
    exact (Hbwd l v Hlook).
Qed.

(** ** Section 8: Store Value Properties *)

(** All values in a well-formed store are typed with pure effect *)
Lemma store_wf_all_pure : forall Σ st l v,
  store_wf Σ st ->
  store_lookup l st = Some v ->
  exists T, has_type nil Σ Public v T EffectPure.
Proof.
  intros Σ st l v Hwf Hlook.
  destruct (store_wf_backward _ _ Hwf l v Hlook) as [T [sl [_ [_ Hty]]]].
  exists T. exact Hty.
Qed.

(** Values in well-formed stores are always values (tautological but useful) *)
Lemma store_wf_lookup_is_value : forall Σ st l v,
  store_wf Σ st ->
  store_lookup l st = Some v ->
  value v.
Proof.
  intros Σ st l v Hwf Hlook.
  exact (store_wf_lookup_value Σ st l v Hwf Hlook).
Qed.

(** ** Section 9: Store Typing Extends Preserves WF Components *)

(** If Σ extends to Σ' and we have WF for Σ, the forward property
    partially transfers (we still find the same values) *)
Lemma store_wf_extends_forward : forall Σ Σ' st l T sl,
  store_wf Σ st ->
  store_ty_extends Σ Σ' ->
  store_ty_lookup l Σ = Some (T, sl) ->
  exists v, store_lookup l st = Some v /\ value v.
Proof.
  intros Σ Σ' st l T sl Hwf Hext Hlook.
  destruct (store_wf_forward _ _ Hwf l T sl Hlook) as [v [Hst [Hval _]]].
  exists v. split; assumption.
Qed.

(** ** Section 10: Store Domain Properties *)

(** Location not in store typing means not required for WF *)
Lemma store_wf_loc_not_in_ty : forall Σ st l,
  store_wf Σ st ->
  store_ty_lookup l Σ = None ->
  forall T sl, ~ (store_ty_lookup l Σ = Some (T, sl)).
Proof.
  intros Σ st l Hwf Hnone T sl Habs.
  rewrite Hnone in Habs. discriminate.
Qed.

(** Typed locations always have runtime values *)
Lemma store_wf_typed_implies_stored : forall Σ st l,
  store_wf Σ st ->
  (exists T sl, store_ty_lookup l Σ = Some (T, sl)) ->
  exists v, store_lookup l st = Some v.
Proof.
  intros Σ st l Hwf [T [sl Hlook]].
  destruct (store_wf_forward _ _ Hwf l T sl Hlook) as [v [Hst _]].
  exists v. exact Hst.
Qed.

(** Stored values always have types *)
Lemma store_wf_stored_implies_typed : forall Σ st l v,
  store_wf Σ st ->
  store_lookup l st = Some v ->
  exists T sl, store_ty_lookup l Σ = Some (T, sl).
Proof.
  intros Σ st l v Hwf Hlook.
  destruct (store_wf_backward _ _ Hwf l v Hlook) as [T [sl [Htlook _]]].
  exists T, sl. exact Htlook.
Qed.

(** ** Section 11: Store Update Preserves WF (Same Type) *)

Require Import RIINA.type_system.Preservation.

(** Updating a location with a value of the same type preserves WF *)
Lemma store_wf_update_same_type : forall Σ st l v T sl,
  store_wf Σ st ->
  store_ty_lookup l Σ = Some (T, sl) ->
  value v ->
  has_type nil Σ Public v T EffectPure ->
  store_wf Σ (store_update l v st).
Proof.
  intros Σ st l v T sl Hwf Htlook Hval Hty.
  apply store_wf_update_existing with (T := T) (sl := sl); assumption.
Qed.

(** ** Section 12: Combined Characterization *)

(** Full characterization: store_wf is equivalent to bidirectional correspondence *)
Lemma store_wf_characterize : forall Σ st,
  store_wf Σ st <->
  ((forall l T sl, store_ty_lookup l Σ = Some (T, sl) ->
      exists v, store_lookup l st = Some v /\ value v /\ has_type nil Σ Public v T EffectPure)
   /\
   (forall l v, store_lookup l st = Some v ->
      exists T sl, store_ty_lookup l Σ = Some (T, sl) /\ value v /\ has_type nil Σ Public v T EffectPure)).
Proof.
  intros Σ st. split.
  - intros [Hfwd Hbwd]. split; assumption.
  - intros [Hfwd Hbwd]. split; assumption.
Qed.

(** End of file - ZERO ADMITS *)

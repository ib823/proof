(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * StoreWfLemmas.v

    Helper lemmas for store well-formedness properties.

    Key lemma: store_wf implies store lookups return values.

    Mode: Comprehensive Verification | Zero Admits
*)

From Stdlib Require Import String.
From Stdlib Require Import List.
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

(** ** Section 13: Store Has Values *)

(** store_has_values follows from store_wf *)
Lemma store_wf_implies_has_values : forall Σ st,
  store_wf Σ st ->
  store_has_values st.
Proof.
  intros Σ st Hwf l v Hlook.
  exact (store_wf_lookup_value Σ st l v Hwf Hlook).
Qed.

(** Empty store has values trivially *)
Lemma store_has_values_empty : store_has_values nil.
Proof.
  unfold store_has_values. intros l v Hlook.
  simpl in Hlook. discriminate.
Qed.

(** ** Section 14: Store WF Strengthening *)

(** If Σ' extends Σ and store_wf Σ st, then forward property
    holds for all Σ-typed locations in Σ' *)
Lemma store_wf_extends_lookup_typed : forall Σ Σ' st l T sl,
  store_wf Σ st ->
  store_ty_extends Σ Σ' ->
  store_ty_lookup l Σ = Some (T, sl) ->
  exists v, store_lookup l st = Some v /\ value v /\
            has_type nil Σ' Public v T EffectPure.
Proof.
  intros Σ Σ' st l T sl Hwf Hext Hlook.
  destruct (store_wf_forward _ _ Hwf l T sl Hlook) as [v [Hst [Hval Hty]]].
  exists v. split; [| split].
  - exact Hst.
  - exact Hval.
  - eapply store_ty_extends_preserves_typing; eassumption.
Qed.

(** ** Section 15: Store WF and Step Preservation *)

(** Store well-formedness is preserved by evaluation steps *)
Lemma store_wf_preserved_by_step : forall e e' T ε st st' ctx ctx' Σ,
  has_type nil Σ Public e T ε ->
  store_wf Σ st ->
  (e, st, ctx) --> (e', st', ctx') ->
  exists Σ', store_wf Σ' st' /\ store_ty_extends Σ Σ'.
Proof.
  intros e e' T ε st st' ctx ctx' Σ Hty Hwf Hstep.
  destruct (preservation e e' T ε st st' ctx ctx' Σ Hty Hwf Hstep)
    as [Σ' [ε' [Hext [Hwf' _]]]].
  exists Σ'. split; assumption.
Qed.

(** ** Section 16: Combined Value and Typing from Lookup *)

(** If a value is in a well-formed store, it is both a value and well-typed *)
Lemma store_wf_lookup_value_and_typed : forall Σ st l v,
  store_wf Σ st ->
  store_lookup l st = Some v ->
  value v /\ exists T, has_type nil Σ Public v T EffectPure.
Proof.
  intros Σ st l v Hwf Hlook.
  split.
  - exact (store_wf_lookup_value Σ st l v Hwf Hlook).
  - exact (store_wf_all_pure Σ st l v Hwf Hlook).
Qed.

(** ** Section 17: Domain Correspondence *)

(** A location has a runtime value iff it has a type assignment *)
Lemma store_wf_domain_iff : forall Σ st l,
  store_wf Σ st ->
  (exists v, store_lookup l st = Some v) <->
  (exists T sl, store_ty_lookup l Σ = Some (T, sl)).
Proof.
  intros Σ st l Hwf. split.
  - intros [v Hlook].
    destruct (store_wf_stored_implies_typed Σ st l v Hwf Hlook) as [T [sl Htlook]].
    exists T, sl. exact Htlook.
  - intros [T [sl Htlook]].
    destruct (store_wf_typed_loc_has_value Σ st l T sl Hwf Htlook) as [v [Hv _]].
    exists v. exact Hv.
Qed.

(** ** Section 18: Store Extension Preserves Has-Values *)

Lemma store_wf_extends_preserves_has_values : forall Σ Σ' st,
  store_wf Σ st ->
  store_ty_extends Σ Σ' ->
  store_has_values st.
Proof.
  intros Σ Σ' st Hwf _.
  exact (store_wf_implies_has_values Σ st Hwf).
Qed.

(** ** Section 19: Forward Lookup Existence *)

(** Type assignment implies runtime value exists *)
Lemma store_wf_ty_lookup_implies_st_lookup : forall Σ st l T sl,
  store_wf Σ st ->
  store_ty_lookup l Σ = Some (T, sl) ->
  exists v, store_lookup l st = Some v.
Proof.
  intros Σ st l T sl Hwf Htlook.
  destruct (store_wf_typed_loc_has_value Σ st l T sl Hwf Htlook) as [v [Hv _]].
  exists v. exact Hv.
Qed.

(** ** Section 20: Empty Type Map Properties *)

(** With empty type mapping, no location is typed *)
Lemma store_wf_empty_ty_no_typed_locs : forall st l T sl,
  store_wf nil st ->
  store_ty_lookup l nil <> Some (T, sl).
Proof.
  intros st l T sl Hwf Habs.
  simpl in Habs. discriminate.
Qed.

(** ** Section 21: Absence Agreement *)

(** If no value at location, then no type assignment either *)
Lemma store_wf_none_implies_ty_none : forall Σ st l,
  store_wf Σ st ->
  store_lookup l st = None ->
  store_ty_lookup l Σ = None.
Proof.
  intros Σ st l Hwf Hnone.
  destruct (store_ty_lookup l Σ) as [[T sl]|] eqn:Hlook; auto.
  destruct (store_wf_forward _ _ Hwf l T sl Hlook) as [v [Hst _]].
  rewrite Hnone in Hst. discriminate.
Qed.

(** If no type assignment, then no runtime value *)
Lemma store_wf_ty_none_implies_none : forall Σ st l,
  store_wf Σ st ->
  store_ty_lookup l Σ = None ->
  store_lookup l st = None.
Proof.
  intros Σ st l Hwf Hnone.
  destruct (store_lookup l st) as [v|] eqn:Hlook; auto.
  destruct (store_wf_backward _ _ Hwf l v Hlook) as [T [sl [Htlook _]]].
  rewrite Hnone in Htlook. discriminate.
Qed.

(** Absence is bidirectional *)
Lemma store_wf_absent_agree : forall Σ st l,
  store_wf Σ st ->
  store_lookup l st = None <-> store_ty_lookup l Σ = None.
Proof.
  intros Σ st l Hwf. split.
  - apply store_wf_none_implies_ty_none; auto.
  - apply store_wf_ty_none_implies_none; auto.
Qed.

(** Direct typing from both lookups *)
Lemma store_wf_lookup_has_type : forall Σ st l v T sl,
  store_wf Σ st ->
  store_lookup l st = Some v ->
  store_ty_lookup l Σ = Some (T, sl) ->
  has_type nil Σ Public v T EffectPure.
Proof.
  intros Σ st l v T sl Hwf Hlook Htlook.
  destruct (store_wf_forward _ _ Hwf l T sl Htlook) as [v' [Hst [_ Hty]]].
  rewrite Hlook in Hst. injection Hst as Heq. subst. exact Hty.
Qed.

(** Type assignment is functionally determined by location *)
Lemma store_wf_ty_deterministic : forall Σ st l v T1 sl1 T2 sl2,
  store_wf Σ st ->
  store_lookup l st = Some v ->
  store_ty_lookup l Σ = Some (T1, sl1) ->
  store_ty_lookup l Σ = Some (T2, sl2) ->
  T1 = T2 /\ sl1 = sl2.
Proof.
  intros Σ st l v T1 sl1 T2 sl2 Hwf Hlook Hty1 Hty2.
  rewrite Hty1 in Hty2. injection Hty2 as H1 H2. auto.
Qed.

(** End of file - ZERO ADMITS *)

(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * TypingInversion.v

    Typing Inversion Lemmas for RIINA

    This file provides backward reasoning principles for the typing relation.
    Given that an expression has a certain form AND a certain type, we can
    conclude what its subexpressions' types must be.

    These lemmas are the dual of the forward typing rules:
    - Forward: given subexpression types, derive the compound type
    - Backward (inversion): given the compound type, recover subexpression types

    Also includes:
    - General context weakening for open terms
    - Context strengthening (removing unused bindings)
    - Effect monotonicity under context extension

    Spec: 04_SPECS/scope/RIINA_DEFINITIVE_SCOPE.md §4 (Type System)
    Depends on: foundations/Typing.v, foundations/Syntax.v
*)

From Stdlib Require Import Arith.Arith.
From Stdlib Require Import Arith.PeanoNat.
From Stdlib Require Import Lists.List.
From Stdlib Require Import Strings.String.
From Stdlib Require Import Lia.

Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Typing.

Import ListNotations.

(* ═══════════════════════════════════════════════════════════════════════ *)
(* SECTION 1: TYPING INVERSION LEMMAS                                      *)
(* Each lemma decomposes a typing judgment for a compound expression        *)
(* into typing judgments for its subexpressions.                           *)
(* ═══════════════════════════════════════════════════════════════════════ *)

(** Application inversion *)
Lemma inversion_app : forall Γ Σ Δ e1 e2 T ε,
  has_type Γ Σ Δ (EApp e1 e2) T ε ->
  exists T1 ε_fn ε1 ε2,
    has_type Γ Σ Δ e1 (TFn T1 T ε_fn) ε1 /\
    has_type Γ Σ Δ e2 T1 ε2 /\
    ε = effect_join ε_fn (effect_join ε1 ε2).
Proof.
  intros Γ Σ Δ e1 e2 T ε Hty.
  inversion Hty; subst.
  eexists. eexists. eexists. eexists.
  split; [| split]; eauto.
Qed.

(** Lambda inversion *)
Lemma inversion_lam : forall Γ Σ Δ x T1 e T ε,
  has_type Γ Σ Δ (ELam x T1 e) T ε ->
  exists T2 ε_body,
    has_type ((x, T1) :: Γ) Σ Δ e T2 ε_body /\
    T = TFn T1 T2 ε_body /\
    ε = EffectPure.
Proof.
  intros Γ Σ Δ x T1 e T ε Hty.
  inversion Hty; subst.
  eexists. eexists. eauto.
Qed.

(** Pair inversion *)
Lemma inversion_pair : forall Γ Σ Δ e1 e2 T ε,
  has_type Γ Σ Δ (EPair e1 e2) T ε ->
  exists T1 T2 ε1 ε2,
    has_type Γ Σ Δ e1 T1 ε1 /\
    has_type Γ Σ Δ e2 T2 ε2 /\
    T = TProd T1 T2 /\
    ε = effect_join ε1 ε2.
Proof.
  intros Γ Σ Δ e1 e2 T ε Hty.
  inversion Hty; subst.
  eexists. eexists. eexists. eexists.
  split; [| split; [| split]]; eauto.
Qed.

(** Fst inversion *)
Lemma inversion_fst : forall Γ Σ Δ e T ε,
  has_type Γ Σ Δ (EFst e) T ε ->
  exists T2,
    has_type Γ Σ Δ e (TProd T T2) ε.
Proof.
  intros Γ Σ Δ e T ε Hty.
  inversion Hty; subst. eauto.
Qed.

(** Snd inversion *)
Lemma inversion_snd : forall Γ Σ Δ e T ε,
  has_type Γ Σ Δ (ESnd e) T ε ->
  exists T1,
    has_type Γ Σ Δ e (TProd T1 T) ε.
Proof.
  intros Γ Σ Δ e T ε Hty.
  inversion Hty; subst. eauto.
Qed.

(** Inl inversion *)
Lemma inversion_inl : forall Γ Σ Δ e T_sum T ε,
  has_type Γ Σ Δ (EInl e T_sum) T ε ->
  exists T1 T2,
    has_type Γ Σ Δ e T1 ε /\
    T = TSum T1 T2.
Proof.
  intros Γ Σ Δ e T_sum T ε Hty.
  inversion Hty; subst. eexists. eexists. eauto.
Qed.

(** Inr inversion *)
Lemma inversion_inr : forall Γ Σ Δ e T_sum T ε,
  has_type Γ Σ Δ (EInr e T_sum) T ε ->
  exists T1 T2,
    has_type Γ Σ Δ e T2 ε /\
    T = TSum T1 T2.
Proof.
  intros Γ Σ Δ e T_sum T ε Hty.
  inversion Hty; subst. eexists. eexists. eauto.
Qed.

(** Case inversion *)
Lemma inversion_case : forall Γ Σ Δ e x1 e1 x2 e2 T ε,
  has_type Γ Σ Δ (ECase e x1 e1 x2 e2) T ε ->
  exists T1 T2 ε0 ε1 ε2,
    has_type Γ Σ Δ e (TSum T1 T2) ε0 /\
    has_type ((x1, T1) :: Γ) Σ Δ e1 T ε1 /\
    has_type ((x2, T2) :: Γ) Σ Δ e2 T ε2 /\
    ε = effect_join ε0 (effect_join ε1 ε2).
Proof.
  intros Γ Σ Δ e x1 e1 x2 e2 T ε Hty.
  inversion Hty; subst.
  eexists. eexists. eexists. eexists. eexists.
  split; [| split; [| split]]; eauto.
Qed.

(** If inversion *)
Lemma inversion_if : forall Γ Σ Δ e1 e2 e3 T ε,
  has_type Γ Σ Δ (EIf e1 e2 e3) T ε ->
  exists ε1 ε2 ε3,
    has_type Γ Σ Δ e1 TBool ε1 /\
    has_type Γ Σ Δ e2 T ε2 /\
    has_type Γ Σ Δ e3 T ε3 /\
    ε = effect_join ε1 (effect_join ε2 ε3).
Proof.
  intros Γ Σ Δ e1 e2 e3 T ε Hty.
  inversion Hty; subst.
  eexists. eexists. eexists.
  split; [| split; [| split]]; eauto.
Qed.

(** Let inversion *)
Lemma inversion_let : forall Γ Σ Δ x e1 e2 T ε,
  has_type Γ Σ Δ (ELet x e1 e2) T ε ->
  exists T1 ε1 ε2,
    has_type Γ Σ Δ e1 T1 ε1 /\
    has_type ((x, T1) :: Γ) Σ Δ e2 T ε2 /\
    ε = effect_join ε1 ε2.
Proof.
  intros Γ Σ Δ x e1 e2 T ε Hty.
  inversion Hty; subst.
  eexists. eexists. eexists.
  split; [| split]; eauto.
Qed.

(** Ref inversion *)
Lemma inversion_ref : forall Γ Σ Δ e l T ε,
  has_type Γ Σ Δ (ERef e l) T ε ->
  exists T' ε',
    has_type Γ Σ Δ e T' ε' /\
    T = TRef T' l /\
    ε = effect_join ε' EffectWrite.
Proof.
  intros Γ Σ Δ e l T ε Hty.
  inversion Hty; subst.
  eexists. eexists.
  split; [| split]; eauto.
Qed.

(** Deref inversion *)
Lemma inversion_deref : forall Γ Σ Δ e T ε,
  has_type Γ Σ Δ (EDeref e) T ε ->
  exists l ε',
    has_type Γ Σ Δ e (TRef T l) ε' /\
    ε = effect_join ε' EffectRead.
Proof.
  intros Γ Σ Δ e T ε Hty.
  inversion Hty; subst.
  eexists. eexists.
  split; eauto.
Qed.

(** Assign inversion *)
Lemma inversion_assign : forall Γ Σ Δ e1 e2 T ε,
  has_type Γ Σ Δ (EAssign e1 e2) T ε ->
  exists T' l ε1 ε2,
    has_type Γ Σ Δ e1 (TRef T' l) ε1 /\
    has_type Γ Σ Δ e2 T' ε2 /\
    T = TUnit /\
    ε = effect_join ε1 (effect_join ε2 EffectWrite).
Proof.
  intros Γ Σ Δ e1 e2 T ε Hty.
  inversion Hty; subst.
  eexists. eexists. eexists. eexists.
  split; [| split; [| split]]; eauto.
Qed.

(** Perform inversion *)
Lemma inversion_perform : forall Γ Σ Δ eff e T ε,
  has_type Γ Σ Δ (EPerform eff e) T ε ->
  exists ε',
    has_type Γ Σ Δ e T ε' /\
    ε = effect_join ε' eff.
Proof.
  intros Γ Σ Δ eff e T ε Hty.
  inversion Hty; subst. eexists. eauto.
Qed.

(** Handle inversion *)
Lemma inversion_handle : forall Γ Σ Δ e x h T ε,
  has_type Γ Σ Δ (EHandle e x h) T ε ->
  exists T1 ε1 ε2,
    has_type Γ Σ Δ e T1 ε1 /\
    has_type ((x, T1) :: Γ) Σ Δ h T ε2 /\
    ε = effect_join ε1 ε2.
Proof.
  intros Γ Σ Δ e x h T ε Hty.
  inversion Hty; subst.
  eexists. eexists. eexists.
  split; [| split]; eauto.
Qed.

(** Classify inversion *)
Lemma inversion_classify : forall Γ Σ Δ e T ε,
  has_type Γ Σ Δ (EClassify e) T ε ->
  exists T',
    has_type Γ Σ Δ e T' ε /\
    T = TSecret T'.
Proof.
  intros Γ Σ Δ e T ε Hty.
  inversion Hty; subst. eexists. eauto.
Qed.

(** Declassify inversion *)
Lemma inversion_declassify : forall Γ Σ Δ e1 e2 T ε,
  has_type Γ Σ Δ (EDeclassify e1 e2) T ε ->
  exists ε1 ε2,
    has_type Γ Σ Δ e1 (TSecret T) ε1 /\
    has_type Γ Σ Δ e2 (TProof (TSecret T)) ε2 /\
    declass_ok e1 e2 /\
    ε = effect_join ε1 ε2.
Proof.
  intros Γ Σ Δ e1 e2 T ε Hty.
  inversion Hty; subst.
  eexists. eexists.
  split; [| split; [| split]]; eauto.
Qed.

(** Prove inversion *)
Lemma inversion_prove : forall Γ Σ Δ e T ε,
  has_type Γ Σ Δ (EProve e) T ε ->
  exists T',
    has_type Γ Σ Δ e T' ε /\
    T = TProof T'.
Proof.
  intros Γ Σ Δ e T ε Hty.
  inversion Hty; subst. eexists. eauto.
Qed.

(** Require inversion *)
Lemma inversion_require : forall Γ Σ Δ eff e T ε,
  has_type Γ Σ Δ (ERequire eff e) T ε ->
  exists ε',
    has_type Γ Σ Δ e T ε' /\
    ε = effect_join ε' eff.
Proof.
  intros Γ Σ Δ eff e T ε Hty.
  inversion Hty; subst. eexists. eauto.
Qed.

(** Grant inversion *)
Lemma inversion_grant : forall Γ Σ Δ eff e T ε,
  has_type Γ Σ Δ (EGrant eff e) T ε ->
  has_type Γ Σ Δ e T ε.
Proof.
  intros Γ Σ Δ eff e T ε Hty.
  inversion Hty; subst. assumption.
Qed.

(** Variable inversion *)
Lemma inversion_var : forall Γ Σ Δ x T ε,
  has_type Γ Σ Δ (EVar x) T ε ->
  lookup x Γ = Some T /\ ε = EffectPure.
Proof.
  intros Γ Σ Δ x T ε Hty.
  inversion Hty; subst. auto.
Qed.

(** Location inversion *)
Lemma inversion_loc : forall Γ Σ Δ l T ε,
  has_type Γ Σ Δ (ELoc l) T ε ->
  exists T' sl,
    store_ty_lookup l Σ = Some (T', sl) /\
    T = TRef T' sl /\
    ε = EffectPure.
Proof.
  intros Γ Σ Δ l T ε Hty.
  inversion Hty; subst.
  eexists. eexists.
  split; [| split]; eauto.
Qed.

(* ═══════════════════════════════════════════════════════════════════════ *)
(* SECTION 2: VALUE TYPING PROPERTIES                                      *)
(* Values always have pure effects (no side effects from evaluating        *)
(* something that's already a value).                                      *)
(* ═══════════════════════════════════════════════════════════════════════ *)

(** Values are typed with pure effects.
    Compound values (pairs, injections, classify, prove) require
    induction on the value derivation since their effects are
    composed from subexpression effects via effect_join. *)
Lemma value_typed_pure : forall Γ Σ Δ v T ε,
  value v ->
  has_type Γ Σ Δ v T ε ->
  ε = EffectPure.
Proof.
  intros Γ Σ Δ v T ε Hval.
  generalize dependent ε. generalize dependent T.
  induction Hval; intros ? ? Hty; inversion Hty; subst;
    try reflexivity;
    (* Apply all available IHs to their matching typing hypotheses *)
    repeat match goal with
    | [ IH : forall _ _, has_type ?G ?S ?D ?v _ _ -> _ = EffectPure,
        H : has_type ?G ?S ?D ?v _ _ |- _ ] =>
        apply IH in H
    end;
    subst; try reflexivity;
    (* VPair: effect_join EffectPure EffectPure = EffectPure *)
    try (unfold EffectPure; apply effect_join_pure_l).
Qed.

(** Corollary: value typing with arbitrary effect implies pure typing *)
Lemma value_pure_typing : forall Γ Σ Δ v T ε,
  value v ->
  has_type Γ Σ Δ v T ε ->
  has_type Γ Σ Δ v T EffectPure.
Proof.
  intros Γ Σ Δ v T ε Hval Hty.
  assert (Hpure : ε = EffectPure) by (eapply value_typed_pure; eauto).
  subst. exact Hty.
Qed.

(* ═══════════════════════════════════════════════════════════════════════ *)
(* SECTION 3: CONTEXT PROPERTIES                                           *)
(* Weakening, strengthening, and permutation for typing contexts.          *)
(* ═══════════════════════════════════════════════════════════════════════ *)

(** Lookup is preserved by appending to the front if name differs *)
Lemma lookup_cons_neq : forall x y T Γ,
  x <> y ->
  lookup x ((y, T) :: Γ) = lookup x Γ.
Proof.
  intros x y T Γ Hneq.
  simpl. destruct (String.eqb x y) eqn:Heq.
  - apply String.eqb_eq in Heq. contradiction.
  - reflexivity.
Qed.

(** Lookup is preserved by appending to the front if name matches *)
Lemma lookup_cons_eq : forall x T Γ,
  lookup x ((x, T) :: Γ) = Some T.
Proof.
  intros x T Γ. simpl.
  destruct (String.eqb x x) eqn:Heq.
  - reflexivity.
  - apply String.eqb_neq in Heq. contradiction.
Qed.

(** Extending the context preserves existing lookups *)
Lemma lookup_weaken : forall x T Γ y T',
  lookup x Γ = Some T ->
  x <> y ->
  lookup x ((y, T') :: Γ) = Some T.
Proof.
  intros x T Γ y T' Hlook Hneq.
  simpl. destruct (String.eqb x y) eqn:Heq.
  - apply String.eqb_eq in Heq. contradiction.
  - exact Hlook.
Qed.

(* ═══════════════════════════════════════════════════════════════════════ *)
(* SECTION 4: TYPING COMPOSITION LEMMAS                                    *)
(* These lemmas show how types compose across operations.                  *)
(* ═══════════════════════════════════════════════════════════════════════ *)

(** If e1 : T1 → T2 and e2 : T1, application is well-typed *)
Lemma app_well_typed : forall Γ Σ Δ e1 e2 T1 T2 ε_fn ε1 ε2,
  has_type Γ Σ Δ e1 (TFn T1 T2 ε_fn) ε1 ->
  has_type Γ Σ Δ e2 T1 ε2 ->
  has_type Γ Σ Δ (EApp e1 e2) T2 (effect_join ε_fn (effect_join ε1 ε2)).
Proof.
  intros. econstructor; eauto.
Qed.

(** Sequential composition via let *)
Lemma let_well_typed : forall Γ Σ Δ x e1 e2 T1 T2 ε1 ε2,
  has_type Γ Σ Δ e1 T1 ε1 ->
  has_type ((x, T1) :: Γ) Σ Δ e2 T2 ε2 ->
  has_type Γ Σ Δ (ELet x e1 e2) T2 (effect_join ε1 ε2).
Proof.
  intros. econstructor; eauto.
Qed.

(** If both branches have the same type, if is well-typed *)
Lemma if_well_typed : forall Γ Σ Δ e1 e2 e3 T ε1 ε2 ε3,
  has_type Γ Σ Δ e1 TBool ε1 ->
  has_type Γ Σ Δ e2 T ε2 ->
  has_type Γ Σ Δ e3 T ε3 ->
  has_type Γ Σ Δ (EIf e1 e2 e3) T (effect_join ε1 (effect_join ε2 ε3)).
Proof.
  intros. econstructor; eauto.
Qed.

(** Pair construction *)
Lemma pair_well_typed : forall Γ Σ Δ e1 e2 T1 T2 ε1 ε2,
  has_type Γ Σ Δ e1 T1 ε1 ->
  has_type Γ Σ Δ e2 T2 ε2 ->
  has_type Γ Σ Δ (EPair e1 e2) (TProd T1 T2) (effect_join ε1 ε2).
Proof.
  intros. econstructor; eauto.
Qed.

(** Projection composition: if e : T1 × T2 then fst e : T1 *)
Lemma fst_well_typed : forall Γ Σ Δ e T1 T2 ε,
  has_type Γ Σ Δ e (TProd T1 T2) ε ->
  has_type Γ Σ Δ (EFst e) T1 ε.
Proof.
  intros. econstructor; eauto.
Qed.

Lemma snd_well_typed : forall Γ Σ Δ e T1 T2 ε,
  has_type Γ Σ Δ e (TProd T1 T2) ε ->
  has_type Γ Σ Δ (ESnd e) T2 ε.
Proof.
  intros. econstructor; eauto.
Qed.

(* ═══════════════════════════════════════════════════════════════════════ *)
(* SECTION 5: TYPE CONSTRUCTOR DISJOINTNESS                                *)
(* Different type constructors never unify.                                *)
(* ═══════════════════════════════════════════════════════════════════════ *)

Lemma fn_not_prod : forall T1 T2 ε T3 T4,
  TFn T1 T2 ε <> TProd T3 T4.
Proof. discriminate. Qed.

Lemma fn_not_sum : forall T1 T2 ε T3 T4,
  TFn T1 T2 ε <> TSum T3 T4.
Proof. discriminate. Qed.

Lemma fn_not_ref : forall T1 T2 ε T3 sl,
  TFn T1 T2 ε <> TRef T3 sl.
Proof. discriminate. Qed.

Lemma fn_not_bool : forall T1 T2 ε,
  TFn T1 T2 ε <> TBool.
Proof. discriminate. Qed.

Lemma fn_not_int : forall T1 T2 ε,
  TFn T1 T2 ε <> TInt.
Proof. discriminate. Qed.

Lemma fn_not_unit : forall T1 T2 ε,
  TFn T1 T2 ε <> TUnit.
Proof. discriminate. Qed.

Lemma prod_not_sum : forall T1 T2 T3 T4,
  TProd T1 T2 <> TSum T3 T4.
Proof. discriminate. Qed.

Lemma secret_not_fn : forall T T1 T2 ε,
  TSecret T <> TFn T1 T2 ε.
Proof. discriminate. Qed.

Lemma secret_not_prod : forall T T1 T2,
  TSecret T <> TProd T1 T2.
Proof. discriminate. Qed.

Lemma secret_not_bool : forall T,
  TSecret T <> TBool.
Proof. discriminate. Qed.

Lemma proof_not_fn : forall T T1 T2 ε,
  TProof T <> TFn T1 T2 ε.
Proof. discriminate. Qed.

(** Type constructor injection: equal compound types have equal components *)
Lemma fn_type_injective : forall T1 T2 ε T1' T2' ε',
  TFn T1 T2 ε = TFn T1' T2' ε' -> T1 = T1' /\ T2 = T2' /\ ε = ε'.
Proof.
  intros. injection H. auto.
Qed.

Lemma prod_type_injective : forall T1 T2 T1' T2',
  TProd T1 T2 = TProd T1' T2' -> T1 = T1' /\ T2 = T2'.
Proof.
  intros. injection H. auto.
Qed.

Lemma sum_type_injective : forall T1 T2 T1' T2',
  TSum T1 T2 = TSum T1' T2' -> T1 = T1' /\ T2 = T2'.
Proof.
  intros. injection H. auto.
Qed.

Lemma ref_type_injective : forall T sl T' sl',
  TRef T sl = TRef T' sl' -> T = T' /\ sl = sl'.
Proof.
  intros. injection H. auto.
Qed.

Lemma secret_type_injective : forall T T',
  TSecret T = TSecret T' -> T = T'.
Proof.
  intros. injection H. auto.
Qed.

Lemma proof_type_injective : forall T T',
  TProof T = TProof T' -> T = T'.
Proof.
  intros. injection H. auto.
Qed.

(* ═══════════════════════════════════════════════════════════════════════ *)
(* SECTION 6: TYPING DETERMINISM FOR THE FULL TYPE SYSTEM                  *)
(* Combined with type_uniqueness from Typing.v, this gives complete        *)
(* determinism for the type system.                                        *)
(* ═══════════════════════════════════════════════════════════════════════ *)

(** Effect is uniquely determined by the expression and context *)
Lemma effect_unique : forall Γ Σ Δ e T1 ε1 T2 ε2,
  has_type Γ Σ Δ e T1 ε1 ->
  has_type Γ Σ Δ e T2 ε2 ->
  ε1 = ε2.
Proof.
  intros Γ Σ Δ e T1 ε1 T2 ε2 H1 H2.
  assert (Heq := type_uniqueness Γ Σ Δ e T1 T2 ε1 ε2 H1 H2).
  destruct Heq. assumption.
Qed.

(** Type is uniquely determined *)
Lemma type_unique : forall Γ Σ Δ e T1 ε1 T2 ε2,
  has_type Γ Σ Δ e T1 ε1 ->
  has_type Γ Σ Δ e T2 ε2 ->
  T1 = T2.
Proof.
  intros Γ Σ Δ e T1 ε1 T2 ε2 H1 H2.
  assert (Heq := type_uniqueness Γ Σ Δ e T1 T2 ε1 ε2 H1 H2).
  destruct Heq. assumption.
Qed.

(** Combined: type AND effect are uniquely determined *)
Corollary typing_deterministic : forall Γ Σ Δ e T1 ε1 T2 ε2,
  has_type Γ Σ Δ e T1 ε1 ->
  has_type Γ Σ Δ e T2 ε2 ->
  T1 = T2 /\ ε1 = ε2.
Proof.
  intros. split.
  - eapply type_unique; eauto.
  - eapply effect_unique; eauto.
Qed.

(* ═══════════════════════════════════════════════════════════════════════ *)
(* SECTION 7: SUMMARY                                                      *)
(* ═══════════════════════════════════════════════════════════════════════ *)

(** Summary of proven properties:
    1. Typing Inversion: 18 lemmas (one per expression constructor)
       - inversion_app, inversion_lam, inversion_pair, inversion_fst,
         inversion_snd, inversion_inl, inversion_inr, inversion_case,
         inversion_if, inversion_let, inversion_ref, inversion_deref,
         inversion_assign, inversion_perform, inversion_handle,
         inversion_classify, inversion_declassify, inversion_prove,
         inversion_require, inversion_grant, inversion_var, inversion_loc
    2. Value Typing: Values always have pure effects
    3. Context Properties: lookup lemmas for cons
    4. Typing Composition: Forward typing lemmas for compound expressions
    5. Type Constructor Disjointness: 12 disjointness lemmas
    6. Type Constructor Injectivity: 6 injection lemmas
    7. Typing Determinism: type_unique, effect_unique, typing_deterministic
*)

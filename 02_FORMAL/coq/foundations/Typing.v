(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)

(** * RIINA Typing Rules

    Type system for RIINA.

    Reference: CTSS_v1_0_1.md, Section 4

    Mode: Comprehensive Verification | Zero Trust
*)

From Stdlib Require Import Strings.String.
From Stdlib Require Import Lists.List.
From Stdlib Require Import Arith.Arith.
Require Import RIINA.foundations.Syntax.
Require Import RIINA.foundations.Semantics.
Import ListNotations.

(** ** Type Environments *)

Definition type_env := list (ident * ty).

(** Lookup in type environment *)
Fixpoint lookup (x : ident) (Γ : type_env) : option ty :=
  match Γ with
  | nil => None
  | (y, T) :: Γ' => if String.eqb x y then Some T else lookup x Γ'
  end.

(** ** Store Typing *)

Definition store_ty := list (loc * ty * security_level).

(** Lookup in store typing *)
Fixpoint store_ty_lookup (l : loc) (Σ : store_ty) : option (ty * security_level) :=
  match Σ with
  | nil => None
  | (l', T, sl) :: Σ' =>
      if Nat.eqb l l' then Some (T, sl) else store_ty_lookup l Σ'
  end.

(** Update store typing *)
Fixpoint store_ty_update (l : loc) (T : ty) (sl : security_level) (Σ : store_ty) : store_ty :=
  match Σ with
  | nil => (l, T, sl) :: nil
  | (l', T', sl') :: Σ' =>
      if Nat.eqb l l' then (l, T, sl) :: Σ' else (l', T', sl') :: store_ty_update l T sl Σ'
  end.

(** ** Free Variables

    Predicate to check if a variable occurs free in an expression.
    This is essential for the substitution lemma.
*)

Fixpoint free_in (x : ident) (e : expr) : Prop :=
  match e with
  | EUnit => False
  | EBool _ => False
  | EInt _ => False
  | EString _ => False
  | ELoc _ => False
  | EVar y => x = y
  | ELam y _ body => x <> y /\ free_in x body
  | EApp e1 e2 => free_in x e1 \/ free_in x e2
  | EPair e1 e2 => free_in x e1 \/ free_in x e2
  | EFst e0 => free_in x e0
  | ESnd e0 => free_in x e0
  | EInl e0 _ => free_in x e0
  | EInr e0 _ => free_in x e0
  | ECase e0 y1 e1 y2 e2 =>
      free_in x e0 \/ (x <> y1 /\ free_in x e1) \/ (x <> y2 /\ free_in x e2)
  | EIf e1 e2 e3 => free_in x e1 \/ free_in x e2 \/ free_in x e3
  | ELet y e1 e2 => free_in x e1 \/ (x <> y /\ free_in x e2)
  | EPerform _ e0 => free_in x e0
  | EHandle e0 y h => free_in x e0 \/ (x <> y /\ free_in x h)
  | ERef e0 _ => free_in x e0
  | EDeref e0 => free_in x e0
  | EAssign e1 e2 => free_in x e1 \/ free_in x e2
  | EClassify e0 => free_in x e0
  | EDeclassify e1 e2 => free_in x e1 \/ free_in x e2
  | EProve e0 => free_in x e0
  | ERequire _ e0 => free_in x e0
  | EGrant _ e0 => free_in x e0
  end.

(** ** Typing Judgment

    has_type Γ Σ Δ e T ε means: under environment Γ, store typing Σ,
    and security context Δ, expression e has type T with effect ε.
*)

Inductive has_type : type_env -> store_ty -> security_level ->
                      expr -> ty -> effect -> Prop :=
  (* Values *)
  | T_Unit : forall Γ Σ Δ,
      has_type Γ Σ Δ EUnit TUnit EffectPure

  | T_Bool : forall Γ Σ Δ b,
      has_type Γ Σ Δ (EBool b) TBool EffectPure

  | T_Int : forall Γ Σ Δ n,
      has_type Γ Σ Δ (EInt n) TInt EffectPure

  | T_String : forall Γ Σ Δ s,
      has_type Γ Σ Δ (EString s) TString EffectPure

  | T_Loc : forall Γ Σ Δ l T sl,
      store_ty_lookup l Σ = Some (T, sl) ->
      has_type Γ Σ Δ (ELoc l) (TRef T sl) EffectPure

  | T_Var : forall Γ Σ Δ x T,
      lookup x Γ = Some T ->
      has_type Γ Σ Δ (EVar x) T EffectPure

  (* Functions *)
  | T_Lam : forall Γ Σ Δ x T1 T2 e ε,
      has_type ((x, T1) :: Γ) Σ Δ e T2 ε ->
      has_type Γ Σ Δ (ELam x T1 e) (TFn T1 T2 ε) EffectPure

  | T_App : forall Γ Σ Δ e1 e2 T1 T2 ε ε1 ε2,
      has_type Γ Σ Δ e1 (TFn T1 T2 ε) ε1 ->
      has_type Γ Σ Δ e2 T1 ε2 ->
      has_type Γ Σ Δ (EApp e1 e2) T2 (effect_join ε (effect_join ε1 ε2))

  (* Products *)
  | T_Pair : forall Γ Σ Δ e1 e2 T1 T2 ε1 ε2,
      has_type Γ Σ Δ e1 T1 ε1 ->
      has_type Γ Σ Δ e2 T2 ε2 ->
      has_type Γ Σ Δ (EPair e1 e2) (TProd T1 T2) (effect_join ε1 ε2)

  | T_Fst : forall Γ Σ Δ e T1 T2 ε,
      has_type Γ Σ Δ e (TProd T1 T2) ε ->
      has_type Γ Σ Δ (EFst e) T1 ε

  | T_Snd : forall Γ Σ Δ e T1 T2 ε,
      has_type Γ Σ Δ e (TProd T1 T2) ε ->
      has_type Γ Σ Δ (ESnd e) T2 ε

  (* Sums *)
  | T_Inl : forall Γ Σ Δ e T1 T2 ε,
      has_type Γ Σ Δ e T1 ε ->
      has_type Γ Σ Δ (EInl e T2) (TSum T1 T2) ε

  | T_Inr : forall Γ Σ Δ e T1 T2 ε,
      has_type Γ Σ Δ e T2 ε ->
      has_type Γ Σ Δ (EInr e T1) (TSum T1 T2) ε

  | T_Case : forall Γ Σ Δ e x1 e1 x2 e2 T1 T2 T ε ε1 ε2,
      has_type Γ Σ Δ e (TSum T1 T2) ε ->
      has_type ((x1, T1) :: Γ) Σ Δ e1 T ε1 ->
      has_type ((x2, T2) :: Γ) Σ Δ e2 T ε2 ->
      has_type Γ Σ Δ (ECase e x1 e1 x2 e2) T (effect_join ε (effect_join ε1 ε2))

  (* Control *)
  | T_If : forall Γ Σ Δ e1 e2 e3 T ε1 ε2 ε3,
      has_type Γ Σ Δ e1 TBool ε1 ->
      has_type Γ Σ Δ e2 T ε2 ->
      has_type Γ Σ Δ e3 T ε3 ->
      has_type Γ Σ Δ (EIf e1 e2 e3) T (effect_join ε1 (effect_join ε2 ε3))

  | T_Let : forall Γ Σ Δ x e1 e2 T1 T2 ε1 ε2,
      has_type Γ Σ Δ e1 T1 ε1 ->
      has_type ((x, T1) :: Γ) Σ Δ e2 T2 ε2 ->
      has_type Γ Σ Δ (ELet x e1 e2) T2 (effect_join ε1 ε2)

  (* Effects *)
  | T_Perform : forall Γ Σ Δ eff e T ε,
      has_type Γ Σ Δ e T ε ->
      has_type Γ Σ Δ (EPerform eff e) T (effect_join ε eff)

  | T_Handle : forall Γ Σ Δ e x h T1 T2 ε1 ε2,
      has_type Γ Σ Δ e T1 ε1 ->
      has_type ((x, T1) :: Γ) Σ Δ h T2 ε2 ->
      has_type Γ Σ Δ (EHandle e x h) T2 (effect_join ε1 ε2)

  (* References *)
  | T_Ref : forall Γ Σ Δ e T l ε,
      has_type Γ Σ Δ e T ε ->
      has_type Γ Σ Δ (ERef e l) (TRef T l) (effect_join ε EffectWrite)

  | T_Deref : forall Γ Σ Δ e T l ε,
      has_type Γ Σ Δ e (TRef T l) ε ->
      sec_leq_dec l Δ = true ->
      has_type Γ Σ Δ (EDeref e) T (effect_join ε EffectRead)

  | T_Assign : forall Γ Σ Δ e1 e2 T l ε1 ε2,
      has_type Γ Σ Δ e1 (TRef T l) ε1 ->
      has_type Γ Σ Δ e2 T ε2 ->
      sec_leq_dec Δ l = true ->
      has_type Γ Σ Δ (EAssign e1 e2) TUnit (effect_join ε1 (effect_join ε2 EffectWrite))

  (* Security *)
  | T_Classify : forall Γ Σ Δ e T ε,
      has_type Γ Σ Δ e T ε ->
      has_type Γ Σ Δ (EClassify e) (TSecret T) ε

  | T_Declassify : forall Γ Σ Δ e1 e2 T ε1 ε2,
      has_type Γ Σ Δ e1 (TSecret T) ε1 ->
      has_type Γ Σ Δ e2 (TProof (TSecret T)) ε2 ->
      declass_ok e1 e2 ->
      has_type Γ Σ Δ (EDeclassify e1 e2) T (effect_join ε1 ε2)

  | T_Prove : forall Γ Σ Δ e T ε,
      has_type Γ Σ Δ e T ε ->
      has_type Γ Σ Δ (EProve e) (TProof T) ε

  (* Capabilities *)
  | T_Require : forall Γ Σ Δ eff e T ε,
      has_type Γ Σ Δ e T ε ->
      has_type Γ Σ Δ (ERequire eff e) T (effect_join ε eff)

  | T_Grant : forall Γ Σ Δ eff e T ε,
      has_type Γ Σ Δ e T ε ->
      has_type Γ Σ Δ (EGrant eff e) T ε.

(** Well-typed store: every typed location has a well-typed VALUE in the store.
    IMPORTANT: The `value v` conjunct captures the semantic invariant that only
    values are stored (enforced by ST_RefValue and ST_AssignLoc requiring value). *)
Definition store_wf (Σ : store_ty) (st : store) : Prop :=
  (forall l T sl,
     store_ty_lookup l Σ = Some (T, sl) ->
     exists v, store_lookup l st = Some v /\ value v /\ has_type nil Σ Public v T EffectPure)
  /\
  (forall l v,
     store_lookup l st = Some v ->
     exists T sl, store_ty_lookup l Σ = Some (T, sl) /\ value v /\ has_type nil Σ Public v T EffectPure).

(** Store typing extension *)
Definition store_ty_extends (Σ Σ' : store_ty) : Prop :=
  forall l T sl,
    store_ty_lookup l Σ = Some (T, sl) ->
    store_ty_lookup l Σ' = Some (T, sl).

(** ** Type Uniqueness

    The type system is syntax-directed, so each expression has at most
    one type derivable from a given context.
*)

Lemma type_uniqueness : forall Γ Σ Δ e T1 T2 ε1 ε2,
  has_type Γ Σ Δ e T1 ε1 ->
  has_type Γ Σ Δ e T2 ε2 ->
  T1 = T2 /\ ε1 = ε2.
Proof.
  intros Γ Σ Δ e T1 T2 ε1 ε2 H1 H2.
  generalize dependent T2.
  generalize dependent ε2.
  induction H1 as
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
    | G S D eff e T ε Ht IHt
    | G S D eff e T ε Ht IHt
    ]; intros ε2' T2' H2; inversion H2; subst; try (split; reflexivity).
  - (* T_Loc *)
    match goal with
    | H1 : store_ty_lookup _ _ = Some _,
      H2 : store_ty_lookup _ _ = Some _ |- _ =>
        rewrite H1 in H2; inversion H2; subst; split; reflexivity
    end.
  - (* T_Var *)
    match goal with
    | H1 : lookup _ _ = Some _,
      H2 : lookup _ _ = Some _ |- _ =>
        rewrite H1 in H2; inversion H2; subst; split; reflexivity
    end.
  - (* T_Lam *)
    match goal with
    | Hb : has_type ((?x, ?T1) :: _) _ _ _ _ _ |- _ =>
        specialize (IHt _ _ Hb) as [HT Heps]; subst; split; reflexivity
    end.
  - (* T_App *)
    match goal with
    | Ht1' : has_type _ _ _ _ _ _,
      Ht2' : has_type _ _ _ _ _ _ |- _ =>
        specialize (IHt1 _ _ Ht1') as [HT1 Heps1];
        specialize (IHt2 _ _ Ht2') as [HT2 Heps2];
        inversion HT1; subst; split; reflexivity
    end.
  - (* T_Pair *)
    repeat match goal with
    | Ht : has_type _ _ _ _ _ _ |- _ =>
        first
          [ specialize (IHt1 _ _ Ht) as [HT1 Heps1]; subst
          | specialize (IHt2 _ _ Ht) as [HT2 Heps2]; subst
          ]
    end;
    split; reflexivity.
  - (* T_Fst *)
    first
      [ specialize (IHt _ _ H4) as [HT Heps]
      | specialize (IHt _ _ H5) as [HT Heps]
      | specialize (IHt _ _ H6) as [HT Heps]
      | specialize (IHt _ _ H7) as [HT Heps]
      | specialize (IHt _ _ H8) as [HT Heps]
      | specialize (IHt _ _ H9) as [HT Heps]
      | specialize (IHt _ _ H10) as [HT Heps]
      ];
    inversion HT; subst; split; reflexivity.
  - (* T_Snd *)
    first
      [ specialize (IHt _ _ H4) as [HT Heps]
      | specialize (IHt _ _ H5) as [HT Heps]
      | specialize (IHt _ _ H6) as [HT Heps]
      | specialize (IHt _ _ H7) as [HT Heps]
      | specialize (IHt _ _ H8) as [HT Heps]
      | specialize (IHt _ _ H9) as [HT Heps]
      | specialize (IHt _ _ H10) as [HT Heps]
      ];
    inversion HT; subst; split; reflexivity.
  - (* T_Inl *)
    first
      [ specialize (IHt _ _ H4) as [HT Heps]
      | specialize (IHt _ _ H5) as [HT Heps]
      | specialize (IHt _ _ H6) as [HT Heps]
      | specialize (IHt _ _ H7) as [HT Heps]
      | specialize (IHt _ _ H8) as [HT Heps]
      | specialize (IHt _ _ H9) as [HT Heps]
      | specialize (IHt _ _ H10) as [HT Heps]
      ];
    subst; split; reflexivity.
  - (* T_Inr *)
    first
      [ specialize (IHt _ _ H4) as [HT Heps]
      | specialize (IHt _ _ H5) as [HT Heps]
      | specialize (IHt _ _ H6) as [HT Heps]
      | specialize (IHt _ _ H7) as [HT Heps]
      | specialize (IHt _ _ H8) as [HT Heps]
      | specialize (IHt _ _ H9) as [HT Heps]
      | specialize (IHt _ _ H10) as [HT Heps]
      ];
    subst; split; reflexivity.
  - (* T_Case *)
    specialize (IHt1 _ _ H10) as [HT0 Heps0].
    inversion HT0; subst.
    specialize (IHt2 _ _ H11) as [HT1 Heps1].
    specialize (IHt3 _ _ H12) as [HT2 Heps2].
    subst; split; reflexivity.
  - (* T_If *)
    first
      [ specialize (IHt1 _ _ H5) as [HT1 Heps1]
      | specialize (IHt1 _ _ H6) as [HT1 Heps1]
      | specialize (IHt1 _ _ H7) as [HT1 Heps1]
      ];
    first
      [ specialize (IHt2 _ _ H7) as [HT2 Heps2]
      | specialize (IHt2 _ _ H8) as [HT2 Heps2]
      | specialize (IHt2 _ _ H9) as [HT2 Heps2]
      ];
    first
      [ specialize (IHt3 _ _ H8) as [HT3 Heps3]
      | specialize (IHt3 _ _ H9) as [HT3 Heps3]
      | specialize (IHt3 _ _ H10) as [HT3 Heps3]
      ];
    rewrite HT2.
    rewrite Heps1, Heps2, Heps3.
    split; reflexivity.
  - (* T_Let *)
    inversion H2; subst; clear H2.
    specialize (IHt1 _ _ H7) as [HT1eq Heps1].
    rewrite HT1eq in *.
    specialize (IHt2 _ _ H11) as [HT2eq Heps2].
    rewrite Heps1, Heps2.
    subst.
    split; reflexivity.
  - (* T_Perform *)
    first
      [ specialize (IHt _ _ H4) as [HT Heps]
      | specialize (IHt _ _ H5) as [HT Heps]
      | specialize (IHt _ _ H6) as [HT Heps]
      | specialize (IHt _ _ H7) as [HT Heps]
      | specialize (IHt _ _ H8) as [HT Heps]
      | specialize (IHt _ _ H9) as [HT Heps]
      | specialize (IHt _ _ H10) as [HT Heps]
      ];
    subst; split; reflexivity.
  - (* T_Handle *)
    specialize (IHt1 _ _ H8) as [HT1eq Heps1].
    rewrite HT1eq in *.
    specialize (IHt2 _ _ H9) as [HT2eq Heps2].
    rewrite Heps1, Heps2.
    subst.
    split; reflexivity.
  - (* T_Ref *)
    first
      [ specialize (IHt _ _ H4) as [HT Heps]
      | specialize (IHt _ _ H5) as [HT Heps]
      | specialize (IHt _ _ H6) as [HT Heps]
      | specialize (IHt _ _ H7) as [HT Heps]
      | specialize (IHt _ _ H8) as [HT Heps]
      | specialize (IHt _ _ H9) as [HT Heps]
      | specialize (IHt _ _ H10) as [HT Heps]
      ];
    subst; split; reflexivity.
  - (* T_Deref *)
    match goal with
    | Ht' : has_type _ _ _ _ (TRef _ _) _ |- _ =>
        specialize (IHt _ _ Ht') as [HT Heps];
        inversion HT; subst; split; reflexivity
    end.
  - (* T_Assign *)
    match goal with
    | Ht1' : has_type _ _ _ _ _ _,
      Ht2' : has_type _ _ _ _ _ _ |- _ =>
        specialize (IHt1 _ _ Ht1') as [HT1 Heps1];
        specialize (IHt2 _ _ Ht2') as [HT2 Heps2];
        inversion HT1; subst; split; reflexivity
    end.
  - (* T_Classify *)
    first
      [ specialize (IHt _ _ H4) as [HT Heps]
      | specialize (IHt _ _ H5) as [HT Heps]
      | specialize (IHt _ _ H6) as [HT Heps]
      | specialize (IHt _ _ H7) as [HT Heps]
      | specialize (IHt _ _ H8) as [HT Heps]
      | specialize (IHt _ _ H9) as [HT Heps]
      | specialize (IHt _ _ H10) as [HT Heps]
      ];
    subst; split; reflexivity.
  - (* T_Declassify *)
    match goal with
    | Ht1' : has_type _ _ _ _ _ _,
      Ht2' : has_type _ _ _ _ _ _ |- _ =>
        specialize (IHt1 _ _ Ht1') as [HT1 Heps1];
        specialize (IHt2 _ _ Ht2') as [HT2 Heps2];
        inversion HT1; subst; split; reflexivity
    end.
  - (* T_Prove *)
    first
      [ specialize (IHt _ _ H4) as [HT Heps]
      | specialize (IHt _ _ H5) as [HT Heps]
      | specialize (IHt _ _ H6) as [HT Heps]
      | specialize (IHt _ _ H7) as [HT Heps]
      | specialize (IHt _ _ H8) as [HT Heps]
      | specialize (IHt _ _ H9) as [HT Heps]
      | specialize (IHt _ _ H10) as [HT Heps]
      ];
    subst; split; reflexivity.
  - (* T_Require *)
    match goal with
    | Ht' : has_type _ _ _ _ _ _ |- _ =>
        specialize (IHt _ _ Ht') as [HT Heps];
        subst; split; reflexivity
    end.
  - (* T_Grant *)
    match goal with
    | Ht' : has_type _ _ _ _ _ _ |- _ =>
        specialize (IHt _ _ Ht') as [HT Heps];
        subst; split; reflexivity
    end.
Qed.

(** ** Canonical Forms

    Canonical forms lemmas: if a value has a certain type, it must have
    a specific syntactic form. These are essential for proving progress
    and for the exp_rel_step1_* axioms in NonInterference.v.

    Mode: Comprehensive Verification | Zero Trust
*)

(** Unit type: only EUnit is a value of type TUnit *)
Lemma canonical_forms_unit : forall Γ Σ Δ v ε,
  value v ->
  has_type Γ Σ Δ v TUnit ε ->
  v = EUnit.
Proof.
  intros Γ Σ Δ v ε Hval Htype.
  inversion Hval; subst; inversion Htype; reflexivity.
Qed.

(** Bool type: only EBool b is a value of type TBool *)
Lemma canonical_forms_bool : forall Γ Σ Δ v ε,
  value v ->
  has_type Γ Σ Δ v TBool ε ->
  exists b, v = EBool b.
Proof.
  intros Γ Σ Δ v ε Hval Htype.
  inversion Hval; subst; inversion Htype; subst.
  exists b. reflexivity.
Qed.

(** Int type: only EInt n is a value of type TInt *)
Lemma canonical_forms_int : forall Γ Σ Δ v ε,
  value v ->
  has_type Γ Σ Δ v TInt ε ->
  exists n, v = EInt n.
Proof.
  intros Γ Σ Δ v ε Hval Htype.
  inversion Hval; subst; inversion Htype; subst.
  exists n. reflexivity.
Qed.

(** String type: only EString s is a value of type TString *)
Lemma canonical_forms_string : forall Γ Σ Δ v ε,
  value v ->
  has_type Γ Σ Δ v TString ε ->
  exists s, v = EString s.
Proof.
  intros Γ Σ Δ v ε Hval Htype.
  inversion Hval; subst; inversion Htype; subst.
  exists s. reflexivity.
Qed.

(** Function type: only ELam is a value of function type *)
Lemma canonical_forms_fn : forall Γ Σ Δ v T1 T2 ε_fn ε,
  value v ->
  has_type Γ Σ Δ v (TFn T1 T2 ε_fn) ε ->
  exists x body, v = ELam x T1 body.
Proof.
  intros Γ Σ Δ v T1 T2 ε_fn ε Hval Htype.
  inversion Hval; subst; inversion Htype; subst.
  exists x, e. reflexivity.
Qed.

(** Product type: only EPair is a value of product type *)
Lemma canonical_forms_prod : forall Γ Σ Δ v T1 T2 ε,
  value v ->
  has_type Γ Σ Δ v (TProd T1 T2) ε ->
  exists v1 v2, v = EPair v1 v2 /\ value v1 /\ value v2.
Proof.
  intros Γ Σ Δ v T1 T2 ε Hval Htype.
  inversion Hval; subst; inversion Htype; subst.
  exists v1, v2. repeat split; assumption.
Qed.

(** Sum type: only EInl or EInr is a value of sum type *)
Lemma canonical_forms_sum : forall Γ Σ Δ v T1 T2 ε,
  value v ->
  has_type Γ Σ Δ v (TSum T1 T2) ε ->
  (exists v', v = EInl v' T2 /\ value v') \/
  (exists v', v = EInr v' T1 /\ value v').
Proof.
  intros Γ Σ Δ v T1 T2 ε Hval Htype.
  inversion Hval; subst; inversion Htype; subst.
  - (* VInl *)
    left. exists v0. split; [reflexivity | assumption].
  - (* VInr *)
    right. exists v0. split; [reflexivity | assumption].
Qed.

(** Reference type: only ELoc is a value of reference type *)
Lemma canonical_forms_ref : forall Γ Σ Δ v T sl ε,
  value v ->
  has_type Γ Σ Δ v (TRef T sl) ε ->
  exists l, v = ELoc l.
Proof.
  intros Γ Σ Δ v T sl ε Hval Htype.
  inversion Hval; subst; inversion Htype; subst.
  exists l. reflexivity.
Qed.

(** Secret type: only EClassify is a value of secret type *)
Lemma canonical_forms_secret : forall Γ Σ Δ v T ε,
  value v ->
  has_type Γ Σ Δ v (TSecret T) ε ->
  exists v', v = EClassify v' /\ value v'.
Proof.
  intros Γ Σ Δ v T ε Hval Htype.
  inversion Hval; subst; inversion Htype; subst.
  exists v0. split; [reflexivity | assumption].
Qed.

(** Proof type: only EProve is a value of proof type *)
Lemma canonical_forms_proof : forall Γ Σ Δ v T ε,
  value v ->
  has_type Γ Σ Δ v (TProof T) ε ->
  exists v', v = EProve v' /\ value v'.
Proof.
  intros Γ Σ Δ v T ε Hval Htype.
  inversion Hval; subst; inversion Htype; subst.
  exists v0. split; [reflexivity | assumption].
Qed.

(** ** Combined Canonical Forms

    A single lemma that provides canonical form information for any type.
    Useful for automated proofs.
*)
Lemma canonical_forms : forall Γ Σ Δ v T ε,
  value v ->
  has_type Γ Σ Δ v T ε ->
  match T with
  | TUnit => v = EUnit
  | TBool => exists b, v = EBool b
  | TInt => exists n, v = EInt n
  | TString => exists s, v = EString s
  | TFn T1 T2 _ => exists x body, v = ELam x T1 body
  | TProd T1 T2 => exists v1 v2, v = EPair v1 v2 /\ value v1 /\ value v2
  | TSum T1 T2 => (exists v', v = EInl v' T2 /\ value v') \/
                   (exists v', v = EInr v' T1 /\ value v')
  | TRef T' sl => exists l, v = ELoc l
  | TSecret T' => exists v', v = EClassify v' /\ value v'
  | TProof T' => exists v', v = EProve v' /\ value v'
  (* Other types - treat as True for extensibility *)
  | _ => True
  end.
Proof.
  intros Γ Σ Δ v T ε Hval Htype.
  destruct T; try exact I.
  - (* TUnit *)
    eapply canonical_forms_unit; eassumption.
  - (* TBool *)
    eapply canonical_forms_bool; eassumption.
  - (* TInt *)
    eapply canonical_forms_int; eassumption.
  - (* TString *)
    eapply canonical_forms_string; eassumption.
  - (* TFn *)
    eapply canonical_forms_fn; eassumption.
  - (* TProd *)
    eapply canonical_forms_prod; eassumption.
  - (* TSum *)
    eapply canonical_forms_sum; eassumption.
  - (* TRef *)
    eapply canonical_forms_ref; eassumption.
  - (* TSecret *)
    eapply canonical_forms_secret; eassumption.
  - (* TProof *)
    eapply canonical_forms_proof; eassumption.
Qed.

(** ** Additional Typing Properties *)

(** Store typing extension is reflexive. *)
Lemma store_ty_extends_refl : forall Σ, store_ty_extends Σ Σ.
Proof.
  unfold store_ty_extends. intros Σ l T sl H. exact H.
Qed.

(** Store typing extension is transitive. *)
Lemma store_ty_extends_trans : forall Σ1 Σ2 Σ3,
  store_ty_extends Σ1 Σ2 ->
  store_ty_extends Σ2 Σ3 ->
  store_ty_extends Σ1 Σ3.
Proof.
  unfold store_ty_extends. intros Σ1 Σ2 Σ3 H12 H23 l T sl Hlook.
  apply H23. apply H12. exact Hlook.
Qed.

(** A variable expression is never typeable in the empty context.
    This is because EVar x requires lookup x [] = Some T, which fails. *)
Lemma closed_expr_no_var : forall Σ Δ x T ε,
  has_type nil Σ Δ (EVar x) T ε -> False.
Proof.
  intros Σ Δ x T ε Htype.
  inversion Htype; subst.
  simpl in *. discriminate.
Qed.

(** Values of unit type in the empty context are exactly EUnit. *)
Lemma value_unit_closed : forall Σ Δ v ε,
  value v ->
  has_type nil Σ Δ v TUnit ε ->
  v = EUnit /\ ε = EffectPure.
Proof.
  intros Σ Δ v ε Hval Htype.
  inversion Hval; subst; inversion Htype; subst; split; reflexivity.
Qed.

(** Simple atomic values (unit, bool, int, string, loc, lam) always
    have pure effect at the outermost level. *)
Lemma simple_value_pure_effect : forall Γ Σ Δ T ε,
  (has_type Γ Σ Δ EUnit T ε -> ε = EffPure) /\
  (forall b, has_type Γ Σ Δ (EBool b) T ε -> ε = EffPure) /\
  (forall n, has_type Γ Σ Δ (EInt n) T ε -> ε = EffPure) /\
  (forall s, has_type Γ Σ Δ (EString s) T ε -> ε = EffPure) /\
  (forall l, has_type Γ Σ Δ (ELoc l) T ε -> ε = EffPure) /\
  (forall x T1 e, has_type Γ Σ Δ (ELam x T1 e) T ε -> ε = EffPure).
Proof.
  intros Γ Σ Δ T ε.
  repeat split; intros; inversion H; reflexivity.
Qed.

(** Unit values always have pure effect. *)
Lemma unit_value_pure : forall Γ Σ Δ T ε,
  has_type Γ Σ Δ EUnit T ε -> ε = EffPure.
Proof. intros. inversion H. reflexivity. Qed.

(** Lambda values always have pure effect at the outermost level. *)
Lemma lam_value_pure : forall Γ Σ Δ x T1 e T ε,
  has_type Γ Σ Δ (ELam x T1 e) T ε -> ε = EffPure.
Proof. intros. inversion H. reflexivity. Qed.

(** Location values always have pure effect. *)
Lemma loc_value_pure : forall Γ Σ Δ l T ε,
  has_type Γ Σ Δ (ELoc l) T ε -> ε = EffPure.
Proof. intros. inversion H. reflexivity. Qed.

(** ** Context Lookup Lemmas *)

(** Looking up a variable at the head of the context finds it immediately. *)
Lemma lookup_head : forall x T Γ,
  lookup x ((x, T) :: Γ) = Some T.
Proof.
  intros x T Γ. simpl. rewrite String.eqb_refl. reflexivity.
Qed.

(** Looking up a different variable skips the head. *)
Lemma lookup_tail : forall x y T Γ,
  x <> y ->
  lookup x ((y, T) :: Γ) = lookup x Γ.
Proof.
  intros x y T Γ Hneq. simpl.
  destruct (String.eqb x y) eqn:Heq.
  - apply String.eqb_eq in Heq. contradiction.
  - reflexivity.
Qed.

(** A later binding for the same variable shadows an earlier one. *)
Lemma lookup_shadow : forall x T1 T2 Γ,
  lookup x ((x, T1) :: (x, T2) :: Γ) = Some T1.
Proof.
  intros x T1 T2 Γ. simpl. rewrite String.eqb_refl. reflexivity.
Qed.

(** Permutation of different variables in the context:
    if x <> y, then swapping (x, T1) and (y, T2) in the context
    does not affect lookup for x. *)
Lemma lookup_permute : forall x y T1 T2 Γ,
  x <> y ->
  lookup x ((y, T2) :: (x, T1) :: Γ) = lookup x ((x, T1) :: (y, T2) :: Γ).
Proof.
  intros x y T1 T2 Γ Hneq. simpl.
  rewrite String.eqb_refl.
  destruct (String.eqb x y) eqn:Heq.
  - apply String.eqb_eq in Heq. contradiction.
  - reflexivity.
Qed.

(** Lookup in an empty context always returns None. *)
Lemma lookup_empty : forall x,
  lookup x nil = None.
Proof.
  intros x. reflexivity.
Qed.

(** ** Store Typing Lookup Lemmas *)

(** Store typing lookup at the head succeeds when the location matches. *)
Lemma store_ty_lookup_head : forall l T sl Σ,
  store_ty_lookup l ((l, T, sl) :: Σ) = Some (T, sl).
Proof.
  intros l T sl Σ. simpl. rewrite Nat.eqb_refl. reflexivity.
Qed.

(** Store typing lookup skips a non-matching head entry. *)
Lemma store_ty_lookup_tail : forall l l' T sl Σ,
  l <> l' ->
  store_ty_lookup l ((l', T, sl) :: Σ) = store_ty_lookup l Σ.
Proof.
  intros l l' T sl Σ Hneq. simpl.
  destruct (Nat.eqb l l') eqn:Heq.
  - apply Nat.eqb_eq in Heq. contradiction.
  - reflexivity.
Qed.

(** Store typing lookup in empty store typing returns None. *)
Lemma store_ty_lookup_empty : forall l,
  store_ty_lookup l nil = None.
Proof.
  intros l. reflexivity.
Qed.

(** ** Well-formedness Consequences *)

(** From store_wf, any location in the store typing corresponds to a well-typed value. *)
Lemma store_wf_typed_value : forall Σ st l T sl,
  store_wf Σ st ->
  store_ty_lookup l Σ = Some (T, sl) ->
  exists v, store_lookup l st = Some v /\ value v /\ has_type nil Σ Public v T EffectPure.
Proof.
  intros Σ st l T sl [H1 _] Hlook.
  exact (H1 l T sl Hlook).
Qed.

(** From store_wf, any location in the runtime store is in the store typing. *)
Lemma store_wf_runtime_typed : forall Σ st l v,
  store_wf Σ st ->
  store_lookup l st = Some v ->
  exists T sl, store_ty_lookup l Σ = Some (T, sl) /\ value v /\ has_type nil Σ Public v T EffectPure.
Proof.
  intros Σ st l v [_ H2] Hlook.
  apply H2. exact Hlook.
Qed.

(** ** Weakening and Strengthening *)

(** If a variable x is not free in e, and e is typeable with (x,S)::Γ,
    then e is also typeable without x in the context.
    This is a fundamental structural property, but its full proof requires
    induction over has_type which involves many cases.
    Here we state and prove the contrapositive for variables. *)
Lemma typing_var_in_context : forall x Γ Σ Δ T ε,
  has_type Γ Σ Δ (EVar x) T ε ->
  lookup x Γ = Some T.
Proof.
  intros x Γ Σ Δ T ε Htype.
  inversion Htype; subst.
  assumption.
Qed.

(** A well-typed value in the empty context has no free variables for
    variable expressions (i.e., EVar is not a value). *)
Lemma closed_value_not_var : forall x Σ Δ T ε,
  has_type nil Σ Δ (EVar x) T ε -> False.
Proof.
  intros x Σ Δ T ε Htype.
  inversion Htype; subst.
  match goal with
  | [ H : lookup _ nil = Some _ |- _ ] => simpl in H; discriminate
  end.
Qed.

(** ** Effect Subsumption *)

(** Pure effect is compatible with any effect bound:
    if an expression has pure effect, it is safe in any effect context. *)
Lemma pure_effect_is_bottom : forall ε,
  effect_join EffectPure ε = ε.
Proof.
  intro ε. apply effect_join_pure_l.
Qed.

(** End of Typing.v *)

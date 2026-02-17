-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
import RIINA.Foundations.Syntax
import RIINA.Foundations.Semantics

/-!
# RIINA Typing Rules - Lean 4 Port

Port of 02_FORMAL/coq/foundations/Typing.v (648 lines, 12 Qed).
Uses definitions from Syntax.lean and Semantics.lean.
-/

namespace RIINA

open security_level effect effect_category taint_source sanitizer
     capability_kind capability ty session_type expr

/-! ## Type Environments -/

/-- Type environment: list of (identifier, type) pairs -/
abbrev type_env := List (ident × ty)

/-- Lookup in type environment -/
def type_env_lookup (x : ident) : type_env → Option ty
  | [] => none
  | (y, T) :: Γ' => if x = y then some T else type_env_lookup x Γ'

/-! ## Store Typing -/

/-- Store typing: list of (location, type, security level) -/
abbrev store_ty := List (loc × ty × security_level)

/-- Lookup in store typing -/
def store_ty_lookup (l : loc) : store_ty → Option (ty × security_level)
  | [] => none
  | entry :: rest =>
      let (l', Tsl) := entry
      if l = l' then some Tsl else store_ty_lookup l rest

/-- Update store typing -/
def store_ty_update (l : loc) (T : ty) (sl : security_level) : store_ty → store_ty
  | [] => [(l, T, sl)]
  | entry :: rest =>
      let (l', _) := entry
      if l = l' then (l, T, sl) :: rest else entry :: store_ty_update l T sl rest

/-- Store typing extension -/
def store_ty_extends (σ σ' : store_ty) : Prop :=
  ∀ (l : loc) (T : ty) (sl : security_level),
    store_ty_lookup l σ = some (T, sl) → store_ty_lookup l σ' = some (T, sl)

/-! ## Effect join (for typing) -/

/-- Join of two effects (max by level) -/
def eff_join (e1 e2 : effect) : effect :=
  effect_join e1 e2

/-! ## Typing Judgment

has_type Γ St Δ e T ε means: under environment Γ, store typing St,
and security context Δ, expression e has type T with effect ε.
-/

/-- Typing judgment (28 rules matching Coq) -/
inductive has_type : type_env → store_ty → security_level → expr → ty → effect → Prop where
  -- Values
  | T_Unit : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      has_type Γ σ Δ EUnit TUnit EffPure
  | T_Bool : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} → {b : Bool} →
      has_type Γ σ Δ (EBool b) TBool EffPure
  | T_Int : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} → {n : Nat} →
      has_type Γ σ Δ (EInt n) TInt EffPure
  | T_String : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} → {s : String} →
      has_type Γ σ Δ (EString s) TString EffPure
  | T_Loc : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {l : loc} → {T : ty} → {sl : security_level} →
      store_ty_lookup l σ = some (T, sl) →
      has_type Γ σ Δ (ELoc l) (TRef T sl) EffPure
  | T_Var : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {x : ident} → {T : ty} →
      type_env_lookup x Γ = some T →
      has_type Γ σ Δ (EVar x) T EffPure
  -- Functions
  | T_Lam : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {x : ident} → {T1 T2 : ty} → {e : expr} → {ε : effect} →
      has_type ((x, T1) :: Γ) σ Δ e T2 ε →
      has_type Γ σ Δ (ELam x T1 e) (TFn T1 T2 ε) EffPure
  | T_App : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {e1 e2 : expr} → {T1 T2 : ty} → {ε ε1 ε2 : effect} →
      has_type Γ σ Δ e1 (TFn T1 T2 ε) ε1 →
      has_type Γ σ Δ e2 T1 ε2 →
      has_type Γ σ Δ (EApp e1 e2) T2 (eff_join ε (eff_join ε1 ε2))
  -- Products
  | T_Pair : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {e1 e2 : expr} → {T1 T2 : ty} → {ε1 ε2 : effect} →
      has_type Γ σ Δ e1 T1 ε1 →
      has_type Γ σ Δ e2 T2 ε2 →
      has_type Γ σ Δ (EPair e1 e2) (TProd T1 T2) (eff_join ε1 ε2)
  | T_Fst : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {e : expr} → {T1 T2 : ty} → {ε : effect} →
      has_type Γ σ Δ e (TProd T1 T2) ε →
      has_type Γ σ Δ (EFst e) T1 ε
  | T_Snd : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {e : expr} → {T1 T2 : ty} → {ε : effect} →
      has_type Γ σ Δ e (TProd T1 T2) ε →
      has_type Γ σ Δ (ESnd e) T2 ε
  -- Sums
  | T_Inl : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {e : expr} → {T1 T2 : ty} → {ε : effect} →
      has_type Γ σ Δ e T1 ε →
      has_type Γ σ Δ (EInl e T2) (TSum T1 T2) ε
  | T_Inr : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {e : expr} → {T1 T2 : ty} → {ε : effect} →
      has_type Γ σ Δ e T2 ε →
      has_type Γ σ Δ (EInr e T1) (TSum T1 T2) ε
  | T_Case : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {e : expr} → {x1 : ident} → {e1 : expr} → {x2 : ident} → {e2 : expr} →
      {T1 T2 T : ty} → {ε ε1 ε2 : effect} →
      has_type Γ σ Δ e (TSum T1 T2) ε →
      has_type ((x1, T1) :: Γ) σ Δ e1 T ε1 →
      has_type ((x2, T2) :: Γ) σ Δ e2 T ε2 →
      has_type Γ σ Δ (ECase e x1 e1 x2 e2) T (eff_join ε (eff_join ε1 ε2))
  -- Control
  | T_If : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {e1 e2 e3 : expr} → {T : ty} → {ε1 ε2 ε3 : effect} →
      has_type Γ σ Δ e1 TBool ε1 →
      has_type Γ σ Δ e2 T ε2 →
      has_type Γ σ Δ e3 T ε3 →
      has_type Γ σ Δ (EIf e1 e2 e3) T (eff_join ε1 (eff_join ε2 ε3))
  | T_Let : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {x : ident} → {e1 e2 : expr} → {T1 T2 : ty} → {ε1 ε2 : effect} →
      has_type Γ σ Δ e1 T1 ε1 →
      has_type ((x, T1) :: Γ) σ Δ e2 T2 ε2 →
      has_type Γ σ Δ (ELet x e1 e2) T2 (eff_join ε1 ε2)
  -- Effects
  | T_Perform : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {eff : effect} → {e : expr} → {T : ty} → {ε : effect} →
      has_type Γ σ Δ e T ε →
      has_type Γ σ Δ (EPerform eff e) T (eff_join ε eff)
  | T_Handle : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {e : expr} → {x : ident} → {h : expr} → {T1 T2 : ty} → {ε1 ε2 : effect} →
      has_type Γ σ Δ e T1 ε1 →
      has_type ((x, T1) :: Γ) σ Δ h T2 ε2 →
      has_type Γ σ Δ (EHandle e x h) T2 (eff_join ε1 ε2)
  -- References
  | T_Ref : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {e : expr} → {T : ty} → {sl : security_level} → {ε : effect} →
      has_type Γ σ Δ e T ε →
      has_type Γ σ Δ (ERef e sl) (TRef T sl) (eff_join ε EffWrite)
  | T_Deref : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {e : expr} → {T : ty} → {sl : security_level} → {ε : effect} →
      has_type Γ σ Δ e (TRef T sl) ε →
      has_type Γ σ Δ (EDeref e) T (eff_join ε EffRead)
  | T_Assign : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {e1 e2 : expr} → {T : ty} → {sl : security_level} → {ε1 ε2 : effect} →
      has_type Γ σ Δ e1 (TRef T sl) ε1 →
      has_type Γ σ Δ e2 T ε2 →
      has_type Γ σ Δ (EAssign e1 e2) TUnit (eff_join ε1 (eff_join ε2 EffWrite))
  -- Security
  | T_Classify : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {e : expr} → {T : ty} → {ε : effect} →
      has_type Γ σ Δ e T ε →
      has_type Γ σ Δ (EClassify e) (TSecret T) ε
  | T_Declassify : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {e1 e2 : expr} → {T : ty} → {ε1 ε2 : effect} →
      has_type Γ σ Δ e1 (TSecret T) ε1 →
      has_type Γ σ Δ e2 (TProof (TSecret T)) ε2 →
      declass_ok e1 e2 →
      has_type Γ σ Δ (EDeclassify e1 e2) T (eff_join ε1 ε2)
  | T_Prove : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {e : expr} → {T : ty} → {ε : effect} →
      has_type Γ σ Δ e T ε →
      has_type Γ σ Δ (EProve e) (TProof T) ε
  -- Capabilities
  | T_Require : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {eff : effect} → {e : expr} → {T : ty} → {ε : effect} →
      has_type Γ σ Δ e T ε →
      has_type Γ σ Δ (ERequire eff e) T (eff_join ε eff)
  | T_Grant : {Γ : type_env} → {σ : store_ty} → {Δ : security_level} →
      {eff : effect} → {e : expr} → {T : ty} → {ε : effect} →
      has_type Γ σ Δ e T ε →
      has_type Γ σ Δ (EGrant eff e) T ε

/-! ## Store Well-Formedness -/

/-- Well-typed store -/
def store_wf (σ : store_ty) (st : store) : Prop :=
  (∀ (l : loc) (T : ty) (sl : security_level),
     store_ty_lookup l σ = some (T, sl) →
     ∃ (v : expr), store_lookup l st = some v ∧ value v ∧
       has_type [] σ LPublic v T EffPure) ∧
  (∀ (l : loc) (v : expr),
     store_lookup l st = some v →
     ∃ (T : ty) (sl : security_level),
       store_ty_lookup l σ = some (T, sl) ∧ value v ∧
       has_type [] σ LPublic v T EffPure)

/-! ## Canonical Forms -/

/-- Unit type: only EUnit is a value of type TUnit -/
theorem canonical_forms_unit {Γ : type_env} {σ : store_ty} {Δ : security_level}
    {v : expr} {ε : effect}
    (hval : value v) (htype : has_type Γ σ Δ v TUnit ε) :
    v = EUnit := by
  cases hval <;> cases htype <;> rfl

/-- Bool type: only EBool b is a value of type TBool -/
theorem canonical_forms_bool {Γ : type_env} {σ : store_ty} {Δ : security_level}
    {v : expr} {ε : effect}
    (hval : value v) (htype : has_type Γ σ Δ v TBool ε) :
    ∃ (b : Bool), v = EBool b := by
  cases hval <;> cases htype
  exact ⟨_, rfl⟩

/-- Int type: only EInt n is a value of type TInt -/
theorem canonical_forms_int {Γ : type_env} {σ : store_ty} {Δ : security_level}
    {v : expr} {ε : effect}
    (hval : value v) (htype : has_type Γ σ Δ v TInt ε) :
    ∃ (n : Nat), v = EInt n := by
  cases hval <;> cases htype
  exact ⟨_, rfl⟩

/-- String type: only EString s is a value of type TString -/
theorem canonical_forms_string {Γ : type_env} {σ : store_ty} {Δ : security_level}
    {v : expr} {ε : effect}
    (hval : value v) (htype : has_type Γ σ Δ v TString ε) :
    ∃ (s : String), v = EString s := by
  cases hval <;> cases htype
  exact ⟨_, rfl⟩

/-- Function type: only ELam is a value of function type -/
theorem canonical_forms_fn {Γ : type_env} {σ : store_ty} {Δ : security_level}
    {v : expr} {T1 T2 : ty} {ε_fn ε : effect}
    (hval : value v) (htype : has_type Γ σ Δ v (TFn T1 T2 ε_fn) ε) :
    ∃ (x : ident) (body : expr), v = ELam x T1 body := by
  cases hval <;> cases htype
  exact ⟨_, _, rfl⟩

/-- Product type: only EPair is a value of product type -/
theorem canonical_forms_prod {Γ : type_env} {σ : store_ty} {Δ : security_level}
    {v : expr} {T1 T2 : ty} {ε : effect}
    (hval : value v) (htype : has_type Γ σ Δ v (TProd T1 T2) ε) :
    ∃ (v1 v2 : expr), v = EPair v1 v2 ∧ value v1 ∧ value v2 := by
  cases hval with
  | VUnit => cases htype
  | VBool _ => cases htype
  | VInt _ => cases htype
  | VString _ => cases htype
  | VLoc _ => cases htype
  | VLam _ _ _ => cases htype
  | VPair _ _ hv1 hv2 => cases htype; exact ⟨_, _, rfl, hv1, hv2⟩
  | VInl _ _ _ => cases htype
  | VInr _ _ _ => cases htype
  | VClassify _ _ => cases htype
  | VProve _ _ => cases htype

/-- Sum type: only EInl or EInr is a value of sum type -/
theorem canonical_forms_sum {Γ : type_env} {σ : store_ty} {Δ : security_level}
    {v : expr} {T1 T2 : ty} {ε : effect}
    (hval : value v) (htype : has_type Γ σ Δ v (TSum T1 T2) ε) :
    (∃ (v' : expr), v = EInl v' T2 ∧ value v') ∨
    (∃ (v' : expr), v = EInr v' T1 ∧ value v') := by
  cases hval with
  | VUnit => cases htype
  | VBool _ => cases htype
  | VInt _ => cases htype
  | VString _ => cases htype
  | VLoc _ => cases htype
  | VLam _ _ _ => cases htype
  | VPair _ _ _ _ => cases htype
  | VInl _ _ hv => cases htype; exact Or.inl ⟨_, rfl, hv⟩
  | VInr _ _ hv => cases htype; exact Or.inr ⟨_, rfl, hv⟩
  | VClassify _ _ => cases htype
  | VProve _ _ => cases htype

/-- Reference type: only ELoc is a value of reference type -/
theorem canonical_forms_ref {Γ : type_env} {σ : store_ty} {Δ : security_level}
    {v : expr} {T : ty} {sl : security_level} {ε : effect}
    (hval : value v) (htype : has_type Γ σ Δ v (TRef T sl) ε) :
    ∃ (l : loc), v = ELoc l := by
  cases hval <;> cases htype
  exact ⟨_, rfl⟩

/-- Secret type: only EClassify is a value of secret type -/
theorem canonical_forms_secret {Γ : type_env} {σ : store_ty} {Δ : security_level}
    {v : expr} {T : ty} {ε : effect}
    (hval : value v) (htype : has_type Γ σ Δ v (TSecret T) ε) :
    ∃ (v' : expr), v = EClassify v' ∧ value v' := by
  cases hval with
  | VUnit => cases htype
  | VBool _ => cases htype
  | VInt _ => cases htype
  | VString _ => cases htype
  | VLoc _ => cases htype
  | VLam _ _ _ => cases htype
  | VPair _ _ _ _ => cases htype
  | VInl _ _ _ => cases htype
  | VInr _ _ _ => cases htype
  | VClassify _ hv => cases htype; exact ⟨_, rfl, hv⟩
  | VProve _ _ => cases htype

/-- Proof type: only EProve is a value of proof type -/
theorem canonical_forms_proof {Γ : type_env} {σ : store_ty} {Δ : security_level}
    {v : expr} {T : ty} {ε : effect}
    (hval : value v) (htype : has_type Γ σ Δ v (TProof T) ε) :
    ∃ (v' : expr), v = EProve v' ∧ value v' := by
  cases hval with
  | VUnit => cases htype
  | VBool _ => cases htype
  | VInt _ => cases htype
  | VString _ => cases htype
  | VLoc _ => cases htype
  | VLam _ _ _ => cases htype
  | VPair _ _ _ _ => cases htype
  | VInl _ _ _ => cases htype
  | VInr _ _ _ => cases htype
  | VClassify _ _ => cases htype
  | VProve _ hv => cases htype; exact ⟨_, rfl, hv⟩

end RIINA

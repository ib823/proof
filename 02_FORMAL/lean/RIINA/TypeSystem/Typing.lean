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

/-- Coq-compat alias used by transpiled files. -/
abbrev lookup := type_env_lookup

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

/-- Coq-compat alias used by transpiled files. -/
abbrev store_ty_ext := store_ty_extends

/-- Transpilation-compat placeholder: one-step structural relation. -/
def val_rel_struct
    (val_rel_prev : store_ty → ty → expr → expr → Prop)
    (St : store_ty) (T : ty) (v1 v2 : expr) : Prop :=
  value v1 ∧ value v2 ∧
  closed_expr v1 ∧ closed_expr v2 ∧
  match T with
  | TUnit => v1 = EUnit ∧ v2 = EUnit
  | TBool => ∃ b, v1 = EBool b ∧ v2 = EBool b
  | TInt => ∃ i, v1 = EInt i ∧ v2 = EInt i
  | TString => ∃ s, v1 = EString s ∧ v2 = EString s
  | TBytes => v1 = v2
  | TSecret _ => True
  | TLabeled _ _ => True
  | TTainted _ _ => True
  | TSanitized _ _ => True
  | TCapability _ => True
  | TCapabilityFull _ => True
  | TProof _ => True
  | TChan _ => True
  | TSecureChan _ _ => True
  | TConstantTime _ => True
  | TZeroizing _ => True
  | TRef _ _ => ∃ l, v1 = ELoc l ∧ v2 = ELoc l
  | TList _ => True
  | TOption _ => True
  | TProd T1 T2 =>
      ∃ a1 b1 a2 b2,
        v1 = EPair a1 b1 ∧ v2 = EPair a2 b2 ∧
        val_rel_prev St T1 a1 a2 ∧
        val_rel_prev St T2 b1 b2
  | TSum T1 T2 =>
      (∃ a1 a2,
          v1 = EInl a1 T2 ∧ v2 = EInl a2 T2 ∧ val_rel_prev St T1 a1 a2) ∨
      (∃ b1 b2,
          v1 = EInr b1 T1 ∧ v2 = EInr b2 T1 ∧ val_rel_prev St T2 b1 b2)
  | TFn _ _ _ => True

/-- Transpilation-compat placeholder: structural value relation at a type. -/
def val_rel_at_type
    (St : store_ty)
    (store_rel_pred : store_ty → store → store → Prop)
    (val_rel_lower : store_ty → ty → expr → expr → Prop)
    (store_rel_lower : store_ty → store → store → Prop)
    (store_vals_pred : store_ty → store → store → Prop)
    (T : ty) (v1 v2 : expr) : Prop :=
  if first_order_type T then val_rel_at_type_fo T v1 v2 else True

/-- Transpilation-compat placeholder: cumulative value relation. -/
def val_rel_le : Nat → store_ty → ty → expr → expr → Prop
  | 0, _St, _T, _v1, _v2 => True
  | Nat.succ n, St, T, v1, v2 =>
      val_rel_le n St T v1 v2 ∧ val_rel_struct (val_rel_le n) St T v1 v2

/-- Transpilation-compat placeholder: cumulative store relation. -/
def store_rel_le (n : Nat) (St : store_ty) (st1 st2 : store) : Prop :=
  store_max st1 = store_max st2

/-- Transpilation-compat placeholder: cumulative expression relation. -/
def exp_rel_le (n : Nat) (St : store_ty) (T : ty)
    (e1 e2 : expr) (st1 st2 : store) (ctx : effect_ctx) : Prop := True

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

/-! ## Store Typing Weakening -/

/-- Typing is monotone in the store typing: extending the store preserves typing. -/
theorem has_type_store_weaken {Γ : type_env} {σ σ' : store_ty} {Δ : security_level}
    {e : expr} {T : ty} {ε : effect}
    (htype : has_type Γ σ Δ e T ε) (hext : store_ty_extends σ σ') :
    has_type Γ σ' Δ e T ε := by
  induction htype with
  | T_Unit => exact has_type.T_Unit
  | T_Bool => exact has_type.T_Bool
  | T_Int => exact has_type.T_Int
  | T_String => exact has_type.T_String
  | T_Loc hlookup => exact has_type.T_Loc (hext _ _ _ hlookup)
  | T_Var hlookup => exact has_type.T_Var hlookup
  | T_Lam _ ih => exact has_type.T_Lam (ih hext)
  | T_App _ _ ih1 ih2 => exact has_type.T_App (ih1 hext) (ih2 hext)
  | T_Pair _ _ ih1 ih2 => exact has_type.T_Pair (ih1 hext) (ih2 hext)
  | T_Fst _ ih => exact has_type.T_Fst (ih hext)
  | T_Snd _ ih => exact has_type.T_Snd (ih hext)
  | T_Inl _ ih => exact has_type.T_Inl (ih hext)
  | T_Inr _ ih => exact has_type.T_Inr (ih hext)
  | T_Case _ _ _ ih1 ih2 ih3 => exact has_type.T_Case (ih1 hext) (ih2 hext) (ih3 hext)
  | T_If _ _ _ ih1 ih2 ih3 => exact has_type.T_If (ih1 hext) (ih2 hext) (ih3 hext)
  | T_Let _ _ ih1 ih2 => exact has_type.T_Let (ih1 hext) (ih2 hext)
  | T_Perform _ ih => exact has_type.T_Perform (ih hext)
  | T_Handle _ _ ih1 ih2 => exact has_type.T_Handle (ih1 hext) (ih2 hext)
  | T_Ref _ ih => exact has_type.T_Ref (ih hext)
  | T_Deref _ ih => exact has_type.T_Deref (ih hext)
  | T_Assign _ _ ih1 ih2 => exact has_type.T_Assign (ih1 hext) (ih2 hext)
  | T_Classify _ ih => exact has_type.T_Classify (ih hext)
  | T_Declassify _ _ hd ih1 ih2 => exact has_type.T_Declassify (ih1 hext) (ih2 hext) hd
  | T_Prove _ ih => exact has_type.T_Prove (ih hext)
  | T_Require _ ih => exact has_type.T_Require (ih hext)
  | T_Grant _ ih => exact has_type.T_Grant (ih hext)

/-! ## Step-Indexed Relational Predicates

These are defined after `has_type` so that `val_rel_n` can include
typing as a component, matching the Coq originals and enabling
typing extraction lemmas.
-/

/-- Step-indexed value relation (includes typing for extraction lemmas). -/
def val_rel_n : Nat → store_ty → ty → expr → expr → Prop
  | 0, St, T, v1, v2 =>
      value v1 ∧ value v2 ∧
      closed_expr v1 ∧ closed_expr v2 ∧
      has_type [] St Public v1 T EffectPure ∧
      has_type [] St Public v2 T EffectPure ∧
      (if first_order_type T then val_rel_at_type_fo T v1 v2 else True)
  | Nat.succ n, St, T, v1, v2 =>
      val_rel_n n St T v1 v2 ∧
      value v1 ∧ value v2 ∧
      closed_expr v1 ∧ closed_expr v2 ∧
      has_type [] St Public v1 T EffectPure ∧
      has_type [] St Public v2 T EffectPure ∧
      (match n with
       | 0 => True
       | Nat.succ _ =>
           val_rel_at_type St
             (fun _ _ _ => True)
             (val_rel_n n)
             (fun _ _ _ => True)
             (fun _ _ _ => True)
             T v1 v2)

/-- Step-indexed store relation. -/
def store_rel_n : Nat → store_ty → store → store → Prop
  | 0, _St, st1, st2 =>
      store_max st1 = store_max st2
  | Nat.succ n, St, st1, st2 =>
      store_rel_n n St st1 st2 ∧
      store_max st1 = store_max st2 ∧
      (∀ l T sl,
         store_ty_lookup l St = some (T, sl) →
         ∃ v1 v2,
           store_lookup l st1 = some v1 ∧
           store_lookup l st2 = some v2 ∧
           (if sec_leq_dec sl Public then
              val_rel_n n St T v1 v2
            else
              value v1 ∧ value v2 ∧
              closed_expr v1 ∧ closed_expr v2 ∧
              has_type [] St Public v1 T EffectPure ∧
              has_type [] St Public v2 T EffectPure))

/-- Step-indexed expression relation (placeholder). -/
def exp_rel_n (_n : Nat) (_St : store_ty) (_T : ty) (_e1 _e2 : expr) : Prop := True

/-- Non-indexed value relation. -/
def val_rel (St : store_ty) (T : ty) (v1 v2 : expr) : Prop :=
  ∀ n, val_rel_n n St T v1 v2

/-- Non-indexed store relation. -/
def store_rel (St : store_ty) (st1 st2 : store) : Prop :=
  ∀ n, store_rel_n n St st1 st2

/-- Non-indexed expression relation. -/
def exp_rel (St : store_ty) (T : ty) (e1 e2 : expr) : Prop :=
  ∀ n, exp_rel_n n St T e1 e2

end RIINA

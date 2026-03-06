-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.
import RIINA.Foundations.Syntax
import RIINA.Foundations.Semantics
import RIINA.TypeSystem.Typing
import RIINA.Properties.ContextProperties

/-!
# RIINA SubstitutionLemma - Lean 4

Proves the substitution lemma: substituting a well-typed closed value for a
variable in a well-typed term preserves typing.

## Correspondence Table

| Coq Definition | Lean Definition | Status |
|----------------|-----------------|--------|
| value_subst | value_subst | OK |
| declass_ok_subst | declass_ok_subst | OK |
| substitution_preserves_typing | substitution_preserves_typing | OK |
| substitution_preserves_typing_nil | substitution_preserves_typing_nil | OK |
| subst_value_typing | subst_value_typing | OK |
-/

namespace RIINA

open security_level effect effect_category taint_source sanitizer
     capability_kind capability ty session_type expr

/-- Values are preserved by substitution. -/
theorem value_subst : ∀ (w : expr) (x : ident) (v : expr),
    value w → value (substExpr x v w) := by
  intro w x v hval
  induction hval with
  | VUnit => exact value.VUnit
  | VBool b => exact value.VBool b
  | VInt n => exact value.VInt n
  | VString s => exact value.VString s
  | VLoc l => exact value.VLoc l
  | VLam y T body =>
    show value (if x == y then ELam y T body else ELam y T (substExpr x v body))
    split
    · exact value.VLam y T body
    · exact value.VLam y T _
  | VPair _ _ _ _ ih1 ih2 =>
    exact value.VPair _ _ ih1 ih2
  | VInl _ T _ ih => exact value.VInl _ T ih
  | VInr _ T _ ih => exact value.VInr _ T ih
  | VClassify _ _ ih => exact value.VClassify _ ih
  | VProve _ _ ih => exact value.VProve _ ih

/-- declass_ok is preserved by substitution. -/
theorem declass_ok_subst : ∀ (e1 e2 : expr) (x : ident) (v : expr),
    declass_ok e1 e2 → declass_ok (substExpr x v e1) (substExpr x v e2) := by
  intro e1 e2 x v ⟨w, hval, heq1, heq2⟩
  subst heq1 heq2
  exact ⟨substExpr x v w, value_subst w x v hval, rfl, rfl⟩

/-- The substitution lemma: substituting a well-typed closed value preserves typing.
    The value `v` must be typed in the empty context (closed).
    Proof by induction on expression `e`, with inversion on typing at each step. -/
theorem substitution_preserves_typing
    (Γ : type_env) (St : store_ty) (Δ : security_level)
    (x : ident) (T1 : ty) (v : expr)
    (e : expr) (T : ty) (ε : effect)
    (htype : has_type ((x, T1) :: Γ) St Δ e T ε)
    (hv : has_type [] St Δ v T1 EffPure) :
    has_type Γ St Δ (substExpr x v e) T ε := by
  induction e generalizing Γ St Δ T ε with
  | EUnit => cases htype; exact has_type.T_Unit
  | EBool _ => cases htype; exact has_type.T_Bool
  | EInt _ => cases htype; exact has_type.T_Int
  | EString _ => cases htype; exact has_type.T_String
  | ELoc _ => cases htype with | T_Loc h => exact has_type.T_Loc h

  | EVar y =>
    cases htype with
    | T_Var hlookup =>
      show has_type Γ St Δ (if x == y then v else EVar y) _ _
      by_cases heq : x = y
      · subst heq; simp [beq_iff_eq]
        simp [type_env_lookup] at hlookup; rw [← hlookup]
        exact closed_typing_weakening St Δ v T1 EffPure Γ hv
      · simp [beq_iff_eq, heq]
        simp [type_env_lookup, Ne.symm heq] at hlookup
        exact has_type.T_Var hlookup

  | ELam y T_param body ih =>
    cases htype with
    | T_Lam hbody =>
      show has_type Γ St Δ
        (if x == y then ELam y T_param body else ELam y T_param (substExpr x v body)) _ _
      by_cases heq : x = y
      · subst heq; simp [beq_iff_eq]
        exact has_type.T_Lam (typing_shadow _ _ _ _ _ _ _ _ _ hbody)
      · simp [beq_iff_eq, heq]
        apply has_type.T_Lam
        have hexch := typing_exchange _ _ _ _ _ _ _ _ _ _ hbody (Ne.symm heq)
        exact ih _ _ _ _ _ hexch hv

  | EApp e1 e2 ih1 ih2 =>
    cases htype with
    | T_App h1 h2 =>
      exact has_type.T_App (ih1 _ _ _ _ _ h1 hv) (ih2 _ _ _ _ _ h2 hv)

  | EPair e1 e2 ih1 ih2 =>
    cases htype with
    | T_Pair h1 h2 =>
      exact has_type.T_Pair (ih1 _ _ _ _ _ h1 hv) (ih2 _ _ _ _ _ h2 hv)

  | EFst e ih =>
    cases htype with
    | T_Fst h => exact has_type.T_Fst (ih _ _ _ _ _ h hv)

  | ESnd e ih =>
    cases htype with
    | T_Snd h => exact has_type.T_Snd (ih _ _ _ _ _ h hv)

  | EInl e T2 ih =>
    cases htype with
    | T_Inl h => exact has_type.T_Inl (ih _ _ _ _ _ h hv)

  | EInr e T2 ih =>
    cases htype with
    | T_Inr h => exact has_type.T_Inr (ih _ _ _ _ _ h hv)

  | ECase scrut y1 br1 y2 br2 ih0 ih1 ih2 =>
    cases htype with
    | T_Case hscr hbr1 hbr2 =>
      show has_type Γ St Δ (ECase (substExpr x v scrut) y1
        (if x == y1 then br1 else substExpr x v br1) y2
        (if x == y2 then br2 else substExpr x v br2)) _ _
      apply has_type.T_Case (ih0 _ _ _ _ _ hscr hv)
      · by_cases heq1 : x = y1
        · subst heq1; simp [beq_iff_eq]
          exact typing_shadow _ _ _ _ _ _ _ _ _ hbr1
        · simp [beq_iff_eq, heq1]
          have hexch := typing_exchange _ _ _ _ _ _ _ _ _ _ hbr1 (Ne.symm heq1)
          exact ih1 _ _ _ _ _ hexch hv
      · by_cases heq2 : x = y2
        · subst heq2; simp [beq_iff_eq]
          exact typing_shadow _ _ _ _ _ _ _ _ _ hbr2
        · simp [beq_iff_eq, heq2]
          have hexch := typing_exchange _ _ _ _ _ _ _ _ _ _ hbr2 (Ne.symm heq2)
          exact ih2 _ _ _ _ _ hexch hv

  | EIf e1 e2 e3 ih1 ih2 ih3 =>
    cases htype with
    | T_If h1 h2 h3 =>
      exact has_type.T_If (ih1 _ _ _ _ _ h1 hv) (ih2 _ _ _ _ _ h2 hv) (ih3 _ _ _ _ _ h3 hv)

  | ELet y e1 e2 ih1 ih2 =>
    cases htype with
    | T_Let h1 h2 =>
      show has_type Γ St Δ
        (ELet y (substExpr x v e1) (if x == y then e2 else substExpr x v e2)) _ _
      apply has_type.T_Let (ih1 _ _ _ _ _ h1 hv)
      by_cases heq : x = y
      · subst heq; simp [beq_iff_eq]
        exact typing_shadow _ _ _ _ _ _ _ _ _ h2
      · simp [beq_iff_eq, heq]
        have hexch := typing_exchange _ _ _ _ _ _ _ _ _ _ h2 (Ne.symm heq)
        exact ih2 _ _ _ _ _ hexch hv

  | EPerform eff e ih =>
    cases htype with
    | T_Perform h => exact has_type.T_Perform (ih _ _ _ _ _ h hv)

  | EHandle e y h ih1 ih2 =>
    cases htype with
    | T_Handle h1 h2 =>
      show has_type Γ St Δ
        (EHandle (substExpr x v e) y (if x == y then h else substExpr x v h)) _ _
      apply has_type.T_Handle (ih1 _ _ _ _ _ h1 hv)
      by_cases heq : x = y
      · subst heq; simp [beq_iff_eq]
        exact typing_shadow _ _ _ _ _ _ _ _ _ h2
      · simp [beq_iff_eq, heq]
        have hexch := typing_exchange _ _ _ _ _ _ _ _ _ _ h2 (Ne.symm heq)
        exact ih2 _ _ _ _ _ hexch hv

  | ERef e sl ih =>
    cases htype with
    | T_Ref h => exact has_type.T_Ref (ih _ _ _ _ _ h hv)

  | EDeref e ih =>
    cases htype with
    | T_Deref h => exact has_type.T_Deref (ih _ _ _ _ _ h hv)

  | EAssign e1 e2 ih1 ih2 =>
    cases htype with
    | T_Assign h1 h2 =>
      exact has_type.T_Assign (ih1 _ _ _ _ _ h1 hv) (ih2 _ _ _ _ _ h2 hv)

  | EClassify e ih =>
    cases htype with
    | T_Classify h => exact has_type.T_Classify (ih _ _ _ _ _ h hv)

  | EDeclassify e1 e2 ih1 ih2 =>
    cases htype with
    | T_Declassify h1 h2 hd =>
      exact has_type.T_Declassify
        (ih1 _ _ _ _ _ h1 hv) (ih2 _ _ _ _ _ h2 hv)
        (declass_ok_subst e1 e2 x v hd)

  | EProve e ih =>
    cases htype with
    | T_Prove h => exact has_type.T_Prove (ih _ _ _ _ _ h hv)

  | ERequire eff e ih =>
    cases htype with
    | T_Require h => exact has_type.T_Require (ih _ _ _ _ _ h hv)

  | EGrant eff e ih =>
    cases htype with
    | T_Grant h => exact has_type.T_Grant (ih _ _ _ _ _ h hv)

/-- Substitution preserves typing (nil context variant). -/
theorem substitution_preserves_typing_nil
    (St : store_ty) (Δ : security_level) (x : ident) (T1 : ty)
    (v : expr) (e : expr) (T : ty) (ε : effect)
    (htype : has_type ((x, T1) :: []) St Δ e T ε)
    (hv : has_type [] St Δ v T1 EffPure) :
    has_type [] St Δ (substExpr x v e) T ε :=
  substitution_preserves_typing [] St Δ x T1 v e T ε htype hv

/-- Substitution of a value into a well-typed body, with store extension. -/
theorem subst_value_typing
    (Γ : type_env) (St St' : store_ty) (Δ : security_level)
    (x : ident) (T1 T2 : ty) (ε : effect) (body v : expr)
    (hbody : has_type ((x, T1) :: Γ) St Δ body T2 ε)
    (hv : has_type [] St' Δ v T1 EffPure)
    (hext : store_ty_extends St St') :
    has_type Γ St' Δ (substExpr x v body) T2 ε :=
  substitution_preserves_typing Γ St' Δ x T1 v body T2 ε
    (has_type_store_weaken hbody hext)
    hv

end RIINA

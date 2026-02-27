-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
import RIINA.Foundations.Syntax
import RIINA.Foundations.Semantics
import RIINA.TypeSystem.Typing
import RIINA.Properties.TypingInversion
import RIINA.Properties.StoreSafety

/-!
# RIINA Preservation - Lean 4 Port

Port of 02_FORMAL/coq/type_system/Preservation.v.

## Key Theorems
- `free_in_context` — free variables are in the environment
- `context_invariance` — typing depends only on free variables
- `closed_typing_weakening` — closed terms type in any context
- `substitution_preserves_typing` — substitution lemma
- `preservation` — single-step type preservation
- `preservation_multi_step` — multi-step type preservation

## Note on store
The Lean step relation has NO reference computation rules
(no ST_RefVal, ST_DerefLoc, ST_AssignLoc), only congruence rules
for references. The store never changes during computation,
which simplifies the preservation proof significantly — we always
have St' = St and store_ty_extends St St is trivial by reflexivity.
-/

namespace RIINA

open security_level effect effect_category taint_source sanitizer
     capability_kind capability ty session_type expr

-- ============================================================================
-- Helper: values don't step
-- ============================================================================

/-- Values cannot take a step. -/
theorem value_not_step : ∀ v st ctx cfg',
    value v → ¬ step (v, st, ctx) cfg' := by
  intro v st ctx cfg' hv hs
  induction hv with
  | VUnit => cases hs
  | VBool => cases hs
  | VInt => cases hs
  | VString => cases hs
  | VLoc => cases hs
  | VLam => cases hs
  | VPair _ _ hv1 hv2 ih1 ih2 =>
    cases hs with
    | ST_Pair1 h => exact ih1 h
    | ST_Pair2 _ h => exact ih2 h
  | VInl _ _ hv1 ih1 =>
    cases hs with
    | ST_Inl1 h => exact ih1 h
  | VInr _ _ hv1 ih1 =>
    cases hs with
    | ST_Inr1 h => exact ih1 h
  | VClassify _ hv1 ih1 =>
    cases hs with
    | ST_Classify1 h => exact ih1 h
  | VProve _ hv1 ih1 =>
    cases hs with
    | ST_Prove1 h => exact ih1 h

-- ============================================================================
-- Helper: substitution preserves the value predicate
-- ============================================================================

/-- Substitution preserves the value predicate. -/
theorem subst_preserves_value : ∀ x s v, value v → value (substExpr x s v) := by
  intro x s v hv
  induction hv with
  | VUnit => simp [substExpr]; exact value.VUnit
  | VBool b => simp [substExpr]; exact value.VBool b
  | VInt n => simp [substExpr]; exact value.VInt n
  | VString str => simp [substExpr]; exact value.VString str
  | VLoc l => simp [substExpr]; exact value.VLoc l
  | VLam y T body =>
    simp [substExpr]; split <;> exact value.VLam _ _ _
  | VPair v1 v2 _ _ ih1 ih2 =>
    simp [substExpr]; exact value.VPair _ _ ih1 ih2
  | VInl v' T _ ih => simp [substExpr]; exact value.VInl _ _ ih
  | VInr v' T _ ih => simp [substExpr]; exact value.VInr _ _ ih
  | VClassify v' _ ih => simp [substExpr]; exact value.VClassify _ ih
  | VProve v' _ ih => simp [substExpr]; exact value.VProve _ ih

-- ============================================================================
-- free_in_context
-- ============================================================================

/-- If x is free in e and e is well-typed in Γ, then x is bound in Γ. -/
theorem free_in_context :
    ∀ x e Γ St Δ T ε,
    free_in x e → has_type Γ St Δ e T ε →
    ∃ T', type_env_lookup x Γ = some T' := by
  intro x e Γ St Δ T ε hfree htype
  induction htype with
  | T_Unit => exact absurd hfree id
  | T_Bool => exact absurd hfree id
  | T_Int => exact absurd hfree id
  | T_String => exact absurd hfree id
  | T_Loc _ => exact absurd hfree id
  | T_Var hlook =>
    simp [free_in] at hfree; subst hfree; exact ⟨_, hlook⟩
  | T_Lam _ ih =>
    simp [free_in] at hfree
    obtain ⟨hneq, hfb⟩ := hfree
    obtain ⟨T', hlook⟩ := ih hfb
    simp [type_env_lookup] at hlook
    split at hlook
    · next h => exact absurd h hneq
    · exact ⟨T', hlook⟩
  | T_App _ _ ih1 ih2 =>
    cases hfree with
    | inl h => exact ih1 h
    | inr h => exact ih2 h
  | T_Pair _ _ ih1 ih2 =>
    cases hfree with
    | inl h => exact ih1 h
    | inr h => exact ih2 h
  | T_Fst _ ih => exact ih hfree
  | T_Snd _ ih => exact ih hfree
  | T_Inl _ ih => exact ih hfree
  | T_Inr _ ih => exact ih hfree
  | T_Case _ _ _ ih0 ih1 ih2 =>
    rcases hfree with h0 | ⟨hneq1, h1⟩ | ⟨hneq2, h2⟩
    · exact ih0 h0
    · obtain ⟨T', hlook⟩ := ih1 h1
      simp [type_env_lookup] at hlook
      split at hlook
      · next h => exact absurd h hneq1
      · exact ⟨T', hlook⟩
    · obtain ⟨T', hlook⟩ := ih2 h2
      simp [type_env_lookup] at hlook
      split at hlook
      · next h => exact absurd h hneq2
      · exact ⟨T', hlook⟩
  | T_If _ _ _ ih1 ih2 ih3 =>
    rcases hfree with h1 | h2 | h3
    · exact ih1 h1
    · exact ih2 h2
    · exact ih3 h3
  | T_Let _ _ ih1 ih2 =>
    rcases hfree with h1 | ⟨hneq, h2⟩
    · exact ih1 h1
    · obtain ⟨T', hlook⟩ := ih2 h2
      simp [type_env_lookup] at hlook
      split at hlook
      · next h => exact absurd h hneq
      · exact ⟨T', hlook⟩
  | T_Perform _ ih => exact ih hfree
  | T_Handle _ _ ih1 ih2 =>
    rcases hfree with h1 | ⟨hneq, h2⟩
    · exact ih1 h1
    · obtain ⟨T', hlook⟩ := ih2 h2
      simp [type_env_lookup] at hlook
      split at hlook
      · next h => exact absurd h hneq
      · exact ⟨T', hlook⟩
  | T_Ref _ ih => exact ih hfree
  | T_Deref _ ih => exact ih hfree
  | T_Assign _ _ ih1 ih2 =>
    cases hfree with
    | inl h => exact ih1 h
    | inr h => exact ih2 h
  | T_Classify _ ih => exact ih hfree
  | T_Declassify _ _ _ ih1 ih2 =>
    cases hfree with
    | inl h => exact ih1 h
    | inr h => exact ih2 h
  | T_Prove _ ih => exact ih hfree
  | T_Require _ ih => exact ih hfree
  | T_Grant _ ih => exact ih hfree

-- ============================================================================
-- context_invariance
-- ============================================================================

/-- Typing depends only on free variables. -/
theorem context_invariance :
    ∀ Γ1 Γ2 St Δ e T ε,
    has_type Γ1 St Δ e T ε →
    (∀ x, free_in x e → type_env_lookup x Γ1 = type_env_lookup x Γ2) →
    has_type Γ2 St Δ e T ε := by
  intro Γ1 Γ2 St Δ e T ε htype hagree
  induction htype generalizing Γ2 with
  | T_Unit => exact has_type.T_Unit
  | T_Bool => exact has_type.T_Bool
  | T_Int => exact has_type.T_Int
  | T_String => exact has_type.T_String
  | T_Loc hlook => exact has_type.T_Loc hlook
  | @T_Var _ _ _ x _ hlook =>
    have heq := hagree x rfl
    rw [hlook] at heq
    exact has_type.T_Var heq.symm
  | @T_Lam _ _ _ y T1' _ _ _ _ ih =>
    apply has_type.T_Lam
    apply ih
    intro x hfree
    simp [type_env_lookup]
    by_cases hxy : x = y
    · simp [hxy]
    · simp [hxy]; exact hagree x ⟨hxy, hfree⟩
  | T_App _ _ ih1 ih2 =>
    exact has_type.T_App
      (ih1 fun x hf => hagree x (Or.inl hf))
      (ih2 fun x hf => hagree x (Or.inr hf))
  | T_Pair _ _ ih1 ih2 =>
    exact has_type.T_Pair
      (ih1 fun x hf => hagree x (Or.inl hf))
      (ih2 fun x hf => hagree x (Or.inr hf))
  | T_Fst _ ih => exact has_type.T_Fst (ih hagree)
  | T_Snd _ ih => exact has_type.T_Snd (ih hagree)
  | T_Inl _ ih => exact has_type.T_Inl (ih hagree)
  | T_Inr _ ih => exact has_type.T_Inr (ih hagree)
  | @T_Case _ _ _ _ x1 _ x2 _ _ _ _ _ _ _ _ _ _ ih0 ih1 ih2 =>
    apply has_type.T_Case
    · exact ih0 fun x hf => hagree x (Or.inl hf)
    · apply ih1; intro x hfree; simp [type_env_lookup]
      by_cases hxx1 : x = x1
      · simp [hxx1]
      · simp [hxx1]; exact hagree x (Or.inr (Or.inl ⟨hxx1, hfree⟩))
    · apply ih2; intro x hfree; simp [type_env_lookup]
      by_cases hxx2 : x = x2
      · simp [hxx2]
      · simp [hxx2]; exact hagree x (Or.inr (Or.inr ⟨hxx2, hfree⟩))
  | T_If _ _ _ ih1 ih2 ih3 =>
    exact has_type.T_If
      (ih1 fun x hf => hagree x (Or.inl hf))
      (ih2 fun x hf => hagree x (Or.inr (Or.inl hf)))
      (ih3 fun x hf => hagree x (Or.inr (Or.inr hf)))
  | @T_Let _ _ _ y _ _ _ _ _ _ _ ih1 ih2 =>
    apply has_type.T_Let
    · exact ih1 fun x hf => hagree x (Or.inl hf)
    · apply ih2; intro x hfree; simp [type_env_lookup]
      by_cases hxy : x = y
      · simp [hxy]
      · simp [hxy]; exact hagree x (Or.inr ⟨hxy, hfree⟩)
  | T_Perform _ ih => exact has_type.T_Perform (ih hagree)
  | @T_Handle _ _ _ _ y _ _ _ _ _ _ ih1 ih2 =>
    apply has_type.T_Handle
    · exact ih1 fun x hf => hagree x (Or.inl hf)
    · apply ih2; intro x hfree; simp [type_env_lookup]
      by_cases hxy : x = y
      · simp [hxy]
      · simp [hxy]; exact hagree x (Or.inr ⟨hxy, hfree⟩)
  | T_Ref _ ih => exact has_type.T_Ref (ih hagree)
  | T_Deref _ ih => exact has_type.T_Deref (ih hagree)
  | T_Assign _ _ ih1 ih2 =>
    exact has_type.T_Assign
      (ih1 fun x hf => hagree x (Or.inl hf))
      (ih2 fun x hf => hagree x (Or.inr hf))
  | T_Classify _ ih => exact has_type.T_Classify (ih hagree)
  | T_Declassify _ _ hd ih1 ih2 =>
    exact has_type.T_Declassify
      (ih1 fun x hf => hagree x (Or.inl hf))
      (ih2 fun x hf => hagree x (Or.inr hf))
      hd
  | T_Prove _ ih => exact has_type.T_Prove (ih hagree)
  | T_Require _ ih => exact has_type.T_Require (ih hagree)
  | T_Grant _ ih => exact has_type.T_Grant (ih hagree)

-- ============================================================================
-- closed_typing_weakening
-- ============================================================================

/-- A term typed in the empty context has no free variables. -/
theorem typing_nil_closed :
    ∀ St Δ e T ε, has_type nil St Δ e T ε → closed_expr e := by
  intro St Δ e T ε htype x hfree
  have ⟨T', hlook⟩ := free_in_context x e nil St Δ T ε hfree htype
  simp [type_env_lookup] at hlook

/-- A closed term (typed in empty context) can be typed in any context. -/
theorem closed_typing_weakening :
    ∀ St Δ v T ε Γ,
    has_type nil St Δ v T ε → has_type Γ St Δ v T ε := by
  intro St Δ v T ε Γ htype
  have hclosed := typing_nil_closed St Δ v T ε htype
  exact context_invariance nil Γ St Δ v T ε htype
    fun x hfree => absurd hfree (hclosed x)

-- ============================================================================
-- substitution_preserves_typing
-- ============================================================================

/-- Helper: swap two different bindings in a context. -/
private theorem context_swap {Γ : type_env} {St Δ} {y z : ident} {Ty Tz : ty}
    {e : expr} {T : ty} {ε : effect}
    (hneq : z ≠ y)
    (htype : has_type ((y, Ty) :: (z, Tz) :: Γ) St Δ e T ε) :
    has_type ((z, Tz) :: (y, Ty) :: Γ) St Δ e T ε := by
  apply context_invariance ((y, Ty) :: (z, Tz) :: Γ)
  · exact htype
  · intro x _
    simp [type_env_lookup]
    by_cases hxy : x = y <;> by_cases hxz : x = z
    · subst hxy; subst hxz; exact absurd rfl hneq
    · simp [hxy, hxz]
    · simp [hxy, hxz]
    · simp [hxy, hxz]

/-- Helper: shadowed binding can be removed. -/
private theorem context_shadow {Γ : type_env} {St Δ} {y : ident} {T1 T2 : ty}
    {e : expr} {T : ty} {ε : effect}
    (htype : has_type ((y, T1) :: (y, T2) :: Γ) St Δ e T ε) :
    has_type ((y, T1) :: Γ) St Δ e T ε := by
  apply context_invariance ((y, T1) :: (y, T2) :: Γ)
  · exact htype
  · intro x _
    simp [type_env_lookup]
    by_cases hxy : x = y
    · simp [hxy]
    · simp [hxy]

/-- The substitution lemma. -/
theorem substitution_preserves_typing :
    ∀ Γ St Δ z v e T1 T2 ε2,
    value v →
    has_type nil St Δ v T1 EffectPure →
    has_type ((z, T1) :: Γ) St Δ e T2 ε2 →
    has_type Γ St Δ (substExpr z v e) T2 ε2 := by
  intro Γ St Δ z v e T1 T2 ε2 hval hv_type he_type
  -- Induction on the expression e
  -- We generalize T2 and ε2 so the IH works for subterms
  revert T2 ε2 he_type
  induction e generalizing Γ with
  | EUnit => intro T2 ε2 he_type; simp [substExpr]; cases he_type; exact has_type.T_Unit
  | EBool b => intro T2 ε2 he_type; simp [substExpr]; cases he_type; exact has_type.T_Bool
  | EInt n => intro T2 ε2 he_type; simp [substExpr]; cases he_type; exact has_type.T_Int
  | EString s => intro T2 ε2 he_type; simp [substExpr]; cases he_type; exact has_type.T_String
  | ELoc l => intro T2 ε2 he_type; simp [substExpr]; cases he_type with | T_Loc h => exact has_type.T_Loc h
  | EVar y =>
    intro T2 ε2 he_type; simp [substExpr]
    by_cases h : z == y
    · simp [h]
      have heq : z = y := by rwa [beq_iff_eq] at h
      subst heq
      cases he_type with
      | T_Var hlook =>
        simp [type_env_lookup] at hlook
        subst hlook
        exact closed_typing_weakening St Δ v T1 EffectPure Γ hv_type
    · simp [h]
      have hneq : z ≠ y := by rwa [beq_iff_eq] at h
      cases he_type with
      | T_Var hlook =>
        simp [type_env_lookup, hneq] at hlook
        exact has_type.T_Var hlook
  | ELam y Ty body ih_body =>
    intro T2 ε2 he_type; simp [substExpr]
    by_cases h : z == y
    · simp [h]
      have heq : z = y := by rwa [beq_iff_eq] at h
      subst heq
      -- Binder shadows z, so [z:=v](Lam z Ty body) = Lam z Ty body
      -- We need has_type Γ St Δ (ELam z Ty body) T2 ε2
      cases he_type with
      | T_Lam hbody =>
        apply has_type.T_Lam
        exact context_shadow hbody
    · simp [h]
      have hneq : z ≠ y := by rwa [beq_iff_eq] at h
      cases he_type with
      | T_Lam hbody =>
        apply has_type.T_Lam
        -- hbody : has_type ((y, Ty) :: (z, T1) :: Γ) St Δ body T2' ε_body
        -- Need: has_type ((y, Ty) :: Γ) St Δ (substExpr z v body) T2' ε_body
        -- By context_swap, get has_type ((z, T1) :: (y, Ty) :: Γ) St Δ body ...
        -- Then apply ih_body with Γ' = (y, Ty) :: Γ
        exact ih_body ((y, Ty) :: Γ) _ _ (context_swap hneq hbody)
  | EApp e1 e2 ih1 ih2 =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_App hfn harg =>
      exact has_type.T_App (ih1 Γ _ _ hfn) (ih2 Γ _ _ harg)
  | EPair e1 e2 ih1 ih2 =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_Pair h1 h2 =>
      exact has_type.T_Pair (ih1 Γ _ _ h1) (ih2 Γ _ _ h2)
  | EFst e ih =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_Fst h => exact has_type.T_Fst (ih Γ _ _ h)
  | ESnd e ih =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_Snd h => exact has_type.T_Snd (ih Γ _ _ h)
  | EInl e Tann ih =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_Inl h => exact has_type.T_Inl (ih Γ _ _ h)
  | EInr e Tann ih =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_Inr h => exact has_type.T_Inr (ih Γ _ _ h)
  | ECase e0 x1 e1 x2 e2 ih0 ih1 ih2 =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_Case hscr hbr1 hbr2 =>
      apply has_type.T_Case (ih0 Γ _ _ hscr)
      · by_cases h1 : z == x1
        · simp [h1]
          have heq : z = x1 := by rwa [beq_iff_eq] at h1
          subst heq; exact context_shadow hbr1
        · simp [h1]
          have hneq : z ≠ x1 := by rwa [beq_iff_eq] at h1
          exact ih1 ((x1, _) :: Γ) _ _ (context_swap hneq hbr1)
      · by_cases h2 : z == x2
        · simp [h2]
          have heq : z = x2 := by rwa [beq_iff_eq] at h2
          subst heq; exact context_shadow hbr2
        · simp [h2]
          have hneq : z ≠ x2 := by rwa [beq_iff_eq] at h2
          exact ih2 ((x2, _) :: Γ) _ _ (context_swap hneq hbr2)
  | EIf e1 e2 e3 ih1 ih2 ih3 =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_If h1 h2 h3 =>
      exact has_type.T_If (ih1 Γ _ _ h1) (ih2 Γ _ _ h2) (ih3 Γ _ _ h3)
  | ELet y e1 e2 ih1 ih2 =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_Let h1 h2 =>
      apply has_type.T_Let (ih1 Γ _ _ h1)
      by_cases h : z == y
      · simp [h]
        have heq : z = y := by rwa [beq_iff_eq] at h
        subst heq; exact context_shadow h2
      · simp [h]
        have hneq : z ≠ y := by rwa [beq_iff_eq] at h
        exact ih2 ((y, _) :: Γ) _ _ (context_swap hneq h2)
  | EPerform eff e ih =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_Perform h => exact has_type.T_Perform (ih Γ _ _ h)
  | EHandle e y h ih_e ih_h =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_Handle h1 h2 =>
      apply has_type.T_Handle (ih_e Γ _ _ h1)
      by_cases hzy : z == y
      · simp [hzy]
        have heq : z = y := by rwa [beq_iff_eq] at hzy
        subst heq; exact context_shadow h2
      · simp [hzy]
        have hneq : z ≠ y := by rwa [beq_iff_eq] at hzy
        exact ih_h ((y, _) :: Γ) _ _ (context_swap hneq h2)
  | ERef e sl ih =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_Ref h => exact has_type.T_Ref (ih Γ _ _ h)
  | EDeref e ih =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_Deref h => exact has_type.T_Deref (ih Γ _ _ h)
  | EAssign e1 e2 ih1 ih2 =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_Assign h1 h2 =>
      exact has_type.T_Assign (ih1 Γ _ _ h1) (ih2 Γ _ _ h2)
  | EClassify e ih =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_Classify h => exact has_type.T_Classify (ih Γ _ _ h)
  | EDeclassify e1 e2 ih1 ih2 =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_Declassify h1 h2 hd =>
      -- declass_ok e1 e2 means ∃ w, value w ∧ e1 = EClassify w ∧ e2 = EProve (EClassify w)
      obtain ⟨w, hw_val, he1_eq, he2_eq⟩ := hd
      -- e1 = EClassify w, e2 = EProve (EClassify w)
      -- After substitution: substExpr z v (EClassify w) = EClassify (substExpr z v w)
      -- substExpr z v (EProve (EClassify w)) = EProve (EClassify (substExpr z v w))
      have hd' : declass_ok (substExpr z v e1) (substExpr z v e2) := by
        subst he1_eq; subst he2_eq
        simp [substExpr]
        exact ⟨substExpr z v w, subst_preserves_value z v w hw_val, rfl, rfl⟩
      exact has_type.T_Declassify (ih1 Γ _ _ h1) (ih2 Γ _ _ h2) hd'
  | EProve e ih =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_Prove h => exact has_type.T_Prove (ih Γ _ _ h)
  | ERequire eff e ih =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_Require h => exact has_type.T_Require (ih Γ _ _ h)
  | EGrant eff e ih =>
    intro T2 ε2 he_type; simp [substExpr]
    cases he_type with
    | T_Grant h => exact has_type.T_Grant (ih Γ _ _ h)

-- ============================================================================
-- preservation (single step)
-- ============================================================================

/-- Single-step preservation: if e has type T and steps to e', then e' has type T
    (possibly with a different effect and extended store typing). -/
theorem preservation :
    ∀ e e' T ε st st' ctx ctx' St,
    has_type nil St Public e T ε →
    store_wf St st →
    step (e, st, ctx) (e', st', ctx') →
    ∃ St' ε', store_ty_extends St St' ∧ store_wf St' st' ∧
              has_type nil St' Public e' T ε' := by
  intro e e' T ε st st' ctx ctx' St htype hwf hstep
  induction hstep generalizing T ε with
  | ST_AppAbs x T_arg body v_arg _ hval =>
    cases htype with
    | T_App hfn harg =>
      cases hfn with
      | T_Lam hbody =>
        have harg_pure := value_pure_typing nil St Public v_arg _ _ hval harg
        have hsub := substitution_preserves_typing nil St Public x v_arg body _ _ _ hval harg_pure hbody
        exact ⟨St, _, store_ty_extends_reflexive St, hwf, hsub⟩
  | ST_App1 e1 e1' e2 _ _ _ _ hstep ih =>
    cases htype with
    | T_App hfn harg =>
      obtain ⟨St', ε', hext, hwf', hfn'⟩ := ih hfn
      exact ⟨St', _, hext, hwf',
        has_type.T_App hfn' (has_type_store_weaken harg hext)⟩
  | ST_App2 v1 e2 e2' _ _ _ _ hval hstep ih =>
    cases htype with
    | T_App hfn harg =>
      obtain ⟨St', ε', hext, hwf', harg'⟩ := ih harg
      exact ⟨St', _, hext, hwf',
        has_type.T_App (has_type_store_weaken hfn hext) harg'⟩
  | ST_Fst v1 v2 _ _ hval1 hval2 =>
    cases htype with
    | T_Fst hpair =>
      cases hpair with
      | T_Pair h1 h2 =>
        have h1_pure := value_pure_typing nil St Public v1 _ _ hval1 h1
        exact ⟨St, _, store_ty_extends_reflexive St, hwf, h1_pure⟩
  | ST_Snd v1 v2 _ _ hval1 hval2 =>
    cases htype with
    | T_Snd hpair =>
      cases hpair with
      | T_Pair h1 h2 =>
        have h2_pure := value_pure_typing nil St Public v2 _ _ hval2 h2
        exact ⟨St, _, store_ty_extends_reflexive St, hwf, h2_pure⟩
  | ST_IfTrue e1 e2 _ _ =>
    cases htype with
    | T_If _ hthen _ => exact ⟨St, _, store_ty_extends_reflexive St, hwf, hthen⟩
  | ST_IfFalse e1 e2 _ _ =>
    cases htype with
    | T_If _ _ helse => exact ⟨St, _, store_ty_extends_reflexive St, hwf, helse⟩
  | ST_LetVal x v e2 _ _ hval =>
    cases htype with
    | T_Let h1 h2 =>
      have h1_pure := value_pure_typing nil St Public v _ _ hval h1
      have hsub := substitution_preserves_typing nil St Public x v e2 _ _ _ hval h1_pure h2
      exact ⟨St, _, store_ty_extends_reflexive St, hwf, hsub⟩
  | ST_CaseInl v T_ann x1 e1 x2 e2 _ _ hval =>
    cases htype with
    | T_Case hsum hbr1 hbr2 =>
      cases hsum with
      | T_Inl hinl =>
        have hinl_pure := value_pure_typing nil St Public v _ _ hval hinl
        have hsub := substitution_preserves_typing nil St Public x1 v e1 _ _ _ hval hinl_pure hbr1
        exact ⟨St, _, store_ty_extends_reflexive St, hwf, hsub⟩
  | ST_CaseInr v T_ann x1 e1 x2 e2 _ _ hval =>
    cases htype with
    | T_Case hsum hbr1 hbr2 =>
      cases hsum with
      | T_Inr hinr =>
        have hinr_pure := value_pure_typing nil St Public v _ _ hval hinr
        have hsub := substitution_preserves_typing nil St Public x2 v e2 _ _ _ hval hinr_pure hbr2
        exact ⟨St, _, store_ty_extends_reflexive St, hwf, hsub⟩
  | ST_Pair1 e1 e1' e2 _ _ _ _ hstep ih =>
    cases htype with
    | T_Pair h1 h2 =>
      obtain ⟨St', ε', hext, hwf', h1'⟩ := ih h1
      exact ⟨St', _, hext, hwf', has_type.T_Pair h1' (has_type_store_weaken h2 hext)⟩
  | ST_Pair2 v1 e2 e2' _ _ _ _ hval hstep ih =>
    cases htype with
    | T_Pair h1 h2 =>
      obtain ⟨St', ε', hext, hwf', h2'⟩ := ih h2
      exact ⟨St', _, hext, hwf', has_type.T_Pair (has_type_store_weaken h1 hext) h2'⟩
  | ST_Fst1 e e' _ _ _ _ hstep ih =>
    cases htype with
    | T_Fst h =>
      obtain ⟨St', ε', hext, hwf', h'⟩ := ih h
      exact ⟨St', _, hext, hwf', has_type.T_Fst h'⟩
  | ST_Snd1 e e' _ _ _ _ hstep ih =>
    cases htype with
    | T_Snd h =>
      obtain ⟨St', ε', hext, hwf', h'⟩ := ih h
      exact ⟨St', _, hext, hwf', has_type.T_Snd h'⟩
  | ST_Inl1 e e' T_ann _ _ _ _ hstep ih =>
    cases htype with
    | T_Inl h =>
      obtain ⟨St', ε', hext, hwf', h'⟩ := ih h
      exact ⟨St', _, hext, hwf', has_type.T_Inl h'⟩
  | ST_Inr1 e e' T_ann _ _ _ _ hstep ih =>
    cases htype with
    | T_Inr h =>
      obtain ⟨St', ε', hext, hwf', h'⟩ := ih h
      exact ⟨St', _, hext, hwf', has_type.T_Inr h'⟩
  | ST_Case1 e e' x1 e1 x2 e2 _ _ _ _ hstep ih =>
    cases htype with
    | T_Case hscr hbr1 hbr2 =>
      obtain ⟨St', ε', hext, hwf', hscr'⟩ := ih hscr
      exact ⟨St', _, hext, hwf',
        has_type.T_Case hscr' (has_type_store_weaken hbr1 hext) (has_type_store_weaken hbr2 hext)⟩
  | ST_If1 e1 e1' e2 e3 _ _ _ _ hstep ih =>
    cases htype with
    | T_If hcond hthen helse =>
      obtain ⟨St', ε', hext, hwf', hcond'⟩ := ih hcond
      exact ⟨St', _, hext, hwf',
        has_type.T_If hcond' (has_type_store_weaken hthen hext) (has_type_store_weaken helse hext)⟩
  | ST_Let1 x e1 e1' e2 _ _ _ _ hstep ih =>
    cases htype with
    | T_Let h1 h2 =>
      obtain ⟨St', ε', hext, hwf', h1'⟩ := ih h1
      exact ⟨St', _, hext, hwf', has_type.T_Let h1' (has_type_store_weaken h2 hext)⟩
  | ST_Classify1 e e' _ _ _ _ hstep ih =>
    cases htype with
    | T_Classify h =>
      obtain ⟨St', ε', hext, hwf', h'⟩ := ih h
      exact ⟨St', _, hext, hwf', has_type.T_Classify h'⟩
  | ST_Declassify1 e1 e1' e2 _ _ _ _ hstep =>
    -- e1 steps, but declass_ok e1 e2 says e1 = EClassify w (a value), contradiction
    cases htype with
    | T_Declassify h1 h2 hd =>
      obtain ⟨w, hw_val, he1_eq, _⟩ := hd
      subst he1_eq
      exact absurd hstep (value_not_step (EClassify w) _ _ _ (value.VClassify w hw_val))
  | ST_Declassify2 v1 e2 e2' _ _ _ _ hval hstep =>
    -- e2 steps, but declass_ok e1 e2 says e2 = EProve (EClassify w) (a value), contradiction
    cases htype with
    | T_Declassify h1 h2 hd =>
      obtain ⟨w, hw_val, _, he2_eq⟩ := hd
      subst he2_eq
      exact absurd hstep (value_not_step (EProve (EClassify w)) _ _ _
        (value.VProve _ (value.VClassify w hw_val)))
  | ST_DeclassifyValue v p _ _ hval hdeclass =>
    cases htype with
    | T_Declassify h1 h2 hd =>
      cases h1 with
      | T_Classify hinner =>
        have hinner_pure := value_pure_typing nil St Public v _ _ hval hinner
        exact ⟨St, _, store_ty_extends_reflexive St, hwf, hinner_pure⟩
  | ST_Prove1 e e' _ _ _ _ hstep ih =>
    cases htype with
    | T_Prove h =>
      obtain ⟨St', ε', hext, hwf', h'⟩ := ih h
      exact ⟨St', _, hext, hwf', has_type.T_Prove h'⟩
  | ST_Require1 eff e e' _ _ _ _ hstep ih =>
    cases htype with
    | T_Require h =>
      obtain ⟨St', ε', hext, hwf', h'⟩ := ih h
      exact ⟨St', _, hext, hwf', has_type.T_Require h'⟩
  | ST_Grant1 eff e e' _ _ _ _ hstep ih =>
    cases htype with
    | T_Grant h =>
      obtain ⟨St', ε', hext, hwf', h'⟩ := ih h
      exact ⟨St', _, hext, hwf', has_type.T_Grant h'⟩
  | ST_Ref1 e e' sl _ _ _ _ hstep ih =>
    cases htype with
    | T_Ref h =>
      obtain ⟨St', ε', hext, hwf', h'⟩ := ih h
      exact ⟨St', _, hext, hwf', has_type.T_Ref h'⟩
  | ST_Deref1 e e' _ _ _ _ hstep ih =>
    cases htype with
    | T_Deref h =>
      obtain ⟨St', ε', hext, hwf', h'⟩ := ih h
      exact ⟨St', _, hext, hwf', has_type.T_Deref h'⟩
  | ST_Assign1 e1 e1' e2 _ _ _ _ hstep ih =>
    cases htype with
    | T_Assign h1 h2 =>
      obtain ⟨St', ε', hext, hwf', h1'⟩ := ih h1
      exact ⟨St', _, hext, hwf',
        has_type.T_Assign h1' (has_type_store_weaken h2 hext)⟩
  | ST_Assign2 v1 e2 e2' _ _ _ _ hval hstep ih =>
    cases htype with
    | T_Assign h1 h2 =>
      obtain ⟨St', ε', hext, hwf', h2'⟩ := ih h2
      exact ⟨St', _, hext, hwf',
        has_type.T_Assign (has_type_store_weaken h1 hext) h2'⟩
  | ST_Handle1 e e' x h _ _ _ _ hstep ih =>
    cases htype with
    | T_Handle h1 h2 =>
      obtain ⟨St', ε', hext, hwf', h1'⟩ := ih h1
      exact ⟨St', _, hext, hwf',
        has_type.T_Handle h1' (has_type_store_weaken h2 hext)⟩
  | ST_Perform1 eff e e' _ _ _ _ hstep ih =>
    cases htype with
    | T_Perform h =>
      obtain ⟨St', ε', hext, hwf', h'⟩ := ih h
      exact ⟨St', _, hext, hwf', has_type.T_Perform h'⟩

-- ============================================================================
-- multi-step preservation
-- ============================================================================

/-- Multi-step preservation: typing is preserved across any number of steps. -/
theorem preservation_multi_step :
    ∀ e e' T ε st st' ctx ctx' St,
    has_type nil St Public e T ε →
    store_wf St st →
    multi_step (e, st, ctx) (e', st', ctx') →
    ∃ St' ε', store_ty_extends St St' ∧ store_wf St' st' ∧
              has_type nil St' Public e' T ε' := by
  intro e e' T ε st st' ctx ctx' St htype hwf hmulti
  induction hmulti with
  | @MS_Refl cfg =>
    exact ⟨St, ε, store_ty_extends_reflexive St, hwf, htype⟩
  | @MS_Step cfg1 cfg2 cfg3 hstep _ ih =>
    obtain ⟨e_mid, st_mid, ctx_mid⟩ := cfg2
    obtain ⟨St_mid, ε_mid, hext1, hwf_mid, htype_mid⟩ :=
      preservation e e_mid T ε st st_mid ctx ctx_mid St htype hwf hstep
    obtain ⟨St', ε', hext2, hwf', htype'⟩ := ih htype_mid hwf_mid
    exact ⟨St', ε', store_extend_compose St St_mid St' hext1 hext2, hwf', htype'⟩

end RIINA

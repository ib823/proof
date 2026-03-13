-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.
import RIINA.Foundations.Syntax
import RIINA.Foundations.Semantics
import RIINA.TypeSystem.Typing

/-!
# RIINA ClosedValueLemmas - Lean 4 Port

Port of 02_FORMAL/coq/properties/ClosedValueLemmas.v.

## Proved (31 theorems)
- closed_expr_cv (definition)
- closed_pair_cv, closed_inl_cv, closed_inr_cv, closed_app_cv
- closed_unit_cv, closed_bool_cv, closed_int_cv, closed_string_cv, closed_loc_cv
- closed_lam_body_cv, closed_lam_cv
- closed_if_cv, closed_let_cv, closed_ref_cv, closed_deref_cv, closed_assign_cv
- closed_classify_cv, closed_prove_cv, closed_fst_cv, closed_snd_cv
- closed_grant_cv, closed_require_cv, closed_perform_cv
- closed_handle_cv, closed_declassify_cv, closed_case_cv
- closed_pair_value_components, closed_inl_value_inner, closed_inr_value_inner
- closed_classify_value_inner, closed_prove_value_inner

## Commented out (require free_in_context / Preservation infrastructure)
- value_typed_closed, value_closed_simple
- nil_ctx_is_closed, closed_weaken_ctx, closed_store_extension
- nil_ctx_pair_closed, nil_ctx_inl_closed, nil_ctx_inr_closed
-/

namespace RIINA

open expr

/-- closed_expr_cv: An expression is closed if no variable is free in it. -/
def closed_expr_cv (e : expr) : Prop :=
  ∀ x, ¬ free_in x e

-- === Simple base-type closedness (free_in returns False) ===

theorem closed_unit_cv : closed_expr_cv EUnit := by
  intro x h; exact h

theorem closed_bool_cv : ∀ b, closed_expr_cv (EBool b) := by
  intro b x h; exact h

theorem closed_int_cv : ∀ n, closed_expr_cv (EInt n) := by
  intro n x h; exact h

theorem closed_string_cv : ∀ s, closed_expr_cv (EString s) := by
  intro s x h; exact h

theorem closed_loc_cv : ∀ l, closed_expr_cv (ELoc l) := by
  intro l x h; exact h

-- === Iff decomposition lemmas ===
-- Pattern: closed_expr_cv (Constructor e ...) ↔ closed subparts

theorem closed_pair_cv : ∀ e1 e2, closed_expr_cv (EPair e1 e2) ↔ closed_expr_cv e1 ∧ closed_expr_cv e2 := by
  intro e1 e2
  constructor
  · intro h
    exact ⟨fun x hf => h x (Or.inl hf), fun x hf => h x (Or.inr hf)⟩
  · intro ⟨h1, h2⟩ x hf
    cases hf with
    | inl hf1 => exact h1 x hf1
    | inr hf2 => exact h2 x hf2

theorem closed_inl_cv : ∀ e T, closed_expr_cv (EInl e T) ↔ closed_expr_cv e := by
  intro e T; constructor
  · intro h x hf; exact h x hf
  · intro h x hf; exact h x hf

theorem closed_inr_cv : ∀ e T, closed_expr_cv (EInr e T) ↔ closed_expr_cv e := by
  intro e T; constructor
  · intro h x hf; exact h x hf
  · intro h x hf; exact h x hf

theorem closed_app_cv : ∀ e1 e2, closed_expr_cv (EApp e1 e2) ↔ closed_expr_cv e1 ∧ closed_expr_cv e2 := by
  intro e1 e2
  constructor
  · intro h
    exact ⟨fun x hf => h x (Or.inl hf), fun x hf => h x (Or.inr hf)⟩
  · intro ⟨h1, h2⟩ x hf
    cases hf with
    | inl hf1 => exact h1 x hf1
    | inr hf2 => exact h2 x hf2

theorem closed_fst_cv : ∀ e, closed_expr_cv (EFst e) ↔ closed_expr_cv e := by
  intro e; constructor
  · intro h x hf; exact h x hf
  · intro h x hf; exact h x hf

theorem closed_snd_cv : ∀ e, closed_expr_cv (ESnd e) ↔ closed_expr_cv e := by
  intro e; constructor
  · intro h x hf; exact h x hf
  · intro h x hf; exact h x hf

theorem closed_ref_cv : ∀ e sl, closed_expr_cv (ERef e sl) ↔ closed_expr_cv e := by
  intro e sl; constructor
  · intro h x hf; exact h x hf
  · intro h x hf; exact h x hf

theorem closed_deref_cv : ∀ e, closed_expr_cv (EDeref e) ↔ closed_expr_cv e := by
  intro e; constructor
  · intro h x hf; exact h x hf
  · intro h x hf; exact h x hf

theorem closed_assign_cv : ∀ e1 e2, closed_expr_cv (EAssign e1 e2) ↔ closed_expr_cv e1 ∧ closed_expr_cv e2 := by
  intro e1 e2
  constructor
  · intro h
    exact ⟨fun x hf => h x (Or.inl hf), fun x hf => h x (Or.inr hf)⟩
  · intro ⟨h1, h2⟩ x hf
    cases hf with
    | inl hf1 => exact h1 x hf1
    | inr hf2 => exact h2 x hf2

theorem closed_classify_cv : ∀ e, closed_expr_cv (EClassify e) ↔ closed_expr_cv e := by
  intro e; constructor
  · intro h x hf; exact h x hf
  · intro h x hf; exact h x hf

theorem closed_prove_cv : ∀ e, closed_expr_cv (EProve e) ↔ closed_expr_cv e := by
  intro e; constructor
  · intro h x hf; exact h x hf
  · intro h x hf; exact h x hf

theorem closed_declassify_cv : ∀ e1 e2, closed_expr_cv (EDeclassify e1 e2) ↔ closed_expr_cv e1 ∧ closed_expr_cv e2 := by
  intro e1 e2
  constructor
  · intro h
    exact ⟨fun x hf => h x (Or.inl hf), fun x hf => h x (Or.inr hf)⟩
  · intro ⟨h1, h2⟩ x hf
    cases hf with
    | inl hf1 => exact h1 x hf1
    | inr hf2 => exact h2 x hf2

theorem closed_grant_cv : ∀ eff e, closed_expr_cv (EGrant eff e) ↔ closed_expr_cv e := by
  intro eff e; constructor
  · intro h x hf; exact h x hf
  · intro h x hf; exact h x hf

theorem closed_require_cv : ∀ eff e, closed_expr_cv (ERequire eff e) ↔ closed_expr_cv e := by
  intro eff e; constructor
  · intro h x hf; exact h x hf
  · intro h x hf; exact h x hf

theorem closed_perform_cv : ∀ eff e, closed_expr_cv (EPerform eff e) ↔ closed_expr_cv e := by
  intro eff e; constructor
  · intro h x hf; exact h x hf
  · intro h x hf; exact h x hf

theorem closed_if_cv : ∀ e1 e2 e3, closed_expr_cv (EIf e1 e2 e3) ↔ closed_expr_cv e1 ∧ closed_expr_cv e2 ∧ closed_expr_cv e3 := by
  intro e1 e2 e3
  constructor
  · intro h
    exact ⟨fun x hf => h x (Or.inl hf),
           fun x hf => h x (Or.inr (Or.inl hf)),
           fun x hf => h x (Or.inr (Or.inr hf))⟩
  · intro ⟨h1, h2, h3⟩ x hf
    cases hf with
    | inl hf1 => exact h1 x hf1
    | inr hf =>
      cases hf with
      | inl hf2 => exact h2 x hf2
      | inr hf3 => exact h3 x hf3

-- Lambda: binder blocks the body variable
theorem closed_lam_cv : ∀ x T body, closed_expr_cv (ELam x T body) ↔ (∀ y, y ≠ x → ¬ free_in y body) := by
  intro x T body
  constructor
  · intro h y hne hfree
    exact h y ⟨hne, hfree⟩
  · intro h y ⟨hne, hfree⟩
    exact h y hne hfree

theorem closed_lam_body_cv : ∀ x T body y, closed_expr_cv (ELam x T body) → free_in y body → y = x := by
  intro x T body y hclosed hfree
  by_cases heq : y = x
  · exact heq
  · exfalso; exact hclosed y (And.intro heq hfree)

-- Let: binder blocks the body variable
theorem closed_let_cv : ∀ y e1 e2, closed_expr_cv (ELet y e1 e2) ↔ closed_expr_cv e1 ∧ (∀ x, x ≠ y → free_in x e2 → False) := by
  intro y e1 e2
  constructor
  · intro h
    constructor
    · intro x hfree; exact h x (Or.inl hfree)
    · intro x hne hfree; exact h x (Or.inr ⟨hne, hfree⟩)
  · intro ⟨h1, h2⟩ x hfree
    cases hfree with
    | inl hf1 => exact h1 x hf1
    | inr hf2 => exact h2 x hf2.1 hf2.2

-- Handle: binder blocks the handler variable
theorem closed_handle_cv : ∀ e y h, closed_expr_cv (EHandle e y h) ↔ closed_expr_cv e ∧ (∀ x, x ≠ y → ¬ free_in x h) := by
  intro e y h_expr
  constructor
  · intro hcl
    constructor
    · intro x hfree; exact hcl x (Or.inl hfree)
    · intro x hne hfree; exact hcl x (Or.inr ⟨hne, hfree⟩)
  · intro ⟨h1, h2⟩ x hfree
    cases hfree with
    | inl hf => exact h1 x hf
    | inr hf => exact h2 x hf.1 hf.2

-- Case: two binders
theorem closed_case_cv : ∀ e y1 e1 y2 e2, closed_expr_cv (ECase e y1 e1 y2 e2) ↔ closed_expr_cv e ∧ (∀ x, x ≠ y1 → ¬ free_in x e1) ∧ (∀ x, x ≠ y2 → ¬ free_in x e2) := by
  intro e y1 e1 y2 e2
  constructor
  · intro hcl
    exact ⟨fun x hf => hcl x (Or.inl hf),
           fun x hne hf => hcl x (Or.inr (Or.inl ⟨hne, hf⟩)),
           fun x hne hf => hcl x (Or.inr (Or.inr ⟨hne, hf⟩))⟩
  · intro ⟨h0, h1, h2⟩ x hfree
    cases hfree with
    | inl hf0 => exact h0 x hf0
    | inr hf =>
      cases hf with
      | inl hf1 => exact h1 x hf1.1 hf1.2
      | inr hf2 => exact h2 x hf2.1 hf2.2

-- === Extraction from closedness ===

theorem closed_pair_value_components : ∀ a b, value (EPair a b) → closed_expr_cv (EPair a b) → closed_expr_cv a ∧ closed_expr_cv b := by
  intro a b _ hcl
  exact (closed_pair_cv a b).mp hcl

theorem closed_inl_value_inner : ∀ a T, value (EInl a T) → closed_expr_cv (EInl a T) → closed_expr_cv a := by
  intro a T _ hcl
  exact (closed_inl_cv a T).mp hcl

theorem closed_inr_value_inner : ∀ b T, value (EInr b T) → closed_expr_cv (EInr b T) → closed_expr_cv b := by
  intro b T _ hcl
  exact (closed_inr_cv b T).mp hcl

theorem closed_classify_value_inner : ∀ v, closed_expr_cv (EClassify v) → closed_expr_cv v := by
  intro v hcl
  exact (closed_classify_cv v).mp hcl

theorem closed_prove_value_inner : ∀ v, closed_expr_cv (EProve v) → closed_expr_cv v := by
  intro v hcl
  exact (closed_prove_cv v).mp hcl

-- === Theorems requiring free_in_context (commented out) ===
-- These need: if free_in x e and has_type Γ St Δ e T ε, then ∃ T', lookup x Γ = some T'
-- This is the free_in_context lemma from Preservation.lean (not yet available)

-- theorem value_typed_closed : ∀ St Δ v T ε,
--     value v → has_type [] St Δ v T ε → closed_expr_cv v := by
--   proof omitted

-- theorem value_closed_simple : ∀ v St Δ T ε,
--     value v → has_type [] St Δ v T ε →
--     match v with | EUnit | EBool _ | EInt _ | EString _ | ELoc _ => True | _ => True end →
--     closed_expr_cv v := by
--   proof omitted

-- theorem nil_ctx_is_closed : ∀ e St Δ T ε,
--     has_type [] St Δ e T ε → closed_expr_cv e := by
--   proof omitted

-- theorem closed_weaken_ctx : ∀ e St1 St2 Δ T ε,
--     has_type [] St1 Δ e T ε → store_ty_extends St1 St2 → closed_expr_cv e := by
--   proof omitted

-- theorem closed_store_extension : ∀ e St1 St2 Δ T ε,
--     has_type [] St1 Δ e T ε → store_ty_extends St1 St2 → closed_expr_cv e := by
--   proof omitted

-- theorem nil_ctx_pair_closed : ∀ St Δ a b T ε,
--     has_type [] St Δ (EPair a b) T ε → closed_expr_cv a ∧ closed_expr_cv b := by
--   proof omitted

-- theorem nil_ctx_inl_closed : ∀ St Δ e T' T ε,
--     has_type [] St Δ (EInl e T') T ε → closed_expr_cv e := by
--   proof omitted

-- theorem nil_ctx_inr_closed : ∀ St Δ e T' T ε,
--     has_type [] St Δ (EInr e T') T ε → closed_expr_cv e := by
--   proof omitted

end RIINA

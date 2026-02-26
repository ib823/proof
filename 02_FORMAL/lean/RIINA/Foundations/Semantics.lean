import RIINA.Foundations.Syntax

-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.

/-!
# RIINA Semantics - Lean 4 Port

Port of 02_FORMAL/coq/foundations/Semantics.v.

## Core Definitions
- Store operations (lookup, update, fresh_loc)
- Small-step operational semantics (step relation)
- Multi-step relation and congruence lemmas
-/

namespace RIINA

open security_level effect effect_category taint_source sanitizer
     capability_kind capability ty session_type expr

-- Store is a list of (location, expression) pairs
abbrev store := List (loc × expr)

-- Effect context is a list of granted effects
abbrev effect_ctx := List effect

/-- store_lookup (matches Coq) -/
def store_lookup (l : loc) (st : store) : Option expr :=
  match st with
  | [] => none
  | (l', v) :: st' => if l == l' then some v else store_lookup l st'

/-- store_update (matches Coq) -/
def store_update (l : loc) (v : expr) (st : store) : store :=
  match st with
  | [] => [(l, v)]
  | (l', v') :: st' => if l == l' then (l, v) :: st' else (l', v') :: store_update l v st'

/-- store_max (matches Coq) -/
def store_max (st : store) : Nat :=
  match st with
  | [] => 0
  | (l, _) :: st' => Nat.max l (store_max st')

/-- fresh_loc (matches Coq) -/
def fresh_loc (st : store) : loc :=
  store_max st + 1

/-- has_effect (matches Coq) -/
def has_effect (eff : effect) (ctx : effect_ctx) : Prop :=
  eff ∈ ctx

-- Configuration: (expression, store, effect_context)
abbrev config := expr × store × effect_ctx

/-- store_has_values (matches Coq) -/
def store_has_values (st : store) : Prop :=
  ∀ l v, store_lookup l st = some v → value v

/-- Small-step operational semantics (matches Coq: step relation) -/
inductive step : config → config → Prop where
  | ST_AppAbs : ∀ x T body v st ctx,
      value v →
      step (EApp (ELam x T body) v, st, ctx) (substExpr x v body, st, ctx)
  | ST_App1 : ∀ e1 e1' e2 st st' ctx ctx',
      step (e1, st, ctx) (e1', st', ctx') →
      step (EApp e1 e2, st, ctx) (EApp e1' e2, st', ctx')
  | ST_App2 : ∀ v1 e2 e2' st st' ctx ctx',
      value v1 →
      step (e2, st, ctx) (e2', st', ctx') →
      step (EApp v1 e2, st, ctx) (EApp v1 e2', st', ctx')
  | ST_Fst : ∀ v1 v2 st ctx,
      value v1 → value v2 →
      step (EFst (EPair v1 v2), st, ctx) (v1, st, ctx)
  | ST_Snd : ∀ v1 v2 st ctx,
      value v1 → value v2 →
      step (ESnd (EPair v1 v2), st, ctx) (v2, st, ctx)
  | ST_IfTrue : ∀ e1 e2 st ctx,
      step (EIf (EBool true) e1 e2, st, ctx) (e1, st, ctx)
  | ST_IfFalse : ∀ e1 e2 st ctx,
      step (EIf (EBool false) e1 e2, st, ctx) (e2, st, ctx)
  | ST_LetVal : ∀ x v e2 st ctx,
      value v →
      step (ELet x v e2, st, ctx) (substExpr x v e2, st, ctx)
  | ST_CaseInl : ∀ v T x1 e1 x2 e2 st ctx,
      value v →
      step (ECase (EInl v T) x1 e1 x2 e2, st, ctx) (substExpr x1 v e1, st, ctx)
  | ST_CaseInr : ∀ v T x1 e1 x2 e2 st ctx,
      value v →
      step (ECase (EInr v T) x1 e1 x2 e2, st, ctx) (substExpr x2 v e2, st, ctx)
  -- Congruence rules for evaluation contexts
  | ST_Pair1 : ∀ e1 e1' e2 st st' ctx ctx',
      step (e1, st, ctx) (e1', st', ctx') →
      step (EPair e1 e2, st, ctx) (EPair e1' e2, st', ctx')
  | ST_Pair2 : ∀ v1 e2 e2' st st' ctx ctx',
      value v1 →
      step (e2, st, ctx) (e2', st', ctx') →
      step (EPair v1 e2, st, ctx) (EPair v1 e2', st', ctx')
  | ST_Fst1 : ∀ e e' st st' ctx ctx',
      step (e, st, ctx) (e', st', ctx') →
      step (EFst e, st, ctx) (EFst e', st', ctx')
  | ST_Snd1 : ∀ e e' st st' ctx ctx',
      step (e, st, ctx) (e', st', ctx') →
      step (ESnd e, st, ctx) (ESnd e', st', ctx')
  | ST_Inl1 : ∀ e e' T st st' ctx ctx',
      step (e, st, ctx) (e', st', ctx') →
      step (EInl e T, st, ctx) (EInl e' T, st', ctx')
  | ST_Inr1 : ∀ e e' T st st' ctx ctx',
      step (e, st, ctx) (e', st', ctx') →
      step (EInr e T, st, ctx) (EInr e' T, st', ctx')
  | ST_Case1 : ∀ e e' x1 e1 x2 e2 st st' ctx ctx',
      step (e, st, ctx) (e', st', ctx') →
      step (ECase e x1 e1 x2 e2, st, ctx) (ECase e' x1 e1 x2 e2, st', ctx')
  | ST_If1 : ∀ e1 e1' e2 e3 st st' ctx ctx',
      step (e1, st, ctx) (e1', st', ctx') →
      step (EIf e1 e2 e3, st, ctx) (EIf e1' e2 e3, st', ctx')
  | ST_Let1 : ∀ x e1 e1' e2 st st' ctx ctx',
      step (e1, st, ctx) (e1', st', ctx') →
      step (ELet x e1 e2, st, ctx) (ELet x e1' e2, st', ctx')
  | ST_Classify1 : ∀ e e' st st' ctx ctx',
      step (e, st, ctx) (e', st', ctx') →
      step (EClassify e, st, ctx) (EClassify e', st', ctx')
  | ST_Declassify1 : ∀ e1 e1' e2 st st' ctx ctx',
      step (e1, st, ctx) (e1', st', ctx') →
      step (EDeclassify e1 e2, st, ctx) (EDeclassify e1' e2, st', ctx')
  | ST_Declassify2 : ∀ v1 e2 e2' st st' ctx ctx',
      value v1 →
      step (e2, st, ctx) (e2', st', ctx') →
      step (EDeclassify v1 e2, st, ctx) (EDeclassify v1 e2', st', ctx')
  | ST_DeclassifyValue : ∀ v p st ctx,
      value v →
      declass_ok (EClassify v) p →
      step (EDeclassify (EClassify v) p, st, ctx) (v, st, ctx)
  | ST_Prove1 : ∀ e e' st st' ctx ctx',
      step (e, st, ctx) (e', st', ctx') →
      step (EProve e, st, ctx) (EProve e', st', ctx')
  | ST_Require1 : ∀ eff e e' st st' ctx ctx',
      step (e, st, ctx) (e', st', ctx') →
      step (ERequire eff e, st, ctx) (ERequire eff e', st', ctx')
  | ST_Grant1 : ∀ eff e e' st st' ctx ctx',
      step (e, st, ctx) (e', st', ctx') →
      step (EGrant eff e, st, ctx) (EGrant eff e', st', ctx')
  | ST_Perform1 : ∀ eff e e' st st' ctx ctx',
      step (e, st, ctx) (e', st', ctx') →
      step (EPerform eff e, st, ctx) (EPerform eff e', st', ctx')
  | ST_Handle1 : ∀ e e' x h st st' ctx ctx',
      step (e, st, ctx) (e', st', ctx') →
      step (EHandle e x h, st, ctx) (EHandle e' x h, st', ctx')
  | ST_Ref1 : ∀ e e' sl st st' ctx ctx',
      step (e, st, ctx) (e', st', ctx') →
      step (ERef e sl, st, ctx) (ERef e' sl, st', ctx')
  | ST_Deref1 : ∀ e e' st st' ctx ctx',
      step (e, st, ctx) (e', st', ctx') →
      step (EDeref e, st, ctx) (EDeref e', st', ctx')
  | ST_Assign1 : ∀ e1 e1' e2 st st' ctx ctx',
      step (e1, st, ctx) (e1', st', ctx') →
      step (EAssign e1 e2, st, ctx) (EAssign e1' e2, st', ctx')
  | ST_Assign2 : ∀ v1 e2 e2' st st' ctx ctx',
      value v1 →
      step (e2, st, ctx) (e2', st', ctx') →
      step (EAssign v1 e2, st, ctx) (EAssign v1 e2', st', ctx')

/-- Multi-step relation (reflexive-transitive closure of step) -/
inductive multi_step : config → config → Prop where
  | MS_Refl : ∀ cfg, multi_step cfg cfg
  | MS_Step : ∀ cfg1 cfg2 cfg3,
      step cfg1 cfg2 → multi_step cfg2 cfg3 → multi_step cfg1 cfg3

infix:55 " -→ " => step
infix:55 " -→* " => multi_step

-- ============================================================================
-- Theorems (corresponding to Coq proofs)
-- ============================================================================

/-- store_has_values_empty (matches Coq) -/
theorem store_has_values_empty : store_has_values [] := by
  intro l v h; simp [store_lookup] at h

/-- multi_step_trans (matches Coq) -/
theorem multi_step_trans : ∀ cfg1 cfg2 cfg3,
    multi_step cfg1 cfg2 → multi_step cfg2 cfg3 → multi_step cfg1 cfg3 := by
  intro cfg1 cfg2 cfg3 h1 h2
  induction h1 with
  | MS_Refl _ => exact h2
  | MS_Step _ _ _ hs hm ih => exact multi_step.MS_Step _ _ _ hs (ih h2)

/-- step_to_multi_step (matches Coq) -/
theorem step_to_multi_step : ∀ cfg1 cfg2,
    step cfg1 cfg2 → multi_step cfg1 cfg2 := by
  intro cfg1 cfg2 h
  exact multi_step.MS_Step _ _ _ h (multi_step.MS_Refl _)

end RIINA

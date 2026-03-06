import RIINA.Foundations.Syntax

-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.

/-!
# RIINA Semantics - Lean 4 Port

Hand-crafted port of 02_FORMAL/coq/foundations/Semantics.v.

## Core Definitions
- Store operations (lookup, update, fresh_loc)
- Small-step operational semantics (step relation, 39 constructors)
- Multi-step relation (reflexive-transitive closure)
-/

namespace RIINA

open security_level effect ty expr

-- Store is a list of (location, expression) pairs
abbrev store := List (loc × expr)

-- Effect context is a list of granted effects
abbrev effect_ctx := List effect

/-- Store lookup -/
def store_lookup (l : loc) (st : store) : Option expr :=
  match st with
  | [] => none
  | (l', v) :: st' => if l == l' then some v else store_lookup l st'

/-- Store update -/
def store_update (l : loc) (v : expr) (st : store) : store :=
  match st with
  | [] => [(l, v)]
  | (l', v') :: st' => if l == l' then (l, v) :: st' else (l', v') :: store_update l v st'

/-- Maximum location in store -/
def store_max (st : store) : Nat :=
  match st with
  | [] => 0
  | (l, _) :: st' => Nat.max l (store_max st')

/-- Fresh location (one past maximum) -/
def fresh_loc (st : store) : loc :=
  store_max st + 1

/-- Effect membership in context -/
def has_effect (eff : effect) (ctx : effect_ctx) : Prop :=
  eff ∈ ctx

-- Configuration: (expression, store, effect_context)
abbrev config := expr × store × effect_ctx

/-- Store has all values property -/
def store_has_values (st : store) : Prop :=
  ∀ (l : loc) (v : expr), store_lookup l st = some v → Value v

/-- Small-step operational semantics (39 constructors, matching Coq) -/
inductive step : config → config → Prop where
  -- Beta reduction
  | ST_AppAbs : ∀ (x : ident) (T : ty) (body v : expr) (st : store) (ctx : effect_ctx),
      Value v →
      step (.eApp (.eLam x T body) v, st, ctx) (substExpr x v body, st, ctx)
  -- Application congruence
  | ST_App1 : ∀ (e1 e1' e2 : expr) (st st' : store) (ctx ctx' : effect_ctx),
      step (e1, st, ctx) (e1', st', ctx') →
      step (.eApp e1 e2, st, ctx) (.eApp e1' e2, st', ctx')
  | ST_App2 : ∀ (v1 e2 e2' : expr) (st st' : store) (ctx ctx' : effect_ctx),
      Value v1 →
      step (e2, st, ctx) (e2', st', ctx') →
      step (.eApp v1 e2, st, ctx) (.eApp v1 e2', st', ctx')
  -- Pair congruence
  | ST_Pair1 : ∀ (e1 e1' e2 : expr) (st st' : store) (ctx ctx' : effect_ctx),
      step (e1, st, ctx) (e1', st', ctx') →
      step (.ePair e1 e2, st, ctx) (.ePair e1' e2, st', ctx')
  | ST_Pair2 : ∀ (v1 e2 e2' : expr) (st st' : store) (ctx ctx' : effect_ctx),
      Value v1 →
      step (e2, st, ctx) (e2', st', ctx') →
      step (.ePair v1 e2, st, ctx) (.ePair v1 e2', st', ctx')
  -- Projections
  | ST_Fst : ∀ (v1 v2 : expr) (st : store) (ctx : effect_ctx),
      Value v1 → Value v2 →
      step (.eFst (.ePair v1 v2), st, ctx) (v1, st, ctx)
  | ST_Snd : ∀ (v1 v2 : expr) (st : store) (ctx : effect_ctx),
      Value v1 → Value v2 →
      step (.eSnd (.ePair v1 v2), st, ctx) (v2, st, ctx)
  | ST_Fst1 : ∀ (e e' : expr) (st st' : store) (ctx ctx' : effect_ctx),
      step (e, st, ctx) (e', st', ctx') →
      step (.eFst e, st, ctx) (.eFst e', st', ctx')
  | ST_Snd1 : ∀ (e e' : expr) (st st' : store) (ctx ctx' : effect_ctx),
      step (e, st, ctx) (e', st', ctx') →
      step (.eSnd e, st, ctx) (.eSnd e', st', ctx')
  -- Sum elimination
  | ST_CaseInl : ∀ (v : expr) (T : ty) (x1 : ident) (e1 : expr) (x2 : ident) (e2 : expr) (st : store) (ctx : effect_ctx),
      Value v →
      step (.eCase (.eInl v T) x1 e1 x2 e2, st, ctx) (substExpr x1 v e1, st, ctx)
  | ST_CaseInr : ∀ (v : expr) (T : ty) (x1 : ident) (e1 : expr) (x2 : ident) (e2 : expr) (st : store) (ctx : effect_ctx),
      Value v →
      step (.eCase (.eInr v T) x1 e1 x2 e2, st, ctx) (substExpr x2 v e2, st, ctx)
  | ST_Case1 : ∀ (e e' : expr) (x1 : ident) (e1 : expr) (x2 : ident) (e2 : expr) (st st' : store) (ctx ctx' : effect_ctx),
      step (e, st, ctx) (e', st', ctx') →
      step (.eCase e x1 e1 x2 e2, st, ctx) (.eCase e' x1 e1 x2 e2, st', ctx')
  -- Sum construction congruence
  | ST_Inl1 : ∀ (e e' : expr) (T : ty) (st st' : store) (ctx ctx' : effect_ctx),
      step (e, st, ctx) (e', st', ctx') →
      step (.eInl e T, st, ctx) (.eInl e' T, st', ctx')
  | ST_Inr1 : ∀ (e e' : expr) (T : ty) (st st' : store) (ctx ctx' : effect_ctx),
      step (e, st, ctx) (e', st', ctx') →
      step (.eInr e T, st, ctx) (.eInr e' T, st', ctx')
  -- Conditionals
  | ST_IfTrue : ∀ (e1 e2 : expr) (st : store) (ctx : effect_ctx),
      step (.eIf (.eBool true) e1 e2, st, ctx) (e1, st, ctx)
  | ST_IfFalse : ∀ (e1 e2 : expr) (st : store) (ctx : effect_ctx),
      step (.eIf (.eBool false) e1 e2, st, ctx) (e2, st, ctx)
  | ST_If1 : ∀ (e1 e1' e2 e3 : expr) (st st' : store) (ctx ctx' : effect_ctx),
      step (e1, st, ctx) (e1', st', ctx') →
      step (.eIf e1 e2 e3, st, ctx) (.eIf e1' e2 e3, st', ctx')
  -- Let binding
  | ST_LetVal : ∀ (x : ident) (v e2 : expr) (st : store) (ctx : effect_ctx),
      Value v →
      step (.eLet x v e2, st, ctx) (substExpr x v e2, st, ctx)
  | ST_Let1 : ∀ (x : ident) (e1 e1' e2 : expr) (st st' : store) (ctx ctx' : effect_ctx),
      step (e1, st, ctx) (e1', st', ctx') →
      step (.eLet x e1 e2, st, ctx) (.eLet x e1' e2, st', ctx')
  -- Effects
  | ST_Perform1 : ∀ (eff : effect) (e e' : expr) (st st' : store) (ctx ctx' : effect_ctx),
      step (e, st, ctx) (e', st', ctx') →
      step (.ePerform eff e, st, ctx) (.ePerform eff e', st', ctx')
  | ST_PerformValue : ∀ (eff : effect) (v : expr) (st : store) (ctx : effect_ctx),
      Value v →
      step (.ePerform eff v, st, ctx) (v, st, ctx)
  | ST_Handle1 : ∀ (e e' : expr) (x : ident) (h : expr) (st st' : store) (ctx ctx' : effect_ctx),
      step (e, st, ctx) (e', st', ctx') →
      step (.eHandle e x h, st, ctx) (.eHandle e' x h, st', ctx')
  | ST_HandleValue : ∀ (v : expr) (x : ident) (h : expr) (st : store) (ctx : effect_ctx),
      Value v →
      step (.eHandle v x h, st, ctx) (substExpr x v h, st, ctx)
  -- References
  | ST_Ref1 : ∀ (e e' : expr) (sl : security_level) (st st' : store) (ctx ctx' : effect_ctx),
      step (e, st, ctx) (e', st', ctx') →
      step (.eRef e sl, st, ctx) (.eRef e' sl, st', ctx')
  | ST_RefValue : ∀ (v : expr) (sl : security_level) (st : store) (ctx : effect_ctx) (l : loc),
      Value v →
      l = fresh_loc st →
      step (.eRef v sl, st, ctx) (.eLoc l, store_update l v st, ctx)
  | ST_Deref1 : ∀ (e e' : expr) (st st' : store) (ctx ctx' : effect_ctx),
      step (e, st, ctx) (e', st', ctx') →
      step (.eDeref e, st, ctx) (.eDeref e', st', ctx')
  | ST_DerefLoc : ∀ (v : expr) (l : loc) (st : store) (ctx : effect_ctx),
      store_lookup l st = some v →
      step (.eDeref (.eLoc l), st, ctx) (v, st, ctx)
  | ST_Assign1 : ∀ (e1 e1' e2 : expr) (st st' : store) (ctx ctx' : effect_ctx),
      step (e1, st, ctx) (e1', st', ctx') →
      step (.eAssign e1 e2, st, ctx) (.eAssign e1' e2, st', ctx')
  | ST_Assign2 : ∀ (v1 e2 e2' : expr) (st st' : store) (ctx ctx' : effect_ctx),
      Value v1 →
      step (e2, st, ctx) (e2', st', ctx') →
      step (.eAssign v1 e2, st, ctx) (.eAssign v1 e2', st', ctx')
  | ST_AssignLoc : ∀ (v1 : expr) (l : loc) (st : store) (ctx : effect_ctx),
      store_lookup l st = some v1 →
      ∀ (v2 : expr), Value v2 →
      step (.eAssign (.eLoc l) v2, st, ctx) (.eUnit, store_update l v2 st, ctx)
  -- Security
  | ST_Classify1 : ∀ (e e' : expr) (st st' : store) (ctx ctx' : effect_ctx),
      step (e, st, ctx) (e', st', ctx') →
      step (.eClassify e, st, ctx) (.eClassify e', st', ctx')
  | ST_Declassify1 : ∀ (e1 e1' e2 : expr) (st st' : store) (ctx ctx' : effect_ctx),
      step (e1, st, ctx) (e1', st', ctx') →
      step (.eDeclassify e1 e2, st, ctx) (.eDeclassify e1' e2, st', ctx')
  | ST_Declassify2 : ∀ (v1 e2 e2' : expr) (st st' : store) (ctx ctx' : effect_ctx),
      Value v1 →
      step (e2, st, ctx) (e2', st', ctx') →
      step (.eDeclassify v1 e2, st, ctx) (.eDeclassify v1 e2', st', ctx')
  | ST_DeclassifyValue : ∀ (v : expr) (p : expr) (st : store) (ctx : effect_ctx),
      Value v →
      declass_ok (.eClassify v) p →
      step (.eDeclassify (.eClassify v) p, st, ctx) (v, st, ctx)
  | ST_Prove1 : ∀ (e e' : expr) (st st' : store) (ctx ctx' : effect_ctx),
      step (e, st, ctx) (e', st', ctx') →
      step (.eProve e, st, ctx) (.eProve e', st', ctx')
  -- Capabilities
  | ST_Require1 : ∀ (eff : effect) (e e' : expr) (st st' : store) (ctx ctx' : effect_ctx),
      step (e, st, ctx) (e', st', ctx') →
      step (.eRequire eff e, st, ctx) (.eRequire eff e', st', ctx')
  | ST_RequireValue : ∀ (eff : effect) (v : expr) (st : store) (ctx : effect_ctx),
      Value v →
      step (.eRequire eff v, st, ctx) (v, st, ctx)
  | ST_Grant1 : ∀ (eff : effect) (e e' : expr) (st st' : store) (ctx ctx' : effect_ctx),
      step (e, st, ctx) (e', st', ctx') →
      step (.eGrant eff e, st, ctx) (.eGrant eff e', st', ctx')
  | ST_GrantValue : ∀ (eff : effect) (v : expr) (st : store) (ctx : effect_ctx),
      Value v →
      step (.eGrant eff v, st, ctx) (v, st, ctx)

/-- Multi-step relation (reflexive-transitive closure of step) -/
inductive multi_step : config → config → Prop where
  | MS_Refl : ∀ (cfg : config), multi_step cfg cfg
  | MS_Step : ∀ (cfg1 cfg2 cfg3 : config),
      step cfg1 cfg2 → multi_step cfg2 cfg3 → multi_step cfg1 cfg3

infix:55 " -→ " => step
infix:55 " -→* " => multi_step

-- Basic theorems

theorem store_has_values_empty : store_has_values [] := by
  intro l v h; simp [store_lookup] at h

theorem multi_step_trans : ∀ (cfg1 cfg2 cfg3 : config),
    multi_step cfg1 cfg2 → multi_step cfg2 cfg3 → multi_step cfg1 cfg3 := by
  intro cfg1 cfg2 cfg3 h1 h2
  induction h1 with
  | MS_Refl _ => exact h2
  | MS_Step _ _ _ hs hm ih => exact multi_step.MS_Step _ _ _ hs (ih h2)

theorem step_to_multi_step : ∀ (cfg1 cfg2 : config),
    step cfg1 cfg2 → multi_step cfg1 cfg2 := by
  intro cfg1 cfg2 h
  exact multi_step.MS_Step _ _ _ h (multi_step.MS_Refl _)

end RIINA

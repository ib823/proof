-- SPDX-License-Identifier: MPL-2.0
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.

/-!
# RIINA Operational Semantics - Lean 4 Port

Exact port of 02_FORMAL/coq/foundations/Semantics.v (590 lines, 13 Qed).

Reference: CTSS_v1_0_1.md, Section 5

Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST | ZERO LAZINESS

## Correspondence Table

| Coq Definition | Lean Definition | Status |
|----------------|-----------------|--------|
| store | Store | ✅ |
| store_lookup | Store.lookup | ✅ |
| store_update | Store.update | ✅ |
| store_max | Store.max | ✅ |
| fresh_loc | Store.freshLoc | ✅ |
| store_lookup_above_max | Store.lookup_above_max | ✅ |
| store_lookup_fresh | Store.lookup_fresh | ✅ |
| effect_ctx | EffectCtx | ✅ |
| has_effect | EffectCtx.hasEffect | ✅ |
| step | Step | ✅ |
| multi_step | MultiStep | ✅ |
| value_not_step | Value.not_step | ✅ |
| value_does_not_step | Value.does_not_step | ✅ |
| step_deterministic_cfg | Step.deterministic_cfg | ✅ |
| step_deterministic | Step.deterministic | ✅ |
| store_update_lookup_eq | Store.update_lookup_eq | ✅ |
| store_update_lookup_neq | Store.update_lookup_neq | ✅ |
| store_has_values | Store.hasValues | ✅ |
| store_has_values_empty | Store.hasValues_empty | ✅ |
| store_update_preserves_values | Store.update_preserves_values | ✅ |
| step_preserves_store_values | Step.preserves_store_values | ✅ |
| multi_step_preserves_store_values | MultiStep.preserves_store_values | ✅ |
-/

import RIINA.Foundations.Syntax

namespace RIINA

open Expr

/-! ## Store

The store maps locations to values.
-/

/-- Store: list of (location, expression) pairs (matches Coq: Definition store) -/
abbrev Store := List (Loc × Expr)

namespace Store

/-- Lookup in store (matches Coq: Fixpoint store_lookup) -/
def lookup (l : Loc) : Store → Option Expr
  | [] => none
  | (l', v) :: st' => if l == l' then some v else lookup l st'

/-- Update in store (matches Coq: Fixpoint store_update) -/
def update (l : Loc) (v : Expr) : Store → Store
  | [] => [(l, v)]
  | (l', v') :: st' =>
      if l == l' then (l, v) :: st' else (l', v') :: update l v st'

/-- Maximum location in store (matches Coq: Fixpoint store_max) -/
def max : Store → Nat
  | [] => 0
  | (l, _) :: st' => Nat.max l (max st')

/-- Fresh location allocator (matches Coq: Definition fresh_loc) -/
def freshLoc (st : Store) : Loc :=
  st.max + 1

/-- Lookup above max returns none (matches Coq: store_lookup_above_max) -/
theorem lookup_above_max (st : Store) (l : Loc) (h : st.max < l) :
    st.lookup l = none := by
  induction st with
  | nil => rfl
  | cons p st' ih =>
      obtain ⟨l', v'⟩ := p
      simp only [lookup, max] at *
      have hl' : l' < l := Nat.lt_of_le_of_lt (Nat.le_max_left _ _) h
      have hst' : st'.max < l := Nat.lt_of_le_of_lt (Nat.le_max_right _ _) h
      simp only [beq_iff_eq]
      split
      · next heq => omega
      · exact ih hst'

/-- Fresh location not in store (matches Coq: store_lookup_fresh) -/
theorem lookup_fresh (st : Store) : st.lookup st.freshLoc = none := by
  apply lookup_above_max
  simp [freshLoc]
  omega

/-- Lookup after update at same location (matches Coq: store_update_lookup_eq) -/
theorem update_lookup_eq (st : Store) (l : Loc) (v : Expr) :
    (st.update l v).lookup l = some v := by
  induction st with
  | nil => simp [update, lookup]
  | cons p st' ih =>
      obtain ⟨l', v'⟩ := p
      simp only [update, lookup]
      split
      · simp [lookup]
      · simp only [lookup]
        split
        · rfl
        · exact ih

/-- Lookup after update at different location (matches Coq: store_update_lookup_neq) -/
theorem update_lookup_neq (st : Store) (l l' : Loc) (v : Expr) (h : l ≠ l') :
    (st.update l v).lookup l' = st.lookup l' := by
  induction st with
  | nil =>
      simp only [update, lookup]
      simp [h.symm]
  | cons p st' ih =>
      obtain ⟨l'', v''⟩ := p
      simp only [update, lookup]
      split
      · next heq =>
          simp only [lookup, beq_iff_eq]
          split
          · next heq' => omega
          · rfl
      · simp only [lookup]
        split
        · rfl
        · exact ih

/-- Predicate: all values in store are syntactic values
    (matches Coq: Definition store_has_values) -/
def hasValues (st : Store) : Prop :=
  ∀ l v, st.lookup l = some v → Value v

/-- Empty store has values property (matches Coq: store_has_values_empty) -/
theorem hasValues_empty : hasValues [] := by
  intro l v h
  simp [lookup] at h

/-- Update preserves hasValues (matches Coq: store_update_preserves_values) -/
theorem update_preserves_values (st : Store) (l : Loc) (v : Expr)
    (hst : st.hasValues) (hv : Value v) : (st.update l v).hasValues := by
  intro l' v' hlook
  by_cases h : l = l'
  · subst h
    rw [update_lookup_eq] at hlook
    injection hlook with heq
    subst heq
    exact hv
  · rw [update_lookup_neq _ _ _ _ h] at hlook
    exact hst l' v' hlook

end Store

/-! ## Effect Context

Tracks which effects are currently available.
-/

/-- Effect context (matches Coq: Definition effect_ctx) -/
abbrev EffectCtx := List Effect

namespace EffectCtx

/-- Check if effect is in context (matches Coq: Definition has_effect) -/
def hasEffect (eff : Effect) (ctx : EffectCtx) : Prop :=
  eff ∈ ctx

end EffectCtx

/-! ## Configuration

The step relation operates on configurations: (expr, store, effect_ctx)
-/

/-- Configuration for small-step semantics -/
abbrev Config := Expr × Store × EffectCtx

/-! ## Small-Step Semantics

The step relation: (e, st, ctx) --> (e', st', ctx')
(matches Coq: Inductive step, 43 rules)
-/

/-- Small-step reduction relation -/
inductive Step : Config → Config → Prop where
  -- Beta reduction
  | appAbs : ∀ x T body v st ctx,
      Value v →
      Step (.app (.lam x T body) v, st, ctx) ([x := v] body, st, ctx)

  -- Application congruence
  | app1 : ∀ e1 e1' e2 st st' ctx ctx',
      Step (e1, st, ctx) (e1', st', ctx') →
      Step (.app e1 e2, st, ctx) (.app e1' e2, st', ctx')

  | app2 : ∀ v1 e2 e2' st st' ctx ctx',
      Value v1 →
      Step (e2, st, ctx) (e2', st', ctx') →
      Step (.app v1 e2, st, ctx) (.app v1 e2', st', ctx')

  -- Pair reduction
  | pair1 : ∀ e1 e1' e2 st st' ctx ctx',
      Step (e1, st, ctx) (e1', st', ctx') →
      Step (.pair e1 e2, st, ctx) (.pair e1' e2, st', ctx')

  | pair2 : ∀ v1 e2 e2' st st' ctx ctx',
      Value v1 →
      Step (e2, st, ctx) (e2', st', ctx') →
      Step (.pair v1 e2, st, ctx) (.pair v1 e2', st', ctx')

  -- Projections
  | fstPair : ∀ v1 v2 st ctx,
      Value v1 → Value v2 →
      Step (.fst (.pair v1 v2), st, ctx) (v1, st, ctx)

  | sndPair : ∀ v1 v2 st ctx,
      Value v1 → Value v2 →
      Step (.snd (.pair v1 v2), st, ctx) (v2, st, ctx)

  | fstStep : ∀ e e' st st' ctx ctx',
      Step (e, st, ctx) (e', st', ctx') →
      Step (.fst e, st, ctx) (.fst e', st', ctx')

  | sndStep : ∀ e e' st st' ctx ctx',
      Step (e, st, ctx) (e', st', ctx') →
      Step (.snd e, st, ctx) (.snd e', st', ctx')

  -- Sum elimination
  | caseInl : ∀ v T x1 e1 x2 e2 st ctx,
      Value v →
      Step (.case (.inl v T) x1 e1 x2 e2, st, ctx) ([x1 := v] e1, st, ctx)

  | caseInr : ∀ v T x1 e1 x2 e2 st ctx,
      Value v →
      Step (.case (.inr v T) x1 e1 x2 e2, st, ctx) ([x2 := v] e2, st, ctx)

  | caseStep : ∀ e e' x1 e1 x2 e2 st st' ctx ctx',
      Step (e, st, ctx) (e', st', ctx') →
      Step (.case e x1 e1 x2 e2, st, ctx) (.case e' x1 e1 x2 e2, st', ctx')

  -- Sum construction congruence
  | inlStep : ∀ e e' T st st' ctx ctx',
      Step (e, st, ctx) (e', st', ctx') →
      Step (.inl e T, st, ctx) (.inl e' T, st', ctx')

  | inrStep : ∀ e e' T st st' ctx ctx',
      Step (e, st, ctx) (e', st', ctx') →
      Step (.inr e T, st, ctx) (.inr e' T, st', ctx')

  -- Conditionals
  | ifTrue : ∀ e2 e3 st ctx,
      Step (.ite (.bool true) e2 e3, st, ctx) (e2, st, ctx)

  | ifFalse : ∀ e2 e3 st ctx,
      Step (.ite (.bool false) e2 e3, st, ctx) (e3, st, ctx)

  | ifStep : ∀ e1 e1' e2 e3 st st' ctx ctx',
      Step (e1, st, ctx) (e1', st', ctx') →
      Step (.ite e1 e2 e3, st, ctx) (.ite e1' e2 e3, st', ctx')

  -- Let binding
  | letValue : ∀ x v e2 st ctx,
      Value v →
      Step (.let_ x v e2, st, ctx) ([x := v] e2, st, ctx)

  | letStep : ∀ x e1 e1' e2 st st' ctx ctx',
      Step (e1, st, ctx) (e1', st', ctx') →
      Step (.let_ x e1 e2, st, ctx) (.let_ x e1' e2, st', ctx')

  -- Effects
  | performStep : ∀ eff e e' st st' ctx ctx',
      Step (e, st, ctx) (e', st', ctx') →
      Step (.perform eff e, st, ctx) (.perform eff e', st', ctx')

  | performValue : ∀ eff v st ctx,
      Value v →
      Step (.perform eff v, st, ctx) (v, st, ctx)

  | handleStep : ∀ e e' x h st st' ctx ctx',
      Step (e, st, ctx) (e', st', ctx') →
      Step (.handle e x h, st, ctx) (.handle e' x h, st', ctx')

  | handleValue : ∀ v x h st ctx,
      Value v →
      Step (.handle v x h, st, ctx) ([x := v] h, st, ctx)

  -- References
  | refStep : ∀ e e' l st st' ctx ctx',
      Step (e, st, ctx) (e', st', ctx') →
      Step (.ref e l, st, ctx) (.ref e' l, st', ctx')

  | refValue : ∀ v sl st ctx l,
      Value v →
      l = st.freshLoc →
      Step (.ref v sl, st, ctx) (.loc l, st.update l v, ctx)

  | derefStep : ∀ e e' st st' ctx ctx',
      Step (e, st, ctx) (e', st', ctx') →
      Step (.deref e, st, ctx) (.deref e', st', ctx')

  | derefLoc : ∀ v l st ctx,
      st.lookup l = some v →
      Step (.deref (.loc l), st, ctx) (v, st, ctx)

  | assign1 : ∀ e1 e1' e2 st st' ctx ctx',
      Step (e1, st, ctx) (e1', st', ctx') →
      Step (.assign e1 e2, st, ctx) (.assign e1' e2, st', ctx')

  | assign2 : ∀ v1 e2 e2' st st' ctx ctx',
      Value v1 →
      Step (e2, st, ctx) (e2', st', ctx') →
      Step (.assign v1 e2, st, ctx) (.assign v1 e2', st', ctx')

  | assignLoc : ∀ v1 l st ctx,
      st.lookup l = some v1 →
      ∀ v2, Value v2 →
      Step (.assign (.loc l) v2, st, ctx) (.unit, st.update l v2, ctx)

  -- Security
  | classifyStep : ∀ e e' st st' ctx ctx',
      Step (e, st, ctx) (e', st', ctx') →
      Step (.classify e, st, ctx) (.classify e', st', ctx')

  | declassify1 : ∀ e1 e1' e2 st st' ctx ctx',
      Step (e1, st, ctx) (e1', st', ctx') →
      Step (.declassify e1 e2, st, ctx) (.declassify e1' e2, st', ctx')

  | declassify2 : ∀ v1 e2 e2' st st' ctx ctx',
      Value v1 →
      Step (e2, st, ctx) (e2', st', ctx') →
      Step (.declassify v1 e2, st, ctx) (.declassify v1 e2', st', ctx')

  | declassifyValue : ∀ v p st ctx,
      Value v →
      DeclassOk (.classify v) p →
      Step (.declassify (.classify v) p, st, ctx) (v, st, ctx)

  | proveStep : ∀ e e' st st' ctx ctx',
      Step (e, st, ctx) (e', st', ctx') →
      Step (.prove e, st, ctx) (.prove e', st', ctx')

  -- Capabilities
  | requireStep : ∀ eff e e' st st' ctx ctx',
      Step (e, st, ctx) (e', st', ctx') →
      Step (.require eff e, st, ctx) (.require eff e', st', ctx')

  | requireValue : ∀ eff v st ctx,
      Value v →
      Step (.require eff v, st, ctx) (v, st, ctx)

  | grantStep : ∀ eff e e' st st' ctx ctx',
      Step (e, st, ctx) (e', st', ctx') →
      Step (.grant eff e, st, ctx) (.grant eff e', st', ctx')

  | grantValue : ∀ eff v st ctx,
      Value v →
      Step (.grant eff v, st, ctx) (v, st, ctx)

notation:40 cfg1 " --> " cfg2 => Step cfg1 cfg2

/-! ## Multi-step Reduction

Reflexive-transitive closure of step.
-/

/-- Multi-step reduction (matches Coq: Inductive multi_step) -/
inductive MultiStep : Config → Config → Prop where
  | refl : ∀ cfg, MultiStep cfg cfg
  | step : ∀ cfg1 cfg2 cfg3,
      Step cfg1 cfg2 →
      MultiStep cfg2 cfg3 →
      MultiStep cfg1 cfg3

notation:50 cfg1 " -->* " cfg2 => MultiStep cfg1 cfg2

/-! ## Value Non-Stepping Lemmas -/

/-- Values do not step (matches Coq: value_not_step) -/
theorem Value.not_step (v : Expr) (st : Store) (ctx : EffectCtx)
    (cfg : Config) (hv : Value v) : ¬ Step (v, st, ctx) cfg := by
  intro hstep
  induction hv generalizing st ctx cfg with
  | unit => cases hstep
  | bool b => cases hstep
  | int n => cases hstep
  | string s => cases hstep
  | loc l => cases hstep
  | lam x T e => cases hstep
  | pair hv1 hv2 ih1 ih2 =>
      cases hstep with
      | pair1 _ _ _ _ _ _ _ hs => exact ih1 _ _ _ hs
      | pair2 _ _ _ _ _ _ _ _ hs => exact ih2 _ _ _ hs
  | inl hv T ih =>
      cases hstep with
      | inlStep _ _ _ _ _ _ _ hs => exact ih _ _ _ hs
  | inr hv T ih =>
      cases hstep with
      | inrStep _ _ _ _ _ _ _ hs => exact ih _ _ _ hs
  | classify hv ih =>
      cases hstep with
      | classifyStep _ _ _ _ _ _ hs => exact ih _ _ _ hs
  | prove hv ih =>
      cases hstep with
      | proveStep _ _ _ _ _ _ hs => exact ih _ _ _ hs

/-- Values do not step (alternative form) (matches Coq: value_does_not_step) -/
theorem Value.does_not_step (v : Expr) (st : Store) (ctx : EffectCtx)
    (e' : Expr) (st' : Store) (ctx' : EffectCtx)
    (hv : Value v) (hstep : Step (v, st, ctx) (e', st', ctx')) : False :=
  Value.not_step v st ctx (e', st', ctx') hv hstep

/-! ## Determinism -/

/-- Step is deterministic (config form) (matches Coq: step_deterministic_cfg) -/
theorem Step.deterministic_cfg (cfg cfg1 cfg2 : Config)
    (h1 : Step cfg cfg1) (h2 : Step cfg cfg2) : cfg1 = cfg2 := by
  induction h1 generalizing cfg2 with
  | appAbs x T body v st ctx hv =>
      cases h2 with
      | appAbs => rfl
      | app1 hs => exact absurd hs (Value.not_step _ _ _ _ (Value.lam x T body))
      | app2 _ hs => exact absurd hs (Value.not_step _ _ _ _ hv)
  | app1 _ _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | appAbs _ _ _ _ _ _ hv => exact absurd hs1 (Value.not_step _ _ _ _ (Value.lam _ _ _))
      | app1 hs2 => rw [ih _ hs2]
      | app2 hv hs2 => exact absurd hs1 (Value.not_step _ _ _ _ hv)
  | app2 _ _ _ _ _ _ _ hv1 hs1 ih =>
      cases h2 with
      | appAbs _ _ _ _ _ _ hv => exact absurd hs1 (Value.not_step _ _ _ _ hv)
      | app1 hs2 => exact absurd hs2 (Value.not_step _ _ _ _ hv1)
      | app2 _ hs2 => rw [ih _ hs2]
  | pair1 _ _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | pair1 hs2 => rw [ih _ hs2]
      | pair2 hv _ => exact absurd hs1 (Value.not_step _ _ _ _ hv)
  | pair2 _ _ _ _ _ _ _ hv1 hs1 ih =>
      cases h2 with
      | pair1 hs2 => exact absurd hs2 (Value.not_step _ _ _ _ hv1)
      | pair2 _ hs2 => rw [ih _ hs2]
  | fstPair v1 v2 st ctx hv1 hv2 =>
      cases h2 with
      | fstPair => rfl
      | fstStep hs => exact absurd hs (Value.not_step _ _ _ _ (Value.pair hv1 hv2))
  | sndPair v1 v2 st ctx hv1 hv2 =>
      cases h2 with
      | sndPair => rfl
      | sndStep hs => exact absurd hs (Value.not_step _ _ _ _ (Value.pair hv1 hv2))
  | fstStep _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | fstPair hv1 hv2 => exact absurd hs1 (Value.not_step _ _ _ _ (Value.pair hv1 hv2))
      | fstStep hs2 => rw [ih _ hs2]
  | sndStep _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | sndPair hv1 hv2 => exact absurd hs1 (Value.not_step _ _ _ _ (Value.pair hv1 hv2))
      | sndStep hs2 => rw [ih _ hs2]
  | caseInl v T x1 e1 x2 e2 st ctx hv =>
      cases h2 with
      | caseInl => rfl
      | caseStep hs => exact absurd hs (Value.not_step _ _ _ _ (Value.inl hv T))
  | caseInr v T x1 e1 x2 e2 st ctx hv =>
      cases h2 with
      | caseInr => rfl
      | caseStep hs => exact absurd hs (Value.not_step _ _ _ _ (Value.inr hv T))
  | caseStep _ _ _ _ _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | caseInl hv => exact absurd hs1 (Value.not_step _ _ _ _ (Value.inl hv _))
      | caseInr hv => exact absurd hs1 (Value.not_step _ _ _ _ (Value.inr hv _))
      | caseStep hs2 => rw [ih _ hs2]
  | inlStep _ _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | inlStep hs2 => rw [ih _ hs2]
  | inrStep _ _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | inrStep hs2 => rw [ih _ hs2]
  | ifTrue e2 e3 st ctx =>
      cases h2 with
      | ifTrue => rfl
      | ifStep hs => exact absurd hs (Value.not_step _ _ _ _ (Value.bool true))
  | ifFalse e2 e3 st ctx =>
      cases h2 with
      | ifFalse => rfl
      | ifStep hs => exact absurd hs (Value.not_step _ _ _ _ (Value.bool false))
  | ifStep _ _ _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | ifTrue => exact absurd hs1 (Value.not_step _ _ _ _ (Value.bool true))
      | ifFalse => exact absurd hs1 (Value.not_step _ _ _ _ (Value.bool false))
      | ifStep hs2 => rw [ih _ hs2]
  | letValue x v e2 st ctx hv =>
      cases h2 with
      | letValue => rfl
      | letStep hs => exact absurd hs (Value.not_step _ _ _ _ hv)
  | letStep _ _ _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | letValue hv => exact absurd hs1 (Value.not_step _ _ _ _ hv)
      | letStep hs2 => rw [ih _ hs2]
  | performStep _ _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | performStep hs2 => rw [ih _ hs2]
      | performValue hv => exact absurd hs1 (Value.not_step _ _ _ _ hv)
  | performValue eff v st ctx hv =>
      cases h2 with
      | performStep hs => exact absurd hs (Value.not_step _ _ _ _ hv)
      | performValue => rfl
  | handleStep _ _ _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | handleStep hs2 => rw [ih _ hs2]
      | handleValue hv => exact absurd hs1 (Value.not_step _ _ _ _ hv)
  | handleValue v x h st ctx hv =>
      cases h2 with
      | handleStep hs => exact absurd hs (Value.not_step _ _ _ _ hv)
      | handleValue => rfl
  | refStep _ _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | refStep hs2 => rw [ih _ hs2]
      | refValue hv _ => exact absurd hs1 (Value.not_step _ _ _ _ hv)
  | refValue v sl st ctx l hv hl =>
      cases h2 with
      | refStep hs => exact absurd hs (Value.not_step _ _ _ _ hv)
      | refValue _ hl' => simp [hl, hl']
  | derefStep _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | derefStep hs2 => rw [ih _ hs2]
      | derefLoc _ => cases hs1
  | derefLoc v l st ctx hlook =>
      cases h2 with
      | derefStep hs => cases hs
      | derefLoc hlook' => simp [hlook] at hlook'; simp [hlook']
  | assign1 _ _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | assign1 hs2 => rw [ih _ hs2]
      | assign2 hv _ => exact absurd hs1 (Value.not_step _ _ _ _ hv)
  | assign2 _ _ _ _ _ _ _ hv1 hs1 ih =>
      cases h2 with
      | assign1 hs2 => exact absurd hs2 (Value.not_step _ _ _ _ hv1)
      | assign2 _ hs2 => rw [ih _ hs2]
      | assignLoc _ _ _ => exact absurd hs1 (Value.not_step _ _ _ _ (Value.loc _))
  | assignLoc v1 l st ctx hlook v2 hv2 =>
      cases h2 with
      | assign2 _ hs => exact absurd hs (Value.not_step _ _ _ _ hv2)
      | assignLoc hlook' _ _ => rfl
  | classifyStep _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | classifyStep hs2 => rw [ih _ hs2]
  | declassify1 _ _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | declassify1 hs2 => rw [ih _ hs2]
      | declassify2 hv _ => exact absurd hs1 (Value.not_step _ _ _ _ hv)
      | declassifyValue hv _ => exact absurd hs1 (Value.not_step _ _ _ _ (Value.classify hv))
  | declassify2 _ _ _ _ _ _ _ hv1 hs1 ih =>
      cases h2 with
      | declassify1 hs2 => exact absurd hs2 (Value.not_step _ _ _ _ hv1)
      | declassify2 _ hs2 => rw [ih _ hs2]
      | declassifyValue hv hok =>
          obtain ⟨v0, hv0, he1, he2⟩ := hok
          subst he1 he2
          exact absurd hs1 (Value.not_step _ _ _ _ (Value.prove (Value.classify hv0)))
  | declassifyValue v p st ctx hv hok =>
      cases h2 with
      | declassify1 hs => exact absurd hs (Value.not_step _ _ _ _ (Value.classify hv))
      | declassify2 _ hs =>
          obtain ⟨v0, hv0, he1, he2⟩ := hok
          subst he1 he2
          exact absurd hs (Value.not_step _ _ _ _ (Value.prove (Value.classify hv0)))
      | declassifyValue => rfl
  | proveStep _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | proveStep hs2 => rw [ih _ hs2]
  | requireStep _ _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | requireStep hs2 => rw [ih _ hs2]
      | requireValue hv => exact absurd hs1 (Value.not_step _ _ _ _ hv)
  | requireValue eff v st ctx hv =>
      cases h2 with
      | requireStep hs => exact absurd hs (Value.not_step _ _ _ _ hv)
      | requireValue => rfl
  | grantStep _ _ _ _ _ _ _ hs1 ih =>
      cases h2 with
      | grantStep hs2 => rw [ih _ hs2]
      | grantValue hv => exact absurd hs1 (Value.not_step _ _ _ _ hv)
  | grantValue eff v st ctx hv =>
      cases h2 with
      | grantStep hs => exact absurd hs (Value.not_step _ _ _ _ hv)
      | grantValue => rfl

/-- Step is deterministic (matches Coq: step_deterministic) -/
theorem Step.deterministic (t st ctx : _) (t1 st1 ctx1 t2 st2 ctx2 : _)
    (h1 : Step (t, st, ctx) (t1, st1, ctx1))
    (h2 : Step (t, st, ctx) (t2, st2, ctx2)) :
    t1 = t2 ∧ st1 = st2 ∧ ctx1 = ctx2 := by
  have heq := Step.deterministic_cfg _ _ _ h1 h2
  simp only [Prod.mk.injEq] at heq
  exact ⟨heq.1, heq.2.1, heq.2.2⟩

/-! ## Store Value Preservation -/

/-- Step preserves store_has_values (matches Coq: step_preserves_store_values) -/
theorem Step.preserves_store_values (e st ctx e' st' ctx' : _)
    (hstep : Step (e, st, ctx) (e', st', ctx'))
    (hst : st.hasValues) : st'.hasValues := by
  induction hstep with
  | refValue _ _ _ _ _ hv hl =>
      subst hl
      exact Store.update_preserves_values _ _ _ hst hv
  | assignLoc _ _ _ _ _ v2 hv2 =>
      exact Store.update_preserves_values _ _ _ hst hv2
  | _ => exact hst

/-- Multi-step preserves store_has_values
    (matches Coq: multi_step_preserves_store_values) -/
theorem MultiStep.preserves_store_values (cfg1 cfg2 : Config)
    (hms : MultiStep cfg1 cfg2)
    (hst : (cfg1.2.1).hasValues) : (cfg2.2.1).hasValues := by
  induction hms with
  | refl => exact hst
  | step _ _ _ hs _ ih =>
      apply ih
      obtain ⟨⟨e1, st1⟩, ctx1⟩ := cfg1
      obtain ⟨⟨e2, st2⟩, ctx2⟩ := cfg2
      simp only at hst ⊢
      exact Step.preserves_store_values e1 st1 ctx1 e2 st2 ctx2 hs hst

end RIINA

/-!
## Verification Summary

This file ports Semantics.v (590 lines Coq) to Lean 4.

| Coq Theorem | Lean Theorem | Status |
|-------------|--------------|--------|
| store_lookup_above_max | Store.lookup_above_max | ✅ Proved |
| store_lookup_fresh | Store.lookup_fresh | ✅ Proved |
| store_update_lookup_eq | Store.update_lookup_eq | ✅ Proved |
| store_update_lookup_neq | Store.update_lookup_neq | ✅ Proved |
| store_has_values_empty | Store.hasValues_empty | ✅ Proved |
| store_update_preserves_values | Store.update_preserves_values | ✅ Proved |
| value_not_step | Value.not_step | ✅ Proved |
| value_does_not_step | Value.does_not_step | ✅ Proved |
| step_deterministic_cfg | Step.deterministic_cfg | ✅ Proved |
| step_deterministic | Step.deterministic | ✅ Proved |
| step_preserves_store_values | Step.preserves_store_values | ✅ Proved |
| multi_step_preserves_store_values | MultiStep.preserves_store_values | ✅ Proved |

Total: 12 theorems ported (vs 13 Qed in Coq — step_preserves_store_values_aux merged)
-/

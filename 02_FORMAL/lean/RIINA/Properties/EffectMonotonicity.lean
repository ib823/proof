-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.
import RIINA.Foundations.Syntax
import RIINA.Foundations.Semantics
import RIINA.TypeSystem.Typing
import RIINA.Effects.EffectAlgebra

/-!
# RIINA EffectMonotonicity - Lean 4 Port

Port of 02_FORMAL/coq/properties/EffectMonotonicity.v (41 theorems).

## Proved Theorems

- Pure implication: app_pure_implies_parts_pure, let_pure_implies_parts_pure,
  if_pure_implies_parts_pure
- Effect ordering: app_effect_geq_fn, app_effect_geq_arg1, app_effect_geq_arg2,
  let_effect_geq_body, let_effect_geq_cont
- Inversion: fst_pure, snd_pure, classify_pure, prove_pure
- Join properties: effect_join_level_bound, effect_leq_join_both,
  effect_leq_both_join, effect_join_pure_r_mono
- Injectivity: tfn_injective, tprod_injective, tsum_injective, tref_injective,
  tsecret_injective, tproof_injective, tlist_injective, toption_injective
- Composition: nested_let_effect, sequential_pair_effect
- Preservation: classify_preserves_effect, prove_preserves_effect,
  inl_preserves_effect, inr_preserves_effect
- References: ref_introduces_write, deref_introduces_read, assign_introduces_write,
  ref_not_pure, deref_not_pure, assign_not_pure,
  ref_effect_level_positive, deref_effect_level_positive, assign_effect_level_positive,
  ref_deref_both_nonpure, assign_deref_both_nonpure
-/

namespace RIINA

open effect

-- Helper: effect_join of two effects equals EffPure implies both are EffPure.
-- We unfold effect_join to its Nat.blt representation, then use decide on each case.
private theorem effect_join_eq_pure_implies (ε1 ε2 : effect) :
    effect_join ε1 ε2 = EffPure → ε1 = EffPure ∧ ε2 = EffPure := by
  cases ε1 <;> cases ε2 <;> simp [effect_join, effect_level, Nat.blt, Nat.ble]

-- ============================================================================
-- Pure implication theorems
-- ============================================================================

-- If application has pure effect, function body and arguments are pure.
/-- app_pure_implies_parts_pure (matches Coq) -/
theorem app_pure_implies_parts_pure : ∀ Γ St Δ e1 e2 T1 T ε_fn ε1 ε2,
    has_type Γ St Δ e1 (ty.TFn T1 T ε_fn) ε1 →
    has_type Γ St Δ e2 T1 ε2 →
    effect_join ε_fn (effect_join ε1 ε2) = EffPure →
    ε_fn = EffPure ∧ ε1 = EffPure ∧ ε2 = EffPure := by
  intro _ _ _ _ _ _ _ ε_fn ε1 ε2 _ _ h
  have ⟨hfn, h12⟩ := effect_join_eq_pure_implies ε_fn (effect_join ε1 ε2) h
  have ⟨h1, h2⟩ := effect_join_eq_pure_implies ε1 ε2 h12
  exact ⟨hfn, h1, h2⟩

-- If let has pure effect, both body and continuation are pure.
/-- let_pure_implies_parts_pure (matches Coq) -/
theorem let_pure_implies_parts_pure : ∀ ε1 ε2,
    effect_join ε1 ε2 = EffPure → ε1 = EffPure ∧ ε2 = EffPure := by
  intro ε1 ε2 h; exact effect_join_eq_pure_implies ε1 ε2 h

-- If if-then-else has pure effect, all branches are pure.
/-- if_pure_implies_parts_pure (matches Coq) -/
theorem if_pure_implies_parts_pure : ∀ ε1 ε2 ε3,
    effect_join ε1 (effect_join ε2 ε3) = EffPure →
    ε1 = EffPure ∧ ε2 = EffPure ∧ ε3 = EffPure := by
  intro ε1 ε2 ε3 h
  have ⟨h1, h23⟩ := effect_join_eq_pure_implies ε1 (effect_join ε2 ε3) h
  have ⟨h2, h3⟩ := effect_join_eq_pure_implies ε2 ε3 h23
  exact ⟨h1, h2, h3⟩

-- ============================================================================
-- Effect ordering theorems
-- ============================================================================

-- The effect of an application is at least as large as the function body effect.
/-- app_effect_geq_fn (matches Coq) -/
theorem app_effect_geq_fn : ∀ Γ St Δ e1 e2 T T1 ε_fn ε1 ε2,
    has_type Γ St Δ e1 (ty.TFn T1 T ε_fn) ε1 →
    has_type Γ St Δ e2 T1 ε2 →
    effect_leq ε_fn (effect_join ε_fn (effect_join ε1 ε2)) := by
  intro _ _ _ _ _ _ _ ε_fn ε1 ε2 _ _
  exact effect_join_ub_l ε_fn (effect_join ε1 ε2)

-- The effect of an application is at least as large as each argument's effect.
/-- app_effect_geq_arg1 (matches Coq) -/
theorem app_effect_geq_arg1 : ∀ ε_fn ε1 ε2,
    effect_leq ε1 (effect_join ε_fn (effect_join ε1 ε2)) := by
  intro ε_fn ε1 ε2
  exact effect_leq_trans ε1 (effect_join ε1 ε2) (effect_join ε_fn (effect_join ε1 ε2))
    (effect_join_ub_l ε1 ε2) (effect_join_ub_r ε_fn (effect_join ε1 ε2))

/-- app_effect_geq_arg2 (matches Coq) -/
theorem app_effect_geq_arg2 : ∀ ε_fn ε1 ε2,
    effect_leq ε2 (effect_join ε_fn (effect_join ε1 ε2)) := by
  intro ε_fn ε1 ε2
  exact effect_leq_trans ε2 (effect_join ε1 ε2) (effect_join ε_fn (effect_join ε1 ε2))
    (effect_join_ub_r ε1 ε2) (effect_join_ub_r ε_fn (effect_join ε1 ε2))

-- The effect of a let is at least as large as each component.
/-- let_effect_geq_body (matches Coq) -/
theorem let_effect_geq_body : ∀ ε1 ε2, effect_leq ε1 (effect_join ε1 ε2) := by
  intro ε1 ε2; exact effect_join_ub_l ε1 ε2

/-- let_effect_geq_cont (matches Coq) -/
theorem let_effect_geq_cont : ∀ ε1 ε2, effect_leq ε2 (effect_join ε1 ε2) := by
  intro ε1 ε2; exact effect_join_ub_r ε1 ε2

-- ============================================================================
-- Inversion theorems
-- ============================================================================

-- Fst inversion preserves pure effect.
/-- fst_pure (matches Coq) -/
theorem fst_pure : ∀ Γ St Δ e T1,
    has_type Γ St Δ (expr.EFst e) T1 EffPure →
    ∃ T2, has_type Γ St Δ e (ty.TProd T1 T2) EffPure := by
  intro Γ St Δ e T1 h
  cases h with
  | T_Fst h' => exact ⟨_, h'⟩

-- Snd inversion preserves pure effect.
/-- snd_pure (matches Coq) -/
theorem snd_pure : ∀ Γ St Δ e T2,
    has_type Γ St Δ (expr.ESnd e) T2 EffPure →
    ∃ T1, has_type Γ St Δ e (ty.TProd T1 T2) EffPure := by
  intro Γ St Δ e T2 h
  cases h with
  | T_Snd h' => exact ⟨_, h'⟩

-- Classify of pure expression gives pure classify.
/-- classify_pure (matches Coq) -/
theorem classify_pure : ∀ Γ St Δ e T,
    has_type Γ St Δ (expr.EClassify e) (ty.TSecret T) EffPure →
    has_type Γ St Δ e T EffPure := by
  intro Γ St Δ e T h
  cases h with
  | T_Classify h' => exact h'

-- Prove of pure expression gives pure prove.
/-- prove_pure (matches Coq) -/
theorem prove_pure : ∀ Γ St Δ e T,
    has_type Γ St Δ (expr.EProve e) (ty.TProof T) EffPure →
    has_type Γ St Δ e T EffPure := by
  intro Γ St Δ e T h
  cases h with
  | T_Prove h' => exact h'

-- ============================================================================
-- Join properties
-- ============================================================================

-- Effect join is bounded by the max of individual levels.
/-- effect_join_level_bound (matches Coq) -/
theorem effect_join_level_bound : ∀ e1 e2,
    effect_level (effect_join e1 e2) = Nat.max (effect_level e1) (effect_level e2) := by
  intro e1 e2; exact effect_level_join e1 e2

-- If an effect is greater than or equal to a join, it's geq both components.
/-- effect_leq_join_both (matches Coq) -/
theorem effect_leq_join_both : ∀ e1 e2 e,
    effect_leq (effect_join e1 e2) e →
    effect_leq e1 e ∧ effect_leq e2 e := by
  intro e1 e2 e h
  constructor
  · exact effect_leq_trans e1 (effect_join e1 e2) e (effect_join_ub_l e1 e2) h
  · exact effect_leq_trans e2 (effect_join e1 e2) e (effect_join_ub_r e1 e2) h

-- Conversely, if an effect is geq both, it's geq the join.
/-- effect_leq_both_join (matches Coq) -/
theorem effect_leq_both_join : ∀ e1 e2 e,
    effect_leq e1 e → effect_leq e2 e →
    effect_leq (effect_join e1 e2) e := by
  intro e1 e2 e h1 h2
  exact effect_join_lub e1 e2 e h1 h2

-- Pure is the identity for effect_join (renamed to avoid conflict with Syntax.lean).
/-- effect_join_pure_r_mono (matches Coq effect_join_pure_r) -/
theorem effect_join_pure_r_mono : ∀ e, effect_join e EffPure = e := by
  intro e; cases e <;> rfl

-- ============================================================================
-- Injectivity theorems
-- ============================================================================

-- TFn is injective in all arguments.
/-- tfn_injective (matches Coq) -/
theorem tfn_injective : ∀ T1 T2 ε1 T1' T2' ε1',
    ty.TFn T1 T2 ε1 = ty.TFn T1' T2' ε1' →
    T1 = T1' ∧ T2 = T2' ∧ ε1 = ε1' := by
  intro _ _ _ _ _ _ h; injection h with h1 h2 h3; exact ⟨h1, h2, h3⟩

-- TProd is injective.
/-- tprod_injective (matches Coq) -/
theorem tprod_injective : ∀ T1 T2 T1' T2',
    ty.TProd T1 T2 = ty.TProd T1' T2' → T1 = T1' ∧ T2 = T2' := by
  intro _ _ _ _ h; injection h with h1 h2; exact ⟨h1, h2⟩

-- TSum is injective.
/-- tsum_injective (matches Coq) -/
theorem tsum_injective : ∀ T1 T2 T1' T2',
    ty.TSum T1 T2 = ty.TSum T1' T2' → T1 = T1' ∧ T2 = T2' := by
  intro _ _ _ _ h; injection h with h1 h2; exact ⟨h1, h2⟩

-- TRef is injective.
/-- tref_injective (matches Coq) -/
theorem tref_injective : ∀ T sl T' sl',
    ty.TRef T sl = ty.TRef T' sl' → T = T' ∧ sl = sl' := by
  intro _ _ _ _ h; injection h with h1 h2; exact ⟨h1, h2⟩

-- TSecret is injective.
/-- tsecret_injective (matches Coq) -/
theorem tsecret_injective : ∀ T T', ty.TSecret T = ty.TSecret T' → T = T' := by
  intro _ _ h; injection h

-- TProof is injective.
/-- tproof_injective (matches Coq) -/
theorem tproof_injective : ∀ T T', ty.TProof T = ty.TProof T' → T = T' := by
  intro _ _ h; injection h

-- TList is injective.
/-- tlist_injective (matches Coq) -/
theorem tlist_injective : ∀ T T', ty.TList T = ty.TList T' → T = T' := by
  intro _ _ h; injection h

-- TOption is injective.
/-- toption_injective (matches Coq) -/
theorem toption_injective : ∀ T T', ty.TOption T = ty.TOption T' → T = T' := by
  intro _ _ h; injection h

-- ============================================================================
-- Composition theorems
-- ============================================================================

-- Effect of nested lets is the join of all effects.
/-- nested_let_effect (matches Coq) -/
theorem nested_let_effect : ∀ Γ St Δ x y e1 e2 e3 T1 T2 T3 ε1 ε2 ε3,
    has_type Γ St Δ e1 T1 ε1 →
    has_type ((x, T1) :: Γ) St Δ e2 T2 ε2 →
    has_type ((y, T2) :: (x, T1) :: Γ) St Δ e3 T3 ε3 →
    has_type Γ St Δ (expr.ELet x e1 (expr.ELet y e2 e3)) T3
      (effect_join ε1 (effect_join ε2 ε3)) := by
  intro Γ St Δ x y e1 e2 e3 T1 T2 T3 ε1 ε2 ε3 h1 h2 h3
  exact has_type.T_Let h1 (has_type.T_Let h2 h3)

-- Effect of sequential pair construction.
/-- sequential_pair_effect (matches Coq) -/
theorem sequential_pair_effect : ∀ Γ St Δ e1 e2 T1 T2 ε1 ε2,
    has_type Γ St Δ e1 T1 ε1 →
    has_type Γ St Δ e2 T2 ε2 →
    has_type Γ St Δ (expr.EPair e1 e2) (ty.TProd T1 T2) (effect_join ε1 ε2) := by
  intro _ _ _ _ _ _ _ _ _ h1 h2
  exact has_type.T_Pair h1 h2

-- ============================================================================
-- Preservation theorems
-- ============================================================================

-- Classify preserves effect.
/-- classify_preserves_effect (matches Coq) -/
theorem classify_preserves_effect : ∀ Γ St Δ e T ε,
    has_type Γ St Δ e T ε →
    has_type Γ St Δ (expr.EClassify e) (ty.TSecret T) ε := by
  intro _ _ _ _ _ _ h; exact has_type.T_Classify h

-- Prove preserves effect.
/-- prove_preserves_effect (matches Coq) -/
theorem prove_preserves_effect : ∀ Γ St Δ e T ε,
    has_type Γ St Δ e T ε →
    has_type Γ St Δ (expr.EProve e) (ty.TProof T) ε := by
  intro _ _ _ _ _ _ h; exact has_type.T_Prove h

-- Inl preserves effect.
/-- inl_preserves_effect (matches Coq) -/
theorem inl_preserves_effect : ∀ Γ St Δ e T1 T2 ε,
    has_type Γ St Δ e T1 ε →
    has_type Γ St Δ (expr.EInl e T2) (ty.TSum T1 T2) ε := by
  intro _ _ _ _ _ _ _ h; exact has_type.T_Inl h

-- Inr preserves effect.
/-- inr_preserves_effect (matches Coq) -/
theorem inr_preserves_effect : ∀ Γ St Δ e T1 T2 ε,
    has_type Γ St Δ e T2 ε →
    has_type Γ St Δ (expr.EInr e T1) (ty.TSum T1 T2) ε := by
  intro _ _ _ _ _ _ _ h; exact has_type.T_Inr h

-- ============================================================================
-- Reference effect theorems
-- ============================================================================

-- Ref always introduces at least EffWrite.
/-- ref_introduces_write (matches Coq) -/
theorem ref_introduces_write : ∀ Γ St Δ e l T ε,
    has_type Γ St Δ (expr.ERef e l) T ε →
    effect_leq EffWrite ε := by
  intro Γ St Δ e l T ε h
  cases h with
  | T_Ref h' =>
    simp only [eff_join]
    exact effect_join_ub_r _ EffWrite

-- Deref always introduces at least EffRead.
/-- deref_introduces_read (matches Coq) -/
theorem deref_introduces_read : ∀ Γ St Δ e T ε,
    has_type Γ St Δ (expr.EDeref e) T ε →
    effect_leq EffRead ε := by
  intro Γ St Δ e T ε h
  cases h with
  | T_Deref h' =>
    simp only [eff_join]
    exact effect_join_ub_r _ EffRead

-- Assign always introduces at least EffWrite.
/-- assign_introduces_write (matches Coq) -/
theorem assign_introduces_write : ∀ Γ St Δ e1 e2 T ε,
    has_type Γ St Δ (expr.EAssign e1 e2) T ε →
    effect_leq EffWrite ε := by
  intro Γ St Δ e1 e2 T ε h
  cases h with
  | T_Assign h1 h2 =>
    simp only [eff_join]
    exact effect_leq_trans EffWrite (effect_join _ EffWrite)
      (effect_join _ (effect_join _ EffWrite))
      (effect_join_ub_r _ EffWrite) (effect_join_ub_r _ _)

-- Ref cannot have pure effect.
/-- ref_not_pure (matches Coq) -/
theorem ref_not_pure : ∀ Γ St Δ e l T, ¬ has_type Γ St Δ (expr.ERef e l) T EffPure := by
  intro Γ St Δ e l T h
  have hw := ref_introduces_write Γ St Δ e l T EffPure h
  simp [effect_leq, effect_level] at hw

-- Deref cannot have pure effect.
/-- deref_not_pure (matches Coq) -/
theorem deref_not_pure : ∀ Γ St Δ e T, ¬ has_type Γ St Δ (expr.EDeref e) T EffPure := by
  intro Γ St Δ e T h
  have hr := deref_introduces_read Γ St Δ e T EffPure h
  simp [effect_leq, effect_level] at hr

-- Assign cannot have pure effect.
/-- assign_not_pure (matches Coq) -/
theorem assign_not_pure : ∀ Γ St Δ e1 e2 T, ¬ has_type Γ St Δ (expr.EAssign e1 e2) T EffPure := by
  intro Γ St Δ e1 e2 T h
  have hw := assign_introduces_write Γ St Δ e1 e2 T EffPure h
  simp [effect_leq, effect_level] at hw

-- Ref expression always has positive effect level
/-- ref_effect_level_positive (matches Coq) -/
theorem ref_effect_level_positive : ∀ Γ St Δ e l T ε,
    has_type Γ St Δ (expr.ERef e l) T ε →
    effect_level ε > 0 := by
  intro Γ St Δ e l T ε h
  have hw := ref_introduces_write Γ St Δ e l T ε h
  cases ε <;> simp_all [effect_leq, effect_level]

-- Deref expression always has positive effect level
/-- deref_effect_level_positive (matches Coq) -/
theorem deref_effect_level_positive : ∀ Γ St Δ e T ε,
    has_type Γ St Δ (expr.EDeref e) T ε →
    effect_level ε > 0 := by
  intro Γ St Δ e T ε h
  have hr := deref_introduces_read Γ St Δ e T ε h
  cases ε <;> simp_all [effect_leq, effect_level]

-- Assign expression always has positive effect level
/-- assign_effect_level_positive (matches Coq) -/
theorem assign_effect_level_positive : ∀ Γ St Δ e1 e2 T ε,
    has_type Γ St Δ (expr.EAssign e1 e2) T ε →
    effect_level ε > 0 := by
  intro Γ St Δ e1 e2 T ε h
  have hw := assign_introduces_write Γ St Δ e1 e2 T ε h
  cases ε <;> simp_all [effect_leq, effect_level]

-- ============================================================================
-- Combined nonpure theorems
-- ============================================================================

-- Ref and deref are both nonpure
/-- ref_deref_both_nonpure (matches Coq) -/
theorem ref_deref_both_nonpure : ∀ Γ St Δ e1 l1 e2 T1 T2 ε1 ε2,
    has_type Γ St Δ (expr.ERef e1 l1) T1 ε1 →
    has_type Γ St Δ (expr.EDeref e2) T2 ε2 →
    ε1 ≠ EffPure ∧ ε2 ≠ EffPure := by
  intro Γ St Δ e1 l1 e2 T1 T2 ε1 ε2 h1 h2
  constructor
  · intro heq; subst heq; exact ref_not_pure Γ St Δ e1 l1 T1 h1
  · intro heq; subst heq; exact deref_not_pure Γ St Δ e2 T2 h2

-- Assign and deref are both nonpure
/-- assign_deref_both_nonpure (matches Coq) -/
theorem assign_deref_both_nonpure : ∀ Γ St Δ e1 e2 e3 T1 T2 ε1 ε2,
    has_type Γ St Δ (expr.EAssign e1 e2) T1 ε1 →
    has_type Γ St Δ (expr.EDeref e3) T2 ε2 →
    ε1 ≠ EffPure ∧ ε2 ≠ EffPure := by
  intro Γ St Δ e1 e2 e3 T1 T2 ε1 ε2 h1 h2
  constructor
  · intro heq; subst heq; exact assign_not_pure Γ St Δ e1 e2 T1 h1
  · intro heq; subst heq; exact deref_not_pure Γ St Δ e3 T2 h2

end RIINA

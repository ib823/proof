-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.
import RIINA.Foundations.Syntax

/-!
# RIINA EffectAlgebra - Lean 4 Port

Port of 02_FORMAL/coq/effects/EffectAlgebra.v.

## Proved (44 theorems)
- Definitions: effect_leq, effect_meet, effect_lt
- Lattice: leq_refl, leq_trans, leq_antisym, leq_total, leq_dec
- Join: comm, assoc, idem, ub_l, ub_r, lub, mono_l, mono_r
- Join characterization: leq_iff, leq_iff_l, pure_l/r_general, level_join
- Meet: comm, assoc, idem, lb_l, lb_r, glb, level_meet
- Absorption: join_meet_absorb, meet_join_absorb
- Distributivity: join_meet_distr, meet_join_distr
- Bounds: pure_bottom, gapura_top, join_gapura, meet_pure, meet_gapura
- Injective: level_injective
- Strict: lt_irrefl, lt_trans, lt_leq, lt_leq_trans, leq_lt_trans
- Strict: trichotomy, lt_not_eq, lt_asymmetric, pure_lt_nonpure
-/

namespace RIINA

open effect

-- === Definitions ===

/-- effect_leq: e1 ≤ e2 iff effect_level e1 ≤ effect_level e2 -/
def effect_leq (e1 e2 : effect) : Prop :=
  effect_level e1 ≤ effect_level e2

/-- effect_meet: minimum of two effects by level -/
def effect_meet (e1 e2 : effect) : effect :=
  if Nat.blt (effect_level e1) (effect_level e2) then e1 else e2

/-- effect_lt: strict ordering on effects -/
def effect_lt (e1 e2 : effect) : Prop :=
  effect_level e1 < effect_level e2

-- === Core: effect_level is injective (each effect has a unique level 0–16) ===

theorem effect_level_injective : ∀ e1 e2, effect_level e1 = effect_level e2 → e1 = e2 := by
  intro e1 e2 h; cases e1 <;> cases e2 <;> simp_all [effect_level]

-- === Preorder / Partial Order ===

theorem effect_leq_refl : ∀ e, effect_leq e e := by
  intro e; simp [effect_leq]

theorem effect_leq_trans : ∀ e1 e2 e3, effect_leq e1 e2 → effect_leq e2 e3 → effect_leq e1 e3 := by
  intro _ _ _ h1 h2; simp [effect_leq] at *; omega

theorem effect_leq_antisym : ∀ e1 e2, effect_leq e1 e2 → effect_leq e2 e1 → e1 = e2 := by
  intro _ _ h1 h2; simp [effect_leq] at *
  exact effect_level_injective _ _ (by omega)

theorem effect_leq_total : ∀ e1 e2, effect_leq e1 e2 ∨ effect_leq e2 e1 := by
  intro e1 e2; simp only [effect_leq]; omega

def effect_leq_dec (e1 e2 : effect) : Decidable (effect_leq e1 e2) :=
  inferInstanceAs (Decidable (effect_level e1 ≤ effect_level e2))

-- === Join: commutativity, associativity, idempotence ===

theorem effect_join_comm : ∀ e1 e2, effect_join e1 e2 = effect_join e2 e1 := by
  intro e1 e2; cases e1 <;> cases e2 <;> rfl

theorem effect_join_assoc : ∀ e1 e2 e3,
    effect_join e1 (effect_join e2 e3) = effect_join (effect_join e1 e2) e3 := by
  intro e1 e2 e3; cases e1 <;> cases e2 <;> cases e3 <;> rfl

theorem effect_join_idem : ∀ e, effect_join e e = e := by
  intro e; cases e <;> rfl

-- === Join level ===

theorem effect_level_join : ∀ e1 e2,
    effect_level (effect_join e1 e2) = Nat.max (effect_level e1) (effect_level e2) := by
  intro e1 e2; cases e1 <;> cases e2 <;> rfl

-- === Join upper bounds and least upper bound ===

theorem effect_join_ub_l : ∀ e1 e2, effect_leq e1 (effect_join e1 e2) := by
  intro e1 e2; simp only [effect_leq, effect_join]
  split <;> simp_all [Nat.blt_eq] <;> omega

theorem effect_join_ub_r : ∀ e1 e2, effect_leq e2 (effect_join e1 e2) := by
  intro e1 e2; simp only [effect_leq, effect_join]
  split <;> simp_all [Nat.blt_eq] <;> omega

theorem effect_join_lub : ∀ e1 e2 e3, effect_leq e1 e3 → effect_leq e2 e3 →
    effect_leq (effect_join e1 e2) e3 := by
  intro e1 e2 e3 h1 h2; simp only [effect_leq, effect_join] at *
  split <;> simp_all [Nat.blt_eq] <;> omega

-- === Join monotonicity ===

theorem effect_join_mono_l : ∀ e1 e2 e3, effect_leq e1 e2 →
    effect_leq (effect_join e1 e3) (effect_join e2 e3) := by
  intro e1 e2 e3 h; simp only [effect_leq, effect_join] at *
  split <;> split <;> simp_all [Nat.blt_eq] <;> omega

theorem effect_join_mono_r : ∀ e1 e2 e3, effect_leq e1 e2 →
    effect_leq (effect_join e3 e1) (effect_join e3 e2) := by
  intro e1 e2 e3 h; simp only [effect_leq, effect_join] at *
  split <;> split <;> simp_all [Nat.blt_eq] <;> omega

-- === Join characterization ===

theorem effect_join_leq_iff : ∀ e1 e2, effect_join e1 e2 = e2 ↔ effect_leq e1 e2 := by
  intro e1 e2; cases e1 <;> cases e2 <;> simp [effect_join, effect_leq, effect_level, Nat.blt, Nat.ble]

theorem effect_join_leq_iff_l : ∀ e1 e2, effect_join e1 e2 = e1 ↔ effect_leq e2 e1 := by
  intro e1 e2; cases e1 <;> cases e2 <;> simp [effect_join, effect_leq, effect_level, Nat.blt, Nat.ble]

-- === Pure (bottom) and Gapura (top) ===

theorem effect_pure_bottom : ∀ e, effect_leq EffPure e := by
  intro e; simp [effect_leq, effect_level]

theorem effect_join_pure_l_general : ∀ e, effect_leq EffPure e → effect_join EffPure e = e := by
  intro e _; cases e <;> rfl

theorem effect_join_pure_r_general : ∀ e, effect_leq EffPure e → effect_join e EffPure = e := by
  intro e _; cases e <;> rfl

theorem effect_gapura_top : ∀ e, effect_leq e EffGapura := by
  intro e; cases e <;> simp [effect_leq, effect_level]

theorem effect_join_gapura : ∀ e, effect_join e EffGapura = EffGapura := by
  intro e; cases e <;> rfl

-- === Meet: commutativity, associativity, idempotence ===

theorem effect_meet_comm : ∀ e1 e2, effect_meet e1 e2 = effect_meet e2 e1 := by
  intro e1 e2; cases e1 <;> cases e2 <;> rfl

theorem effect_meet_assoc : ∀ e1 e2 e3,
    effect_meet e1 (effect_meet e2 e3) = effect_meet (effect_meet e1 e2) e3 := by
  intro e1 e2 e3; cases e1 <;> cases e2 <;> cases e3 <;> rfl

theorem effect_meet_idem : ∀ e, effect_meet e e = e := by
  intro e; cases e <;> rfl

-- === Meet level ===

theorem effect_level_meet : ∀ e1 e2,
    effect_level (effect_meet e1 e2) = Nat.min (effect_level e1) (effect_level e2) := by
  intro e1 e2; cases e1 <;> cases e2 <;> rfl

-- === Meet lower bounds and greatest lower bound ===

theorem effect_meet_lb_l : ∀ e1 e2, effect_leq (effect_meet e1 e2) e1 := by
  intro e1 e2; simp only [effect_leq, effect_meet]
  split <;> simp_all [Nat.blt_eq] <;> omega

theorem effect_meet_lb_r : ∀ e1 e2, effect_leq (effect_meet e1 e2) e2 := by
  intro e1 e2; simp only [effect_leq, effect_meet]
  split <;> simp_all [Nat.blt_eq] <;> omega

theorem effect_meet_glb : ∀ e1 e2 e3, effect_leq e3 e1 → effect_leq e3 e2 →
    effect_leq e3 (effect_meet e1 e2) := by
  intro e1 e2 e3 h1 h2; simp only [effect_leq, effect_meet] at *
  split <;> simp_all [Nat.blt_eq] <;> omega

-- === Meet with Pure / Gapura ===

theorem effect_meet_pure : ∀ e, effect_meet e EffPure = EffPure := by
  intro e; cases e <;> rfl

theorem effect_meet_gapura : ∀ e, effect_meet e EffGapura = e := by
  intro e; cases e <;> rfl

-- === Absorption laws ===

theorem effect_join_meet_absorb : ∀ e1 e2, effect_join e1 (effect_meet e1 e2) = e1 := by
  intro e1 e2; cases e1 <;> cases e2 <;> rfl

theorem effect_meet_join_absorb : ∀ e1 e2, effect_meet e1 (effect_join e1 e2) = e1 := by
  intro e1 e2; cases e1 <;> cases e2 <;> rfl

-- === Distributivity ===

theorem effect_join_meet_distr : ∀ e1 e2 e3,
    effect_join e1 (effect_meet e2 e3) = effect_meet (effect_join e1 e2) (effect_join e1 e3) := by
  intro e1 e2 e3; cases e1 <;> cases e2 <;> cases e3 <;> rfl

theorem effect_meet_join_distr : ∀ e1 e2 e3,
    effect_meet e1 (effect_join e2 e3) = effect_join (effect_meet e1 e2) (effect_meet e1 e3) := by
  intro e1 e2 e3; cases e1 <;> cases e2 <;> cases e3 <;> rfl

-- === Strict ordering ===

theorem effect_lt_irrefl : ∀ e, ¬ effect_lt e e := by
  intro e; simp [effect_lt]

theorem effect_lt_trans : ∀ e1 e2 e3, effect_lt e1 e2 → effect_lt e2 e3 → effect_lt e1 e3 := by
  intro _ _ _ h1 h2; simp [effect_lt] at *; omega

theorem effect_lt_leq : ∀ e1 e2, effect_lt e1 e2 → effect_leq e1 e2 := by
  intro _ _ h; simp [effect_lt, effect_leq] at *; omega

theorem effect_lt_leq_trans : ∀ e1 e2 e3, effect_lt e1 e2 → effect_leq e2 e3 → effect_lt e1 e3 := by
  intro _ _ _ h1 h2; simp [effect_lt, effect_leq] at *; omega

theorem effect_leq_lt_trans : ∀ e1 e2 e3, effect_leq e1 e2 → effect_lt e2 e3 → effect_lt e1 e3 := by
  intro _ _ _ h1 h2; simp [effect_lt, effect_leq] at *; omega

theorem effect_lt_asymmetric : ∀ e1 e2, effect_lt e1 e2 → ¬ effect_lt e2 e1 := by
  intro _ _ h1 h2; simp [effect_lt] at *; omega

theorem effect_trichotomy : ∀ e1 e2, effect_lt e1 e2 ∨ e1 = e2 ∨ effect_lt e2 e1 := by
  intro e1 e2; simp only [effect_lt]
  by_cases h : effect_level e1 < effect_level e2
  · exact Or.inl h
  · by_cases h2 : effect_level e1 = effect_level e2
    · exact Or.inr (Or.inl (effect_level_injective _ _ h2))
    · exact Or.inr (Or.inr (by omega))

theorem effect_lt_not_eq : ∀ e1 e2, effect_lt e1 e2 → e1 ≠ e2 := by
  intro _ _ hlt heq; subst heq; simp [effect_lt] at hlt

theorem effect_pure_lt_nonpure : ∀ e, e ≠ EffPure → effect_lt EffPure e := by
  intro e hne; cases e <;> simp_all [effect_lt, effect_level]

end RIINA

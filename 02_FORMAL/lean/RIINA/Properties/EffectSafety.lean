-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.
import RIINA.Foundations.Syntax
import RIINA.Foundations.Semantics
import RIINA.TypeSystem.Typing
import RIINA.Effects.EffectAlgebra

/-!
# RIINA EffectSafety - Lean 4 Port

Port of 02_FORMAL/coq/properties/EffectSafety.v (53 theorems).

## Proved Theorems
- Effect join inversion and non-purity lemmas
- Effect ordering (leq, lt) facts
- Effect join monotonicity and identity laws
- Effect level facts
- Canonical form: atomic values are pure
- Decidability of the value predicate
-/

namespace RIINA

open security_level effect effect_category taint_source sanitizer
     capability_kind capability ty session_type expr

-- If the join of two effects is EffPure, both must be EffPure.
-- This is because EffPure has level 0 (the minimum), and effect_join
-- takes the maximum.
/-- effect_join_pure_inv (matches Coq) -/
theorem effect_join_pure_inv : ∀ ε1 ε2, effect_join ε1 ε2 = EffPure → ε1 = EffPure ∧ ε2 = EffPure := by
  intro ε1 ε2 h
  cases ε1 <;> cases ε2 <;> simp_all [effect_join, effect_level, Nat.blt, Nat.ble]

-- Join with EffWrite is never pure.
/-- effect_join_write_not_pure (matches Coq) -/
theorem effect_join_write_not_pure : ∀ ε, effect_join ε EffWrite ≠ EffPure := by
  intro ε h
  cases ε <;> simp_all [effect_join, effect_level, Nat.blt, Nat.ble]

-- Join with EffRead is never pure.
/-- effect_join_read_not_pure (matches Coq) -/
theorem effect_join_read_not_pure : ∀ ε, effect_join ε EffRead ≠ EffPure := by
  intro ε h
  cases ε <;> simp_all [effect_join, effect_level, Nat.blt, Nat.ble]

-- The value predicate is decidable. This is useful for case analysis
-- in many proof contexts.
/-- value_dec (matches Coq) -/
theorem value_dec : ∀ e, value e ∨ ¬ value e := by
  intro e
  cases e with
  | EUnit => exact Or.inl value.VUnit
  | EBool b => exact Or.inl (value.VBool b)
  | EInt n => exact Or.inl (value.VInt n)
  | EString s => exact Or.inl (value.VString s)
  | ELoc l => exact Or.inl (value.VLoc l)
  | ELam x T body => exact Or.inl (value.VLam x T body)
  | EVar _ => exact Or.inr (fun h => nomatch h)
  | EApp _ _ => exact Or.inr (fun h => nomatch h)
  | EFst _ => exact Or.inr (fun h => nomatch h)
  | ESnd _ => exact Or.inr (fun h => nomatch h)
  | EIf _ _ _ => exact Or.inr (fun h => nomatch h)
  | ELet _ _ _ => exact Or.inr (fun h => nomatch h)
  | EPerform _ _ => exact Or.inr (fun h => nomatch h)
  | EHandle _ _ _ => exact Or.inr (fun h => nomatch h)
  | ERef _ _ => exact Or.inr (fun h => nomatch h)
  | EDeref _ => exact Or.inr (fun h => nomatch h)
  | EAssign _ _ => exact Or.inr (fun h => nomatch h)
  | EDeclassify _ _ => exact Or.inr (fun h => nomatch h)
  | ERequire _ _ => exact Or.inr (fun h => nomatch h)
  | EGrant _ _ => exact Or.inr (fun h => nomatch h)
  | ECase _ _ _ _ _ => exact Or.inr (fun h => nomatch h)
  | EPair e1 e2 =>
    -- EPair needs recursive decision; for now, left branch always works
    -- since we'd need to recurse. We'll use classical reasoning:
    exact Classical.em (value (EPair e1 e2))
  | EInl e T =>
    exact Classical.em (value (EInl e T))
  | EInr e T =>
    exact Classical.em (value (EInr e T))
  | EClassify e =>
    exact Classical.em (value (EClassify e))
  | EProve e =>
    exact Classical.em (value (EProve e))

-- The main theorem: if a closed expression is typed with EffPure,
-- then taking a step does not change the store.
--
-- Proof strategy: by induction on the step relation, inverting the
-- typing derivation to get effect constraints, and using
-- effect_join_pure_inv to show all sub-effects are pure.
-- The only step rules that change the store are ST_RefValue and
-- ST_AssignLoc, both of which require EffWrite in the typing
-- derivation, contradicting EffPure.
--
-- NOTE: This requires full preservation infrastructure (subject reduction).
-- Commenting out the deep theorems that need full induction on step/has_type
-- until that infrastructure is available. The key algebraic lemmas are all proved.

-- pure_step_preserves_store requires induction on step + type inversion
-- pure_step_preserves_ctx requires induction on step + type inversion
-- preservation_pure requires full subject reduction
-- pure_multi_step_preserves_store requires preservation_pure
-- multi_step_value_inv requires induction on multi_step + value inversion
-- pure_multi_step_preserves_ctx requires preservation_pure
-- pure_multi_step_compose is trivially rfl on st = st

-- Atomic values (non-compound) have EffPure effect.
/-- atomic_value_pure (matches Coq) -/
theorem atomic_value_pure : ∀ Γ St Δ v T ε, has_type Γ St Δ v T ε →
    (v = EUnit ∨ (∃ b, v = EBool b) ∨ (∃ n, v = EInt n) ∨
     (∃ s, v = EString s) ∨ (∃ l, v = ELoc l) ∨
     (∃ x T' body, v = ELam x T' body)) → ε = EffPure := by
  intro Γ St Δ v T ε htype hval
  rcases hval with rfl | ⟨b, rfl⟩ | ⟨n, rfl⟩ | ⟨s, rfl⟩ | ⟨l, rfl⟩ | ⟨x, T', body, rfl⟩
  · cases htype; rfl
  · cases htype; rfl
  · cases htype; rfl
  · cases htype; rfl
  · cases htype; rfl
  · cases htype; rfl

-- The EffPure effect is the only effect with level 0.
/-- effect_level_zero_is_pure (matches Coq) -/
theorem effect_level_zero_is_pure : ∀ ε, effect_level ε = 0 → ε = EffPure := by
  intro ε h; cases ε <;> simp_all [effect_level]

-- Effect join with any non-pure effect is non-pure.
/-- effect_join_nonpure (matches Coq) -/
theorem effect_join_nonpure : ∀ ε1 ε2, ε2 ≠ EffPure → effect_join ε1 ε2 ≠ EffPure := by
  intro ε1 ε2 hne heq
  have ⟨_, h2⟩ := effect_join_pure_inv ε1 ε2 heq
  exact hne h2

-- Effect join is monotone in both arguments:
-- if ε1 <= ε1' and ε2 <= ε2', then join(ε1, ε2) <= join(ε1', ε2').
/-- effect_join_monotone (matches Coq) -/
theorem effect_join_monotone : ∀ ε1 ε1' ε2 ε2',
    effect_leq ε1 ε1' → effect_leq ε2 ε2' →
    effect_leq (effect_join ε1 ε2) (effect_join ε1' ε2') := by
  intro ε1 ε1' ε2 ε2' h1 h2
  simp only [effect_leq, effect_join] at *
  split <;> split <;> simp_all [Nat.blt_eq] <;> omega

-- Effect join is monotone in the left argument.
/-- effect_join_mono_l (matches Coq) -/
theorem effect_join_mono_l_es : ∀ ε1 ε1' ε2,
    effect_leq ε1 ε1' → effect_leq (effect_join ε1 ε2) (effect_join ε1' ε2) := by
  intro ε1 ε1' ε2 h
  exact effect_join_monotone ε1 ε1' ε2 ε2 h (effect_leq_refl ε2)

-- Effect join is monotone in the right argument.
/-- effect_join_mono_r (matches Coq) -/
theorem effect_join_mono_r_es : ∀ ε1 ε2 ε2',
    effect_leq ε2 ε2' → effect_leq (effect_join ε1 ε2) (effect_join ε1 ε2') := by
  intro ε1 ε2 ε2' h
  exact effect_join_monotone ε1 ε1 ε2 ε2' (effect_leq_refl ε1) h

-- EffPure is the bottom element.
/-- effect_leq_pure (matches Coq) -/
theorem effect_leq_pure_es : ∀ ε, effect_leq EffPure ε := by
  exact effect_pure_bottom

-- EffRead is below EffWrite.
/-- read_leq_write (matches Coq) -/
theorem read_leq_write : effect_leq EffRead EffWrite := by
  simp [effect_leq, effect_level]

-- EffWrite subsumes EffRead under join.
/-- write_subsumes_read (matches Coq) -/
theorem write_subsumes_read : effect_join EffRead EffWrite = EffWrite := by
  rfl

-- EffFileSystem is between Write and Network in the hierarchy.
/-- write_leq_filesystem (matches Coq) -/
theorem write_leq_filesystem : effect_leq EffWrite EffFileSystem := by
  simp [effect_leq, effect_level]

-- EffPure is below EffRead.
/-- pure_leq_read (matches Coq) -/
theorem pure_leq_read : effect_leq EffPure EffRead := by
  simp [effect_leq, effect_level]

-- EffPure is below EffWrite.
/-- pure_leq_write (matches Coq) -/
theorem pure_leq_write : effect_leq EffPure EffWrite := by
  simp [effect_leq, effect_level]

-- Read and Write are not equal.
/-- read_neq_write (matches Coq) -/
theorem read_neq_write : EffRead ≠ EffWrite := by
  intro h; cases h

-- EffPure is the left identity for join (renamed to avoid conflict with Syntax.lean).
/-- effect_join_pure_l_es (matches Coq) -/
theorem effect_join_pure_l_es : ∀ ε, effect_join EffPure ε = ε := by
  intro ε; cases ε <;> rfl

-- Effect join is idempotent.
/-- effect_join_idem (matches Coq) -/
theorem effect_join_idem_es : ∀ ε, effect_join ε ε = ε := by
  intro ε; cases ε <;> rfl

-- Every base-type value (unit, bool, int, string, loc, lam) is typed with EffPure.
/-- base_value_always_pure (matches Coq) -/
theorem base_value_always_pure : ∀ Γ St Δ v T ε, has_type Γ St Δ v T ε →
    (v = EUnit ∨ (∃ b, v = EBool b) ∨ (∃ n, v = EInt n) ∨
     (∃ s, v = EString s) ∨ (∃ l, v = ELoc l) ∨
     (∃ x T' body, v = ELam x T' body)) → ε = EffPure := by
  exact atomic_value_pure

-- All non-pure base effects are distinct from EffPure.
/-- effect_read_not_pure (matches Coq) -/
theorem effect_read_not_pure : EffRead ≠ EffPure := by
  intro h; cases h

/-- effect_write_not_pure (matches Coq) -/
theorem effect_write_not_pure : EffWrite ≠ EffPure := by
  intro h; cases h

/-- effect_filesystem_not_pure (matches Coq) -/
theorem effect_filesystem_not_pure : EffFileSystem ≠ EffPure := by
  intro h; cases h

/-- effect_network_not_pure (matches Coq) -/
theorem effect_network_not_pure : EffNetwork ≠ EffPure := by
  intro h; cases h

/-- effect_system_not_pure (matches Coq) -/
theorem effect_system_not_pure : EffSystem ≠ EffPure := by
  intro h; cases h

/-- effect_crypto_not_pure (matches Coq) -/
theorem effect_crypto_not_pure : EffCrypto ≠ EffPure := by
  intro h; cases h

/-- effect_random_not_pure (matches Coq) -/
theorem effect_random_not_pure : EffRandom ≠ EffPure := by
  intro h; cases h

/-- effect_time_not_pure (matches Coq) -/
theorem effect_time_not_pure : EffTime ≠ EffPure := by
  intro h; cases h

/-- effect_process_not_pure (matches Coq) -/
theorem effect_process_not_pure : EffProcess ≠ EffPure := by
  intro h; cases h

/-- effect_netsecure_not_pure (matches Coq) -/
theorem effect_netsecure_not_pure : EffNetSecure ≠ EffPure := by
  intro h; cases h

/-- effect_level_pure (matches Coq) -/
theorem effect_level_pure : effect_level EffPure = 0 := by
  rfl

/-- effect_level_read (matches Coq) -/
theorem effect_level_read : effect_level EffRead = 1 := by
  rfl

/-- effect_level_write (matches Coq) -/
theorem effect_level_write : effect_level EffWrite = 2 := by
  rfl

-- Pure is minimal effect
/-- effect_level_pure_min (matches Coq) -/
theorem effect_level_pure_min : ∀ ε, effect_level EffPure ≤ effect_level ε := by
  intro ε; simp [effect_level]

/-- pure_leq_filesystem (matches Coq) -/
theorem pure_leq_filesystem : effect_leq EffPure EffFileSystem := by
  simp [effect_leq, effect_level]

/-- read_leq_filesystem (matches Coq) -/
theorem read_leq_filesystem : effect_leq EffRead EffFileSystem := by
  simp [effect_leq, effect_level]

/-- pure_leq_network (matches Coq) -/
theorem pure_leq_network : effect_leq EffPure EffNetwork := by
  simp [effect_leq, effect_level]

/-- pure_leq_crypto (matches Coq) -/
theorem pure_leq_crypto : effect_leq EffPure EffCrypto := by
  simp [effect_leq, effect_level]

/-- effect_join_pure_pure (matches Coq) -/
theorem effect_join_pure_pure : effect_join EffPure EffPure = EffPure := by
  rfl

/-- pure_lt_read (matches Coq) -/
theorem pure_lt_read : effect_level EffPure < effect_level EffRead := by
  simp [effect_level]

/-- read_lt_write (matches Coq) -/
theorem read_lt_write : effect_level EffRead < effect_level EffWrite := by
  simp [effect_level]

-- An effect is at most the join with any other effect
/-- effect_leq_join_l (matches Coq) -/
theorem effect_leq_join_l : ∀ ε1 ε2, effect_leq ε1 (effect_join ε1 ε2) := by
  exact effect_join_ub_l

/-- effect_leq_join_r (matches Coq) -/
theorem effect_leq_join_r : ∀ ε1 ε2, effect_leq ε2 (effect_join ε1 ε2) := by
  exact effect_join_ub_r

-- Join with EffNetwork is never pure
/-- effect_join_network_not_pure (matches Coq) -/
theorem effect_join_network_not_pure : ∀ ε, effect_join ε EffNetwork ≠ EffPure := by
  intro ε h
  cases ε <;> simp_all [effect_join, effect_level, Nat.blt, Nat.ble]

-- Positive level implies not pure
/-- effect_level_positive_not_pure (matches Coq) -/
theorem effect_level_positive_not_pure : ∀ ε, effect_level ε > 0 → ε ≠ EffPure := by
  intro ε hgt heq; subst heq; simp [effect_level] at hgt

-- EffPure is the right identity for join (renamed to avoid conflict with Syntax.lean).
/-- effect_join_pure_r_es (matches Coq) -/
theorem effect_join_pure_r_es : ∀ ε, effect_join ε EffPure = ε := by
  intro ε; cases ε <;> rfl

end RIINA

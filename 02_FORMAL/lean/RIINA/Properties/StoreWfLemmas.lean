-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.
import RIINA.Foundations.Syntax
import RIINA.Foundations.Semantics
import RIINA.TypeSystem.Typing

/-!
# RIINA StoreWfLemmas - Lean 4 Port

Port of 02_FORMAL/coq/properties/StoreWfLemmas.v (31 theorems).

## Correspondence Table

| Coq Definition | Lean Definition | Status |
|----------------|-----------------|--------|
| store_wf_lookup_value | store_wf_lookup_value | OK |
| store_wf_lookup_typed | store_wf_lookup_typed | OK |
| store_wf_typed_loc_has_value | store_wf_typed_loc_has_value | OK |
| store_wf_typed_loc_gives_typed_value | store_wf_typed_loc_gives_typed_value | OK |
| store_wf_forward | store_wf_forward | OK |
| store_wf_backward | store_wf_backward | OK |
| store_wf_empty | store_wf_empty | OK |
| store_wf_empty_ty_no_values | store_wf_empty_ty_no_values | OK |
| store_wf_lookup_agree | store_wf_lookup_agree | OK |
| store_wf_all_pure | store_wf_all_pure | OK |
| store_wf_lookup_is_value | store_wf_lookup_is_value | OK |
| store_wf_extends_forward | store_wf_extends_forward | OK |
| store_wf_loc_not_in_ty | store_wf_loc_not_in_ty | OK |
| store_wf_typed_implies_stored | store_wf_typed_implies_stored | OK |
| store_wf_stored_implies_typed | store_wf_stored_implies_typed | OK |
| store_wf_update_same_type | store_wf_update_same_type | OK |
| store_wf_characterize | store_wf_characterize | OK |
| store_wf_implies_has_values | store_wf_implies_has_values | OK |
| store_wf_extends_lookup_typed | store_wf_extends_lookup_typed | OK |
| store_wf_preserved_by_step | store_wf_preserved_by_step | COMMENTED (requires preservation theorem) |
| store_wf_lookup_value_and_typed | store_wf_lookup_value_and_typed | OK |
| store_wf_domain_iff | store_wf_domain_iff | OK |
| store_wf_extends_preserves_has_values | store_wf_extends_preserves_has_values | OK |
| store_wf_ty_lookup_implies_st_lookup | store_wf_ty_lookup_implies_st_lookup | OK |
| store_wf_empty_ty_no_typed_locs | store_wf_empty_ty_no_typed_locs | OK |
| store_wf_none_implies_ty_none | store_wf_none_implies_ty_none | OK |
| store_wf_ty_none_implies_none | store_wf_ty_none_implies_none | OK |
| store_wf_absent_agree | store_wf_absent_agree | OK |
| store_wf_lookup_has_type | store_wf_lookup_has_type | OK |
| store_wf_ty_deterministic | store_wf_ty_deterministic | OK |
-/

namespace RIINA

open security_level effect effect_category taint_source sanitizer
     capability_kind capability ty session_type expr

-- Store well-formedness implies stored expressions are values
/-- store_wf_lookup_value (matches Coq) -/
theorem store_wf_lookup_value :
    ∀ St st l v, store_wf St st → store_lookup l st = some v → value v := by
  intro St st l v hwf hlook
  obtain ⟨T, sl, _, hval, _⟩ := hwf.2 l v hlook
  exact hval

-- Store well-formedness implies stored expressions are well-typed
/-- store_wf_lookup_typed (matches Coq) -/
theorem store_wf_lookup_typed :
    ∀ St st l v, store_wf St st → store_lookup l st = some v →
    ∃ T sl, store_ty_lookup l St = some (T, sl) ∧ has_type [] St LPublic v T EffPure := by
  intro St st l v hwf hlook
  obtain ⟨T, sl, hty, _, htyp⟩ := hwf.2 l v hlook
  exact ⟨T, sl, hty, htyp⟩

-- For typed locations, lookup succeeds with a value
/-- store_wf_typed_loc_has_value (matches Coq) -/
theorem store_wf_typed_loc_has_value :
    ∀ St st l T sl, store_wf St st → store_ty_lookup l St = some (T, sl) →
    ∃ v, store_lookup l st = some v ∧ value v := by
  intro St st l T sl hwf hty
  obtain ⟨v, hlook, hval, _⟩ := hwf.1 l T sl hty
  exact ⟨v, hlook, hval⟩

-- Combined: typed location lookup gives typed value
/-- store_wf_typed_loc_gives_typed_value (matches Coq) -/
theorem store_wf_typed_loc_gives_typed_value :
    ∀ St st l T sl, store_wf St st → store_ty_lookup l St = some (T, sl) →
    ∃ v, store_lookup l st = some v ∧ value v ∧ has_type [] St LPublic v T EffPure := by
  intro St st l T sl hwf hty
  exact hwf.1 l T sl hty

-- Forward direction: store_wf implies domain correspondence
/-- store_wf_forward (matches Coq) -/
theorem store_wf_forward :
    ∀ St st, store_wf St st → ∀ l T sl, store_ty_lookup l St = some (T, sl) →
    ∃ v, store_lookup l st = some v ∧ value v ∧ has_type [] St LPublic v T EffPure := by
  intro St st hwf l T sl hty
  exact hwf.1 l T sl hty

-- Backward direction: store_wf implies runtime values are typed
/-- store_wf_backward (matches Coq) -/
theorem store_wf_backward :
    ∀ St st, store_wf St st → ∀ l v, store_lookup l st = some v →
    ∃ T sl, store_ty_lookup l St = some (T, sl) ∧ value v ∧ has_type [] St LPublic v T EffPure := by
  intro St st hwf l v hlook
  exact hwf.2 l v hlook

-- Empty store is well-formed with empty store typing
/-- store_wf_empty (matches Coq) -/
theorem store_wf_empty : store_wf [] [] := by
  constructor
  · intro l T sl h; simp [store_ty_lookup] at h
  · intro l v h; simp [store_lookup] at h

-- Empty store typing means empty store (forward)
/-- store_wf_empty_ty_no_values (matches Coq) -/
theorem store_wf_empty_ty_no_values :
    ∀ st, store_wf [] st →
    ∀ l v, store_lookup l st = none ∨ ¬ value v ∨ store_lookup l st ≠ some v := by
  intro st hwf l v
  match h : store_lookup l st with
  | none => exact Or.inl rfl
  | some w =>
    obtain ⟨T, sl, hty, _, _⟩ := hwf.2 l w h
    simp [store_ty_lookup] at hty

-- If two stores agree on all lookups, wf transfers
/-- store_wf_lookup_agree (matches Coq) -/
theorem store_wf_lookup_agree :
    ∀ St st1 st2, store_wf St st1 →
    (∀ l, store_lookup l st1 = store_lookup l st2) → store_wf St st2 := by
  intro St st1 st2 hwf hagree
  constructor
  · intro l T sl hty
    obtain ⟨v, hlook, hval, htyp⟩ := hwf.1 l T sl hty
    exact ⟨v, (hagree l) ▸ hlook, hval, htyp⟩
  · intro l v hlook
    have hlook' : store_lookup l st1 = some v := by rw [hagree]; exact hlook
    exact hwf.2 l v hlook'

-- All values in a well-formed store are typed with pure effect
/-- store_wf_all_pure (matches Coq) -/
theorem store_wf_all_pure :
    ∀ St st l v, store_wf St st → store_lookup l st = some v →
    ∃ T, has_type [] St LPublic v T EffPure := by
  intro St st l v hwf hlook
  obtain ⟨T, _, _, _, htyp⟩ := hwf.2 l v hlook
  exact ⟨T, htyp⟩

-- Values in well-formed stores are always values (tautological but useful)
/-- store_wf_lookup_is_value (matches Coq) -/
theorem store_wf_lookup_is_value :
    ∀ St st l v, store_wf St st → store_lookup l st = some v → value v := by
  intro St st l v hwf hlook
  obtain ⟨_, _, _, hval, _⟩ := hwf.2 l v hlook
  exact hval

-- If St extends to St' and we have WF for St, the forward property
-- partially transfers (we still find the same values)
/-- store_wf_extends_forward (matches Coq) -/
theorem store_wf_extends_forward :
    ∀ St St' st l T sl, store_wf St st → store_ty_extends St St' →
    store_ty_lookup l St = some (T, sl) →
    ∃ v, store_lookup l st = some v ∧ value v := by
  intro St St' st l T sl hwf _ hty
  obtain ⟨v, hlook, hval, _⟩ := hwf.1 l T sl hty
  exact ⟨v, hlook, hval⟩

-- Location not in store typing means not required for WF
/-- store_wf_loc_not_in_ty (matches Coq) -/
theorem store_wf_loc_not_in_ty :
    ∀ St st l, store_wf St st → store_ty_lookup l St = none →
    ∀ T sl, ¬ (store_ty_lookup l St = some (T, sl)) := by
  intro _ _ _ _ hnone T sl hsome
  rw [hnone] at hsome
  exact Option.noConfusion hsome

-- Typed locations always have runtime values
/-- store_wf_typed_implies_stored (matches Coq) -/
theorem store_wf_typed_implies_stored :
    ∀ St st l, store_wf St st → (∃ T sl, store_ty_lookup l St = some (T, sl)) →
    ∃ v, store_lookup l st = some v := by
  intro St st l hwf ⟨T, sl, hty⟩
  obtain ⟨v, hlook, _, _⟩ := hwf.1 l T sl hty
  exact ⟨v, hlook⟩

-- Stored values always have types
/-- store_wf_stored_implies_typed (matches Coq) -/
theorem store_wf_stored_implies_typed :
    ∀ St st l v, store_wf St st → store_lookup l st = some v →
    ∃ T sl, store_ty_lookup l St = some (T, sl) := by
  intro St st l v hwf hlook
  obtain ⟨T, sl, hty, _, _⟩ := hwf.2 l v hlook
  exact ⟨T, sl, hty⟩

-- Helper: looking up the updated location returns the new value
private theorem store_update_lookup_eq (l : loc) (v : expr) :
    ∀ (st : store), (∃ w, store_lookup l st = some w) →
    store_lookup l (store_update l v st) = some v
  | [], ⟨_, hw⟩ => by simp [store_lookup] at hw
  | (l', _) :: st', hex => by
    simp only [store_update]
    by_cases heq : l = l'
    · subst heq; simp [store_lookup]
    · have hbeq : (l == l') = false := by simp [heq]
      simp only [hbeq, Bool.false_eq_true, ite_false, store_lookup]
      apply store_update_lookup_eq
      obtain ⟨w, hw⟩ := hex
      simp [store_lookup, hbeq] at hw
      exact ⟨w, hw⟩

-- Helper: looking up a different location is unchanged by update
private theorem store_update_lookup_ne (l l' : loc) (v : expr) (hne : l ≠ l') :
    ∀ (st : store), store_lookup l' (store_update l v st) = store_lookup l' st
  | [] => by
    simp [store_update, store_lookup]
    intro h; exact absurd h.symm hne
  | (l'', _) :: st' => by
    simp only [store_update]
    by_cases heq : l = l''
    · subst heq
      simp only [beq_self_eq_true, ite_true, store_lookup]
      have hbeq' : (l' == l) = false := by simp [Ne.symm hne]
      simp [hbeq']
    · have hbeq : (l == l'') = false := by simp [heq]
      simp only [hbeq, Bool.false_eq_true, ite_false, store_lookup]
      by_cases heq' : l' = l''
      · subst heq'; simp
      · have hbeq' : (l' == l'') = false := by simp [heq']
        simp only [hbeq', Bool.false_eq_true, ite_false]
        exact store_update_lookup_ne l l' v hne st'

-- Updating a location with a value of the same type preserves WF
/-- store_wf_update_same_type (matches Coq) -/
theorem store_wf_update_same_type :
    ∀ St st l v T sl, store_wf St st → store_ty_lookup l St = some (T, sl) →
    value v → has_type [] St LPublic v T EffPure →
    store_wf St (store_update l v st) := by
  intro St st l v T sl hwf hty hval htyp
  constructor
  · -- Forward: typed location has value in updated store
    intro l' T' sl' hty'
    by_cases heq : l = l'
    · -- l = l' : the updated location
      subst heq
      have hsame : some (T', sl') = some (T, sl) := hty' ▸ hty
      have := Option.some.inj hsame
      cases this
      obtain ⟨w, hw, _, _⟩ := hwf.1 l T sl hty
      exact ⟨v, store_update_lookup_eq l v st ⟨w, hw⟩, hval, htyp⟩
    · -- l ≠ l' : unchanged location
      obtain ⟨w, hw, hwval, hwtyp⟩ := hwf.1 l' T' sl' hty'
      have : store_lookup l' (store_update l v st) = store_lookup l' st :=
        store_update_lookup_ne l l' v heq st
      rw [this]
      exact ⟨w, hw, hwval, hwtyp⟩
  · -- Backward: value in updated store has a type
    intro l' w hlook
    by_cases heq : l = l'
    · -- l = l' : the updated location
      subst heq
      obtain ⟨w', hw', _, _⟩ := hwf.1 l T sl hty
      have hup : store_lookup l (store_update l v st) = some v :=
        store_update_lookup_eq l v st ⟨w', hw'⟩
      have heqw : w = v := Option.some.inj (hlook ▸ hup)
      subst heqw
      exact ⟨T, sl, hty, hval, htyp⟩
    · -- l ≠ l' : unchanged location
      have : store_lookup l' (store_update l v st) = store_lookup l' st :=
        store_update_lookup_ne l l' v heq st
      rw [this] at hlook
      exact hwf.2 l' w hlook

-- Full characterization: store_wf is equivalent to bidirectional correspondence
/-- store_wf_characterize (matches Coq) -/
theorem store_wf_characterize :
    ∀ St st, store_wf St st ↔
    ((∀ l T sl, store_ty_lookup l St = some (T, sl) →
      ∃ v, store_lookup l st = some v ∧ value v ∧ has_type [] St LPublic v T EffPure) ∧
     (∀ l v, store_lookup l st = some v →
      ∃ T sl, store_ty_lookup l St = some (T, sl) ∧ value v ∧ has_type [] St LPublic v T EffPure)) := by
  intro St st
  exact Iff.rfl

-- store_has_values follows from store_wf
/-- store_wf_implies_has_values (matches Coq) -/
theorem store_wf_implies_has_values :
    ∀ St st, store_wf St st → store_has_values st := by
  intro St st hwf l v hlook
  obtain ⟨_, _, _, hval, _⟩ := hwf.2 l v hlook
  exact hval

-- NOTE: store_has_values_empty is already defined in Semantics.lean,
-- so we do not re-declare it here.

-- If St' extends St and store_wf St st, then forward property
-- holds for all St-typed locations in St'
/-- store_wf_extends_lookup_typed (matches Coq) -/
theorem store_wf_extends_lookup_typed :
    ∀ St St' st l T sl, store_wf St st → store_ty_extends St St' →
    store_ty_lookup l St = some (T, sl) →
    ∃ v, store_lookup l st = some v ∧ value v ∧ has_type [] St' LPublic v T EffPure := by
  intro St St' st l T sl hwf hext hty
  obtain ⟨v, hlook, hval, htyp⟩ := hwf.1 l T sl hty
  exact ⟨v, hlook, hval, has_type_store_weaken htyp hext⟩

-- Store well-formedness is preserved by evaluation steps
-- NOTE: This theorem requires the full type preservation theorem (which
-- itself depends on many other lemmas). Commented out.
/-
/-- store_wf_preserved_by_step (matches Coq) -/
theorem store_wf_preserved_by_step :
    ∀ e e' T ε st st' ctx ctx' St,
    has_type [] St LPublic e T ε → store_wf St st →
    (e, st, ctx) -→ (e', st', ctx') →
    ∃ St', store_wf St' st' ∧ store_ty_extends St St' := by
  sorry
-/

-- If a value is in a well-formed store, it is both a value and well-typed
/-- store_wf_lookup_value_and_typed (matches Coq) -/
theorem store_wf_lookup_value_and_typed :
    ∀ St st l v, store_wf St st → store_lookup l st = some v →
    value v ∧ ∃ T, has_type [] St LPublic v T EffPure := by
  intro St st l v hwf hlook
  obtain ⟨T, _, _, hval, htyp⟩ := hwf.2 l v hlook
  exact ⟨hval, T, htyp⟩

-- A location has a runtime value iff it has a type assignment
/-- store_wf_domain_iff (matches Coq) -/
theorem store_wf_domain_iff :
    ∀ St st l, store_wf St st →
    ((∃ v, store_lookup l st = some v) ↔ (∃ T sl, store_ty_lookup l St = some (T, sl))) := by
  intro St st l hwf
  constructor
  · intro ⟨v, hlook⟩
    obtain ⟨T, sl, hty, _, _⟩ := hwf.2 l v hlook
    exact ⟨T, sl, hty⟩
  · intro ⟨T, sl, hty⟩
    obtain ⟨v, hlook, _, _⟩ := hwf.1 l T sl hty
    exact ⟨v, hlook⟩

/-- store_wf_extends_preserves_has_values (matches Coq) -/
theorem store_wf_extends_preserves_has_values :
    ∀ St St' st, store_wf St st → store_ty_extends St St' → store_has_values st := by
  intro St _ st hwf _
  exact store_wf_implies_has_values St st hwf

-- Type assignment implies runtime value exists
/-- store_wf_ty_lookup_implies_st_lookup (matches Coq) -/
theorem store_wf_ty_lookup_implies_st_lookup :
    ∀ St st l T sl, store_wf St st → store_ty_lookup l St = some (T, sl) →
    ∃ v, store_lookup l st = some v := by
  intro St st l T sl hwf hty
  obtain ⟨v, hlook, _, _⟩ := hwf.1 l T sl hty
  exact ⟨v, hlook⟩

-- With empty type mapping, no location is typed
/-- store_wf_empty_ty_no_typed_locs (matches Coq) -/
theorem store_wf_empty_ty_no_typed_locs :
    ∀ st l T sl, store_wf [] st → store_ty_lookup l ([] : store_ty) ≠ some (T, sl) := by
  intro _ _ _ _ _ h
  simp [store_ty_lookup] at h

-- If no value at location, then no type assignment either
/-- store_wf_none_implies_ty_none (matches Coq) -/
theorem store_wf_none_implies_ty_none :
    ∀ St st l, store_wf St st → store_lookup l st = none → store_ty_lookup l St = none := by
  intro St st l hwf hlook
  match hty : store_ty_lookup l St with
  | none => rfl
  | some (T, sl) =>
    obtain ⟨v, hvlook, _, _⟩ := hwf.1 l T sl hty
    rw [hvlook] at hlook
    exact absurd hlook (Option.noConfusion)

-- If no type assignment, then no runtime value
/-- store_wf_ty_none_implies_none (matches Coq) -/
theorem store_wf_ty_none_implies_none :
    ∀ St st l, store_wf St st → store_ty_lookup l St = none → store_lookup l st = none := by
  intro St st l hwf hty
  match hlook : store_lookup l st with
  | none => rfl
  | some v =>
    obtain ⟨T, sl, htyp, _, _⟩ := hwf.2 l v hlook
    rw [hty] at htyp
    exact absurd htyp (Option.noConfusion)

-- Absence is bidirectional
/-- store_wf_absent_agree (matches Coq) -/
theorem store_wf_absent_agree :
    ∀ St st l, store_wf St st →
    (store_lookup l st = none ↔ store_ty_lookup l St = none) := by
  intro St st l hwf
  constructor
  · exact store_wf_none_implies_ty_none St st l hwf
  · exact store_wf_ty_none_implies_none St st l hwf

-- Direct typing from both lookups
/-- store_wf_lookup_has_type (matches Coq) -/
theorem store_wf_lookup_has_type :
    ∀ St st l v T sl, store_wf St st → store_lookup l st = some v →
    store_ty_lookup l St = some (T, sl) → has_type [] St LPublic v T EffPure := by
  intro St st l v T sl hwf hlook hty
  obtain ⟨v', hlook', _, htyp⟩ := hwf.1 l T sl hty
  have : v = v' := by rw [hlook] at hlook'; exact Option.some.inj hlook'
  rw [this]
  exact htyp

-- Type assignment is functionally determined by location
/-- store_wf_ty_deterministic (matches Coq) -/
theorem store_wf_ty_deterministic :
    ∀ St st l v T1 sl1 T2 sl2, store_wf St st → store_lookup l st = some v →
    store_ty_lookup l St = some (T1, sl1) → store_ty_lookup l St = some (T2, sl2) →
    T1 = T2 ∧ sl1 = sl2 := by
  intro St st l v T1 sl1 T2 sl2 _ _ h1 h2
  have heq := Option.some.inj (h1 ▸ h2)
  cases heq
  exact ⟨rfl, rfl⟩

end RIINA

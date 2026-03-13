-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.
import RIINA.Foundations.Syntax
import RIINA.Foundations.Semantics
import RIINA.TypeSystem.Typing

/-!
# RIINA StoreSafety - Lean 4 Port

Port of 02_FORMAL/coq/properties/StoreSafety.v (32 theorems).
All proofs verified — zero proof gaps.

## Correspondence Table

| Coq Definition | Lean Definition | Status |
|----------------|-----------------|--------|
| store_extend_after_alloc | store_extend_after_alloc | OK |
| store_lookup_after_update | store_lookup_after_update | OK |
| store_lookup_update_other | store_lookup_update_other | OK |
| store_ty_update_same | store_ty_update_same | OK |
| store_ty_update_other | store_ty_update_other | OK |
| store_extend_compose | store_extend_compose | OK |
| store_extend_antisym_lookup | store_extend_antisym_lookup | OK |
| typing_monotone_store | typing_monotone_store | OK |
| loc_typed_under_extension | loc_typed_under_extension | OK |
| value_typed_under_extension | value_typed_under_extension | OK |
| store_wf_values_pure | store_wf_values_pure | OK |
| store_wf_all_values | store_wf_all_values | OK |
| store_wf_typed_implies_stored | store_wf_typed_implies_stored | OK |
| store_wf_stored_implies_typed | store_wf_stored_implies_typed | OK |
| store_ty_lookup_dec | store_ty_lookup_dec | OK |
| loc_eq_dec | loc_eq_dec | OK |
| store_ty_update_commute_lookup | store_ty_update_commute_lookup | OK |
| store_wf_empty | store_wf_empty | OK |
| typing_under_alloc | typing_under_alloc | OK |
| typing_under_double_alloc | typing_under_double_alloc | OK |
| store_wf_extends_typed | store_wf_extends_typed | OK |
| fresh_loc_store_ty_none | fresh_loc_store_ty_none | OK |
| fresh_loc_store_none | fresh_loc_store_none | OK |
| store_wf_all_well_typed | store_wf_all_well_typed | OK |
| store_ty_in_extends | store_ty_in_extends | OK |
| store_ty_not_in_extends | store_ty_not_in_extends | OK |
| store_ty_extends_update_both | store_ty_extends_update_both | OK |
| store_ty_extends_preserves_lookup | store_ty_extends_preserves_lookup | OK |
| store_ty_extends_same_type | store_ty_extends_same_type | OK |
| store_ty_update_lookup_same | store_ty_update_lookup_same | OK |
| store_ty_extends_reflexive | store_ty_extends_reflexive | OK |
| store_ty_extends_chain | store_ty_extends_chain | OK |
-/

namespace RIINA

open security_level effect effect_category taint_source sanitizer
     capability_kind capability ty session_type expr

-- ============================================================================
-- Private helper lemmas for store_ty_lookup / store_ty_update / store_lookup
-- ============================================================================

/-- Looking up the same location that was just updated returns the new entry (store typing). -/
private theorem sty_update_same (l : loc) (T : ty) (sl : security_level) :
    ∀ (St : store_ty), store_ty_lookup l (store_ty_update l T sl St) = some (T, sl)
  | [] => by
    show (if l = l then some (T, sl) else store_ty_lookup l []) = some (T, sl); simp
  | (l', T', sl') :: rest => by
    show store_ty_lookup l (if l = l' then (l, T, sl) :: rest
           else (l', T', sl') :: store_ty_update l T sl rest) = some (T, sl)
    by_cases h : l = l'
    · simp only [if_pos h]
      show (if l = l then some (T, sl) else store_ty_lookup l rest) = some (T, sl); simp
    · simp only [if_neg h]
      show (if l = l' then some (T', sl') else
             store_ty_lookup l (store_ty_update l T sl rest)) = some (T, sl)
      simp [h, sty_update_same l T sl rest]

/-- Looking up a different location after an update is unchanged (store typing). -/
private theorem sty_update_other (l la : loc) (T : ty) (sl : security_level) (hneq : l ≠ la) :
    ∀ (St : store_ty), store_ty_lookup l (store_ty_update la T sl St) = store_ty_lookup l St
  | [] => by
    show (if l = la then some (T, sl) else store_ty_lookup l []) = store_ty_lookup l []
    simp [hneq]
  | (l', T', sl') :: rest => by
    show store_ty_lookup l (if la = l' then (la, T, sl) :: rest
           else (l', T', sl') :: store_ty_update la T sl rest) =
         (if l = l' then some (T', sl') else store_ty_lookup l rest)
    by_cases ha : la = l'
    · simp only [if_pos ha]
      show (if l = la then some (T, sl) else store_ty_lookup l rest) =
           (if l = l' then some (T', sl') else store_ty_lookup l rest)
      have hne' : l ≠ l' := by rw [← ha]; exact hneq
      simp [hneq, hne']
    · simp only [if_neg ha]
      show (if l = l' then some (T', sl') else
             store_ty_lookup l (store_ty_update la T sl rest)) =
           (if l = l' then some (T', sl') else store_ty_lookup l rest)
      by_cases hl : l = l'
      · simp [hl]
      · simp [hl, sty_update_other l la T sl hneq rest]

/-- Looking up after update: same location (runtime store). -/
private theorem st_update_same (l : loc) (v : expr) :
    ∀ (st : store), store_lookup l (store_update l v st) = some v
  | [] => by
    show (if (l == l) = true then some v else store_lookup l []) = some v
    simp [beq_iff_eq]
  | (l', w) :: rest => by
    show store_lookup l (if (l == l') = true then (l, v) :: rest
           else (l', w) :: store_update l v rest) = some v
    by_cases h : l = l'
    · simp only [show (l == l') = true from by simp [beq_iff_eq, h], if_true]
      show (if (l == l) = true then some v else store_lookup l rest) = some v
      simp [beq_iff_eq]
    · simp only [show (l == l') = false from by simp [beq_iff_eq, h], ite_false]
      show (if (l == l') = true then some w else
             store_lookup l (store_update l v rest)) = some v
      simp [show (l == l') = false from by simp [beq_iff_eq, h]]
      exact st_update_same l v rest

/-- Looking up a different location after update is unchanged (runtime store). -/
private theorem st_update_other (l la : loc) (v : expr) (hneq : l ≠ la) :
    ∀ (st : store), store_lookup l (store_update la v st) = store_lookup l st
  | [] => by
    show (if (l == la) = true then some v else store_lookup l []) = store_lookup l []
    simp [beq_iff_eq, hneq]
  | (l', w) :: rest => by
    show store_lookup l (if (la == l') = true then (la, v) :: rest
           else (l', w) :: store_update la v rest) =
         (if (l == l') = true then some w else store_lookup l rest)
    by_cases ha : la = l'
    · simp only [show (la == l') = true from by simp [beq_iff_eq, ha], if_true]
      show (if (l == la) = true then some v else store_lookup l rest) =
           (if (l == l') = true then some w else store_lookup l rest)
      have hne' : l ≠ l' := by rw [← ha]; exact hneq
      simp [beq_iff_eq, hneq, hne']
    · simp only [show (la == l') = false from by simp [beq_iff_eq, ha], ite_false]
      show (if (l == l') = true then some w else
             store_lookup l (store_update la v rest)) =
           (if (l == l') = true then some w else store_lookup l rest)
      by_cases hl : l = l'
      · simp [show (l == l') = true from by simp [beq_iff_eq, hl]]
      · simp [show (l == l') = false from by simp [beq_iff_eq, hl]]
        exact st_update_other l la v hneq rest

/-- If store_lookup succeeds, the location is bounded by store_max. -/
private theorem store_max_geq :
    ∀ (st : store) (l : loc) (v : expr),
    store_lookup l st = some v → l ≤ store_max st := by
  intro st
  induction st with
  | cons entry rest ih =>
    intro l v; simp only [store_lookup]; split
    · intro _
      have heq : l = entry.1 := by rwa [beq_iff_eq] at *
      rw [heq]; simp only [store_max]; exact Nat.le_max_left _ _
    · intro h
      exact Nat.le_trans (ih l v h) (by simp [store_max]; exact Nat.le_max_right _ _)
  | _ => intro l v; simp [store_lookup]

-- ============================================================================
-- Theorems (32 total, all proven)
-- ============================================================================

-- Store extension after fresh allocation: update extends the original.
/-- store_extend_after_alloc (matches Coq) -/
theorem store_extend_after_alloc :
    ∀ St l T sl, store_ty_lookup l St = none →
    store_ty_extends St (store_ty_update l T sl St) := by
  intro St l T sl hnone la Ta sla hlook
  by_cases heq : l = la
  · subst heq; rw [hnone] at hlook; exact absurd hlook (Option.noConfusion)
  · rw [sty_update_other la l T sl (Ne.symm heq) St]; exact hlook

-- After updating location l, looking up l returns the new value.
/-- store_lookup_after_update (matches Coq) -/
theorem store_lookup_after_update :
    ∀ st l v, store_lookup l (store_update l v st) = some v := by
  intro st l v; exact st_update_same l v st

-- After updating a different location, lookup for l is unchanged.
/-- store_lookup_update_other (matches Coq) -/
theorem store_lookup_update_other :
    ∀ st l l' v, l ≠ l' →
    store_lookup l (store_update l' v st) = store_lookup l st := by
  intro st l l' v hneq; exact st_update_other l l' v hneq st

-- Store typing update for the same location returns the new entry.
/-- store_ty_update_same (matches Coq) -/
theorem store_ty_update_same :
    ∀ St l T sl, store_ty_lookup l (store_ty_update l T sl St) = some (T, sl) := by
  intro St l T sl; exact sty_update_same l T sl St

-- Store typing update for a different location is unchanged.
/-- store_ty_update_other (matches Coq) -/
theorem store_ty_update_other :
    ∀ St l l' T sl, l ≠ l' →
    store_ty_lookup l (store_ty_update l' T sl St) = store_ty_lookup l St := by
  intro St l l' T sl hneq; exact sty_update_other l l' T sl hneq St

-- Two sequential extensions compose.
/-- store_extend_compose (matches Coq) -/
theorem store_extend_compose :
    ∀ St1 St2 St3, store_ty_extends St1 St2 → store_ty_extends St2 St3 →
    store_ty_extends St1 St3 := by
  intro St1 St2 St3 h12 h23 l T sl hlook
  exact h23 l T sl (h12 l T sl hlook)

-- Extension is anti-symmetric on lookups.
/-- store_extend_antisym_lookup (matches Coq) -/
theorem store_extend_antisym_lookup :
    ∀ St1 St2 l T sl, store_ty_extends St1 St2 → store_ty_extends St2 St1 →
    store_ty_lookup l St1 = some (T, sl) → store_ty_lookup l St2 = some (T, sl) := by
  intro St1 St2 l T sl h12 _ hlook
  exact h12 l T sl hlook

-- Well-typed expressions remain well-typed after store extension.
/-- typing_monotone_store (matches Coq) -/
theorem typing_monotone_store :
    ∀ Γ St St' Δ e T ε, store_ty_extends St St' →
    has_type Γ St Δ e T ε → has_type Γ St' Δ e T ε := by
  intro Γ St St' Δ e T ε hext htype
  exact has_type_store_weaken htype hext

-- Location typing is preserved under store extension.
/-- loc_typed_under_extension (matches Coq) -/
theorem loc_typed_under_extension :
    ∀ St St' l T sl, store_ty_extends St St' →
    store_ty_lookup l St = some (T, sl) → store_ty_lookup l St' = some (T, sl) := by
  intro St St' l T sl hext hlook
  exact hext l T sl hlook

-- Closed values preserve typing under store extension.
/-- value_typed_under_extension (matches Coq) -/
theorem value_typed_under_extension :
    ∀ St St' v T ε, store_ty_extends St St' →
    has_type [] St LPublic v T ε → value v →
    has_type [] St' LPublic v T ε := by
  intro St St' v T ε hext htype _
  exact has_type_store_weaken htype hext

-- Every well-typed value in a well-formed store has EffPure effect.
/-- store_wf_values_pure (matches Coq) -/
theorem store_wf_values_pure :
    ∀ St st l T sl v, store_wf St st →
    store_ty_lookup l St = some (T, sl) → store_lookup l st = some v →
    has_type [] St LPublic v T EffPure := by
  intro St st l T sl v hwf hty hlook
  obtain ⟨v', hlook', _, htyp⟩ := hwf.1 l T sl hty
  have : v = v' := Option.some.inj (hlook ▸ hlook')
  rw [this]; exact htyp

-- All stored values in a well-formed store are values.
/-- store_wf_all_values (matches Coq) -/
theorem store_wf_all_values :
    ∀ St st l v, store_wf St st → store_lookup l st = some v → value v := by
  intro St st l v hwf hlook
  obtain ⟨_, _, _, hval, _⟩ := hwf.2 l v hlook
  exact hval

-- store_wf_typed_implies_stored: already defined in StoreWfLemmas
-- store_wf_stored_implies_typed: already defined in StoreWfLemmas

-- Location lookup decidability in store typing.
/-- store_ty_lookup_dec (matches Coq) -/
theorem store_ty_lookup_dec :
    ∀ l St, (∃ T sl, store_ty_lookup l St = some (T, sl)) ∨
            (store_ty_lookup l St = none) := by
  intro l St
  cases h : store_ty_lookup l St with
  | some p => exact Or.inl ⟨p.1, p.2, by simp [h]⟩
  | none => exact Or.inr rfl

-- Location equality is decidable (nat decidability).
/-- loc_eq_dec (matches Coq) -/
theorem loc_eq_dec : ∀ (l1 l2 : loc), l1 = l2 ∨ l1 ≠ l2 := by
  intro l1 l2; exact Decidable.em (l1 = l2)

-- Store typing update commutes for distinct locations (lookup equivalence).
/-- store_ty_update_commute_lookup (matches Coq) -/
theorem store_ty_update_commute_lookup :
    ∀ St l1 T1 sl1 l2 T2 sl2 l, l1 ≠ l2 →
    store_ty_lookup l (store_ty_update l1 T1 sl1 (store_ty_update l2 T2 sl2 St)) =
    store_ty_lookup l (store_ty_update l2 T2 sl2 (store_ty_update l1 T1 sl1 St)) := by
  intro St l1 T1 sl1 l2 T2 sl2 l hneq
  by_cases h1 : l = l1
  · subst h1
    rw [sty_update_same, sty_update_other _ _ _ _ hneq, sty_update_same]
  · by_cases h2 : l = l2
    · subst h2
      rw [sty_update_other _ _ _ _ h1, sty_update_same, sty_update_same]
    · rw [sty_update_other _ _ _ _ h1, sty_update_other _ _ _ _ h2,
          sty_update_other _ _ _ _ h2, sty_update_other _ _ _ _ h1]

-- store_wf_empty: already defined in StoreWfLemmas

-- Typing is preserved when a fresh location is added to the store typing.
/-- typing_under_alloc (matches Coq) -/
theorem typing_under_alloc :
    ∀ Γ St Δ e T ε l T' sl', store_ty_lookup l St = none →
    has_type Γ St Δ e T ε → has_type Γ (store_ty_update l T' sl' St) Δ e T ε := by
  intro Γ St Δ e T ε l T' sl' hnone htype
  have hext : store_ty_extends St (store_ty_update l T' sl' St) := by
    intro la Ta sla hlook
    by_cases heq : l = la
    · subst heq; rw [hnone] at hlook; exact absurd hlook (Option.noConfusion)
    · rw [sty_update_other la l T' sl' (Ne.symm heq) St]; exact hlook
  exact has_type_store_weaken htype hext

-- Double allocation preserves typing when both locations are fresh.
/-- typing_under_double_alloc (matches Coq) -/
theorem typing_under_double_alloc :
    ∀ Γ St Δ e T ε l1 T1 sl1 l2 T2 sl2, l1 ≠ l2 →
    store_ty_lookup l1 St = none → store_ty_lookup l2 St = none →
    has_type Γ St Δ e T ε →
    has_type Γ (store_ty_update l2 T2 sl2 (store_ty_update l1 T1 sl1 St)) Δ e T ε := by
  intro Γ St Δ e T ε l1 T1 sl1 l2 T2 sl2 hneq hn1 hn2 htype
  have hext1 : store_ty_extends St (store_ty_update l1 T1 sl1 St) := by
    intro la Ta sla hlook
    by_cases heq : l1 = la
    · subst heq; rw [hn1] at hlook; exact absurd hlook (Option.noConfusion)
    · rw [sty_update_other la l1 T1 sl1 (Ne.symm heq) St]; exact hlook
  have hn2' : store_ty_lookup l2 (store_ty_update l1 T1 sl1 St) = none := by
    rw [sty_update_other l2 l1 T1 sl1 (Ne.symm hneq) St]; exact hn2
  have hext2 : store_ty_extends (store_ty_update l1 T1 sl1 St)
                                (store_ty_update l2 T2 sl2 (store_ty_update l1 T1 sl1 St)) := by
    intro la Ta sla hlook
    by_cases heq : l2 = la
    · subst heq; rw [hn2'] at hlook; exact absurd hlook (Option.noConfusion)
    · rw [sty_update_other la l2 T2 sl2 (Ne.symm heq) (store_ty_update l1 T1 sl1 St)]
      exact hlook
  exact has_type_store_weaken (has_type_store_weaken htype hext1) hext2

-- If St extends St' and both are well-formed with their stores,
-- then typed locations in St have runtime values.
/-- store_wf_extends_typed (matches Coq) -/
theorem store_wf_extends_typed :
    ∀ St St' st l T sl, store_ty_extends St St' → store_wf St st →
    store_ty_lookup l St = some (T, sl) →
    ∃ v, store_lookup l st = some v ∧ value v := by
  intro St _ st l T sl _ hwf hty
  obtain ⟨v, hlook, hval, _⟩ := hwf.1 l T sl hty
  exact ⟨v, hlook, hval⟩

-- Fresh location lookup on store typing returns None.
/-- fresh_loc_store_ty_none (matches Coq) -/
theorem fresh_loc_store_ty_none :
    ∀ St st, store_wf St st → store_ty_lookup (fresh_loc st) St = none := by
  intro St st hwf
  match h : store_ty_lookup (fresh_loc st) St with
  | none => rfl
  | some (T, sl) =>
    exfalso
    obtain ⟨v, hlook, _, _⟩ := hwf.1 (fresh_loc st) T sl h
    have hle := store_max_geq st (fresh_loc st) v hlook
    simp [fresh_loc] at hle
    exact Nat.not_succ_le_self _ hle

-- Fresh location has no runtime entry.
/-- fresh_loc_store_none (matches Coq) -/
theorem fresh_loc_store_none : ∀ st, store_lookup (fresh_loc st) st = none := by
  intro st
  match h : store_lookup (fresh_loc st) st with
  | none => rfl
  | some w =>
    exfalso
    have hle := store_max_geq st (fresh_loc st) w h
    simp [fresh_loc] at hle
    exact Nat.not_succ_le_self _ hle

-- All values in a well-formed store are well-typed with pure effect
-- (combining forward and reverse directions).
/-- store_wf_all_well_typed (matches Coq) -/
theorem store_wf_all_well_typed :
    ∀ St st l v, store_wf St st → store_lookup l st = some v →
    ∃ T sl, store_ty_lookup l St = some (T, sl) ∧ value v ∧
    has_type [] St LPublic v T EffPure := by
  intro St st l v hwf hlook
  exact hwf.2 l v hlook

-- If a location is in St and St extends to St', the location is in St'.
/-- store_ty_in_extends (matches Coq) -/
theorem store_ty_in_extends :
    ∀ St St' l, store_ty_extends St St' →
    (∃ T sl, store_ty_lookup l St = some (T, sl)) →
    (∃ T sl, store_ty_lookup l St' = some (T, sl)) := by
  intro St St' l hext ⟨T, sl, hlook⟩
  exact ⟨T, sl, hext l T sl hlook⟩

-- Location absence is contra-variant under extension.
/-- store_ty_not_in_extends (matches Coq) -/
theorem store_ty_not_in_extends :
    ∀ St St' l, store_ty_extends St St' →
    store_ty_lookup l St' = none → store_ty_lookup l St = none := by
  intro St St' l hext hnone
  match h : store_ty_lookup l St with
  | none => rfl
  | some (T, sl) =>
    have := hext l T sl h
    rw [hnone] at this
    exact absurd this (Option.noConfusion)

-- Extension is preserved when the same location is added to both.
/-- store_ty_extends_update_both (matches Coq) -/
theorem store_ty_extends_update_both :
    ∀ St St' l T sl, store_ty_extends St St' →
    store_ty_extends (store_ty_update l T sl St) (store_ty_update l T sl St') := by
  intro St St' l T sl hext la Ta sla hlook
  by_cases heq : l = la
  · subst heq
    rw [sty_update_same] at hlook
    have := Option.some.inj hlook; cases this
    exact sty_update_same l T sl St'
  · rw [sty_update_other _ _ _ _ (Ne.symm heq)] at hlook
    rw [sty_update_other _ _ _ _ (Ne.symm heq)]
    exact hext la Ta sla hlook

-- Extension preserves type at a location.
/-- store_ty_extends_preserves_lookup (matches Coq) -/
theorem store_ty_extends_preserves_lookup :
    ∀ St St' l T sl, store_ty_extends St St' →
    store_ty_lookup l St = some (T, sl) → store_ty_lookup l St' = some (T, sl) := by
  intro St St' l T sl hext hlook
  exact hext l T sl hlook

-- Extension is compatible with looking up the same location.
/-- store_ty_extends_same_type (matches Coq) -/
theorem store_ty_extends_same_type :
    ∀ St St' l T1 sl1 T2 sl2, store_ty_extends St St' →
    store_ty_lookup l St = some (T1, sl1) → store_ty_lookup l St' = some (T2, sl2) →
    T1 = T2 ∧ sl1 = sl2 := by
  intro St St' l T1 sl1 T2 sl2 hext h1 h2
  have h3 := hext l T1 sl1 h1
  rw [h3] at h2
  have := Option.some.inj h2
  cases this; exact ⟨rfl, rfl⟩

-- Adding then looking up same location.
/-- store_ty_update_lookup_same (matches Coq) -/
theorem store_ty_update_lookup_same :
    ∀ l T sl St, store_ty_lookup l (store_ty_update l T sl St) = some (T, sl) := by
  intro l T sl St; exact sty_update_same l T sl St

-- Extension is reflexive.
/-- store_ty_extends_reflexive (matches Coq) -/
theorem store_ty_extends_reflexive : ∀ St, store_ty_extends St St := by
  intro St l T sl hlook; exact hlook

-- Two-step extension chain.
/-- store_ty_extends_chain (matches Coq) -/
theorem store_ty_extends_chain :
    ∀ St1 St2 St3, store_ty_extends St1 St2 → store_ty_extends St2 St3 →
    store_ty_extends St1 St3 := by
  intro St1 St2 St3 h12 h23 l T sl hlook
  exact h23 l T sl (h12 l T sl hlook)

end RIINA

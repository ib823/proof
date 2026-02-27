-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.
import RIINA.Foundations.Syntax
import RIINA.Foundations.Semantics
import RIINA.TypeSystem.Typing

/-!
# RIINA Preservation - Lean 4 Port

Port of 02_FORMAL/coq/type_system/Preservation.v.

## Proved Theorems
- store_lookup_update_eq, store_lookup_update_neq
- store_ty_lookup_update_eq, store_ty_lookup_update_neq
- store_ty_extends_update_fresh, store_ty_extends_preserves_typing
- store_ty_extends_refl, store_ty_extends_trans
- store_wf_update_existing, store_wf_update_fresh
- store_ty_lookup_fresh_none
- value_has_pure_effect
- store_wf_typed_loc_value, store_wf_lookup_has_type

## Commented Out (require substantial infrastructure not yet available)
- free_in_context (theorem 1): needs well-formulated statement
- context_invariance (theorem 2): needs well-formulated statement
- closed_typing_weakening (theorem 3): needs well-formulated statement
- substitution_preserves_typing: needs context weakening/invariance lemmas
- preservation_helper, preservation, multi_step_preservation:
    need substitution_preserves_typing and deep step induction
-/

namespace RIINA

/-! ## Helper lemmas for store operations -/

/-- Looking up a location in a store updated at the same location yields the new value. -/
private theorem store_lookup_update_eq :
    ∀ (st : store) (l : loc) (v : expr),
    store_lookup l (store_update l v st) = Some v := by
  intro st l v
  induction st with
  | «nil» => simp [store_update, store_lookup]
  | «cons» hd tl ih =>
    obtain ⟨l', v'⟩ := hd
    simp only [store_update]
    split
    · simp [store_lookup]
    · rename_i h
      simp only [store_lookup]
      split
      · exact absurd ‹_› h
      · exact ih

/-- Looking up a different location in an updated store yields the original value. -/
private theorem store_lookup_update_neq :
    ∀ (st : store) (l l' : loc) (v : expr),
    l ≠ l' → store_lookup l (store_update l' v st) = store_lookup l st := by
  intro st l l' v hne
  induction st with
  | «nil» =>
    simp only [store_update, store_lookup]
    have : ¬((l == l') = true) := by
      intro h; simp [BEq.beq] at h; exact hne h
    simp [this]
  | «cons» hd tl ih =>
    obtain ⟨l'', v''⟩ := hd
    simp only [store_update]
    split
    · rename_i h1
      have hl'eq : l' = l'' := by simp [BEq.beq] at h1; exact h1
      have hne2 : l ≠ l'' := by rw [← hl'eq]; exact hne
      have h3 : ¬((l == l'') = true) := by
        intro h; simp [BEq.beq] at h; exact hne2 h
      simp only [store_lookup]
      have h2 : ¬((l == l') = true) := by
        intro h; simp [BEq.beq] at h; exact hne h
      simp [h2, h3]
    · simp only [store_lookup]
      split
      · rfl
      · exact ih

/-- Looking up a location in a store typing updated at the same location yields the new entry. -/
private theorem store_ty_lookup_update_eq :
    ∀ (St : store_ty) (l : loc) (T : ty) (sl : security_level),
    store_ty_lookup l (store_ty_update l T sl St) = Some (T, sl) := by
  intro St l T sl
  induction St with
  | «nil» => simp [store_ty_update, store_ty_lookup]
  | «cons» hd tl ih =>
    obtain ⟨l', T', sl'⟩ := hd
    simp only [store_ty_update]
    split
    · simp [store_ty_lookup]
    · rename_i h
      simp [store_ty_lookup, h, ih]

/-- Looking up a different location in an updated store typing yields the original entry. -/
private theorem store_ty_lookup_update_neq :
    ∀ (St : store_ty) (l l' : loc) (T : ty) (sl : security_level),
    l ≠ l' → store_ty_lookup l (store_ty_update l' T sl St) = store_ty_lookup l St := by
  intro St l l' T sl hne
  induction St with
  | «nil» =>
    simp only [store_ty_update, store_ty_lookup]
    simp [hne]
  | «cons» hd tl ih =>
    obtain ⟨l'', T'', sl''⟩ := hd
    simp only [store_ty_update]
    split
    · rename_i h1
      simp only [store_ty_lookup]
      have hne2 : ¬(l = l'') := by rw [← h1]; exact hne
      simp [hne, hne2]
    · simp only [store_ty_lookup]
      split
      · rfl
      · exact ih

/-- Adding a fresh location to the store typing extends it. -/
theorem store_ty_extends_update_fresh :
    ∀ (St : store_ty) (l : loc) (T : ty) (sl : security_level),
    store_ty_lookup l St = None →
    store_ty_extends St (store_ty_update l T sl St) := by
  intro St l T sl hnone l' T' sl' hlookup
  by_cases h : l = l'
  · subst h; rw [hnone] at hlookup; exact absurd hlookup (by simp)
  · have hne : l' ≠ l := fun h' => h h'.symm
    rw [store_ty_lookup_update_neq St l' l T sl hne]
    exact hlookup

/-- Extending the store typing preserves typing judgments. -/
theorem store_ty_extends_preserves_typing :
    ∀ (Γ : type_env) (St St' : store_ty) (Δ : security_level) (e : expr) (T : ty) (ε : effect),
    store_ty_extends St St' → has_type Γ St Δ e T ε → has_type Γ St' Δ e T ε := by
  intro Γ St St' Δ e T ε hext htype
  exact has_type_store_weaken htype hext

/-- Store typing extension is reflexive. -/
private theorem store_ty_extends_refl : ∀ (St : store_ty), store_ty_extends St St := by
  intro St l T sl h
  exact h

/-- Store typing extension is transitive. -/
private theorem store_ty_extends_trans :
    ∀ (St1 St2 St3 : store_ty),
    store_ty_extends St1 St2 → store_ty_extends St2 St3 → store_ty_extends St1 St3 := by
  intro St1 St2 St3 h12 h23 l T sl h1
  exact h23 l T sl (h12 l T sl h1)

/-! ## Store well-formedness preservation -/

/-- Updating an existing location in a well-formed store preserves well-formedness. -/
theorem store_wf_update_existing :
    ∀ (St : store_ty) (st : store) (l : loc) (T : ty) (sl : security_level) (v : expr),
    store_wf St st →
    store_ty_lookup l St = Some (T, sl) →
    value v →
    has_type nil St Public v T EffectPure →
    store_wf St (store_update l v st) := by
  intro St st l T sl v hwf hlookup hval htype
  obtain ⟨hwf1, hwf2⟩ := hwf
  constructor
  · intro l' T' sl' hlookup'
    by_cases h : l = l'
    · subst h
      rw [hlookup] at hlookup'
      cases hlookup'
      exact ⟨v, store_lookup_update_eq st l v, hval, htype⟩
    · have hne : l' ≠ l := fun h' => h h'.symm
      rw [store_lookup_update_neq st l' l v hne]
      exact hwf1 l' T' sl' hlookup'
  · intro l' v' hlookup_v
    by_cases h : l = l'
    · subst h
      rw [store_lookup_update_eq] at hlookup_v
      cases hlookup_v
      exact ⟨T, sl, hlookup, hval, htype⟩
    · have hne : l' ≠ l := fun h' => h h'.symm
      rw [store_lookup_update_neq st l' l v hne] at hlookup_v
      exact hwf2 l' v' hlookup_v

/-- Helper: no store entry has a key larger than store_max. -/
private theorem store_lookup_gt_max :
    ∀ (st : store) (l : loc),
    l > store_max st → store_lookup l st = None := by
  intro st l hgt
  induction st with
  | «nil» => simp [store_lookup]
  | «cons» hd tl ih =>
    obtain ⟨l', v'⟩ := hd
    simp only [store_lookup]
    have hmax : store_max ((l', v') :: tl) = Nat.max l' (store_max tl) := rfl
    rw [hmax] at hgt
    have hl' : l ≠ l' := by
      intro heq; subst heq
      exact Nat.not_le.mpr hgt (Nat.le_max_left l (store_max tl))
    have htl : l > store_max tl :=
      Nat.lt_of_le_of_lt (Nat.le_max_right l' (store_max tl)) hgt
    have : ¬((l == l') = true) := by
      intro h; simp [BEq.beq] at h; exact hl' h
    simp [this]
    exact ih htl

/-- The fresh location is not in any store. -/
private theorem store_lookup_fresh :
    ∀ (st : store), store_lookup (fresh_loc st) st = None := by
  intro st
  apply store_lookup_gt_max
  simp [fresh_loc]

/-- The fresh location is not in any store typing that is well-formed with the store. -/
theorem store_ty_lookup_fresh_none :
    ∀ (St : store_ty) (st : store),
    store_wf St st → store_ty_lookup (fresh_loc st) St = None := by
  intro St st hwf
  obtain ⟨hwf1, _⟩ := hwf
  match hq : store_ty_lookup (fresh_loc st) St with
  | none => rfl
  | some (T, sl) =>
    obtain ⟨v, hv1, _, _⟩ := hwf1 _ T sl hq
    rw [store_lookup_fresh] at hv1
    exact absurd hv1 (by simp)

/-- Adding a fresh location with a well-typed value preserves store well-formedness. -/
theorem store_wf_update_fresh :
    ∀ (St : store_ty) (st : store) (l : loc) (T : ty) (sl : security_level) (v : expr),
    store_wf St st →
    store_lookup l st = None →
    store_ty_lookup l St = None →
    value v →
    has_type nil St Public v T EffectPure →
    store_wf (store_ty_update l T sl St) (store_update l v st) := by
  intro St st l T sl v hwf hst_none hSt_none hval htype
  obtain ⟨hwf1, hwf2⟩ := hwf
  have hext := store_ty_extends_update_fresh St l T sl hSt_none
  constructor
  · intro l' T' sl' hlookup'
    by_cases h : l = l'
    · subst h
      rw [store_ty_lookup_update_eq] at hlookup'
      cases hlookup'
      exact ⟨v, store_lookup_update_eq st l v, hval,
             has_type_store_weaken htype hext⟩
    · have hne : l' ≠ l := fun h' => h h'.symm
      rw [store_ty_lookup_update_neq St l' l T sl hne] at hlookup'
      rw [store_lookup_update_neq st l' l v hne]
      obtain ⟨v', hv1, hv2, hv3⟩ := hwf1 l' T' sl' hlookup'
      exact ⟨v', hv1, hv2, has_type_store_weaken hv3 hext⟩
  · intro l' v' hlookup_v
    by_cases h : l = l'
    · subst h
      rw [store_lookup_update_eq] at hlookup_v
      cases hlookup_v
      rw [store_ty_lookup_update_eq]
      exact ⟨T, sl, rfl, hval, has_type_store_weaken htype hext⟩
    · have hne : l' ≠ l := fun h' => h h'.symm
      rw [store_lookup_update_neq st l' l v hne] at hlookup_v
      obtain ⟨T', sl', hT1, hv2, hv3⟩ := hwf2 l' v' hlookup_v
      rw [store_ty_lookup_update_neq St l' l T sl hne]
      exact ⟨T', sl', hT1, hv2, has_type_store_weaken hv3 hext⟩

/-! ## Value typing -/

/-- Values typed in the empty context have pure effect. -/
theorem value_has_pure_effect :
    ∀ (v : expr) (T : ty) (ε : effect) (St : store_ty),
    value v → has_type nil St Public v T ε →
    has_type nil St Public v T EffectPure := by
  intro v T ε St hval
  revert T ε
  induction hval with
  | VUnit => intro T ε htype; cases htype; exact has_type.T_Unit
  | VBool b => intro T ε htype; cases htype; exact has_type.T_Bool
  | VInt n => intro T ε htype; cases htype; exact has_type.T_Int
  | VString s => intro T ε htype; cases htype; exact has_type.T_String
  | VLoc l => intro T ε htype; cases htype with | T_Loc h => exact has_type.T_Loc h
  | VLam x T' body =>
    intro T ε htype; cases htype with | T_Lam h => exact has_type.T_Lam h
  | VPair v1 v2 _ _ ih1 ih2 =>
    intro T ε htype
    cases htype with
    | T_Pair h1 h2 =>
      have := has_type.T_Pair (ih1 _ _ h1) (ih2 _ _ h2)
      simp only [eff_join, effect_join, effect_level] at this
      exact this
  | VInl v' T' _ ih =>
    intro T ε htype
    cases htype with
    | T_Inl h => exact has_type.T_Inl (ih _ _ h)
  | VInr v' T' _ ih =>
    intro T ε htype
    cases htype with
    | T_Inr h => exact has_type.T_Inr (ih _ _ h)
  | VClassify v' _ ih =>
    intro T ε htype
    cases htype with
    | T_Classify h => exact has_type.T_Classify (ih _ _ h)
  | VProve v' _ ih =>
    intro T ε htype
    cases htype with
    | T_Prove h => exact has_type.T_Prove (ih _ _ h)

/-! ## Store well-formedness queries -/

/-- In a well-formed store, a typed location has a value. -/
theorem store_wf_typed_loc_value :
    ∀ (St : store_ty) (st : store) (l : loc) (T : ty) (sl : security_level),
    store_wf St st → store_ty_lookup l St = Some (T, sl) →
    ∃ v, store_lookup l st = Some v ∧ value v := by
  intro St st l T sl hwf hlookup
  obtain ⟨hwf1, _⟩ := hwf
  obtain ⟨v, hv1, hv2, _⟩ := hwf1 l T sl hlookup
  exact ⟨v, hv1, hv2⟩

/-- In a well-formed store, a typed location has a well-typed value. -/
private theorem store_wf_lookup_has_type :
    ∀ (St : store_ty) (st : store) (l : loc) (T : ty) (sl : security_level),
    store_wf St st → store_ty_lookup l St = Some (T, sl) →
    ∃ v, store_lookup l st = Some v ∧ value v ∧ has_type nil St Public v T EffectPure := by
  intro St st l T sl hwf hlookup
  obtain ⟨hwf1, _⟩ := hwf
  obtain ⟨v, hv1, hv2, hv3⟩ := hwf1 l T sl hlookup
  exact ⟨v, hv1, hv2, hv3⟩

/-! ## Theorems commented out

The following theorems from the Coq port require substantial infrastructure that is not
yet available in the Lean formalization. They are commented out with explanations.
-/

-- COMMENTED OUT: free_in_context (theorem "1" in the Coq port)
-- Reason: The original auto-generated statement had invalid Lean syntax (prose text in
-- the theorem identifier). The theorem states that if x is free in e and e is well-typed
-- in Gamma, then x is in Gamma. Proving this requires induction on the free_in predicate
-- and the typing derivation simultaneously, which needs additional infrastructure.

-- COMMENTED OUT: context_invariance (theorem "2" in the Coq port)
-- Reason: Same invalid syntax issue. States that typing depends only on free variables.
-- Requires induction on the typing derivation with careful handling of variable binding.

-- COMMENTED OUT: closed_typing_weakening (theorem "3" in the Coq port)
-- Reason: Same invalid syntax issue. States that closed terms can be typed in any context.
-- Requires context_invariance as a prerequisite.

-- COMMENTED OUT: substitution_preserves_typing
-- Reason: Requires induction on the typing derivation with the context containing (z, T1).
-- The Lean 4 induction tactic cannot induct when an index is not a variable. This needs
-- context invariance and weakening lemmas, plus careful handling of BEq vs propositional
-- equality for identifiers. Would be a substantial proof effort.

-- COMMENTED OUT: preservation_helper
-- Reason: Requires substitution_preserves_typing and deep case analysis on the step relation
-- combined with typing rule inversion. The full preservation proof depends on all the
-- infrastructure lemmas above.

-- COMMENTED OUT: preservation
-- Reason: The original used an undefined `preservation_stmt` type. The actual theorem would
-- state that if e has type T and e steps to e', then e' has type T (possibly with extended
-- store typing). Requires preservation_helper.

-- COMMENTED OUT: multi_step_preservation
-- Reason: Requires preservation (single-step) and induction on the multi_step relation.
-- Straightforward once preservation is proved, but depends on the unproved preservation.

end RIINA

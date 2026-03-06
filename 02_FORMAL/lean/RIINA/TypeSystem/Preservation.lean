-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.
import RIINA.Foundations.Syntax
import RIINA.Foundations.Semantics
import RIINA.TypeSystem.Typing
import RIINA.Properties.SubstitutionLemma
import RIINA.Properties.SN_Closure

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
- preservation_helper (32 step cases, 0 sorry)
- preservation (single-step, wrapper)
- multi_step_preservation (reflexive-transitive closure)
-/

namespace RIINA

open expr value

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

/-! ## Preservation Theorem

If a well-typed expression takes a step, the result is also well-typed
(with the same type, possibly different effect and extended store typing).
-/

/-- Single-step preservation (subject reduction). -/
theorem preservation_helper :
    ∀ (cfg1 cfg2 : config),
    step cfg1 cfg2 →
    ∀ (T : ty) (ε : effect) (St : store_ty),
    has_type [] St Public cfg1.1 T ε →
    store_wf St cfg1.2.1 →
    ∃ (St' : store_ty) (ε' : effect),
      store_ty_extends St St' ∧
      store_wf St' cfg2.2.1 ∧
      has_type [] St' Public cfg2.1 T ε' := by
  intro cfg1 cfg2 hstep
  induction hstep with
  -- ===== COMPUTATION RULES =====
  | ST_AppAbs x T_param body v _st _ctx hval =>
    intro T ε St hty hwf
    cases hty with
    | T_App h1 h2 =>
      cases h1 with
      | T_Lam hbody =>
        have hv_pure := value_has_pure_effect v _ _ St hval h2
        exact ⟨St, _, store_ty_extends_refl St, hwf,
               substitution_preserves_typing [] St Public x T_param v body _ _ hbody hv_pure⟩
  | ST_Fst v1 v2 _st _ctx _hv1 _hv2 =>
    intro T ε St hty hwf
    cases hty with
    | T_Fst hpair =>
      cases hpair with
      | T_Pair h1 h2 => exact ⟨St, _, store_ty_extends_refl St, hwf, h1⟩
  | ST_Snd v1 v2 _st _ctx _hv1 _hv2 =>
    intro T ε St hty hwf
    cases hty with
    | T_Snd hpair =>
      cases hpair with
      | T_Pair h1 h2 => exact ⟨St, _, store_ty_extends_refl St, hwf, h2⟩
  | ST_IfTrue e1 _e2 _st _ctx =>
    intro T ε St hty hwf
    cases hty with
    | T_If hcond h1 h2 => exact ⟨St, _, store_ty_extends_refl St, hwf, h1⟩
  | ST_IfFalse _e1 e2 _st _ctx =>
    intro T ε St hty hwf
    cases hty with
    | T_If hcond h1 h2 => exact ⟨St, _, store_ty_extends_refl St, hwf, h2⟩
  | ST_LetVal x v e2 _st _ctx hval =>
    intro T ε St hty hwf
    cases hty with
    | T_Let h1 h2 =>
      have hv_pure := value_has_pure_effect v _ _ St hval h1
      exact ⟨St, _, store_ty_extends_refl St, hwf,
             substitution_preserves_typing [] St Public x _ v e2 _ _ h2 hv_pure⟩
  | ST_CaseInl v _T x1 e1 _x2 _e2 _st _ctx hval =>
    intro T ε St hty hwf
    cases hty with
    | T_Case hscr h1 h2 =>
      cases hscr with
      | T_Inl hv =>
        have hv_pure := value_has_pure_effect v _ _ St hval hv
        exact ⟨St, _, store_ty_extends_refl St, hwf,
               substitution_preserves_typing [] St Public x1 _ v e1 _ _ h1 hv_pure⟩
  | ST_CaseInr v _T _x1 _e1 x2 e2 _st _ctx hval =>
    intro T ε St hty hwf
    cases hty with
    | T_Case hscr h1 h2 =>
      cases hscr with
      | T_Inr hv =>
        have hv_pure := value_has_pure_effect v _ _ St hval hv
        exact ⟨St, _, store_ty_extends_refl St, hwf,
               substitution_preserves_typing [] St Public x2 _ v e2 _ _ h2 hv_pure⟩
  | ST_DeclassifyValue v p _st _ctx hval _hdeclass =>
    intro T ε St hty hwf
    cases hty with
    | T_Declassify h1 h2 _hd =>
      cases h1 with
      | T_Classify hv => exact ⟨St, _, store_ty_extends_refl St, hwf, hv⟩
  -- ===== CONGRUENCE RULES =====
  | ST_App1 e1 _e1' e2 _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_App h1 h2 =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h1 hwf
      exact ⟨St', _, hext, hwf',
             has_type.T_App hty' (has_type_store_weaken h2 hext)⟩
  | ST_App2 v1 e2 _e2' _st _st' _ctx _ctx' _hval _hstep2 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_App h1 h2 =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h2 hwf
      exact ⟨St', _, hext, hwf',
             has_type.T_App (has_type_store_weaken h1 hext) hty'⟩
  | ST_Pair1 e1 _e1' e2 _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Pair h1 h2 =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h1 hwf
      exact ⟨St', _, hext, hwf',
             has_type.T_Pair hty' (has_type_store_weaken h2 hext)⟩
  | ST_Pair2 v1 e2 _e2' _st _st' _ctx _ctx' _hval _hstep2 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Pair h1 h2 =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h2 hwf
      exact ⟨St', _, hext, hwf',
             has_type.T_Pair (has_type_store_weaken h1 hext) hty'⟩
  | ST_Fst1 e _e' _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Fst h =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h hwf
      exact ⟨St', _, hext, hwf', has_type.T_Fst hty'⟩
  | ST_Snd1 e _e' _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Snd h =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h hwf
      exact ⟨St', _, hext, hwf', has_type.T_Snd hty'⟩
  | ST_Inl1 e _e' _T _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Inl h =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h hwf
      exact ⟨St', _, hext, hwf', has_type.T_Inl hty'⟩
  | ST_Inr1 e _e' _T _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Inr h =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h hwf
      exact ⟨St', _, hext, hwf', has_type.T_Inr hty'⟩
  | ST_Case1 e _e' x1 e1 x2 e2 _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Case hscr h1 h2 =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ hscr hwf
      exact ⟨St', _, hext, hwf',
             has_type.T_Case hty'
               (has_type_store_weaken h1 hext)
               (has_type_store_weaken h2 hext)⟩
  | ST_If1 e1 _e1' e2 e3 _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_If h1 h2 h3 =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h1 hwf
      exact ⟨St', _, hext, hwf',
             has_type.T_If hty'
               (has_type_store_weaken h2 hext)
               (has_type_store_weaken h3 hext)⟩
  | ST_Let1 x e1 _e1' e2 _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Let h1 h2 =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h1 hwf
      exact ⟨St', _, hext, hwf',
             has_type.T_Let hty' (has_type_store_weaken h2 hext)⟩
  | ST_Classify1 e _e' _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Classify h =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h hwf
      exact ⟨St', _, hext, hwf', has_type.T_Classify hty'⟩
  | ST_Declassify1 e1 _e1' e2 _st _st' _ctx _ctx' hstep1 _ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Declassify h1 h2 hd =>
      obtain ⟨w, hval_w, heq1, _⟩ := hd
      subst heq1
      exact absurd hstep1 (fun h => SN_Closure.value_not_step (EClassify w) _ _ _ _ _
        (value.VClassify w hval_w) h)
  | ST_Declassify2 v1 e2 _e2' _st _st' _ctx _ctx' hval1 hstep2 _ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Declassify h1 h2 hd =>
      obtain ⟨w, hval_w, _, heq2⟩ := hd
      subst heq2
      exact absurd hstep2 (fun h => SN_Closure.value_not_step (EProve (EClassify w)) _ _ _ _ _
        (value.VProve (EClassify w) (value.VClassify w hval_w)) h)
  | ST_Prove1 e _e' _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Prove h =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h hwf
      exact ⟨St', _, hext, hwf', has_type.T_Prove hty'⟩
  | ST_Require1 eff e _e' _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Require h =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h hwf
      exact ⟨St', _, hext, hwf', has_type.T_Require hty'⟩
  | ST_Grant1 eff e _e' _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Grant h =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h hwf
      exact ⟨St', _, hext, hwf', has_type.T_Grant hty'⟩
  | ST_Perform1 eff e _e' _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Perform h =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h hwf
      exact ⟨St', _, hext, hwf', has_type.T_Perform hty'⟩
  | ST_Handle1 e _e' x h _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Handle h1 h2 =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h1 hwf
      exact ⟨St', _, hext, hwf',
             has_type.T_Handle hty' (has_type_store_weaken h2 hext)⟩
  | ST_Ref1 e _e' _sl _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Ref h =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h hwf
      exact ⟨St', _, hext, hwf', has_type.T_Ref hty'⟩
  | ST_Deref1 e _e' _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Deref h =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h hwf
      exact ⟨St', _, hext, hwf', has_type.T_Deref hty'⟩
  | ST_Assign1 e1 _e1' e2 _st _st' _ctx _ctx' _hstep1 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Assign h1 h2 =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h1 hwf
      exact ⟨St', _, hext, hwf',
             has_type.T_Assign hty' (has_type_store_weaken h2 hext)⟩
  | ST_Assign2 v1 e2 _e2' _st _st' _ctx _ctx' _hval _hstep2 ih =>
    intro T ε St hty hwf
    cases hty with
    | T_Assign h1 h2 =>
      obtain ⟨St', ε', hext, hwf', hty'⟩ := ih _ _ _ h2 hwf
      exact ⟨St', _, hext, hwf',
             has_type.T_Assign (has_type_store_weaken h1 hext) hty'⟩

/-- Single-step preservation (user-facing wrapper). -/
theorem preservation :
    ∀ (e e' : expr) (st st' : store) (ctx ctx' : effect_ctx)
      (T : ty) (ε : effect) (St : store_ty),
    step (e, st, ctx) (e', st', ctx') →
    has_type [] St Public e T ε →
    store_wf St st →
    ∃ (St' : store_ty) (ε' : effect),
      store_ty_extends St St' ∧
      store_wf St' st' ∧
      has_type [] St' Public e' T ε' := by
  intro e e' st st' ctx ctx' T ε St hstep hty hwf
  exact preservation_helper (e, st, ctx) (e', st', ctx') hstep T ε St hty hwf

/-- Multi-step preservation: extends single-step preservation to the
    reflexive-transitive closure of step. -/
theorem multi_step_preservation :
    ∀ (cfg1 cfg2 : config),
    multi_step cfg1 cfg2 →
    ∀ (T : ty) (ε : effect) (St : store_ty),
    has_type [] St Public cfg1.1 T ε →
    store_wf St cfg1.2.1 →
    ∃ (St' : store_ty) (ε' : effect),
      store_ty_extends St St' ∧
      store_wf St' cfg2.2.1 ∧
      has_type [] St' Public cfg2.1 T ε' := by
  intro cfg1 cfg2 hmulti
  induction hmulti with
  | MS_Refl _ =>
    intro T ε St hty hwf
    exact ⟨St, ε, store_ty_extends_refl St, hwf, hty⟩
  | MS_Step cfg1 cfg2 cfg3 hstep _hmulti' ih =>
    intro T ε St hty hwf
    obtain ⟨St2, ε2, hext1, hwf2, hty2⟩ :=
      preservation_helper cfg1 cfg2 hstep T ε St hty hwf
    obtain ⟨St', ε', hext2, hwf', hty'⟩ := ih T ε2 St2 hty2 hwf2
    exact ⟨St', ε', store_ty_extends_trans St St2 St' hext1 hext2, hwf', hty'⟩

end RIINA

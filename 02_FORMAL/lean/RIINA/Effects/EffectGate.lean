-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.
import RIINA.Foundations.Syntax
import RIINA.TypeSystem.Typing
import RIINA.Effects.EffectAlgebra
import RIINA.Effects.EffectSystem

/-!
# RIINA EffectGate - Lean 4 Port

Port of 02_FORMAL/coq/effects/EffectGate.v (38 theorems).

## Key Definitions
- `performs_within`: An expression's perform-effects are all within a given bound
- `has_type_full`: Alias for `has_type`
- `is_gate`: Gate enforcement predicate for effect-bounded application
- `core_effects_within`: Typing implies performs_within (key connecting lemma)

## Proved Theorems (35 of 38)
## COMMENTED OUT (3 of 38): effect_sound_after_step, effect_sound_multi_step
  (require Preservation, not yet proved in Lean)
-/

namespace RIINA

open security_level effect effect_category taint_source sanitizer
     capability_kind capability ty session_type expr

-- performs_within, has_type_full, performs_within_mono: imported from EffectSystem

/-- core_effects_within: typing implies performs_within. -/
theorem core_effects_within
    (G : type_env) (σ : store_ty) (D : security_level)
    (e : expr) (T : ty) (eff : effect)
    (hty : has_type G σ D e T eff) : performs_within e eff := by
  induction hty with
  | T_Unit => trivial
  | T_Bool => trivial
  | T_Int => trivial
  | T_String => trivial
  | T_Loc _ => trivial
  | T_Var _ => trivial
  | T_Lam _ _ => trivial
  | @T_App _ _ _ e1 e2 _ _ ε ε1 ε2 _ _ ih1 ih2 =>
    exact ⟨performs_within_mono e1 ε1 _ (by
             apply effect_leq_trans _ _ _ (effect_join_ub_l ε1 ε2)
             exact effect_join_ub_r ε (effect_join ε1 ε2)) ih1,
           performs_within_mono e2 ε2 _ (by
             apply effect_leq_trans _ _ _ (effect_join_ub_r ε1 ε2)
             exact effect_join_ub_r ε (effect_join ε1 ε2)) ih2⟩
  | @T_Pair _ _ _ e1 e2 _ _ ε1 ε2 _ _ ih1 ih2 =>
    exact ⟨performs_within_mono e1 ε1 _ (effect_join_ub_l ε1 ε2) ih1,
           performs_within_mono e2 ε2 _ (effect_join_ub_r ε1 ε2) ih2⟩
  | T_Fst _ ih => exact ih
  | T_Snd _ ih => exact ih
  | T_Inl _ ih => exact ih
  | T_Inr _ ih => exact ih
  | @T_Case _ _ _ e _ e1 _ e2 _ _ _ ε ε1 ε2 _ _ _ ih0 ih1 ih2 =>
    exact ⟨performs_within_mono e ε _ (effect_join_ub_l ε (effect_join ε1 ε2)) ih0,
           performs_within_mono e1 ε1 _ (by
             apply effect_leq_trans _ _ _ (effect_join_ub_l ε1 ε2)
             exact effect_join_ub_r ε (effect_join ε1 ε2)) ih1,
           performs_within_mono e2 ε2 _ (by
             apply effect_leq_trans _ _ _ (effect_join_ub_r ε1 ε2)
             exact effect_join_ub_r ε (effect_join ε1 ε2)) ih2⟩
  | @T_If _ _ _ e1 e2 e3 _ ε1 ε2 ε3 _ _ _ ih1 ih2 ih3 =>
    exact ⟨performs_within_mono e1 ε1 _ (effect_join_ub_l ε1 (effect_join ε2 ε3)) ih1,
           performs_within_mono e2 ε2 _ (by
             apply effect_leq_trans _ _ _ (effect_join_ub_l ε2 ε3)
             exact effect_join_ub_r ε1 (effect_join ε2 ε3)) ih2,
           performs_within_mono e3 ε3 _ (by
             apply effect_leq_trans _ _ _ (effect_join_ub_r ε2 ε3)
             exact effect_join_ub_r ε1 (effect_join ε2 ε3)) ih3⟩
  | @T_Let _ _ _ _ e1 e2 _ _ ε1 ε2 _ _ ih1 ih2 =>
    exact ⟨performs_within_mono e1 ε1 _ (effect_join_ub_l ε1 ε2) ih1,
           performs_within_mono e2 ε2 _ (effect_join_ub_r ε1 ε2) ih2⟩
  | @T_Perform _ _ _ eff' e _ ε _ ih =>
    exact ⟨effect_join_ub_r ε eff',
           performs_within_mono e ε _ (effect_join_ub_l ε eff') ih⟩
  | @T_Handle _ _ _ e _ h _ _ ε1 ε2 _ _ ih1 ih2 =>
    exact ⟨performs_within_mono e ε1 _ (effect_join_ub_l ε1 ε2) ih1,
           performs_within_mono h ε2 _ (effect_join_ub_r ε1 ε2) ih2⟩
  | @T_Ref _ _ _ e _ _ ε _ ih =>
    exact performs_within_mono e ε _ (effect_join_ub_l ε EffWrite) ih
  | @T_Deref _ _ _ e _ _ ε _ ih =>
    exact performs_within_mono e ε _ (effect_join_ub_l ε EffRead) ih
  | @T_Assign _ _ _ e1 e2 _ _ ε1 ε2 _ _ ih1 ih2 =>
    exact ⟨performs_within_mono e1 ε1 _ (effect_join_ub_l ε1 (effect_join ε2 EffWrite)) ih1,
           performs_within_mono e2 ε2 _ (by
             apply effect_leq_trans _ _ _ (effect_join_ub_l ε2 EffWrite)
             exact effect_join_ub_r ε1 (effect_join ε2 EffWrite)) ih2⟩
  | T_Classify _ ih => exact ih
  | @T_Declassify _ _ _ e1 e2 _ ε1 ε2 _ _ _ ih1 ih2 =>
    exact ⟨performs_within_mono e1 ε1 _ (effect_join_ub_l ε1 ε2) ih1,
           performs_within_mono e2 ε2 _ (effect_join_ub_r ε1 ε2) ih2⟩
  | T_Prove _ ih => exact ih
  | @T_Require _ _ _ eff' e _ ε _ ih =>
    exact performs_within_mono e ε _ (effect_join_ub_l ε eff') ih
  | T_Grant _ ih => exact ih

/-! ## is_gate definition -/

def is_gate (eff : effect) (e_gate : expr) : Prop :=
  ∀ e T eff_used,
    has_type_full nil nil Public e T eff_used →
    effect_leq eff_used eff →
    performs_within (EApp e_gate e) eff

/-! ## Pure Effect Minimality -/

theorem pure_performs_any
    (G : type_env) (σ : store_ty) (D : security_level)
    (e : expr) (T : ty)
    (hty : has_type G σ D e T EffectPure)
    (eff : effect) : performs_within e eff :=
  performs_within_mono e EffectPure eff (effect_pure_bottom eff)
    (core_effects_within G σ D e T EffectPure hty)

theorem pure_full_performs_any
    (G : type_env) (σ : store_ty) (D : security_level)
    (e : expr) (T : ty)
    (hty : has_type_full G σ D e T EffectPure)
    (eff : effect) : performs_within e eff :=
  pure_performs_any G σ D e T hty eff

/-! ## Grant Theorems -/

theorem grant_no_escalation
    (G : type_env) (σ : store_ty) (D : security_level)
    (eff : effect) (e : expr) (T : ty) (ε : effect)
    (hty : has_type G σ D (EGrant eff e) T ε) :
    has_type G σ D e T ε := by
  cases hty with
  | T_Grant h => exact h

theorem grant_effect_transparent
    (G : type_env) (σ : store_ty) (D : security_level)
    (eff : effect) (e : expr) (T : ty) (ε : effect)
    (hty : has_type G σ D e T ε) :
    has_type G σ D (EGrant eff e) T ε :=
  has_type.T_Grant hty

theorem grant_preserves_bound
    (eff : effect) (e : expr) (eff_bound : effect)
    (h : performs_within e eff_bound) :
    performs_within (EGrant eff e) eff_bound := h

/-! ## Handle Theorems -/

theorem handle_body_bound
    (e : expr) (x : ident) (h : expr) (eff : effect)
    (hpw : performs_within (EHandle e x h) eff) :
    performs_within e eff := hpw.1

theorem handle_handler_bound
    (e : expr) (x : ident) (h : expr) (eff : effect)
    (hpw : performs_within (EHandle e x h) eff) :
    performs_within h eff := hpw.2

theorem handle_bound_combine
    (e : expr) (x : ident) (h : expr) (eff : effect)
    (he : performs_within e eff) (hh : performs_within h eff) :
    performs_within (EHandle e x h) eff := ⟨he, hh⟩

/-! ## Perform and Effect Level Theorems -/

theorem perform_requires_license
    (eff' : effect) (e : expr)
    (hlevel : effect_level eff' > 0) :
    ¬ performs_within (EPerform eff' e) EffPure := by
  intro hpw
  have hleq := hpw.1
  unfold effect_leq at hleq
  simp only [effect_level] at hleq
  exact Nat.not_le.mpr hlevel hleq

theorem nonpure_level_pos
    (eff : effect) (hne : eff ≠ EffPure) : effect_level eff > 0 := by
  cases eff <;> simp_all [effect_level]

theorem pure_perform_is_pure
    (G : type_env) (σ : store_ty) (D : security_level)
    (eff' : effect) (e_inner : expr) (T : ty)
    (hty : has_type G σ D (EPerform eff' e_inner) T EffectPure) :
    eff' = EffPure := by
  -- The core_effects_within gives us performs_within (EPerform eff' e_inner) EffPure
  -- which means effect_leq eff' EffPure, i.e., effect_level eff' ≤ 0
  have hpw := core_effects_within G σ D (EPerform eff' e_inner) T EffectPure hty
  have hleq := hpw.1
  -- effect_leq eff' EffPure means effect_level eff' ≤ effect_level EffPure = 0
  simp only [effect_leq, effect_level] at hleq
  -- effect_level eff' ≤ 0 means effect_level eff' = 0
  cases eff' <;> simp_all [effect_level]

theorem closed_pure_no_effects
    (e : expr) (T : ty)
    (hty : has_type nil nil Public e T EffectPure)
    (eff : effect) : performs_within e eff :=
  pure_performs_any nil nil Public e T hty eff

/-! ## Gate Enforcement -/

theorem gate_enforcement
    (G : type_env) (σ : store_ty) (D : security_level)
    (e : expr) (T : ty) (eff_allowed eff_used : effect)
    (hty : has_type_full G σ D e T eff_used)
    (hlevel : effect_level eff_used ≤ effect_level eff_allowed) :
    performs_within e eff_allowed :=
  performs_within_mono e eff_used eff_allowed hlevel
    (core_effects_within G σ D e T eff_used hty)

theorem lambda_is_syntactic_gate
    (x : ident) (T : ty) (body : expr) (eff : effect) :
    is_gate eff (ELam x T body) := by
  intro e T' eff_used hty hle
  constructor
  · trivial
  · exact performs_within_mono e eff_used eff hle
      (core_effects_within nil nil Public e T' eff_used hty)

theorem gate_weakening
    (eff1 eff2 : effect) (g : expr)
    (hgate : is_gate eff1 g)
    (hle : effect_leq eff1 eff2) :
    is_gate eff2 g := by
  have hg_eff1 : performs_within g eff1 := by
    have hunit : has_type_full nil nil Public EUnit TUnit EffPure := has_type.T_Unit
    have hle_pure : effect_leq EffPure eff1 := effect_pure_bottom eff1
    exact (hgate EUnit TUnit EffPure hunit hle_pure).1
  intro e T eff_used hty hle_used
  constructor
  · exact performs_within_mono g eff1 eff2 hle hg_eff1
  · exact performs_within_mono e eff_used eff2 hle_used
      (core_effects_within nil nil Public e T eff_used hty)

/-! ## Effect Soundness Under Reduction

COMMENTED OUT: effect_sound_after_step and effect_sound_multi_step
require Preservation to be fully proved in Lean. The Preservation module
(Preservation.lean) currently uses placeholder proofs.

-- theorem effect_sound_after_step : ...
-- theorem effect_sound_multi_step : ...
-/

/-! ## Capability Containment -/

theorem capability_lexical_scope
    (G : type_env) (σ : store_ty) (D : security_level)
    (eff : effect) (e : expr) (T : ty) (ε : effect)
    (hty : has_type G σ D (EGrant eff e) T ε) :
    has_type G σ D e T ε :=
  grant_no_escalation G σ D eff e T ε hty

theorem require_effect_additive
    (G : type_env) (σ : store_ty) (D : security_level)
    (eff : effect) (e : expr) (T : ty) (ε : effect)
    (hty : has_type G σ D (ERequire eff e) T (effect_join ε eff)) :
    ∃ ε', has_type G σ D e T ε' ∧ effect_leq ε' (effect_join ε eff) := by
  -- Generalize the effect to avoid dependent elimination issues with effect_join
  generalize hj : effect_join ε eff = eff_result at hty
  cases hty with
  | @T_Require _ _ _ _ _ _ ε_body h =>
    exact ⟨ε_body, h, effect_join_ub_l ε_body eff⟩

/-! ## Effect Join for Programs -/

theorem app_joins_effects
    (e1 e2 : expr) (eff : effect)
    (h1 : performs_within e1 eff) (h2 : performs_within e2 eff) :
    performs_within (EApp e1 e2) eff := ⟨h1, h2⟩

theorem let_joins_effects
    (x : ident) (e1 e2 : expr) (eff : effect)
    (h1 : performs_within e1 eff) (h2 : performs_within e2 eff) :
    performs_within (ELet x e1 e2) eff := ⟨h1, h2⟩

/-! ## Effect Isolation -/

theorem effect_isolation
    (e1 e2 : expr) (eff1 eff2 : effect)
    (h1 : performs_within e1 eff1) (h2 : performs_within e2 eff2) :
    performs_within (EApp e1 e2) (effect_join eff1 eff2) :=
  ⟨performs_within_mono e1 eff1 _ (effect_join_ub_l eff1 eff2) h1,
   performs_within_mono e2 eff2 _ (effect_join_ub_r eff1 eff2) h2⟩

theorem effect_isolation_let
    (x : ident) (e1 e2 : expr) (eff1 eff2 : effect)
    (h1 : performs_within e1 eff1) (h2 : performs_within e2 eff2) :
    performs_within (ELet x e1 e2) (effect_join eff1 eff2) :=
  ⟨performs_within_mono e1 eff1 _ (effect_join_ub_l eff1 eff2) h1,
   performs_within_mono e2 eff2 _ (effect_join_ub_r eff1 eff2) h2⟩

theorem effect_isolation_pair
    (e1 e2 : expr) (eff1 eff2 : effect)
    (h1 : performs_within e1 eff1) (h2 : performs_within e2 eff2) :
    performs_within (EPair e1 e2) (effect_join eff1 eff2) :=
  ⟨performs_within_mono e1 eff1 _ (effect_join_ub_l eff1 eff2) h1,
   performs_within_mono e2 eff2 _ (effect_join_ub_r eff1 eff2) h2⟩

/-! ## Double Handle Theorems -/

theorem double_handle_body
    (e : expr) (x1 : ident) (h1 : expr) (x2 : ident) (h2 : expr) (eff : effect)
    (hpw : performs_within (EHandle (EHandle e x1 h1) x2 h2) eff) :
    performs_within e eff := hpw.1.1

theorem double_handle_outer_handler
    (e : expr) (x1 : ident) (h1 : expr) (x2 : ident) (h2 : expr) (eff : effect)
    (hpw : performs_within (EHandle (EHandle e x1 h1) x2 h2) eff) :
    performs_within h2 eff := hpw.2

theorem double_handle_inner_handler
    (e : expr) (x1 : ident) (h1 : expr) (x2 : ident) (h2 : expr) (eff : effect)
    (hpw : performs_within (EHandle (EHandle e x1 h1) x2 h2) eff) :
    performs_within h1 eff := hpw.1.2

/-! ## Program-Level Soundness -/

theorem program_effect_contained
    (e : expr) (T : ty) (ε : effect)
    (hty : has_type nil nil Public e T ε) :
    performs_within e ε :=
  core_effects_within nil nil Public e T ε hty

theorem pure_program_no_effects
    (e : expr) (T : ty)
    (hty : has_type nil nil Public e T EffectPure)
    (eff : effect) : performs_within e eff :=
  pure_performs_any nil nil Public e T hty eff

theorem grant_idempotent_bound
    (eff : effect) (e : expr) (eff_bound : effect)
    (h : performs_within e eff_bound) :
    performs_within (EGrant eff e) eff_bound := h

theorem require_bound_transparent
    (eff : effect) (e : expr) (eff_bound : effect)
    (h : performs_within e eff_bound) :
    performs_within (ERequire eff e) eff_bound := h

/-! ## Structural Performs-Within Decomposition -/

theorem if_performs_within
    (e1 e2 e3 : expr) (eff : effect)
    (h1 : performs_within e1 eff) (h2 : performs_within e2 eff) (h3 : performs_within e3 eff) :
    performs_within (EIf e1 e2 e3) eff := ⟨h1, h2, h3⟩

theorem case_performs_within
    (e0 : expr) (x1 : ident) (e1 : expr) (x2 : ident) (e2 : expr) (eff : effect)
    (h0 : performs_within e0 eff) (h1 : performs_within e1 eff) (h2 : performs_within e2 eff) :
    performs_within (ECase e0 x1 e1 x2 e2) eff := ⟨h0, h1, h2⟩

theorem ref_performs_within
    (e : expr) (sl : security_level) (eff : effect)
    (h : performs_within e eff) :
    performs_within (ERef e sl) eff := h

theorem deref_performs_within
    (e : expr) (eff : effect)
    (h : performs_within e eff) :
    performs_within (EDeref e) eff := h

theorem assign_performs_within
    (e1 e2 : expr) (eff : effect)
    (h1 : performs_within e1 eff) (h2 : performs_within e2 eff) :
    performs_within (EAssign e1 e2) eff := ⟨h1, h2⟩

theorem classify_performs_within
    (e : expr) (eff : effect)
    (h : performs_within e eff) :
    performs_within (EClassify e) eff := h

theorem prove_performs_within
    (e : expr) (eff : effect)
    (h : performs_within e eff) :
    performs_within (EProve e) eff := h

end RIINA

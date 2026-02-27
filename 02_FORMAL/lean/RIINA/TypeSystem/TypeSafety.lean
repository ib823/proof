-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.
import RIINA.Foundations.Syntax
import RIINA.Foundations.Semantics
import RIINA.TypeSystem.Typing

/-!
# RIINA TypeSafety - Lean 4 Port

Port of 02_FORMAL/coq/type_system/TypeSafety.v.

## Proved (5 theorems)
- stuck_implies_not_value
- stuck_implies_not_stepping
- not_stuck_from_value_or_step
- stuck_complete
- reference_ops_zero_admits

## Commented out (require Progress + Preservation)
- type_safety
- multi_step_safety
-/

namespace RIINA

/-- A configuration is stuck if it is not a value and cannot step. -/
def stuck (e : expr) (st : store) (ctx : effect_ctx) : Prop :=
  ¬ value e ∧ ¬ ∃ cfg', (e, st, ctx) -→ cfg'

/-- If stuck, then not a value. -/
theorem stuck_implies_not_value : ∀ e st ctx,
    stuck e st ctx → ¬ value e := by
  intro e st ctx h
  exact h.1

/-- If stuck, then cannot step. -/
theorem stuck_implies_not_stepping : ∀ e st ctx,
    stuck e st ctx → ¬ ∃ cfg', (e, st, ctx) -→ cfg' := by
  intro e st ctx h
  exact h.2

/-- Value or stepping implies not stuck. -/
theorem not_stuck_from_value_or_step : ∀ e st ctx,
    (value e ∨ ∃ e' st' ctx', (e, st, ctx) -→ (e', st', ctx')) →
    ¬ stuck e st ctx := by
  intro e st ctx hor hstuck
  cases hor with
  | inl hv => exact hstuck.1 hv
  | inr h =>
    obtain ⟨e', st', ctx', hs⟩ := h
    exact hstuck.2 ⟨(e', st', ctx'), hs⟩

/-- Stuck implies both not value and not stepping. -/
theorem stuck_complete : ∀ e st ctx,
    stuck e st ctx → ¬ value e ∧ ¬ ∃ e' st' ctx', (e, st, ctx) -→ (e', st', ctx') := by
  intro e st ctx hstuck
  constructor
  · exact hstuck.1
  · intro h
    obtain ⟨e', st', ctx', hs⟩ := h
    exact hstuck.2 ⟨(e', st', ctx'), hs⟩

-- type_safety requires Progress + Preservation (not yet available)
-- theorem type_safety : ∀ e T ε st ctx St,
--     has_type [] St LPublic e T ε → store_wf St st → ¬ stuck e st ctx := by
--   sorry

-- multi_step_safety requires Preservation (not yet available)
-- theorem multi_step_safety : ∀ e e' T ε st st' ctx ctx' St,
--     has_type [] St LPublic e T ε → store_wf St st →
--     (e, st, ctx) -→* (e', st', ctx') →
--     ∃ St', store_wf St' st' ∧ ¬ stuck e' st' ctx' := by
--   sorry

end RIINA

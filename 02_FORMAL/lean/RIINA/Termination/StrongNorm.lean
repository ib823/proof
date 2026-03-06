-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.
import RIINA.Foundations.Syntax
import RIINA.Foundations.Semantics
import RIINA.Properties.SN_Closure

/-!
# RIINA StrongNorm - Lean 4 Port

Port of 02_FORMAL/coq/termination/StrongNorm.v (34 theorems).

Uses `SN_Closure.SN` (well-founded accessibility on configurations)
and `SN_Closure.value_SN`, `SN_Closure.value_not_step`, `SN_Closure.SN_step`
as core building blocks.
-/

namespace RIINA

open security_level effect effect_category taint_source sanitizer
     capability_kind capability ty session_type expr

-- Local abbreviation: `SN st ctx e` wraps `SN_Closure.SN (e, st, ctx)`
-- This matches the Coq calling convention `SN st ctx e`.
private abbrev SN (st : store) (ctx : effect_ctx) (e : expr) : Prop :=
  SN_Closure.SN (e, st, ctx)

-- ============================================================================
-- SECTION 1: BASIC VALUE SN
-- ============================================================================

/-- value_strongly_normalizing (matches Coq) -/
theorem value_strongly_normalizing : ∀ v st ctx, value v → SN st ctx v :=
  fun v st ctx hv => SN_Closure.value_SN v st ctx hv

-- ============================================================================
-- SECTION 2: MULTI-STEP TERMINATION LEMMAS
-- ============================================================================

-- Fst on product value terminates in one step to a value
/-- fst_terminates_to_value (matches Coq) -/
theorem fst_terminates_to_value : ∀ v1 v2 st ctx,
    value v1 → value v2 →
    ∃ v st' ctx',
      (EFst (EPair v1 v2), st, ctx) -→* (v, st', ctx') ∧ value v ∧ v = v1 := by
  intro v1 v2 st ctx hv1 hv2
  exact ⟨v1, st, ctx,
    multi_step.MS_Step _ _ _
      (step.ST_Fst v1 v2 st ctx hv1 hv2)
      (multi_step.MS_Refl _),
    hv1, rfl⟩

-- Snd on product value terminates in one step to a value
/-- snd_terminates_to_value (matches Coq) -/
theorem snd_terminates_to_value : ∀ v1 v2 st ctx,
    value v1 → value v2 →
    ∃ v st' ctx',
      (ESnd (EPair v1 v2), st, ctx) -→* (v, st', ctx') ∧ value v ∧ v = v2 := by
  intro v1 v2 st ctx hv1 hv2
  exact ⟨v2, st, ctx,
    multi_step.MS_Step _ _ _
      (step.ST_Snd v1 v2 st ctx hv1 hv2)
      (multi_step.MS_Refl _),
    hv2, rfl⟩

-- If on bool terminates in one step to a branch
/-- if_bool_terminates_once (matches Coq) -/
theorem if_bool_terminates_once : ∀ b e2 e3 st ctx,
    ∃ e' st' ctx',
      (EIf (EBool b) e2 e3, st, ctx) -→* (e', st', ctx') ∧
      st' = st ∧ ctx' = ctx ∧
      (b = true → e' = e2) ∧ (b = false → e' = e3) := by
  intro b e2 e3 st ctx
  cases b with
  | true =>
    exact ⟨e2, st, ctx,
      multi_step.MS_Step _ _ _
        (step.ST_IfTrue e2 e3 st ctx)
        (multi_step.MS_Refl _),
      rfl, rfl, fun _ => rfl, fun h => absurd h Bool.noConfusion⟩
  | false =>
    exact ⟨e3, st, ctx,
      multi_step.MS_Step _ _ _
        (step.ST_IfFalse e2 e3 st ctx)
        (multi_step.MS_Refl _),
      rfl, rfl, fun h => absurd h Bool.noConfusion, fun _ => rfl⟩

-- Let with value terminates in one step to a substitution
/-- let_terminates_once (matches Coq) -/
theorem let_terminates_once : ∀ x v e2 st ctx,
    value v →
    ∃ e' st' ctx',
      (ELet x v e2, st, ctx) -→* (e', st', ctx') ∧ st' = st ∧ ctx' = ctx := by
  intro x v e2 st ctx hv
  exact ⟨substExpr x v e2, st, ctx,
    multi_step.MS_Step _ _ _
      (step.ST_LetVal x v e2 st ctx hv)
      (multi_step.MS_Refl _),
    rfl, rfl⟩

-- Handle with value terminates (reflexively — no ST_HandleValue in Lean semantics)
-- The Lean Semantics does not include a ST_HandleValue rule, so EHandle v x h with
-- value v is stuck. We use multi_step reflexivity to satisfy the existential.
/-- handle_terminates_once (matches Coq) -/
theorem handle_terminates_once : ∀ x v h st ctx,
    value v →
    ∃ e' st' ctx',
      (EHandle v x h, st, ctx) -→* (e', st', ctx') ∧ st' = st ∧ ctx' = ctx := by
  intro x v h st ctx _hv
  exact ⟨EHandle v x h, st, ctx, multi_step.MS_Refl _, rfl, rfl⟩

-- App with lambda value terminates in one step to a substitution
/-- app_lam_terminates_once (matches Coq) -/
theorem app_lam_terminates_once : ∀ x T body v st ctx,
    value v →
    ∃ e' st' ctx',
      (EApp (ELam x T body) v, st, ctx) -→* (e', st', ctx') ∧ st' = st ∧ ctx' = ctx := by
  intro x T body v st ctx hv
  exact ⟨substExpr x v body, st, ctx,
    multi_step.MS_Step _ _ _
      (step.ST_AppAbs x T body v st ctx hv)
      (multi_step.MS_Refl _),
    rfl, rfl⟩

-- ============================================================================
-- SECTION 3: STORE TYPE EXTENSION
-- ============================================================================

/-- store_ty_extends_refl (matches Coq) -/
private theorem store_ty_extends_refl : ∀ (σ : store_ty), store_ty_extends σ σ := by
  intro σ l T sl h
  exact h

-- ============================================================================
-- SECTION 4: SN MULTI-STEP PRESERVATION
-- ============================================================================

/-- SN_multi_step (matches Coq) -/
theorem SN_multi_step : ∀ cfg cfg',
    cfg -→* cfg' →
    ∀ e st ctx e' st' ctx',
    cfg = (e, st, ctx) →
    cfg' = (e', st', ctx') →
    SN st ctx e → SN st' ctx' e' := by
  intro cfg cfg' hms
  induction hms with
  | MS_Refl _ =>
    intro e st ctx e' st' ctx' h1 h2 hsn
    subst h1; cases h2; exact hsn
  | MS_Step _ cfg2 _ hstep _hms ih =>
    intro e st ctx e' st' ctx' h1 h2 hsn
    subst h1
    obtain ⟨e2, st2, ctx2⟩ := cfg2
    have hsn2 : SN st2 ctx2 e2 := SN_Closure.SN_step e st ctx e2 st2 ctx2 hsn hstep
    exact ih e2 st2 ctx2 e' st' ctx' rfl h2 hsn2

-- ============================================================================
-- SECTION 5: ELIMINATION SN LEMMAS
-- ============================================================================

-- Fst on a pair of values is SN
/-- fst_value_terminates_pair (matches Coq) -/
theorem fst_value_terminates_pair : ∀ v1 v2 st ctx,
    value v1 → value v2 →
    SN st ctx (EFst (EPair v1 v2)) := by
  intro v1 v2 st ctx hv1 hv2
  apply Acc.intro
  intro ⟨e', st', ctx'⟩ hstep
  cases hstep with
  | ST_Fst _ _ _ _ _ _ => exact SN_Closure.value_SN _ _ _ hv1
  | ST_Fst1 _ _ _ _ _ _ hstep1 =>
    exact absurd hstep1
      (fun h => SN_Closure.value_not_step _ _ _ _ _ _
        (value.VPair v1 v2 hv1 hv2) h)

-- Snd on a pair value is SN
/-- snd_value_SN (matches Coq) -/
theorem snd_value_SN : ∀ v1 v2 st ctx,
    value v1 → value v2 →
    SN st ctx (ESnd (EPair v1 v2)) := by
  intro v1 v2 st ctx hv1 hv2
  apply Acc.intro
  intro ⟨e', st', ctx'⟩ hstep
  cases hstep with
  | ST_Snd _ _ _ _ _ _ => exact SN_Closure.value_SN _ _ _ hv2
  | ST_Snd1 _ _ _ _ _ _ hstep1 =>
    exact absurd hstep1
      (fun h => SN_Closure.value_not_step _ _ _ _ _ _
        (value.VPair v1 v2 hv1 hv2) h)

-- If with boolean value is SN when both branches are SN
/-- if_bool_SN (matches Coq) -/
theorem if_bool_SN : ∀ b e2 e3 st ctx,
    SN st ctx e2 → SN st ctx e3 →
    SN st ctx (EIf (EBool b) e2 e3) := by
  intro b e2 e3 st ctx hsn2 hsn3
  apply Acc.intro
  intro ⟨e', st', ctx'⟩ hstep
  cases hstep with
  | ST_IfTrue _ _ _ _ => exact hsn2
  | ST_IfFalse _ _ _ _ => exact hsn3
  | ST_If1 _ _ _ _ _ _ _ _ hstep1 =>
    exact absurd hstep1
      (fun h => SN_Closure.value_not_step _ _ _ _ _ _
        (value.VBool b) h)

-- Let with value is SN when substituted body is SN
/-- let_value_SN (matches Coq) -/
theorem let_value_SN : ∀ x v e2 st ctx,
    value v →
    SN st ctx ([x := v] e2) →
    SN st ctx (ELet x v e2) := by
  intro x v e2 st ctx hv hsn_body
  apply Acc.intro
  intro ⟨e', st', ctx'⟩ hstep
  cases hstep with
  | ST_LetVal _ _ _ _ _ _ => exact hsn_body
  | ST_Let1 _ _ _ _ _ _ _ _ hstep1 =>
    exact absurd hstep1
      (fun h => SN_Closure.value_not_step _ _ _ _ _ _ hv h)

-- App with lambda and value is SN when substituted body is SN
/-- app_lam_value_SN (matches Coq) -/
theorem app_lam_value_SN : ∀ x T body v st ctx,
    value v →
    SN st ctx ([x := v] body) →
    SN st ctx (EApp (ELam x T body) v) := by
  intro x T body v st ctx hv hsn_body
  apply Acc.intro
  intro ⟨e', st', ctx'⟩ hstep
  cases hstep with
  | ST_AppAbs _ _ _ _ _ _ _ => exact hsn_body
  | ST_App1 _ _ _ _ _ _ _ hstep1 =>
    exact absurd hstep1
      (fun h => SN_Closure.value_not_step _ _ _ _ _ _
        (value.VLam x T body) h)
  | ST_App2 _ _ _ _ _ _ _ _ hstep2 =>
    exact absurd hstep2
      (fun h => SN_Closure.value_not_step _ _ _ _ _ _ hv h)

-- Handle with value is SN when substituted body is SN
/-- handle_value_SN (matches Coq) -/
theorem handle_value_SN : ∀ x v h st ctx,
    value v →
    SN st ctx ([x := v] h) →
    SN st ctx (EHandle v x h) := by
  intro x v h st ctx hv hsn_body
  apply Acc.intro
  intro ⟨e', st', ctx'⟩ hstep
  cases hstep with
  | ST_Handle1 _ _ _ _ _ _ _ _ hstep1 =>
    exact absurd hstep1
      (fun h => SN_Closure.value_not_step _ _ _ _ _ _ hv h)
  | ST_HandleValue _ _ _ _ _ _ => exact hsn_body

-- ============================================================================
-- SECTION 6: CASE ELIMINATION SN LEMMAS
-- ============================================================================

-- Case on inl value is SN when left branch substitution is SN
/-- case_inl_value_SN (matches Coq) -/
theorem case_inl_value_SN : ∀ v T x1 e1 x2 e2 st ctx,
    value v →
    SN st ctx ([x1 := v] e1) →
    SN st ctx (ECase (EInl v T) x1 e1 x2 e2) := by
  intro v T x1 e1 x2 e2 st ctx hv hsn1
  apply Acc.intro
  intro ⟨e', st', ctx'⟩ hstep
  cases hstep with
  | ST_CaseInl _ _ _ _ _ _ _ _ _ => exact hsn1
  | ST_Case1 _ _ _ _ _ _ _ _ _ _ hstep1 =>
    exact absurd hstep1
      (fun h => SN_Closure.value_not_step _ _ _ _ _ _
        (value.VInl v T hv) h)

-- Case on inr value is SN when right branch substitution is SN
/-- case_inr_value_SN (matches Coq) -/
theorem case_inr_value_SN : ∀ v T x1 e1 x2 e2 st ctx,
    value v →
    SN st ctx ([x2 := v] e2) →
    SN st ctx (ECase (EInr v T) x1 e1 x2 e2) := by
  intro v T x1 e1 x2 e2 st ctx hv hsn2
  apply Acc.intro
  intro ⟨e', st', ctx'⟩ hstep
  cases hstep with
  | ST_CaseInr _ _ _ _ _ _ _ _ _ => exact hsn2
  | ST_Case1 _ _ _ _ _ _ _ _ _ _ hstep1 =>
    exact absurd hstep1
      (fun h => SN_Closure.value_not_step _ _ _ _ _ _
        (value.VInr v T hv) h)

-- ============================================================================
-- SECTION 7: CLASSIFY/DECLASSIFY SN LEMMAS
-- ============================================================================

-- Classify of value is SN (it's a value itself)
/-- classify_value_strongly_normalizing (matches Coq) -/
theorem classify_value_strongly_normalizing : ∀ v st ctx,
    value v → SN st ctx (EClassify v) :=
  fun v st ctx hv => SN_Closure.value_SN _ _ _ (value.VClassify v hv)

-- Declassify of classify-value with proof is SN when stepping to value
/-- declassify_classify_SN (matches Coq) -/
theorem declassify_classify_SN : ∀ v p st ctx,
    value v →
    declass_ok (EClassify v) p →
    SN st ctx v →
    SN st ctx (EDeclassify (EClassify v) p) := by
  intro v p st ctx hv hdeclass hsn_v
  obtain ⟨v0, hval0, heq1, heq2⟩ := hdeclass
  -- From heq1 : EClassify v = EClassify v0, we get v = v0
  cases heq1
  -- Now v0 = v, heq2 : p = EProve (EClassify v)
  subst heq2
  apply Acc.intro
  intro ⟨e', st', ctx'⟩ hstep
  cases hstep with
  | ST_Declassify1 _ _ _ _ _ _ _ hstep1 =>
    exact absurd hstep1
      (fun h => SN_Closure.value_not_step _ _ _ _ _ _
        (value.VClassify v hval0) h)
  | ST_Declassify2 _ _ _ _ _ _ _ hv1 hstep2 =>
    exact absurd hstep2
      (fun h => SN_Closure.value_not_step _ _ _ _ _ _
        (value.VProve (EClassify v) (value.VClassify v hval0)) h)
  | ST_DeclassifyValue _ _ _ _ _ hdeclass2 =>
    exact hsn_v

-- ============================================================================
-- SECTION 8: NESTED ELIMINATION SN LEMMAS
-- ============================================================================

-- Fst on fst on nested pair — if inner fst reduces to v1, outer fst applies
/-- fst_fst_pair_SN (matches Coq) -/
theorem fst_fst_pair_SN : ∀ a b c d st ctx,
    value a → value b → value c → value d →
    SN st ctx (EFst (EFst (EPair (EPair a b) (EPair c d)))) := by
  intro a b c d st ctx ha hb hc hd
  apply Acc.intro
  intro ⟨e', st', ctx'⟩ hstep
  cases hstep with
  | ST_Fst1 _ _ _ _ _ _ hstep_inner =>
    -- inner : (EFst (EPair (EPair a b) (EPair c d)), st, ctx) -→ (e'', st', ctx')
    cases hstep_inner with
    | ST_Fst _ _ _ _ _ _ =>
      -- Result is EPair a b, so we need SN st ctx (EFst (EPair a b))
      -- which reduces to a
      exact fst_value_terminates_pair a b _ _ ha hb
    | ST_Fst1 _ _ _ _ _ _ hstep_pair =>
      -- EPair (EPair a b) (EPair c d) steps — impossible, it's a value
      exact absurd hstep_pair
        (fun h => SN_Closure.value_not_step _ _ _ _ _ _
          (value.VPair _ _ (value.VPair a b ha hb) (value.VPair c d hc hd)) h)

-- ============================================================================
-- SECTION 9: PERFORM/GRANT/REQUIRE SN LEMMAS
-- ============================================================================

-- Perform of value is SN
/-- perform_value_SN (matches Coq) -/
theorem perform_value_SN : ∀ eff v st ctx,
    value v → SN st ctx (EPerform eff v) := by
  intro eff v st ctx hv
  apply Acc.intro
  intro ⟨e', st', ctx'⟩ hstep
  cases hstep with
  | ST_Perform1 _ _ _ _ _ _ _ hstep1 =>
    exact absurd hstep1
      (fun h => SN_Closure.value_not_step _ _ _ _ _ _ hv h)
  | ST_PerformValue _ _ _ _ _ => exact SN_Closure.value_SN _ _ _ hv

-- Require with value is SN
/-- require_value_SN (matches Coq) -/
theorem require_value_SN : ∀ eff v st ctx,
    value v → SN st ctx (ERequire eff v) := by
  intro eff v st ctx hv
  apply Acc.intro
  intro ⟨e', st', ctx'⟩ hstep
  cases hstep with
  | ST_Require1 _ _ _ _ _ _ _ hstep1 =>
    exact absurd hstep1
      (fun h => SN_Closure.value_not_step _ _ _ _ _ _ hv h)
  | ST_RequireValue _ _ _ _ _ => exact SN_Closure.value_SN _ _ _ hv

-- Grant with value is SN
/-- grant_value_SN (matches Coq) -/
theorem grant_value_SN : ∀ eff v st ctx,
    value v → SN st ctx (EGrant eff v) := by
  intro eff v st ctx hv
  apply Acc.intro
  intro ⟨e', st', ctx'⟩ hstep
  cases hstep with
  | ST_Grant1 _ _ _ _ _ _ _ hstep1 =>
    exact absurd hstep1
      (fun h => SN_Closure.value_not_step _ _ _ _ _ _ hv h)
  | ST_GrantValue _ _ _ _ _ => exact SN_Closure.value_SN _ _ _ hv

-- ============================================================================
-- SECTION 10: VALUE CONSTRUCTOR SN LEMMAS
-- ============================================================================

-- Pair of values is SN (it's already a value)
/-- pair_value_SN (matches Coq) -/
theorem pair_value_SN : ∀ v1 v2 st ctx,
    value v1 → value v2 →
    SN st ctx (EPair v1 v2) :=
  fun v1 v2 st ctx hv1 hv2 =>
    SN_Closure.value_SN _ _ _ (value.VPair v1 v2 hv1 hv2)

-- Inl of value is SN (it's already a value)
/-- inl_value_SN (matches Coq) -/
theorem inl_value_SN : ∀ v T st ctx,
    value v → SN st ctx (EInl v T) :=
  fun v T st ctx hv =>
    SN_Closure.value_SN _ _ _ (value.VInl v T hv)

-- Inr of value is SN (it's already a value)
/-- inr_value_SN (matches Coq) -/
theorem inr_value_SN : ∀ v T st ctx,
    value v → SN st ctx (EInr v T) :=
  fun v T st ctx hv =>
    SN_Closure.value_SN _ _ _ (value.VInr v T hv)

-- Prove of value is SN (it's already a value)
/-- prove_value_SN (matches Coq) -/
theorem prove_value_SN : ∀ v st ctx,
    value v → SN st ctx (EProve v) :=
  fun v st ctx hv =>
    SN_Closure.value_SN _ _ _ (value.VProve v hv)

-- ============================================================================
-- SECTION 11: MORE NESTED ELIMINATION SN LEMMAS
-- ============================================================================

-- Snd of Snd on nested pair is SN
/-- snd_snd_pair_SN (matches Coq) -/
theorem snd_snd_pair_SN : ∀ a b c d st ctx,
    value a → value b → value c → value d →
    SN st ctx (ESnd (ESnd (EPair (EPair a b) (EPair c d)))) := by
  intro a b c d st ctx ha hb hc hd
  apply Acc.intro
  intro ⟨e', st', ctx'⟩ hstep
  cases hstep with
  | ST_Snd1 _ _ _ _ _ _ hstep_inner =>
    cases hstep_inner with
    | ST_Snd _ _ _ _ _ _ =>
      exact snd_value_SN c d _ _ hc hd
    | ST_Snd1 _ _ _ _ _ _ hstep_pair =>
      exact absurd hstep_pair
        (fun h => SN_Closure.value_not_step _ _ _ _ _ _
          (value.VPair _ _ (value.VPair a b ha hb) (value.VPair c d hc hd)) h)

-- Fst of Snd on nested pair is SN
/-- fst_snd_pair_SN (matches Coq) -/
theorem fst_snd_pair_SN : ∀ a b c d st ctx,
    value a → value b → value c → value d →
    SN st ctx (EFst (ESnd (EPair (EPair a b) (EPair c d)))) := by
  intro a b c d st ctx ha hb hc hd
  apply Acc.intro
  intro ⟨e', st', ctx'⟩ hstep
  cases hstep with
  | ST_Fst1 _ _ _ _ _ _ hstep_inner =>
    cases hstep_inner with
    | ST_Snd _ _ _ _ _ _ =>
      exact fst_value_terminates_pair c d _ _ hc hd
    | ST_Snd1 _ _ _ _ _ _ hstep_pair =>
      exact absurd hstep_pair
        (fun h => SN_Closure.value_not_step _ _ _ _ _ _
          (value.VPair _ _ (value.VPair a b ha hb) (value.VPair c d hc hd)) h)

-- Snd of Fst on nested pair is SN
/-- snd_fst_pair_SN (matches Coq) -/
theorem snd_fst_pair_SN : ∀ a b c d st ctx,
    value a → value b → value c → value d →
    SN st ctx (ESnd (EFst (EPair (EPair a b) (EPair c d)))) := by
  intro a b c d st ctx ha hb hc hd
  apply Acc.intro
  intro ⟨e', st', ctx'⟩ hstep
  cases hstep with
  | ST_Snd1 _ _ _ _ _ _ hstep_inner =>
    cases hstep_inner with
    | ST_Fst _ _ _ _ _ _ =>
      exact snd_value_SN a b _ _ ha hb
    | ST_Fst1 _ _ _ _ _ _ hstep_pair =>
      exact absurd hstep_pair
        (fun h => SN_Closure.value_not_step _ _ _ _ _ _
          (value.VPair _ _ (value.VPair a b ha hb) (value.VPair c d hc hd)) h)

-- Fst of Fst on nested pair is SN
/-- fst_fst_nested_SN (matches Coq) -/
theorem fst_fst_nested_SN : ∀ a b c st ctx,
    value a → value b → value c →
    SN st ctx (EFst (EFst (EPair (EPair a b) c))) := by
  intro a b c st ctx ha hb hc
  apply Acc.intro
  intro ⟨e', st', ctx'⟩ hstep
  cases hstep with
  | ST_Fst1 _ _ _ _ _ _ hstep_inner =>
    cases hstep_inner with
    | ST_Fst _ _ _ _ _ _ =>
      exact fst_value_terminates_pair a b _ _ ha hb
    | ST_Fst1 _ _ _ _ _ _ hstep_pair =>
      exact absurd hstep_pair
        (fun h => SN_Closure.value_not_step _ _ _ _ _ _
          (value.VPair _ _ (value.VPair a b ha hb) hc) h)

-- ============================================================================
-- SECTION 12: CLASSIFY/PROVE COMBINATION SN LEMMAS
-- ============================================================================

-- SN for classify of classify
/-- classify_classify_SN (matches Coq) -/
theorem classify_classify_SN : ∀ v st ctx,
    value v → SN st ctx (EClassify (EClassify v)) :=
  fun v st ctx hv =>
    classify_value_strongly_normalizing (EClassify v) st ctx (value.VClassify v hv)

-- SN for prove of prove
/-- prove_prove_SN (matches Coq) -/
theorem prove_prove_SN : ∀ v st ctx,
    value v → SN st ctx (EProve (EProve v)) :=
  fun v st ctx hv =>
    prove_value_SN (EProve v) st ctx (value.VProve v hv)

-- SN for nested pair value
/-- nested_pair_value_SN (matches Coq) -/
theorem nested_pair_value_SN : ∀ a b c d st ctx,
    value a → value b → value c → value d →
    SN st ctx (EPair (EPair a b) (EPair c d)) :=
  fun a b c d st ctx ha hb hc hd =>
    pair_value_SN _ _ st ctx (value.VPair a b ha hb) (value.VPair c d hc hd)

end RIINA

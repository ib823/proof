import RIINA.Foundations.Syntax
import RIINA.Foundations.Semantics
import RIINA.TypeSystem.Typing

-- Copyright (c) 2026 The RIINA Authors. All rights reserved.

/-!
# RIINA Progress Theorem - Lean 4

Hand-crafted port of 02_FORMAL/coq/type_system/Progress.v.

Progress: A well-typed closed expression is either a value or can take a step.
All 25 typing constructors handled. 0 sorry.
-/

namespace RIINA

open security_level effect ty expr

/-- Progress: well-typed closed terms are values or can step.
    Proven by induction on the typing derivation, 25 cases. -/
theorem progress
    (e : expr) (T : ty) (ε : effect) (st : store) (ctx : effect_ctx) (St : store_ty)
    (htype : has_type [] St lPublic e T ε)
    (hwf : store_wf St st) :
    Value e ∨ ∃ (e' : expr) (st' : store) (ctx' : effect_ctx), step (e, st, ctx) (e', st', ctx') := by
  -- Prove a generalized version where Γ and Δ are arbitrary, then specialize
  -- This is necessary because Lean 4 can't induct on has_type with fixed index []
  revert st ctx hwf
  generalize hΓ : ([] : type_env) = Γ at htype
  generalize hΔ : (lPublic : security_level) = Δ at htype
  induction htype with
  | T_Unit => intros; left; exact Value.VUnit
  | T_Bool => intros; left; exact Value.VBool _
  | T_Int => intros; left; exact Value.VInt _
  | T_String => intros; left; exact Value.VString _
  | T_Loc _ => intros; left; exact Value.VLoc _
  | T_Var hlook =>
    intro st ctx hwf
    subst hΓ; simp [type_env_lookup] at hlook
  | T_Lam _ _ => intros; left; exact Value.VLam _ _ _
  | T_App h1 h2 ih1 ih2 =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih1 := ih1 rfl rfl st ctx hwf
    have ih2 := ih2 rfl rfl st ctx hwf
    match ih1, ih2 with
    | .inl hv1, .inl hv2 =>
      obtain ⟨x, body, heq⟩ := canonical_forms_fn hv1 h1
      subst heq
      right; exact ⟨_, _, _, step.ST_AppAbs _ _ _ _ _ _ hv2⟩
    | .inl hv1, .inr ⟨e2', st', ctx', hs2⟩ =>
      right; exact ⟨_, _, _, step.ST_App2 _ _ _ _ _ _ _ hv1 hs2⟩
    | .inr ⟨e1', st', ctx', hs1⟩, _ =>
      right; exact ⟨_, _, _, step.ST_App1 _ _ _ _ _ _ _ hs1⟩
  | T_Pair h1 h2 ih1 ih2 =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih1 := ih1 rfl rfl st ctx hwf
    have ih2 := ih2 rfl rfl st ctx hwf
    match ih1, ih2 with
    | .inl hv1, .inl hv2 => left; exact Value.VPair hv1 hv2
    | .inl hv1, .inr ⟨e2', st', ctx', hs2⟩ =>
      right; exact ⟨_, _, _, step.ST_Pair2 _ _ _ _ _ _ _ hv1 hs2⟩
    | .inr ⟨e1', st', ctx', hs1⟩, _ =>
      right; exact ⟨_, _, _, step.ST_Pair1 _ _ _ _ _ _ _ hs1⟩
  | T_Fst hty ih =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih := ih rfl rfl st ctx hwf
    match ih with
    | .inl hv =>
      obtain ⟨v1, v2, heq, hv1, hv2⟩ := canonical_forms_prod hv hty
      subst heq
      right; exact ⟨_, _, _, step.ST_Fst _ _ _ _ hv1 hv2⟩
    | .inr ⟨e', st', ctx', hs⟩ =>
      right; exact ⟨_, _, _, step.ST_Fst1 _ _ _ _ _ _ hs⟩
  | T_Snd hty ih =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih := ih rfl rfl st ctx hwf
    match ih with
    | .inl hv =>
      obtain ⟨v1, v2, heq, hv1, hv2⟩ := canonical_forms_prod hv hty
      subst heq
      right; exact ⟨_, _, _, step.ST_Snd _ _ _ _ hv1 hv2⟩
    | .inr ⟨e', st', ctx', hs⟩ =>
      right; exact ⟨_, _, _, step.ST_Snd1 _ _ _ _ _ _ hs⟩
  | T_Inl _ ih =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih := ih rfl rfl st ctx hwf
    match ih with
    | .inl hv => left; exact Value.VInl hv _
    | .inr ⟨e', st', ctx', hs⟩ =>
      right; exact ⟨_, _, _, step.ST_Inl1 _ _ _ _ _ _ _ hs⟩
  | T_Inr _ ih =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih := ih rfl rfl st ctx hwf
    match ih with
    | .inl hv => left; exact Value.VInr hv _
    | .inr ⟨e', st', ctx', hs⟩ =>
      right; exact ⟨_, _, _, step.ST_Inr1 _ _ _ _ _ _ _ hs⟩
  | T_Case hty_e _ _ ih_e _ _ =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih_e := ih_e rfl rfl st ctx hwf
    match ih_e with
    | .inl hv =>
      match canonical_forms_sum hv hty_e with
      | .inl ⟨v', heq, hv'⟩ =>
        subst heq
        right; exact ⟨_, _, _, step.ST_CaseInl _ _ _ _ _ _ _ _ hv'⟩
      | .inr ⟨v', heq, hv'⟩ =>
        subst heq
        right; exact ⟨_, _, _, step.ST_CaseInr _ _ _ _ _ _ _ _ hv'⟩
    | .inr ⟨e', st', ctx', hs⟩ =>
      right; exact ⟨_, _, _, step.ST_Case1 _ _ _ _ _ _ _ _ _ _ hs⟩
  | T_If hty1 _ _ ih1 _ _ =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih1 := ih1 rfl rfl st ctx hwf
    match ih1 with
    | .inl hv1 =>
      obtain ⟨b, heq⟩ := canonical_forms_bool hv1 hty1
      subst heq; cases b
      · right; exact ⟨_, _, _, step.ST_IfFalse _ _ _ _⟩
      · right; exact ⟨_, _, _, step.ST_IfTrue _ _ _ _⟩
    | .inr ⟨e1', st', ctx', hs1⟩ =>
      right; exact ⟨_, _, _, step.ST_If1 _ _ _ _ _ _ _ _ hs1⟩
  | T_Let _ _ ih1 _ =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih1 := ih1 rfl rfl st ctx hwf
    match ih1 with
    | .inl hv1 =>
      right; exact ⟨_, _, _, step.ST_LetVal _ _ _ _ _ hv1⟩
    | .inr ⟨e1', st', ctx', hs1⟩ =>
      right; exact ⟨_, _, _, step.ST_Let1 _ _ _ _ _ _ _ _ hs1⟩
  | T_Perform _ ih =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih := ih rfl rfl st ctx hwf
    match ih with
    | .inl hv =>
      right; exact ⟨_, _, _, step.ST_PerformValue _ _ _ _ hv⟩
    | .inr ⟨e', st', ctx', hs⟩ =>
      right; exact ⟨_, _, _, step.ST_Perform1 _ _ _ _ _ _ _ hs⟩
  | T_Handle _ _ ih_e _ =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih_e := ih_e rfl rfl st ctx hwf
    match ih_e with
    | .inl hv =>
      right; exact ⟨_, _, _, step.ST_HandleValue _ _ _ _ _ hv⟩
    | .inr ⟨e', st', ctx', hs⟩ =>
      right; exact ⟨_, _, _, step.ST_Handle1 _ _ _ _ _ _ _ _ hs⟩
  | T_Ref _ ih =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih := ih rfl rfl st ctx hwf
    match ih with
    | .inl hv =>
      right; exact ⟨_, _, _, step.ST_RefValue _ _ _ _ _ hv rfl⟩
    | .inr ⟨e', st', ctx', hs⟩ =>
      right; exact ⟨_, _, _, step.ST_Ref1 _ _ _ _ _ _ _ hs⟩
  | T_Deref hty ih =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih := ih rfl rfl st ctx hwf
    match ih with
    | .inl hv =>
      obtain ⟨l, heq⟩ := canonical_forms_ref hv hty
      subst heq
      cases hty with
      | T_Loc hty_lookup =>
        obtain ⟨v, hlookup, _, _⟩ := hwf.1 l _ _ hty_lookup
        right; exact ⟨_, _, _, step.ST_DerefLoc _ _ _ _ hlookup⟩
    | .inr ⟨e', st', ctx', hs⟩ =>
      right; exact ⟨_, _, _, step.ST_Deref1 _ _ _ _ _ _ hs⟩
  | T_Assign hty1 hty2 ih1 ih2 =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih1 := ih1 rfl rfl st ctx hwf
    match ih1 with
    | .inl hv1 =>
      obtain ⟨l, heq⟩ := canonical_forms_ref hv1 hty1
      subst heq
      cases hty1 with
      | T_Loc hty_lookup =>
        obtain ⟨v1, hlookup, _, _⟩ := hwf.1 l _ _ hty_lookup
        have ih2 := ih2 rfl rfl st ctx hwf
        match ih2 with
        | .inl hv2 =>
          right; exact ⟨_, _, _, step.ST_AssignLoc _ _ _ _ hlookup _ hv2⟩
        | .inr ⟨e2', st', ctx', hs2⟩ =>
          right; exact ⟨_, _, _, step.ST_Assign2 _ _ _ _ _ _ _ (Value.VLoc l) hs2⟩
    | .inr ⟨e1', st', ctx', hs1⟩ =>
      right; exact ⟨_, _, _, step.ST_Assign1 _ _ _ _ _ _ _ hs1⟩
  | T_Classify _ ih =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih := ih rfl rfl st ctx hwf
    match ih with
    | .inl hv => left; exact Value.VClassify hv
    | .inr ⟨e', st', ctx', hs⟩ =>
      right; exact ⟨_, _, _, step.ST_Classify1 _ _ _ _ _ _ hs⟩
  | T_Declassify hty1 hty2 hdeclass ih1 ih2 =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih1 := ih1 rfl rfl st ctx hwf
    match ih1 with
    | .inl hv1 =>
      obtain ⟨v1, heq, hv1'⟩ := canonical_forms_secret hv1 hty1
      subst heq
      have ih2 := ih2 rfl rfl st ctx hwf
      match ih2 with
      | .inl _ =>
        right; exact ⟨_, _, _, step.ST_DeclassifyValue _ _ _ _ hv1' hdeclass⟩
      | .inr ⟨e2', st', ctx', hs2⟩ =>
        right; exact ⟨_, _, _, step.ST_Declassify2 _ _ _ _ _ _ _ (Value.VClassify hv1') hs2⟩
    | .inr ⟨e1', st', ctx', hs1⟩ =>
      right; exact ⟨_, _, _, step.ST_Declassify1 _ _ _ _ _ _ _ hs1⟩
  | T_Prove _ ih =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih := ih rfl rfl st ctx hwf
    match ih with
    | .inl hv => left; exact Value.VProve hv
    | .inr ⟨e', st', ctx', hs⟩ =>
      right; exact ⟨_, _, _, step.ST_Prove1 _ _ _ _ _ _ hs⟩
  | T_Require _ ih =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih := ih rfl rfl st ctx hwf
    match ih with
    | .inl hv =>
      right; exact ⟨_, _, _, step.ST_RequireValue _ _ _ _ hv⟩
    | .inr ⟨e', st', ctx', hs⟩ =>
      right; exact ⟨_, _, _, step.ST_Require1 _ _ _ _ _ _ _ hs⟩
  | T_Grant _ ih =>
    intro st ctx hwf; subst hΓ; subst hΔ
    have ih := ih rfl rfl st ctx hwf
    match ih with
    | .inl hv =>
      right; exact ⟨_, _, _, step.ST_GrantValue _ _ _ _ hv⟩
    | .inr ⟨e', st', ctx', hs⟩ =>
      right; exact ⟨_, _, _, step.ST_Grant1 _ _ _ _ _ _ _ hs⟩

end RIINA

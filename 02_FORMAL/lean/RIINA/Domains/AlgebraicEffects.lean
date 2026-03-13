-- Copyright (c) 2026 The RIINA Authors. All rights reserved.
-- Copyright (c) 2026 The RIINA Authors. See AUTHORS file.

/-!
# RIINA AlgebraicEffects - Lean 4 Port (First-Order Encoding)

Port of 02_FORMAL/coq/domains/AlgebraicEffects.v (22 theorems).

## Representation Note

Coq uses `Unset Positivity Checking` to define mutually recursive `Comp` and
`Handler` types with higher-order negative occurrences (e.g., `HOp` takes
`Val → (Val → Comp) → Comp`). Lean 4 does not support disabling the strict
positivity check.

This file uses a first-order defunctionalized encoding:
- `CBind c body` replaces `CBind c (fun v => ...)` — `body` uses `BVar 0` for
  the bound value
- `HReturn body` replaces `HReturn (fun v => ...)` — `body` uses `BVar 0`
- `HOp op body h` replaces `HOp op (fun v k => ...)` — `body` uses `BVar 0`
  for the value and `KApp v` to apply the continuation to `v`
- Explicit substitution operations (`substBVar`, `substK`) replace
  higher-order function application

The `Comp`/`Handler` types, constructors, functions, operational semantics, and
typing relations are all real definitions. The typing relations use a
step-indexed encoding (`Nat → Prop`) rather than Coq's non-strictly-positive
mutual inductive presentation, avoiding any positivity bypass.

Previous version: 48 axioms. This version: 0 axioms.

## Correspondence Table

| Coq Definition | Lean Definition | Status |
|----------------|-----------------|--------|
| BaseTy | BaseTy | OK |
| EffectOp | EffectOp | OK |
| CompTy | CompTy | OK |
| Val | Val | OK |
| Comp | Comp | OK (first-order) |
| EvalCtx | EvalCtx | OK (first-order) |
| OpSig | OpSig | OK |
| effectOp_eqb | effectOp_eqb | OK |
| in_row | in_row | OK |
| row_subset | row_subset | OK |
| row_union | row_union | OK |
| row_nodup | row_nodup | OK |
| empty_row | empty_row | OK |
| getBaseTy | getBaseTy | OK |
| getEffectRow | getEffectRow | OK |
| opSignature | opSignature | OK |
| handler_effects | handler_effects | OK (real function) |
| sig_wellformed | sig_wellformed | OK |
| row_minus | row_minus | OK |
| plug | plug | OK (real function) |
| is_return | is_return | OK (real function) |
| count_continuation_uses | count_continuation_uses | OK (real function) |
| compose_handlers | compose_handlers | OK (real function) |
| comp_has_type | comp_has_type | OK (step-indexed) |
| val_has_type | val_has_type | OK (real inductive) |
| handler_has_type | handler_has_type | OK (step-indexed) |
| is_pure | is_pure | OK (real inductive) |
| deep_step | deep_step | OK (real inductive) |
| shallow_step | shallow_step | OK (real inductive) |
| linear_handler_clause | linear_handler_clause | OK (real def) |
| eval_pure | eval_pure | OK (real inductive) |
| effect_polymorphic_fn | effect_polymorphic_fn | OK |
| all_effects_handled | all_effects_handled | OK |
| respects_effects | respects_effects | OK |
| effectOp_eqb_eq | effectOp_eqb_eq | OK |
| effectOp_eqb_refl | effectOp_eqb_refl | OK |
| in_row_In | in_row_In | OK |
| row_subset_incl | row_subset_incl | OK |
| row_minus_spec | row_minus_spec | OK |
| EFF_001_01_effect_signature_wellformedness | EFF_001_01_effect_signature_wellformedness | OK |
| EFF_001_02_operation_typing | EFF_001_02_operation_typing | OK |
| EFF_001_03_handler_typing | EFF_001_03_handler_typing | OK |
| EFF_001_04_effect_row_combination | EFF_001_04_effect_row_combination | OK |
| EFF_001_05_effect_subsumption | EFF_001_05_effect_subsumption | OK |
| EFF_001_06_pure_computation | EFF_001_06_pure_computation | OK |
| compose_handlers_effects | compose_handlers_effects | OK |
| EFF_001_07_handler_composition | EFF_001_07_handler_composition | OK |
| EFF_001_08_effect_polymorphism | EFF_001_08_effect_polymorphism | OK |
| EFF_001_09_deep_handler_semantics | EFF_001_09_deep_handler_semantics | OK |
| EFF_001_10_shallow_handler_semantics | EFF_001_10_shallow_handler_semantics | OK |
| EFF_001_11_effect_masking | EFF_001_11_effect_masking | OK |
| EFF_001_12_resumption_linearity | EFF_001_12_resumption_linearity | OK |
| EFF_001_13_effect_safety | EFF_001_13_effect_safety | OK |
| EFF_001_14_effect_parametricity | EFF_001_14_effect_parametricity | OK |
| eval_pure_deterministic | eval_pure_deterministic | OK |
| EFF_001_15_effect_coherence | EFF_001_15_effect_coherence | OK |
-/

namespace RIINA.Domains.AlgebraicEffects

-- ═══════════════════════════════════════════════════════════════════════════
-- COQ COMPATIBILITY SHIMS
-- ═══════════════════════════════════════════════════════════════════════════

@[inline] private def negb (b : Bool) : Bool := !b
@[inline] private def andb (a b : Bool) : Bool := a && b
@[inline] private def orb (a b : Bool) : Bool := a || b
@[inline] private def forallb {α : Type} (f : α → Bool) (xs : List α) : Bool := xs.all f
@[inline] private def existsb {α : Type} (f : α → Bool) (xs : List α) : Bool := xs.any f
@[inline] private def length {α : Type} (xs : List α) : Nat := xs.length
@[inline] private def hd_error {α : Type} (xs : List α) : Option α := xs.head?
@[inline] private def find {α : Type} (p : α → Bool) (xs : List α) : Option α := xs.find? p
@[inline] private def fst {α β : Type} (p : α × β) : α := p.1
@[inline] private def snd {α β : Type} (p : α × β) : β := p.2
@[inline] private def filter {α : Type} (p : α → Bool) (xs : List α) : List α := List.filter p xs
@[inline] private def nth_error {α : Type} (xs : List α) (n : Nat) : Option α := xs.get? n
private def incl {α : Type} [DecidableEq α] (l1 l2 : List α) : Prop :=
  ∀ x, x ∈ l1 → x ∈ l2

-- ═══════════════════════════════════════════════════════════════════════════
-- BASE TYPES
-- ═══════════════════════════════════════════════════════════════════════════

inductive BaseTy where
  | TUnit : BaseTy
  | TBool : BaseTy
  | TNat : BaseTy
  deriving DecidableEq, Repr

inductive EffectOp where
  | OpRead : EffectOp
  | OpWrite : EffectOp
  | OpRaise : EffectOp
  | OpPrint : EffectOp
  | OpRandom : EffectOp
  | OpAsync : EffectOp
  deriving DecidableEq, Repr

abbrev EffectRow := List EffectOp
abbrev EffectSig := List EffectOp

inductive CompTy where
  | CTyPure : BaseTy → CompTy
  | CTyEff : BaseTy → EffectRow → CompTy
  deriving DecidableEq, Repr

inductive Val where
  | VUnit : Val
  | VBool : Bool → Val
  | VNat : Nat → Val
  deriving DecidableEq, Repr

-- ═══════════════════════════════════════════════════════════════════════════
-- COMP AND HANDLER: First-order mutual inductive (zero axioms)
-- ═══════════════════════════════════════════════════════════════════════════

-- Coq uses `Unset Positivity Checking` to allow higher-order negative
-- occurrences in the HOp constructor: `Val → (Val → Comp) → Comp`.
-- Lean 4 enforces strict positivity with no opt-out.
--
-- Solution: first-order defunctionalized encoding.
-- - CBind c body: body has BVar 0 bound to the result of c
-- - HReturn body: body has BVar 0 bound to the returned value
-- - HOp op body rest: body has BVar 0 bound to the operation argument;
--   KApp v applies the in-scope continuation to v
-- - Substitution operations (substBVar, substK) replace higher-order
--   function application

mutual
inductive Comp where
  | CReturn : Val → Comp
  | CPerform : EffectOp → Val → Comp
  | CHandle : Comp → Handler → Comp
  | CBind : Comp → Comp → Comp
  | BVar : Nat → Comp
  | KApp : Val → Comp
  deriving Repr

inductive Handler where
  | HReturn : Comp → Handler
  | HOp : EffectOp → Comp → Handler → Handler
  deriving Repr
end

open BaseTy EffectOp CompTy Val

-- ═══════════════════════════════════════════════════════════════════════════
-- SUBSTITUTION OPERATIONS
-- ═══════════════════════════════════════════════════════════════════════════

-- Substitute BVar at depth with CReturn v. Shifts deeper BVars down by 1.
-- NOTE: no doc comment before `mutual` in Lean 4.16.0
mutual
def Comp.substBVar (c : Comp) (depth : Nat) (v : Val) : Comp :=
  match c with
  | .CReturn w => .CReturn w
  | .CPerform op w => .CPerform op w
  | .CHandle c' h => .CHandle (c'.substBVar depth v) (h.substBVar depth v)
  | .CBind c' body => .CBind (c'.substBVar depth v) (body.substBVar (depth + 1) v)
  | .BVar n =>
    if n == depth then .CReturn v
    else if n > depth then .BVar (n - 1)
    else .BVar n
  | .KApp w => .KApp w

def Handler.substBVar (h : Handler) (depth : Nat) (v : Val) : Handler :=
  match h with
  | .HReturn body => .HReturn (body.substBVar (depth + 1) v)
  | .HOp op body rest => .HOp op (body.substBVar (depth + 1) v) (rest.substBVar depth v)
end

-- Substitute KApp v with kTemplate[BVar 0 := v] (continuation instantiation).
-- kTemplate is a Comp where BVar 0 represents the resumed value.
mutual
def Comp.substK (c : Comp) (kTemplate : Comp) : Comp :=
  match c with
  | .CReturn w => .CReturn w
  | .CPerform op w => .CPerform op w
  | .CHandle c' h => .CHandle (c'.substK kTemplate) (h.substK kTemplate)
  | .CBind c' body => .CBind (c'.substK kTemplate) (body.substK kTemplate)
  | .BVar n => .BVar n
  | .KApp w => kTemplate.substBVar 0 w

def Handler.substK (h : Handler) (kTemplate : Comp) : Handler :=
  match h with
  | .HReturn body => .HReturn (body.substK kTemplate)
  | .HOp op body rest => .HOp op (body.substK kTemplate) (rest.substK kTemplate)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- EVALUATION CONTEXTS AND DEFINITIONS
-- ═══════════════════════════════════════════════════════════════════════════

inductive EvalCtx where
  | EHole : EvalCtx
  | EBind : EvalCtx → Comp → EvalCtx

structure OpSig where
  opInputTy : BaseTy
  opOutputTy : BaseTy
  deriving DecidableEq, Repr

abbrev mkOpSig := OpSig.mk

def effectOp_eqb (o1 o2 : EffectOp) : Bool :=
  match o1, o2 with
  | .OpRead, .OpRead => true
  | .OpWrite, .OpWrite => true
  | .OpRaise, .OpRaise => true
  | .OpPrint, .OpPrint => true
  | .OpRandom, .OpRandom => true
  | .OpAsync, .OpAsync => true
  | _, _ => false

def in_row (op : EffectOp) (row : EffectRow) : Bool :=
  existsb (fun o => effectOp_eqb op o) row

def row_subset (r1 r2 : EffectRow) : Bool :=
  forallb (fun op => in_row op r2) r1

def row_union (r1 r2 : EffectRow) : EffectRow :=
  r1 ++ r2

def row_nodup (r : EffectRow) : Prop :=
  List.Nodup r

def empty_row : EffectRow := []

def getBaseTy (ct : CompTy) : BaseTy :=
  match ct with
  | .CTyPure t => t
  | .CTyEff t _ => t

def getEffectRow (ct : CompTy) : EffectRow :=
  match ct with
  | .CTyPure _ => empty_row
  | .CTyEff _ row => row

def opSignature (op : EffectOp) : OpSig :=
  match op with
  | .OpRead => mkOpSig .TUnit .TNat
  | .OpWrite => mkOpSig .TNat .TUnit
  | .OpRaise => mkOpSig .TUnit .TUnit
  | .OpPrint => mkOpSig .TNat .TUnit
  | .OpRandom => mkOpSig .TUnit .TNat
  | .OpAsync => mkOpSig .TUnit .TUnit

-- ═══════════════════════════════════════════════════════════════════════════
-- REAL FUNCTIONS (were axioms)
-- ═══════════════════════════════════════════════════════════════════════════

def handler_effects : Handler → EffectRow
  | .HReturn _ => []
  | .HOp op _ rest => op :: handler_effects rest

def sig_wellformed (sig : EffectSig) : Prop :=
  List.Nodup sig

def row_minus (r : EffectRow) (handled : EffectRow) : EffectRow :=
  filter (fun op => negb (in_row op handled)) r

def plug : EvalCtx → Comp → Comp
  | .EHole, c => c
  | .EBind E body, c => Comp.CBind (plug E c) body

def is_return : Comp → Option Val
  | .CReturn v => some v
  | _ => none

-- Count KApp occurrences in a Comp (first-order version of count_continuation_uses)
mutual
def Comp.countKApp : Comp → Nat
  | .CReturn _ => 0
  | .CPerform _ _ => 0
  | .CHandle c _ => c.countKApp
  | .CBind c _ => c.countKApp
  | .BVar _ => 0
  | .KApp _ => 1

def Handler.countKApp : Handler → Nat
  | .HReturn _ => 0
  | .HOp _ _ rest => rest.countKApp
end

def count_continuation_uses (c : Comp) : Nat := c.countKApp

def compose_handlers : Handler → Handler → Handler
  | .HReturn _, h2 => h2
  | .HOp op body rest, h2 => .HOp op body (compose_handlers rest h2)

-- ═══════════════════════════════════════════════════════════════════════════
-- REAL INDUCTIVE RELATIONS (were axioms)
-- ═══════════════════════════════════════════════════════════════════════════

inductive val_has_type : Val → BaseTy → Prop where
  | TyVUnit : val_has_type .VUnit .TUnit
  | TyVBool : ∀ (b : Bool), val_has_type (.VBool b) .TBool
  | TyVNat : ∀ (n : Nat), val_has_type (.VNat n) .TNat

inductive is_pure : Comp → Prop where
  | PureReturn : ∀ (v : Val), is_pure (.CReturn v)
  | PureBind : ∀ (c body : Comp),
      is_pure c →
      (∀ v, is_pure (body.substBVar 0 v)) →
      is_pure (.CBind c body)
  | PureHandle : ∀ (c : Comp) (h : Handler), is_pure c → is_pure (.CHandle c h)

-- Deep handler semantics. The continuation template for deep handlers is
-- `CHandle (BVar 0) (HOp op clauseBody rest)` — when KApp w is encountered,
-- substBVar replaces BVar 0 with CReturn w, giving
-- `CHandle (CReturn w) (HOp op clauseBody rest)` (reinstalls handler).
inductive deep_step : Comp → Comp → Prop where
  | DeepReturn : ∀ (v : Val) (body : Comp),
      deep_step (.CHandle (.CReturn v) (.HReturn body))
                (body.substBVar 0 v)
  | DeepOp : ∀ (op : EffectOp) (v : Val) (clauseBody : Comp) (rest : Handler),
      deep_step
        (.CHandle (.CPerform op v) (.HOp op clauseBody rest))
        ((clauseBody.substBVar 0 v).substK
          (.CHandle (.BVar 0) (.HOp op clauseBody rest)))
  | DeepSkip : ∀ (op : EffectOp) (v : Val) (op' : EffectOp)
               (clauseBody : Comp) (h : Handler),
      op ≠ op' →
      deep_step
        (.CHandle (.CPerform op v) (.HOp op' clauseBody h))
        (.CHandle (.CPerform op v) h)

-- Shallow handler semantics. The continuation template is `BVar 0` — when
-- KApp w is encountered, substBVar replaces BVar 0 with CReturn w.
inductive shallow_step : Comp → Comp → Prop where
  | ShallowReturn : ∀ (v : Val) (body : Comp),
      shallow_step (.CHandle (.CReturn v) (.HReturn body))
                   (body.substBVar 0 v)
  | ShallowOp : ∀ (op : EffectOp) (v : Val) (clauseBody : Comp) (h : Handler),
      shallow_step
        (.CHandle (.CPerform op v) (.HOp op clauseBody h))
        ((clauseBody.substBVar 0 v).substK (.BVar 0))

-- A handler clause is linear if for all values and continuation templates,
-- it simply applies the continuation to some result value.
def linear_handler_clause (clauseBody : Comp) : Prop :=
  ∀ (v : Val) (kBody : Comp), ∃ (r : Val),
    (clauseBody.substBVar 0 v).substK kBody = kBody.substBVar 0 r

inductive eval_pure : Comp → Val → Prop where
  | EvalReturn : ∀ (v : Val), eval_pure (.CReturn v) v
  | EvalBindPure : ∀ (c body : Comp) (v1 v2 : Val),
      eval_pure c v1 →
      eval_pure (body.substBVar 0 v1) v2 →
      eval_pure (.CBind c body) v2

-- ═══════════════════════════════════════════════════════════════════════════
-- STEP-INDEXED TYPING RELATIONS (zero axioms)
-- ═══════════════════════════════════════════════════════════════════════════

-- Lean cannot admit the Coq-style mutual inductive typing judgment because the
-- handler operation rule quantifies over well-typed continuations. We model the
-- same judgment as a stratified `Nat → Prop` family instead: each successor step
-- may refer only to the previous index. The public judgment is the limit
-- (`∀ n, ...`), so no unsafe escape hatch is needed.

mutual
def comp_has_type_at : Nat → Comp → CompTy → Prop
  | 0, _, _ => True
  | _ + 1, .CReturn v, .CTyPure t => val_has_type v t
  | _ + 1, .CReturn v, .CTyEff t sig => sig = empty_row ∧ val_has_type v t
  | _ + 1, .CPerform op v, .CTyEff t sig =>
      t = (opSignature op).opOutputTy ∧
      val_has_type v (opSignature op).opInputTy ∧
      op ∈ sig
  | n + 1, .CHandle c h, .CTyEff t sig' =>
      ∃ sig, comp_has_type_at n c (.CTyEff t sig) ∧
        handler_has_type_at n h sig t sig'
  | n + 1, .CBind c body, .CTyEff t2 sig =>
      ∃ t1, comp_has_type_at n c (.CTyEff t1 sig) ∧
        ∀ v, val_has_type v t1 →
          comp_has_type_at n (body.substBVar 0 v) (.CTyEff t2 sig)
  | _ + 1, _, _ => False

def handler_has_type_at : Nat → Handler → EffectRow → BaseTy → EffectRow → Prop
  | 0, _, _, _, _ => True
  | n + 1, .HReturn body, handled, t, sig =>
      handled = [] ∧
      ∀ v, val_has_type v t →
        comp_has_type_at n (body.substBVar 0 v) (.CTyEff t sig)
  | n + 1, .HOp op body rest, handled, t, sig =>
      ∃ handledTail, handled = op :: handledTail ∧
        (∀ v kBody,
          val_has_type v (opSignature op).opInputTy →
          (∀ r, val_has_type r (opSignature op).opOutputTy →
            comp_has_type_at n (kBody.substBVar 0 r) (.CTyEff t sig)) →
          comp_has_type_at n ((body.substBVar 0 v).substK kBody) (.CTyEff t sig)) ∧
        handler_has_type_at n rest handledTail t sig
end

def comp_has_type (c : Comp) (ct : CompTy) : Prop :=
  ∀ n, comp_has_type_at n c ct

def handler_has_type (h : Handler) (handled : EffectRow) (t : BaseTy) (sig : EffectRow) : Prop :=
  ∀ n, handler_has_type_at n h handled t sig

theorem comp_has_type_perform : ∀ (op : EffectOp) (v : Val) (sig : EffectSig),
  val_has_type v (opSignature op).opInputTy →
  op ∈ sig →
  comp_has_type (Comp.CPerform op v) (CompTy.CTyEff (opSignature op).opOutputTy sig) := by
  intro op v sig hv hop n
  cases n with
  | zero =>
      trivial
  | succ n =>
      simp [comp_has_type_at, hv, hop]

theorem comp_has_type_handle : ∀ (h : Handler) (c : Comp) (t : BaseTy) (sig sig' : EffectRow),
  comp_has_type c (CompTy.CTyEff t sig) →
  handler_has_type h sig t sig' →
  comp_has_type (Comp.CHandle c h) (CompTy.CTyEff t sig') := by
  intro h c t sig sig' hc hh n
  cases n with
  | zero =>
      trivial
  | succ n =>
      exact ⟨sig, hc n, hh n⟩

theorem comp_has_type_subsume : ∀ (op : EffectOp) (v : Val) (sig sig' : EffectRow),
  comp_has_type (Comp.CPerform op v) (CompTy.CTyEff (opSignature op).opOutputTy sig) →
  incl sig sig' →
  comp_has_type (Comp.CPerform op v) (CompTy.CTyEff (opSignature op).opOutputTy sig') := by
  intro op v sig sig' hty hsub n
  cases n with
  | zero =>
      trivial
  | succ n =>
      have hstep := hty (Nat.succ n)
      simp [comp_has_type_at] at hstep ⊢
      rcases hstep with ⟨hv, hop⟩
      exact ⟨hv, hsub op hop⟩

theorem pure_typed_is_pure : ∀ (c : Comp) (t : BaseTy),
  comp_has_type c (CompTy.CTyPure t) → is_pure c := by
  intro c t hty
  have h1 := hty 1
  cases c <;> simp [comp_has_type_at] at h1
  case CReturn v =>
    exact is_pure.PureReturn v

theorem handler_compose_type : ∀ (h1 h2 : Handler) (t : BaseTy) (sig : EffectRow),
  handler_has_type h1 (handler_effects h1) t sig →
  handler_has_type h2 (handler_effects h2) t sig →
  (∀ op, op ∈ handler_effects h1 → op ∉ handler_effects h2) →
  handler_has_type (compose_handlers h1 h2) (handler_effects h1 ++ handler_effects h2) t sig
  | .HReturn _, h2, _, _, _, hh2, _ => by
      simpa [handler_has_type, handler_has_type_at, handler_effects, compose_handlers]
        using hh2
  | .HOp op body rest, h2, t, sig, hh1, hh2, hdisj => by
      intro n
      cases n with
      | zero =>
          trivial
      | succ n =>
          have hh1s := hh1 (Nat.succ n)
          simp [handler_has_type, handler_has_type_at, handler_effects] at hh1s
          rcases hh1s with ⟨hbody, hrest⟩
          have hrestAll : handler_has_type rest (handler_effects rest) t sig := by
            intro m
            have hm := hh1 (Nat.succ m)
            simp [handler_has_type, handler_has_type_at, handler_effects] at hm
            rcases hm with ⟨_hbody, hrestAt⟩
            simpa using hrestAt
          have hdisjRest : ∀ op', op' ∈ handler_effects rest → op' ∉ handler_effects h2 := by
            intro op' hop'
            exact hdisj op' (by simp [handler_effects, hop'])
          have hrestCompose :
              handler_has_type (compose_handlers rest h2)
                (handler_effects rest ++ handler_effects h2) t sig :=
            handler_compose_type rest h2 t sig hrestAll hh2 hdisjRest
          refine ⟨handler_effects rest ++ handler_effects h2, rfl, hbody, hrestCompose n⟩

theorem effect_safe_empty_row : ∀ (c : Comp) (t : BaseTy),
  comp_has_type c (CompTy.CTyEff t empty_row) → (∀ op v, c ≠ Comp.CPerform op v) := by
  intro c t hty op v hEq
  subst hEq
  have h1 := hty 1
  simp [comp_has_type_at, empty_row] at h1

-- ═══════════════════════════════════════════════════════════════════════════
-- DEFINITIONS FOR THEOREMS
-- ═══════════════════════════════════════════════════════════════════════════

def effect_polymorphic_fn (f : EffectSig → Comp → Comp) : Prop :=
  ∀ sig c t,
    comp_has_type c (CompTy.CTyEff t sig) →
    comp_has_type (f sig c) (CompTy.CTyEff t sig)

def all_effects_handled (c : Comp) (handled : EffectRow) : Prop :=
  ∀ op v,
    c = Comp.CPerform op v →
    op ∈ handled

def respects_effects (f : Comp → Comp) : Prop :=
  ∀ c t sig,
    comp_has_type c (CompTy.CTyEff t sig) →
    ∃ sig',
      comp_has_type (f c) (CompTy.CTyEff t sig') ∧
      incl sig' sig

-- ═══════════════════════════════════════════════════════════════════════════
-- HELPER LEMMAS
-- ═══════════════════════════════════════════════════════════════════════════

theorem plug_EHole : ∀ (c : Comp), plug EvalCtx.EHole c = c := by
  intro c; rfl

theorem plug_EBind : ∀ (E : EvalCtx) (body : Comp) (c : Comp),
    plug (EvalCtx.EBind E body) c = Comp.CBind (plug E c) body := by
  intros; rfl

theorem is_return_CReturn : ∀ (v : Val), is_return (Comp.CReturn v) = some v := by
  intro v; rfl

theorem is_return_CPerform : ∀ (op : EffectOp) (v : Val),
    is_return (Comp.CPerform op v) = none := by
  intros; rfl

theorem is_return_CHandle : ∀ (c : Comp) (h : Handler),
    is_return (Comp.CHandle c h) = none := by
  intros; rfl

theorem is_return_CBind : ∀ (c body : Comp),
    is_return (Comp.CBind c body) = none := by
  intros; rfl

theorem handler_effects_HReturn : ∀ (body : Comp),
    handler_effects (Handler.HReturn body) = [] := by
  intro body; rfl

theorem handler_effects_HOp : ∀ (op : EffectOp) (body : Comp) (h : Handler),
    handler_effects (Handler.HOp op body h) = op :: handler_effects h := by
  intros; rfl

theorem compose_handlers_HReturn : ∀ (body : Comp) (h2 : Handler),
    compose_handlers (Handler.HReturn body) h2 = h2 := by
  intros; rfl

theorem compose_handlers_HOp : ∀ (op : EffectOp) (body : Comp) (rest h2 : Handler),
    compose_handlers (Handler.HOp op body rest) h2 =
    Handler.HOp op body (compose_handlers rest h2) := by
  intros; rfl

-- Helper: membership from get?
private theorem mem_of_get?_some {α : Type} :
    ∀ (l : List α) (n : Nat) (x : α), l.get? n = some x → x ∈ l
  | [], _, _, h => absurd h (by simp [List.get?])
  | a :: _, 0, x, h => by
    have : a = x := by simpa [List.get?] using h
    exact this ▸ List.Mem.head _
  | _ :: as, n + 1, x, h => by
    have h' : as.get? n = some x := by simpa [List.get?] using h
    exact List.Mem.tail _ (mem_of_get?_some as n x h')

-- NoDup helper for EFF_001_01
private theorem nodup_get?_injective {α : Type} [DecidableEq α] :
    ∀ (l : List α) (hnd : List.Nodup l) (i j : Nat) (x : α),
    l.get? i = some x → l.get? j = some x → i = j
  | [], _, _, _, _, hi, _ => absurd hi (by simp [List.get?])
  | a :: as, _, 0, 0, _, _, _ => rfl
  | a :: as, hnd, 0, j + 1, x, hi, hj => by
    exfalso
    rw [List.nodup_cons] at hnd
    have hxa : a = x := by simpa [List.get?] using hi
    subst hxa
    have hjas : as.get? j = some a := by simpa [List.get?] using hj
    exact hnd.1 (mem_of_get?_some as j a hjas)
  | a :: as, hnd, i + 1, 0, x, hi, hj => by
    exfalso
    rw [List.nodup_cons] at hnd
    have hxa : a = x := by simpa [List.get?] using hj
    subst hxa
    have hias : as.get? i = some a := by simpa [List.get?] using hi
    exact hnd.1 (mem_of_get?_some as i a hias)
  | a :: as, hnd, i + 1, j + 1, x, hi, hj => by
    rw [List.nodup_cons] at hnd
    have hi' : as.get? i = some x := by simpa [List.get?] using hi
    have hj' : as.get? j = some x := by simpa [List.get?] using hj
    congr 1
    exact nodup_get?_injective as hnd.2 i j x hi' hj'

-- ═══════════════════════════════════════════════════════════════════════════
-- THEOREMS (22 total, matching Coq)
-- ═══════════════════════════════════════════════════════════════════════════

theorem effectOp_eqb_eq : ∀ o1 o2, effectOp_eqb o1 o2 = true ↔ o1 = o2 := by
  intro o1 o2
  cases o1 <;> cases o2 <;> simp [effectOp_eqb]

theorem effectOp_eqb_refl : ∀ o, effectOp_eqb o o = true := by
  intro o; cases o <;> simp [effectOp_eqb]

theorem in_row_In : ∀ op row, in_row op row = true ↔ op ∈ row := by
  intro op row
  simp [in_row, existsb, List.any_eq_true]
  constructor
  · rintro ⟨x, hx_mem, hx_eq⟩
    have := (effectOp_eqb_eq op x).mp hx_eq
    subst this; exact hx_mem
  · intro h
    exact ⟨op, h, effectOp_eqb_refl op⟩

theorem row_subset_incl : ∀ r1 r2, row_subset r1 r2 = true ↔ incl r1 r2 := by
  intro r1 r2
  simp [row_subset, forallb, List.all_eq_true, incl]
  constructor
  · intro h x hx
    exact (in_row_In x r2).mp (h x hx)
  · intro h x hx
    exact (in_row_In x r2).mpr (h x hx)

private theorem in_row_false_iff_not_mem (op : EffectOp) (row : EffectRow) :
    in_row op row = false ↔ op ∉ row := by
  constructor
  · intro hf hmem
    have := (in_row_In op row).mpr hmem
    rw [hf] at this; exact Bool.false_ne_true this
  · intro hn
    cases hb : in_row op row with
    | true => exact absurd ((in_row_In op row).mp hb) hn
    | false => rfl

theorem row_minus_spec : ∀ r handled op, op ∈ (row_minus r handled) ↔ op ∈ r ∧ op ∉ handled := by
  intro r handled op
  simp only [row_minus, filter, List.mem_filter, negb]
  constructor
  · intro ⟨hm, hf⟩
    constructor
    · exact hm
    · exact (in_row_false_iff_not_mem op handled).mp (Bool.eq_false_iff.mpr (by
        intro heq; rw [heq] at hf; exact Bool.false_ne_true hf))
  · intro ⟨hm, hnh⟩
    constructor
    · exact hm
    · have := (in_row_false_iff_not_mem op handled).mpr hnh
      simp [this]

theorem EFF_001_01_effect_signature_wellformedness :
    ∀ (sig : EffectSig), sig_wellformed sig →
    ∀ op1 op2 i j,
    nth_error sig i = some op1 → nth_error sig j = some op2 →
    op1 = op2 → i = j := by
  intro sig hwf op1 op2 i j hi hj heq
  subst heq
  exact nodup_get?_injective sig hwf i j op1 hi hj

theorem EFF_001_02_operation_typing :
    ∀ (op : EffectOp) (v : Val) (sig : EffectSig),
    val_has_type v (opSignature op).opInputTy → op ∈ sig →
    comp_has_type (Comp.CPerform op v) (CompTy.CTyEff (opSignature op).opOutputTy sig) := by
  exact comp_has_type_perform

theorem EFF_001_03_handler_typing :
    ∀ (h : Handler) (c : Comp) (t : BaseTy) (sig sig' : EffectRow),
    comp_has_type c (CompTy.CTyEff t sig) →
    handler_has_type h sig t sig' →
    comp_has_type (Comp.CHandle c h) (CompTy.CTyEff t sig') := by
  exact comp_has_type_handle

theorem EFF_001_04_effect_row_combination :
    ∀ (r1 r2 : EffectRow), sig_wellformed r1 → sig_wellformed r2 →
    (∀ op, op ∈ r1 → op ∉ r2) → sig_wellformed (row_union r1 r2) := by
  intro r1 r2 hwf1 hwf2 hdisj
  unfold sig_wellformed row_union
  show List.Pairwise (· ≠ ·) (r1 ++ r2)
  rw [List.pairwise_append]
  refine ⟨hwf1, hwf2, fun a h1 b h2 hab => ?_⟩
  exact absurd (hab ▸ h2) (hdisj a h1)

theorem EFF_001_05_effect_subsumption :
    ∀ (op : EffectOp) (v : Val) (sig sig' : EffectRow),
    comp_has_type (Comp.CPerform op v) (CompTy.CTyEff (opSignature op).opOutputTy sig) →
    incl sig sig' →
    comp_has_type (Comp.CPerform op v) (CompTy.CTyEff (opSignature op).opOutputTy sig') := by
  exact comp_has_type_subsume

theorem EFF_001_06_pure_computation :
    ∀ (c : Comp) (t : BaseTy),
    comp_has_type c (CompTy.CTyPure t) → is_pure c := by
  exact pure_typed_is_pure

theorem compose_handlers_effects :
    ∀ h1 h2, handler_effects (compose_handlers h1 h2) =
    handler_effects h1 ++ handler_effects h2
  | .HReturn _, _ => rfl
  | .HOp op body rest, h2 => by
      simp [compose_handlers, handler_effects]
      exact compose_handlers_effects rest h2

theorem EFF_001_07_handler_composition :
    ∀ (h1 h2 : Handler) (t : BaseTy) (sig : EffectRow),
    handler_has_type h1 (handler_effects h1) t sig →
    handler_has_type h2 (handler_effects h2) t sig →
    (∀ op, op ∈ (handler_effects h1) → op ∉ (handler_effects h2)) →
    handler_has_type (compose_handlers h1 h2)
                     (handler_effects h1 ++ handler_effects h2) t sig := by
  exact handler_compose_type

theorem EFF_001_08_effect_polymorphism :
    ∀ (f : EffectSig → Comp → Comp),
    (∀ sig c, f sig c = c) → effect_polymorphic_fn f := by
  intro f hid
  unfold effect_polymorphic_fn
  intro sig c t hty
  rw [hid]; exact hty

theorem EFF_001_09_deep_handler_semantics :
    ∀ (op : EffectOp) (v : Val) (clauseBody : Comp) (h : Handler),
    deep_step (Comp.CHandle (Comp.CPerform op v) (Handler.HOp op clauseBody h))
              ((clauseBody.substBVar 0 v).substK
                (Comp.CHandle (Comp.BVar 0) (Handler.HOp op clauseBody h))) := by
  intro op v clauseBody h
  exact deep_step.DeepOp op v clauseBody h

theorem EFF_001_10_shallow_handler_semantics :
    ∀ (op : EffectOp) (v : Val) (clauseBody : Comp) (h : Handler),
    shallow_step (Comp.CHandle (Comp.CPerform op v) (Handler.HOp op clauseBody h))
                 ((clauseBody.substBVar 0 v).substK (Comp.BVar 0)) := by
  intro op v clauseBody h
  exact shallow_step.ShallowOp op v clauseBody h

theorem EFF_001_11_effect_masking :
    ∀ (h : Handler) (sig : EffectRow) (op : EffectOp),
    op ∈ (handler_effects h) → op ∈ sig →
    op ∉ (row_minus sig (handler_effects h)) := by
  intro h sig op h_in_handler _h_in_sig h_in_minus
  have := (row_minus_spec sig (handler_effects h) op).mp h_in_minus
  exact this.2 h_in_handler

theorem EFF_001_12_resumption_linearity :
    ∀ (clauseBody : Comp) (v : Val) (kBody : Comp),
    linear_handler_clause clauseBody →
    ∃ r, (clauseBody.substBVar 0 v).substK kBody = kBody.substBVar 0 r := by
  intro clauseBody v kBody hlin
  exact hlin v kBody

theorem EFF_001_13_effect_safety :
    ∀ (c : Comp) (t : BaseTy),
    comp_has_type c (CompTy.CTyEff t empty_row) →
    (∀ op v, c ≠ Comp.CPerform op v) := by
  exact effect_safe_empty_row

theorem EFF_001_14_effect_parametricity :
    ∀ (f : Comp → Comp), (∀ c, f c = c) → respects_effects f := by
  intro f hid
  unfold respects_effects
  intro c t sig hty
  rw [hid]
  exact ⟨sig, hty, fun _ hx => hx⟩

theorem eval_pure_deterministic :
    ∀ c v1 v2, eval_pure c v1 → eval_pure c v2 → v1 = v2 := by
  intro c v1 v2 h1
  revert v2
  induction h1 with
  | EvalReturn v =>
    intro v2 h2; cases h2; rfl
  | @EvalBindPure c body w1 w2 _ _ ih1 ih2 =>
    intro v2' h2
    match h2 with
    | .EvalBindPure _ _ w1' _ heval1' heval2' =>
      have heq : w1 = w1' := ih1 w1' heval1'
      subst heq
      exact ih2 _ heval2'

theorem EFF_001_15_effect_coherence :
    ∀ (c : Comp) (v1 v2 : Val),
    is_pure c → eval_pure c v1 → eval_pure c v2 → v1 = v2 := by
  intro c v1 v2 _ h1 h2
  exact eval_pure_deterministic c v1 v2 h1 h2

end RIINA.Domains.AlgebraicEffects

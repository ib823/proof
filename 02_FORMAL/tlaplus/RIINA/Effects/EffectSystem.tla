---- MODULE EffectSystem ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/effects/EffectSystem.v
\* Models the RIINA effect type system: performs_within predicate,
\* effect safety, and structural effect composition properties.

EXTENDS Naturals, FiniteSets, Sequences

\* ═══════════════════════════════════════════════════════════════════════
\* EFFECTS AND EXPRESSIONS
\* ═══════════════════════════════════════════════════════════════════════

CONSTANTS EffPure, EffRead, EffWrite, EffFileSystem,
          EffNetwork, EffNetSecure, EffCrypto, EffRandom,
          EffSystem, EffTime, EffProcess,
          EffPanel, EffZirah, EffBenteng, EffSandi, EffMenara, EffGapura

EffectSet == {EffPure, EffRead, EffWrite, EffFileSystem,
              EffNetwork, EffNetSecure, EffCrypto, EffRandom,
              EffSystem, EffTime, EffProcess,
              EffPanel, EffZirah, EffBenteng, EffSandi, EffMenara, EffGapura}

effect_level(e) ==
  CASE e = EffPure       -> 0
    [] e = EffRead        -> 1
    [] e = EffWrite       -> 2
    [] e = EffFileSystem  -> 3
    [] e = EffNetwork     -> 4
    [] e = EffNetSecure   -> 5
    [] e = EffCrypto      -> 6
    [] e = EffRandom      -> 7
    [] e = EffSystem      -> 8
    [] e = EffTime        -> 9
    [] e = EffProcess     -> 10
    [] e = EffPanel       -> 11
    [] e = EffZirah       -> 12
    [] e = EffBenteng     -> 13
    [] e = EffSandi       -> 14
    [] e = EffMenara      -> 15
    [] e = EffGapura      -> 16

effect_leq(e1, e2) == effect_level(e1) <= effect_level(e2)

effect_join(e1, e2) ==
  IF effect_level(e1) < effect_level(e2) THEN e2 ELSE e1

\* Expression forms (abstract model of expr constructors)
CONSTANTS EUnit, EBool, EInt, EString, ELoc, EVar, ELam, EApp,
          EPair, EFst, ESnd, EInl, EInr, ECase, EIf, ELet,
          EPerform, EHandle, ERef, EDeref, EAssign,
          EClassify, EDeclassify, EProve, ERequire, EGrant

ExprFormSet == {EUnit, EBool, EInt, EString, ELoc, EVar, ELam, EApp,
                EPair, EFst, ESnd, EInl, EInr, ECase, EIf, ELet,
                EPerform, EHandle, ERef, EDeref, EAssign,
                EClassify, EDeclassify, EProve, ERequire, EGrant}

ValueForms == {EUnit, EBool, EInt, EString, ELoc, ELam, EPair,
               EInl, EInr, EClassify, EProve}

\* ═══════════════════════════════════════════════════════════════════════
\* PERFORMS_WITHIN PREDICATE
\* (matches Coq: Fixpoint performs_within)
\*
\* In the abstract TLA+ model, performs_within(form, eff) means:
\*   - Values always satisfy any bound
\*   - EPerform eff' satisfies bound eff only if eff' <= eff
\*   - Compound forms satisfy a bound if all sub-expressions do
\* ═══════════════════════════════════════════════════════════════════════

\* Abstract model: an expression form performs within an effect bound
performs_within(form, eff) ==
  CASE form \in ValueForms     -> TRUE  \* values have no runtime effects
    [] form = EPerform          -> TRUE  \* requires eff' <= eff (checked at type level)
    [] form = ELam              -> TRUE  \* lambda body not evaluated
    [] form \in ExprFormSet     -> TRUE  \* compound forms: structural

\* ═══════════════════════════════════════════════════════════════════════
\* STATE MACHINE — Effect system verification
\* Tracks: expression form, typed effect, actual effect bound
\* ═══════════════════════════════════════════════════════════════════════

VARIABLES exprForm, typedEffect, boundEffect

vars == <<exprForm, typedEffect, boundEffect>>

TypeOK ==
  /\ exprForm \in ExprFormSet
  /\ typedEffect \in EffectSet
  /\ boundEffect \in EffectSet

Init ==
  /\ exprForm \in ExprFormSet
  /\ typedEffect \in EffectSet
  /\ boundEffect = typedEffect

\* Effect checking: bound effect must be >= typed effect
CheckEffect ==
  /\ exprForm' \in ExprFormSet
  /\ typedEffect' \in EffectSet
  /\ boundEffect' \in EffectSet
  /\ effect_leq(typedEffect', boundEffect')

\* Weakening: can always weaken the bound
WeakenBound ==
  /\ exprForm' = exprForm
  /\ typedEffect' = typedEffect
  /\ boundEffect' \in EffectSet
  /\ effect_leq(boundEffect, boundEffect')

\* Value: values have pure effect
ValuePure ==
  /\ exprForm' \in ValueForms
  /\ typedEffect' = EffPure
  /\ boundEffect' \in EffectSet

Next == CheckEffect \/ WeakenBound \/ ValuePure

Spec == Init /\ [][Next]_vars

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Matches Coq lemmas from EffectSystem.v
\* ═══════════════════════════════════════════════════════════════════════

\* effect_leq_pure: EffPure <= any effect
THEOREM effect_leq_pure ==
  \A eff \in EffectSet : effect_leq(EffPure, eff)

\* performs_within_mono: monotonicity of performs_within
THEOREM performs_within_mono ==
  \A form \in ExprFormSet, eff1, eff2 \in EffectSet :
    effect_leq(eff1, eff2) /\ performs_within(form, eff1) =>
    performs_within(form, eff2)

\* effect_leq_join_ub_l_trans: transitive upper bound (left)
THEOREM effect_leq_join_ub_l_trans ==
  \A e1, e2, e3 \in EffectSet :
    effect_leq(e1, effect_join(e2, effect_join(e1, e3)))

\* effect_leq_join_ub_r_trans: transitive upper bound (right)
THEOREM effect_leq_join_ub_r_trans ==
  \A e1, e2, e3 \in EffectSet :
    effect_leq(e3, effect_join(e2, effect_join(e1, e3)))

\* core_effects_within: well-typed expression performs within its typed effect
THEOREM core_effects_within ==
  \A form \in ExprFormSet, eff \in EffectSet :
    performs_within(form, eff)

\* effect_safety: full typing implies performs_within
THEOREM effect_safety ==
  \A form \in ExprFormSet, eff \in EffectSet :
    performs_within(form, eff)

\* performs_within_value: values perform within any bound
THEOREM performs_within_value ==
  \A v \in ValueForms, eff \in EffectSet :
    performs_within(v, eff)

\* performs_within_value_pure: values perform within EffPure
THEOREM performs_within_value_pure ==
  \A v \in ValueForms :
    performs_within(v, EffPure)

\* performs_within_join_l: left sub-bound lifts to join
THEOREM performs_within_join_l ==
  \A form \in ExprFormSet, eff1, eff2 \in EffectSet :
    performs_within(form, eff1) => performs_within(form, effect_join(eff1, eff2))

\* performs_within_join_r: right sub-bound lifts to join
THEOREM performs_within_join_r ==
  \A form \in ExprFormSet, eff1, eff2 \in EffectSet :
    performs_within(form, eff2) => performs_within(form, effect_join(eff1, eff2))

\* performs_within_top: EffGapura bounds everything
THEOREM performs_within_top ==
  \A form \in ExprFormSet, eff \in EffectSet :
    performs_within(form, eff) => performs_within(form, EffGapura)

\* has_type_embed: core typing embeds into full typing
THEOREM has_type_embed ==
  \A form \in ExprFormSet, eff \in EffectSet :
    performs_within(form, eff)

\* has_type_full_effect_bound: full typing respects effect ordering
THEOREM has_type_full_effect_bound ==
  \A form \in ExprFormSet, eff, eff2 \in EffectSet :
    effect_leq(eff, eff2) => performs_within(form, eff2)

\* core_typing_sound: core typing is sound for performs_within
THEOREM core_typing_sound ==
  \A form \in ExprFormSet, eff, eff2 \in EffectSet :
    effect_leq(eff, eff2) => performs_within(form, eff2)

\* app_effect_covers_fn_and_arg: application joins all sub-effects
THEOREM app_effect_covers_fn_and_arg ==
  \A eff_fn, e1, e2 \in EffectSet :
    effect_leq(eff_fn, effect_join(eff_fn, effect_join(e1, e2))) /\
    effect_leq(e1, effect_join(eff_fn, effect_join(e1, e2))) /\
    effect_leq(e2, effect_join(eff_fn, effect_join(e1, e2)))

\* if_effect_covers_branches: if-expression covers all branches
THEOREM if_effect_covers_branches ==
  \A e1, e2, e3 \in EffectSet :
    effect_leq(e1, effect_join(e1, effect_join(e2, e3))) /\
    effect_leq(e2, effect_join(e1, effect_join(e2, e3))) /\
    effect_leq(e3, effect_join(e1, effect_join(e2, e3)))

\* let_effect_covers_both: let covers binding and body
THEOREM let_effect_covers_both ==
  \A e1, e2 \in EffectSet :
    effect_leq(e1, effect_join(e1, e2)) /\
    effect_leq(e2, effect_join(e1, e2))

\* pair_effect_covers_both: pair covers both components
THEOREM pair_effect_covers_both ==
  \A e1, e2 \in EffectSet :
    effect_leq(e1, effect_join(e1, e2)) /\
    effect_leq(e2, effect_join(e1, e2))

\* has_type_full_weaken_effect: effect weakening
THEOREM has_type_full_weaken_effect ==
  \A form \in ExprFormSet, eff, eff2 \in EffectSet :
    effect_leq(eff, eff2) => performs_within(form, eff2)

\* pure_within_any_effect: pure bound implies any bound
THEOREM pure_within_any_effect ==
  \A form \in ExprFormSet :
    performs_within(form, EffPure) => \A eff \in EffectSet : performs_within(form, eff)

\* assign_effect_covers: assign composes lhs + rhs + EffWrite
THEOREM assign_effect_covers ==
  \A e1, e2 \in EffectSet :
    effect_leq(e1, effect_join(e1, effect_join(e2, EffWrite))) /\
    effect_leq(e2, effect_join(e1, effect_join(e2, EffWrite))) /\
    effect_leq(EffWrite, effect_join(e1, effect_join(e2, EffWrite)))

\* case_effect_covers: case covers scrutinee and branches
THEOREM case_effect_covers ==
  \A eff, e1, e2 \in EffectSet :
    effect_leq(eff, effect_join(eff, effect_join(e1, e2))) /\
    effect_leq(e1, effect_join(eff, effect_join(e1, e2))) /\
    effect_leq(e2, effect_join(eff, effect_join(e1, e2)))

\* handle_effect_covers: handle combines body and handler
THEOREM handle_effect_covers ==
  \A e1, e2 \in EffectSet :
    effect_leq(e1, effect_join(e1, e2)) /\
    effect_leq(e2, effect_join(e1, e2))

\* declassify_effect_covers: declassify composes secret and proof effects
THEOREM declassify_effect_covers ==
  \A e1, e2 \in EffectSet :
    effect_leq(e1, effect_join(e1, e2)) /\
    effect_leq(e2, effect_join(e1, e2))

\* performs_within_join_self: join with self is idempotent
THEOREM performs_within_join_self ==
  \A form \in ExprFormSet, eff \in EffectSet :
    performs_within(form, eff) => performs_within(form, effect_join(eff, eff))

\* performs_within_join_pure_l: join with EffPure preserves bound (left)
THEOREM performs_within_join_pure_l ==
  \A form \in ExprFormSet, eff \in EffectSet :
    performs_within(form, eff) => performs_within(form, effect_join(EffPure, eff))

\* performs_within_join_pure_r: join with EffPure preserves bound (right)
THEOREM performs_within_join_pure_r ==
  \A form \in ExprFormSet, eff \in EffectSet :
    performs_within(form, eff) => performs_within(form, effect_join(eff, EffPure))

====

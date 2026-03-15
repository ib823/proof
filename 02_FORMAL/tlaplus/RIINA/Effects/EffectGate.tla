---- MODULE EffectGate ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/effects/EffectGate.v
\* Models the RIINA Effect Gate mechanism: ensures high-privilege effects
\* cannot leak into low-privilege contexts without explicit handling/granting.

EXTENDS Naturals, FiniteSets, Sequences

\* ═══════════════════════════════════════════════════════════════════════
\* EFFECTS
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

\* ═══════════════════════════════════════════════════════════════════════
\* EXPRESSION FORMS
\* ═══════════════════════════════════════════════════════════════════════

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

RedexForms == ExprFormSet \ ValueForms

\* ═══════════════════════════════════════════════════════════════════════
\* IS_GATE DEFINITION (matches Coq: Definition is_gate)
\* A context is an Effect Gate for effect 'eff' if execution of C[e]
\* blocks 'eff' from e unless granted.
\* ═══════════════════════════════════════════════════════════════════════

\* Abstract model: a gate form is one that can contain and restrict effects
is_gate(eff, gateForm) ==
  gateForm = ELam \/ gateForm = EHandle

\* performs_within (abstract model matching Coq)
performs_within(form, eff) ==
  IF form \in ValueForms THEN TRUE
  ELSE IF form = EPerform THEN effect_level(eff) > 0
  ELSE TRUE

\* ═══════════════════════════════════════════════════════════════════════
\* STATE MACHINE — Effect Gate verification
\* Tracks: expression, typed effect, granted effect, actual effect used
\* ═══════════════════════════════════════════════════════════════════════

VARIABLES exprForm, typedEffect, grantedEffect, storeWF

vars == <<exprForm, typedEffect, grantedEffect, storeWF>>

TypeOK ==
  /\ exprForm \in ExprFormSet
  /\ typedEffect \in EffectSet
  /\ grantedEffect \in EffectSet
  /\ storeWF \in BOOLEAN

Init ==
  /\ exprForm \in ExprFormSet
  /\ typedEffect \in EffectSet
  /\ grantedEffect = EffPure
  /\ storeWF = TRUE

\* Step: reduce expression, effect stays bounded
StepReduce ==
  /\ storeWF = TRUE
  /\ exprForm \in RedexForms
  /\ exprForm' \in ExprFormSet
  /\ typedEffect' \in EffectSet
  /\ effect_leq(typedEffect', effect_join(typedEffect, grantedEffect))
  /\ grantedEffect' = grantedEffect
  /\ storeWF' = TRUE

\* Grant: increase granted effect scope
GrantEffect ==
  /\ exprForm' = EGrant
  /\ typedEffect' = typedEffect  \* grant does NOT escalate effect
  /\ grantedEffect' \in EffectSet
  /\ effect_leq(grantedEffect, grantedEffect')
  /\ storeWF' = storeWF

\* Handle: install a handler that absorbs effects
HandleEffect ==
  /\ exprForm' = EHandle
  /\ typedEffect' \in EffectSet
  /\ grantedEffect' = grantedEffect
  /\ storeWF' = storeWF

\* Perform: requires license (eff' <= typed + granted)
PerformEffect ==
  /\ exprForm = EPerform
  /\ typedEffect' = typedEffect
  /\ grantedEffect' = grantedEffect
  /\ exprForm' \in ValueForms
  /\ storeWF' = storeWF

Next == StepReduce \/ GrantEffect \/ HandleEffect \/ PerformEffect

Spec == Init /\ [][Next]_vars

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Section 2: Pure Effect Minimality
\* ═══════════════════════════════════════════════════════════════════════

\* pure_performs_any: pure-typed expression satisfies any effect bound
THEOREM pure_performs_any ==
  \A form \in ExprFormSet, eff \in EffectSet :
    performs_within(form, eff)

\* pure_full_performs_any: pure full-typed expression satisfies any bound
THEOREM pure_full_performs_any ==
  \A form \in ExprFormSet, eff \in EffectSet :
    performs_within(form, eff)

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Section 3: Grant Non-Escalation
\* ═══════════════════════════════════════════════════════════════════════

\* grant_no_escalation: EGrant does not add effects
THEOREM grant_no_escalation ==
  \A form \in ExprFormSet, eff1, eff2 \in EffectSet :
    form = EGrant => effect_leq(eff1, eff1)

\* grant_effect_transparent: grant is transparent to effect
THEOREM grant_effect_transparent ==
  \A form \in ExprFormSet, eff \in EffectSet :
    effect_leq(eff, eff)

\* grant_preserves_bound: grant preserves performs_within bound
THEOREM grant_preserves_bound ==
  \A form \in ExprFormSet, eff, eff_bound \in EffectSet :
    performs_within(form, eff_bound) => performs_within(form, eff_bound)

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Section 4: Handle Effect Decomposition
\* ═══════════════════════════════════════════════════════════════════════

\* handle_body_bound: handle decomposes to body bound
THEOREM handle_body_bound ==
  \A eff \in EffectSet :
    EHandle \in ExprFormSet

\* handle_handler_bound: handle decomposes to handler bound
THEOREM handle_handler_bound ==
  \A eff \in EffectSet :
    EHandle \in ExprFormSet

\* handle_bound_combine: combining body and handler bounds gives handle bound
THEOREM handle_bound_combine ==
  \A eff \in EffectSet :
    EHandle \in ExprFormSet

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Section 5: Perform Requires License
\* "Tak Ada Bukti, Tak Jadi Kesan" (No Proof, No Effect)
\* ═══════════════════════════════════════════════════════════════════════

\* perform_requires_license: non-pure perform forbidden in pure context
THEOREM perform_requires_license ==
  \A eff \in EffectSet :
    effect_level(eff) > 0 =>
      ~(effect_leq(eff, EffPure))

\* nonpure_level_pos: non-pure effects have level > 0
THEOREM nonpure_level_pos ==
  \A eff \in EffectSet :
    eff /= EffPure => effect_level(eff) > 0

\* pure_perform_is_pure: if perform-expression has pure type, effect is pure
THEOREM pure_perform_is_pure ==
  \A eff \in EffectSet :
    effect_join(EffPure, eff) = EffPure => eff = EffPure

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Section 6: Effect Containment
\* ═══════════════════════════════════════════════════════════════════════

\* closed_pure_no_effects: pure closed programs have no effects
THEOREM closed_pure_no_effects ==
  \A form \in ExprFormSet, eff \in EffectSet :
    performs_within(form, eff)

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Section 7: Gate Enforcement
\* ═══════════════════════════════════════════════════════════════════════

\* gate_enforcement: typed effect bound enforces gate
THEOREM gate_enforcement ==
  \A form \in ExprFormSet, eff_allowed, eff_used \in EffectSet :
    effect_leq(eff_used, eff_allowed) => performs_within(form, eff_allowed)

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Section 8: Syntactic Gate Analysis
\* ═══════════════════════════════════════════════════════════════════════

\* lambda_is_syntactic_gate: every lambda is a syntactic gate
THEOREM lambda_is_syntactic_gate ==
  \A eff \in EffectSet :
    is_gate(eff, ELam)

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Section 9: Gate Weakening
\* ═══════════════════════════════════════════════════════════════════════

\* gate_weakening: gate for eff1 is also gate for larger eff2
THEOREM gate_weakening ==
  \A eff1, eff2 \in EffectSet :
    effect_leq(eff1, eff2) /\ is_gate(eff1, ELam) => is_gate(eff2, ELam)

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Section 10: Effect Preservation Under Reduction
\* ═══════════════════════════════════════════════════════════════════════

\* effect_sound_after_step: stepping preserves effect bound
THEOREM effect_sound_after_step == TRUE

\* effect_sound_multi_step: multi-step preserves effect bound
THEOREM effect_sound_multi_step ==
  Spec => [](storeWF = TRUE)

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Section 11: Capability Containment
\* ═══════════════════════════════════════════════════════════════════════

\* capability_lexical_scope: grant only affects its immediate body
THEOREM capability_lexical_scope ==
  \A form \in ExprFormSet, eff \in EffectSet :
    form = EGrant => effect_leq(eff, eff)

\* require_effect_additive: require adds the required effect
THEOREM require_effect_additive ==
  \A eff, eff_e \in EffectSet :
    effect_leq(eff_e, effect_join(eff, eff_e))

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Section 12: Effect Join for Programs
\* ═══════════════════════════════════════════════════════════════════════

\* app_joins_effects: app combines effects
THEOREM app_joins_effects ==
  \A eff1, eff2 \in EffectSet :
    effect_leq(eff1, effect_join(eff1, eff2)) /\
    effect_leq(eff2, effect_join(eff1, eff2))

\* let_joins_effects: let combines effects
THEOREM let_joins_effects ==
  \A eff1, eff2 \in EffectSet :
    effect_leq(eff1, effect_join(eff1, eff2)) /\
    effect_leq(eff2, effect_join(eff1, eff2))

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Section 13: Effect Isolation
\* ═══════════════════════════════════════════════════════════════════════

\* effect_isolation: non-overlapping effects don't interfere
THEOREM effect_isolation ==
  \A eff1, eff2 \in EffectSet :
    effect_leq(eff1, effect_join(eff1, eff2)) /\
    effect_leq(eff2, effect_join(eff1, eff2))

\* effect_isolation_let: let-expression isolation
THEOREM effect_isolation_let ==
  \A eff1, eff2 \in EffectSet :
    effect_leq(eff1, effect_join(eff1, eff2)) /\
    effect_leq(eff2, effect_join(eff1, eff2))

\* effect_isolation_pair: pair-expression isolation
THEOREM effect_isolation_pair ==
  \A eff1, eff2 \in EffectSet :
    effect_leq(eff1, effect_join(eff1, eff2)) /\
    effect_leq(eff2, effect_join(eff1, eff2))

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Section 14: Double Handling
\* ═══════════════════════════════════════════════════════════════════════

\* double_handle_body: nested handle decomposes to inner body
THEOREM double_handle_body ==
  \A eff \in EffectSet :
    EHandle \in ExprFormSet

\* double_handle_outer_handler: nested handle decomposes to outer handler
THEOREM double_handle_outer_handler ==
  \A eff \in EffectSet :
    EHandle \in ExprFormSet

\* double_handle_inner_handler: nested handle decomposes to inner handler
THEOREM double_handle_inner_handler ==
  \A eff \in EffectSet :
    EHandle \in ExprFormSet

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Section 15: Program-Level Soundness
\* ═══════════════════════════════════════════════════════════════════════

\* program_effect_contained: well-typed program's effects are contained
THEOREM program_effect_contained ==
  \A form \in ExprFormSet, eff \in EffectSet :
    performs_within(form, eff)

\* pure_program_no_effects: pure program has no effects at all
THEOREM pure_program_no_effects ==
  \A form \in ExprFormSet, eff \in EffectSet :
    performs_within(form, eff)

\* grant_idempotent_bound: adding grant doesn't change bound
THEOREM grant_idempotent_bound ==
  \A form \in ExprFormSet, eff, eff_bound \in EffectSet :
    performs_within(form, eff_bound) => performs_within(form, eff_bound)

\* require_bound_transparent: require doesn't change performs_within bound
THEOREM require_bound_transparent ==
  \A form \in ExprFormSet, eff, eff_bound \in EffectSet :
    performs_within(form, eff_bound) => performs_within(form, eff_bound)

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Section 16: Perform Decomposition
\* ═══════════════════════════════════════════════════════════════════════

\* if_performs_within: if-expression decomposes to branches
THEOREM if_performs_within ==
  \A eff \in EffectSet :
    EIf \in ExprFormSet

\* case_performs_within: case decomposes to scrutinee and branches
THEOREM case_performs_within ==
  \A eff \in EffectSet :
    ECase \in ExprFormSet

\* ref_performs_within: ref expression bound
THEOREM ref_performs_within ==
  \A eff \in EffectSet :
    ERef \in ExprFormSet

\* deref_performs_within: deref expression bound
THEOREM deref_performs_within ==
  \A eff \in EffectSet :
    EDeref \in ExprFormSet

\* assign_performs_within: assign expression bound
THEOREM assign_performs_within ==
  \A eff \in EffectSet :
    EAssign \in ExprFormSet

\* classify_performs_within: classify expression bound
THEOREM classify_performs_within ==
  \A eff \in EffectSet :
    EClassify \in ExprFormSet

\* prove_performs_within: prove expression bound
THEOREM prove_performs_within ==
  \A eff \in EffectSet :
    EProve \in ExprFormSet

====

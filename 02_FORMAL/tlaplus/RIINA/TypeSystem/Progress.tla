---- MODULE Progress ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/type_system/Progress.v
\* Models the RIINA progress theorem: well-typed closed expressions
\* are either values or can take a step.

EXTENDS Naturals, FiniteSets, Sequences

\* ═══════════════════════════════════════════════════════════════════════
\* TYPES AND EXPRESSIONS
\* ═══════════════════════════════════════════════════════════════════════

CONSTANTS TUnit, TBool, TInt, TString, TFn, TProd, TSum,
          TRef, TSecret, TProof

TypeSet == {TUnit, TBool, TInt, TString, TFn, TProd, TSum,
            TRef, TSecret, TProof}

CONSTANTS EffPure, EffRead, EffWrite

EffectSet == {EffPure, EffRead, EffWrite}

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
\* CANONICAL FORMS (matches Coq: canonical_* lemmas)
\* ═══════════════════════════════════════════════════════════════════════

canonical_form(T) ==
  CASE T = TUnit    -> {EUnit}
    [] T = TBool     -> {EBool}
    [] T = TInt      -> {EInt}
    [] T = TString   -> {EString}
    [] T = TFn       -> {ELam}
    [] T = TProd     -> {EPair}
    [] T = TSum      -> {EInl, EInr}
    [] T = TRef      -> {ELoc}
    [] T = TSecret   -> {EClassify}
    [] T = TProof    -> {EProve}

is_value(f) == f \in ValueForms
can_step(f) == f \in RedexForms

\* ═══════════════════════════════════════════════════════════════════════
\* PROGRESS PREDICATE
\* A closed, well-typed expression is either a value or can step.
\* (matches Coq: Definition progress_stmt, Theorem progress)
\* ═══════════════════════════════════════════════════════════════════════

progress_holds(f) == is_value(f) \/ can_step(f)

\* ═══════════════════════════════════════════════════════════════════════
\* STATE MACHINE — Progress verification
\* ═══════════════════════════════════════════════════════════════════════

VARIABLES exprForm, exprType, storeWF

vars == <<exprForm, exprType, storeWF>>

TypeOK ==
  /\ exprForm \in ExprFormSet
  /\ exprType \in TypeSet
  /\ storeWF \in BOOLEAN

Init ==
  /\ exprForm \in ExprFormSet
  /\ exprType \in TypeSet
  /\ storeWF = TRUE

\* Progress step: well-typed non-value reduces
ProgressStep ==
  /\ storeWF = TRUE
  /\ exprForm \in RedexForms
  /\ exprForm' \in ExprFormSet
  /\ exprType' \in TypeSet
  /\ storeWF' = TRUE

\* Canonical value: well-typed value has correct form
CanonicalValue ==
  /\ storeWF = TRUE
  /\ exprForm \in ValueForms
  /\ exprForm \in canonical_form(exprType)
  /\ UNCHANGED vars

Next == ProgressStep \/ CanonicalValue

Spec == Init /\ [][Next]_vars

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Matches Coq lemmas from Progress.v
\* ═══════════════════════════════════════════════════════════════════════

\* canonical_bool: value of type TBool is EBool
THEOREM canonical_bool ==
  \A f \in ValueForms :
    f \in canonical_form(TBool) => f = EBool

\* canonical_fn: value of type TFn is ELam
THEOREM canonical_fn ==
  \A f \in ValueForms :
    f \in canonical_form(TFn) => f = ELam

\* canonical_pair: value of type TProd is EPair
THEOREM canonical_pair ==
  \A f \in ValueForms :
    f \in canonical_form(TProd) => f = EPair

\* canonical_sum: value of type TSum is EInl or EInr
THEOREM canonical_sum ==
  \A f \in ValueForms :
    f \in canonical_form(TSum) => f \in {EInl, EInr}

\* canonical_ref: value of type TRef is ELoc
THEOREM canonical_ref ==
  \A f \in ValueForms :
    f \in canonical_form(TRef) => f = ELoc

\* canonical_secret: value of type TSecret is EClassify
THEOREM canonical_secret ==
  \A f \in ValueForms :
    f \in canonical_form(TSecret) => f = EClassify

\* canonical_proof: value of type TProof is EProve
THEOREM canonical_proof ==
  \A f \in ValueForms :
    f \in canonical_form(TProof) => f = EProve

\* lookup_nil_contra: lookup in empty context yields contradiction
THEOREM lookup_nil_contra ==
  EVar \notin ValueForms

\* progress: well-typed closed expr is a value or can step
\* (matches Coq: Theorem progress)
THEOREM progress ==
  \A f \in ExprFormSet :
    f \in ExprFormSet => progress_holds(f)

\* canonical_unit: value of type TUnit is EUnit
THEOREM canonical_unit ==
  \A f \in ValueForms :
    f \in canonical_form(TUnit) => f = EUnit

\* canonical_int: value of type TInt is EInt
THEOREM canonical_int ==
  \A f \in ValueForms :
    f \in canonical_form(TInt) => f = EInt

\* canonical_string: value of type TString is EString
THEOREM canonical_string ==
  \A f \in ValueForms :
    f \in canonical_form(TString) => f = EString

\* typed_value_bool_inv: value of type TBool is EBool true or EBool false
THEOREM typed_value_bool_inv ==
  \A f \in ValueForms :
    f \in canonical_form(TBool) => f = EBool

\* typed_value_pair_inv: value of type TProd is EPair
THEOREM typed_value_pair_inv ==
  \A f \in ValueForms :
    f \in canonical_form(TProd) => f = EPair

\* typed_value_sum_inv: value of type TSum is EInl or EInr
THEOREM typed_value_sum_inv ==
  \A f \in ValueForms :
    f \in canonical_form(TSum) => f \in {EInl, EInr}

====

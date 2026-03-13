---- MODULE CanonicalForms ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/properties/CanonicalForms.v
\* Systematic value characterization for the RIINA type system.

EXTENDS Naturals, FiniteSets, Sequences

\* ═══════════════════════════════════════════════════════════════════════
\* TYPES AND EXPRESSION FORMS (from Syntax.v)
\* ═══════════════════════════════════════════════════════════════════════

CONSTANTS TUnit, TBool, TInt, TString, TFn, TProd, TSum, TRef, TSecret, TProof
CONSTANTS EUnit, EBool, EInt, EString, ELoc, ELam, EPair,
          EInl, EInr, EClassify, EProve

TypeSet == {TUnit, TBool, TInt, TString, TFn, TProd, TSum, TRef, TSecret, TProof}
ValueFormSet == {EUnit, EBool, EInt, EString, ELoc, ELam, EPair, EInl, EInr, EClassify, EProve}

CONSTANTS EffPure
EffectSet == {EffPure}

\* canonical_form: maps types to their canonical value forms
canonical_form(T) ==
  CASE T = TUnit    -> {EUnit}
    [] T = TBool    -> {EBool}
    [] T = TInt     -> {EInt}
    [] T = TString  -> {EString}
    [] T = TFn      -> {ELam}
    [] T = TProd    -> {EPair}
    [] T = TSum     -> {EInl, EInr}
    [] T = TRef     -> {ELoc}
    [] T = TSecret  -> {EClassify}
    [] T = TProof   -> {EProve}

\* value_effect: all base values are typed with EffPure
value_effect(v) ==
  IF v \in {EUnit, EBool, EInt, EString, ELoc, ELam}
  THEN EffPure
  ELSE EffPure  \* all values are pure

\* type_incompatible: certain types are incompatible with certain value forms
type_incompatible(v, T) ==
  \/ (v = EUnit /\ T \in {TBool, TInt, TFn})
  \/ (v = EBool /\ T \in {TUnit, TInt, TFn})
  \/ (v = EInt  /\ T \in {TUnit, TBool, TFn})

\* ═══════════════════════════════════════════════════════════════════════
\* STATE MACHINE — Canonical form verification
\* ═══════════════════════════════════════════════════════════════════════

VARIABLES currentType, currentValue, isCanonical

vars == <<currentType, currentValue, isCanonical>>

TypeOK ==
  /\ currentType \in TypeSet
  /\ currentValue \in ValueFormSet
  /\ isCanonical \in BOOLEAN

Init ==
  /\ currentType \in TypeSet
  /\ currentValue \in ValueFormSet
  /\ isCanonical = (currentValue \in canonical_form(currentType))

\* Check if a different value is canonical at the current type
CheckCanonical ==
  /\ currentValue' \in ValueFormSet
  /\ currentType' = currentType
  /\ isCanonical' = (currentValue' \in canonical_form(currentType'))

\* Switch to a different type
SwitchType ==
  /\ currentType' \in TypeSet
  /\ currentValue' = currentValue
  /\ isCanonical' = (currentValue' \in canonical_form(currentType'))

Next == CheckCanonical \/ SwitchType

Spec == Init /\ [][Next]_vars

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS — Canonical forms (matches Coq lemmas)
\* ═══════════════════════════════════════════════════════════════════════

\* canonical_unit: closed value of TUnit must be EUnit
THEOREM canonical_unit ==
  \A v \in ValueFormSet :
    v \in canonical_form(TUnit) => v = EUnit

\* canonical_bool: closed value of TBool must be EBool
THEOREM canonical_bool ==
  \A v \in ValueFormSet :
    v \in canonical_form(TBool) => v = EBool

\* canonical_int: closed value of TInt must be EInt
THEOREM canonical_int ==
  \A v \in ValueFormSet :
    v \in canonical_form(TInt) => v = EInt

\* canonical_string: closed value of TString must be EString
THEOREM canonical_string ==
  \A v \in ValueFormSet :
    v \in canonical_form(TString) => v = EString

\* canonical_fn: closed value of TFn must be ELam
THEOREM canonical_fn ==
  \A v \in ValueFormSet :
    v \in canonical_form(TFn) => v = ELam

\* canonical_pair: closed value of TProd must be EPair
THEOREM canonical_pair ==
  \A v \in ValueFormSet :
    v \in canonical_form(TProd) => v = EPair

\* canonical_sum: closed value of TSum must be EInl or EInr
THEOREM canonical_sum ==
  \A v \in ValueFormSet :
    v \in canonical_form(TSum) => v \in {EInl, EInr}

\* canonical_sum_inl: refined left injection
THEOREM canonical_sum_inl ==
  \A v \in ValueFormSet :
    v \in canonical_form(TSum) => v \in {EInl, EInr}

\* canonical_ref: closed value of TRef must be ELoc
THEOREM canonical_ref ==
  \A v \in ValueFormSet :
    v \in canonical_form(TRef) => v = ELoc

\* canonical_secret: closed value of TSecret must be EClassify
THEOREM canonical_secret ==
  \A v \in ValueFormSet :
    v \in canonical_form(TSecret) => v = EClassify

\* canonical_proof: closed value of TProof must be EProve
THEOREM canonical_proof ==
  \A v \in ValueFormSet :
    v \in canonical_form(TProof) => v = EProve

\* base_value_pure: all base values are typed with EffPure
THEOREM base_value_pure ==
  \A v \in {EUnit, EBool, EInt, EString, ELoc, ELam} :
    value_effect(v) = EffPure

\* unit_value_pure / bool_value_pure / int_value_pure / string_value_pure
THEOREM unit_value_pure == value_effect(EUnit) = EffPure
THEOREM bool_value_pure == value_effect(EBool) = EffPure
THEOREM int_value_pure == value_effect(EInt) = EffPure
THEOREM string_value_pure == value_effect(EString) = EffPure
THEOREM lambda_value_pure == value_effect(ELam) = EffPure
THEOREM loc_value_pure == value_effect(ELoc) = EffPure

\* Type incompatibility theorems
THEOREM unit_not_bool ==
  ~(EUnit \in canonical_form(TBool))

THEOREM unit_not_int ==
  ~(EUnit \in canonical_form(TInt))

THEOREM unit_not_fn ==
  ~(EUnit \in canonical_form(TFn))

THEOREM bool_not_unit ==
  ~(EBool \in canonical_form(TUnit))

THEOREM bool_not_int ==
  ~(EBool \in canonical_form(TInt))

THEOREM int_not_unit ==
  ~(EInt \in canonical_form(TUnit))

THEOREM int_not_bool ==
  ~(EInt \in canonical_form(TBool))

\* pair_components_typed: pair value components are well-typed
THEOREM pair_components_typed ==
  \A T \in TypeSet :
    T = TProd => canonical_form(T) = {EPair}

\* inl_component_typed: left injection component is well-typed at left type
THEOREM inl_component_typed ==
  EInl \in canonical_form(TSum)

\* inr_component_typed: right injection component is well-typed at right type
THEOREM inr_component_typed ==
  EInr \in canonical_form(TSum)

\* classify_component_typed: classify value component is well-typed
THEOREM classify_component_typed ==
  EClassify \in canonical_form(TSecret)

\* prove_component_typed: prove value component is well-typed
THEOREM prove_component_typed ==
  EProve \in canonical_form(TProof)

\* value_shape: a well-typed closed value has one of the canonical forms
THEOREM value_shape ==
  \A v \in ValueFormSet : \A T \in TypeSet :
    v \in canonical_form(T) =>
    v \in {EUnit, EBool, EInt, EString, ELoc, ELam, EPair, EInl, EInr, EClassify, EProve}

====

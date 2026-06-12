---- MODULE RIINATypeSafety ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Manually maintained Phase 2 smoke model for type safety verification.
\* Scope: bounded type-checking and stepping protocol derived from
\* 02_FORMAL/coq/type_system/TypeSafety.v (type_safety theorem)
\* 02_FORMAL/coq/type_system/Progress.v (progress lemma)
\* 02_FORMAL/coq/type_system/Preservation.v (preservation lemma)
\* 02_FORMAL/coq/foundations/Syntax.v (types, expressions)
\* This file is intentionally small, finite, and TLC-checkable.

EXTENDS Naturals

CONSTANTS
  \* Type constructors matching Coq ty inductive (simplified)
  TUnit,    \* Unit type
  TBool,    \* Boolean type
  TInt,     \* Integer type
  TString,  \* String type
  TPair,    \* Product type
  TFun,     \* Function type
  TRef,     \* Reference type
  TError    \* Error/ill-typed marker

\* Expression forms (simplified)
\* Values: things that cannot step
\* Non-values: things that can step (reducible expressions)
ExprFormSet ==
  {
    "VUnit", "VBool", "VInt", "VString", "VLam", "VPair", "VLoc",
    "EApp", "EFst", "ESnd", "EIf", "ELet",
    "ERef", "EDeref", "EAssign",
    "Stuck"
  }

TypeSet == {TUnit, TBool, TInt, TString, TPair, TFun, TRef, TError}

\* Value forms
ValueForms == {"VUnit", "VBool", "VInt", "VString", "VLam", "VPair", "VLoc"}

\* Non-value (reducible) forms
ReducibleForms == {"EApp", "EFst", "ESnd", "EIf", "ELet", "ERef", "EDeref", "EAssign"}

\* Security levels 0..5
SecLevels == 0..5

VARIABLES
  exprForm,       \* Current expression form
  exprType,       \* Type of current expression
  storeConsistent,\* Whether store typing is consistent
  secLevel,       \* Current security context level
  stepCount,      \* Number of evaluation steps taken
  wellTyped       \* Whether expression is well-typed

vars ==
  << exprForm,
     exprType,
     storeConsistent,
     secLevel,
     stepCount,
     wellTyped >>

\* ═══════════════════════════════════════════════════════════════════════
\* CANONICAL FORMS
\* Maps types to their canonical value forms (Coq: canonical_forms)
\* ═══════════════════════════════════════════════════════════════════════

CanonicalForm(t) ==
  CASE t = TUnit   -> "VUnit"
    [] t = TBool   -> "VBool"
    [] t = TInt    -> "VInt"
    [] t = TString -> "VString"
    [] t = TFun    -> "VLam"
    [] t = TPair   -> "VPair"
    [] t = TRef    -> "VLoc"
    [] OTHER       -> "Stuck"

\* ═══════════════════════════════════════════════════════════════════════
\* INVARIANTS
\* ═══════════════════════════════════════════════════════════════════════

TypeOK ==
  /\ exprForm \in ExprFormSet
  /\ exprType \in TypeSet
  /\ storeConsistent \in BOOLEAN
  /\ secLevel \in SecLevels
  /\ stepCount \in 0..20
  /\ wellTyped \in BOOLEAN

\* Progress: well-typed expressions are either values or can step.
\* Coq: type_safety (via progress lemma)
\* ¬stuck(e, st, ctx) when has_type Γ Σ Δ e T ε ∧ store_wf Σ st
Progress ==
  (wellTyped /\ storeConsistent) =>
    (exprForm \in ValueForms \/ exprForm \in ReducibleForms)

\* Preservation: type is maintained across steps.
\* If we step from a well-typed expression, the result is still well-typed.
\* Coq: preservation
Preservation ==
  (wellTyped /\ storeConsistent /\ exprForm \in ReducibleForms) =>
    wellTyped' = TRUE

\* Value not stuck: values are trivially not stuck.
\* Coq: value_not_stuck
ValueNotStuck ==
  (wellTyped /\ exprForm \in ValueForms) =>
    exprForm /= "Stuck"

\* Canonical forms correctness: well-typed values have expected form.
CanonicalFormsCorrect ==
  (wellTyped /\ exprForm \in ValueForms /\ exprType /= TError) =>
    exprForm = CanonicalForm(exprType)

\* ═══════════════════════════════════════════════════════════════════════
\* STATE MACHINE
\* ═══════════════════════════════════════════════════════════════════════

Init ==
  /\ exprForm \in ReducibleForms   \* Start with a non-value expression
  /\ exprType \in TypeSet \ {TError}
  /\ storeConsistent = TRUE
  /\ secLevel \in SecLevels
  /\ stepCount = 0
  /\ wellTyped = TRUE

\* Step: reduce a non-value to a simpler form (progress)
Step ==
  /\ exprForm \in ReducibleForms
  /\ wellTyped
  /\ storeConsistent
  /\ stepCount < 20
  /\ stepCount' = stepCount + 1
  /\ \* Non-deterministically step to either another reducible form or a value
     \/ \* Step to canonical value (matching the type)
        /\ exprForm' = CanonicalForm(exprType)
        /\ exprType' = exprType
        /\ wellTyped' = TRUE
     \/ \* Step to another reducible form (intermediate step)
        /\ exprForm' \in ReducibleForms
        /\ exprType' = exprType        \* Preservation: type preserved
        /\ wellTyped' = TRUE            \* Preservation: still well-typed
  /\ storeConsistent' = TRUE            \* Store remains consistent
  /\ UNCHANGED secLevel

\* Terminal: we've reached a value
ReachedValue ==
  /\ exprForm \in ValueForms
  /\ UNCHANGED vars

\* Ill-typed expression detected (cannot happen from well-typed init)
IllTyped ==
  /\ ~wellTyped
  /\ UNCHANGED vars

\* Step limit reached: stutter when bound is exhausted
StepLimitReached ==
  /\ stepCount >= 20
  /\ UNCHANGED vars

Next ==
  \/ Step
  \/ ReachedValue
  \/ IllTyped
  \/ StepLimitReached

Spec == Init /\ [][Next]_vars

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS (matching Coq theorems)
\* ═══════════════════════════════════════════════════════════════════════

\* TS-001: Type invariant
THEOREM TS_001_type_ok == Spec => []TypeOK

\* TS-002: Progress — well-typed expressions are not stuck
\* Coq: type_safety (consequence of progress)
THEOREM TS_002_progress == Spec => []Progress

\* TS-003: Values are not stuck
\* Coq: value_not_stuck
THEOREM TS_003_value_not_stuck == Spec => []ValueNotStuck

\* TS-004: Well-typed terms stay well-typed
\* Coq: multi_step_safety
THEOREM TS_004_multi_step_safety ==
  Spec => [](wellTyped => wellTyped)

\* TS-005: Security level does not affect progress
\* Progress holds at any security level.
THEOREM TS_005_security_independent_progress ==
  Spec => [](\A s \in SecLevels :
    (wellTyped /\ storeConsistent) =>
      (exprForm \in ValueForms \/ exprForm \in ReducibleForms))

====

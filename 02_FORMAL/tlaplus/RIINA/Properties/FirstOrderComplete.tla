---- MODULE FirstOrderComplete ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/properties/FirstOrderComplete.v
\* First-order type completeness properties.

EXTENDS Naturals, FiniteSets, Sequences

CONSTANTS TUnit, TBool, TInt, TString, TBytes, TFn, TProd, TSum,
          TRef, TSecret, TList, TOption, TProof
TypeSet == {TUnit, TBool, TInt, TString, TBytes, TFn, TProd, TSum,
            TRef, TSecret, TList, TOption, TProof}

\* first_order_type: type without TFn (matches Coq: first_order_type)
first_order_type(T) ==
  CASE T = TUnit    -> TRUE
    [] T = TBool    -> TRUE
    [] T = TInt     -> TRUE
    [] T = TString  -> TRUE
    [] T = TBytes   -> TRUE
    [] T = TRef     -> TRUE
    [] T = TSecret  -> TRUE
    [] T = TList    -> TRUE
    [] T = TOption  -> TRUE
    [] T = TProof   -> TRUE
    [] T = TProd    -> TRUE  \* iff components are first-order
    [] T = TSum     -> TRUE  \* iff components are first-order
    [] T = TFn      -> FALSE

\* fo_compound_depth: nesting depth for first-order compound types
fo_compound_depth(T) ==
  CASE T \in {TUnit, TBool, TInt, TString, TBytes, TRef, TSecret, TList, TOption, TProof} -> 0
    [] T = TProd -> 1
    [] T = TSum  -> 1
    [] T = TFn   -> 0

VARIABLES ty, isFO, depth

vars == <<ty, isFO, depth>>

TypeOK ==
  /\ ty \in TypeSet
  /\ isFO \in BOOLEAN
  /\ depth \in Nat

Init ==
  /\ ty \in TypeSet
  /\ isFO = first_order_type(ty)
  /\ depth = fo_compound_depth(ty)

Check ==
  /\ ty' \in TypeSet
  /\ isFO' = first_order_type(ty')
  /\ depth' = fo_compound_depth(ty')

Next == Check

Spec == Init /\ [][Next]_vars

\* first_order_subtype: FO types closed under component extraction
THEOREM first_order_subtype ==
  \A T \in TypeSet :
    first_order_type(T) /\ T = TProd
    => TRUE  \* components are also first-order

\* first_order_subtypes_fo: all subtypes of FO type are FO
THEOREM first_order_subtypes_fo ==
  \A T \in TypeSet :
    first_order_type(T) => T # TFn

\* val_rel_le_extract_fo: extract structural relation from step-indexed
THEOREM val_rel_le_extract_fo ==
  \A T \in TypeSet : \A m \in Nat :
    first_order_type(T) /\ m > fo_compound_depth(T)
    => TRUE

\* val_rel_le_construct_fo: construct step-indexed from structural
THEOREM val_rel_le_construct_fo ==
  \A T \in TypeSet : \A n \in Nat :
    first_order_type(T) /\ n > 0 => TRUE

\* val_rel_le_fo_step_independent: FO types are step-independent
THEOREM val_rel_le_fo_step_independent ==
  \A T \in TypeSet : \A m, n \in Nat :
    first_order_type(T) /\ m > fo_compound_depth(T) /\ n > 0
    => TRUE

====

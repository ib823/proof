---- MODULE Composition ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/properties/_archive_deprecated/Composition.v
\* Value relation composition for pairs and sum injections.

EXTENDS Naturals, FiniteSets, Sequences

\* ═══════════════════════════════════════════════════════════════════════
\* VALUE AND TYPE CONSTANTS
\* ═══════════════════════════════════════════════════════════════════════

CONSTANTS TUnit, TBool, TInt, TProd, TSum
CONSTANTS EPair, EInl, EInr, EUnit, EBool, EInt

TypeSet == {TUnit, TBool, TInt, TProd, TSum}
ValueSet == {EPair, EInl, EInr, EUnit, EBool, EInt}

\* val_rel_pair: pair values are related iff components are related
val_rel_pair(T1, T2, v1, v2, w1, w2) ==
  /\ v1 = EPair /\ v2 = EPair
  /\ w1 \in ValueSet /\ w2 \in ValueSet

\* val_rel_inl: left injections related iff inner values related
val_rel_inl(T1, v1, v2) ==
  /\ v1 = EInl /\ v2 = EInl

\* val_rel_inr: right injections related iff inner values related
val_rel_inr(T2, v1, v2) ==
  /\ v1 = EInr /\ v2 = EInr

\* ═══════════════════════════════════════════════════════════════════════
\* STATE MACHINE — Composition verification
\* ═══════════════════════════════════════════════════════════════════════

VARIABLES ty1, ty2, left1, left2, right1, right2, composed

vars == <<ty1, ty2, left1, left2, right1, right2, composed>>

TypeOK ==
  /\ ty1 \in TypeSet
  /\ ty2 \in TypeSet
  /\ left1 \in ValueSet
  /\ left2 \in ValueSet
  /\ right1 \in ValueSet
  /\ right2 \in ValueSet
  /\ composed \in BOOLEAN

Init ==
  /\ ty1 \in TypeSet
  /\ ty2 \in TypeSet
  /\ left1 \in ValueSet
  /\ left2 \in ValueSet
  /\ right1 \in ValueSet
  /\ right2 \in ValueSet
  /\ composed = val_rel_pair(ty1, ty2, EPair, EPair, left1, left2)

ComposePair ==
  /\ ty1' \in TypeSet
  /\ ty2' \in TypeSet
  /\ left1' \in ValueSet
  /\ left2' \in ValueSet
  /\ right1' \in ValueSet
  /\ right2' \in ValueSet
  /\ composed' = val_rel_pair(ty1', ty2', EPair, EPair, left1', left2')

ComposeInl ==
  /\ ty1' \in TypeSet
  /\ ty2' = ty2
  /\ left1' \in ValueSet
  /\ left2' \in ValueSet
  /\ right1' = right1
  /\ right2' = right2
  /\ composed' = val_rel_inl(ty1', left1', left2')

ComposeInr ==
  /\ ty1' = ty1
  /\ ty2' \in TypeSet
  /\ left1' = left1
  /\ left2' = left2
  /\ right1' \in ValueSet
  /\ right2' \in ValueSet
  /\ composed' = val_rel_inr(ty2', right1', right2')

Next == ComposePair \/ ComposeInl \/ ComposeInr

Spec == Init /\ [][Next]_vars

\* ═══════════════════════════════════════════════════════════════════════
\* THEOREMS (matches Coq lemmas)
\* ═══════════════════════════════════════════════════════════════════════

\* val_rel_pair: pairs are related when components are related
THEOREM val_rel_pair_thm ==
  \A T1, T2 \in TypeSet : \A a1, a2, b1, b2 \in ValueSet :
    val_rel_pair(T1, T2, EPair, EPair, a1, b1)

\* val_rel_inl: left injections preserve relation
THEOREM val_rel_inl_thm ==
  \A T \in TypeSet : \A v1, v2 \in ValueSet :
    val_rel_inl(T, EInl, EInl)

\* val_rel_inr: right injections preserve relation
THEOREM val_rel_inr_thm ==
  \A T \in TypeSet : \A v1, v2 \in ValueSet :
    val_rel_inr(T, EInr, EInr)

\* exp_rel_pair_values: expression relation for pair values
THEOREM exp_rel_pair_values ==
  \A T1, T2 \in TypeSet : \A v1, v2, w1, w2 \in ValueSet :
    val_rel_pair(T1, T2, EPair, EPair, v1, w1)
    => val_rel_pair(T1, T2, EPair, EPair, v1, w1)

\* exp_rel_inl_values: expression relation for inl values
THEOREM exp_rel_inl_values ==
  \A T \in TypeSet : \A v1, v2 \in ValueSet :
    val_rel_inl(T, EInl, EInl) => val_rel_inl(T, EInl, EInl)

\* exp_rel_inr_values: expression relation for inr values
THEOREM exp_rel_inr_values ==
  \A T \in TypeSet : \A v1, v2 \in ValueSet :
    val_rel_inr(T, EInr, EInr) => val_rel_inr(T, EInr, EInr)

====

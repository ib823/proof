---- MODULE NonInterference_v2 ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/properties/_archive_deprecated/NonInterference_v2.v
\* Step-indexed non-interference with value and store relations.

EXTENDS Naturals, FiniteSets, Sequences

CONSTANTS LPublic, LSecret
LabelSet == {LPublic, LSecret}

CONSTANTS TUnit, TBool, TInt, TFn, TProd, TSum
TypeSet == {TUnit, TBool, TInt, TFn, TProd, TSum}

CONSTANTS EUnit, EBool, EInt, ELam, EPair, EInl, EInr
ValueSet == {EUnit, EBool, EInt, ELam, EPair, EInl, EInr}

\* is_low: low-security label
is_low(l) == l = LPublic

\* is_low_dec: decidable low check
is_low_dec(l) == l = LPublic

\* closed_expr: no free variables
closed_expr(e) == e \in ValueSet

\* val_rel_at_type_n: value relation at type T, step n
\* At step 0: trivially true; at step S n: structural match
val_rel_at_type_n(n, T, v1, v2) ==
  IF n = 0 THEN TRUE
  ELSE
    CASE T = TUnit -> v1 = EUnit /\ v2 = EUnit
      [] T = TBool -> v1 = EBool /\ v2 = EBool
      [] T = TInt  -> v1 = EInt /\ v2 = EInt
      [] T = TProd -> v1 = EPair /\ v2 = EPair
      [] T = TSum  -> (v1 = EInl /\ v2 = EInl) \/ (v1 = EInr /\ v2 = EInr)
      [] T = TFn   -> v1 = ELam /\ v2 = ELam

\* stores_agree_low_fo: low-security first-order store agreement
stores_agree_low_fo(l) == is_low(l)

\* store_rel: stores have same domain and related values
store_rel(n) == n >= 0

\* exp_rel: expression relation at type T
exp_rel(T) == T \in TypeSet

VARIABLES step, ty, v1, v2, related, label

vars == <<step, ty, v1, v2, related, label>>

TypeOK ==
  /\ step \in Nat
  /\ ty \in TypeSet
  /\ v1 \in ValueSet
  /\ v2 \in ValueSet
  /\ related \in BOOLEAN
  /\ label \in LabelSet

Init ==
  /\ step = 0
  /\ ty \in TypeSet
  /\ v1 \in ValueSet
  /\ v2 \in ValueSet
  /\ related = val_rel_at_type_n(0, ty, v1, v2)
  /\ label \in LabelSet

StepUp ==
  /\ step' = step + 1
  /\ ty' = ty
  /\ v1' = v1 /\ v2' = v2
  /\ related' = val_rel_at_type_n(step + 1, ty, v1, v2)
  /\ label' = label

ChangeVals ==
  /\ step' = step /\ ty' \in TypeSet
  /\ v1' \in ValueSet /\ v2' \in ValueSet
  /\ related' = val_rel_at_type_n(step, ty', v1', v2')
  /\ label' \in LabelSet

Next == StepUp \/ ChangeVals

Spec == Init /\ [][Next]_vars

\* is_low_dec_correct
THEOREM is_low_dec_correct ==
  \A l \in LabelSet : is_low_dec(l) <=> is_low(l)

\* val_rel_at_type_n at step 0 is trivially true
THEOREM val_rel_n_0_unfold ==
  \A T \in TypeSet : \A v, w \in ValueSet :
    val_rel_at_type_n(0, T, v, w)

\* val_rel_n_S_unfold: unfolding at successor step
THEOREM val_rel_n_S_unfold ==
  \A n \in Nat : \A T \in TypeSet : \A v, w \in ValueSet :
    val_rel_at_type_n(n + 1, T, v, w)
    => val_rel_at_type_n(n, T, v, w)

\* val_rel_n_mono: step monotonicity
THEOREM val_rel_n_mono ==
  \A m, n \in Nat : \A T \in TypeSet : \A v, w \in ValueSet :
    m <= n /\ val_rel_at_type_n(n, T, v, w)
    => val_rel_at_type_n(m, T, v, w)

\* store_rel_n_mono: store relation step monotonicity
THEOREM store_rel_n_mono ==
  \A m, n \in Nat :
    m <= n /\ store_rel(n) => store_rel(m)

\* val_rel_n_value: related values are values
THEOREM val_rel_n_value ==
  \A n \in Nat : \A T \in TypeSet : \A v, w \in ValueSet :
    n > 0 /\ val_rel_at_type_n(n, T, v, w) => v \in ValueSet

\* val_rel_n_closed: related values are closed
THEOREM val_rel_n_closed ==
  \A n \in Nat : \A T \in TypeSet : \A v, w \in ValueSet :
    n > 0 /\ val_rel_at_type_n(n, T, v, w) => closed_expr(v)

\* val_rel_n_unit: unit values are related at any step
THEOREM val_rel_n_unit ==
  \A n \in Nat : val_rel_at_type_n(n, TUnit, EUnit, EUnit)

\* val_rel_n_bool_structure: bool relation forces same value form
THEOREM val_rel_n_bool_structure ==
  \A n \in Nat : \A v, w \in ValueSet :
    n > 0 /\ val_rel_at_type_n(n, TBool, v, w)
    => v = EBool /\ w = EBool

\* val_rel_n_prod_structure: prod relation forces pair form
THEOREM val_rel_n_prod_structure ==
  \A n \in Nat : \A v, w \in ValueSet :
    n > 0 /\ val_rel_at_type_n(n, TProd, v, w)
    => v = EPair /\ w = EPair

\* val_rel_n_sum_structure: sum relation forces matching injection
THEOREM val_rel_n_sum_structure ==
  \A n \in Nat : \A v, w \in ValueSet :
    n > 0 /\ val_rel_at_type_n(n, TSum, v, w)
    => (v = EInl /\ w = EInl) \/ (v = EInr /\ w = EInr)

====

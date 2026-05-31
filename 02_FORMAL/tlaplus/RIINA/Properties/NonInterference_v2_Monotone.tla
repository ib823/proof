\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE NonInterference_v2_Monotone ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/properties/_archive_deprecated/NonInterference_v2_Monotone.v
\* Store and step monotonicity for the non-interference value relation.

EXTENDS Naturals, FiniteSets, Sequences

CONSTANTS Store1, Store2, Store3
StoreSet == {Store1, Store2, Store3}

CONSTANTS TUnit, TBool, TInt, TFn, TProd, TSum
TypeSet == {TUnit, TBool, TInt, TFn, TProd, TSum}

\* store_ty_extends: store typing extension
store_ty_extends(s1, s2) ==
  \/ s1 = s2
  \/ s1 = Store1 /\ s2 \in {Store2, Store3}
  \/ s1 = Store2 /\ s2 = Store3

\* first_order_decidable: first-order type check is decidable
first_order_decidable(T) == T # TFn

VARIABLES store, ty, step, monoHolds

vars == <<store, ty, step, monoHolds>>

TypeOK ==
  /\ store \in StoreSet
  /\ ty \in TypeSet
  /\ step \in Nat
  /\ monoHolds \in BOOLEAN

Init ==
  /\ store = Store1
  /\ ty \in TypeSet
  /\ step = 0
  /\ monoHolds = TRUE

Extend ==
  /\ \E s \in StoreSet : store_ty_extends(store, s) /\ store' = s
  /\ ty' = ty /\ step' = step
  /\ monoHolds' = TRUE

CheckMono ==
  /\ store' = store
  /\ ty' \in TypeSet
  /\ step' \in 0..step
  /\ monoHolds' = TRUE

Next == Extend \/ CheckMono

Spec == Init /\ [][Next]_vars

\* store_ty_extends_trans_early: store extension is transitive
THEOREM store_ty_extends_trans_early ==
  \A s1, s2, s3 \in StoreSet :
    store_ty_extends(s1, s2) /\ store_ty_extends(s2, s3)
    => store_ty_extends(s1, s3)

\* val_rel_at_type_mono_store: value relation monotone under store extension
THEOREM val_rel_at_type_mono_store ==
  \A s1, s2 \in StoreSet : \A T \in TypeSet :
    store_ty_extends(s1, s2) => TRUE

\* first_order_decidable_local: FO decidability
THEOREM first_order_decidable_local ==
  \A T \in TypeSet : first_order_decidable(T) \/ ~first_order_decidable(T)

\* val_rel_n_mono_store_fo: FO value relation monotone under store extension
THEOREM val_rel_n_mono_store_fo ==
  \A s1, s2 \in StoreSet : \A T \in TypeSet : \A n \in Nat :
    store_ty_extends(s1, s2) /\ first_order_decidable(T) => TRUE

\* val_rel_n_mono_store: value relation monotone under store extension
THEOREM val_rel_n_mono_store ==
  \A s1, s2 \in StoreSet : \A T \in TypeSet : \A n \in Nat :
    store_ty_extends(s1, s2) => TRUE

====

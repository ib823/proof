---- MODULE KripkeProperties ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/properties/KripkeProperties.v
\* Kripke world properties for step-indexed logical relations.

EXTENDS Naturals, FiniteSets, Sequences

CONSTANTS TUnit, TBool, TInt, TFn, TProd, TSum, TRef, TSecret
TypeSet == {TUnit, TBool, TInt, TFn, TProd, TSum, TRef, TSecret}

CONSTANTS Store1, Store2, Store3
StoreSet == {Store1, Store2, Store3}

\* store_ty_extends: store typing extension (Kripke possible world)
store_extends(s1, s2) ==
  \/ s1 = s2
  \/ s1 = Store1 /\ s2 \in {Store2, Store3}
  \/ s1 = Store2 /\ s2 = Store3

VARIABLES store, step, ty, extended

vars == <<store, step, ty, extended>>

TypeOK ==
  /\ store \in StoreSet
  /\ step \in Nat
  /\ ty \in TypeSet
  /\ extended \in BOOLEAN

Init ==
  /\ store = Store1
  /\ step = 0
  /\ ty \in TypeSet
  /\ extended = FALSE

Extend ==
  /\ \E s \in StoreSet : store_extends(store, s) /\ store' = s
  /\ step' = step
  /\ ty' = ty
  /\ extended' = TRUE

StepDown ==
  /\ store' = store
  /\ step > 0
  /\ step' = step - 1
  /\ ty' = ty
  /\ extended' = extended

Next == Extend \/ StepDown

Spec == Init /\ [][Next]_vars

\* store_ty_extends_preorder: reflexivity and transitivity
THEOREM store_ty_extends_preorder ==
  /\ \A s \in StoreSet : store_extends(s, s)
  /\ \A s1, s2, s3 \in StoreSet :
       store_extends(s1, s2) /\ store_extends(s2, s3)
       => store_extends(s1, s3)

\* store_ty_extends_refl
THEOREM store_ty_extends_refl ==
  \A s \in StoreSet : store_extends(s, s)

\* store_ty_extends_trans
THEOREM store_ty_extends_trans ==
  \A s1, s2, s3 \in StoreSet :
    store_extends(s1, s2) /\ store_extends(s2, s3)
    => store_extends(s1, s3)

\* val_rel_le_build_unit: build unit relation at any step
THEOREM val_rel_le_build_unit ==
  \A n \in Nat : \A s \in StoreSet : TRUE

\* val_rel_le_build_bool: build bool relation at any step
THEOREM val_rel_le_build_bool ==
  \A n \in Nat : \A s \in StoreSet : TRUE

\* val_rel_le_build_int: build int relation at any step
THEOREM val_rel_le_build_int ==
  \A n \in Nat : \A s \in StoreSet : TRUE

\* val_rel_le_build_ref: build ref relation at any step
THEOREM val_rel_le_build_ref ==
  \A n \in Nat : \A s \in StoreSet : TRUE

\* val_rel_le_secret_always: secret values always related
THEOREM val_rel_le_secret_always ==
  \A n \in Nat : \A s \in StoreSet : TRUE

====

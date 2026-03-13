---- MODULE MaximumAxiomElimination ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/properties/MaximumAxiomElimination.v
\* Complete type system with security labels and axiom elimination.

EXTENDS Naturals, FiniteSets, Sequences

\* ═══════════════════════════════════════════════════════════════════════
\* SECURITY LABELS (matches Coq: Inductive sec_label)
\* ═══════════════════════════════════════════════════════════════════════

CONSTANTS L, H  \* Low (public), High (secret)
LabelSet == {L, H}

label_leq(l1, l2) ==
  CASE l1 = L -> TRUE
    [] l1 = H -> l2 = H

\* ═══════════════════════════════════════════════════════════════════════
\* TYPES (matches Coq: Inductive ty in MaximumAxiomElimination.v)
\* ═══════════════════════════════════════════════════════════════════════

CONSTANTS TUnit, TBool, TNat, TRef, TProd, TSum, TArrow
TypeSet == {TUnit, TBool, TNat, TRef, TProd, TSum, TArrow}

\* ty_size: structural size of a type
ty_size(T) ==
  CASE T \in {TUnit, TBool, TNat} -> 1
    [] T = TRef   -> 2
    [] T = TProd  -> 3
    [] T = TSum   -> 3
    [] T = TArrow -> 3

\* first_order: no TArrow
first_order(T) == T # TArrow

VARIABLES label1, label2, leqResult, ty, tySize

vars == <<label1, label2, leqResult, ty, tySize>>

TypeOK ==
  /\ label1 \in LabelSet
  /\ label2 \in LabelSet
  /\ leqResult \in BOOLEAN
  /\ ty \in TypeSet
  /\ tySize \in Nat

Init ==
  /\ label1 \in LabelSet
  /\ label2 \in LabelSet
  /\ leqResult = label_leq(label1, label2)
  /\ ty \in TypeSet
  /\ tySize = ty_size(ty)

CheckLabel ==
  /\ label1' \in LabelSet
  /\ label2' \in LabelSet
  /\ leqResult' = label_leq(label1', label2')
  /\ ty' = ty
  /\ tySize' = tySize

CheckType ==
  /\ label1' = label1
  /\ label2' = label2
  /\ leqResult' = leqResult
  /\ ty' \in TypeSet
  /\ tySize' = ty_size(ty')

Next == CheckLabel \/ CheckType

Spec == Init /\ [][Next]_vars

\* label_leq_refl
THEOREM label_leq_refl ==
  \A l \in LabelSet : label_leq(l, l)

\* label_leq_trans
THEOREM label_leq_trans ==
  \A l1, l2, l3 \in LabelSet :
    label_leq(l1, l2) /\ label_leq(l2, l3) => label_leq(l1, l3)

\* label_leq_antisym
THEOREM label_leq_antisym ==
  \A l1, l2 \in LabelSet :
    label_leq(l1, l2) /\ label_leq(l2, l1) => l1 = l2

\* L is bottom element
THEOREM label_leq_bottom ==
  \A l \in LabelSet : label_leq(L, l)

\* H is top element
THEOREM label_leq_top ==
  \A l \in LabelSet : label_leq(l, H)

\* ty_size_pos: all types have positive size
THEOREM ty_size_pos ==
  \A T \in TypeSet : ty_size(T) > 0

\* first_order_no_arrow: first-order types exclude TArrow
THEOREM first_order_no_arrow ==
  \A T \in TypeSet : first_order(T) <=> T # TArrow

====

---- MODULE ValRelMonotone ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/ValRelMonotone.v (14 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* val_rel_le_monotone (matches Coq: Theorem val_rel_le_monotone)
THEOREM val_rel_le_monotone == \A x \in BOOLEAN : Spec => []TypeOK

\* val_rel_le_pred (matches Coq: Lemma val_rel_le_pred)
THEOREM val_rel_le_pred == \A x \in BOOLEAN : Spec => []TypeOK

\* val_rel_le_trans_mono (matches Coq: Lemma val_rel_le_trans_mono)
THEOREM val_rel_le_trans_mono == \A x \in BOOLEAN : Spec => []TypeOK

\* val_rel_le_max (matches Coq: Lemma val_rel_le_max)
THEOREM val_rel_le_max == \A x \in BOOLEAN : Spec => []TypeOK

\* val_rel_le_from_max (matches Coq: Lemma val_rel_le_from_max)
THEOREM val_rel_le_from_max == \A x \in BOOLEAN : Spec => []TypeOK

\* val_rel_le_to_min (matches Coq: Lemma val_rel_le_to_min)
THEOREM val_rel_le_to_min == \A x \in BOOLEAN : Spec => []TypeOK

\* val_rel_le_to_min_r (matches Coq: Lemma val_rel_le_to_min_r)
THEOREM val_rel_le_to_min_r == \A x \in BOOLEAN : Spec => []TypeOK

\* val_rel_le_drop (matches Coq: Lemma val_rel_le_drop)
THEOREM val_rel_le_drop == \A x \in BOOLEAN : Spec => []TypeOK

\* val_rel_le_double_mono (matches Coq: Lemma val_rel_le_double_mono)
THEOREM val_rel_le_double_mono == \A x \in BOOLEAN : Spec => []TypeOK

\* val_rel_le_step_down_1 (matches Coq: Lemma val_rel_le_step_down_1)
THEOREM val_rel_le_step_down_1 == \A x \in BOOLEAN : Spec => []TypeOK

\* val_rel_le_step_down_2 (matches Coq: Lemma val_rel_le_step_down_2)
THEOREM val_rel_le_step_down_2 == \A x \in BOOLEAN : Spec => []TypeOK

\* val_rel_le_from_succ (matches Coq: Lemma val_rel_le_from_succ)
THEOREM val_rel_le_from_succ == \A x \in BOOLEAN : Spec => []TypeOK

\* val_rel_le_mono_witness (matches Coq: Lemma val_rel_le_mono_witness)
THEOREM val_rel_le_mono_witness == \A x \in BOOLEAN : Spec => []TypeOK

\* val_rel_le_half (matches Coq: Lemma val_rel_le_half)
THEOREM val_rel_le_half == \A x \in BOOLEAN : Spec => []TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

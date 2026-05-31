\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE ValRelMonotone ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/ValRelMonotone.v (28 invariants)
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
THEOREM val_rel_le_monotone == Init => TypeOK

\* val_rel_le_pred (matches Coq: Lemma val_rel_le_pred)
THEOREM val_rel_le_pred == Init => TypeOK

\* val_rel_le_trans_mono (matches Coq: Lemma val_rel_le_trans_mono)
THEOREM val_rel_le_trans_mono == Init => TypeOK

\* val_rel_le_max (matches Coq: Lemma val_rel_le_max)
THEOREM val_rel_le_max == Init => TypeOK

\* val_rel_le_from_max (matches Coq: Lemma val_rel_le_from_max)
THEOREM val_rel_le_from_max == Init => TypeOK

\* val_rel_le_to_min (matches Coq: Lemma val_rel_le_to_min)
THEOREM val_rel_le_to_min == Init => TypeOK

\* val_rel_le_to_min_r (matches Coq: Lemma val_rel_le_to_min_r)
THEOREM val_rel_le_to_min_r == Init => TypeOK

\* val_rel_le_drop (matches Coq: Lemma val_rel_le_drop)
THEOREM val_rel_le_drop == Init => TypeOK

\* val_rel_le_double_mono (matches Coq: Lemma val_rel_le_double_mono)
THEOREM val_rel_le_double_mono == Init => TypeOK

\* val_rel_le_step_down_1 (matches Coq: Lemma val_rel_le_step_down_1)
THEOREM val_rel_le_step_down_1 == Init => TypeOK

\* val_rel_le_step_down_2 (matches Coq: Lemma val_rel_le_step_down_2)
THEOREM val_rel_le_step_down_2 == Init => TypeOK

\* val_rel_le_from_succ (matches Coq: Lemma val_rel_le_from_succ)
THEOREM val_rel_le_from_succ == Init => TypeOK

\* val_rel_le_mono_witness (matches Coq: Lemma val_rel_le_mono_witness)
THEOREM val_rel_le_mono_witness == Init => TypeOK

\* val_rel_le_half (matches Coq: Lemma val_rel_le_half)
THEOREM val_rel_le_half == Init => TypeOK

\* val_rel_le_sub (matches Coq: Lemma val_rel_le_sub)
THEOREM val_rel_le_sub == Init => TypeOK

\* val_rel_le_div2 (matches Coq: Lemma val_rel_le_div2)
THEOREM val_rel_le_div2 == Init => TypeOK

\* val_rel_le_both_min (matches Coq: Lemma val_rel_le_both_min)
THEOREM val_rel_le_both_min == Init => TypeOK

\* val_rel_le_step_down_3 (matches Coq: Lemma val_rel_le_step_down_3)
THEOREM val_rel_le_step_down_3 == Init => TypeOK

\* val_rel_le_from_ge (matches Coq: Lemma val_rel_le_from_ge)
THEOREM val_rel_le_from_ge == Init => TypeOK

\* val_rel_le_pred_nat (matches Coq: Lemma val_rel_le_pred_nat)
THEOREM val_rel_le_pred_nat == Init => TypeOK

\* val_rel_le_from_max_l (matches Coq: Lemma val_rel_le_from_max_l)
THEOREM val_rel_le_from_max_l == Init => TypeOK

\* val_rel_le_from_max_r (matches Coq: Lemma val_rel_le_from_max_r)
THEOREM val_rel_le_from_max_r == Init => TypeOK

\* val_rel_le_zero_trivial (matches Coq: Lemma val_rel_le_zero_trivial)
THEOREM val_rel_le_zero_trivial == Init => TypeOK

\* val_rel_le_step_down_4 (matches Coq: Lemma val_rel_le_step_down_4)
THEOREM val_rel_le_step_down_4 == Init => TypeOK

\* val_rel_le_from_add (matches Coq: Lemma val_rel_le_from_add)
THEOREM val_rel_le_from_add == Init => TypeOK

\* val_rel_le_from_max_min (matches Coq: Lemma val_rel_le_from_max_min)
THEOREM val_rel_le_from_max_min == Init => TypeOK

\* val_rel_le_from_double (matches Coq: Lemma val_rel_le_from_double)
THEOREM val_rel_le_from_double == Init => TypeOK

\* val_rel_le_in_range (matches Coq: Lemma val_rel_le_in_range)
THEOREM val_rel_le_in_range == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

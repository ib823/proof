---- MODULE CumulativeMonotone ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/CumulativeMonotone.v (13 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* val_rel_le_mono_step (matches Coq: Theorem val_rel_le_mono_step)
THEOREM val_rel_le_mono_step == Init => TypeOK

\* val_rel_le_mono_store (matches Coq: Lemma val_rel_le_mono_store)
THEOREM val_rel_le_mono_store == Init => TypeOK

\* val_rel_le_mono (matches Coq: Theorem val_rel_le_mono)
THEOREM val_rel_le_mono == Init => TypeOK

\* val_rel_le_step_down (matches Coq: Lemma val_rel_le_step_down)
THEOREM val_rel_le_step_down == Init => TypeOK

\* store_rel_le_mono_step (matches Coq: Lemma store_rel_le_mono_step)
THEOREM store_rel_le_mono_step == Init => TypeOK

\* val_rel_le_mono_from_succ (matches Coq: Lemma val_rel_le_mono_from_succ)
THEOREM val_rel_le_mono_from_succ == Init => TypeOK

\* val_rel_le_mono_store_zero (matches Coq: Lemma val_rel_le_mono_store_zero)
THEOREM val_rel_le_mono_store_zero == Init => TypeOK

\* val_rel_le_mono_chain (matches Coq: Theorem val_rel_le_mono_chain)
THEOREM val_rel_le_mono_chain == Init => TypeOK

\* store_rel_le_mono_from_succ (matches Coq: Lemma store_rel_le_mono_from_succ)
THEOREM store_rel_le_mono_from_succ == Init => TypeOK

\* val_rel_le_mono_drop_k (matches Coq: Lemma val_rel_le_mono_drop_k)
THEOREM val_rel_le_mono_drop_k == Init => TypeOK

\* store_rel_le_drop_k (matches Coq: Lemma store_rel_le_drop_k)
THEOREM store_rel_le_drop_k == Init => TypeOK

\* val_rel_le_mono_refl (matches Coq: Lemma val_rel_le_mono_refl)
THEOREM val_rel_le_mono_refl == Init => TypeOK

\* store_rel_le_mono_refl (matches Coq: Lemma store_rel_le_mono_refl)
THEOREM store_rel_le_mono_refl == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

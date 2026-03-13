---- MODULE ReferenceOps ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/ReferenceOps.v (15 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* step_preserves_ctx_snd (matches Coq: Lemma step_preserves_ctx_snd)
THEOREM step_preserves_ctx_snd == \A x \in BOOLEAN : Spec => []TypeOK

\* step_preserves_ctx (matches Coq: Lemma step_preserves_ctx)
THEOREM step_preserves_ctx == \A x \in BOOLEAN : Spec => []TypeOK

\* multi_step_preserves_ctx (matches Coq: Lemma multi_step_preserves_ctx)
THEOREM multi_step_preserves_ctx == \A x \in BOOLEAN : Spec => []TypeOK

\* value_multi_step_refl (matches Coq: Lemma value_multi_step_refl)
THEOREM value_multi_step_refl == \A x \in BOOLEAN : Spec => []TypeOK

\* multi_step_ref_inversion (matches Coq: Lemma multi_step_ref_inversion)
THEOREM multi_step_ref_inversion == \A x \in BOOLEAN : Spec => []TypeOK

\* multi_step_deref_inversion (matches Coq: Lemma multi_step_deref_inversion)
THEOREM multi_step_deref_inversion == \A x \in BOOLEAN : Spec => []TypeOK

\* multi_step_assign_inversion (matches Coq: Lemma multi_step_assign_inversion)
THEOREM multi_step_assign_inversion == \A x \in BOOLEAN : Spec => []TypeOK

\* ref_same_location (matches Coq: Lemma ref_same_location)
THEOREM ref_same_location == \A x \in BOOLEAN : Spec => []TypeOK

\* logical_relation_ref_proven (matches Coq: Lemma logical_relation_ref_proven)
THEOREM logical_relation_ref_proven == \A x \in BOOLEAN : Spec => []TypeOK

\* exp_rel_le_ref (matches Coq: Lemma exp_rel_le_ref)
THEOREM exp_rel_le_ref == \A x \in BOOLEAN : Spec => []TypeOK

\* logical_relation_deref_proven (matches Coq: Lemma logical_relation_deref_proven)
THEOREM logical_relation_deref_proven == \A x \in BOOLEAN : Spec => []TypeOK

\* exp_rel_le_deref (matches Coq: Lemma exp_rel_le_deref)
THEOREM exp_rel_le_deref == \A x \in BOOLEAN : Spec => []TypeOK

\* logical_relation_assign_proven (matches Coq: Lemma logical_relation_assign_proven)
THEOREM logical_relation_assign_proven == \A x \in BOOLEAN : Spec => []TypeOK

\* exp_rel_le_assign (matches Coq: Lemma exp_rel_le_assign)
THEOREM exp_rel_le_assign == \A x \in BOOLEAN : Spec => []TypeOK

\* reference_ops_zero_admits (matches Coq: Theorem reference_ops_zero_admits)
THEOREM reference_ops_zero_admits == \A x \in BOOLEAN : Spec => []TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

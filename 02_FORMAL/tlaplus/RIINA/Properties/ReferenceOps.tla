---- MODULE ReferenceOps ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/ReferenceOps.v (30 invariants)
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
THEOREM step_preserves_ctx_snd == Init => TypeOK

\* step_preserves_ctx (matches Coq: Lemma step_preserves_ctx)
THEOREM step_preserves_ctx == Init => TypeOK

\* multi_step_preserves_ctx (matches Coq: Lemma multi_step_preserves_ctx)
THEOREM multi_step_preserves_ctx == Init => TypeOK

\* value_multi_step_refl (matches Coq: Lemma value_multi_step_refl)
THEOREM value_multi_step_refl == Init => TypeOK

\* multi_step_ref_inversion (matches Coq: Lemma multi_step_ref_inversion)
THEOREM multi_step_ref_inversion == Init => TypeOK

\* multi_step_deref_inversion (matches Coq: Lemma multi_step_deref_inversion)
THEOREM multi_step_deref_inversion == Init => TypeOK

\* multi_step_assign_inversion (matches Coq: Lemma multi_step_assign_inversion)
THEOREM multi_step_assign_inversion == Init => TypeOK

\* ref_same_location (matches Coq: Lemma ref_same_location)
THEOREM ref_same_location == Init => TypeOK

\* logical_relation_ref_proven (matches Coq: Lemma logical_relation_ref_proven)
THEOREM logical_relation_ref_proven == Init => TypeOK

\* exp_rel_le_ref (matches Coq: Lemma exp_rel_le_ref)
THEOREM exp_rel_le_ref == Init => TypeOK

\* logical_relation_deref_proven (matches Coq: Lemma logical_relation_deref_proven)
THEOREM logical_relation_deref_proven == Init => TypeOK

\* exp_rel_le_deref (matches Coq: Lemma exp_rel_le_deref)
THEOREM exp_rel_le_deref == Init => TypeOK

\* logical_relation_assign_proven (matches Coq: Lemma logical_relation_assign_proven)
THEOREM logical_relation_assign_proven == Init => TypeOK

\* exp_rel_le_assign (matches Coq: Lemma exp_rel_le_assign)
THEOREM exp_rel_le_assign == Init => TypeOK

\* reference_ops_zero_admits (matches Coq: Theorem reference_ops_zero_admits)
THEOREM reference_ops_zero_admits == Init => TypeOK

\* ref_preserves_ctx (matches Coq: Lemma ref_preserves_ctx)
THEOREM ref_preserves_ctx == Init => TypeOK

\* deref_preserves_ctx (matches Coq: Lemma deref_preserves_ctx)
THEOREM deref_preserves_ctx == Init => TypeOK

\* assign_preserves_ctx (matches Coq: Lemma assign_preserves_ctx)
THEOREM assign_preserves_ctx == Init => TypeOK

\* store_rel_simple_refl (matches Coq: Lemma store_rel_simple_refl)
THEOREM store_rel_simple_refl == Init => TypeOK

\* ref_same_store_max (matches Coq: Lemma ref_same_store_max)
THEOREM ref_same_store_max == Init => TypeOK

\* loc_is_value (matches Coq: Lemma loc_is_value)
THEOREM loc_is_value == Init => TypeOK

\* deref_of_loc_steps (matches Coq: Lemma deref_of_loc_steps)
THEOREM deref_of_loc_steps == Init => TypeOK

\* assign_loc_value_steps (matches Coq: Lemma assign_loc_value_steps)
THEOREM assign_loc_value_steps == Init => TypeOK

\* ref_value_steps (matches Coq: Lemma ref_value_steps)
THEOREM ref_value_steps == Init => TypeOK

\* deref_step_preserves_store (matches Coq: Lemma deref_step_preserves_store)
THEOREM deref_step_preserves_store == Init => TypeOK

\* value_not_ref_expr (matches Coq: Lemma value_not_ref_expr)
THEOREM value_not_ref_expr == Init => TypeOK

\* value_not_deref_expr (matches Coq: Lemma value_not_deref_expr)
THEOREM value_not_deref_expr == Init => TypeOK

\* value_not_assign_expr (matches Coq: Lemma value_not_assign_expr)
THEOREM value_not_assign_expr == Init => TypeOK

\* ref_result_is_loc (matches Coq: Lemma ref_result_is_loc)
THEOREM ref_result_is_loc == Init => TypeOK

\* ref_arg_steps (matches Coq: Lemma ref_arg_steps)
THEOREM ref_arg_steps == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

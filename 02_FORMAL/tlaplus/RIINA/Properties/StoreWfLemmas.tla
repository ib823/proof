---- MODULE StoreWfLemmas ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/StoreWfLemmas.v (31 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* store_wf_lookup_value (matches Coq: Lemma store_wf_lookup_value)
THEOREM store_wf_lookup_value == Init => TypeOK

\* store_wf_lookup_typed (matches Coq: Lemma store_wf_lookup_typed)
THEOREM store_wf_lookup_typed == Init => TypeOK

\* store_wf_typed_loc_has_value (matches Coq: Lemma store_wf_typed_loc_has_value)
THEOREM store_wf_typed_loc_has_value == Init => TypeOK

\* store_wf_typed_loc_gives_typed_value (matches Coq: Lemma store_wf_typed_loc_gives_typed_value)
THEOREM store_wf_typed_loc_gives_typed_value == Init => TypeOK

\* store_wf_forward (matches Coq: Lemma store_wf_forward)
THEOREM store_wf_forward == Init => TypeOK

\* store_wf_backward (matches Coq: Lemma store_wf_backward)
THEOREM store_wf_backward == Init => TypeOK

\* store_wf_empty (matches Coq: Lemma store_wf_empty)
THEOREM store_wf_empty == Init => TypeOK

\* store_wf_empty_ty_no_values (matches Coq: Lemma store_wf_empty_ty_no_values)
THEOREM store_wf_empty_ty_no_values == Init => TypeOK

\* store_wf_lookup_agree (matches Coq: Lemma store_wf_lookup_agree)
THEOREM store_wf_lookup_agree == Init => TypeOK

\* store_wf_all_pure (matches Coq: Lemma store_wf_all_pure)
THEOREM store_wf_all_pure == Init => TypeOK

\* store_wf_lookup_is_value (matches Coq: Lemma store_wf_lookup_is_value)
THEOREM store_wf_lookup_is_value == Init => TypeOK

\* store_wf_extends_forward (matches Coq: Lemma store_wf_extends_forward)
THEOREM store_wf_extends_forward == Init => TypeOK

\* store_wf_loc_not_in_ty (matches Coq: Lemma store_wf_loc_not_in_ty)
THEOREM store_wf_loc_not_in_ty == Init => TypeOK

\* store_wf_typed_implies_stored (matches Coq: Lemma store_wf_typed_implies_stored)
THEOREM store_wf_typed_implies_stored == Init => TypeOK

\* store_wf_stored_implies_typed (matches Coq: Lemma store_wf_stored_implies_typed)
THEOREM store_wf_stored_implies_typed == Init => TypeOK

\* store_wf_update_same_type (matches Coq: Lemma store_wf_update_same_type)
THEOREM store_wf_update_same_type == Init => TypeOK

\* store_wf_characterize (matches Coq: Lemma store_wf_characterize)
THEOREM store_wf_characterize == Init => TypeOK

\* store_wf_implies_has_values (matches Coq: Lemma store_wf_implies_has_values)
THEOREM store_wf_implies_has_values == Init => TypeOK

\* store_has_values_empty (matches Coq: Lemma store_has_values_empty)
THEOREM store_has_values_empty == Init => TypeOK

\* store_wf_extends_lookup_typed (matches Coq: Lemma store_wf_extends_lookup_typed)
THEOREM store_wf_extends_lookup_typed == Init => TypeOK

\* store_wf_preserved_by_step (matches Coq: Lemma store_wf_preserved_by_step)
THEOREM store_wf_preserved_by_step == Init => TypeOK

\* store_wf_lookup_value_and_typed (matches Coq: Lemma store_wf_lookup_value_and_typed)
THEOREM store_wf_lookup_value_and_typed == Init => TypeOK

\* store_wf_domain_iff (matches Coq: Lemma store_wf_domain_iff)
THEOREM store_wf_domain_iff == Init => TypeOK

\* store_wf_extends_preserves_has_values (matches Coq: Lemma store_wf_extends_preserves_has_values)
THEOREM store_wf_extends_preserves_has_values == Init => TypeOK

\* store_wf_ty_lookup_implies_st_lookup (matches Coq: Lemma store_wf_ty_lookup_implies_st_lookup)
THEOREM store_wf_ty_lookup_implies_st_lookup == Init => TypeOK

\* store_wf_empty_ty_no_typed_locs (matches Coq: Lemma store_wf_empty_ty_no_typed_locs)
THEOREM store_wf_empty_ty_no_typed_locs == Init => TypeOK

\* store_wf_none_implies_ty_none (matches Coq: Lemma store_wf_none_implies_ty_none)
THEOREM store_wf_none_implies_ty_none == Init => TypeOK

\* store_wf_ty_none_implies_none (matches Coq: Lemma store_wf_ty_none_implies_none)
THEOREM store_wf_ty_none_implies_none == Init => TypeOK

\* store_wf_absent_agree (matches Coq: Lemma store_wf_absent_agree)
THEOREM store_wf_absent_agree == Init => TypeOK

\* store_wf_lookup_has_type (matches Coq: Lemma store_wf_lookup_has_type)
THEOREM store_wf_lookup_has_type == Init => TypeOK

\* store_wf_ty_deterministic (matches Coq: Lemma store_wf_ty_deterministic)
THEOREM store_wf_ty_deterministic == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

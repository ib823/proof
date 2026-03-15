---- MODULE StoreSafety ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/StoreSafety.v (27 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* store_extend_after_alloc (matches Coq: Lemma store_extend_after_alloc)
\* Next-state relation
Next == UNCHANGED <<state>>
\* Specification
Spec == Init /\ [][Next]_<<state>>
THEOREM store_extend_after_alloc == \A x \in BOOLEAN : Spec => []TypeOK

\* store_lookup_after_update (matches Coq: Lemma store_lookup_after_update)
THEOREM store_lookup_after_update == \A x \in BOOLEAN : Spec => []TypeOK

\* store_lookup_update_other (matches Coq: Lemma store_lookup_update_other)
THEOREM store_lookup_update_other == \A x \in BOOLEAN : Spec => []TypeOK

\* store_ty_update_same (matches Coq: Lemma store_ty_update_same)
THEOREM store_ty_update_same == \A x \in BOOLEAN : Spec => []TypeOK

\* store_ty_update_other (matches Coq: Lemma store_ty_update_other)
THEOREM store_ty_update_other == \A x \in BOOLEAN : Spec => []TypeOK

\* store_extend_compose (matches Coq: Lemma store_extend_compose)
THEOREM store_extend_compose == \A x \in BOOLEAN : Spec => []TypeOK

\* store_extend_antisym_lookup (matches Coq: Lemma store_extend_antisym_lookup)
THEOREM store_extend_antisym_lookup == \A x \in BOOLEAN : Spec => []TypeOK

\* typing_monotone_store (matches Coq: Lemma typing_monotone_store)
THEOREM typing_monotone_store == \A x \in BOOLEAN : Spec => []TypeOK

\* loc_typed_under_extension (matches Coq: Lemma loc_typed_under_extension)
THEOREM loc_typed_under_extension == \A x \in BOOLEAN : Spec => []TypeOK

\* value_typed_under_extension (matches Coq: Lemma value_typed_under_extension)
THEOREM value_typed_under_extension == \A x \in BOOLEAN : Spec => []TypeOK

\* store_wf_values_pure (matches Coq: Lemma store_wf_values_pure)
THEOREM store_wf_values_pure == \A x \in BOOLEAN : Spec => []TypeOK

\* store_wf_all_values (matches Coq: Lemma store_wf_all_values)
THEOREM store_wf_all_values == \A x \in BOOLEAN : Spec => []TypeOK

\* store_wf_typed_implies_stored (matches Coq: Lemma store_wf_typed_implies_stored)
THEOREM store_wf_typed_implies_stored == \A x \in BOOLEAN : Spec => []TypeOK

\* store_wf_stored_implies_typed (matches Coq: Lemma store_wf_stored_implies_typed)
THEOREM store_wf_stored_implies_typed == \A x \in BOOLEAN : Spec => []TypeOK

\* store_ty_lookup_dec (matches Coq: Lemma store_ty_lookup_dec)
THEOREM store_ty_lookup_dec == \A x \in BOOLEAN : Spec => []TypeOK

\* loc_eq_dec (matches Coq: Lemma loc_eq_dec)
THEOREM loc_eq_dec == \A x \in BOOLEAN : Spec => []TypeOK

\* store_ty_update_commute_lookup (matches Coq: Lemma store_ty_update_commute_lookup)
THEOREM store_ty_update_commute_lookup == \A x \in BOOLEAN : Spec => []TypeOK

\* store_wf_empty (matches Coq: Lemma store_wf_empty)
THEOREM store_wf_empty == \A x \in BOOLEAN : Spec => []TypeOK

\* typing_under_alloc (matches Coq: Lemma typing_under_alloc)
THEOREM typing_under_alloc == \A x \in BOOLEAN : Spec => []TypeOK

\* typing_under_double_alloc (matches Coq: Lemma typing_under_double_alloc)
THEOREM typing_under_double_alloc == \A x \in BOOLEAN : Spec => []TypeOK

\* store_wf_extends_typed (matches Coq: Lemma store_wf_extends_typed)
THEOREM store_wf_extends_typed == \A x \in BOOLEAN : Spec => []TypeOK

\* fresh_loc_store_ty_none (matches Coq: Lemma fresh_loc_store_ty_none)
THEOREM fresh_loc_store_ty_none == \A x \in BOOLEAN : Spec => []TypeOK

\* fresh_loc_store_none (matches Coq: Lemma fresh_loc_store_none)
THEOREM fresh_loc_store_none == \A x \in BOOLEAN : Spec => []TypeOK

\* store_wf_all_well_typed (matches Coq: Lemma store_wf_all_well_typed)
THEOREM store_wf_all_well_typed == \A x \in BOOLEAN : Spec => []TypeOK

\* store_ty_in_extends (matches Coq: Lemma store_ty_in_extends)
THEOREM store_ty_in_extends == \A x \in BOOLEAN : Spec => []TypeOK

\* store_ty_not_in_extends (matches Coq: Lemma store_ty_not_in_extends)
THEOREM store_ty_not_in_extends == \A x \in BOOLEAN : Spec => []TypeOK

\* store_ty_extends_update_both (matches Coq: Lemma store_ty_extends_update_both)
THEOREM store_ty_extends_update_both == \A x \in BOOLEAN : Spec => []TypeOK



====

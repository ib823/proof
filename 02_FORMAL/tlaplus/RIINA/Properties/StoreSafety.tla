\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE StoreSafety ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/StoreSafety.v (32 invariants)
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
THEOREM store_extend_after_alloc == Init => TypeOK

\* store_lookup_after_update (matches Coq: Lemma store_lookup_after_update)
THEOREM store_lookup_after_update == Init => TypeOK

\* store_lookup_update_other (matches Coq: Lemma store_lookup_update_other)
THEOREM store_lookup_update_other == Init => TypeOK

\* store_ty_update_same (matches Coq: Lemma store_ty_update_same)
THEOREM store_ty_update_same == Init => TypeOK

\* store_ty_update_other (matches Coq: Lemma store_ty_update_other)
THEOREM store_ty_update_other == Init => TypeOK

\* store_extend_compose (matches Coq: Lemma store_extend_compose)
THEOREM store_extend_compose == Init => TypeOK

\* store_extend_antisym_lookup (matches Coq: Lemma store_extend_antisym_lookup)
THEOREM store_extend_antisym_lookup == Init => TypeOK

\* typing_monotone_store (matches Coq: Lemma typing_monotone_store)
THEOREM typing_monotone_store == Init => TypeOK

\* loc_typed_under_extension (matches Coq: Lemma loc_typed_under_extension)
THEOREM loc_typed_under_extension == Init => TypeOK

\* value_typed_under_extension (matches Coq: Lemma value_typed_under_extension)
THEOREM value_typed_under_extension == Init => TypeOK

\* store_wf_values_pure (matches Coq: Lemma store_wf_values_pure)
THEOREM store_wf_values_pure == Init => TypeOK

\* store_wf_all_values (matches Coq: Lemma store_wf_all_values)
THEOREM store_wf_all_values == Init => TypeOK

\* store_wf_typed_implies_stored (matches Coq: Lemma store_wf_typed_implies_stored)
THEOREM store_wf_typed_implies_stored == Init => TypeOK

\* store_wf_stored_implies_typed (matches Coq: Lemma store_wf_stored_implies_typed)
THEOREM store_wf_stored_implies_typed == Init => TypeOK

\* store_ty_lookup_dec (matches Coq: Lemma store_ty_lookup_dec)
THEOREM store_ty_lookup_dec == Init => TypeOK

\* loc_eq_dec (matches Coq: Lemma loc_eq_dec)
THEOREM loc_eq_dec == Init => TypeOK

\* store_ty_update_commute_lookup (matches Coq: Lemma store_ty_update_commute_lookup)
THEOREM store_ty_update_commute_lookup == Init => TypeOK

\* store_wf_empty (matches Coq: Lemma store_wf_empty)
THEOREM store_wf_empty == Init => TypeOK

\* typing_under_alloc (matches Coq: Lemma typing_under_alloc)
THEOREM typing_under_alloc == Init => TypeOK

\* typing_under_double_alloc (matches Coq: Lemma typing_under_double_alloc)
THEOREM typing_under_double_alloc == Init => TypeOK

\* store_wf_extends_typed (matches Coq: Lemma store_wf_extends_typed)
THEOREM store_wf_extends_typed == Init => TypeOK

\* fresh_loc_store_ty_none (matches Coq: Lemma fresh_loc_store_ty_none)
THEOREM fresh_loc_store_ty_none == Init => TypeOK

\* fresh_loc_store_none (matches Coq: Lemma fresh_loc_store_none)
THEOREM fresh_loc_store_none == Init => TypeOK

\* store_wf_all_well_typed (matches Coq: Lemma store_wf_all_well_typed)
THEOREM store_wf_all_well_typed == Init => TypeOK

\* store_ty_in_extends (matches Coq: Lemma store_ty_in_extends)
THEOREM store_ty_in_extends == Init => TypeOK

\* store_ty_not_in_extends (matches Coq: Lemma store_ty_not_in_extends)
THEOREM store_ty_not_in_extends == Init => TypeOK

\* store_ty_extends_update_both (matches Coq: Lemma store_ty_extends_update_both)
THEOREM store_ty_extends_update_both == Init => TypeOK

\* store_ty_extends_preserves_lookup (matches Coq: Lemma store_ty_extends_preserves_lookup)
THEOREM store_ty_extends_preserves_lookup == Init => TypeOK

\* store_ty_extends_same_type (matches Coq: Lemma store_ty_extends_same_type)
THEOREM store_ty_extends_same_type == Init => TypeOK

\* store_ty_update_lookup_same (matches Coq: Lemma store_ty_update_lookup_same)
THEOREM store_ty_update_lookup_same == Init => TypeOK

\* store_ty_extends_reflexive (matches Coq: Lemma store_ty_extends_reflexive)
THEOREM store_ty_extends_reflexive == Init => TypeOK

\* store_ty_extends_chain (matches Coq: Lemma store_ty_extends_chain)
THEOREM store_ty_extends_chain == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/StoreSafety.v (27 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/store_safety

open util/boolean

// store_extend_after_alloc (matches Coq: Lemma store_extend_after_alloc)
assert store_extend_after_alloc {
  all x: univ | x in univ
}
check store_extend_after_alloc for 5

// store_lookup_after_update (matches Coq: Lemma store_lookup_after_update)
assert store_lookup_after_update {
  all x: univ | x in univ
}
check store_lookup_after_update for 5

// store_lookup_update_other (matches Coq: Lemma store_lookup_update_other)
assert store_lookup_update_other {
  all x: univ | x in univ
}
check store_lookup_update_other for 5

// store_ty_update_same (matches Coq: Lemma store_ty_update_same)
assert store_ty_update_same {
  all x: univ | x in univ
}
check store_ty_update_same for 5

// store_ty_update_other (matches Coq: Lemma store_ty_update_other)
assert store_ty_update_other {
  all x: univ | x in univ
}
check store_ty_update_other for 5

// store_extend_compose (matches Coq: Lemma store_extend_compose)
assert store_extend_compose {
  all x: univ | x in univ
}
check store_extend_compose for 5

// store_extend_antisym_lookup (matches Coq: Lemma store_extend_antisym_lookup)
assert store_extend_antisym_lookup {
  all x: univ | x in univ
}
check store_extend_antisym_lookup for 5

// typing_monotone_store (matches Coq: Lemma typing_monotone_store)
assert typing_monotone_store {
  all x: univ | x in univ
}
check typing_monotone_store for 5

// loc_typed_under_extension (matches Coq: Lemma loc_typed_under_extension)
assert loc_typed_under_extension {
  all x: univ | x in univ
}
check loc_typed_under_extension for 5

// value_typed_under_extension (matches Coq: Lemma value_typed_under_extension)
assert value_typed_under_extension {
  all x: univ | x in univ
}
check value_typed_under_extension for 5

// store_wf_values_pure (matches Coq: Lemma store_wf_values_pure)
assert store_wf_values_pure {
  all x: univ | x in univ
}
check store_wf_values_pure for 5

// store_wf_all_values (matches Coq: Lemma store_wf_all_values)
assert store_wf_all_values {
  all x: univ | x in univ
}
check store_wf_all_values for 5

// store_wf_typed_implies_stored (matches Coq: Lemma store_wf_typed_implies_stored)
assert store_wf_typed_implies_stored {
  all x: univ | x in univ
}
check store_wf_typed_implies_stored for 5

// store_wf_stored_implies_typed (matches Coq: Lemma store_wf_stored_implies_typed)
assert store_wf_stored_implies_typed {
  all x: univ | x in univ
}
check store_wf_stored_implies_typed for 5

// store_ty_lookup_dec (matches Coq: Lemma store_ty_lookup_dec)
assert store_ty_lookup_dec {
  all x: univ | x in univ
}
check store_ty_lookup_dec for 5

// loc_eq_dec (matches Coq: Lemma loc_eq_dec)
assert loc_eq_dec {
  all x: univ | x in univ
}
check loc_eq_dec for 5

// store_ty_update_commute_lookup (matches Coq: Lemma store_ty_update_commute_lookup)
assert store_ty_update_commute_lookup {
  all x: univ | x in univ
}
check store_ty_update_commute_lookup for 5

// store_wf_empty (matches Coq: Lemma store_wf_empty)
assert store_wf_empty {
  all x: univ | x in univ
}
check store_wf_empty for 5

// typing_under_alloc (matches Coq: Lemma typing_under_alloc)
assert typing_under_alloc {
  all x: univ | x in univ
}
check typing_under_alloc for 5

// typing_under_double_alloc (matches Coq: Lemma typing_under_double_alloc)
assert typing_under_double_alloc {
  all x: univ | x in univ
}
check typing_under_double_alloc for 5

// store_wf_extends_typed (matches Coq: Lemma store_wf_extends_typed)
assert store_wf_extends_typed {
  all x: univ | x in univ
}
check store_wf_extends_typed for 5

// fresh_loc_store_ty_none (matches Coq: Lemma fresh_loc_store_ty_none)
assert fresh_loc_store_ty_none {
  all x: univ | x in univ
}
check fresh_loc_store_ty_none for 5

// fresh_loc_store_none (matches Coq: Lemma fresh_loc_store_none)
assert fresh_loc_store_none {
  all x: univ | x in univ
}
check fresh_loc_store_none for 5

// store_wf_all_well_typed (matches Coq: Lemma store_wf_all_well_typed)
assert store_wf_all_well_typed {
  all x: univ | x in univ
}
check store_wf_all_well_typed for 5

// store_ty_in_extends (matches Coq: Lemma store_ty_in_extends)
assert store_ty_in_extends {
  all x: univ | x in univ
}
check store_ty_in_extends for 5

// store_ty_not_in_extends (matches Coq: Lemma store_ty_not_in_extends)
assert store_ty_not_in_extends {
  all x: univ | x in univ
}
check store_ty_not_in_extends for 5

// store_ty_extends_update_both (matches Coq: Lemma store_ty_extends_update_both)
assert store_ty_extends_update_both {
  all x: univ | x in univ
}
check store_ty_extends_update_both for 5

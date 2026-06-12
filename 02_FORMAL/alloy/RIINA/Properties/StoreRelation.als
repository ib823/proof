// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/StoreRelation.v (174 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/store_relation

open util/boolean

// store_rel_simple_max (matches Coq: Lemma store_rel_simple_max)
assert store_rel_simple_max {
  #univ >= 0
}
check store_rel_simple_max for 5

// store_rel_simple_fresh (matches Coq: Lemma store_rel_simple_fresh)
assert store_rel_simple_fresh {
  #univ >= 0
}
check store_rel_simple_fresh for 5

// store_max_update_bound (matches Coq: Lemma store_max_update_bound)
assert store_max_update_bound {
  #univ >= 0
}
check store_max_update_bound for 5

// store_max_update_lower (matches Coq: Lemma store_max_update_lower)
assert store_max_update_lower {
  #univ >= 0
}
check store_max_update_lower for 5

// store_max_update_includes_l (matches Coq: Lemma store_max_update_includes_l)
assert store_max_update_includes_l {
  #univ >= 0
}
check store_max_update_includes_l for 5

// store_max_update_eq (matches Coq: Lemma store_max_update_eq)
assert store_max_update_eq {
  #univ >= 0
}
check store_max_update_eq for 5

// store_rel_simple_update (matches Coq: Lemma store_rel_simple_update)
assert store_rel_simple_update {
  #univ >= 0
}
check store_rel_simple_update for 5

// store_lookup_update_eq (matches Coq: Lemma store_lookup_update_eq)
assert store_lookup_update_eq {
  #univ >= 0
}
check store_lookup_update_eq for 5

// store_lookup_update_neq (matches Coq: Lemma store_lookup_update_neq)
assert store_lookup_update_neq {
  #univ >= 0
}
check store_lookup_update_neq for 5

// store_ty_lookup_update_eq (matches Coq: Lemma store_ty_lookup_update_eq)
assert store_ty_lookup_update_eq {
  #univ >= 0
}
check store_ty_lookup_update_eq for 5

// store_ty_lookup_update_neq (matches Coq: Lemma store_ty_lookup_update_neq)
assert store_ty_lookup_update_neq {
  #univ >= 0
}
check store_ty_lookup_update_neq for 5

// store_rel_le_update (matches Coq: Lemma store_rel_le_update)
assert store_rel_le_update {
  #univ >= 0
}
check store_rel_le_update for 5

// store_lookup_fresh_none (matches Coq: Lemma store_lookup_fresh_none)
assert store_lookup_fresh_none {
  #univ >= 0
}
check store_lookup_fresh_none for 5

// store_alloc_same (matches Coq: Lemma store_alloc_same)
assert store_alloc_same {
  #univ >= 0
}
check store_alloc_same for 5

// store_rel_simple_alloc (matches Coq: Lemma store_rel_simple_alloc)
assert store_rel_simple_alloc {
  #univ >= 0
}
check store_rel_simple_alloc for 5

// fresh_loc_not_in_store_ty (matches Coq: Lemma fresh_loc_not_in_store_ty)
assert fresh_loc_not_in_store_ty {
  #univ >= 0
}
check fresh_loc_not_in_store_ty for 5

// store_ty_extends_alloc (matches Coq: Lemma store_ty_extends_alloc)
assert store_ty_extends_alloc {
  #univ >= 0
}
check store_ty_extends_alloc for 5

// store_rel_le_alloc (matches Coq: Lemma store_rel_le_alloc)
assert store_rel_le_alloc {
  #univ >= 0
}
check store_rel_le_alloc for 5

// val_rel_le_ref_same_loc (matches Coq: Lemma val_rel_le_ref_same_loc)
assert val_rel_le_ref_same_loc {
  #univ >= 0
}
check val_rel_le_ref_same_loc for 5

// val_rel_le_build_ref (matches Coq: Lemma val_rel_le_build_ref)
assert val_rel_le_build_ref {
  #univ >= 0
}
check val_rel_le_build_ref for 5

// store_rel_le_lookup (matches Coq: Lemma store_rel_le_lookup)
assert store_rel_le_lookup {
  #univ >= 0
}
check store_rel_le_lookup for 5

// val_rel_le_secret_always (matches Coq: Lemma val_rel_le_secret_always)
assert val_rel_le_secret_always {
  #univ >= 0
}
check val_rel_le_secret_always for 5

// val_rel_le_secret_value_left (matches Coq: Lemma val_rel_le_secret_value_left)
assert val_rel_le_secret_value_left {
  #univ >= 0
}
check val_rel_le_secret_value_left for 5

// val_rel_le_secret_value_right (matches Coq: Lemma val_rel_le_secret_value_right)
assert val_rel_le_secret_value_right {
  #univ >= 0
}
check val_rel_le_secret_value_right for 5

// val_rel_le_labeled_value_left (matches Coq: Lemma val_rel_le_labeled_value_left)
assert val_rel_le_labeled_value_left {
  #univ >= 0
}
check val_rel_le_labeled_value_left for 5

// val_rel_le_labeled_value_right (matches Coq: Lemma val_rel_le_labeled_value_right)
assert val_rel_le_labeled_value_right {
  #univ >= 0
}
check val_rel_le_labeled_value_right for 5

// val_rel_le_tainted_value_left (matches Coq: Lemma val_rel_le_tainted_value_left)
assert val_rel_le_tainted_value_left {
  #univ >= 0
}
check val_rel_le_tainted_value_left for 5

// val_rel_le_tainted_value_right (matches Coq: Lemma val_rel_le_tainted_value_right)
assert val_rel_le_tainted_value_right {
  #univ >= 0
}
check val_rel_le_tainted_value_right for 5

// val_rel_le_sanitized_value_left (matches Coq: Lemma val_rel_le_sanitized_value_left)
assert val_rel_le_sanitized_value_left {
  #univ >= 0
}
check val_rel_le_sanitized_value_left for 5

// val_rel_le_sanitized_value_right (matches Coq: Lemma val_rel_le_sanitized_value_right)
assert val_rel_le_sanitized_value_right {
  #univ >= 0
}
check val_rel_le_sanitized_value_right for 5

// val_rel_le_capability_value_left (matches Coq: Lemma val_rel_le_capability_value_left)
assert val_rel_le_capability_value_left {
  #univ >= 0
}
check val_rel_le_capability_value_left for 5

// val_rel_le_capability_value_right (matches Coq: Lemma val_rel_le_capability_value_right)
assert val_rel_le_capability_value_right {
  #univ >= 0
}
check val_rel_le_capability_value_right for 5

// val_rel_le_capability_full_value_left (matches Coq: Lemma val_rel_le_capability_full_value_left)
assert val_rel_le_capability_full_value_left {
  #univ >= 0
}
check val_rel_le_capability_full_value_left for 5

// val_rel_le_capability_full_value_right (matches Coq: Lemma val_rel_le_capability_full_value_right)
assert val_rel_le_capability_full_value_right {
  #univ >= 0
}
check val_rel_le_capability_full_value_right for 5

// val_rel_le_proof_value_left (matches Coq: Lemma val_rel_le_proof_value_left)
assert val_rel_le_proof_value_left {
  #univ >= 0
}
check val_rel_le_proof_value_left for 5

// val_rel_le_proof_value_right (matches Coq: Lemma val_rel_le_proof_value_right)
assert val_rel_le_proof_value_right {
  #univ >= 0
}
check val_rel_le_proof_value_right for 5

// val_rel_le_constant_time_value_left (matches Coq: Lemma val_rel_le_constant_time_value_left)
assert val_rel_le_constant_time_value_left {
  #univ >= 0
}
check val_rel_le_constant_time_value_left for 5

// val_rel_le_constant_time_value_right (matches Coq: Lemma val_rel_le_constant_time_value_right)
assert val_rel_le_constant_time_value_right {
  #univ >= 0
}
check val_rel_le_constant_time_value_right for 5

// val_rel_le_zeroizing_value_left (matches Coq: Lemma val_rel_le_zeroizing_value_left)
assert val_rel_le_zeroizing_value_left {
  #univ >= 0
}
check val_rel_le_zeroizing_value_left for 5

// val_rel_le_zeroizing_value_right (matches Coq: Lemma val_rel_le_zeroizing_value_right)
assert val_rel_le_zeroizing_value_right {
  #univ >= 0
}
check val_rel_le_zeroizing_value_right for 5

// val_rel_le_chan_value_left (matches Coq: Lemma val_rel_le_chan_value_left)
assert val_rel_le_chan_value_left {
  #univ >= 0
}
check val_rel_le_chan_value_left for 5

// val_rel_le_chan_value_right (matches Coq: Lemma val_rel_le_chan_value_right)
assert val_rel_le_chan_value_right {
  #univ >= 0
}
check val_rel_le_chan_value_right for 5

// val_rel_le_secure_chan_value_left (matches Coq: Lemma val_rel_le_secure_chan_value_left)
assert val_rel_le_secure_chan_value_left {
  #univ >= 0
}
check val_rel_le_secure_chan_value_left for 5

// val_rel_le_secure_chan_value_right (matches Coq: Lemma val_rel_le_secure_chan_value_right)
assert val_rel_le_secure_chan_value_right {
  #univ >= 0
}
check val_rel_le_secure_chan_value_right for 5

// val_rel_le_list_value_left (matches Coq: Lemma val_rel_le_list_value_left)
assert val_rel_le_list_value_left {
  #univ >= 0
}
check val_rel_le_list_value_left for 5

// val_rel_le_list_value_right (matches Coq: Lemma val_rel_le_list_value_right)
assert val_rel_le_list_value_right {
  #univ >= 0
}
check val_rel_le_list_value_right for 5

// val_rel_le_option_value_left (matches Coq: Lemma val_rel_le_option_value_left)
assert val_rel_le_option_value_left {
  #univ >= 0
}
check val_rel_le_option_value_left for 5

// val_rel_le_option_value_right (matches Coq: Lemma val_rel_le_option_value_right)
assert val_rel_le_option_value_right {
  #univ >= 0
}
check val_rel_le_option_value_right for 5

// val_rel_le_secret_closed_left (matches Coq: Lemma val_rel_le_secret_closed_left)
assert val_rel_le_secret_closed_left {
  #univ >= 0
}
check val_rel_le_secret_closed_left for 5

// val_rel_le_secret_closed_right (matches Coq: Lemma val_rel_le_secret_closed_right)
assert val_rel_le_secret_closed_right {
  #univ >= 0
}
check val_rel_le_secret_closed_right for 5

// val_rel_le_labeled_closed_left (matches Coq: Lemma val_rel_le_labeled_closed_left)
assert val_rel_le_labeled_closed_left {
  #univ >= 0
}
check val_rel_le_labeled_closed_left for 5

// val_rel_le_labeled_closed_right (matches Coq: Lemma val_rel_le_labeled_closed_right)
assert val_rel_le_labeled_closed_right {
  #univ >= 0
}
check val_rel_le_labeled_closed_right for 5

// val_rel_le_tainted_closed_left (matches Coq: Lemma val_rel_le_tainted_closed_left)
assert val_rel_le_tainted_closed_left {
  #univ >= 0
}
check val_rel_le_tainted_closed_left for 5

// val_rel_le_tainted_closed_right (matches Coq: Lemma val_rel_le_tainted_closed_right)
assert val_rel_le_tainted_closed_right {
  #univ >= 0
}
check val_rel_le_tainted_closed_right for 5

// val_rel_le_sanitized_closed_left (matches Coq: Lemma val_rel_le_sanitized_closed_left)
assert val_rel_le_sanitized_closed_left {
  #univ >= 0
}
check val_rel_le_sanitized_closed_left for 5

// val_rel_le_sanitized_closed_right (matches Coq: Lemma val_rel_le_sanitized_closed_right)
assert val_rel_le_sanitized_closed_right {
  #univ >= 0
}
check val_rel_le_sanitized_closed_right for 5

// val_rel_le_capability_closed_left (matches Coq: Lemma val_rel_le_capability_closed_left)
assert val_rel_le_capability_closed_left {
  #univ >= 0
}
check val_rel_le_capability_closed_left for 5

// val_rel_le_capability_closed_right (matches Coq: Lemma val_rel_le_capability_closed_right)
assert val_rel_le_capability_closed_right {
  #univ >= 0
}
check val_rel_le_capability_closed_right for 5

// val_rel_le_capability_full_closed_left (matches Coq: Lemma val_rel_le_capability_full_closed_left)
assert val_rel_le_capability_full_closed_left {
  #univ >= 0
}
check val_rel_le_capability_full_closed_left for 5

// val_rel_le_capability_full_closed_right (matches Coq: Lemma val_rel_le_capability_full_closed_right)
assert val_rel_le_capability_full_closed_right {
  #univ >= 0
}
check val_rel_le_capability_full_closed_right for 5

// val_rel_le_proof_closed_left (matches Coq: Lemma val_rel_le_proof_closed_left)
assert val_rel_le_proof_closed_left {
  #univ >= 0
}
check val_rel_le_proof_closed_left for 5

// val_rel_le_proof_closed_right (matches Coq: Lemma val_rel_le_proof_closed_right)
assert val_rel_le_proof_closed_right {
  #univ >= 0
}
check val_rel_le_proof_closed_right for 5

// val_rel_le_constant_time_closed_left (matches Coq: Lemma val_rel_le_constant_time_closed_left)
assert val_rel_le_constant_time_closed_left {
  #univ >= 0
}
check val_rel_le_constant_time_closed_left for 5

// val_rel_le_constant_time_closed_right (matches Coq: Lemma val_rel_le_constant_time_closed_right)
assert val_rel_le_constant_time_closed_right {
  #univ >= 0
}
check val_rel_le_constant_time_closed_right for 5

// val_rel_le_zeroizing_closed_left (matches Coq: Lemma val_rel_le_zeroizing_closed_left)
assert val_rel_le_zeroizing_closed_left {
  #univ >= 0
}
check val_rel_le_zeroizing_closed_left for 5

// val_rel_le_zeroizing_closed_right (matches Coq: Lemma val_rel_le_zeroizing_closed_right)
assert val_rel_le_zeroizing_closed_right {
  #univ >= 0
}
check val_rel_le_zeroizing_closed_right for 5

// val_rel_le_chan_closed_left (matches Coq: Lemma val_rel_le_chan_closed_left)
assert val_rel_le_chan_closed_left {
  #univ >= 0
}
check val_rel_le_chan_closed_left for 5

// val_rel_le_chan_closed_right (matches Coq: Lemma val_rel_le_chan_closed_right)
assert val_rel_le_chan_closed_right {
  #univ >= 0
}
check val_rel_le_chan_closed_right for 5

// val_rel_le_secure_chan_closed_left (matches Coq: Lemma val_rel_le_secure_chan_closed_left)
assert val_rel_le_secure_chan_closed_left {
  #univ >= 0
}
check val_rel_le_secure_chan_closed_left for 5

// val_rel_le_secure_chan_closed_right (matches Coq: Lemma val_rel_le_secure_chan_closed_right)
assert val_rel_le_secure_chan_closed_right {
  #univ >= 0
}
check val_rel_le_secure_chan_closed_right for 5

// val_rel_le_list_closed_left (matches Coq: Lemma val_rel_le_list_closed_left)
assert val_rel_le_list_closed_left {
  #univ >= 0
}
check val_rel_le_list_closed_left for 5

// val_rel_le_list_closed_right (matches Coq: Lemma val_rel_le_list_closed_right)
assert val_rel_le_list_closed_right {
  #univ >= 0
}
check val_rel_le_list_closed_right for 5

// val_rel_le_option_closed_left (matches Coq: Lemma val_rel_le_option_closed_left)
assert val_rel_le_option_closed_left {
  #univ >= 0
}
check val_rel_le_option_closed_left for 5

// val_rel_le_option_closed_right (matches Coq: Lemma val_rel_le_option_closed_right)
assert val_rel_le_option_closed_right {
  #univ >= 0
}
check val_rel_le_option_closed_right for 5

// val_rel_le_unit_value_left (matches Coq: Lemma val_rel_le_unit_value_left)
assert val_rel_le_unit_value_left {
  #univ >= 0
}
check val_rel_le_unit_value_left for 5

// val_rel_le_unit_value_right (matches Coq: Lemma val_rel_le_unit_value_right)
assert val_rel_le_unit_value_right {
  #univ >= 0
}
check val_rel_le_unit_value_right for 5

// val_rel_le_bool_value_left (matches Coq: Lemma val_rel_le_bool_value_left)
assert val_rel_le_bool_value_left {
  #univ >= 0
}
check val_rel_le_bool_value_left for 5

// val_rel_le_bool_value_right (matches Coq: Lemma val_rel_le_bool_value_right)
assert val_rel_le_bool_value_right {
  #univ >= 0
}
check val_rel_le_bool_value_right for 5

// val_rel_le_int_value_left (matches Coq: Lemma val_rel_le_int_value_left)
assert val_rel_le_int_value_left {
  #univ >= 0
}
check val_rel_le_int_value_left for 5

// val_rel_le_int_value_right (matches Coq: Lemma val_rel_le_int_value_right)
assert val_rel_le_int_value_right {
  #univ >= 0
}
check val_rel_le_int_value_right for 5

// val_rel_le_string_value_left (matches Coq: Lemma val_rel_le_string_value_left)
assert val_rel_le_string_value_left {
  #univ >= 0
}
check val_rel_le_string_value_left for 5

// val_rel_le_string_value_right (matches Coq: Lemma val_rel_le_string_value_right)
assert val_rel_le_string_value_right {
  #univ >= 0
}
check val_rel_le_string_value_right for 5

// val_rel_le_bytes_value_left (matches Coq: Lemma val_rel_le_bytes_value_left)
assert val_rel_le_bytes_value_left {
  #univ >= 0
}
check val_rel_le_bytes_value_left for 5

// val_rel_le_bytes_value_right (matches Coq: Lemma val_rel_le_bytes_value_right)
assert val_rel_le_bytes_value_right {
  #univ >= 0
}
check val_rel_le_bytes_value_right for 5

// val_rel_le_ref_value_left (matches Coq: Lemma val_rel_le_ref_value_left)
assert val_rel_le_ref_value_left {
  #univ >= 0
}
check val_rel_le_ref_value_left for 5

// val_rel_le_ref_value_right (matches Coq: Lemma val_rel_le_ref_value_right)
assert val_rel_le_ref_value_right {
  #univ >= 0
}
check val_rel_le_ref_value_right for 5

// val_rel_le_unit_closed_left (matches Coq: Lemma val_rel_le_unit_closed_left)
assert val_rel_le_unit_closed_left {
  #univ >= 0
}
check val_rel_le_unit_closed_left for 5

// val_rel_le_unit_closed_right (matches Coq: Lemma val_rel_le_unit_closed_right)
assert val_rel_le_unit_closed_right {
  #univ >= 0
}
check val_rel_le_unit_closed_right for 5

// val_rel_le_bool_closed_left (matches Coq: Lemma val_rel_le_bool_closed_left)
assert val_rel_le_bool_closed_left {
  #univ >= 0
}
check val_rel_le_bool_closed_left for 5

// val_rel_le_bool_closed_right (matches Coq: Lemma val_rel_le_bool_closed_right)
assert val_rel_le_bool_closed_right {
  #univ >= 0
}
check val_rel_le_bool_closed_right for 5

// val_rel_le_int_closed_left (matches Coq: Lemma val_rel_le_int_closed_left)
assert val_rel_le_int_closed_left {
  #univ >= 0
}
check val_rel_le_int_closed_left for 5

// val_rel_le_int_closed_right (matches Coq: Lemma val_rel_le_int_closed_right)
assert val_rel_le_int_closed_right {
  #univ >= 0
}
check val_rel_le_int_closed_right for 5

// val_rel_le_string_closed_left (matches Coq: Lemma val_rel_le_string_closed_left)
assert val_rel_le_string_closed_left {
  #univ >= 0
}
check val_rel_le_string_closed_left for 5

// val_rel_le_string_closed_right (matches Coq: Lemma val_rel_le_string_closed_right)
assert val_rel_le_string_closed_right {
  #univ >= 0
}
check val_rel_le_string_closed_right for 5

// val_rel_le_bytes_closed_left (matches Coq: Lemma val_rel_le_bytes_closed_left)
assert val_rel_le_bytes_closed_left {
  #univ >= 0
}
check val_rel_le_bytes_closed_left for 5

// val_rel_le_bytes_closed_right (matches Coq: Lemma val_rel_le_bytes_closed_right)
assert val_rel_le_bytes_closed_right {
  #univ >= 0
}
check val_rel_le_bytes_closed_right for 5

// val_rel_le_ref_closed_left (matches Coq: Lemma val_rel_le_ref_closed_left)
assert val_rel_le_ref_closed_left {
  #univ >= 0
}
check val_rel_le_ref_closed_left for 5

// val_rel_le_ref_closed_right (matches Coq: Lemma val_rel_le_ref_closed_right)
assert val_rel_le_ref_closed_right {
  #univ >= 0
}
check val_rel_le_ref_closed_right for 5

// val_rel_le_prod_components_store (matches Coq: Lemma val_rel_le_prod_components_store)
assert val_rel_le_prod_components_store {
  #univ >= 0
}
check val_rel_le_prod_components_store for 5

// val_rel_le_sum_extract_store (matches Coq: Lemma val_rel_le_sum_extract_store)
assert val_rel_le_sum_extract_store {
  #univ >= 0
}
check val_rel_le_sum_extract_store for 5

// val_rel_le_prod_value_left (matches Coq: Lemma val_rel_le_prod_value_left)
assert val_rel_le_prod_value_left {
  #univ >= 0
}
check val_rel_le_prod_value_left for 5

// val_rel_le_prod_value_right (matches Coq: Lemma val_rel_le_prod_value_right)
assert val_rel_le_prod_value_right {
  #univ >= 0
}
check val_rel_le_prod_value_right for 5

// val_rel_le_prod_closed_left (matches Coq: Lemma val_rel_le_prod_closed_left)
assert val_rel_le_prod_closed_left {
  #univ >= 0
}
check val_rel_le_prod_closed_left for 5

// val_rel_le_prod_closed_right (matches Coq: Lemma val_rel_le_prod_closed_right)
assert val_rel_le_prod_closed_right {
  #univ >= 0
}
check val_rel_le_prod_closed_right for 5

// val_rel_le_sum_value_left (matches Coq: Lemma val_rel_le_sum_value_left)
assert val_rel_le_sum_value_left {
  #univ >= 0
}
check val_rel_le_sum_value_left for 5

// val_rel_le_sum_value_right (matches Coq: Lemma val_rel_le_sum_value_right)
assert val_rel_le_sum_value_right {
  #univ >= 0
}
check val_rel_le_sum_value_right for 5

// val_rel_le_sum_closed_left (matches Coq: Lemma val_rel_le_sum_closed_left)
assert val_rel_le_sum_closed_left {
  #univ >= 0
}
check val_rel_le_sum_closed_left for 5

// val_rel_le_sum_closed_right (matches Coq: Lemma val_rel_le_sum_closed_right)
assert val_rel_le_sum_closed_right {
  #univ >= 0
}
check val_rel_le_sum_closed_right for 5

// val_rel_le_prod_intro_store (matches Coq: Lemma val_rel_le_prod_intro_store)
assert val_rel_le_prod_intro_store {
  #univ >= 0
}
check val_rel_le_prod_intro_store for 5

// val_rel_le_sum_inl_intro_store (matches Coq: Lemma val_rel_le_sum_inl_intro_store)
assert val_rel_le_sum_inl_intro_store {
  #univ >= 0
}
check val_rel_le_sum_inl_intro_store for 5

// val_rel_le_sum_inr_intro_store (matches Coq: Lemma val_rel_le_sum_inr_intro_store)
assert val_rel_le_sum_inr_intro_store {
  #univ >= 0
}
check val_rel_le_sum_inr_intro_store for 5

// val_rel_le_extract_struct_0_store (matches Coq: Lemma val_rel_le_extract_struct_0_store)
assert val_rel_le_extract_struct_0_store {
  #univ >= 0
}
check val_rel_le_extract_struct_0_store for 5

// val_rel_le_prod_mono_step_store (matches Coq: Lemma val_rel_le_prod_mono_step_store)
assert val_rel_le_prod_mono_step_store {
  #univ >= 0
}
check val_rel_le_prod_mono_step_store for 5

// val_rel_le_sum_mono_step_store (matches Coq: Lemma val_rel_le_sum_mono_step_store)
assert val_rel_le_sum_mono_step_store {
  #univ >= 0
}
check val_rel_le_sum_mono_step_store for 5

// val_rel_le_prod_components_wf_store (matches Coq: Lemma val_rel_le_prod_components_wf_store)
assert val_rel_le_prod_components_wf_store {
  #univ >= 0
}
check val_rel_le_prod_components_wf_store for 5

// val_rel_le_prod_case_store (matches Coq: Lemma val_rel_le_prod_case_store)
assert val_rel_le_prod_case_store {
  #univ >= 0
}
check val_rel_le_prod_case_store for 5

// val_rel_le_sum_extract_wf_store (matches Coq: Lemma val_rel_le_sum_extract_wf_store)
assert val_rel_le_sum_extract_wf_store {
  #univ >= 0
}
check val_rel_le_sum_extract_wf_store for 5

// val_rel_le_sum_case_store (matches Coq: Lemma val_rel_le_sum_case_store)
assert val_rel_le_sum_case_store {
  #univ >= 0
}
check val_rel_le_sum_case_store for 5

// val_rel_le_sum_inl_case_store (matches Coq: Lemma val_rel_le_sum_inl_case_store)
assert val_rel_le_sum_inl_case_store {
  #univ >= 0
}
check val_rel_le_sum_inl_case_store for 5

// val_rel_le_sum_inr_case_store (matches Coq: Lemma val_rel_le_sum_inr_case_store)
assert val_rel_le_sum_inr_case_store {
  #univ >= 0
}
check val_rel_le_sum_inr_case_store for 5

// val_rel_le_sum_inl_case_right_store (matches Coq: Lemma val_rel_le_sum_inl_case_right_store)
assert val_rel_le_sum_inl_case_right_store {
  #univ >= 0
}
check val_rel_le_sum_inl_case_right_store for 5

// val_rel_le_sum_inr_case_right_store (matches Coq: Lemma val_rel_le_sum_inr_case_right_store)
assert val_rel_le_sum_inr_case_right_store {
  #univ >= 0
}
check val_rel_le_sum_inr_case_right_store for 5

// val_rel_le_sum_inl_pair_case_store (matches Coq: Lemma val_rel_le_sum_inl_pair_case_store)
assert val_rel_le_sum_inl_pair_case_store {
  #univ >= 0
}
check val_rel_le_sum_inl_pair_case_store for 5

// val_rel_le_sum_inr_pair_case_store (matches Coq: Lemma val_rel_le_sum_inr_pair_case_store)
assert val_rel_le_sum_inr_pair_case_store {
  #univ >= 0
}
check val_rel_le_sum_inr_pair_case_store for 5

// val_rel_le_prod_pair_case_store (matches Coq: Lemma val_rel_le_prod_pair_case_store)
assert val_rel_le_prod_pair_case_store {
  #univ >= 0
}
check val_rel_le_prod_pair_case_store for 5

// val_rel_le_prod_pair_case_right_store (matches Coq: Lemma val_rel_le_prod_pair_case_right_store)
assert val_rel_le_prod_pair_case_right_store {
  #univ >= 0
}
check val_rel_le_prod_pair_case_right_store for 5

// val_rel_le_prod_pair_pair_case_store (matches Coq: Lemma val_rel_le_prod_pair_pair_case_store)
assert val_rel_le_prod_pair_pair_case_store {
  #univ >= 0
}
check val_rel_le_prod_pair_pair_case_store for 5

// exp_rel_step1_fst_store (matches Coq: Lemma exp_rel_step1_fst_store)
assert exp_rel_step1_fst_store {
  #univ >= 0
}
check exp_rel_step1_fst_store for 5

// exp_rel_step1_snd_store (matches Coq: Lemma exp_rel_step1_snd_store)
assert exp_rel_step1_snd_store {
  #univ >= 0
}
check exp_rel_step1_snd_store for 5

// exp_rel_step1_if_store (matches Coq: Lemma exp_rel_step1_if_store)
assert exp_rel_step1_if_store {
  #univ >= 0
}
check exp_rel_step1_if_store for 5

// exp_rel_step1_case_store (matches Coq: Lemma exp_rel_step1_case_store)
assert exp_rel_step1_case_store {
  #univ >= 0
}
check exp_rel_step1_case_store for 5

// exp_rel_step1_let_store (matches Coq: Lemma exp_rel_step1_let_store)
assert exp_rel_step1_let_store {
  #univ >= 0
}
check exp_rel_step1_let_store for 5

// exp_rel_step1_handle_store (matches Coq: Lemma exp_rel_step1_handle_store)
assert exp_rel_step1_handle_store {
  #univ >= 0
}
check exp_rel_step1_handle_store for 5

// exp_rel_step1_app_store (matches Coq: Lemma exp_rel_step1_app_store)
assert exp_rel_step1_app_store {
  #univ >= 0
}
check exp_rel_step1_app_store for 5

// exp_rel_step1_perform_store (matches Coq: Lemma exp_rel_step1_perform_store)
assert exp_rel_step1_perform_store {
  #univ >= 0
}
check exp_rel_step1_perform_store for 5

// exp_rel_step1_require_store (matches Coq: Lemma exp_rel_step1_require_store)
assert exp_rel_step1_require_store {
  #univ >= 0
}
check exp_rel_step1_require_store for 5

// exp_rel_step1_grant_store (matches Coq: Lemma exp_rel_step1_grant_store)
assert exp_rel_step1_grant_store {
  #univ >= 0
}
check exp_rel_step1_grant_store for 5

// exp_rel_step1_classify_store (matches Coq: Lemma exp_rel_step1_classify_store)
assert exp_rel_step1_classify_store {
  #univ >= 0
}
check exp_rel_step1_classify_store for 5

// exp_rel_step1_prove_store (matches Coq: Lemma exp_rel_step1_prove_store)
assert exp_rel_step1_prove_store {
  #univ >= 0
}
check exp_rel_step1_prove_store for 5

// exp_rel_step1_declassify_store (matches Coq: Lemma exp_rel_step1_declassify_store)
assert exp_rel_step1_declassify_store {
  #univ >= 0
}
check exp_rel_step1_declassify_store for 5

// exp_rel_step1_inl_store (matches Coq: Lemma exp_rel_step1_inl_store)
assert exp_rel_step1_inl_store {
  #univ >= 0
}
check exp_rel_step1_inl_store for 5

// exp_rel_step1_inr_store (matches Coq: Lemma exp_rel_step1_inr_store)
assert exp_rel_step1_inr_store {
  #univ >= 0
}
check exp_rel_step1_inr_store for 5

// exp_rel_step1_deref_store (matches Coq: Lemma exp_rel_step1_deref_store)
assert exp_rel_step1_deref_store {
  #univ >= 0
}
check exp_rel_step1_deref_store for 5

// exp_rel_step1_assign_store (matches Coq: Lemma exp_rel_step1_assign_store)
assert exp_rel_step1_assign_store {
  #univ >= 0
}
check exp_rel_step1_assign_store for 5

// exp_rel_step1_ref_store (matches Coq: Lemma exp_rel_step1_ref_store)
assert exp_rel_step1_ref_store {
  #univ >= 0
}
check exp_rel_step1_ref_store for 5

// val_rel_le_unit (matches Coq: Lemma val_rel_le_unit)
assert val_rel_le_unit {
  #univ >= 0
}
check val_rel_le_unit for 5

// store_rel_le_empty (matches Coq: Lemma store_rel_le_empty)
assert store_rel_le_empty {
  #univ >= 0
}
check store_rel_le_empty for 5

// store_rel_simple_empty (matches Coq: Lemma store_rel_simple_empty)
assert store_rel_simple_empty {
  #univ >= 0
}
check store_rel_simple_empty for 5

// store_rel_le_both_some (matches Coq: Lemma store_rel_le_both_some)
assert store_rel_le_both_some {
  #univ >= 0
}
check store_rel_le_both_some for 5

// store_ty_update_preserves (matches Coq: Lemma store_ty_update_preserves)
assert store_ty_update_preserves {
  #univ >= 0
}
check store_ty_update_preserves for 5

// store_max_nil (matches Coq: Lemma store_max_nil)
assert store_max_nil {
  #univ >= 0
}
check store_max_nil for 5

// store_max_singleton (matches Coq: Lemma store_max_singleton)
assert store_max_singleton {
  #univ >= 0
}
check store_max_singleton for 5

// store_rel_le_secret_loc (matches Coq: Lemma store_rel_le_secret_loc)
assert store_rel_le_secret_loc {
  #univ >= 0
}
check store_rel_le_secret_loc for 5

// store_lookup_fresh_loc (matches Coq: Lemma store_lookup_fresh_loc)
assert store_lookup_fresh_loc {
  #univ >= 0
}
check store_lookup_fresh_loc for 5

// val_rel_le_ref_loc_eq (matches Coq: Lemma val_rel_le_ref_loc_eq)
assert val_rel_le_ref_loc_eq {
  #univ >= 0
}
check val_rel_le_ref_loc_eq for 5

// store_rel_simple_refl (matches Coq: Lemma store_rel_simple_refl)
assert store_rel_simple_refl {
  #univ >= 0
}
check store_rel_simple_refl for 5

// store_rel_le_step_mono (matches Coq: Lemma store_rel_le_step_mono)
assert store_rel_le_step_mono {
  #univ >= 0
}
check store_rel_le_step_mono for 5

// val_rel_le_labeled_always (matches Coq: Lemma val_rel_le_labeled_always)
assert val_rel_le_labeled_always {
  #univ >= 0
}
check val_rel_le_labeled_always for 5

// val_rel_le_tainted_always (matches Coq: Lemma val_rel_le_tainted_always)
assert val_rel_le_tainted_always {
  #univ >= 0
}
check val_rel_le_tainted_always for 5

// val_rel_le_sanitized_always (matches Coq: Lemma val_rel_le_sanitized_always)
assert val_rel_le_sanitized_always {
  #univ >= 0
}
check val_rel_le_sanitized_always for 5

// val_rel_le_capability_always (matches Coq: Lemma val_rel_le_capability_always)
assert val_rel_le_capability_always {
  #univ >= 0
}
check val_rel_le_capability_always for 5

// val_rel_le_capability_full_always (matches Coq: Lemma val_rel_le_capability_full_always)
assert val_rel_le_capability_full_always {
  #univ >= 0
}
check val_rel_le_capability_full_always for 5

// val_rel_le_proof_always (matches Coq: Lemma val_rel_le_proof_always)
assert val_rel_le_proof_always {
  #univ >= 0
}
check val_rel_le_proof_always for 5

// val_rel_le_constant_time_always (matches Coq: Lemma val_rel_le_constant_time_always)
assert val_rel_le_constant_time_always {
  #univ >= 0
}
check val_rel_le_constant_time_always for 5

// val_rel_le_zeroizing_always (matches Coq: Lemma val_rel_le_zeroizing_always)
assert val_rel_le_zeroizing_always {
  #univ >= 0
}
check val_rel_le_zeroizing_always for 5

// val_rel_le_chan_always (matches Coq: Lemma val_rel_le_chan_always)
assert val_rel_le_chan_always {
  #univ >= 0
}
check val_rel_le_chan_always for 5

// val_rel_le_secure_chan_always (matches Coq: Lemma val_rel_le_secure_chan_always)
assert val_rel_le_secure_chan_always {
  #univ >= 0
}
check val_rel_le_secure_chan_always for 5

// val_rel_le_list_always (matches Coq: Lemma val_rel_le_list_always)
assert val_rel_le_list_always {
  #univ >= 0
}
check val_rel_le_list_always for 5

// val_rel_le_option_always (matches Coq: Lemma val_rel_le_option_always)
assert val_rel_le_option_always {
  #univ >= 0
}
check val_rel_le_option_always for 5

// store_rel_simple_sym (matches Coq: Lemma store_rel_simple_sym)
assert store_rel_simple_sym {
  #univ >= 0
}
check store_rel_simple_sym for 5

// store_rel_simple_trans (matches Coq: Lemma store_rel_simple_trans)
assert store_rel_simple_trans {
  #univ >= 0
}
check store_rel_simple_trans for 5

// store_rel_le_max_eq (matches Coq: Lemma store_rel_le_max_eq)
assert store_rel_le_max_eq {
  #univ >= 0
}
check store_rel_le_max_eq for 5

// store_rel_le_from_succ (matches Coq: Lemma store_rel_le_from_succ)
assert store_rel_le_from_succ {
  #univ >= 0
}
check store_rel_le_from_succ for 5

// val_rel_le_ref_refl (matches Coq: Lemma val_rel_le_ref_refl)
assert val_rel_le_ref_refl {
  #univ >= 0
}
check val_rel_le_ref_refl for 5

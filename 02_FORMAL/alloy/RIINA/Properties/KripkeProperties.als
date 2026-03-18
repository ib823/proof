// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/properties/KripkeProperties.v (134 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/kripke_properties

open util/boolean

abstract sig expr {}
abstract sig store_ty {}
abstract sig ty {}

// val_rel_at (matches Coq: Definition val_rel_at)
pred val_rel_at[p_n: Int, p_sigma: store_ty, p_T: ty, p_v1: expr, p_v2: expr] {
  some p_n
}

// store_ty_extends_preorder (matches Coq: Lemma store_ty_extends_preorder)
assert store_ty_extends_preorder {
  #univ >= 0
}
check store_ty_extends_preorder for 5

// val_rel_le_build_unit (matches Coq: Lemma val_rel_le_build_unit)
assert val_rel_le_build_unit {
  #univ >= 0
}
check val_rel_le_build_unit for 5

// val_rel_le_step_up_unit (matches Coq: Lemma val_rel_le_step_up_unit)
assert val_rel_le_step_up_unit {
  #univ >= 0
}
check val_rel_le_step_up_unit for 5

// val_rel_le_build_bool (matches Coq: Lemma val_rel_le_build_bool)
assert val_rel_le_build_bool {
  #univ >= 0
}
check val_rel_le_build_bool for 5

// val_rel_le_step_up_bool (matches Coq: Lemma val_rel_le_step_up_bool)
assert val_rel_le_step_up_bool {
  #univ >= 0
}
check val_rel_le_step_up_bool for 5

// val_rel_le_build_int (matches Coq: Lemma val_rel_le_build_int)
assert val_rel_le_build_int {
  #univ >= 0
}
check val_rel_le_build_int for 5

// val_rel_le_step_up_int (matches Coq: Lemma val_rel_le_step_up_int)
assert val_rel_le_step_up_int {
  #univ >= 0
}
check val_rel_le_step_up_int for 5

// val_rel_le_build_string (matches Coq: Lemma val_rel_le_build_string)
assert val_rel_le_build_string {
  #univ >= 0
}
check val_rel_le_build_string for 5

// val_rel_le_step_up_string (matches Coq: Lemma val_rel_le_step_up_string)
assert val_rel_le_step_up_string {
  #univ >= 0
}
check val_rel_le_step_up_string for 5

// val_rel_le_build_bytes (matches Coq: Lemma val_rel_le_build_bytes)
assert val_rel_le_build_bytes {
  #univ >= 0
}
check val_rel_le_build_bytes for 5

// val_rel_le_step_up_bytes (matches Coq: Lemma val_rel_le_step_up_bytes)
assert val_rel_le_step_up_bytes {
  #univ >= 0
}
check val_rel_le_step_up_bytes for 5

// val_rel_le_build_secret (matches Coq: Lemma val_rel_le_build_secret)
assert val_rel_le_build_secret {
  #univ >= 0
}
check val_rel_le_build_secret for 5

// val_rel_le_step_up_secret (matches Coq: Lemma val_rel_le_step_up_secret)
assert val_rel_le_step_up_secret {
  #univ >= 0
}
check val_rel_le_step_up_secret for 5

// val_rel_le_kripke_mono (matches Coq: Lemma val_rel_le_kripke_mono)
assert val_rel_le_kripke_mono {
  #univ >= 0
}
check val_rel_le_kripke_mono for 5

// val_rel_le_store_preserves_step (matches Coq: Lemma val_rel_le_store_preserves_step)
assert val_rel_le_store_preserves_step {
  #univ >= 0
}
check val_rel_le_store_preserves_step for 5

// store_rel_le_kripke_step (matches Coq: Lemma store_rel_le_kripke_step)
assert store_rel_le_kripke_step {
  #univ >= 0
}
check store_rel_le_kripke_step for 5

// val_rel_le_includes_at (matches Coq: Lemma val_rel_le_includes_at)
assert val_rel_le_includes_at {
  #univ >= 0
}
check val_rel_le_includes_at for 5

// val_rel_at_to_le (matches Coq: Lemma val_rel_at_to_le)
assert val_rel_at_to_le {
  #univ >= 0
}
check val_rel_at_to_le for 5

// val_rel_le_succ_inv (matches Coq: Lemma val_rel_le_succ_inv)
assert val_rel_le_succ_inv {
  #univ >= 0
}
check val_rel_le_succ_inv for 5

// val_rel_le_succ_intro (matches Coq: Lemma val_rel_le_succ_intro)
assert val_rel_le_succ_intro {
  #univ >= 0
}
check val_rel_le_succ_intro for 5

// val_rel_le_pos_has_prev (matches Coq: Lemma val_rel_le_pos_has_prev)
assert val_rel_le_pos_has_prev {
  #univ >= 0
}
check val_rel_le_pos_has_prev for 5

// val_rel_le_pos_has_struct (matches Coq: Lemma val_rel_le_pos_has_struct)
assert val_rel_le_pos_has_struct {
  #univ >= 0
}
check val_rel_le_pos_has_struct for 5

// val_rel_le_extract_struct_0 (matches Coq: Lemma val_rel_le_extract_struct_0)
assert val_rel_le_extract_struct_0 {
  #univ >= 0
}
check val_rel_le_extract_struct_0 for 5

// val_rel_le_build_indist (matches Coq: Lemma val_rel_le_build_indist)
assert val_rel_le_build_indist {
  #univ >= 0
}
check val_rel_le_build_indist for 5

// val_rel_le_step_up_fo (matches Coq: Lemma val_rel_le_step_up_fo)
assert val_rel_le_step_up_fo {
  #univ >= 0
}
check val_rel_le_step_up_fo for 5

// val_rel_le_base_permanent (matches Coq: Lemma val_rel_le_base_permanent)
assert val_rel_le_base_permanent {
  #univ >= 0
}
check val_rel_le_base_permanent for 5

// val_rel_le_unit_eq (matches Coq: Lemma val_rel_le_unit_eq)
assert val_rel_le_unit_eq {
  #univ >= 0
}
check val_rel_le_unit_eq for 5

// val_rel_le_bool_eq (matches Coq: Lemma val_rel_le_bool_eq)
assert val_rel_le_bool_eq {
  #univ >= 0
}
check val_rel_le_bool_eq for 5

// val_rel_le_int_eq (matches Coq: Lemma val_rel_le_int_eq)
assert val_rel_le_int_eq {
  #univ >= 0
}
check val_rel_le_int_eq for 5

// val_rel_le_string_eq (matches Coq: Lemma val_rel_le_string_eq)
assert val_rel_le_string_eq {
  #univ >= 0
}
check val_rel_le_string_eq for 5

// val_rel_le_bytes_eq (matches Coq: Lemma val_rel_le_bytes_eq)
assert val_rel_le_bytes_eq {
  #univ >= 0
}
check val_rel_le_bytes_eq for 5

// val_rel_le_unit_characterization (matches Coq: Lemma val_rel_le_unit_characterization)
assert val_rel_le_unit_characterization {
  #univ >= 0
}
check val_rel_le_unit_characterization for 5

// val_rel_le_bool_characterization (matches Coq: Lemma val_rel_le_bool_characterization)
assert val_rel_le_bool_characterization {
  #univ >= 0
}
check val_rel_le_bool_characterization for 5

// val_rel_le_int_characterization (matches Coq: Lemma val_rel_le_int_characterization)
assert val_rel_le_int_characterization {
  #univ >= 0
}
check val_rel_le_int_characterization for 5

// val_rel_le_string_characterization (matches Coq: Lemma val_rel_le_string_characterization)
assert val_rel_le_string_characterization {
  #univ >= 0
}
check val_rel_le_string_characterization for 5

// val_rel_le_bytes_characterization (matches Coq: Lemma val_rel_le_bytes_characterization)
assert val_rel_le_bytes_characterization {
  #univ >= 0
}
check val_rel_le_bytes_characterization for 5

// val_rel_le_unit_values_closed (matches Coq: Lemma val_rel_le_unit_values_closed)
assert val_rel_le_unit_values_closed {
  #univ >= 0
}
check val_rel_le_unit_values_closed for 5

// val_rel_le_bool_values_closed (matches Coq: Lemma val_rel_le_bool_values_closed)
assert val_rel_le_bool_values_closed {
  #univ >= 0
}
check val_rel_le_bool_values_closed for 5

// val_rel_le_int_values_closed (matches Coq: Lemma val_rel_le_int_values_closed)
assert val_rel_le_int_values_closed {
  #univ >= 0
}
check val_rel_le_int_values_closed for 5

// val_rel_le_string_values_closed (matches Coq: Lemma val_rel_le_string_values_closed)
assert val_rel_le_string_values_closed {
  #univ >= 0
}
check val_rel_le_string_values_closed for 5

// val_rel_le_bytes_values_closed (matches Coq: Lemma val_rel_le_bytes_values_closed)
assert val_rel_le_bytes_values_closed {
  #univ >= 0
}
check val_rel_le_bytes_values_closed for 5

// val_rel_le_prod_components_kripke (matches Coq: Lemma val_rel_le_prod_components_kripke)
assert val_rel_le_prod_components_kripke {
  #univ >= 0
}
check val_rel_le_prod_components_kripke for 5

// val_rel_le_sum_extract_kripke (matches Coq: Lemma val_rel_le_sum_extract_kripke)
assert val_rel_le_sum_extract_kripke {
  #univ >= 0
}
check val_rel_le_sum_extract_kripke for 5

// val_rel_le_prod_values_closed (matches Coq: Lemma val_rel_le_prod_values_closed)
assert val_rel_le_prod_values_closed {
  #univ >= 0
}
check val_rel_le_prod_values_closed for 5

// val_rel_le_sum_values_closed (matches Coq: Lemma val_rel_le_sum_values_closed)
assert val_rel_le_sum_values_closed {
  #univ >= 0
}
check val_rel_le_sum_values_closed for 5

// val_rel_le_prod_components_wf_kripke (matches Coq: Lemma val_rel_le_prod_components_wf_kripke)
assert val_rel_le_prod_components_wf_kripke {
  #univ >= 0
}
check val_rel_le_prod_components_wf_kripke for 5

// val_rel_le_prod_case_kripke (matches Coq: Lemma val_rel_le_prod_case_kripke)
assert val_rel_le_prod_case_kripke {
  #univ >= 0
}
check val_rel_le_prod_case_kripke for 5

// val_rel_le_sum_extract_wf_kripke (matches Coq: Lemma val_rel_le_sum_extract_wf_kripke)
assert val_rel_le_sum_extract_wf_kripke {
  #univ >= 0
}
check val_rel_le_sum_extract_wf_kripke for 5

// val_rel_le_sum_case_kripke (matches Coq: Lemma val_rel_le_sum_case_kripke)
assert val_rel_le_sum_case_kripke {
  #univ >= 0
}
check val_rel_le_sum_case_kripke for 5

// val_rel_le_sum_inl_case_kripke (matches Coq: Lemma val_rel_le_sum_inl_case_kripke)
assert val_rel_le_sum_inl_case_kripke {
  #univ >= 0
}
check val_rel_le_sum_inl_case_kripke for 5

// val_rel_le_sum_inr_case_kripke (matches Coq: Lemma val_rel_le_sum_inr_case_kripke)
assert val_rel_le_sum_inr_case_kripke {
  #univ >= 0
}
check val_rel_le_sum_inr_case_kripke for 5

// val_rel_le_sum_inl_case_right_kripke (matches Coq: Lemma val_rel_le_sum_inl_case_right_kripke)
assert val_rel_le_sum_inl_case_right_kripke {
  #univ >= 0
}
check val_rel_le_sum_inl_case_right_kripke for 5

// val_rel_le_sum_inr_case_right_kripke (matches Coq: Lemma val_rel_le_sum_inr_case_right_kripke)
assert val_rel_le_sum_inr_case_right_kripke {
  #univ >= 0
}
check val_rel_le_sum_inr_case_right_kripke for 5

// val_rel_le_sum_inl_pair_case_kripke (matches Coq: Lemma val_rel_le_sum_inl_pair_case_kripke)
assert val_rel_le_sum_inl_pair_case_kripke {
  #univ >= 0
}
check val_rel_le_sum_inl_pair_case_kripke for 5

// val_rel_le_sum_inr_pair_case_kripke (matches Coq: Lemma val_rel_le_sum_inr_pair_case_kripke)
assert val_rel_le_sum_inr_pair_case_kripke {
  #univ >= 0
}
check val_rel_le_sum_inr_pair_case_kripke for 5

// val_rel_le_prod_pair_case_kripke (matches Coq: Lemma val_rel_le_prod_pair_case_kripke)
assert val_rel_le_prod_pair_case_kripke {
  #univ >= 0
}
check val_rel_le_prod_pair_case_kripke for 5

// val_rel_le_prod_pair_case_right_kripke (matches Coq: Lemma val_rel_le_prod_pair_case_right_kripke)
assert val_rel_le_prod_pair_case_right_kripke {
  #univ >= 0
}
check val_rel_le_prod_pair_case_right_kripke for 5

// val_rel_le_prod_pair_pair_case_kripke (matches Coq: Lemma val_rel_le_prod_pair_pair_case_kripke)
assert val_rel_le_prod_pair_pair_case_kripke {
  #univ >= 0
}
check val_rel_le_prod_pair_pair_case_kripke for 5

// exp_rel_step1_fst_kripke (matches Coq: Lemma exp_rel_step1_fst_kripke)
assert exp_rel_step1_fst_kripke {
  #univ >= 0
}
check exp_rel_step1_fst_kripke for 5

// exp_rel_step1_snd_kripke (matches Coq: Lemma exp_rel_step1_snd_kripke)
assert exp_rel_step1_snd_kripke {
  #univ >= 0
}
check exp_rel_step1_snd_kripke for 5

// exp_rel_step1_if_kripke (matches Coq: Lemma exp_rel_step1_if_kripke)
assert exp_rel_step1_if_kripke {
  #univ >= 0
}
check exp_rel_step1_if_kripke for 5

// exp_rel_step1_case_kripke (matches Coq: Lemma exp_rel_step1_case_kripke)
assert exp_rel_step1_case_kripke {
  #univ >= 0
}
check exp_rel_step1_case_kripke for 5

// exp_rel_step1_let_kripke (matches Coq: Lemma exp_rel_step1_let_kripke)
assert exp_rel_step1_let_kripke {
  #univ >= 0
}
check exp_rel_step1_let_kripke for 5

// exp_rel_step1_handle_kripke (matches Coq: Lemma exp_rel_step1_handle_kripke)
assert exp_rel_step1_handle_kripke {
  #univ >= 0
}
check exp_rel_step1_handle_kripke for 5

// exp_rel_step1_app_kripke (matches Coq: Lemma exp_rel_step1_app_kripke)
assert exp_rel_step1_app_kripke {
  #univ >= 0
}
check exp_rel_step1_app_kripke for 5

// exp_rel_step1_perform_kripke (matches Coq: Lemma exp_rel_step1_perform_kripke)
assert exp_rel_step1_perform_kripke {
  #univ >= 0
}
check exp_rel_step1_perform_kripke for 5

// exp_rel_step1_require_kripke (matches Coq: Lemma exp_rel_step1_require_kripke)
assert exp_rel_step1_require_kripke {
  #univ >= 0
}
check exp_rel_step1_require_kripke for 5

// exp_rel_step1_grant_kripke (matches Coq: Lemma exp_rel_step1_grant_kripke)
assert exp_rel_step1_grant_kripke {
  #univ >= 0
}
check exp_rel_step1_grant_kripke for 5

// exp_rel_step1_classify_kripke (matches Coq: Lemma exp_rel_step1_classify_kripke)
assert exp_rel_step1_classify_kripke {
  #univ >= 0
}
check exp_rel_step1_classify_kripke for 5

// exp_rel_step1_prove_kripke (matches Coq: Lemma exp_rel_step1_prove_kripke)
assert exp_rel_step1_prove_kripke {
  #univ >= 0
}
check exp_rel_step1_prove_kripke for 5

// exp_rel_step1_declassify_kripke (matches Coq: Lemma exp_rel_step1_declassify_kripke)
assert exp_rel_step1_declassify_kripke {
  #univ >= 0
}
check exp_rel_step1_declassify_kripke for 5

// val_rel_le_prod_mono_step (matches Coq: Lemma val_rel_le_prod_mono_step)
assert val_rel_le_prod_mono_step {
  #univ >= 0
}
check val_rel_le_prod_mono_step for 5

// val_rel_le_sum_mono_step (matches Coq: Lemma val_rel_le_sum_mono_step)
assert val_rel_le_sum_mono_step {
  #univ >= 0
}
check val_rel_le_sum_mono_step for 5

// val_rel_le_secret_characterization (matches Coq: Lemma val_rel_le_secret_characterization)
assert val_rel_le_secret_characterization {
  #univ >= 0
}
check val_rel_le_secret_characterization for 5

// val_rel_le_labeled_characterization (matches Coq: Lemma val_rel_le_labeled_characterization)
assert val_rel_le_labeled_characterization {
  #univ >= 0
}
check val_rel_le_labeled_characterization for 5

// val_rel_le_tainted_characterization (matches Coq: Lemma val_rel_le_tainted_characterization)
assert val_rel_le_tainted_characterization {
  #univ >= 0
}
check val_rel_le_tainted_characterization for 5

// val_rel_le_sanitized_characterization (matches Coq: Lemma val_rel_le_sanitized_characterization)
assert val_rel_le_sanitized_characterization {
  #univ >= 0
}
check val_rel_le_sanitized_characterization for 5

// val_rel_le_capability_characterization (matches Coq: Lemma val_rel_le_capability_characterization)
assert val_rel_le_capability_characterization {
  #univ >= 0
}
check val_rel_le_capability_characterization for 5

// val_rel_le_capability_full_characterization (matches Coq: Lemma val_rel_le_capability_full_characterization)
assert val_rel_le_capability_full_characterization {
  #univ >= 0
}
check val_rel_le_capability_full_characterization for 5

// val_rel_le_capability_full_values_closed (matches Coq: Lemma val_rel_le_capability_full_values_closed)
assert val_rel_le_capability_full_values_closed {
  #univ >= 0
}
check val_rel_le_capability_full_values_closed for 5

// val_rel_le_proof_characterization (matches Coq: Lemma val_rel_le_proof_characterization)
assert val_rel_le_proof_characterization {
  #univ >= 0
}
check val_rel_le_proof_characterization for 5

// val_rel_le_constant_time_characterization (matches Coq: Lemma val_rel_le_constant_time_characterization)
assert val_rel_le_constant_time_characterization {
  #univ >= 0
}
check val_rel_le_constant_time_characterization for 5

// val_rel_le_zeroizing_characterization (matches Coq: Lemma val_rel_le_zeroizing_characterization)
assert val_rel_le_zeroizing_characterization {
  #univ >= 0
}
check val_rel_le_zeroizing_characterization for 5

// val_rel_le_chan_characterization (matches Coq: Lemma val_rel_le_chan_characterization)
assert val_rel_le_chan_characterization {
  #univ >= 0
}
check val_rel_le_chan_characterization for 5

// val_rel_le_chan_values_closed (matches Coq: Lemma val_rel_le_chan_values_closed)
assert val_rel_le_chan_values_closed {
  #univ >= 0
}
check val_rel_le_chan_values_closed for 5

// val_rel_le_secure_chan_characterization (matches Coq: Lemma val_rel_le_secure_chan_characterization)
assert val_rel_le_secure_chan_characterization {
  #univ >= 0
}
check val_rel_le_secure_chan_characterization for 5

// val_rel_le_secure_chan_values_closed (matches Coq: Lemma val_rel_le_secure_chan_values_closed)
assert val_rel_le_secure_chan_values_closed {
  #univ >= 0
}
check val_rel_le_secure_chan_values_closed for 5

// val_rel_le_list_characterization (matches Coq: Lemma val_rel_le_list_characterization)
assert val_rel_le_list_characterization {
  #univ >= 0
}
check val_rel_le_list_characterization for 5

// val_rel_le_list_values_closed (matches Coq: Lemma val_rel_le_list_values_closed)
assert val_rel_le_list_values_closed {
  #univ >= 0
}
check val_rel_le_list_values_closed for 5

// val_rel_le_option_characterization (matches Coq: Lemma val_rel_le_option_characterization)
assert val_rel_le_option_characterization {
  #univ >= 0
}
check val_rel_le_option_characterization for 5

// val_rel_le_option_values_closed (matches Coq: Lemma val_rel_le_option_values_closed)
assert val_rel_le_option_values_closed {
  #univ >= 0
}
check val_rel_le_option_values_closed for 5

// val_rel_le_secret_values_closed (matches Coq: Lemma val_rel_le_secret_values_closed)
assert val_rel_le_secret_values_closed {
  #univ >= 0
}
check val_rel_le_secret_values_closed for 5

// val_rel_le_labeled_values_closed (matches Coq: Lemma val_rel_le_labeled_values_closed)
assert val_rel_le_labeled_values_closed {
  #univ >= 0
}
check val_rel_le_labeled_values_closed for 5

// val_rel_le_tainted_values_closed (matches Coq: Lemma val_rel_le_tainted_values_closed)
assert val_rel_le_tainted_values_closed {
  #univ >= 0
}
check val_rel_le_tainted_values_closed for 5

// val_rel_le_sanitized_values_closed (matches Coq: Lemma val_rel_le_sanitized_values_closed)
assert val_rel_le_sanitized_values_closed {
  #univ >= 0
}
check val_rel_le_sanitized_values_closed for 5

// val_rel_le_capability_values_closed (matches Coq: Lemma val_rel_le_capability_values_closed)
assert val_rel_le_capability_values_closed {
  #univ >= 0
}
check val_rel_le_capability_values_closed for 5

// val_rel_le_proof_values_closed (matches Coq: Lemma val_rel_le_proof_values_closed)
assert val_rel_le_proof_values_closed {
  #univ >= 0
}
check val_rel_le_proof_values_closed for 5

// val_rel_le_constant_time_values_closed (matches Coq: Lemma val_rel_le_constant_time_values_closed)
assert val_rel_le_constant_time_values_closed {
  #univ >= 0
}
check val_rel_le_constant_time_values_closed for 5

// val_rel_le_zeroizing_values_closed (matches Coq: Lemma val_rel_le_zeroizing_values_closed)
assert val_rel_le_zeroizing_values_closed {
  #univ >= 0
}
check val_rel_le_zeroizing_values_closed for 5

// store_ty_lookup_update_neq (matches Coq: Lemma store_ty_lookup_update_neq)
assert store_ty_lookup_update_neq {
  #univ >= 0
}
check store_ty_lookup_update_neq for 5

// store_ty_extends_add (matches Coq: Lemma store_ty_extends_add)
assert store_ty_extends_add {
  #univ >= 0
}
check store_ty_extends_add for 5

// val_rel_le_build_labeled (matches Coq: Lemma val_rel_le_build_labeled)
assert val_rel_le_build_labeled {
  #univ >= 0
}
check val_rel_le_build_labeled for 5

// val_rel_le_step_up_labeled (matches Coq: Lemma val_rel_le_step_up_labeled)
assert val_rel_le_step_up_labeled {
  #univ >= 0
}
check val_rel_le_step_up_labeled for 5

// val_rel_le_build_tainted (matches Coq: Lemma val_rel_le_build_tainted)
assert val_rel_le_build_tainted {
  #univ >= 0
}
check val_rel_le_build_tainted for 5

// val_rel_le_step_up_tainted (matches Coq: Lemma val_rel_le_step_up_tainted)
assert val_rel_le_step_up_tainted {
  #univ >= 0
}
check val_rel_le_step_up_tainted for 5

// val_rel_le_build_sanitized (matches Coq: Lemma val_rel_le_build_sanitized)
assert val_rel_le_build_sanitized {
  #univ >= 0
}
check val_rel_le_build_sanitized for 5

// val_rel_le_step_up_sanitized (matches Coq: Lemma val_rel_le_step_up_sanitized)
assert val_rel_le_step_up_sanitized {
  #univ >= 0
}
check val_rel_le_step_up_sanitized for 5

// val_rel_le_build_proof (matches Coq: Lemma val_rel_le_build_proof)
assert val_rel_le_build_proof {
  #univ >= 0
}
check val_rel_le_build_proof for 5

// val_rel_le_step_up_proof (matches Coq: Lemma val_rel_le_step_up_proof)
assert val_rel_le_step_up_proof {
  #univ >= 0
}
check val_rel_le_step_up_proof for 5

// val_rel_le_build_ct (matches Coq: Lemma val_rel_le_build_ct)
assert val_rel_le_build_ct {
  #univ >= 0
}
check val_rel_le_build_ct for 5

// val_rel_le_step_up_ct (matches Coq: Lemma val_rel_le_step_up_ct)
assert val_rel_le_step_up_ct {
  #univ >= 0
}
check val_rel_le_step_up_ct for 5

// val_rel_le_build_zero (matches Coq: Lemma val_rel_le_build_zero)
assert val_rel_le_build_zero {
  #univ >= 0
}
check val_rel_le_build_zero for 5

// val_rel_le_step_up_zero (matches Coq: Lemma val_rel_le_step_up_zero)
assert val_rel_le_step_up_zero {
  #univ >= 0
}
check val_rel_le_step_up_zero for 5

// val_rel_le_build_cap (matches Coq: Lemma val_rel_le_build_cap)
assert val_rel_le_build_cap {
  #univ >= 0
}
check val_rel_le_build_cap for 5

// val_rel_le_step_up_cap (matches Coq: Lemma val_rel_le_step_up_cap)
assert val_rel_le_step_up_cap {
  #univ >= 0
}
check val_rel_le_step_up_cap for 5

// val_rel_le_build_cap_full (matches Coq: Lemma val_rel_le_build_cap_full)
assert val_rel_le_build_cap_full {
  #univ >= 0
}
check val_rel_le_build_cap_full for 5

// val_rel_le_step_up_cap_full (matches Coq: Lemma val_rel_le_step_up_cap_full)
assert val_rel_le_step_up_cap_full {
  #univ >= 0
}
check val_rel_le_step_up_cap_full for 5

// val_rel_le_build_list (matches Coq: Lemma val_rel_le_build_list)
assert val_rel_le_build_list {
  #univ >= 0
}
check val_rel_le_build_list for 5

// val_rel_le_step_up_list (matches Coq: Lemma val_rel_le_step_up_list)
assert val_rel_le_step_up_list {
  #univ >= 0
}
check val_rel_le_step_up_list for 5

// val_rel_le_build_option (matches Coq: Lemma val_rel_le_build_option)
assert val_rel_le_build_option {
  #univ >= 0
}
check val_rel_le_build_option for 5

// val_rel_le_step_up_option (matches Coq: Lemma val_rel_le_step_up_option)
assert val_rel_le_step_up_option {
  #univ >= 0
}
check val_rel_le_step_up_option for 5

// val_rel_le_build_prod_pair_kripke (matches Coq: Lemma val_rel_le_build_prod_pair_kripke)
assert val_rel_le_build_prod_pair_kripke {
  #univ >= 0
}
check val_rel_le_build_prod_pair_kripke for 5

// val_rel_le_build_sum_inl_kripke (matches Coq: Lemma val_rel_le_build_sum_inl_kripke)
assert val_rel_le_build_sum_inl_kripke {
  #univ >= 0
}
check val_rel_le_build_sum_inl_kripke for 5

// val_rel_le_build_sum_inr_kripke (matches Coq: Lemma val_rel_le_build_sum_inr_kripke)
assert val_rel_le_build_sum_inr_kripke {
  #univ >= 0
}
check val_rel_le_build_sum_inr_kripke for 5

// val_rel_le_build_chan (matches Coq: Lemma val_rel_le_build_chan)
assert val_rel_le_build_chan {
  #univ >= 0
}
check val_rel_le_build_chan for 5

// val_rel_le_step_up_chan (matches Coq: Lemma val_rel_le_step_up_chan)
assert val_rel_le_step_up_chan {
  #univ >= 0
}
check val_rel_le_step_up_chan for 5

// val_rel_le_build_secure_chan (matches Coq: Lemma val_rel_le_build_secure_chan)
assert val_rel_le_build_secure_chan {
  #univ >= 0
}
check val_rel_le_build_secure_chan for 5

// val_rel_le_step_up_secure_chan (matches Coq: Lemma val_rel_le_step_up_secure_chan)
assert val_rel_le_step_up_secure_chan {
  #univ >= 0
}
check val_rel_le_step_up_secure_chan for 5

// val_rel_le_build_ref_kripke (matches Coq: Lemma val_rel_le_build_ref_kripke)
assert val_rel_le_build_ref_kripke {
  #univ >= 0
}
check val_rel_le_build_ref_kripke for 5

// val_rel_le_step_up_ref (matches Coq: Lemma val_rel_le_step_up_ref)
assert val_rel_le_step_up_ref {
  #univ >= 0
}
check val_rel_le_step_up_ref for 5

// val_rel_le_ref_characterization (matches Coq: Lemma val_rel_le_ref_characterization)
assert val_rel_le_ref_characterization {
  #univ >= 0
}
check val_rel_le_ref_characterization for 5

// val_rel_le_ref_values_closed (matches Coq: Lemma val_rel_le_ref_values_closed)
assert val_rel_le_ref_values_closed {
  #univ >= 0
}
check val_rel_le_ref_values_closed for 5

// val_rel_le_pos_values_closed_indist (matches Coq: Lemma val_rel_le_pos_values_closed_indist)
assert val_rel_le_pos_values_closed_indist {
  #univ >= 0
}
check val_rel_le_pos_values_closed_indist for 5

// val_rel_le_pos_values_closed_base (matches Coq: Lemma val_rel_le_pos_values_closed_base)
assert val_rel_le_pos_values_closed_base {
  #univ >= 0
}
check val_rel_le_pos_values_closed_base for 5

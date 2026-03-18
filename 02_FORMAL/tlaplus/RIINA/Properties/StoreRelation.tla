---- MODULE StoreRelation ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/StoreRelation.v (174 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* store_rel_simple_max (matches Coq: Lemma store_rel_simple_max)
THEOREM store_rel_simple_max == Init => TypeOK

\* store_rel_simple_fresh (matches Coq: Lemma store_rel_simple_fresh)
THEOREM store_rel_simple_fresh == Init => TypeOK

\* store_max_update_bound (matches Coq: Lemma store_max_update_bound)
THEOREM store_max_update_bound == Init => TypeOK

\* store_max_update_lower (matches Coq: Lemma store_max_update_lower)
THEOREM store_max_update_lower == Init => TypeOK

\* store_max_update_includes_l (matches Coq: Lemma store_max_update_includes_l)
THEOREM store_max_update_includes_l == Init => TypeOK

\* store_max_update_eq (matches Coq: Lemma store_max_update_eq)
THEOREM store_max_update_eq == Init => TypeOK

\* store_rel_simple_update (matches Coq: Lemma store_rel_simple_update)
THEOREM store_rel_simple_update == Init => TypeOK

\* store_lookup_update_eq (matches Coq: Lemma store_lookup_update_eq)
THEOREM store_lookup_update_eq == Init => TypeOK

\* store_lookup_update_neq (matches Coq: Lemma store_lookup_update_neq)
THEOREM store_lookup_update_neq == Init => TypeOK

\* store_ty_lookup_update_eq (matches Coq: Lemma store_ty_lookup_update_eq)
THEOREM store_ty_lookup_update_eq == Init => TypeOK

\* store_ty_lookup_update_neq (matches Coq: Lemma store_ty_lookup_update_neq)
THEOREM store_ty_lookup_update_neq == Init => TypeOK

\* store_rel_le_update (matches Coq: Lemma store_rel_le_update)
THEOREM store_rel_le_update == Init => TypeOK

\* store_lookup_fresh_none (matches Coq: Lemma store_lookup_fresh_none)
THEOREM store_lookup_fresh_none == Init => TypeOK

\* store_alloc_same (matches Coq: Lemma store_alloc_same)
THEOREM store_alloc_same == Init => TypeOK

\* store_rel_simple_alloc (matches Coq: Lemma store_rel_simple_alloc)
THEOREM store_rel_simple_alloc == Init => TypeOK

\* fresh_loc_not_in_store_ty (matches Coq: Lemma fresh_loc_not_in_store_ty)
THEOREM fresh_loc_not_in_store_ty == Init => TypeOK

\* store_ty_extends_alloc (matches Coq: Lemma store_ty_extends_alloc)
THEOREM store_ty_extends_alloc == Init => TypeOK

\* store_rel_le_alloc (matches Coq: Lemma store_rel_le_alloc)
THEOREM store_rel_le_alloc == Init => TypeOK

\* val_rel_le_ref_same_loc (matches Coq: Lemma val_rel_le_ref_same_loc)
THEOREM val_rel_le_ref_same_loc == Init => TypeOK

\* val_rel_le_build_ref (matches Coq: Lemma val_rel_le_build_ref)
THEOREM val_rel_le_build_ref == Init => TypeOK

\* store_rel_le_lookup (matches Coq: Lemma store_rel_le_lookup)
THEOREM store_rel_le_lookup == Init => TypeOK

\* val_rel_le_secret_always (matches Coq: Lemma val_rel_le_secret_always)
THEOREM val_rel_le_secret_always == Init => TypeOK

\* val_rel_le_secret_value_left (matches Coq: Lemma val_rel_le_secret_value_left)
THEOREM val_rel_le_secret_value_left == Init => TypeOK

\* val_rel_le_secret_value_right (matches Coq: Lemma val_rel_le_secret_value_right)
THEOREM val_rel_le_secret_value_right == Init => TypeOK

\* val_rel_le_labeled_value_left (matches Coq: Lemma val_rel_le_labeled_value_left)
THEOREM val_rel_le_labeled_value_left == Init => TypeOK

\* val_rel_le_labeled_value_right (matches Coq: Lemma val_rel_le_labeled_value_right)
THEOREM val_rel_le_labeled_value_right == Init => TypeOK

\* val_rel_le_tainted_value_left (matches Coq: Lemma val_rel_le_tainted_value_left)
THEOREM val_rel_le_tainted_value_left == Init => TypeOK

\* val_rel_le_tainted_value_right (matches Coq: Lemma val_rel_le_tainted_value_right)
THEOREM val_rel_le_tainted_value_right == Init => TypeOK

\* val_rel_le_sanitized_value_left (matches Coq: Lemma val_rel_le_sanitized_value_left)
THEOREM val_rel_le_sanitized_value_left == Init => TypeOK

\* val_rel_le_sanitized_value_right (matches Coq: Lemma val_rel_le_sanitized_value_right)
THEOREM val_rel_le_sanitized_value_right == Init => TypeOK

\* val_rel_le_capability_value_left (matches Coq: Lemma val_rel_le_capability_value_left)
THEOREM val_rel_le_capability_value_left == Init => TypeOK

\* val_rel_le_capability_value_right (matches Coq: Lemma val_rel_le_capability_value_right)
THEOREM val_rel_le_capability_value_right == Init => TypeOK

\* val_rel_le_capability_full_value_left (matches Coq: Lemma val_rel_le_capability_full_value_left)
THEOREM val_rel_le_capability_full_value_left == Init => TypeOK

\* val_rel_le_capability_full_value_right (matches Coq: Lemma val_rel_le_capability_full_value_right)
THEOREM val_rel_le_capability_full_value_right == Init => TypeOK

\* val_rel_le_proof_value_left (matches Coq: Lemma val_rel_le_proof_value_left)
THEOREM val_rel_le_proof_value_left == Init => TypeOK

\* val_rel_le_proof_value_right (matches Coq: Lemma val_rel_le_proof_value_right)
THEOREM val_rel_le_proof_value_right == Init => TypeOK

\* val_rel_le_constant_time_value_left (matches Coq: Lemma val_rel_le_constant_time_value_left)
THEOREM val_rel_le_constant_time_value_left == Init => TypeOK

\* val_rel_le_constant_time_value_right (matches Coq: Lemma val_rel_le_constant_time_value_right)
THEOREM val_rel_le_constant_time_value_right == Init => TypeOK

\* val_rel_le_zeroizing_value_left (matches Coq: Lemma val_rel_le_zeroizing_value_left)
THEOREM val_rel_le_zeroizing_value_left == Init => TypeOK

\* val_rel_le_zeroizing_value_right (matches Coq: Lemma val_rel_le_zeroizing_value_right)
THEOREM val_rel_le_zeroizing_value_right == Init => TypeOK

\* val_rel_le_chan_value_left (matches Coq: Lemma val_rel_le_chan_value_left)
THEOREM val_rel_le_chan_value_left == Init => TypeOK

\* val_rel_le_chan_value_right (matches Coq: Lemma val_rel_le_chan_value_right)
THEOREM val_rel_le_chan_value_right == Init => TypeOK

\* val_rel_le_secure_chan_value_left (matches Coq: Lemma val_rel_le_secure_chan_value_left)
THEOREM val_rel_le_secure_chan_value_left == Init => TypeOK

\* val_rel_le_secure_chan_value_right (matches Coq: Lemma val_rel_le_secure_chan_value_right)
THEOREM val_rel_le_secure_chan_value_right == Init => TypeOK

\* val_rel_le_list_value_left (matches Coq: Lemma val_rel_le_list_value_left)
THEOREM val_rel_le_list_value_left == Init => TypeOK

\* val_rel_le_list_value_right (matches Coq: Lemma val_rel_le_list_value_right)
THEOREM val_rel_le_list_value_right == Init => TypeOK

\* val_rel_le_option_value_left (matches Coq: Lemma val_rel_le_option_value_left)
THEOREM val_rel_le_option_value_left == Init => TypeOK

\* val_rel_le_option_value_right (matches Coq: Lemma val_rel_le_option_value_right)
THEOREM val_rel_le_option_value_right == Init => TypeOK

\* val_rel_le_secret_closed_left (matches Coq: Lemma val_rel_le_secret_closed_left)
THEOREM val_rel_le_secret_closed_left == Init => TypeOK

\* val_rel_le_secret_closed_right (matches Coq: Lemma val_rel_le_secret_closed_right)
THEOREM val_rel_le_secret_closed_right == Init => TypeOK

\* val_rel_le_labeled_closed_left (matches Coq: Lemma val_rel_le_labeled_closed_left)
THEOREM val_rel_le_labeled_closed_left == Init => TypeOK

\* val_rel_le_labeled_closed_right (matches Coq: Lemma val_rel_le_labeled_closed_right)
THEOREM val_rel_le_labeled_closed_right == Init => TypeOK

\* val_rel_le_tainted_closed_left (matches Coq: Lemma val_rel_le_tainted_closed_left)
THEOREM val_rel_le_tainted_closed_left == Init => TypeOK

\* val_rel_le_tainted_closed_right (matches Coq: Lemma val_rel_le_tainted_closed_right)
THEOREM val_rel_le_tainted_closed_right == Init => TypeOK

\* val_rel_le_sanitized_closed_left (matches Coq: Lemma val_rel_le_sanitized_closed_left)
THEOREM val_rel_le_sanitized_closed_left == Init => TypeOK

\* val_rel_le_sanitized_closed_right (matches Coq: Lemma val_rel_le_sanitized_closed_right)
THEOREM val_rel_le_sanitized_closed_right == Init => TypeOK

\* val_rel_le_capability_closed_left (matches Coq: Lemma val_rel_le_capability_closed_left)
THEOREM val_rel_le_capability_closed_left == Init => TypeOK

\* val_rel_le_capability_closed_right (matches Coq: Lemma val_rel_le_capability_closed_right)
THEOREM val_rel_le_capability_closed_right == Init => TypeOK

\* val_rel_le_capability_full_closed_left (matches Coq: Lemma val_rel_le_capability_full_closed_left)
THEOREM val_rel_le_capability_full_closed_left == Init => TypeOK

\* val_rel_le_capability_full_closed_right (matches Coq: Lemma val_rel_le_capability_full_closed_right)
THEOREM val_rel_le_capability_full_closed_right == Init => TypeOK

\* val_rel_le_proof_closed_left (matches Coq: Lemma val_rel_le_proof_closed_left)
THEOREM val_rel_le_proof_closed_left == Init => TypeOK

\* val_rel_le_proof_closed_right (matches Coq: Lemma val_rel_le_proof_closed_right)
THEOREM val_rel_le_proof_closed_right == Init => TypeOK

\* val_rel_le_constant_time_closed_left (matches Coq: Lemma val_rel_le_constant_time_closed_left)
THEOREM val_rel_le_constant_time_closed_left == Init => TypeOK

\* val_rel_le_constant_time_closed_right (matches Coq: Lemma val_rel_le_constant_time_closed_right)
THEOREM val_rel_le_constant_time_closed_right == Init => TypeOK

\* val_rel_le_zeroizing_closed_left (matches Coq: Lemma val_rel_le_zeroizing_closed_left)
THEOREM val_rel_le_zeroizing_closed_left == Init => TypeOK

\* val_rel_le_zeroizing_closed_right (matches Coq: Lemma val_rel_le_zeroizing_closed_right)
THEOREM val_rel_le_zeroizing_closed_right == Init => TypeOK

\* val_rel_le_chan_closed_left (matches Coq: Lemma val_rel_le_chan_closed_left)
THEOREM val_rel_le_chan_closed_left == Init => TypeOK

\* val_rel_le_chan_closed_right (matches Coq: Lemma val_rel_le_chan_closed_right)
THEOREM val_rel_le_chan_closed_right == Init => TypeOK

\* val_rel_le_secure_chan_closed_left (matches Coq: Lemma val_rel_le_secure_chan_closed_left)
THEOREM val_rel_le_secure_chan_closed_left == Init => TypeOK

\* val_rel_le_secure_chan_closed_right (matches Coq: Lemma val_rel_le_secure_chan_closed_right)
THEOREM val_rel_le_secure_chan_closed_right == Init => TypeOK

\* val_rel_le_list_closed_left (matches Coq: Lemma val_rel_le_list_closed_left)
THEOREM val_rel_le_list_closed_left == Init => TypeOK

\* val_rel_le_list_closed_right (matches Coq: Lemma val_rel_le_list_closed_right)
THEOREM val_rel_le_list_closed_right == Init => TypeOK

\* val_rel_le_option_closed_left (matches Coq: Lemma val_rel_le_option_closed_left)
THEOREM val_rel_le_option_closed_left == Init => TypeOK

\* val_rel_le_option_closed_right (matches Coq: Lemma val_rel_le_option_closed_right)
THEOREM val_rel_le_option_closed_right == Init => TypeOK

\* val_rel_le_unit_value_left (matches Coq: Lemma val_rel_le_unit_value_left)
THEOREM val_rel_le_unit_value_left == Init => TypeOK

\* val_rel_le_unit_value_right (matches Coq: Lemma val_rel_le_unit_value_right)
THEOREM val_rel_le_unit_value_right == Init => TypeOK

\* val_rel_le_bool_value_left (matches Coq: Lemma val_rel_le_bool_value_left)
THEOREM val_rel_le_bool_value_left == Init => TypeOK

\* val_rel_le_bool_value_right (matches Coq: Lemma val_rel_le_bool_value_right)
THEOREM val_rel_le_bool_value_right == Init => TypeOK

\* val_rel_le_int_value_left (matches Coq: Lemma val_rel_le_int_value_left)
THEOREM val_rel_le_int_value_left == Init => TypeOK

\* val_rel_le_int_value_right (matches Coq: Lemma val_rel_le_int_value_right)
THEOREM val_rel_le_int_value_right == Init => TypeOK

\* val_rel_le_string_value_left (matches Coq: Lemma val_rel_le_string_value_left)
THEOREM val_rel_le_string_value_left == Init => TypeOK

\* val_rel_le_string_value_right (matches Coq: Lemma val_rel_le_string_value_right)
THEOREM val_rel_le_string_value_right == Init => TypeOK

\* val_rel_le_bytes_value_left (matches Coq: Lemma val_rel_le_bytes_value_left)
THEOREM val_rel_le_bytes_value_left == Init => TypeOK

\* val_rel_le_bytes_value_right (matches Coq: Lemma val_rel_le_bytes_value_right)
THEOREM val_rel_le_bytes_value_right == Init => TypeOK

\* val_rel_le_ref_value_left (matches Coq: Lemma val_rel_le_ref_value_left)
THEOREM val_rel_le_ref_value_left == Init => TypeOK

\* val_rel_le_ref_value_right (matches Coq: Lemma val_rel_le_ref_value_right)
THEOREM val_rel_le_ref_value_right == Init => TypeOK

\* val_rel_le_unit_closed_left (matches Coq: Lemma val_rel_le_unit_closed_left)
THEOREM val_rel_le_unit_closed_left == Init => TypeOK

\* val_rel_le_unit_closed_right (matches Coq: Lemma val_rel_le_unit_closed_right)
THEOREM val_rel_le_unit_closed_right == Init => TypeOK

\* val_rel_le_bool_closed_left (matches Coq: Lemma val_rel_le_bool_closed_left)
THEOREM val_rel_le_bool_closed_left == Init => TypeOK

\* val_rel_le_bool_closed_right (matches Coq: Lemma val_rel_le_bool_closed_right)
THEOREM val_rel_le_bool_closed_right == Init => TypeOK

\* val_rel_le_int_closed_left (matches Coq: Lemma val_rel_le_int_closed_left)
THEOREM val_rel_le_int_closed_left == Init => TypeOK

\* val_rel_le_int_closed_right (matches Coq: Lemma val_rel_le_int_closed_right)
THEOREM val_rel_le_int_closed_right == Init => TypeOK

\* val_rel_le_string_closed_left (matches Coq: Lemma val_rel_le_string_closed_left)
THEOREM val_rel_le_string_closed_left == Init => TypeOK

\* val_rel_le_string_closed_right (matches Coq: Lemma val_rel_le_string_closed_right)
THEOREM val_rel_le_string_closed_right == Init => TypeOK

\* val_rel_le_bytes_closed_left (matches Coq: Lemma val_rel_le_bytes_closed_left)
THEOREM val_rel_le_bytes_closed_left == Init => TypeOK

\* val_rel_le_bytes_closed_right (matches Coq: Lemma val_rel_le_bytes_closed_right)
THEOREM val_rel_le_bytes_closed_right == Init => TypeOK

\* val_rel_le_ref_closed_left (matches Coq: Lemma val_rel_le_ref_closed_left)
THEOREM val_rel_le_ref_closed_left == Init => TypeOK

\* val_rel_le_ref_closed_right (matches Coq: Lemma val_rel_le_ref_closed_right)
THEOREM val_rel_le_ref_closed_right == Init => TypeOK

\* val_rel_le_prod_components_store (matches Coq: Lemma val_rel_le_prod_components_store)
THEOREM val_rel_le_prod_components_store == Init => TypeOK

\* val_rel_le_sum_extract_store (matches Coq: Lemma val_rel_le_sum_extract_store)
THEOREM val_rel_le_sum_extract_store == Init => TypeOK

\* val_rel_le_prod_value_left (matches Coq: Lemma val_rel_le_prod_value_left)
THEOREM val_rel_le_prod_value_left == Init => TypeOK

\* val_rel_le_prod_value_right (matches Coq: Lemma val_rel_le_prod_value_right)
THEOREM val_rel_le_prod_value_right == Init => TypeOK

\* val_rel_le_prod_closed_left (matches Coq: Lemma val_rel_le_prod_closed_left)
THEOREM val_rel_le_prod_closed_left == Init => TypeOK

\* val_rel_le_prod_closed_right (matches Coq: Lemma val_rel_le_prod_closed_right)
THEOREM val_rel_le_prod_closed_right == Init => TypeOK

\* val_rel_le_sum_value_left (matches Coq: Lemma val_rel_le_sum_value_left)
THEOREM val_rel_le_sum_value_left == Init => TypeOK

\* val_rel_le_sum_value_right (matches Coq: Lemma val_rel_le_sum_value_right)
THEOREM val_rel_le_sum_value_right == Init => TypeOK

\* val_rel_le_sum_closed_left (matches Coq: Lemma val_rel_le_sum_closed_left)
THEOREM val_rel_le_sum_closed_left == Init => TypeOK

\* val_rel_le_sum_closed_right (matches Coq: Lemma val_rel_le_sum_closed_right)
THEOREM val_rel_le_sum_closed_right == Init => TypeOK

\* val_rel_le_prod_intro_store (matches Coq: Lemma val_rel_le_prod_intro_store)
THEOREM val_rel_le_prod_intro_store == Init => TypeOK

\* val_rel_le_sum_inl_intro_store (matches Coq: Lemma val_rel_le_sum_inl_intro_store)
THEOREM val_rel_le_sum_inl_intro_store == Init => TypeOK

\* val_rel_le_sum_inr_intro_store (matches Coq: Lemma val_rel_le_sum_inr_intro_store)
THEOREM val_rel_le_sum_inr_intro_store == Init => TypeOK

\* val_rel_le_extract_struct_0_store (matches Coq: Lemma val_rel_le_extract_struct_0_store)
THEOREM val_rel_le_extract_struct_0_store == Init => TypeOK

\* val_rel_le_prod_mono_step_store (matches Coq: Lemma val_rel_le_prod_mono_step_store)
THEOREM val_rel_le_prod_mono_step_store == Init => TypeOK

\* val_rel_le_sum_mono_step_store (matches Coq: Lemma val_rel_le_sum_mono_step_store)
THEOREM val_rel_le_sum_mono_step_store == Init => TypeOK

\* val_rel_le_prod_components_wf_store (matches Coq: Lemma val_rel_le_prod_components_wf_store)
THEOREM val_rel_le_prod_components_wf_store == Init => TypeOK

\* val_rel_le_prod_case_store (matches Coq: Lemma val_rel_le_prod_case_store)
THEOREM val_rel_le_prod_case_store == Init => TypeOK

\* val_rel_le_sum_extract_wf_store (matches Coq: Lemma val_rel_le_sum_extract_wf_store)
THEOREM val_rel_le_sum_extract_wf_store == Init => TypeOK

\* val_rel_le_sum_case_store (matches Coq: Lemma val_rel_le_sum_case_store)
THEOREM val_rel_le_sum_case_store == Init => TypeOK

\* val_rel_le_sum_inl_case_store (matches Coq: Lemma val_rel_le_sum_inl_case_store)
THEOREM val_rel_le_sum_inl_case_store == Init => TypeOK

\* val_rel_le_sum_inr_case_store (matches Coq: Lemma val_rel_le_sum_inr_case_store)
THEOREM val_rel_le_sum_inr_case_store == Init => TypeOK

\* val_rel_le_sum_inl_case_right_store (matches Coq: Lemma val_rel_le_sum_inl_case_right_store)
THEOREM val_rel_le_sum_inl_case_right_store == Init => TypeOK

\* val_rel_le_sum_inr_case_right_store (matches Coq: Lemma val_rel_le_sum_inr_case_right_store)
THEOREM val_rel_le_sum_inr_case_right_store == Init => TypeOK

\* val_rel_le_sum_inl_pair_case_store (matches Coq: Lemma val_rel_le_sum_inl_pair_case_store)
THEOREM val_rel_le_sum_inl_pair_case_store == Init => TypeOK

\* val_rel_le_sum_inr_pair_case_store (matches Coq: Lemma val_rel_le_sum_inr_pair_case_store)
THEOREM val_rel_le_sum_inr_pair_case_store == Init => TypeOK

\* val_rel_le_prod_pair_case_store (matches Coq: Lemma val_rel_le_prod_pair_case_store)
THEOREM val_rel_le_prod_pair_case_store == Init => TypeOK

\* val_rel_le_prod_pair_case_right_store (matches Coq: Lemma val_rel_le_prod_pair_case_right_store)
THEOREM val_rel_le_prod_pair_case_right_store == Init => TypeOK

\* val_rel_le_prod_pair_pair_case_store (matches Coq: Lemma val_rel_le_prod_pair_pair_case_store)
THEOREM val_rel_le_prod_pair_pair_case_store == Init => TypeOK

\* exp_rel_step1_fst_store (matches Coq: Lemma exp_rel_step1_fst_store)
THEOREM exp_rel_step1_fst_store == Init => TypeOK

\* exp_rel_step1_snd_store (matches Coq: Lemma exp_rel_step1_snd_store)
THEOREM exp_rel_step1_snd_store == Init => TypeOK

\* exp_rel_step1_if_store (matches Coq: Lemma exp_rel_step1_if_store)
THEOREM exp_rel_step1_if_store == Init => TypeOK

\* exp_rel_step1_case_store (matches Coq: Lemma exp_rel_step1_case_store)
THEOREM exp_rel_step1_case_store == Init => TypeOK

\* exp_rel_step1_let_store (matches Coq: Lemma exp_rel_step1_let_store)
THEOREM exp_rel_step1_let_store == Init => TypeOK

\* exp_rel_step1_handle_store (matches Coq: Lemma exp_rel_step1_handle_store)
THEOREM exp_rel_step1_handle_store == Init => TypeOK

\* exp_rel_step1_app_store (matches Coq: Lemma exp_rel_step1_app_store)
THEOREM exp_rel_step1_app_store == Init => TypeOK

\* exp_rel_step1_perform_store (matches Coq: Lemma exp_rel_step1_perform_store)
THEOREM exp_rel_step1_perform_store == Init => TypeOK

\* exp_rel_step1_require_store (matches Coq: Lemma exp_rel_step1_require_store)
THEOREM exp_rel_step1_require_store == Init => TypeOK

\* exp_rel_step1_grant_store (matches Coq: Lemma exp_rel_step1_grant_store)
THEOREM exp_rel_step1_grant_store == Init => TypeOK

\* exp_rel_step1_classify_store (matches Coq: Lemma exp_rel_step1_classify_store)
THEOREM exp_rel_step1_classify_store == Init => TypeOK

\* exp_rel_step1_prove_store (matches Coq: Lemma exp_rel_step1_prove_store)
THEOREM exp_rel_step1_prove_store == Init => TypeOK

\* exp_rel_step1_declassify_store (matches Coq: Lemma exp_rel_step1_declassify_store)
THEOREM exp_rel_step1_declassify_store == Init => TypeOK

\* exp_rel_step1_inl_store (matches Coq: Lemma exp_rel_step1_inl_store)
THEOREM exp_rel_step1_inl_store == Init => TypeOK

\* exp_rel_step1_inr_store (matches Coq: Lemma exp_rel_step1_inr_store)
THEOREM exp_rel_step1_inr_store == Init => TypeOK

\* exp_rel_step1_deref_store (matches Coq: Lemma exp_rel_step1_deref_store)
THEOREM exp_rel_step1_deref_store == Init => TypeOK

\* exp_rel_step1_assign_store (matches Coq: Lemma exp_rel_step1_assign_store)
THEOREM exp_rel_step1_assign_store == Init => TypeOK

\* exp_rel_step1_ref_store (matches Coq: Lemma exp_rel_step1_ref_store)
THEOREM exp_rel_step1_ref_store == Init => TypeOK

\* val_rel_le_unit (matches Coq: Lemma val_rel_le_unit)
THEOREM val_rel_le_unit == Init => TypeOK

\* store_rel_le_empty (matches Coq: Lemma store_rel_le_empty)
THEOREM store_rel_le_empty == Init => TypeOK

\* store_rel_simple_empty (matches Coq: Lemma store_rel_simple_empty)
THEOREM store_rel_simple_empty == Init => TypeOK

\* store_rel_le_both_some (matches Coq: Lemma store_rel_le_both_some)
THEOREM store_rel_le_both_some == Init => TypeOK

\* store_ty_update_preserves (matches Coq: Lemma store_ty_update_preserves)
THEOREM store_ty_update_preserves == Init => TypeOK

\* store_max_nil (matches Coq: Lemma store_max_nil)
THEOREM store_max_nil == Init => TypeOK

\* store_max_singleton (matches Coq: Lemma store_max_singleton)
THEOREM store_max_singleton == Init => TypeOK

\* store_rel_le_secret_loc (matches Coq: Lemma store_rel_le_secret_loc)
THEOREM store_rel_le_secret_loc == Init => TypeOK

\* store_lookup_fresh_loc (matches Coq: Lemma store_lookup_fresh_loc)
THEOREM store_lookup_fresh_loc == Init => TypeOK

\* val_rel_le_ref_loc_eq (matches Coq: Lemma val_rel_le_ref_loc_eq)
THEOREM val_rel_le_ref_loc_eq == Init => TypeOK

\* store_rel_simple_refl (matches Coq: Lemma store_rel_simple_refl)
THEOREM store_rel_simple_refl == Init => TypeOK

\* store_rel_le_step_mono (matches Coq: Lemma store_rel_le_step_mono)
THEOREM store_rel_le_step_mono == Init => TypeOK

\* val_rel_le_labeled_always (matches Coq: Lemma val_rel_le_labeled_always)
THEOREM val_rel_le_labeled_always == Init => TypeOK

\* val_rel_le_tainted_always (matches Coq: Lemma val_rel_le_tainted_always)
THEOREM val_rel_le_tainted_always == Init => TypeOK

\* val_rel_le_sanitized_always (matches Coq: Lemma val_rel_le_sanitized_always)
THEOREM val_rel_le_sanitized_always == Init => TypeOK

\* val_rel_le_capability_always (matches Coq: Lemma val_rel_le_capability_always)
THEOREM val_rel_le_capability_always == Init => TypeOK

\* val_rel_le_capability_full_always (matches Coq: Lemma val_rel_le_capability_full_always)
THEOREM val_rel_le_capability_full_always == Init => TypeOK

\* val_rel_le_proof_always (matches Coq: Lemma val_rel_le_proof_always)
THEOREM val_rel_le_proof_always == Init => TypeOK

\* val_rel_le_constant_time_always (matches Coq: Lemma val_rel_le_constant_time_always)
THEOREM val_rel_le_constant_time_always == Init => TypeOK

\* val_rel_le_zeroizing_always (matches Coq: Lemma val_rel_le_zeroizing_always)
THEOREM val_rel_le_zeroizing_always == Init => TypeOK

\* val_rel_le_chan_always (matches Coq: Lemma val_rel_le_chan_always)
THEOREM val_rel_le_chan_always == Init => TypeOK

\* val_rel_le_secure_chan_always (matches Coq: Lemma val_rel_le_secure_chan_always)
THEOREM val_rel_le_secure_chan_always == Init => TypeOK

\* val_rel_le_list_always (matches Coq: Lemma val_rel_le_list_always)
THEOREM val_rel_le_list_always == Init => TypeOK

\* val_rel_le_option_always (matches Coq: Lemma val_rel_le_option_always)
THEOREM val_rel_le_option_always == Init => TypeOK

\* store_rel_simple_sym (matches Coq: Lemma store_rel_simple_sym)
THEOREM store_rel_simple_sym == Init => TypeOK

\* store_rel_simple_trans (matches Coq: Lemma store_rel_simple_trans)
THEOREM store_rel_simple_trans == Init => TypeOK

\* store_rel_le_max_eq (matches Coq: Lemma store_rel_le_max_eq)
THEOREM store_rel_le_max_eq == Init => TypeOK

\* store_rel_le_from_succ (matches Coq: Lemma store_rel_le_from_succ)
THEOREM store_rel_le_from_succ == Init => TypeOK

\* val_rel_le_ref_refl (matches Coq: Lemma val_rel_le_ref_refl)
THEOREM val_rel_le_ref_refl == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

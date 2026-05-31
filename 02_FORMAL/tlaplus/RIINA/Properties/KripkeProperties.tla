\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE KripkeProperties ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/properties/KripkeProperties.v (134 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* val_rel_at (matches Coq: Definition val_rel_at)
val_rel_at(n, sigma, T, v1, v2) == TRUE

\* store_ty_extends_preorder (matches Coq: Lemma store_ty_extends_preorder)
THEOREM store_ty_extends_preorder == Init => TypeOK

\* val_rel_le_build_unit (matches Coq: Lemma val_rel_le_build_unit)
THEOREM val_rel_le_build_unit == Init => TypeOK

\* val_rel_le_step_up_unit (matches Coq: Lemma val_rel_le_step_up_unit)
THEOREM val_rel_le_step_up_unit == Init => TypeOK

\* val_rel_le_build_bool (matches Coq: Lemma val_rel_le_build_bool)
THEOREM val_rel_le_build_bool == Init => TypeOK

\* val_rel_le_step_up_bool (matches Coq: Lemma val_rel_le_step_up_bool)
THEOREM val_rel_le_step_up_bool == Init => TypeOK

\* val_rel_le_build_int (matches Coq: Lemma val_rel_le_build_int)
THEOREM val_rel_le_build_int == Init => TypeOK

\* val_rel_le_step_up_int (matches Coq: Lemma val_rel_le_step_up_int)
THEOREM val_rel_le_step_up_int == Init => TypeOK

\* val_rel_le_build_string (matches Coq: Lemma val_rel_le_build_string)
THEOREM val_rel_le_build_string == Init => TypeOK

\* val_rel_le_step_up_string (matches Coq: Lemma val_rel_le_step_up_string)
THEOREM val_rel_le_step_up_string == Init => TypeOK

\* val_rel_le_build_bytes (matches Coq: Lemma val_rel_le_build_bytes)
THEOREM val_rel_le_build_bytes == Init => TypeOK

\* val_rel_le_step_up_bytes (matches Coq: Lemma val_rel_le_step_up_bytes)
THEOREM val_rel_le_step_up_bytes == Init => TypeOK

\* val_rel_le_build_secret (matches Coq: Lemma val_rel_le_build_secret)
THEOREM val_rel_le_build_secret == Init => TypeOK

\* val_rel_le_step_up_secret (matches Coq: Lemma val_rel_le_step_up_secret)
THEOREM val_rel_le_step_up_secret == Init => TypeOK

\* val_rel_le_kripke_mono (matches Coq: Lemma val_rel_le_kripke_mono)
THEOREM val_rel_le_kripke_mono == Init => TypeOK

\* val_rel_le_store_preserves_step (matches Coq: Lemma val_rel_le_store_preserves_step)
THEOREM val_rel_le_store_preserves_step == Init => TypeOK

\* store_rel_le_kripke_step (matches Coq: Lemma store_rel_le_kripke_step)
THEOREM store_rel_le_kripke_step == Init => TypeOK

\* val_rel_le_includes_at (matches Coq: Lemma val_rel_le_includes_at)
THEOREM val_rel_le_includes_at == Init => TypeOK

\* val_rel_at_to_le (matches Coq: Lemma val_rel_at_to_le)
THEOREM val_rel_at_to_le == Init => TypeOK

\* val_rel_le_succ_inv (matches Coq: Lemma val_rel_le_succ_inv)
THEOREM val_rel_le_succ_inv == Init => TypeOK

\* val_rel_le_succ_intro (matches Coq: Lemma val_rel_le_succ_intro)
THEOREM val_rel_le_succ_intro == Init => TypeOK

\* val_rel_le_pos_has_prev (matches Coq: Lemma val_rel_le_pos_has_prev)
THEOREM val_rel_le_pos_has_prev == Init => TypeOK

\* val_rel_le_pos_has_struct (matches Coq: Lemma val_rel_le_pos_has_struct)
THEOREM val_rel_le_pos_has_struct == Init => TypeOK

\* val_rel_le_extract_struct_0 (matches Coq: Lemma val_rel_le_extract_struct_0)
THEOREM val_rel_le_extract_struct_0 == Init => TypeOK

\* val_rel_le_build_indist (matches Coq: Lemma val_rel_le_build_indist)
THEOREM val_rel_le_build_indist == Init => TypeOK

\* val_rel_le_step_up_fo (matches Coq: Lemma val_rel_le_step_up_fo)
THEOREM val_rel_le_step_up_fo == Init => TypeOK

\* val_rel_le_base_permanent (matches Coq: Lemma val_rel_le_base_permanent)
THEOREM val_rel_le_base_permanent == Init => TypeOK

\* val_rel_le_unit_eq (matches Coq: Lemma val_rel_le_unit_eq)
THEOREM val_rel_le_unit_eq == Init => TypeOK

\* val_rel_le_bool_eq (matches Coq: Lemma val_rel_le_bool_eq)
THEOREM val_rel_le_bool_eq == Init => TypeOK

\* val_rel_le_int_eq (matches Coq: Lemma val_rel_le_int_eq)
THEOREM val_rel_le_int_eq == Init => TypeOK

\* val_rel_le_string_eq (matches Coq: Lemma val_rel_le_string_eq)
THEOREM val_rel_le_string_eq == Init => TypeOK

\* val_rel_le_bytes_eq (matches Coq: Lemma val_rel_le_bytes_eq)
THEOREM val_rel_le_bytes_eq == Init => TypeOK

\* val_rel_le_unit_characterization (matches Coq: Lemma val_rel_le_unit_characterization)
THEOREM val_rel_le_unit_characterization == Init => TypeOK

\* val_rel_le_bool_characterization (matches Coq: Lemma val_rel_le_bool_characterization)
THEOREM val_rel_le_bool_characterization == Init => TypeOK

\* val_rel_le_int_characterization (matches Coq: Lemma val_rel_le_int_characterization)
THEOREM val_rel_le_int_characterization == Init => TypeOK

\* val_rel_le_string_characterization (matches Coq: Lemma val_rel_le_string_characterization)
THEOREM val_rel_le_string_characterization == Init => TypeOK

\* val_rel_le_bytes_characterization (matches Coq: Lemma val_rel_le_bytes_characterization)
THEOREM val_rel_le_bytes_characterization == Init => TypeOK

\* val_rel_le_unit_values_closed (matches Coq: Lemma val_rel_le_unit_values_closed)
THEOREM val_rel_le_unit_values_closed == Init => TypeOK

\* val_rel_le_bool_values_closed (matches Coq: Lemma val_rel_le_bool_values_closed)
THEOREM val_rel_le_bool_values_closed == Init => TypeOK

\* val_rel_le_int_values_closed (matches Coq: Lemma val_rel_le_int_values_closed)
THEOREM val_rel_le_int_values_closed == Init => TypeOK

\* val_rel_le_string_values_closed (matches Coq: Lemma val_rel_le_string_values_closed)
THEOREM val_rel_le_string_values_closed == Init => TypeOK

\* val_rel_le_bytes_values_closed (matches Coq: Lemma val_rel_le_bytes_values_closed)
THEOREM val_rel_le_bytes_values_closed == Init => TypeOK

\* val_rel_le_prod_components_kripke (matches Coq: Lemma val_rel_le_prod_components_kripke)
THEOREM val_rel_le_prod_components_kripke == Init => TypeOK

\* val_rel_le_sum_extract_kripke (matches Coq: Lemma val_rel_le_sum_extract_kripke)
THEOREM val_rel_le_sum_extract_kripke == Init => TypeOK

\* val_rel_le_prod_values_closed (matches Coq: Lemma val_rel_le_prod_values_closed)
THEOREM val_rel_le_prod_values_closed == Init => TypeOK

\* val_rel_le_sum_values_closed (matches Coq: Lemma val_rel_le_sum_values_closed)
THEOREM val_rel_le_sum_values_closed == Init => TypeOK

\* val_rel_le_prod_components_wf_kripke (matches Coq: Lemma val_rel_le_prod_components_wf_kripke)
THEOREM val_rel_le_prod_components_wf_kripke == Init => TypeOK

\* val_rel_le_prod_case_kripke (matches Coq: Lemma val_rel_le_prod_case_kripke)
THEOREM val_rel_le_prod_case_kripke == Init => TypeOK

\* val_rel_le_sum_extract_wf_kripke (matches Coq: Lemma val_rel_le_sum_extract_wf_kripke)
THEOREM val_rel_le_sum_extract_wf_kripke == Init => TypeOK

\* val_rel_le_sum_case_kripke (matches Coq: Lemma val_rel_le_sum_case_kripke)
THEOREM val_rel_le_sum_case_kripke == Init => TypeOK

\* val_rel_le_sum_inl_case_kripke (matches Coq: Lemma val_rel_le_sum_inl_case_kripke)
THEOREM val_rel_le_sum_inl_case_kripke == Init => TypeOK

\* val_rel_le_sum_inr_case_kripke (matches Coq: Lemma val_rel_le_sum_inr_case_kripke)
THEOREM val_rel_le_sum_inr_case_kripke == Init => TypeOK

\* val_rel_le_sum_inl_case_right_kripke (matches Coq: Lemma val_rel_le_sum_inl_case_right_kripke)
THEOREM val_rel_le_sum_inl_case_right_kripke == Init => TypeOK

\* val_rel_le_sum_inr_case_right_kripke (matches Coq: Lemma val_rel_le_sum_inr_case_right_kripke)
THEOREM val_rel_le_sum_inr_case_right_kripke == Init => TypeOK

\* val_rel_le_sum_inl_pair_case_kripke (matches Coq: Lemma val_rel_le_sum_inl_pair_case_kripke)
THEOREM val_rel_le_sum_inl_pair_case_kripke == Init => TypeOK

\* val_rel_le_sum_inr_pair_case_kripke (matches Coq: Lemma val_rel_le_sum_inr_pair_case_kripke)
THEOREM val_rel_le_sum_inr_pair_case_kripke == Init => TypeOK

\* val_rel_le_prod_pair_case_kripke (matches Coq: Lemma val_rel_le_prod_pair_case_kripke)
THEOREM val_rel_le_prod_pair_case_kripke == Init => TypeOK

\* val_rel_le_prod_pair_case_right_kripke (matches Coq: Lemma val_rel_le_prod_pair_case_right_kripke)
THEOREM val_rel_le_prod_pair_case_right_kripke == Init => TypeOK

\* val_rel_le_prod_pair_pair_case_kripke (matches Coq: Lemma val_rel_le_prod_pair_pair_case_kripke)
THEOREM val_rel_le_prod_pair_pair_case_kripke == Init => TypeOK

\* exp_rel_step1_fst_kripke (matches Coq: Lemma exp_rel_step1_fst_kripke)
THEOREM exp_rel_step1_fst_kripke == Init => TypeOK

\* exp_rel_step1_snd_kripke (matches Coq: Lemma exp_rel_step1_snd_kripke)
THEOREM exp_rel_step1_snd_kripke == Init => TypeOK

\* exp_rel_step1_if_kripke (matches Coq: Lemma exp_rel_step1_if_kripke)
THEOREM exp_rel_step1_if_kripke == Init => TypeOK

\* exp_rel_step1_case_kripke (matches Coq: Lemma exp_rel_step1_case_kripke)
THEOREM exp_rel_step1_case_kripke == Init => TypeOK

\* exp_rel_step1_let_kripke (matches Coq: Lemma exp_rel_step1_let_kripke)
THEOREM exp_rel_step1_let_kripke == Init => TypeOK

\* exp_rel_step1_handle_kripke (matches Coq: Lemma exp_rel_step1_handle_kripke)
THEOREM exp_rel_step1_handle_kripke == Init => TypeOK

\* exp_rel_step1_app_kripke (matches Coq: Lemma exp_rel_step1_app_kripke)
THEOREM exp_rel_step1_app_kripke == Init => TypeOK

\* exp_rel_step1_perform_kripke (matches Coq: Lemma exp_rel_step1_perform_kripke)
THEOREM exp_rel_step1_perform_kripke == Init => TypeOK

\* exp_rel_step1_require_kripke (matches Coq: Lemma exp_rel_step1_require_kripke)
THEOREM exp_rel_step1_require_kripke == Init => TypeOK

\* exp_rel_step1_grant_kripke (matches Coq: Lemma exp_rel_step1_grant_kripke)
THEOREM exp_rel_step1_grant_kripke == Init => TypeOK

\* exp_rel_step1_classify_kripke (matches Coq: Lemma exp_rel_step1_classify_kripke)
THEOREM exp_rel_step1_classify_kripke == Init => TypeOK

\* exp_rel_step1_prove_kripke (matches Coq: Lemma exp_rel_step1_prove_kripke)
THEOREM exp_rel_step1_prove_kripke == Init => TypeOK

\* exp_rel_step1_declassify_kripke (matches Coq: Lemma exp_rel_step1_declassify_kripke)
THEOREM exp_rel_step1_declassify_kripke == Init => TypeOK

\* val_rel_le_prod_mono_step (matches Coq: Lemma val_rel_le_prod_mono_step)
THEOREM val_rel_le_prod_mono_step == Init => TypeOK

\* val_rel_le_sum_mono_step (matches Coq: Lemma val_rel_le_sum_mono_step)
THEOREM val_rel_le_sum_mono_step == Init => TypeOK

\* val_rel_le_secret_characterization (matches Coq: Lemma val_rel_le_secret_characterization)
THEOREM val_rel_le_secret_characterization == Init => TypeOK

\* val_rel_le_labeled_characterization (matches Coq: Lemma val_rel_le_labeled_characterization)
THEOREM val_rel_le_labeled_characterization == Init => TypeOK

\* val_rel_le_tainted_characterization (matches Coq: Lemma val_rel_le_tainted_characterization)
THEOREM val_rel_le_tainted_characterization == Init => TypeOK

\* val_rel_le_sanitized_characterization (matches Coq: Lemma val_rel_le_sanitized_characterization)
THEOREM val_rel_le_sanitized_characterization == Init => TypeOK

\* val_rel_le_capability_characterization (matches Coq: Lemma val_rel_le_capability_characterization)
THEOREM val_rel_le_capability_characterization == Init => TypeOK

\* val_rel_le_capability_full_characterization (matches Coq: Lemma val_rel_le_capability_full_characterization)
THEOREM val_rel_le_capability_full_characterization == Init => TypeOK

\* val_rel_le_capability_full_values_closed (matches Coq: Lemma val_rel_le_capability_full_values_closed)
THEOREM val_rel_le_capability_full_values_closed == Init => TypeOK

\* val_rel_le_proof_characterization (matches Coq: Lemma val_rel_le_proof_characterization)
THEOREM val_rel_le_proof_characterization == Init => TypeOK

\* val_rel_le_constant_time_characterization (matches Coq: Lemma val_rel_le_constant_time_characterization)
THEOREM val_rel_le_constant_time_characterization == Init => TypeOK

\* val_rel_le_zeroizing_characterization (matches Coq: Lemma val_rel_le_zeroizing_characterization)
THEOREM val_rel_le_zeroizing_characterization == Init => TypeOK

\* val_rel_le_chan_characterization (matches Coq: Lemma val_rel_le_chan_characterization)
THEOREM val_rel_le_chan_characterization == Init => TypeOK

\* val_rel_le_chan_values_closed (matches Coq: Lemma val_rel_le_chan_values_closed)
THEOREM val_rel_le_chan_values_closed == Init => TypeOK

\* val_rel_le_secure_chan_characterization (matches Coq: Lemma val_rel_le_secure_chan_characterization)
THEOREM val_rel_le_secure_chan_characterization == Init => TypeOK

\* val_rel_le_secure_chan_values_closed (matches Coq: Lemma val_rel_le_secure_chan_values_closed)
THEOREM val_rel_le_secure_chan_values_closed == Init => TypeOK

\* val_rel_le_list_characterization (matches Coq: Lemma val_rel_le_list_characterization)
THEOREM val_rel_le_list_characterization == Init => TypeOK

\* val_rel_le_list_values_closed (matches Coq: Lemma val_rel_le_list_values_closed)
THEOREM val_rel_le_list_values_closed == Init => TypeOK

\* val_rel_le_option_characterization (matches Coq: Lemma val_rel_le_option_characterization)
THEOREM val_rel_le_option_characterization == Init => TypeOK

\* val_rel_le_option_values_closed (matches Coq: Lemma val_rel_le_option_values_closed)
THEOREM val_rel_le_option_values_closed == Init => TypeOK

\* val_rel_le_secret_values_closed (matches Coq: Lemma val_rel_le_secret_values_closed)
THEOREM val_rel_le_secret_values_closed == Init => TypeOK

\* val_rel_le_labeled_values_closed (matches Coq: Lemma val_rel_le_labeled_values_closed)
THEOREM val_rel_le_labeled_values_closed == Init => TypeOK

\* val_rel_le_tainted_values_closed (matches Coq: Lemma val_rel_le_tainted_values_closed)
THEOREM val_rel_le_tainted_values_closed == Init => TypeOK

\* val_rel_le_sanitized_values_closed (matches Coq: Lemma val_rel_le_sanitized_values_closed)
THEOREM val_rel_le_sanitized_values_closed == Init => TypeOK

\* val_rel_le_capability_values_closed (matches Coq: Lemma val_rel_le_capability_values_closed)
THEOREM val_rel_le_capability_values_closed == Init => TypeOK

\* val_rel_le_proof_values_closed (matches Coq: Lemma val_rel_le_proof_values_closed)
THEOREM val_rel_le_proof_values_closed == Init => TypeOK

\* val_rel_le_constant_time_values_closed (matches Coq: Lemma val_rel_le_constant_time_values_closed)
THEOREM val_rel_le_constant_time_values_closed == Init => TypeOK

\* val_rel_le_zeroizing_values_closed (matches Coq: Lemma val_rel_le_zeroizing_values_closed)
THEOREM val_rel_le_zeroizing_values_closed == Init => TypeOK

\* store_ty_lookup_update_neq (matches Coq: Lemma store_ty_lookup_update_neq)
THEOREM store_ty_lookup_update_neq == Init => TypeOK

\* store_ty_extends_add (matches Coq: Lemma store_ty_extends_add)
THEOREM store_ty_extends_add == Init => TypeOK

\* val_rel_le_build_labeled (matches Coq: Lemma val_rel_le_build_labeled)
THEOREM val_rel_le_build_labeled == Init => TypeOK

\* val_rel_le_step_up_labeled (matches Coq: Lemma val_rel_le_step_up_labeled)
THEOREM val_rel_le_step_up_labeled == Init => TypeOK

\* val_rel_le_build_tainted (matches Coq: Lemma val_rel_le_build_tainted)
THEOREM val_rel_le_build_tainted == Init => TypeOK

\* val_rel_le_step_up_tainted (matches Coq: Lemma val_rel_le_step_up_tainted)
THEOREM val_rel_le_step_up_tainted == Init => TypeOK

\* val_rel_le_build_sanitized (matches Coq: Lemma val_rel_le_build_sanitized)
THEOREM val_rel_le_build_sanitized == Init => TypeOK

\* val_rel_le_step_up_sanitized (matches Coq: Lemma val_rel_le_step_up_sanitized)
THEOREM val_rel_le_step_up_sanitized == Init => TypeOK

\* val_rel_le_build_proof (matches Coq: Lemma val_rel_le_build_proof)
THEOREM val_rel_le_build_proof == Init => TypeOK

\* val_rel_le_step_up_proof (matches Coq: Lemma val_rel_le_step_up_proof)
THEOREM val_rel_le_step_up_proof == Init => TypeOK

\* val_rel_le_build_ct (matches Coq: Lemma val_rel_le_build_ct)
THEOREM val_rel_le_build_ct == Init => TypeOK

\* val_rel_le_step_up_ct (matches Coq: Lemma val_rel_le_step_up_ct)
THEOREM val_rel_le_step_up_ct == Init => TypeOK

\* val_rel_le_build_zero (matches Coq: Lemma val_rel_le_build_zero)
THEOREM val_rel_le_build_zero == Init => TypeOK

\* val_rel_le_step_up_zero (matches Coq: Lemma val_rel_le_step_up_zero)
THEOREM val_rel_le_step_up_zero == Init => TypeOK

\* val_rel_le_build_cap (matches Coq: Lemma val_rel_le_build_cap)
THEOREM val_rel_le_build_cap == Init => TypeOK

\* val_rel_le_step_up_cap (matches Coq: Lemma val_rel_le_step_up_cap)
THEOREM val_rel_le_step_up_cap == Init => TypeOK

\* val_rel_le_build_cap_full (matches Coq: Lemma val_rel_le_build_cap_full)
THEOREM val_rel_le_build_cap_full == Init => TypeOK

\* val_rel_le_step_up_cap_full (matches Coq: Lemma val_rel_le_step_up_cap_full)
THEOREM val_rel_le_step_up_cap_full == Init => TypeOK

\* val_rel_le_build_list (matches Coq: Lemma val_rel_le_build_list)
THEOREM val_rel_le_build_list == Init => TypeOK

\* val_rel_le_step_up_list (matches Coq: Lemma val_rel_le_step_up_list)
THEOREM val_rel_le_step_up_list == Init => TypeOK

\* val_rel_le_build_option (matches Coq: Lemma val_rel_le_build_option)
THEOREM val_rel_le_build_option == Init => TypeOK

\* val_rel_le_step_up_option (matches Coq: Lemma val_rel_le_step_up_option)
THEOREM val_rel_le_step_up_option == Init => TypeOK

\* val_rel_le_build_prod_pair_kripke (matches Coq: Lemma val_rel_le_build_prod_pair_kripke)
THEOREM val_rel_le_build_prod_pair_kripke == Init => TypeOK

\* val_rel_le_build_sum_inl_kripke (matches Coq: Lemma val_rel_le_build_sum_inl_kripke)
THEOREM val_rel_le_build_sum_inl_kripke == Init => TypeOK

\* val_rel_le_build_sum_inr_kripke (matches Coq: Lemma val_rel_le_build_sum_inr_kripke)
THEOREM val_rel_le_build_sum_inr_kripke == Init => TypeOK

\* val_rel_le_build_chan (matches Coq: Lemma val_rel_le_build_chan)
THEOREM val_rel_le_build_chan == Init => TypeOK

\* val_rel_le_step_up_chan (matches Coq: Lemma val_rel_le_step_up_chan)
THEOREM val_rel_le_step_up_chan == Init => TypeOK

\* val_rel_le_build_secure_chan (matches Coq: Lemma val_rel_le_build_secure_chan)
THEOREM val_rel_le_build_secure_chan == Init => TypeOK

\* val_rel_le_step_up_secure_chan (matches Coq: Lemma val_rel_le_step_up_secure_chan)
THEOREM val_rel_le_step_up_secure_chan == Init => TypeOK

\* val_rel_le_build_ref_kripke (matches Coq: Lemma val_rel_le_build_ref_kripke)
THEOREM val_rel_le_build_ref_kripke == Init => TypeOK

\* val_rel_le_step_up_ref (matches Coq: Lemma val_rel_le_step_up_ref)
THEOREM val_rel_le_step_up_ref == Init => TypeOK

\* val_rel_le_ref_characterization (matches Coq: Lemma val_rel_le_ref_characterization)
THEOREM val_rel_le_ref_characterization == Init => TypeOK

\* val_rel_le_ref_values_closed (matches Coq: Lemma val_rel_le_ref_values_closed)
THEOREM val_rel_le_ref_values_closed == Init => TypeOK

\* val_rel_le_pos_values_closed_indist (matches Coq: Lemma val_rel_le_pos_values_closed_indist)
THEOREM val_rel_le_pos_values_closed_indist == Init => TypeOK

\* val_rel_le_pos_values_closed_base (matches Coq: Lemma val_rel_le_pos_values_closed_base)
THEOREM val_rel_le_pos_values_closed_base == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

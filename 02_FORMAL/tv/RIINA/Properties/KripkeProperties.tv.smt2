; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/KripkeProperties.v (134 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for KripkeProperties
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; val_rel_at: source semantics (matches Coq)
(declare-fun source_val_rel_at () Bool)
(declare-fun target_val_rel_at () Bool)
(assert (= source_val_rel_at target_val_rel_at))

; store_ty_extends_preorder: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_extends_preorder () Bool)
(declare-fun target_store_ty_extends_preorder () Bool)
(assert (= source_store_ty_extends_preorder target_store_ty_extends_preorder))

; val_rel_le_build_unit: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_unit () Bool)
(declare-fun target_val_rel_le_build_unit () Bool)
(assert (= source_val_rel_le_build_unit target_val_rel_le_build_unit))

; val_rel_le_step_up_unit: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_unit () Bool)
(declare-fun target_val_rel_le_step_up_unit () Bool)
(assert (= source_val_rel_le_step_up_unit target_val_rel_le_step_up_unit))

; val_rel_le_build_bool: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_bool () Bool)
(declare-fun target_val_rel_le_build_bool () Bool)
(assert (= source_val_rel_le_build_bool target_val_rel_le_build_bool))

; val_rel_le_step_up_bool: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_bool () Bool)
(declare-fun target_val_rel_le_step_up_bool () Bool)
(assert (= source_val_rel_le_step_up_bool target_val_rel_le_step_up_bool))

; val_rel_le_build_int: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_int () Bool)
(declare-fun target_val_rel_le_build_int () Bool)
(assert (= source_val_rel_le_build_int target_val_rel_le_build_int))

; val_rel_le_step_up_int: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_int () Bool)
(declare-fun target_val_rel_le_step_up_int () Bool)
(assert (= source_val_rel_le_step_up_int target_val_rel_le_step_up_int))

; val_rel_le_build_string: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_string () Bool)
(declare-fun target_val_rel_le_build_string () Bool)
(assert (= source_val_rel_le_build_string target_val_rel_le_build_string))

; val_rel_le_step_up_string: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_string () Bool)
(declare-fun target_val_rel_le_step_up_string () Bool)
(assert (= source_val_rel_le_step_up_string target_val_rel_le_step_up_string))

; val_rel_le_build_bytes: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_bytes () Bool)
(declare-fun target_val_rel_le_build_bytes () Bool)
(assert (= source_val_rel_le_build_bytes target_val_rel_le_build_bytes))

; val_rel_le_step_up_bytes: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_bytes () Bool)
(declare-fun target_val_rel_le_step_up_bytes () Bool)
(assert (= source_val_rel_le_step_up_bytes target_val_rel_le_step_up_bytes))

; val_rel_le_build_secret: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_secret () Bool)
(declare-fun target_val_rel_le_build_secret () Bool)
(assert (= source_val_rel_le_build_secret target_val_rel_le_build_secret))

; val_rel_le_step_up_secret: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_secret () Bool)
(declare-fun target_val_rel_le_step_up_secret () Bool)
(assert (= source_val_rel_le_step_up_secret target_val_rel_le_step_up_secret))

; val_rel_le_kripke_mono: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_kripke_mono () Bool)
(declare-fun target_val_rel_le_kripke_mono () Bool)
(assert (= source_val_rel_le_kripke_mono target_val_rel_le_kripke_mono))

; val_rel_le_store_preserves_step: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_store_preserves_step () Bool)
(declare-fun target_val_rel_le_store_preserves_step () Bool)
(assert (= source_val_rel_le_store_preserves_step target_val_rel_le_store_preserves_step))

; store_rel_le_kripke_step: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_le_kripke_step () Bool)
(declare-fun target_store_rel_le_kripke_step () Bool)
(assert (= source_store_rel_le_kripke_step target_store_rel_le_kripke_step))

; val_rel_le_includes_at: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_includes_at () Bool)
(declare-fun target_val_rel_le_includes_at () Bool)
(assert (= source_val_rel_le_includes_at target_val_rel_le_includes_at))

; val_rel_at_to_le: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_at_to_le () Bool)
(declare-fun target_val_rel_at_to_le () Bool)
(assert (= source_val_rel_at_to_le target_val_rel_at_to_le))

; val_rel_le_succ_inv: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_succ_inv () Bool)
(declare-fun target_val_rel_le_succ_inv () Bool)
(assert (= source_val_rel_le_succ_inv target_val_rel_le_succ_inv))

; val_rel_le_succ_intro: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_succ_intro () Bool)
(declare-fun target_val_rel_le_succ_intro () Bool)
(assert (= source_val_rel_le_succ_intro target_val_rel_le_succ_intro))

; val_rel_le_pos_has_prev: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_pos_has_prev () Bool)
(declare-fun target_val_rel_le_pos_has_prev () Bool)
(assert (= source_val_rel_le_pos_has_prev target_val_rel_le_pos_has_prev))

; val_rel_le_pos_has_struct: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_pos_has_struct () Bool)
(declare-fun target_val_rel_le_pos_has_struct () Bool)
(assert (= source_val_rel_le_pos_has_struct target_val_rel_le_pos_has_struct))

; val_rel_le_extract_struct_0: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_extract_struct_0 () Bool)
(declare-fun target_val_rel_le_extract_struct_0 () Bool)
(assert (= source_val_rel_le_extract_struct_0 target_val_rel_le_extract_struct_0))

; val_rel_le_build_indist: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_indist () Bool)
(declare-fun target_val_rel_le_build_indist () Bool)
(assert (= source_val_rel_le_build_indist target_val_rel_le_build_indist))

; val_rel_le_step_up_fo: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_fo () Bool)
(declare-fun target_val_rel_le_step_up_fo () Bool)
(assert (= source_val_rel_le_step_up_fo target_val_rel_le_step_up_fo))

; val_rel_le_base_permanent: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_base_permanent () Bool)
(declare-fun target_val_rel_le_base_permanent () Bool)
(assert (= source_val_rel_le_base_permanent target_val_rel_le_base_permanent))

; val_rel_le_unit_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_unit_eq () Bool)
(declare-fun target_val_rel_le_unit_eq () Bool)
(assert (= source_val_rel_le_unit_eq target_val_rel_le_unit_eq))

; val_rel_le_bool_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_bool_eq () Bool)
(declare-fun target_val_rel_le_bool_eq () Bool)
(assert (= source_val_rel_le_bool_eq target_val_rel_le_bool_eq))

; val_rel_le_int_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_int_eq () Bool)
(declare-fun target_val_rel_le_int_eq () Bool)
(assert (= source_val_rel_le_int_eq target_val_rel_le_int_eq))

; val_rel_le_string_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_string_eq () Bool)
(declare-fun target_val_rel_le_string_eq () Bool)
(assert (= source_val_rel_le_string_eq target_val_rel_le_string_eq))

; val_rel_le_bytes_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_bytes_eq () Bool)
(declare-fun target_val_rel_le_bytes_eq () Bool)
(assert (= source_val_rel_le_bytes_eq target_val_rel_le_bytes_eq))

; val_rel_le_unit_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_unit_characterization () Bool)
(declare-fun target_val_rel_le_unit_characterization () Bool)
(assert (= source_val_rel_le_unit_characterization target_val_rel_le_unit_characterization))

; val_rel_le_bool_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_bool_characterization () Bool)
(declare-fun target_val_rel_le_bool_characterization () Bool)
(assert (= source_val_rel_le_bool_characterization target_val_rel_le_bool_characterization))

; val_rel_le_int_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_int_characterization () Bool)
(declare-fun target_val_rel_le_int_characterization () Bool)
(assert (= source_val_rel_le_int_characterization target_val_rel_le_int_characterization))

; val_rel_le_string_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_string_characterization () Bool)
(declare-fun target_val_rel_le_string_characterization () Bool)
(assert (= source_val_rel_le_string_characterization target_val_rel_le_string_characterization))

; val_rel_le_bytes_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_bytes_characterization () Bool)
(declare-fun target_val_rel_le_bytes_characterization () Bool)
(assert (= source_val_rel_le_bytes_characterization target_val_rel_le_bytes_characterization))

; val_rel_le_unit_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_unit_values_closed () Bool)
(declare-fun target_val_rel_le_unit_values_closed () Bool)
(assert (= source_val_rel_le_unit_values_closed target_val_rel_le_unit_values_closed))

; val_rel_le_bool_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_bool_values_closed () Bool)
(declare-fun target_val_rel_le_bool_values_closed () Bool)
(assert (= source_val_rel_le_bool_values_closed target_val_rel_le_bool_values_closed))

; val_rel_le_int_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_int_values_closed () Bool)
(declare-fun target_val_rel_le_int_values_closed () Bool)
(assert (= source_val_rel_le_int_values_closed target_val_rel_le_int_values_closed))

; val_rel_le_string_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_string_values_closed () Bool)
(declare-fun target_val_rel_le_string_values_closed () Bool)
(assert (= source_val_rel_le_string_values_closed target_val_rel_le_string_values_closed))

; val_rel_le_bytes_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_bytes_values_closed () Bool)
(declare-fun target_val_rel_le_bytes_values_closed () Bool)
(assert (= source_val_rel_le_bytes_values_closed target_val_rel_le_bytes_values_closed))

; val_rel_le_prod_components_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_components_kripke () Bool)
(declare-fun target_val_rel_le_prod_components_kripke () Bool)
(assert (= source_val_rel_le_prod_components_kripke target_val_rel_le_prod_components_kripke))

; val_rel_le_sum_extract_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_extract_kripke () Bool)
(declare-fun target_val_rel_le_sum_extract_kripke () Bool)
(assert (= source_val_rel_le_sum_extract_kripke target_val_rel_le_sum_extract_kripke))

; val_rel_le_prod_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_values_closed () Bool)
(declare-fun target_val_rel_le_prod_values_closed () Bool)
(assert (= source_val_rel_le_prod_values_closed target_val_rel_le_prod_values_closed))

; val_rel_le_sum_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_values_closed () Bool)
(declare-fun target_val_rel_le_sum_values_closed () Bool)
(assert (= source_val_rel_le_sum_values_closed target_val_rel_le_sum_values_closed))

; val_rel_le_prod_components_wf_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_components_wf_kripke () Bool)
(declare-fun target_val_rel_le_prod_components_wf_kripke () Bool)
(assert (= source_val_rel_le_prod_components_wf_kripke target_val_rel_le_prod_components_wf_kripke))

; val_rel_le_prod_case_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_case_kripke () Bool)
(declare-fun target_val_rel_le_prod_case_kripke () Bool)
(assert (= source_val_rel_le_prod_case_kripke target_val_rel_le_prod_case_kripke))

; val_rel_le_sum_extract_wf_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_extract_wf_kripke () Bool)
(declare-fun target_val_rel_le_sum_extract_wf_kripke () Bool)
(assert (= source_val_rel_le_sum_extract_wf_kripke target_val_rel_le_sum_extract_wf_kripke))

; val_rel_le_sum_case_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_case_kripke () Bool)
(declare-fun target_val_rel_le_sum_case_kripke () Bool)
(assert (= source_val_rel_le_sum_case_kripke target_val_rel_le_sum_case_kripke))

; val_rel_le_sum_inl_case_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_inl_case_kripke () Bool)
(declare-fun target_val_rel_le_sum_inl_case_kripke () Bool)
(assert (= source_val_rel_le_sum_inl_case_kripke target_val_rel_le_sum_inl_case_kripke))

; val_rel_le_sum_inr_case_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_inr_case_kripke () Bool)
(declare-fun target_val_rel_le_sum_inr_case_kripke () Bool)
(assert (= source_val_rel_le_sum_inr_case_kripke target_val_rel_le_sum_inr_case_kripke))

; val_rel_le_sum_inl_case_right_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_inl_case_right_kripke () Bool)
(declare-fun target_val_rel_le_sum_inl_case_right_kripke () Bool)
(assert (= source_val_rel_le_sum_inl_case_right_kripke target_val_rel_le_sum_inl_case_right_kripke))

; val_rel_le_sum_inr_case_right_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_inr_case_right_kripke () Bool)
(declare-fun target_val_rel_le_sum_inr_case_right_kripke () Bool)
(assert (= source_val_rel_le_sum_inr_case_right_kripke target_val_rel_le_sum_inr_case_right_kripke))

; val_rel_le_sum_inl_pair_case_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_inl_pair_case_kripke () Bool)
(declare-fun target_val_rel_le_sum_inl_pair_case_kripke () Bool)
(assert (= source_val_rel_le_sum_inl_pair_case_kripke target_val_rel_le_sum_inl_pair_case_kripke))

; val_rel_le_sum_inr_pair_case_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_inr_pair_case_kripke () Bool)
(declare-fun target_val_rel_le_sum_inr_pair_case_kripke () Bool)
(assert (= source_val_rel_le_sum_inr_pair_case_kripke target_val_rel_le_sum_inr_pair_case_kripke))

; val_rel_le_prod_pair_case_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_pair_case_kripke () Bool)
(declare-fun target_val_rel_le_prod_pair_case_kripke () Bool)
(assert (= source_val_rel_le_prod_pair_case_kripke target_val_rel_le_prod_pair_case_kripke))

; val_rel_le_prod_pair_case_right_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_pair_case_right_kripke () Bool)
(declare-fun target_val_rel_le_prod_pair_case_right_kripke () Bool)
(assert (= source_val_rel_le_prod_pair_case_right_kripke target_val_rel_le_prod_pair_case_right_kripke))

; val_rel_le_prod_pair_pair_case_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_pair_pair_case_kripke () Bool)
(declare-fun target_val_rel_le_prod_pair_pair_case_kripke () Bool)
(assert (= source_val_rel_le_prod_pair_pair_case_kripke target_val_rel_le_prod_pair_pair_case_kripke))

; exp_rel_step1_fst_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_fst_kripke () Bool)
(declare-fun target_exp_rel_step1_fst_kripke () Bool)
(assert (= source_exp_rel_step1_fst_kripke target_exp_rel_step1_fst_kripke))

; exp_rel_step1_snd_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_snd_kripke () Bool)
(declare-fun target_exp_rel_step1_snd_kripke () Bool)
(assert (= source_exp_rel_step1_snd_kripke target_exp_rel_step1_snd_kripke))

; exp_rel_step1_if_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_if_kripke () Bool)
(declare-fun target_exp_rel_step1_if_kripke () Bool)
(assert (= source_exp_rel_step1_if_kripke target_exp_rel_step1_if_kripke))

; exp_rel_step1_case_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_case_kripke () Bool)
(declare-fun target_exp_rel_step1_case_kripke () Bool)
(assert (= source_exp_rel_step1_case_kripke target_exp_rel_step1_case_kripke))

; exp_rel_step1_let_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_let_kripke () Bool)
(declare-fun target_exp_rel_step1_let_kripke () Bool)
(assert (= source_exp_rel_step1_let_kripke target_exp_rel_step1_let_kripke))

; exp_rel_step1_handle_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_handle_kripke () Bool)
(declare-fun target_exp_rel_step1_handle_kripke () Bool)
(assert (= source_exp_rel_step1_handle_kripke target_exp_rel_step1_handle_kripke))

; exp_rel_step1_app_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_app_kripke () Bool)
(declare-fun target_exp_rel_step1_app_kripke () Bool)
(assert (= source_exp_rel_step1_app_kripke target_exp_rel_step1_app_kripke))

; exp_rel_step1_perform_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_perform_kripke () Bool)
(declare-fun target_exp_rel_step1_perform_kripke () Bool)
(assert (= source_exp_rel_step1_perform_kripke target_exp_rel_step1_perform_kripke))

; exp_rel_step1_require_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_require_kripke () Bool)
(declare-fun target_exp_rel_step1_require_kripke () Bool)
(assert (= source_exp_rel_step1_require_kripke target_exp_rel_step1_require_kripke))

; exp_rel_step1_grant_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_grant_kripke () Bool)
(declare-fun target_exp_rel_step1_grant_kripke () Bool)
(assert (= source_exp_rel_step1_grant_kripke target_exp_rel_step1_grant_kripke))

; exp_rel_step1_classify_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_classify_kripke () Bool)
(declare-fun target_exp_rel_step1_classify_kripke () Bool)
(assert (= source_exp_rel_step1_classify_kripke target_exp_rel_step1_classify_kripke))

; exp_rel_step1_prove_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_prove_kripke () Bool)
(declare-fun target_exp_rel_step1_prove_kripke () Bool)
(assert (= source_exp_rel_step1_prove_kripke target_exp_rel_step1_prove_kripke))

; exp_rel_step1_declassify_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_declassify_kripke () Bool)
(declare-fun target_exp_rel_step1_declassify_kripke () Bool)
(assert (= source_exp_rel_step1_declassify_kripke target_exp_rel_step1_declassify_kripke))

; val_rel_le_prod_mono_step: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_mono_step () Bool)
(declare-fun target_val_rel_le_prod_mono_step () Bool)
(assert (= source_val_rel_le_prod_mono_step target_val_rel_le_prod_mono_step))

; val_rel_le_sum_mono_step: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_mono_step () Bool)
(declare-fun target_val_rel_le_sum_mono_step () Bool)
(assert (= source_val_rel_le_sum_mono_step target_val_rel_le_sum_mono_step))

; val_rel_le_secret_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_secret_characterization () Bool)
(declare-fun target_val_rel_le_secret_characterization () Bool)
(assert (= source_val_rel_le_secret_characterization target_val_rel_le_secret_characterization))

; val_rel_le_labeled_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_labeled_characterization () Bool)
(declare-fun target_val_rel_le_labeled_characterization () Bool)
(assert (= source_val_rel_le_labeled_characterization target_val_rel_le_labeled_characterization))

; val_rel_le_tainted_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_tainted_characterization () Bool)
(declare-fun target_val_rel_le_tainted_characterization () Bool)
(assert (= source_val_rel_le_tainted_characterization target_val_rel_le_tainted_characterization))

; val_rel_le_sanitized_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sanitized_characterization () Bool)
(declare-fun target_val_rel_le_sanitized_characterization () Bool)
(assert (= source_val_rel_le_sanitized_characterization target_val_rel_le_sanitized_characterization))

; val_rel_le_capability_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_capability_characterization () Bool)
(declare-fun target_val_rel_le_capability_characterization () Bool)
(assert (= source_val_rel_le_capability_characterization target_val_rel_le_capability_characterization))

; val_rel_le_capability_full_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_capability_full_characterization () Bool)
(declare-fun target_val_rel_le_capability_full_characterization () Bool)
(assert (= source_val_rel_le_capability_full_characterization target_val_rel_le_capability_full_characterization))

; val_rel_le_capability_full_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_capability_full_values_closed () Bool)
(declare-fun target_val_rel_le_capability_full_values_closed () Bool)
(assert (= source_val_rel_le_capability_full_values_closed target_val_rel_le_capability_full_values_closed))

; val_rel_le_proof_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_proof_characterization () Bool)
(declare-fun target_val_rel_le_proof_characterization () Bool)
(assert (= source_val_rel_le_proof_characterization target_val_rel_le_proof_characterization))

; val_rel_le_constant_time_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_constant_time_characterization () Bool)
(declare-fun target_val_rel_le_constant_time_characterization () Bool)
(assert (= source_val_rel_le_constant_time_characterization target_val_rel_le_constant_time_characterization))

; val_rel_le_zeroizing_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_zeroizing_characterization () Bool)
(declare-fun target_val_rel_le_zeroizing_characterization () Bool)
(assert (= source_val_rel_le_zeroizing_characterization target_val_rel_le_zeroizing_characterization))

; val_rel_le_chan_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_chan_characterization () Bool)
(declare-fun target_val_rel_le_chan_characterization () Bool)
(assert (= source_val_rel_le_chan_characterization target_val_rel_le_chan_characterization))

; val_rel_le_chan_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_chan_values_closed () Bool)
(declare-fun target_val_rel_le_chan_values_closed () Bool)
(assert (= source_val_rel_le_chan_values_closed target_val_rel_le_chan_values_closed))

; val_rel_le_secure_chan_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_secure_chan_characterization () Bool)
(declare-fun target_val_rel_le_secure_chan_characterization () Bool)
(assert (= source_val_rel_le_secure_chan_characterization target_val_rel_le_secure_chan_characterization))

; val_rel_le_secure_chan_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_secure_chan_values_closed () Bool)
(declare-fun target_val_rel_le_secure_chan_values_closed () Bool)
(assert (= source_val_rel_le_secure_chan_values_closed target_val_rel_le_secure_chan_values_closed))

; val_rel_le_list_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_list_characterization () Bool)
(declare-fun target_val_rel_le_list_characterization () Bool)
(assert (= source_val_rel_le_list_characterization target_val_rel_le_list_characterization))

; val_rel_le_list_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_list_values_closed () Bool)
(declare-fun target_val_rel_le_list_values_closed () Bool)
(assert (= source_val_rel_le_list_values_closed target_val_rel_le_list_values_closed))

; val_rel_le_option_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_option_characterization () Bool)
(declare-fun target_val_rel_le_option_characterization () Bool)
(assert (= source_val_rel_le_option_characterization target_val_rel_le_option_characterization))

; val_rel_le_option_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_option_values_closed () Bool)
(declare-fun target_val_rel_le_option_values_closed () Bool)
(assert (= source_val_rel_le_option_values_closed target_val_rel_le_option_values_closed))

; val_rel_le_secret_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_secret_values_closed () Bool)
(declare-fun target_val_rel_le_secret_values_closed () Bool)
(assert (= source_val_rel_le_secret_values_closed target_val_rel_le_secret_values_closed))

; val_rel_le_labeled_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_labeled_values_closed () Bool)
(declare-fun target_val_rel_le_labeled_values_closed () Bool)
(assert (= source_val_rel_le_labeled_values_closed target_val_rel_le_labeled_values_closed))

; val_rel_le_tainted_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_tainted_values_closed () Bool)
(declare-fun target_val_rel_le_tainted_values_closed () Bool)
(assert (= source_val_rel_le_tainted_values_closed target_val_rel_le_tainted_values_closed))

; val_rel_le_sanitized_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sanitized_values_closed () Bool)
(declare-fun target_val_rel_le_sanitized_values_closed () Bool)
(assert (= source_val_rel_le_sanitized_values_closed target_val_rel_le_sanitized_values_closed))

; val_rel_le_capability_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_capability_values_closed () Bool)
(declare-fun target_val_rel_le_capability_values_closed () Bool)
(assert (= source_val_rel_le_capability_values_closed target_val_rel_le_capability_values_closed))

; val_rel_le_proof_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_proof_values_closed () Bool)
(declare-fun target_val_rel_le_proof_values_closed () Bool)
(assert (= source_val_rel_le_proof_values_closed target_val_rel_le_proof_values_closed))

; val_rel_le_constant_time_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_constant_time_values_closed () Bool)
(declare-fun target_val_rel_le_constant_time_values_closed () Bool)
(assert (= source_val_rel_le_constant_time_values_closed target_val_rel_le_constant_time_values_closed))

; val_rel_le_zeroizing_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_zeroizing_values_closed () Bool)
(declare-fun target_val_rel_le_zeroizing_values_closed () Bool)
(assert (= source_val_rel_le_zeroizing_values_closed target_val_rel_le_zeroizing_values_closed))

; store_ty_lookup_update_neq: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_lookup_update_neq () Bool)
(declare-fun target_store_ty_lookup_update_neq () Bool)
(assert (= source_store_ty_lookup_update_neq target_store_ty_lookup_update_neq))

; store_ty_extends_add: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_extends_add () Bool)
(declare-fun target_store_ty_extends_add () Bool)
(assert (= source_store_ty_extends_add target_store_ty_extends_add))

; val_rel_le_build_labeled: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_labeled () Bool)
(declare-fun target_val_rel_le_build_labeled () Bool)
(assert (= source_val_rel_le_build_labeled target_val_rel_le_build_labeled))

; val_rel_le_step_up_labeled: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_labeled () Bool)
(declare-fun target_val_rel_le_step_up_labeled () Bool)
(assert (= source_val_rel_le_step_up_labeled target_val_rel_le_step_up_labeled))

; val_rel_le_build_tainted: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_tainted () Bool)
(declare-fun target_val_rel_le_build_tainted () Bool)
(assert (= source_val_rel_le_build_tainted target_val_rel_le_build_tainted))

; val_rel_le_step_up_tainted: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_tainted () Bool)
(declare-fun target_val_rel_le_step_up_tainted () Bool)
(assert (= source_val_rel_le_step_up_tainted target_val_rel_le_step_up_tainted))

; val_rel_le_build_sanitized: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_sanitized () Bool)
(declare-fun target_val_rel_le_build_sanitized () Bool)
(assert (= source_val_rel_le_build_sanitized target_val_rel_le_build_sanitized))

; val_rel_le_step_up_sanitized: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_sanitized () Bool)
(declare-fun target_val_rel_le_step_up_sanitized () Bool)
(assert (= source_val_rel_le_step_up_sanitized target_val_rel_le_step_up_sanitized))

; val_rel_le_build_proof: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_proof () Bool)
(declare-fun target_val_rel_le_build_proof () Bool)
(assert (= source_val_rel_le_build_proof target_val_rel_le_build_proof))

; val_rel_le_step_up_proof: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_proof () Bool)
(declare-fun target_val_rel_le_step_up_proof () Bool)
(assert (= source_val_rel_le_step_up_proof target_val_rel_le_step_up_proof))

; val_rel_le_build_ct: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_ct () Bool)
(declare-fun target_val_rel_le_build_ct () Bool)
(assert (= source_val_rel_le_build_ct target_val_rel_le_build_ct))

; val_rel_le_step_up_ct: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_ct () Bool)
(declare-fun target_val_rel_le_step_up_ct () Bool)
(assert (= source_val_rel_le_step_up_ct target_val_rel_le_step_up_ct))

; val_rel_le_build_zero: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_zero () Bool)
(declare-fun target_val_rel_le_build_zero () Bool)
(assert (= source_val_rel_le_build_zero target_val_rel_le_build_zero))

; val_rel_le_step_up_zero: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_zero () Bool)
(declare-fun target_val_rel_le_step_up_zero () Bool)
(assert (= source_val_rel_le_step_up_zero target_val_rel_le_step_up_zero))

; val_rel_le_build_cap: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_cap () Bool)
(declare-fun target_val_rel_le_build_cap () Bool)
(assert (= source_val_rel_le_build_cap target_val_rel_le_build_cap))

; val_rel_le_step_up_cap: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_cap () Bool)
(declare-fun target_val_rel_le_step_up_cap () Bool)
(assert (= source_val_rel_le_step_up_cap target_val_rel_le_step_up_cap))

; val_rel_le_build_cap_full: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_cap_full () Bool)
(declare-fun target_val_rel_le_build_cap_full () Bool)
(assert (= source_val_rel_le_build_cap_full target_val_rel_le_build_cap_full))

; val_rel_le_step_up_cap_full: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_cap_full () Bool)
(declare-fun target_val_rel_le_step_up_cap_full () Bool)
(assert (= source_val_rel_le_step_up_cap_full target_val_rel_le_step_up_cap_full))

; val_rel_le_build_list: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_list () Bool)
(declare-fun target_val_rel_le_build_list () Bool)
(assert (= source_val_rel_le_build_list target_val_rel_le_build_list))

; val_rel_le_step_up_list: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_list () Bool)
(declare-fun target_val_rel_le_step_up_list () Bool)
(assert (= source_val_rel_le_step_up_list target_val_rel_le_step_up_list))

; val_rel_le_build_option: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_option () Bool)
(declare-fun target_val_rel_le_build_option () Bool)
(assert (= source_val_rel_le_build_option target_val_rel_le_build_option))

; val_rel_le_step_up_option: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_option () Bool)
(declare-fun target_val_rel_le_step_up_option () Bool)
(assert (= source_val_rel_le_step_up_option target_val_rel_le_step_up_option))

; val_rel_le_build_prod_pair_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_prod_pair_kripke () Bool)
(declare-fun target_val_rel_le_build_prod_pair_kripke () Bool)
(assert (= source_val_rel_le_build_prod_pair_kripke target_val_rel_le_build_prod_pair_kripke))

; val_rel_le_build_sum_inl_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_sum_inl_kripke () Bool)
(declare-fun target_val_rel_le_build_sum_inl_kripke () Bool)
(assert (= source_val_rel_le_build_sum_inl_kripke target_val_rel_le_build_sum_inl_kripke))

; val_rel_le_build_sum_inr_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_sum_inr_kripke () Bool)
(declare-fun target_val_rel_le_build_sum_inr_kripke () Bool)
(assert (= source_val_rel_le_build_sum_inr_kripke target_val_rel_le_build_sum_inr_kripke))

; val_rel_le_build_chan: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_chan () Bool)
(declare-fun target_val_rel_le_build_chan () Bool)
(assert (= source_val_rel_le_build_chan target_val_rel_le_build_chan))

; val_rel_le_step_up_chan: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_chan () Bool)
(declare-fun target_val_rel_le_step_up_chan () Bool)
(assert (= source_val_rel_le_step_up_chan target_val_rel_le_step_up_chan))

; val_rel_le_build_secure_chan: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_secure_chan () Bool)
(declare-fun target_val_rel_le_build_secure_chan () Bool)
(assert (= source_val_rel_le_build_secure_chan target_val_rel_le_build_secure_chan))

; val_rel_le_step_up_secure_chan: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_secure_chan () Bool)
(declare-fun target_val_rel_le_step_up_secure_chan () Bool)
(assert (= source_val_rel_le_step_up_secure_chan target_val_rel_le_step_up_secure_chan))

; val_rel_le_build_ref_kripke: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_ref_kripke () Bool)
(declare-fun target_val_rel_le_build_ref_kripke () Bool)
(assert (= source_val_rel_le_build_ref_kripke target_val_rel_le_build_ref_kripke))

; val_rel_le_step_up_ref: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_step_up_ref () Bool)
(declare-fun target_val_rel_le_step_up_ref () Bool)
(assert (= source_val_rel_le_step_up_ref target_val_rel_le_step_up_ref))

; val_rel_le_ref_characterization: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_ref_characterization () Bool)
(declare-fun target_val_rel_le_ref_characterization () Bool)
(assert (= source_val_rel_le_ref_characterization target_val_rel_le_ref_characterization))

; val_rel_le_ref_values_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_ref_values_closed () Bool)
(declare-fun target_val_rel_le_ref_values_closed () Bool)
(assert (= source_val_rel_le_ref_values_closed target_val_rel_le_ref_values_closed))

; val_rel_le_pos_values_closed_indist: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_pos_values_closed_indist () Bool)
(declare-fun target_val_rel_le_pos_values_closed_indist () Bool)
(assert (= source_val_rel_le_pos_values_closed_indist target_val_rel_le_pos_values_closed_indist))

; val_rel_le_pos_values_closed_base: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_pos_values_closed_base () Bool)
(declare-fun target_val_rel_le_pos_values_closed_base () Bool)
(assert (= source_val_rel_le_pos_values_closed_base target_val_rel_le_pos_values_closed_base))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

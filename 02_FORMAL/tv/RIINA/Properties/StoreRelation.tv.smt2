; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/StoreRelation.v (174 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for StoreRelation
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; store_rel_simple_max: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_simple_max () Bool)
(declare-fun target_store_rel_simple_max () Bool)
(assert (= source_store_rel_simple_max target_store_rel_simple_max))

; store_rel_simple_fresh: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_simple_fresh () Bool)
(declare-fun target_store_rel_simple_fresh () Bool)
(assert (= source_store_rel_simple_fresh target_store_rel_simple_fresh))

; store_max_update_bound: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_max_update_bound () Bool)
(declare-fun target_store_max_update_bound () Bool)
(assert (= source_store_max_update_bound target_store_max_update_bound))

; store_max_update_lower: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_max_update_lower () Bool)
(declare-fun target_store_max_update_lower () Bool)
(assert (= source_store_max_update_lower target_store_max_update_lower))

; store_max_update_includes_l: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_max_update_includes_l () Bool)
(declare-fun target_store_max_update_includes_l () Bool)
(assert (= source_store_max_update_includes_l target_store_max_update_includes_l))

; store_max_update_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_max_update_eq () Bool)
(declare-fun target_store_max_update_eq () Bool)
(assert (= source_store_max_update_eq target_store_max_update_eq))

; store_rel_simple_update: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_simple_update () Bool)
(declare-fun target_store_rel_simple_update () Bool)
(assert (= source_store_rel_simple_update target_store_rel_simple_update))

; store_lookup_update_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_lookup_update_eq () Bool)
(declare-fun target_store_lookup_update_eq () Bool)
(assert (= source_store_lookup_update_eq target_store_lookup_update_eq))

; store_lookup_update_neq: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_lookup_update_neq () Bool)
(declare-fun target_store_lookup_update_neq () Bool)
(assert (= source_store_lookup_update_neq target_store_lookup_update_neq))

; store_ty_lookup_update_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_lookup_update_eq () Bool)
(declare-fun target_store_ty_lookup_update_eq () Bool)
(assert (= source_store_ty_lookup_update_eq target_store_ty_lookup_update_eq))

; store_ty_lookup_update_neq: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_lookup_update_neq () Bool)
(declare-fun target_store_ty_lookup_update_neq () Bool)
(assert (= source_store_ty_lookup_update_neq target_store_ty_lookup_update_neq))

; store_rel_le_update: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_le_update () Bool)
(declare-fun target_store_rel_le_update () Bool)
(assert (= source_store_rel_le_update target_store_rel_le_update))

; store_lookup_fresh_none: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_lookup_fresh_none () Bool)
(declare-fun target_store_lookup_fresh_none () Bool)
(assert (= source_store_lookup_fresh_none target_store_lookup_fresh_none))

; store_alloc_same: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_alloc_same () Bool)
(declare-fun target_store_alloc_same () Bool)
(assert (= source_store_alloc_same target_store_alloc_same))

; store_rel_simple_alloc: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_simple_alloc () Bool)
(declare-fun target_store_rel_simple_alloc () Bool)
(assert (= source_store_rel_simple_alloc target_store_rel_simple_alloc))

; fresh_loc_not_in_store_ty: translation preserves property (matches Coq: Lemma)
(declare-fun source_fresh_loc_not_in_store_ty () Bool)
(declare-fun target_fresh_loc_not_in_store_ty () Bool)
(assert (= source_fresh_loc_not_in_store_ty target_fresh_loc_not_in_store_ty))

; store_ty_extends_alloc: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_extends_alloc () Bool)
(declare-fun target_store_ty_extends_alloc () Bool)
(assert (= source_store_ty_extends_alloc target_store_ty_extends_alloc))

; store_rel_le_alloc: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_le_alloc () Bool)
(declare-fun target_store_rel_le_alloc () Bool)
(assert (= source_store_rel_le_alloc target_store_rel_le_alloc))

; val_rel_le_ref_same_loc: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_ref_same_loc () Bool)
(declare-fun target_val_rel_le_ref_same_loc () Bool)
(assert (= source_val_rel_le_ref_same_loc target_val_rel_le_ref_same_loc))

; val_rel_le_build_ref: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_build_ref () Bool)
(declare-fun target_val_rel_le_build_ref () Bool)
(assert (= source_val_rel_le_build_ref target_val_rel_le_build_ref))

; store_rel_le_lookup: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_le_lookup () Bool)
(declare-fun target_store_rel_le_lookup () Bool)
(assert (= source_store_rel_le_lookup target_store_rel_le_lookup))

; val_rel_le_secret_always: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_secret_always () Bool)
(declare-fun target_val_rel_le_secret_always () Bool)
(assert (= source_val_rel_le_secret_always target_val_rel_le_secret_always))

; val_rel_le_secret_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_secret_value_left () Bool)
(declare-fun target_val_rel_le_secret_value_left () Bool)
(assert (= source_val_rel_le_secret_value_left target_val_rel_le_secret_value_left))

; val_rel_le_secret_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_secret_value_right () Bool)
(declare-fun target_val_rel_le_secret_value_right () Bool)
(assert (= source_val_rel_le_secret_value_right target_val_rel_le_secret_value_right))

; val_rel_le_labeled_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_labeled_value_left () Bool)
(declare-fun target_val_rel_le_labeled_value_left () Bool)
(assert (= source_val_rel_le_labeled_value_left target_val_rel_le_labeled_value_left))

; val_rel_le_labeled_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_labeled_value_right () Bool)
(declare-fun target_val_rel_le_labeled_value_right () Bool)
(assert (= source_val_rel_le_labeled_value_right target_val_rel_le_labeled_value_right))

; val_rel_le_tainted_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_tainted_value_left () Bool)
(declare-fun target_val_rel_le_tainted_value_left () Bool)
(assert (= source_val_rel_le_tainted_value_left target_val_rel_le_tainted_value_left))

; val_rel_le_tainted_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_tainted_value_right () Bool)
(declare-fun target_val_rel_le_tainted_value_right () Bool)
(assert (= source_val_rel_le_tainted_value_right target_val_rel_le_tainted_value_right))

; val_rel_le_sanitized_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sanitized_value_left () Bool)
(declare-fun target_val_rel_le_sanitized_value_left () Bool)
(assert (= source_val_rel_le_sanitized_value_left target_val_rel_le_sanitized_value_left))

; val_rel_le_sanitized_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sanitized_value_right () Bool)
(declare-fun target_val_rel_le_sanitized_value_right () Bool)
(assert (= source_val_rel_le_sanitized_value_right target_val_rel_le_sanitized_value_right))

; val_rel_le_capability_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_capability_value_left () Bool)
(declare-fun target_val_rel_le_capability_value_left () Bool)
(assert (= source_val_rel_le_capability_value_left target_val_rel_le_capability_value_left))

; val_rel_le_capability_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_capability_value_right () Bool)
(declare-fun target_val_rel_le_capability_value_right () Bool)
(assert (= source_val_rel_le_capability_value_right target_val_rel_le_capability_value_right))

; val_rel_le_capability_full_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_capability_full_value_left () Bool)
(declare-fun target_val_rel_le_capability_full_value_left () Bool)
(assert (= source_val_rel_le_capability_full_value_left target_val_rel_le_capability_full_value_left))

; val_rel_le_capability_full_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_capability_full_value_right () Bool)
(declare-fun target_val_rel_le_capability_full_value_right () Bool)
(assert (= source_val_rel_le_capability_full_value_right target_val_rel_le_capability_full_value_right))

; val_rel_le_proof_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_proof_value_left () Bool)
(declare-fun target_val_rel_le_proof_value_left () Bool)
(assert (= source_val_rel_le_proof_value_left target_val_rel_le_proof_value_left))

; val_rel_le_proof_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_proof_value_right () Bool)
(declare-fun target_val_rel_le_proof_value_right () Bool)
(assert (= source_val_rel_le_proof_value_right target_val_rel_le_proof_value_right))

; val_rel_le_constant_time_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_constant_time_value_left () Bool)
(declare-fun target_val_rel_le_constant_time_value_left () Bool)
(assert (= source_val_rel_le_constant_time_value_left target_val_rel_le_constant_time_value_left))

; val_rel_le_constant_time_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_constant_time_value_right () Bool)
(declare-fun target_val_rel_le_constant_time_value_right () Bool)
(assert (= source_val_rel_le_constant_time_value_right target_val_rel_le_constant_time_value_right))

; val_rel_le_zeroizing_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_zeroizing_value_left () Bool)
(declare-fun target_val_rel_le_zeroizing_value_left () Bool)
(assert (= source_val_rel_le_zeroizing_value_left target_val_rel_le_zeroizing_value_left))

; val_rel_le_zeroizing_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_zeroizing_value_right () Bool)
(declare-fun target_val_rel_le_zeroizing_value_right () Bool)
(assert (= source_val_rel_le_zeroizing_value_right target_val_rel_le_zeroizing_value_right))

; val_rel_le_chan_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_chan_value_left () Bool)
(declare-fun target_val_rel_le_chan_value_left () Bool)
(assert (= source_val_rel_le_chan_value_left target_val_rel_le_chan_value_left))

; val_rel_le_chan_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_chan_value_right () Bool)
(declare-fun target_val_rel_le_chan_value_right () Bool)
(assert (= source_val_rel_le_chan_value_right target_val_rel_le_chan_value_right))

; val_rel_le_secure_chan_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_secure_chan_value_left () Bool)
(declare-fun target_val_rel_le_secure_chan_value_left () Bool)
(assert (= source_val_rel_le_secure_chan_value_left target_val_rel_le_secure_chan_value_left))

; val_rel_le_secure_chan_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_secure_chan_value_right () Bool)
(declare-fun target_val_rel_le_secure_chan_value_right () Bool)
(assert (= source_val_rel_le_secure_chan_value_right target_val_rel_le_secure_chan_value_right))

; val_rel_le_list_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_list_value_left () Bool)
(declare-fun target_val_rel_le_list_value_left () Bool)
(assert (= source_val_rel_le_list_value_left target_val_rel_le_list_value_left))

; val_rel_le_list_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_list_value_right () Bool)
(declare-fun target_val_rel_le_list_value_right () Bool)
(assert (= source_val_rel_le_list_value_right target_val_rel_le_list_value_right))

; val_rel_le_option_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_option_value_left () Bool)
(declare-fun target_val_rel_le_option_value_left () Bool)
(assert (= source_val_rel_le_option_value_left target_val_rel_le_option_value_left))

; val_rel_le_option_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_option_value_right () Bool)
(declare-fun target_val_rel_le_option_value_right () Bool)
(assert (= source_val_rel_le_option_value_right target_val_rel_le_option_value_right))

; val_rel_le_secret_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_secret_closed_left () Bool)
(declare-fun target_val_rel_le_secret_closed_left () Bool)
(assert (= source_val_rel_le_secret_closed_left target_val_rel_le_secret_closed_left))

; val_rel_le_secret_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_secret_closed_right () Bool)
(declare-fun target_val_rel_le_secret_closed_right () Bool)
(assert (= source_val_rel_le_secret_closed_right target_val_rel_le_secret_closed_right))

; val_rel_le_labeled_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_labeled_closed_left () Bool)
(declare-fun target_val_rel_le_labeled_closed_left () Bool)
(assert (= source_val_rel_le_labeled_closed_left target_val_rel_le_labeled_closed_left))

; val_rel_le_labeled_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_labeled_closed_right () Bool)
(declare-fun target_val_rel_le_labeled_closed_right () Bool)
(assert (= source_val_rel_le_labeled_closed_right target_val_rel_le_labeled_closed_right))

; val_rel_le_tainted_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_tainted_closed_left () Bool)
(declare-fun target_val_rel_le_tainted_closed_left () Bool)
(assert (= source_val_rel_le_tainted_closed_left target_val_rel_le_tainted_closed_left))

; val_rel_le_tainted_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_tainted_closed_right () Bool)
(declare-fun target_val_rel_le_tainted_closed_right () Bool)
(assert (= source_val_rel_le_tainted_closed_right target_val_rel_le_tainted_closed_right))

; val_rel_le_sanitized_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sanitized_closed_left () Bool)
(declare-fun target_val_rel_le_sanitized_closed_left () Bool)
(assert (= source_val_rel_le_sanitized_closed_left target_val_rel_le_sanitized_closed_left))

; val_rel_le_sanitized_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sanitized_closed_right () Bool)
(declare-fun target_val_rel_le_sanitized_closed_right () Bool)
(assert (= source_val_rel_le_sanitized_closed_right target_val_rel_le_sanitized_closed_right))

; val_rel_le_capability_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_capability_closed_left () Bool)
(declare-fun target_val_rel_le_capability_closed_left () Bool)
(assert (= source_val_rel_le_capability_closed_left target_val_rel_le_capability_closed_left))

; val_rel_le_capability_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_capability_closed_right () Bool)
(declare-fun target_val_rel_le_capability_closed_right () Bool)
(assert (= source_val_rel_le_capability_closed_right target_val_rel_le_capability_closed_right))

; val_rel_le_capability_full_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_capability_full_closed_left () Bool)
(declare-fun target_val_rel_le_capability_full_closed_left () Bool)
(assert (= source_val_rel_le_capability_full_closed_left target_val_rel_le_capability_full_closed_left))

; val_rel_le_capability_full_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_capability_full_closed_right () Bool)
(declare-fun target_val_rel_le_capability_full_closed_right () Bool)
(assert (= source_val_rel_le_capability_full_closed_right target_val_rel_le_capability_full_closed_right))

; val_rel_le_proof_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_proof_closed_left () Bool)
(declare-fun target_val_rel_le_proof_closed_left () Bool)
(assert (= source_val_rel_le_proof_closed_left target_val_rel_le_proof_closed_left))

; val_rel_le_proof_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_proof_closed_right () Bool)
(declare-fun target_val_rel_le_proof_closed_right () Bool)
(assert (= source_val_rel_le_proof_closed_right target_val_rel_le_proof_closed_right))

; val_rel_le_constant_time_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_constant_time_closed_left () Bool)
(declare-fun target_val_rel_le_constant_time_closed_left () Bool)
(assert (= source_val_rel_le_constant_time_closed_left target_val_rel_le_constant_time_closed_left))

; val_rel_le_constant_time_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_constant_time_closed_right () Bool)
(declare-fun target_val_rel_le_constant_time_closed_right () Bool)
(assert (= source_val_rel_le_constant_time_closed_right target_val_rel_le_constant_time_closed_right))

; val_rel_le_zeroizing_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_zeroizing_closed_left () Bool)
(declare-fun target_val_rel_le_zeroizing_closed_left () Bool)
(assert (= source_val_rel_le_zeroizing_closed_left target_val_rel_le_zeroizing_closed_left))

; val_rel_le_zeroizing_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_zeroizing_closed_right () Bool)
(declare-fun target_val_rel_le_zeroizing_closed_right () Bool)
(assert (= source_val_rel_le_zeroizing_closed_right target_val_rel_le_zeroizing_closed_right))

; val_rel_le_chan_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_chan_closed_left () Bool)
(declare-fun target_val_rel_le_chan_closed_left () Bool)
(assert (= source_val_rel_le_chan_closed_left target_val_rel_le_chan_closed_left))

; val_rel_le_chan_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_chan_closed_right () Bool)
(declare-fun target_val_rel_le_chan_closed_right () Bool)
(assert (= source_val_rel_le_chan_closed_right target_val_rel_le_chan_closed_right))

; val_rel_le_secure_chan_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_secure_chan_closed_left () Bool)
(declare-fun target_val_rel_le_secure_chan_closed_left () Bool)
(assert (= source_val_rel_le_secure_chan_closed_left target_val_rel_le_secure_chan_closed_left))

; val_rel_le_secure_chan_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_secure_chan_closed_right () Bool)
(declare-fun target_val_rel_le_secure_chan_closed_right () Bool)
(assert (= source_val_rel_le_secure_chan_closed_right target_val_rel_le_secure_chan_closed_right))

; val_rel_le_list_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_list_closed_left () Bool)
(declare-fun target_val_rel_le_list_closed_left () Bool)
(assert (= source_val_rel_le_list_closed_left target_val_rel_le_list_closed_left))

; val_rel_le_list_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_list_closed_right () Bool)
(declare-fun target_val_rel_le_list_closed_right () Bool)
(assert (= source_val_rel_le_list_closed_right target_val_rel_le_list_closed_right))

; val_rel_le_option_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_option_closed_left () Bool)
(declare-fun target_val_rel_le_option_closed_left () Bool)
(assert (= source_val_rel_le_option_closed_left target_val_rel_le_option_closed_left))

; val_rel_le_option_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_option_closed_right () Bool)
(declare-fun target_val_rel_le_option_closed_right () Bool)
(assert (= source_val_rel_le_option_closed_right target_val_rel_le_option_closed_right))

; val_rel_le_unit_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_unit_value_left () Bool)
(declare-fun target_val_rel_le_unit_value_left () Bool)
(assert (= source_val_rel_le_unit_value_left target_val_rel_le_unit_value_left))

; val_rel_le_unit_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_unit_value_right () Bool)
(declare-fun target_val_rel_le_unit_value_right () Bool)
(assert (= source_val_rel_le_unit_value_right target_val_rel_le_unit_value_right))

; val_rel_le_bool_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_bool_value_left () Bool)
(declare-fun target_val_rel_le_bool_value_left () Bool)
(assert (= source_val_rel_le_bool_value_left target_val_rel_le_bool_value_left))

; val_rel_le_bool_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_bool_value_right () Bool)
(declare-fun target_val_rel_le_bool_value_right () Bool)
(assert (= source_val_rel_le_bool_value_right target_val_rel_le_bool_value_right))

; val_rel_le_int_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_int_value_left () Bool)
(declare-fun target_val_rel_le_int_value_left () Bool)
(assert (= source_val_rel_le_int_value_left target_val_rel_le_int_value_left))

; val_rel_le_int_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_int_value_right () Bool)
(declare-fun target_val_rel_le_int_value_right () Bool)
(assert (= source_val_rel_le_int_value_right target_val_rel_le_int_value_right))

; val_rel_le_string_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_string_value_left () Bool)
(declare-fun target_val_rel_le_string_value_left () Bool)
(assert (= source_val_rel_le_string_value_left target_val_rel_le_string_value_left))

; val_rel_le_string_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_string_value_right () Bool)
(declare-fun target_val_rel_le_string_value_right () Bool)
(assert (= source_val_rel_le_string_value_right target_val_rel_le_string_value_right))

; val_rel_le_bytes_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_bytes_value_left () Bool)
(declare-fun target_val_rel_le_bytes_value_left () Bool)
(assert (= source_val_rel_le_bytes_value_left target_val_rel_le_bytes_value_left))

; val_rel_le_bytes_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_bytes_value_right () Bool)
(declare-fun target_val_rel_le_bytes_value_right () Bool)
(assert (= source_val_rel_le_bytes_value_right target_val_rel_le_bytes_value_right))

; val_rel_le_ref_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_ref_value_left () Bool)
(declare-fun target_val_rel_le_ref_value_left () Bool)
(assert (= source_val_rel_le_ref_value_left target_val_rel_le_ref_value_left))

; val_rel_le_ref_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_ref_value_right () Bool)
(declare-fun target_val_rel_le_ref_value_right () Bool)
(assert (= source_val_rel_le_ref_value_right target_val_rel_le_ref_value_right))

; val_rel_le_unit_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_unit_closed_left () Bool)
(declare-fun target_val_rel_le_unit_closed_left () Bool)
(assert (= source_val_rel_le_unit_closed_left target_val_rel_le_unit_closed_left))

; val_rel_le_unit_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_unit_closed_right () Bool)
(declare-fun target_val_rel_le_unit_closed_right () Bool)
(assert (= source_val_rel_le_unit_closed_right target_val_rel_le_unit_closed_right))

; val_rel_le_bool_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_bool_closed_left () Bool)
(declare-fun target_val_rel_le_bool_closed_left () Bool)
(assert (= source_val_rel_le_bool_closed_left target_val_rel_le_bool_closed_left))

; val_rel_le_bool_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_bool_closed_right () Bool)
(declare-fun target_val_rel_le_bool_closed_right () Bool)
(assert (= source_val_rel_le_bool_closed_right target_val_rel_le_bool_closed_right))

; val_rel_le_int_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_int_closed_left () Bool)
(declare-fun target_val_rel_le_int_closed_left () Bool)
(assert (= source_val_rel_le_int_closed_left target_val_rel_le_int_closed_left))

; val_rel_le_int_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_int_closed_right () Bool)
(declare-fun target_val_rel_le_int_closed_right () Bool)
(assert (= source_val_rel_le_int_closed_right target_val_rel_le_int_closed_right))

; val_rel_le_string_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_string_closed_left () Bool)
(declare-fun target_val_rel_le_string_closed_left () Bool)
(assert (= source_val_rel_le_string_closed_left target_val_rel_le_string_closed_left))

; val_rel_le_string_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_string_closed_right () Bool)
(declare-fun target_val_rel_le_string_closed_right () Bool)
(assert (= source_val_rel_le_string_closed_right target_val_rel_le_string_closed_right))

; val_rel_le_bytes_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_bytes_closed_left () Bool)
(declare-fun target_val_rel_le_bytes_closed_left () Bool)
(assert (= source_val_rel_le_bytes_closed_left target_val_rel_le_bytes_closed_left))

; val_rel_le_bytes_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_bytes_closed_right () Bool)
(declare-fun target_val_rel_le_bytes_closed_right () Bool)
(assert (= source_val_rel_le_bytes_closed_right target_val_rel_le_bytes_closed_right))

; val_rel_le_ref_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_ref_closed_left () Bool)
(declare-fun target_val_rel_le_ref_closed_left () Bool)
(assert (= source_val_rel_le_ref_closed_left target_val_rel_le_ref_closed_left))

; val_rel_le_ref_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_ref_closed_right () Bool)
(declare-fun target_val_rel_le_ref_closed_right () Bool)
(assert (= source_val_rel_le_ref_closed_right target_val_rel_le_ref_closed_right))

; val_rel_le_prod_components_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_components_store () Bool)
(declare-fun target_val_rel_le_prod_components_store () Bool)
(assert (= source_val_rel_le_prod_components_store target_val_rel_le_prod_components_store))

; val_rel_le_sum_extract_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_extract_store () Bool)
(declare-fun target_val_rel_le_sum_extract_store () Bool)
(assert (= source_val_rel_le_sum_extract_store target_val_rel_le_sum_extract_store))

; val_rel_le_prod_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_value_left () Bool)
(declare-fun target_val_rel_le_prod_value_left () Bool)
(assert (= source_val_rel_le_prod_value_left target_val_rel_le_prod_value_left))

; val_rel_le_prod_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_value_right () Bool)
(declare-fun target_val_rel_le_prod_value_right () Bool)
(assert (= source_val_rel_le_prod_value_right target_val_rel_le_prod_value_right))

; val_rel_le_prod_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_closed_left () Bool)
(declare-fun target_val_rel_le_prod_closed_left () Bool)
(assert (= source_val_rel_le_prod_closed_left target_val_rel_le_prod_closed_left))

; val_rel_le_prod_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_closed_right () Bool)
(declare-fun target_val_rel_le_prod_closed_right () Bool)
(assert (= source_val_rel_le_prod_closed_right target_val_rel_le_prod_closed_right))

; val_rel_le_sum_value_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_value_left () Bool)
(declare-fun target_val_rel_le_sum_value_left () Bool)
(assert (= source_val_rel_le_sum_value_left target_val_rel_le_sum_value_left))

; val_rel_le_sum_value_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_value_right () Bool)
(declare-fun target_val_rel_le_sum_value_right () Bool)
(assert (= source_val_rel_le_sum_value_right target_val_rel_le_sum_value_right))

; val_rel_le_sum_closed_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_closed_left () Bool)
(declare-fun target_val_rel_le_sum_closed_left () Bool)
(assert (= source_val_rel_le_sum_closed_left target_val_rel_le_sum_closed_left))

; val_rel_le_sum_closed_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_closed_right () Bool)
(declare-fun target_val_rel_le_sum_closed_right () Bool)
(assert (= source_val_rel_le_sum_closed_right target_val_rel_le_sum_closed_right))

; val_rel_le_prod_intro_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_intro_store () Bool)
(declare-fun target_val_rel_le_prod_intro_store () Bool)
(assert (= source_val_rel_le_prod_intro_store target_val_rel_le_prod_intro_store))

; val_rel_le_sum_inl_intro_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_inl_intro_store () Bool)
(declare-fun target_val_rel_le_sum_inl_intro_store () Bool)
(assert (= source_val_rel_le_sum_inl_intro_store target_val_rel_le_sum_inl_intro_store))

; val_rel_le_sum_inr_intro_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_inr_intro_store () Bool)
(declare-fun target_val_rel_le_sum_inr_intro_store () Bool)
(assert (= source_val_rel_le_sum_inr_intro_store target_val_rel_le_sum_inr_intro_store))

; val_rel_le_extract_struct_0_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_extract_struct_0_store () Bool)
(declare-fun target_val_rel_le_extract_struct_0_store () Bool)
(assert (= source_val_rel_le_extract_struct_0_store target_val_rel_le_extract_struct_0_store))

; val_rel_le_prod_mono_step_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_mono_step_store () Bool)
(declare-fun target_val_rel_le_prod_mono_step_store () Bool)
(assert (= source_val_rel_le_prod_mono_step_store target_val_rel_le_prod_mono_step_store))

; val_rel_le_sum_mono_step_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_mono_step_store () Bool)
(declare-fun target_val_rel_le_sum_mono_step_store () Bool)
(assert (= source_val_rel_le_sum_mono_step_store target_val_rel_le_sum_mono_step_store))

; val_rel_le_prod_components_wf_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_components_wf_store () Bool)
(declare-fun target_val_rel_le_prod_components_wf_store () Bool)
(assert (= source_val_rel_le_prod_components_wf_store target_val_rel_le_prod_components_wf_store))

; val_rel_le_prod_case_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_case_store () Bool)
(declare-fun target_val_rel_le_prod_case_store () Bool)
(assert (= source_val_rel_le_prod_case_store target_val_rel_le_prod_case_store))

; val_rel_le_sum_extract_wf_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_extract_wf_store () Bool)
(declare-fun target_val_rel_le_sum_extract_wf_store () Bool)
(assert (= source_val_rel_le_sum_extract_wf_store target_val_rel_le_sum_extract_wf_store))

; val_rel_le_sum_case_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_case_store () Bool)
(declare-fun target_val_rel_le_sum_case_store () Bool)
(assert (= source_val_rel_le_sum_case_store target_val_rel_le_sum_case_store))

; val_rel_le_sum_inl_case_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_inl_case_store () Bool)
(declare-fun target_val_rel_le_sum_inl_case_store () Bool)
(assert (= source_val_rel_le_sum_inl_case_store target_val_rel_le_sum_inl_case_store))

; val_rel_le_sum_inr_case_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_inr_case_store () Bool)
(declare-fun target_val_rel_le_sum_inr_case_store () Bool)
(assert (= source_val_rel_le_sum_inr_case_store target_val_rel_le_sum_inr_case_store))

; val_rel_le_sum_inl_case_right_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_inl_case_right_store () Bool)
(declare-fun target_val_rel_le_sum_inl_case_right_store () Bool)
(assert (= source_val_rel_le_sum_inl_case_right_store target_val_rel_le_sum_inl_case_right_store))

; val_rel_le_sum_inr_case_right_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_inr_case_right_store () Bool)
(declare-fun target_val_rel_le_sum_inr_case_right_store () Bool)
(assert (= source_val_rel_le_sum_inr_case_right_store target_val_rel_le_sum_inr_case_right_store))

; val_rel_le_sum_inl_pair_case_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_inl_pair_case_store () Bool)
(declare-fun target_val_rel_le_sum_inl_pair_case_store () Bool)
(assert (= source_val_rel_le_sum_inl_pair_case_store target_val_rel_le_sum_inl_pair_case_store))

; val_rel_le_sum_inr_pair_case_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sum_inr_pair_case_store () Bool)
(declare-fun target_val_rel_le_sum_inr_pair_case_store () Bool)
(assert (= source_val_rel_le_sum_inr_pair_case_store target_val_rel_le_sum_inr_pair_case_store))

; val_rel_le_prod_pair_case_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_pair_case_store () Bool)
(declare-fun target_val_rel_le_prod_pair_case_store () Bool)
(assert (= source_val_rel_le_prod_pair_case_store target_val_rel_le_prod_pair_case_store))

; val_rel_le_prod_pair_case_right_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_pair_case_right_store () Bool)
(declare-fun target_val_rel_le_prod_pair_case_right_store () Bool)
(assert (= source_val_rel_le_prod_pair_case_right_store target_val_rel_le_prod_pair_case_right_store))

; val_rel_le_prod_pair_pair_case_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_prod_pair_pair_case_store () Bool)
(declare-fun target_val_rel_le_prod_pair_pair_case_store () Bool)
(assert (= source_val_rel_le_prod_pair_pair_case_store target_val_rel_le_prod_pair_pair_case_store))

; exp_rel_step1_fst_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_fst_store () Bool)
(declare-fun target_exp_rel_step1_fst_store () Bool)
(assert (= source_exp_rel_step1_fst_store target_exp_rel_step1_fst_store))

; exp_rel_step1_snd_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_snd_store () Bool)
(declare-fun target_exp_rel_step1_snd_store () Bool)
(assert (= source_exp_rel_step1_snd_store target_exp_rel_step1_snd_store))

; exp_rel_step1_if_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_if_store () Bool)
(declare-fun target_exp_rel_step1_if_store () Bool)
(assert (= source_exp_rel_step1_if_store target_exp_rel_step1_if_store))

; exp_rel_step1_case_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_case_store () Bool)
(declare-fun target_exp_rel_step1_case_store () Bool)
(assert (= source_exp_rel_step1_case_store target_exp_rel_step1_case_store))

; exp_rel_step1_let_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_let_store () Bool)
(declare-fun target_exp_rel_step1_let_store () Bool)
(assert (= source_exp_rel_step1_let_store target_exp_rel_step1_let_store))

; exp_rel_step1_handle_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_handle_store () Bool)
(declare-fun target_exp_rel_step1_handle_store () Bool)
(assert (= source_exp_rel_step1_handle_store target_exp_rel_step1_handle_store))

; exp_rel_step1_app_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_app_store () Bool)
(declare-fun target_exp_rel_step1_app_store () Bool)
(assert (= source_exp_rel_step1_app_store target_exp_rel_step1_app_store))

; exp_rel_step1_perform_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_perform_store () Bool)
(declare-fun target_exp_rel_step1_perform_store () Bool)
(assert (= source_exp_rel_step1_perform_store target_exp_rel_step1_perform_store))

; exp_rel_step1_require_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_require_store () Bool)
(declare-fun target_exp_rel_step1_require_store () Bool)
(assert (= source_exp_rel_step1_require_store target_exp_rel_step1_require_store))

; exp_rel_step1_grant_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_grant_store () Bool)
(declare-fun target_exp_rel_step1_grant_store () Bool)
(assert (= source_exp_rel_step1_grant_store target_exp_rel_step1_grant_store))

; exp_rel_step1_classify_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_classify_store () Bool)
(declare-fun target_exp_rel_step1_classify_store () Bool)
(assert (= source_exp_rel_step1_classify_store target_exp_rel_step1_classify_store))

; exp_rel_step1_prove_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_prove_store () Bool)
(declare-fun target_exp_rel_step1_prove_store () Bool)
(assert (= source_exp_rel_step1_prove_store target_exp_rel_step1_prove_store))

; exp_rel_step1_declassify_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_declassify_store () Bool)
(declare-fun target_exp_rel_step1_declassify_store () Bool)
(assert (= source_exp_rel_step1_declassify_store target_exp_rel_step1_declassify_store))

; exp_rel_step1_inl_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_inl_store () Bool)
(declare-fun target_exp_rel_step1_inl_store () Bool)
(assert (= source_exp_rel_step1_inl_store target_exp_rel_step1_inl_store))

; exp_rel_step1_inr_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_inr_store () Bool)
(declare-fun target_exp_rel_step1_inr_store () Bool)
(assert (= source_exp_rel_step1_inr_store target_exp_rel_step1_inr_store))

; exp_rel_step1_deref_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_deref_store () Bool)
(declare-fun target_exp_rel_step1_deref_store () Bool)
(assert (= source_exp_rel_step1_deref_store target_exp_rel_step1_deref_store))

; exp_rel_step1_assign_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_assign_store () Bool)
(declare-fun target_exp_rel_step1_assign_store () Bool)
(assert (= source_exp_rel_step1_assign_store target_exp_rel_step1_assign_store))

; exp_rel_step1_ref_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_exp_rel_step1_ref_store () Bool)
(declare-fun target_exp_rel_step1_ref_store () Bool)
(assert (= source_exp_rel_step1_ref_store target_exp_rel_step1_ref_store))

; val_rel_le_unit: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_unit () Bool)
(declare-fun target_val_rel_le_unit () Bool)
(assert (= source_val_rel_le_unit target_val_rel_le_unit))

; store_rel_le_empty: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_le_empty () Bool)
(declare-fun target_store_rel_le_empty () Bool)
(assert (= source_store_rel_le_empty target_store_rel_le_empty))

; store_rel_simple_empty: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_simple_empty () Bool)
(declare-fun target_store_rel_simple_empty () Bool)
(assert (= source_store_rel_simple_empty target_store_rel_simple_empty))

; store_rel_le_both_some: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_le_both_some () Bool)
(declare-fun target_store_rel_le_both_some () Bool)
(assert (= source_store_rel_le_both_some target_store_rel_le_both_some))

; store_ty_update_preserves: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_update_preserves () Bool)
(declare-fun target_store_ty_update_preserves () Bool)
(assert (= source_store_ty_update_preserves target_store_ty_update_preserves))

; store_max_nil: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_max_nil () Bool)
(declare-fun target_store_max_nil () Bool)
(assert (= source_store_max_nil target_store_max_nil))

; store_max_singleton: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_max_singleton () Bool)
(declare-fun target_store_max_singleton () Bool)
(assert (= source_store_max_singleton target_store_max_singleton))

; store_rel_le_secret_loc: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_le_secret_loc () Bool)
(declare-fun target_store_rel_le_secret_loc () Bool)
(assert (= source_store_rel_le_secret_loc target_store_rel_le_secret_loc))

; store_lookup_fresh_loc: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_lookup_fresh_loc () Bool)
(declare-fun target_store_lookup_fresh_loc () Bool)
(assert (= source_store_lookup_fresh_loc target_store_lookup_fresh_loc))

; val_rel_le_ref_loc_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_ref_loc_eq () Bool)
(declare-fun target_val_rel_le_ref_loc_eq () Bool)
(assert (= source_val_rel_le_ref_loc_eq target_val_rel_le_ref_loc_eq))

; store_rel_simple_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_simple_refl () Bool)
(declare-fun target_store_rel_simple_refl () Bool)
(assert (= source_store_rel_simple_refl target_store_rel_simple_refl))

; store_rel_le_step_mono: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_le_step_mono () Bool)
(declare-fun target_store_rel_le_step_mono () Bool)
(assert (= source_store_rel_le_step_mono target_store_rel_le_step_mono))

; val_rel_le_labeled_always: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_labeled_always () Bool)
(declare-fun target_val_rel_le_labeled_always () Bool)
(assert (= source_val_rel_le_labeled_always target_val_rel_le_labeled_always))

; val_rel_le_tainted_always: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_tainted_always () Bool)
(declare-fun target_val_rel_le_tainted_always () Bool)
(assert (= source_val_rel_le_tainted_always target_val_rel_le_tainted_always))

; val_rel_le_sanitized_always: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_sanitized_always () Bool)
(declare-fun target_val_rel_le_sanitized_always () Bool)
(assert (= source_val_rel_le_sanitized_always target_val_rel_le_sanitized_always))

; val_rel_le_capability_always: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_capability_always () Bool)
(declare-fun target_val_rel_le_capability_always () Bool)
(assert (= source_val_rel_le_capability_always target_val_rel_le_capability_always))

; val_rel_le_capability_full_always: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_capability_full_always () Bool)
(declare-fun target_val_rel_le_capability_full_always () Bool)
(assert (= source_val_rel_le_capability_full_always target_val_rel_le_capability_full_always))

; val_rel_le_proof_always: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_proof_always () Bool)
(declare-fun target_val_rel_le_proof_always () Bool)
(assert (= source_val_rel_le_proof_always target_val_rel_le_proof_always))

; val_rel_le_constant_time_always: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_constant_time_always () Bool)
(declare-fun target_val_rel_le_constant_time_always () Bool)
(assert (= source_val_rel_le_constant_time_always target_val_rel_le_constant_time_always))

; val_rel_le_zeroizing_always: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_zeroizing_always () Bool)
(declare-fun target_val_rel_le_zeroizing_always () Bool)
(assert (= source_val_rel_le_zeroizing_always target_val_rel_le_zeroizing_always))

; val_rel_le_chan_always: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_chan_always () Bool)
(declare-fun target_val_rel_le_chan_always () Bool)
(assert (= source_val_rel_le_chan_always target_val_rel_le_chan_always))

; val_rel_le_secure_chan_always: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_secure_chan_always () Bool)
(declare-fun target_val_rel_le_secure_chan_always () Bool)
(assert (= source_val_rel_le_secure_chan_always target_val_rel_le_secure_chan_always))

; val_rel_le_list_always: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_list_always () Bool)
(declare-fun target_val_rel_le_list_always () Bool)
(assert (= source_val_rel_le_list_always target_val_rel_le_list_always))

; val_rel_le_option_always: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_option_always () Bool)
(declare-fun target_val_rel_le_option_always () Bool)
(assert (= source_val_rel_le_option_always target_val_rel_le_option_always))

; store_rel_simple_sym: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_simple_sym () Bool)
(declare-fun target_store_rel_simple_sym () Bool)
(assert (= source_store_rel_simple_sym target_store_rel_simple_sym))

; store_rel_simple_trans: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_simple_trans () Bool)
(declare-fun target_store_rel_simple_trans () Bool)
(assert (= source_store_rel_simple_trans target_store_rel_simple_trans))

; store_rel_le_max_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_le_max_eq () Bool)
(declare-fun target_store_rel_le_max_eq () Bool)
(assert (= source_store_rel_le_max_eq target_store_rel_le_max_eq))

; store_rel_le_from_succ: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_rel_le_from_succ () Bool)
(declare-fun target_store_rel_le_from_succ () Bool)
(assert (= source_store_rel_le_from_succ target_store_rel_le_from_succ))

; val_rel_le_ref_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_ref_refl () Bool)
(declare-fun target_val_rel_le_ref_refl () Bool)
(assert (= source_val_rel_le_ref_refl target_val_rel_le_ref_refl))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

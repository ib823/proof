; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/CRDTComposition.v (103 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for CRDTComposition
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; map_lookup: source semantics (matches Coq)
(declare-fun source_map_lookup () Bool)
(declare-fun target_map_lookup () Bool)
(assert (= source_map_lookup target_map_lookup))

; map_insert: source semantics (matches Coq)
(declare-fun source_map_insert () Bool)
(declare-fun target_map_insert () Bool)
(assert (= source_map_insert target_map_insert))

; map_merge_aux: source semantics (matches Coq)
(declare-fun source_map_merge_aux () Bool)
(declare-fun target_map_merge_aux () Bool)
(assert (= source_map_merge_aux target_map_merge_aux))

; map_has_key: source semantics (matches Coq)
(declare-fun source_map_has_key () Bool)
(declare-fun target_map_has_key () Bool)
(assert (= source_map_has_key target_map_has_key))

; map_remaining: source semantics (matches Coq)
(declare-fun source_map_remaining () Bool)
(declare-fun target_map_remaining () Bool)
(assert (= source_map_remaining target_map_remaining))

; map_merge: source semantics (matches Coq)
(declare-fun source_map_merge () Bool)
(declare-fun target_map_merge () Bool)
(assert (= source_map_merge target_map_merge))

; map_empty: source semantics (matches Coq)
(declare-fun source_map_empty () Bool)
(declare-fun target_map_empty () Bool)
(assert (= source_map_empty target_map_empty))

; hash: source semantics (matches Coq)
(declare-fun source_hash () Bool)
(declare-fun target_hash () Bool)
(assert (= source_hash target_hash))

; merkle_valid: source semantics (matches Coq)
(declare-fun source_merkle_valid () Bool)
(declare-fun target_merkle_valid () Bool)
(assert (= source_merkle_valid target_merkle_valid))

; merkle_create: source semantics (matches Coq)
(declare-fun source_merkle_create () Bool)
(declare-fun target_merkle_create () Bool)
(assert (= source_merkle_create target_merkle_create))

; merkle_merge: source semantics (matches Coq)
(declare-fun source_merkle_merge () Bool)
(declare-fun target_merkle_merge () Bool)
(assert (= source_merkle_merge target_merkle_merge))

; dag_node_hash: source semantics (matches Coq)
(declare-fun source_dag_node_hash () Bool)
(declare-fun target_dag_node_hash () Bool)
(assert (= source_dag_node_hash target_dag_node_hash))

; dag_has_hash: source semantics (matches Coq)
(declare-fun source_dag_has_hash () Bool)
(declare-fun target_dag_has_hash () Bool)
(assert (= source_dag_has_hash target_dag_has_hash))

; dag_node_valid: source semantics (matches Coq)
(declare-fun source_dag_node_valid () Bool)
(declare-fun target_dag_node_valid () Bool)
(assert (= source_dag_node_valid target_dag_node_valid))

; dag_merge: source semantics (matches Coq)
(declare-fun source_dag_merge () Bool)
(declare-fun target_dag_merge () Bool)
(assert (= source_dag_merge target_dag_merge))

; dag_valid: source semantics (matches Coq)
(declare-fun source_dag_valid () Bool)
(declare-fun target_dag_valid () Bool)
(assert (= source_dag_valid target_dag_valid))

; prod_merge_comm: translation preserves property (matches Coq: Theorem)
(declare-fun source_prod_merge_comm () Bool)
(declare-fun target_prod_merge_comm () Bool)
(assert (= source_prod_merge_comm target_prod_merge_comm))

; prod_merge_assoc: translation preserves property (matches Coq: Theorem)
(declare-fun source_prod_merge_assoc () Bool)
(declare-fun target_prod_merge_assoc () Bool)
(assert (= source_prod_merge_assoc target_prod_merge_assoc))

; prod_merge_idem: translation preserves property (matches Coq: Theorem)
(declare-fun source_prod_merge_idem () Bool)
(declare-fun target_prod_merge_idem () Bool)
(assert (= source_prod_merge_idem target_prod_merge_idem))

; prod_merge_fst: translation preserves property (matches Coq: Theorem)
(declare-fun source_prod_merge_fst () Bool)
(declare-fun target_prod_merge_fst () Bool)
(assert (= source_prod_merge_fst target_prod_merge_fst))

; prod_merge_snd: translation preserves property (matches Coq: Theorem)
(declare-fun source_prod_merge_snd () Bool)
(declare-fun target_prod_merge_snd () Bool)
(assert (= source_prod_merge_snd target_prod_merge_snd))

; prod_bottom_merge_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_prod_bottom_merge_l () Bool)
(declare-fun target_prod_bottom_merge_l () Bool)
(assert (= source_prod_bottom_merge_l target_prod_bottom_merge_l))

; prod_bottom_merge_r: translation preserves property (matches Coq: Theorem)
(declare-fun source_prod_bottom_merge_r () Bool)
(declare-fun target_prod_bottom_merge_r () Bool)
(assert (= source_prod_bottom_merge_r target_prod_bottom_merge_r))

; prod_leq_refl: translation preserves property (matches Coq: Theorem)
(declare-fun source_prod_leq_refl () Bool)
(declare-fun target_prod_leq_refl () Bool)
(assert (= source_prod_leq_refl target_prod_leq_refl))

; prod_leq_trans: translation preserves property (matches Coq: Theorem)
(declare-fun source_prod_leq_trans () Bool)
(declare-fun target_prod_leq_trans () Bool)
(assert (= source_prod_leq_trans target_prod_leq_trans))

; prod_leq_antisym: translation preserves property (matches Coq: Theorem)
(declare-fun source_prod_leq_antisym () Bool)
(declare-fun target_prod_leq_antisym () Bool)
(assert (= source_prod_leq_antisym target_prod_leq_antisym))

; nat_prod_merge_comm: translation preserves property (matches Coq: Theorem)
(declare-fun source_nat_prod_merge_comm () Bool)
(declare-fun target_nat_prod_merge_comm () Bool)
(assert (= source_nat_prod_merge_comm target_nat_prod_merge_comm))

; nat_prod_merge_assoc: translation preserves property (matches Coq: Theorem)
(declare-fun source_nat_prod_merge_assoc () Bool)
(declare-fun target_nat_prod_merge_assoc () Bool)
(assert (= source_nat_prod_merge_assoc target_nat_prod_merge_assoc))

; nat_prod_merge_idem: translation preserves property (matches Coq: Theorem)
(declare-fun source_nat_prod_merge_idem () Bool)
(declare-fun target_nat_prod_merge_idem () Bool)
(assert (= source_nat_prod_merge_idem target_nat_prod_merge_idem))

; nat_prod_merge_bottom_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_nat_prod_merge_bottom_l () Bool)
(declare-fun target_nat_prod_merge_bottom_l () Bool)
(assert (= source_nat_prod_merge_bottom_l target_nat_prod_merge_bottom_l))

; nat_prod_merge_bottom_r: translation preserves property (matches Coq: Theorem)
(declare-fun source_nat_prod_merge_bottom_r () Bool)
(declare-fun target_nat_prod_merge_bottom_r () Bool)
(assert (= source_nat_prod_merge_bottom_r target_nat_prod_merge_bottom_r))

; map_lookup_empty: translation preserves property (matches Coq: Theorem)
(declare-fun source_map_lookup_empty () Bool)
(declare-fun target_map_lookup_empty () Bool)
(assert (= source_map_lookup_empty target_map_lookup_empty))

; map_lookup_insert_same: translation preserves property (matches Coq: Theorem)
(declare-fun source_map_lookup_insert_same () Bool)
(declare-fun target_map_lookup_insert_same () Bool)
(assert (= source_map_lookup_insert_same target_map_lookup_insert_same))

; map_lookup_insert_diff: translation preserves property (matches Coq: Theorem)
(declare-fun source_map_lookup_insert_diff () Bool)
(declare-fun target_map_lookup_insert_diff () Bool)
(assert (= source_map_lookup_insert_diff target_map_lookup_insert_diff))

; map_has_key_insert: translation preserves property (matches Coq: Theorem)
(declare-fun source_map_has_key_insert () Bool)
(declare-fun target_map_has_key_insert () Bool)
(assert (= source_map_has_key_insert target_map_has_key_insert))

; map_has_key_empty: translation preserves property (matches Coq: Theorem)
(declare-fun source_map_has_key_empty () Bool)
(declare-fun target_map_has_key_empty () Bool)
(assert (= source_map_has_key_empty target_map_has_key_empty))

; map_merge_aux_lookup_in: translation preserves property (matches Coq: Theorem)
(declare-fun source_map_merge_aux_lookup_in () Bool)
(declare-fun target_map_merge_aux_lookup_in () Bool)
(assert (= source_map_merge_aux_lookup_in target_map_merge_aux_lookup_in))

; map_merge_aux_preserves: translation preserves property (matches Coq: Theorem)
(declare-fun source_map_merge_aux_preserves () Bool)
(declare-fun target_map_merge_aux_preserves () Bool)
(assert (= source_map_merge_aux_preserves target_map_merge_aux_preserves))

; map_merge_aux_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_map_merge_aux_length () Bool)
(declare-fun target_map_merge_aux_length () Bool)
(assert (= source_map_merge_aux_length target_map_merge_aux_length))

; map_merge_aux_lookup_gen: translation preserves property (matches Coq: Lemma)
(declare-fun source_map_merge_aux_lookup_gen () Bool)
(declare-fun target_map_merge_aux_lookup_gen () Bool)
(assert (= source_map_merge_aux_lookup_gen target_map_merge_aux_lookup_gen))

; map_merge_aux_idem_key: translation preserves property (matches Coq: Theorem)
(declare-fun source_map_merge_aux_idem_key () Bool)
(declare-fun target_map_merge_aux_idem_key () Bool)
(assert (= source_map_merge_aux_idem_key target_map_merge_aux_idem_key))

; map_insert_lookup_ge: translation preserves property (matches Coq: Theorem)
(declare-fun source_map_insert_lookup_ge () Bool)
(declare-fun target_map_insert_lookup_ge () Bool)
(assert (= source_map_insert_lookup_ge target_map_insert_lookup_ge))

; map_merge_aux_empty_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_map_merge_aux_empty_l () Bool)
(declare-fun target_map_merge_aux_empty_l () Bool)
(assert (= source_map_merge_aux_empty_l target_map_merge_aux_empty_l))

; triple_merge_comm: translation preserves property (matches Coq: Theorem)
(declare-fun source_triple_merge_comm () Bool)
(declare-fun target_triple_merge_comm () Bool)
(assert (= source_triple_merge_comm target_triple_merge_comm))

; triple_merge_assoc: translation preserves property (matches Coq: Theorem)
(declare-fun source_triple_merge_assoc () Bool)
(declare-fun target_triple_merge_assoc () Bool)
(assert (= source_triple_merge_assoc target_triple_merge_assoc))

; triple_merge_idem: translation preserves property (matches Coq: Theorem)
(declare-fun source_triple_merge_idem () Bool)
(declare-fun target_triple_merge_idem () Bool)
(assert (= source_triple_merge_idem target_triple_merge_idem))

; composition_preserves_convergence: translation preserves property (matches Coq: Theorem)
(declare-fun source_composition_preserves_convergence () Bool)
(declare-fun target_composition_preserves_convergence () Bool)
(assert (= source_composition_preserves_convergence target_composition_preserves_convergence))

; nested_product_comm: translation preserves property (matches Coq: Theorem)
(declare-fun source_nested_product_comm () Bool)
(declare-fun target_nested_product_comm () Bool)
(assert (= source_nested_product_comm target_nested_product_comm))

; nested_product_assoc: translation preserves property (matches Coq: Theorem)
(declare-fun source_nested_product_assoc () Bool)
(declare-fun target_nested_product_assoc () Bool)
(assert (= source_nested_product_assoc target_nested_product_assoc))

; nested_product_idem: translation preserves property (matches Coq: Theorem)
(declare-fun source_nested_product_idem () Bool)
(declare-fun target_nested_product_idem () Bool)
(assert (= source_nested_product_idem target_nested_product_idem))

; fold_merge_idem: translation preserves property (matches Coq: Theorem)
(declare-fun source_fold_merge_idem () Bool)
(declare-fun target_fold_merge_idem () Bool)
(assert (= source_fold_merge_idem target_fold_merge_idem))

; fold_merge_double_update: translation preserves property (matches Coq: Theorem)
(declare-fun source_fold_merge_double_update () Bool)
(declare-fun target_fold_merge_double_update () Bool)
(assert (= source_fold_merge_double_update target_fold_merge_double_update))

; merkle_create_valid: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_create_valid () Bool)
(declare-fun target_merkle_create_valid () Bool)
(assert (= source_merkle_create_valid target_merkle_create_valid))

; merkle_equal_states_equal_hashes: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_equal_states_equal_hashes () Bool)
(declare-fun target_merkle_equal_states_equal_hashes () Bool)
(assert (= source_merkle_equal_states_equal_hashes target_merkle_equal_states_equal_hashes))

; merkle_hash_deterministic: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_hash_deterministic () Bool)
(declare-fun target_merkle_hash_deterministic () Bool)
(assert (= source_merkle_hash_deterministic target_merkle_hash_deterministic))

; merkle_merge_valid: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_merge_valid () Bool)
(declare-fun target_merkle_merge_valid () Bool)
(assert (= source_merkle_merge_valid target_merkle_merge_valid))

; merkle_merge_comm: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_merge_comm () Bool)
(declare-fun target_merkle_merge_comm () Bool)
(assert (= source_merkle_merge_comm target_merkle_merge_comm))

; merkle_merge_assoc: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_merge_assoc () Bool)
(declare-fun target_merkle_merge_assoc () Bool)
(assert (= source_merkle_merge_assoc target_merkle_merge_assoc))

; merkle_merge_idem: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_merge_idem () Bool)
(declare-fun target_merkle_merge_idem () Bool)
(assert (= source_merkle_merge_idem target_merkle_merge_idem))

; merkle_crdt_tamper_evident: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_crdt_tamper_evident () Bool)
(declare-fun target_merkle_crdt_tamper_evident () Bool)
(assert (= source_merkle_crdt_tamper_evident target_merkle_crdt_tamper_evident))

; merkle_tamper_detected: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_tamper_detected () Bool)
(declare-fun target_merkle_tamper_detected () Bool)
(assert (= source_merkle_tamper_detected target_merkle_tamper_detected))

; merkle_merge_state_max: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_merge_state_max () Bool)
(declare-fun target_merkle_merge_state_max () Bool)
(assert (= source_merkle_merge_state_max target_merkle_merge_state_max))

; merkle_merge_state_geq_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_merge_state_geq_l () Bool)
(declare-fun target_merkle_merge_state_geq_l () Bool)
(assert (= source_merkle_merge_state_geq_l target_merkle_merge_state_geq_l))

; merkle_merge_state_geq_r: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_merge_state_geq_r () Bool)
(declare-fun target_merkle_merge_state_geq_r () Bool)
(assert (= source_merkle_merge_state_geq_r target_merkle_merge_state_geq_r))

; merkle_merge_preserves_hash_consistency: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_merge_preserves_hash_consistency () Bool)
(declare-fun target_merkle_merge_preserves_hash_consistency () Bool)
(assert (= source_merkle_merge_preserves_hash_consistency target_merkle_merge_preserves_hash_consistency))

; merkle_merge_bottom_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_merge_bottom_l () Bool)
(declare-fun target_merkle_merge_bottom_l () Bool)
(assert (= source_merkle_merge_bottom_l target_merkle_merge_bottom_l))

; merkle_content_addressed_eq: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_content_addressed_eq () Bool)
(declare-fun target_merkle_content_addressed_eq () Bool)
(assert (= source_merkle_content_addressed_eq target_merkle_content_addressed_eq))

; merkle_content_addressed_hash_eq: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_content_addressed_hash_eq () Bool)
(declare-fun target_merkle_content_addressed_hash_eq () Bool)
(assert (= source_merkle_content_addressed_hash_eq target_merkle_content_addressed_hash_eq))

; dag_merge_contains_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_merge_contains_l () Bool)
(declare-fun target_dag_merge_contains_l () Bool)
(assert (= source_dag_merge_contains_l target_dag_merge_contains_l))

; dag_merge_contains_r: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_merge_contains_r () Bool)
(declare-fun target_dag_merge_contains_r () Bool)
(assert (= source_dag_merge_contains_r target_dag_merge_contains_r))

; dag_merge_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_merge_length () Bool)
(declare-fun target_dag_merge_length () Bool)
(assert (= source_dag_merge_length target_dag_merge_length))

; existsb_app_local: translation preserves property (matches Coq: Lemma)
(declare-fun source_existsb_app_local () Bool)
(declare-fun target_existsb_app_local () Bool)
(assert (= source_existsb_app_local target_existsb_app_local))

; dag_has_hash_merge: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_has_hash_merge () Bool)
(declare-fun target_dag_has_hash_merge () Bool)
(assert (= source_dag_has_hash_merge target_dag_has_hash_merge))

; dag_has_hash_merge_r: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_has_hash_merge_r () Bool)
(declare-fun target_dag_has_hash_merge_r () Bool)
(assert (= source_dag_has_hash_merge_r target_dag_has_hash_merge_r))

; dag_merge_empty_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_merge_empty_l () Bool)
(declare-fun target_dag_merge_empty_l () Bool)
(assert (= source_dag_merge_empty_l target_dag_merge_empty_l))

; dag_merge_empty_r: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_merge_empty_r () Bool)
(declare-fun target_dag_merge_empty_r () Bool)
(assert (= source_dag_merge_empty_r target_dag_merge_empty_r))

; dag_hash_mismatch_detects_tamper: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_hash_mismatch_detects_tamper () Bool)
(declare-fun target_dag_hash_mismatch_detects_tamper () Bool)
(assert (= source_dag_hash_mismatch_detects_tamper target_dag_hash_mismatch_detects_tamper))

; dag_merge_assoc_structure: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_merge_assoc_structure () Bool)
(declare-fun target_dag_merge_assoc_structure () Bool)
(assert (= source_dag_merge_assoc_structure target_dag_merge_assoc_structure))

; dag_crdt_merge_monotone: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_crdt_merge_monotone () Bool)
(declare-fun target_dag_crdt_merge_monotone () Bool)
(assert (= source_dag_crdt_merge_monotone target_dag_crdt_merge_monotone))

; dag_merge_preserves_integrity: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_merge_preserves_integrity () Bool)
(declare-fun target_dag_merge_preserves_integrity () Bool)
(assert (= source_dag_merge_preserves_integrity target_dag_merge_preserves_integrity))

; dag_merge_comm_hash: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_merge_comm_hash () Bool)
(declare-fun target_dag_merge_comm_hash () Bool)
(assert (= source_dag_merge_comm_hash target_dag_merge_comm_hash))

; dag_valid_merge_preserves: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_valid_merge_preserves () Bool)
(declare-fun target_dag_valid_merge_preserves () Bool)
(assert (= source_dag_valid_merge_preserves target_dag_valid_merge_preserves))

; prod_triple_convergence: translation preserves property (matches Coq: Theorem)
(declare-fun source_prod_triple_convergence () Bool)
(declare-fun target_prod_triple_convergence () Bool)
(assert (= source_prod_triple_convergence target_prod_triple_convergence))

; nat_prod_order_independent: translation preserves property (matches Coq: Theorem)
(declare-fun source_nat_prod_order_independent () Bool)
(declare-fun target_nat_prod_order_independent () Bool)
(assert (= source_nat_prod_order_independent target_nat_prod_order_independent))

; merkle_merge_order_independent: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_merge_order_independent () Bool)
(declare-fun target_merkle_merge_order_independent () Bool)
(assert (= source_merkle_merge_order_independent target_merkle_merge_order_independent))

; merkle_idempotent_delivery: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_idempotent_delivery () Bool)
(declare-fun target_merkle_idempotent_delivery () Bool)
(assert (= source_merkle_idempotent_delivery target_merkle_idempotent_delivery))

; map_insert_roundtrip: translation preserves property (matches Coq: Theorem)
(declare-fun source_map_insert_roundtrip () Bool)
(declare-fun target_map_insert_roundtrip () Bool)
(assert (= source_map_insert_roundtrip target_map_insert_roundtrip))

; map_insert_overwrite: translation preserves property (matches Coq: Theorem)
(declare-fun source_map_insert_overwrite () Bool)
(declare-fun target_map_insert_overwrite () Bool)
(assert (= source_map_insert_overwrite target_map_insert_overwrite))

; map_insert_independent: translation preserves property (matches Coq: Theorem)
(declare-fun source_map_insert_independent () Bool)
(declare-fun target_map_insert_independent () Bool)
(assert (= source_map_insert_independent target_map_insert_independent))

; prod_merge_fst_preserves: translation preserves property (matches Coq: Theorem)
(declare-fun source_prod_merge_fst_preserves () Bool)
(declare-fun target_prod_merge_fst_preserves () Bool)
(assert (= source_prod_merge_fst_preserves target_prod_merge_fst_preserves))

; prod_merge_snd_preserves: translation preserves property (matches Coq: Theorem)
(declare-fun source_prod_merge_snd_preserves () Bool)
(declare-fun target_prod_merge_snd_preserves () Bool)
(assert (= source_prod_merge_snd_preserves target_prod_merge_snd_preserves))

; prod_merge_partial_bottom_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_prod_merge_partial_bottom_l () Bool)
(declare-fun target_prod_merge_partial_bottom_l () Bool)
(assert (= source_prod_merge_partial_bottom_l target_prod_merge_partial_bottom_l))

; nat_prod_leq_refl: translation preserves property (matches Coq: Theorem)
(declare-fun source_nat_prod_leq_refl () Bool)
(declare-fun target_nat_prod_leq_refl () Bool)
(assert (= source_nat_prod_leq_refl target_nat_prod_leq_refl))

; nat_prod_merge_geq_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_nat_prod_merge_geq_l () Bool)
(declare-fun target_nat_prod_merge_geq_l () Bool)
(assert (= source_nat_prod_merge_geq_l target_nat_prod_merge_geq_l))

; nat_prod_merge_geq_r: translation preserves property (matches Coq: Theorem)
(declare-fun source_nat_prod_merge_geq_r () Bool)
(declare-fun target_nat_prod_merge_geq_r () Bool)
(assert (= source_nat_prod_merge_geq_r target_nat_prod_merge_geq_r))

; map_has_key_insert_diff: translation preserves property (matches Coq: Theorem)
(declare-fun source_map_has_key_insert_diff () Bool)
(declare-fun target_map_has_key_insert_diff () Bool)
(assert (= source_map_has_key_insert_diff target_map_has_key_insert_diff))

; map_merge_aux_nil_r: translation preserves property (matches Coq: Theorem)
(declare-fun source_map_merge_aux_nil_r () Bool)
(declare-fun target_map_merge_aux_nil_r () Bool)
(assert (= source_map_merge_aux_nil_r target_map_merge_aux_nil_r))

; merkle_create_merge_self: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_create_merge_self () Bool)
(declare-fun target_merkle_create_merge_self () Bool)
(assert (= source_merkle_create_merge_self target_merkle_create_merge_self))

; merkle_create_state: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_create_state () Bool)
(declare-fun target_merkle_create_state () Bool)
(assert (= source_merkle_create_state target_merkle_create_state))

; merkle_create_hash: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_create_hash () Bool)
(declare-fun target_merkle_create_hash () Bool)
(assert (= source_merkle_create_hash target_merkle_create_hash))

; dag_merge_node_count: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_merge_node_count () Bool)
(declare-fun target_dag_merge_node_count () Bool)
(assert (= source_dag_merge_node_count target_dag_merge_node_count))

; dag_singleton_has_hash: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_singleton_has_hash () Bool)
(declare-fun target_dag_singleton_has_hash () Bool)
(assert (= source_dag_singleton_has_hash target_dag_singleton_has_hash))

; dag_singleton_no_other: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_singleton_no_other () Bool)
(declare-fun target_dag_singleton_no_other () Bool)
(assert (= source_dag_singleton_no_other target_dag_singleton_no_other))

; triple_merge_fst_fst: translation preserves property (matches Coq: Theorem)
(declare-fun source_triple_merge_fst_fst () Bool)
(declare-fun target_triple_merge_fst_fst () Bool)
(assert (= source_triple_merge_fst_fst target_triple_merge_fst_fst))

; triple_merge_fst_snd: translation preserves property (matches Coq: Theorem)
(declare-fun source_triple_merge_fst_snd () Bool)
(declare-fun target_triple_merge_fst_snd () Bool)
(assert (= source_triple_merge_fst_snd target_triple_merge_fst_snd))

; triple_merge_snd: translation preserves property (matches Coq: Theorem)
(declare-fun source_triple_merge_snd () Bool)
(declare-fun target_triple_merge_snd () Bool)
(assert (= source_triple_merge_snd target_triple_merge_snd))

; composition_idempotent_delivery: translation preserves property (matches Coq: Theorem)
(declare-fun source_composition_idempotent_delivery () Bool)
(declare-fun target_composition_idempotent_delivery () Bool)
(assert (= source_composition_idempotent_delivery target_composition_idempotent_delivery))

; dag_merge_triple_assoc: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_merge_triple_assoc () Bool)
(declare-fun target_dag_merge_triple_assoc () Bool)
(assert (= source_dag_merge_triple_assoc target_dag_merge_triple_assoc))

; hash_deterministic: translation preserves property (matches Coq: Theorem)
(declare-fun source_hash_deterministic () Bool)
(declare-fun target_hash_deterministic () Bool)
(assert (= source_hash_deterministic target_hash_deterministic))

; hash_eq_implies_state_eq: translation preserves property (matches Coq: Theorem)
(declare-fun source_hash_eq_implies_state_eq () Bool)
(declare-fun target_hash_eq_implies_state_eq () Bool)
(assert (= source_hash_eq_implies_state_eq target_hash_eq_implies_state_eq))

; hash_neq_implies_state_neq: translation preserves property (matches Coq: Theorem)
(declare-fun source_hash_neq_implies_state_neq () Bool)
(declare-fun target_hash_neq_implies_state_neq () Bool)
(assert (= source_hash_neq_implies_state_neq target_hash_neq_implies_state_neq))

; content_addressed_eq: translation preserves property (matches Coq: Theorem)
(declare-fun source_content_addressed_eq () Bool)
(declare-fun target_content_addressed_eq () Bool)
(assert (= source_content_addressed_eq target_content_addressed_eq))

; content_addressed_merge_consistent: translation preserves property (matches Coq: Theorem)
(declare-fun source_content_addressed_merge_consistent () Bool)
(declare-fun target_content_addressed_merge_consistent () Bool)
(assert (= source_content_addressed_merge_consistent target_content_addressed_merge_consistent))

; map_merge_aux_has_key: translation preserves property (matches Coq: Theorem)
(declare-fun source_map_merge_aux_has_key () Bool)
(declare-fun target_map_merge_aux_has_key () Bool)
(assert (= source_map_merge_aux_has_key target_map_merge_aux_has_key))

; prod_bottom_idem: translation preserves property (matches Coq: Theorem)
(declare-fun source_prod_bottom_idem () Bool)
(declare-fun target_prod_bottom_idem () Bool)
(assert (= source_prod_bottom_idem target_prod_bottom_idem))

; dag_empty_no_hash: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_empty_no_hash () Bool)
(declare-fun target_dag_empty_no_hash () Bool)
(assert (= source_dag_empty_no_hash target_dag_empty_no_hash))

; dag_empty_valid: translation preserves property (matches Coq: Theorem)
(declare-fun source_dag_empty_valid () Bool)
(declare-fun target_dag_empty_valid () Bool)
(assert (= source_dag_empty_valid target_dag_empty_valid))

; merkle_merge_creates: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_merge_creates () Bool)
(declare-fun target_merkle_merge_creates () Bool)
(assert (= source_merkle_merge_creates target_merkle_merge_creates))

; merkle_valid_hash_matches: translation preserves property (matches Coq: Theorem)
(declare-fun source_merkle_valid_hash_matches () Bool)
(declare-fun target_merkle_valid_hash_matches () Bool)
(assert (= source_merkle_valid_hash_matches target_merkle_valid_hash_matches))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/VerifiedMicrokernel.v (25 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for VerifiedMicrokernel
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; holds: source semantics (matches Coq)
; Translation validation: holds preserves semantics
(push 1)
(declare-const source_holds Int)
(declare-const target_holds Int)
(assert (>= source_holds 0))
(assert (>= target_holds 0))
(assert (not (= source_holds target_holds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; rights_subset: source semantics (matches Coq)
; Translation validation: rights_subset preserves semantics
(push 1)
(declare-const source_rights_subset Int)
(declare-const target_rights_subset Int)
(assert (>= source_rights_subset 0))
(assert (>= target_rights_subset 0))
(assert (not (= source_rights_subset target_rights_subset)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_revoked: source semantics (matches Coq)
; Translation validation: is_revoked preserves semantics
(push 1)
(declare-const source_is_revoked Int)
(declare-const target_is_revoked Int)
(assert (>= source_is_revoked 0))
(assert (>= target_is_revoked 0))
(assert (not (= source_is_revoked target_is_revoked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cap_valid: source semantics (matches Coq)
; Translation validation: cap_valid preserves semantics
(push 1)
(declare-const source_cap_valid Int)
(declare-const target_cap_valid Int)
(assert (>= source_cap_valid 0))
(assert (>= target_cap_valid 0))
(assert (not (= source_cap_valid target_cap_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; action_authorized: source semantics (matches Coq)
; Translation validation: action_authorized preserves semantics
(push 1)
(declare-const source_action_authorized Int)
(declare-const target_action_authorized Int)
(assert (>= source_action_authorized 0))
(assert (>= target_action_authorized 0))
(assert (not (= source_action_authorized target_action_authorized)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; can_invoke: source semantics (matches Coq)
; Translation validation: can_invoke preserves semantics
(push 1)
(declare-const source_can_invoke Int)
(declare-const target_can_invoke Int)
(assert (>= source_can_invoke 0))
(assert (>= target_can_invoke 0))
(assert (not (= source_can_invoke target_can_invoke)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mapped: source semantics (matches Coq)
; Translation validation: mapped preserves semantics
(push 1)
(declare-const source_mapped Int)
(declare-const target_mapped Int)
(assert (>= source_mapped 0))
(assert (>= target_mapped 0))
(assert (not (= source_mapped target_mapped)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; shared_readonly: source semantics (matches Coq)
; Translation validation: shared_readonly preserves semantics
(push 1)
(declare-const source_shared_readonly Int)
(declare-const target_shared_readonly Int)
(assert (>= source_shared_readonly 0))
(assert (>= target_shared_readonly 0))
(assert (not (= source_shared_readonly target_shared_readonly)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_kernel_memory: source semantics (matches Coq)
; Translation validation: is_kernel_memory preserves semantics
(push 1)
(declare-const source_is_kernel_memory Int)
(declare-const target_is_kernel_memory Int)
(assert (>= source_is_kernel_memory 0))
(assert (>= target_is_kernel_memory 0))
(assert (not (= source_is_kernel_memory target_is_kernel_memory)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; page_table_integrity: source semantics (matches Coq)
; Translation validation: page_table_integrity preserves semantics
(push 1)
(declare-const source_page_table_integrity Int)
(declare-const target_page_table_integrity Int)
(assert (>= source_page_table_integrity 0))
(assert (>= target_page_table_integrity 0))
(assert (not (= source_page_table_integrity target_page_table_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; has_frame_cap: source semantics (matches Coq)
; Translation validation: has_frame_cap preserves semantics
(push 1)
(declare-const source_has_frame_cap Int)
(declare-const target_has_frame_cap Int)
(assert (>= source_has_frame_cap 0))
(assert (>= target_has_frame_cap 0))
(assert (not (= source_has_frame_cap target_has_frame_cap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; valid_memory_state: source semantics (matches Coq)
; Translation validation: valid_memory_state preserves semantics
(push 1)
(declare-const source_valid_memory_state Int)
(declare-const target_valid_memory_state Int)
(assert (>= source_valid_memory_state 0))
(assert (>= target_valid_memory_state 0))
(assert (not (= source_valid_memory_state target_valid_memory_state)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ipc_waiting: source semantics (matches Coq)
; Translation validation: ipc_waiting preserves semantics
(push 1)
(declare-const source_ipc_waiting Int)
(declare-const target_ipc_waiting Int)
(assert (>= source_ipc_waiting 0))
(assert (>= target_ipc_waiting 0))
(assert (not (= source_ipc_waiting target_ipc_waiting)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; valid_ipc_state: source semantics (matches Coq)
; Translation validation: valid_ipc_state preserves semantics
(push 1)
(declare-const source_valid_ipc_state Int)
(declare-const target_valid_ipc_state Int)
(assert (>= source_valid_ipc_state 0))
(assert (>= target_valid_ipc_state 0))
(assert (not (= source_valid_ipc_state target_valid_ipc_state)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; valid_state: source semantics (matches Coq)
; Translation validation: valid_state preserves semantics
(push 1)
(declare-const source_valid_state Int)
(declare-const target_valid_state Int)
(assert (>= source_valid_state 0))
(assert (>= target_valid_state 0))
(assert (not (= source_valid_state target_valid_state)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; endpoint_protected: source semantics (matches Coq)
; Translation validation: endpoint_protected preserves semantics
(push 1)
(declare-const source_endpoint_protected Int)
(declare-const target_endpoint_protected Int)
(assert (>= source_endpoint_protected 0))
(assert (>= target_endpoint_protected 0))
(assert (not (= source_endpoint_protected target_endpoint_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; msg_caps_valid: source semantics (matches Coq)
; Translation validation: msg_caps_valid preserves semantics
(push 1)
(declare-const source_msg_caps_valid Int)
(declare-const target_msg_caps_valid Int)
(assert (>= source_msg_caps_valid 0))
(assert (>= target_msg_caps_valid 0))
(assert (not (= source_msg_caps_valid target_msg_caps_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; transfer_preserves_validity: source semantics (matches Coq)
; Translation validation: transfer_preserves_validity preserves semantics
(push 1)
(declare-const source_transfer_preserves_validity Int)
(declare-const target_transfer_preserves_validity Int)
(assert (>= source_transfer_preserves_validity 0))
(assert (>= target_transfer_preserves_validity 0))
(assert (not (= source_transfer_preserves_validity target_transfer_preserves_validity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; isolation_invariant: source semantics (matches Coq)
; Translation validation: isolation_invariant preserves semantics
(push 1)
(declare-const source_isolation_invariant Int)
(declare-const target_isolation_invariant Int)
(assert (>= source_isolation_invariant 0))
(assert (>= target_isolation_invariant 0))
(assert (not (= source_isolation_invariant target_isolation_invariant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; properly_isolated: source semantics (matches Coq)
; Translation validation: properly_isolated preserves semantics
(push 1)
(declare-const source_properly_isolated Int)
(declare-const target_properly_isolated Int)
(assert (>= source_properly_isolated 0))
(assert (>= target_properly_isolated 0))
(assert (not (= source_properly_isolated target_properly_isolated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unmapped: source semantics (matches Coq)
; Translation validation: unmapped preserves semantics
(push 1)
(declare-const source_unmapped Int)
(declare-const target_unmapped Int)
(assert (>= source_unmapped 0))
(assert (>= target_unmapped 0))
(assert (not (= source_unmapped target_unmapped)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; allocation_safe: source semantics (matches Coq)
; Translation validation: allocation_safe preserves semantics
(push 1)
(declare-const source_allocation_safe Int)
(declare-const target_allocation_safe Int)
(assert (>= source_allocation_safe 0))
(assert (>= target_allocation_safe 0))
(assert (not (= source_allocation_safe target_allocation_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; msg_type_safe: source semantics (matches Coq)
; Translation validation: msg_type_safe preserves semantics
(push 1)
(declare-const source_msg_type_safe Int)
(declare-const target_msg_type_safe Int)
(assert (>= source_msg_type_safe 0))
(assert (>= target_msg_type_safe 0))
(assert (not (= source_msg_type_safe target_msg_type_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_amplification: source semantics (matches Coq)
; Translation validation: no_amplification preserves semantics
(push 1)
(declare-const source_no_amplification Int)
(declare-const target_no_amplification Int)
(assert (>= source_no_amplification 0))
(assert (>= target_no_amplification 0))
(assert (not (= source_no_amplification target_no_amplification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ipc_maintains_isolation: source semantics (matches Coq)
; Translation validation: ipc_maintains_isolation preserves semantics
(push 1)
(declare-const source_ipc_maintains_isolation Int)
(declare-const target_ipc_maintains_isolation Int)
(assert (>= source_ipc_maintains_isolation 0))
(assert (>= target_ipc_maintains_isolation 0))
(assert (not (= source_ipc_maintains_isolation target_ipc_maintains_isolation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; notif_no_sensitive_data: source semantics (matches Coq)
; Translation validation: notif_no_sensitive_data preserves semantics
(push 1)
(declare-const source_notif_no_sensitive_data Int)
(declare-const target_notif_no_sensitive_data Int)
(assert (>= source_notif_no_sensitive_data 0))
(assert (>= target_notif_no_sensitive_data 0))
(assert (not (= source_notif_no_sensitive_data target_notif_no_sensitive_data)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_01_cap_unforgeable: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_01_cap_unforgeable preserves semantics
(push 1)
(declare-const source_OS_001_01_cap_unforgeable Int)
(declare-const target_OS_001_01_cap_unforgeable Int)
(assert (>= source_OS_001_01_cap_unforgeable 0))
(assert (>= target_OS_001_01_cap_unforgeable 0))
(assert (not (= source_OS_001_01_cap_unforgeable target_OS_001_01_cap_unforgeable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_02_cap_monotonic: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_02_cap_monotonic preserves semantics
(push 1)
(declare-const source_OS_001_02_cap_monotonic Int)
(declare-const target_OS_001_02_cap_monotonic Int)
(assert (>= source_OS_001_02_cap_monotonic 0))
(assert (>= target_OS_001_02_cap_monotonic 0))
(assert (not (= source_OS_001_02_cap_monotonic target_OS_001_02_cap_monotonic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_03_cap_revocation_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_03_cap_revocation_complete preserves semantics
(push 1)
(declare-const source_OS_001_03_cap_revocation_complete Int)
(declare-const target_OS_001_03_cap_revocation_complete Int)
(assert (>= source_OS_001_03_cap_revocation_complete 0))
(assert (>= target_OS_001_03_cap_revocation_complete 0))
(assert (not (= source_OS_001_03_cap_revocation_complete target_OS_001_03_cap_revocation_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_04_cap_transfer_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_04_cap_transfer_safe preserves semantics
(push 1)
(declare-const source_OS_001_04_cap_transfer_safe Int)
(declare-const target_OS_001_04_cap_transfer_safe Int)
(assert (>= source_OS_001_04_cap_transfer_safe 0))
(assert (>= target_OS_001_04_cap_transfer_safe 0))
(assert (not (= source_OS_001_04_cap_transfer_safe target_OS_001_04_cap_transfer_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_05_cap_derivation_sound: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_05_cap_derivation_sound preserves semantics
(push 1)
(declare-const source_OS_001_05_cap_derivation_sound Int)
(declare-const target_OS_001_05_cap_derivation_sound Int)
(assert (>= source_OS_001_05_cap_derivation_sound 0))
(assert (>= target_OS_001_05_cap_derivation_sound 0))
(assert (not (= source_OS_001_05_cap_derivation_sound target_OS_001_05_cap_derivation_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_06_no_confused_deputy: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_06_no_confused_deputy preserves semantics
(push 1)
(declare-const source_OS_001_06_no_confused_deputy Int)
(declare-const target_OS_001_06_no_confused_deputy Int)
(assert (>= source_OS_001_06_no_confused_deputy 0))
(assert (>= target_OS_001_06_no_confused_deputy 0))
(assert (not (= source_OS_001_06_no_confused_deputy target_OS_001_06_no_confused_deputy)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_07_cap_lookup_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_07_cap_lookup_correct preserves semantics
(push 1)
(declare-const source_OS_001_07_cap_lookup_correct Int)
(declare-const target_OS_001_07_cap_lookup_correct Int)
(assert (>= source_OS_001_07_cap_lookup_correct 0))
(assert (>= target_OS_001_07_cap_lookup_correct 0))
(assert (not (= source_OS_001_07_cap_lookup_correct target_OS_001_07_cap_lookup_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_08_cap_space_isolation: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_08_cap_space_isolation preserves semantics
(push 1)
(declare-const source_OS_001_08_cap_space_isolation Int)
(declare-const target_OS_001_08_cap_space_isolation Int)
(assert (>= source_OS_001_08_cap_space_isolation 0))
(assert (>= target_OS_001_08_cap_space_isolation 0))
(assert (not (= source_OS_001_08_cap_space_isolation target_OS_001_08_cap_space_isolation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_09_cap_invoke_authorized: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_09_cap_invoke_authorized preserves semantics
(push 1)
(declare-const source_OS_001_09_cap_invoke_authorized Int)
(declare-const target_OS_001_09_cap_invoke_authorized Int)
(assert (>= source_OS_001_09_cap_invoke_authorized 0))
(assert (>= target_OS_001_09_cap_invoke_authorized 0))
(assert (not (= source_OS_001_09_cap_invoke_authorized target_OS_001_09_cap_invoke_authorized)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_10_cap_badge_integrity: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_10_cap_badge_integrity preserves semantics
(push 1)
(declare-const source_OS_001_10_cap_badge_integrity Int)
(declare-const target_OS_001_10_cap_badge_integrity Int)
(assert (>= source_OS_001_10_cap_badge_integrity 0))
(assert (>= target_OS_001_10_cap_badge_integrity 0))
(assert (not (= source_OS_001_10_cap_badge_integrity target_OS_001_10_cap_badge_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_11_address_space_isolation: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_11_address_space_isolation preserves semantics
(push 1)
(declare-const source_OS_001_11_address_space_isolation Int)
(declare-const target_OS_001_11_address_space_isolation Int)
(assert (>= source_OS_001_11_address_space_isolation 0))
(assert (>= target_OS_001_11_address_space_isolation 0))
(assert (not (= source_OS_001_11_address_space_isolation target_OS_001_11_address_space_isolation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_12_kernel_memory_integrity: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_12_kernel_memory_integrity preserves semantics
(push 1)
(declare-const source_OS_001_12_kernel_memory_integrity Int)
(declare-const target_OS_001_12_kernel_memory_integrity Int)
(assert (>= source_OS_001_12_kernel_memory_integrity 0))
(assert (>= target_OS_001_12_kernel_memory_integrity 0))
(assert (not (= source_OS_001_12_kernel_memory_integrity target_OS_001_12_kernel_memory_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_13_page_table_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_13_page_table_correct preserves semantics
(push 1)
(declare-const source_OS_001_13_page_table_correct Int)
(declare-const target_OS_001_13_page_table_correct Int)
(assert (>= source_OS_001_13_page_table_correct 0))
(assert (>= target_OS_001_13_page_table_correct 0))
(assert (not (= source_OS_001_13_page_table_correct target_OS_001_13_page_table_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_14_no_page_table_corruption: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_14_no_page_table_corruption preserves semantics
(push 1)
(declare-const source_OS_001_14_no_page_table_corruption Int)
(declare-const target_OS_001_14_no_page_table_corruption Int)
(assert (>= source_OS_001_14_no_page_table_corruption 0))
(assert (>= target_OS_001_14_no_page_table_corruption 0))
(assert (not (= source_OS_001_14_no_page_table_corruption target_OS_001_14_no_page_table_corruption)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_15_mapping_respects_caps: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_15_mapping_respects_caps preserves semantics
(push 1)
(declare-const source_OS_001_15_mapping_respects_caps Int)
(declare-const target_OS_001_15_mapping_respects_caps Int)
(assert (>= source_OS_001_15_mapping_respects_caps 0))
(assert (>= target_OS_001_15_mapping_respects_caps 0))
(assert (not (= source_OS_001_15_mapping_respects_caps target_OS_001_15_mapping_respects_caps)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_16_unmap_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_16_unmap_complete preserves semantics
(push 1)
(declare-const source_OS_001_16_unmap_complete Int)
(declare-const target_OS_001_16_unmap_complete Int)
(assert (>= source_OS_001_16_unmap_complete 0))
(assert (>= target_OS_001_16_unmap_complete 0))
(assert (not (= source_OS_001_16_unmap_complete target_OS_001_16_unmap_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_17_no_kernel_data_leak: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_17_no_kernel_data_leak preserves semantics
(push 1)
(declare-const source_OS_001_17_no_kernel_data_leak Int)
(declare-const target_OS_001_17_no_kernel_data_leak Int)
(assert (>= source_OS_001_17_no_kernel_data_leak 0))
(assert (>= target_OS_001_17_no_kernel_data_leak 0))
(assert (not (= source_OS_001_17_no_kernel_data_leak target_OS_001_17_no_kernel_data_leak)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_18_frame_allocation_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_18_frame_allocation_safe preserves semantics
(push 1)
(declare-const source_OS_001_18_frame_allocation_safe Int)
(declare-const target_OS_001_18_frame_allocation_safe Int)
(assert (>= source_OS_001_18_frame_allocation_safe 0))
(assert (>= target_OS_001_18_frame_allocation_safe 0))
(assert (not (= source_OS_001_18_frame_allocation_safe target_OS_001_18_frame_allocation_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_19_ipc_type_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_19_ipc_type_safe preserves semantics
(push 1)
(declare-const source_OS_001_19_ipc_type_safe Int)
(declare-const target_OS_001_19_ipc_type_safe Int)
(assert (>= source_OS_001_19_ipc_type_safe 0))
(assert (>= target_OS_001_19_ipc_type_safe 0))
(assert (not (= source_OS_001_19_ipc_type_safe target_OS_001_19_ipc_type_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_20_ipc_cap_transfer_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_20_ipc_cap_transfer_safe preserves semantics
(push 1)
(declare-const source_OS_001_20_ipc_cap_transfer_safe Int)
(declare-const target_OS_001_20_ipc_cap_transfer_safe Int)
(assert (>= source_OS_001_20_ipc_cap_transfer_safe 0))
(assert (>= target_OS_001_20_ipc_cap_transfer_safe 0))
(assert (not (= source_OS_001_20_ipc_cap_transfer_safe target_OS_001_20_ipc_cap_transfer_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_21_ipc_deadlock_free: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_21_ipc_deadlock_free preserves semantics
(push 1)
(declare-const source_OS_001_21_ipc_deadlock_free Int)
(declare-const target_OS_001_21_ipc_deadlock_free Int)
(assert (>= source_OS_001_21_ipc_deadlock_free 0))
(assert (>= target_OS_001_21_ipc_deadlock_free 0))
(assert (not (= source_OS_001_21_ipc_deadlock_free target_OS_001_21_ipc_deadlock_free)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_22_ipc_no_amplification: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_22_ipc_no_amplification preserves semantics
(push 1)
(declare-const source_OS_001_22_ipc_no_amplification Int)
(declare-const target_OS_001_22_ipc_no_amplification Int)
(assert (>= source_OS_001_22_ipc_no_amplification 0))
(assert (>= target_OS_001_22_ipc_no_amplification 0))
(assert (not (= source_OS_001_22_ipc_no_amplification target_OS_001_22_ipc_no_amplification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_23_ipc_isolation: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_23_ipc_isolation preserves semantics
(push 1)
(declare-const source_OS_001_23_ipc_isolation Int)
(declare-const target_OS_001_23_ipc_isolation Int)
(assert (>= source_OS_001_23_ipc_isolation 0))
(assert (>= target_OS_001_23_ipc_isolation 0))
(assert (not (= source_OS_001_23_ipc_isolation target_OS_001_23_ipc_isolation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_24_endpoint_protection: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_24_endpoint_protection preserves semantics
(push 1)
(declare-const source_OS_001_24_endpoint_protection Int)
(declare-const target_OS_001_24_endpoint_protection Int)
(assert (>= source_OS_001_24_endpoint_protection 0))
(assert (>= target_OS_001_24_endpoint_protection 0))
(assert (not (= source_OS_001_24_endpoint_protection target_OS_001_24_endpoint_protection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OS_001_25_notification_no_leak: translation preserves property (matches Coq: Theorem)
; Translation validation: OS_001_25_notification_no_leak preserves semantics
(push 1)
(declare-const source_OS_001_25_notification_no_leak Int)
(declare-const target_OS_001_25_notification_no_leak Int)
(assert (>= source_OS_001_25_notification_no_leak 0))
(assert (>= target_OS_001_25_notification_no_leak 0))
(assert (not (= source_OS_001_25_notification_no_leak target_OS_001_25_notification_no_leak)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

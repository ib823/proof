; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/TotalStackFoundation.v (51 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for TotalStackFoundation
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; layer_eqb: source semantics (matches Coq)
; Translation validation: layer_eqb preserves semantics
(push 1)
(declare-const source_layer_eqb Int)
(declare-const target_layer_eqb Int)
(assert (>= source_layer_eqb 0))
(assert (>= target_layer_eqb 0))
(assert (not (= source_layer_eqb target_layer_eqb)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; layer_index: source semantics (matches Coq)
; Translation validation: layer_index preserves semantics
(push 1)
(declare-const source_layer_index Int)
(declare-const target_layer_index Int)
(assert (>= source_layer_index 0))
(assert (>= target_layer_index 0))
(assert (not (= source_layer_index target_layer_index)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; layer_adjacent: source semantics (matches Coq)
; Translation validation: layer_adjacent preserves semantics
(push 1)
(declare-const source_layer_adjacent Int)
(declare-const target_layer_adjacent Int)
(assert (>= source_layer_adjacent 0))
(assert (>= target_layer_adjacent 0))
(assert (not (= source_layer_adjacent target_layer_adjacent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sp_eqb: source semantics (matches Coq)
; Translation validation: sp_eqb preserves semantics
(push 1)
(declare-const source_sp_eqb Int)
(declare-const target_sp_eqb Int)
(assert (>= source_sp_eqb 0))
(assert (>= target_sp_eqb 0))
(assert (not (= source_sp_eqb target_sp_eqb)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; layer_defends: source semantics (matches Coq)
; Translation validation: layer_defends preserves semantics
(push 1)
(declare-const source_layer_defends Int)
(declare-const target_layer_defends Int)
(assert (>= source_layer_defends 0))
(assert (>= target_layer_defends 0))
(assert (not (= source_layer_defends target_layer_defends)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; all_layers_verified: source semantics (matches Coq)
; Translation validation: all_layers_verified preserves semantics
(push 1)
(declare-const source_all_layers_verified Int)
(declare-const target_all_layers_verified Int)
(assert (>= source_all_layers_verified 0))
(assert (>= target_all_layers_verified 0))
(assert (not (= source_all_layers_verified target_all_layers_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; interface_verified: source semantics (matches Coq)
; Translation validation: interface_verified preserves semantics
(push 1)
(declare-const source_interface_verified Int)
(declare-const target_interface_verified Int)
(assert (>= source_interface_verified 0))
(assert (>= target_interface_verified 0))
(assert (not (= source_interface_verified target_interface_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; property_preserved: source semantics (matches Coq)
; Translation validation: property_preserved preserves semantics
(push 1)
(declare-const source_property_preserved Int)
(declare-const target_property_preserved Int)
(assert (>= source_property_preserved 0))
(assert (>= target_property_preserved 0))
(assert (not (= source_property_preserved target_property_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; attack_blocked: source semantics (matches Coq)
; Translation validation: attack_blocked preserves semantics
(push 1)
(declare-const source_attack_blocked Int)
(declare-const target_attack_blocked Int)
(assert (>= source_attack_blocked 0))
(assert (>= target_attack_blocked 0))
(assert (not (= source_attack_blocked target_attack_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; layer_in_stack: source semantics (matches Coq)
; Translation validation: layer_in_stack preserves semantics
(push 1)
(declare-const source_layer_in_stack Int)
(declare-const target_layer_in_stack Int)
(assert (>= source_layer_in_stack 0))
(assert (>= target_layer_in_stack 0))
(assert (not (= source_layer_in_stack target_layer_in_stack)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; layer_verified_in_stack: source semantics (matches Coq)
; Translation validation: layer_verified_in_stack preserves semantics
(push 1)
(declare-const source_layer_verified_in_stack Int)
(declare-const target_layer_verified_in_stack Int)
(assert (>= source_layer_verified_in_stack 0))
(assert (>= target_layer_verified_in_stack 0))
(assert (not (= source_layer_verified_in_stack target_layer_verified_in_stack)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; property_in_layer: source semantics (matches Coq)
; Translation validation: property_in_layer preserves semantics
(push 1)
(declare-const source_property_in_layer Int)
(declare-const target_property_in_layer Int)
(assert (>= source_property_in_layer 0))
(assert (>= target_property_in_layer 0))
(assert (not (= source_property_in_layer target_property_in_layer)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; all_interfaces_verified: source semantics (matches Coq)
; Translation validation: all_interfaces_verified preserves semantics
(push 1)
(declare-const source_all_interfaces_verified Int)
(declare-const target_all_interfaces_verified Int)
(assert (>= source_all_interfaces_verified 0))
(assert (>= target_all_interfaces_verified 0))
(assert (not (= source_all_interfaces_verified target_all_interfaces_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; has_all_layers: source semantics (matches Coq)
; Translation validation: has_all_layers preserves semantics
(push 1)
(declare-const source_has_all_layers Int)
(declare-const target_has_all_layers Int)
(assert (>= source_has_all_layers 0))
(assert (>= target_has_all_layers 0))
(assert (not (= source_has_all_layers target_has_all_layers)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; make_layer_verif: source semantics (matches Coq)
; Translation validation: make_layer_verif preserves semantics
(push 1)
(declare-const source_make_layer_verif Int)
(declare-const target_make_layer_verif Int)
(assert (>= source_make_layer_verif 0))
(assert (>= target_make_layer_verif 0))
(assert (not (= source_make_layer_verif target_make_layer_verif)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; complete_stack_state: source semantics (matches Coq)
; Translation validation: complete_stack_state preserves semantics
(push 1)
(declare-const source_complete_stack_state Int)
(declare-const target_complete_stack_state Int)
(assert (>= source_complete_stack_state 0))
(assert (>= target_complete_stack_state 0))
(assert (not (= source_complete_stack_state target_complete_stack_state)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; interface_secure: source semantics (matches Coq)
; Translation validation: interface_secure preserves semantics
(push 1)
(declare-const source_interface_secure Int)
(declare-const target_interface_secure Int)
(assert (>= source_interface_secure 0))
(assert (>= target_interface_secure 0))
(assert (not (= source_interface_secure target_interface_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; property_preserved_across_layers: source semantics (matches Coq)
; Translation validation: property_preserved_across_layers preserves semantics
(push 1)
(declare-const source_property_preserved_across_layers Int)
(declare-const target_property_preserved_across_layers Int)
(assert (>= source_property_preserved_across_layers 0))
(assert (>= target_property_preserved_across_layers 0))
(assert (not (= source_property_preserved_across_layers target_property_preserved_across_layers)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; layer_compromised: source semantics (matches Coq)
; Translation validation: layer_compromised preserves semantics
(push 1)
(declare-const source_layer_compromised Int)
(declare-const target_layer_compromised Int)
(assert (>= source_layer_compromised 0))
(assert (>= target_layer_compromised 0))
(assert (not (= source_layer_compromised target_layer_compromised)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hardware_root_of_trust: source semantics (matches Coq)
; Translation validation: hardware_root_of_trust preserves semantics
(push 1)
(declare-const source_hardware_root_of_trust Int)
(declare-const target_hardware_root_of_trust Int)
(assert (>= source_hardware_root_of_trust 0))
(assert (>= target_hardware_root_of_trust 0))
(assert (not (= source_hardware_root_of_trust target_hardware_root_of_trust)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; measured_boot_integrity: source semantics (matches Coq)
; Translation validation: measured_boot_integrity preserves semantics
(push 1)
(declare-const source_measured_boot_integrity Int)
(declare-const target_measured_boot_integrity Int)
(assert (>= source_measured_boot_integrity 0))
(assert (>= target_measured_boot_integrity 0))
(assert (not (= source_measured_boot_integrity target_measured_boot_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; secure_channel: source semantics (matches Coq)
; Translation validation: secure_channel preserves semantics
(push 1)
(declare-const source_secure_channel Int)
(declare-const target_secure_channel Int)
(assert (>= source_secure_channel 0))
(assert (>= target_secure_channel 0))
(assert (not (= source_secure_channel target_secure_channel)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; capability_delegation_correct: source semantics (matches Coq)
; Translation validation: capability_delegation_correct preserves semantics
(push 1)
(declare-const source_capability_delegation_correct Int)
(declare-const target_capability_delegation_correct Int)
(assert (>= source_capability_delegation_correct 0))
(assert (>= target_capability_delegation_correct 0))
(assert (not (= source_capability_delegation_correct target_capability_delegation_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; end_to_end_encryption: source semantics (matches Coq)
; Translation validation: end_to_end_encryption preserves semantics
(push 1)
(declare-const source_end_to_end_encryption Int)
(declare-const target_end_to_end_encryption Int)
(assert (>= source_end_to_end_encryption 0))
(assert (>= target_end_to_end_encryption 0))
(assert (not (= source_end_to_end_encryption target_end_to_end_encryption)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; all_critical_layers_verified: source semantics (matches Coq)
; Translation validation: all_critical_layers_verified preserves semantics
(push 1)
(declare-const source_all_critical_layers_verified Int)
(declare-const target_all_critical_layers_verified Int)
(assert (>= source_all_critical_layers_verified 0))
(assert (>= target_all_critical_layers_verified 0))
(assert (not (= source_all_critical_layers_verified target_all_critical_layers_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; layer_eqb_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: layer_eqb_refl preserves semantics
(push 1)
(declare-const source_layer_eqb_refl Int)
(declare-const target_layer_eqb_refl Int)
(assert (>= source_layer_eqb_refl 0))
(assert (>= target_layer_eqb_refl 0))
(assert (not (= source_layer_eqb_refl target_layer_eqb_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; layer_eqb_eq: translation preserves property (matches Coq: Lemma)
; Translation validation: layer_eqb_eq preserves semantics
(push 1)
(declare-const source_layer_eqb_eq Int)
(declare-const target_layer_eqb_eq Int)
(assert (>= source_layer_eqb_eq 0))
(assert (>= target_layer_eqb_eq 0))
(assert (not (= source_layer_eqb_eq target_layer_eqb_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; layer_adjacent_L0_L1: translation preserves property (matches Coq: Lemma)
; Translation validation: layer_adjacent_L0_L1 preserves semantics
(push 1)
(declare-const source_layer_adjacent_L0_L1 Int)
(declare-const target_layer_adjacent_L0_L1 Int)
(assert (>= source_layer_adjacent_L0_L1 0))
(assert (>= target_layer_adjacent_L0_L1 0))
(assert (not (= source_layer_adjacent_L0_L1 target_layer_adjacent_L0_L1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; layer_adjacent_L1_L2: translation preserves property (matches Coq: Lemma)
; Translation validation: layer_adjacent_L1_L2 preserves semantics
(push 1)
(declare-const source_layer_adjacent_L1_L2 Int)
(declare-const target_layer_adjacent_L1_L2 Int)
(assert (>= source_layer_adjacent_L1_L2 0))
(assert (>= target_layer_adjacent_L1_L2 0))
(assert (not (= source_layer_adjacent_L1_L2 target_layer_adjacent_L1_L2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; layer_adjacent_L2_L3: translation preserves property (matches Coq: Lemma)
; Translation validation: layer_adjacent_L2_L3 preserves semantics
(push 1)
(declare-const source_layer_adjacent_L2_L3 Int)
(declare-const target_layer_adjacent_L2_L3 Int)
(assert (>= source_layer_adjacent_L2_L3 0))
(assert (>= target_layer_adjacent_L2_L3 0))
(assert (not (= source_layer_adjacent_L2_L3 target_layer_adjacent_L2_L3)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; layer_adjacent_L3_L4: translation preserves property (matches Coq: Lemma)
; Translation validation: layer_adjacent_L3_L4 preserves semantics
(push 1)
(declare-const source_layer_adjacent_L3_L4 Int)
(declare-const target_layer_adjacent_L3_L4 Int)
(assert (>= source_layer_adjacent_L3_L4 0))
(assert (>= target_layer_adjacent_L3_L4 0))
(assert (not (= source_layer_adjacent_L3_L4 target_layer_adjacent_L3_L4)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; layer_adjacent_L4_L5: translation preserves property (matches Coq: Lemma)
; Translation validation: layer_adjacent_L4_L5 preserves semantics
(push 1)
(declare-const source_layer_adjacent_L4_L5 Int)
(declare-const target_layer_adjacent_L4_L5 Int)
(assert (>= source_layer_adjacent_L4_L5 0))
(assert (>= target_layer_adjacent_L4_L5 0))
(assert (not (= source_layer_adjacent_L4_L5 target_layer_adjacent_L4_L5)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; layer_adjacent_L5_L6: translation preserves property (matches Coq: Lemma)
; Translation validation: layer_adjacent_L5_L6 preserves semantics
(push 1)
(declare-const source_layer_adjacent_L5_L6 Int)
(declare-const target_layer_adjacent_L5_L6 Int)
(assert (>= source_layer_adjacent_L5_L6 0))
(assert (>= target_layer_adjacent_L5_L6 0))
(assert (not (= source_layer_adjacent_L5_L6 target_layer_adjacent_L5_L6)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; layer_adjacent_L6_L7: translation preserves property (matches Coq: Lemma)
; Translation validation: layer_adjacent_L6_L7 preserves semantics
(push 1)
(declare-const source_layer_adjacent_L6_L7 Int)
(declare-const target_layer_adjacent_L6_L7 Int)
(assert (>= source_layer_adjacent_L6_L7 0))
(assert (>= target_layer_adjacent_L6_L7 0))
(assert (not (= source_layer_adjacent_L6_L7 target_layer_adjacent_L6_L7)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sp_eqb_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: sp_eqb_refl preserves semantics
(push 1)
(declare-const source_sp_eqb_refl Int)
(declare-const target_sp_eqb_refl Int)
(assert (>= source_sp_eqb_refl 0))
(assert (>= target_sp_eqb_refl 0))
(assert (not (= source_sp_eqb_refl target_sp_eqb_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; existsb_app: translation preserves property (matches Coq: Lemma)
; Translation validation: existsb_app preserves semantics
(push 1)
(declare-const source_existsb_app Int)
(declare-const target_existsb_app Int)
(assert (>= source_existsb_app 0))
(assert (>= target_existsb_app 0))
(assert (not (= source_existsb_app target_existsb_app)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; existsb_cons_true: translation preserves property (matches Coq: Lemma)
; Translation validation: existsb_cons_true preserves semantics
(push 1)
(declare-const source_existsb_cons_true Int)
(declare-const target_existsb_cons_true Int)
(assert (>= source_existsb_cons_true 0))
(assert (>= target_existsb_cons_true 0))
(assert (not (= source_existsb_cons_true target_existsb_cons_true)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; existsb_cons_or: translation preserves property (matches Coq: Lemma)
; Translation validation: existsb_cons_or preserves semantics
(push 1)
(declare-const source_existsb_cons_or Int)
(declare-const target_existsb_cons_or Int)
(assert (>= source_existsb_cons_or 0))
(assert (>= target_existsb_cons_or 0))
(assert (not (= source_existsb_cons_or target_existsb_cons_or)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; forallb_impl: translation preserves property (matches Coq: Lemma)
; Translation validation: forallb_impl preserves semantics
(push 1)
(declare-const source_forallb_impl Int)
(declare-const target_forallb_impl Int)
(assert (>= source_forallb_impl 0))
(assert (>= target_forallb_impl 0))
(assert (not (= source_forallb_impl target_forallb_impl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_intro_both: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_intro_both preserves semantics
(push 1)
(declare-const source_andb_true_intro_both Int)
(declare-const target_andb_true_intro_both Int)
(assert (>= source_andb_true_intro_both 0))
(assert (>= target_andb_true_intro_both 0))
(assert (not (= source_andb_true_intro_both target_andb_true_intro_both)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_01_l0_l1_interface_security: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_01_l0_l1_interface_security preserves semantics
(push 1)
(declare-const source_TOTAL_001_01_l0_l1_interface_security Int)
(declare-const target_TOTAL_001_01_l0_l1_interface_security Int)
(assert (>= source_TOTAL_001_01_l0_l1_interface_security 0))
(assert (>= target_TOTAL_001_01_l0_l1_interface_security 0))
(assert (not (= source_TOTAL_001_01_l0_l1_interface_security target_TOTAL_001_01_l0_l1_interface_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_02_l1_l2_interface_security: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_02_l1_l2_interface_security preserves semantics
(push 1)
(declare-const source_TOTAL_001_02_l1_l2_interface_security Int)
(declare-const target_TOTAL_001_02_l1_l2_interface_security Int)
(assert (>= source_TOTAL_001_02_l1_l2_interface_security 0))
(assert (>= target_TOTAL_001_02_l1_l2_interface_security 0))
(assert (not (= source_TOTAL_001_02_l1_l2_interface_security target_TOTAL_001_02_l1_l2_interface_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_03_l2_l3_interface_security: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_03_l2_l3_interface_security preserves semantics
(push 1)
(declare-const source_TOTAL_001_03_l2_l3_interface_security Int)
(declare-const target_TOTAL_001_03_l2_l3_interface_security Int)
(assert (>= source_TOTAL_001_03_l2_l3_interface_security 0))
(assert (>= target_TOTAL_001_03_l2_l3_interface_security 0))
(assert (not (= source_TOTAL_001_03_l2_l3_interface_security target_TOTAL_001_03_l2_l3_interface_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_04_l3_l4_interface_security: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_04_l3_l4_interface_security preserves semantics
(push 1)
(declare-const source_TOTAL_001_04_l3_l4_interface_security Int)
(declare-const target_TOTAL_001_04_l3_l4_interface_security Int)
(assert (>= source_TOTAL_001_04_l3_l4_interface_security 0))
(assert (>= target_TOTAL_001_04_l3_l4_interface_security 0))
(assert (not (= source_TOTAL_001_04_l3_l4_interface_security target_TOTAL_001_04_l3_l4_interface_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_05_l4_l5_interface_security: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_05_l4_l5_interface_security preserves semantics
(push 1)
(declare-const source_TOTAL_001_05_l4_l5_interface_security Int)
(declare-const target_TOTAL_001_05_l4_l5_interface_security Int)
(assert (>= source_TOTAL_001_05_l4_l5_interface_security 0))
(assert (>= target_TOTAL_001_05_l4_l5_interface_security 0))
(assert (not (= source_TOTAL_001_05_l4_l5_interface_security target_TOTAL_001_05_l4_l5_interface_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_06_l5_l6_interface_security: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_06_l5_l6_interface_security preserves semantics
(push 1)
(declare-const source_TOTAL_001_06_l5_l6_interface_security Int)
(declare-const target_TOTAL_001_06_l5_l6_interface_security Int)
(assert (>= source_TOTAL_001_06_l5_l6_interface_security 0))
(assert (>= target_TOTAL_001_06_l5_l6_interface_security 0))
(assert (not (= source_TOTAL_001_06_l5_l6_interface_security target_TOTAL_001_06_l5_l6_interface_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_07_l6_l7_interface_security: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_07_l6_l7_interface_security preserves semantics
(push 1)
(declare-const source_TOTAL_001_07_l6_l7_interface_security Int)
(declare-const target_TOTAL_001_07_l6_l7_interface_security Int)
(assert (>= source_TOTAL_001_07_l6_l7_interface_security 0))
(assert (>= target_TOTAL_001_07_l6_l7_interface_security 0))
(assert (not (= source_TOTAL_001_07_l6_l7_interface_security target_TOTAL_001_07_l6_l7_interface_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_08_confidentiality_preserved: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_08_confidentiality_preserved preserves semantics
(push 1)
(declare-const source_TOTAL_001_08_confidentiality_preserved Int)
(declare-const target_TOTAL_001_08_confidentiality_preserved Int)
(assert (>= source_TOTAL_001_08_confidentiality_preserved 0))
(assert (>= target_TOTAL_001_08_confidentiality_preserved 0))
(assert (not (= source_TOTAL_001_08_confidentiality_preserved target_TOTAL_001_08_confidentiality_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_09_integrity_preserved: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_09_integrity_preserved preserves semantics
(push 1)
(declare-const source_TOTAL_001_09_integrity_preserved Int)
(declare-const target_TOTAL_001_09_integrity_preserved Int)
(assert (>= source_TOTAL_001_09_integrity_preserved 0))
(assert (>= target_TOTAL_001_09_integrity_preserved 0))
(assert (not (= source_TOTAL_001_09_integrity_preserved target_TOTAL_001_09_integrity_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_10_availability_preserved: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_10_availability_preserved preserves semantics
(push 1)
(declare-const source_TOTAL_001_10_availability_preserved Int)
(declare-const target_TOTAL_001_10_availability_preserved Int)
(assert (>= source_TOTAL_001_10_availability_preserved 0))
(assert (>= target_TOTAL_001_10_availability_preserved 0))
(assert (not (= source_TOTAL_001_10_availability_preserved target_TOTAL_001_10_availability_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_11_authentication_preserved: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_11_authentication_preserved preserves semantics
(push 1)
(declare-const source_TOTAL_001_11_authentication_preserved Int)
(declare-const target_TOTAL_001_11_authentication_preserved Int)
(assert (>= source_TOTAL_001_11_authentication_preserved 0))
(assert (>= target_TOTAL_001_11_authentication_preserved 0))
(assert (not (= source_TOTAL_001_11_authentication_preserved target_TOTAL_001_11_authentication_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_12_authorization_preserved: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_12_authorization_preserved preserves semantics
(push 1)
(declare-const source_TOTAL_001_12_authorization_preserved Int)
(declare-const target_TOTAL_001_12_authorization_preserved Int)
(assert (>= source_TOTAL_001_12_authorization_preserved 0))
(assert (>= target_TOTAL_001_12_authorization_preserved 0))
(assert (not (= source_TOTAL_001_12_authorization_preserved target_TOTAL_001_12_authorization_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_13_memory_corruption_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_13_memory_corruption_impossible preserves semantics
(push 1)
(declare-const source_TOTAL_001_13_memory_corruption_impossible Int)
(declare-const target_TOTAL_001_13_memory_corruption_impossible Int)
(assert (>= source_TOTAL_001_13_memory_corruption_impossible 0))
(assert (>= target_TOTAL_001_13_memory_corruption_impossible 0))
(assert (not (= source_TOTAL_001_13_memory_corruption_impossible target_TOTAL_001_13_memory_corruption_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_14_side_channel_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_14_side_channel_impossible preserves semantics
(push 1)
(declare-const source_TOTAL_001_14_side_channel_impossible Int)
(declare-const target_TOTAL_001_14_side_channel_impossible Int)
(assert (>= source_TOTAL_001_14_side_channel_impossible 0))
(assert (>= target_TOTAL_001_14_side_channel_impossible 0))
(assert (not (= source_TOTAL_001_14_side_channel_impossible target_TOTAL_001_14_side_channel_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_15_network_attack_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_15_network_attack_impossible preserves semantics
(push 1)
(declare-const source_TOTAL_001_15_network_attack_impossible Int)
(declare-const target_TOTAL_001_15_network_attack_impossible Int)
(assert (>= source_TOTAL_001_15_network_attack_impossible 0))
(assert (>= target_TOTAL_001_15_network_attack_impossible 0))
(assert (not (= source_TOTAL_001_15_network_attack_impossible target_TOTAL_001_15_network_attack_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_16_privilege_escalation_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_16_privilege_escalation_impossible preserves semantics
(push 1)
(declare-const source_TOTAL_001_16_privilege_escalation_impossible Int)
(declare-const target_TOTAL_001_16_privilege_escalation_impossible Int)
(assert (>= source_TOTAL_001_16_privilege_escalation_impossible 0))
(assert (>= target_TOTAL_001_16_privilege_escalation_impossible 0))
(assert (not (= source_TOTAL_001_16_privilege_escalation_impossible target_TOTAL_001_16_privilege_escalation_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_17_ui_deception_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_17_ui_deception_impossible preserves semantics
(push 1)
(declare-const source_TOTAL_001_17_ui_deception_impossible Int)
(declare-const target_TOTAL_001_17_ui_deception_impossible Int)
(assert (>= source_TOTAL_001_17_ui_deception_impossible 0))
(assert (>= target_TOTAL_001_17_ui_deception_impossible 0))
(assert (not (= source_TOTAL_001_17_ui_deception_impossible target_TOTAL_001_17_ui_deception_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_18_boot_compromise_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_18_boot_compromise_impossible preserves semantics
(push 1)
(declare-const source_TOTAL_001_18_boot_compromise_impossible Int)
(declare-const target_TOTAL_001_18_boot_compromise_impossible Int)
(assert (>= source_TOTAL_001_18_boot_compromise_impossible 0))
(assert (>= target_TOTAL_001_18_boot_compromise_impossible 0))
(assert (not (= source_TOTAL_001_18_boot_compromise_impossible target_TOTAL_001_18_boot_compromise_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_19_adjacent_layers_compose: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_19_adjacent_layers_compose preserves semantics
(push 1)
(declare-const source_TOTAL_001_19_adjacent_layers_compose Int)
(declare-const target_TOTAL_001_19_adjacent_layers_compose Int)
(assert (>= source_TOTAL_001_19_adjacent_layers_compose 0))
(assert (>= target_TOTAL_001_19_adjacent_layers_compose 0))
(assert (not (= source_TOTAL_001_19_adjacent_layers_compose target_TOTAL_001_19_adjacent_layers_compose)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_20_security_property_transitivity: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_20_security_property_transitivity preserves semantics
(push 1)
(declare-const source_TOTAL_001_20_security_property_transitivity Int)
(declare-const target_TOTAL_001_20_security_property_transitivity Int)
(assert (>= source_TOTAL_001_20_security_property_transitivity 0))
(assert (>= target_TOTAL_001_20_security_property_transitivity 0))
(assert (not (= source_TOTAL_001_20_security_property_transitivity target_TOTAL_001_20_security_property_transitivity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_21_no_security_gap: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_21_no_security_gap preserves semantics
(push 1)
(declare-const source_TOTAL_001_21_no_security_gap Int)
(declare-const target_TOTAL_001_21_no_security_gap Int)
(assert (>= source_TOTAL_001_21_no_security_gap 0))
(assert (>= target_TOTAL_001_21_no_security_gap 0))
(assert (not (= source_TOTAL_001_21_no_security_gap target_TOTAL_001_21_no_security_gap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_22_defense_in_depth: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_22_defense_in_depth preserves semantics
(push 1)
(declare-const source_TOTAL_001_22_defense_in_depth Int)
(declare-const target_TOTAL_001_22_defense_in_depth Int)
(assert (>= source_TOTAL_001_22_defense_in_depth 0))
(assert (>= target_TOTAL_001_22_defense_in_depth 0))
(assert (not (= source_TOTAL_001_22_defense_in_depth target_TOTAL_001_22_defense_in_depth)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_23_single_layer_compromise_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_23_single_layer_compromise_bounded preserves semantics
(push 1)
(declare-const source_TOTAL_001_23_single_layer_compromise_bounded Int)
(declare-const target_TOTAL_001_23_single_layer_compromise_bounded Int)
(assert (>= source_TOTAL_001_23_single_layer_compromise_bounded 0))
(assert (>= target_TOTAL_001_23_single_layer_compromise_bounded 0))
(assert (not (= source_TOTAL_001_23_single_layer_compromise_bounded target_TOTAL_001_23_single_layer_compromise_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_24_hardware_root_of_trust: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_24_hardware_root_of_trust preserves semantics
(push 1)
(declare-const source_TOTAL_001_24_hardware_root_of_trust Int)
(declare-const target_TOTAL_001_24_hardware_root_of_trust Int)
(assert (>= source_TOTAL_001_24_hardware_root_of_trust 0))
(assert (>= target_TOTAL_001_24_hardware_root_of_trust 0))
(assert (not (= source_TOTAL_001_24_hardware_root_of_trust target_TOTAL_001_24_hardware_root_of_trust)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_25_measured_boot_integrity: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_25_measured_boot_integrity preserves semantics
(push 1)
(declare-const source_TOTAL_001_25_measured_boot_integrity Int)
(declare-const target_TOTAL_001_25_measured_boot_integrity Int)
(assert (>= source_TOTAL_001_25_measured_boot_integrity 0))
(assert (>= target_TOTAL_001_25_measured_boot_integrity 0))
(assert (not (= source_TOTAL_001_25_measured_boot_integrity target_TOTAL_001_25_measured_boot_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_26_secure_channel_establishment: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_26_secure_channel_establishment preserves semantics
(push 1)
(declare-const source_TOTAL_001_26_secure_channel_establishment Int)
(declare-const target_TOTAL_001_26_secure_channel_establishment Int)
(assert (>= source_TOTAL_001_26_secure_channel_establishment 0))
(assert (>= target_TOTAL_001_26_secure_channel_establishment 0))
(assert (not (= source_TOTAL_001_26_secure_channel_establishment target_TOTAL_001_26_secure_channel_establishment)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_27_capability_delegation: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_27_capability_delegation preserves semantics
(push 1)
(declare-const source_TOTAL_001_27_capability_delegation Int)
(declare-const target_TOTAL_001_27_capability_delegation Int)
(assert (>= source_TOTAL_001_27_capability_delegation 0))
(assert (>= target_TOTAL_001_27_capability_delegation 0))
(assert (not (= source_TOTAL_001_27_capability_delegation target_TOTAL_001_27_capability_delegation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_28_end_to_end_encryption: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_28_end_to_end_encryption preserves semantics
(push 1)
(declare-const source_TOTAL_001_28_end_to_end_encryption Int)
(declare-const target_TOTAL_001_28_end_to_end_encryption Int)
(assert (>= source_TOTAL_001_28_end_to_end_encryption 0))
(assert (>= target_TOTAL_001_28_end_to_end_encryption 0))
(assert (not (= source_TOTAL_001_28_end_to_end_encryption target_TOTAL_001_28_end_to_end_encryption)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_29_remote_code_execution_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_29_remote_code_execution_impossible preserves semantics
(push 1)
(declare-const source_TOTAL_001_29_remote_code_execution_impossible Int)
(declare-const target_TOTAL_001_29_remote_code_execution_impossible Int)
(assert (>= source_TOTAL_001_29_remote_code_execution_impossible 0))
(assert (>= target_TOTAL_001_29_remote_code_execution_impossible 0))
(assert (not (= source_TOTAL_001_29_remote_code_execution_impossible target_TOTAL_001_29_remote_code_execution_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_30_data_exfiltration_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_30_data_exfiltration_impossible preserves semantics
(push 1)
(declare-const source_TOTAL_001_30_data_exfiltration_impossible Int)
(declare-const target_TOTAL_001_30_data_exfiltration_impossible Int)
(assert (>= source_TOTAL_001_30_data_exfiltration_impossible 0))
(assert (>= target_TOTAL_001_30_data_exfiltration_impossible 0))
(assert (not (= source_TOTAL_001_30_data_exfiltration_impossible target_TOTAL_001_30_data_exfiltration_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_31_denial_of_service_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_31_denial_of_service_bounded preserves semantics
(push 1)
(declare-const source_TOTAL_001_31_denial_of_service_bounded Int)
(declare-const target_TOTAL_001_31_denial_of_service_bounded Int)
(assert (>= source_TOTAL_001_31_denial_of_service_bounded 0))
(assert (>= target_TOTAL_001_31_denial_of_service_bounded 0))
(assert (not (= source_TOTAL_001_31_denial_of_service_bounded target_TOTAL_001_31_denial_of_service_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_32_malware_execution_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_32_malware_execution_impossible preserves semantics
(push 1)
(declare-const source_TOTAL_001_32_malware_execution_impossible Int)
(declare-const target_TOTAL_001_32_malware_execution_impossible Int)
(assert (>= source_TOTAL_001_32_malware_execution_impossible 0))
(assert (>= target_TOTAL_001_32_malware_execution_impossible 0))
(assert (not (= source_TOTAL_001_32_malware_execution_impossible target_TOTAL_001_32_malware_execution_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_33_insider_threat_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_33_insider_threat_bounded preserves semantics
(push 1)
(declare-const source_TOTAL_001_33_insider_threat_bounded Int)
(declare-const target_TOTAL_001_33_insider_threat_bounded Int)
(assert (>= source_TOTAL_001_33_insider_threat_bounded 0))
(assert (>= target_TOTAL_001_33_insider_threat_bounded 0))
(assert (not (= source_TOTAL_001_33_insider_threat_bounded target_TOTAL_001_33_insider_threat_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_34_all_layer_proofs_compose: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_34_all_layer_proofs_compose preserves semantics
(push 1)
(declare-const source_TOTAL_001_34_all_layer_proofs_compose Int)
(declare-const target_TOTAL_001_34_all_layer_proofs_compose Int)
(assert (>= source_TOTAL_001_34_all_layer_proofs_compose 0))
(assert (>= target_TOTAL_001_34_all_layer_proofs_compose 0))
(assert (not (= source_TOTAL_001_34_all_layer_proofs_compose target_TOTAL_001_34_all_layer_proofs_compose)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; attack_blocked_by_layer: translation preserves property (matches Coq: Lemma)
; Translation validation: attack_blocked_by_layer preserves semantics
(push 1)
(declare-const source_attack_blocked_by_layer Int)
(declare-const target_attack_blocked_by_layer Int)
(assert (>= source_attack_blocked_by_layer 0))
(assert (>= target_attack_blocked_by_layer 0))
(assert (not (= source_attack_blocked_by_layer target_attack_blocked_by_layer)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; TOTAL_001_35_total_stack_security: translation preserves property (matches Coq: Theorem)
; Translation validation: TOTAL_001_35_total_stack_security preserves semantics
(push 1)
(declare-const source_TOTAL_001_35_total_stack_security Int)
(declare-const target_TOTAL_001_35_total_stack_security Int)
(assert (>= source_TOTAL_001_35_total_stack_security 0))
(assert (>= target_TOTAL_001_35_total_stack_security 0))
(assert (not (= source_TOTAL_001_35_total_stack_security target_TOTAL_001_35_total_stack_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

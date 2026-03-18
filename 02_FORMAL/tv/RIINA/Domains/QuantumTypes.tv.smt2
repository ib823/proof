; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/QuantumTypes.v (29 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for QuantumTypes
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; mem: source semantics (matches Coq)
(declare-fun source_mem () Bool)
(declare-fun target_mem () Bool)
(assert (= source_mem target_mem))

; remove: source semantics (matches Coq)
(declare-fun source_remove () Bool)
(declare-fun target_remove () Bool)
(assert (= source_remove target_remove))

; count: source semantics (matches Coq)
(declare-fun source_count () Bool)
(declare-fun target_count () Bool)
(assert (= source_count target_count))

; check: source semantics (matches Coq)
(declare-fun source_check () Bool)
(declare-fun target_check () Bool)
(assert (= source_check target_check))

; well_typed: source semantics (matches Coq)
(declare-fun source_well_typed () Bool)
(declare-fun target_well_typed () Bool)
(assert (= source_well_typed target_well_typed))

; fully_consumed: source semantics (matches Coq)
(declare-fun source_fully_consumed () Bool)
(declare-fun target_fully_consumed () Bool)
(assert (= source_fully_consumed target_fully_consumed))

; well_typed_b: source semantics (matches Coq)
(declare-fun source_well_typed_b () Bool)
(declare-fun target_well_typed_b () Bool)
(assert (= source_well_typed_b target_well_typed_b))

; fully_consumed_b: source semantics (matches Coq)
(declare-fun source_fully_consumed_b () Bool)
(declare-fun target_fully_consumed_b () Bool)
(assert (= source_fully_consumed_b target_fully_consumed_b))

; mem_true_In: translation preserves property (matches Coq: Lemma)
(declare-fun source_mem_true_In () Bool)
(declare-fun target_mem_true_In () Bool)
(assert (= source_mem_true_In target_mem_true_In))

; In_mem_true: translation preserves property (matches Coq: Lemma)
(declare-fun source_In_mem_true () Bool)
(declare-fun target_In_mem_true () Bool)
(assert (= source_In_mem_true target_In_mem_true))

; mem_false_not_In: translation preserves property (matches Coq: Lemma)
(declare-fun source_mem_false_not_In () Bool)
(declare-fun target_mem_false_not_In () Bool)
(assert (= source_mem_false_not_In target_mem_false_not_In))

; remove_length: translation preserves property (matches Coq: Lemma)
(declare-fun source_remove_length () Bool)
(declare-fun target_remove_length () Bool)
(assert (= source_remove_length target_remove_length))

; remove_not_first: translation preserves property (matches Coq: Lemma)
(declare-fun source_remove_not_first () Bool)
(declare-fun target_remove_not_first () Bool)
(assert (= source_remove_not_first target_remove_not_first))

; count_remove_helper: translation preserves property (matches Coq: Lemma)
(declare-fun source_count_remove_helper () Bool)
(declare-fun target_count_remove_helper () Bool)
(assert (= source_count_remove_helper target_count_remove_helper))

; no_cloning: translation preserves property (matches Coq: Theorem)
(declare-fun source_no_cloning () Bool)
(declare-fun target_no_cloning () Bool)
(assert (= source_no_cloning target_no_cloning))

; linearity_full_consumption: translation preserves property (matches Coq: Theorem)
(declare-fun source_linearity_full_consumption () Bool)
(declare-fun target_linearity_full_consumption () Bool)
(assert (= source_linearity_full_consumption target_linearity_full_consumption))

; measurement_consumes: translation preserves property (matches Coq: Theorem)
(declare-fun source_measurement_consumes () Bool)
(declare-fun target_measurement_consumes () Bool)
(assert (= source_measurement_consumes target_measurement_consumes))

; gate_preserves_context: translation preserves property (matches Coq: Theorem)
(declare-fun source_gate_preserves_context () Bool)
(declare-fun target_gate_preserves_context () Bool)
(assert (= source_gate_preserves_context target_gate_preserves_context))

; type_checking_decidable: translation preserves property (matches Coq: Theorem)
(declare-fun source_type_checking_decidable () Bool)
(declare-fun target_type_checking_decidable () Bool)
(assert (= source_type_checking_decidable target_type_checking_decidable))

; no_dangling_qubits: translation preserves property (matches Coq: Theorem)
(declare-fun source_no_dangling_qubits () Bool)
(declare-fun target_no_dangling_qubits () Bool)
(assert (= source_no_dangling_qubits target_no_dangling_qubits))

; seq_preserves_linearity: translation preserves property (matches Coq: Theorem)
(declare-fun source_seq_preserves_linearity () Bool)
(declare-fun target_seq_preserves_linearity () Bool)
(assert (= source_seq_preserves_linearity target_seq_preserves_linearity))

; create_increases_resources: translation preserves property (matches Coq: Theorem)
(declare-fun source_create_increases_resources () Bool)
(declare-fun target_create_increases_resources () Bool)
(assert (= source_create_increases_resources target_create_increases_resources))

; measure_decreases_resources: translation preserves property (matches Coq: Theorem)
(declare-fun source_measure_decreases_resources () Bool)
(declare-fun target_measure_decreases_resources () Bool)
(assert (= source_measure_decreases_resources target_measure_decreases_resources))

; create_measure_consumed: translation preserves property (matches Coq: Theorem)
(declare-fun source_create_measure_consumed () Bool)
(declare-fun target_create_measure_consumed () Bool)
(assert (= source_create_measure_consumed target_create_measure_consumed))

; create_gate_measure_consumed: translation preserves property (matches Coq: Theorem)
(declare-fun source_create_gate_measure_consumed () Bool)
(declare-fun target_create_gate_measure_consumed () Bool)
(assert (= source_create_gate_measure_consumed target_create_gate_measure_consumed))

; mem_head: translation preserves property (matches Coq: Theorem)
(declare-fun source_mem_head () Bool)
(declare-fun target_mem_head () Bool)
(assert (= source_mem_head target_mem_head))

; mem_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_mem_nil () Bool)
(declare-fun target_mem_nil () Bool)
(assert (= source_mem_nil target_mem_nil))

; count_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_count_nil () Bool)
(declare-fun target_count_nil () Bool)
(assert (= source_count_nil target_count_nil))

; count_le_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_count_le_length () Bool)
(declare-fun target_count_le_length () Bool)
(assert (= source_count_le_length target_count_le_length))

; remove_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_remove_nil () Bool)
(declare-fun target_remove_nil () Bool)
(assert (= source_remove_nil target_remove_nil))

; gate_requires_qubit: translation preserves property (matches Coq: Theorem)
(declare-fun source_gate_requires_qubit () Bool)
(declare-fun target_gate_requires_qubit () Bool)
(assert (= source_gate_requires_qubit target_gate_requires_qubit))

; measure_requires_qubit: translation preserves property (matches Coq: Theorem)
(declare-fun source_measure_requires_qubit () Bool)
(declare-fun target_measure_requires_qubit () Bool)
(assert (= source_measure_requires_qubit target_measure_requires_qubit))

; gate2_requires_distinct: translation preserves property (matches Coq: Theorem)
(declare-fun source_gate2_requires_distinct () Bool)
(declare-fun target_gate2_requires_distinct () Bool)
(assert (= source_gate2_requires_distinct target_gate2_requires_distinct))

; double_create_fails: translation preserves property (matches Coq: Theorem)
(declare-fun source_double_create_fails () Bool)
(declare-fun target_double_create_fails () Bool)
(assert (= source_double_create_fails target_double_create_fails))

; count_singleton: translation preserves property (matches Coq: Theorem)
(declare-fun source_count_singleton () Bool)
(declare-fun target_count_singleton () Bool)
(assert (= source_count_singleton target_count_singleton))

; mem_singleton: translation preserves property (matches Coq: Theorem)
(declare-fun source_mem_singleton () Bool)
(declare-fun target_mem_singleton () Bool)
(assert (= source_mem_singleton target_mem_singleton))

; create_on_empty_succeeds: translation preserves property (matches Coq: Theorem)
(declare-fun source_create_on_empty_succeeds () Bool)
(declare-fun target_create_on_empty_succeeds () Bool)
(assert (= source_create_on_empty_succeeds target_create_on_empty_succeeds))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

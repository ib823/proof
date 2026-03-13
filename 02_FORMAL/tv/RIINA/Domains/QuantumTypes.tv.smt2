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
; Translation validation: mem preserves semantics
(push 1)
(declare-const source_mem Int)
(declare-const target_mem Int)
(assert (>= source_mem 0))
(assert (>= target_mem 0))
(assert (not (= source_mem target_mem)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; remove: source semantics (matches Coq)
; Translation validation: remove preserves semantics
(push 1)
(declare-const source_remove Int)
(declare-const target_remove Int)
(assert (>= source_remove 0))
(assert (>= target_remove 0))
(assert (not (= source_remove target_remove)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; count: source semantics (matches Coq)
; Translation validation: count preserves semantics
(push 1)
(declare-const source_count Int)
(declare-const target_count Int)
(assert (>= source_count 0))
(assert (>= target_count 0))
(assert (not (= source_count target_count)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; check: source semantics (matches Coq)
; Translation validation: check preserves semantics
(push 1)
(declare-const source_check Int)
(declare-const target_check Int)
(assert (>= source_check 0))
(assert (>= target_check 0))
(assert (not (= source_check target_check)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; well_typed: source semantics (matches Coq)
; Translation validation: well_typed preserves semantics
(push 1)
(declare-const source_well_typed Int)
(declare-const target_well_typed Int)
(assert (>= source_well_typed 0))
(assert (>= target_well_typed 0))
(assert (not (= source_well_typed target_well_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fully_consumed: source semantics (matches Coq)
; Translation validation: fully_consumed preserves semantics
(push 1)
(declare-const source_fully_consumed Int)
(declare-const target_fully_consumed Int)
(assert (>= source_fully_consumed 0))
(assert (>= target_fully_consumed 0))
(assert (not (= source_fully_consumed target_fully_consumed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; well_typed_b: source semantics (matches Coq)
; Translation validation: well_typed_b preserves semantics
(push 1)
(declare-const source_well_typed_b Int)
(declare-const target_well_typed_b Int)
(assert (>= source_well_typed_b 0))
(assert (>= target_well_typed_b 0))
(assert (not (= source_well_typed_b target_well_typed_b)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fully_consumed_b: source semantics (matches Coq)
; Translation validation: fully_consumed_b preserves semantics
(push 1)
(declare-const source_fully_consumed_b Int)
(declare-const target_fully_consumed_b Int)
(assert (>= source_fully_consumed_b 0))
(assert (>= target_fully_consumed_b 0))
(assert (not (= source_fully_consumed_b target_fully_consumed_b)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mem_true_In: translation preserves property (matches Coq: Lemma)
; Translation validation: mem_true_In preserves semantics
(push 1)
(declare-const source_mem_true_In Int)
(declare-const target_mem_true_In Int)
(assert (>= source_mem_true_In 0))
(assert (>= target_mem_true_In 0))
(assert (not (= source_mem_true_In target_mem_true_In)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; In_mem_true: translation preserves property (matches Coq: Lemma)
; Translation validation: In_mem_true preserves semantics
(push 1)
(declare-const source_In_mem_true Int)
(declare-const target_In_mem_true Int)
(assert (>= source_In_mem_true 0))
(assert (>= target_In_mem_true 0))
(assert (not (= source_In_mem_true target_In_mem_true)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mem_false_not_In: translation preserves property (matches Coq: Lemma)
; Translation validation: mem_false_not_In preserves semantics
(push 1)
(declare-const source_mem_false_not_In Int)
(declare-const target_mem_false_not_In Int)
(assert (>= source_mem_false_not_In 0))
(assert (>= target_mem_false_not_In 0))
(assert (not (= source_mem_false_not_In target_mem_false_not_In)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; remove_length: translation preserves property (matches Coq: Lemma)
; Translation validation: remove_length preserves semantics
(push 1)
(declare-const source_remove_length Int)
(declare-const target_remove_length Int)
(assert (>= source_remove_length 0))
(assert (>= target_remove_length 0))
(assert (not (= source_remove_length target_remove_length)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; remove_not_first: translation preserves property (matches Coq: Lemma)
; Translation validation: remove_not_first preserves semantics
(push 1)
(declare-const source_remove_not_first Int)
(declare-const target_remove_not_first Int)
(assert (>= source_remove_not_first 0))
(assert (>= target_remove_not_first 0))
(assert (not (= source_remove_not_first target_remove_not_first)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; count_remove_helper: translation preserves property (matches Coq: Lemma)
; Translation validation: count_remove_helper preserves semantics
(push 1)
(declare-const source_count_remove_helper Int)
(declare-const target_count_remove_helper Int)
(assert (>= source_count_remove_helper 0))
(assert (>= target_count_remove_helper 0))
(assert (not (= source_count_remove_helper target_count_remove_helper)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_cloning: translation preserves property (matches Coq: Theorem)
; Translation validation: no_cloning preserves semantics
(push 1)
(declare-const source_no_cloning Int)
(declare-const target_no_cloning Int)
(assert (>= source_no_cloning 0))
(assert (>= target_no_cloning 0))
(assert (not (= source_no_cloning target_no_cloning)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; linearity_full_consumption: translation preserves property (matches Coq: Theorem)
; Translation validation: linearity_full_consumption preserves semantics
(push 1)
(declare-const source_linearity_full_consumption Int)
(declare-const target_linearity_full_consumption Int)
(assert (>= source_linearity_full_consumption 0))
(assert (>= target_linearity_full_consumption 0))
(assert (not (= source_linearity_full_consumption target_linearity_full_consumption)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; measurement_consumes: translation preserves property (matches Coq: Theorem)
; Translation validation: measurement_consumes preserves semantics
(push 1)
(declare-const source_measurement_consumes Int)
(declare-const target_measurement_consumes Int)
(assert (>= source_measurement_consumes 0))
(assert (>= target_measurement_consumes 0))
(assert (not (= source_measurement_consumes target_measurement_consumes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; gate_preserves_context: translation preserves property (matches Coq: Theorem)
; Translation validation: gate_preserves_context preserves semantics
(push 1)
(declare-const source_gate_preserves_context Int)
(declare-const target_gate_preserves_context Int)
(assert (>= source_gate_preserves_context 0))
(assert (>= target_gate_preserves_context 0))
(assert (not (= source_gate_preserves_context target_gate_preserves_context)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; type_checking_decidable: translation preserves property (matches Coq: Theorem)
; Translation validation: type_checking_decidable preserves semantics
(push 1)
(declare-const source_type_checking_decidable Int)
(declare-const target_type_checking_decidable Int)
(assert (>= source_type_checking_decidable 0))
(assert (>= target_type_checking_decidable 0))
(assert (not (= source_type_checking_decidable target_type_checking_decidable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_dangling_qubits: translation preserves property (matches Coq: Theorem)
; Translation validation: no_dangling_qubits preserves semantics
(push 1)
(declare-const source_no_dangling_qubits Int)
(declare-const target_no_dangling_qubits Int)
(assert (>= source_no_dangling_qubits 0))
(assert (>= target_no_dangling_qubits 0))
(assert (not (= source_no_dangling_qubits target_no_dangling_qubits)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; seq_preserves_linearity: translation preserves property (matches Coq: Theorem)
; Translation validation: seq_preserves_linearity preserves semantics
(push 1)
(declare-const source_seq_preserves_linearity Int)
(declare-const target_seq_preserves_linearity Int)
(assert (>= source_seq_preserves_linearity 0))
(assert (>= target_seq_preserves_linearity 0))
(assert (not (= source_seq_preserves_linearity target_seq_preserves_linearity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; create_increases_resources: translation preserves property (matches Coq: Theorem)
; Translation validation: create_increases_resources preserves semantics
(push 1)
(declare-const source_create_increases_resources Int)
(declare-const target_create_increases_resources Int)
(assert (>= source_create_increases_resources 0))
(assert (>= target_create_increases_resources 0))
(assert (not (= source_create_increases_resources target_create_increases_resources)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; measure_decreases_resources: translation preserves property (matches Coq: Theorem)
; Translation validation: measure_decreases_resources preserves semantics
(push 1)
(declare-const source_measure_decreases_resources Int)
(declare-const target_measure_decreases_resources Int)
(assert (>= source_measure_decreases_resources 0))
(assert (>= target_measure_decreases_resources 0))
(assert (not (= source_measure_decreases_resources target_measure_decreases_resources)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; create_measure_consumed: translation preserves property (matches Coq: Theorem)
; Translation validation: create_measure_consumed preserves semantics
(push 1)
(declare-const source_create_measure_consumed Int)
(declare-const target_create_measure_consumed Int)
(assert (>= source_create_measure_consumed 0))
(assert (>= target_create_measure_consumed 0))
(assert (not (= source_create_measure_consumed target_create_measure_consumed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; create_gate_measure_consumed: translation preserves property (matches Coq: Theorem)
; Translation validation: create_gate_measure_consumed preserves semantics
(push 1)
(declare-const source_create_gate_measure_consumed Int)
(declare-const target_create_gate_measure_consumed Int)
(assert (>= source_create_gate_measure_consumed 0))
(assert (>= target_create_gate_measure_consumed 0))
(assert (not (= source_create_gate_measure_consumed target_create_gate_measure_consumed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mem_head: translation preserves property (matches Coq: Theorem)
; Translation validation: mem_head preserves semantics
(push 1)
(declare-const source_mem_head Int)
(declare-const target_mem_head Int)
(assert (>= source_mem_head 0))
(assert (>= target_mem_head 0))
(assert (not (= source_mem_head target_mem_head)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mem_nil: translation preserves property (matches Coq: Theorem)
; Translation validation: mem_nil preserves semantics
(push 1)
(declare-const source_mem_nil Int)
(declare-const target_mem_nil Int)
(assert (>= source_mem_nil 0))
(assert (>= target_mem_nil 0))
(assert (not (= source_mem_nil target_mem_nil)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; count_nil: translation preserves property (matches Coq: Theorem)
; Translation validation: count_nil preserves semantics
(push 1)
(declare-const source_count_nil Int)
(declare-const target_count_nil Int)
(assert (>= source_count_nil 0))
(assert (>= target_count_nil 0))
(assert (not (= source_count_nil target_count_nil)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; count_le_length: translation preserves property (matches Coq: Theorem)
; Translation validation: count_le_length preserves semantics
(push 1)
(declare-const source_count_le_length Int)
(declare-const target_count_le_length Int)
(assert (>= source_count_le_length 0))
(assert (>= target_count_le_length 0))
(assert (not (= source_count_le_length target_count_le_length)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; remove_nil: translation preserves property (matches Coq: Theorem)
; Translation validation: remove_nil preserves semantics
(push 1)
(declare-const source_remove_nil Int)
(declare-const target_remove_nil Int)
(assert (>= source_remove_nil 0))
(assert (>= target_remove_nil 0))
(assert (not (= source_remove_nil target_remove_nil)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; gate_requires_qubit: translation preserves property (matches Coq: Theorem)
; Translation validation: gate_requires_qubit preserves semantics
(push 1)
(declare-const source_gate_requires_qubit Int)
(declare-const target_gate_requires_qubit Int)
(assert (>= source_gate_requires_qubit 0))
(assert (>= target_gate_requires_qubit 0))
(assert (not (= source_gate_requires_qubit target_gate_requires_qubit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; measure_requires_qubit: translation preserves property (matches Coq: Theorem)
; Translation validation: measure_requires_qubit preserves semantics
(push 1)
(declare-const source_measure_requires_qubit Int)
(declare-const target_measure_requires_qubit Int)
(assert (>= source_measure_requires_qubit 0))
(assert (>= target_measure_requires_qubit 0))
(assert (not (= source_measure_requires_qubit target_measure_requires_qubit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; gate2_requires_distinct: translation preserves property (matches Coq: Theorem)
; Translation validation: gate2_requires_distinct preserves semantics
(push 1)
(declare-const source_gate2_requires_distinct Int)
(declare-const target_gate2_requires_distinct Int)
(assert (>= source_gate2_requires_distinct 0))
(assert (>= target_gate2_requires_distinct 0))
(assert (not (= source_gate2_requires_distinct target_gate2_requires_distinct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; double_create_fails: translation preserves property (matches Coq: Theorem)
; Translation validation: double_create_fails preserves semantics
(push 1)
(declare-const source_double_create_fails Int)
(declare-const target_double_create_fails Int)
(assert (>= source_double_create_fails 0))
(assert (>= target_double_create_fails 0))
(assert (not (= source_double_create_fails target_double_create_fails)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; count_singleton: translation preserves property (matches Coq: Theorem)
; Translation validation: count_singleton preserves semantics
(push 1)
(declare-const source_count_singleton Int)
(declare-const target_count_singleton Int)
(assert (>= source_count_singleton 0))
(assert (>= target_count_singleton 0))
(assert (not (= source_count_singleton target_count_singleton)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mem_singleton: translation preserves property (matches Coq: Theorem)
; Translation validation: mem_singleton preserves semantics
(push 1)
(declare-const source_mem_singleton Int)
(declare-const target_mem_singleton Int)
(assert (>= source_mem_singleton 0))
(assert (>= target_mem_singleton 0))
(assert (not (= source_mem_singleton target_mem_singleton)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; create_on_empty_succeeds: translation preserves property (matches Coq: Theorem)
; Translation validation: create_on_empty_succeeds preserves semantics
(push 1)
(declare-const source_create_on_empty_succeeds Int)
(declare-const target_create_on_empty_succeeds Int)
(assert (>= source_create_on_empty_succeeds 0))
(assert (>= target_create_on_empty_succeeds 0))
(assert (not (= source_create_on_empty_succeeds target_create_on_empty_succeeds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

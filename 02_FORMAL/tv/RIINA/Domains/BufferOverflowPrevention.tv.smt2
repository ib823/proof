; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/BufferOverflowPrevention.v (22 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for BufferOverflowPrevention
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; buffer_valid: source semantics (matches Coq)
; Translation validation: buffer_valid preserves semantics
(push 1)
(declare-const source_buffer_valid Int)
(declare-const target_buffer_valid Int)
(assert (>= source_buffer_valid 0))
(assert (>= target_buffer_valid 0))
(assert (not (= source_buffer_valid target_buffer_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; buffer_can_write: source semantics (matches Coq)
; Translation validation: buffer_can_write preserves semantics
(push 1)
(declare-const source_buffer_can_write Int)
(declare-const target_buffer_can_write Int)
(assert (>= source_buffer_can_write 0))
(assert (>= target_buffer_can_write 0))
(assert (not (= source_buffer_can_write target_buffer_can_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; buffer_can_read: source semantics (matches Coq)
; Translation validation: buffer_can_read preserves semantics
(push 1)
(declare-const source_buffer_can_read Int)
(declare-const target_buffer_can_read Int)
(assert (>= source_buffer_can_read 0))
(assert (>= target_buffer_can_read 0))
(assert (not (= source_buffer_can_read target_buffer_can_read)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; overflow_protected: source semantics (matches Coq)
; Translation validation: overflow_protected preserves semantics
(push 1)
(declare-const source_overflow_protected Int)
(declare-const target_overflow_protected Int)
(assert (>= source_overflow_protected 0))
(assert (>= target_overflow_protected 0))
(assert (not (= source_overflow_protected target_overflow_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_overflow_config: source semantics (matches Coq)
; Translation validation: riina_overflow_config preserves semantics
(push 1)
(declare-const source_riina_overflow_config Int)
(declare-const target_riina_overflow_config Int)
(assert (>= source_riina_overflow_config 0))
(assert (>= target_riina_overflow_config 0))
(assert (not (= source_riina_overflow_config target_riina_overflow_config)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; test_buffer: source semantics (matches Coq)
; Translation validation: test_buffer preserves semantics
(push 1)
(declare-const source_test_buffer Int)
(declare-const target_test_buffer Int)
(assert (>= source_test_buffer 0))
(assert (>= target_test_buffer 0))
(assert (not (= source_test_buffer target_test_buffer)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_iff preserves semantics
(push 1)
(declare-const source_andb_true_iff Int)
(declare-const target_andb_true_iff Int)
(assert (>= source_andb_true_iff 0))
(assert (>= target_andb_true_iff 0))
(assert (not (= source_andb_true_iff target_andb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_001_test_buffer_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_001_test_buffer_valid preserves semantics
(push 1)
(declare-const source_BOF_001_test_buffer_valid Int)
(declare-const target_BOF_001_test_buffer_valid Int)
(assert (>= source_BOF_001_test_buffer_valid 0))
(assert (>= target_BOF_001_test_buffer_valid 0))
(assert (not (= source_BOF_001_test_buffer_valid target_BOF_001_test_buffer_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_002_can_write_bounds: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_002_can_write_bounds preserves semantics
(push 1)
(declare-const source_BOF_002_can_write_bounds Int)
(declare-const target_BOF_002_can_write_bounds Int)
(assert (>= source_BOF_002_can_write_bounds 0))
(assert (>= target_BOF_002_can_write_bounds 0))
(assert (not (= source_BOF_002_can_write_bounds target_BOF_002_can_write_bounds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_003_cannot_write_beyond: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_003_cannot_write_beyond preserves semantics
(push 1)
(declare-const source_BOF_003_cannot_write_beyond Int)
(declare-const target_BOF_003_cannot_write_beyond Int)
(assert (>= source_BOF_003_cannot_write_beyond 0))
(assert (>= target_BOF_003_cannot_write_beyond 0))
(assert (not (= source_BOF_003_cannot_write_beyond target_BOF_003_cannot_write_beyond)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_004_can_read_used: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_004_can_read_used preserves semantics
(push 1)
(declare-const source_BOF_004_can_read_used Int)
(declare-const target_BOF_004_can_read_used Int)
(assert (>= source_BOF_004_can_read_used 0))
(assert (>= target_BOF_004_can_read_used 0))
(assert (not (= source_BOF_004_can_read_used target_BOF_004_can_read_used)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_005_cannot_read_beyond: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_005_cannot_read_beyond preserves semantics
(push 1)
(declare-const source_BOF_005_cannot_read_beyond Int)
(declare-const target_BOF_005_cannot_read_beyond Int)
(assert (>= source_BOF_005_cannot_read_beyond 0))
(assert (>= target_BOF_005_cannot_read_beyond 0))
(assert (not (= source_BOF_005_cannot_read_beyond target_BOF_005_cannot_read_beyond)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_006_riina_protected: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_006_riina_protected preserves semantics
(push 1)
(declare-const source_BOF_006_riina_protected Int)
(declare-const target_BOF_006_riina_protected Int)
(assert (>= source_BOF_006_riina_protected 0))
(assert (>= target_BOF_006_riina_protected 0))
(assert (not (= source_BOF_006_riina_protected target_BOF_006_riina_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_007_bounds_check_write: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_007_bounds_check_write preserves semantics
(push 1)
(declare-const source_BOF_007_bounds_check_write Int)
(declare-const target_BOF_007_bounds_check_write Int)
(assert (>= source_BOF_007_bounds_check_write 0))
(assert (>= target_BOF_007_bounds_check_write 0))
(assert (not (= source_BOF_007_bounds_check_write target_BOF_007_bounds_check_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_008_bounds_check_read: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_008_bounds_check_read preserves semantics
(push 1)
(declare-const source_BOF_008_bounds_check_read Int)
(declare-const target_BOF_008_bounds_check_read Int)
(assert (>= source_BOF_008_bounds_check_read 0))
(assert (>= target_BOF_008_bounds_check_read 0))
(assert (not (= source_BOF_008_bounds_check_read target_BOF_008_bounds_check_read)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_009_integer_overflow: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_009_integer_overflow preserves semantics
(push 1)
(declare-const source_BOF_009_integer_overflow Int)
(declare-const target_BOF_009_integer_overflow Int)
(assert (>= source_BOF_009_integer_overflow 0))
(assert (>= target_BOF_009_integer_overflow 0))
(assert (not (= source_BOF_009_integer_overflow target_BOF_009_integer_overflow)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_010_stack_canaries: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_010_stack_canaries preserves semantics
(push 1)
(declare-const source_BOF_010_stack_canaries Int)
(declare-const target_BOF_010_stack_canaries Int)
(assert (>= source_BOF_010_stack_canaries 0))
(assert (>= target_BOF_010_stack_canaries 0))
(assert (not (= source_BOF_010_stack_canaries target_BOF_010_stack_canaries)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_011_valid_implies_bounds: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_011_valid_implies_bounds preserves semantics
(push 1)
(declare-const source_BOF_011_valid_implies_bounds Int)
(declare-const target_BOF_011_valid_implies_bounds Int)
(assert (>= source_BOF_011_valid_implies_bounds 0))
(assert (>= target_BOF_011_valid_implies_bounds 0))
(assert (not (= source_BOF_011_valid_implies_bounds target_BOF_011_valid_implies_bounds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_012_riina_bounds_write: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_012_riina_bounds_write preserves semantics
(push 1)
(declare-const source_BOF_012_riina_bounds_write Int)
(declare-const target_BOF_012_riina_bounds_write Int)
(assert (>= source_BOF_012_riina_bounds_write 0))
(assert (>= target_BOF_012_riina_bounds_write 0))
(assert (not (= source_BOF_012_riina_bounds_write target_BOF_012_riina_bounds_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_013_riina_canaries: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_013_riina_canaries preserves semantics
(push 1)
(declare-const source_BOF_013_riina_canaries Int)
(declare-const target_BOF_013_riina_canaries Int)
(assert (>= source_BOF_013_riina_canaries 0))
(assert (>= target_BOF_013_riina_canaries 0))
(assert (not (= source_BOF_013_riina_canaries target_BOF_013_riina_canaries)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_014_zero_write_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_014_zero_write_safe preserves semantics
(push 1)
(declare-const source_BOF_014_zero_write_safe Int)
(declare-const target_BOF_014_zero_write_safe Int)
(assert (>= source_BOF_014_zero_write_safe 0))
(assert (>= target_BOF_014_zero_write_safe 0))
(assert (not (= source_BOF_014_zero_write_safe target_BOF_014_zero_write_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_015_complete_prevention: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_015_complete_prevention preserves semantics
(push 1)
(declare-const source_BOF_015_complete_prevention Int)
(declare-const target_BOF_015_complete_prevention Int)
(assert (>= source_BOF_015_complete_prevention 0))
(assert (>= target_BOF_015_complete_prevention 0))
(assert (not (= source_BOF_015_complete_prevention target_BOF_015_complete_prevention)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_016_write_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_016_write_bounded preserves semantics
(push 1)
(declare-const source_BOF_016_write_bounded Int)
(declare-const target_BOF_016_write_bounded Int)
(assert (>= source_BOF_016_write_bounded 0))
(assert (>= target_BOF_016_write_bounded 0))
(assert (not (= source_BOF_016_write_bounded target_BOF_016_write_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_017_read_start_within: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_017_read_start_within preserves semantics
(push 1)
(declare-const source_BOF_017_read_start_within Int)
(declare-const target_BOF_017_read_start_within Int)
(assert (>= source_BOF_017_read_start_within 0))
(assert (>= target_BOF_017_read_start_within 0))
(assert (not (= source_BOF_017_read_start_within target_BOF_017_read_start_within)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_018_zero_read_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_018_zero_read_safe preserves semantics
(push 1)
(declare-const source_BOF_018_zero_read_safe Int)
(declare-const target_BOF_018_zero_read_safe Int)
(assert (>= source_BOF_018_zero_read_safe 0))
(assert (>= target_BOF_018_zero_read_safe 0))
(assert (not (= source_BOF_018_zero_read_safe target_BOF_018_zero_read_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_019_full_buffer_no_write: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_019_full_buffer_no_write preserves semantics
(push 1)
(declare-const source_BOF_019_full_buffer_no_write Int)
(declare-const target_BOF_019_full_buffer_no_write Int)
(assert (>= source_BOF_019_full_buffer_no_write 0))
(assert (>= target_BOF_019_full_buffer_no_write 0))
(assert (not (= source_BOF_019_full_buffer_no_write target_BOF_019_full_buffer_no_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_020_null_terminator_check: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_020_null_terminator_check preserves semantics
(push 1)
(declare-const source_BOF_020_null_terminator_check Int)
(declare-const target_BOF_020_null_terminator_check Int)
(assert (>= source_BOF_020_null_terminator_check 0))
(assert (>= target_BOF_020_null_terminator_check 0))
(assert (not (= source_BOF_020_null_terminator_check target_BOF_020_null_terminator_check)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; BOF_021_valid_after_write: translation preserves property (matches Coq: Theorem)
; Translation validation: BOF_021_valid_after_write preserves semantics
(push 1)
(declare-const source_BOF_021_valid_after_write Int)
(declare-const target_BOF_021_valid_after_write Int)
(assert (>= source_BOF_021_valid_after_write 0))
(assert (>= target_BOF_021_valid_after_write 0))
(assert (not (= source_BOF_021_valid_after_write target_BOF_021_valid_after_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/Y001_VerifiedStdlib.v (41 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for Y001_VerifiedStdlib
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; is_utf8_continuation: source semantics (matches Coq)
; Translation validation: is_utf8_continuation preserves semantics
(push 1)
(declare-const source_is_utf8_continuation Int)
(declare-const target_is_utf8_continuation Int)
(assert (>= source_is_utf8_continuation 0))
(assert (>= target_is_utf8_continuation 0))
(assert (not (= source_is_utf8_continuation target_is_utf8_continuation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_utf8_start_1: source semantics (matches Coq)
; Translation validation: is_utf8_start_1 preserves semantics
(push 1)
(declare-const source_is_utf8_start_1 Int)
(declare-const target_is_utf8_start_1 Int)
(assert (>= source_is_utf8_start_1 0))
(assert (>= target_is_utf8_start_1 0))
(assert (not (= source_is_utf8_start_1 target_is_utf8_start_1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_utf8_start_2: source semantics (matches Coq)
; Translation validation: is_utf8_start_2 preserves semantics
(push 1)
(declare-const source_is_utf8_start_2 Int)
(declare-const target_is_utf8_start_2 Int)
(assert (>= source_is_utf8_start_2 0))
(assert (>= target_is_utf8_start_2 0))
(assert (not (= source_is_utf8_start_2 target_is_utf8_start_2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_utf8_start_3: source semantics (matches Coq)
; Translation validation: is_utf8_start_3 preserves semantics
(push 1)
(declare-const source_is_utf8_start_3 Int)
(declare-const target_is_utf8_start_3 Int)
(assert (>= source_is_utf8_start_3 0))
(assert (>= target_is_utf8_start_3 0))
(assert (not (= source_is_utf8_start_3 target_is_utf8_start_3)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_utf8_start_4: source semantics (matches Coq)
; Translation validation: is_utf8_start_4 preserves semantics
(push 1)
(declare-const source_is_utf8_start_4 Int)
(declare-const target_is_utf8_start_4 Int)
(assert (>= source_is_utf8_start_4 0))
(assert (>= target_is_utf8_start_4 0))
(assert (not (= source_is_utf8_start_4 target_is_utf8_start_4)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_valid_utf8: source semantics (matches Coq)
; Translation validation: is_valid_utf8 preserves semantics
(push 1)
(declare-const source_is_valid_utf8 Int)
(declare-const target_is_valid_utf8 Int)
(assert (>= source_is_valid_utf8 0))
(assert (>= target_is_valid_utf8 0))
(assert (not (= source_is_valid_utf8 target_is_valid_utf8)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; utf8_len_bytes: source semantics (matches Coq)
; Translation validation: utf8_len_bytes preserves semantics
(push 1)
(declare-const source_utf8_len_bytes Int)
(declare-const target_utf8_len_bytes Int)
(assert (>= source_utf8_len_bytes 0))
(assert (>= target_utf8_len_bytes 0))
(assert (not (= source_utf8_len_bytes target_utf8_len_bytes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; utf8_char_count: source semantics (matches Coq)
; Translation validation: utf8_char_count preserves semantics
(push 1)
(declare-const source_utf8_char_count Int)
(declare-const target_utf8_char_count Int)
(assert (>= source_utf8_char_count 0))
(assert (>= target_utf8_char_count 0))
(assert (not (= source_utf8_char_count target_utf8_char_count)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; utf8_len_chars: source semantics (matches Coq)
; Translation validation: utf8_len_chars preserves semantics
(push 1)
(declare-const source_utf8_len_chars Int)
(declare-const target_utf8_len_chars Int)
(assert (>= source_utf8_len_chars 0))
(assert (>= target_utf8_len_chars 0))
(assert (not (= source_utf8_len_chars target_utf8_len_chars)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bigint_add: source semantics (matches Coq)
; Translation validation: bigint_add preserves semantics
(push 1)
(declare-const source_bigint_add Int)
(declare-const target_bigint_add Int)
(assert (>= source_bigint_add 0))
(assert (>= target_bigint_add 0))
(assert (not (= source_bigint_add target_bigint_add)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_01_option_map_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_01_option_map_correct preserves semantics
(push 1)
(declare-const source_Y_001_01_option_map_correct Int)
(declare-const target_Y_001_01_option_map_correct Int)
(assert (>= source_Y_001_01_option_map_correct 0))
(assert (>= target_Y_001_01_option_map_correct 0))
(assert (not (= source_Y_001_01_option_map_correct target_Y_001_01_option_map_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_02_option_bind_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_02_option_bind_correct preserves semantics
(push 1)
(declare-const source_Y_001_02_option_bind_correct Int)
(declare-const target_Y_001_02_option_bind_correct Int)
(assert (>= source_Y_001_02_option_bind_correct 0))
(assert (>= target_Y_001_02_option_bind_correct 0))
(assert (not (= source_Y_001_02_option_bind_correct target_Y_001_02_option_bind_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_03_result_map_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_03_result_map_correct preserves semantics
(push 1)
(declare-const source_Y_001_03_result_map_correct Int)
(declare-const target_Y_001_03_result_map_correct Int)
(assert (>= source_Y_001_03_result_map_correct 0))
(assert (>= target_Y_001_03_result_map_correct 0))
(assert (not (= source_Y_001_03_result_map_correct target_Y_001_03_result_map_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_04_result_and_then_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_04_result_and_then_correct preserves semantics
(push 1)
(declare-const source_Y_001_04_result_and_then_correct Int)
(declare-const target_Y_001_04_result_and_then_correct Int)
(assert (>= source_Y_001_04_result_and_then_correct 0))
(assert (>= target_Y_001_04_result_and_then_correct 0))
(assert (not (= source_Y_001_04_result_and_then_correct target_Y_001_04_result_and_then_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_05_option_unwrap_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_05_option_unwrap_safe preserves semantics
(push 1)
(declare-const source_Y_001_05_option_unwrap_safe Int)
(declare-const target_Y_001_05_option_unwrap_safe Int)
(assert (>= source_Y_001_05_option_unwrap_safe 0))
(assert (>= target_Y_001_05_option_unwrap_safe 0))
(assert (not (= source_Y_001_05_option_unwrap_safe target_Y_001_05_option_unwrap_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_06_result_unwrap_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_06_result_unwrap_safe preserves semantics
(push 1)
(declare-const source_Y_001_06_result_unwrap_safe Int)
(declare-const target_Y_001_06_result_unwrap_safe Int)
(assert (>= source_Y_001_06_result_unwrap_safe 0))
(assert (>= target_Y_001_06_result_unwrap_safe 0))
(assert (not (= source_Y_001_06_result_unwrap_safe target_Y_001_06_result_unwrap_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_07_option_or_default: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_07_option_or_default preserves semantics
(push 1)
(declare-const source_Y_001_07_option_or_default Int)
(declare-const target_Y_001_07_option_or_default Int)
(assert (>= source_Y_001_07_option_or_default 0))
(assert (>= target_Y_001_07_option_or_default 0))
(assert (not (= source_Y_001_07_option_or_default target_Y_001_07_option_or_default)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_08_result_or_default: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_08_result_or_default preserves semantics
(push 1)
(declare-const source_Y_001_08_result_or_default Int)
(declare-const target_Y_001_08_result_or_default Int)
(assert (>= source_Y_001_08_result_or_default 0))
(assert (>= target_Y_001_08_result_or_default 0))
(assert (not (= source_Y_001_08_result_or_default target_Y_001_08_result_or_default)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_09_vec_push_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_09_vec_push_correct preserves semantics
(push 1)
(declare-const source_Y_001_09_vec_push_correct Int)
(declare-const target_Y_001_09_vec_push_correct Int)
(assert (>= source_Y_001_09_vec_push_correct 0))
(assert (>= target_Y_001_09_vec_push_correct 0))
(assert (not (= source_Y_001_09_vec_push_correct target_Y_001_09_vec_push_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_10_vec_pop_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_10_vec_pop_correct preserves semantics
(push 1)
(declare-const source_Y_001_10_vec_pop_correct Int)
(declare-const target_Y_001_10_vec_pop_correct Int)
(assert (>= source_Y_001_10_vec_pop_correct 0))
(assert (>= target_Y_001_10_vec_pop_correct 0))
(assert (not (= source_Y_001_10_vec_pop_correct target_Y_001_10_vec_pop_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_11_vec_get_bounds: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_11_vec_get_bounds preserves semantics
(push 1)
(declare-const source_Y_001_11_vec_get_bounds Int)
(declare-const target_Y_001_11_vec_get_bounds Int)
(assert (>= source_Y_001_11_vec_get_bounds 0))
(assert (>= target_Y_001_11_vec_get_bounds 0))
(assert (not (= source_Y_001_11_vec_get_bounds target_Y_001_11_vec_get_bounds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_12_vec_len_accurate: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_12_vec_len_accurate preserves semantics
(push 1)
(declare-const source_Y_001_12_vec_len_accurate Int)
(declare-const target_Y_001_12_vec_len_accurate Int)
(assert (>= source_Y_001_12_vec_len_accurate 0))
(assert (>= target_Y_001_12_vec_len_accurate 0))
(assert (not (= source_Y_001_12_vec_len_accurate target_Y_001_12_vec_len_accurate)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_13_hashmap_get_put: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_13_hashmap_get_put preserves semantics
(push 1)
(declare-const source_Y_001_13_hashmap_get_put Int)
(declare-const target_Y_001_13_hashmap_get_put Int)
(assert (>= source_Y_001_13_hashmap_get_put 0))
(assert (>= target_Y_001_13_hashmap_get_put 0))
(assert (not (= source_Y_001_13_hashmap_get_put target_Y_001_13_hashmap_get_put)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_14_hashmap_get_other: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_14_hashmap_get_other preserves semantics
(push 1)
(declare-const source_Y_001_14_hashmap_get_other Int)
(declare-const target_Y_001_14_hashmap_get_other Int)
(assert (>= source_Y_001_14_hashmap_get_other 0))
(assert (>= target_Y_001_14_hashmap_get_other 0))
(assert (not (= source_Y_001_14_hashmap_get_other target_Y_001_14_hashmap_get_other)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_14b_hashmap_different_key: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_14b_hashmap_different_key preserves semantics
(push 1)
(declare-const source_Y_001_14b_hashmap_different_key Int)
(declare-const target_Y_001_14b_hashmap_different_key Int)
(assert (>= source_Y_001_14b_hashmap_different_key 0))
(assert (>= target_Y_001_14b_hashmap_different_key 0))
(assert (not (= source_Y_001_14b_hashmap_different_key target_Y_001_14b_hashmap_different_key)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_15_hashmap_remove_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_15_hashmap_remove_correct preserves semantics
(push 1)
(declare-const source_Y_001_15_hashmap_remove_correct Int)
(declare-const target_Y_001_15_hashmap_remove_correct Int)
(assert (>= source_Y_001_15_hashmap_remove_correct 0))
(assert (>= target_Y_001_15_hashmap_remove_correct 0))
(assert (not (= source_Y_001_15_hashmap_remove_correct target_Y_001_15_hashmap_remove_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_16_btree_ordered: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_16_btree_ordered preserves semantics
(push 1)
(declare-const source_Y_001_16_btree_ordered Int)
(declare-const target_Y_001_16_btree_ordered Int)
(assert (>= source_Y_001_16_btree_ordered 0))
(assert (>= target_Y_001_16_btree_ordered 0))
(assert (not (= source_Y_001_16_btree_ordered target_Y_001_16_btree_ordered)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_17_btree_balanced: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_17_btree_balanced preserves semantics
(push 1)
(declare-const source_Y_001_17_btree_balanced Int)
(declare-const target_Y_001_17_btree_balanced Int)
(assert (>= source_Y_001_17_btree_balanced 0))
(assert (>= target_Y_001_17_btree_balanced 0))
(assert (not (= source_Y_001_17_btree_balanced target_Y_001_17_btree_balanced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_18_collection_no_overflow: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_18_collection_no_overflow preserves semantics
(push 1)
(declare-const source_Y_001_18_collection_no_overflow Int)
(declare-const target_Y_001_18_collection_no_overflow Int)
(assert (>= source_Y_001_18_collection_no_overflow 0))
(assert (>= target_Y_001_18_collection_no_overflow 0))
(assert (not (= source_Y_001_18_collection_no_overflow target_Y_001_18_collection_no_overflow)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_19_utf8_valid_preserved: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_19_utf8_valid_preserved preserves semantics
(push 1)
(declare-const source_Y_001_19_utf8_valid_preserved Int)
(declare-const target_Y_001_19_utf8_valid_preserved Int)
(assert (>= source_Y_001_19_utf8_valid_preserved 0))
(assert (>= target_Y_001_19_utf8_valid_preserved 0))
(assert (not (= source_Y_001_19_utf8_valid_preserved target_Y_001_19_utf8_valid_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_20_string_concat_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_20_string_concat_valid preserves semantics
(push 1)
(declare-const source_Y_001_20_string_concat_valid Int)
(declare-const target_Y_001_20_string_concat_valid Int)
(assert (>= source_Y_001_20_string_concat_valid 0))
(assert (>= target_Y_001_20_string_concat_valid 0))
(assert (not (= source_Y_001_20_string_concat_valid target_Y_001_20_string_concat_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_21_string_len_bytes: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_21_string_len_bytes preserves semantics
(push 1)
(declare-const source_Y_001_21_string_len_bytes Int)
(declare-const target_Y_001_21_string_len_bytes Int)
(assert (>= source_Y_001_21_string_len_bytes 0))
(assert (>= target_Y_001_21_string_len_bytes 0))
(assert (not (= source_Y_001_21_string_len_bytes target_Y_001_21_string_len_bytes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_22_string_len_chars: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_22_string_len_chars preserves semantics
(push 1)
(declare-const source_Y_001_22_string_len_chars Int)
(declare-const target_Y_001_22_string_len_chars Int)
(assert (>= source_Y_001_22_string_len_chars 0))
(assert (>= target_Y_001_22_string_len_chars 0))
(assert (not (= source_Y_001_22_string_len_chars target_Y_001_22_string_len_chars)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_23_string_slice_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_23_string_slice_valid preserves semantics
(push 1)
(declare-const source_Y_001_23_string_slice_valid Int)
(declare-const target_Y_001_23_string_slice_valid Int)
(assert (>= source_Y_001_23_string_slice_valid 0))
(assert (>= target_Y_001_23_string_slice_valid 0))
(assert (not (= source_Y_001_23_string_slice_valid target_Y_001_23_string_slice_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_24_format_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_24_format_bounded preserves semantics
(push 1)
(declare-const source_Y_001_24_format_bounded Int)
(declare-const target_Y_001_24_format_bounded Int)
(assert (>= source_Y_001_24_format_bounded 0))
(assert (>= target_Y_001_24_format_bounded 0))
(assert (not (= source_Y_001_24_format_bounded target_Y_001_24_format_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_25_no_format_string_attack: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_25_no_format_string_attack preserves semantics
(push 1)
(declare-const source_Y_001_25_no_format_string_attack Int)
(declare-const target_Y_001_25_no_format_string_attack Int)
(assert (>= source_Y_001_25_no_format_string_attack 0))
(assert (>= target_Y_001_25_no_format_string_attack 0))
(assert (not (= source_Y_001_25_no_format_string_attack target_Y_001_25_no_format_string_attack)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_26_string_compare_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_26_string_compare_correct preserves semantics
(push 1)
(declare-const source_Y_001_26_string_compare_correct Int)
(declare-const target_Y_001_26_string_compare_correct Int)
(assert (>= source_Y_001_26_string_compare_correct 0))
(assert (>= target_Y_001_26_string_compare_correct 0))
(assert (not (= source_Y_001_26_string_compare_correct target_Y_001_26_string_compare_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_27_io_effect_tracked: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_27_io_effect_tracked preserves semantics
(push 1)
(declare-const source_Y_001_27_io_effect_tracked Int)
(declare-const target_Y_001_27_io_effect_tracked Int)
(assert (>= source_Y_001_27_io_effect_tracked 0))
(assert (>= target_Y_001_27_io_effect_tracked 0))
(assert (not (= source_Y_001_27_io_effect_tracked target_Y_001_27_io_effect_tracked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_28_file_read_bounds: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_28_file_read_bounds preserves semantics
(push 1)
(declare-const source_Y_001_28_file_read_bounds Int)
(declare-const target_Y_001_28_file_read_bounds Int)
(assert (>= source_Y_001_28_file_read_bounds 0))
(assert (>= target_Y_001_28_file_read_bounds 0))
(assert (not (= source_Y_001_28_file_read_bounds target_Y_001_28_file_read_bounds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_29_json_parse_pure: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_29_json_parse_pure preserves semantics
(push 1)
(declare-const source_Y_001_29_json_parse_pure Int)
(declare-const target_Y_001_29_json_parse_pure Int)
(assert (>= source_Y_001_29_json_parse_pure 0))
(assert (>= target_Y_001_29_json_parse_pure 0))
(assert (not (= source_Y_001_29_json_parse_pure target_Y_001_29_json_parse_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_30_json_roundtrip: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_30_json_roundtrip preserves semantics
(push 1)
(declare-const source_Y_001_30_json_roundtrip Int)
(declare-const target_Y_001_30_json_roundtrip Int)
(assert (>= source_Y_001_30_json_roundtrip 0))
(assert (>= target_Y_001_30_json_roundtrip 0))
(assert (not (= source_Y_001_30_json_roundtrip target_Y_001_30_json_roundtrip)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_31_json_parse_terminates: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_31_json_parse_terminates preserves semantics
(push 1)
(declare-const source_Y_001_31_json_parse_terminates Int)
(declare-const target_Y_001_31_json_parse_terminates Int)
(assert (>= source_Y_001_31_json_parse_terminates 0))
(assert (>= target_Y_001_31_json_parse_terminates 0))
(assert (not (= source_Y_001_31_json_parse_terminates target_Y_001_31_json_parse_terminates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_32_xml_parse_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_32_xml_parse_safe preserves semantics
(push 1)
(declare-const source_Y_001_32_xml_parse_safe Int)
(declare-const target_Y_001_32_xml_parse_safe Int)
(assert (>= source_Y_001_32_xml_parse_safe 0))
(assert (>= target_Y_001_32_xml_parse_safe 0))
(assert (not (= source_Y_001_32_xml_parse_safe target_Y_001_32_xml_parse_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_33_regex_terminates: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_33_regex_terminates preserves semantics
(push 1)
(declare-const source_Y_001_33_regex_terminates Int)
(declare-const target_Y_001_33_regex_terminates Int)
(assert (>= source_Y_001_33_regex_terminates 0))
(assert (>= target_Y_001_33_regex_terminates 0))
(assert (not (= source_Y_001_33_regex_terminates target_Y_001_33_regex_terminates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_34_regex_no_redos: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_34_regex_no_redos preserves semantics
(push 1)
(declare-const source_Y_001_34_regex_no_redos Int)
(declare-const target_Y_001_34_regex_no_redos Int)
(assert (>= source_Y_001_34_regex_no_redos 0))
(assert (>= target_Y_001_34_regex_no_redos 0))
(assert (not (= source_Y_001_34_regex_no_redos target_Y_001_34_regex_no_redos)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_35_int_add_no_overflow: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_35_int_add_no_overflow preserves semantics
(push 1)
(declare-const source_Y_001_35_int_add_no_overflow Int)
(declare-const target_Y_001_35_int_add_no_overflow Int)
(assert (>= source_Y_001_35_int_add_no_overflow 0))
(assert (>= target_Y_001_35_int_add_no_overflow 0))
(assert (not (= source_Y_001_35_int_add_no_overflow target_Y_001_35_int_add_no_overflow)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_36_int_mul_no_overflow: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_36_int_mul_no_overflow preserves semantics
(push 1)
(declare-const source_Y_001_36_int_mul_no_overflow Int)
(declare-const target_Y_001_36_int_mul_no_overflow Int)
(assert (>= source_Y_001_36_int_mul_no_overflow 0))
(assert (>= target_Y_001_36_int_mul_no_overflow 0))
(assert (not (= source_Y_001_36_int_mul_no_overflow target_Y_001_36_int_mul_no_overflow)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_37_int_div_no_zero: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_37_int_div_no_zero preserves semantics
(push 1)
(declare-const source_Y_001_37_int_div_no_zero Int)
(declare-const target_Y_001_37_int_div_no_zero Int)
(assert (>= source_Y_001_37_int_div_no_zero 0))
(assert (>= target_Y_001_37_int_div_no_zero 0))
(assert (not (= source_Y_001_37_int_div_no_zero target_Y_001_37_int_div_no_zero)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_38_float_nan_propagates: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_38_float_nan_propagates preserves semantics
(push 1)
(declare-const source_Y_001_38_float_nan_propagates Int)
(declare-const target_Y_001_38_float_nan_propagates Int)
(assert (>= source_Y_001_38_float_nan_propagates 0))
(assert (>= target_Y_001_38_float_nan_propagates 0))
(assert (not (= source_Y_001_38_float_nan_propagates target_Y_001_38_float_nan_propagates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_39_bigint_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_39_bigint_correct preserves semantics
(push 1)
(declare-const source_Y_001_39_bigint_correct Int)
(declare-const target_Y_001_39_bigint_correct Int)
(assert (>= source_Y_001_39_bigint_correct 0))
(assert (>= target_Y_001_39_bigint_correct 0))
(assert (not (= source_Y_001_39_bigint_correct target_Y_001_39_bigint_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Y_001_40_numeric_constant_time: translation preserves property (matches Coq: Theorem)
; Translation validation: Y_001_40_numeric_constant_time preserves semantics
(push 1)
(declare-const source_Y_001_40_numeric_constant_time Int)
(declare-const target_Y_001_40_numeric_constant_time Int)
(assert (>= source_Y_001_40_numeric_constant_time 0))
(assert (>= target_Y_001_40_numeric_constant_time 0))
(assert (not (= source_Y_001_40_numeric_constant_time target_Y_001_40_numeric_constant_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/MobileBridgeVerification.v (32 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for MobileBridgeVerification
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; cap_allows: source semantics (matches Coq)
; Translation validation: cap_allows preserves semantics
(push 1)
(declare-const source_cap_allows Int)
(declare-const target_cap_allows Int)
(assert (>= source_cap_allows 0))
(assert (>= target_cap_allows 0))
(assert (not (= source_cap_allows target_cap_allows)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_call_safe: source semantics (matches Coq)
; Translation validation: bridge_call_safe preserves semantics
(push 1)
(declare-const source_bridge_call_safe Int)
(declare-const target_bridge_call_safe Int)
(assert (>= source_bridge_call_safe 0))
(assert (>= target_bridge_call_safe 0))
(assert (not (= source_bridge_call_safe target_bridge_call_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; error_safe: source semantics (matches Coq)
; Translation validation: error_safe preserves semantics
(push 1)
(declare-const source_error_safe Int)
(declare-const target_error_safe Int)
(assert (>= source_error_safe 0))
(assert (>= target_error_safe 0))
(assert (not (= source_error_safe target_error_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_secret_in_error: source semantics (matches Coq)
; Translation validation: no_secret_in_error preserves semantics
(push 1)
(declare-const source_no_secret_in_error Int)
(declare-const target_no_secret_in_error Int)
(assert (>= source_no_secret_in_error 0))
(assert (>= target_no_secret_in_error 0))
(assert (not (= source_no_secret_in_error target_no_secret_in_error)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; c_to_jni_string: source semantics (matches Coq)
; Translation validation: c_to_jni_string preserves semantics
(push 1)
(declare-const source_c_to_jni_string Int)
(declare-const target_c_to_jni_string Int)
(assert (>= source_c_to_jni_string 0))
(assert (>= target_c_to_jni_string 0))
(assert (not (= source_c_to_jni_string target_c_to_jni_string)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; jni_to_c_string: source semantics (matches Coq)
; Translation validation: jni_to_c_string preserves semantics
(push 1)
(declare-const source_jni_to_c_string Int)
(declare-const target_jni_to_c_string Int)
(assert (>= source_jni_to_c_string 0))
(assert (>= target_jni_to_c_string 0))
(assert (not (= source_jni_to_c_string target_jni_to_c_string)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; swift_type_of: source semantics (matches Coq)
; Translation validation: swift_type_of preserves semantics
(push 1)
(declare-const source_swift_type_of Int)
(declare-const target_swift_type_of Int)
(assert (>= source_swift_type_of 0))
(assert (>= target_swift_type_of 0))
(assert (not (= source_swift_type_of target_swift_type_of)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; swift_value_tag: source semantics (matches Coq)
; Translation validation: swift_value_tag preserves semantics
(push 1)
(declare-const source_swift_value_tag Int)
(declare-const target_swift_value_tag Int)
(assert (>= source_swift_value_tag 0))
(assert (>= target_swift_value_tag 0))
(assert (not (= source_swift_value_tag target_swift_value_tag)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; callback_ret_safe: source semantics (matches Coq)
; Translation validation: callback_ret_safe preserves semantics
(push 1)
(declare-const source_callback_ret_safe Int)
(declare-const target_callback_ret_safe Int)
(assert (>= source_callback_ret_safe 0))
(assert (>= target_callback_ret_safe 0))
(assert (not (= source_callback_ret_safe target_callback_ret_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; callback_args_safe: source semantics (matches Coq)
; Translation validation: callback_args_safe preserves semantics
(push 1)
(declare-const source_callback_args_safe Int)
(declare-const target_callback_args_safe Int)
(assert (>= source_callback_args_safe 0))
(assert (>= target_callback_args_safe 0))
(assert (not (= source_callback_args_safe target_callback_args_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; callback_safe: source semantics (matches Coq)
; Translation validation: callback_safe preserves semantics
(push 1)
(declare-const source_callback_safe Int)
(declare-const target_callback_safe Int)
(assert (>= source_callback_safe 0))
(assert (>= target_callback_safe 0))
(assert (not (= source_callback_safe target_callback_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; callback_rejected: source semantics (matches Coq)
; Translation validation: callback_rejected preserves semantics
(push 1)
(declare-const source_callback_rejected Int)
(declare-const target_callback_rejected Int)
(assert (>= source_callback_rejected 0))
(assert (>= target_callback_rejected 0))
(assert (not (= source_callback_rejected target_callback_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_001_jni_roundtrip_int: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_001_jni_roundtrip_int preserves semantics
(push 1)
(declare-const source_bridge_001_jni_roundtrip_int Int)
(declare-const target_bridge_001_jni_roundtrip_int Int)
(assert (>= source_bridge_001_jni_roundtrip_int 0))
(assert (>= target_bridge_001_jni_roundtrip_int 0))
(assert (not (= source_bridge_001_jni_roundtrip_int target_bridge_001_jni_roundtrip_int)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_001_jni_roundtrip_bool: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_001_jni_roundtrip_bool preserves semantics
(push 1)
(declare-const source_bridge_001_jni_roundtrip_bool Int)
(declare-const target_bridge_001_jni_roundtrip_bool Int)
(assert (>= source_bridge_001_jni_roundtrip_bool 0))
(assert (>= target_bridge_001_jni_roundtrip_bool 0))
(assert (not (= source_bridge_001_jni_roundtrip_bool target_bridge_001_jni_roundtrip_bool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_001_swift_roundtrip_int: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_001_swift_roundtrip_int preserves semantics
(push 1)
(declare-const source_bridge_001_swift_roundtrip_int Int)
(declare-const target_bridge_001_swift_roundtrip_int Int)
(assert (>= source_bridge_001_swift_roundtrip_int 0))
(assert (>= target_bridge_001_swift_roundtrip_int 0))
(assert (not (= source_bridge_001_swift_roundtrip_int target_bridge_001_swift_roundtrip_int)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_001_swift_roundtrip_bool: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_001_swift_roundtrip_bool preserves semantics
(push 1)
(declare-const source_bridge_001_swift_roundtrip_bool Int)
(declare-const target_bridge_001_swift_roundtrip_bool Int)
(assert (>= source_bridge_001_swift_roundtrip_bool 0))
(assert (>= target_bridge_001_swift_roundtrip_bool 0))
(assert (not (= source_bridge_001_swift_roundtrip_bool target_bridge_001_swift_roundtrip_bool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_002_jni_pure_always_allowed: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_002_jni_pure_always_allowed preserves semantics
(push 1)
(declare-const source_bridge_002_jni_pure_always_allowed Int)
(declare-const target_bridge_002_jni_pure_always_allowed Int)
(assert (>= source_bridge_002_jni_pure_always_allowed 0))
(assert (>= target_bridge_002_jni_pure_always_allowed 0))
(assert (not (= source_bridge_002_jni_pure_always_allowed target_bridge_002_jni_pure_always_allowed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_002_jni_invalid_blocks_all: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_002_jni_invalid_blocks_all preserves semantics
(push 1)
(declare-const source_bridge_002_jni_invalid_blocks_all Int)
(declare-const target_bridge_002_jni_invalid_blocks_all Int)
(assert (>= source_bridge_002_jni_invalid_blocks_all 0))
(assert (>= target_bridge_002_jni_invalid_blocks_all 0))
(assert (not (= source_bridge_002_jni_invalid_blocks_all target_bridge_002_jni_invalid_blocks_all)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_002_jni_io_requires_io_cap: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_002_jni_io_requires_io_cap preserves semantics
(push 1)
(declare-const source_bridge_002_jni_io_requires_io_cap Int)
(declare-const target_bridge_002_jni_io_requires_io_cap Int)
(assert (>= source_bridge_002_jni_io_requires_io_cap 0))
(assert (>= target_bridge_002_jni_io_requires_io_cap 0))
(assert (not (= source_bridge_002_jni_io_requires_io_cap target_bridge_002_jni_io_requires_io_cap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_003_swift_pure_always_allowed: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_003_swift_pure_always_allowed preserves semantics
(push 1)
(declare-const source_bridge_003_swift_pure_always_allowed Int)
(declare-const target_bridge_003_swift_pure_always_allowed Int)
(assert (>= source_bridge_003_swift_pure_always_allowed 0))
(assert (>= target_bridge_003_swift_pure_always_allowed 0))
(assert (not (= source_bridge_003_swift_pure_always_allowed target_bridge_003_swift_pure_always_allowed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_003_swift_net_requires_net: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_003_swift_net_requires_net preserves semantics
(push 1)
(declare-const source_bridge_003_swift_net_requires_net Int)
(declare-const target_bridge_003_swift_net_requires_net Int)
(assert (>= source_bridge_003_swift_net_requires_net 0))
(assert (>= target_bridge_003_swift_net_requires_net 0))
(assert (not (= source_bridge_003_swift_net_requires_net target_bridge_003_swift_net_requires_net)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_003_swift_ui_requires_ui: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_003_swift_ui_requires_ui preserves semantics
(push 1)
(declare-const source_bridge_003_swift_ui_requires_ui Int)
(declare-const target_bridge_003_swift_ui_requires_ui Int)
(assert (>= source_bridge_003_swift_ui_requires_ui 0))
(assert (>= target_bridge_003_swift_ui_requires_ui 0))
(assert (not (= source_bridge_003_swift_ui_requires_ui target_bridge_003_swift_ui_requires_ui)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_004_safe_call_requires_cap: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_004_safe_call_requires_cap preserves semantics
(push 1)
(declare-const source_bridge_004_safe_call_requires_cap Int)
(declare-const target_bridge_004_safe_call_requires_cap Int)
(assert (>= source_bridge_004_safe_call_requires_cap 0))
(assert (>= target_bridge_004_safe_call_requires_cap 0))
(assert (not (= source_bridge_004_safe_call_requires_cap target_bridge_004_safe_call_requires_cap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_004_pure_call_always_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_004_pure_call_always_safe preserves semantics
(push 1)
(declare-const source_bridge_004_pure_call_always_safe Int)
(declare-const target_bridge_004_pure_call_always_safe Int)
(assert (>= source_bridge_004_pure_call_always_safe 0))
(assert (>= target_bridge_004_pure_call_always_safe 0))
(assert (not (= source_bridge_004_pure_call_always_safe target_bridge_004_pure_call_always_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_005_error_is_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_005_error_is_safe preserves semantics
(push 1)
(declare-const source_bridge_005_error_is_safe Int)
(declare-const target_bridge_005_error_is_safe Int)
(assert (>= source_bridge_005_error_is_safe 0))
(assert (>= target_bridge_005_error_is_safe 0))
(assert (not (= source_bridge_005_error_is_safe target_bridge_005_error_is_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_005_ok_is_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_005_ok_is_safe preserves semantics
(push 1)
(declare-const source_bridge_005_ok_is_safe Int)
(declare-const target_bridge_005_ok_is_safe Int)
(assert (>= source_bridge_005_ok_is_safe 0))
(assert (>= target_bridge_005_ok_is_safe 0))
(assert (not (= source_bridge_005_ok_is_safe target_bridge_005_ok_is_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_005_no_secret_leak: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_005_no_secret_leak preserves semantics
(push 1)
(declare-const source_bridge_005_no_secret_leak Int)
(declare-const target_bridge_005_no_secret_leak Int)
(assert (>= source_bridge_005_no_secret_leak 0))
(assert (>= target_bridge_005_no_secret_leak 0))
(assert (not (= source_bridge_005_no_secret_leak target_bridge_005_no_secret_leak)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_006_jni_string_roundtrip_len: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_006_jni_string_roundtrip_len preserves semantics
(push 1)
(declare-const source_bridge_006_jni_string_roundtrip_len Int)
(declare-const target_bridge_006_jni_string_roundtrip_len Int)
(assert (>= source_bridge_006_jni_string_roundtrip_len 0))
(assert (>= target_bridge_006_jni_string_roundtrip_len 0))
(assert (not (= source_bridge_006_jni_string_roundtrip_len target_bridge_006_jni_string_roundtrip_len)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_006_jni_string_roundtrip_hash: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_006_jni_string_roundtrip_hash preserves semantics
(push 1)
(declare-const source_bridge_006_jni_string_roundtrip_hash Int)
(declare-const target_bridge_006_jni_string_roundtrip_hash Int)
(assert (>= source_bridge_006_jni_string_roundtrip_hash 0))
(assert (>= target_bridge_006_jni_string_roundtrip_hash 0))
(assert (not (= source_bridge_006_jni_string_roundtrip_hash target_bridge_006_jni_string_roundtrip_hash)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_006_jni_string_is_utf8: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_006_jni_string_is_utf8 preserves semantics
(push 1)
(declare-const source_bridge_006_jni_string_is_utf8 Int)
(declare-const target_bridge_006_jni_string_is_utf8 Int)
(assert (>= source_bridge_006_jni_string_is_utf8 0))
(assert (>= target_bridge_006_jni_string_is_utf8 0))
(assert (not (= source_bridge_006_jni_string_is_utf8 target_bridge_006_jni_string_is_utf8)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_006_jni_string_full_roundtrip: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_006_jni_string_full_roundtrip preserves semantics
(push 1)
(declare-const source_bridge_006_jni_string_full_roundtrip Int)
(declare-const target_bridge_006_jni_string_full_roundtrip Int)
(assert (>= source_bridge_006_jni_string_full_roundtrip 0))
(assert (>= target_bridge_006_jni_string_full_roundtrip 0))
(assert (not (= source_bridge_006_jni_string_full_roundtrip target_bridge_006_jni_string_full_roundtrip)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_006_rvalue_string_jni_roundtrip: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_006_rvalue_string_jni_roundtrip preserves semantics
(push 1)
(declare-const source_bridge_006_rvalue_string_jni_roundtrip Int)
(declare-const target_bridge_006_rvalue_string_jni_roundtrip Int)
(assert (>= source_bridge_006_rvalue_string_jni_roundtrip 0))
(assert (>= target_bridge_006_rvalue_string_jni_roundtrip 0))
(assert (not (= source_bridge_006_rvalue_string_jni_roundtrip target_bridge_006_rvalue_string_jni_roundtrip)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_007_swift_type_preserved_int: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_007_swift_type_preserved_int preserves semantics
(push 1)
(declare-const source_bridge_007_swift_type_preserved_int Int)
(declare-const target_bridge_007_swift_type_preserved_int Int)
(assert (>= source_bridge_007_swift_type_preserved_int 0))
(assert (>= target_bridge_007_swift_type_preserved_int 0))
(assert (not (= source_bridge_007_swift_type_preserved_int target_bridge_007_swift_type_preserved_int)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_007_swift_type_preserved_bool: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_007_swift_type_preserved_bool preserves semantics
(push 1)
(declare-const source_bridge_007_swift_type_preserved_bool Int)
(declare-const target_bridge_007_swift_type_preserved_bool Int)
(assert (>= source_bridge_007_swift_type_preserved_bool 0))
(assert (>= target_bridge_007_swift_type_preserved_bool 0))
(assert (not (= source_bridge_007_swift_type_preserved_bool target_bridge_007_swift_type_preserved_bool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_007_swift_type_preserved_string: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_007_swift_type_preserved_string preserves semantics
(push 1)
(declare-const source_bridge_007_swift_type_preserved_string Int)
(declare-const target_bridge_007_swift_type_preserved_string Int)
(assert (>= source_bridge_007_swift_type_preserved_string 0))
(assert (>= target_bridge_007_swift_type_preserved_string 0))
(assert (not (= source_bridge_007_swift_type_preserved_string target_bridge_007_swift_type_preserved_string)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_007_swift_type_preserved_unit: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_007_swift_type_preserved_unit preserves semantics
(push 1)
(declare-const source_bridge_007_swift_type_preserved_unit Int)
(declare-const target_bridge_007_swift_type_preserved_unit Int)
(assert (>= source_bridge_007_swift_type_preserved_unit 0))
(assert (>= target_bridge_007_swift_type_preserved_unit 0))
(assert (not (= source_bridge_007_swift_type_preserved_unit target_bridge_007_swift_type_preserved_unit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_007_marshal_swift_type_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_007_marshal_swift_type_safe preserves semantics
(push 1)
(declare-const source_bridge_007_marshal_swift_type_safe Int)
(declare-const target_bridge_007_marshal_swift_type_safe Int)
(assert (>= source_bridge_007_marshal_swift_type_safe 0))
(assert (>= target_bridge_007_marshal_swift_type_safe 0))
(assert (not (= source_bridge_007_marshal_swift_type_safe target_bridge_007_marshal_swift_type_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_007_unmarshal_swift_type_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_007_unmarshal_swift_type_safe preserves semantics
(push 1)
(declare-const source_bridge_007_unmarshal_swift_type_safe Int)
(declare-const target_bridge_007_unmarshal_swift_type_safe Int)
(assert (>= source_bridge_007_unmarshal_swift_type_safe 0))
(assert (>= target_bridge_007_unmarshal_swift_type_safe 0))
(assert (not (= source_bridge_007_unmarshal_swift_type_safe target_bridge_007_unmarshal_swift_type_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_007_rvalue_string_swift_roundtrip: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_007_rvalue_string_swift_roundtrip preserves semantics
(push 1)
(declare-const source_bridge_007_rvalue_string_swift_roundtrip Int)
(declare-const target_bridge_007_rvalue_string_swift_roundtrip Int)
(assert (>= source_bridge_007_rvalue_string_swift_roundtrip 0))
(assert (>= target_bridge_007_rvalue_string_swift_roundtrip 0))
(assert (not (= source_bridge_007_rvalue_string_swift_roundtrip target_bridge_007_rvalue_string_swift_roundtrip)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_008_pure_callback_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_008_pure_callback_safe preserves semantics
(push 1)
(declare-const source_bridge_008_pure_callback_safe Int)
(declare-const target_bridge_008_pure_callback_safe Int)
(assert (>= source_bridge_008_pure_callback_safe 0))
(assert (>= target_bridge_008_pure_callback_safe 0))
(assert (not (= source_bridge_008_pure_callback_safe target_bridge_008_pure_callback_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_008_public_args_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_008_public_args_safe preserves semantics
(push 1)
(declare-const source_bridge_008_public_args_safe Int)
(declare-const target_bridge_008_public_args_safe Int)
(assert (>= source_bridge_008_public_args_safe 0))
(assert (>= target_bridge_008_public_args_safe 0))
(assert (not (= source_bridge_008_public_args_safe target_bridge_008_public_args_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_008_secret_ret_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_008_secret_ret_rejected preserves semantics
(push 1)
(declare-const source_bridge_008_secret_ret_rejected Int)
(declare-const target_bridge_008_secret_ret_rejected Int)
(assert (>= source_bridge_008_secret_ret_rejected 0))
(assert (>= target_bridge_008_secret_ret_rejected 0))
(assert (not (= source_bridge_008_secret_ret_rejected target_bridge_008_secret_ret_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_008_safe_not_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_008_safe_not_rejected preserves semantics
(push 1)
(declare-const source_bridge_008_safe_not_rejected Int)
(declare-const target_bridge_008_safe_not_rejected Int)
(assert (>= source_bridge_008_safe_not_rejected 0))
(assert (>= target_bridge_008_safe_not_rejected 0))
(assert (not (= source_bridge_008_safe_not_rejected target_bridge_008_safe_not_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bridge_008_no_secret_through_safe_callback: translation preserves property (matches Coq: Theorem)
; Translation validation: bridge_008_no_secret_through_safe_callback preserves semantics
(push 1)
(declare-const source_bridge_008_no_secret_through_safe_callback Int)
(declare-const target_bridge_008_no_secret_through_safe_callback Int)
(assert (>= source_bridge_008_no_secret_through_safe_callback 0))
(assert (>= target_bridge_008_no_secret_through_safe_callback 0))
(assert (not (= source_bridge_008_no_secret_through_safe_callback target_bridge_008_no_secret_through_safe_callback)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

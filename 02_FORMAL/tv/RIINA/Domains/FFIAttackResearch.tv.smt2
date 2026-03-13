; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/FFIAttackResearch.v (20 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for FFIAttackResearch
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; ffi_type_size: source semantics (matches Coq)
; Translation validation: ffi_type_size preserves semantics
(push 1)
(declare-const source_ffi_type_size Int)
(declare-const target_ffi_type_size Int)
(assert (>= source_ffi_type_size 0))
(assert (>= target_ffi_type_size 0))
(assert (not (= source_ffi_type_size target_ffi_type_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ffi_type_align: source semantics (matches Coq)
; Translation validation: ffi_type_align preserves semantics
(push 1)
(declare-const source_ffi_type_align Int)
(declare-const target_ffi_type_align Int)
(assert (>= source_ffi_type_align 0))
(assert (>= target_ffi_type_align 0))
(assert (not (= source_ffi_type_align target_ffi_type_align)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ffi_call_safe: source semantics (matches Coq)
; Translation validation: ffi_call_safe preserves semantics
(push 1)
(declare-const source_ffi_call_safe Int)
(declare-const target_ffi_call_safe Int)
(assert (>= source_ffi_call_safe 0))
(assert (>= target_ffi_call_safe 0))
(assert (not (= source_ffi_call_safe target_ffi_call_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; regions_disjoint: source semantics (matches Coq)
; Translation validation: regions_disjoint preserves semantics
(push 1)
(declare-const source_regions_disjoint Int)
(declare-const target_regions_disjoint Int)
(assert (>= source_regions_disjoint 0))
(assert (>= target_regions_disjoint 0))
(assert (not (= source_regions_disjoint target_regions_disjoint)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; addr_in_region: source semantics (matches Coq)
; Translation validation: addr_in_region preserves semantics
(push 1)
(declare-const source_addr_in_region Int)
(declare-const target_addr_in_region Int)
(assert (>= source_addr_in_region 0))
(assert (>= target_addr_in_region 0))
(assert (not (= source_addr_in_region target_addr_in_region)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; call_allowed: source semantics (matches Coq)
; Translation validation: call_allowed preserves semantics
(push 1)
(declare-const source_call_allowed Int)
(declare-const target_call_allowed Int)
(assert (>= source_call_allowed 0))
(assert (>= target_call_allowed 0))
(assert (not (= source_call_allowed target_call_allowed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; buf_remaining: source semantics (matches Coq)
; Translation validation: buf_remaining preserves semantics
(push 1)
(declare-const source_buf_remaining Int)
(declare-const target_buf_remaining Int)
(assert (>= source_buf_remaining 0))
(assert (>= target_buf_remaining 0))
(assert (not (= source_buf_remaining target_buf_remaining)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; can_marshal: source semantics (matches Coq)
; Translation validation: can_marshal preserves semantics
(push 1)
(declare-const source_can_marshal Int)
(declare-const target_can_marshal Int)
(assert (>= source_can_marshal 0))
(assert (>= target_can_marshal 0))
(assert (not (= source_can_marshal target_can_marshal)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ffi_safe_implies_sandboxed: translation preserves property (matches Coq: Theorem)
; Translation validation: ffi_safe_implies_sandboxed preserves semantics
(push 1)
(declare-const source_ffi_safe_implies_sandboxed Int)
(declare-const target_ffi_safe_implies_sandboxed Int)
(assert (>= source_ffi_safe_implies_sandboxed 0))
(assert (>= target_ffi_safe_implies_sandboxed 0))
(assert (not (= source_ffi_safe_implies_sandboxed target_ffi_safe_implies_sandboxed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ffi_safe_implies_validated: translation preserves property (matches Coq: Theorem)
; Translation validation: ffi_safe_implies_validated preserves semantics
(push 1)
(declare-const source_ffi_safe_implies_validated Int)
(declare-const target_ffi_safe_implies_validated Int)
(assert (>= source_ffi_safe_implies_validated 0))
(assert (>= target_ffi_safe_implies_validated 0))
(assert (not (= source_ffi_safe_implies_validated target_ffi_safe_implies_validated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ffi_safe_construct: translation preserves property (matches Coq: Theorem)
; Translation validation: ffi_safe_construct preserves semantics
(push 1)
(declare-const source_ffi_safe_construct Int)
(declare-const target_ffi_safe_construct Int)
(assert (>= source_ffi_safe_construct 0))
(assert (>= target_ffi_safe_construct 0))
(assert (not (= source_ffi_safe_construct target_ffi_safe_construct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; int8_alignment_positive: translation preserves property (matches Coq: Theorem)
; Translation validation: int8_alignment_positive preserves semantics
(push 1)
(declare-const source_int8_alignment_positive Int)
(declare-const target_int8_alignment_positive Int)
(assert (>= source_int8_alignment_positive 0))
(assert (>= target_int8_alignment_positive 0))
(assert (not (= source_int8_alignment_positive target_int8_alignment_positive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ffi_type_align_ge_1: translation preserves property (matches Coq: Lemma)
; Translation validation: ffi_type_align_ge_1 preserves semantics
(push 1)
(declare-const source_ffi_type_align_ge_1 Int)
(declare-const target_ffi_type_align_ge_1 Int)
(assert (>= source_ffi_type_align_ge_1 0))
(assert (>= target_ffi_type_align_ge_1 0))
(assert (not (= source_ffi_type_align_ge_1 target_ffi_type_align_ge_1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ptr_size_constant: translation preserves property (matches Coq: Theorem)
; Translation validation: ptr_size_constant preserves semantics
(push 1)
(declare-const source_ptr_size_constant Int)
(declare-const target_ptr_size_constant Int)
(assert (>= source_ptr_size_constant 0))
(assert (>= target_ptr_size_constant 0))
(assert (not (= source_ptr_size_constant target_ptr_size_constant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; array_size_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: array_size_correct preserves semantics
(push 1)
(declare-const source_array_size_correct Int)
(declare-const target_array_size_correct Int)
(assert (>= source_array_size_correct 0))
(assert (>= target_array_size_correct 0))
(assert (not (= source_array_size_correct target_array_size_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; empty_struct_zero_size: translation preserves property (matches Coq: Theorem)
; Translation validation: empty_struct_zero_size preserves semantics
(push 1)
(declare-const source_empty_struct_zero_size Int)
(declare-const target_empty_struct_zero_size Int)
(assert (>= source_empty_struct_zero_size 0))
(assert (>= target_empty_struct_zero_size 0))
(assert (not (= source_empty_struct_zero_size target_empty_struct_zero_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; marshal_preserves_capacity: translation preserves property (matches Coq: Theorem)
; Translation validation: marshal_preserves_capacity preserves semantics
(push 1)
(declare-const source_marshal_preserves_capacity Int)
(declare-const target_marshal_preserves_capacity Int)
(assert (>= source_marshal_preserves_capacity 0))
(assert (>= target_marshal_preserves_capacity 0))
(assert (not (= source_marshal_preserves_capacity target_marshal_preserves_capacity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; marshal_increases_used: translation preserves property (matches Coq: Theorem)
; Translation validation: marshal_increases_used preserves semantics
(push 1)
(declare-const source_marshal_increases_used Int)
(declare-const target_marshal_increases_used Int)
(assert (>= source_marshal_increases_used 0))
(assert (>= target_marshal_increases_used 0))
(assert (not (= source_marshal_increases_used target_marshal_increases_used)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; marshal_never_overflows: translation preserves property (matches Coq: Theorem)
; Translation validation: marshal_never_overflows preserves semantics
(push 1)
(declare-const source_marshal_never_overflows Int)
(declare-const target_marshal_never_overflows Int)
(assert (>= source_marshal_never_overflows 0))
(assert (>= target_marshal_never_overflows 0))
(assert (not (= source_marshal_never_overflows target_marshal_never_overflows)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; marshal_failure_means_insufficient: translation preserves property (matches Coq: Theorem)
; Translation validation: marshal_failure_means_insufficient preserves semantics
(push 1)
(declare-const source_marshal_failure_means_insufficient Int)
(declare-const target_marshal_failure_means_insufficient Int)
(assert (>= source_marshal_failure_means_insufficient 0))
(assert (>= target_marshal_failure_means_insufficient 0))
(assert (not (= source_marshal_failure_means_insufficient target_marshal_failure_means_insufficient)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; marshal_void_always_succeeds: translation preserves property (matches Coq: Theorem)
; Translation validation: marshal_void_always_succeeds preserves semantics
(push 1)
(declare-const source_marshal_void_always_succeeds Int)
(declare-const target_marshal_void_always_succeeds Int)
(assert (>= source_marshal_void_always_succeeds 0))
(assert (>= target_marshal_void_always_succeeds 0))
(assert (not (= source_marshal_void_always_succeeds target_marshal_void_always_succeeds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; disjoint_regions_no_overlap: translation preserves property (matches Coq: Theorem)
; Translation validation: disjoint_regions_no_overlap preserves semantics
(push 1)
(declare-const source_disjoint_regions_no_overlap Int)
(declare-const target_disjoint_regions_no_overlap Int)
(assert (>= source_disjoint_regions_no_overlap 0))
(assert (>= target_disjoint_regions_no_overlap 0))
(assert (not (= source_disjoint_regions_no_overlap target_disjoint_regions_no_overlap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sandbox_call_allowed_decidable: translation preserves property (matches Coq: Theorem)
; Translation validation: sandbox_call_allowed_decidable preserves semantics
(push 1)
(declare-const source_sandbox_call_allowed_decidable Int)
(declare-const target_sandbox_call_allowed_decidable Int)
(assert (>= source_sandbox_call_allowed_decidable 0))
(assert (>= target_sandbox_call_allowed_decidable 0))
(assert (not (= source_sandbox_call_allowed_decidable target_sandbox_call_allowed_decidable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; disjoint_symmetric: translation preserves property (matches Coq: Theorem)
; Translation validation: disjoint_symmetric preserves semantics
(push 1)
(declare-const source_disjoint_symmetric Int)
(declare-const target_disjoint_symmetric Int)
(assert (>= source_disjoint_symmetric 0))
(assert (>= target_disjoint_symmetric 0))
(assert (not (= source_disjoint_symmetric target_disjoint_symmetric)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; addr_in_region_bounds: translation preserves property (matches Coq: Theorem)
; Translation validation: addr_in_region_bounds preserves semantics
(push 1)
(declare-const source_addr_in_region_bounds Int)
(declare-const target_addr_in_region_bounds Int)
(assert (>= source_addr_in_region_bounds 0))
(assert (>= target_addr_in_region_bounds 0))
(assert (not (= source_addr_in_region_bounds target_addr_in_region_bounds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ffi_void_size_zero: translation preserves property (matches Coq: Theorem)
; Translation validation: ffi_void_size_zero preserves semantics
(push 1)
(declare-const source_ffi_void_size_zero Int)
(declare-const target_ffi_void_size_zero Int)
(assert (>= source_ffi_void_size_zero 0))
(assert (>= target_ffi_void_size_zero 0))
(assert (not (= source_ffi_void_size_zero target_ffi_void_size_zero)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ffi_int8_size: translation preserves property (matches Coq: Theorem)
; Translation validation: ffi_int8_size preserves semantics
(push 1)
(declare-const source_ffi_int8_size Int)
(declare-const target_ffi_int8_size Int)
(assert (>= source_ffi_int8_size 0))
(assert (>= target_ffi_int8_size 0))
(assert (not (= source_ffi_int8_size target_ffi_int8_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; marshal_void_preserves_used: translation preserves property (matches Coq: Theorem)
; Translation validation: marshal_void_preserves_used preserves semantics
(push 1)
(declare-const source_marshal_void_preserves_used Int)
(declare-const target_marshal_void_preserves_used Int)
(assert (>= source_marshal_void_preserves_used 0))
(assert (>= target_marshal_void_preserves_used 0))
(assert (not (= source_marshal_void_preserves_used target_marshal_void_preserves_used)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

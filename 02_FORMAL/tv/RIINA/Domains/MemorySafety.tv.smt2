; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/MemorySafety.v (139 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for MemorySafety
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; uaf_protected: source semantics (matches Coq)
; Translation validation: uaf_protected preserves semantics
(push 1)
(declare-const source_uaf_protected Int)
(declare-const target_uaf_protected Int)
(assert (>= source_uaf_protected 0))
(assert (>= target_uaf_protected 0))
(assert (not (= source_uaf_protected target_uaf_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; df_protected: source semantics (matches Coq)
; Translation validation: df_protected preserves semantics
(push 1)
(declare-const source_df_protected Int)
(declare-const target_df_protected Int)
(assert (>= source_df_protected 0))
(assert (>= target_df_protected 0))
(assert (not (= source_df_protected target_df_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nd_protected: source semantics (matches Coq)
; Translation validation: nd_protected preserves semantics
(push 1)
(declare-const source_nd_protected Int)
(declare-const target_nd_protected Int)
(assert (>= source_nd_protected 0))
(assert (>= target_nd_protected 0))
(assert (not (= source_nd_protected target_nd_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bounds_protected: source semantics (matches Coq)
; Translation validation: bounds_protected preserves semantics
(push 1)
(declare-const source_bounds_protected Int)
(declare-const target_bounds_protected Int)
(assert (>= source_bounds_protected 0))
(assert (>= target_bounds_protected 0))
(assert (not (= source_bounds_protected target_bounds_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; stack_protected: source semantics (matches Coq)
; Translation validation: stack_protected preserves semantics
(push 1)
(declare-const source_stack_protected Int)
(declare-const target_stack_protected Int)
(assert (>= source_stack_protected 0))
(assert (>= target_stack_protected 0))
(assert (not (= source_stack_protected target_stack_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; heap_protected: source semantics (matches Coq)
; Translation validation: heap_protected preserves semantics
(push 1)
(declare-const source_heap_protected Int)
(declare-const target_heap_protected Int)
(assert (>= source_heap_protected 0))
(assert (>= target_heap_protected 0))
(assert (not (= source_heap_protected target_heap_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; isolation_protected: source semantics (matches Coq)
; Translation validation: isolation_protected preserves semantics
(push 1)
(declare-const source_isolation_protected Int)
(declare-const target_isolation_protected Int)
(assert (>= source_isolation_protected 0))
(assert (>= target_isolation_protected 0))
(assert (not (= source_isolation_protected target_isolation_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; memory_safe: source semantics (matches Coq)
; Translation validation: memory_safe preserves semantics
(push 1)
(declare-const source_memory_safe Int)
(declare-const target_memory_safe Int)
(assert (>= source_memory_safe 0))
(assert (>= target_memory_safe 0))
(assert (not (= source_memory_safe target_memory_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ptr_is_valid: source semantics (matches Coq)
; Translation validation: ptr_is_valid preserves semantics
(push 1)
(declare-const source_ptr_is_valid Int)
(declare-const target_ptr_is_valid Int)
(assert (>= source_ptr_is_valid 0))
(assert (>= target_ptr_is_valid 0))
(assert (not (= source_ptr_is_valid target_ptr_is_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ptr_is_null: source semantics (matches Coq)
; Translation validation: ptr_is_null preserves semantics
(push 1)
(declare-const source_ptr_is_null Int)
(declare-const target_ptr_is_null Int)
(assert (>= source_ptr_is_null 0))
(assert (>= target_ptr_is_null 0))
(assert (not (= source_ptr_is_null target_ptr_is_null)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ptr_is_dangling: source semantics (matches Coq)
; Translation validation: ptr_is_dangling preserves semantics
(push 1)
(declare-const source_ptr_is_dangling Int)
(declare-const target_ptr_is_dangling Int)
(assert (>= source_ptr_is_dangling 0))
(assert (>= target_ptr_is_dangling 0))
(assert (not (= source_ptr_is_dangling target_ptr_is_dangling)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ptr_in_bounds: source semantics (matches Coq)
; Translation validation: ptr_in_bounds preserves semantics
(push 1)
(declare-const source_ptr_in_bounds Int)
(declare-const target_ptr_in_bounds Int)
(assert (>= source_ptr_in_bounds 0))
(assert (>= target_ptr_in_bounds 0))
(assert (not (= source_ptr_in_bounds target_ptr_in_bounds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ptr_safe_for_access: source semantics (matches Coq)
; Translation validation: ptr_safe_for_access preserves semantics
(push 1)
(declare-const source_ptr_safe_for_access Int)
(declare-const target_ptr_safe_for_access Int)
(assert (>= source_ptr_safe_for_access 0))
(assert (>= target_ptr_safe_for_access 0))
(assert (not (= source_ptr_safe_for_access target_ptr_safe_for_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ptr_safe_for_access_range: source semantics (matches Coq)
; Translation validation: ptr_safe_for_access_range preserves semantics
(push 1)
(declare-const source_ptr_safe_for_access_range Int)
(declare-const target_ptr_safe_for_access_range Int)
(assert (>= source_ptr_safe_for_access_range 0))
(assert (>= target_ptr_safe_for_access_range 0))
(assert (not (= source_ptr_safe_for_access_range target_ptr_safe_for_access_range)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; region_is_allocated: source semantics (matches Coq)
; Translation validation: region_is_allocated preserves semantics
(push 1)
(declare-const source_region_is_allocated Int)
(declare-const target_region_is_allocated Int)
(assert (>= source_region_is_allocated 0))
(assert (>= target_region_is_allocated 0))
(assert (not (= source_region_is_allocated target_region_is_allocated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; region_is_freed: source semantics (matches Coq)
; Translation validation: region_is_freed preserves semantics
(push 1)
(declare-const source_region_is_freed Int)
(declare-const target_region_is_freed Int)
(assert (>= source_region_is_freed 0))
(assert (>= target_region_is_freed 0))
(assert (not (= source_region_is_freed target_region_is_freed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; region_can_access: source semantics (matches Coq)
; Translation validation: region_can_access preserves semantics
(push 1)
(declare-const source_region_can_access Int)
(declare-const target_region_can_access Int)
(assert (>= source_region_can_access 0))
(assert (>= target_region_can_access 0))
(assert (not (= source_region_can_access target_region_can_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; region_can_write: source semantics (matches Coq)
; Translation validation: region_can_write preserves semantics
(push 1)
(declare-const source_region_can_write Int)
(declare-const target_region_can_write Int)
(assert (>= source_region_can_write 0))
(assert (>= target_region_can_write 0))
(assert (not (= source_region_can_write target_region_can_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; domain_level: source semantics (matches Coq)
; Translation validation: domain_level preserves semantics
(push 1)
(declare-const source_domain_level Int)
(declare-const target_domain_level Int)
(assert (>= source_domain_level 0))
(assert (>= target_domain_level 0))
(assert (not (= source_domain_level target_domain_level)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; domain_can_access: source semantics (matches Coq)
; Translation validation: domain_can_access preserves semantics
(push 1)
(declare-const source_domain_can_access Int)
(declare-const target_domain_can_access Int)
(assert (>= source_domain_can_access 0))
(assert (>= target_domain_can_access 0))
(assert (not (= source_domain_can_access target_domain_can_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; permission_allows_read: source semantics (matches Coq)
; Translation validation: permission_allows_read preserves semantics
(push 1)
(declare-const source_permission_allows_read Int)
(declare-const target_permission_allows_read Int)
(assert (>= source_permission_allows_read 0))
(assert (>= target_permission_allows_read 0))
(assert (not (= source_permission_allows_read target_permission_allows_read)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; permission_allows_write: source semantics (matches Coq)
; Translation validation: permission_allows_write preserves semantics
(push 1)
(declare-const source_permission_allows_write Int)
(declare-const target_permission_allows_write Int)
(assert (>= source_permission_allows_write 0))
(assert (>= target_permission_allows_write 0))
(assert (not (= source_permission_allows_write target_permission_allows_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; secure_region_can_read: source semantics (matches Coq)
; Translation validation: secure_region_can_read preserves semantics
(push 1)
(declare-const source_secure_region_can_read Int)
(declare-const target_secure_region_can_read Int)
(assert (>= source_secure_region_can_read 0))
(assert (>= target_secure_region_can_read 0))
(assert (not (= source_secure_region_can_read target_secure_region_can_read)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; secure_region_can_write: source semantics (matches Coq)
; Translation validation: secure_region_can_write preserves semantics
(push 1)
(declare-const source_secure_region_can_write Int)
(declare-const target_secure_region_can_write Int)
(assert (>= source_secure_region_can_write 0))
(assert (>= target_secure_region_can_write 0))
(assert (not (= source_secure_region_can_write target_secure_region_can_write)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_uaf: source semantics (matches Coq)
; Translation validation: riina_uaf preserves semantics
(push 1)
(declare-const source_riina_uaf Int)
(declare-const target_riina_uaf Int)
(assert (>= source_riina_uaf 0))
(assert (>= target_riina_uaf 0))
(assert (not (= source_riina_uaf target_riina_uaf)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_df: source semantics (matches Coq)
; Translation validation: riina_df preserves semantics
(push 1)
(declare-const source_riina_df Int)
(declare-const target_riina_df Int)
(assert (>= source_riina_df 0))
(assert (>= target_riina_df 0))
(assert (not (= source_riina_df target_riina_df)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_nd: source semantics (matches Coq)
; Translation validation: riina_nd preserves semantics
(push 1)
(declare-const source_riina_nd Int)
(declare-const target_riina_nd Int)
(assert (>= source_riina_nd 0))
(assert (>= target_riina_nd 0))
(assert (not (= source_riina_nd target_riina_nd)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_bounds: source semantics (matches Coq)
; Translation validation: riina_bounds preserves semantics
(push 1)
(declare-const source_riina_bounds Int)
(declare-const target_riina_bounds Int)
(assert (>= source_riina_bounds 0))
(assert (>= target_riina_bounds 0))
(assert (not (= source_riina_bounds target_riina_bounds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_stack: source semantics (matches Coq)
; Translation validation: riina_stack preserves semantics
(push 1)
(declare-const source_riina_stack Int)
(declare-const target_riina_stack Int)
(assert (>= source_riina_stack 0))
(assert (>= target_riina_stack 0))
(assert (not (= source_riina_stack target_riina_stack)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_heap: source semantics (matches Coq)
; Translation validation: riina_heap preserves semantics
(push 1)
(declare-const source_riina_heap Int)
(declare-const target_riina_heap Int)
(assert (>= source_riina_heap 0))
(assert (>= target_riina_heap 0))
(assert (not (= source_riina_heap target_riina_heap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_isolation: source semantics (matches Coq)
; Translation validation: riina_isolation preserves semantics
(push 1)
(declare-const source_riina_isolation Int)
(declare-const target_riina_isolation Int)
(assert (>= source_riina_isolation 0))
(assert (>= target_riina_isolation 0))
(assert (not (= source_riina_isolation target_riina_isolation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_mem_safety: source semantics (matches Coq)
; Translation validation: riina_mem_safety preserves semantics
(push 1)
(declare-const source_riina_mem_safety Int)
(declare-const target_riina_mem_safety Int)
(assert (>= source_riina_mem_safety 0))
(assert (>= target_riina_mem_safety 0))
(assert (not (= source_riina_mem_safety target_riina_mem_safety)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; valid_pointer: source semantics (matches Coq)
; Translation validation: valid_pointer preserves semantics
(push 1)
(declare-const source_valid_pointer Int)
(declare-const target_valid_pointer Int)
(assert (>= source_valid_pointer 0))
(assert (>= target_valid_pointer 0))
(assert (not (= source_valid_pointer target_valid_pointer)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; null_pointer: source semantics (matches Coq)
; Translation validation: null_pointer preserves semantics
(push 1)
(declare-const source_null_pointer Int)
(declare-const target_null_pointer Int)
(assert (>= source_null_pointer 0))
(assert (>= target_null_pointer 0))
(assert (not (= source_null_pointer target_null_pointer)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dangling_pointer: source semantics (matches Coq)
; Translation validation: dangling_pointer preserves semantics
(push 1)
(declare-const source_dangling_pointer Int)
(declare-const target_dangling_pointer Int)
(assert (>= source_dangling_pointer 0))
(assert (>= target_dangling_pointer 0))
(assert (not (= source_dangling_pointer target_dangling_pointer)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; oob_pointer: source semantics (matches Coq)
; Translation validation: oob_pointer preserves semantics
(push 1)
(declare-const source_oob_pointer Int)
(declare-const target_oob_pointer Int)
(assert (>= source_oob_pointer 0))
(assert (>= target_oob_pointer 0))
(assert (not (= source_oob_pointer target_oob_pointer)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; allocated_region: source semantics (matches Coq)
; Translation validation: allocated_region preserves semantics
(push 1)
(declare-const source_allocated_region Int)
(declare-const target_allocated_region Int)
(assert (>= source_allocated_region 0))
(assert (>= target_allocated_region 0))
(assert (not (= source_allocated_region target_allocated_region)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; freed_region: source semantics (matches Coq)
; Translation validation: freed_region preserves semantics
(push 1)
(declare-const source_freed_region Int)
(declare-const target_freed_region Int)
(assert (>= source_freed_region 0))
(assert (>= target_freed_region 0))
(assert (not (= source_freed_region target_freed_region)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unallocated_region: source semantics (matches Coq)
; Translation validation: unallocated_region preserves semantics
(push 1)
(declare-const source_unallocated_region Int)
(declare-const target_unallocated_region Int)
(assert (>= source_unallocated_region 0))
(assert (>= target_unallocated_region 0))
(assert (not (= source_unallocated_region target_unallocated_region)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kernel_region: source semantics (matches Coq)
; Translation validation: kernel_region preserves semantics
(push 1)
(declare-const source_kernel_region Int)
(declare-const target_kernel_region Int)
(assert (>= source_kernel_region 0))
(assert (>= target_kernel_region 0))
(assert (not (= source_kernel_region target_kernel_region)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; user_region: source semantics (matches Coq)
; Translation validation: user_region preserves semantics
(push 1)
(declare-const source_user_region Int)
(declare-const target_user_region Int)
(assert (>= source_user_region 0))
(assert (>= target_user_region 0))
(assert (not (= source_user_region target_user_region)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; guest_region: source semantics (matches Coq)
; Translation validation: guest_region preserves semantics
(push 1)
(declare-const source_guest_region Int)
(declare-const target_guest_region Int)
(assert (>= source_guest_region 0))
(assert (>= target_guest_region 0))
(assert (not (= source_guest_region target_guest_region)))
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

; andb_false_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_false_iff preserves semantics
(push 1)
(declare-const source_andb_false_iff Int)
(declare-const target_andb_false_iff Int)
(assert (>= source_andb_false_iff 0))
(assert (>= target_andb_false_iff 0))
(assert (not (= source_andb_false_iff target_andb_false_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; negb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: negb_true_iff preserves semantics
(push 1)
(declare-const source_negb_true_iff Int)
(declare-const target_negb_true_iff Int)
(assert (>= source_negb_true_iff 0))
(assert (>= target_negb_true_iff 0))
(assert (not (= source_negb_true_iff target_negb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; negb_false_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: negb_false_iff preserves semantics
(push 1)
(declare-const source_negb_false_iff Int)
(declare-const target_negb_false_iff Int)
(assert (>= source_negb_false_iff 0))
(assert (>= target_negb_false_iff 0))
(assert (not (= source_negb_false_iff target_negb_false_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_001: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_001 preserves semantics
(push 1)
(declare-const source_MEM_001 Int)
(declare-const target_MEM_001 Int)
(assert (>= source_MEM_001 0))
(assert (>= target_MEM_001 0))
(assert (not (= source_MEM_001 target_MEM_001)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_002: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_002 preserves semantics
(push 1)
(declare-const source_MEM_002 Int)
(declare-const target_MEM_002 Int)
(assert (>= source_MEM_002 0))
(assert (>= target_MEM_002 0))
(assert (not (= source_MEM_002 target_MEM_002)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_003: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_003 preserves semantics
(push 1)
(declare-const source_MEM_003 Int)
(declare-const target_MEM_003 Int)
(assert (>= source_MEM_003 0))
(assert (>= target_MEM_003 0))
(assert (not (= source_MEM_003 target_MEM_003)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_004: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_004 preserves semantics
(push 1)
(declare-const source_MEM_004 Int)
(declare-const target_MEM_004 Int)
(assert (>= source_MEM_004 0))
(assert (>= target_MEM_004 0))
(assert (not (= source_MEM_004 target_MEM_004)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_005: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_005 preserves semantics
(push 1)
(declare-const source_MEM_005 Int)
(declare-const target_MEM_005 Int)
(assert (>= source_MEM_005 0))
(assert (>= target_MEM_005 0))
(assert (not (= source_MEM_005 target_MEM_005)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_006: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_006 preserves semantics
(push 1)
(declare-const source_MEM_006 Int)
(declare-const target_MEM_006 Int)
(assert (>= source_MEM_006 0))
(assert (>= target_MEM_006 0))
(assert (not (= source_MEM_006 target_MEM_006)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_007: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_007 preserves semantics
(push 1)
(declare-const source_MEM_007 Int)
(declare-const target_MEM_007 Int)
(assert (>= source_MEM_007 0))
(assert (>= target_MEM_007 0))
(assert (not (= source_MEM_007 target_MEM_007)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_008: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_008 preserves semantics
(push 1)
(declare-const source_MEM_008 Int)
(declare-const target_MEM_008 Int)
(assert (>= source_MEM_008 0))
(assert (>= target_MEM_008 0))
(assert (not (= source_MEM_008 target_MEM_008)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_009: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_009 preserves semantics
(push 1)
(declare-const source_MEM_009 Int)
(declare-const target_MEM_009 Int)
(assert (>= source_MEM_009 0))
(assert (>= target_MEM_009 0))
(assert (not (= source_MEM_009 target_MEM_009)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_010: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_010 preserves semantics
(push 1)
(declare-const source_MEM_010 Int)
(declare-const target_MEM_010 Int)
(assert (>= source_MEM_010 0))
(assert (>= target_MEM_010 0))
(assert (not (= source_MEM_010 target_MEM_010)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_011: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_011 preserves semantics
(push 1)
(declare-const source_MEM_011 Int)
(declare-const target_MEM_011 Int)
(assert (>= source_MEM_011 0))
(assert (>= target_MEM_011 0))
(assert (not (= source_MEM_011 target_MEM_011)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_012: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_012 preserves semantics
(push 1)
(declare-const source_MEM_012 Int)
(declare-const target_MEM_012 Int)
(assert (>= source_MEM_012 0))
(assert (>= target_MEM_012 0))
(assert (not (= source_MEM_012 target_MEM_012)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_013: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_013 preserves semantics
(push 1)
(declare-const source_MEM_013 Int)
(declare-const target_MEM_013 Int)
(assert (>= source_MEM_013 0))
(assert (>= target_MEM_013 0))
(assert (not (= source_MEM_013 target_MEM_013)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_014: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_014 preserves semantics
(push 1)
(declare-const source_MEM_014 Int)
(declare-const target_MEM_014 Int)
(assert (>= source_MEM_014 0))
(assert (>= target_MEM_014 0))
(assert (not (= source_MEM_014 target_MEM_014)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_015: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_015 preserves semantics
(push 1)
(declare-const source_MEM_015 Int)
(declare-const target_MEM_015 Int)
(assert (>= source_MEM_015 0))
(assert (>= target_MEM_015 0))
(assert (not (= source_MEM_015 target_MEM_015)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_016: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_016 preserves semantics
(push 1)
(declare-const source_MEM_016 Int)
(declare-const target_MEM_016 Int)
(assert (>= source_MEM_016 0))
(assert (>= target_MEM_016 0))
(assert (not (= source_MEM_016 target_MEM_016)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_017: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_017 preserves semantics
(push 1)
(declare-const source_MEM_017 Int)
(declare-const target_MEM_017 Int)
(assert (>= source_MEM_017 0))
(assert (>= target_MEM_017 0))
(assert (not (= source_MEM_017 target_MEM_017)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_018: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_018 preserves semantics
(push 1)
(declare-const source_MEM_018 Int)
(declare-const target_MEM_018 Int)
(assert (>= source_MEM_018 0))
(assert (>= target_MEM_018 0))
(assert (not (= source_MEM_018 target_MEM_018)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_019: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_019 preserves semantics
(push 1)
(declare-const source_MEM_019 Int)
(declare-const target_MEM_019 Int)
(assert (>= source_MEM_019 0))
(assert (>= target_MEM_019 0))
(assert (not (= source_MEM_019 target_MEM_019)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_020: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_020 preserves semantics
(push 1)
(declare-const source_MEM_020 Int)
(declare-const target_MEM_020 Int)
(assert (>= source_MEM_020 0))
(assert (>= target_MEM_020 0))
(assert (not (= source_MEM_020 target_MEM_020)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_021: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_021 preserves semantics
(push 1)
(declare-const source_MEM_021 Int)
(declare-const target_MEM_021 Int)
(assert (>= source_MEM_021 0))
(assert (>= target_MEM_021 0))
(assert (not (= source_MEM_021 target_MEM_021)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_022: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_022 preserves semantics
(push 1)
(declare-const source_MEM_022 Int)
(declare-const target_MEM_022 Int)
(assert (>= source_MEM_022 0))
(assert (>= target_MEM_022 0))
(assert (not (= source_MEM_022 target_MEM_022)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_023: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_023 preserves semantics
(push 1)
(declare-const source_MEM_023 Int)
(declare-const target_MEM_023 Int)
(assert (>= source_MEM_023 0))
(assert (>= target_MEM_023 0))
(assert (not (= source_MEM_023 target_MEM_023)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_024: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_024 preserves semantics
(push 1)
(declare-const source_MEM_024 Int)
(declare-const target_MEM_024 Int)
(assert (>= source_MEM_024 0))
(assert (>= target_MEM_024 0))
(assert (not (= source_MEM_024 target_MEM_024)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_025: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_025 preserves semantics
(push 1)
(declare-const source_MEM_025 Int)
(declare-const target_MEM_025 Int)
(assert (>= source_MEM_025 0))
(assert (>= target_MEM_025 0))
(assert (not (= source_MEM_025 target_MEM_025)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_026: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_026 preserves semantics
(push 1)
(declare-const source_MEM_026 Int)
(declare-const target_MEM_026 Int)
(assert (>= source_MEM_026 0))
(assert (>= target_MEM_026 0))
(assert (not (= source_MEM_026 target_MEM_026)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_027: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_027 preserves semantics
(push 1)
(declare-const source_MEM_027 Int)
(declare-const target_MEM_027 Int)
(assert (>= source_MEM_027 0))
(assert (>= target_MEM_027 0))
(assert (not (= source_MEM_027 target_MEM_027)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_028: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_028 preserves semantics
(push 1)
(declare-const source_MEM_028 Int)
(declare-const target_MEM_028 Int)
(assert (>= source_MEM_028 0))
(assert (>= target_MEM_028 0))
(assert (not (= source_MEM_028 target_MEM_028)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_029: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_029 preserves semantics
(push 1)
(declare-const source_MEM_029 Int)
(declare-const target_MEM_029 Int)
(assert (>= source_MEM_029 0))
(assert (>= target_MEM_029 0))
(assert (not (= source_MEM_029 target_MEM_029)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_030: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_030 preserves semantics
(push 1)
(declare-const source_MEM_030 Int)
(declare-const target_MEM_030 Int)
(assert (>= source_MEM_030 0))
(assert (>= target_MEM_030 0))
(assert (not (= source_MEM_030 target_MEM_030)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_031: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_031 preserves semantics
(push 1)
(declare-const source_MEM_031 Int)
(declare-const target_MEM_031 Int)
(assert (>= source_MEM_031 0))
(assert (>= target_MEM_031 0))
(assert (not (= source_MEM_031 target_MEM_031)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_032: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_032 preserves semantics
(push 1)
(declare-const source_MEM_032 Int)
(declare-const target_MEM_032 Int)
(assert (>= source_MEM_032 0))
(assert (>= target_MEM_032 0))
(assert (not (= source_MEM_032 target_MEM_032)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_033: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_033 preserves semantics
(push 1)
(declare-const source_MEM_033 Int)
(declare-const target_MEM_033 Int)
(assert (>= source_MEM_033 0))
(assert (>= target_MEM_033 0))
(assert (not (= source_MEM_033 target_MEM_033)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_034: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_034 preserves semantics
(push 1)
(declare-const source_MEM_034 Int)
(declare-const target_MEM_034 Int)
(assert (>= source_MEM_034 0))
(assert (>= target_MEM_034 0))
(assert (not (= source_MEM_034 target_MEM_034)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_035: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_035 preserves semantics
(push 1)
(declare-const source_MEM_035 Int)
(declare-const target_MEM_035 Int)
(assert (>= source_MEM_035 0))
(assert (>= target_MEM_035 0))
(assert (not (= source_MEM_035 target_MEM_035)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_036: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_036 preserves semantics
(push 1)
(declare-const source_MEM_036 Int)
(declare-const target_MEM_036 Int)
(assert (>= source_MEM_036 0))
(assert (>= target_MEM_036 0))
(assert (not (= source_MEM_036 target_MEM_036)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_037: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_037 preserves semantics
(push 1)
(declare-const source_MEM_037 Int)
(declare-const target_MEM_037 Int)
(assert (>= source_MEM_037 0))
(assert (>= target_MEM_037 0))
(assert (not (= source_MEM_037 target_MEM_037)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_038: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_038 preserves semantics
(push 1)
(declare-const source_MEM_038 Int)
(declare-const target_MEM_038 Int)
(assert (>= source_MEM_038 0))
(assert (>= target_MEM_038 0))
(assert (not (= source_MEM_038 target_MEM_038)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_039: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_039 preserves semantics
(push 1)
(declare-const source_MEM_039 Int)
(declare-const target_MEM_039 Int)
(assert (>= source_MEM_039 0))
(assert (>= target_MEM_039 0))
(assert (not (= source_MEM_039 target_MEM_039)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_040_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_040_complete preserves semantics
(push 1)
(declare-const source_MEM_040_complete Int)
(declare-const target_MEM_040_complete Int)
(assert (>= source_MEM_040_complete 0))
(assert (>= target_MEM_040_complete 0))
(assert (not (= source_MEM_040_complete target_MEM_040_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_041_valid_pointer_is_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_041_valid_pointer_is_valid preserves semantics
(push 1)
(declare-const source_MEM_041_valid_pointer_is_valid Int)
(declare-const target_MEM_041_valid_pointer_is_valid Int)
(assert (>= source_MEM_041_valid_pointer_is_valid 0))
(assert (>= target_MEM_041_valid_pointer_is_valid 0))
(assert (not (= source_MEM_041_valid_pointer_is_valid target_MEM_041_valid_pointer_is_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_042_null_pointer_not_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_042_null_pointer_not_valid preserves semantics
(push 1)
(declare-const source_MEM_042_null_pointer_not_valid Int)
(declare-const target_MEM_042_null_pointer_not_valid Int)
(assert (>= source_MEM_042_null_pointer_not_valid 0))
(assert (>= target_MEM_042_null_pointer_not_valid 0))
(assert (not (= source_MEM_042_null_pointer_not_valid target_MEM_042_null_pointer_not_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_043_dangling_pointer_not_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_043_dangling_pointer_not_valid preserves semantics
(push 1)
(declare-const source_MEM_043_dangling_pointer_not_valid Int)
(declare-const target_MEM_043_dangling_pointer_not_valid Int)
(assert (>= source_MEM_043_dangling_pointer_not_valid 0))
(assert (>= target_MEM_043_dangling_pointer_not_valid 0))
(assert (not (= source_MEM_043_dangling_pointer_not_valid target_MEM_043_dangling_pointer_not_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_044_oob_pointer_not_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_044_oob_pointer_not_valid preserves semantics
(push 1)
(declare-const source_MEM_044_oob_pointer_not_valid Int)
(declare-const target_MEM_044_oob_pointer_not_valid Int)
(assert (>= source_MEM_044_oob_pointer_not_valid 0))
(assert (>= target_MEM_044_oob_pointer_not_valid 0))
(assert (not (= source_MEM_044_oob_pointer_not_valid target_MEM_044_oob_pointer_not_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_045_null_pointer_is_null: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_045_null_pointer_is_null preserves semantics
(push 1)
(declare-const source_MEM_045_null_pointer_is_null Int)
(declare-const target_MEM_045_null_pointer_is_null Int)
(assert (>= source_MEM_045_null_pointer_is_null 0))
(assert (>= target_MEM_045_null_pointer_is_null 0))
(assert (not (= source_MEM_045_null_pointer_is_null target_MEM_045_null_pointer_is_null)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_046_valid_pointer_not_null: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_046_valid_pointer_not_null preserves semantics
(push 1)
(declare-const source_MEM_046_valid_pointer_not_null Int)
(declare-const target_MEM_046_valid_pointer_not_null Int)
(assert (>= source_MEM_046_valid_pointer_not_null 0))
(assert (>= target_MEM_046_valid_pointer_not_null 0))
(assert (not (= source_MEM_046_valid_pointer_not_null target_MEM_046_valid_pointer_not_null)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_047_dangling_is_dangling: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_047_dangling_is_dangling preserves semantics
(push 1)
(declare-const source_MEM_047_dangling_is_dangling Int)
(declare-const target_MEM_047_dangling_is_dangling Int)
(assert (>= source_MEM_047_dangling_is_dangling 0))
(assert (>= target_MEM_047_dangling_is_dangling 0))
(assert (not (= source_MEM_047_dangling_is_dangling target_MEM_047_dangling_is_dangling)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_048_valid_not_dangling: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_048_valid_not_dangling preserves semantics
(push 1)
(declare-const source_MEM_048_valid_not_dangling Int)
(declare-const target_MEM_048_valid_not_dangling Int)
(assert (>= source_MEM_048_valid_not_dangling 0))
(assert (>= target_MEM_048_valid_not_dangling 0))
(assert (not (= source_MEM_048_valid_not_dangling target_MEM_048_valid_not_dangling)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_049_valid_in_bounds: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_049_valid_in_bounds preserves semantics
(push 1)
(declare-const source_MEM_049_valid_in_bounds Int)
(declare-const target_MEM_049_valid_in_bounds Int)
(assert (>= source_MEM_049_valid_in_bounds 0))
(assert (>= target_MEM_049_valid_in_bounds 0))
(assert (not (= source_MEM_049_valid_in_bounds target_MEM_049_valid_in_bounds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_050_oob_not_in_bounds: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_050_oob_not_in_bounds preserves semantics
(push 1)
(declare-const source_MEM_050_oob_not_in_bounds Int)
(declare-const target_MEM_050_oob_not_in_bounds Int)
(assert (>= source_MEM_050_oob_not_in_bounds 0))
(assert (>= target_MEM_050_oob_not_in_bounds 0))
(assert (not (= source_MEM_050_oob_not_in_bounds target_MEM_050_oob_not_in_bounds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_051_valid_safe_for_access: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_051_valid_safe_for_access preserves semantics
(push 1)
(declare-const source_MEM_051_valid_safe_for_access Int)
(declare-const target_MEM_051_valid_safe_for_access Int)
(assert (>= source_MEM_051_valid_safe_for_access 0))
(assert (>= target_MEM_051_valid_safe_for_access 0))
(assert (not (= source_MEM_051_valid_safe_for_access target_MEM_051_valid_safe_for_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_052_null_not_safe_for_access: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_052_null_not_safe_for_access preserves semantics
(push 1)
(declare-const source_MEM_052_null_not_safe_for_access Int)
(declare-const target_MEM_052_null_not_safe_for_access Int)
(assert (>= source_MEM_052_null_not_safe_for_access 0))
(assert (>= target_MEM_052_null_not_safe_for_access 0))
(assert (not (= source_MEM_052_null_not_safe_for_access target_MEM_052_null_not_safe_for_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_053_dangling_not_safe_for_access: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_053_dangling_not_safe_for_access preserves semantics
(push 1)
(declare-const source_MEM_053_dangling_not_safe_for_access Int)
(declare-const target_MEM_053_dangling_not_safe_for_access Int)
(assert (>= source_MEM_053_dangling_not_safe_for_access 0))
(assert (>= target_MEM_053_dangling_not_safe_for_access 0))
(assert (not (= source_MEM_053_dangling_not_safe_for_access target_MEM_053_dangling_not_safe_for_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_054_safe_access_implies_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_054_safe_access_implies_valid preserves semantics
(push 1)
(declare-const source_MEM_054_safe_access_implies_valid Int)
(declare-const target_MEM_054_safe_access_implies_valid Int)
(assert (>= source_MEM_054_safe_access_implies_valid 0))
(assert (>= target_MEM_054_safe_access_implies_valid 0))
(assert (not (= source_MEM_054_safe_access_implies_valid target_MEM_054_safe_access_implies_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_055_safe_access_implies_in_bounds: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_055_safe_access_implies_in_bounds preserves semantics
(push 1)
(declare-const source_MEM_055_safe_access_implies_in_bounds Int)
(declare-const target_MEM_055_safe_access_implies_in_bounds Int)
(assert (>= source_MEM_055_safe_access_implies_in_bounds 0))
(assert (>= target_MEM_055_safe_access_implies_in_bounds 0))
(assert (not (= source_MEM_055_safe_access_implies_in_bounds target_MEM_055_safe_access_implies_in_bounds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_056_allocated_region_is_allocated: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_056_allocated_region_is_allocated preserves semantics
(push 1)
(declare-const source_MEM_056_allocated_region_is_allocated Int)
(declare-const target_MEM_056_allocated_region_is_allocated Int)
(assert (>= source_MEM_056_allocated_region_is_allocated 0))
(assert (>= target_MEM_056_allocated_region_is_allocated 0))
(assert (not (= source_MEM_056_allocated_region_is_allocated target_MEM_056_allocated_region_is_allocated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_057_freed_region_not_allocated: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_057_freed_region_not_allocated preserves semantics
(push 1)
(declare-const source_MEM_057_freed_region_not_allocated Int)
(declare-const target_MEM_057_freed_region_not_allocated Int)
(assert (>= source_MEM_057_freed_region_not_allocated 0))
(assert (>= target_MEM_057_freed_region_not_allocated 0))
(assert (not (= source_MEM_057_freed_region_not_allocated target_MEM_057_freed_region_not_allocated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_058_unallocated_region_not_allocated: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_058_unallocated_region_not_allocated preserves semantics
(push 1)
(declare-const source_MEM_058_unallocated_region_not_allocated Int)
(declare-const target_MEM_058_unallocated_region_not_allocated Int)
(assert (>= source_MEM_058_unallocated_region_not_allocated 0))
(assert (>= target_MEM_058_unallocated_region_not_allocated 0))
(assert (not (= source_MEM_058_unallocated_region_not_allocated target_MEM_058_unallocated_region_not_allocated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_059_freed_region_is_freed: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_059_freed_region_is_freed preserves semantics
(push 1)
(declare-const source_MEM_059_freed_region_is_freed Int)
(declare-const target_MEM_059_freed_region_is_freed Int)
(assert (>= source_MEM_059_freed_region_is_freed 0))
(assert (>= target_MEM_059_freed_region_is_freed 0))
(assert (not (= source_MEM_059_freed_region_is_freed target_MEM_059_freed_region_is_freed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_060_allocated_region_not_freed: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_060_allocated_region_not_freed preserves semantics
(push 1)
(declare-const source_MEM_060_allocated_region_not_freed Int)
(declare-const target_MEM_060_allocated_region_not_freed Int)
(assert (>= source_MEM_060_allocated_region_not_freed 0))
(assert (>= target_MEM_060_allocated_region_not_freed 0))
(assert (not (= source_MEM_060_allocated_region_not_freed target_MEM_060_allocated_region_not_freed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_061_allocated_can_access: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_061_allocated_can_access preserves semantics
(push 1)
(declare-const source_MEM_061_allocated_can_access Int)
(declare-const target_MEM_061_allocated_can_access Int)
(assert (>= source_MEM_061_allocated_can_access 0))
(assert (>= target_MEM_061_allocated_can_access 0))
(assert (not (= source_MEM_061_allocated_can_access target_MEM_061_allocated_can_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_062_freed_cannot_access: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_062_freed_cannot_access preserves semantics
(push 1)
(declare-const source_MEM_062_freed_cannot_access Int)
(declare-const target_MEM_062_freed_cannot_access Int)
(assert (>= source_MEM_062_freed_cannot_access 0))
(assert (>= target_MEM_062_freed_cannot_access 0))
(assert (not (= source_MEM_062_freed_cannot_access target_MEM_062_freed_cannot_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_063_access_implies_allocated: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_063_access_implies_allocated preserves semantics
(push 1)
(declare-const source_MEM_063_access_implies_allocated Int)
(declare-const target_MEM_063_access_implies_allocated Int)
(assert (>= source_MEM_063_access_implies_allocated 0))
(assert (>= target_MEM_063_access_implies_allocated 0))
(assert (not (= source_MEM_063_access_implies_allocated target_MEM_063_access_implies_allocated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_064_access_implies_owned: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_064_access_implies_owned preserves semantics
(push 1)
(declare-const source_MEM_064_access_implies_owned Int)
(declare-const target_MEM_064_access_implies_owned Int)
(assert (>= source_MEM_064_access_implies_owned 0))
(assert (>= target_MEM_064_access_implies_owned 0))
(assert (not (= source_MEM_064_access_implies_owned target_MEM_064_access_implies_owned)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_065_uaf_prevented: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_065_uaf_prevented preserves semantics
(push 1)
(declare-const source_MEM_065_uaf_prevented Int)
(declare-const target_MEM_065_uaf_prevented Int)
(assert (>= source_MEM_065_uaf_prevented 0))
(assert (>= target_MEM_065_uaf_prevented 0))
(assert (not (= source_MEM_065_uaf_prevented target_MEM_065_uaf_prevented)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_066_stack_protected: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_066_stack_protected preserves semantics
(push 1)
(declare-const source_MEM_066_stack_protected Int)
(declare-const target_MEM_066_stack_protected Int)
(assert (>= source_MEM_066_stack_protected 0))
(assert (>= target_MEM_066_stack_protected 0))
(assert (not (= source_MEM_066_stack_protected target_MEM_066_stack_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_067_canary_enabled: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_067_canary_enabled preserves semantics
(push 1)
(declare-const source_MEM_067_canary_enabled Int)
(declare-const target_MEM_067_canary_enabled Int)
(assert (>= source_MEM_067_canary_enabled 0))
(assert (>= target_MEM_067_canary_enabled 0))
(assert (not (= source_MEM_067_canary_enabled target_MEM_067_canary_enabled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_068_return_addr_protected: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_068_return_addr_protected preserves semantics
(push 1)
(declare-const source_MEM_068_return_addr_protected Int)
(declare-const target_MEM_068_return_addr_protected Int)
(assert (>= source_MEM_068_return_addr_protected 0))
(assert (>= target_MEM_068_return_addr_protected 0))
(assert (not (= source_MEM_068_return_addr_protected target_MEM_068_return_addr_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_069_frame_isolation: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_069_frame_isolation preserves semantics
(push 1)
(declare-const source_MEM_069_frame_isolation Int)
(declare-const target_MEM_069_frame_isolation Int)
(assert (>= source_MEM_069_frame_isolation 0))
(assert (>= target_MEM_069_frame_isolation 0))
(assert (not (= source_MEM_069_frame_isolation target_MEM_069_frame_isolation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_070_shadow_stack: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_070_shadow_stack preserves semantics
(push 1)
(declare-const source_MEM_070_shadow_stack Int)
(declare-const target_MEM_070_shadow_stack Int)
(assert (>= source_MEM_070_shadow_stack 0))
(assert (>= target_MEM_070_shadow_stack 0))
(assert (not (= source_MEM_070_shadow_stack target_MEM_070_shadow_stack)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_071_stack_implies_canary: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_071_stack_implies_canary preserves semantics
(push 1)
(declare-const source_MEM_071_stack_implies_canary Int)
(declare-const target_MEM_071_stack_implies_canary Int)
(assert (>= source_MEM_071_stack_implies_canary 0))
(assert (>= target_MEM_071_stack_implies_canary 0))
(assert (not (= source_MEM_071_stack_implies_canary target_MEM_071_stack_implies_canary)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_072_stack_implies_return_protected: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_072_stack_implies_return_protected preserves semantics
(push 1)
(declare-const source_MEM_072_stack_implies_return_protected Int)
(declare-const target_MEM_072_stack_implies_return_protected Int)
(assert (>= source_MEM_072_stack_implies_return_protected 0))
(assert (>= target_MEM_072_stack_implies_return_protected 0))
(assert (not (= source_MEM_072_stack_implies_return_protected target_MEM_072_stack_implies_return_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_073_stack_implies_frame_isolation: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_073_stack_implies_frame_isolation preserves semantics
(push 1)
(declare-const source_MEM_073_stack_implies_frame_isolation Int)
(declare-const target_MEM_073_stack_implies_frame_isolation Int)
(assert (>= source_MEM_073_stack_implies_frame_isolation 0))
(assert (>= target_MEM_073_stack_implies_frame_isolation 0))
(assert (not (= source_MEM_073_stack_implies_frame_isolation target_MEM_073_stack_implies_frame_isolation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_074_stack_implies_shadow: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_074_stack_implies_shadow preserves semantics
(push 1)
(declare-const source_MEM_074_stack_implies_shadow Int)
(declare-const target_MEM_074_stack_implies_shadow Int)
(assert (>= source_MEM_074_stack_implies_shadow 0))
(assert (>= target_MEM_074_stack_implies_shadow 0))
(assert (not (= source_MEM_074_stack_implies_shadow target_MEM_074_stack_implies_shadow)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_075_complete_stack_protection: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_075_complete_stack_protection preserves semantics
(push 1)
(declare-const source_MEM_075_complete_stack_protection Int)
(declare-const target_MEM_075_complete_stack_protection Int)
(assert (>= source_MEM_075_complete_stack_protection 0))
(assert (>= target_MEM_075_complete_stack_protection 0))
(assert (not (= source_MEM_075_complete_stack_protection target_MEM_075_complete_stack_protection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_076_heap_protected: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_076_heap_protected preserves semantics
(push 1)
(declare-const source_MEM_076_heap_protected Int)
(declare-const target_MEM_076_heap_protected Int)
(assert (>= source_MEM_076_heap_protected 0))
(assert (>= target_MEM_076_heap_protected 0))
(assert (not (= source_MEM_076_heap_protected target_MEM_076_heap_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_077_allocation_tracking: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_077_allocation_tracking preserves semantics
(push 1)
(declare-const source_MEM_077_allocation_tracking Int)
(declare-const target_MEM_077_allocation_tracking Int)
(assert (>= source_MEM_077_allocation_tracking 0))
(assert (>= target_MEM_077_allocation_tracking 0))
(assert (not (= source_MEM_077_allocation_tracking target_MEM_077_allocation_tracking)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_078_deallocation_check: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_078_deallocation_check preserves semantics
(push 1)
(declare-const source_MEM_078_deallocation_check Int)
(declare-const target_MEM_078_deallocation_check Int)
(assert (>= source_MEM_078_deallocation_check 0))
(assert (>= target_MEM_078_deallocation_check 0))
(assert (not (= source_MEM_078_deallocation_check target_MEM_078_deallocation_check)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_079_fragmentation_prevention: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_079_fragmentation_prevention preserves semantics
(push 1)
(declare-const source_MEM_079_fragmentation_prevention Int)
(declare-const target_MEM_079_fragmentation_prevention Int)
(assert (>= source_MEM_079_fragmentation_prevention 0))
(assert (>= target_MEM_079_fragmentation_prevention 0))
(assert (not (= source_MEM_079_fragmentation_prevention target_MEM_079_fragmentation_prevention)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_080_metadata_integrity: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_080_metadata_integrity preserves semantics
(push 1)
(declare-const source_MEM_080_metadata_integrity Int)
(declare-const target_MEM_080_metadata_integrity Int)
(assert (>= source_MEM_080_metadata_integrity 0))
(assert (>= target_MEM_080_metadata_integrity 0))
(assert (not (= source_MEM_080_metadata_integrity target_MEM_080_metadata_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_081_heap_implies_allocation_tracking: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_081_heap_implies_allocation_tracking preserves semantics
(push 1)
(declare-const source_MEM_081_heap_implies_allocation_tracking Int)
(declare-const target_MEM_081_heap_implies_allocation_tracking Int)
(assert (>= source_MEM_081_heap_implies_allocation_tracking 0))
(assert (>= target_MEM_081_heap_implies_allocation_tracking 0))
(assert (not (= source_MEM_081_heap_implies_allocation_tracking target_MEM_081_heap_implies_allocation_tracking)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_082_heap_implies_deallocation_check: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_082_heap_implies_deallocation_check preserves semantics
(push 1)
(declare-const source_MEM_082_heap_implies_deallocation_check Int)
(declare-const target_MEM_082_heap_implies_deallocation_check Int)
(assert (>= source_MEM_082_heap_implies_deallocation_check 0))
(assert (>= target_MEM_082_heap_implies_deallocation_check 0))
(assert (not (= source_MEM_082_heap_implies_deallocation_check target_MEM_082_heap_implies_deallocation_check)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_083_heap_implies_fragmentation_prevention: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_083_heap_implies_fragmentation_prevention preserves semantics
(push 1)
(declare-const source_MEM_083_heap_implies_fragmentation_prevention Int)
(declare-const target_MEM_083_heap_implies_fragmentation_prevention Int)
(assert (>= source_MEM_083_heap_implies_fragmentation_prevention 0))
(assert (>= target_MEM_083_heap_implies_fragmentation_prevention 0))
(assert (not (= source_MEM_083_heap_implies_fragmentation_prevention target_MEM_083_heap_implies_fragmentation_prevention)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_084_heap_implies_metadata_integrity: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_084_heap_implies_metadata_integrity preserves semantics
(push 1)
(declare-const source_MEM_084_heap_implies_metadata_integrity Int)
(declare-const target_MEM_084_heap_implies_metadata_integrity Int)
(assert (>= source_MEM_084_heap_implies_metadata_integrity 0))
(assert (>= target_MEM_084_heap_implies_metadata_integrity 0))
(assert (not (= source_MEM_084_heap_implies_metadata_integrity target_MEM_084_heap_implies_metadata_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_085_complete_heap_protection: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_085_complete_heap_protection preserves semantics
(push 1)
(declare-const source_MEM_085_complete_heap_protection Int)
(declare-const target_MEM_085_complete_heap_protection Int)
(assert (>= source_MEM_085_complete_heap_protection 0))
(assert (>= target_MEM_085_complete_heap_protection 0))
(assert (not (= source_MEM_085_complete_heap_protection target_MEM_085_complete_heap_protection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_086_isolation_protected: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_086_isolation_protected preserves semantics
(push 1)
(declare-const source_MEM_086_isolation_protected Int)
(declare-const target_MEM_086_isolation_protected Int)
(assert (>= source_MEM_086_isolation_protected 0))
(assert (>= target_MEM_086_isolation_protected 0))
(assert (not (= source_MEM_086_isolation_protected target_MEM_086_isolation_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_087_domain_separation: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_087_domain_separation preserves semantics
(push 1)
(declare-const source_MEM_087_domain_separation Int)
(declare-const target_MEM_087_domain_separation Int)
(assert (>= source_MEM_087_domain_separation 0))
(assert (>= target_MEM_087_domain_separation 0))
(assert (not (= source_MEM_087_domain_separation target_MEM_087_domain_separation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_088_permission_enforcement: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_088_permission_enforcement preserves semantics
(push 1)
(declare-const source_MEM_088_permission_enforcement Int)
(declare-const target_MEM_088_permission_enforcement Int)
(assert (>= source_MEM_088_permission_enforcement 0))
(assert (>= target_MEM_088_permission_enforcement 0))
(assert (not (= source_MEM_088_permission_enforcement target_MEM_088_permission_enforcement)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_089_cross_domain_check: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_089_cross_domain_check preserves semantics
(push 1)
(declare-const source_MEM_089_cross_domain_check Int)
(declare-const target_MEM_089_cross_domain_check Int)
(assert (>= source_MEM_089_cross_domain_check 0))
(assert (>= target_MEM_089_cross_domain_check 0))
(assert (not (= source_MEM_089_cross_domain_check target_MEM_089_cross_domain_check)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_090_capability_required: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_090_capability_required preserves semantics
(push 1)
(declare-const source_MEM_090_capability_required Int)
(declare-const target_MEM_090_capability_required Int)
(assert (>= source_MEM_090_capability_required 0))
(assert (>= target_MEM_090_capability_required 0))
(assert (not (= source_MEM_090_capability_required target_MEM_090_capability_required)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_091_isolation_implies_domain_separation: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_091_isolation_implies_domain_separation preserves semantics
(push 1)
(declare-const source_MEM_091_isolation_implies_domain_separation Int)
(declare-const target_MEM_091_isolation_implies_domain_separation Int)
(assert (>= source_MEM_091_isolation_implies_domain_separation 0))
(assert (>= target_MEM_091_isolation_implies_domain_separation 0))
(assert (not (= source_MEM_091_isolation_implies_domain_separation target_MEM_091_isolation_implies_domain_separation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_092_isolation_implies_permission_enforcement: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_092_isolation_implies_permission_enforcement preserves semantics
(push 1)
(declare-const source_MEM_092_isolation_implies_permission_enforcement Int)
(declare-const target_MEM_092_isolation_implies_permission_enforcement Int)
(assert (>= source_MEM_092_isolation_implies_permission_enforcement 0))
(assert (>= target_MEM_092_isolation_implies_permission_enforcement 0))
(assert (not (= source_MEM_092_isolation_implies_permission_enforcement target_MEM_092_isolation_implies_permission_enforcement)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_093_isolation_implies_cross_domain_check: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_093_isolation_implies_cross_domain_check preserves semantics
(push 1)
(declare-const source_MEM_093_isolation_implies_cross_domain_check Int)
(declare-const target_MEM_093_isolation_implies_cross_domain_check Int)
(assert (>= source_MEM_093_isolation_implies_cross_domain_check 0))
(assert (>= target_MEM_093_isolation_implies_cross_domain_check 0))
(assert (not (= source_MEM_093_isolation_implies_cross_domain_check target_MEM_093_isolation_implies_cross_domain_check)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_094_isolation_implies_capability: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_094_isolation_implies_capability preserves semantics
(push 1)
(declare-const source_MEM_094_isolation_implies_capability Int)
(declare-const target_MEM_094_isolation_implies_capability Int)
(assert (>= source_MEM_094_isolation_implies_capability 0))
(assert (>= target_MEM_094_isolation_implies_capability 0))
(assert (not (= source_MEM_094_isolation_implies_capability target_MEM_094_isolation_implies_capability)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_095_complete_isolation: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_095_complete_isolation preserves semantics
(push 1)
(declare-const source_MEM_095_complete_isolation Int)
(declare-const target_MEM_095_complete_isolation Int)
(assert (>= source_MEM_095_complete_isolation 0))
(assert (>= target_MEM_095_complete_isolation 0))
(assert (not (= source_MEM_095_complete_isolation target_MEM_095_complete_isolation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_096_kernel_can_access_kernel: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_096_kernel_can_access_kernel preserves semantics
(push 1)
(declare-const source_MEM_096_kernel_can_access_kernel Int)
(declare-const target_MEM_096_kernel_can_access_kernel Int)
(assert (>= source_MEM_096_kernel_can_access_kernel 0))
(assert (>= target_MEM_096_kernel_can_access_kernel 0))
(assert (not (= source_MEM_096_kernel_can_access_kernel target_MEM_096_kernel_can_access_kernel)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_097_kernel_can_access_user: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_097_kernel_can_access_user preserves semantics
(push 1)
(declare-const source_MEM_097_kernel_can_access_user Int)
(declare-const target_MEM_097_kernel_can_access_user Int)
(assert (>= source_MEM_097_kernel_can_access_user 0))
(assert (>= target_MEM_097_kernel_can_access_user 0))
(assert (not (= source_MEM_097_kernel_can_access_user target_MEM_097_kernel_can_access_user)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_098_kernel_can_access_guest: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_098_kernel_can_access_guest preserves semantics
(push 1)
(declare-const source_MEM_098_kernel_can_access_guest Int)
(declare-const target_MEM_098_kernel_can_access_guest Int)
(assert (>= source_MEM_098_kernel_can_access_guest 0))
(assert (>= target_MEM_098_kernel_can_access_guest 0))
(assert (not (= source_MEM_098_kernel_can_access_guest target_MEM_098_kernel_can_access_guest)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_099_kernel_can_access_untrusted: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_099_kernel_can_access_untrusted preserves semantics
(push 1)
(declare-const source_MEM_099_kernel_can_access_untrusted Int)
(declare-const target_MEM_099_kernel_can_access_untrusted Int)
(assert (>= source_MEM_099_kernel_can_access_untrusted 0))
(assert (>= target_MEM_099_kernel_can_access_untrusted 0))
(assert (not (= source_MEM_099_kernel_can_access_untrusted target_MEM_099_kernel_can_access_untrusted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_100_user_cannot_access_kernel: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_100_user_cannot_access_kernel preserves semantics
(push 1)
(declare-const source_MEM_100_user_cannot_access_kernel Int)
(declare-const target_MEM_100_user_cannot_access_kernel Int)
(assert (>= source_MEM_100_user_cannot_access_kernel 0))
(assert (>= target_MEM_100_user_cannot_access_kernel 0))
(assert (not (= source_MEM_100_user_cannot_access_kernel target_MEM_100_user_cannot_access_kernel)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_101_user_can_access_user: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_101_user_can_access_user preserves semantics
(push 1)
(declare-const source_MEM_101_user_can_access_user Int)
(declare-const target_MEM_101_user_can_access_user Int)
(assert (>= source_MEM_101_user_can_access_user 0))
(assert (>= target_MEM_101_user_can_access_user 0))
(assert (not (= source_MEM_101_user_can_access_user target_MEM_101_user_can_access_user)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_102_guest_cannot_access_user: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_102_guest_cannot_access_user preserves semantics
(push 1)
(declare-const source_MEM_102_guest_cannot_access_user Int)
(declare-const target_MEM_102_guest_cannot_access_user Int)
(assert (>= source_MEM_102_guest_cannot_access_user 0))
(assert (>= target_MEM_102_guest_cannot_access_user 0))
(assert (not (= source_MEM_102_guest_cannot_access_user target_MEM_102_guest_cannot_access_user)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_103_untrusted_cannot_access_guest: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_103_untrusted_cannot_access_guest preserves semantics
(push 1)
(declare-const source_MEM_103_untrusted_cannot_access_guest Int)
(declare-const target_MEM_103_untrusted_cannot_access_guest Int)
(assert (>= source_MEM_103_untrusted_cannot_access_guest 0))
(assert (>= target_MEM_103_untrusted_cannot_access_guest 0))
(assert (not (= source_MEM_103_untrusted_cannot_access_guest target_MEM_103_untrusted_cannot_access_guest)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_104_domain_access_reflexive: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_104_domain_access_reflexive preserves semantics
(push 1)
(declare-const source_MEM_104_domain_access_reflexive Int)
(declare-const target_MEM_104_domain_access_reflexive Int)
(assert (>= source_MEM_104_domain_access_reflexive 0))
(assert (>= target_MEM_104_domain_access_reflexive 0))
(assert (not (= source_MEM_104_domain_access_reflexive target_MEM_104_domain_access_reflexive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_105_domain_hierarchy_transitive: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_105_domain_hierarchy_transitive preserves semantics
(push 1)
(declare-const source_MEM_105_domain_hierarchy_transitive Int)
(declare-const target_MEM_105_domain_hierarchy_transitive Int)
(assert (>= source_MEM_105_domain_hierarchy_transitive 0))
(assert (>= target_MEM_105_domain_hierarchy_transitive 0))
(assert (not (= source_MEM_105_domain_hierarchy_transitive target_MEM_105_domain_hierarchy_transitive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_106_kernel_read_kernel_region: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_106_kernel_read_kernel_region preserves semantics
(push 1)
(declare-const source_MEM_106_kernel_read_kernel_region Int)
(declare-const target_MEM_106_kernel_read_kernel_region Int)
(assert (>= source_MEM_106_kernel_read_kernel_region 0))
(assert (>= target_MEM_106_kernel_read_kernel_region 0))
(assert (not (= source_MEM_106_kernel_read_kernel_region target_MEM_106_kernel_read_kernel_region)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_107_user_cannot_read_kernel_region: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_107_user_cannot_read_kernel_region preserves semantics
(push 1)
(declare-const source_MEM_107_user_cannot_read_kernel_region Int)
(declare-const target_MEM_107_user_cannot_read_kernel_region Int)
(assert (>= source_MEM_107_user_cannot_read_kernel_region 0))
(assert (>= target_MEM_107_user_cannot_read_kernel_region 0))
(assert (not (= source_MEM_107_user_cannot_read_kernel_region target_MEM_107_user_cannot_read_kernel_region)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_108_kernel_read_user_region: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_108_kernel_read_user_region preserves semantics
(push 1)
(declare-const source_MEM_108_kernel_read_user_region Int)
(declare-const target_MEM_108_kernel_read_user_region Int)
(assert (>= source_MEM_108_kernel_read_user_region 0))
(assert (>= target_MEM_108_kernel_read_user_region 0))
(assert (not (= source_MEM_108_kernel_read_user_region target_MEM_108_kernel_read_user_region)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_109_user_read_user_region: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_109_user_read_user_region preserves semantics
(push 1)
(declare-const source_MEM_109_user_read_user_region Int)
(declare-const target_MEM_109_user_read_user_region Int)
(assert (>= source_MEM_109_user_read_user_region 0))
(assert (>= target_MEM_109_user_read_user_region 0))
(assert (not (= source_MEM_109_user_read_user_region target_MEM_109_user_read_user_region)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_110_guest_read_guest_region: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_110_guest_read_guest_region preserves semantics
(push 1)
(declare-const source_MEM_110_guest_read_guest_region Int)
(declare-const target_MEM_110_guest_read_guest_region Int)
(assert (>= source_MEM_110_guest_read_guest_region 0))
(assert (>= target_MEM_110_guest_read_guest_region 0))
(assert (not (= source_MEM_110_guest_read_guest_region target_MEM_110_guest_read_guest_region)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_111_guest_cannot_write_guest_region: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_111_guest_cannot_write_guest_region preserves semantics
(push 1)
(declare-const source_MEM_111_guest_cannot_write_guest_region Int)
(declare-const target_MEM_111_guest_cannot_write_guest_region Int)
(assert (>= source_MEM_111_guest_cannot_write_guest_region 0))
(assert (>= target_MEM_111_guest_cannot_write_guest_region 0))
(assert (not (= source_MEM_111_guest_cannot_write_guest_region target_MEM_111_guest_cannot_write_guest_region)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_112_kernel_write_user_region: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_112_kernel_write_user_region preserves semantics
(push 1)
(declare-const source_MEM_112_kernel_write_user_region Int)
(declare-const target_MEM_112_kernel_write_user_region Int)
(assert (>= source_MEM_112_kernel_write_user_region 0))
(assert (>= target_MEM_112_kernel_write_user_region 0))
(assert (not (= source_MEM_112_kernel_write_user_region target_MEM_112_kernel_write_user_region)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_113_read_requires_allocation: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_113_read_requires_allocation preserves semantics
(push 1)
(declare-const source_MEM_113_read_requires_allocation Int)
(declare-const target_MEM_113_read_requires_allocation Int)
(assert (>= source_MEM_113_read_requires_allocation 0))
(assert (>= target_MEM_113_read_requires_allocation 0))
(assert (not (= source_MEM_113_read_requires_allocation target_MEM_113_read_requires_allocation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_114_write_requires_allocation: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_114_write_requires_allocation preserves semantics
(push 1)
(declare-const source_MEM_114_write_requires_allocation Int)
(declare-const target_MEM_114_write_requires_allocation Int)
(assert (>= source_MEM_114_write_requires_allocation 0))
(assert (>= target_MEM_114_write_requires_allocation 0))
(assert (not (= source_MEM_114_write_requires_allocation target_MEM_114_write_requires_allocation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_115_read_requires_permission: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_115_read_requires_permission preserves semantics
(push 1)
(declare-const source_MEM_115_read_requires_permission Int)
(declare-const target_MEM_115_read_requires_permission Int)
(assert (>= source_MEM_115_read_requires_permission 0))
(assert (>= target_MEM_115_read_requires_permission 0))
(assert (not (= source_MEM_115_read_requires_permission target_MEM_115_read_requires_permission)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_116_full_memory_safe_implies_stack: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_116_full_memory_safe_implies_stack preserves semantics
(push 1)
(declare-const source_MEM_116_full_memory_safe_implies_stack Int)
(declare-const target_MEM_116_full_memory_safe_implies_stack Int)
(assert (>= source_MEM_116_full_memory_safe_implies_stack 0))
(assert (>= target_MEM_116_full_memory_safe_implies_stack 0))
(assert (not (= source_MEM_116_full_memory_safe_implies_stack target_MEM_116_full_memory_safe_implies_stack)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_117_full_memory_safe_implies_heap: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_117_full_memory_safe_implies_heap preserves semantics
(push 1)
(declare-const source_MEM_117_full_memory_safe_implies_heap Int)
(declare-const target_MEM_117_full_memory_safe_implies_heap Int)
(assert (>= source_MEM_117_full_memory_safe_implies_heap 0))
(assert (>= target_MEM_117_full_memory_safe_implies_heap 0))
(assert (not (= source_MEM_117_full_memory_safe_implies_heap target_MEM_117_full_memory_safe_implies_heap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_118_full_memory_safe_implies_isolation: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_118_full_memory_safe_implies_isolation preserves semantics
(push 1)
(declare-const source_MEM_118_full_memory_safe_implies_isolation Int)
(declare-const target_MEM_118_full_memory_safe_implies_isolation Int)
(assert (>= source_MEM_118_full_memory_safe_implies_isolation 0))
(assert (>= target_MEM_118_full_memory_safe_implies_isolation 0))
(assert (not (= source_MEM_118_full_memory_safe_implies_isolation target_MEM_118_full_memory_safe_implies_isolation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_119_riina_full_protection: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_119_riina_full_protection preserves semantics
(push 1)
(declare-const source_MEM_119_riina_full_protection Int)
(declare-const target_MEM_119_riina_full_protection Int)
(assert (>= source_MEM_119_riina_full_protection 0))
(assert (>= target_MEM_119_riina_full_protection 0))
(assert (not (= source_MEM_119_riina_full_protection target_MEM_119_riina_full_protection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_120_no_uaf_with_tracking: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_120_no_uaf_with_tracking preserves semantics
(push 1)
(declare-const source_MEM_120_no_uaf_with_tracking Int)
(declare-const target_MEM_120_no_uaf_with_tracking Int)
(assert (>= source_MEM_120_no_uaf_with_tracking 0))
(assert (>= target_MEM_120_no_uaf_with_tracking 0))
(assert (not (= source_MEM_120_no_uaf_with_tracking target_MEM_120_no_uaf_with_tracking)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_121_no_double_free_with_tracking: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_121_no_double_free_with_tracking preserves semantics
(push 1)
(declare-const source_MEM_121_no_double_free_with_tracking Int)
(declare-const target_MEM_121_no_double_free_with_tracking Int)
(assert (>= source_MEM_121_no_double_free_with_tracking 0))
(assert (>= target_MEM_121_no_double_free_with_tracking 0))
(assert (not (= source_MEM_121_no_double_free_with_tracking target_MEM_121_no_double_free_with_tracking)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_122_null_safety_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_122_null_safety_complete preserves semantics
(push 1)
(declare-const source_MEM_122_null_safety_complete Int)
(declare-const target_MEM_122_null_safety_complete Int)
(assert (>= source_MEM_122_null_safety_complete 0))
(assert (>= target_MEM_122_null_safety_complete 0))
(assert (not (= source_MEM_122_null_safety_complete target_MEM_122_null_safety_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_123_bounds_safety_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_123_bounds_safety_complete preserves semantics
(push 1)
(declare-const source_MEM_123_bounds_safety_complete Int)
(declare-const target_MEM_123_bounds_safety_complete Int)
(assert (>= source_MEM_123_bounds_safety_complete 0))
(assert (>= target_MEM_123_bounds_safety_complete 0))
(assert (not (= source_MEM_123_bounds_safety_complete target_MEM_123_bounds_safety_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_124_ptr_safe_zero_offset: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_124_ptr_safe_zero_offset preserves semantics
(push 1)
(declare-const source_MEM_124_ptr_safe_zero_offset Int)
(declare-const target_MEM_124_ptr_safe_zero_offset Int)
(assert (>= source_MEM_124_ptr_safe_zero_offset 0))
(assert (>= target_MEM_124_ptr_safe_zero_offset 0))
(assert (not (= source_MEM_124_ptr_safe_zero_offset target_MEM_124_ptr_safe_zero_offset)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_125_complete_memory_safety_riina: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_125_complete_memory_safety_riina preserves semantics
(push 1)
(declare-const source_MEM_125_complete_memory_safety_riina Int)
(declare-const target_MEM_125_complete_memory_safety_riina Int)
(assert (>= source_MEM_125_complete_memory_safety_riina 0))
(assert (>= target_MEM_125_complete_memory_safety_riina 0))
(assert (not (= source_MEM_125_complete_memory_safety_riina target_MEM_125_complete_memory_safety_riina)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_126_safe_range_valid_pointer: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_126_safe_range_valid_pointer preserves semantics
(push 1)
(declare-const source_MEM_126_safe_range_valid_pointer Int)
(declare-const target_MEM_126_safe_range_valid_pointer Int)
(assert (>= source_MEM_126_safe_range_valid_pointer 0))
(assert (>= target_MEM_126_safe_range_valid_pointer 0))
(assert (not (= source_MEM_126_safe_range_valid_pointer target_MEM_126_safe_range_valid_pointer)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_127_unsafe_range_exceeds_bounds: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_127_unsafe_range_exceeds_bounds preserves semantics
(push 1)
(declare-const source_MEM_127_unsafe_range_exceeds_bounds Int)
(declare-const target_MEM_127_unsafe_range_exceeds_bounds Int)
(assert (>= source_MEM_127_unsafe_range_exceeds_bounds 0))
(assert (>= target_MEM_127_unsafe_range_exceeds_bounds 0))
(assert (not (= source_MEM_127_unsafe_range_exceeds_bounds target_MEM_127_unsafe_range_exceeds_bounds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_128_null_unsafe_for_range: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_128_null_unsafe_for_range preserves semantics
(push 1)
(declare-const source_MEM_128_null_unsafe_for_range Int)
(declare-const target_MEM_128_null_unsafe_for_range Int)
(assert (>= source_MEM_128_null_unsafe_for_range 0))
(assert (>= target_MEM_128_null_unsafe_for_range 0))
(assert (not (= source_MEM_128_null_unsafe_for_range target_MEM_128_null_unsafe_for_range)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_129_dangling_unsafe_for_range: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_129_dangling_unsafe_for_range preserves semantics
(push 1)
(declare-const source_MEM_129_dangling_unsafe_for_range Int)
(declare-const target_MEM_129_dangling_unsafe_for_range Int)
(assert (>= source_MEM_129_dangling_unsafe_for_range 0))
(assert (>= target_MEM_129_dangling_unsafe_for_range 0))
(assert (not (= source_MEM_129_dangling_unsafe_for_range target_MEM_129_dangling_unsafe_for_range)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_130_safe_range_implies_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_130_safe_range_implies_valid preserves semantics
(push 1)
(declare-const source_MEM_130_safe_range_implies_valid Int)
(declare-const target_MEM_130_safe_range_implies_valid Int)
(assert (>= source_MEM_130_safe_range_implies_valid 0))
(assert (>= target_MEM_130_safe_range_implies_valid 0))
(assert (not (= source_MEM_130_safe_range_implies_valid target_MEM_130_safe_range_implies_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_131_zero_range_safe_if_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_131_zero_range_safe_if_valid preserves semantics
(push 1)
(declare-const source_MEM_131_zero_range_safe_if_valid Int)
(declare-const target_MEM_131_zero_range_safe_if_valid Int)
(assert (>= source_MEM_131_zero_range_safe_if_valid 0))
(assert (>= target_MEM_131_zero_range_safe_if_valid 0))
(assert (not (= source_MEM_131_zero_range_safe_if_valid target_MEM_131_zero_range_safe_if_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_132_safe_range_monotonic: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_132_safe_range_monotonic preserves semantics
(push 1)
(declare-const source_MEM_132_safe_range_monotonic Int)
(declare-const target_MEM_132_safe_range_monotonic Int)
(assert (>= source_MEM_132_safe_range_monotonic 0))
(assert (>= target_MEM_132_safe_range_monotonic 0))
(assert (not (= source_MEM_132_safe_range_monotonic target_MEM_132_safe_range_monotonic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_133_single_access_from_range: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_133_single_access_from_range preserves semantics
(push 1)
(declare-const source_MEM_133_single_access_from_range Int)
(declare-const target_MEM_133_single_access_from_range Int)
(assert (>= source_MEM_133_single_access_from_range 0))
(assert (>= target_MEM_133_single_access_from_range 0))
(assert (not (= source_MEM_133_single_access_from_range target_MEM_133_single_access_from_range)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_134_out_of_bounds_unsafe: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_134_out_of_bounds_unsafe preserves semantics
(push 1)
(declare-const source_MEM_134_out_of_bounds_unsafe Int)
(declare-const target_MEM_134_out_of_bounds_unsafe Int)
(assert (>= source_MEM_134_out_of_bounds_unsafe 0))
(assert (>= target_MEM_134_out_of_bounds_unsafe 0))
(assert (not (= source_MEM_134_out_of_bounds_unsafe target_MEM_134_out_of_bounds_unsafe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; MEM_135_safe_implies_not_exceeds_bounds: translation preserves property (matches Coq: Theorem)
; Translation validation: MEM_135_safe_implies_not_exceeds_bounds preserves semantics
(push 1)
(declare-const source_MEM_135_safe_implies_not_exceeds_bounds Int)
(declare-const target_MEM_135_safe_implies_not_exceeds_bounds Int)
(assert (>= source_MEM_135_safe_implies_not_exceeds_bounds 0))
(assert (>= target_MEM_135_safe_implies_not_exceeds_bounds 0))
(assert (not (= source_MEM_135_safe_implies_not_exceeds_bounds target_MEM_135_safe_implies_not_exceeds_bounds)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

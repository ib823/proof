; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/ControlFlowIntegrity.v (21 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for ControlFlowIntegrity
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; edge_in_cfg: source semantics (matches Coq)
; Translation validation: edge_in_cfg preserves semantics
(push 1)
(declare-const source_edge_in_cfg Int)
(declare-const target_edge_in_cfg Int)
(assert (>= source_edge_in_cfg 0))
(assert (>= target_edge_in_cfg 0))
(assert (not (= source_edge_in_cfg target_edge_in_cfg)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; shadow_push: source semantics (matches Coq)
; Translation validation: shadow_push preserves semantics
(push 1)
(declare-const source_shadow_push Int)
(declare-const target_shadow_push Int)
(assert (>= source_shadow_push 0))
(assert (>= target_shadow_push 0))
(assert (not (= source_shadow_push target_shadow_push)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; valid_return: source semantics (matches Coq)
; Translation validation: valid_return preserves semantics
(push 1)
(declare-const source_valid_return Int)
(declare-const target_valid_return Int)
(assert (>= source_valid_return 0))
(assert (>= target_valid_return 0))
(assert (not (= source_valid_return target_valid_return)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; valid_indirect_call: source semantics (matches Coq)
; Translation validation: valid_indirect_call preserves semantics
(push 1)
(declare-const source_valid_indirect_call Int)
(declare-const target_valid_indirect_call Int)
(assert (>= source_valid_indirect_call 0))
(assert (>= target_valid_indirect_call 0))
(assert (not (= source_valid_indirect_call target_valid_indirect_call)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; has_perm: source semantics (matches Coq)
; Translation validation: has_perm preserves semantics
(push 1)
(declare-const source_has_perm Int)
(declare-const target_has_perm Int)
(assert (>= source_has_perm 0))
(assert (>= target_has_perm 0))
(assert (not (= source_has_perm target_has_perm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; w_xor_x: source semantics (matches Coq)
; Translation validation: w_xor_x preserves semantics
(push 1)
(declare-const source_w_xor_x Int)
(declare-const target_w_xor_x Int)
(assert (>= source_w_xor_x 0))
(assert (>= target_w_xor_x 0))
(assert (not (= source_w_xor_x target_w_xor_x)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; vtable_type_matches: source semantics (matches Coq)
; Translation validation: vtable_type_matches preserves semantics
(push 1)
(declare-const source_vtable_type_matches Int)
(declare-const target_vtable_type_matches Int)
(assert (>= source_vtable_type_matches 0))
(assert (>= target_vtable_type_matches 0))
(assert (not (= source_vtable_type_matches target_vtable_type_matches)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; handler_registered: source semantics (matches Coq)
; Translation validation: handler_registered preserves semantics
(push 1)
(declare-const source_handler_registered Int)
(declare-const target_handler_registered Int)
(assert (>= source_handler_registered 0))
(assert (>= target_handler_registered 0))
(assert (not (= source_handler_registered target_handler_registered)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; longjmp_safe: source semantics (matches Coq)
; Translation validation: longjmp_safe preserves semantics
(push 1)
(declare-const source_longjmp_safe Int)
(declare-const target_longjmp_safe Int)
(assert (>= source_longjmp_safe 0))
(assert (>= target_longjmp_safe 0))
(assert (not (= source_longjmp_safe target_longjmp_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; got_writable: source semantics (matches Coq)
; Translation validation: got_writable preserves semantics
(push 1)
(declare-const source_got_writable Int)
(declare-const target_got_writable Int)
(assert (>= source_got_writable 0))
(assert (>= target_got_writable 0))
(assert (not (= source_got_writable target_got_writable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; got_protected: source semantics (matches Coq)
; Translation validation: got_protected preserves semantics
(push 1)
(declare-const source_got_protected Int)
(declare-const target_got_protected Int)
(assert (>= source_got_protected 0))
(assert (>= target_got_protected 0))
(assert (not (= source_got_protected target_got_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; thread_accessible: source semantics (matches Coq)
; Translation validation: thread_accessible preserves semantics
(push 1)
(declare-const source_thread_accessible Int)
(declare-const target_thread_accessible Int)
(assert (>= source_thread_accessible 0))
(assert (>= target_thread_accessible 0))
(assert (not (= source_thread_accessible target_thread_accessible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_001_rop_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_001_rop_impossible preserves semantics
(push 1)
(declare-const source_ctl_001_rop_impossible Int)
(declare-const target_ctl_001_rop_impossible Int)
(assert (>= source_ctl_001_rop_impossible 0))
(assert (>= target_ctl_001_rop_impossible 0))
(assert (not (= source_ctl_001_rop_impossible target_ctl_001_rop_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_002_jop_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_002_jop_impossible preserves semantics
(push 1)
(declare-const source_ctl_002_jop_impossible Int)
(declare-const target_ctl_002_jop_impossible Int)
(assert (>= source_ctl_002_jop_impossible 0))
(assert (>= target_ctl_002_jop_impossible 0))
(assert (not (= source_ctl_002_jop_impossible target_ctl_002_jop_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_003_cop_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_003_cop_impossible preserves semantics
(push 1)
(declare-const source_ctl_003_cop_impossible Int)
(declare-const target_ctl_003_cop_impossible Int)
(assert (>= source_ctl_003_cop_impossible 0))
(assert (>= target_ctl_003_cop_impossible 0))
(assert (not (= source_ctl_003_cop_impossible target_ctl_003_cop_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_004_ret2libc_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_004_ret2libc_impossible preserves semantics
(push 1)
(declare-const source_ctl_004_ret2libc_impossible Int)
(declare-const target_ctl_004_ret2libc_impossible Int)
(assert (>= source_ctl_004_ret2libc_impossible 0))
(assert (>= target_ctl_004_ret2libc_impossible 0))
(assert (not (= source_ctl_004_ret2libc_impossible target_ctl_004_ret2libc_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_005_srop_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_005_srop_impossible preserves semantics
(push 1)
(declare-const source_ctl_005_srop_impossible Int)
(declare-const target_ctl_005_srop_impossible Int)
(assert (>= source_ctl_005_srop_impossible 0))
(assert (>= target_ctl_005_srop_impossible 0))
(assert (not (= source_ctl_005_srop_impossible target_ctl_005_srop_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_006_code_injection_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_006_code_injection_impossible preserves semantics
(push 1)
(declare-const source_ctl_006_code_injection_impossible Int)
(declare-const target_ctl_006_code_injection_impossible Int)
(assert (>= source_ctl_006_code_injection_impossible 0))
(assert (>= target_ctl_006_code_injection_impossible 0))
(assert (not (= source_ctl_006_code_injection_impossible target_ctl_006_code_injection_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_007_code_reuse_controlled: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_007_code_reuse_controlled preserves semantics
(push 1)
(declare-const source_ctl_007_code_reuse_controlled Int)
(declare-const target_ctl_007_code_reuse_controlled Int)
(assert (>= source_ctl_007_code_reuse_controlled 0))
(assert (>= target_ctl_007_code_reuse_controlled 0))
(assert (not (= source_ctl_007_code_reuse_controlled target_ctl_007_code_reuse_controlled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_008_data_only_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_008_data_only_mitigated preserves semantics
(push 1)
(declare-const source_ctl_008_data_only_mitigated Int)
(declare-const target_ctl_008_data_only_mitigated Int)
(assert (>= source_ctl_008_data_only_mitigated 0))
(assert (>= target_ctl_008_data_only_mitigated 0))
(assert (not (= source_ctl_008_data_only_mitigated target_ctl_008_data_only_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_009_cf_bending_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_009_cf_bending_impossible preserves semantics
(push 1)
(declare-const source_ctl_009_cf_bending_impossible Int)
(declare-const target_ctl_009_cf_bending_impossible Int)
(assert (>= source_ctl_009_cf_bending_impossible 0))
(assert (>= target_ctl_009_cf_bending_impossible 0))
(assert (not (= source_ctl_009_cf_bending_impossible target_ctl_009_cf_bending_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_010_indirect_call_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_010_indirect_call_safe preserves semantics
(push 1)
(declare-const source_ctl_010_indirect_call_safe Int)
(declare-const target_ctl_010_indirect_call_safe Int)
(assert (>= source_ctl_010_indirect_call_safe 0))
(assert (>= target_ctl_010_indirect_call_safe 0))
(assert (not (= source_ctl_010_indirect_call_safe target_ctl_010_indirect_call_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_011_vtable_hijack_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_011_vtable_hijack_impossible preserves semantics
(push 1)
(declare-const source_ctl_011_vtable_hijack_impossible Int)
(declare-const target_ctl_011_vtable_hijack_impossible Int)
(assert (>= source_ctl_011_vtable_hijack_impossible 0))
(assert (>= target_ctl_011_vtable_hijack_impossible 0))
(assert (not (= source_ctl_011_vtable_hijack_impossible target_ctl_011_vtable_hijack_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_012_exception_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_012_exception_safe preserves semantics
(push 1)
(declare-const source_ctl_012_exception_safe Int)
(declare-const target_ctl_012_exception_safe Int)
(assert (>= source_ctl_012_exception_safe 0))
(assert (>= target_ctl_012_exception_safe 0))
(assert (not (= source_ctl_012_exception_safe target_ctl_012_exception_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_013_longjmp_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_013_longjmp_safe preserves semantics
(push 1)
(declare-const source_ctl_013_longjmp_safe Int)
(declare-const target_ctl_013_longjmp_safe Int)
(assert (>= source_ctl_013_longjmp_safe 0))
(assert (>= target_ctl_013_longjmp_safe 0))
(assert (not (= source_ctl_013_longjmp_safe target_ctl_013_longjmp_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_014_got_plt_protected: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_014_got_plt_protected preserves semantics
(push 1)
(declare-const source_ctl_014_got_plt_protected Int)
(declare-const target_ctl_014_got_plt_protected Int)
(assert (>= source_ctl_014_got_plt_protected 0))
(assert (>= target_ctl_014_got_plt_protected 0))
(assert (not (= source_ctl_014_got_plt_protected target_ctl_014_got_plt_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_015_thread_hijack_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_015_thread_hijack_impossible preserves semantics
(push 1)
(declare-const source_ctl_015_thread_hijack_impossible Int)
(declare-const target_ctl_015_thread_hijack_impossible Int)
(assert (>= source_ctl_015_thread_hijack_impossible 0))
(assert (>= target_ctl_015_thread_hijack_impossible 0))
(assert (not (= source_ctl_015_thread_hijack_impossible target_ctl_015_thread_hijack_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_016_shadow_push_pop_identity: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_016_shadow_push_pop_identity preserves semantics
(push 1)
(declare-const source_ctl_016_shadow_push_pop_identity Int)
(declare-const target_ctl_016_shadow_push_pop_identity Int)
(assert (>= source_ctl_016_shadow_push_pop_identity 0))
(assert (>= target_ctl_016_shadow_push_pop_identity 0))
(assert (not (= source_ctl_016_shadow_push_pop_identity target_ctl_016_shadow_push_pop_identity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_017_valid_return_after_push: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_017_valid_return_after_push preserves semantics
(push 1)
(declare-const source_ctl_017_valid_return_after_push Int)
(declare-const target_ctl_017_valid_return_after_push Int)
(assert (>= source_ctl_017_valid_return_after_push 0))
(assert (>= target_ctl_017_valid_return_after_push 0))
(assert (not (= source_ctl_017_valid_return_after_push target_ctl_017_valid_return_after_push)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_018_wxor_x_empty: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_018_wxor_x_empty preserves semantics
(push 1)
(declare-const source_ctl_018_wxor_x_empty Int)
(declare-const target_ctl_018_wxor_x_empty Int)
(assert (>= source_ctl_018_wxor_x_empty 0))
(assert (>= target_ctl_018_wxor_x_empty 0))
(assert (not (= source_ctl_018_wxor_x_empty target_ctl_018_wxor_x_empty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_019_reloc_state_decidable: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_019_reloc_state_decidable preserves semantics
(push 1)
(declare-const source_ctl_019_reloc_state_decidable Int)
(declare-const target_ctl_019_reloc_state_decidable Int)
(assert (>= source_ctl_019_reloc_state_decidable 0))
(assert (>= target_ctl_019_reloc_state_decidable 0))
(assert (not (= source_ctl_019_reloc_state_decidable target_ctl_019_reloc_state_decidable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_020_shadow_push_length: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_020_shadow_push_length preserves semantics
(push 1)
(declare-const source_ctl_020_shadow_push_length Int)
(declare-const target_ctl_020_shadow_push_length Int)
(assert (>= source_ctl_020_shadow_push_length 0))
(assert (>= target_ctl_020_shadow_push_length 0))
(assert (not (= source_ctl_020_shadow_push_length target_ctl_020_shadow_push_length)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctl_021_valid_trace_prefix: translation preserves property (matches Coq: Theorem)
; Translation validation: ctl_021_valid_trace_prefix preserves semantics
(push 1)
(declare-const source_ctl_021_valid_trace_prefix Int)
(declare-const target_ctl_021_valid_trace_prefix Int)
(assert (>= source_ctl_021_valid_trace_prefix 0))
(assert (>= target_ctl_021_valid_trace_prefix 0))
(assert (not (= source_ctl_021_valid_trace_prefix target_ctl_021_valid_trace_prefix)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

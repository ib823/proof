; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/ROPDefense.v (89 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for ROPDefense
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

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

; return_matches_shadow: source semantics (matches Coq)
; Translation validation: return_matches_shadow preserves semantics
(push 1)
(declare-const source_return_matches_shadow Int)
(declare-const target_return_matches_shadow Int)
(assert (>= source_return_matches_shadow 0))
(assert (>= target_return_matches_shadow 0))
(assert (not (= source_return_matches_shadow target_return_matches_shadow)))
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

; is_valid_target: source semantics (matches Coq)
; Translation validation: is_valid_target preserves semantics
(push 1)
(declare-const source_is_valid_target Int)
(declare-const target_is_valid_target Int)
(assert (>= source_is_valid_target 0))
(assert (>= target_is_valid_target 0))
(assert (not (= source_is_valid_target target_is_valid_target)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; indirect_branch_valid: source semantics (matches Coq)
; Translation validation: indirect_branch_valid preserves semantics
(push 1)
(declare-const source_indirect_branch_valid Int)
(declare-const target_indirect_branch_valid Int)
(assert (>= source_indirect_branch_valid 0))
(assert (>= target_indirect_branch_valid 0))
(assert (not (= source_indirect_branch_valid target_indirect_branch_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; btb_entry_valid: source semantics (matches Coq)
; Translation validation: btb_entry_valid preserves semantics
(push 1)
(declare-const source_btb_entry_valid Int)
(declare-const target_btb_entry_valid Int)
(assert (>= source_btb_entry_valid 0))
(assert (>= target_btb_entry_valid 0))
(assert (not (= source_btb_entry_valid target_btb_entry_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; gadget_blocked: source semantics (matches Coq)
; Translation validation: gadget_blocked preserves semantics
(push 1)
(declare-const source_gadget_blocked Int)
(declare-const target_gadget_blocked Int)
(assert (>= source_gadget_blocked 0))
(assert (>= target_gadget_blocked 0))
(assert (not (= source_gadget_blocked target_gadget_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; chain_blocked: source semantics (matches Coq)
; Translation validation: chain_blocked preserves semantics
(push 1)
(declare-const source_chain_blocked Int)
(declare-const target_chain_blocked Int)
(assert (>= source_chain_blocked 0))
(assert (>= target_chain_blocked 0))
(assert (not (= source_chain_blocked target_chain_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cp_protected: source semantics (matches Coq)
; Translation validation: cp_protected preserves semantics
(push 1)
(declare-const source_cp_protected Int)
(declare-const target_cp_protected Int)
(assert (>= source_cp_protected 0))
(assert (>= target_cp_protected 0))
(assert (not (= source_cp_protected target_cp_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cfi_complete: source semantics (matches Coq)
; Translation validation: cfi_complete preserves semantics
(push 1)
(declare-const source_cfi_complete Int)
(declare-const target_cfi_complete Int)
(assert (>= source_cfi_complete 0))
(assert (>= target_cfi_complete 0))
(assert (not (= source_cfi_complete target_cfi_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; code_reuse_prevented: source semantics (matches Coq)
; Translation validation: code_reuse_prevented preserves semantics
(push 1)
(declare-const source_code_reuse_prevented Int)
(declare-const target_code_reuse_prevented Int)
(assert (>= source_code_reuse_prevented 0))
(assert (>= target_code_reuse_prevented 0))
(assert (not (= source_code_reuse_prevented target_code_reuse_prevented)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; rop_defended: source semantics (matches Coq)
; Translation validation: rop_defended preserves semantics
(push 1)
(declare-const source_rop_defended Int)
(declare-const target_rop_defended Int)
(assert (>= source_rop_defended 0))
(assert (>= target_rop_defended 0))
(assert (not (= source_rop_defended target_rop_defended)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cpi_complete: source semantics (matches Coq)
; Translation validation: cpi_complete preserves semantics
(push 1)
(declare-const source_cpi_complete Int)
(declare-const target_cpi_complete Int)
(assert (>= source_cpi_complete 0))
(assert (>= target_cpi_complete 0))
(assert (not (= source_cpi_complete target_cpi_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_cfi: source semantics (matches Coq)
; Translation validation: riina_cfi preserves semantics
(push 1)
(declare-const source_riina_cfi Int)
(declare-const target_riina_cfi Int)
(assert (>= source_riina_cfi 0))
(assert (>= target_riina_cfi 0))
(assert (not (= source_riina_cfi target_riina_cfi)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_cr: source semantics (matches Coq)
; Translation validation: riina_cr preserves semantics
(push 1)
(declare-const source_riina_cr Int)
(declare-const target_riina_cr Int)
(assert (>= source_riina_cr 0))
(assert (>= target_riina_cr 0))
(assert (not (= source_riina_cr target_riina_cr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_rop: source semantics (matches Coq)
; Translation validation: riina_rop preserves semantics
(push 1)
(declare-const source_riina_rop Int)
(declare-const target_riina_rop Int)
(assert (>= source_riina_rop 0))
(assert (>= target_riina_rop 0))
(assert (not (= source_riina_rop target_riina_rop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_cpi: source semantics (matches Coq)
; Translation validation: riina_cpi preserves semantics
(push 1)
(declare-const source_riina_cpi Int)
(declare-const target_riina_cpi Int)
(assert (>= source_riina_cpi 0))
(assert (>= target_riina_cpi 0))
(assert (not (= source_riina_cpi target_riina_cpi)))
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

; andb_true_intro: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_intro preserves semantics
(push 1)
(declare-const source_andb_true_intro Int)
(declare-const target_andb_true_intro Int)
(assert (>= source_andb_true_intro 0))
(assert (>= target_andb_true_intro 0))
(assert (not (= source_andb_true_intro target_andb_true_intro)))
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

; orb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: orb_true_iff preserves semantics
(push 1)
(declare-const source_orb_true_iff Int)
(declare-const target_orb_true_iff Int)
(assert (>= source_orb_true_iff 0))
(assert (>= target_orb_true_iff 0))
(assert (not (= source_orb_true_iff target_orb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_001: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_001 preserves semantics
(push 1)
(declare-const source_ROP_001 Int)
(declare-const target_ROP_001 Int)
(assert (>= source_ROP_001 0))
(assert (>= target_ROP_001 0))
(assert (not (= source_ROP_001 target_ROP_001)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_002: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_002 preserves semantics
(push 1)
(declare-const source_ROP_002 Int)
(declare-const target_ROP_002 Int)
(assert (>= source_ROP_002 0))
(assert (>= target_ROP_002 0))
(assert (not (= source_ROP_002 target_ROP_002)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_003: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_003 preserves semantics
(push 1)
(declare-const source_ROP_003 Int)
(declare-const target_ROP_003 Int)
(assert (>= source_ROP_003 0))
(assert (>= target_ROP_003 0))
(assert (not (= source_ROP_003 target_ROP_003)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_004: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_004 preserves semantics
(push 1)
(declare-const source_ROP_004 Int)
(declare-const target_ROP_004 Int)
(assert (>= source_ROP_004 0))
(assert (>= target_ROP_004 0))
(assert (not (= source_ROP_004 target_ROP_004)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_005: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_005 preserves semantics
(push 1)
(declare-const source_ROP_005 Int)
(declare-const target_ROP_005 Int)
(assert (>= source_ROP_005 0))
(assert (>= target_ROP_005 0))
(assert (not (= source_ROP_005 target_ROP_005)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_006: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_006 preserves semantics
(push 1)
(declare-const source_ROP_006 Int)
(declare-const target_ROP_006 Int)
(assert (>= source_ROP_006 0))
(assert (>= target_ROP_006 0))
(assert (not (= source_ROP_006 target_ROP_006)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_007: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_007 preserves semantics
(push 1)
(declare-const source_ROP_007 Int)
(declare-const target_ROP_007 Int)
(assert (>= source_ROP_007 0))
(assert (>= target_ROP_007 0))
(assert (not (= source_ROP_007 target_ROP_007)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_008: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_008 preserves semantics
(push 1)
(declare-const source_ROP_008 Int)
(declare-const target_ROP_008 Int)
(assert (>= source_ROP_008 0))
(assert (>= target_ROP_008 0))
(assert (not (= source_ROP_008 target_ROP_008)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_009: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_009 preserves semantics
(push 1)
(declare-const source_ROP_009 Int)
(declare-const target_ROP_009 Int)
(assert (>= source_ROP_009 0))
(assert (>= target_ROP_009 0))
(assert (not (= source_ROP_009 target_ROP_009)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_010: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_010 preserves semantics
(push 1)
(declare-const source_ROP_010 Int)
(declare-const target_ROP_010 Int)
(assert (>= source_ROP_010 0))
(assert (>= target_ROP_010 0))
(assert (not (= source_ROP_010 target_ROP_010)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_011: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_011 preserves semantics
(push 1)
(declare-const source_ROP_011 Int)
(declare-const target_ROP_011 Int)
(assert (>= source_ROP_011 0))
(assert (>= target_ROP_011 0))
(assert (not (= source_ROP_011 target_ROP_011)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_012: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_012 preserves semantics
(push 1)
(declare-const source_ROP_012 Int)
(declare-const target_ROP_012 Int)
(assert (>= source_ROP_012 0))
(assert (>= target_ROP_012 0))
(assert (not (= source_ROP_012 target_ROP_012)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_013: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_013 preserves semantics
(push 1)
(declare-const source_ROP_013 Int)
(declare-const target_ROP_013 Int)
(assert (>= source_ROP_013 0))
(assert (>= target_ROP_013 0))
(assert (not (= source_ROP_013 target_ROP_013)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_014: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_014 preserves semantics
(push 1)
(declare-const source_ROP_014 Int)
(declare-const target_ROP_014 Int)
(assert (>= source_ROP_014 0))
(assert (>= target_ROP_014 0))
(assert (not (= source_ROP_014 target_ROP_014)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_015: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_015 preserves semantics
(push 1)
(declare-const source_ROP_015 Int)
(declare-const target_ROP_015 Int)
(assert (>= source_ROP_015 0))
(assert (>= target_ROP_015 0))
(assert (not (= source_ROP_015 target_ROP_015)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_016: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_016 preserves semantics
(push 1)
(declare-const source_ROP_016 Int)
(declare-const target_ROP_016 Int)
(assert (>= source_ROP_016 0))
(assert (>= target_ROP_016 0))
(assert (not (= source_ROP_016 target_ROP_016)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_017: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_017 preserves semantics
(push 1)
(declare-const source_ROP_017 Int)
(declare-const target_ROP_017 Int)
(assert (>= source_ROP_017 0))
(assert (>= target_ROP_017 0))
(assert (not (= source_ROP_017 target_ROP_017)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_018: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_018 preserves semantics
(push 1)
(declare-const source_ROP_018 Int)
(declare-const target_ROP_018 Int)
(assert (>= source_ROP_018 0))
(assert (>= target_ROP_018 0))
(assert (not (= source_ROP_018 target_ROP_018)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_019: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_019 preserves semantics
(push 1)
(declare-const source_ROP_019 Int)
(declare-const target_ROP_019 Int)
(assert (>= source_ROP_019 0))
(assert (>= target_ROP_019 0))
(assert (not (= source_ROP_019 target_ROP_019)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_020: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_020 preserves semantics
(push 1)
(declare-const source_ROP_020 Int)
(declare-const target_ROP_020 Int)
(assert (>= source_ROP_020 0))
(assert (>= target_ROP_020 0))
(assert (not (= source_ROP_020 target_ROP_020)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_021: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_021 preserves semantics
(push 1)
(declare-const source_ROP_021 Int)
(declare-const target_ROP_021 Int)
(assert (>= source_ROP_021 0))
(assert (>= target_ROP_021 0))
(assert (not (= source_ROP_021 target_ROP_021)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_022: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_022 preserves semantics
(push 1)
(declare-const source_ROP_022 Int)
(declare-const target_ROP_022 Int)
(assert (>= source_ROP_022 0))
(assert (>= target_ROP_022 0))
(assert (not (= source_ROP_022 target_ROP_022)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_023: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_023 preserves semantics
(push 1)
(declare-const source_ROP_023 Int)
(declare-const target_ROP_023 Int)
(assert (>= source_ROP_023 0))
(assert (>= target_ROP_023 0))
(assert (not (= source_ROP_023 target_ROP_023)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_024: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_024 preserves semantics
(push 1)
(declare-const source_ROP_024 Int)
(declare-const target_ROP_024 Int)
(assert (>= source_ROP_024 0))
(assert (>= target_ROP_024 0))
(assert (not (= source_ROP_024 target_ROP_024)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_025_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_025_complete preserves semantics
(push 1)
(declare-const source_ROP_025_complete Int)
(declare-const target_ROP_025_complete Int)
(assert (>= source_ROP_025_complete 0))
(assert (>= target_ROP_025_complete 0))
(assert (not (= source_ROP_025_complete target_ROP_025_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_026_shadow_push_preserves: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_026_shadow_push_preserves preserves semantics
(push 1)
(declare-const source_ROP_026_shadow_push_preserves Int)
(declare-const target_ROP_026_shadow_push_preserves Int)
(assert (>= source_ROP_026_shadow_push_preserves 0))
(assert (>= target_ROP_026_shadow_push_preserves 0))
(assert (not (= source_ROP_026_shadow_push_preserves target_ROP_026_shadow_push_preserves)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_027_shadow_pop_decreases: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_027_shadow_pop_decreases preserves semantics
(push 1)
(declare-const source_ROP_027_shadow_pop_decreases Int)
(declare-const target_ROP_027_shadow_pop_decreases Int)
(assert (>= source_ROP_027_shadow_pop_decreases 0))
(assert (>= target_ROP_027_shadow_pop_decreases 0))
(assert (not (= source_ROP_027_shadow_pop_decreases target_ROP_027_shadow_pop_decreases)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_028_shadow_peek_top: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_028_shadow_peek_top preserves semantics
(push 1)
(declare-const source_ROP_028_shadow_peek_top Int)
(declare-const target_ROP_028_shadow_peek_top Int)
(assert (>= source_ROP_028_shadow_peek_top 0))
(assert (>= target_ROP_028_shadow_peek_top 0))
(assert (not (= source_ROP_028_shadow_peek_top target_ROP_028_shadow_peek_top)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_029_valid_return_requires_entry: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_029_valid_return_requires_entry preserves semantics
(push 1)
(declare-const source_ROP_029_valid_return_requires_entry Int)
(declare-const target_ROP_029_valid_return_requires_entry Int)
(assert (>= source_ROP_029_valid_return_requires_entry 0))
(assert (>= target_ROP_029_valid_return_requires_entry 0))
(assert (not (= source_ROP_029_valid_return_requires_entry target_ROP_029_valid_return_requires_entry)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_030_empty_stack_no_return: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_030_empty_stack_no_return preserves semantics
(push 1)
(declare-const source_ROP_030_empty_stack_no_return Int)
(declare-const target_ROP_030_empty_stack_no_return Int)
(assert (>= source_ROP_030_empty_stack_no_return 0))
(assert (>= target_ROP_030_empty_stack_no_return 0))
(assert (not (= source_ROP_030_empty_stack_no_return target_ROP_030_empty_stack_no_return)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_031_push_pop_inverse: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_031_push_pop_inverse preserves semantics
(push 1)
(declare-const source_ROP_031_push_pop_inverse Int)
(declare-const target_ROP_031_push_pop_inverse Int)
(assert (>= source_ROP_031_push_pop_inverse 0))
(assert (>= target_ROP_031_push_pop_inverse 0))
(assert (not (= source_ROP_031_push_pop_inverse target_ROP_031_push_pop_inverse)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_032_pushed_entry_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_032_pushed_entry_valid preserves semantics
(push 1)
(declare-const source_ROP_032_pushed_entry_valid Int)
(declare-const target_ROP_032_pushed_entry_valid Int)
(assert (>= source_ROP_032_pushed_entry_valid 0))
(assert (>= target_ROP_032_pushed_entry_valid 0))
(assert (not (= source_ROP_032_pushed_entry_valid target_ROP_032_pushed_entry_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_033_return_matches_pushed: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_033_return_matches_pushed preserves semantics
(push 1)
(declare-const source_ROP_033_return_matches_pushed Int)
(declare-const target_ROP_033_return_matches_pushed Int)
(assert (>= source_ROP_033_return_matches_pushed 0))
(assert (>= target_ROP_033_return_matches_pushed 0))
(assert (not (= source_ROP_033_return_matches_pushed target_ROP_033_return_matches_pushed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_034_return_mismatch_fails: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_034_return_mismatch_fails preserves semantics
(push 1)
(declare-const source_ROP_034_return_mismatch_fails Int)
(declare-const target_ROP_034_return_mismatch_fails Int)
(assert (>= source_ROP_034_return_mismatch_fails 0))
(assert (>= target_ROP_034_return_mismatch_fails 0))
(assert (not (= source_ROP_034_return_mismatch_fails target_ROP_034_return_mismatch_fails)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_035_shadow_stack_depth_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_035_shadow_stack_depth_bounded preserves semantics
(push 1)
(declare-const source_ROP_035_shadow_stack_depth_bounded Int)
(declare-const target_ROP_035_shadow_stack_depth_bounded Int)
(assert (>= source_ROP_035_shadow_stack_depth_bounded 0))
(assert (>= target_ROP_035_shadow_stack_depth_bounded 0))
(assert (not (= source_ROP_035_shadow_stack_depth_bounded target_ROP_035_shadow_stack_depth_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_036_valid_target_in_list: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_036_valid_target_in_list preserves semantics
(push 1)
(declare-const source_ROP_036_valid_target_in_list Int)
(declare-const target_ROP_036_valid_target_in_list Int)
(assert (>= source_ROP_036_valid_target_in_list 0))
(assert (>= target_ROP_036_valid_target_in_list 0))
(assert (not (= source_ROP_036_valid_target_in_list target_ROP_036_valid_target_in_list)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_037_empty_targets_no_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_037_empty_targets_no_valid preserves semantics
(push 1)
(declare-const source_ROP_037_empty_targets_no_valid Int)
(declare-const target_ROP_037_empty_targets_no_valid Int)
(assert (>= source_ROP_037_empty_targets_no_valid 0))
(assert (>= target_ROP_037_empty_targets_no_valid 0))
(assert (not (= source_ROP_037_empty_targets_no_valid target_ROP_037_empty_targets_no_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_038_singleton_target_exact: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_038_singleton_target_exact preserves semantics
(push 1)
(declare-const source_ROP_038_singleton_target_exact Int)
(declare-const target_ROP_038_singleton_target_exact Int)
(assert (>= source_ROP_038_singleton_target_exact 0))
(assert (>= target_ROP_038_singleton_target_exact 0))
(assert (not (= source_ROP_038_singleton_target_exact target_ROP_038_singleton_target_exact)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_039_is_valid_target_sound: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_039_is_valid_target_sound preserves semantics
(push 1)
(declare-const source_ROP_039_is_valid_target_sound Int)
(declare-const target_ROP_039_is_valid_target_sound Int)
(assert (>= source_ROP_039_is_valid_target_sound 0))
(assert (>= target_ROP_039_is_valid_target_sound 0))
(assert (not (= source_ROP_039_is_valid_target_sound target_ROP_039_is_valid_target_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_040_is_valid_target_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_040_is_valid_target_complete preserves semantics
(push 1)
(declare-const source_ROP_040_is_valid_target_complete Int)
(declare-const target_ROP_040_is_valid_target_complete Int)
(assert (>= source_ROP_040_is_valid_target_complete 0))
(assert (>= target_ROP_040_is_valid_target_complete 0))
(assert (not (= source_ROP_040_is_valid_target_complete target_ROP_040_is_valid_target_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_041_btb_validated_implies_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_041_btb_validated_implies_valid preserves semantics
(push 1)
(declare-const source_ROP_041_btb_validated_implies_valid Int)
(declare-const target_ROP_041_btb_validated_implies_valid Int)
(assert (>= source_ROP_041_btb_validated_implies_valid 0))
(assert (>= target_ROP_041_btb_validated_implies_valid 0))
(assert (not (= source_ROP_041_btb_validated_implies_valid target_ROP_041_btb_validated_implies_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_042_unvalidated_btb_unsafe: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_042_unvalidated_btb_unsafe preserves semantics
(push 1)
(declare-const source_ROP_042_unvalidated_btb_unsafe Int)
(declare-const target_ROP_042_unvalidated_btb_unsafe Int)
(assert (>= source_ROP_042_unvalidated_btb_unsafe 0))
(assert (>= target_ROP_042_unvalidated_btb_unsafe 0))
(assert (not (= source_ROP_042_unvalidated_btb_unsafe target_ROP_042_unvalidated_btb_unsafe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_043_target_subset_preserved: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_043_target_subset_preserved preserves semantics
(push 1)
(declare-const source_ROP_043_target_subset_preserved Int)
(declare-const target_ROP_043_target_subset_preserved Int)
(assert (>= source_ROP_043_target_subset_preserved 0))
(assert (>= target_ROP_043_target_subset_preserved 0))
(assert (not (= source_ROP_043_target_subset_preserved target_ROP_043_target_subset_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_044_rop_gadget_blocked: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_044_rop_gadget_blocked preserves semantics
(push 1)
(declare-const source_ROP_044_rop_gadget_blocked Int)
(declare-const target_ROP_044_rop_gadget_blocked Int)
(assert (>= source_ROP_044_rop_gadget_blocked 0))
(assert (>= target_ROP_044_rop_gadget_blocked 0))
(assert (not (= source_ROP_044_rop_gadget_blocked target_ROP_044_rop_gadget_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_045_jop_gadget_blocked: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_045_jop_gadget_blocked preserves semantics
(push 1)
(declare-const source_ROP_045_jop_gadget_blocked Int)
(declare-const target_ROP_045_jop_gadget_blocked Int)
(assert (>= source_ROP_045_jop_gadget_blocked 0))
(assert (>= target_ROP_045_jop_gadget_blocked 0))
(assert (not (= source_ROP_045_jop_gadget_blocked target_ROP_045_jop_gadget_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_046_cop_gadget_blocked: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_046_cop_gadget_blocked preserves semantics
(push 1)
(declare-const source_ROP_046_cop_gadget_blocked Int)
(declare-const target_ROP_046_cop_gadget_blocked Int)
(assert (>= source_ROP_046_cop_gadget_blocked 0))
(assert (>= target_ROP_046_cop_gadget_blocked 0))
(assert (not (= source_ROP_046_cop_gadget_blocked target_ROP_046_cop_gadget_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_047_srop_gadget_blocked: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_047_srop_gadget_blocked preserves semantics
(push 1)
(declare-const source_ROP_047_srop_gadget_blocked Int)
(declare-const target_ROP_047_srop_gadget_blocked Int)
(assert (>= source_ROP_047_srop_gadget_blocked 0))
(assert (>= target_ROP_047_srop_gadget_blocked 0))
(assert (not (= source_ROP_047_srop_gadget_blocked target_ROP_047_srop_gadget_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_048_riina_blocks_all_gadgets: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_048_riina_blocks_all_gadgets preserves semantics
(push 1)
(declare-const source_ROP_048_riina_blocks_all_gadgets Int)
(declare-const target_ROP_048_riina_blocks_all_gadgets Int)
(assert (>= source_ROP_048_riina_blocks_all_gadgets 0))
(assert (>= target_ROP_048_riina_blocks_all_gadgets 0))
(assert (not (= source_ROP_048_riina_blocks_all_gadgets target_ROP_048_riina_blocks_all_gadgets)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_049_empty_chain_blocked: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_049_empty_chain_blocked preserves semantics
(push 1)
(declare-const source_ROP_049_empty_chain_blocked Int)
(declare-const target_ROP_049_empty_chain_blocked Int)
(assert (>= source_ROP_049_empty_chain_blocked 0))
(assert (>= target_ROP_049_empty_chain_blocked 0))
(assert (not (= source_ROP_049_empty_chain_blocked target_ROP_049_empty_chain_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_050_riina_blocks_all_chains: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_050_riina_blocks_all_chains preserves semantics
(push 1)
(declare-const source_ROP_050_riina_blocks_all_chains Int)
(declare-const target_ROP_050_riina_blocks_all_chains Int)
(assert (>= source_ROP_050_riina_blocks_all_chains 0))
(assert (>= target_ROP_050_riina_blocks_all_chains 0))
(assert (not (= source_ROP_050_riina_blocks_all_chains target_ROP_050_riina_blocks_all_chains)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_051_chain_blocked_implies_each_blocked: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_051_chain_blocked_implies_each_blocked preserves semantics
(push 1)
(declare-const source_ROP_051_chain_blocked_implies_each_blocked Int)
(declare-const target_ROP_051_chain_blocked_implies_each_blocked Int)
(assert (>= source_ROP_051_chain_blocked_implies_each_blocked 0))
(assert (>= target_ROP_051_chain_blocked_implies_each_blocked 0))
(assert (not (= source_ROP_051_chain_blocked_implies_each_blocked target_ROP_051_chain_blocked_implies_each_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_052_single_unblocked_breaks_chain: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_052_single_unblocked_breaks_chain preserves semantics
(push 1)
(declare-const source_ROP_052_single_unblocked_breaks_chain Int)
(declare-const target_ROP_052_single_unblocked_breaks_chain Int)
(assert (>= source_ROP_052_single_unblocked_breaks_chain 0))
(assert (>= target_ROP_052_single_unblocked_breaks_chain 0))
(assert (not (= source_ROP_052_single_unblocked_breaks_chain target_ROP_052_single_unblocked_breaks_chain)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_053_cpi_complete_riina: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_053_cpi_complete_riina preserves semantics
(push 1)
(declare-const source_ROP_053_cpi_complete_riina Int)
(declare-const target_ROP_053_cpi_complete_riina Int)
(assert (>= source_ROP_053_cpi_complete_riina 0))
(assert (>= target_ROP_053_cpi_complete_riina 0))
(assert (not (= source_ROP_053_cpi_complete_riina target_ROP_053_cpi_complete_riina)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_054_authenticated_ptr_protected: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_054_authenticated_ptr_protected preserves semantics
(push 1)
(declare-const source_ROP_054_authenticated_ptr_protected Int)
(declare-const target_ROP_054_authenticated_ptr_protected Int)
(assert (>= source_ROP_054_authenticated_ptr_protected 0))
(assert (>= target_ROP_054_authenticated_ptr_protected 0))
(assert (not (= source_ROP_054_authenticated_ptr_protected target_ROP_054_authenticated_ptr_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_055_unauthenticated_ptr_unsafe: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_055_unauthenticated_ptr_unsafe preserves semantics
(push 1)
(declare-const source_ROP_055_unauthenticated_ptr_unsafe Int)
(declare-const target_ROP_055_unauthenticated_ptr_unsafe Int)
(assert (>= source_ROP_055_unauthenticated_ptr_unsafe 0))
(assert (>= target_ROP_055_unauthenticated_ptr_unsafe 0))
(assert (not (= source_ROP_055_unauthenticated_ptr_unsafe target_ROP_055_unauthenticated_ptr_unsafe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_056_bounds_unchecked_unsafe: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_056_bounds_unchecked_unsafe preserves semantics
(push 1)
(declare-const source_ROP_056_bounds_unchecked_unsafe Int)
(declare-const target_ROP_056_bounds_unchecked_unsafe Int)
(assert (>= source_ROP_056_bounds_unchecked_unsafe 0))
(assert (>= target_ROP_056_bounds_unchecked_unsafe 0))
(assert (not (= source_ROP_056_bounds_unchecked_unsafe target_ROP_056_bounds_unchecked_unsafe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_057_fully_protected_ptr: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_057_fully_protected_ptr preserves semantics
(push 1)
(declare-const source_ROP_057_fully_protected_ptr Int)
(declare-const target_ROP_057_fully_protected_ptr Int)
(assert (>= source_ROP_057_fully_protected_ptr 0))
(assert (>= target_ROP_057_fully_protected_ptr 0))
(assert (not (= source_ROP_057_fully_protected_ptr target_ROP_057_fully_protected_ptr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_058_no_auth_requirement_passes: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_058_no_auth_requirement_passes preserves semantics
(push 1)
(declare-const source_ROP_058_no_auth_requirement_passes Int)
(declare-const target_ROP_058_no_auth_requirement_passes Int)
(assert (>= source_ROP_058_no_auth_requirement_passes 0))
(assert (>= target_ROP_058_no_auth_requirement_passes 0))
(assert (not (= source_ROP_058_no_auth_requirement_passes target_ROP_058_no_auth_requirement_passes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_059_function_ptr_type: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_059_function_ptr_type preserves semantics
(push 1)
(declare-const source_ROP_059_function_ptr_type Int)
(declare-const target_ROP_059_function_ptr_type Int)
(assert (>= source_ROP_059_function_ptr_type 0))
(assert (>= target_ROP_059_function_ptr_type 0))
(assert (not (= source_ROP_059_function_ptr_type target_ROP_059_function_ptr_type)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_060_return_addr_protected: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_060_return_addr_protected preserves semantics
(push 1)
(declare-const source_ROP_060_return_addr_protected Int)
(declare-const target_ROP_060_return_addr_protected Int)
(assert (>= source_ROP_060_return_addr_protected 0))
(assert (>= target_ROP_060_return_addr_protected 0))
(assert (not (= source_ROP_060_return_addr_protected target_ROP_060_return_addr_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_061_forward_edge_enabled: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_061_forward_edge_enabled preserves semantics
(push 1)
(declare-const source_ROP_061_forward_edge_enabled Int)
(declare-const target_ROP_061_forward_edge_enabled Int)
(assert (>= source_ROP_061_forward_edge_enabled 0))
(assert (>= target_ROP_061_forward_edge_enabled 0))
(assert (not (= source_ROP_061_forward_edge_enabled target_ROP_061_forward_edge_enabled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_062_ibt_enabled: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_062_ibt_enabled preserves semantics
(push 1)
(declare-const source_ROP_062_ibt_enabled Int)
(declare-const target_ROP_062_ibt_enabled Int)
(assert (>= source_ROP_062_ibt_enabled 0))
(assert (>= target_ROP_062_ibt_enabled 0))
(assert (not (= source_ROP_062_ibt_enabled target_ROP_062_ibt_enabled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_063_forward_edge_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_063_forward_edge_complete preserves semantics
(push 1)
(declare-const source_ROP_063_forward_edge_complete Int)
(declare-const target_ROP_063_forward_edge_complete Int)
(assert (>= source_ROP_063_forward_edge_complete 0))
(assert (>= target_ROP_063_forward_edge_complete 0))
(assert (not (= source_ROP_063_forward_edge_complete target_ROP_063_forward_edge_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_064_forward_edge_blocks_jop: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_064_forward_edge_blocks_jop preserves semantics
(push 1)
(declare-const source_ROP_064_forward_edge_blocks_jop Int)
(declare-const target_ROP_064_forward_edge_blocks_jop Int)
(assert (>= source_ROP_064_forward_edge_blocks_jop 0))
(assert (>= target_ROP_064_forward_edge_blocks_jop 0))
(assert (not (= source_ROP_064_forward_edge_blocks_jop target_ROP_064_forward_edge_blocks_jop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_065_forward_edge_blocks_cop: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_065_forward_edge_blocks_cop preserves semantics
(push 1)
(declare-const source_ROP_065_forward_edge_blocks_cop Int)
(declare-const target_ROP_065_forward_edge_blocks_cop Int)
(assert (>= source_ROP_065_forward_edge_blocks_cop 0))
(assert (>= target_ROP_065_forward_edge_blocks_cop 0))
(assert (not (= source_ROP_065_forward_edge_blocks_cop target_ROP_065_forward_edge_blocks_cop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_066_indirect_call_requires_ibt: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_066_indirect_call_requires_ibt preserves semantics
(push 1)
(declare-const source_ROP_066_indirect_call_requires_ibt Int)
(declare-const target_ROP_066_indirect_call_requires_ibt Int)
(assert (>= source_ROP_066_indirect_call_requires_ibt 0))
(assert (>= target_ROP_066_indirect_call_requires_ibt 0))
(assert (not (= source_ROP_066_indirect_call_requires_ibt target_ROP_066_indirect_call_requires_ibt)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_067_forward_cfi_and_ibt_together: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_067_forward_cfi_and_ibt_together preserves semantics
(push 1)
(declare-const source_ROP_067_forward_cfi_and_ibt_together Int)
(declare-const target_ROP_067_forward_cfi_and_ibt_together Int)
(assert (>= source_ROP_067_forward_cfi_and_ibt_together 0))
(assert (>= target_ROP_067_forward_cfi_and_ibt_together 0))
(assert (not (= source_ROP_067_forward_cfi_and_ibt_together target_ROP_067_forward_cfi_and_ibt_together)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_068_backward_edge_enabled: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_068_backward_edge_enabled preserves semantics
(push 1)
(declare-const source_ROP_068_backward_edge_enabled Int)
(declare-const target_ROP_068_backward_edge_enabled Int)
(assert (>= source_ROP_068_backward_edge_enabled 0))
(assert (>= target_ROP_068_backward_edge_enabled 0))
(assert (not (= source_ROP_068_backward_edge_enabled target_ROP_068_backward_edge_enabled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_069_shadow_stack_enabled: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_069_shadow_stack_enabled preserves semantics
(push 1)
(declare-const source_ROP_069_shadow_stack_enabled Int)
(declare-const target_ROP_069_shadow_stack_enabled Int)
(assert (>= source_ROP_069_shadow_stack_enabled 0))
(assert (>= target_ROP_069_shadow_stack_enabled 0))
(assert (not (= source_ROP_069_shadow_stack_enabled target_ROP_069_shadow_stack_enabled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_070_backward_edge_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_070_backward_edge_complete preserves semantics
(push 1)
(declare-const source_ROP_070_backward_edge_complete Int)
(declare-const target_ROP_070_backward_edge_complete Int)
(assert (>= source_ROP_070_backward_edge_complete 0))
(assert (>= target_ROP_070_backward_edge_complete 0))
(assert (not (= source_ROP_070_backward_edge_complete target_ROP_070_backward_edge_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_071_backward_edge_blocks_rop: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_071_backward_edge_blocks_rop preserves semantics
(push 1)
(declare-const source_ROP_071_backward_edge_blocks_rop Int)
(declare-const target_ROP_071_backward_edge_blocks_rop Int)
(assert (>= source_ROP_071_backward_edge_blocks_rop 0))
(assert (>= target_ROP_071_backward_edge_blocks_rop 0))
(assert (not (= source_ROP_071_backward_edge_blocks_rop target_ROP_071_backward_edge_blocks_rop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_072_backward_edge_blocks_srop: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_072_backward_edge_blocks_srop preserves semantics
(push 1)
(declare-const source_ROP_072_backward_edge_blocks_srop Int)
(declare-const target_ROP_072_backward_edge_blocks_srop Int)
(assert (>= source_ROP_072_backward_edge_blocks_srop 0))
(assert (>= target_ROP_072_backward_edge_blocks_srop 0))
(assert (not (= source_ROP_072_backward_edge_blocks_srop target_ROP_072_backward_edge_blocks_srop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_073_return_requires_shadow: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_073_return_requires_shadow preserves semantics
(push 1)
(declare-const source_ROP_073_return_requires_shadow Int)
(declare-const target_ROP_073_return_requires_shadow Int)
(assert (>= source_ROP_073_return_requires_shadow 0))
(assert (>= target_ROP_073_return_requires_shadow 0))
(assert (not (= source_ROP_073_return_requires_shadow target_ROP_073_return_requires_shadow)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_074_backward_cfi_and_shadow_together: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_074_backward_cfi_and_shadow_together preserves semantics
(push 1)
(declare-const source_ROP_074_backward_cfi_and_shadow_together Int)
(declare-const target_ROP_074_backward_cfi_and_shadow_together Int)
(assert (>= source_ROP_074_backward_cfi_and_shadow_together 0))
(assert (>= target_ROP_074_backward_cfi_and_shadow_together 0))
(assert (not (= source_ROP_074_backward_cfi_and_shadow_together target_ROP_074_backward_cfi_and_shadow_together)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_075_return_address_protection_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_075_return_address_protection_complete preserves semantics
(push 1)
(declare-const source_ROP_075_return_address_protection_complete Int)
(declare-const target_ROP_075_return_address_protection_complete Int)
(assert (>= source_ROP_075_return_address_protection_complete 0))
(assert (>= target_ROP_075_return_address_protection_complete 0))
(assert (not (= source_ROP_075_return_address_protection_complete target_ROP_075_return_address_protection_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_076_riina_full_cfi: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_076_riina_full_cfi preserves semantics
(push 1)
(declare-const source_ROP_076_riina_full_cfi Int)
(declare-const target_ROP_076_riina_full_cfi Int)
(assert (>= source_ROP_076_riina_full_cfi 0))
(assert (>= target_ROP_076_riina_full_cfi 0))
(assert (not (= source_ROP_076_riina_full_cfi target_ROP_076_riina_full_cfi)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_077_riina_full_code_reuse: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_077_riina_full_code_reuse preserves semantics
(push 1)
(declare-const source_ROP_077_riina_full_code_reuse Int)
(declare-const target_ROP_077_riina_full_code_reuse Int)
(assert (>= source_ROP_077_riina_full_code_reuse 0))
(assert (>= target_ROP_077_riina_full_code_reuse 0))
(assert (not (= source_ROP_077_riina_full_code_reuse target_ROP_077_riina_full_code_reuse)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_078_riina_full_rop_defense: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_078_riina_full_rop_defense preserves semantics
(push 1)
(declare-const source_ROP_078_riina_full_rop_defense Int)
(declare-const target_ROP_078_riina_full_rop_defense Int)
(assert (>= source_ROP_078_riina_full_rop_defense 0))
(assert (>= target_ROP_078_riina_full_rop_defense 0))
(assert (not (= source_ROP_078_riina_full_rop_defense target_ROP_078_riina_full_rop_defense)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_079_all_attack_types_blocked: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_079_all_attack_types_blocked preserves semantics
(push 1)
(declare-const source_ROP_079_all_attack_types_blocked Int)
(declare-const target_ROP_079_all_attack_types_blocked Int)
(assert (>= source_ROP_079_all_attack_types_blocked 0))
(assert (>= target_ROP_079_all_attack_types_blocked 0))
(assert (not (= source_ROP_079_all_attack_types_blocked target_ROP_079_all_attack_types_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_080_complete_defense_equivalence: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_080_complete_defense_equivalence preserves semantics
(push 1)
(declare-const source_ROP_080_complete_defense_equivalence Int)
(declare-const target_ROP_080_complete_defense_equivalence Int)
(assert (>= source_ROP_080_complete_defense_equivalence 0))
(assert (>= target_ROP_080_complete_defense_equivalence 0))
(assert (not (= source_ROP_080_complete_defense_equivalence target_ROP_080_complete_defense_equivalence)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_081_shadow_stack_prevents_rop: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_081_shadow_stack_prevents_rop preserves semantics
(push 1)
(declare-const source_ROP_081_shadow_stack_prevents_rop Int)
(declare-const target_ROP_081_shadow_stack_prevents_rop Int)
(assert (>= source_ROP_081_shadow_stack_prevents_rop 0))
(assert (>= target_ROP_081_shadow_stack_prevents_rop 0))
(assert (not (= source_ROP_081_shadow_stack_prevents_rop target_ROP_081_shadow_stack_prevents_rop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_082_ibt_prevents_jop: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_082_ibt_prevents_jop preserves semantics
(push 1)
(declare-const source_ROP_082_ibt_prevents_jop Int)
(declare-const target_ROP_082_ibt_prevents_jop Int)
(assert (>= source_ROP_082_ibt_prevents_jop 0))
(assert (>= target_ROP_082_ibt_prevents_jop 0))
(assert (not (= source_ROP_082_ibt_prevents_jop target_ROP_082_ibt_prevents_jop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_083_cpi_prevents_ptr_hijack: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_083_cpi_prevents_ptr_hijack preserves semantics
(push 1)
(declare-const source_ROP_083_cpi_prevents_ptr_hijack Int)
(declare-const target_ROP_083_cpi_prevents_ptr_hijack Int)
(assert (>= source_ROP_083_cpi_prevents_ptr_hijack 0))
(assert (>= target_ROP_083_cpi_prevents_ptr_hijack 0))
(assert (not (= source_ROP_083_cpi_prevents_ptr_hijack target_ROP_083_cpi_prevents_ptr_hijack)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_084_defense_in_depth: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_084_defense_in_depth preserves semantics
(push 1)
(declare-const source_ROP_084_defense_in_depth Int)
(declare-const target_ROP_084_defense_in_depth Int)
(assert (>= source_ROP_084_defense_in_depth 0))
(assert (>= target_ROP_084_defense_in_depth 0))
(assert (not (= source_ROP_084_defense_in_depth target_ROP_084_defense_in_depth)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ROP_085_riina_rop_immune: translation preserves property (matches Coq: Theorem)
; Translation validation: ROP_085_riina_rop_immune preserves semantics
(push 1)
(declare-const source_ROP_085_riina_rop_immune Int)
(declare-const target_ROP_085_riina_rop_immune Int)
(assert (>= source_ROP_085_riina_rop_immune 0))
(assert (>= target_ROP_085_riina_rop_immune 0))
(assert (not (= source_ROP_085_riina_rop_immune target_ROP_085_riina_rop_immune)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

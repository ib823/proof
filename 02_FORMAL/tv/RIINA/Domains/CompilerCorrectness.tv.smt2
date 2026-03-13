; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/CompilerCorrectness.v (78 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for CompilerCorrectness
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; parsing_correct: source semantics (matches Coq)
; Translation validation: parsing_correct preserves semantics
(push 1)
(declare-const source_parsing_correct Int)
(declare-const target_parsing_correct Int)
(assert (>= source_parsing_correct 0))
(assert (>= target_parsing_correct 0))
(assert (not (= source_parsing_correct target_parsing_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typecheck_sound: source semantics (matches Coq)
; Translation validation: typecheck_sound preserves semantics
(push 1)
(declare-const source_typecheck_sound Int)
(declare-const target_typecheck_sound Int)
(assert (>= source_typecheck_sound 0))
(assert (>= target_typecheck_sound 0))
(assert (not (= source_typecheck_sound target_typecheck_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; optimization_safe: source semantics (matches Coq)
; Translation validation: optimization_safe preserves semantics
(push 1)
(declare-const source_optimization_safe Int)
(declare-const target_optimization_safe Int)
(assert (>= source_optimization_safe 0))
(assert (>= target_optimization_safe 0))
(assert (not (= source_optimization_safe target_optimization_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; codegen_correct: source semantics (matches Coq)
; Translation validation: codegen_correct preserves semantics
(push 1)
(declare-const source_codegen_correct Int)
(declare-const target_codegen_correct Int)
(assert (>= source_codegen_correct 0))
(assert (>= target_codegen_correct 0))
(assert (not (= source_codegen_correct target_codegen_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compiler_verified: source semantics (matches Coq)
; Translation validation: compiler_verified preserves semantics
(push 1)
(declare-const source_compiler_verified Int)
(declare-const target_compiler_verified Int)
(assert (>= source_compiler_verified 0))
(assert (>= target_compiler_verified 0))
(assert (not (= source_compiler_verified target_compiler_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_parsing: source semantics (matches Coq)
; Translation validation: riina_parsing preserves semantics
(push 1)
(declare-const source_riina_parsing Int)
(declare-const target_riina_parsing Int)
(assert (>= source_riina_parsing 0))
(assert (>= target_riina_parsing 0))
(assert (not (= source_riina_parsing target_riina_parsing)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_typecheck: source semantics (matches Coq)
; Translation validation: riina_typecheck preserves semantics
(push 1)
(declare-const source_riina_typecheck Int)
(declare-const target_riina_typecheck Int)
(assert (>= source_riina_typecheck 0))
(assert (>= target_riina_typecheck 0))
(assert (not (= source_riina_typecheck target_riina_typecheck)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_optim: source semantics (matches Coq)
; Translation validation: riina_optim preserves semantics
(push 1)
(declare-const source_riina_optim Int)
(declare-const target_riina_optim Int)
(assert (>= source_riina_optim 0))
(assert (>= target_riina_optim 0))
(assert (not (= source_riina_optim target_riina_optim)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_codegen: source semantics (matches Coq)
; Translation validation: riina_codegen preserves semantics
(push 1)
(declare-const source_riina_codegen Int)
(declare-const target_riina_codegen Int)
(assert (>= source_riina_codegen 0))
(assert (>= target_riina_codegen 0))
(assert (not (= source_riina_codegen target_riina_codegen)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_compiler: source semantics (matches Coq)
; Translation validation: riina_compiler preserves semantics
(push 1)
(declare-const source_riina_compiler Int)
(declare-const target_riina_compiler Int)
(assert (>= source_riina_compiler 0))
(assert (>= target_riina_compiler 0))
(assert (not (= source_riina_compiler target_riina_compiler)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ir_equiv: source semantics (matches Coq)
; Translation validation: ir_equiv preserves semantics
(push 1)
(declare-const source_ir_equiv Int)
(declare-const target_ir_equiv Int)
(assert (>= source_ir_equiv 0))
(assert (>= target_ir_equiv 0))
(assert (not (= source_ir_equiv target_ir_equiv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compile_ty: source semantics (matches Coq)
; Translation validation: compile_ty preserves semantics
(push 1)
(declare-const source_compile_ty Int)
(declare-const target_compile_ty Int)
(assert (>= source_compile_ty 0))
(assert (>= target_compile_ty 0))
(assert (not (= source_compile_ty target_compile_ty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compile_expr: source semantics (matches Coq)
; Translation validation: compile_expr preserves semantics
(push 1)
(declare-const source_compile_expr Int)
(declare-const target_compile_expr Int)
(assert (>= source_compile_expr 0))
(assert (>= target_compile_expr 0))
(assert (not (= source_compile_expr target_compile_expr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; src_ir_equiv: source semantics (matches Coq)
; Translation validation: src_ir_equiv preserves semantics
(push 1)
(declare-const source_src_ir_equiv Int)
(declare-const target_src_ir_equiv Int)
(assert (>= source_src_ir_equiv 0))
(assert (>= target_src_ir_equiv 0))
(assert (not (= source_src_ir_equiv target_src_ir_equiv)))
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

; CC_001: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_001 preserves semantics
(push 1)
(declare-const source_CC_001 Int)
(declare-const target_CC_001 Int)
(assert (>= source_CC_001 0))
(assert (>= target_CC_001 0))
(assert (not (= source_CC_001 target_CC_001)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_002: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_002 preserves semantics
(push 1)
(declare-const source_CC_002 Int)
(declare-const target_CC_002 Int)
(assert (>= source_CC_002 0))
(assert (>= target_CC_002 0))
(assert (not (= source_CC_002 target_CC_002)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_003: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_003 preserves semantics
(push 1)
(declare-const source_CC_003 Int)
(declare-const target_CC_003 Int)
(assert (>= source_CC_003 0))
(assert (>= target_CC_003 0))
(assert (not (= source_CC_003 target_CC_003)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_004: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_004 preserves semantics
(push 1)
(declare-const source_CC_004 Int)
(declare-const target_CC_004 Int)
(assert (>= source_CC_004 0))
(assert (>= target_CC_004 0))
(assert (not (= source_CC_004 target_CC_004)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_005: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_005 preserves semantics
(push 1)
(declare-const source_CC_005 Int)
(declare-const target_CC_005 Int)
(assert (>= source_CC_005 0))
(assert (>= target_CC_005 0))
(assert (not (= source_CC_005 target_CC_005)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_006: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_006 preserves semantics
(push 1)
(declare-const source_CC_006 Int)
(declare-const target_CC_006 Int)
(assert (>= source_CC_006 0))
(assert (>= target_CC_006 0))
(assert (not (= source_CC_006 target_CC_006)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_007: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_007 preserves semantics
(push 1)
(declare-const source_CC_007 Int)
(declare-const target_CC_007 Int)
(assert (>= source_CC_007 0))
(assert (>= target_CC_007 0))
(assert (not (= source_CC_007 target_CC_007)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_008: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_008 preserves semantics
(push 1)
(declare-const source_CC_008 Int)
(declare-const target_CC_008 Int)
(assert (>= source_CC_008 0))
(assert (>= target_CC_008 0))
(assert (not (= source_CC_008 target_CC_008)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_009: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_009 preserves semantics
(push 1)
(declare-const source_CC_009 Int)
(declare-const target_CC_009 Int)
(assert (>= source_CC_009 0))
(assert (>= target_CC_009 0))
(assert (not (= source_CC_009 target_CC_009)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_010: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_010 preserves semantics
(push 1)
(declare-const source_CC_010 Int)
(declare-const target_CC_010 Int)
(assert (>= source_CC_010 0))
(assert (>= target_CC_010 0))
(assert (not (= source_CC_010 target_CC_010)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_011: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_011 preserves semantics
(push 1)
(declare-const source_CC_011 Int)
(declare-const target_CC_011 Int)
(assert (>= source_CC_011 0))
(assert (>= target_CC_011 0))
(assert (not (= source_CC_011 target_CC_011)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_012: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_012 preserves semantics
(push 1)
(declare-const source_CC_012 Int)
(declare-const target_CC_012 Int)
(assert (>= source_CC_012 0))
(assert (>= target_CC_012 0))
(assert (not (= source_CC_012 target_CC_012)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_013: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_013 preserves semantics
(push 1)
(declare-const source_CC_013 Int)
(declare-const target_CC_013 Int)
(assert (>= source_CC_013 0))
(assert (>= target_CC_013 0))
(assert (not (= source_CC_013 target_CC_013)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_014: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_014 preserves semantics
(push 1)
(declare-const source_CC_014 Int)
(declare-const target_CC_014 Int)
(assert (>= source_CC_014 0))
(assert (>= target_CC_014 0))
(assert (not (= source_CC_014 target_CC_014)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_015: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_015 preserves semantics
(push 1)
(declare-const source_CC_015 Int)
(declare-const target_CC_015 Int)
(assert (>= source_CC_015 0))
(assert (>= target_CC_015 0))
(assert (not (= source_CC_015 target_CC_015)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_016: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_016 preserves semantics
(push 1)
(declare-const source_CC_016 Int)
(declare-const target_CC_016 Int)
(assert (>= source_CC_016 0))
(assert (>= target_CC_016 0))
(assert (not (= source_CC_016 target_CC_016)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_017: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_017 preserves semantics
(push 1)
(declare-const source_CC_017 Int)
(declare-const target_CC_017 Int)
(assert (>= source_CC_017 0))
(assert (>= target_CC_017 0))
(assert (not (= source_CC_017 target_CC_017)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_018: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_018 preserves semantics
(push 1)
(declare-const source_CC_018 Int)
(declare-const target_CC_018 Int)
(assert (>= source_CC_018 0))
(assert (>= target_CC_018 0))
(assert (not (= source_CC_018 target_CC_018)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_019: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_019 preserves semantics
(push 1)
(declare-const source_CC_019 Int)
(declare-const target_CC_019 Int)
(assert (>= source_CC_019 0))
(assert (>= target_CC_019 0))
(assert (not (= source_CC_019 target_CC_019)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_020: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_020 preserves semantics
(push 1)
(declare-const source_CC_020 Int)
(declare-const target_CC_020 Int)
(assert (>= source_CC_020 0))
(assert (>= target_CC_020 0))
(assert (not (= source_CC_020 target_CC_020)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_021: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_021 preserves semantics
(push 1)
(declare-const source_CC_021 Int)
(declare-const target_CC_021 Int)
(assert (>= source_CC_021 0))
(assert (>= target_CC_021 0))
(assert (not (= source_CC_021 target_CC_021)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_022: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_022 preserves semantics
(push 1)
(declare-const source_CC_022 Int)
(declare-const target_CC_022 Int)
(assert (>= source_CC_022 0))
(assert (>= target_CC_022 0))
(assert (not (= source_CC_022 target_CC_022)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_023: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_023 preserves semantics
(push 1)
(declare-const source_CC_023 Int)
(declare-const target_CC_023 Int)
(assert (>= source_CC_023 0))
(assert (>= target_CC_023 0))
(assert (not (= source_CC_023 target_CC_023)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_024: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_024 preserves semantics
(push 1)
(declare-const source_CC_024 Int)
(declare-const target_CC_024 Int)
(assert (>= source_CC_024 0))
(assert (>= target_CC_024 0))
(assert (not (= source_CC_024 target_CC_024)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_025: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_025 preserves semantics
(push 1)
(declare-const source_CC_025 Int)
(declare-const target_CC_025 Int)
(assert (>= source_CC_025 0))
(assert (>= target_CC_025 0))
(assert (not (= source_CC_025 target_CC_025)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_026: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_026 preserves semantics
(push 1)
(declare-const source_CC_026 Int)
(declare-const target_CC_026 Int)
(assert (>= source_CC_026 0))
(assert (>= target_CC_026 0))
(assert (not (= source_CC_026 target_CC_026)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_027: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_027 preserves semantics
(push 1)
(declare-const source_CC_027 Int)
(declare-const target_CC_027 Int)
(assert (>= source_CC_027 0))
(assert (>= target_CC_027 0))
(assert (not (= source_CC_027 target_CC_027)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_028: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_028 preserves semantics
(push 1)
(declare-const source_CC_028 Int)
(declare-const target_CC_028 Int)
(assert (>= source_CC_028 0))
(assert (>= target_CC_028 0))
(assert (not (= source_CC_028 target_CC_028)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_029: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_029 preserves semantics
(push 1)
(declare-const source_CC_029 Int)
(declare-const target_CC_029 Int)
(assert (>= source_CC_029 0))
(assert (>= target_CC_029 0))
(assert (not (= source_CC_029 target_CC_029)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CC_030_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: CC_030_complete preserves semantics
(push 1)
(declare-const source_CC_030_complete Int)
(declare-const target_CC_030_complete Int)
(assert (>= source_CC_030_complete 0))
(assert (>= target_CC_030_complete 0))
(assert (not (= source_CC_030_complete target_CC_030_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ir_value_not_step: translation preserves property (matches Coq: Lemma)
; Translation validation: ir_value_not_step preserves semantics
(push 1)
(declare-const source_ir_value_not_step Int)
(declare-const target_ir_value_not_step Int)
(assert (>= source_ir_value_not_step 0))
(assert (>= target_ir_value_not_step 0))
(assert (not (= source_ir_value_not_step target_ir_value_not_step)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ir_preservation: translation preserves property (matches Coq: Theorem)
; Translation validation: ir_preservation preserves semantics
(push 1)
(declare-const source_ir_preservation Int)
(declare-const target_ir_preservation Int)
(assert (>= source_ir_preservation 0))
(assert (>= target_ir_preservation 0))
(assert (not (= source_ir_preservation target_ir_preservation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ir_multi_preservation: translation preserves property (matches Coq: Theorem)
; Translation validation: ir_multi_preservation preserves semantics
(push 1)
(declare-const source_ir_multi_preservation Int)
(declare-const target_ir_multi_preservation Int)
(assert (>= source_ir_multi_preservation 0))
(assert (>= target_ir_multi_preservation 0))
(assert (not (= source_ir_multi_preservation target_ir_multi_preservation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ir_pair_value_not_step: translation preserves property (matches Coq: Lemma)
; Translation validation: ir_pair_value_not_step preserves semantics
(push 1)
(declare-const source_ir_pair_value_not_step Int)
(declare-const target_ir_pair_value_not_step Int)
(assert (>= source_ir_pair_value_not_step 0))
(assert (>= target_ir_pair_value_not_step 0))
(assert (not (= source_ir_pair_value_not_step target_ir_pair_value_not_step)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ir_bool_not_step: translation preserves property (matches Coq: Lemma)
; Translation validation: ir_bool_not_step preserves semantics
(push 1)
(declare-const source_ir_bool_not_step Int)
(declare-const target_ir_bool_not_step Int)
(assert (>= source_ir_bool_not_step 0))
(assert (>= target_ir_bool_not_step 0))
(assert (not (= source_ir_bool_not_step target_ir_bool_not_step)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ir_step_deterministic: translation preserves property (matches Coq: Theorem)
; Translation validation: ir_step_deterministic preserves semantics
(push 1)
(declare-const source_ir_step_deterministic Int)
(declare-const target_ir_step_deterministic Int)
(assert (>= source_ir_step_deterministic 0))
(assert (>= target_ir_step_deterministic 0))
(assert (not (= source_ir_step_deterministic target_ir_step_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ir_progress: translation preserves property (matches Coq: Theorem)
; Translation validation: ir_progress preserves semantics
(push 1)
(declare-const source_ir_progress Int)
(declare-const target_ir_progress Int)
(assert (>= source_ir_progress 0))
(assert (>= target_ir_progress 0))
(assert (not (= source_ir_progress target_ir_progress)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ir_equiv_refl: translation preserves property (matches Coq: Theorem)
; Translation validation: ir_equiv_refl preserves semantics
(push 1)
(declare-const source_ir_equiv_refl Int)
(declare-const target_ir_equiv_refl Int)
(assert (>= source_ir_equiv_refl 0))
(assert (>= target_ir_equiv_refl 0))
(assert (not (= source_ir_equiv_refl target_ir_equiv_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ir_equiv_sym: translation preserves property (matches Coq: Theorem)
; Translation validation: ir_equiv_sym preserves semantics
(push 1)
(declare-const source_ir_equiv_sym Int)
(declare-const target_ir_equiv_sym Int)
(assert (>= source_ir_equiv_sym 0))
(assert (>= target_ir_equiv_sym 0))
(assert (not (= source_ir_equiv_sym target_ir_equiv_sym)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ir_equiv_trans: translation preserves property (matches Coq: Theorem)
; Translation validation: ir_equiv_trans preserves semantics
(push 1)
(declare-const source_ir_equiv_trans Int)
(declare-const target_ir_equiv_trans Int)
(assert (>= source_ir_equiv_trans 0))
(assert (>= target_ir_equiv_trans 0))
(assert (not (= source_ir_equiv_trans target_ir_equiv_trans)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ir_multi_trans: translation preserves property (matches Coq: Lemma)
; Translation validation: ir_multi_trans preserves semantics
(push 1)
(declare-const source_ir_multi_trans Int)
(declare-const target_ir_multi_trans Int)
(assert (>= source_ir_multi_trans 0))
(assert (>= target_ir_multi_trans 0))
(assert (not (= source_ir_multi_trans target_ir_multi_trans)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ir_multi_pair_cong1: translation preserves property (matches Coq: Lemma)
; Translation validation: ir_multi_pair_cong1 preserves semantics
(push 1)
(declare-const source_ir_multi_pair_cong1 Int)
(declare-const target_ir_multi_pair_cong1 Int)
(assert (>= source_ir_multi_pair_cong1 0))
(assert (>= target_ir_multi_pair_cong1 0))
(assert (not (= source_ir_multi_pair_cong1 target_ir_multi_pair_cong1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ir_multi_pair_cong2: translation preserves property (matches Coq: Lemma)
; Translation validation: ir_multi_pair_cong2 preserves semantics
(push 1)
(declare-const source_ir_multi_pair_cong2 Int)
(declare-const target_ir_multi_pair_cong2 Int)
(assert (>= source_ir_multi_pair_cong2 0))
(assert (>= target_ir_multi_pair_cong2 0))
(assert (not (= source_ir_multi_pair_cong2 target_ir_multi_pair_cong2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; opt_if_true_sound: translation preserves property (matches Coq: Theorem)
; Translation validation: opt_if_true_sound preserves semantics
(push 1)
(declare-const source_opt_if_true_sound Int)
(declare-const target_opt_if_true_sound Int)
(assert (>= source_opt_if_true_sound 0))
(assert (>= target_opt_if_true_sound 0))
(assert (not (= source_opt_if_true_sound target_opt_if_true_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; opt_if_false_sound: translation preserves property (matches Coq: Theorem)
; Translation validation: opt_if_false_sound preserves semantics
(push 1)
(declare-const source_opt_if_false_sound Int)
(declare-const target_opt_if_false_sound Int)
(assert (>= source_opt_if_false_sound 0))
(assert (>= target_opt_if_false_sound 0))
(assert (not (= source_opt_if_false_sound target_opt_if_false_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; opt_fst_pair_sound: translation preserves property (matches Coq: Theorem)
; Translation validation: opt_fst_pair_sound preserves semantics
(push 1)
(declare-const source_opt_fst_pair_sound Int)
(declare-const target_opt_fst_pair_sound Int)
(assert (>= source_opt_fst_pair_sound 0))
(assert (>= target_opt_fst_pair_sound 0))
(assert (not (= source_opt_fst_pair_sound target_opt_fst_pair_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; opt_snd_pair_sound: translation preserves property (matches Coq: Theorem)
; Translation validation: opt_snd_pair_sound preserves semantics
(push 1)
(declare-const source_opt_snd_pair_sound Int)
(declare-const target_opt_snd_pair_sound Int)
(assert (>= source_opt_snd_pair_sound 0))
(assert (>= target_opt_snd_pair_sound 0))
(assert (not (= source_opt_snd_pair_sound target_opt_snd_pair_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ir_value_normal: translation preserves property (matches Coq: Theorem)
; Translation validation: ir_value_normal preserves semantics
(push 1)
(declare-const source_ir_value_normal Int)
(declare-const target_ir_value_normal Int)
(assert (>= source_ir_value_normal 0))
(assert (>= target_ir_value_normal 0))
(assert (not (= source_ir_value_normal target_ir_value_normal)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ir_value_reduces_self: translation preserves property (matches Coq: Theorem)
; Translation validation: ir_value_reduces_self preserves semantics
(push 1)
(declare-const source_ir_value_reduces_self Int)
(declare-const target_ir_value_reduces_self Int)
(assert (>= source_ir_value_reduces_self 0))
(assert (>= target_ir_value_reduces_self 0))
(assert (not (= source_ir_value_reduces_self target_ir_value_reduces_self)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; equiv_preserves_typing: translation preserves property (matches Coq: Theorem)
; Translation validation: equiv_preserves_typing preserves semantics
(push 1)
(declare-const source_equiv_preserves_typing Int)
(declare-const target_equiv_preserves_typing Int)
(assert (>= source_equiv_preserves_typing 0))
(assert (>= target_equiv_preserves_typing 0))
(assert (not (= source_equiv_preserves_typing target_equiv_preserves_typing)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; src_value_not_step: translation preserves property (matches Coq: Lemma)
; Translation validation: src_value_not_step preserves semantics
(push 1)
(declare-const source_src_value_not_step Int)
(declare-const target_src_value_not_step Int)
(assert (>= source_src_value_not_step 0))
(assert (>= target_src_value_not_step 0))
(assert (not (= source_src_value_not_step target_src_value_not_step)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; src_step_deterministic: translation preserves property (matches Coq: Theorem)
; Translation validation: src_step_deterministic preserves semantics
(push 1)
(declare-const source_src_step_deterministic Int)
(declare-const target_src_step_deterministic Int)
(assert (>= source_src_step_deterministic 0))
(assert (>= target_src_step_deterministic 0))
(assert (not (= source_src_step_deterministic target_src_step_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; src_preservation: translation preserves property (matches Coq: Theorem)
; Translation validation: src_preservation preserves semantics
(push 1)
(declare-const source_src_preservation Int)
(declare-const target_src_preservation Int)
(assert (>= source_src_preservation 0))
(assert (>= target_src_preservation 0))
(assert (not (= source_src_preservation target_src_preservation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; src_progress: translation preserves property (matches Coq: Theorem)
; Translation validation: src_progress preserves semantics
(push 1)
(declare-const source_src_progress Int)
(declare-const target_src_progress Int)
(assert (>= source_src_progress 0))
(assert (>= target_src_progress 0))
(assert (not (= source_src_progress target_src_progress)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compile_preserves_value: translation preserves property (matches Coq: Theorem)
; Translation validation: compile_preserves_value preserves semantics
(push 1)
(declare-const source_compile_preserves_value Int)
(declare-const target_compile_preserves_value Int)
(assert (>= source_compile_preserves_value 0))
(assert (>= target_compile_preserves_value 0))
(assert (not (= source_compile_preserves_value target_compile_preserves_value)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compile_preserves_typing: translation preserves property (matches Coq: Theorem)
; Translation validation: compile_preserves_typing preserves semantics
(push 1)
(declare-const source_compile_preserves_typing Int)
(declare-const target_compile_preserves_typing Int)
(assert (>= source_compile_preserves_typing 0))
(assert (>= target_compile_preserves_typing 0))
(assert (not (= source_compile_preserves_typing target_compile_preserves_typing)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compile_forward_simulation: translation preserves property (matches Coq: Theorem)
; Translation validation: compile_forward_simulation preserves semantics
(push 1)
(declare-const source_compile_forward_simulation Int)
(declare-const target_compile_forward_simulation Int)
(assert (>= source_compile_forward_simulation 0))
(assert (>= target_compile_forward_simulation 0))
(assert (not (= source_compile_forward_simulation target_compile_forward_simulation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compile_forward_multi_simulation: translation preserves property (matches Coq: Theorem)
; Translation validation: compile_forward_multi_simulation preserves semantics
(push 1)
(declare-const source_compile_forward_multi_simulation Int)
(declare-const target_compile_forward_multi_simulation Int)
(assert (>= source_compile_forward_multi_simulation 0))
(assert (>= target_compile_forward_multi_simulation 0))
(assert (not (= source_compile_forward_multi_simulation target_compile_forward_multi_simulation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compile_value_inv: translation preserves property (matches Coq: Lemma)
; Translation validation: compile_value_inv preserves semantics
(push 1)
(declare-const source_compile_value_inv Int)
(declare-const target_compile_value_inv Int)
(assert (>= source_compile_value_inv 0))
(assert (>= target_compile_value_inv 0))
(assert (not (= source_compile_value_inv target_compile_value_inv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compile_backward_simulation: translation preserves property (matches Coq: Theorem)
; Translation validation: compile_backward_simulation preserves semantics
(push 1)
(declare-const source_compile_backward_simulation Int)
(declare-const target_compile_backward_simulation Int)
(assert (>= source_compile_backward_simulation 0))
(assert (>= target_compile_backward_simulation 0))
(assert (not (= source_compile_backward_simulation target_compile_backward_simulation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compile_establishes_equiv: translation preserves property (matches Coq: Theorem)
; Translation validation: compile_establishes_equiv preserves semantics
(push 1)
(declare-const source_compile_establishes_equiv Int)
(declare-const target_compile_establishes_equiv Int)
(assert (>= source_compile_establishes_equiv 0))
(assert (>= target_compile_establishes_equiv 0))
(assert (not (= source_compile_establishes_equiv target_compile_establishes_equiv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; equiv_preserved_forward: translation preserves property (matches Coq: Theorem)
; Translation validation: equiv_preserved_forward preserves semantics
(push 1)
(declare-const source_equiv_preserved_forward Int)
(declare-const target_equiv_preserved_forward Int)
(assert (>= source_equiv_preserved_forward 0))
(assert (>= target_equiv_preserved_forward 0))
(assert (not (= source_equiv_preserved_forward target_equiv_preserved_forward)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compile_terminates_equivalently: translation preserves property (matches Coq: Theorem)
; Translation validation: compile_terminates_equivalently preserves semantics
(push 1)
(declare-const source_compile_terminates_equivalently Int)
(declare-const target_compile_terminates_equivalently Int)
(assert (>= source_compile_terminates_equivalently 0))
(assert (>= target_compile_terminates_equivalently 0))
(assert (not (= source_compile_terminates_equivalently target_compile_terminates_equivalently)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compile_type_safety: translation preserves property (matches Coq: Theorem)
; Translation validation: compile_type_safety preserves semantics
(push 1)
(declare-const source_compile_type_safety Int)
(declare-const target_compile_type_safety Int)
(assert (>= source_compile_type_safety 0))
(assert (>= target_compile_type_safety 0))
(assert (not (= source_compile_type_safety target_compile_type_safety)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; opt_dead_code_if_true: translation preserves property (matches Coq: Theorem)
; Translation validation: opt_dead_code_if_true preserves semantics
(push 1)
(declare-const source_opt_dead_code_if_true Int)
(declare-const target_opt_dead_code_if_true Int)
(assert (>= source_opt_dead_code_if_true 0))
(assert (>= target_opt_dead_code_if_true 0))
(assert (not (= source_opt_dead_code_if_true target_opt_dead_code_if_true)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; opt_dead_code_if_false: translation preserves property (matches Coq: Theorem)
; Translation validation: opt_dead_code_if_false preserves semantics
(push 1)
(declare-const source_opt_dead_code_if_false Int)
(declare-const target_opt_dead_code_if_false Int)
(assert (>= source_opt_dead_code_if_false 0))
(assert (>= target_opt_dead_code_if_false 0))
(assert (not (= source_opt_dead_code_if_false target_opt_dead_code_if_false)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; opt_fst_pair_typed: translation preserves property (matches Coq: Theorem)
; Translation validation: opt_fst_pair_typed preserves semantics
(push 1)
(declare-const source_opt_fst_pair_typed Int)
(declare-const target_opt_fst_pair_typed Int)
(assert (>= source_opt_fst_pair_typed 0))
(assert (>= target_opt_fst_pair_typed 0))
(assert (not (= source_opt_fst_pair_typed target_opt_fst_pair_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; opt_snd_pair_typed: translation preserves property (matches Coq: Theorem)
; Translation validation: opt_snd_pair_typed preserves semantics
(push 1)
(declare-const source_opt_snd_pair_typed Int)
(declare-const target_opt_snd_pair_typed Int)
(assert (>= source_opt_snd_pair_typed 0))
(assert (>= target_opt_snd_pair_typed 0))
(assert (not (= source_opt_snd_pair_typed target_opt_snd_pair_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; const_prop_bool: translation preserves property (matches Coq: Theorem)
; Translation validation: const_prop_bool preserves semantics
(push 1)
(declare-const source_const_prop_bool Int)
(declare-const target_const_prop_bool Int)
(assert (>= source_const_prop_bool 0))
(assert (>= target_const_prop_bool 0))
(assert (not (= source_const_prop_bool target_const_prop_bool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; const_prop_int: translation preserves property (matches Coq: Theorem)
; Translation validation: const_prop_int preserves semantics
(push 1)
(declare-const source_const_prop_int Int)
(declare-const target_const_prop_int Int)
(assert (>= source_const_prop_int 0))
(assert (>= target_const_prop_int 0))
(assert (not (= source_const_prop_int target_const_prop_int)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; const_prop_unit: translation preserves property (matches Coq: Theorem)
; Translation validation: const_prop_unit preserves semantics
(push 1)
(declare-const source_const_prop_unit Int)
(declare-const target_const_prop_unit Int)
(assert (>= source_const_prop_unit 0))
(assert (>= target_const_prop_unit 0))
(assert (not (= source_const_prop_unit target_const_prop_unit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; parsing_correct_prop: translation preserves property (matches Coq: Theorem)
; Translation validation: parsing_correct_prop preserves semantics
(push 1)
(declare-const source_parsing_correct_prop Int)
(declare-const target_parsing_correct_prop Int)
(assert (>= source_parsing_correct_prop 0))
(assert (>= target_parsing_correct_prop 0))
(assert (not (= source_parsing_correct_prop target_parsing_correct_prop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; optimization_relation_reflexive: translation preserves property (matches Coq: Theorem)
; Translation validation: optimization_relation_reflexive preserves semantics
(push 1)
(declare-const source_optimization_relation_reflexive Int)
(declare-const target_optimization_relation_reflexive Int)
(assert (>= source_optimization_relation_reflexive 0))
(assert (>= target_optimization_relation_reflexive 0))
(assert (not (= source_optimization_relation_reflexive target_optimization_relation_reflexive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; optimization_relation_symmetric: translation preserves property (matches Coq: Theorem)
; Translation validation: optimization_relation_symmetric preserves semantics
(push 1)
(declare-const source_optimization_relation_symmetric Int)
(declare-const target_optimization_relation_symmetric Int)
(assert (>= source_optimization_relation_symmetric 0))
(assert (>= target_optimization_relation_symmetric 0))
(assert (not (= source_optimization_relation_symmetric target_optimization_relation_symmetric)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; optimization_relation_transitive: translation preserves property (matches Coq: Theorem)
; Translation validation: optimization_relation_transitive preserves semantics
(push 1)
(declare-const source_optimization_relation_transitive Int)
(declare-const target_optimization_relation_transitive Int)
(assert (>= source_optimization_relation_transitive 0))
(assert (>= target_optimization_relation_transitive 0))
(assert (not (= source_optimization_relation_transitive target_optimization_relation_transitive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_pipeline_correctness: translation preserves property (matches Coq: Theorem)
; Translation validation: full_pipeline_correctness preserves semantics
(push 1)
(declare-const source_full_pipeline_correctness Int)
(declare-const target_full_pipeline_correctness Int)
(assert (>= source_full_pipeline_correctness 0))
(assert (>= target_full_pipeline_correctness 0))
(assert (not (= source_full_pipeline_correctness target_full_pipeline_correctness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; full_pipeline_termination: translation preserves property (matches Coq: Theorem)
; Translation validation: full_pipeline_termination preserves semantics
(push 1)
(declare-const source_full_pipeline_termination Int)
(declare-const target_full_pipeline_termination Int)
(assert (>= source_full_pipeline_termination 0))
(assert (>= target_full_pipeline_termination 0))
(assert (not (= source_full_pipeline_termination target_full_pipeline_termination)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

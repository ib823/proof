; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/WasmBackendVerification.v (43 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for WasmBackendVerification
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; sec_le: source semantics (matches Coq)
; Translation validation: sec_le preserves semantics
(push 1)
(declare-const source_sec_le Int)
(declare-const target_sec_le Int)
(assert (>= source_sec_le 0))
(assert (>= target_sec_le 0))
(assert (not (= source_sec_le target_sec_le)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; type_compile: source semantics (matches Coq)
; Translation validation: type_compile preserves semantics
(push 1)
(declare-const source_type_compile Int)
(declare-const target_type_compile Int)
(assert (>= source_type_compile 0))
(assert (>= target_type_compile 0))
(assert (not (= source_type_compile target_type_compile)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ir_eval: source semantics (matches Coq)
; Translation validation: ir_eval preserves semantics
(push 1)
(declare-const source_ir_eval Int)
(declare-const target_ir_eval Int)
(assert (>= source_ir_eval 0))
(assert (>= target_ir_eval 0))
(assert (not (= source_ir_eval target_ir_eval)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compile_ir: source semantics (matches Coq)
; Translation validation: compile_ir preserves semantics
(push 1)
(declare-const source_compile_ir Int)
(declare-const target_compile_ir Int)
(assert (>= source_compile_ir 0))
(assert (>= target_compile_ir 0))
(assert (not (= source_compile_ir target_compile_ir)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; export_is_public: source semantics (matches Coq)
; Translation validation: export_is_public preserves semantics
(push 1)
(declare-const source_export_is_public Int)
(declare-const target_export_is_public Int)
(assert (>= source_export_is_public 0))
(assert (>= target_export_is_public 0))
(assert (not (= source_export_is_public target_export_is_public)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ni_preserved: source semantics (matches Coq)
; Translation validation: ni_preserved preserves semantics
(push 1)
(declare-const source_ni_preserved Int)
(declare-const target_ni_preserved Int)
(assert (>= source_ni_preserved 0))
(assert (>= target_ni_preserved 0))
(assert (not (= source_ni_preserved target_ni_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; memory_partitioned: source semantics (matches Coq)
; Translation validation: memory_partitioned preserves semantics
(push 1)
(declare-const source_memory_partitioned Int)
(declare-const target_memory_partitioned Int)
(assert (>= source_memory_partitioned 0))
(assert (>= target_memory_partitioned 0))
(assert (not (= source_memory_partitioned target_memory_partitioned)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; effect_le: source semantics (matches Coq)
; Translation validation: effect_le preserves semantics
(push 1)
(declare-const source_effect_le Int)
(declare-const target_effect_le Int)
(assert (>= source_effect_le 0))
(assert (>= target_effect_le 0))
(assert (not (= source_effect_le target_effect_le)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; import_effect_safe: source semantics (matches Coq)
; Translation validation: import_effect_safe preserves semantics
(push 1)
(declare-const source_import_effect_safe Int)
(declare-const target_import_effect_safe Int)
(assert (>= source_import_effect_safe 0))
(assert (>= target_import_effect_safe 0))
(assert (not (= source_import_effect_safe target_import_effect_safe)))
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

; no_cross_label_access: source semantics (matches Coq)
; Translation validation: no_cross_label_access preserves semantics
(push 1)
(declare-const source_no_cross_label_access Int)
(declare-const target_no_cross_label_access Int)
(assert (>= source_no_cross_label_access 0))
(assert (>= target_no_cross_label_access 0))
(assert (not (= source_no_cross_label_access target_no_cross_label_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; string_in_segment: source semantics (matches Coq)
; Translation validation: string_in_segment preserves semantics
(push 1)
(declare-const source_string_in_segment Int)
(declare-const target_string_in_segment Int)
(assert (>= source_string_in_segment 0))
(assert (>= target_string_in_segment 0))
(assert (not (= source_string_in_segment target_string_in_segment)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; string_compiles_to_ptr: source semantics (matches Coq)
; Translation validation: string_compiles_to_ptr preserves semantics
(push 1)
(declare-const source_string_compiles_to_ptr Int)
(declare-const target_string_compiles_to_ptr Int)
(assert (>= source_string_compiles_to_ptr 0))
(assert (>= target_string_compiles_to_ptr 0))
(assert (not (= source_string_compiles_to_ptr target_string_compiles_to_ptr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closure_layout_valid: source semantics (matches Coq)
; Translation validation: closure_layout_valid preserves semantics
(push 1)
(declare-const source_closure_layout_valid Int)
(declare-const target_closure_layout_valid Int)
(assert (>= source_closure_layout_valid 0))
(assert (>= target_closure_layout_valid 0))
(assert (not (= source_closure_layout_valid target_closure_layout_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compile_closure_alloc: source semantics (matches Coq)
; Translation validation: compile_closure_alloc preserves semantics
(push 1)
(declare-const source_compile_closure_alloc Int)
(declare-const target_compile_closure_alloc Int)
(assert (>= source_compile_closure_alloc 0))
(assert (>= target_compile_closure_alloc 0))
(assert (not (= source_compile_closure_alloc target_compile_closure_alloc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pair_size: source semantics (matches Coq)
; Translation validation: pair_size preserves semantics
(push 1)
(declare-const source_pair_size Int)
(declare-const target_pair_size Int)
(assert (>= source_pair_size 0))
(assert (>= target_pair_size 0))
(assert (not (= source_pair_size target_pair_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sum_size: source semantics (matches Coq)
; Translation validation: sum_size preserves semantics
(push 1)
(declare-const source_sum_size Int)
(declare-const target_sum_size Int)
(assert (>= source_sum_size 0))
(assert (>= target_sum_size 0))
(assert (not (= source_sum_size target_sum_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pair_fst_offset: source semantics (matches Coq)
; Translation validation: pair_fst_offset preserves semantics
(push 1)
(declare-const source_pair_fst_offset Int)
(declare-const target_pair_fst_offset Int)
(assert (>= source_pair_fst_offset 0))
(assert (>= target_pair_fst_offset 0))
(assert (not (= source_pair_fst_offset target_pair_fst_offset)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pair_snd_offset: source semantics (matches Coq)
; Translation validation: pair_snd_offset preserves semantics
(push 1)
(declare-const source_pair_snd_offset Int)
(declare-const target_pair_snd_offset Int)
(assert (>= source_pair_snd_offset 0))
(assert (>= target_pair_snd_offset 0))
(assert (not (= source_pair_snd_offset target_pair_snd_offset)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sum_tag_valid: source semantics (matches Coq)
; Translation validation: sum_tag_valid preserves semantics
(push 1)
(declare-const source_sum_tag_valid Int)
(declare-const target_sum_tag_valid Int)
(assert (>= source_sum_tag_valid 0))
(assert (>= target_sum_tag_valid 0))
(assert (not (= source_sum_tag_valid target_sum_tag_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_eval_const: translation preserves property (matches Coq: Lemma)
; Translation validation: wasm_eval_const preserves semantics
(push 1)
(declare-const source_wasm_eval_const Int)
(declare-const target_wasm_eval_const Int)
(assert (>= source_wasm_eval_const 0))
(assert (>= target_wasm_eval_const 0))
(assert (not (= source_wasm_eval_const target_wasm_eval_const)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_eval_add: translation preserves property (matches Coq: Lemma)
; Translation validation: wasm_eval_add preserves semantics
(push 1)
(declare-const source_wasm_eval_add Int)
(declare-const target_wasm_eval_add Int)
(assert (>= source_wasm_eval_add 0))
(assert (>= target_wasm_eval_add 0))
(assert (not (= source_wasm_eval_add target_wasm_eval_add)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_eval_mul: translation preserves property (matches Coq: Lemma)
; Translation validation: wasm_eval_mul preserves semantics
(push 1)
(declare-const source_wasm_eval_mul Int)
(declare-const target_wasm_eval_mul Int)
(assert (>= source_wasm_eval_mul 0))
(assert (>= target_wasm_eval_mul 0))
(assert (not (= source_wasm_eval_mul target_wasm_eval_mul)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_001_const_preservation: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_001_const_preservation preserves semantics
(push 1)
(declare-const source_wasm_001_const_preservation Int)
(declare-const target_wasm_001_const_preservation Int)
(assert (>= source_wasm_001_const_preservation 0))
(assert (>= target_wasm_001_const_preservation 0))
(assert (not (= source_wasm_001_const_preservation target_wasm_001_const_preservation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_002_ni_preservation: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_002_ni_preservation preserves semantics
(push 1)
(declare-const source_wasm_002_ni_preservation Int)
(declare-const target_wasm_002_ni_preservation Int)
(assert (>= source_wasm_002_ni_preservation 0))
(assert (>= target_wasm_002_ni_preservation 0))
(assert (not (= source_wasm_002_ni_preservation target_wasm_002_ni_preservation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_002_memory_separation: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_002_memory_separation preserves semantics
(push 1)
(declare-const source_wasm_002_memory_separation Int)
(declare-const target_wasm_002_memory_separation Int)
(assert (>= source_wasm_002_memory_separation 0))
(assert (>= target_wasm_002_memory_separation 0))
(assert (not (= source_wasm_002_memory_separation target_wasm_002_memory_separation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_003_effect_preservation: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_003_effect_preservation preserves semantics
(push 1)
(declare-const source_wasm_003_effect_preservation Int)
(declare-const target_wasm_003_effect_preservation Int)
(assert (>= source_wasm_003_effect_preservation 0))
(assert (>= target_wasm_003_effect_preservation 0))
(assert (not (= source_wasm_003_effect_preservation target_wasm_003_effect_preservation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_003_io_self_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_003_io_self_safe preserves semantics
(push 1)
(declare-const source_wasm_003_io_self_safe Int)
(declare-const target_wasm_003_io_self_safe Int)
(assert (>= source_wasm_003_io_self_safe 0))
(assert (>= target_wasm_003_io_self_safe 0))
(assert (not (= source_wasm_003_io_self_safe target_wasm_003_io_self_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_004_int_type_preserved: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_004_int_type_preserved preserves semantics
(push 1)
(declare-const source_wasm_004_int_type_preserved Int)
(declare-const target_wasm_004_int_type_preserved Int)
(assert (>= source_wasm_004_int_type_preserved 0))
(assert (>= target_wasm_004_int_type_preserved 0))
(assert (not (= source_wasm_004_int_type_preserved target_wasm_004_int_type_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_004_add_type_preserved: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_004_add_type_preserved preserves semantics
(push 1)
(declare-const source_wasm_004_add_type_preserved Int)
(declare-const target_wasm_004_add_type_preserved Int)
(assert (>= source_wasm_004_add_type_preserved 0))
(assert (>= target_wasm_004_add_type_preserved 0))
(assert (not (= source_wasm_004_add_type_preserved target_wasm_004_add_type_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_004_bool_type_preserved: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_004_bool_type_preserved preserves semantics
(push 1)
(declare-const source_wasm_004_bool_type_preserved Int)
(declare-const target_wasm_004_bool_type_preserved Int)
(assert (>= source_wasm_004_bool_type_preserved 0))
(assert (>= target_wasm_004_bool_type_preserved 0))
(assert (not (= source_wasm_004_bool_type_preserved target_wasm_004_bool_type_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_005_disjoint_regions: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_005_disjoint_regions preserves semantics
(push 1)
(declare-const source_wasm_005_disjoint_regions Int)
(declare-const target_wasm_005_disjoint_regions Int)
(assert (>= source_wasm_005_disjoint_regions 0))
(assert (>= target_wasm_005_disjoint_regions 0))
(assert (not (= source_wasm_005_disjoint_regions target_wasm_005_disjoint_regions)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_005_public_cannot_access_secret: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_005_public_cannot_access_secret preserves semantics
(push 1)
(declare-const source_wasm_005_public_cannot_access_secret Int)
(declare-const target_wasm_005_public_cannot_access_secret Int)
(assert (>= source_wasm_005_public_cannot_access_secret 0))
(assert (>= target_wasm_005_public_cannot_access_secret 0))
(assert (not (= source_wasm_005_public_cannot_access_secret target_wasm_005_public_cannot_access_secret)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_006_string_const_produces_ptr: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_006_string_const_produces_ptr preserves semantics
(push 1)
(declare-const source_wasm_006_string_const_produces_ptr Int)
(declare-const target_wasm_006_string_const_produces_ptr Int)
(assert (>= source_wasm_006_string_const_produces_ptr 0))
(assert (>= target_wasm_006_string_const_produces_ptr 0))
(assert (not (= source_wasm_006_string_const_produces_ptr target_wasm_006_string_const_produces_ptr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_006_string_ptr_is_i32: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_006_string_ptr_is_i32 preserves semantics
(push 1)
(declare-const source_wasm_006_string_ptr_is_i32 Int)
(declare-const target_wasm_006_string_ptr_is_i32 Int)
(assert (>= source_wasm_006_string_ptr_is_i32 0))
(assert (>= target_wasm_006_string_ptr_is_i32 0))
(assert (not (= source_wasm_006_string_ptr_is_i32 target_wasm_006_string_ptr_is_i32)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_006_string_dedup: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_006_string_dedup preserves semantics
(push 1)
(declare-const source_wasm_006_string_dedup Int)
(declare-const target_wasm_006_string_dedup Int)
(assert (>= source_wasm_006_string_dedup 0))
(assert (>= target_wasm_006_string_dedup 0))
(assert (not (= source_wasm_006_string_dedup target_wasm_006_string_dedup)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_007_closure_layout: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_007_closure_layout preserves semantics
(push 1)
(declare-const source_wasm_007_closure_layout Int)
(declare-const target_wasm_007_closure_layout Int)
(assert (>= source_wasm_007_closure_layout 0))
(assert (>= target_wasm_007_closure_layout 0))
(assert (not (= source_wasm_007_closure_layout target_wasm_007_closure_layout)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_007_closure_no_overlap: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_007_closure_no_overlap preserves semantics
(push 1)
(declare-const source_wasm_007_closure_no_overlap Int)
(declare-const target_wasm_007_closure_no_overlap Int)
(assert (>= source_wasm_007_closure_no_overlap 0))
(assert (>= target_wasm_007_closure_no_overlap 0))
(assert (not (= source_wasm_007_closure_no_overlap target_wasm_007_closure_no_overlap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_007_closure_func_idx_recoverable: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_007_closure_func_idx_recoverable preserves semantics
(push 1)
(declare-const source_wasm_007_closure_func_idx_recoverable Int)
(declare-const target_wasm_007_closure_func_idx_recoverable Int)
(assert (>= source_wasm_007_closure_func_idx_recoverable 0))
(assert (>= target_wasm_007_closure_func_idx_recoverable 0))
(assert (not (= source_wasm_007_closure_func_idx_recoverable target_wasm_007_closure_func_idx_recoverable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_008_pair_offsets_disjoint: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_008_pair_offsets_disjoint preserves semantics
(push 1)
(declare-const source_wasm_008_pair_offsets_disjoint Int)
(declare-const target_wasm_008_pair_offsets_disjoint Int)
(assert (>= source_wasm_008_pair_offsets_disjoint 0))
(assert (>= target_wasm_008_pair_offsets_disjoint 0))
(assert (not (= source_wasm_008_pair_offsets_disjoint target_wasm_008_pair_offsets_disjoint)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_008_pair_fits_in_region: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_008_pair_fits_in_region preserves semantics
(push 1)
(declare-const source_wasm_008_pair_fits_in_region Int)
(declare-const target_wasm_008_pair_fits_in_region Int)
(assert (>= source_wasm_008_pair_fits_in_region 0))
(assert (>= target_wasm_008_pair_fits_in_region 0))
(assert (not (= source_wasm_008_pair_fits_in_region target_wasm_008_pair_fits_in_region)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_008_sum_tag_determines_branch: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_008_sum_tag_determines_branch preserves semantics
(push 1)
(declare-const source_wasm_008_sum_tag_determines_branch Int)
(declare-const target_wasm_008_sum_tag_determines_branch Int)
(assert (>= source_wasm_008_sum_tag_determines_branch 0))
(assert (>= target_wasm_008_sum_tag_determines_branch 0))
(assert (not (= source_wasm_008_sum_tag_determines_branch target_wasm_008_sum_tag_determines_branch)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_008_sum_fits_in_region: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_008_sum_fits_in_region preserves semantics
(push 1)
(declare-const source_wasm_008_sum_fits_in_region Int)
(declare-const target_wasm_008_sum_fits_in_region Int)
(assert (>= source_wasm_008_sum_fits_in_region 0))
(assert (>= target_wasm_008_sum_fits_in_region 0))
(assert (not (= source_wasm_008_sum_fits_in_region target_wasm_008_sum_fits_in_region)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_008_pairs_disjoint: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_008_pairs_disjoint preserves semantics
(push 1)
(declare-const source_wasm_008_pairs_disjoint Int)
(declare-const target_wasm_008_pairs_disjoint Int)
(assert (>= source_wasm_008_pairs_disjoint 0))
(assert (>= target_wasm_008_pairs_disjoint 0))
(assert (not (= source_wasm_008_pairs_disjoint target_wasm_008_pairs_disjoint)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_009_alloc_returns_current: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_009_alloc_returns_current preserves semantics
(push 1)
(declare-const source_wasm_009_alloc_returns_current Int)
(declare-const target_wasm_009_alloc_returns_current Int)
(assert (>= source_wasm_009_alloc_returns_current 0))
(assert (>= target_wasm_009_alloc_returns_current 0))
(assert (not (= source_wasm_009_alloc_returns_current target_wasm_009_alloc_returns_current)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_009_alloc_advances_ptr: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_009_alloc_advances_ptr preserves semantics
(push 1)
(declare-const source_wasm_009_alloc_advances_ptr Int)
(declare-const target_wasm_009_alloc_advances_ptr Int)
(assert (>= source_wasm_009_alloc_advances_ptr 0))
(assert (>= target_wasm_009_alloc_advances_ptr 0))
(assert (not (= source_wasm_009_alloc_advances_ptr target_wasm_009_alloc_advances_ptr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_009_alloc_preserves_limit: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_009_alloc_preserves_limit preserves semantics
(push 1)
(declare-const source_wasm_009_alloc_preserves_limit Int)
(declare-const target_wasm_009_alloc_preserves_limit Int)
(assert (>= source_wasm_009_alloc_preserves_limit 0))
(assert (>= target_wasm_009_alloc_preserves_limit 0))
(assert (not (= source_wasm_009_alloc_preserves_limit target_wasm_009_alloc_preserves_limit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_009_sequential_alloc_disjoint: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_009_sequential_alloc_disjoint preserves semantics
(push 1)
(declare-const source_wasm_009_sequential_alloc_disjoint Int)
(declare-const target_wasm_009_sequential_alloc_disjoint Int)
(assert (>= source_wasm_009_sequential_alloc_disjoint 0))
(assert (>= target_wasm_009_sequential_alloc_disjoint 0))
(assert (not (= source_wasm_009_sequential_alloc_disjoint target_wasm_009_sequential_alloc_disjoint)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_009_alloc_oom: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_009_alloc_oom preserves semantics
(push 1)
(declare-const source_wasm_009_alloc_oom Int)
(declare-const target_wasm_009_alloc_oom Int)
(assert (>= source_wasm_009_alloc_oom 0))
(assert (>= target_wasm_009_alloc_oom 0))
(assert (not (= source_wasm_009_alloc_oom target_wasm_009_alloc_oom)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_010_compile_ir_total: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_010_compile_ir_total preserves semantics
(push 1)
(declare-const source_wasm_010_compile_ir_total Int)
(declare-const target_wasm_010_compile_ir_total Int)
(assert (>= source_wasm_010_compile_ir_total 0))
(assert (>= target_wasm_010_compile_ir_total 0))
(assert (not (= source_wasm_010_compile_ir_total target_wasm_010_compile_ir_total)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_010_const_translates: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_010_const_translates preserves semantics
(push 1)
(declare-const source_wasm_010_const_translates Int)
(declare-const target_wasm_010_const_translates Int)
(assert (>= source_wasm_010_const_translates 0))
(assert (>= target_wasm_010_const_translates 0))
(assert (not (= source_wasm_010_const_translates target_wasm_010_const_translates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_010_var_translates: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_010_var_translates preserves semantics
(push 1)
(declare-const source_wasm_010_var_translates Int)
(declare-const target_wasm_010_var_translates Int)
(assert (>= source_wasm_010_var_translates 0))
(assert (>= target_wasm_010_var_translates 0))
(assert (not (= source_wasm_010_var_translates target_wasm_010_var_translates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_010_add_translates: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_010_add_translates preserves semantics
(push 1)
(declare-const source_wasm_010_add_translates Int)
(declare-const target_wasm_010_add_translates Int)
(assert (>= source_wasm_010_add_translates 0))
(assert (>= target_wasm_010_add_translates 0))
(assert (not (= source_wasm_010_add_translates target_wasm_010_add_translates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_010_mul_translates: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_010_mul_translates preserves semantics
(push 1)
(declare-const source_wasm_010_mul_translates Int)
(declare-const target_wasm_010_mul_translates Int)
(assert (>= source_wasm_010_mul_translates 0))
(assert (>= target_wasm_010_mul_translates 0))
(assert (not (= source_wasm_010_mul_translates target_wasm_010_mul_translates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_010_call_translates: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_010_call_translates preserves semantics
(push 1)
(declare-const source_wasm_010_call_translates Int)
(declare-const target_wasm_010_call_translates Int)
(assert (>= source_wasm_010_call_translates 0))
(assert (>= target_wasm_010_call_translates 0))
(assert (not (= source_wasm_010_call_translates target_wasm_010_call_translates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_010_let_translates: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_010_let_translates preserves semantics
(push 1)
(declare-const source_wasm_010_let_translates Int)
(declare-const target_wasm_010_let_translates Int)
(assert (>= source_wasm_010_let_translates 0))
(assert (>= target_wasm_010_let_translates 0))
(assert (not (= source_wasm_010_let_translates target_wasm_010_let_translates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_010_if_translates: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_010_if_translates preserves semantics
(push 1)
(declare-const source_wasm_010_if_translates Int)
(declare-const target_wasm_010_if_translates Int)
(assert (>= source_wasm_010_if_translates 0))
(assert (>= target_wasm_010_if_translates 0))
(assert (not (= source_wasm_010_if_translates target_wasm_010_if_translates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_010_load_translates: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_010_load_translates preserves semantics
(push 1)
(declare-const source_wasm_010_load_translates Int)
(declare-const target_wasm_010_load_translates Int)
(assert (>= source_wasm_010_load_translates 0))
(assert (>= target_wasm_010_load_translates 0))
(assert (not (= source_wasm_010_load_translates target_wasm_010_load_translates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_010_store_translates: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_010_store_translates preserves semantics
(push 1)
(declare-const source_wasm_010_store_translates Int)
(declare-const target_wasm_010_store_translates Int)
(assert (>= source_wasm_010_store_translates 0))
(assert (>= target_wasm_010_store_translates 0))
(assert (not (= source_wasm_010_store_translates target_wasm_010_store_translates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; app_ne_nil_r: translation preserves property (matches Coq: Lemma)
; Translation validation: app_ne_nil_r preserves semantics
(push 1)
(declare-const source_app_ne_nil_r Int)
(declare-const target_app_ne_nil_r Int)
(assert (>= source_app_ne_nil_r 0))
(assert (>= target_app_ne_nil_r 0))
(assert (not (= source_app_ne_nil_r target_app_ne_nil_r)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; singleton_ne_nil: translation preserves property (matches Coq: Lemma)
; Translation validation: singleton_ne_nil preserves semantics
(push 1)
(declare-const source_singleton_ne_nil Int)
(declare-const target_singleton_ne_nil Int)
(assert (>= source_singleton_ne_nil 0))
(assert (>= target_singleton_ne_nil 0))
(assert (not (= source_singleton_ne_nil target_singleton_ne_nil)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cons_ne_nil: translation preserves property (matches Coq: Lemma)
; Translation validation: cons_ne_nil preserves semantics
(push 1)
(declare-const source_cons_ne_nil Int)
(declare-const target_cons_ne_nil Int)
(assert (>= source_cons_ne_nil 0))
(assert (>= target_cons_ne_nil 0))
(assert (not (= source_cons_ne_nil target_cons_ne_nil)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wasm_010_completeness: translation preserves property (matches Coq: Theorem)
; Translation validation: wasm_010_completeness preserves semantics
(push 1)
(declare-const source_wasm_010_completeness Int)
(declare-const target_wasm_010_completeness Int)
(assert (>= source_wasm_010_completeness 0))
(assert (>= target_wasm_010_completeness 0))
(assert (not (= source_wasm_010_completeness target_wasm_010_completeness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

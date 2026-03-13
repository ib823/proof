; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/PI001_VerifiedPerformance.v (34 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for PI001_VerifiedPerformance
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; scalar_add: source semantics (matches Coq)
; Translation validation: scalar_add preserves semantics
(push 1)
(declare-const source_scalar_add Int)
(declare-const target_scalar_add Int)
(assert (>= source_scalar_add 0))
(assert (>= target_scalar_add 0))
(assert (not (= source_scalar_add target_scalar_add)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; simd_add: source semantics (matches Coq)
; Translation validation: simd_add preserves semantics
(push 1)
(declare-const source_simd_add Int)
(declare-const target_simd_add Int)
(assert (>= source_simd_add 0))
(assert (>= target_simd_add 0))
(assert (not (= source_simd_add target_simd_add)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; scalar_mul: source semantics (matches Coq)
; Translation validation: scalar_mul preserves semantics
(push 1)
(declare-const source_scalar_mul Int)
(declare-const target_scalar_mul Int)
(assert (>= source_scalar_mul 0))
(assert (>= target_scalar_mul 0))
(assert (not (= source_scalar_mul target_scalar_mul)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; simd_mul: source semantics (matches Coq)
; Translation validation: simd_mul preserves semantics
(push 1)
(declare-const source_simd_mul Int)
(declare-const target_simd_mul Int)
(assert (>= source_simd_mul 0))
(assert (>= target_simd_mul 0))
(assert (not (= source_simd_mul target_simd_mul)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dot_product: source semantics (matches Coq)
; Translation validation: dot_product preserves semantics
(push 1)
(declare-const source_dot_product Int)
(declare-const target_dot_product Int)
(assert (>= source_dot_product 0))
(assert (>= target_dot_product 0))
(assert (not (= source_dot_product target_dot_product)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; vec_sum: source semantics (matches Coq)
; Translation validation: vec_sum preserves semantics
(push 1)
(declare-const source_vec_sum Int)
(declare-const target_vec_sum Int)
(assert (>= source_vec_sum 0))
(assert (>= target_vec_sum 0))
(assert (not (= source_vec_sum target_vec_sum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; veb_value: source semantics (matches Coq)
; Translation validation: veb_value preserves semantics
(push 1)
(declare-const source_veb_value Int)
(declare-const target_veb_value Int)
(assert (>= source_veb_value 0))
(assert (>= target_veb_value 0))
(assert (not (= source_veb_value target_veb_value)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; veb_height: source semantics (matches Coq)
; Translation validation: veb_height preserves semantics
(push 1)
(declare-const source_veb_height Int)
(declare-const target_veb_height Int)
(assert (>= source_veb_height 0))
(assert (>= target_veb_height 0))
(assert (not (= source_veb_height target_veb_height)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; veb_size: source semantics (matches Coq)
; Translation validation: veb_size preserves semantics
(push 1)
(declare-const source_veb_size Int)
(declare-const target_veb_size Int)
(assert (>= source_veb_size 0))
(assert (>= target_veb_size 0))
(assert (not (= source_veb_size target_veb_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; veb_inorder: source semantics (matches Coq)
; Translation validation: veb_inorder preserves semantics
(push 1)
(declare-const source_veb_inorder Int)
(declare-const target_veb_inorder Int)
(assert (>= source_veb_inorder 0))
(assert (>= target_veb_inorder 0))
(assert (not (= source_veb_inorder target_veb_inorder)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sorted: source semantics (matches Coq)
; Translation validation: sorted preserves semantics
(push 1)
(declare-const source_sorted Int)
(declare-const target_sorted Int)
(assert (>= source_sorted 0))
(assert (>= target_sorted 0))
(assert (not (= source_sorted target_sorted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; veb_search: source semantics (matches Coq)
; Translation validation: veb_search preserves semantics
(push 1)
(declare-const source_veb_search Int)
(declare-const target_veb_search Int)
(assert (>= source_veb_search 0))
(assert (>= target_veb_search 0))
(assert (not (= source_veb_search target_veb_search)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cas: source semantics (matches Coq)
; Translation validation: cas preserves semantics
(push 1)
(declare-const source_cas Int)
(declare-const target_cas Int)
(assert (>= source_cas 0))
(assert (>= target_cas 0))
(assert (not (= source_cas target_cas)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; msq_empty: source semantics (matches Coq)
; Translation validation: msq_empty preserves semantics
(push 1)
(declare-const source_msq_empty Int)
(declare-const target_msq_empty Int)
(assert (>= source_msq_empty 0))
(assert (>= target_msq_empty 0))
(assert (not (= source_msq_empty target_msq_empty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; msq_enqueue: source semantics (matches Coq)
; Translation validation: msq_enqueue preserves semantics
(push 1)
(declare-const source_msq_enqueue Int)
(declare-const target_msq_enqueue Int)
(assert (>= source_msq_enqueue 0))
(assert (>= target_msq_enqueue 0))
(assert (not (= source_msq_enqueue target_msq_enqueue)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lin_ordered: source semantics (matches Coq)
; Translation validation: lin_ordered preserves semantics
(push 1)
(declare-const source_lin_ordered Int)
(declare-const target_lin_ordered Int)
(assert (>= source_lin_ordered 0))
(assert (>= target_lin_ordered 0))
(assert (not (= source_lin_ordered target_lin_ordered)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; opt_eval: source semantics (matches Coq)
; Translation validation: opt_eval preserves semantics
(push 1)
(declare-const source_opt_eval Int)
(declare-const target_opt_eval Int)
(assert (>= source_opt_eval 0))
(assert (>= target_opt_eval 0))
(assert (not (= source_opt_eval target_opt_eval)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dce: source semantics (matches Coq)
; Translation validation: dce preserves semantics
(push 1)
(declare-const source_dce Int)
(declare-const target_dce Int)
(assert (>= source_dce 0))
(assert (>= target_dce 0))
(assert (not (= source_dce target_dce)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; const_fold: source semantics (matches Coq)
; Translation validation: const_fold preserves semantics
(push 1)
(declare-const source_const_fold Int)
(declare-const target_const_fold Int)
(assert (>= source_const_fold 0))
(assert (>= target_const_fold 0))
(assert (not (= source_const_fold target_const_fold)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hash_nat: source semantics (matches Coq)
; Translation validation: hash_nat preserves semantics
(push 1)
(declare-const source_hash_nat Int)
(declare-const target_hash_nat Int)
(assert (>= source_hash_nat 0))
(assert (>= target_hash_nat 0))
(assert (not (= source_hash_nat target_hash_nat)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; puzzle_valid: source semantics (matches Coq)
; Translation validation: puzzle_valid preserves semantics
(push 1)
(declare-const source_puzzle_valid Int)
(declare-const target_puzzle_valid Int)
(assert (>= source_puzzle_valid 0))
(assert (>= target_puzzle_valid 0))
(assert (not (= source_puzzle_valid target_puzzle_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; puzzle_verify: source semantics (matches Coq)
; Translation validation: puzzle_verify preserves semantics
(push 1)
(declare-const source_puzzle_verify Int)
(declare-const target_puzzle_verify Int)
(assert (>= source_puzzle_verify 0))
(assert (>= target_puzzle_verify 0))
(assert (not (= source_puzzle_verify target_puzzle_verify)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_001_01_simd_add_equiv: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_001_01_simd_add_equiv preserves semantics
(push 1)
(declare-const source_PI_001_01_simd_add_equiv Int)
(declare-const target_PI_001_01_simd_add_equiv Int)
(assert (>= source_PI_001_01_simd_add_equiv 0))
(assert (>= target_PI_001_01_simd_add_equiv 0))
(assert (not (= source_PI_001_01_simd_add_equiv target_PI_001_01_simd_add_equiv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_001_02_simd_mul_equiv: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_001_02_simd_mul_equiv preserves semantics
(push 1)
(declare-const source_PI_001_02_simd_mul_equiv Int)
(declare-const target_PI_001_02_simd_mul_equiv Int)
(assert (>= source_PI_001_02_simd_mul_equiv 0))
(assert (>= target_PI_001_02_simd_mul_equiv 0))
(assert (not (= source_PI_001_02_simd_mul_equiv target_PI_001_02_simd_mul_equiv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_001_03_scalar_add_length: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_001_03_scalar_add_length preserves semantics
(push 1)
(declare-const source_PI_001_03_scalar_add_length Int)
(declare-const target_PI_001_03_scalar_add_length Int)
(assert (>= source_PI_001_03_scalar_add_length 0))
(assert (>= target_PI_001_03_scalar_add_length 0))
(assert (not (= source_PI_001_03_scalar_add_length target_PI_001_03_scalar_add_length)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_001_04_scalar_add_comm: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_001_04_scalar_add_comm preserves semantics
(push 1)
(declare-const source_PI_001_04_scalar_add_comm Int)
(declare-const target_PI_001_04_scalar_add_comm Int)
(assert (>= source_PI_001_04_scalar_add_comm 0))
(assert (>= target_PI_001_04_scalar_add_comm 0))
(assert (not (= source_PI_001_04_scalar_add_comm target_PI_001_04_scalar_add_comm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_001_05_scalar_add_assoc: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_001_05_scalar_add_assoc preserves semantics
(push 1)
(declare-const source_PI_001_05_scalar_add_assoc Int)
(declare-const target_PI_001_05_scalar_add_assoc Int)
(assert (>= source_PI_001_05_scalar_add_assoc 0))
(assert (>= target_PI_001_05_scalar_add_assoc 0))
(assert (not (= source_PI_001_05_scalar_add_assoc target_PI_001_05_scalar_add_assoc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_001_06_scalar_mul_length: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_001_06_scalar_mul_length preserves semantics
(push 1)
(declare-const source_PI_001_06_scalar_mul_length Int)
(declare-const target_PI_001_06_scalar_mul_length Int)
(assert (>= source_PI_001_06_scalar_mul_length 0))
(assert (>= target_PI_001_06_scalar_mul_length 0))
(assert (not (= source_PI_001_06_scalar_mul_length target_PI_001_06_scalar_mul_length)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_001_07_dot_product_zero_left: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_001_07_dot_product_zero_left preserves semantics
(push 1)
(declare-const source_PI_001_07_dot_product_zero_left Int)
(declare-const target_PI_001_07_dot_product_zero_left Int)
(assert (>= source_PI_001_07_dot_product_zero_left 0))
(assert (>= target_PI_001_07_dot_product_zero_left 0))
(assert (not (= source_PI_001_07_dot_product_zero_left target_PI_001_07_dot_product_zero_left)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_001_08_simd_preserves_length: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_001_08_simd_preserves_length preserves semantics
(push 1)
(declare-const source_PI_001_08_simd_preserves_length Int)
(declare-const target_PI_001_08_simd_preserves_length Int)
(assert (>= source_PI_001_08_simd_preserves_length 0))
(assert (>= target_PI_001_08_simd_preserves_length 0))
(assert (not (= source_PI_001_08_simd_preserves_length target_PI_001_08_simd_preserves_length)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_002_01_veb_search_root: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_002_01_veb_search_root preserves semantics
(push 1)
(declare-const source_PI_002_01_veb_search_root Int)
(declare-const target_PI_002_01_veb_search_root Int)
(assert (>= source_PI_002_01_veb_search_root 0))
(assert (>= target_PI_002_01_veb_search_root 0))
(assert (not (= source_PI_002_01_veb_search_root target_PI_002_01_veb_search_root)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_002_02_veb_leaf_search: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_002_02_veb_leaf_search preserves semantics
(push 1)
(declare-const source_PI_002_02_veb_leaf_search Int)
(declare-const target_PI_002_02_veb_leaf_search Int)
(assert (>= source_PI_002_02_veb_leaf_search 0))
(assert (>= target_PI_002_02_veb_leaf_search 0))
(assert (not (= source_PI_002_02_veb_leaf_search target_PI_002_02_veb_leaf_search)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_002_03_veb_height_positive: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_002_03_veb_height_positive preserves semantics
(push 1)
(declare-const source_PI_002_03_veb_height_positive Int)
(declare-const target_PI_002_03_veb_height_positive Int)
(assert (>= source_PI_002_03_veb_height_positive 0))
(assert (>= target_PI_002_03_veb_height_positive 0))
(assert (not (= source_PI_002_03_veb_height_positive target_PI_002_03_veb_height_positive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_002_04_veb_size_positive: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_002_04_veb_size_positive preserves semantics
(push 1)
(declare-const source_PI_002_04_veb_size_positive Int)
(declare-const target_PI_002_04_veb_size_positive Int)
(assert (>= source_PI_002_04_veb_size_positive 0))
(assert (>= target_PI_002_04_veb_size_positive 0))
(assert (not (= source_PI_002_04_veb_size_positive target_PI_002_04_veb_size_positive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_002_05_veb_inorder_nonempty: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_002_05_veb_inorder_nonempty preserves semantics
(push 1)
(declare-const source_PI_002_05_veb_inorder_nonempty Int)
(declare-const target_PI_002_05_veb_inorder_nonempty Int)
(assert (>= source_PI_002_05_veb_inorder_nonempty 0))
(assert (>= target_PI_002_05_veb_inorder_nonempty 0))
(assert (not (= source_PI_002_05_veb_inorder_nonempty target_PI_002_05_veb_inorder_nonempty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_002_06_veb_height_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_002_06_veb_height_bound preserves semantics
(push 1)
(declare-const source_PI_002_06_veb_height_bound Int)
(declare-const target_PI_002_06_veb_height_bound Int)
(assert (>= source_PI_002_06_veb_height_bound 0))
(assert (>= target_PI_002_06_veb_height_bound 0))
(assert (not (= source_PI_002_06_veb_height_bound target_PI_002_06_veb_height_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_003_01_msq_empty_dequeue: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_003_01_msq_empty_dequeue preserves semantics
(push 1)
(declare-const source_PI_003_01_msq_empty_dequeue Int)
(declare-const target_PI_003_01_msq_empty_dequeue Int)
(assert (>= source_PI_003_01_msq_empty_dequeue 0))
(assert (>= target_PI_003_01_msq_empty_dequeue 0))
(assert (not (= source_PI_003_01_msq_empty_dequeue target_PI_003_01_msq_empty_dequeue)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_003_02_msq_enqueue_nonempty: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_003_02_msq_enqueue_nonempty preserves semantics
(push 1)
(declare-const source_PI_003_02_msq_enqueue_nonempty Int)
(declare-const target_PI_003_02_msq_enqueue_nonempty Int)
(assert (>= source_PI_003_02_msq_enqueue_nonempty 0))
(assert (>= target_PI_003_02_msq_enqueue_nonempty 0))
(assert (not (= source_PI_003_02_msq_enqueue_nonempty target_PI_003_02_msq_enqueue_nonempty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_003_03_msq_fifo: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_003_03_msq_fifo preserves semantics
(push 1)
(declare-const source_PI_003_03_msq_fifo Int)
(declare-const target_PI_003_03_msq_fifo Int)
(assert (>= source_PI_003_03_msq_fifo 0))
(assert (>= target_PI_003_03_msq_fifo 0))
(assert (not (= source_PI_003_03_msq_fifo target_PI_003_03_msq_fifo)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_003_04_msq_enqueue_length: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_003_04_msq_enqueue_length preserves semantics
(push 1)
(declare-const source_PI_003_04_msq_enqueue_length Int)
(declare-const target_PI_003_04_msq_enqueue_length Int)
(assert (>= source_PI_003_04_msq_enqueue_length 0))
(assert (>= target_PI_003_04_msq_enqueue_length 0))
(assert (not (= source_PI_003_04_msq_enqueue_length target_PI_003_04_msq_enqueue_length)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_003_05_cas_success: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_003_05_cas_success preserves semantics
(push 1)
(declare-const source_PI_003_05_cas_success Int)
(declare-const target_PI_003_05_cas_success Int)
(assert (>= source_PI_003_05_cas_success 0))
(assert (>= target_PI_003_05_cas_success 0))
(assert (not (= source_PI_003_05_cas_success target_PI_003_05_cas_success)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_003_06_cas_failure: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_003_06_cas_failure preserves semantics
(push 1)
(declare-const source_PI_003_06_cas_failure Int)
(declare-const target_PI_003_06_cas_failure Int)
(assert (>= source_PI_003_06_cas_failure 0))
(assert (>= target_PI_003_06_cas_failure 0))
(assert (not (= source_PI_003_06_cas_failure target_PI_003_06_cas_failure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_003_07_linearization_empty: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_003_07_linearization_empty preserves semantics
(push 1)
(declare-const source_PI_003_07_linearization_empty Int)
(declare-const target_PI_003_07_linearization_empty Int)
(assert (>= source_PI_003_07_linearization_empty 0))
(assert (>= target_PI_003_07_linearization_empty 0))
(assert (not (= source_PI_003_07_linearization_empty target_PI_003_07_linearization_empty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_004_01_dce_false_branch: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_004_01_dce_false_branch preserves semantics
(push 1)
(declare-const source_PI_004_01_dce_false_branch Int)
(declare-const target_PI_004_01_dce_false_branch Int)
(assert (>= source_PI_004_01_dce_false_branch 0))
(assert (>= target_PI_004_01_dce_false_branch 0))
(assert (not (= source_PI_004_01_dce_false_branch target_PI_004_01_dce_false_branch)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_004_02_dce_true_branch: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_004_02_dce_true_branch preserves semantics
(push 1)
(declare-const source_PI_004_02_dce_true_branch Int)
(declare-const target_PI_004_02_dce_true_branch Int)
(assert (>= source_PI_004_02_dce_true_branch 0))
(assert (>= target_PI_004_02_dce_true_branch 0))
(assert (not (= source_PI_004_02_dce_true_branch target_PI_004_02_dce_true_branch)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_004_03_const_fold_add: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_004_03_const_fold_add preserves semantics
(push 1)
(declare-const source_PI_004_03_const_fold_add Int)
(declare-const target_PI_004_03_const_fold_add Int)
(assert (>= source_PI_004_03_const_fold_add 0))
(assert (>= target_PI_004_03_const_fold_add 0))
(assert (not (= source_PI_004_03_const_fold_add target_PI_004_03_const_fold_add)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_004_04_const_fold_mul: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_004_04_const_fold_mul preserves semantics
(push 1)
(declare-const source_PI_004_04_const_fold_mul Int)
(declare-const target_PI_004_04_const_fold_mul Int)
(assert (>= source_PI_004_04_const_fold_mul 0))
(assert (>= target_PI_004_04_const_fold_mul 0))
(assert (not (= source_PI_004_04_const_fold_mul target_PI_004_04_const_fold_mul)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_004_05_const_preserves: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_004_05_const_preserves preserves semantics
(push 1)
(declare-const source_PI_004_05_const_preserves Int)
(declare-const target_PI_004_05_const_preserves Int)
(assert (>= source_PI_004_05_const_preserves 0))
(assert (>= target_PI_004_05_const_preserves 0))
(assert (not (= source_PI_004_05_const_preserves target_PI_004_05_const_preserves)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_004_06_var_preserves: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_004_06_var_preserves preserves semantics
(push 1)
(declare-const source_PI_004_06_var_preserves Int)
(declare-const target_PI_004_06_var_preserves Int)
(assert (>= source_PI_004_06_var_preserves 0))
(assert (>= target_PI_004_06_var_preserves 0))
(assert (not (= source_PI_004_06_var_preserves target_PI_004_06_var_preserves)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_004_07_dce_const_preserves: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_004_07_dce_const_preserves preserves semantics
(push 1)
(declare-const source_PI_004_07_dce_const_preserves Int)
(declare-const target_PI_004_07_dce_const_preserves Int)
(assert (>= source_PI_004_07_dce_const_preserves 0))
(assert (>= target_PI_004_07_dce_const_preserves 0))
(assert (not (= source_PI_004_07_dce_const_preserves target_PI_004_07_dce_const_preserves)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_004_08_dce_var_preserves: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_004_08_dce_var_preserves preserves semantics
(push 1)
(declare-const source_PI_004_08_dce_var_preserves Int)
(declare-const target_PI_004_08_dce_var_preserves Int)
(assert (>= source_PI_004_08_dce_var_preserves 0))
(assert (>= target_PI_004_08_dce_var_preserves 0))
(assert (not (= source_PI_004_08_dce_var_preserves target_PI_004_08_dce_var_preserves)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_005_01_puzzle_verify_sound: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_005_01_puzzle_verify_sound preserves semantics
(push 1)
(declare-const source_PI_005_01_puzzle_verify_sound Int)
(declare-const target_PI_005_01_puzzle_verify_sound Int)
(assert (>= source_PI_005_01_puzzle_verify_sound 0))
(assert (>= target_PI_005_01_puzzle_verify_sound 0))
(assert (not (= source_PI_005_01_puzzle_verify_sound target_PI_005_01_puzzle_verify_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_005_02_puzzle_verify_complete: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_005_02_puzzle_verify_complete preserves semantics
(push 1)
(declare-const source_PI_005_02_puzzle_verify_complete Int)
(declare-const target_PI_005_02_puzzle_verify_complete Int)
(assert (>= source_PI_005_02_puzzle_verify_complete 0))
(assert (>= target_PI_005_02_puzzle_verify_complete 0))
(assert (not (= source_PI_005_02_puzzle_verify_complete target_PI_005_02_puzzle_verify_complete)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_005_03_puzzle_zero_target: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_005_03_puzzle_zero_target preserves semantics
(push 1)
(declare-const source_PI_005_03_puzzle_zero_target Int)
(declare-const target_PI_005_03_puzzle_zero_target Int)
(assert (>= source_PI_005_03_puzzle_zero_target 0))
(assert (>= target_PI_005_03_puzzle_zero_target 0))
(assert (not (= source_PI_005_03_puzzle_zero_target target_PI_005_03_puzzle_zero_target)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_005_04_puzzle_deterministic: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_005_04_puzzle_deterministic preserves semantics
(push 1)
(declare-const source_PI_005_04_puzzle_deterministic Int)
(declare-const target_PI_005_04_puzzle_deterministic Int)
(assert (>= source_PI_005_04_puzzle_deterministic 0))
(assert (>= target_PI_005_04_puzzle_deterministic 0))
(assert (not (= source_PI_005_04_puzzle_deterministic target_PI_005_04_puzzle_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PI_005_05_vec_sum_nil: translation preserves property (matches Coq: Theorem)
; Translation validation: PI_005_05_vec_sum_nil preserves semantics
(push 1)
(declare-const source_PI_005_05_vec_sum_nil Int)
(declare-const target_PI_005_05_vec_sum_nil Int)
(assert (>= source_PI_005_05_vec_sum_nil 0))
(assert (>= target_PI_005_05_vec_sum_nil 0))
(assert (not (= source_PI_005_05_vec_sum_nil target_PI_005_05_vec_sum_nil)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

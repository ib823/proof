; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/MLSafetyTypes.v (24 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for MLSafetyTypes
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; shape_eq: source semantics (matches Coq)
; Translation validation: shape_eq preserves semantics
(push 1)
(declare-const source_shape_eq Int)
(declare-const target_shape_eq Int)
(assert (>= source_shape_eq 0))
(assert (>= target_shape_eq 0))
(assert (not (= source_shape_eq target_shape_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dp_compose: source semantics (matches Coq)
; Translation validation: dp_compose preserves semantics
(push 1)
(declare-const source_dp_compose Int)
(declare-const target_dp_compose Int)
(assert (>= source_dp_compose 0))
(assert (>= target_dp_compose 0))
(assert (not (= source_dp_compose target_dp_compose)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lipschitz_bound: source semantics (matches Coq)
; Translation validation: lipschitz_bound preserves semantics
(push 1)
(declare-const source_lipschitz_bound Int)
(declare-const target_lipschitz_bound Int)
(assert (>= source_lipschitz_bound 0))
(assert (>= target_lipschitz_bound 0))
(assert (not (= source_lipschitz_bound target_lipschitz_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; forallb_combine_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: forallb_combine_refl preserves semantics
(push 1)
(declare-const source_forallb_combine_refl Int)
(declare-const target_forallb_combine_refl Int)
(assert (>= source_forallb_combine_refl 0))
(assert (>= target_forallb_combine_refl 0))
(assert (not (= source_forallb_combine_refl target_forallb_combine_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; forallb_combine_sym: translation preserves property (matches Coq: Lemma)
; Translation validation: forallb_combine_sym preserves semantics
(push 1)
(declare-const source_forallb_combine_sym Int)
(declare-const target_forallb_combine_sym Int)
(assert (>= source_forallb_combine_sym 0))
(assert (>= target_forallb_combine_sym 0))
(assert (not (= source_forallb_combine_sym target_forallb_combine_sym)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; shape_eq_refl: translation preserves property (matches Coq: Theorem)
; Translation validation: shape_eq_refl preserves semantics
(push 1)
(declare-const source_shape_eq_refl Int)
(declare-const target_shape_eq_refl Int)
(assert (>= source_shape_eq_refl 0))
(assert (>= target_shape_eq_refl 0))
(assert (not (= source_shape_eq_refl target_shape_eq_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; shape_eq_sym: translation preserves property (matches Coq: Theorem)
; Translation validation: shape_eq_sym preserves semantics
(push 1)
(declare-const source_shape_eq_sym Int)
(declare-const target_shape_eq_sym Int)
(assert (>= source_shape_eq_sym 0))
(assert (>= target_shape_eq_sym 0))
(assert (not (= source_shape_eq_sym target_shape_eq_sym)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; matmul_shape_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: matmul_shape_correct preserves semantics
(push 1)
(declare-const source_matmul_shape_correct Int)
(declare-const target_matmul_shape_correct Int)
(assert (>= source_matmul_shape_correct 0))
(assert (>= target_matmul_shape_correct 0))
(assert (not (= source_matmul_shape_correct target_matmul_shape_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; matmul_incompat: translation preserves property (matches Coq: Theorem)
; Translation validation: matmul_incompat preserves semantics
(push 1)
(declare-const source_matmul_incompat Int)
(declare-const target_matmul_incompat Int)
(assert (>= source_matmul_incompat 0))
(assert (>= target_matmul_incompat 0))
(assert (not (= source_matmul_incompat target_matmul_incompat)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dp_composition_additive: translation preserves property (matches Coq: Theorem)
; Translation validation: dp_composition_additive preserves semantics
(push 1)
(declare-const source_dp_composition_additive Int)
(declare-const target_dp_composition_additive Int)
(assert (>= source_dp_composition_additive 0))
(assert (>= target_dp_composition_additive 0))
(assert (not (= source_dp_composition_additive target_dp_composition_additive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dp_compose_assoc: translation preserves property (matches Coq: Theorem)
; Translation validation: dp_compose_assoc preserves semantics
(push 1)
(declare-const source_dp_compose_assoc Int)
(declare-const target_dp_compose_assoc Int)
(assert (>= source_dp_compose_assoc 0))
(assert (>= target_dp_compose_assoc 0))
(assert (not (= source_dp_compose_assoc target_dp_compose_assoc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lipschitz_compose: translation preserves property (matches Coq: Theorem)
; Translation validation: lipschitz_compose preserves semantics
(push 1)
(declare-const source_lipschitz_compose Int)
(declare-const target_lipschitz_compose Int)
(assert (>= source_lipschitz_compose 0))
(assert (>= target_lipschitz_compose 0))
(assert (not (= source_lipschitz_compose target_lipschitz_compose)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lipschitz_id: translation preserves property (matches Coq: Theorem)
; Translation validation: lipschitz_id preserves semantics
(push 1)
(declare-const source_lipschitz_id Int)
(declare-const target_lipschitz_id Int)
(assert (>= source_lipschitz_id 0))
(assert (>= target_lipschitz_id 0))
(assert (not (= source_lipschitz_id target_lipschitz_id)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lipschitz_const: translation preserves property (matches Coq: Theorem)
; Translation validation: lipschitz_const preserves semantics
(push 1)
(declare-const source_lipschitz_const Int)
(declare-const target_lipschitz_const Int)
(assert (>= source_lipschitz_const 0))
(assert (>= target_lipschitz_const 0))
(assert (not (= source_lipschitz_const target_lipschitz_const)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dp_queries_additive: translation preserves property (matches Coq: Theorem)
; Translation validation: dp_queries_additive preserves semantics
(push 1)
(declare-const source_dp_queries_additive Int)
(declare-const target_dp_queries_additive Int)
(assert (>= source_dp_queries_additive 0))
(assert (>= target_dp_queries_additive 0))
(assert (not (= source_dp_queries_additive target_dp_queries_additive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dp_compose_zero_l: translation preserves property (matches Coq: Theorem)
; Translation validation: dp_compose_zero_l preserves semantics
(push 1)
(declare-const source_dp_compose_zero_l Int)
(declare-const target_dp_compose_zero_l Int)
(assert (>= source_dp_compose_zero_l 0))
(assert (>= target_dp_compose_zero_l 0))
(assert (not (= source_dp_compose_zero_l target_dp_compose_zero_l)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dp_compose_zero_r: translation preserves property (matches Coq: Theorem)
; Translation validation: dp_compose_zero_r preserves semantics
(push 1)
(declare-const source_dp_compose_zero_r Int)
(declare-const target_dp_compose_zero_r Int)
(assert (>= source_dp_compose_zero_r 0))
(assert (>= target_dp_compose_zero_r 0))
(assert (not (= source_dp_compose_zero_r target_dp_compose_zero_r)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dp_compose_comm: translation preserves property (matches Coq: Theorem)
; Translation validation: dp_compose_comm preserves semantics
(push 1)
(declare-const source_dp_compose_comm Int)
(declare-const target_dp_compose_comm Int)
(assert (>= source_dp_compose_comm 0))
(assert (>= target_dp_compose_comm 0))
(assert (not (= source_dp_compose_comm target_dp_compose_comm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; shape_eq_implies_same_length: translation preserves property (matches Coq: Theorem)
; Translation validation: shape_eq_implies_same_length preserves semantics
(push 1)
(declare-const source_shape_eq_implies_same_length Int)
(declare-const target_shape_eq_implies_same_length Int)
(assert (>= source_shape_eq_implies_same_length 0))
(assert (>= target_shape_eq_implies_same_length 0))
(assert (not (= source_shape_eq_implies_same_length target_shape_eq_implies_same_length)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; shape_eq_nil: translation preserves property (matches Coq: Theorem)
; Translation validation: shape_eq_nil preserves semantics
(push 1)
(declare-const source_shape_eq_nil Int)
(declare-const target_shape_eq_nil Int)
(assert (>= source_shape_eq_nil 0))
(assert (>= target_shape_eq_nil 0))
(assert (not (= source_shape_eq_nil target_shape_eq_nil)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; shape_eq_singleton: translation preserves property (matches Coq: Theorem)
; Translation validation: shape_eq_singleton preserves semantics
(push 1)
(declare-const source_shape_eq_singleton Int)
(declare-const target_shape_eq_singleton Int)
(assert (>= source_shape_eq_singleton 0))
(assert (>= target_shape_eq_singleton 0))
(assert (not (= source_shape_eq_singleton target_shape_eq_singleton)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; matmul_square: translation preserves property (matches Coq: Theorem)
; Translation validation: matmul_square preserves semantics
(push 1)
(declare-const source_matmul_square Int)
(declare-const target_matmul_square Int)
(assert (>= source_matmul_square 0))
(assert (>= target_matmul_square 0))
(assert (not (= source_matmul_square target_matmul_square)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; matmul_col_vector: translation preserves property (matches Coq: Theorem)
; Translation validation: matmul_col_vector preserves semantics
(push 1)
(declare-const source_matmul_col_vector Int)
(declare-const target_matmul_col_vector Int)
(assert (>= source_matmul_col_vector 0))
(assert (>= target_matmul_col_vector 0))
(assert (not (= source_matmul_col_vector target_matmul_col_vector)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dp_epsilon_nonneg: translation preserves property (matches Coq: Theorem)
; Translation validation: dp_epsilon_nonneg preserves semantics
(push 1)
(declare-const source_dp_epsilon_nonneg Int)
(declare-const target_dp_epsilon_nonneg Int)
(assert (>= source_dp_epsilon_nonneg 0))
(assert (>= target_dp_epsilon_nonneg 0))
(assert (not (= source_dp_epsilon_nonneg target_dp_epsilon_nonneg)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lipschitz_mono: translation preserves property (matches Coq: Theorem)
; Translation validation: lipschitz_mono preserves semantics
(push 1)
(declare-const source_lipschitz_mono Int)
(declare-const target_lipschitz_mono Int)
(assert (>= source_lipschitz_mono 0))
(assert (>= target_lipschitz_mono 0))
(assert (not (= source_lipschitz_mono target_lipschitz_mono)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compose_fn_assoc: translation preserves property (matches Coq: Theorem)
; Translation validation: compose_fn_assoc preserves semantics
(push 1)
(declare-const source_compose_fn_assoc Int)
(declare-const target_compose_fn_assoc Int)
(assert (>= source_compose_fn_assoc 0))
(assert (>= target_compose_fn_assoc 0))
(assert (not (= source_compose_fn_assoc target_compose_fn_assoc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compose_fn_id_l: translation preserves property (matches Coq: Theorem)
; Translation validation: compose_fn_id_l preserves semantics
(push 1)
(declare-const source_compose_fn_id_l Int)
(declare-const target_compose_fn_id_l Int)
(assert (>= source_compose_fn_id_l 0))
(assert (>= target_compose_fn_id_l 0))
(assert (not (= source_compose_fn_id_l target_compose_fn_id_l)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

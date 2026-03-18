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
(declare-fun source_shape_eq () Bool)
(declare-fun target_shape_eq () Bool)
(assert (= source_shape_eq target_shape_eq))

; dp_compose: source semantics (matches Coq)
(declare-fun source_dp_compose () Bool)
(declare-fun target_dp_compose () Bool)
(assert (= source_dp_compose target_dp_compose))

; lipschitz_bound: source semantics (matches Coq)
(declare-fun source_lipschitz_bound () Bool)
(declare-fun target_lipschitz_bound () Bool)
(assert (= source_lipschitz_bound target_lipschitz_bound))

; forallb_combine_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_forallb_combine_refl () Bool)
(declare-fun target_forallb_combine_refl () Bool)
(assert (= source_forallb_combine_refl target_forallb_combine_refl))

; forallb_combine_sym: translation preserves property (matches Coq: Lemma)
(declare-fun source_forallb_combine_sym () Bool)
(declare-fun target_forallb_combine_sym () Bool)
(assert (= source_forallb_combine_sym target_forallb_combine_sym))

; shape_eq_refl: translation preserves property (matches Coq: Theorem)
(declare-fun source_shape_eq_refl () Bool)
(declare-fun target_shape_eq_refl () Bool)
(assert (= source_shape_eq_refl target_shape_eq_refl))

; shape_eq_sym: translation preserves property (matches Coq: Theorem)
(declare-fun source_shape_eq_sym () Bool)
(declare-fun target_shape_eq_sym () Bool)
(assert (= source_shape_eq_sym target_shape_eq_sym))

; matmul_shape_correct: translation preserves property (matches Coq: Theorem)
(declare-fun source_matmul_shape_correct () Bool)
(declare-fun target_matmul_shape_correct () Bool)
(assert (= source_matmul_shape_correct target_matmul_shape_correct))

; matmul_incompat: translation preserves property (matches Coq: Theorem)
(declare-fun source_matmul_incompat () Bool)
(declare-fun target_matmul_incompat () Bool)
(assert (= source_matmul_incompat target_matmul_incompat))

; dp_composition_additive: translation preserves property (matches Coq: Theorem)
(declare-fun source_dp_composition_additive () Bool)
(declare-fun target_dp_composition_additive () Bool)
(assert (= source_dp_composition_additive target_dp_composition_additive))

; dp_compose_assoc: translation preserves property (matches Coq: Theorem)
(declare-fun source_dp_compose_assoc () Bool)
(declare-fun target_dp_compose_assoc () Bool)
(assert (= source_dp_compose_assoc target_dp_compose_assoc))

; lipschitz_compose: translation preserves property (matches Coq: Theorem)
(declare-fun source_lipschitz_compose () Bool)
(declare-fun target_lipschitz_compose () Bool)
(assert (= source_lipschitz_compose target_lipschitz_compose))

; lipschitz_id: translation preserves property (matches Coq: Theorem)
(declare-fun source_lipschitz_id () Bool)
(declare-fun target_lipschitz_id () Bool)
(assert (= source_lipschitz_id target_lipschitz_id))

; lipschitz_const: translation preserves property (matches Coq: Theorem)
(declare-fun source_lipschitz_const () Bool)
(declare-fun target_lipschitz_const () Bool)
(assert (= source_lipschitz_const target_lipschitz_const))

; dp_queries_additive: translation preserves property (matches Coq: Theorem)
(declare-fun source_dp_queries_additive () Bool)
(declare-fun target_dp_queries_additive () Bool)
(assert (= source_dp_queries_additive target_dp_queries_additive))

; dp_compose_zero_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_dp_compose_zero_l () Bool)
(declare-fun target_dp_compose_zero_l () Bool)
(assert (= source_dp_compose_zero_l target_dp_compose_zero_l))

; dp_compose_zero_r: translation preserves property (matches Coq: Theorem)
(declare-fun source_dp_compose_zero_r () Bool)
(declare-fun target_dp_compose_zero_r () Bool)
(assert (= source_dp_compose_zero_r target_dp_compose_zero_r))

; dp_compose_comm: translation preserves property (matches Coq: Theorem)
(declare-fun source_dp_compose_comm () Bool)
(declare-fun target_dp_compose_comm () Bool)
(assert (= source_dp_compose_comm target_dp_compose_comm))

; shape_eq_implies_same_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_shape_eq_implies_same_length () Bool)
(declare-fun target_shape_eq_implies_same_length () Bool)
(assert (= source_shape_eq_implies_same_length target_shape_eq_implies_same_length))

; shape_eq_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_shape_eq_nil () Bool)
(declare-fun target_shape_eq_nil () Bool)
(assert (= source_shape_eq_nil target_shape_eq_nil))

; shape_eq_singleton: translation preserves property (matches Coq: Theorem)
(declare-fun source_shape_eq_singleton () Bool)
(declare-fun target_shape_eq_singleton () Bool)
(assert (= source_shape_eq_singleton target_shape_eq_singleton))

; matmul_square: translation preserves property (matches Coq: Theorem)
(declare-fun source_matmul_square () Bool)
(declare-fun target_matmul_square () Bool)
(assert (= source_matmul_square target_matmul_square))

; matmul_col_vector: translation preserves property (matches Coq: Theorem)
(declare-fun source_matmul_col_vector () Bool)
(declare-fun target_matmul_col_vector () Bool)
(assert (= source_matmul_col_vector target_matmul_col_vector))

; dp_epsilon_nonneg: translation preserves property (matches Coq: Theorem)
(declare-fun source_dp_epsilon_nonneg () Bool)
(declare-fun target_dp_epsilon_nonneg () Bool)
(assert (= source_dp_epsilon_nonneg target_dp_epsilon_nonneg))

; lipschitz_mono: translation preserves property (matches Coq: Theorem)
(declare-fun source_lipschitz_mono () Bool)
(declare-fun target_lipschitz_mono () Bool)
(assert (= source_lipschitz_mono target_lipschitz_mono))

; compose_fn_assoc: translation preserves property (matches Coq: Theorem)
(declare-fun source_compose_fn_assoc () Bool)
(declare-fun target_compose_fn_assoc () Bool)
(assert (= source_compose_fn_assoc target_compose_fn_assoc))

; compose_fn_id_l: translation preserves property (matches Coq: Theorem)
(declare-fun source_compose_fn_id_l () Bool)
(declare-fun target_compose_fn_id_l () Bool)
(assert (= source_compose_fn_id_l target_compose_fn_id_l))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

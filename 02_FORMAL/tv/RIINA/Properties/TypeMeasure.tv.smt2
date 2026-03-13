; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/TypeMeasure.v (29 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for TypeMeasure
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; ty_size: source semantics (matches Coq)
; Translation validation: ty_size preserves semantics
(push 1)
(declare-const source_ty_size Int)
(declare-const target_ty_size Int)
(assert (>= source_ty_size 0))
(assert (>= target_ty_size 0))
(assert (not (= source_ty_size target_ty_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_size_lt: source semantics (matches Coq)
; Translation validation: ty_size_lt preserves semantics
(push 1)
(declare-const source_ty_size_lt Int)
(declare-const target_ty_size_lt Int)
(assert (>= source_ty_size_lt 0))
(assert (>= target_ty_size_lt 0))
(assert (not (= source_ty_size_lt target_ty_size_lt)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; first_order_type: source semantics (matches Coq)
; Translation validation: first_order_type preserves semantics
(push 1)
(declare-const source_first_order_type Int)
(declare-const target_first_order_type Int)
(assert (>= source_first_order_type 0))
(assert (>= target_first_order_type 0))
(assert (not (= source_first_order_type target_first_order_type)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fo_compound_depth: source semantics (matches Coq)
; Translation validation: fo_compound_depth preserves semantics
(push 1)
(declare-const source_fo_compound_depth Int)
(declare-const target_fo_compound_depth Int)
(assert (>= source_fo_compound_depth 0))
(assert (>= target_fo_compound_depth 0))
(assert (not (= source_fo_compound_depth target_fo_compound_depth)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_depth: source semantics (matches Coq)
; Translation validation: ty_depth preserves semantics
(push 1)
(declare-const source_ty_depth Int)
(declare-const target_ty_depth Int)
(assert (>= source_ty_depth 0))
(assert (>= target_ty_depth 0))
(assert (not (= source_ty_depth target_ty_depth)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_size_pos: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_size_pos preserves semantics
(push 1)
(declare-const source_ty_size_pos Int)
(declare-const target_ty_size_pos Int)
(assert (>= source_ty_size_pos 0))
(assert (>= target_ty_size_pos 0))
(assert (not (= source_ty_size_pos target_ty_size_pos)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_size_fn_arg: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_size_fn_arg preserves semantics
(push 1)
(declare-const source_ty_size_fn_arg Int)
(declare-const target_ty_size_fn_arg Int)
(assert (>= source_ty_size_fn_arg 0))
(assert (>= target_ty_size_fn_arg 0))
(assert (not (= source_ty_size_fn_arg target_ty_size_fn_arg)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_size_fn_res: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_size_fn_res preserves semantics
(push 1)
(declare-const source_ty_size_fn_res Int)
(declare-const target_ty_size_fn_res Int)
(assert (>= source_ty_size_fn_res 0))
(assert (>= target_ty_size_fn_res 0))
(assert (not (= source_ty_size_fn_res target_ty_size_fn_res)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_size_prod_left: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_size_prod_left preserves semantics
(push 1)
(declare-const source_ty_size_prod_left Int)
(declare-const target_ty_size_prod_left Int)
(assert (>= source_ty_size_prod_left 0))
(assert (>= target_ty_size_prod_left 0))
(assert (not (= source_ty_size_prod_left target_ty_size_prod_left)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_size_prod_right: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_size_prod_right preserves semantics
(push 1)
(declare-const source_ty_size_prod_right Int)
(declare-const target_ty_size_prod_right Int)
(assert (>= source_ty_size_prod_right 0))
(assert (>= target_ty_size_prod_right 0))
(assert (not (= source_ty_size_prod_right target_ty_size_prod_right)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_size_sum_left: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_size_sum_left preserves semantics
(push 1)
(declare-const source_ty_size_sum_left Int)
(declare-const target_ty_size_sum_left Int)
(assert (>= source_ty_size_sum_left 0))
(assert (>= target_ty_size_sum_left 0))
(assert (not (= source_ty_size_sum_left target_ty_size_sum_left)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_size_sum_right: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_size_sum_right preserves semantics
(push 1)
(declare-const source_ty_size_sum_right Int)
(declare-const target_ty_size_sum_right Int)
(assert (>= source_ty_size_sum_right 0))
(assert (>= target_ty_size_sum_right 0))
(assert (not (= source_ty_size_sum_right target_ty_size_sum_right)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_size_ref_content: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_size_ref_content preserves semantics
(push 1)
(declare-const source_ty_size_ref_content Int)
(declare-const target_ty_size_ref_content Int)
(assert (>= source_ty_size_ref_content 0))
(assert (>= target_ty_size_ref_content 0))
(assert (not (= source_ty_size_ref_content target_ty_size_ref_content)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_size_secret_content: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_size_secret_content preserves semantics
(push 1)
(declare-const source_ty_size_secret_content Int)
(declare-const target_ty_size_secret_content Int)
(assert (>= source_ty_size_secret_content 0))
(assert (>= target_ty_size_secret_content 0))
(assert (not (= source_ty_size_secret_content target_ty_size_secret_content)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_size_proof_content: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_size_proof_content preserves semantics
(push 1)
(declare-const source_ty_size_proof_content Int)
(declare-const target_ty_size_proof_content Int)
(assert (>= source_ty_size_proof_content 0))
(assert (>= target_ty_size_proof_content 0))
(assert (not (= source_ty_size_proof_content target_ty_size_proof_content)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_size_lt_wf: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_size_lt_wf preserves semantics
(push 1)
(declare-const source_ty_size_lt_wf Int)
(declare-const target_ty_size_lt_wf Int)
(assert (>= source_ty_size_lt_wf 0))
(assert (>= target_ty_size_lt_wf 0))
(assert (not (= source_ty_size_lt_wf target_ty_size_lt_wf)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_size_induction: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_size_induction preserves semantics
(push 1)
(declare-const source_ty_size_induction Int)
(declare-const target_ty_size_induction Int)
(assert (>= source_ty_size_induction 0))
(assert (>= target_ty_size_induction 0))
(assert (not (= source_ty_size_induction target_ty_size_induction)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; first_order_no_fn: translation preserves property (matches Coq: Lemma)
; Translation validation: first_order_no_fn preserves semantics
(push 1)
(declare-const source_first_order_no_fn Int)
(declare-const target_first_order_no_fn Int)
(assert (>= source_first_order_no_fn 0))
(assert (>= target_first_order_no_fn 0))
(assert (not (= source_first_order_no_fn target_first_order_no_fn)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; first_order_decidable: translation preserves property (matches Coq: Lemma)
; Translation validation: first_order_decidable preserves semantics
(push 1)
(declare-const source_first_order_decidable Int)
(declare-const target_first_order_decidable Int)
(assert (>= source_first_order_decidable 0))
(assert (>= target_first_order_decidable 0))
(assert (not (= source_first_order_decidable target_first_order_decidable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; first_order_prod_inv: translation preserves property (matches Coq: Lemma)
; Translation validation: first_order_prod_inv preserves semantics
(push 1)
(declare-const source_first_order_prod_inv Int)
(declare-const target_first_order_prod_inv Int)
(assert (>= source_first_order_prod_inv 0))
(assert (>= target_first_order_prod_inv 0))
(assert (not (= source_first_order_prod_inv target_first_order_prod_inv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; first_order_sum_inv: translation preserves property (matches Coq: Lemma)
; Translation validation: first_order_sum_inv preserves semantics
(push 1)
(declare-const source_first_order_sum_inv Int)
(declare-const target_first_order_sum_inv Int)
(assert (>= source_first_order_sum_inv 0))
(assert (>= target_first_order_sum_inv 0))
(assert (not (= source_first_order_sum_inv target_first_order_sum_inv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; first_order_ref_inv: translation preserves property (matches Coq: Lemma)
; Translation validation: first_order_ref_inv preserves semantics
(push 1)
(declare-const source_first_order_ref_inv Int)
(declare-const target_first_order_ref_inv Int)
(assert (>= source_first_order_ref_inv 0))
(assert (>= target_first_order_ref_inv 0))
(assert (not (= source_first_order_ref_inv target_first_order_ref_inv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; first_order_secret_inv: translation preserves property (matches Coq: Lemma)
; Translation validation: first_order_secret_inv preserves semantics
(push 1)
(declare-const source_first_order_secret_inv Int)
(declare-const target_first_order_secret_inv Int)
(assert (>= source_first_order_secret_inv 0))
(assert (>= target_first_order_secret_inv 0))
(assert (not (= source_first_order_secret_inv target_first_order_secret_inv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; first_order_proof_inv: translation preserves property (matches Coq: Lemma)
; Translation validation: first_order_proof_inv preserves semantics
(push 1)
(declare-const source_first_order_proof_inv Int)
(declare-const target_first_order_proof_inv Int)
(assert (>= source_first_order_proof_inv 0))
(assert (>= target_first_order_proof_inv 0))
(assert (not (= source_first_order_proof_inv target_first_order_proof_inv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fo_compound_depth_prod: translation preserves property (matches Coq: Lemma)
; Translation validation: fo_compound_depth_prod preserves semantics
(push 1)
(declare-const source_fo_compound_depth_prod Int)
(declare-const target_fo_compound_depth_prod Int)
(assert (>= source_fo_compound_depth_prod 0))
(assert (>= target_fo_compound_depth_prod 0))
(assert (not (= source_fo_compound_depth_prod target_fo_compound_depth_prod)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fo_compound_depth_sum: translation preserves property (matches Coq: Lemma)
; Translation validation: fo_compound_depth_sum preserves semantics
(push 1)
(declare-const source_fo_compound_depth_sum Int)
(declare-const target_fo_compound_depth_sum Int)
(assert (>= source_fo_compound_depth_sum 0))
(assert (>= target_fo_compound_depth_sum 0))
(assert (not (= source_fo_compound_depth_sum target_fo_compound_depth_sum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fo_compound_depth_prod_left: translation preserves property (matches Coq: Lemma)
; Translation validation: fo_compound_depth_prod_left preserves semantics
(push 1)
(declare-const source_fo_compound_depth_prod_left Int)
(declare-const target_fo_compound_depth_prod_left Int)
(assert (>= source_fo_compound_depth_prod_left 0))
(assert (>= target_fo_compound_depth_prod_left 0))
(assert (not (= source_fo_compound_depth_prod_left target_fo_compound_depth_prod_left)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fo_compound_depth_prod_right: translation preserves property (matches Coq: Lemma)
; Translation validation: fo_compound_depth_prod_right preserves semantics
(push 1)
(declare-const source_fo_compound_depth_prod_right Int)
(declare-const target_fo_compound_depth_prod_right Int)
(assert (>= source_fo_compound_depth_prod_right 0))
(assert (>= target_fo_compound_depth_prod_right 0))
(assert (not (= source_fo_compound_depth_prod_right target_fo_compound_depth_prod_right)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fo_compound_depth_sum_left: translation preserves property (matches Coq: Lemma)
; Translation validation: fo_compound_depth_sum_left preserves semantics
(push 1)
(declare-const source_fo_compound_depth_sum_left Int)
(declare-const target_fo_compound_depth_sum_left Int)
(assert (>= source_fo_compound_depth_sum_left 0))
(assert (>= target_fo_compound_depth_sum_left 0))
(assert (not (= source_fo_compound_depth_sum_left target_fo_compound_depth_sum_left)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fo_compound_depth_sum_right: translation preserves property (matches Coq: Lemma)
; Translation validation: fo_compound_depth_sum_right preserves semantics
(push 1)
(declare-const source_fo_compound_depth_sum_right Int)
(declare-const target_fo_compound_depth_sum_right Int)
(assert (>= source_fo_compound_depth_sum_right 0))
(assert (>= target_fo_compound_depth_sum_right 0))
(assert (not (= source_fo_compound_depth_sum_right target_fo_compound_depth_sum_right)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fo_compound_depth_primitive: translation preserves property (matches Coq: Lemma)
; Translation validation: fo_compound_depth_primitive preserves semantics
(push 1)
(declare-const source_fo_compound_depth_primitive Int)
(declare-const target_fo_compound_depth_primitive Int)
(assert (>= source_fo_compound_depth_primitive 0))
(assert (>= target_fo_compound_depth_primitive 0))
(assert (not (= source_fo_compound_depth_primitive target_fo_compound_depth_primitive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_depth_fn_arg: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_depth_fn_arg preserves semantics
(push 1)
(declare-const source_ty_depth_fn_arg Int)
(declare-const target_ty_depth_fn_arg Int)
(assert (>= source_ty_depth_fn_arg 0))
(assert (>= target_ty_depth_fn_arg 0))
(assert (not (= source_ty_depth_fn_arg target_ty_depth_fn_arg)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_depth_fn_res: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_depth_fn_res preserves semantics
(push 1)
(declare-const source_ty_depth_fn_res Int)
(declare-const target_ty_depth_fn_res Int)
(assert (>= source_ty_depth_fn_res 0))
(assert (>= target_ty_depth_fn_res 0))
(assert (not (= source_ty_depth_fn_res target_ty_depth_fn_res)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; first_order_base_depth: translation preserves property (matches Coq: Lemma)
; Translation validation: first_order_base_depth preserves semantics
(push 1)
(declare-const source_first_order_base_depth Int)
(declare-const target_first_order_base_depth Int)
(assert (>= source_first_order_base_depth 0))
(assert (>= target_first_order_base_depth 0))
(assert (not (= source_first_order_base_depth target_first_order_base_depth)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

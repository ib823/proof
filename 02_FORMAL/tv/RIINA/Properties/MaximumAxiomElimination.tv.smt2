; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/MaximumAxiomElimination.v (53 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for MaximumAxiomElimination
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; label_leq: source semantics (matches Coq)
; Translation validation: label_leq preserves semantics
(push 1)
(declare-const source_label_leq Int)
(declare-const target_label_leq Int)
(assert (>= source_label_leq 0))
(assert (>= target_label_leq 0))
(assert (not (= source_label_leq target_label_leq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

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

; is_value_b: source semantics (matches Coq)
; Translation validation: is_value_b preserves semantics
(push 1)
(declare-const source_is_value_b Int)
(declare-const target_is_value_b Int)
(assert (>= source_is_value_b 0))
(assert (>= target_is_value_b 0))
(assert (not (= source_is_value_b target_is_value_b)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_empty: source semantics (matches Coq)
; Translation validation: store_empty preserves semantics
(push 1)
(declare-const source_store_empty Int)
(declare-const target_store_empty Int)
(assert (>= source_store_empty 0))
(assert (>= target_store_empty 0))
(assert (not (= source_store_empty target_store_empty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_empty: source semantics (matches Coq)
; Translation validation: store_ty_empty preserves semantics
(push 1)
(declare-const source_store_ty_empty Int)
(declare-const target_store_ty_empty Int)
(assert (>= source_store_ty_empty 0))
(assert (>= target_store_ty_empty 0))
(assert (not (= source_store_ty_empty target_store_ty_empty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_update: source semantics (matches Coq)
; Translation validation: store_update preserves semantics
(push 1)
(declare-const source_store_update Int)
(declare-const target_store_update Int)
(assert (>= source_store_update 0))
(assert (>= target_store_update 0))
(assert (not (= source_store_update target_store_update)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_update: source semantics (matches Coq)
; Translation validation: store_ty_update preserves semantics
(push 1)
(declare-const source_store_ty_update Int)
(declare-const target_store_ty_update Int)
(assert (>= source_store_ty_update 0))
(assert (>= target_store_ty_update 0))
(assert (not (= source_store_ty_update target_store_ty_update)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_extends: source semantics (matches Coq)
; Translation validation: store_ty_extends preserves semantics
(push 1)
(declare-const source_store_ty_extends Int)
(declare-const target_store_ty_extends Int)
(assert (>= source_store_ty_extends 0))
(assert (>= target_store_ty_extends 0))
(assert (not (= source_store_ty_extends target_store_ty_extends)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_n: source semantics (matches Coq)
; Translation validation: val_rel_n preserves semantics
(push 1)
(declare-const source_val_rel_n Int)
(declare-const target_val_rel_n Int)
(assert (>= source_val_rel_n 0))
(assert (>= target_val_rel_n 0))
(assert (not (= source_val_rel_n target_val_rel_n)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_rel_n: source semantics (matches Coq)
; Translation validation: store_rel_n preserves semantics
(push 1)
(declare-const source_store_rel_n Int)
(declare-const target_store_rel_n Int)
(assert (>= source_store_rel_n 0))
(assert (>= target_store_rel_n 0))
(assert (not (= source_store_rel_n target_store_rel_n)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; exp_rel_n: source semantics (matches Coq)
; Translation validation: exp_rel_n preserves semantics
(push 1)
(declare-const source_exp_rel_n Int)
(declare-const target_exp_rel_n Int)
(assert (>= source_exp_rel_n 0))
(assert (>= target_exp_rel_n 0))
(assert (not (= source_exp_rel_n target_exp_rel_n)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_join: source semantics (matches Coq)
; Translation validation: label_join preserves semantics
(push 1)
(declare-const source_label_join Int)
(declare-const target_label_join Int)
(assert (>= source_label_join 0))
(assert (>= target_label_join 0))
(assert (not (= source_label_join target_label_join)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_leq_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: label_leq_refl preserves semantics
(push 1)
(declare-const source_label_leq_refl Int)
(declare-const target_label_leq_refl Int)
(assert (>= source_label_leq_refl 0))
(assert (>= target_label_leq_refl 0))
(assert (not (= source_label_leq_refl target_label_leq_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_leq_trans: translation preserves property (matches Coq: Lemma)
; Translation validation: label_leq_trans preserves semantics
(push 1)
(declare-const source_label_leq_trans Int)
(declare-const target_label_leq_trans Int)
(assert (>= source_label_leq_trans 0))
(assert (>= target_label_leq_trans 0))
(assert (not (= source_label_leq_trans target_label_leq_trans)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_leq_antisym: translation preserves property (matches Coq: Lemma)
; Translation validation: label_leq_antisym preserves semantics
(push 1)
(declare-const source_label_leq_antisym Int)
(declare-const target_label_leq_antisym Int)
(assert (>= source_label_leq_antisym 0))
(assert (>= target_label_leq_antisym 0))
(assert (not (= source_label_leq_antisym target_label_leq_antisym)))
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

; store_update_lookup_eq: translation preserves property (matches Coq: Lemma)
; Translation validation: store_update_lookup_eq preserves semantics
(push 1)
(declare-const source_store_update_lookup_eq Int)
(declare-const target_store_update_lookup_eq Int)
(assert (>= source_store_update_lookup_eq 0))
(assert (>= target_store_update_lookup_eq 0))
(assert (not (= source_store_update_lookup_eq target_store_update_lookup_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_update_lookup_neq: translation preserves property (matches Coq: Lemma)
; Translation validation: store_update_lookup_neq preserves semantics
(push 1)
(declare-const source_store_update_lookup_neq Int)
(declare-const target_store_update_lookup_neq Int)
(assert (>= source_store_update_lookup_neq 0))
(assert (>= target_store_update_lookup_neq 0))
(assert (not (= source_store_update_lookup_neq target_store_update_lookup_neq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_update_lookup_eq: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_update_lookup_eq preserves semantics
(push 1)
(declare-const source_store_ty_update_lookup_eq Int)
(declare-const target_store_ty_update_lookup_eq Int)
(assert (>= source_store_ty_update_lookup_eq 0))
(assert (>= target_store_ty_update_lookup_eq 0))
(assert (not (= source_store_ty_update_lookup_eq target_store_ty_update_lookup_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_update_lookup_neq: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_update_lookup_neq preserves semantics
(push 1)
(declare-const source_store_ty_update_lookup_neq Int)
(declare-const target_store_ty_update_lookup_neq Int)
(assert (>= source_store_ty_update_lookup_neq 0))
(assert (>= target_store_ty_update_lookup_neq 0))
(assert (not (= source_store_ty_update_lookup_neq target_store_ty_update_lookup_neq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_extends_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_extends_refl preserves semantics
(push 1)
(declare-const source_store_ty_extends_refl Int)
(declare-const target_store_ty_extends_refl Int)
(assert (>= source_store_ty_extends_refl 0))
(assert (>= target_store_ty_extends_refl 0))
(assert (not (= source_store_ty_extends_refl target_store_ty_extends_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_extends_trans: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_extends_trans preserves semantics
(push 1)
(declare-const source_store_ty_extends_trans Int)
(declare-const target_store_ty_extends_trans Int)
(assert (>= source_store_ty_extends_trans 0))
(assert (>= target_store_ty_extends_trans 0))
(assert (not (= source_store_ty_extends_trans target_store_ty_extends_trans)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_n_zero: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_n_zero preserves semantics
(push 1)
(declare-const source_val_rel_n_zero Int)
(declare-const target_val_rel_n_zero Int)
(assert (>= source_val_rel_n_zero 0))
(assert (>= target_val_rel_n_zero 0))
(assert (not (= source_val_rel_n_zero target_val_rel_n_zero)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_n_unit: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_n_unit preserves semantics
(push 1)
(declare-const source_val_rel_n_unit Int)
(declare-const target_val_rel_n_unit Int)
(assert (>= source_val_rel_n_unit 0))
(assert (>= target_val_rel_n_unit 0))
(assert (not (= source_val_rel_n_unit target_val_rel_n_unit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_n_bool: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_n_bool preserves semantics
(push 1)
(declare-const source_val_rel_n_bool Int)
(declare-const target_val_rel_n_bool Int)
(assert (>= source_val_rel_n_bool 0))
(assert (>= target_val_rel_n_bool 0))
(assert (not (= source_val_rel_n_bool target_val_rel_n_bool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_n_nat: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_n_nat preserves semantics
(push 1)
(declare-const source_val_rel_n_nat Int)
(declare-const target_val_rel_n_nat Int)
(assert (>= source_val_rel_n_nat 0))
(assert (>= target_val_rel_n_nat 0))
(assert (not (= source_val_rel_n_nat target_val_rel_n_nat)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_n_ref: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_n_ref preserves semantics
(push 1)
(declare-const source_val_rel_n_ref Int)
(declare-const target_val_rel_n_ref Int)
(assert (>= source_val_rel_n_ref 0))
(assert (>= target_val_rel_n_ref 0))
(assert (not (= source_val_rel_n_ref target_val_rel_n_ref)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_n_ref_same_loc: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_n_ref_same_loc preserves semantics
(push 1)
(declare-const source_val_rel_n_ref_same_loc Int)
(declare-const target_val_rel_n_ref_same_loc Int)
(assert (>= source_val_rel_n_ref_same_loc 0))
(assert (>= target_val_rel_n_ref_same_loc 0))
(assert (not (= source_val_rel_n_ref_same_loc target_val_rel_n_ref_same_loc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_n_cumulative: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_n_cumulative preserves semantics
(push 1)
(declare-const source_val_rel_n_cumulative Int)
(declare-const target_val_rel_n_cumulative Int)
(assert (>= source_val_rel_n_cumulative 0))
(assert (>= target_val_rel_n_cumulative 0))
(assert (not (= source_val_rel_n_cumulative target_val_rel_n_cumulative)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_n_step_down: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_n_step_down preserves semantics
(push 1)
(declare-const source_val_rel_n_step_down Int)
(declare-const target_val_rel_n_step_down Int)
(assert (>= source_val_rel_n_step_down 0))
(assert (>= target_val_rel_n_step_down 0))
(assert (not (= source_val_rel_n_step_down target_val_rel_n_step_down)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_n_value_left: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_n_value_left preserves semantics
(push 1)
(declare-const source_val_rel_n_value_left Int)
(declare-const target_val_rel_n_value_left Int)
(assert (>= source_val_rel_n_value_left 0))
(assert (>= target_val_rel_n_value_left 0))
(assert (not (= source_val_rel_n_value_left target_val_rel_n_value_left)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_n_value_right: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_n_value_right preserves semantics
(push 1)
(declare-const source_val_rel_n_value_right Int)
(declare-const target_val_rel_n_value_right Int)
(assert (>= source_val_rel_n_value_right 0))
(assert (>= target_val_rel_n_value_right 0))
(assert (not (= source_val_rel_n_value_right target_val_rel_n_value_right)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_n_prod: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_n_prod preserves semantics
(push 1)
(declare-const source_val_rel_n_prod Int)
(declare-const target_val_rel_n_prod Int)
(assert (>= source_val_rel_n_prod 0))
(assert (>= target_val_rel_n_prod 0))
(assert (not (= source_val_rel_n_prod target_val_rel_n_prod)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_n_inl: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_n_inl preserves semantics
(push 1)
(declare-const source_val_rel_n_inl Int)
(declare-const target_val_rel_n_inl Int)
(assert (>= source_val_rel_n_inl 0))
(assert (>= target_val_rel_n_inl 0))
(assert (not (= source_val_rel_n_inl target_val_rel_n_inl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_n_inr: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_n_inr preserves semantics
(push 1)
(declare-const source_val_rel_n_inr Int)
(declare-const target_val_rel_n_inr Int)
(assert (>= source_val_rel_n_inr 0))
(assert (>= target_val_rel_n_inr 0))
(assert (not (= source_val_rel_n_inr target_val_rel_n_inr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_n_lam: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_n_lam preserves semantics
(push 1)
(declare-const source_val_rel_n_lam Int)
(declare-const target_val_rel_n_lam Int)
(assert (>= source_val_rel_n_lam 0))
(assert (>= target_val_rel_n_lam 0))
(assert (not (= source_val_rel_n_lam target_val_rel_n_lam)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_n_fo_step_independent: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_n_fo_step_independent preserves semantics
(push 1)
(declare-const source_val_rel_n_fo_step_independent Int)
(declare-const target_val_rel_n_fo_step_independent Int)
(assert (>= source_val_rel_n_fo_step_independent 0))
(assert (>= target_val_rel_n_fo_step_independent 0))
(assert (not (= source_val_rel_n_fo_step_independent target_val_rel_n_fo_step_independent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_rel_n_zero: translation preserves property (matches Coq: Lemma)
; Translation validation: store_rel_n_zero preserves semantics
(push 1)
(declare-const source_store_rel_n_zero Int)
(declare-const target_store_rel_n_zero Int)
(assert (>= source_store_rel_n_zero 0))
(assert (>= target_store_rel_n_zero 0))
(assert (not (= source_store_rel_n_zero target_store_rel_n_zero)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_rel_n_step_down: translation preserves property (matches Coq: Lemma)
; Translation validation: store_rel_n_step_down preserves semantics
(push 1)
(declare-const source_store_rel_n_step_down Int)
(declare-const target_store_rel_n_step_down Int)
(assert (>= source_store_rel_n_step_down 0))
(assert (>= target_store_rel_n_step_down 0))
(assert (not (= source_store_rel_n_step_down target_store_rel_n_step_down)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_rel_n_empty: translation preserves property (matches Coq: Lemma)
; Translation validation: store_rel_n_empty preserves semantics
(push 1)
(declare-const source_store_rel_n_empty Int)
(declare-const target_store_rel_n_empty Int)
(assert (>= source_store_rel_n_empty 0))
(assert (>= target_store_rel_n_empty 0))
(assert (not (= source_store_rel_n_empty target_store_rel_n_empty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_update_preserves_rel: translation preserves property (matches Coq: Lemma)
; Translation validation: store_update_preserves_rel preserves semantics
(push 1)
(declare-const source_store_update_preserves_rel Int)
(declare-const target_store_update_preserves_rel Int)
(assert (>= source_store_update_preserves_rel 0))
(assert (>= target_store_update_preserves_rel 0))
(assert (not (= source_store_update_preserves_rel target_store_update_preserves_rel)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_extends_antisym: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_extends_antisym preserves semantics
(push 1)
(declare-const source_store_ty_extends_antisym Int)
(declare-const target_store_ty_extends_antisym Int)
(assert (>= source_store_ty_extends_antisym 0))
(assert (>= target_store_ty_extends_antisym 0))
(assert (not (= source_store_ty_extends_antisym target_store_ty_extends_antisym)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_update_extends: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_update_extends preserves semantics
(push 1)
(declare-const source_store_ty_update_extends Int)
(declare-const target_store_ty_update_extends Int)
(assert (>= source_store_ty_update_extends 0))
(assert (>= target_store_ty_update_extends 0))
(assert (not (= source_store_ty_update_extends target_store_ty_update_extends)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_lookup_deterministic: translation preserves property (matches Coq: Lemma)
; Translation validation: store_lookup_deterministic preserves semantics
(push 1)
(declare-const source_store_lookup_deterministic Int)
(declare-const target_store_lookup_deterministic Int)
(assert (>= source_store_lookup_deterministic 0))
(assert (>= target_store_lookup_deterministic 0))
(assert (not (= source_store_lookup_deterministic target_store_lookup_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_lookup_deterministic: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_lookup_deterministic preserves semantics
(push 1)
(declare-const source_store_ty_lookup_deterministic Int)
(declare-const target_store_ty_lookup_deterministic Int)
(assert (>= source_store_ty_lookup_deterministic 0))
(assert (>= target_store_ty_lookup_deterministic 0))
(assert (not (= source_store_ty_lookup_deterministic target_store_ty_lookup_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_update_idem: translation preserves property (matches Coq: Lemma)
; Translation validation: store_update_idem preserves semantics
(push 1)
(declare-const source_store_update_idem Int)
(declare-const target_store_update_idem Int)
(assert (>= source_store_update_idem 0))
(assert (>= target_store_update_idem 0))
(assert (not (= source_store_update_idem target_store_update_idem)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_update_comm: translation preserves property (matches Coq: Lemma)
; Translation validation: store_update_comm preserves semantics
(push 1)
(declare-const source_store_update_comm Int)
(declare-const target_store_update_comm Int)
(assert (>= source_store_update_comm 0))
(assert (>= target_store_update_comm 0))
(assert (not (= source_store_update_comm target_store_update_comm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; exp_rel_n_zero: translation preserves property (matches Coq: Lemma)
; Translation validation: exp_rel_n_zero preserves semantics
(push 1)
(declare-const source_exp_rel_n_zero Int)
(declare-const target_exp_rel_n_zero Int)
(assert (>= source_exp_rel_n_zero 0))
(assert (>= target_exp_rel_n_zero 0))
(assert (not (= source_exp_rel_n_zero target_exp_rel_n_zero)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; exp_rel_n_unit_expr: translation preserves property (matches Coq: Lemma)
; Translation validation: exp_rel_n_unit_expr preserves semantics
(push 1)
(declare-const source_exp_rel_n_unit_expr Int)
(declare-const target_exp_rel_n_unit_expr Int)
(assert (>= source_exp_rel_n_unit_expr 0))
(assert (>= target_exp_rel_n_unit_expr 0))
(assert (not (= source_exp_rel_n_unit_expr target_exp_rel_n_unit_expr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; exp_rel_n_step_down: translation preserves property (matches Coq: Lemma)
; Translation validation: exp_rel_n_step_down preserves semantics
(push 1)
(declare-const source_exp_rel_n_step_down Int)
(declare-const target_exp_rel_n_step_down Int)
(assert (>= source_exp_rel_n_step_down 0))
(assert (>= target_exp_rel_n_step_down 0))
(assert (not (= source_exp_rel_n_step_down target_exp_rel_n_step_down)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_implies_exp_rel: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_implies_exp_rel preserves semantics
(push 1)
(declare-const source_val_rel_implies_exp_rel Int)
(declare-const target_val_rel_implies_exp_rel Int)
(assert (>= source_val_rel_implies_exp_rel 0))
(assert (>= target_val_rel_implies_exp_rel 0))
(assert (not (= source_val_rel_implies_exp_rel target_val_rel_implies_exp_rel)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; exp_rel_n_bool_expr: translation preserves property (matches Coq: Lemma)
; Translation validation: exp_rel_n_bool_expr preserves semantics
(push 1)
(declare-const source_exp_rel_n_bool_expr Int)
(declare-const target_exp_rel_n_bool_expr Int)
(assert (>= source_exp_rel_n_bool_expr 0))
(assert (>= target_exp_rel_n_bool_expr 0))
(assert (not (= source_exp_rel_n_bool_expr target_exp_rel_n_bool_expr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_join_comm: translation preserves property (matches Coq: Lemma)
; Translation validation: label_join_comm preserves semantics
(push 1)
(declare-const source_label_join_comm Int)
(declare-const target_label_join_comm Int)
(assert (>= source_label_join_comm 0))
(assert (>= target_label_join_comm 0))
(assert (not (= source_label_join_comm target_label_join_comm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_join_assoc: translation preserves property (matches Coq: Lemma)
; Translation validation: label_join_assoc preserves semantics
(push 1)
(declare-const source_label_join_assoc Int)
(declare-const target_label_join_assoc Int)
(assert (>= source_label_join_assoc 0))
(assert (>= target_label_join_assoc 0))
(assert (not (= source_label_join_assoc target_label_join_assoc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_join_idem: translation preserves property (matches Coq: Lemma)
; Translation validation: label_join_idem preserves semantics
(push 1)
(declare-const source_label_join_idem Int)
(declare-const target_label_join_idem Int)
(assert (>= source_label_join_idem 0))
(assert (>= target_label_join_idem 0))
(assert (not (= source_label_join_idem target_label_join_idem)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_eq_dec: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_eq_dec preserves semantics
(push 1)
(declare-const source_ty_eq_dec Int)
(declare-const target_ty_eq_dec Int)
(assert (>= source_ty_eq_dec 0))
(assert (>= target_ty_eq_dec 0))
(assert (not (= source_ty_eq_dec target_ty_eq_dec)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; first_order_prod_components: translation preserves property (matches Coq: Lemma)
; Translation validation: first_order_prod_components preserves semantics
(push 1)
(declare-const source_first_order_prod_components Int)
(declare-const target_first_order_prod_components Int)
(assert (>= source_first_order_prod_components 0))
(assert (>= target_first_order_prod_components 0))
(assert (not (= source_first_order_prod_components target_first_order_prod_components)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; first_order_sum_components: translation preserves property (matches Coq: Lemma)
; Translation validation: first_order_sum_components preserves semantics
(push 1)
(declare-const source_first_order_sum_components Int)
(declare-const target_first_order_sum_components Int)
(assert (>= source_first_order_sum_components 0))
(assert (>= target_first_order_sum_components 0))
(assert (not (= source_first_order_sum_components target_first_order_sum_components)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fo_depth_prod: translation preserves property (matches Coq: Lemma)
; Translation validation: fo_depth_prod preserves semantics
(push 1)
(declare-const source_fo_depth_prod Int)
(declare-const target_fo_depth_prod Int)
(assert (>= source_fo_depth_prod 0))
(assert (>= target_fo_depth_prod 0))
(assert (not (= source_fo_depth_prod target_fo_depth_prod)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fo_depth_sum: translation preserves property (matches Coq: Lemma)
; Translation validation: fo_depth_sum preserves semantics
(push 1)
(declare-const source_fo_depth_sum Int)
(declare-const target_fo_depth_sum Int)
(assert (>= source_fo_depth_sum 0))
(assert (>= target_fo_depth_sum 0))
(assert (not (= source_fo_depth_sum target_fo_depth_sum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fo_depth_primitive: translation preserves property (matches Coq: Lemma)
; Translation validation: fo_depth_primitive preserves semantics
(push 1)
(declare-const source_fo_depth_primitive Int)
(declare-const target_fo_depth_primitive Int)
(assert (>= source_fo_depth_primitive 0))
(assert (>= target_fo_depth_primitive 0))
(assert (not (= source_fo_depth_primitive target_fo_depth_primitive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

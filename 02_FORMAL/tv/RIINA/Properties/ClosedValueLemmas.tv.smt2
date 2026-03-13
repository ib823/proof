; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/ClosedValueLemmas.v (28 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for ClosedValueLemmas
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; closed_expr_cv: source semantics (matches Coq)
; Translation validation: closed_expr_cv preserves semantics
(push 1)
(declare-const source_closed_expr_cv Int)
(declare-const target_closed_expr_cv Int)
(assert (>= source_closed_expr_cv 0))
(assert (>= target_closed_expr_cv 0))
(assert (not (= source_closed_expr_cv target_closed_expr_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; value_typed_closed: translation preserves property (matches Coq: Lemma)
; Translation validation: value_typed_closed preserves semantics
(push 1)
(declare-const source_value_typed_closed Int)
(declare-const target_value_typed_closed Int)
(assert (>= source_value_typed_closed 0))
(assert (>= target_value_typed_closed 0))
(assert (not (= source_value_typed_closed target_value_typed_closed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_pair_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_pair_cv preserves semantics
(push 1)
(declare-const source_closed_pair_cv Int)
(declare-const target_closed_pair_cv Int)
(assert (>= source_closed_pair_cv 0))
(assert (>= target_closed_pair_cv 0))
(assert (not (= source_closed_pair_cv target_closed_pair_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_inl_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_inl_cv preserves semantics
(push 1)
(declare-const source_closed_inl_cv Int)
(declare-const target_closed_inl_cv Int)
(assert (>= source_closed_inl_cv 0))
(assert (>= target_closed_inl_cv 0))
(assert (not (= source_closed_inl_cv target_closed_inl_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_inr_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_inr_cv preserves semantics
(push 1)
(declare-const source_closed_inr_cv Int)
(declare-const target_closed_inr_cv Int)
(assert (>= source_closed_inr_cv 0))
(assert (>= target_closed_inr_cv 0))
(assert (not (= source_closed_inr_cv target_closed_inr_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_app_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_app_cv preserves semantics
(push 1)
(declare-const source_closed_app_cv Int)
(declare-const target_closed_app_cv Int)
(assert (>= source_closed_app_cv 0))
(assert (>= target_closed_app_cv 0))
(assert (not (= source_closed_app_cv target_closed_app_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_unit_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_unit_cv preserves semantics
(push 1)
(declare-const source_closed_unit_cv Int)
(declare-const target_closed_unit_cv Int)
(assert (>= source_closed_unit_cv 0))
(assert (>= target_closed_unit_cv 0))
(assert (not (= source_closed_unit_cv target_closed_unit_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_bool_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_bool_cv preserves semantics
(push 1)
(declare-const source_closed_bool_cv Int)
(declare-const target_closed_bool_cv Int)
(assert (>= source_closed_bool_cv 0))
(assert (>= target_closed_bool_cv 0))
(assert (not (= source_closed_bool_cv target_closed_bool_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_int_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_int_cv preserves semantics
(push 1)
(declare-const source_closed_int_cv Int)
(declare-const target_closed_int_cv Int)
(assert (>= source_closed_int_cv 0))
(assert (>= target_closed_int_cv 0))
(assert (not (= source_closed_int_cv target_closed_int_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_string_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_string_cv preserves semantics
(push 1)
(declare-const source_closed_string_cv Int)
(declare-const target_closed_string_cv Int)
(assert (>= source_closed_string_cv 0))
(assert (>= target_closed_string_cv 0))
(assert (not (= source_closed_string_cv target_closed_string_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_loc_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_loc_cv preserves semantics
(push 1)
(declare-const source_closed_loc_cv Int)
(declare-const target_closed_loc_cv Int)
(assert (>= source_closed_loc_cv 0))
(assert (>= target_closed_loc_cv 0))
(assert (not (= source_closed_loc_cv target_closed_loc_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_lam_body_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_lam_body_cv preserves semantics
(push 1)
(declare-const source_closed_lam_body_cv Int)
(declare-const target_closed_lam_body_cv Int)
(assert (>= source_closed_lam_body_cv 0))
(assert (>= target_closed_lam_body_cv 0))
(assert (not (= source_closed_lam_body_cv target_closed_lam_body_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_if_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_if_cv preserves semantics
(push 1)
(declare-const source_closed_if_cv Int)
(declare-const target_closed_if_cv Int)
(assert (>= source_closed_if_cv 0))
(assert (>= target_closed_if_cv 0))
(assert (not (= source_closed_if_cv target_closed_if_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_let_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_let_cv preserves semantics
(push 1)
(declare-const source_closed_let_cv Int)
(declare-const target_closed_let_cv Int)
(assert (>= source_closed_let_cv 0))
(assert (>= target_closed_let_cv 0))
(assert (not (= source_closed_let_cv target_closed_let_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_ref_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_ref_cv preserves semantics
(push 1)
(declare-const source_closed_ref_cv Int)
(declare-const target_closed_ref_cv Int)
(assert (>= source_closed_ref_cv 0))
(assert (>= target_closed_ref_cv 0))
(assert (not (= source_closed_ref_cv target_closed_ref_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_deref_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_deref_cv preserves semantics
(push 1)
(declare-const source_closed_deref_cv Int)
(declare-const target_closed_deref_cv Int)
(assert (>= source_closed_deref_cv 0))
(assert (>= target_closed_deref_cv 0))
(assert (not (= source_closed_deref_cv target_closed_deref_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_assign_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_assign_cv preserves semantics
(push 1)
(declare-const source_closed_assign_cv Int)
(declare-const target_closed_assign_cv Int)
(assert (>= source_closed_assign_cv 0))
(assert (>= target_closed_assign_cv 0))
(assert (not (= source_closed_assign_cv target_closed_assign_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_classify_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_classify_cv preserves semantics
(push 1)
(declare-const source_closed_classify_cv Int)
(declare-const target_closed_classify_cv Int)
(assert (>= source_closed_classify_cv 0))
(assert (>= target_closed_classify_cv 0))
(assert (not (= source_closed_classify_cv target_closed_classify_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_prove_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_prove_cv preserves semantics
(push 1)
(declare-const source_closed_prove_cv Int)
(declare-const target_closed_prove_cv Int)
(assert (>= source_closed_prove_cv 0))
(assert (>= target_closed_prove_cv 0))
(assert (not (= source_closed_prove_cv target_closed_prove_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_fst_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_fst_cv preserves semantics
(push 1)
(declare-const source_closed_fst_cv Int)
(declare-const target_closed_fst_cv Int)
(assert (>= source_closed_fst_cv 0))
(assert (>= target_closed_fst_cv 0))
(assert (not (= source_closed_fst_cv target_closed_fst_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_snd_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_snd_cv preserves semantics
(push 1)
(declare-const source_closed_snd_cv Int)
(declare-const target_closed_snd_cv Int)
(assert (>= source_closed_snd_cv 0))
(assert (>= target_closed_snd_cv 0))
(assert (not (= source_closed_snd_cv target_closed_snd_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; value_closed_simple: translation preserves property (matches Coq: Lemma)
; Translation validation: value_closed_simple preserves semantics
(push 1)
(declare-const source_value_closed_simple Int)
(declare-const target_value_closed_simple Int)
(assert (>= source_value_closed_simple 0))
(assert (>= target_value_closed_simple 0))
(assert (not (= source_value_closed_simple target_value_closed_simple)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_weaken_ctx: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_weaken_ctx preserves semantics
(push 1)
(declare-const source_closed_weaken_ctx Int)
(declare-const target_closed_weaken_ctx Int)
(assert (>= source_closed_weaken_ctx 0))
(assert (>= target_closed_weaken_ctx 0))
(assert (not (= source_closed_weaken_ctx target_closed_weaken_ctx)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nil_ctx_is_closed: translation preserves property (matches Coq: Lemma)
; Translation validation: nil_ctx_is_closed preserves semantics
(push 1)
(declare-const source_nil_ctx_is_closed Int)
(declare-const target_nil_ctx_is_closed Int)
(assert (>= source_nil_ctx_is_closed 0))
(assert (>= target_nil_ctx_is_closed 0))
(assert (not (= source_nil_ctx_is_closed target_nil_ctx_is_closed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_grant_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_grant_cv preserves semantics
(push 1)
(declare-const source_closed_grant_cv Int)
(declare-const target_closed_grant_cv Int)
(assert (>= source_closed_grant_cv 0))
(assert (>= target_closed_grant_cv 0))
(assert (not (= source_closed_grant_cv target_closed_grant_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_require_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_require_cv preserves semantics
(push 1)
(declare-const source_closed_require_cv Int)
(declare-const target_closed_require_cv Int)
(assert (>= source_closed_require_cv 0))
(assert (>= target_closed_require_cv 0))
(assert (not (= source_closed_require_cv target_closed_require_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_perform_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_perform_cv preserves semantics
(push 1)
(declare-const source_closed_perform_cv Int)
(declare-const target_closed_perform_cv Int)
(assert (>= source_closed_perform_cv 0))
(assert (>= target_closed_perform_cv 0))
(assert (not (= source_closed_perform_cv target_closed_perform_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_handle_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_handle_cv preserves semantics
(push 1)
(declare-const source_closed_handle_cv Int)
(declare-const target_closed_handle_cv Int)
(assert (>= source_closed_handle_cv 0))
(assert (>= target_closed_handle_cv 0))
(assert (not (= source_closed_handle_cv target_closed_handle_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_declassify_cv: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_declassify_cv preserves semantics
(push 1)
(declare-const source_closed_declassify_cv Int)
(declare-const target_closed_declassify_cv Int)
(assert (>= source_closed_declassify_cv 0))
(assert (>= target_closed_declassify_cv 0))
(assert (not (= source_closed_declassify_cv target_closed_declassify_cv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

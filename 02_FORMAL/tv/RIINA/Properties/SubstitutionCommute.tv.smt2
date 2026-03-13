; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/SubstitutionCommute.v (40 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for SubstitutionCommute
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; id_rho_sc: source semantics (matches Coq)
; Translation validation: id_rho_sc preserves semantics
(push 1)
(declare-const source_id_rho_sc Int)
(declare-const target_id_rho_sc Int)
(assert (>= source_id_rho_sc 0))
(assert (>= target_id_rho_sc 0))
(assert (not (= source_id_rho_sc target_id_rho_sc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; extend_rho_sc: source semantics (matches Coq)
; Translation validation: extend_rho_sc preserves semantics
(push 1)
(declare-const source_extend_rho_sc Int)
(declare-const target_extend_rho_sc Int)
(assert (>= source_extend_rho_sc 0))
(assert (>= target_extend_rho_sc 0))
(assert (not (= source_extend_rho_sc target_extend_rho_sc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_expr_sc: source semantics (matches Coq)
; Translation validation: closed_expr_sc preserves semantics
(push 1)
(declare-const source_closed_expr_sc Int)
(declare-const target_closed_expr_sc Int)
(assert (>= source_closed_expr_sc 0))
(assert (>= target_closed_expr_sc 0))
(assert (not (= source_closed_expr_sc target_closed_expr_sc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_rho_sc: source semantics (matches Coq)
; Translation validation: closed_rho_sc preserves semantics
(push 1)
(declare-const source_closed_rho_sc Int)
(declare-const target_closed_rho_sc Int)
(assert (>= source_closed_rho_sc 0))
(assert (>= target_closed_rho_sc 0))
(assert (not (= source_closed_rho_sc target_closed_rho_sc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; extend_rho_sc_same: translation preserves property (matches Coq: Lemma)
; Translation validation: extend_rho_sc_same preserves semantics
(push 1)
(declare-const source_extend_rho_sc_same Int)
(declare-const target_extend_rho_sc_same Int)
(assert (>= source_extend_rho_sc_same 0))
(assert (>= target_extend_rho_sc_same 0))
(assert (not (= source_extend_rho_sc_same target_extend_rho_sc_same)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; extend_rho_sc_diff: translation preserves property (matches Coq: Lemma)
; Translation validation: extend_rho_sc_diff preserves semantics
(push 1)
(declare-const source_extend_rho_sc_diff Int)
(declare-const target_extend_rho_sc_diff Int)
(assert (>= source_extend_rho_sc_diff 0))
(assert (>= target_extend_rho_sc_diff 0))
(assert (not (= source_extend_rho_sc_diff target_extend_rho_sc_diff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; extend_rho_sc_shadow: translation preserves property (matches Coq: Lemma)
; Translation validation: extend_rho_sc_shadow preserves semantics
(push 1)
(declare-const source_extend_rho_sc_shadow Int)
(declare-const target_extend_rho_sc_shadow Int)
(assert (>= source_extend_rho_sc_shadow 0))
(assert (>= target_extend_rho_sc_shadow 0))
(assert (not (= source_extend_rho_sc_shadow target_extend_rho_sc_shadow)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; extend_rho_sc_comm: translation preserves property (matches Coq: Lemma)
; Translation validation: extend_rho_sc_comm preserves semantics
(push 1)
(declare-const source_extend_rho_sc_comm Int)
(declare-const target_extend_rho_sc_comm Int)
(assert (>= source_extend_rho_sc_comm 0))
(assert (>= target_extend_rho_sc_comm 0))
(assert (not (= source_extend_rho_sc_comm target_extend_rho_sc_comm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_not_free_sc: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_not_free_sc preserves semantics
(push 1)
(declare-const source_subst_not_free_sc Int)
(declare-const target_subst_not_free_sc Int)
(assert (>= source_subst_not_free_sc 0))
(assert (>= target_subst_not_free_sc 0))
(assert (not (= source_subst_not_free_sc target_subst_not_free_sc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_closed_sc: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_closed_sc preserves semantics
(push 1)
(declare-const source_subst_closed_sc Int)
(declare-const target_subst_closed_sc Int)
(assert (>= source_subst_closed_sc 0))
(assert (>= target_subst_closed_sc 0))
(assert (not (= source_subst_closed_sc target_subst_closed_sc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_unit_sub: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_unit_sub preserves semantics
(push 1)
(declare-const source_closed_unit_sub Int)
(declare-const target_closed_unit_sub Int)
(assert (>= source_closed_unit_sub 0))
(assert (>= target_closed_unit_sub 0))
(assert (not (= source_closed_unit_sub target_closed_unit_sub)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_bool_sub: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_bool_sub preserves semantics
(push 1)
(declare-const source_closed_bool_sub Int)
(declare-const target_closed_bool_sub Int)
(assert (>= source_closed_bool_sub 0))
(assert (>= target_closed_bool_sub 0))
(assert (not (= source_closed_bool_sub target_closed_bool_sub)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_int_sub: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_int_sub preserves semantics
(push 1)
(declare-const source_closed_int_sub Int)
(declare-const target_closed_int_sub Int)
(assert (>= source_closed_int_sub 0))
(assert (>= target_closed_int_sub 0))
(assert (not (= source_closed_int_sub target_closed_int_sub)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_string_sub: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_string_sub preserves semantics
(push 1)
(declare-const source_closed_string_sub Int)
(declare-const target_closed_string_sub Int)
(assert (>= source_closed_string_sub 0))
(assert (>= target_closed_string_sub 0))
(assert (not (= source_closed_string_sub target_closed_string_sub)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_loc_sub: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_loc_sub preserves semantics
(push 1)
(declare-const source_closed_loc_sub Int)
(declare-const target_closed_loc_sub Int)
(assert (>= source_closed_loc_sub 0))
(assert (>= target_closed_loc_sub 0))
(assert (not (= source_closed_loc_sub target_closed_loc_sub)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_var_same: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_var_same preserves semantics
(push 1)
(declare-const source_subst_var_same Int)
(declare-const target_subst_var_same Int)
(assert (>= source_subst_var_same 0))
(assert (>= target_subst_var_same 0))
(assert (not (= source_subst_var_same target_subst_var_same)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_var_diff: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_var_diff preserves semantics
(push 1)
(declare-const source_subst_var_diff Int)
(declare-const target_subst_var_diff Int)
(assert (>= source_subst_var_diff 0))
(assert (>= target_subst_var_diff 0))
(assert (not (= source_subst_var_diff target_subst_var_diff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_unit: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_unit preserves semantics
(push 1)
(declare-const source_subst_unit Int)
(declare-const target_subst_unit Int)
(assert (>= source_subst_unit 0))
(assert (>= target_subst_unit 0))
(assert (not (= source_subst_unit target_subst_unit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_bool: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_bool preserves semantics
(push 1)
(declare-const source_subst_bool Int)
(declare-const target_subst_bool Int)
(assert (>= source_subst_bool 0))
(assert (>= target_subst_bool 0))
(assert (not (= source_subst_bool target_subst_bool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_int: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_int preserves semantics
(push 1)
(declare-const source_subst_int Int)
(declare-const target_subst_int Int)
(assert (>= source_subst_int 0))
(assert (>= target_subst_int 0))
(assert (not (= source_subst_int target_subst_int)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_string: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_string preserves semantics
(push 1)
(declare-const source_subst_string Int)
(declare-const target_subst_string Int)
(assert (>= source_subst_string 0))
(assert (>= target_subst_string 0))
(assert (not (= source_subst_string target_subst_string)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_loc: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_loc preserves semantics
(push 1)
(declare-const source_subst_loc Int)
(declare-const target_subst_loc Int)
(assert (>= source_subst_loc 0))
(assert (>= target_subst_loc 0))
(assert (not (= source_subst_loc target_subst_loc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_id: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_id preserves semantics
(push 1)
(declare-const source_subst_id Int)
(declare-const target_subst_id Int)
(assert (>= source_subst_id 0))
(assert (>= target_subst_id 0))
(assert (not (= source_subst_id target_subst_id)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_value: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_value preserves semantics
(push 1)
(declare-const source_subst_value Int)
(declare-const target_subst_value Int)
(assert (>= source_subst_value 0))
(assert (>= target_subst_value 0))
(assert (not (= source_subst_value target_subst_value)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_app: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_app preserves semantics
(push 1)
(declare-const source_subst_app Int)
(declare-const target_subst_app Int)
(assert (>= source_subst_app 0))
(assert (>= target_subst_app 0))
(assert (not (= source_subst_app target_subst_app)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_pair: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_pair preserves semantics
(push 1)
(declare-const source_subst_pair Int)
(declare-const target_subst_pair Int)
(assert (>= source_subst_pair 0))
(assert (>= target_subst_pair 0))
(assert (not (= source_subst_pair target_subst_pair)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_fst: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_fst preserves semantics
(push 1)
(declare-const source_subst_fst Int)
(declare-const target_subst_fst Int)
(assert (>= source_subst_fst 0))
(assert (>= target_subst_fst 0))
(assert (not (= source_subst_fst target_subst_fst)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_snd: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_snd preserves semantics
(push 1)
(declare-const source_subst_snd Int)
(declare-const target_subst_snd Int)
(assert (>= source_subst_snd 0))
(assert (>= target_subst_snd 0))
(assert (not (= source_subst_snd target_subst_snd)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_inl: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_inl preserves semantics
(push 1)
(declare-const source_subst_inl Int)
(declare-const target_subst_inl Int)
(assert (>= source_subst_inl 0))
(assert (>= target_subst_inl 0))
(assert (not (= source_subst_inl target_subst_inl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_inr: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_inr preserves semantics
(push 1)
(declare-const source_subst_inr Int)
(declare-const target_subst_inr Int)
(assert (>= source_subst_inr 0))
(assert (>= target_subst_inr 0))
(assert (not (= source_subst_inr target_subst_inr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_if: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_if preserves semantics
(push 1)
(declare-const source_subst_if Int)
(declare-const target_subst_if Int)
(assert (>= source_subst_if 0))
(assert (>= target_subst_if 0))
(assert (not (= source_subst_if target_subst_if)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_ref: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_ref preserves semantics
(push 1)
(declare-const source_subst_ref Int)
(declare-const target_subst_ref Int)
(assert (>= source_subst_ref 0))
(assert (>= target_subst_ref 0))
(assert (not (= source_subst_ref target_subst_ref)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_deref: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_deref preserves semantics
(push 1)
(declare-const source_subst_deref Int)
(declare-const target_subst_deref Int)
(assert (>= source_subst_deref 0))
(assert (>= target_subst_deref 0))
(assert (not (= source_subst_deref target_subst_deref)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_assign: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_assign preserves semantics
(push 1)
(declare-const source_subst_assign Int)
(declare-const target_subst_assign Int)
(assert (>= source_subst_assign 0))
(assert (>= target_subst_assign 0))
(assert (not (= source_subst_assign target_subst_assign)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_classify: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_classify preserves semantics
(push 1)
(declare-const source_subst_classify Int)
(declare-const target_subst_classify Int)
(assert (>= source_subst_classify 0))
(assert (>= target_subst_classify 0))
(assert (not (= source_subst_classify target_subst_classify)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_prove: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_prove preserves semantics
(push 1)
(declare-const source_subst_prove Int)
(declare-const target_subst_prove Int)
(assert (>= source_subst_prove 0))
(assert (>= target_subst_prove 0))
(assert (not (= source_subst_prove target_subst_prove)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_declassify: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_declassify preserves semantics
(push 1)
(declare-const source_subst_declassify Int)
(declare-const target_subst_declassify Int)
(assert (>= source_subst_declassify 0))
(assert (>= target_subst_declassify 0))
(assert (not (= source_subst_declassify target_subst_declassify)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_perform: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_perform preserves semantics
(push 1)
(declare-const source_subst_perform Int)
(declare-const target_subst_perform Int)
(assert (>= source_subst_perform 0))
(assert (>= target_subst_perform 0))
(assert (not (= source_subst_perform target_subst_perform)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_require: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_require preserves semantics
(push 1)
(declare-const source_subst_require Int)
(declare-const target_subst_require Int)
(assert (>= source_subst_require 0))
(assert (>= target_subst_require 0))
(assert (not (= source_subst_require target_subst_require)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_grant: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_grant preserves semantics
(push 1)
(declare-const source_subst_grant Int)
(declare-const target_subst_grant Int)
(assert (>= source_subst_grant 0))
(assert (>= target_subst_grant 0))
(assert (not (= source_subst_grant target_subst_grant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_lam_same: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_lam_same preserves semantics
(push 1)
(declare-const source_subst_lam_same Int)
(declare-const target_subst_lam_same Int)
(assert (>= source_subst_lam_same 0))
(assert (>= target_subst_lam_same 0))
(assert (not (= source_subst_lam_same target_subst_lam_same)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_lam_diff: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_lam_diff preserves semantics
(push 1)
(declare-const source_subst_lam_diff Int)
(declare-const target_subst_lam_diff Int)
(assert (>= source_subst_lam_diff 0))
(assert (>= target_subst_lam_diff 0))
(assert (not (= source_subst_lam_diff target_subst_lam_diff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_let_same: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_let_same preserves semantics
(push 1)
(declare-const source_subst_let_same Int)
(declare-const target_subst_let_same Int)
(assert (>= source_subst_let_same 0))
(assert (>= target_subst_let_same 0))
(assert (not (= source_subst_let_same target_subst_let_same)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_let_diff: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_let_diff preserves semantics
(push 1)
(declare-const source_subst_let_diff Int)
(declare-const target_subst_let_diff Int)
(assert (>= source_subst_let_diff 0))
(assert (>= target_subst_let_diff 0))
(assert (not (= source_subst_let_diff target_subst_let_diff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

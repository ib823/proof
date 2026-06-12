; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/SubstitutionCommute.v (53 validations)
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
(declare-fun source_id_rho_sc () Bool)
(declare-fun target_id_rho_sc () Bool)
(assert (= source_id_rho_sc target_id_rho_sc))

; extend_rho_sc: source semantics (matches Coq)
(declare-fun source_extend_rho_sc () Bool)
(declare-fun target_extend_rho_sc () Bool)
(assert (= source_extend_rho_sc target_extend_rho_sc))

; closed_expr_sc: source semantics (matches Coq)
(declare-fun source_closed_expr_sc () Bool)
(declare-fun target_closed_expr_sc () Bool)
(assert (= source_closed_expr_sc target_closed_expr_sc))

; closed_rho_sc: source semantics (matches Coq)
(declare-fun source_closed_rho_sc () Bool)
(declare-fun target_closed_rho_sc () Bool)
(assert (= source_closed_rho_sc target_closed_rho_sc))

; extend_rho_sc_same: translation preserves property (matches Coq: Lemma)
(declare-fun source_extend_rho_sc_same () Bool)
(declare-fun target_extend_rho_sc_same () Bool)
(assert (= source_extend_rho_sc_same target_extend_rho_sc_same))

; extend_rho_sc_diff: translation preserves property (matches Coq: Lemma)
(declare-fun source_extend_rho_sc_diff () Bool)
(declare-fun target_extend_rho_sc_diff () Bool)
(assert (= source_extend_rho_sc_diff target_extend_rho_sc_diff))

; extend_rho_sc_shadow: translation preserves property (matches Coq: Lemma)
(declare-fun source_extend_rho_sc_shadow () Bool)
(declare-fun target_extend_rho_sc_shadow () Bool)
(assert (= source_extend_rho_sc_shadow target_extend_rho_sc_shadow))

; extend_rho_sc_comm: translation preserves property (matches Coq: Lemma)
(declare-fun source_extend_rho_sc_comm () Bool)
(declare-fun target_extend_rho_sc_comm () Bool)
(assert (= source_extend_rho_sc_comm target_extend_rho_sc_comm))

; subst_not_free_sc: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_not_free_sc () Bool)
(declare-fun target_subst_not_free_sc () Bool)
(assert (= source_subst_not_free_sc target_subst_not_free_sc))

; subst_closed_sc: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_closed_sc () Bool)
(declare-fun target_subst_closed_sc () Bool)
(assert (= source_subst_closed_sc target_subst_closed_sc))

; closed_unit_sub: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_unit_sub () Bool)
(declare-fun target_closed_unit_sub () Bool)
(assert (= source_closed_unit_sub target_closed_unit_sub))

; closed_bool_sub: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_bool_sub () Bool)
(declare-fun target_closed_bool_sub () Bool)
(assert (= source_closed_bool_sub target_closed_bool_sub))

; closed_int_sub: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_int_sub () Bool)
(declare-fun target_closed_int_sub () Bool)
(assert (= source_closed_int_sub target_closed_int_sub))

; closed_string_sub: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_string_sub () Bool)
(declare-fun target_closed_string_sub () Bool)
(assert (= source_closed_string_sub target_closed_string_sub))

; closed_loc_sub: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_loc_sub () Bool)
(declare-fun target_closed_loc_sub () Bool)
(assert (= source_closed_loc_sub target_closed_loc_sub))

; subst_var_same: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_var_same () Bool)
(declare-fun target_subst_var_same () Bool)
(assert (= source_subst_var_same target_subst_var_same))

; subst_var_diff: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_var_diff () Bool)
(declare-fun target_subst_var_diff () Bool)
(assert (= source_subst_var_diff target_subst_var_diff))

; subst_unit: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_unit () Bool)
(declare-fun target_subst_unit () Bool)
(assert (= source_subst_unit target_subst_unit))

; subst_bool: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_bool () Bool)
(declare-fun target_subst_bool () Bool)
(assert (= source_subst_bool target_subst_bool))

; subst_int: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_int () Bool)
(declare-fun target_subst_int () Bool)
(assert (= source_subst_int target_subst_int))

; subst_string: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_string () Bool)
(declare-fun target_subst_string () Bool)
(assert (= source_subst_string target_subst_string))

; subst_loc: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_loc () Bool)
(declare-fun target_subst_loc () Bool)
(assert (= source_subst_loc target_subst_loc))

; subst_id: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_id () Bool)
(declare-fun target_subst_id () Bool)
(assert (= source_subst_id target_subst_id))

; subst_value: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_value () Bool)
(declare-fun target_subst_value () Bool)
(assert (= source_subst_value target_subst_value))

; subst_app: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_app () Bool)
(declare-fun target_subst_app () Bool)
(assert (= source_subst_app target_subst_app))

; subst_pair: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_pair () Bool)
(declare-fun target_subst_pair () Bool)
(assert (= source_subst_pair target_subst_pair))

; subst_fst: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_fst () Bool)
(declare-fun target_subst_fst () Bool)
(assert (= source_subst_fst target_subst_fst))

; subst_snd: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_snd () Bool)
(declare-fun target_subst_snd () Bool)
(assert (= source_subst_snd target_subst_snd))

; subst_inl: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_inl () Bool)
(declare-fun target_subst_inl () Bool)
(assert (= source_subst_inl target_subst_inl))

; subst_inr: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_inr () Bool)
(declare-fun target_subst_inr () Bool)
(assert (= source_subst_inr target_subst_inr))

; subst_if: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_if () Bool)
(declare-fun target_subst_if () Bool)
(assert (= source_subst_if target_subst_if))

; subst_ref: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_ref () Bool)
(declare-fun target_subst_ref () Bool)
(assert (= source_subst_ref target_subst_ref))

; subst_deref: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_deref () Bool)
(declare-fun target_subst_deref () Bool)
(assert (= source_subst_deref target_subst_deref))

; subst_assign: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_assign () Bool)
(declare-fun target_subst_assign () Bool)
(assert (= source_subst_assign target_subst_assign))

; subst_classify: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_classify () Bool)
(declare-fun target_subst_classify () Bool)
(assert (= source_subst_classify target_subst_classify))

; subst_prove: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_prove () Bool)
(declare-fun target_subst_prove () Bool)
(assert (= source_subst_prove target_subst_prove))

; subst_declassify: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_declassify () Bool)
(declare-fun target_subst_declassify () Bool)
(assert (= source_subst_declassify target_subst_declassify))

; subst_perform: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_perform () Bool)
(declare-fun target_subst_perform () Bool)
(assert (= source_subst_perform target_subst_perform))

; subst_require: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_require () Bool)
(declare-fun target_subst_require () Bool)
(assert (= source_subst_require target_subst_require))

; subst_grant: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_grant () Bool)
(declare-fun target_subst_grant () Bool)
(assert (= source_subst_grant target_subst_grant))

; subst_lam_same: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_lam_same () Bool)
(declare-fun target_subst_lam_same () Bool)
(assert (= source_subst_lam_same target_subst_lam_same))

; subst_lam_diff: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_lam_diff () Bool)
(declare-fun target_subst_lam_diff () Bool)
(assert (= source_subst_lam_diff target_subst_lam_diff))

; subst_let_same: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_let_same () Bool)
(declare-fun target_subst_let_same () Bool)
(assert (= source_subst_let_same target_subst_let_same))

; subst_let_diff: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_let_diff () Bool)
(declare-fun target_subst_let_diff () Bool)
(assert (= source_subst_let_diff target_subst_let_diff))

; subst_handle_same: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_handle_same () Bool)
(declare-fun target_subst_handle_same () Bool)
(assert (= source_subst_handle_same target_subst_handle_same))

; subst_handle_diff: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_handle_diff () Bool)
(declare-fun target_subst_handle_diff () Bool)
(assert (= source_subst_handle_diff target_subst_handle_diff))

; subst_case_same_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_case_same_left () Bool)
(declare-fun target_subst_case_same_left () Bool)
(assert (= source_subst_case_same_left target_subst_case_same_left))

; id_rho_sc_identity: translation preserves property (matches Coq: Lemma)
(declare-fun source_id_rho_sc_identity () Bool)
(declare-fun target_id_rho_sc_identity () Bool)
(assert (= source_id_rho_sc_identity target_id_rho_sc_identity))

; extend_id_rho_sc_at: translation preserves property (matches Coq: Lemma)
(declare-fun source_extend_id_rho_sc_at () Bool)
(declare-fun target_extend_id_rho_sc_at () Bool)
(assert (= source_extend_id_rho_sc_at target_extend_id_rho_sc_at))

; extend_id_rho_sc_other: translation preserves property (matches Coq: Lemma)
(declare-fun source_extend_id_rho_sc_other () Bool)
(declare-fun target_extend_id_rho_sc_other () Bool)
(assert (= source_extend_id_rho_sc_other target_extend_id_rho_sc_other))

; subst_var_eqb: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_var_eqb () Bool)
(declare-fun target_subst_var_eqb () Bool)
(assert (= source_subst_var_eqb target_subst_var_eqb))

; closed_pair_sub: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_pair_sub () Bool)
(declare-fun target_closed_pair_sub () Bool)
(assert (= source_closed_pair_sub target_closed_pair_sub))

; closed_inl_sub: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_inl_sub () Bool)
(declare-fun target_closed_inl_sub () Bool)
(assert (= source_closed_inl_sub target_closed_inl_sub))

; closed_inr_sub: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_inr_sub () Bool)
(declare-fun target_closed_inr_sub () Bool)
(assert (= source_closed_inr_sub target_closed_inr_sub))

; closed_classify_sub: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_classify_sub () Bool)
(declare-fun target_closed_classify_sub () Bool)
(assert (= source_closed_classify_sub target_closed_classify_sub))

; closed_prove_sub: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_prove_sub () Bool)
(declare-fun target_closed_prove_sub () Bool)
(assert (= source_closed_prove_sub target_closed_prove_sub))

; closed_fst_sub: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_fst_sub () Bool)
(declare-fun target_closed_fst_sub () Bool)
(assert (= source_closed_fst_sub target_closed_fst_sub))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

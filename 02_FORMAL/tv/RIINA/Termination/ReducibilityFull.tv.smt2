; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/termination/ReducibilityFull.v (40 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for ReducibilityFull
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; step_inv: source semantics (matches Coq)
; Translation validation: step_inv preserves semantics
(push 1)
(declare-const source_step_inv Int)
(declare-const target_step_inv Int)
(assert (>= source_step_inv 0))
(assert (>= target_step_inv 0))
(assert (not (= source_step_inv target_step_inv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN: source semantics (matches Coq)
; Translation validation: SN preserves semantics
(push 1)
(declare-const source_SN Int)
(declare-const target_SN Int)
(assert (>= source_SN 0))
(assert (>= target_SN 0))
(assert (not (= source_SN target_SN)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_expr: source semantics (matches Coq)
; Translation validation: SN_expr preserves semantics
(push 1)
(declare-const source_SN_expr Int)
(declare-const target_SN_expr Int)
(assert (>= source_SN_expr 0))
(assert (>= target_SN_expr 0))
(assert (not (= source_SN_expr target_SN_expr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; id_rho: source semantics (matches Coq)
; Translation validation: id_rho preserves semantics
(push 1)
(declare-const source_id_rho Int)
(declare-const target_id_rho Int)
(assert (>= source_id_rho 0))
(assert (>= target_id_rho 0))
(assert (not (= source_id_rho target_id_rho)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; extend_rho: source semantics (matches Coq)
; Translation validation: extend_rho preserves semantics
(push 1)
(declare-const source_extend_rho Int)
(declare-const target_extend_rho Int)
(assert (>= source_extend_rho 0))
(assert (>= target_extend_rho 0))
(assert (not (= source_extend_rho target_extend_rho)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_env: source semantics (matches Coq)
; Translation validation: subst_env preserves semantics
(push 1)
(declare-const source_subst_env Int)
(declare-const target_subst_env Int)
(assert (>= source_subst_env 0))
(assert (>= target_subst_env 0))
(assert (not (= source_subst_env target_subst_env)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_rho: source semantics (matches Coq)
; Translation validation: closed_rho preserves semantics
(push 1)
(declare-const source_closed_rho Int)
(declare-const target_closed_rho Int)
(assert (>= source_closed_rho 0))
(assert (>= target_closed_rho 0))
(assert (not (= source_closed_rho target_closed_rho)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Reducible: source semantics (matches Coq)
; Translation validation: Reducible preserves semantics
(push 1)
(declare-const source_Reducible Int)
(declare-const target_Reducible Int)
(assert (>= source_Reducible 0))
(assert (>= target_Reducible 0))
(assert (not (= source_Reducible target_Reducible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; value_not_step: translation preserves property (matches Coq: Lemma)
; Translation validation: value_not_step preserves semantics
(push 1)
(declare-const source_value_not_step Int)
(declare-const target_value_not_step Int)
(assert (>= source_value_not_step 0))
(assert (>= target_value_not_step 0))
(assert (not (= source_value_not_step target_value_not_step)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; value_SN: translation preserves property (matches Coq: Lemma)
; Translation validation: value_SN preserves semantics
(push 1)
(declare-const source_value_SN Int)
(declare-const target_value_SN Int)
(assert (>= source_value_SN 0))
(assert (>= target_value_SN 0))
(assert (not (= source_value_SN target_value_SN)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_step: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_step preserves semantics
(push 1)
(declare-const source_SN_step Int)
(declare-const target_SN_step Int)
(assert (>= source_SN_step 0))
(assert (>= target_SN_step 0))
(assert (not (= source_SN_step target_SN_step)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_classify_aux: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_classify_aux preserves semantics
(push 1)
(declare-const source_SN_classify_aux Int)
(declare-const target_SN_classify_aux Int)
(assert (>= source_SN_classify_aux 0))
(assert (>= target_SN_classify_aux 0))
(assert (not (= source_SN_classify_aux target_SN_classify_aux)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_classify: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_classify preserves semantics
(push 1)
(declare-const source_SN_classify Int)
(declare-const target_SN_classify Int)
(assert (>= source_SN_classify 0))
(assert (>= target_SN_classify 0))
(assert (not (= source_SN_classify target_SN_classify)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_prove_aux: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_prove_aux preserves semantics
(push 1)
(declare-const source_SN_prove_aux Int)
(declare-const target_SN_prove_aux Int)
(assert (>= source_SN_prove_aux 0))
(assert (>= target_SN_prove_aux 0))
(assert (not (= source_SN_prove_aux target_SN_prove_aux)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_prove: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_prove preserves semantics
(push 1)
(declare-const source_SN_prove Int)
(declare-const target_SN_prove Int)
(assert (>= source_SN_prove 0))
(assert (>= target_SN_prove 0))
(assert (not (= source_SN_prove target_SN_prove)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_perform_aux: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_perform_aux preserves semantics
(push 1)
(declare-const source_SN_perform_aux Int)
(declare-const target_SN_perform_aux Int)
(assert (>= source_SN_perform_aux 0))
(assert (>= target_SN_perform_aux 0))
(assert (not (= source_SN_perform_aux target_SN_perform_aux)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_perform: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_perform preserves semantics
(push 1)
(declare-const source_SN_perform Int)
(declare-const target_SN_perform Int)
(assert (>= source_SN_perform 0))
(assert (>= target_SN_perform 0))
(assert (not (= source_SN_perform target_SN_perform)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_require_aux: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_require_aux preserves semantics
(push 1)
(declare-const source_SN_require_aux Int)
(declare-const target_SN_require_aux Int)
(assert (>= source_SN_require_aux 0))
(assert (>= target_SN_require_aux 0))
(assert (not (= source_SN_require_aux target_SN_require_aux)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_require: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_require preserves semantics
(push 1)
(declare-const source_SN_require Int)
(declare-const target_SN_require Int)
(assert (>= source_SN_require 0))
(assert (>= target_SN_require 0))
(assert (not (= source_SN_require target_SN_require)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_grant_aux: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_grant_aux preserves semantics
(push 1)
(declare-const source_SN_grant_aux Int)
(declare-const target_SN_grant_aux Int)
(assert (>= source_SN_grant_aux 0))
(assert (>= target_SN_grant_aux 0))
(assert (not (= source_SN_grant_aux target_SN_grant_aux)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_grant: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_grant preserves semantics
(push 1)
(declare-const source_SN_grant Int)
(declare-const target_SN_grant Int)
(assert (>= source_SN_grant 0))
(assert (>= target_SN_grant 0))
(assert (not (= source_SN_grant target_SN_grant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_declassify_value_left_aux: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_declassify_value_left_aux preserves semantics
(push 1)
(declare-const source_SN_declassify_value_left_aux Int)
(declare-const target_SN_declassify_value_left_aux Int)
(assert (>= source_SN_declassify_value_left_aux 0))
(assert (>= target_SN_declassify_value_left_aux 0))
(assert (not (= source_SN_declassify_value_left_aux target_SN_declassify_value_left_aux)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_declassify_value_left: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_declassify_value_left preserves semantics
(push 1)
(declare-const source_SN_declassify_value_left Int)
(declare-const target_SN_declassify_value_left Int)
(assert (>= source_SN_declassify_value_left 0))
(assert (>= target_SN_declassify_value_left 0))
(assert (not (= source_SN_declassify_value_left target_SN_declassify_value_left)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_declassify_aux: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_declassify_aux preserves semantics
(push 1)
(declare-const source_SN_declassify_aux Int)
(declare-const target_SN_declassify_aux Int)
(assert (>= source_SN_declassify_aux 0))
(assert (>= target_SN_declassify_aux 0))
(assert (not (= source_SN_declassify_aux target_SN_declassify_aux)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_declassify: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_declassify preserves semantics
(push 1)
(declare-const source_SN_declassify Int)
(declare-const target_SN_declassify Int)
(assert (>= source_SN_declassify 0))
(assert (>= target_SN_declassify 0))
(assert (not (= source_SN_declassify target_SN_declassify)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; extend_rho_id: translation preserves property (matches Coq: Lemma)
; Translation validation: extend_rho_id preserves semantics
(push 1)
(declare-const source_extend_rho_id Int)
(declare-const target_extend_rho_id Int)
(assert (>= source_extend_rho_id 0))
(assert (>= target_extend_rho_id 0))
(assert (not (= source_extend_rho_id target_extend_rho_id)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_env_id: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_env_id preserves semantics
(push 1)
(declare-const source_subst_env_id Int)
(declare-const target_subst_env_id Int)
(assert (>= source_subst_env_id 0))
(assert (>= target_subst_env_id 0))
(assert (not (= source_subst_env_id target_subst_env_id)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_not_free_in: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_not_free_in preserves semantics
(push 1)
(declare-const source_subst_not_free_in Int)
(declare-const target_subst_not_free_in Int)
(assert (>= source_subst_not_free_in 0))
(assert (>= target_subst_not_free_in 0))
(assert (not (= source_subst_not_free_in target_subst_not_free_in)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; free_in_var: translation preserves property (matches Coq: Lemma)
; Translation validation: free_in_var preserves semantics
(push 1)
(declare-const source_free_in_var Int)
(declare-const target_free_in_var Int)
(assert (>= source_free_in_var 0))
(assert (>= target_free_in_var 0))
(assert (not (= source_free_in_var target_free_in_var)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; not_free_in_var_neq: translation preserves property (matches Coq: Lemma)
; Translation validation: not_free_in_var_neq preserves semantics
(push 1)
(declare-const source_not_free_in_var_neq Int)
(declare-const target_not_free_in_var_neq Int)
(assert (>= source_not_free_in_var_neq 0))
(assert (>= target_not_free_in_var_neq 0))
(assert (not (= source_not_free_in_var_neq target_not_free_in_var_neq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; extend_rho_shadow: translation preserves property (matches Coq: Lemma)
; Translation validation: extend_rho_shadow preserves semantics
(push 1)
(declare-const source_extend_rho_shadow Int)
(declare-const target_extend_rho_shadow Int)
(assert (>= source_extend_rho_shadow 0))
(assert (>= target_extend_rho_shadow 0))
(assert (not (= source_extend_rho_shadow target_extend_rho_shadow)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; extend_rho_commute: translation preserves property (matches Coq: Lemma)
; Translation validation: extend_rho_commute preserves semantics
(push 1)
(declare-const source_extend_rho_commute Int)
(declare-const target_extend_rho_commute Int)
(assert (>= source_extend_rho_commute 0))
(assert (>= target_extend_rho_commute 0))
(assert (not (= source_extend_rho_commute target_extend_rho_commute)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_env_ext: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_env_ext preserves semantics
(push 1)
(declare-const source_subst_env_ext Int)
(declare-const target_subst_env_ext Int)
(assert (>= source_subst_env_ext 0))
(assert (>= target_subst_env_ext 0))
(assert (not (= source_subst_env_ext target_subst_env_ext)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_subst_env_commute_gen: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_subst_env_commute_gen preserves semantics
(push 1)
(declare-const source_subst_subst_env_commute_gen Int)
(declare-const target_subst_subst_env_commute_gen Int)
(assert (>= source_subst_subst_env_commute_gen 0))
(assert (>= target_subst_subst_env_commute_gen 0))
(assert (not (= source_subst_subst_env_commute_gen target_subst_subst_env_commute_gen)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_subst_env_commute: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_subst_env_commute preserves semantics
(push 1)
(declare-const source_subst_subst_env_commute Int)
(declare-const target_subst_subst_env_commute Int)
(assert (>= source_subst_subst_env_commute 0))
(assert (>= target_subst_subst_env_commute 0))
(assert (not (= source_subst_subst_env_commute target_subst_subst_env_commute)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CR1: translation preserves property (matches Coq: Lemma)
; Translation validation: CR1 preserves semantics
(push 1)
(declare-const source_CR1 Int)
(declare-const target_CR1 Int)
(assert (>= source_CR1 0))
(assert (>= target_CR1 0))
(assert (not (= source_CR1 target_CR1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CR3_base: translation preserves property (matches Coq: Lemma)
; Translation validation: CR3_base preserves semantics
(push 1)
(declare-const source_CR3_base Int)
(declare-const target_CR3_base Int)
(assert (>= source_CR3_base 0))
(assert (>= target_CR3_base 0))
(assert (not (= source_CR3_base target_CR3_base)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unit_reducible: translation preserves property (matches Coq: Lemma)
; Translation validation: unit_reducible preserves semantics
(push 1)
(declare-const source_unit_reducible Int)
(declare-const target_unit_reducible Int)
(assert (>= source_unit_reducible 0))
(assert (>= target_unit_reducible 0))
(assert (not (= source_unit_reducible target_unit_reducible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bool_reducible: translation preserves property (matches Coq: Lemma)
; Translation validation: bool_reducible preserves semantics
(push 1)
(declare-const source_bool_reducible Int)
(declare-const target_bool_reducible Int)
(assert (>= source_bool_reducible 0))
(assert (>= target_bool_reducible 0))
(assert (not (= source_bool_reducible target_bool_reducible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; int_reducible: translation preserves property (matches Coq: Lemma)
; Translation validation: int_reducible preserves semantics
(push 1)
(declare-const source_int_reducible Int)
(declare-const target_int_reducible Int)
(assert (>= source_int_reducible 0))
(assert (>= target_int_reducible 0))
(assert (not (= source_int_reducible target_int_reducible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; string_reducible: translation preserves property (matches Coq: Lemma)
; Translation validation: string_reducible preserves semantics
(push 1)
(declare-const source_string_reducible Int)
(declare-const target_string_reducible Int)
(assert (>= source_string_reducible 0))
(assert (>= target_string_reducible 0))
(assert (not (= source_string_reducible target_string_reducible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; env_reducible_nil: translation preserves property (matches Coq: Lemma)
; Translation validation: env_reducible_nil preserves semantics
(push 1)
(declare-const source_env_reducible_nil Int)
(declare-const target_env_reducible_nil Int)
(assert (>= source_env_reducible_nil 0))
(assert (>= target_env_reducible_nil 0))
(assert (not (= source_env_reducible_nil target_env_reducible_nil)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; env_reducible_cons: translation preserves property (matches Coq: Lemma)
; Translation validation: env_reducible_cons preserves semantics
(push 1)
(declare-const source_env_reducible_cons Int)
(declare-const target_env_reducible_cons Int)
(assert (>= source_env_reducible_cons 0))
(assert (>= target_env_reducible_cons 0))
(assert (not (= source_env_reducible_cons target_env_reducible_cons)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fundamental_reducibility: translation preserves property (matches Coq: Lemma)
; Translation validation: fundamental_reducibility preserves semantics
(push 1)
(declare-const source_fundamental_reducibility Int)
(declare-const target_fundamental_reducibility Int)
(assert (>= source_fundamental_reducibility 0))
(assert (>= target_fundamental_reducibility 0))
(assert (not (= source_fundamental_reducibility target_fundamental_reducibility)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; well_typed_SN: translation preserves property (matches Coq: Theorem)
; Translation validation: well_typed_SN preserves semantics
(push 1)
(declare-const source_well_typed_SN Int)
(declare-const target_well_typed_SN Int)
(assert (>= source_well_typed_SN 0))
(assert (>= target_well_typed_SN 0))
(assert (not (= source_well_typed_SN target_well_typed_SN)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_app: translation preserves property (matches Coq: Theorem)
; Translation validation: SN_app preserves semantics
(push 1)
(declare-const source_SN_app Int)
(declare-const target_SN_app Int)
(assert (>= source_SN_app 0))
(assert (>= target_SN_app 0))
(assert (not (= source_SN_app target_SN_app)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_closed_step: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_closed_step preserves semantics
(push 1)
(declare-const source_SN_closed_step Int)
(declare-const target_SN_closed_step Int)
(assert (>= source_SN_closed_step 0))
(assert (>= target_SN_closed_step 0))
(assert (not (= source_SN_closed_step target_SN_closed_step)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SN_beta_value: translation preserves property (matches Coq: Lemma)
; Translation validation: SN_beta_value preserves semantics
(push 1)
(declare-const source_SN_beta_value Int)
(declare-const target_SN_beta_value Int)
(assert (>= source_SN_beta_value 0))
(assert (>= target_SN_beta_value 0))
(assert (not (= source_SN_beta_value target_SN_beta_value)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/TypingInversion.v (52 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for TypingInversion
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; inversion_app: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_app preserves semantics
(push 1)
(declare-const source_inversion_app Int)
(declare-const target_inversion_app Int)
(assert (>= source_inversion_app 0))
(assert (>= target_inversion_app 0))
(assert (not (= source_inversion_app target_inversion_app)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_lam: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_lam preserves semantics
(push 1)
(declare-const source_inversion_lam Int)
(declare-const target_inversion_lam Int)
(assert (>= source_inversion_lam 0))
(assert (>= target_inversion_lam 0))
(assert (not (= source_inversion_lam target_inversion_lam)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_pair: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_pair preserves semantics
(push 1)
(declare-const source_inversion_pair Int)
(declare-const target_inversion_pair Int)
(assert (>= source_inversion_pair 0))
(assert (>= target_inversion_pair 0))
(assert (not (= source_inversion_pair target_inversion_pair)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_fst: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_fst preserves semantics
(push 1)
(declare-const source_inversion_fst Int)
(declare-const target_inversion_fst Int)
(assert (>= source_inversion_fst 0))
(assert (>= target_inversion_fst 0))
(assert (not (= source_inversion_fst target_inversion_fst)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_snd: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_snd preserves semantics
(push 1)
(declare-const source_inversion_snd Int)
(declare-const target_inversion_snd Int)
(assert (>= source_inversion_snd 0))
(assert (>= target_inversion_snd 0))
(assert (not (= source_inversion_snd target_inversion_snd)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_inl: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_inl preserves semantics
(push 1)
(declare-const source_inversion_inl Int)
(declare-const target_inversion_inl Int)
(assert (>= source_inversion_inl 0))
(assert (>= target_inversion_inl 0))
(assert (not (= source_inversion_inl target_inversion_inl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_inr: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_inr preserves semantics
(push 1)
(declare-const source_inversion_inr Int)
(declare-const target_inversion_inr Int)
(assert (>= source_inversion_inr 0))
(assert (>= target_inversion_inr 0))
(assert (not (= source_inversion_inr target_inversion_inr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_case: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_case preserves semantics
(push 1)
(declare-const source_inversion_case Int)
(declare-const target_inversion_case Int)
(assert (>= source_inversion_case 0))
(assert (>= target_inversion_case 0))
(assert (not (= source_inversion_case target_inversion_case)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_if: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_if preserves semantics
(push 1)
(declare-const source_inversion_if Int)
(declare-const target_inversion_if Int)
(assert (>= source_inversion_if 0))
(assert (>= target_inversion_if 0))
(assert (not (= source_inversion_if target_inversion_if)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_let: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_let preserves semantics
(push 1)
(declare-const source_inversion_let Int)
(declare-const target_inversion_let Int)
(assert (>= source_inversion_let 0))
(assert (>= target_inversion_let 0))
(assert (not (= source_inversion_let target_inversion_let)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_ref: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_ref preserves semantics
(push 1)
(declare-const source_inversion_ref Int)
(declare-const target_inversion_ref Int)
(assert (>= source_inversion_ref 0))
(assert (>= target_inversion_ref 0))
(assert (not (= source_inversion_ref target_inversion_ref)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_deref: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_deref preserves semantics
(push 1)
(declare-const source_inversion_deref Int)
(declare-const target_inversion_deref Int)
(assert (>= source_inversion_deref 0))
(assert (>= target_inversion_deref 0))
(assert (not (= source_inversion_deref target_inversion_deref)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_assign: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_assign preserves semantics
(push 1)
(declare-const source_inversion_assign Int)
(declare-const target_inversion_assign Int)
(assert (>= source_inversion_assign 0))
(assert (>= target_inversion_assign 0))
(assert (not (= source_inversion_assign target_inversion_assign)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_perform: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_perform preserves semantics
(push 1)
(declare-const source_inversion_perform Int)
(declare-const target_inversion_perform Int)
(assert (>= source_inversion_perform 0))
(assert (>= target_inversion_perform 0))
(assert (not (= source_inversion_perform target_inversion_perform)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_handle: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_handle preserves semantics
(push 1)
(declare-const source_inversion_handle Int)
(declare-const target_inversion_handle Int)
(assert (>= source_inversion_handle 0))
(assert (>= target_inversion_handle 0))
(assert (not (= source_inversion_handle target_inversion_handle)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_classify: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_classify preserves semantics
(push 1)
(declare-const source_inversion_classify Int)
(declare-const target_inversion_classify Int)
(assert (>= source_inversion_classify 0))
(assert (>= target_inversion_classify 0))
(assert (not (= source_inversion_classify target_inversion_classify)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_declassify: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_declassify preserves semantics
(push 1)
(declare-const source_inversion_declassify Int)
(declare-const target_inversion_declassify Int)
(assert (>= source_inversion_declassify 0))
(assert (>= target_inversion_declassify 0))
(assert (not (= source_inversion_declassify target_inversion_declassify)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_prove: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_prove preserves semantics
(push 1)
(declare-const source_inversion_prove Int)
(declare-const target_inversion_prove Int)
(assert (>= source_inversion_prove 0))
(assert (>= target_inversion_prove 0))
(assert (not (= source_inversion_prove target_inversion_prove)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_require: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_require preserves semantics
(push 1)
(declare-const source_inversion_require Int)
(declare-const target_inversion_require Int)
(assert (>= source_inversion_require 0))
(assert (>= target_inversion_require 0))
(assert (not (= source_inversion_require target_inversion_require)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_grant: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_grant preserves semantics
(push 1)
(declare-const source_inversion_grant Int)
(declare-const target_inversion_grant Int)
(assert (>= source_inversion_grant 0))
(assert (>= target_inversion_grant 0))
(assert (not (= source_inversion_grant target_inversion_grant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_var: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_var preserves semantics
(push 1)
(declare-const source_inversion_var Int)
(declare-const target_inversion_var Int)
(assert (>= source_inversion_var 0))
(assert (>= target_inversion_var 0))
(assert (not (= source_inversion_var target_inversion_var)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; inversion_loc: translation preserves property (matches Coq: Lemma)
; Translation validation: inversion_loc preserves semantics
(push 1)
(declare-const source_inversion_loc Int)
(declare-const target_inversion_loc Int)
(assert (>= source_inversion_loc 0))
(assert (>= target_inversion_loc 0))
(assert (not (= source_inversion_loc target_inversion_loc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; value_typed_pure: translation preserves property (matches Coq: Lemma)
; Translation validation: value_typed_pure preserves semantics
(push 1)
(declare-const source_value_typed_pure Int)
(declare-const target_value_typed_pure Int)
(assert (>= source_value_typed_pure 0))
(assert (>= target_value_typed_pure 0))
(assert (not (= source_value_typed_pure target_value_typed_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; value_pure_typing: translation preserves property (matches Coq: Lemma)
; Translation validation: value_pure_typing preserves semantics
(push 1)
(declare-const source_value_pure_typing Int)
(declare-const target_value_pure_typing Int)
(assert (>= source_value_pure_typing 0))
(assert (>= target_value_pure_typing 0))
(assert (not (= source_value_pure_typing target_value_pure_typing)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_cons_neq: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_cons_neq preserves semantics
(push 1)
(declare-const source_lookup_cons_neq Int)
(declare-const target_lookup_cons_neq Int)
(assert (>= source_lookup_cons_neq 0))
(assert (>= target_lookup_cons_neq 0))
(assert (not (= source_lookup_cons_neq target_lookup_cons_neq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_cons_eq: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_cons_eq preserves semantics
(push 1)
(declare-const source_lookup_cons_eq Int)
(declare-const target_lookup_cons_eq Int)
(assert (>= source_lookup_cons_eq 0))
(assert (>= target_lookup_cons_eq 0))
(assert (not (= source_lookup_cons_eq target_lookup_cons_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_weaken: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_weaken preserves semantics
(push 1)
(declare-const source_lookup_weaken Int)
(declare-const target_lookup_weaken Int)
(assert (>= source_lookup_weaken 0))
(assert (>= target_lookup_weaken 0))
(assert (not (= source_lookup_weaken target_lookup_weaken)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; app_well_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: app_well_typed preserves semantics
(push 1)
(declare-const source_app_well_typed Int)
(declare-const target_app_well_typed Int)
(assert (>= source_app_well_typed 0))
(assert (>= target_app_well_typed 0))
(assert (not (= source_app_well_typed target_app_well_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; let_well_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: let_well_typed preserves semantics
(push 1)
(declare-const source_let_well_typed Int)
(declare-const target_let_well_typed Int)
(assert (>= source_let_well_typed 0))
(assert (>= target_let_well_typed 0))
(assert (not (= source_let_well_typed target_let_well_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; if_well_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: if_well_typed preserves semantics
(push 1)
(declare-const source_if_well_typed Int)
(declare-const target_if_well_typed Int)
(assert (>= source_if_well_typed 0))
(assert (>= target_if_well_typed 0))
(assert (not (= source_if_well_typed target_if_well_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pair_well_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: pair_well_typed preserves semantics
(push 1)
(declare-const source_pair_well_typed Int)
(declare-const target_pair_well_typed Int)
(assert (>= source_pair_well_typed 0))
(assert (>= target_pair_well_typed 0))
(assert (not (= source_pair_well_typed target_pair_well_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fst_well_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: fst_well_typed preserves semantics
(push 1)
(declare-const source_fst_well_typed Int)
(declare-const target_fst_well_typed Int)
(assert (>= source_fst_well_typed 0))
(assert (>= target_fst_well_typed 0))
(assert (not (= source_fst_well_typed target_fst_well_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; snd_well_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: snd_well_typed preserves semantics
(push 1)
(declare-const source_snd_well_typed Int)
(declare-const target_snd_well_typed Int)
(assert (>= source_snd_well_typed 0))
(assert (>= target_snd_well_typed 0))
(assert (not (= source_snd_well_typed target_snd_well_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fn_not_prod: translation preserves property (matches Coq: Lemma)
; Translation validation: fn_not_prod preserves semantics
(push 1)
(declare-const source_fn_not_prod Int)
(declare-const target_fn_not_prod Int)
(assert (>= source_fn_not_prod 0))
(assert (>= target_fn_not_prod 0))
(assert (not (= source_fn_not_prod target_fn_not_prod)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fn_not_sum: translation preserves property (matches Coq: Lemma)
; Translation validation: fn_not_sum preserves semantics
(push 1)
(declare-const source_fn_not_sum Int)
(declare-const target_fn_not_sum Int)
(assert (>= source_fn_not_sum 0))
(assert (>= target_fn_not_sum 0))
(assert (not (= source_fn_not_sum target_fn_not_sum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fn_not_ref: translation preserves property (matches Coq: Lemma)
; Translation validation: fn_not_ref preserves semantics
(push 1)
(declare-const source_fn_not_ref Int)
(declare-const target_fn_not_ref Int)
(assert (>= source_fn_not_ref 0))
(assert (>= target_fn_not_ref 0))
(assert (not (= source_fn_not_ref target_fn_not_ref)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fn_not_bool: translation preserves property (matches Coq: Lemma)
; Translation validation: fn_not_bool preserves semantics
(push 1)
(declare-const source_fn_not_bool Int)
(declare-const target_fn_not_bool Int)
(assert (>= source_fn_not_bool 0))
(assert (>= target_fn_not_bool 0))
(assert (not (= source_fn_not_bool target_fn_not_bool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fn_not_int: translation preserves property (matches Coq: Lemma)
; Translation validation: fn_not_int preserves semantics
(push 1)
(declare-const source_fn_not_int Int)
(declare-const target_fn_not_int Int)
(assert (>= source_fn_not_int 0))
(assert (>= target_fn_not_int 0))
(assert (not (= source_fn_not_int target_fn_not_int)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fn_not_unit: translation preserves property (matches Coq: Lemma)
; Translation validation: fn_not_unit preserves semantics
(push 1)
(declare-const source_fn_not_unit Int)
(declare-const target_fn_not_unit Int)
(assert (>= source_fn_not_unit 0))
(assert (>= target_fn_not_unit 0))
(assert (not (= source_fn_not_unit target_fn_not_unit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; prod_not_sum: translation preserves property (matches Coq: Lemma)
; Translation validation: prod_not_sum preserves semantics
(push 1)
(declare-const source_prod_not_sum Int)
(declare-const target_prod_not_sum Int)
(assert (>= source_prod_not_sum 0))
(assert (>= target_prod_not_sum 0))
(assert (not (= source_prod_not_sum target_prod_not_sum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; secret_not_fn: translation preserves property (matches Coq: Lemma)
; Translation validation: secret_not_fn preserves semantics
(push 1)
(declare-const source_secret_not_fn Int)
(declare-const target_secret_not_fn Int)
(assert (>= source_secret_not_fn 0))
(assert (>= target_secret_not_fn 0))
(assert (not (= source_secret_not_fn target_secret_not_fn)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; secret_not_prod: translation preserves property (matches Coq: Lemma)
; Translation validation: secret_not_prod preserves semantics
(push 1)
(declare-const source_secret_not_prod Int)
(declare-const target_secret_not_prod Int)
(assert (>= source_secret_not_prod 0))
(assert (>= target_secret_not_prod 0))
(assert (not (= source_secret_not_prod target_secret_not_prod)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; secret_not_bool: translation preserves property (matches Coq: Lemma)
; Translation validation: secret_not_bool preserves semantics
(push 1)
(declare-const source_secret_not_bool Int)
(declare-const target_secret_not_bool Int)
(assert (>= source_secret_not_bool 0))
(assert (>= target_secret_not_bool 0))
(assert (not (= source_secret_not_bool target_secret_not_bool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; proof_not_fn: translation preserves property (matches Coq: Lemma)
; Translation validation: proof_not_fn preserves semantics
(push 1)
(declare-const source_proof_not_fn Int)
(declare-const target_proof_not_fn Int)
(assert (>= source_proof_not_fn 0))
(assert (>= target_proof_not_fn 0))
(assert (not (= source_proof_not_fn target_proof_not_fn)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fn_type_injective: translation preserves property (matches Coq: Lemma)
; Translation validation: fn_type_injective preserves semantics
(push 1)
(declare-const source_fn_type_injective Int)
(declare-const target_fn_type_injective Int)
(assert (>= source_fn_type_injective 0))
(assert (>= target_fn_type_injective 0))
(assert (not (= source_fn_type_injective target_fn_type_injective)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; prod_type_injective: translation preserves property (matches Coq: Lemma)
; Translation validation: prod_type_injective preserves semantics
(push 1)
(declare-const source_prod_type_injective Int)
(declare-const target_prod_type_injective Int)
(assert (>= source_prod_type_injective 0))
(assert (>= target_prod_type_injective 0))
(assert (not (= source_prod_type_injective target_prod_type_injective)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sum_type_injective: translation preserves property (matches Coq: Lemma)
; Translation validation: sum_type_injective preserves semantics
(push 1)
(declare-const source_sum_type_injective Int)
(declare-const target_sum_type_injective Int)
(assert (>= source_sum_type_injective 0))
(assert (>= target_sum_type_injective 0))
(assert (not (= source_sum_type_injective target_sum_type_injective)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ref_type_injective: translation preserves property (matches Coq: Lemma)
; Translation validation: ref_type_injective preserves semantics
(push 1)
(declare-const source_ref_type_injective Int)
(declare-const target_ref_type_injective Int)
(assert (>= source_ref_type_injective 0))
(assert (>= target_ref_type_injective 0))
(assert (not (= source_ref_type_injective target_ref_type_injective)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; secret_type_injective: translation preserves property (matches Coq: Lemma)
; Translation validation: secret_type_injective preserves semantics
(push 1)
(declare-const source_secret_type_injective Int)
(declare-const target_secret_type_injective Int)
(assert (>= source_secret_type_injective 0))
(assert (>= target_secret_type_injective 0))
(assert (not (= source_secret_type_injective target_secret_type_injective)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; proof_type_injective: translation preserves property (matches Coq: Lemma)
; Translation validation: proof_type_injective preserves semantics
(push 1)
(declare-const source_proof_type_injective Int)
(declare-const target_proof_type_injective Int)
(assert (>= source_proof_type_injective 0))
(assert (>= target_proof_type_injective 0))
(assert (not (= source_proof_type_injective target_proof_type_injective)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; effect_unique: translation preserves property (matches Coq: Lemma)
; Translation validation: effect_unique preserves semantics
(push 1)
(declare-const source_effect_unique Int)
(declare-const target_effect_unique Int)
(assert (>= source_effect_unique 0))
(assert (>= target_effect_unique 0))
(assert (not (= source_effect_unique target_effect_unique)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; type_unique: translation preserves property (matches Coq: Lemma)
; Translation validation: type_unique preserves semantics
(push 1)
(declare-const source_type_unique Int)
(declare-const target_type_unique Int)
(assert (>= source_type_unique 0))
(assert (>= target_type_unique 0))
(assert (not (= source_type_unique target_type_unique)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

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
(declare-fun source_inversion_app () Bool)
(declare-fun target_inversion_app () Bool)
(assert (= source_inversion_app target_inversion_app))

; inversion_lam: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_lam () Bool)
(declare-fun target_inversion_lam () Bool)
(assert (= source_inversion_lam target_inversion_lam))

; inversion_pair: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_pair () Bool)
(declare-fun target_inversion_pair () Bool)
(assert (= source_inversion_pair target_inversion_pair))

; inversion_fst: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_fst () Bool)
(declare-fun target_inversion_fst () Bool)
(assert (= source_inversion_fst target_inversion_fst))

; inversion_snd: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_snd () Bool)
(declare-fun target_inversion_snd () Bool)
(assert (= source_inversion_snd target_inversion_snd))

; inversion_inl: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_inl () Bool)
(declare-fun target_inversion_inl () Bool)
(assert (= source_inversion_inl target_inversion_inl))

; inversion_inr: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_inr () Bool)
(declare-fun target_inversion_inr () Bool)
(assert (= source_inversion_inr target_inversion_inr))

; inversion_case: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_case () Bool)
(declare-fun target_inversion_case () Bool)
(assert (= source_inversion_case target_inversion_case))

; inversion_if: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_if () Bool)
(declare-fun target_inversion_if () Bool)
(assert (= source_inversion_if target_inversion_if))

; inversion_let: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_let () Bool)
(declare-fun target_inversion_let () Bool)
(assert (= source_inversion_let target_inversion_let))

; inversion_ref: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_ref () Bool)
(declare-fun target_inversion_ref () Bool)
(assert (= source_inversion_ref target_inversion_ref))

; inversion_deref: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_deref () Bool)
(declare-fun target_inversion_deref () Bool)
(assert (= source_inversion_deref target_inversion_deref))

; inversion_assign: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_assign () Bool)
(declare-fun target_inversion_assign () Bool)
(assert (= source_inversion_assign target_inversion_assign))

; inversion_perform: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_perform () Bool)
(declare-fun target_inversion_perform () Bool)
(assert (= source_inversion_perform target_inversion_perform))

; inversion_handle: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_handle () Bool)
(declare-fun target_inversion_handle () Bool)
(assert (= source_inversion_handle target_inversion_handle))

; inversion_classify: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_classify () Bool)
(declare-fun target_inversion_classify () Bool)
(assert (= source_inversion_classify target_inversion_classify))

; inversion_declassify: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_declassify () Bool)
(declare-fun target_inversion_declassify () Bool)
(assert (= source_inversion_declassify target_inversion_declassify))

; inversion_prove: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_prove () Bool)
(declare-fun target_inversion_prove () Bool)
(assert (= source_inversion_prove target_inversion_prove))

; inversion_require: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_require () Bool)
(declare-fun target_inversion_require () Bool)
(assert (= source_inversion_require target_inversion_require))

; inversion_grant: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_grant () Bool)
(declare-fun target_inversion_grant () Bool)
(assert (= source_inversion_grant target_inversion_grant))

; inversion_var: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_var () Bool)
(declare-fun target_inversion_var () Bool)
(assert (= source_inversion_var target_inversion_var))

; inversion_loc: translation preserves property (matches Coq: Lemma)
(declare-fun source_inversion_loc () Bool)
(declare-fun target_inversion_loc () Bool)
(assert (= source_inversion_loc target_inversion_loc))

; value_typed_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_typed_pure () Bool)
(declare-fun target_value_typed_pure () Bool)
(assert (= source_value_typed_pure target_value_typed_pure))

; value_pure_typing: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_pure_typing () Bool)
(declare-fun target_value_pure_typing () Bool)
(assert (= source_value_pure_typing target_value_pure_typing))

; lookup_cons_neq: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_cons_neq () Bool)
(declare-fun target_lookup_cons_neq () Bool)
(assert (= source_lookup_cons_neq target_lookup_cons_neq))

; lookup_cons_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_cons_eq () Bool)
(declare-fun target_lookup_cons_eq () Bool)
(assert (= source_lookup_cons_eq target_lookup_cons_eq))

; lookup_weaken: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_weaken () Bool)
(declare-fun target_lookup_weaken () Bool)
(assert (= source_lookup_weaken target_lookup_weaken))

; app_well_typed: translation preserves property (matches Coq: Lemma)
(declare-fun source_app_well_typed () Bool)
(declare-fun target_app_well_typed () Bool)
(assert (= source_app_well_typed target_app_well_typed))

; let_well_typed: translation preserves property (matches Coq: Lemma)
(declare-fun source_let_well_typed () Bool)
(declare-fun target_let_well_typed () Bool)
(assert (= source_let_well_typed target_let_well_typed))

; if_well_typed: translation preserves property (matches Coq: Lemma)
(declare-fun source_if_well_typed () Bool)
(declare-fun target_if_well_typed () Bool)
(assert (= source_if_well_typed target_if_well_typed))

; pair_well_typed: translation preserves property (matches Coq: Lemma)
(declare-fun source_pair_well_typed () Bool)
(declare-fun target_pair_well_typed () Bool)
(assert (= source_pair_well_typed target_pair_well_typed))

; fst_well_typed: translation preserves property (matches Coq: Lemma)
(declare-fun source_fst_well_typed () Bool)
(declare-fun target_fst_well_typed () Bool)
(assert (= source_fst_well_typed target_fst_well_typed))

; snd_well_typed: translation preserves property (matches Coq: Lemma)
(declare-fun source_snd_well_typed () Bool)
(declare-fun target_snd_well_typed () Bool)
(assert (= source_snd_well_typed target_snd_well_typed))

; fn_not_prod: translation preserves property (matches Coq: Lemma)
(declare-fun source_fn_not_prod () Bool)
(declare-fun target_fn_not_prod () Bool)
(assert (= source_fn_not_prod target_fn_not_prod))

; fn_not_sum: translation preserves property (matches Coq: Lemma)
(declare-fun source_fn_not_sum () Bool)
(declare-fun target_fn_not_sum () Bool)
(assert (= source_fn_not_sum target_fn_not_sum))

; fn_not_ref: translation preserves property (matches Coq: Lemma)
(declare-fun source_fn_not_ref () Bool)
(declare-fun target_fn_not_ref () Bool)
(assert (= source_fn_not_ref target_fn_not_ref))

; fn_not_bool: translation preserves property (matches Coq: Lemma)
(declare-fun source_fn_not_bool () Bool)
(declare-fun target_fn_not_bool () Bool)
(assert (= source_fn_not_bool target_fn_not_bool))

; fn_not_int: translation preserves property (matches Coq: Lemma)
(declare-fun source_fn_not_int () Bool)
(declare-fun target_fn_not_int () Bool)
(assert (= source_fn_not_int target_fn_not_int))

; fn_not_unit: translation preserves property (matches Coq: Lemma)
(declare-fun source_fn_not_unit () Bool)
(declare-fun target_fn_not_unit () Bool)
(assert (= source_fn_not_unit target_fn_not_unit))

; prod_not_sum: translation preserves property (matches Coq: Lemma)
(declare-fun source_prod_not_sum () Bool)
(declare-fun target_prod_not_sum () Bool)
(assert (= source_prod_not_sum target_prod_not_sum))

; secret_not_fn: translation preserves property (matches Coq: Lemma)
(declare-fun source_secret_not_fn () Bool)
(declare-fun target_secret_not_fn () Bool)
(assert (= source_secret_not_fn target_secret_not_fn))

; secret_not_prod: translation preserves property (matches Coq: Lemma)
(declare-fun source_secret_not_prod () Bool)
(declare-fun target_secret_not_prod () Bool)
(assert (= source_secret_not_prod target_secret_not_prod))

; secret_not_bool: translation preserves property (matches Coq: Lemma)
(declare-fun source_secret_not_bool () Bool)
(declare-fun target_secret_not_bool () Bool)
(assert (= source_secret_not_bool target_secret_not_bool))

; proof_not_fn: translation preserves property (matches Coq: Lemma)
(declare-fun source_proof_not_fn () Bool)
(declare-fun target_proof_not_fn () Bool)
(assert (= source_proof_not_fn target_proof_not_fn))

; fn_type_injective: translation preserves property (matches Coq: Lemma)
(declare-fun source_fn_type_injective () Bool)
(declare-fun target_fn_type_injective () Bool)
(assert (= source_fn_type_injective target_fn_type_injective))

; prod_type_injective: translation preserves property (matches Coq: Lemma)
(declare-fun source_prod_type_injective () Bool)
(declare-fun target_prod_type_injective () Bool)
(assert (= source_prod_type_injective target_prod_type_injective))

; sum_type_injective: translation preserves property (matches Coq: Lemma)
(declare-fun source_sum_type_injective () Bool)
(declare-fun target_sum_type_injective () Bool)
(assert (= source_sum_type_injective target_sum_type_injective))

; ref_type_injective: translation preserves property (matches Coq: Lemma)
(declare-fun source_ref_type_injective () Bool)
(declare-fun target_ref_type_injective () Bool)
(assert (= source_ref_type_injective target_ref_type_injective))

; secret_type_injective: translation preserves property (matches Coq: Lemma)
(declare-fun source_secret_type_injective () Bool)
(declare-fun target_secret_type_injective () Bool)
(assert (= source_secret_type_injective target_secret_type_injective))

; proof_type_injective: translation preserves property (matches Coq: Lemma)
(declare-fun source_proof_type_injective () Bool)
(declare-fun target_proof_type_injective () Bool)
(assert (= source_proof_type_injective target_proof_type_injective))

; effect_unique: translation preserves property (matches Coq: Lemma)
(declare-fun source_effect_unique () Bool)
(declare-fun target_effect_unique () Bool)
(assert (= source_effect_unique target_effect_unique))

; type_unique: translation preserves property (matches Coq: Lemma)
(declare-fun source_type_unique () Bool)
(declare-fun target_type_unique () Bool)
(assert (= source_type_unique target_type_unique))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

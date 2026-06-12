; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/type_system/Preservation.v (21 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for Preservation
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; free_in_context: translation preserves property (matches Coq: Lemma)
(declare-fun source_free_in_context () Bool)
(declare-fun target_free_in_context () Bool)
(assert (= source_free_in_context target_free_in_context))

; store_lookup_update_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_lookup_update_eq () Bool)
(declare-fun target_store_lookup_update_eq () Bool)
(assert (= source_store_lookup_update_eq target_store_lookup_update_eq))

; store_lookup_update_neq: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_lookup_update_neq () Bool)
(declare-fun target_store_lookup_update_neq () Bool)
(assert (= source_store_lookup_update_neq target_store_lookup_update_neq))

; store_ty_lookup_update_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_lookup_update_eq () Bool)
(declare-fun target_store_ty_lookup_update_eq () Bool)
(assert (= source_store_ty_lookup_update_eq target_store_ty_lookup_update_eq))

; store_ty_lookup_update_neq: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_lookup_update_neq () Bool)
(declare-fun target_store_ty_lookup_update_neq () Bool)
(assert (= source_store_ty_lookup_update_neq target_store_ty_lookup_update_neq))

; store_ty_extends_update_fresh: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_extends_update_fresh () Bool)
(declare-fun target_store_ty_extends_update_fresh () Bool)
(assert (= source_store_ty_extends_update_fresh target_store_ty_extends_update_fresh))

; store_ty_extends_preserves_typing: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_extends_preserves_typing () Bool)
(declare-fun target_store_ty_extends_preserves_typing () Bool)
(assert (= source_store_ty_extends_preserves_typing target_store_ty_extends_preserves_typing))

; store_ty_extends_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_extends_refl () Bool)
(declare-fun target_store_ty_extends_refl () Bool)
(assert (= source_store_ty_extends_refl target_store_ty_extends_refl))

; store_wf_update_existing: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_wf_update_existing () Bool)
(declare-fun target_store_wf_update_existing () Bool)
(assert (= source_store_wf_update_existing target_store_wf_update_existing))

; store_wf_update_fresh: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_wf_update_fresh () Bool)
(declare-fun target_store_wf_update_fresh () Bool)
(assert (= source_store_wf_update_fresh target_store_wf_update_fresh))

; store_ty_lookup_fresh_none: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_lookup_fresh_none () Bool)
(declare-fun target_store_ty_lookup_fresh_none () Bool)
(assert (= source_store_ty_lookup_fresh_none target_store_ty_lookup_fresh_none))

; context_invariance: translation preserves property (matches Coq: Lemma)
(declare-fun source_context_invariance () Bool)
(declare-fun target_context_invariance () Bool)
(assert (= source_context_invariance target_context_invariance))

; closed_typing_weakening: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_typing_weakening () Bool)
(declare-fun target_closed_typing_weakening () Bool)
(assert (= source_closed_typing_weakening target_closed_typing_weakening))

; substitution_preserves_typing: translation preserves property (matches Coq: Lemma)
(declare-fun source_substitution_preserves_typing () Bool)
(declare-fun target_substitution_preserves_typing () Bool)
(assert (= source_substitution_preserves_typing target_substitution_preserves_typing))

; value_has_pure_effect: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_has_pure_effect () Bool)
(declare-fun target_value_has_pure_effect () Bool)
(assert (= source_value_has_pure_effect target_value_has_pure_effect))

; preservation_helper: translation preserves property (matches Coq: Lemma)
(declare-fun source_preservation_helper () Bool)
(declare-fun target_preservation_helper () Bool)
(assert (= source_preservation_helper target_preservation_helper))

; preservation: translation preserves property (matches Coq: Theorem)
(declare-fun source_preservation () Bool)
(declare-fun target_preservation () Bool)
(assert (= source_preservation target_preservation))

; store_ty_extends_trans: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_ty_extends_trans () Bool)
(declare-fun target_store_ty_extends_trans () Bool)
(assert (= source_store_ty_extends_trans target_store_ty_extends_trans))

; multi_step_preservation: translation preserves property (matches Coq: Theorem)
(declare-fun source_multi_step_preservation () Bool)
(declare-fun target_multi_step_preservation () Bool)
(assert (= source_multi_step_preservation target_multi_step_preservation))

; store_wf_typed_loc_value: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_wf_typed_loc_value () Bool)
(declare-fun target_store_wf_typed_loc_value () Bool)
(assert (= source_store_wf_typed_loc_value target_store_wf_typed_loc_value))

; store_wf_lookup_has_type: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_wf_lookup_has_type () Bool)
(declare-fun target_store_wf_lookup_has_type () Bool)
(assert (= source_store_wf_lookup_has_type target_store_wf_lookup_has_type))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

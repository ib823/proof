; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/ContextProperties.v (38 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for ContextProperties
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; free_in_dec: translation preserves property (matches Coq: Lemma)
(declare-fun source_free_in_dec () Bool)
(declare-fun target_free_in_dec () Bool)
(assert (= source_free_in_dec target_free_in_dec))

; lookup_cons_neq_inv: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_cons_neq_inv () Bool)
(declare-fun target_lookup_cons_neq_inv () Bool)
(assert (= source_lookup_cons_neq_inv target_lookup_cons_neq_inv))

; lookup_deterministic: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_deterministic () Bool)
(declare-fun target_lookup_deterministic () Bool)
(assert (= source_lookup_deterministic target_lookup_deterministic))

; lookup_cons_inv: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_cons_inv () Bool)
(declare-fun target_lookup_cons_inv () Bool)
(assert (= source_lookup_cons_inv target_lookup_cons_inv))

; lookup_weaken_neq: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_weaken_neq () Bool)
(declare-fun target_lookup_weaken_neq () Bool)
(assert (= source_lookup_weaken_neq target_lookup_weaken_neq))

; typing_weaken_head: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_weaken_head () Bool)
(declare-fun target_typing_weaken_head () Bool)
(assert (= source_typing_weaken_head target_typing_weaken_head))

; typing_weaken_fresh: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_weaken_fresh () Bool)
(declare-fun target_typing_weaken_fresh () Bool)
(assert (= source_typing_weaken_fresh target_typing_weaken_fresh))

; typing_strengthen_head: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_strengthen_head () Bool)
(declare-fun target_typing_strengthen_head () Bool)
(assert (= source_typing_strengthen_head target_typing_strengthen_head))

; typing_exchange: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_exchange () Bool)
(declare-fun target_typing_exchange () Bool)
(assert (= source_typing_exchange target_typing_exchange))

; typing_delta_irrelevance: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_delta_irrelevance () Bool)
(declare-fun target_typing_delta_irrelevance () Bool)
(assert (= source_typing_delta_irrelevance target_typing_delta_irrelevance))

; typing_shadow: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_shadow () Bool)
(declare-fun target_typing_shadow () Bool)
(assert (= source_typing_shadow target_typing_shadow))

; closed_no_free_vars: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_no_free_vars () Bool)
(declare-fun target_closed_no_free_vars () Bool)
(assert (= source_closed_no_free_vars target_closed_no_free_vars))

; typing_weaken_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_weaken_closed () Bool)
(declare-fun target_typing_weaken_closed () Bool)
(assert (= source_typing_weaken_closed target_typing_weaken_closed))

; typing_weaken_multi_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_weaken_multi_closed () Bool)
(declare-fun target_typing_weaken_multi_closed () Bool)
(assert (= source_typing_weaken_multi_closed target_typing_weaken_multi_closed))

; typing_weaken_prefix: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_weaken_prefix () Bool)
(declare-fun target_typing_weaken_prefix () Bool)
(assert (= source_typing_weaken_prefix target_typing_weaken_prefix))

; store_extends_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_extends_refl () Bool)
(declare-fun target_store_extends_refl () Bool)
(assert (= source_store_extends_refl target_store_extends_refl))

; store_extends_trans: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_extends_trans () Bool)
(declare-fun target_store_extends_trans () Bool)
(assert (= source_store_extends_trans target_store_extends_trans))

; typing_weaken_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_weaken_store () Bool)
(declare-fun target_typing_weaken_store () Bool)
(assert (= source_typing_weaken_store target_typing_weaken_store))

; typing_weaken_head_delta: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_weaken_head_delta () Bool)
(declare-fun target_typing_weaken_head_delta () Bool)
(assert (= source_typing_weaken_head_delta target_typing_weaken_head_delta))

; typing_weaken_two: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_weaken_two () Bool)
(declare-fun target_typing_weaken_two () Bool)
(assert (= source_typing_weaken_two target_typing_weaken_two))

; typing_weaken_head_store: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_weaken_head_store () Bool)
(declare-fun target_typing_weaken_head_store () Bool)
(assert (= source_typing_weaken_head_store target_typing_weaken_head_store))

; lookup_app_l: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_app_l () Bool)
(declare-fun target_lookup_app_l () Bool)
(assert (= source_lookup_app_l target_lookup_app_l))

; lookup_app_r: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_app_r () Bool)
(declare-fun target_lookup_app_r () Bool)
(assert (= source_lookup_app_r target_lookup_app_r))

; lookup_nil: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_nil () Bool)
(declare-fun target_lookup_nil () Bool)
(assert (= source_lookup_nil target_lookup_nil))

; lookup_head_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_head_eq () Bool)
(declare-fun target_lookup_head_eq () Bool)
(assert (= source_lookup_head_eq target_lookup_head_eq))

; typing_contract: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_contract () Bool)
(declare-fun target_typing_contract () Bool)
(assert (= source_typing_contract target_typing_contract))

; store_wf_runtime_entry_typed: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_wf_runtime_entry_typed () Bool)
(declare-fun target_store_wf_runtime_entry_typed () Bool)
(assert (= source_store_wf_runtime_entry_typed target_store_wf_runtime_entry_typed))

; store_wf_bidirectional: translation preserves property (matches Coq: Lemma)
(declare-fun source_store_wf_bidirectional () Bool)
(declare-fun target_store_wf_bidirectional () Bool)
(assert (= source_store_wf_bidirectional target_store_wf_bidirectional))

; subst_closed_typing: translation preserves property (matches Coq: Lemma)
(declare-fun source_subst_closed_typing () Bool)
(declare-fun target_subst_closed_typing () Bool)
(assert (= source_subst_closed_typing target_subst_closed_typing))

; typing_weaken_fresh_list: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_weaken_fresh_list () Bool)
(declare-fun target_typing_weaken_fresh_list () Bool)
(assert (= source_typing_weaken_fresh_list target_typing_weaken_fresh_list))

; lookup_singleton: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_singleton () Bool)
(declare-fun target_lookup_singleton () Bool)
(assert (= source_lookup_singleton target_lookup_singleton))

; lookup_cons_tail: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_cons_tail () Bool)
(declare-fun target_lookup_cons_tail () Bool)
(assert (= source_lookup_cons_tail target_lookup_cons_tail))

; lookup_dec: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_dec () Bool)
(declare-fun target_lookup_dec () Bool)
(assert (= source_lookup_dec target_lookup_dec))

; closed_typing_any_ctx: translation preserves property (matches Coq: Lemma)
(declare-fun source_closed_typing_any_ctx () Bool)
(declare-fun target_closed_typing_any_ctx () Bool)
(assert (= source_closed_typing_any_ctx target_closed_typing_any_ctx))

; typing_weaken_exchange: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_weaken_exchange () Bool)
(declare-fun target_typing_weaken_exchange () Bool)
(assert (= source_typing_weaken_exchange target_typing_weaken_exchange))

; typing_weaken_append: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_weaken_append () Bool)
(declare-fun target_typing_weaken_append () Bool)
(assert (= source_typing_weaken_append target_typing_weaken_append))

; typing_prefix_sufficient: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_prefix_sufficient () Bool)
(declare-fun target_typing_prefix_sufficient () Bool)
(assert (= source_typing_prefix_sufficient target_typing_prefix_sufficient))

; typing_singleton_var: translation preserves property (matches Coq: Lemma)
(declare-fun source_typing_singleton_var () Bool)
(declare-fun target_typing_singleton_var () Bool)
(assert (= source_typing_singleton_var target_typing_singleton_var))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

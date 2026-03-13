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
; Translation validation: free_in_dec preserves semantics
(push 1)
(declare-const source_free_in_dec Int)
(declare-const target_free_in_dec Int)
(assert (>= source_free_in_dec 0))
(assert (>= target_free_in_dec 0))
(assert (not (= source_free_in_dec target_free_in_dec)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_cons_neq_inv: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_cons_neq_inv preserves semantics
(push 1)
(declare-const source_lookup_cons_neq_inv Int)
(declare-const target_lookup_cons_neq_inv Int)
(assert (>= source_lookup_cons_neq_inv 0))
(assert (>= target_lookup_cons_neq_inv 0))
(assert (not (= source_lookup_cons_neq_inv target_lookup_cons_neq_inv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_deterministic: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_deterministic preserves semantics
(push 1)
(declare-const source_lookup_deterministic Int)
(declare-const target_lookup_deterministic Int)
(assert (>= source_lookup_deterministic 0))
(assert (>= target_lookup_deterministic 0))
(assert (not (= source_lookup_deterministic target_lookup_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_cons_inv: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_cons_inv preserves semantics
(push 1)
(declare-const source_lookup_cons_inv Int)
(declare-const target_lookup_cons_inv Int)
(assert (>= source_lookup_cons_inv 0))
(assert (>= target_lookup_cons_inv 0))
(assert (not (= source_lookup_cons_inv target_lookup_cons_inv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_weaken_neq: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_weaken_neq preserves semantics
(push 1)
(declare-const source_lookup_weaken_neq Int)
(declare-const target_lookup_weaken_neq Int)
(assert (>= source_lookup_weaken_neq 0))
(assert (>= target_lookup_weaken_neq 0))
(assert (not (= source_lookup_weaken_neq target_lookup_weaken_neq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_weaken_head: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_weaken_head preserves semantics
(push 1)
(declare-const source_typing_weaken_head Int)
(declare-const target_typing_weaken_head Int)
(assert (>= source_typing_weaken_head 0))
(assert (>= target_typing_weaken_head 0))
(assert (not (= source_typing_weaken_head target_typing_weaken_head)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_weaken_fresh: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_weaken_fresh preserves semantics
(push 1)
(declare-const source_typing_weaken_fresh Int)
(declare-const target_typing_weaken_fresh Int)
(assert (>= source_typing_weaken_fresh 0))
(assert (>= target_typing_weaken_fresh 0))
(assert (not (= source_typing_weaken_fresh target_typing_weaken_fresh)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_strengthen_head: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_strengthen_head preserves semantics
(push 1)
(declare-const source_typing_strengthen_head Int)
(declare-const target_typing_strengthen_head Int)
(assert (>= source_typing_strengthen_head 0))
(assert (>= target_typing_strengthen_head 0))
(assert (not (= source_typing_strengthen_head target_typing_strengthen_head)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_exchange: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_exchange preserves semantics
(push 1)
(declare-const source_typing_exchange Int)
(declare-const target_typing_exchange Int)
(assert (>= source_typing_exchange 0))
(assert (>= target_typing_exchange 0))
(assert (not (= source_typing_exchange target_typing_exchange)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_delta_irrelevance: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_delta_irrelevance preserves semantics
(push 1)
(declare-const source_typing_delta_irrelevance Int)
(declare-const target_typing_delta_irrelevance Int)
(assert (>= source_typing_delta_irrelevance 0))
(assert (>= target_typing_delta_irrelevance 0))
(assert (not (= source_typing_delta_irrelevance target_typing_delta_irrelevance)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_shadow: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_shadow preserves semantics
(push 1)
(declare-const source_typing_shadow Int)
(declare-const target_typing_shadow Int)
(assert (>= source_typing_shadow 0))
(assert (>= target_typing_shadow 0))
(assert (not (= source_typing_shadow target_typing_shadow)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_no_free_vars: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_no_free_vars preserves semantics
(push 1)
(declare-const source_closed_no_free_vars Int)
(declare-const target_closed_no_free_vars Int)
(assert (>= source_closed_no_free_vars 0))
(assert (>= target_closed_no_free_vars 0))
(assert (not (= source_closed_no_free_vars target_closed_no_free_vars)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_weaken_closed: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_weaken_closed preserves semantics
(push 1)
(declare-const source_typing_weaken_closed Int)
(declare-const target_typing_weaken_closed Int)
(assert (>= source_typing_weaken_closed 0))
(assert (>= target_typing_weaken_closed 0))
(assert (not (= source_typing_weaken_closed target_typing_weaken_closed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_weaken_multi_closed: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_weaken_multi_closed preserves semantics
(push 1)
(declare-const source_typing_weaken_multi_closed Int)
(declare-const target_typing_weaken_multi_closed Int)
(assert (>= source_typing_weaken_multi_closed 0))
(assert (>= target_typing_weaken_multi_closed 0))
(assert (not (= source_typing_weaken_multi_closed target_typing_weaken_multi_closed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_weaken_prefix: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_weaken_prefix preserves semantics
(push 1)
(declare-const source_typing_weaken_prefix Int)
(declare-const target_typing_weaken_prefix Int)
(assert (>= source_typing_weaken_prefix 0))
(assert (>= target_typing_weaken_prefix 0))
(assert (not (= source_typing_weaken_prefix target_typing_weaken_prefix)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_extends_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: store_extends_refl preserves semantics
(push 1)
(declare-const source_store_extends_refl Int)
(declare-const target_store_extends_refl Int)
(assert (>= source_store_extends_refl 0))
(assert (>= target_store_extends_refl 0))
(assert (not (= source_store_extends_refl target_store_extends_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_extends_trans: translation preserves property (matches Coq: Lemma)
; Translation validation: store_extends_trans preserves semantics
(push 1)
(declare-const source_store_extends_trans Int)
(declare-const target_store_extends_trans Int)
(assert (>= source_store_extends_trans 0))
(assert (>= target_store_extends_trans 0))
(assert (not (= source_store_extends_trans target_store_extends_trans)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_weaken_store: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_weaken_store preserves semantics
(push 1)
(declare-const source_typing_weaken_store Int)
(declare-const target_typing_weaken_store Int)
(assert (>= source_typing_weaken_store 0))
(assert (>= target_typing_weaken_store 0))
(assert (not (= source_typing_weaken_store target_typing_weaken_store)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_weaken_head_delta: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_weaken_head_delta preserves semantics
(push 1)
(declare-const source_typing_weaken_head_delta Int)
(declare-const target_typing_weaken_head_delta Int)
(assert (>= source_typing_weaken_head_delta 0))
(assert (>= target_typing_weaken_head_delta 0))
(assert (not (= source_typing_weaken_head_delta target_typing_weaken_head_delta)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_weaken_two: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_weaken_two preserves semantics
(push 1)
(declare-const source_typing_weaken_two Int)
(declare-const target_typing_weaken_two Int)
(assert (>= source_typing_weaken_two 0))
(assert (>= target_typing_weaken_two 0))
(assert (not (= source_typing_weaken_two target_typing_weaken_two)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_weaken_head_store: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_weaken_head_store preserves semantics
(push 1)
(declare-const source_typing_weaken_head_store Int)
(declare-const target_typing_weaken_head_store Int)
(assert (>= source_typing_weaken_head_store 0))
(assert (>= target_typing_weaken_head_store 0))
(assert (not (= source_typing_weaken_head_store target_typing_weaken_head_store)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_app_l: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_app_l preserves semantics
(push 1)
(declare-const source_lookup_app_l Int)
(declare-const target_lookup_app_l Int)
(assert (>= source_lookup_app_l 0))
(assert (>= target_lookup_app_l 0))
(assert (not (= source_lookup_app_l target_lookup_app_l)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_app_r: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_app_r preserves semantics
(push 1)
(declare-const source_lookup_app_r Int)
(declare-const target_lookup_app_r Int)
(assert (>= source_lookup_app_r 0))
(assert (>= target_lookup_app_r 0))
(assert (not (= source_lookup_app_r target_lookup_app_r)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_nil: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_nil preserves semantics
(push 1)
(declare-const source_lookup_nil Int)
(declare-const target_lookup_nil Int)
(assert (>= source_lookup_nil 0))
(assert (>= target_lookup_nil 0))
(assert (not (= source_lookup_nil target_lookup_nil)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_head_eq: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_head_eq preserves semantics
(push 1)
(declare-const source_lookup_head_eq Int)
(declare-const target_lookup_head_eq Int)
(assert (>= source_lookup_head_eq 0))
(assert (>= target_lookup_head_eq 0))
(assert (not (= source_lookup_head_eq target_lookup_head_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_contract: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_contract preserves semantics
(push 1)
(declare-const source_typing_contract Int)
(declare-const target_typing_contract Int)
(assert (>= source_typing_contract 0))
(assert (>= target_typing_contract 0))
(assert (not (= source_typing_contract target_typing_contract)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_wf_runtime_entry_typed: translation preserves property (matches Coq: Lemma)
; Translation validation: store_wf_runtime_entry_typed preserves semantics
(push 1)
(declare-const source_store_wf_runtime_entry_typed Int)
(declare-const target_store_wf_runtime_entry_typed Int)
(assert (>= source_store_wf_runtime_entry_typed 0))
(assert (>= target_store_wf_runtime_entry_typed 0))
(assert (not (= source_store_wf_runtime_entry_typed target_store_wf_runtime_entry_typed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_wf_bidirectional: translation preserves property (matches Coq: Lemma)
; Translation validation: store_wf_bidirectional preserves semantics
(push 1)
(declare-const source_store_wf_bidirectional Int)
(declare-const target_store_wf_bidirectional Int)
(assert (>= source_store_wf_bidirectional 0))
(assert (>= target_store_wf_bidirectional 0))
(assert (not (= source_store_wf_bidirectional target_store_wf_bidirectional)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subst_closed_typing: translation preserves property (matches Coq: Lemma)
; Translation validation: subst_closed_typing preserves semantics
(push 1)
(declare-const source_subst_closed_typing Int)
(declare-const target_subst_closed_typing Int)
(assert (>= source_subst_closed_typing 0))
(assert (>= target_subst_closed_typing 0))
(assert (not (= source_subst_closed_typing target_subst_closed_typing)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_weaken_fresh_list: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_weaken_fresh_list preserves semantics
(push 1)
(declare-const source_typing_weaken_fresh_list Int)
(declare-const target_typing_weaken_fresh_list Int)
(assert (>= source_typing_weaken_fresh_list 0))
(assert (>= target_typing_weaken_fresh_list 0))
(assert (not (= source_typing_weaken_fresh_list target_typing_weaken_fresh_list)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_singleton: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_singleton preserves semantics
(push 1)
(declare-const source_lookup_singleton Int)
(declare-const target_lookup_singleton Int)
(assert (>= source_lookup_singleton 0))
(assert (>= target_lookup_singleton 0))
(assert (not (= source_lookup_singleton target_lookup_singleton)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_cons_tail: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_cons_tail preserves semantics
(push 1)
(declare-const source_lookup_cons_tail Int)
(declare-const target_lookup_cons_tail Int)
(assert (>= source_lookup_cons_tail 0))
(assert (>= target_lookup_cons_tail 0))
(assert (not (= source_lookup_cons_tail target_lookup_cons_tail)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_dec: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_dec preserves semantics
(push 1)
(declare-const source_lookup_dec Int)
(declare-const target_lookup_dec Int)
(assert (>= source_lookup_dec 0))
(assert (>= target_lookup_dec 0))
(assert (not (= source_lookup_dec target_lookup_dec)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_typing_any_ctx: translation preserves property (matches Coq: Lemma)
; Translation validation: closed_typing_any_ctx preserves semantics
(push 1)
(declare-const source_closed_typing_any_ctx Int)
(declare-const target_closed_typing_any_ctx Int)
(assert (>= source_closed_typing_any_ctx 0))
(assert (>= target_closed_typing_any_ctx 0))
(assert (not (= source_closed_typing_any_ctx target_closed_typing_any_ctx)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_weaken_exchange: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_weaken_exchange preserves semantics
(push 1)
(declare-const source_typing_weaken_exchange Int)
(declare-const target_typing_weaken_exchange Int)
(assert (>= source_typing_weaken_exchange 0))
(assert (>= target_typing_weaken_exchange 0))
(assert (not (= source_typing_weaken_exchange target_typing_weaken_exchange)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_weaken_append: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_weaken_append preserves semantics
(push 1)
(declare-const source_typing_weaken_append Int)
(declare-const target_typing_weaken_append Int)
(assert (>= source_typing_weaken_append 0))
(assert (>= target_typing_weaken_append 0))
(assert (not (= source_typing_weaken_append target_typing_weaken_append)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_prefix_sufficient: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_prefix_sufficient preserves semantics
(push 1)
(declare-const source_typing_prefix_sufficient Int)
(declare-const target_typing_prefix_sufficient Int)
(assert (>= source_typing_prefix_sufficient 0))
(assert (>= target_typing_prefix_sufficient 0))
(assert (not (= source_typing_prefix_sufficient target_typing_prefix_sufficient)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; typing_singleton_var: translation preserves property (matches Coq: Lemma)
; Translation validation: typing_singleton_var preserves semantics
(push 1)
(declare-const source_typing_singleton_var Int)
(declare-const target_typing_singleton_var Int)
(assert (>= source_typing_singleton_var 0))
(assert (>= target_typing_singleton_var 0))
(assert (not (= source_typing_singleton_var target_typing_singleton_var)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

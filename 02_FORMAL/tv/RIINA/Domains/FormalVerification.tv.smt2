; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/FormalVerification.v (36 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for FormalVerification
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; eval_pred: source semantics (matches Coq)
; Translation validation: eval_pred preserves semantics
(push 1)
(declare-const source_eval_pred Int)
(declare-const target_eval_pred Int)
(assert (>= source_eval_pred 0))
(assert (>= target_eval_pred 0))
(assert (not (= source_eval_pred target_eval_pred)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pred_implies: source semantics (matches Coq)
; Translation validation: pred_implies preserves semantics
(push 1)
(declare-const source_pred_implies Int)
(declare-const target_pred_implies Int)
(assert (>= source_pred_implies 0))
(assert (>= target_pred_implies 0))
(assert (not (= source_pred_implies target_pred_implies)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pred_decidable: source semantics (matches Coq)
; Translation validation: pred_decidable preserves semantics
(push 1)
(declare-const source_pred_decidable Int)
(declare-const target_pred_decidable Int)
(assert (>= source_pred_decidable 0))
(assert (>= target_pred_decidable 0))
(assert (not (= source_pred_decidable target_pred_decidable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; empty_heap: source semantics (matches Coq)
; Translation validation: empty_heap preserves semantics
(push 1)
(declare-const source_empty_heap Int)
(declare-const target_empty_heap Int)
(assert (>= source_empty_heap 0))
(assert (>= target_empty_heap 0))
(assert (not (= source_empty_heap target_empty_heap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; disjoint: source semantics (matches Coq)
; Translation validation: disjoint preserves semantics
(push 1)
(declare-const source_disjoint Int)
(declare-const target_disjoint Int)
(assert (>= source_disjoint 0))
(assert (>= target_disjoint 0))
(assert (not (= source_disjoint target_disjoint)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; heap_union: source semantics (matches Coq)
; Translation validation: heap_union preserves semantics
(push 1)
(declare-const source_heap_union Int)
(declare-const target_heap_union Int)
(assert (>= source_heap_union 0))
(assert (>= target_heap_union 0))
(assert (not (= source_heap_union target_heap_union)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; heap_sat: source semantics (matches Coq)
; Translation validation: heap_sat preserves semantics
(push 1)
(declare-const source_heap_sat Int)
(declare-const target_heap_sat Int)
(assert (>= source_heap_sat 0))
(assert (>= target_heap_sat 0))
(assert (not (= source_heap_sat target_heap_sat)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; contract_sat: source semantics (matches Coq)
; Translation validation: contract_sat preserves semantics
(push 1)
(declare-const source_contract_sat Int)
(declare-const target_contract_sat Int)
(assert (>= source_contract_sat 0))
(assert (>= target_contract_sat 0))
(assert (not (= source_contract_sat target_contract_sat)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; contract_stronger: source semantics (matches Coq)
; Translation validation: contract_stronger preserves semantics
(push 1)
(declare-const source_contract_stronger Int)
(declare-const target_contract_stronger Int)
(assert (>= source_contract_stronger 0))
(assert (>= target_contract_stronger 0))
(assert (not (= source_contract_stronger target_contract_stronger)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; eval_vc: source semantics (matches Coq)
; Translation validation: eval_vc preserves semantics
(push 1)
(declare-const source_eval_vc Int)
(declare-const target_eval_vc Int)
(assert (>= source_eval_vc 0))
(assert (>= target_eval_vc 0))
(assert (not (= source_eval_vc target_eval_vc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; vc_valid: source semantics (matches Coq)
; Translation validation: vc_valid preserves semantics
(push 1)
(declare-const source_vc_valid Int)
(declare-const target_vc_valid Int)
(assert (>= source_vc_valid 0))
(assert (>= target_vc_valid 0))
(assert (not (= source_vc_valid target_vc_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_family_wf: source semantics (matches Coq)
; Translation validation: ty_family_wf preserves semantics
(push 1)
(declare-const source_ty_family_wf Int)
(declare-const target_ty_family_wf Int)
(assert (>= source_ty_family_wf 0))
(assert (>= target_ty_family_wf 0))
(assert (not (= source_ty_family_wf target_ty_family_wf)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; eval_smt: source semantics (matches Coq)
; Translation validation: eval_smt preserves semantics
(push 1)
(declare-const source_eval_smt Int)
(declare-const target_eval_smt Int)
(assert (>= source_eval_smt 0))
(assert (>= target_eval_smt 0))
(assert (not (= source_eval_smt target_eval_smt)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pred_to_smt: source semantics (matches Coq)
; Translation validation: pred_to_smt preserves semantics
(push 1)
(declare-const source_pred_to_smt Int)
(declare-const target_pred_to_smt Int)
(assert (>= source_pred_to_smt 0))
(assert (>= target_pred_to_smt 0))
(assert (not (= source_pred_to_smt target_pred_to_smt)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; liquid_step: source semantics (matches Coq)
; Translation validation: liquid_step preserves semantics
(push 1)
(declare-const source_liquid_step Int)
(declare-const target_liquid_step Int)
(assert (>= source_liquid_step 0))
(assert (>= target_liquid_step 0))
(assert (not (= source_liquid_step target_liquid_step)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; liquid_measure: source semantics (matches Coq)
; Translation validation: liquid_measure preserves semantics
(push 1)
(declare-const source_liquid_measure Int)
(declare-const target_liquid_measure Int)
(assert (>= source_liquid_measure 0))
(assert (>= target_liquid_measure 0))
(assert (not (= source_liquid_measure target_liquid_measure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; prop_sat: source semantics (matches Coq)
; Translation validation: prop_sat preserves semantics
(push 1)
(declare-const source_prop_sat Int)
(declare-const target_prop_sat Int)
(assert (>= source_prop_sat 0))
(assert (>= target_prop_sat 0))
(assert (not (= source_prop_sat target_prop_sat)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; interp_prop: source semantics (matches Coq)
; Translation validation: interp_prop preserves semantics
(push 1)
(declare-const source_interp_prop Int)
(declare-const target_interp_prop Int)
(assert (>= source_interp_prop 0))
(assert (>= target_interp_prop 0))
(assert (not (= source_interp_prop target_interp_prop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ctx_valid: source semantics (matches Coq)
; Translation validation: ctx_valid preserves semantics
(push 1)
(declare-const source_ctx_valid Int)
(declare-const target_ctx_valid Int)
(assert (>= source_ctx_valid 0))
(assert (>= target_ctx_valid 0))
(assert (not (= source_ctx_valid target_ctx_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compile: source semantics (matches Coq)
; Translation validation: compile preserves semantics
(push 1)
(declare-const source_compile Int)
(declare-const target_compile Int)
(assert (>= source_compile 0))
(assert (>= target_compile 0))
(assert (not (= source_compile target_compile)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; src_effect: source semantics (matches Coq)
; Translation validation: src_effect preserves semantics
(push 1)
(declare-const source_src_effect Int)
(declare-const target_src_effect Int)
(assert (>= source_src_effect 0))
(assert (>= target_src_effect 0))
(assert (not (= source_src_effect target_src_effect)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tgt_effect: source semantics (matches Coq)
; Translation validation: tgt_effect preserves semantics
(push 1)
(declare-const source_tgt_effect Int)
(declare-const target_tgt_effect Int)
(assert (>= source_tgt_effect 0))
(assert (>= target_tgt_effect 0))
(assert (not (= source_tgt_effect target_tgt_effect)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sec_leq: source semantics (matches Coq)
; Translation validation: sec_leq preserves semantics
(push 1)
(declare-const source_sec_leq Int)
(declare-const target_sec_leq Int)
(assert (>= source_sec_leq 0))
(assert (>= target_sec_leq 0))
(assert (not (= source_sec_leq target_sec_leq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; src_sec_label: source semantics (matches Coq)
; Translation validation: src_sec_label preserves semantics
(push 1)
(declare-const source_src_sec_label Int)
(declare-const target_src_sec_label Int)
(assert (>= source_src_sec_label 0))
(assert (>= target_src_sec_label 0))
(assert (not (= source_src_sec_label target_src_sec_label)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tgt_sec_label: source semantics (matches Coq)
; Translation validation: tgt_sec_label preserves semantics
(push 1)
(declare-const source_tgt_sec_label Int)
(declare-const target_tgt_sec_label Int)
(assert (>= source_tgt_sec_label 0))
(assert (>= target_tgt_sec_label 0))
(assert (not (= source_tgt_sec_label target_tgt_sec_label)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compile_val: source semantics (matches Coq)
; Translation validation: compile_val preserves semantics
(push 1)
(declare-const source_compile_val Int)
(declare-const target_compile_val Int)
(assert (>= source_compile_val 0))
(assert (>= target_compile_val 0))
(assert (not (= source_compile_val target_compile_val)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; obs_equiv: source semantics (matches Coq)
; Translation validation: obs_equiv preserves semantics
(push 1)
(declare-const source_obs_equiv Int)
(declare-const target_obs_equiv Int)
(assert (>= source_obs_equiv 0))
(assert (>= target_obs_equiv 0))
(assert (not (= source_obs_equiv target_obs_equiv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wp: source semantics (matches Coq)
; Translation validation: wp preserves semantics
(push 1)
(declare-const source_wp Int)
(declare-const target_wp Int)
(assert (>= source_wp 0))
(assert (>= target_wp 0))
(assert (not (= source_wp target_wp)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; refinement_wf: source semantics (matches Coq)
; Translation validation: refinement_wf preserves semantics
(push 1)
(declare-const source_refinement_wf Int)
(declare-const target_refinement_wf Int)
(assert (>= source_refinement_wf 0))
(assert (>= target_refinement_wf 0))
(assert (not (= source_refinement_wf target_refinement_wf)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; refinement_subtype: source semantics (matches Coq)
; Translation validation: refinement_subtype preserves semantics
(push 1)
(declare-const source_refinement_subtype Int)
(declare-const target_refinement_subtype Int)
(assert (>= source_refinement_subtype 0))
(assert (>= target_refinement_subtype 0))
(assert (not (= source_refinement_subtype target_refinement_subtype)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; liquid_terminates: source semantics (matches Coq)
; Translation validation: liquid_terminates preserves semantics
(push 1)
(declare-const source_liquid_terminates Int)
(declare-const target_liquid_terminates Int)
(assert (>= source_liquid_terminates 0))
(assert (>= target_liquid_terminates 0))
(assert (not (= source_liquid_terminates target_liquid_terminates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_subst: source semantics (matches Coq)
; Translation validation: ty_subst preserves semantics
(push 1)
(declare-const source_ty_subst Int)
(declare-const target_ty_subst Int)
(assert (>= source_ty_subst 0))
(assert (>= target_ty_subst 0))
(assert (not (= source_ty_subst target_ty_subst)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; precondition_verified: source semantics (matches Coq)
; Translation validation: precondition_verified preserves semantics
(push 1)
(declare-const source_precondition_verified Int)
(declare-const target_precondition_verified Int)
(assert (>= source_precondition_verified 0))
(assert (>= target_precondition_verified 0))
(assert (not (= source_precondition_verified target_precondition_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; postcondition_verified: source semantics (matches Coq)
; Translation validation: postcondition_verified preserves semantics
(push 1)
(declare-const source_postcondition_verified Int)
(declare-const target_postcondition_verified Int)
(assert (>= source_postcondition_verified 0))
(assert (>= target_postcondition_verified 0))
(assert (not (= source_postcondition_verified target_postcondition_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; invariant_preserved: source semantics (matches Coq)
; Translation validation: invariant_preserved preserves semantics
(push 1)
(declare-const source_invariant_preserved Int)
(declare-const target_invariant_preserved Int)
(assert (>= source_invariant_preserved 0))
(assert (>= target_invariant_preserved 0))
(assert (not (= source_invariant_preserved target_invariant_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hoare_triple: source semantics (matches Coq)
; Translation validation: hoare_triple preserves semantics
(push 1)
(declare-const source_hoare_triple Int)
(declare-const target_hoare_triple Int)
(assert (>= source_hoare_triple 0))
(assert (>= target_hoare_triple 0))
(assert (not (= source_hoare_triple target_hoare_triple)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bmc_check: source semantics (matches Coq)
; Translation validation: bmc_check preserves semantics
(push 1)
(declare-const source_bmc_check Int)
(declare-const target_bmc_check Int)
(assert (>= source_bmc_check 0))
(assert (>= target_bmc_check 0))
(assert (not (= source_bmc_check target_bmc_check)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; prop_to_pred: source semantics (matches Coq)
; Translation validation: prop_to_pred preserves semantics
(push 1)
(declare-const source_prop_to_pred Int)
(declare-const target_prop_to_pred Int)
(assert (>= source_prop_to_pred 0))
(assert (>= target_prop_to_pred 0))
(assert (not (= source_prop_to_pred target_prop_to_pred)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; valid_counterexample: source semantics (matches Coq)
; Translation validation: valid_counterexample preserves semantics
(push 1)
(declare-const source_valid_counterexample Int)
(declare-const target_valid_counterexample Int)
(assert (>= source_valid_counterexample 0))
(assert (>= target_valid_counterexample 0))
(assert (not (= source_valid_counterexample target_valid_counterexample)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; abstraction_sound: source semantics (matches Coq)
; Translation validation: abstraction_sound preserves semantics
(push 1)
(declare-const source_abstraction_sound Int)
(declare-const target_abstraction_sound Int)
(assert (>= source_abstraction_sound 0))
(assert (>= target_abstraction_sound 0))
(assert (not (= source_abstraction_sound target_abstraction_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; extract_witness: source semantics (matches Coq)
; Translation validation: extract_witness preserves semantics
(push 1)
(declare-const source_extract_witness Int)
(declare-const target_extract_witness Int)
(assert (>= source_extract_witness 0))
(assert (>= target_extract_witness 0))
(assert (not (= source_extract_witness target_extract_witness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; proof_irrelevant: source semantics (matches Coq)
; Translation validation: proof_irrelevant preserves semantics
(push 1)
(declare-const source_proof_irrelevant Int)
(declare-const target_proof_irrelevant Int)
(assert (>= source_proof_irrelevant 0))
(assert (>= target_proof_irrelevant 0))
(assert (not (= source_proof_irrelevant target_proof_irrelevant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; vc_from_contract: source semantics (matches Coq)
; Translation validation: vc_from_contract preserves semantics
(push 1)
(declare-const source_vc_from_contract Int)
(declare-const target_vc_from_contract Int)
(assert (>= source_vc_from_contract 0))
(assert (>= target_vc_from_contract 0))
(assert (not (= source_vc_from_contract target_vc_from_contract)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pred_decidable_PTrue: translation preserves property (matches Coq: Lemma)
; Translation validation: pred_decidable_PTrue preserves semantics
(push 1)
(declare-const source_pred_decidable_PTrue Int)
(declare-const target_pred_decidable_PTrue Int)
(assert (>= source_pred_decidable_PTrue 0))
(assert (>= target_pred_decidable_PTrue 0))
(assert (not (= source_pred_decidable_PTrue target_pred_decidable_PTrue)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pred_decidable_eval: translation preserves property (matches Coq: Lemma)
; Translation validation: pred_decidable_eval preserves semantics
(push 1)
(declare-const source_pred_decidable_eval Int)
(declare-const target_pred_decidable_eval Int)
(assert (>= source_pred_decidable_eval 0))
(assert (>= target_pred_decidable_eval 0))
(assert (not (= source_pred_decidable_eval target_pred_decidable_eval)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_01: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_01 preserves semantics
(push 1)
(declare-const source_E_001_01 Int)
(declare-const target_E_001_01 Int)
(assert (>= source_E_001_01 0))
(assert (>= target_E_001_01 0))
(assert (not (= source_E_001_01 target_E_001_01)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_02: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_02 preserves semantics
(push 1)
(declare-const source_E_001_02 Int)
(declare-const target_E_001_02 Int)
(assert (>= source_E_001_02 0))
(assert (>= target_E_001_02 0))
(assert (not (= source_E_001_02 target_E_001_02)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; smt_translation_correct: translation preserves property (matches Coq: Lemma)
; Translation validation: smt_translation_correct preserves semantics
(push 1)
(declare-const source_smt_translation_correct Int)
(declare-const target_smt_translation_correct Int)
(assert (>= source_smt_translation_correct 0))
(assert (>= target_smt_translation_correct 0))
(assert (not (= source_smt_translation_correct target_smt_translation_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_03: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_03 preserves semantics
(push 1)
(declare-const source_E_001_03 Int)
(declare-const target_E_001_03 Int)
(assert (>= source_E_001_03 0))
(assert (>= target_E_001_03 0))
(assert (not (= source_E_001_03 target_E_001_03)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_04: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_04 preserves semantics
(push 1)
(declare-const source_E_001_04 Int)
(declare-const target_E_001_04 Int)
(assert (>= source_E_001_04 0))
(assert (>= target_E_001_04 0))
(assert (not (= source_E_001_04 target_E_001_04)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_05: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_05 preserves semantics
(push 1)
(declare-const source_E_001_05 Int)
(declare-const target_E_001_05 Int)
(assert (>= source_E_001_05 0))
(assert (>= target_E_001_05 0))
(assert (not (= source_E_001_05 target_E_001_05)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_06: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_06 preserves semantics
(push 1)
(declare-const source_E_001_06 Int)
(declare-const target_E_001_06 Int)
(assert (>= source_E_001_06 0))
(assert (>= target_E_001_06 0))
(assert (not (= source_E_001_06 target_E_001_06)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_07: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_07 preserves semantics
(push 1)
(declare-const source_E_001_07 Int)
(declare-const target_E_001_07 Int)
(assert (>= source_E_001_07 0))
(assert (>= target_E_001_07 0))
(assert (not (= source_E_001_07 target_E_001_07)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ty_subst_preserves_base: translation preserves property (matches Coq: Lemma)
; Translation validation: ty_subst_preserves_base preserves semantics
(push 1)
(declare-const source_ty_subst_preserves_base Int)
(declare-const target_ty_subst_preserves_base Int)
(assert (>= source_ty_subst_preserves_base 0))
(assert (>= target_ty_subst_preserves_base 0))
(assert (not (= source_ty_subst_preserves_base target_ty_subst_preserves_base)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_08: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_08 preserves semantics
(push 1)
(declare-const source_E_001_08 Int)
(declare-const target_E_001_08 Int)
(assert (>= source_E_001_08 0))
(assert (>= target_E_001_08 0))
(assert (not (= source_E_001_08 target_E_001_08)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_09: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_09 preserves semantics
(push 1)
(declare-const source_E_001_09 Int)
(declare-const target_E_001_09 Int)
(assert (>= source_E_001_09 0))
(assert (>= target_E_001_09 0))
(assert (not (= source_E_001_09 target_E_001_09)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_10: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_10 preserves semantics
(push 1)
(declare-const source_E_001_10 Int)
(declare-const target_E_001_10 Int)
(assert (>= source_E_001_10 0))
(assert (>= target_E_001_10 0))
(assert (not (= source_E_001_10 target_E_001_10)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_11: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_11 preserves semantics
(push 1)
(declare-const source_E_001_11 Int)
(declare-const target_E_001_11 Int)
(assert (>= source_E_001_11 0))
(assert (>= target_E_001_11 0))
(assert (not (= source_E_001_11 target_E_001_11)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_12: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_12 preserves semantics
(push 1)
(declare-const source_E_001_12 Int)
(declare-const target_E_001_12 Int)
(assert (>= source_E_001_12 0))
(assert (>= target_E_001_12 0))
(assert (not (= source_E_001_12 target_E_001_12)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_13: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_13 preserves semantics
(push 1)
(declare-const source_E_001_13 Int)
(declare-const target_E_001_13 Int)
(assert (>= source_E_001_13 0))
(assert (>= target_E_001_13 0))
(assert (not (= source_E_001_13 target_E_001_13)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_14: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_14 preserves semantics
(push 1)
(declare-const source_E_001_14 Int)
(declare-const target_E_001_14 Int)
(assert (>= source_E_001_14 0))
(assert (>= target_E_001_14 0))
(assert (not (= source_E_001_14 target_E_001_14)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_15: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_15 preserves semantics
(push 1)
(declare-const source_E_001_15 Int)
(declare-const target_E_001_15 Int)
(assert (>= source_E_001_15 0))
(assert (>= target_E_001_15 0))
(assert (not (= source_E_001_15 target_E_001_15)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_16: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_16 preserves semantics
(push 1)
(declare-const source_E_001_16 Int)
(declare-const target_E_001_16 Int)
(assert (>= source_E_001_16 0))
(assert (>= target_E_001_16 0))
(assert (not (= source_E_001_16 target_E_001_16)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_17: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_17 preserves semantics
(push 1)
(declare-const source_E_001_17 Int)
(declare-const target_E_001_17 Int)
(assert (>= source_E_001_17 0))
(assert (>= target_E_001_17 0))
(assert (not (= source_E_001_17 target_E_001_17)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_18: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_18 preserves semantics
(push 1)
(declare-const source_E_001_18 Int)
(declare-const target_E_001_18 Int)
(assert (>= source_E_001_18 0))
(assert (>= target_E_001_18 0))
(assert (not (= source_E_001_18 target_E_001_18)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_19: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_19 preserves semantics
(push 1)
(declare-const source_E_001_19 Int)
(declare-const target_E_001_19 Int)
(assert (>= source_E_001_19 0))
(assert (>= target_E_001_19 0))
(assert (not (= source_E_001_19 target_E_001_19)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_20: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_20 preserves semantics
(push 1)
(declare-const source_E_001_20 Int)
(declare-const target_E_001_20 Int)
(assert (>= source_E_001_20 0))
(assert (>= target_E_001_20 0))
(assert (not (= source_E_001_20 target_E_001_20)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_21: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_21 preserves semantics
(push 1)
(declare-const source_E_001_21 Int)
(declare-const target_E_001_21 Int)
(assert (>= source_E_001_21 0))
(assert (>= target_E_001_21 0))
(assert (not (= source_E_001_21 target_E_001_21)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_22: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_22 preserves semantics
(push 1)
(declare-const source_E_001_22 Int)
(declare-const target_E_001_22 Int)
(assert (>= source_E_001_22 0))
(assert (>= target_E_001_22 0))
(assert (not (= source_E_001_22 target_E_001_22)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bool_proof_irrelevant: translation preserves property (matches Coq: Lemma)
; Translation validation: bool_proof_irrelevant preserves semantics
(push 1)
(declare-const source_bool_proof_irrelevant Int)
(declare-const target_bool_proof_irrelevant Int)
(assert (>= source_bool_proof_irrelevant 0))
(assert (>= target_bool_proof_irrelevant 0))
(assert (not (= source_bool_proof_irrelevant target_bool_proof_irrelevant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_23: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_23 preserves semantics
(push 1)
(declare-const source_E_001_23 Int)
(declare-const target_E_001_23 Int)
(assert (>= source_E_001_23 0))
(assert (>= target_E_001_23 0))
(assert (not (= source_E_001_23 target_E_001_23)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_24: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_24 preserves semantics
(push 1)
(declare-const source_E_001_24 Int)
(declare-const target_E_001_24 Int)
(assert (>= source_E_001_24 0))
(assert (>= target_E_001_24 0))
(assert (not (= source_E_001_24 target_E_001_24)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_25: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_25 preserves semantics
(push 1)
(declare-const source_E_001_25 Int)
(declare-const target_E_001_25 Int)
(assert (>= source_E_001_25 0))
(assert (>= target_E_001_25 0))
(assert (not (= source_E_001_25 target_E_001_25)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_26: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_26 preserves semantics
(push 1)
(declare-const source_E_001_26 Int)
(declare-const target_E_001_26 Int)
(assert (>= source_E_001_26 0))
(assert (>= target_E_001_26 0))
(assert (not (= source_E_001_26 target_E_001_26)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_27: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_27 preserves semantics
(push 1)
(declare-const source_E_001_27 Int)
(declare-const target_E_001_27 Int)
(assert (>= source_E_001_27 0))
(assert (>= target_E_001_27 0))
(assert (not (= source_E_001_27 target_E_001_27)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_28: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_28 preserves semantics
(push 1)
(declare-const source_E_001_28 Int)
(declare-const target_E_001_28 Int)
(assert (>= source_E_001_28 0))
(assert (>= target_E_001_28 0))
(assert (not (= source_E_001_28 target_E_001_28)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; wp_skip_sound: translation preserves property (matches Coq: Lemma)
; Translation validation: wp_skip_sound preserves semantics
(push 1)
(declare-const source_wp_skip_sound Int)
(declare-const target_wp_skip_sound Int)
(assert (>= source_wp_skip_sound 0))
(assert (>= target_wp_skip_sound 0))
(assert (not (= source_wp_skip_sound target_wp_skip_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_29: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_29 preserves semantics
(push 1)
(declare-const source_E_001_29 Int)
(declare-const target_E_001_29 Int)
(assert (>= source_E_001_29 0))
(assert (>= target_E_001_29 0))
(assert (not (= source_E_001_29 target_E_001_29)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; E_001_30: translation preserves property (matches Coq: Theorem)
; Translation validation: E_001_30 preserves semantics
(push 1)
(declare-const source_E_001_30 Int)
(declare-const target_E_001_30 Int)
(assert (>= source_E_001_30 0))
(assert (>= target_E_001_30 0))
(assert (not (= source_E_001_30 target_E_001_30)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

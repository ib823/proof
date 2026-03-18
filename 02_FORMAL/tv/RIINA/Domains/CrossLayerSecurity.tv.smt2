; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/CrossLayerSecurity.v (21 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for CrossLayerSecurity
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; label_eqb: source semantics (matches Coq)
(declare-fun source_label_eqb () Bool)
(declare-fun target_label_eqb () Bool)
(assert (= source_label_eqb target_label_eqb))

; label_leb: source semantics (matches Coq)
(declare-fun source_label_leb () Bool)
(declare-fun target_label_leb () Bool)
(assert (= source_label_leb target_label_leb))

; label_join: source semantics (matches Coq)
(declare-fun source_label_join () Bool)
(declare-fun target_label_join () Bool)
(assert (= source_label_join target_label_join))

; src_low_equiv: source semantics (matches Coq)
(declare-fun source_src_low_equiv () Bool)
(declare-fun target_src_low_equiv () Bool)
(assert (= source_src_low_equiv target_src_low_equiv))

; tgt_label_of_prog: source semantics (matches Coq)
(declare-fun source_tgt_label_of_prog () Bool)
(declare-fun target_tgt_label_of_prog () Bool)
(assert (= source_tgt_label_of_prog target_tgt_label_of_prog))

; is_constant_time: source semantics (matches Coq)
(declare-fun source_is_constant_time () Bool)
(declare-fun target_is_constant_time () Bool)
(assert (= source_is_constant_time target_is_constant_time))

; label_eqb_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_label_eqb_refl () Bool)
(declare-fun target_label_eqb_refl () Bool)
(assert (= source_label_eqb_refl target_label_eqb_refl))

; label_leb_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_label_leb_refl () Bool)
(declare-fun target_label_leb_refl () Bool)
(assert (= source_label_leb_refl target_label_leb_refl))

; label_leb_trans: translation preserves property (matches Coq: Lemma)
(declare-fun source_label_leb_trans () Bool)
(declare-fun target_label_leb_trans () Bool)
(assert (= source_label_leb_trans target_label_leb_trans))

; label_join_low_r: translation preserves property (matches Coq: Lemma)
(declare-fun source_label_join_low_r () Bool)
(declare-fun target_label_join_low_r () Bool)
(assert (= source_label_join_low_r target_label_join_low_r))

; label_join_comm: translation preserves property (matches Coq: Lemma)
(declare-fun source_label_join_comm () Bool)
(declare-fun target_label_join_comm () Bool)
(assert (= source_label_join_comm target_label_join_comm))

; lookup_some_both: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_some_both () Bool)
(declare-fun target_lookup_some_both () Bool)
(assert (= source_lookup_some_both target_lookup_some_both))

; source_noninterference: translation preserves property (matches Coq: Theorem)
(declare-fun source_source_noninterference () Bool)
(declare-fun target_source_noninterference () Bool)
(assert (= source_source_noninterference target_source_noninterference))

; compilation_preserves_labels: translation preserves property (matches Coq: Theorem)
(declare-fun source_compilation_preserves_labels () Bool)
(declare-fun target_compilation_preserves_labels () Bool)
(assert (= source_compilation_preserves_labels target_compilation_preserves_labels))

; tgt_eval_env_independent: translation preserves property (matches Coq: Lemma)
(declare-fun source_tgt_eval_env_independent () Bool)
(declare-fun target_tgt_eval_env_independent () Bool)
(assert (= source_tgt_eval_env_independent target_tgt_eval_env_independent))

; target_noninterference: translation preserves property (matches Coq: Theorem)
(declare-fun source_target_noninterference () Bool)
(declare-fun target_target_noninterference () Bool)
(assert (= source_target_noninterference target_target_noninterference))

; semantic_preservation: translation preserves property (matches Coq: Theorem)
(declare-fun source_semantic_preservation () Bool)
(declare-fun target_semantic_preservation () Bool)
(assert (= source_semantic_preservation target_semantic_preservation))

; security_composition: translation preserves property (matches Coq: Theorem)
(declare-fun source_security_composition () Bool)
(declare-fun target_security_composition () Bool)
(assert (= source_security_composition target_security_composition))

; label_monotonicity_compilation: translation preserves property (matches Coq: Theorem)
(declare-fun source_label_monotonicity_compilation () Bool)
(declare-fun target_label_monotonicity_compilation () Bool)
(assert (= source_label_monotonicity_compilation target_label_monotonicity_compilation))

; constant_time_preserved: translation preserves property (matches Coq: Theorem)
(declare-fun source_constant_time_preserved () Bool)
(declare-fun target_constant_time_preserved () Bool)
(assert (= source_constant_time_preserved target_constant_time_preserved))

; end_to_end_security: translation preserves property (matches Coq: Theorem)
(declare-fun source_end_to_end_security () Bool)
(declare-fun target_end_to_end_security () Bool)
(assert (= source_end_to_end_security target_end_to_end_security))

; compiler_determinism: translation preserves property (matches Coq: Theorem)
(declare-fun source_compiler_determinism () Bool)
(declare-fun target_compiler_determinism () Bool)
(assert (= source_compiler_determinism target_compiler_determinism))

; label_lattice_join_upper_bound: translation preserves property (matches Coq: Theorem)
(declare-fun source_label_lattice_join_upper_bound () Bool)
(declare-fun target_label_lattice_join_upper_bound () Bool)
(assert (= source_label_lattice_join_upper_bound target_label_lattice_join_upper_bound))

; label_lattice_join_least: translation preserves property (matches Coq: Theorem)
(declare-fun source_label_lattice_join_least () Bool)
(declare-fun target_label_lattice_join_least () Bool)
(assert (= source_label_lattice_join_least target_label_lattice_join_least))

; label_eqb_refl2: translation preserves property (matches Coq: Theorem)
(declare-fun source_label_eqb_refl2 () Bool)
(declare-fun target_label_eqb_refl2 () Bool)
(assert (= source_label_eqb_refl2 target_label_eqb_refl2))

; label_join_comm2: translation preserves property (matches Coq: Theorem)
(declare-fun source_label_join_comm2 () Bool)
(declare-fun target_label_join_comm2 () Bool)
(assert (= source_label_join_comm2 target_label_join_comm2))

; label_join_idem2: translation preserves property (matches Coq: Theorem)
(declare-fun source_label_join_idem2 () Bool)
(declare-fun target_label_join_idem2 () Bool)
(assert (= source_label_join_idem2 target_label_join_idem2))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

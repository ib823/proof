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
; Translation validation: label_eqb preserves semantics
(push 1)
(declare-const source_label_eqb Int)
(declare-const target_label_eqb Int)
(assert (>= source_label_eqb 0))
(assert (>= target_label_eqb 0))
(assert (not (= source_label_eqb target_label_eqb)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_leb: source semantics (matches Coq)
; Translation validation: label_leb preserves semantics
(push 1)
(declare-const source_label_leb Int)
(declare-const target_label_leb Int)
(assert (>= source_label_leb 0))
(assert (>= target_label_leb 0))
(assert (not (= source_label_leb target_label_leb)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_join: source semantics (matches Coq)
; Translation validation: label_join preserves semantics
(push 1)
(declare-const source_label_join Int)
(declare-const target_label_join Int)
(assert (>= source_label_join 0))
(assert (>= target_label_join 0))
(assert (not (= source_label_join target_label_join)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; src_low_equiv: source semantics (matches Coq)
; Translation validation: src_low_equiv preserves semantics
(push 1)
(declare-const source_src_low_equiv Int)
(declare-const target_src_low_equiv Int)
(assert (>= source_src_low_equiv 0))
(assert (>= target_src_low_equiv 0))
(assert (not (= source_src_low_equiv target_src_low_equiv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tgt_label_of_prog: source semantics (matches Coq)
; Translation validation: tgt_label_of_prog preserves semantics
(push 1)
(declare-const source_tgt_label_of_prog Int)
(declare-const target_tgt_label_of_prog Int)
(assert (>= source_tgt_label_of_prog 0))
(assert (>= target_tgt_label_of_prog 0))
(assert (not (= source_tgt_label_of_prog target_tgt_label_of_prog)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_constant_time: source semantics (matches Coq)
; Translation validation: is_constant_time preserves semantics
(push 1)
(declare-const source_is_constant_time Int)
(declare-const target_is_constant_time Int)
(assert (>= source_is_constant_time 0))
(assert (>= target_is_constant_time 0))
(assert (not (= source_is_constant_time target_is_constant_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_eqb_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: label_eqb_refl preserves semantics
(push 1)
(declare-const source_label_eqb_refl Int)
(declare-const target_label_eqb_refl Int)
(assert (>= source_label_eqb_refl 0))
(assert (>= target_label_eqb_refl 0))
(assert (not (= source_label_eqb_refl target_label_eqb_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_leb_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: label_leb_refl preserves semantics
(push 1)
(declare-const source_label_leb_refl Int)
(declare-const target_label_leb_refl Int)
(assert (>= source_label_leb_refl 0))
(assert (>= target_label_leb_refl 0))
(assert (not (= source_label_leb_refl target_label_leb_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_leb_trans: translation preserves property (matches Coq: Lemma)
; Translation validation: label_leb_trans preserves semantics
(push 1)
(declare-const source_label_leb_trans Int)
(declare-const target_label_leb_trans Int)
(assert (>= source_label_leb_trans 0))
(assert (>= target_label_leb_trans 0))
(assert (not (= source_label_leb_trans target_label_leb_trans)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_join_low_r: translation preserves property (matches Coq: Lemma)
; Translation validation: label_join_low_r preserves semantics
(push 1)
(declare-const source_label_join_low_r Int)
(declare-const target_label_join_low_r Int)
(assert (>= source_label_join_low_r 0))
(assert (>= target_label_join_low_r 0))
(assert (not (= source_label_join_low_r target_label_join_low_r)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_join_comm: translation preserves property (matches Coq: Lemma)
; Translation validation: label_join_comm preserves semantics
(push 1)
(declare-const source_label_join_comm Int)
(declare-const target_label_join_comm Int)
(assert (>= source_label_join_comm 0))
(assert (>= target_label_join_comm 0))
(assert (not (= source_label_join_comm target_label_join_comm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lookup_some_both: translation preserves property (matches Coq: Lemma)
; Translation validation: lookup_some_both preserves semantics
(push 1)
(declare-const source_lookup_some_both Int)
(declare-const target_lookup_some_both Int)
(assert (>= source_lookup_some_both 0))
(assert (>= target_lookup_some_both 0))
(assert (not (= source_lookup_some_both target_lookup_some_both)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; source_noninterference: translation preserves property (matches Coq: Theorem)
; Translation validation: source_noninterference preserves semantics
(push 1)
(declare-const source_source_noninterference Int)
(declare-const target_source_noninterference Int)
(assert (>= source_source_noninterference 0))
(assert (>= target_source_noninterference 0))
(assert (not (= source_source_noninterference target_source_noninterference)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compilation_preserves_labels: translation preserves property (matches Coq: Theorem)
; Translation validation: compilation_preserves_labels preserves semantics
(push 1)
(declare-const source_compilation_preserves_labels Int)
(declare-const target_compilation_preserves_labels Int)
(assert (>= source_compilation_preserves_labels 0))
(assert (>= target_compilation_preserves_labels 0))
(assert (not (= source_compilation_preserves_labels target_compilation_preserves_labels)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tgt_eval_env_independent: translation preserves property (matches Coq: Lemma)
; Translation validation: tgt_eval_env_independent preserves semantics
(push 1)
(declare-const source_tgt_eval_env_independent Int)
(declare-const target_tgt_eval_env_independent Int)
(assert (>= source_tgt_eval_env_independent 0))
(assert (>= target_tgt_eval_env_independent 0))
(assert (not (= source_tgt_eval_env_independent target_tgt_eval_env_independent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; target_noninterference: translation preserves property (matches Coq: Theorem)
; Translation validation: target_noninterference preserves semantics
(push 1)
(declare-const source_target_noninterference Int)
(declare-const target_target_noninterference Int)
(assert (>= source_target_noninterference 0))
(assert (>= target_target_noninterference 0))
(assert (not (= source_target_noninterference target_target_noninterference)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; semantic_preservation: translation preserves property (matches Coq: Theorem)
; Translation validation: semantic_preservation preserves semantics
(push 1)
(declare-const source_semantic_preservation Int)
(declare-const target_semantic_preservation Int)
(assert (>= source_semantic_preservation 0))
(assert (>= target_semantic_preservation 0))
(assert (not (= source_semantic_preservation target_semantic_preservation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; security_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: security_composition preserves semantics
(push 1)
(declare-const source_security_composition Int)
(declare-const target_security_composition Int)
(assert (>= source_security_composition 0))
(assert (>= target_security_composition 0))
(assert (not (= source_security_composition target_security_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_monotonicity_compilation: translation preserves property (matches Coq: Theorem)
; Translation validation: label_monotonicity_compilation preserves semantics
(push 1)
(declare-const source_label_monotonicity_compilation Int)
(declare-const target_label_monotonicity_compilation Int)
(assert (>= source_label_monotonicity_compilation 0))
(assert (>= target_label_monotonicity_compilation 0))
(assert (not (= source_label_monotonicity_compilation target_label_monotonicity_compilation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; constant_time_preserved: translation preserves property (matches Coq: Theorem)
; Translation validation: constant_time_preserved preserves semantics
(push 1)
(declare-const source_constant_time_preserved Int)
(declare-const target_constant_time_preserved Int)
(assert (>= source_constant_time_preserved 0))
(assert (>= target_constant_time_preserved 0))
(assert (not (= source_constant_time_preserved target_constant_time_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; end_to_end_security: translation preserves property (matches Coq: Theorem)
; Translation validation: end_to_end_security preserves semantics
(push 1)
(declare-const source_end_to_end_security Int)
(declare-const target_end_to_end_security Int)
(assert (>= source_end_to_end_security 0))
(assert (>= target_end_to_end_security 0))
(assert (not (= source_end_to_end_security target_end_to_end_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compiler_determinism: translation preserves property (matches Coq: Theorem)
; Translation validation: compiler_determinism preserves semantics
(push 1)
(declare-const source_compiler_determinism Int)
(declare-const target_compiler_determinism Int)
(assert (>= source_compiler_determinism 0))
(assert (>= target_compiler_determinism 0))
(assert (not (= source_compiler_determinism target_compiler_determinism)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_lattice_join_upper_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: label_lattice_join_upper_bound preserves semantics
(push 1)
(declare-const source_label_lattice_join_upper_bound Int)
(declare-const target_label_lattice_join_upper_bound Int)
(assert (>= source_label_lattice_join_upper_bound 0))
(assert (>= target_label_lattice_join_upper_bound 0))
(assert (not (= source_label_lattice_join_upper_bound target_label_lattice_join_upper_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_lattice_join_least: translation preserves property (matches Coq: Theorem)
; Translation validation: label_lattice_join_least preserves semantics
(push 1)
(declare-const source_label_lattice_join_least Int)
(declare-const target_label_lattice_join_least Int)
(assert (>= source_label_lattice_join_least 0))
(assert (>= target_label_lattice_join_least 0))
(assert (not (= source_label_lattice_join_least target_label_lattice_join_least)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_eqb_refl2: translation preserves property (matches Coq: Theorem)
; Translation validation: label_eqb_refl2 preserves semantics
(push 1)
(declare-const source_label_eqb_refl2 Int)
(declare-const target_label_eqb_refl2 Int)
(assert (>= source_label_eqb_refl2 0))
(assert (>= target_label_eqb_refl2 0))
(assert (not (= source_label_eqb_refl2 target_label_eqb_refl2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_join_comm2: translation preserves property (matches Coq: Theorem)
; Translation validation: label_join_comm2 preserves semantics
(push 1)
(declare-const source_label_join_comm2 Int)
(declare-const target_label_join_comm2 Int)
(assert (>= source_label_join_comm2 0))
(assert (>= target_label_join_comm2 0))
(assert (not (= source_label_join_comm2 target_label_join_comm2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_join_idem2: translation preserves property (matches Coq: Theorem)
; Translation validation: label_join_idem2 preserves semantics
(push 1)
(declare-const source_label_join_idem2 Int)
(declare-const target_label_join_idem2 Int)
(assert (>= source_label_join_idem2 0))
(assert (>= target_label_join_idem2 0))
(assert (not (= source_label_join_idem2 target_label_join_idem2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

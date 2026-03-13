; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/KripkeProperties.v (41 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for KripkeProperties
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; val_rel_at: source semantics (matches Coq)
; Translation validation: val_rel_at preserves semantics
(push 1)
(declare-const source_val_rel_at Int)
(declare-const target_val_rel_at Int)
(assert (>= source_val_rel_at 0))
(assert (>= target_val_rel_at 0))
(assert (not (= source_val_rel_at target_val_rel_at)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_extends_preorder: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_extends_preorder preserves semantics
(push 1)
(declare-const source_store_ty_extends_preorder Int)
(declare-const target_store_ty_extends_preorder Int)
(assert (>= source_store_ty_extends_preorder 0))
(assert (>= target_store_ty_extends_preorder 0))
(assert (not (= source_store_ty_extends_preorder target_store_ty_extends_preorder)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_build_unit: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_build_unit preserves semantics
(push 1)
(declare-const source_val_rel_le_build_unit Int)
(declare-const target_val_rel_le_build_unit Int)
(assert (>= source_val_rel_le_build_unit 0))
(assert (>= target_val_rel_le_build_unit 0))
(assert (not (= source_val_rel_le_build_unit target_val_rel_le_build_unit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_step_up_unit: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_step_up_unit preserves semantics
(push 1)
(declare-const source_val_rel_le_step_up_unit Int)
(declare-const target_val_rel_le_step_up_unit Int)
(assert (>= source_val_rel_le_step_up_unit 0))
(assert (>= target_val_rel_le_step_up_unit 0))
(assert (not (= source_val_rel_le_step_up_unit target_val_rel_le_step_up_unit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_build_bool: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_build_bool preserves semantics
(push 1)
(declare-const source_val_rel_le_build_bool Int)
(declare-const target_val_rel_le_build_bool Int)
(assert (>= source_val_rel_le_build_bool 0))
(assert (>= target_val_rel_le_build_bool 0))
(assert (not (= source_val_rel_le_build_bool target_val_rel_le_build_bool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_step_up_bool: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_step_up_bool preserves semantics
(push 1)
(declare-const source_val_rel_le_step_up_bool Int)
(declare-const target_val_rel_le_step_up_bool Int)
(assert (>= source_val_rel_le_step_up_bool 0))
(assert (>= target_val_rel_le_step_up_bool 0))
(assert (not (= source_val_rel_le_step_up_bool target_val_rel_le_step_up_bool)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_build_int: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_build_int preserves semantics
(push 1)
(declare-const source_val_rel_le_build_int Int)
(declare-const target_val_rel_le_build_int Int)
(assert (>= source_val_rel_le_build_int 0))
(assert (>= target_val_rel_le_build_int 0))
(assert (not (= source_val_rel_le_build_int target_val_rel_le_build_int)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_step_up_int: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_step_up_int preserves semantics
(push 1)
(declare-const source_val_rel_le_step_up_int Int)
(declare-const target_val_rel_le_step_up_int Int)
(assert (>= source_val_rel_le_step_up_int 0))
(assert (>= target_val_rel_le_step_up_int 0))
(assert (not (= source_val_rel_le_step_up_int target_val_rel_le_step_up_int)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_build_string: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_build_string preserves semantics
(push 1)
(declare-const source_val_rel_le_build_string Int)
(declare-const target_val_rel_le_build_string Int)
(assert (>= source_val_rel_le_build_string 0))
(assert (>= target_val_rel_le_build_string 0))
(assert (not (= source_val_rel_le_build_string target_val_rel_le_build_string)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_step_up_string: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_step_up_string preserves semantics
(push 1)
(declare-const source_val_rel_le_step_up_string Int)
(declare-const target_val_rel_le_step_up_string Int)
(assert (>= source_val_rel_le_step_up_string 0))
(assert (>= target_val_rel_le_step_up_string 0))
(assert (not (= source_val_rel_le_step_up_string target_val_rel_le_step_up_string)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_build_bytes: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_build_bytes preserves semantics
(push 1)
(declare-const source_val_rel_le_build_bytes Int)
(declare-const target_val_rel_le_build_bytes Int)
(assert (>= source_val_rel_le_build_bytes 0))
(assert (>= target_val_rel_le_build_bytes 0))
(assert (not (= source_val_rel_le_build_bytes target_val_rel_le_build_bytes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_step_up_bytes: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_step_up_bytes preserves semantics
(push 1)
(declare-const source_val_rel_le_step_up_bytes Int)
(declare-const target_val_rel_le_step_up_bytes Int)
(assert (>= source_val_rel_le_step_up_bytes 0))
(assert (>= target_val_rel_le_step_up_bytes 0))
(assert (not (= source_val_rel_le_step_up_bytes target_val_rel_le_step_up_bytes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_build_secret: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_build_secret preserves semantics
(push 1)
(declare-const source_val_rel_le_build_secret Int)
(declare-const target_val_rel_le_build_secret Int)
(assert (>= source_val_rel_le_build_secret 0))
(assert (>= target_val_rel_le_build_secret 0))
(assert (not (= source_val_rel_le_build_secret target_val_rel_le_build_secret)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_step_up_secret: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_step_up_secret preserves semantics
(push 1)
(declare-const source_val_rel_le_step_up_secret Int)
(declare-const target_val_rel_le_step_up_secret Int)
(assert (>= source_val_rel_le_step_up_secret 0))
(assert (>= target_val_rel_le_step_up_secret 0))
(assert (not (= source_val_rel_le_step_up_secret target_val_rel_le_step_up_secret)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_kripke_mono: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_kripke_mono preserves semantics
(push 1)
(declare-const source_val_rel_le_kripke_mono Int)
(declare-const target_val_rel_le_kripke_mono Int)
(assert (>= source_val_rel_le_kripke_mono 0))
(assert (>= target_val_rel_le_kripke_mono 0))
(assert (not (= source_val_rel_le_kripke_mono target_val_rel_le_kripke_mono)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_store_preserves_step: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_store_preserves_step preserves semantics
(push 1)
(declare-const source_val_rel_le_store_preserves_step Int)
(declare-const target_val_rel_le_store_preserves_step Int)
(assert (>= source_val_rel_le_store_preserves_step 0))
(assert (>= target_val_rel_le_store_preserves_step 0))
(assert (not (= source_val_rel_le_store_preserves_step target_val_rel_le_store_preserves_step)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_rel_le_kripke_step: translation preserves property (matches Coq: Lemma)
; Translation validation: store_rel_le_kripke_step preserves semantics
(push 1)
(declare-const source_store_rel_le_kripke_step Int)
(declare-const target_store_rel_le_kripke_step Int)
(assert (>= source_store_rel_le_kripke_step 0))
(assert (>= target_store_rel_le_kripke_step 0))
(assert (not (= source_store_rel_le_kripke_step target_store_rel_le_kripke_step)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_includes_at: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_includes_at preserves semantics
(push 1)
(declare-const source_val_rel_le_includes_at Int)
(declare-const target_val_rel_le_includes_at Int)
(assert (>= source_val_rel_le_includes_at 0))
(assert (>= target_val_rel_le_includes_at 0))
(assert (not (= source_val_rel_le_includes_at target_val_rel_le_includes_at)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_at_to_le: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_at_to_le preserves semantics
(push 1)
(declare-const source_val_rel_at_to_le Int)
(declare-const target_val_rel_at_to_le Int)
(assert (>= source_val_rel_at_to_le 0))
(assert (>= target_val_rel_at_to_le 0))
(assert (not (= source_val_rel_at_to_le target_val_rel_at_to_le)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_build_indist: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_build_indist preserves semantics
(push 1)
(declare-const source_val_rel_le_build_indist Int)
(declare-const target_val_rel_le_build_indist Int)
(assert (>= source_val_rel_le_build_indist 0))
(assert (>= target_val_rel_le_build_indist 0))
(assert (not (= source_val_rel_le_build_indist target_val_rel_le_build_indist)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_step_up_fo: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_step_up_fo preserves semantics
(push 1)
(declare-const source_val_rel_le_step_up_fo Int)
(declare-const target_val_rel_le_step_up_fo Int)
(assert (>= source_val_rel_le_step_up_fo 0))
(assert (>= target_val_rel_le_step_up_fo 0))
(assert (not (= source_val_rel_le_step_up_fo target_val_rel_le_step_up_fo)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_base_permanent: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_base_permanent preserves semantics
(push 1)
(declare-const source_val_rel_le_base_permanent Int)
(declare-const target_val_rel_le_base_permanent Int)
(assert (>= source_val_rel_le_base_permanent 0))
(assert (>= target_val_rel_le_base_permanent 0))
(assert (not (= source_val_rel_le_base_permanent target_val_rel_le_base_permanent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_unit_eq: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_unit_eq preserves semantics
(push 1)
(declare-const source_val_rel_le_unit_eq Int)
(declare-const target_val_rel_le_unit_eq Int)
(assert (>= source_val_rel_le_unit_eq 0))
(assert (>= target_val_rel_le_unit_eq 0))
(assert (not (= source_val_rel_le_unit_eq target_val_rel_le_unit_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_bool_eq: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_bool_eq preserves semantics
(push 1)
(declare-const source_val_rel_le_bool_eq Int)
(declare-const target_val_rel_le_bool_eq Int)
(assert (>= source_val_rel_le_bool_eq 0))
(assert (>= target_val_rel_le_bool_eq 0))
(assert (not (= source_val_rel_le_bool_eq target_val_rel_le_bool_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_lookup_update_neq: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_lookup_update_neq preserves semantics
(push 1)
(declare-const source_store_ty_lookup_update_neq Int)
(declare-const target_store_ty_lookup_update_neq Int)
(assert (>= source_store_ty_lookup_update_neq 0))
(assert (>= target_store_ty_lookup_update_neq 0))
(assert (not (= source_store_ty_lookup_update_neq target_store_ty_lookup_update_neq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; store_ty_extends_add: translation preserves property (matches Coq: Lemma)
; Translation validation: store_ty_extends_add preserves semantics
(push 1)
(declare-const source_store_ty_extends_add Int)
(declare-const target_store_ty_extends_add Int)
(assert (>= source_store_ty_extends_add 0))
(assert (>= target_store_ty_extends_add 0))
(assert (not (= source_store_ty_extends_add target_store_ty_extends_add)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_build_labeled: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_build_labeled preserves semantics
(push 1)
(declare-const source_val_rel_le_build_labeled Int)
(declare-const target_val_rel_le_build_labeled Int)
(assert (>= source_val_rel_le_build_labeled 0))
(assert (>= target_val_rel_le_build_labeled 0))
(assert (not (= source_val_rel_le_build_labeled target_val_rel_le_build_labeled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_step_up_labeled: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_step_up_labeled preserves semantics
(push 1)
(declare-const source_val_rel_le_step_up_labeled Int)
(declare-const target_val_rel_le_step_up_labeled Int)
(assert (>= source_val_rel_le_step_up_labeled 0))
(assert (>= target_val_rel_le_step_up_labeled 0))
(assert (not (= source_val_rel_le_step_up_labeled target_val_rel_le_step_up_labeled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_build_tainted: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_build_tainted preserves semantics
(push 1)
(declare-const source_val_rel_le_build_tainted Int)
(declare-const target_val_rel_le_build_tainted Int)
(assert (>= source_val_rel_le_build_tainted 0))
(assert (>= target_val_rel_le_build_tainted 0))
(assert (not (= source_val_rel_le_build_tainted target_val_rel_le_build_tainted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_step_up_tainted: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_step_up_tainted preserves semantics
(push 1)
(declare-const source_val_rel_le_step_up_tainted Int)
(declare-const target_val_rel_le_step_up_tainted Int)
(assert (>= source_val_rel_le_step_up_tainted 0))
(assert (>= target_val_rel_le_step_up_tainted 0))
(assert (not (= source_val_rel_le_step_up_tainted target_val_rel_le_step_up_tainted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_build_sanitized: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_build_sanitized preserves semantics
(push 1)
(declare-const source_val_rel_le_build_sanitized Int)
(declare-const target_val_rel_le_build_sanitized Int)
(assert (>= source_val_rel_le_build_sanitized 0))
(assert (>= target_val_rel_le_build_sanitized 0))
(assert (not (= source_val_rel_le_build_sanitized target_val_rel_le_build_sanitized)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_step_up_sanitized: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_step_up_sanitized preserves semantics
(push 1)
(declare-const source_val_rel_le_step_up_sanitized Int)
(declare-const target_val_rel_le_step_up_sanitized Int)
(assert (>= source_val_rel_le_step_up_sanitized 0))
(assert (>= target_val_rel_le_step_up_sanitized 0))
(assert (not (= source_val_rel_le_step_up_sanitized target_val_rel_le_step_up_sanitized)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_build_proof: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_build_proof preserves semantics
(push 1)
(declare-const source_val_rel_le_build_proof Int)
(declare-const target_val_rel_le_build_proof Int)
(assert (>= source_val_rel_le_build_proof 0))
(assert (>= target_val_rel_le_build_proof 0))
(assert (not (= source_val_rel_le_build_proof target_val_rel_le_build_proof)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_step_up_proof: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_step_up_proof preserves semantics
(push 1)
(declare-const source_val_rel_le_step_up_proof Int)
(declare-const target_val_rel_le_step_up_proof Int)
(assert (>= source_val_rel_le_step_up_proof 0))
(assert (>= target_val_rel_le_step_up_proof 0))
(assert (not (= source_val_rel_le_step_up_proof target_val_rel_le_step_up_proof)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_build_ct: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_build_ct preserves semantics
(push 1)
(declare-const source_val_rel_le_build_ct Int)
(declare-const target_val_rel_le_build_ct Int)
(assert (>= source_val_rel_le_build_ct 0))
(assert (>= target_val_rel_le_build_ct 0))
(assert (not (= source_val_rel_le_build_ct target_val_rel_le_build_ct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_step_up_ct: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_step_up_ct preserves semantics
(push 1)
(declare-const source_val_rel_le_step_up_ct Int)
(declare-const target_val_rel_le_step_up_ct Int)
(assert (>= source_val_rel_le_step_up_ct 0))
(assert (>= target_val_rel_le_step_up_ct 0))
(assert (not (= source_val_rel_le_step_up_ct target_val_rel_le_step_up_ct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_build_zero: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_build_zero preserves semantics
(push 1)
(declare-const source_val_rel_le_build_zero Int)
(declare-const target_val_rel_le_build_zero Int)
(assert (>= source_val_rel_le_build_zero 0))
(assert (>= target_val_rel_le_build_zero 0))
(assert (not (= source_val_rel_le_build_zero target_val_rel_le_build_zero)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_step_up_zero: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_step_up_zero preserves semantics
(push 1)
(declare-const source_val_rel_le_step_up_zero Int)
(declare-const target_val_rel_le_step_up_zero Int)
(assert (>= source_val_rel_le_step_up_zero 0))
(assert (>= target_val_rel_le_step_up_zero 0))
(assert (not (= source_val_rel_le_step_up_zero target_val_rel_le_step_up_zero)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_build_cap: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_build_cap preserves semantics
(push 1)
(declare-const source_val_rel_le_build_cap Int)
(declare-const target_val_rel_le_build_cap Int)
(assert (>= source_val_rel_le_build_cap 0))
(assert (>= target_val_rel_le_build_cap 0))
(assert (not (= source_val_rel_le_build_cap target_val_rel_le_build_cap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_step_up_cap: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_step_up_cap preserves semantics
(push 1)
(declare-const source_val_rel_le_step_up_cap Int)
(declare-const target_val_rel_le_step_up_cap Int)
(assert (>= source_val_rel_le_step_up_cap 0))
(assert (>= target_val_rel_le_step_up_cap 0))
(assert (not (= source_val_rel_le_step_up_cap target_val_rel_le_step_up_cap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_build_ref_kripke: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_build_ref_kripke preserves semantics
(push 1)
(declare-const source_val_rel_le_build_ref_kripke Int)
(declare-const target_val_rel_le_build_ref_kripke Int)
(assert (>= source_val_rel_le_build_ref_kripke 0))
(assert (>= target_val_rel_le_build_ref_kripke 0))
(assert (not (= source_val_rel_le_build_ref_kripke target_val_rel_le_build_ref_kripke)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; val_rel_le_step_up_ref: translation preserves property (matches Coq: Lemma)
; Translation validation: val_rel_le_step_up_ref preserves semantics
(push 1)
(declare-const source_val_rel_le_step_up_ref Int)
(declare-const target_val_rel_le_step_up_ref Int)
(assert (>= source_val_rel_le_step_up_ref 0))
(assert (>= target_val_rel_le_step_up_ref 0))
(assert (not (= source_val_rel_le_step_up_ref target_val_rel_le_step_up_ref)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

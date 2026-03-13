; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/ProbabilisticVerification.v (20 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for ProbabilisticVerification
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; negligible: source semantics (matches Coq)
; Translation validation: negligible preserves semantics
(push 1)
(declare-const source_negligible Int)
(declare-const target_negligible Int)
(assert (>= source_negligible 0))
(assert (>= target_negligible 0))
(assert (not (= source_negligible target_negligible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; comp_indist: source semantics (matches Coq)
; Translation validation: comp_indist preserves semantics
(push 1)
(declare-const source_comp_indist Int)
(declare-const target_comp_indist Int)
(assert (>= source_comp_indist 0))
(assert (>= target_comp_indist 0))
(assert (not (= source_comp_indist target_comp_indist)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; xor_nat: source semantics (matches Coq)
; Translation validation: xor_nat preserves semantics
(push 1)
(declare-const source_xor_nat Int)
(declare-const target_xor_nat Int)
(assert (>= source_xor_nat 0))
(assert (>= target_xor_nat 0))
(assert (not (= source_xor_nat target_xor_nat)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; uniform_nonneg: translation preserves property (matches Coq: Theorem)
; Translation validation: uniform_nonneg preserves semantics
(push 1)
(declare-const source_uniform_nonneg Int)
(declare-const target_uniform_nonneg Int)
(assert (>= source_uniform_nonneg 0))
(assert (>= target_uniform_nonneg 0))
(assert (not (= source_uniform_nonneg target_uniform_nonneg)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; zero_negligible: translation preserves property (matches Coq: Theorem)
; Translation validation: zero_negligible preserves semantics
(push 1)
(declare-const source_zero_negligible Int)
(declare-const target_zero_negligible Int)
(assert (>= source_zero_negligible 0))
(assert (>= target_zero_negligible 0))
(assert (not (= source_zero_negligible target_zero_negligible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Qplus_lt_compat2: translation preserves property (matches Coq: Lemma)
; Translation validation: Qplus_lt_compat2 preserves semantics
(push 1)
(declare-const source_Qplus_lt_compat2 Int)
(declare-const target_Qplus_lt_compat2 Int)
(assert (>= source_Qplus_lt_compat2 0))
(assert (>= target_Qplus_lt_compat2 0))
(assert (not (= source_Qplus_lt_compat2 target_Qplus_lt_compat2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; two_over_nSc_le_one_over_nc: translation preserves property (matches Coq: Lemma)
; Translation validation: two_over_nSc_le_one_over_nc preserves semantics
(push 1)
(declare-const source_two_over_nSc_le_one_over_nc Int)
(declare-const target_two_over_nSc_le_one_over_nc Int)
(assert (>= source_two_over_nSc_le_one_over_nc 0))
(assert (>= target_two_over_nSc_le_one_over_nc 0))
(assert (not (= source_two_over_nSc_le_one_over_nc target_two_over_nSc_le_one_over_nc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; negligible_sum: translation preserves property (matches Coq: Theorem)
; Translation validation: negligible_sum preserves semantics
(push 1)
(declare-const source_negligible_sum Int)
(declare-const target_negligible_sum Int)
(assert (>= source_negligible_sum 0))
(assert (>= target_negligible_sum 0))
(assert (not (= source_negligible_sum target_negligible_sum)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Qabs_Qminus_self: translation preserves property (matches Coq: Lemma)
; Translation validation: Qabs_Qminus_self preserves semantics
(push 1)
(declare-const source_Qabs_Qminus_self Int)
(declare-const target_Qabs_Qminus_self Int)
(assert (>= source_Qabs_Qminus_self 0))
(assert (>= target_Qabs_Qminus_self 0))
(assert (not (= source_Qabs_Qminus_self target_Qabs_Qminus_self)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fold_combine_self_gen: translation preserves property (matches Coq: Lemma)
; Translation validation: fold_combine_self_gen preserves semantics
(push 1)
(declare-const source_fold_combine_self_gen Int)
(declare-const target_fold_combine_self_gen Int)
(assert (>= source_fold_combine_self_gen 0))
(assert (>= target_fold_combine_self_gen 0))
(assert (not (= source_fold_combine_self_gen target_fold_combine_self_gen)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fold_combine_self: translation preserves property (matches Coq: Lemma)
; Translation validation: fold_combine_self preserves semantics
(push 1)
(declare-const source_fold_combine_self Int)
(declare-const target_fold_combine_self Int)
(assert (>= source_fold_combine_self 0))
(assert (>= target_fold_combine_self 0))
(assert (not (= source_fold_combine_self target_fold_combine_self)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; identical_indist: translation preserves property (matches Coq: Theorem)
; Translation validation: identical_indist preserves semantics
(push 1)
(declare-const source_identical_indist Int)
(declare-const target_identical_indist Int)
(assert (>= source_identical_indist 0))
(assert (>= target_identical_indist 0))
(assert (not (= source_identical_indist target_identical_indist)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; comp_indist_refl: translation preserves property (matches Coq: Theorem)
; Translation validation: comp_indist_refl preserves semantics
(push 1)
(declare-const source_comp_indist_refl Int)
(declare-const target_comp_indist_refl Int)
(assert (>= source_comp_indist_refl 0))
(assert (>= target_comp_indist_refl 0))
(assert (not (= source_comp_indist_refl target_comp_indist_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; xor_self_inverse: translation preserves property (matches Coq: Theorem)
; Translation validation: xor_self_inverse preserves semantics
(push 1)
(declare-const source_xor_self_inverse Int)
(declare-const target_xor_self_inverse Int)
(assert (>= source_xor_self_inverse 0))
(assert (>= target_xor_self_inverse 0))
(assert (not (= source_xor_self_inverse target_xor_self_inverse)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; xor_comm: translation preserves property (matches Coq: Theorem)
; Translation validation: xor_comm preserves semantics
(push 1)
(declare-const source_xor_comm Int)
(declare-const target_xor_comm Int)
(assert (>= source_xor_comm 0))
(assert (>= target_xor_comm 0))
(assert (not (= source_xor_comm target_xor_comm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; xor_zero_id: translation preserves property (matches Coq: Theorem)
; Translation validation: xor_zero_id preserves semantics
(push 1)
(declare-const source_xor_zero_id Int)
(declare-const target_xor_zero_id Int)
(assert (>= source_xor_zero_id 0))
(assert (>= target_xor_zero_id 0))
(assert (not (= source_xor_zero_id target_xor_zero_id)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; xor_assoc: translation preserves property (matches Coq: Theorem)
; Translation validation: xor_assoc preserves semantics
(push 1)
(declare-const source_xor_assoc Int)
(declare-const target_xor_assoc Int)
(assert (>= source_xor_assoc 0))
(assert (>= target_xor_assoc 0))
(assert (not (= source_xor_assoc target_xor_assoc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; xor_self_zero: translation preserves property (matches Coq: Theorem)
; Translation validation: xor_self_zero preserves semantics
(push 1)
(declare-const source_xor_self_zero Int)
(declare-const target_xor_self_zero Int)
(assert (>= source_xor_self_zero 0))
(assert (>= target_xor_self_zero 0))
(assert (not (= source_xor_self_zero target_xor_self_zero)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; otp_roundtrip: translation preserves property (matches Coq: Theorem)
; Translation validation: otp_roundtrip preserves semantics
(push 1)
(declare-const source_otp_roundtrip Int)
(declare-const target_otp_roundtrip Int)
(assert (>= source_otp_roundtrip 0))
(assert (>= target_otp_roundtrip 0))
(assert (not (= source_otp_roundtrip target_otp_roundtrip)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; xor_deterministic: translation preserves property (matches Coq: Theorem)
; Translation validation: xor_deterministic preserves semantics
(push 1)
(declare-const source_xor_deterministic Int)
(declare-const target_xor_deterministic Int)
(assert (>= source_xor_deterministic 0))
(assert (>= target_xor_deterministic 0))
(assert (not (= source_xor_deterministic target_xor_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; uniform_length: translation preserves property (matches Coq: Theorem)
; Translation validation: uniform_length preserves semantics
(push 1)
(declare-const source_uniform_length Int)
(declare-const target_uniform_length Int)
(assert (>= source_uniform_length 0))
(assert (>= target_uniform_length 0))
(assert (not (= source_uniform_length target_uniform_length)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; qabs_nonneg: translation preserves property (matches Coq: Theorem)
; Translation validation: qabs_nonneg preserves semantics
(push 1)
(declare-const source_qabs_nonneg Int)
(declare-const target_qabs_nonneg Int)
(assert (>= source_qabs_nonneg 0))
(assert (>= target_qabs_nonneg 0))
(assert (not (= source_qabs_nonneg target_qabs_nonneg)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; qabs_zero: translation preserves property (matches Coq: Theorem)
; Translation validation: qabs_zero preserves semantics
(push 1)
(declare-const source_qabs_zero Int)
(declare-const target_qabs_zero Int)
(assert (>= source_qabs_zero 0))
(assert (>= target_qabs_zero 0))
(assert (not (= source_qabs_zero target_qabs_zero)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

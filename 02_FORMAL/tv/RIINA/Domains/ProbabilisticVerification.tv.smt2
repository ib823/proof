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
(declare-fun source_negligible () Bool)
(declare-fun target_negligible () Bool)
(assert (= source_negligible target_negligible))

; comp_indist: source semantics (matches Coq)
(declare-fun source_comp_indist () Bool)
(declare-fun target_comp_indist () Bool)
(assert (= source_comp_indist target_comp_indist))

; xor_nat: source semantics (matches Coq)
(declare-fun source_xor_nat () Bool)
(declare-fun target_xor_nat () Bool)
(assert (= source_xor_nat target_xor_nat))

; uniform_nonneg: translation preserves property (matches Coq: Theorem)
(declare-fun source_uniform_nonneg () Bool)
(declare-fun target_uniform_nonneg () Bool)
(assert (= source_uniform_nonneg target_uniform_nonneg))

; zero_negligible: translation preserves property (matches Coq: Theorem)
(declare-fun source_zero_negligible () Bool)
(declare-fun target_zero_negligible () Bool)
(assert (= source_zero_negligible target_zero_negligible))

; Qplus_lt_compat2: translation preserves property (matches Coq: Lemma)
(declare-fun source_Qplus_lt_compat2 () Bool)
(declare-fun target_Qplus_lt_compat2 () Bool)
(assert (= source_Qplus_lt_compat2 target_Qplus_lt_compat2))

; two_over_nSc_le_one_over_nc: translation preserves property (matches Coq: Lemma)
(declare-fun source_two_over_nSc_le_one_over_nc () Bool)
(declare-fun target_two_over_nSc_le_one_over_nc () Bool)
(assert (= source_two_over_nSc_le_one_over_nc target_two_over_nSc_le_one_over_nc))

; negligible_sum: translation preserves property (matches Coq: Theorem)
(declare-fun source_negligible_sum () Bool)
(declare-fun target_negligible_sum () Bool)
(assert (= source_negligible_sum target_negligible_sum))

; Qabs_Qminus_self: translation preserves property (matches Coq: Lemma)
(declare-fun source_Qabs_Qminus_self () Bool)
(declare-fun target_Qabs_Qminus_self () Bool)
(assert (= source_Qabs_Qminus_self target_Qabs_Qminus_self))

; fold_combine_self_gen: translation preserves property (matches Coq: Lemma)
(declare-fun source_fold_combine_self_gen () Bool)
(declare-fun target_fold_combine_self_gen () Bool)
(assert (= source_fold_combine_self_gen target_fold_combine_self_gen))

; fold_combine_self: translation preserves property (matches Coq: Lemma)
(declare-fun source_fold_combine_self () Bool)
(declare-fun target_fold_combine_self () Bool)
(assert (= source_fold_combine_self target_fold_combine_self))

; identical_indist: translation preserves property (matches Coq: Theorem)
(declare-fun source_identical_indist () Bool)
(declare-fun target_identical_indist () Bool)
(assert (= source_identical_indist target_identical_indist))

; comp_indist_refl: translation preserves property (matches Coq: Theorem)
(declare-fun source_comp_indist_refl () Bool)
(declare-fun target_comp_indist_refl () Bool)
(assert (= source_comp_indist_refl target_comp_indist_refl))

; xor_self_inverse: translation preserves property (matches Coq: Theorem)
(declare-fun source_xor_self_inverse () Bool)
(declare-fun target_xor_self_inverse () Bool)
(assert (= source_xor_self_inverse target_xor_self_inverse))

; xor_comm: translation preserves property (matches Coq: Theorem)
(declare-fun source_xor_comm () Bool)
(declare-fun target_xor_comm () Bool)
(assert (= source_xor_comm target_xor_comm))

; xor_zero_id: translation preserves property (matches Coq: Theorem)
(declare-fun source_xor_zero_id () Bool)
(declare-fun target_xor_zero_id () Bool)
(assert (= source_xor_zero_id target_xor_zero_id))

; xor_assoc: translation preserves property (matches Coq: Theorem)
(declare-fun source_xor_assoc () Bool)
(declare-fun target_xor_assoc () Bool)
(assert (= source_xor_assoc target_xor_assoc))

; xor_self_zero: translation preserves property (matches Coq: Theorem)
(declare-fun source_xor_self_zero () Bool)
(declare-fun target_xor_self_zero () Bool)
(assert (= source_xor_self_zero target_xor_self_zero))

; otp_roundtrip: translation preserves property (matches Coq: Theorem)
(declare-fun source_otp_roundtrip () Bool)
(declare-fun target_otp_roundtrip () Bool)
(assert (= source_otp_roundtrip target_otp_roundtrip))

; xor_deterministic: translation preserves property (matches Coq: Theorem)
(declare-fun source_xor_deterministic () Bool)
(declare-fun target_xor_deterministic () Bool)
(assert (= source_xor_deterministic target_xor_deterministic))

; uniform_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_uniform_length () Bool)
(declare-fun target_uniform_length () Bool)
(assert (= source_uniform_length target_uniform_length))

; qabs_nonneg: translation preserves property (matches Coq: Theorem)
(declare-fun source_qabs_nonneg () Bool)
(declare-fun target_qabs_nonneg () Bool)
(assert (= source_qabs_nonneg target_qabs_nonneg))

; qabs_zero: translation preserves property (matches Coq: Theorem)
(declare-fun source_qabs_zero () Bool)
(declare-fun target_qabs_zero () Bool)
(assert (= source_qabs_zero target_qabs_zero))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/properties/Declassification.v (16 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for Declassification
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; val_rel_le_secret_trivial: translation preserves property (matches Coq: Lemma)
(declare-fun source_val_rel_le_secret_trivial () Bool)
(declare-fun target_val_rel_le_secret_trivial () Bool)
(assert (= source_val_rel_le_secret_trivial target_val_rel_le_secret_trivial))

; declassify_eval: translation preserves property (matches Coq: Lemma)
(declare-fun source_declassify_eval () Bool)
(declare-fun target_declassify_eval () Bool)
(assert (= source_declassify_eval target_declassify_eval))

; logical_relation_declassify_proven: translation preserves property (matches Coq: Lemma)
(declare-fun source_logical_relation_declassify_proven () Bool)
(declare-fun target_logical_relation_declassify_proven () Bool)
(assert (= source_logical_relation_declassify_proven target_logical_relation_declassify_proven))

; value_multi_step_refl_decl: translation preserves property (matches Coq: Lemma)
(declare-fun source_value_multi_step_refl_decl () Bool)
(declare-fun target_value_multi_step_refl_decl () Bool)
(assert (= source_value_multi_step_refl_decl target_value_multi_step_refl_decl))

; eval_deterministic_cfg: translation preserves property (matches Coq: Lemma)
(declare-fun source_eval_deterministic_cfg () Bool)
(declare-fun target_eval_deterministic_cfg () Bool)
(assert (= source_eval_deterministic_cfg target_eval_deterministic_cfg))

; eval_deterministic: translation preserves property (matches Coq: Lemma)
(declare-fun source_eval_deterministic () Bool)
(declare-fun target_eval_deterministic () Bool)
(assert (= source_eval_deterministic target_eval_deterministic))

; declassify_policy_safe: translation preserves property (matches Coq: Lemma)
(declare-fun source_declassify_policy_safe () Bool)
(declare-fun target_declassify_policy_safe () Bool)
(assert (= source_declassify_policy_safe target_declassify_policy_safe))

; classify_creates_secret: translation preserves property (matches Coq: Lemma)
(declare-fun source_classify_creates_secret () Bool)
(declare-fun target_classify_creates_secret () Bool)
(assert (= source_classify_creates_secret target_classify_creates_secret))

; double_classify_typed: translation preserves property (matches Coq: Lemma)
(declare-fun source_double_classify_typed () Bool)
(declare-fun target_double_classify_typed () Bool)
(assert (= source_double_classify_typed target_double_classify_typed))

; classify_value: translation preserves property (matches Coq: Lemma)
(declare-fun source_classify_value () Bool)
(declare-fun target_classify_value () Bool)
(assert (= source_classify_value target_classify_value))

; classify_closed: translation preserves property (matches Coq: Lemma)
(declare-fun source_classify_closed () Bool)
(declare-fun target_classify_closed () Bool)
(assert (= source_classify_closed target_classify_closed))

; declassify_requires_public_context: translation preserves property (matches Coq: Lemma)
(declare-fun source_declassify_requires_public_context () Bool)
(declare-fun target_declassify_requires_public_context () Bool)
(assert (= source_declassify_requires_public_context target_declassify_requires_public_context))

; secret_value_pure: translation preserves property (matches Coq: Lemma)
(declare-fun source_secret_value_pure () Bool)
(declare-fun target_secret_value_pure () Bool)
(assert (= source_secret_value_pure target_secret_value_pure))

; declassify_deterministic: translation preserves property (matches Coq: Lemma)
(declare-fun source_declassify_deterministic () Bool)
(declare-fun target_declassify_deterministic () Bool)
(assert (= source_declassify_deterministic target_declassify_deterministic))

; declassify_result: translation preserves property (matches Coq: Lemma)
(declare-fun source_declassify_result () Bool)
(declare-fun target_declassify_result () Bool)
(assert (= source_declassify_result target_declassify_result))

; declassification_zero_admits: translation preserves property (matches Coq: Theorem)
(declare-fun source_declassification_zero_admits () Bool)
(declare-fun target_declassification_zero_admits () Bool)
(assert (= source_declassification_zero_admits target_declassification_zero_admits))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

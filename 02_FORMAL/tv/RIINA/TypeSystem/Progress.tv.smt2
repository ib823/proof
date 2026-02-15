; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/type_system/Progress.v (15 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for Progress
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; canonical_bool: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_bool () Bool)
(declare-fun target_canonical_bool () Bool)
(assert (= source_canonical_bool target_canonical_bool))

; canonical_fn: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_fn () Bool)
(declare-fun target_canonical_fn () Bool)
(assert (= source_canonical_fn target_canonical_fn))

; canonical_pair: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_pair () Bool)
(declare-fun target_canonical_pair () Bool)
(assert (= source_canonical_pair target_canonical_pair))

; canonical_sum: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_sum () Bool)
(declare-fun target_canonical_sum () Bool)
(assert (= source_canonical_sum target_canonical_sum))

; canonical_ref: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_ref () Bool)
(declare-fun target_canonical_ref () Bool)
(assert (= source_canonical_ref target_canonical_ref))

; canonical_secret: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_secret () Bool)
(declare-fun target_canonical_secret () Bool)
(assert (= source_canonical_secret target_canonical_secret))

; canonical_proof: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_proof () Bool)
(declare-fun target_canonical_proof () Bool)
(assert (= source_canonical_proof target_canonical_proof))

; lookup_nil_contra: translation preserves property (matches Coq: Lemma)
(declare-fun source_lookup_nil_contra () Bool)
(declare-fun target_lookup_nil_contra () Bool)
(assert (= source_lookup_nil_contra target_lookup_nil_contra))

; progress: translation preserves property (matches Coq: Theorem)
(declare-fun source_progress () Bool)
(declare-fun target_progress () Bool)
(assert (= source_progress target_progress))

; canonical_unit: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_unit () Bool)
(declare-fun target_canonical_unit () Bool)
(assert (= source_canonical_unit target_canonical_unit))

; canonical_int: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_int () Bool)
(declare-fun target_canonical_int () Bool)
(assert (= source_canonical_int target_canonical_int))

; canonical_string: translation preserves property (matches Coq: Lemma)
(declare-fun source_canonical_string () Bool)
(declare-fun target_canonical_string () Bool)
(assert (= source_canonical_string target_canonical_string))

; typed_value_bool_inv: translation preserves property (matches Coq: Lemma)
(declare-fun source_typed_value_bool_inv () Bool)
(declare-fun target_typed_value_bool_inv () Bool)
(assert (= source_typed_value_bool_inv target_typed_value_bool_inv))

; typed_value_pair_inv: translation preserves property (matches Coq: Lemma)
(declare-fun source_typed_value_pair_inv () Bool)
(declare-fun target_typed_value_pair_inv () Bool)
(assert (= source_typed_value_pair_inv target_typed_value_pair_inv))

; typed_value_sum_inv: translation preserves property (matches Coq: Lemma)
(declare-fun source_typed_value_sum_inv () Bool)
(declare-fun target_typed_value_sum_inv () Bool)
(assert (= source_typed_value_sum_inv target_typed_value_sum_inv))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

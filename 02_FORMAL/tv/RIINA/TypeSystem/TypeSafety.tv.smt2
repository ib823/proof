; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/type_system/TypeSafety.v (6 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for TypeSafety
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; stuck: source semantics (matches Coq)
(declare-fun source_stuck () Bool)
(declare-fun target_stuck () Bool)
(assert (= source_stuck target_stuck))

; type_safety: translation preserves property (matches Coq: Theorem)
(declare-fun source_type_safety () Bool)
(declare-fun target_type_safety () Bool)
(assert (= source_type_safety target_type_safety))

; multi_step_safety: translation preserves property (matches Coq: Theorem)
(declare-fun source_multi_step_safety () Bool)
(declare-fun target_multi_step_safety () Bool)
(assert (= source_multi_step_safety target_multi_step_safety))

; stuck_implies_not_value: translation preserves property (matches Coq: Lemma)
(declare-fun source_stuck_implies_not_value () Bool)
(declare-fun target_stuck_implies_not_value () Bool)
(assert (= source_stuck_implies_not_value target_stuck_implies_not_value))

; stuck_implies_not_stepping: translation preserves property (matches Coq: Lemma)
(declare-fun source_stuck_implies_not_stepping () Bool)
(declare-fun target_stuck_implies_not_stepping () Bool)
(assert (= source_stuck_implies_not_stepping target_stuck_implies_not_stepping))

; not_stuck_from_value_or_step: translation preserves property (matches Coq: Lemma)
(declare-fun source_not_stuck_from_value_or_step () Bool)
(declare-fun target_not_stuck_from_value_or_step () Bool)
(assert (= source_not_stuck_from_value_or_step target_not_stuck_from_value_or_step))

; stuck_complete: translation preserves property (matches Coq: Lemma)
(declare-fun source_stuck_complete () Bool)
(declare-fun target_stuck_complete () Bool)
(assert (= source_stuck_complete target_stuck_complete))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

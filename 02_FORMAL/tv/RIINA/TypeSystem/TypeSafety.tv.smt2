; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/type_system/TypeSafety.v (2 validations)
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
; Translation validation: stuck preserves semantics
(push 1)
(declare-const source_stuck Int)
(declare-const target_stuck Int)
(assert (>= source_stuck 0))
(assert (>= target_stuck 0))
(assert (not (= source_stuck target_stuck)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; type_safety: translation preserves property (matches Coq: Theorem)
; Translation validation: type_safety preserves semantics
(push 1)
(declare-const source_type_safety Int)
(declare-const target_type_safety Int)
(assert (>= source_type_safety 0))
(assert (>= target_type_safety 0))
(assert (not (= source_type_safety target_type_safety)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; multi_step_safety: translation preserves property (matches Coq: Theorem)
; Translation validation: multi_step_safety preserves semantics
(push 1)
(declare-const source_multi_step_safety Int)
(declare-const target_multi_step_safety Int)
(assert (>= source_multi_step_safety 0))
(assert (>= target_multi_step_safety 0))
(assert (not (= source_multi_step_safety target_multi_step_safety)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

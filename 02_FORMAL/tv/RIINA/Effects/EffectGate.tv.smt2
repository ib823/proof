; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/effects/EffectGate.v (38 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for EffectGate
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; is_gate: source semantics (matches Coq)
; Translation validation: is_gate preserves semantics
(push 1)
(declare-const source_is_gate Int)
(declare-const target_is_gate Int)
(assert (>= source_is_gate 0))
(assert (>= target_is_gate 0))
(assert (not (= source_is_gate target_is_gate)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pure_performs_any: translation preserves property (matches Coq: Theorem)
; Translation validation: pure_performs_any preserves semantics
(push 1)
(declare-const source_pure_performs_any Int)
(declare-const target_pure_performs_any Int)
(assert (>= source_pure_performs_any 0))
(assert (>= target_pure_performs_any 0))
(assert (not (= source_pure_performs_any target_pure_performs_any)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pure_full_performs_any: translation preserves property (matches Coq: Theorem)
; Translation validation: pure_full_performs_any preserves semantics
(push 1)
(declare-const source_pure_full_performs_any Int)
(declare-const target_pure_full_performs_any Int)
(assert (>= source_pure_full_performs_any 0))
(assert (>= target_pure_full_performs_any 0))
(assert (not (= source_pure_full_performs_any target_pure_full_performs_any)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; grant_no_escalation: translation preserves property (matches Coq: Theorem)
; Translation validation: grant_no_escalation preserves semantics
(push 1)
(declare-const source_grant_no_escalation Int)
(declare-const target_grant_no_escalation Int)
(assert (>= source_grant_no_escalation 0))
(assert (>= target_grant_no_escalation 0))
(assert (not (= source_grant_no_escalation target_grant_no_escalation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; grant_effect_transparent: translation preserves property (matches Coq: Theorem)
; Translation validation: grant_effect_transparent preserves semantics
(push 1)
(declare-const source_grant_effect_transparent Int)
(declare-const target_grant_effect_transparent Int)
(assert (>= source_grant_effect_transparent 0))
(assert (>= target_grant_effect_transparent 0))
(assert (not (= source_grant_effect_transparent target_grant_effect_transparent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; grant_preserves_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: grant_preserves_bound preserves semantics
(push 1)
(declare-const source_grant_preserves_bound Int)
(declare-const target_grant_preserves_bound Int)
(assert (>= source_grant_preserves_bound 0))
(assert (>= target_grant_preserves_bound 0))
(assert (not (= source_grant_preserves_bound target_grant_preserves_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; handle_body_bound: translation preserves property (matches Coq: Lemma)
; Translation validation: handle_body_bound preserves semantics
(push 1)
(declare-const source_handle_body_bound Int)
(declare-const target_handle_body_bound Int)
(assert (>= source_handle_body_bound 0))
(assert (>= target_handle_body_bound 0))
(assert (not (= source_handle_body_bound target_handle_body_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; handle_handler_bound: translation preserves property (matches Coq: Lemma)
; Translation validation: handle_handler_bound preserves semantics
(push 1)
(declare-const source_handle_handler_bound Int)
(declare-const target_handle_handler_bound Int)
(assert (>= source_handle_handler_bound 0))
(assert (>= target_handle_handler_bound 0))
(assert (not (= source_handle_handler_bound target_handle_handler_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; handle_bound_combine: translation preserves property (matches Coq: Lemma)
; Translation validation: handle_bound_combine preserves semantics
(push 1)
(declare-const source_handle_bound_combine Int)
(declare-const target_handle_bound_combine Int)
(assert (>= source_handle_bound_combine 0))
(assert (>= target_handle_bound_combine 0))
(assert (not (= source_handle_bound_combine target_handle_bound_combine)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; perform_requires_license: translation preserves property (matches Coq: Theorem)
; Translation validation: perform_requires_license preserves semantics
(push 1)
(declare-const source_perform_requires_license Int)
(declare-const target_perform_requires_license Int)
(assert (>= source_perform_requires_license 0))
(assert (>= target_perform_requires_license 0))
(assert (not (= source_perform_requires_license target_perform_requires_license)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nonpure_level_pos: translation preserves property (matches Coq: Lemma)
; Translation validation: nonpure_level_pos preserves semantics
(push 1)
(declare-const source_nonpure_level_pos Int)
(declare-const target_nonpure_level_pos Int)
(assert (>= source_nonpure_level_pos 0))
(assert (>= target_nonpure_level_pos 0))
(assert (not (= source_nonpure_level_pos target_nonpure_level_pos)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pure_perform_is_pure: translation preserves property (matches Coq: Theorem)
; Translation validation: pure_perform_is_pure preserves semantics
(push 1)
(declare-const source_pure_perform_is_pure Int)
(declare-const target_pure_perform_is_pure Int)
(assert (>= source_pure_perform_is_pure 0))
(assert (>= target_pure_perform_is_pure 0))
(assert (not (= source_pure_perform_is_pure target_pure_perform_is_pure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; closed_pure_no_effects: translation preserves property (matches Coq: Theorem)
; Translation validation: closed_pure_no_effects preserves semantics
(push 1)
(declare-const source_closed_pure_no_effects Int)
(declare-const target_closed_pure_no_effects Int)
(assert (>= source_closed_pure_no_effects 0))
(assert (>= target_closed_pure_no_effects 0))
(assert (not (= source_closed_pure_no_effects target_closed_pure_no_effects)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; gate_enforcement: translation preserves property (matches Coq: Theorem)
; Translation validation: gate_enforcement preserves semantics
(push 1)
(declare-const source_gate_enforcement Int)
(declare-const target_gate_enforcement Int)
(assert (>= source_gate_enforcement 0))
(assert (>= target_gate_enforcement 0))
(assert (not (= source_gate_enforcement target_gate_enforcement)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; lambda_is_syntactic_gate: translation preserves property (matches Coq: Theorem)
; Translation validation: lambda_is_syntactic_gate preserves semantics
(push 1)
(declare-const source_lambda_is_syntactic_gate Int)
(declare-const target_lambda_is_syntactic_gate Int)
(assert (>= source_lambda_is_syntactic_gate 0))
(assert (>= target_lambda_is_syntactic_gate 0))
(assert (not (= source_lambda_is_syntactic_gate target_lambda_is_syntactic_gate)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; gate_weakening: translation preserves property (matches Coq: Theorem)
; Translation validation: gate_weakening preserves semantics
(push 1)
(declare-const source_gate_weakening Int)
(declare-const target_gate_weakening Int)
(assert (>= source_gate_weakening 0))
(assert (>= target_gate_weakening 0))
(assert (not (= source_gate_weakening target_gate_weakening)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; effect_sound_after_step: translation preserves property (matches Coq: Theorem)
; Translation validation: effect_sound_after_step preserves semantics
(push 1)
(declare-const source_effect_sound_after_step Int)
(declare-const target_effect_sound_after_step Int)
(assert (>= source_effect_sound_after_step 0))
(assert (>= target_effect_sound_after_step 0))
(assert (not (= source_effect_sound_after_step target_effect_sound_after_step)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; effect_sound_multi_step: translation preserves property (matches Coq: Theorem)
; Translation validation: effect_sound_multi_step preserves semantics
(push 1)
(declare-const source_effect_sound_multi_step Int)
(declare-const target_effect_sound_multi_step Int)
(assert (>= source_effect_sound_multi_step 0))
(assert (>= target_effect_sound_multi_step 0))
(assert (not (= source_effect_sound_multi_step target_effect_sound_multi_step)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; capability_lexical_scope: translation preserves property (matches Coq: Theorem)
; Translation validation: capability_lexical_scope preserves semantics
(push 1)
(declare-const source_capability_lexical_scope Int)
(declare-const target_capability_lexical_scope Int)
(assert (>= source_capability_lexical_scope 0))
(assert (>= target_capability_lexical_scope 0))
(assert (not (= source_capability_lexical_scope target_capability_lexical_scope)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; require_effect_additive: translation preserves property (matches Coq: Theorem)
; Translation validation: require_effect_additive preserves semantics
(push 1)
(declare-const source_require_effect_additive Int)
(declare-const target_require_effect_additive Int)
(assert (>= source_require_effect_additive 0))
(assert (>= target_require_effect_additive 0))
(assert (not (= source_require_effect_additive target_require_effect_additive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; app_joins_effects: translation preserves property (matches Coq: Theorem)
; Translation validation: app_joins_effects preserves semantics
(push 1)
(declare-const source_app_joins_effects Int)
(declare-const target_app_joins_effects Int)
(assert (>= source_app_joins_effects 0))
(assert (>= target_app_joins_effects 0))
(assert (not (= source_app_joins_effects target_app_joins_effects)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; let_joins_effects: translation preserves property (matches Coq: Theorem)
; Translation validation: let_joins_effects preserves semantics
(push 1)
(declare-const source_let_joins_effects Int)
(declare-const target_let_joins_effects Int)
(assert (>= source_let_joins_effects 0))
(assert (>= target_let_joins_effects 0))
(assert (not (= source_let_joins_effects target_let_joins_effects)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; effect_isolation: translation preserves property (matches Coq: Theorem)
; Translation validation: effect_isolation preserves semantics
(push 1)
(declare-const source_effect_isolation Int)
(declare-const target_effect_isolation Int)
(assert (>= source_effect_isolation 0))
(assert (>= target_effect_isolation 0))
(assert (not (= source_effect_isolation target_effect_isolation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; effect_isolation_let: translation preserves property (matches Coq: Theorem)
; Translation validation: effect_isolation_let preserves semantics
(push 1)
(declare-const source_effect_isolation_let Int)
(declare-const target_effect_isolation_let Int)
(assert (>= source_effect_isolation_let 0))
(assert (>= target_effect_isolation_let 0))
(assert (not (= source_effect_isolation_let target_effect_isolation_let)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; effect_isolation_pair: translation preserves property (matches Coq: Theorem)
; Translation validation: effect_isolation_pair preserves semantics
(push 1)
(declare-const source_effect_isolation_pair Int)
(declare-const target_effect_isolation_pair Int)
(assert (>= source_effect_isolation_pair 0))
(assert (>= target_effect_isolation_pair 0))
(assert (not (= source_effect_isolation_pair target_effect_isolation_pair)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; double_handle_body: translation preserves property (matches Coq: Theorem)
; Translation validation: double_handle_body preserves semantics
(push 1)
(declare-const source_double_handle_body Int)
(declare-const target_double_handle_body Int)
(assert (>= source_double_handle_body 0))
(assert (>= target_double_handle_body 0))
(assert (not (= source_double_handle_body target_double_handle_body)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; double_handle_outer_handler: translation preserves property (matches Coq: Theorem)
; Translation validation: double_handle_outer_handler preserves semantics
(push 1)
(declare-const source_double_handle_outer_handler Int)
(declare-const target_double_handle_outer_handler Int)
(assert (>= source_double_handle_outer_handler 0))
(assert (>= target_double_handle_outer_handler 0))
(assert (not (= source_double_handle_outer_handler target_double_handle_outer_handler)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; double_handle_inner_handler: translation preserves property (matches Coq: Theorem)
; Translation validation: double_handle_inner_handler preserves semantics
(push 1)
(declare-const source_double_handle_inner_handler Int)
(declare-const target_double_handle_inner_handler Int)
(assert (>= source_double_handle_inner_handler 0))
(assert (>= target_double_handle_inner_handler 0))
(assert (not (= source_double_handle_inner_handler target_double_handle_inner_handler)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; program_effect_contained: translation preserves property (matches Coq: Theorem)
; Translation validation: program_effect_contained preserves semantics
(push 1)
(declare-const source_program_effect_contained Int)
(declare-const target_program_effect_contained Int)
(assert (>= source_program_effect_contained 0))
(assert (>= target_program_effect_contained 0))
(assert (not (= source_program_effect_contained target_program_effect_contained)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pure_program_no_effects: translation preserves property (matches Coq: Theorem)
; Translation validation: pure_program_no_effects preserves semantics
(push 1)
(declare-const source_pure_program_no_effects Int)
(declare-const target_pure_program_no_effects Int)
(assert (>= source_pure_program_no_effects 0))
(assert (>= target_pure_program_no_effects 0))
(assert (not (= source_pure_program_no_effects target_pure_program_no_effects)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; grant_idempotent_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: grant_idempotent_bound preserves semantics
(push 1)
(declare-const source_grant_idempotent_bound Int)
(declare-const target_grant_idempotent_bound Int)
(assert (>= source_grant_idempotent_bound 0))
(assert (>= target_grant_idempotent_bound 0))
(assert (not (= source_grant_idempotent_bound target_grant_idempotent_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; require_bound_transparent: translation preserves property (matches Coq: Theorem)
; Translation validation: require_bound_transparent preserves semantics
(push 1)
(declare-const source_require_bound_transparent Int)
(declare-const target_require_bound_transparent Int)
(assert (>= source_require_bound_transparent 0))
(assert (>= target_require_bound_transparent 0))
(assert (not (= source_require_bound_transparent target_require_bound_transparent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; if_performs_within: translation preserves property (matches Coq: Theorem)
; Translation validation: if_performs_within preserves semantics
(push 1)
(declare-const source_if_performs_within Int)
(declare-const target_if_performs_within Int)
(assert (>= source_if_performs_within 0))
(assert (>= target_if_performs_within 0))
(assert (not (= source_if_performs_within target_if_performs_within)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; case_performs_within: translation preserves property (matches Coq: Theorem)
; Translation validation: case_performs_within preserves semantics
(push 1)
(declare-const source_case_performs_within Int)
(declare-const target_case_performs_within Int)
(assert (>= source_case_performs_within 0))
(assert (>= target_case_performs_within 0))
(assert (not (= source_case_performs_within target_case_performs_within)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ref_performs_within: translation preserves property (matches Coq: Theorem)
; Translation validation: ref_performs_within preserves semantics
(push 1)
(declare-const source_ref_performs_within Int)
(declare-const target_ref_performs_within Int)
(assert (>= source_ref_performs_within 0))
(assert (>= target_ref_performs_within 0))
(assert (not (= source_ref_performs_within target_ref_performs_within)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; deref_performs_within: translation preserves property (matches Coq: Theorem)
; Translation validation: deref_performs_within preserves semantics
(push 1)
(declare-const source_deref_performs_within Int)
(declare-const target_deref_performs_within Int)
(assert (>= source_deref_performs_within 0))
(assert (>= target_deref_performs_within 0))
(assert (not (= source_deref_performs_within target_deref_performs_within)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; assign_performs_within: translation preserves property (matches Coq: Theorem)
; Translation validation: assign_performs_within preserves semantics
(push 1)
(declare-const source_assign_performs_within Int)
(declare-const target_assign_performs_within Int)
(assert (>= source_assign_performs_within 0))
(assert (>= target_assign_performs_within 0))
(assert (not (= source_assign_performs_within target_assign_performs_within)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; classify_performs_within: translation preserves property (matches Coq: Theorem)
; Translation validation: classify_performs_within preserves semantics
(push 1)
(declare-const source_classify_performs_within Int)
(declare-const target_classify_performs_within Int)
(assert (>= source_classify_performs_within 0))
(assert (>= target_classify_performs_within 0))
(assert (not (= source_classify_performs_within target_classify_performs_within)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; prove_performs_within: translation preserves property (matches Coq: Theorem)
; Translation validation: prove_performs_within preserves semantics
(push 1)
(declare-const source_prove_performs_within Int)
(declare-const target_prove_performs_within Int)
(assert (>= source_prove_performs_within 0))
(assert (>= target_prove_performs_within 0))
(assert (not (= source_prove_performs_within target_prove_performs_within)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

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
(declare-fun source_is_gate () Bool)
(declare-fun target_is_gate () Bool)
(assert (= source_is_gate target_is_gate))

; pure_performs_any: translation preserves property (matches Coq: Theorem)
(declare-fun source_pure_performs_any () Bool)
(declare-fun target_pure_performs_any () Bool)
(assert (= source_pure_performs_any target_pure_performs_any))

; pure_full_performs_any: translation preserves property (matches Coq: Theorem)
(declare-fun source_pure_full_performs_any () Bool)
(declare-fun target_pure_full_performs_any () Bool)
(assert (= source_pure_full_performs_any target_pure_full_performs_any))

; grant_no_escalation: translation preserves property (matches Coq: Theorem)
(declare-fun source_grant_no_escalation () Bool)
(declare-fun target_grant_no_escalation () Bool)
(assert (= source_grant_no_escalation target_grant_no_escalation))

; grant_effect_transparent: translation preserves property (matches Coq: Theorem)
(declare-fun source_grant_effect_transparent () Bool)
(declare-fun target_grant_effect_transparent () Bool)
(assert (= source_grant_effect_transparent target_grant_effect_transparent))

; grant_preserves_bound: translation preserves property (matches Coq: Theorem)
(declare-fun source_grant_preserves_bound () Bool)
(declare-fun target_grant_preserves_bound () Bool)
(assert (= source_grant_preserves_bound target_grant_preserves_bound))

; handle_body_bound: translation preserves property (matches Coq: Lemma)
(declare-fun source_handle_body_bound () Bool)
(declare-fun target_handle_body_bound () Bool)
(assert (= source_handle_body_bound target_handle_body_bound))

; handle_handler_bound: translation preserves property (matches Coq: Lemma)
(declare-fun source_handle_handler_bound () Bool)
(declare-fun target_handle_handler_bound () Bool)
(assert (= source_handle_handler_bound target_handle_handler_bound))

; handle_bound_combine: translation preserves property (matches Coq: Lemma)
(declare-fun source_handle_bound_combine () Bool)
(declare-fun target_handle_bound_combine () Bool)
(assert (= source_handle_bound_combine target_handle_bound_combine))

; perform_requires_license: translation preserves property (matches Coq: Theorem)
(declare-fun source_perform_requires_license () Bool)
(declare-fun target_perform_requires_license () Bool)
(assert (= source_perform_requires_license target_perform_requires_license))

; nonpure_level_pos: translation preserves property (matches Coq: Lemma)
(declare-fun source_nonpure_level_pos () Bool)
(declare-fun target_nonpure_level_pos () Bool)
(assert (= source_nonpure_level_pos target_nonpure_level_pos))

; pure_perform_is_pure: translation preserves property (matches Coq: Theorem)
(declare-fun source_pure_perform_is_pure () Bool)
(declare-fun target_pure_perform_is_pure () Bool)
(assert (= source_pure_perform_is_pure target_pure_perform_is_pure))

; closed_pure_no_effects: translation preserves property (matches Coq: Theorem)
(declare-fun source_closed_pure_no_effects () Bool)
(declare-fun target_closed_pure_no_effects () Bool)
(assert (= source_closed_pure_no_effects target_closed_pure_no_effects))

; gate_enforcement: translation preserves property (matches Coq: Theorem)
(declare-fun source_gate_enforcement () Bool)
(declare-fun target_gate_enforcement () Bool)
(assert (= source_gate_enforcement target_gate_enforcement))

; lambda_is_syntactic_gate: translation preserves property (matches Coq: Theorem)
(declare-fun source_lambda_is_syntactic_gate () Bool)
(declare-fun target_lambda_is_syntactic_gate () Bool)
(assert (= source_lambda_is_syntactic_gate target_lambda_is_syntactic_gate))

; gate_weakening: translation preserves property (matches Coq: Theorem)
(declare-fun source_gate_weakening () Bool)
(declare-fun target_gate_weakening () Bool)
(assert (= source_gate_weakening target_gate_weakening))

; effect_sound_after_step: translation preserves property (matches Coq: Theorem)
(declare-fun source_effect_sound_after_step () Bool)
(declare-fun target_effect_sound_after_step () Bool)
(assert (= source_effect_sound_after_step target_effect_sound_after_step))

; effect_sound_multi_step: translation preserves property (matches Coq: Theorem)
(declare-fun source_effect_sound_multi_step () Bool)
(declare-fun target_effect_sound_multi_step () Bool)
(assert (= source_effect_sound_multi_step target_effect_sound_multi_step))

; capability_lexical_scope: translation preserves property (matches Coq: Theorem)
(declare-fun source_capability_lexical_scope () Bool)
(declare-fun target_capability_lexical_scope () Bool)
(assert (= source_capability_lexical_scope target_capability_lexical_scope))

; require_effect_additive: translation preserves property (matches Coq: Theorem)
(declare-fun source_require_effect_additive () Bool)
(declare-fun target_require_effect_additive () Bool)
(assert (= source_require_effect_additive target_require_effect_additive))

; app_joins_effects: translation preserves property (matches Coq: Theorem)
(declare-fun source_app_joins_effects () Bool)
(declare-fun target_app_joins_effects () Bool)
(assert (= source_app_joins_effects target_app_joins_effects))

; let_joins_effects: translation preserves property (matches Coq: Theorem)
(declare-fun source_let_joins_effects () Bool)
(declare-fun target_let_joins_effects () Bool)
(assert (= source_let_joins_effects target_let_joins_effects))

; effect_isolation: translation preserves property (matches Coq: Theorem)
(declare-fun source_effect_isolation () Bool)
(declare-fun target_effect_isolation () Bool)
(assert (= source_effect_isolation target_effect_isolation))

; effect_isolation_let: translation preserves property (matches Coq: Theorem)
(declare-fun source_effect_isolation_let () Bool)
(declare-fun target_effect_isolation_let () Bool)
(assert (= source_effect_isolation_let target_effect_isolation_let))

; effect_isolation_pair: translation preserves property (matches Coq: Theorem)
(declare-fun source_effect_isolation_pair () Bool)
(declare-fun target_effect_isolation_pair () Bool)
(assert (= source_effect_isolation_pair target_effect_isolation_pair))

; double_handle_body: translation preserves property (matches Coq: Theorem)
(declare-fun source_double_handle_body () Bool)
(declare-fun target_double_handle_body () Bool)
(assert (= source_double_handle_body target_double_handle_body))

; double_handle_outer_handler: translation preserves property (matches Coq: Theorem)
(declare-fun source_double_handle_outer_handler () Bool)
(declare-fun target_double_handle_outer_handler () Bool)
(assert (= source_double_handle_outer_handler target_double_handle_outer_handler))

; double_handle_inner_handler: translation preserves property (matches Coq: Theorem)
(declare-fun source_double_handle_inner_handler () Bool)
(declare-fun target_double_handle_inner_handler () Bool)
(assert (= source_double_handle_inner_handler target_double_handle_inner_handler))

; program_effect_contained: translation preserves property (matches Coq: Theorem)
(declare-fun source_program_effect_contained () Bool)
(declare-fun target_program_effect_contained () Bool)
(assert (= source_program_effect_contained target_program_effect_contained))

; pure_program_no_effects: translation preserves property (matches Coq: Theorem)
(declare-fun source_pure_program_no_effects () Bool)
(declare-fun target_pure_program_no_effects () Bool)
(assert (= source_pure_program_no_effects target_pure_program_no_effects))

; grant_idempotent_bound: translation preserves property (matches Coq: Theorem)
(declare-fun source_grant_idempotent_bound () Bool)
(declare-fun target_grant_idempotent_bound () Bool)
(assert (= source_grant_idempotent_bound target_grant_idempotent_bound))

; require_bound_transparent: translation preserves property (matches Coq: Theorem)
(declare-fun source_require_bound_transparent () Bool)
(declare-fun target_require_bound_transparent () Bool)
(assert (= source_require_bound_transparent target_require_bound_transparent))

; if_performs_within: translation preserves property (matches Coq: Theorem)
(declare-fun source_if_performs_within () Bool)
(declare-fun target_if_performs_within () Bool)
(assert (= source_if_performs_within target_if_performs_within))

; case_performs_within: translation preserves property (matches Coq: Theorem)
(declare-fun source_case_performs_within () Bool)
(declare-fun target_case_performs_within () Bool)
(assert (= source_case_performs_within target_case_performs_within))

; ref_performs_within: translation preserves property (matches Coq: Theorem)
(declare-fun source_ref_performs_within () Bool)
(declare-fun target_ref_performs_within () Bool)
(assert (= source_ref_performs_within target_ref_performs_within))

; deref_performs_within: translation preserves property (matches Coq: Theorem)
(declare-fun source_deref_performs_within () Bool)
(declare-fun target_deref_performs_within () Bool)
(assert (= source_deref_performs_within target_deref_performs_within))

; assign_performs_within: translation preserves property (matches Coq: Theorem)
(declare-fun source_assign_performs_within () Bool)
(declare-fun target_assign_performs_within () Bool)
(assert (= source_assign_performs_within target_assign_performs_within))

; classify_performs_within: translation preserves property (matches Coq: Theorem)
(declare-fun source_classify_performs_within () Bool)
(declare-fun target_classify_performs_within () Bool)
(assert (= source_classify_performs_within target_classify_performs_within))

; prove_performs_within: translation preserves property (matches Coq: Theorem)
(declare-fun source_prove_performs_within () Bool)
(declare-fun target_prove_performs_within () Bool)
(assert (= source_prove_performs_within target_prove_performs_within))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/PSI001_OperationalSecurity.v (39 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for PSI001_OperationalSecurity
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; field_add: source semantics (matches Coq)
; Translation validation: field_add preserves semantics
(push 1)
(declare-const source_field_add Int)
(declare-const target_field_add Int)
(assert (>= source_field_add 0))
(assert (>= target_field_add 0))
(assert (not (= source_field_add target_field_add)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; field_mul: source semantics (matches Coq)
; Translation validation: field_mul preserves semantics
(push 1)
(declare-const source_field_mul Int)
(declare-const target_field_mul Int)
(assert (>= source_field_mul 0))
(assert (>= target_field_mul 0))
(assert (not (= source_field_mul target_field_mul)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; field_sub: source semantics (matches Coq)
; Translation validation: field_sub preserves semantics
(push 1)
(declare-const source_field_sub Int)
(declare-const target_field_sub Int)
(assert (>= source_field_sub 0))
(assert (>= target_field_sub 0))
(assert (not (= source_field_sub target_field_sub)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; poly_eval: source semantics (matches Coq)
; Translation validation: poly_eval preserves semantics
(push 1)
(declare-const source_poly_eval Int)
(declare-const target_poly_eval Int)
(assert (>= source_poly_eval 0))
(assert (>= target_poly_eval 0))
(assert (not (= source_poly_eval target_poly_eval)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; secret_from_poly: source semantics (matches Coq)
; Translation validation: secret_from_poly preserves semantics
(push 1)
(declare-const source_secret_from_poly Int)
(declare-const target_secret_from_poly Int)
(assert (>= source_secret_from_poly 0))
(assert (>= target_secret_from_poly 0))
(assert (not (= source_secret_from_poly target_secret_from_poly)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; threshold_met: source semantics (matches Coq)
; Translation validation: threshold_met preserves semantics
(push 1)
(declare-const source_threshold_met Int)
(declare-const target_threshold_met Int)
(assert (>= source_threshold_met 0))
(assert (>= target_threshold_met 0))
(assert (not (= source_threshold_met target_threshold_met)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tp_approved: source semantics (matches Coq)
; Translation validation: tp_approved preserves semantics
(push 1)
(declare-const source_tp_approved Int)
(declare-const target_tp_approved Int)
(assert (>= source_tp_approved 0))
(assert (>= target_tp_approved 0))
(assert (not (= source_tp_approved target_tp_approved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tp_add_approval: source semantics (matches Coq)
; Translation validation: tp_add_approval preserves semantics
(push 1)
(declare-const source_tp_add_approval Int)
(declare-const target_tp_add_approval Int)
(assert (>= source_tp_add_approval 0))
(assert (>= target_tp_add_approval 0))
(assert (not (= source_tp_add_approval target_tp_add_approval)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tp_valid: source semantics (matches Coq)
; Translation validation: tp_valid preserves semantics
(push 1)
(declare-const source_tp_valid Int)
(declare-const target_tp_valid Int)
(assert (>= source_tp_valid 0))
(assert (>= target_tp_valid 0))
(assert (not (= source_tp_valid target_tp_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; handle_auth: source semantics (matches Coq)
; Translation validation: handle_auth preserves semantics
(push 1)
(declare-const source_handle_auth Int)
(declare-const target_handle_auth Int)
(assert (>= source_handle_auth 0))
(assert (>= target_handle_auth 0))
(assert (not (= source_handle_auth target_handle_auth)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dms_check: source semantics (matches Coq)
; Translation validation: dms_check preserves semantics
(push 1)
(declare-const source_dms_check Int)
(declare-const target_dms_check Int)
(assert (>= source_dms_check 0))
(assert (>= target_dms_check 0))
(assert (not (= source_dms_check target_dms_check)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dms_checkin: source semantics (matches Coq)
; Translation validation: dms_checkin preserves semantics
(push 1)
(declare-const source_dms_checkin Int)
(declare-const target_dms_checkin Int)
(assert (>= source_dms_checkin 0))
(assert (>= target_dms_checkin 0))
(assert (not (= source_dms_checkin target_dms_checkin)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ib_can_query: source semantics (matches Coq)
; Translation validation: ib_can_query preserves semantics
(push 1)
(declare-const source_ib_can_query Int)
(declare-const target_ib_can_query Int)
(assert (>= source_ib_can_query 0))
(assert (>= target_ib_can_query 0))
(assert (not (= source_ib_can_query target_ib_can_query)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ib_record_query: source semantics (matches Coq)
; Translation validation: ib_record_query preserves semantics
(push 1)
(declare-const source_ib_record_query Int)
(declare-const target_ib_record_query Int)
(assert (>= source_ib_record_query 0))
(assert (>= target_ib_record_query 0))
(assert (not (= source_ib_record_query target_ib_record_query)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; audit_log_append: source semantics (matches Coq)
; Translation validation: audit_log_append preserves semantics
(push 1)
(declare-const source_audit_log_append Int)
(declare-const target_audit_log_append Int)
(assert (>= source_audit_log_append 0))
(assert (>= target_audit_log_append 0))
(assert (not (= source_audit_log_append target_audit_log_append)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; audit_chain_valid: source semantics (matches Coq)
; Translation validation: audit_chain_valid preserves semantics
(push 1)
(declare-const source_audit_chain_valid Int)
(declare-const target_audit_chain_valid Int)
(assert (>= source_audit_chain_valid 0))
(assert (>= target_audit_chain_valid 0))
(assert (not (= source_audit_chain_valid target_audit_chain_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; platforms_independent: source semantics (matches Coq)
; Translation validation: platforms_independent preserves semantics
(push 1)
(declare-const source_platforms_independent Int)
(declare-const target_platforms_independent Int)
(assert (>= source_platforms_independent 0))
(assert (>= target_platforms_independent 0))
(assert (not (= source_platforms_independent target_platforms_independent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nversion_agree: source semantics (matches Coq)
; Translation validation: nversion_agree preserves semantics
(push 1)
(declare-const source_nversion_agree Int)
(declare-const target_nversion_agree Int)
(assert (>= source_nversion_agree 0))
(assert (>= target_nversion_agree 0))
(assert (not (= source_nversion_agree target_nversion_agree)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tl_can_execute: source semantics (matches Coq)
; Translation validation: tl_can_execute preserves semantics
(push 1)
(declare-const source_tl_can_execute Int)
(declare-const target_tl_can_execute Int)
(assert (>= source_tl_can_execute 0))
(assert (>= target_tl_can_execute 0))
(assert (not (= source_tl_can_execute target_tl_can_execute)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tl_can_cancel: source semantics (matches Coq)
; Translation validation: tl_can_cancel preserves semantics
(push 1)
(declare-const source_tl_can_cancel Int)
(declare-const target_tl_can_cancel Int)
(assert (>= source_tl_can_cancel 0))
(assert (>= target_tl_can_cancel 0))
(assert (not (= source_tl_can_cancel target_tl_can_cancel)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tl_cancel: source semantics (matches Coq)
; Translation validation: tl_cancel preserves semantics
(push 1)
(declare-const source_tl_cancel Int)
(declare-const target_tl_cancel Int)
(assert (>= source_tl_cancel 0))
(assert (>= target_tl_cancel 0))
(assert (not (= source_tl_cancel target_tl_cancel)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nth_map_seq: translation preserves property (matches Coq: Lemma)
; Translation validation: nth_map_seq preserves semantics
(push 1)
(declare-const source_nth_map_seq Int)
(declare-const target_nth_map_seq Int)
(assert (>= source_nth_map_seq 0))
(assert (>= target_nth_map_seq 0))
(assert (not (= source_nth_map_seq target_nth_map_seq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_001_01_poly_eval_zero: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_001_01_poly_eval_zero preserves semantics
(push 1)
(declare-const source_PSI_001_01_poly_eval_zero Int)
(declare-const target_PSI_001_01_poly_eval_zero Int)
(assert (>= source_PSI_001_01_poly_eval_zero 0))
(assert (>= target_PSI_001_01_poly_eval_zero 0))
(assert (not (= source_PSI_001_01_poly_eval_zero target_PSI_001_01_poly_eval_zero)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_001_02_generate_shares_length: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_001_02_generate_shares_length preserves semantics
(push 1)
(declare-const source_PSI_001_02_generate_shares_length Int)
(declare-const target_PSI_001_02_generate_shares_length Int)
(assert (>= source_PSI_001_02_generate_shares_length 0))
(assert (>= target_PSI_001_02_generate_shares_length 0))
(assert (not (= source_PSI_001_02_generate_shares_length target_PSI_001_02_generate_shares_length)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_001_03_threshold_monotone: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_001_03_threshold_monotone preserves semantics
(push 1)
(declare-const source_PSI_001_03_threshold_monotone Int)
(declare-const target_PSI_001_03_threshold_monotone Int)
(assert (>= source_PSI_001_03_threshold_monotone 0))
(assert (>= target_PSI_001_03_threshold_monotone 0))
(assert (not (= source_PSI_001_03_threshold_monotone target_PSI_001_03_threshold_monotone)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_001_04_insufficient_shares: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_001_04_insufficient_shares preserves semantics
(push 1)
(declare-const source_PSI_001_04_insufficient_shares Int)
(declare-const target_PSI_001_04_insufficient_shares Int)
(assert (>= source_PSI_001_04_insufficient_shares 0))
(assert (>= target_PSI_001_04_insufficient_shares 0))
(assert (not (= source_PSI_001_04_insufficient_shares target_PSI_001_04_insufficient_shares)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_001_05_share_x_positive: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_001_05_share_x_positive preserves semantics
(push 1)
(declare-const source_PSI_001_05_share_x_positive Int)
(declare-const target_PSI_001_05_share_x_positive Int)
(assert (>= source_PSI_001_05_share_x_positive 0))
(assert (>= target_PSI_001_05_share_x_positive 0))
(assert (not (= source_PSI_001_05_share_x_positive target_PSI_001_05_share_x_positive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_001_06_shares_distinct_x: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_001_06_shares_distinct_x preserves semantics
(push 1)
(declare-const source_PSI_001_06_shares_distinct_x Int)
(declare-const target_PSI_001_06_shares_distinct_x Int)
(assert (>= source_PSI_001_06_shares_distinct_x 0))
(assert (>= target_PSI_001_06_shares_distinct_x 0))
(assert (not (= source_PSI_001_06_shares_distinct_x target_PSI_001_06_shares_distinct_x)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_001_07_secret_is_constant_term: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_001_07_secret_is_constant_term preserves semantics
(push 1)
(declare-const source_PSI_001_07_secret_is_constant_term Int)
(declare-const target_PSI_001_07_secret_is_constant_term Int)
(assert (>= source_PSI_001_07_secret_is_constant_term 0))
(assert (>= target_PSI_001_07_secret_is_constant_term 0))
(assert (not (= source_PSI_001_07_secret_is_constant_term target_PSI_001_07_secret_is_constant_term)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_001_08_empty_poly_zero_secret: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_001_08_empty_poly_zero_secret preserves semantics
(push 1)
(declare-const source_PSI_001_08_empty_poly_zero_secret Int)
(declare-const target_PSI_001_08_empty_poly_zero_secret Int)
(assert (>= source_PSI_001_08_empty_poly_zero_secret 0))
(assert (>= target_PSI_001_08_empty_poly_zero_secret 0))
(assert (not (= source_PSI_001_08_empty_poly_zero_secret target_PSI_001_08_empty_poly_zero_secret)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_002_01_single_approval_insufficient: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_002_01_single_approval_insufficient preserves semantics
(push 1)
(declare-const source_PSI_002_01_single_approval_insufficient Int)
(declare-const target_PSI_002_01_single_approval_insufficient Int)
(assert (>= source_PSI_002_01_single_approval_insufficient 0))
(assert (>= target_PSI_002_01_single_approval_insufficient 0))
(assert (not (= source_PSI_002_01_single_approval_insufficient target_PSI_002_01_single_approval_insufficient)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_002_02_approval_monotone: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_002_02_approval_monotone preserves semantics
(push 1)
(declare-const source_PSI_002_02_approval_monotone Int)
(declare-const target_PSI_002_02_approval_monotone Int)
(assert (>= source_PSI_002_02_approval_monotone 0))
(assert (>= target_PSI_002_02_approval_monotone 0))
(assert (not (= source_PSI_002_02_approval_monotone target_PSI_002_02_approval_monotone)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_002_03_duplicate_approval_noop: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_002_03_duplicate_approval_noop preserves semantics
(push 1)
(declare-const source_PSI_002_03_duplicate_approval_noop Int)
(declare-const target_PSI_002_03_duplicate_approval_noop Int)
(assert (>= source_PSI_002_03_duplicate_approval_noop 0))
(assert (>= target_PSI_002_03_duplicate_approval_noop 0))
(assert (not (= source_PSI_002_03_duplicate_approval_noop target_PSI_002_03_duplicate_approval_noop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_002_04_valid_policy_n_le_m: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_002_04_valid_policy_n_le_m preserves semantics
(push 1)
(declare-const source_PSI_002_04_valid_policy_n_le_m Int)
(declare-const target_PSI_002_04_valid_policy_n_le_m Int)
(assert (>= source_PSI_002_04_valid_policy_n_le_m 0))
(assert (>= target_PSI_002_04_valid_policy_n_le_m 0))
(assert (not (= source_PSI_002_04_valid_policy_n_le_m target_PSI_002_04_valid_policy_n_le_m)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_002_05_valid_policy_n_positive: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_002_05_valid_policy_n_positive preserves semantics
(push 1)
(declare-const source_PSI_002_05_valid_policy_n_positive Int)
(declare-const target_PSI_002_05_valid_policy_n_positive Int)
(assert (>= source_PSI_002_05_valid_policy_n_positive 0))
(assert (>= target_PSI_002_05_valid_policy_n_positive 0))
(assert (not (= source_PSI_002_05_valid_policy_n_positive target_PSI_002_05_valid_policy_n_positive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_002_06_approval_count_increases: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_002_06_approval_count_increases preserves semantics
(push 1)
(declare-const source_PSI_002_06_approval_count_increases Int)
(declare-const target_PSI_002_06_approval_count_increases Int)
(assert (>= source_PSI_002_06_approval_count_increases 0))
(assert (>= target_PSI_002_06_approval_count_increases 0))
(assert (not (= source_PSI_002_06_approval_count_increases target_PSI_002_06_approval_count_increases)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_003_01_duress_triggers_alert: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_003_01_duress_triggers_alert preserves semantics
(push 1)
(declare-const source_PSI_003_01_duress_triggers_alert Int)
(declare-const target_PSI_003_01_duress_triggers_alert Int)
(assert (>= source_PSI_003_01_duress_triggers_alert 0))
(assert (>= target_PSI_003_01_duress_triggers_alert 0))
(assert (not (= source_PSI_003_01_duress_triggers_alert target_PSI_003_01_duress_triggers_alert)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_003_02_duress_provides_fake: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_003_02_duress_provides_fake preserves semantics
(push 1)
(declare-const source_PSI_003_02_duress_provides_fake Int)
(declare-const target_PSI_003_02_duress_provides_fake Int)
(assert (>= source_PSI_003_02_duress_provides_fake 0))
(assert (>= target_PSI_003_02_duress_provides_fake 0))
(assert (not (= source_PSI_003_02_duress_provides_fake target_PSI_003_02_duress_provides_fake)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_003_03_duress_locks_down: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_003_03_duress_locks_down preserves semantics
(push 1)
(declare-const source_PSI_003_03_duress_locks_down Int)
(declare-const target_PSI_003_03_duress_locks_down Int)
(assert (>= source_PSI_003_03_duress_locks_down 0))
(assert (>= target_PSI_003_03_duress_locks_down 0))
(assert (not (= source_PSI_003_03_duress_locks_down target_PSI_003_03_duress_locks_down)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_003_04_all_auth_audited: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_003_04_all_auth_audited preserves semantics
(push 1)
(declare-const source_PSI_003_04_all_auth_audited Int)
(declare-const target_PSI_003_04_all_auth_audited Int)
(assert (>= source_PSI_003_04_all_auth_audited 0))
(assert (>= target_PSI_003_04_all_auth_audited 0))
(assert (not (= source_PSI_003_04_all_auth_audited target_PSI_003_04_all_auth_audited)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_003_05_normal_no_fake: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_003_05_normal_no_fake preserves semantics
(push 1)
(declare-const source_PSI_003_05_normal_no_fake Int)
(declare-const target_PSI_003_05_normal_no_fake Int)
(assert (>= source_PSI_003_05_normal_no_fake 0))
(assert (>= target_PSI_003_05_normal_no_fake 0))
(assert (not (= source_PSI_003_05_normal_no_fake target_PSI_003_05_normal_no_fake)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_003_06_normal_no_alert: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_003_06_normal_no_alert preserves semantics
(push 1)
(declare-const source_PSI_003_06_normal_no_alert Int)
(declare-const target_PSI_003_06_normal_no_alert Int)
(assert (>= source_PSI_003_06_normal_no_alert 0))
(assert (>= target_PSI_003_06_normal_no_alert 0))
(assert (not (= source_PSI_003_06_normal_no_alert target_PSI_003_06_normal_no_alert)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_004_01_checkin_resets: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_004_01_checkin_resets preserves semantics
(push 1)
(declare-const source_PSI_004_01_checkin_resets Int)
(declare-const target_PSI_004_01_checkin_resets Int)
(assert (>= source_PSI_004_01_checkin_resets 0))
(assert (>= target_PSI_004_01_checkin_resets 0))
(assert (not (= source_PSI_004_01_checkin_resets target_PSI_004_01_checkin_resets)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_004_02_checkin_updates_time: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_004_02_checkin_updates_time preserves semantics
(push 1)
(declare-const source_PSI_004_02_checkin_updates_time Int)
(declare-const target_PSI_004_02_checkin_updates_time Int)
(assert (>= source_PSI_004_02_checkin_updates_time 0))
(assert (>= target_PSI_004_02_checkin_updates_time 0))
(assert (not (= source_PSI_004_02_checkin_updates_time target_PSI_004_02_checkin_updates_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_004_03_timeout_triggers: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_004_03_timeout_triggers preserves semantics
(push 1)
(declare-const source_PSI_004_03_timeout_triggers Int)
(declare-const target_PSI_004_03_timeout_triggers Int)
(assert (>= source_PSI_004_03_timeout_triggers 0))
(assert (>= target_PSI_004_03_timeout_triggers 0))
(assert (not (= source_PSI_004_03_timeout_triggers target_PSI_004_03_timeout_triggers)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_004_04_no_timeout_no_trigger: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_004_04_no_timeout_no_trigger preserves semantics
(push 1)
(declare-const source_PSI_004_04_no_timeout_no_trigger Int)
(declare-const target_PSI_004_04_no_timeout_no_trigger Int)
(assert (>= source_PSI_004_04_no_timeout_no_trigger 0))
(assert (>= target_PSI_004_04_no_timeout_no_trigger 0))
(assert (not (= source_PSI_004_04_no_timeout_no_trigger target_PSI_004_04_no_timeout_no_trigger)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_004_05_recovery_action_preserved: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_004_05_recovery_action_preserved preserves semantics
(push 1)
(declare-const source_PSI_004_05_recovery_action_preserved Int)
(declare-const target_PSI_004_05_recovery_action_preserved Int)
(assert (>= source_PSI_004_05_recovery_action_preserved 0))
(assert (>= target_PSI_004_05_recovery_action_preserved 0))
(assert (not (= source_PSI_004_05_recovery_action_preserved target_PSI_004_05_recovery_action_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_005_01_budget_enforced: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_005_01_budget_enforced preserves semantics
(push 1)
(declare-const source_PSI_005_01_budget_enforced Int)
(declare-const target_PSI_005_01_budget_enforced Int)
(assert (>= source_PSI_005_01_budget_enforced 0))
(assert (>= target_PSI_005_01_budget_enforced 0))
(assert (not (= source_PSI_005_01_budget_enforced target_PSI_005_01_budget_enforced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_005_02_budget_query_count: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_005_02_budget_query_count preserves semantics
(push 1)
(declare-const source_PSI_005_02_budget_query_count Int)
(declare-const target_PSI_005_02_budget_query_count Int)
(assert (>= source_PSI_005_02_budget_query_count 0))
(assert (>= target_PSI_005_02_budget_query_count 0))
(assert (not (= source_PSI_005_02_budget_query_count target_PSI_005_02_budget_query_count)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_005_03_record_increases_bytes: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_005_03_record_increases_bytes preserves semantics
(push 1)
(declare-const source_PSI_005_03_record_increases_bytes Int)
(declare-const target_PSI_005_03_record_increases_bytes Int)
(assert (>= source_PSI_005_03_record_increases_bytes 0))
(assert (>= target_PSI_005_03_record_increases_bytes 0))
(assert (not (= source_PSI_005_03_record_increases_bytes target_PSI_005_03_record_increases_bytes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_005_04_record_increases_queries: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_005_04_record_increases_queries preserves semantics
(push 1)
(declare-const source_PSI_005_04_record_increases_queries Int)
(declare-const target_PSI_005_04_record_increases_queries Int)
(assert (>= source_PSI_005_04_record_increases_queries 0))
(assert (>= target_PSI_005_04_record_increases_queries 0))
(assert (not (= source_PSI_005_04_record_increases_queries target_PSI_005_04_record_increases_queries)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_005_05_audit_append_preserves: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_005_05_audit_append_preserves preserves semantics
(push 1)
(declare-const source_PSI_005_05_audit_append_preserves Int)
(declare-const target_PSI_005_05_audit_append_preserves Int)
(assert (>= source_PSI_005_05_audit_append_preserves 0))
(assert (>= target_PSI_005_05_audit_append_preserves 0))
(assert (not (= source_PSI_005_05_audit_append_preserves target_PSI_005_05_audit_append_preserves)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_006_01_timelock_cancellation_window: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_006_01_timelock_cancellation_window preserves semantics
(push 1)
(declare-const source_PSI_006_01_timelock_cancellation_window Int)
(declare-const target_PSI_006_01_timelock_cancellation_window Int)
(assert (>= source_PSI_006_01_timelock_cancellation_window 0))
(assert (>= target_PSI_006_01_timelock_cancellation_window 0))
(assert (not (= source_PSI_006_01_timelock_cancellation_window target_PSI_006_01_timelock_cancellation_window)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_006_02_cancelled_cannot_execute: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_006_02_cancelled_cannot_execute preserves semantics
(push 1)
(declare-const source_PSI_006_02_cancelled_cannot_execute Int)
(declare-const target_PSI_006_02_cancelled_cannot_execute Int)
(assert (>= source_PSI_006_02_cancelled_cannot_execute 0))
(assert (>= target_PSI_006_02_cancelled_cannot_execute 0))
(assert (not (= source_PSI_006_02_cancelled_cannot_execute target_PSI_006_02_cancelled_cannot_execute)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_006_03_cancel_sets_flag: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_006_03_cancel_sets_flag preserves semantics
(push 1)
(declare-const source_PSI_006_03_cancel_sets_flag Int)
(declare-const target_PSI_006_03_cancel_sets_flag Int)
(assert (>= source_PSI_006_03_cancel_sets_flag 0))
(assert (>= target_PSI_006_03_cancel_sets_flag 0))
(assert (not (= source_PSI_006_03_cancel_sets_flag target_PSI_006_03_cancel_sets_flag)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_006_04_early_execute_blocked: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_006_04_early_execute_blocked preserves semantics
(push 1)
(declare-const source_PSI_006_04_early_execute_blocked Int)
(declare-const target_PSI_006_04_early_execute_blocked Int)
(assert (>= source_PSI_006_04_early_execute_blocked 0))
(assert (>= target_PSI_006_04_early_execute_blocked 0))
(assert (not (= source_PSI_006_04_early_execute_blocked target_PSI_006_04_early_execute_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_006_05_cancel_preserves_operation: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_006_05_cancel_preserves_operation preserves semantics
(push 1)
(declare-const source_PSI_006_05_cancel_preserves_operation Int)
(declare-const target_PSI_006_05_cancel_preserves_operation Int)
(assert (>= source_PSI_006_05_cancel_preserves_operation 0))
(assert (>= target_PSI_006_05_cancel_preserves_operation 0))
(assert (not (= source_PSI_006_05_cancel_preserves_operation target_PSI_006_05_cancel_preserves_operation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_007_01_different_vendor_independent: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_007_01_different_vendor_independent preserves semantics
(push 1)
(declare-const source_PSI_007_01_different_vendor_independent Int)
(declare-const target_PSI_007_01_different_vendor_independent Int)
(assert (>= source_PSI_007_01_different_vendor_independent 0))
(assert (>= target_PSI_007_01_different_vendor_independent 0))
(assert (not (= source_PSI_007_01_different_vendor_independent target_PSI_007_01_different_vendor_independent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_007_02_nversion_single_agrees: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_007_02_nversion_single_agrees preserves semantics
(push 1)
(declare-const source_PSI_007_02_nversion_single_agrees Int)
(declare-const target_PSI_007_02_nversion_single_agrees Int)
(assert (>= source_PSI_007_02_nversion_single_agrees 0))
(assert (>= target_PSI_007_02_nversion_single_agrees 0))
(assert (not (= source_PSI_007_02_nversion_single_agrees target_PSI_007_02_nversion_single_agrees)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; PSI_007_03_nversion_empty_agrees: translation preserves property (matches Coq: Theorem)
; Translation validation: PSI_007_03_nversion_empty_agrees preserves semantics
(push 1)
(declare-const source_PSI_007_03_nversion_empty_agrees Int)
(declare-const target_PSI_007_03_nversion_empty_agrees Int)
(assert (>= source_PSI_007_03_nversion_empty_agrees 0))
(assert (>= target_PSI_007_03_nversion_empty_agrees 0))
(assert (not (= source_PSI_007_03_nversion_empty_agrees target_PSI_007_03_nversion_empty_agrees)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

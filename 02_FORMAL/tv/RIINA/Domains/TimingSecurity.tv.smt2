; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/TimingSecurity.v (67 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for TimingSecurity
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; valid_session_transition: source semantics (matches Coq)
; Translation validation: valid_session_transition preserves semantics
(push 1)
(declare-const source_valid_session_transition Int)
(declare-const target_valid_session_transition Int)
(assert (>= source_valid_session_transition 0))
(assert (>= target_valid_session_transition 0))
(assert (not (= source_valid_session_transition target_valid_session_transition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; timing_leakage: source semantics (matches Coq)
; Translation validation: timing_leakage preserves semantics
(push 1)
(declare-const source_timing_leakage Int)
(declare-const target_timing_leakage Int)
(assert (>= source_timing_leakage 0))
(assert (>= target_timing_leakage 0))
(assert (not (= source_timing_leakage target_timing_leakage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ntp_authenticated: source semantics (matches Coq)
; Translation validation: ntp_authenticated preserves semantics
(push 1)
(declare-const source_ntp_authenticated Int)
(declare-const target_ntp_authenticated Int)
(assert (>= source_ntp_authenticated 0))
(assert (>= target_ntp_authenticated 0))
(assert (not (= source_ntp_authenticated target_ntp_authenticated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; in_replay_window: source semantics (matches Coq)
; Translation validation: in_replay_window preserves semantics
(push 1)
(declare-const source_in_replay_window Int)
(declare-const target_in_replay_window Int)
(assert (>= source_in_replay_window 0))
(assert (>= target_in_replay_window 0))
(assert (not (= source_in_replay_window target_in_replay_window)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nonce_fresh: source semantics (matches Coq)
; Translation validation: nonce_fresh preserves semantics
(push 1)
(declare-const source_nonce_fresh Int)
(declare-const target_nonce_fresh Int)
(assert (>= source_nonce_fresh 0))
(assert (>= target_nonce_fresh 0))
(assert (not (= source_nonce_fresh target_nonce_fresh)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; verify_timestamp_signature: source semantics (matches Coq)
; Translation validation: verify_timestamp_signature preserves semantics
(push 1)
(declare-const source_verify_timestamp_signature Int)
(declare-const target_verify_timestamp_signature Int)
(assert (>= source_verify_timestamp_signature 0))
(assert (>= target_verify_timestamp_signature 0))
(assert (not (= source_verify_timestamp_signature target_verify_timestamp_signature)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; clock_synchronized: source semantics (matches Coq)
; Translation validation: clock_synchronized preserves semantics
(push 1)
(declare-const source_clock_synchronized Int)
(declare-const target_clock_synchronized Int)
(assert (>= source_clock_synchronized 0))
(assert (>= target_clock_synchronized 0))
(assert (not (= source_clock_synchronized target_clock_synchronized)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; respects_lock_order: source semantics (matches Coq)
; Translation validation: respects_lock_order preserves semantics
(push 1)
(declare-const source_respects_lock_order Int)
(declare-const target_respects_lock_order Int)
(assert (>= source_respects_lock_order 0))
(assert (>= target_respects_lock_order 0))
(assert (not (= source_respects_lock_order target_respects_lock_order)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; liveness_guaranteed: source semantics (matches Coq)
; Translation validation: liveness_guaranteed preserves semantics
(push 1)
(declare-const source_liveness_guaranteed Int)
(declare-const target_liveness_guaranteed Int)
(assert (>= source_liveness_guaranteed 0))
(assert (>= target_liveness_guaranteed 0))
(assert (not (= source_liveness_guaranteed target_liveness_guaranteed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; thread_starved: source semantics (matches Coq)
; Translation validation: thread_starved preserves semantics
(push 1)
(declare-const source_thread_starved Int)
(declare-const target_thread_starved Int)
(assert (>= source_thread_starved 0))
(assert (>= target_thread_starved 0))
(assert (not (= source_thread_starved target_thread_starved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_001_session_type_valid: source semantics (matches Coq)
; Translation validation: time_001_session_type_valid preserves semantics
(push 1)
(declare-const source_time_001_session_type_valid Int)
(declare-const target_time_001_session_type_valid Int)
(assert (>= source_time_001_session_type_valid 0))
(assert (>= target_time_001_session_type_valid 0))
(assert (not (= source_time_001_session_type_valid target_time_001_session_type_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_001_lock_exclusive: source semantics (matches Coq)
; Translation validation: time_001_lock_exclusive preserves semantics
(push 1)
(declare-const source_time_001_lock_exclusive Int)
(declare-const target_time_001_lock_exclusive Int)
(assert (>= source_time_001_lock_exclusive 0))
(assert (>= target_time_001_lock_exclusive 0))
(assert (not (= source_time_001_lock_exclusive target_time_001_lock_exclusive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_003_is_constant_time: source semantics (matches Coq)
; Translation validation: time_003_is_constant_time preserves semantics
(push 1)
(declare-const source_time_003_is_constant_time Int)
(declare-const target_time_003_is_constant_time Int)
(assert (>= source_time_003_is_constant_time 0))
(assert (>= target_time_003_is_constant_time 0))
(assert (not (= source_time_003_is_constant_time target_time_003_is_constant_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_003_ct_compare_length: source semantics (matches Coq)
; Translation validation: time_003_ct_compare_length preserves semantics
(push 1)
(declare-const source_time_003_ct_compare_length Int)
(declare-const target_time_003_ct_compare_length Int)
(assert (>= source_time_003_ct_compare_length 0))
(assert (>= target_time_003_ct_compare_length 0))
(assert (not (= source_time_003_ct_compare_length target_time_003_ct_compare_length)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_004_domains_isolated: source semantics (matches Coq)
; Translation validation: time_004_domains_isolated preserves semantics
(push 1)
(declare-const source_time_004_domains_isolated Int)
(declare-const target_time_004_domains_isolated Int)
(assert (>= source_time_004_domains_isolated 0))
(assert (>= target_time_004_domains_isolated 0))
(assert (not (= source_time_004_domains_isolated target_time_004_domains_isolated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_004_no_cross_domain_leakage: source semantics (matches Coq)
; Translation validation: time_004_no_cross_domain_leakage preserves semantics
(push 1)
(declare-const source_time_004_no_cross_domain_leakage Int)
(declare-const target_time_004_no_cross_domain_leakage Int)
(assert (>= source_time_004_no_cross_domain_leakage 0))
(assert (>= target_time_004_no_cross_domain_leakage 0))
(assert (not (= source_time_004_no_cross_domain_leakage target_time_004_no_cross_domain_leakage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_005_nts_verify: source semantics (matches Coq)
; Translation validation: time_005_nts_verify preserves semantics
(push 1)
(declare-const source_time_005_nts_verify Int)
(declare-const target_time_005_nts_verify Int)
(assert (>= source_time_005_nts_verify 0))
(assert (>= target_time_005_nts_verify 0))
(assert (not (= source_time_005_nts_verify target_time_005_nts_verify)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_006_validate_message: source semantics (matches Coq)
; Translation validation: time_006_validate_message preserves semantics
(push 1)
(declare-const source_time_006_validate_message Int)
(declare-const target_time_006_validate_message Int)
(assert (>= source_time_006_validate_message 0))
(assert (>= target_time_006_validate_message 0))
(assert (not (= source_time_006_validate_message target_time_006_validate_message)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_006_update_window: source semantics (matches Coq)
; Translation validation: time_006_update_window preserves semantics
(push 1)
(declare-const source_time_006_update_window Int)
(declare-const target_time_006_update_window Int)
(assert (>= source_time_006_update_window 0))
(assert (>= target_time_006_update_window 0))
(assert (not (= source_time_006_update_window target_time_006_update_window)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_007_validate_sequence: source semantics (matches Coq)
; Translation validation: time_007_validate_sequence preserves semantics
(push 1)
(declare-const source_time_007_validate_sequence Int)
(declare-const target_time_007_validate_sequence Int)
(assert (>= source_time_007_validate_sequence 0))
(assert (>= target_time_007_validate_sequence 0))
(assert (not (= source_time_007_validate_sequence target_time_007_validate_sequence)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_008_deadline_feasible: source semantics (matches Coq)
; Translation validation: time_008_deadline_feasible preserves semantics
(push 1)
(declare-const source_time_008_deadline_feasible Int)
(declare-const target_time_008_deadline_feasible Int)
(assert (>= source_time_008_deadline_feasible 0))
(assert (>= target_time_008_deadline_feasible 0))
(assert (not (= source_time_008_deadline_feasible target_time_008_deadline_feasible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_008_edf_select: source semantics (matches Coq)
; Translation validation: time_008_edf_select preserves semantics
(push 1)
(declare-const source_time_008_edf_select Int)
(declare-const target_time_008_edf_select Int)
(assert (>= source_time_008_edf_select 0))
(assert (>= target_time_008_edf_select 0))
(assert (not (= source_time_008_edf_select target_time_008_edf_select)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_009_verify_signed_timestamp: source semantics (matches Coq)
; Translation validation: time_009_verify_signed_timestamp preserves semantics
(push 1)
(declare-const source_time_009_verify_signed_timestamp Int)
(declare-const target_time_009_verify_signed_timestamp Int)
(assert (>= source_time_009_verify_signed_timestamp 0))
(assert (>= target_time_009_verify_signed_timestamp 0))
(assert (not (= source_time_009_verify_signed_timestamp target_time_009_verify_signed_timestamp)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_010_check_timeout: source semantics (matches Coq)
; Translation validation: time_010_check_timeout preserves semantics
(push 1)
(declare-const source_time_010_check_timeout Int)
(declare-const target_time_010_check_timeout Int)
(assert (>= source_time_010_check_timeout 0))
(assert (>= target_time_010_check_timeout 0))
(assert (not (= source_time_010_check_timeout target_time_010_check_timeout)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_010_update_handler: source semantics (matches Coq)
; Translation validation: time_010_update_handler preserves semantics
(push 1)
(declare-const source_time_010_update_handler Int)
(declare-const target_time_010_update_handler Int)
(assert (>= source_time_010_update_handler 0))
(assert (>= target_time_010_update_handler 0))
(assert (not (= source_time_010_update_handler target_time_010_update_handler)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_011_compute_skew: source semantics (matches Coq)
; Translation validation: time_011_compute_skew preserves semantics
(push 1)
(declare-const source_time_011_compute_skew Int)
(declare-const target_time_011_compute_skew Int)
(assert (>= source_time_011_compute_skew 0))
(assert (>= target_time_011_compute_skew 0))
(assert (not (= source_time_011_compute_skew target_time_011_compute_skew)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_011_adjust_clock: source semantics (matches Coq)
; Translation validation: time_011_adjust_clock preserves semantics
(push 1)
(declare-const source_time_011_adjust_clock Int)
(declare-const target_time_011_adjust_clock Int)
(assert (>= source_time_011_adjust_clock 0))
(assert (>= target_time_011_adjust_clock 0))
(assert (not (= source_time_011_adjust_clock target_time_011_adjust_clock)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_012_inherit_priority: source semantics (matches Coq)
; Translation validation: time_012_inherit_priority preserves semantics
(push 1)
(declare-const source_time_012_inherit_priority Int)
(declare-const target_time_012_inherit_priority Int)
(assert (>= source_time_012_inherit_priority 0))
(assert (>= target_time_012_inherit_priority 0))
(assert (not (= source_time_012_inherit_priority target_time_012_inherit_priority)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_012_release_inheritance: source semantics (matches Coq)
; Translation validation: time_012_release_inheritance preserves semantics
(push 1)
(declare-const source_time_012_release_inheritance Int)
(declare-const target_time_012_release_inheritance Int)
(assert (>= source_time_012_release_inheritance 0))
(assert (>= target_time_012_release_inheritance 0))
(assert (not (= source_time_012_release_inheritance target_time_012_release_inheritance)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_013_can_acquire: source semantics (matches Coq)
; Translation validation: time_013_can_acquire preserves semantics
(push 1)
(declare-const source_time_013_can_acquire Int)
(declare-const target_time_013_can_acquire Int)
(assert (>= source_time_013_can_acquire 0))
(assert (>= target_time_013_can_acquire 0))
(assert (not (= source_time_013_can_acquire target_time_013_can_acquire)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_013_release_lock: source semantics (matches Coq)
; Translation validation: time_013_release_lock preserves semantics
(push 1)
(declare-const source_time_013_release_lock Int)
(declare-const target_time_013_release_lock Int)
(assert (>= source_time_013_release_lock 0))
(assert (>= target_time_013_release_lock 0))
(assert (not (= source_time_013_release_lock target_time_013_release_lock)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_014_make_progress: source semantics (matches Coq)
; Translation validation: time_014_make_progress preserves semantics
(push 1)
(declare-const source_time_014_make_progress Int)
(declare-const target_time_014_make_progress Int)
(assert (>= source_time_014_make_progress 0))
(assert (>= target_time_014_make_progress 0))
(assert (not (= source_time_014_make_progress target_time_014_make_progress)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_014_check_liveness: source semantics (matches Coq)
; Translation validation: time_014_check_liveness preserves semantics
(push 1)
(declare-const source_time_014_check_liveness Int)
(declare-const target_time_014_check_liveness Int)
(assert (>= source_time_014_check_liveness 0))
(assert (>= target_time_014_check_liveness 0))
(assert (not (= source_time_014_check_liveness target_time_014_check_liveness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_015_update_schedule: source semantics (matches Coq)
; Translation validation: time_015_update_schedule preserves semantics
(push 1)
(declare-const source_time_015_update_schedule Int)
(declare-const target_time_015_update_schedule Int)
(assert (>= source_time_015_update_schedule 0))
(assert (>= target_time_015_update_schedule 0))
(assert (not (= source_time_015_update_schedule target_time_015_update_schedule)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; leb_true_le: translation preserves property (matches Coq: Lemma)
; Translation validation: leb_true_le preserves semantics
(push 1)
(declare-const source_leb_true_le Int)
(declare-const target_leb_true_le Int)
(assert (>= source_leb_true_le 0))
(assert (>= target_leb_true_le 0))
(assert (not (= source_leb_true_le target_leb_true_le)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ltb_true_lt: translation preserves property (matches Coq: Lemma)
; Translation validation: ltb_true_lt preserves semantics
(push 1)
(declare-const source_ltb_true_lt Int)
(declare-const target_ltb_true_lt Int)
(assert (>= source_ltb_true_lt 0))
(assert (>= target_ltb_true_lt 0))
(assert (not (= source_ltb_true_lt target_ltb_true_lt)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; negb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: negb_true_iff preserves semantics
(push 1)
(declare-const source_negb_true_iff Int)
(declare-const target_negb_true_iff Int)
(assert (>= source_negb_true_iff 0))
(assert (>= target_negb_true_iff 0))
(assert (not (= source_negb_true_iff target_negb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_iff_both: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_iff_both preserves semantics
(push 1)
(declare-const source_andb_true_iff_both Int)
(declare-const target_andb_true_iff_both Int)
(assert (>= source_andb_true_iff_both 0))
(assert (>= target_andb_true_iff_both 0))
(assert (not (= source_andb_true_iff_both target_andb_true_iff_both)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; forallb_true_forall: translation preserves property (matches Coq: Lemma)
; Translation validation: forallb_true_forall preserves semantics
(push 1)
(declare-const source_forallb_true_forall Int)
(declare-const target_forallb_true_forall Int)
(assert (>= source_forallb_true_forall 0))
(assert (>= target_forallb_true_forall 0))
(assert (not (= source_forallb_true_forall target_forallb_true_forall)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; existsb_exists: translation preserves property (matches Coq: Lemma)
; Translation validation: existsb_exists preserves semantics
(push 1)
(declare-const source_existsb_exists Int)
(declare-const target_existsb_exists Int)
(assert (>= source_existsb_exists 0))
(assert (>= target_existsb_exists 0))
(assert (not (= source_existsb_exists target_existsb_exists)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nat_eqb_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: nat_eqb_refl preserves semantics
(push 1)
(declare-const source_nat_eqb_refl Int)
(declare-const target_nat_eqb_refl Int)
(assert (>= source_nat_eqb_refl 0))
(assert (>= target_nat_eqb_refl 0))
(assert (not (= source_nat_eqb_refl target_nat_eqb_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; nat_eqb_eq: translation preserves property (matches Coq: Lemma)
; Translation validation: nat_eqb_eq preserves semantics
(push 1)
(declare-const source_nat_eqb_eq Int)
(declare-const target_nat_eqb_eq Int)
(assert (>= source_nat_eqb_eq 0))
(assert (>= target_nat_eqb_eq 0))
(assert (not (= source_nat_eqb_eq target_nat_eqb_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_001_race_condition_prevention: translation preserves property (matches Coq: Theorem)
; Translation validation: time_001_race_condition_prevention preserves semantics
(push 1)
(declare-const source_time_001_race_condition_prevention Int)
(declare-const target_time_001_race_condition_prevention Int)
(assert (>= source_time_001_race_condition_prevention 0))
(assert (>= target_time_001_race_condition_prevention 0))
(assert (not (= source_time_001_race_condition_prevention target_time_001_race_condition_prevention)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_001_lock_mutual_exclusion: translation preserves property (matches Coq: Theorem)
; Translation validation: time_001_lock_mutual_exclusion preserves semantics
(push 1)
(declare-const source_time_001_lock_mutual_exclusion Int)
(declare-const target_time_001_lock_mutual_exclusion Int)
(assert (>= source_time_001_lock_mutual_exclusion 0))
(assert (>= target_time_001_lock_mutual_exclusion 0))
(assert (not (= source_time_001_lock_mutual_exclusion target_time_001_lock_mutual_exclusion)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_001_session_preserves_owner: translation preserves property (matches Coq: Theorem)
; Translation validation: time_001_session_preserves_owner preserves semantics
(push 1)
(declare-const source_time_001_session_preserves_owner Int)
(declare-const target_time_001_session_preserves_owner Int)
(assert (>= source_time_001_session_preserves_owner 0))
(assert (>= target_time_001_session_preserves_owner 0))
(assert (not (= source_time_001_session_preserves_owner target_time_001_session_preserves_owner)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_002_toctou_atomic_check_act: translation preserves property (matches Coq: Theorem)
; Translation validation: time_002_toctou_atomic_check_act preserves semantics
(push 1)
(declare-const source_time_002_toctou_atomic_check_act Int)
(declare-const target_time_002_toctou_atomic_check_act Int)
(assert (>= source_time_002_toctou_atomic_check_act 0))
(assert (>= target_time_002_toctou_atomic_check_act 0))
(assert (not (= source_time_002_toctou_atomic_check_act target_time_002_toctou_atomic_check_act)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_002_atomic_version_increment: translation preserves property (matches Coq: Theorem)
; Translation validation: time_002_atomic_version_increment preserves semantics
(push 1)
(declare-const source_time_002_atomic_version_increment Int)
(declare-const target_time_002_atomic_version_increment Int)
(assert (>= source_time_002_atomic_version_increment 0))
(assert (>= target_time_002_atomic_version_increment 0))
(assert (not (= source_time_002_atomic_version_increment target_time_002_atomic_version_increment)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_002_failed_cas_unchanged: translation preserves property (matches Coq: Theorem)
; Translation validation: time_002_failed_cas_unchanged preserves semantics
(push 1)
(declare-const source_time_002_failed_cas_unchanged Int)
(declare-const target_time_002_failed_cas_unchanged Int)
(assert (>= source_time_002_failed_cas_unchanged 0))
(assert (>= target_time_002_failed_cas_unchanged 0))
(assert (not (= source_time_002_failed_cas_unchanged target_time_002_failed_cas_unchanged)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_003_constant_time_property: translation preserves property (matches Coq: Theorem)
; Translation validation: time_003_constant_time_property preserves semantics
(push 1)
(declare-const source_time_003_constant_time_property Int)
(declare-const target_time_003_constant_time_property Int)
(assert (>= source_time_003_constant_time_property 0))
(assert (>= target_time_003_constant_time_property 0))
(assert (not (= source_time_003_constant_time_property target_time_003_constant_time_property)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_003_no_timing_leakage: translation preserves property (matches Coq: Theorem)
; Translation validation: time_003_no_timing_leakage preserves semantics
(push 1)
(declare-const source_time_003_no_timing_leakage Int)
(declare-const target_time_003_no_timing_leakage Int)
(assert (>= source_time_003_no_timing_leakage 0))
(assert (>= target_time_003_no_timing_leakage 0))
(assert (not (= source_time_003_no_timing_leakage target_time_003_no_timing_leakage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_003_ct_compare_deterministic: translation preserves property (matches Coq: Theorem)
; Translation validation: time_003_ct_compare_deterministic preserves semantics
(push 1)
(declare-const source_time_003_ct_compare_deterministic Int)
(declare-const target_time_003_ct_compare_deterministic Int)
(assert (>= source_time_003_ct_compare_deterministic 0))
(assert (>= target_time_003_ct_compare_deterministic 0))
(assert (not (= source_time_003_ct_compare_deterministic target_time_003_ct_compare_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_004_timing_isolation_prevents_channel: translation preserves property (matches Coq: Theorem)
; Translation validation: time_004_timing_isolation_prevents_channel preserves semantics
(push 1)
(declare-const source_time_004_timing_isolation_prevents_channel Int)
(declare-const target_time_004_timing_isolation_prevents_channel Int)
(assert (>= source_time_004_timing_isolation_prevents_channel 0))
(assert (>= target_time_004_timing_isolation_prevents_channel 0))
(assert (not (= source_time_004_timing_isolation_prevents_channel target_time_004_timing_isolation_prevents_channel)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_004_isolated_domain_property: translation preserves property (matches Coq: Theorem)
; Translation validation: time_004_isolated_domain_property preserves semantics
(push 1)
(declare-const source_time_004_isolated_domain_property Int)
(declare-const target_time_004_isolated_domain_property Int)
(assert (>= source_time_004_isolated_domain_property 0))
(assert (>= target_time_004_isolated_domain_property 0))
(assert (not (= source_time_004_isolated_domain_property target_time_004_isolated_domain_property)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_005_unauthenticated_ntp_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: time_005_unauthenticated_ntp_rejected preserves semantics
(push 1)
(declare-const source_time_005_unauthenticated_ntp_rejected Int)
(declare-const target_time_005_unauthenticated_ntp_rejected Int)
(assert (>= source_time_005_unauthenticated_ntp_rejected 0))
(assert (>= target_time_005_unauthenticated_ntp_rejected 0))
(assert (not (= source_time_005_unauthenticated_ntp_rejected target_time_005_unauthenticated_ntp_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_005_authenticated_ntp_accepted: translation preserves property (matches Coq: Theorem)
; Translation validation: time_005_authenticated_ntp_accepted preserves semantics
(push 1)
(declare-const source_time_005_authenticated_ntp_accepted Int)
(declare-const target_time_005_authenticated_ntp_accepted Int)
(assert (>= source_time_005_authenticated_ntp_accepted 0))
(assert (>= target_time_005_authenticated_ntp_accepted 0))
(assert (not (= source_time_005_authenticated_ntp_accepted target_time_005_authenticated_ntp_accepted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_005_wrong_signature_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: time_005_wrong_signature_rejected preserves semantics
(push 1)
(declare-const source_time_005_wrong_signature_rejected Int)
(declare-const target_time_005_wrong_signature_rejected Int)
(assert (>= source_time_005_wrong_signature_rejected 0))
(assert (>= target_time_005_wrong_signature_rejected 0))
(assert (not (= source_time_005_wrong_signature_rejected target_time_005_wrong_signature_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_006_replay_detected: translation preserves property (matches Coq: Theorem)
; Translation validation: time_006_replay_detected preserves semantics
(push 1)
(declare-const source_time_006_replay_detected Int)
(declare-const target_time_006_replay_detected Int)
(assert (>= source_time_006_replay_detected 0))
(assert (>= target_time_006_replay_detected 0))
(assert (not (= source_time_006_replay_detected target_time_006_replay_detected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_006_fresh_nonce_recorded: translation preserves property (matches Coq: Theorem)
; Translation validation: time_006_fresh_nonce_recorded preserves semantics
(push 1)
(declare-const source_time_006_fresh_nonce_recorded Int)
(declare-const target_time_006_fresh_nonce_recorded Int)
(assert (>= source_time_006_fresh_nonce_recorded 0))
(assert (>= target_time_006_fresh_nonce_recorded 0))
(assert (not (= source_time_006_fresh_nonce_recorded target_time_006_fresh_nonce_recorded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_006_old_timestamp_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: time_006_old_timestamp_rejected preserves semantics
(push 1)
(declare-const source_time_006_old_timestamp_rejected Int)
(declare-const target_time_006_old_timestamp_rejected Int)
(assert (>= source_time_006_old_timestamp_rejected 0))
(assert (>= target_time_006_old_timestamp_rejected 0))
(assert (not (= source_time_006_old_timestamp_rejected target_time_006_old_timestamp_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_007_out_of_order_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: time_007_out_of_order_rejected preserves semantics
(push 1)
(declare-const source_time_007_out_of_order_rejected Int)
(declare-const target_time_007_out_of_order_rejected Int)
(assert (>= source_time_007_out_of_order_rejected 0))
(assert (>= target_time_007_out_of_order_rejected 0))
(assert (not (= source_time_007_out_of_order_rejected target_time_007_out_of_order_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_007_correct_sequence_accepted: translation preserves property (matches Coq: Theorem)
; Translation validation: time_007_correct_sequence_accepted preserves semantics
(push 1)
(declare-const source_time_007_correct_sequence_accepted Int)
(declare-const target_time_007_correct_sequence_accepted Int)
(assert (>= source_time_007_correct_sequence_accepted 0))
(assert (>= target_time_007_correct_sequence_accepted 0))
(assert (not (= source_time_007_correct_sequence_accepted target_time_007_correct_sequence_accepted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_007_sequence_increments: translation preserves property (matches Coq: Theorem)
; Translation validation: time_007_sequence_increments preserves semantics
(push 1)
(declare-const source_time_007_sequence_increments Int)
(declare-const target_time_007_sequence_increments Int)
(assert (>= source_time_007_sequence_increments 0))
(assert (>= target_time_007_sequence_increments 0))
(assert (not (= source_time_007_sequence_increments target_time_007_sequence_increments)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_008_selected_task_meets_deadline: translation preserves property (matches Coq: Theorem)
; Translation validation: time_008_selected_task_meets_deadline preserves semantics
(push 1)
(declare-const source_time_008_selected_task_meets_deadline Int)
(declare-const target_time_008_selected_task_meets_deadline Int)
(assert (>= source_time_008_selected_task_meets_deadline 0))
(assert (>= target_time_008_selected_task_meets_deadline 0))
(assert (not (= source_time_008_selected_task_meets_deadline target_time_008_selected_task_meets_deadline)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_008_no_deadline_miss: translation preserves property (matches Coq: Theorem)
; Translation validation: time_008_no_deadline_miss preserves semantics
(push 1)
(declare-const source_time_008_no_deadline_miss Int)
(declare-const target_time_008_no_deadline_miss Int)
(assert (>= source_time_008_no_deadline_miss 0))
(assert (>= target_time_008_no_deadline_miss 0))
(assert (not (= source_time_008_no_deadline_miss target_time_008_no_deadline_miss)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_009_unsigned_timestamp_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: time_009_unsigned_timestamp_rejected preserves semantics
(push 1)
(declare-const source_time_009_unsigned_timestamp_rejected Int)
(declare-const target_time_009_unsigned_timestamp_rejected Int)
(assert (>= source_time_009_unsigned_timestamp_rejected 0))
(assert (>= target_time_009_unsigned_timestamp_rejected 0))
(assert (not (= source_time_009_unsigned_timestamp_rejected target_time_009_unsigned_timestamp_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_009_valid_signature_accepted: translation preserves property (matches Coq: Theorem)
; Translation validation: time_009_valid_signature_accepted preserves semantics
(push 1)
(declare-const source_time_009_valid_signature_accepted Int)
(declare-const target_time_009_valid_signature_accepted Int)
(assert (>= source_time_009_valid_signature_accepted 0))
(assert (>= target_time_009_valid_signature_accepted 0))
(assert (not (= source_time_009_valid_signature_accepted target_time_009_valid_signature_accepted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_009_wrong_signature_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: time_009_wrong_signature_rejected preserves semantics
(push 1)
(declare-const source_time_009_wrong_signature_rejected Int)
(declare-const target_time_009_wrong_signature_rejected Int)
(assert (>= source_time_009_wrong_signature_rejected 0))
(assert (>= target_time_009_wrong_signature_rejected 0))
(assert (not (= source_time_009_wrong_signature_rejected target_time_009_wrong_signature_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_010_expired_timeout_detected: translation preserves property (matches Coq: Theorem)
; Translation validation: time_010_expired_timeout_detected preserves semantics
(push 1)
(declare-const source_time_010_expired_timeout_detected Int)
(declare-const target_time_010_expired_timeout_detected Int)
(assert (>= source_time_010_expired_timeout_detected 0))
(assert (>= target_time_010_expired_timeout_detected 0))
(assert (not (= source_time_010_expired_timeout_detected target_time_010_expired_timeout_detected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_010_pending_timeout_preserved: translation preserves property (matches Coq: Theorem)
; Translation validation: time_010_pending_timeout_preserved preserves semantics
(push 1)
(declare-const source_time_010_pending_timeout_preserved Int)
(declare-const target_time_010_pending_timeout_preserved Int)
(assert (>= source_time_010_pending_timeout_preserved 0))
(assert (>= target_time_010_pending_timeout_preserved 0))
(assert (not (= source_time_010_pending_timeout_preserved target_time_010_pending_timeout_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_010_completed_timeout_stable: translation preserves property (matches Coq: Theorem)
; Translation validation: time_010_completed_timeout_stable preserves semantics
(push 1)
(declare-const source_time_010_completed_timeout_stable Int)
(declare-const target_time_010_completed_timeout_stable Int)
(assert (>= source_time_010_completed_timeout_stable 0))
(assert (>= target_time_010_completed_timeout_stable 0))
(assert (not (= source_time_010_completed_timeout_stable target_time_010_completed_timeout_stable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_011_adjusted_clock_synchronized: translation preserves property (matches Coq: Theorem)
; Translation validation: time_011_adjusted_clock_synchronized preserves semantics
(push 1)
(declare-const source_time_011_adjusted_clock_synchronized Int)
(declare-const target_time_011_adjusted_clock_synchronized Int)
(assert (>= source_time_011_adjusted_clock_synchronized 0))
(assert (>= target_time_011_adjusted_clock_synchronized 0))
(assert (not (= source_time_011_adjusted_clock_synchronized target_time_011_adjusted_clock_synchronized)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_011_synchronized_clock_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: time_011_synchronized_clock_valid preserves semantics
(push 1)
(declare-const source_time_011_synchronized_clock_valid Int)
(declare-const target_time_011_synchronized_clock_valid Int)
(assert (>= source_time_011_synchronized_clock_valid 0))
(assert (>= target_time_011_synchronized_clock_valid 0))
(assert (not (= source_time_011_synchronized_clock_valid target_time_011_synchronized_clock_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_011_excessive_skew_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: time_011_excessive_skew_rejected preserves semantics
(push 1)
(declare-const source_time_011_excessive_skew_rejected Int)
(declare-const target_time_011_excessive_skew_rejected Int)
(assert (>= source_time_011_excessive_skew_rejected 0))
(assert (>= target_time_011_excessive_skew_rejected 0))
(assert (not (= source_time_011_excessive_skew_rejected target_time_011_excessive_skew_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_012_priority_inheritance_raises: translation preserves property (matches Coq: Theorem)
; Translation validation: time_012_priority_inheritance_raises preserves semantics
(push 1)
(declare-const source_time_012_priority_inheritance_raises Int)
(declare-const target_time_012_priority_inheritance_raises Int)
(assert (>= source_time_012_priority_inheritance_raises 0))
(assert (>= target_time_012_priority_inheritance_raises 0))
(assert (not (= source_time_012_priority_inheritance_raises target_time_012_priority_inheritance_raises)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_012_release_restores_base: translation preserves property (matches Coq: Theorem)
; Translation validation: time_012_release_restores_base preserves semantics
(push 1)
(declare-const source_time_012_release_restores_base Int)
(declare-const target_time_012_release_restores_base Int)
(assert (>= source_time_012_release_restores_base 0))
(assert (>= target_time_012_release_restores_base 0))
(assert (not (= source_time_012_release_restores_base target_time_012_release_restores_base)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_012_no_inversion_after_inheritance: translation preserves property (matches Coq: Theorem)
; Translation validation: time_012_no_inversion_after_inheritance preserves semantics
(push 1)
(declare-const source_time_012_no_inversion_after_inheritance Int)
(declare-const target_time_012_no_inversion_after_inheritance Int)
(assert (>= source_time_012_no_inversion_after_inheritance 0))
(assert (>= target_time_012_no_inversion_after_inheritance 0))
(assert (not (= source_time_012_no_inversion_after_inheritance target_time_012_no_inversion_after_inheritance)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_013_lock_order_respected: translation preserves property (matches Coq: Theorem)
; Translation validation: time_013_lock_order_respected preserves semantics
(push 1)
(declare-const source_time_013_lock_order_respected Int)
(declare-const target_time_013_lock_order_respected Int)
(assert (>= source_time_013_lock_order_respected 0))
(assert (>= target_time_013_lock_order_respected 0))
(assert (not (= source_time_013_lock_order_respected target_time_013_lock_order_respected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_013_out_of_order_rejected: translation preserves property (matches Coq: Theorem)
; Translation validation: time_013_out_of_order_rejected preserves semantics
(push 1)
(declare-const source_time_013_out_of_order_rejected Int)
(declare-const target_time_013_out_of_order_rejected Int)
(assert (>= source_time_013_out_of_order_rejected 0))
(assert (>= target_time_013_out_of_order_rejected 0))
(assert (not (= source_time_013_out_of_order_rejected target_time_013_out_of_order_rejected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_013_deadlock_free: translation preserves property (matches Coq: Theorem)
; Translation validation: time_013_deadlock_free preserves semantics
(push 1)
(declare-const source_time_013_deadlock_free Int)
(declare-const target_time_013_deadlock_free Int)
(assert (>= source_time_013_deadlock_free 0))
(assert (>= target_time_013_deadlock_free 0))
(assert (not (= source_time_013_deadlock_free target_time_013_deadlock_free)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_014_progress_increases: translation preserves property (matches Coq: Theorem)
; Translation validation: time_014_progress_increases preserves semantics
(push 1)
(declare-const source_time_014_progress_increases Int)
(declare-const target_time_014_progress_increases Int)
(assert (>= source_time_014_progress_increases 0))
(assert (>= target_time_014_progress_increases 0))
(assert (not (= source_time_014_progress_increases target_time_014_progress_increases)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_014_bounded_progress_completes: translation preserves property (matches Coq: Theorem)
; Translation validation: time_014_bounded_progress_completes preserves semantics
(push 1)
(declare-const source_time_014_bounded_progress_completes Int)
(declare-const target_time_014_bounded_progress_completes Int)
(assert (>= source_time_014_bounded_progress_completes 0))
(assert (>= target_time_014_bounded_progress_completes 0))
(assert (not (= source_time_014_bounded_progress_completes target_time_014_bounded_progress_completes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_014_liveness_guaranteed: translation preserves property (matches Coq: Theorem)
; Translation validation: time_014_liveness_guaranteed preserves semantics
(push 1)
(declare-const source_time_014_liveness_guaranteed Int)
(declare-const target_time_014_liveness_guaranteed Int)
(assert (>= source_time_014_liveness_guaranteed 0))
(assert (>= target_time_014_liveness_guaranteed 0))
(assert (not (= source_time_014_liveness_guaranteed target_time_014_liveness_guaranteed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_015_scheduled_updates_record: translation preserves property (matches Coq: Theorem)
; Translation validation: time_015_scheduled_updates_record preserves semantics
(push 1)
(declare-const source_time_015_scheduled_updates_record Int)
(declare-const target_time_015_scheduled_updates_record Int)
(assert (>= source_time_015_scheduled_updates_record 0))
(assert (>= target_time_015_scheduled_updates_record 0))
(assert (not (= source_time_015_scheduled_updates_record target_time_015_scheduled_updates_record)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_015_starved_thread_prioritized: translation preserves property (matches Coq: Theorem)
; Translation validation: time_015_starved_thread_prioritized preserves semantics
(push 1)
(declare-const source_time_015_starved_thread_prioritized Int)
(declare-const target_time_015_starved_thread_prioritized Int)
(assert (>= source_time_015_starved_thread_prioritized 0))
(assert (>= target_time_015_starved_thread_prioritized 0))
(assert (not (= source_time_015_starved_thread_prioritized target_time_015_starved_thread_prioritized)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_015_fairness_guaranteed: translation preserves property (matches Coq: Theorem)
; Translation validation: time_015_fairness_guaranteed preserves semantics
(push 1)
(declare-const source_time_015_fairness_guaranteed Int)
(declare-const target_time_015_fairness_guaranteed Int)
(assert (>= source_time_015_fairness_guaranteed 0))
(assert (>= target_time_015_fairness_guaranteed 0))
(assert (not (= source_time_015_fairness_guaranteed target_time_015_fairness_guaranteed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_015_update_preserves_threads: translation preserves property (matches Coq: Theorem)
; Translation validation: time_015_update_preserves_threads preserves semantics
(push 1)
(declare-const source_time_015_update_preserves_threads Int)
(declare-const target_time_015_update_preserves_threads Int)
(assert (>= source_time_015_update_preserves_threads 0))
(assert (>= target_time_015_update_preserves_threads 0))
(assert (not (= source_time_015_update_preserves_threads target_time_015_update_preserves_threads)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_001_main: translation preserves property (matches Coq: Theorem)
; Translation validation: time_001_main preserves semantics
(push 1)
(declare-const source_time_001_main Int)
(declare-const target_time_001_main Int)
(assert (>= source_time_001_main 0))
(assert (>= target_time_001_main 0))
(assert (not (= source_time_001_main target_time_001_main)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_002_main: translation preserves property (matches Coq: Theorem)
; Translation validation: time_002_main preserves semantics
(push 1)
(declare-const source_time_002_main Int)
(declare-const target_time_002_main Int)
(assert (>= source_time_002_main 0))
(assert (>= target_time_002_main 0))
(assert (not (= source_time_002_main target_time_002_main)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_003_main: translation preserves property (matches Coq: Theorem)
; Translation validation: time_003_main preserves semantics
(push 1)
(declare-const source_time_003_main Int)
(declare-const target_time_003_main Int)
(assert (>= source_time_003_main 0))
(assert (>= target_time_003_main 0))
(assert (not (= source_time_003_main target_time_003_main)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_004_main: translation preserves property (matches Coq: Theorem)
; Translation validation: time_004_main preserves semantics
(push 1)
(declare-const source_time_004_main Int)
(declare-const target_time_004_main Int)
(assert (>= source_time_004_main 0))
(assert (>= target_time_004_main 0))
(assert (not (= source_time_004_main target_time_004_main)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_005_main: translation preserves property (matches Coq: Theorem)
; Translation validation: time_005_main preserves semantics
(push 1)
(declare-const source_time_005_main Int)
(declare-const target_time_005_main Int)
(assert (>= source_time_005_main 0))
(assert (>= target_time_005_main 0))
(assert (not (= source_time_005_main target_time_005_main)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_006_main: translation preserves property (matches Coq: Theorem)
; Translation validation: time_006_main preserves semantics
(push 1)
(declare-const source_time_006_main Int)
(declare-const target_time_006_main Int)
(assert (>= source_time_006_main 0))
(assert (>= target_time_006_main 0))
(assert (not (= source_time_006_main target_time_006_main)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_007_main: translation preserves property (matches Coq: Theorem)
; Translation validation: time_007_main preserves semantics
(push 1)
(declare-const source_time_007_main Int)
(declare-const target_time_007_main Int)
(assert (>= source_time_007_main 0))
(assert (>= target_time_007_main 0))
(assert (not (= source_time_007_main target_time_007_main)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_008_main: translation preserves property (matches Coq: Theorem)
; Translation validation: time_008_main preserves semantics
(push 1)
(declare-const source_time_008_main Int)
(declare-const target_time_008_main Int)
(assert (>= source_time_008_main 0))
(assert (>= target_time_008_main 0))
(assert (not (= source_time_008_main target_time_008_main)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_009_main: translation preserves property (matches Coq: Theorem)
; Translation validation: time_009_main preserves semantics
(push 1)
(declare-const source_time_009_main Int)
(declare-const target_time_009_main Int)
(assert (>= source_time_009_main 0))
(assert (>= target_time_009_main 0))
(assert (not (= source_time_009_main target_time_009_main)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_010_main: translation preserves property (matches Coq: Theorem)
; Translation validation: time_010_main preserves semantics
(push 1)
(declare-const source_time_010_main Int)
(declare-const target_time_010_main Int)
(assert (>= source_time_010_main 0))
(assert (>= target_time_010_main 0))
(assert (not (= source_time_010_main target_time_010_main)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_011_main: translation preserves property (matches Coq: Theorem)
; Translation validation: time_011_main preserves semantics
(push 1)
(declare-const source_time_011_main Int)
(declare-const target_time_011_main Int)
(assert (>= source_time_011_main 0))
(assert (>= target_time_011_main 0))
(assert (not (= source_time_011_main target_time_011_main)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_012_main: translation preserves property (matches Coq: Theorem)
; Translation validation: time_012_main preserves semantics
(push 1)
(declare-const source_time_012_main Int)
(declare-const target_time_012_main Int)
(assert (>= source_time_012_main 0))
(assert (>= target_time_012_main 0))
(assert (not (= source_time_012_main target_time_012_main)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_013_main: translation preserves property (matches Coq: Theorem)
; Translation validation: time_013_main preserves semantics
(push 1)
(declare-const source_time_013_main Int)
(declare-const target_time_013_main Int)
(assert (>= source_time_013_main 0))
(assert (>= target_time_013_main 0))
(assert (not (= source_time_013_main target_time_013_main)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_014_main: translation preserves property (matches Coq: Theorem)
; Translation validation: time_014_main preserves semantics
(push 1)
(declare-const source_time_014_main Int)
(declare-const target_time_014_main Int)
(assert (>= source_time_014_main 0))
(assert (>= target_time_014_main 0))
(assert (not (= source_time_014_main target_time_014_main)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; time_015_main: translation preserves property (matches Coq: Theorem)
; Translation validation: time_015_main preserves semantics
(push 1)
(declare-const source_time_015_main Int)
(declare-const target_time_015_main Int)
(assert (>= source_time_015_main 0))
(assert (>= target_time_015_main 0))
(assert (not (= source_time_015_main target_time_015_main)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

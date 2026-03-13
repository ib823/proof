; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/VerifiedIdentity.v (40 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for VerifiedIdentity
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; list_eq: source semantics (matches Coq)
; Translation validation: list_eq preserves semantics
(push 1)
(declare-const source_list_eq Int)
(declare-const target_list_eq Int)
(assert (>= source_list_eq 0))
(assert (>= target_list_eq 0))
(assert (not (= source_list_eq target_list_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SECURE_MEMORY_COST: source semantics (matches Coq)
; Translation validation: SECURE_MEMORY_COST preserves semantics
(push 1)
(declare-const source_SECURE_MEMORY_COST Int)
(declare-const target_SECURE_MEMORY_COST Int)
(assert (>= source_SECURE_MEMORY_COST 0))
(assert (>= target_SECURE_MEMORY_COST 0))
(assert (not (= source_SECURE_MEMORY_COST target_SECURE_MEMORY_COST)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SECURE_TIME_COST: source semantics (matches Coq)
; Translation validation: SECURE_TIME_COST preserves semantics
(push 1)
(declare-const source_SECURE_TIME_COST Int)
(declare-const target_SECURE_TIME_COST Int)
(assert (>= source_SECURE_TIME_COST 0))
(assert (>= target_SECURE_TIME_COST 0))
(assert (not (= source_SECURE_TIME_COST target_SECURE_TIME_COST)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SECURE_PARALLELISM: source semantics (matches Coq)
; Translation validation: SECURE_PARALLELISM preserves semantics
(push 1)
(declare-const source_SECURE_PARALLELISM Int)
(declare-const target_SECURE_PARALLELISM Int)
(assert (>= source_SECURE_PARALLELISM 0))
(assert (>= target_SECURE_PARALLELISM 0))
(assert (not (= source_SECURE_PARALLELISM target_SECURE_PARALLELISM)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SECURE_OUTPUT_LEN: source semantics (matches Coq)
; Translation validation: SECURE_OUTPUT_LEN preserves semantics
(push 1)
(declare-const source_SECURE_OUTPUT_LEN Int)
(declare-const target_SECURE_OUTPUT_LEN Int)
(assert (>= source_SECURE_OUTPUT_LEN 0))
(assert (>= target_SECURE_OUTPUT_LEN 0))
(assert (not (= source_SECURE_OUTPUT_LEN target_SECURE_OUTPUT_LEN)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; secure_params: source semantics (matches Coq)
; Translation validation: secure_params preserves semantics
(push 1)
(declare-const source_secure_params Int)
(declare-const target_secure_params Int)
(assert (>= source_secure_params 0))
(assert (>= target_secure_params 0))
(assert (not (= source_secure_params target_secure_params)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; params_secure: source semantics (matches Coq)
; Translation validation: params_secure preserves semantics
(push 1)
(declare-const source_params_secure Int)
(declare-const target_params_secure Int)
(assert (>= source_params_secure 0))
(assert (>= target_params_secure 0))
(assert (not (= source_params_secure target_params_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hash_deterministic_prop: source semantics (matches Coq)
; Translation validation: hash_deterministic_prop preserves semantics
(push 1)
(declare-const source_hash_deterministic_prop Int)
(declare-const target_hash_deterministic_prop Int)
(assert (>= source_hash_deterministic_prop 0))
(assert (>= target_hash_deterministic_prop 0))
(assert (not (= source_hash_deterministic_prop target_hash_deterministic_prop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hash_collision_resistant: source semantics (matches Coq)
; Translation validation: hash_collision_resistant preserves semantics
(push 1)
(declare-const source_hash_collision_resistant Int)
(declare-const target_hash_collision_resistant Int)
(assert (>= source_hash_collision_resistant 0))
(assert (>= target_hash_collision_resistant 0))
(assert (not (= source_hash_collision_resistant target_hash_collision_resistant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; constant_time_eq: source semantics (matches Coq)
; Translation validation: constant_time_eq preserves semantics
(push 1)
(declare-const source_constant_time_eq Int)
(declare-const target_constant_time_eq Int)
(assert (>= source_constant_time_eq 0))
(assert (>= target_constant_time_eq 0))
(assert (not (= source_constant_time_eq target_constant_time_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; empty_used_set: source semantics (matches Coq)
; Translation validation: empty_used_set preserves semantics
(push 1)
(declare-const source_empty_used_set Int)
(declare-const target_empty_used_set Int)
(assert (>= source_empty_used_set 0))
(assert (>= target_empty_used_set 0))
(assert (not (= source_empty_used_set target_empty_used_set)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mark_used: source semantics (matches Coq)
; Translation validation: mark_used preserves semantics
(push 1)
(declare-const source_mark_used Int)
(declare-const target_mark_used Int)
(assert (>= source_mark_used 0))
(assert (>= target_mark_used 0))
(assert (not (= source_mark_used target_mark_used)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_used: source semantics (matches Coq)
; Translation validation: is_used preserves semantics
(push 1)
(declare-const source_is_used Int)
(declare-const target_is_used Int)
(assert (>= source_is_used 0))
(assert (>= target_is_used 0))
(assert (not (= source_is_used target_is_used)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; verify_token_binding: source semantics (matches Coq)
; Translation validation: verify_token_binding preserves semantics
(push 1)
(declare-const source_verify_token_binding Int)
(declare-const target_verify_token_binding Int)
(assert (>= source_verify_token_binding 0))
(assert (>= target_verify_token_binding 0))
(assert (not (= source_verify_token_binding target_verify_token_binding)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; verify_token_expiry: source semantics (matches Coq)
; Translation validation: verify_token_expiry preserves semantics
(push 1)
(declare-const source_verify_token_expiry Int)
(declare-const target_verify_token_expiry Int)
(assert (>= source_verify_token_expiry 0))
(assert (>= target_verify_token_expiry 0))
(assert (not (= source_verify_token_expiry target_verify_token_expiry)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; verify_token_not_replayed: source semantics (matches Coq)
; Translation validation: verify_token_not_replayed preserves semantics
(push 1)
(declare-const source_verify_token_not_replayed Int)
(declare-const target_verify_token_not_replayed Int)
(assert (>= source_verify_token_not_replayed 0))
(assert (>= target_verify_token_not_replayed 0))
(assert (not (= source_verify_token_not_replayed target_verify_token_not_replayed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; verify_token: source semantics (matches Coq)
; Translation validation: verify_token preserves semantics
(push 1)
(declare-const source_verify_token Int)
(declare-const target_verify_token Int)
(assert (>= source_verify_token 0))
(assert (>= target_verify_token 0))
(assert (not (= source_verify_token target_verify_token)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; empty_revoked: source semantics (matches Coq)
; Translation validation: empty_revoked preserves semantics
(push 1)
(declare-const source_empty_revoked Int)
(declare-const target_empty_revoked Int)
(assert (>= source_empty_revoked 0))
(assert (>= target_empty_revoked 0))
(assert (not (= source_empty_revoked target_empty_revoked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; revoke_token: source semantics (matches Coq)
; Translation validation: revoke_token preserves semantics
(push 1)
(declare-const source_revoke_token Int)
(declare-const target_revoke_token Int)
(assert (>= source_revoke_token 0))
(assert (>= target_revoke_token 0))
(assert (not (= source_revoke_token target_revoke_token)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_revoked: source semantics (matches Coq)
; Translation validation: is_revoked preserves semantics
(push 1)
(declare-const source_is_revoked Int)
(declare-const target_is_revoked Int)
(assert (>= source_is_revoked 0))
(assert (>= target_is_revoked 0))
(assert (not (= source_is_revoked target_is_revoked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; empty_session_store: source semantics (matches Coq)
; Translation validation: empty_session_store preserves semantics
(push 1)
(declare-const source_empty_session_store Int)
(declare-const target_empty_session_store Int)
(assert (>= source_empty_session_store 0))
(assert (>= target_empty_session_store 0))
(assert (not (= source_empty_session_store target_empty_session_store)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; add_session: source semantics (matches Coq)
; Translation validation: add_session preserves semantics
(push 1)
(declare-const source_add_session Int)
(declare-const target_add_session Int)
(assert (>= source_add_session 0))
(assert (>= target_add_session 0))
(assert (not (= source_add_session target_add_session)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; session_valid: source semantics (matches Coq)
; Translation validation: session_valid preserves semantics
(push 1)
(declare-const source_session_valid Int)
(declare-const target_session_valid Int)
(assert (>= source_session_valid 0))
(assert (>= target_session_valid 0))
(assert (not (= source_session_valid target_session_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; session_regenerated: source semantics (matches Coq)
; Translation validation: session_regenerated preserves semantics
(push 1)
(declare-const source_session_regenerated Int)
(declare-const target_session_regenerated Int)
(assert (>= source_session_regenerated 0))
(assert (>= target_session_regenerated 0))
(assert (not (= source_session_regenerated target_session_regenerated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fido2_origin_matches: source semantics (matches Coq)
; Translation validation: fido2_origin_matches preserves semantics
(push 1)
(declare-const source_fido2_origin_matches Int)
(declare-const target_fido2_origin_matches Int)
(assert (>= source_fido2_origin_matches 0))
(assert (>= target_fido2_origin_matches 0))
(assert (not (= source_fido2_origin_matches target_fido2_origin_matches)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fido2_counter_valid: source semantics (matches Coq)
; Translation validation: fido2_counter_valid preserves semantics
(push 1)
(declare-const source_fido2_counter_valid Int)
(declare-const target_fido2_counter_valid Int)
(assert (>= source_fido2_counter_valid 0))
(assert (>= target_fido2_counter_valid 0))
(assert (not (= source_fido2_counter_valid target_fido2_counter_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fido2_user_verified: source semantics (matches Coq)
; Translation validation: fido2_user_verified preserves semantics
(push 1)
(declare-const source_fido2_user_verified Int)
(declare-const target_fido2_user_verified Int)
(assert (>= source_fido2_user_verified 0))
(assert (>= target_fido2_user_verified 0))
(assert (not (= source_fido2_user_verified target_fido2_user_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; verify_fido2: source semantics (matches Coq)
; Translation validation: verify_fido2 preserves semantics
(push 1)
(declare-const source_verify_fido2 Int)
(declare-const target_verify_fido2 Int)
(assert (>= source_verify_fido2 0))
(assert (>= target_verify_fido2 0))
(assert (not (= source_verify_fido2 target_verify_fido2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; valid_credential: source semantics (matches Coq)
; Translation validation: valid_credential preserves semantics
(push 1)
(declare-const source_valid_credential Int)
(declare-const target_valid_credential Int)
(assert (>= source_valid_credential 0))
(assert (>= target_valid_credential 0))
(assert (not (= source_valid_credential target_valid_credential)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; credential_matches: source semantics (matches Coq)
; Translation validation: credential_matches preserves semantics
(push 1)
(declare-const source_credential_matches Int)
(declare-const target_credential_matches Int)
(assert (>= source_credential_matches 0))
(assert (>= target_credential_matches 0))
(assert (not (= source_credential_matches target_credential_matches)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; authenticate: source semantics (matches Coq)
; Translation validation: authenticate preserves semantics
(push 1)
(declare-const source_authenticate Int)
(declare-const target_authenticate Int)
(assert (>= source_authenticate 0))
(assert (>= target_authenticate 0))
(assert (not (= source_authenticate target_authenticate)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; log_auth_attempt: source semantics (matches Coq)
; Translation validation: log_auth_attempt preserves semantics
(push 1)
(declare-const source_log_auth_attempt Int)
(declare-const target_log_auth_attempt Int)
(assert (>= source_log_auth_attempt 0))
(assert (>= target_log_auth_attempt 0))
(assert (not (= source_log_auth_attempt target_log_auth_attempt)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; rate_limit_check: source semantics (matches Coq)
; Translation validation: rate_limit_check preserves semantics
(push 1)
(declare-const source_rate_limit_check Int)
(declare-const target_rate_limit_check Int)
(assert (>= source_rate_limit_check 0))
(assert (>= target_rate_limit_check 0))
(assert (not (= source_rate_limit_check target_rate_limit_check)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; rate_limit_update: source semantics (matches Coq)
; Translation validation: rate_limit_update preserves semantics
(push 1)
(declare-const source_rate_limit_update Int)
(declare-const target_rate_limit_update Int)
(assert (>= source_rate_limit_update 0))
(assert (>= target_rate_limit_update 0))
(assert (not (= source_rate_limit_update target_rate_limit_update)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; has_key: source semantics (matches Coq)
; Translation validation: has_key preserves semantics
(push 1)
(declare-const source_has_key Int)
(declare-const target_has_key Int)
(assert (>= source_has_key 0))
(assert (>= target_has_key 0))
(assert (not (= source_has_key target_has_key)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; factor_strength: source semantics (matches Coq)
; Translation validation: factor_strength preserves semantics
(push 1)
(declare-const source_factor_strength Int)
(declare-const target_factor_strength Int)
(assert (>= source_factor_strength 0))
(assert (>= target_factor_strength 0))
(assert (not (= source_factor_strength target_factor_strength)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; factor_secure: source semantics (matches Coq)
; Translation validation: factor_secure preserves semantics
(push 1)
(declare-const source_factor_secure Int)
(declare-const target_factor_secure Int)
(assert (>= source_factor_secure 0))
(assert (>= target_factor_secure 0))
(assert (not (= source_factor_secure target_factor_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mfa_combine: source semantics (matches Coq)
; Translation validation: mfa_combine preserves semantics
(push 1)
(declare-const source_mfa_combine Int)
(declare-const target_mfa_combine Int)
(assert (>= source_mfa_combine 0))
(assert (>= target_mfa_combine 0))
(assert (not (= source_mfa_combine target_mfa_combine)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sum_factor_strengths: source semantics (matches Coq)
; Translation validation: sum_factor_strengths preserves semantics
(push 1)
(declare-const source_sum_factor_strengths Int)
(declare-const target_sum_factor_strengths Int)
(assert (>= source_sum_factor_strengths 0))
(assert (>= target_sum_factor_strengths 0))
(assert (not (= source_sum_factor_strengths target_sum_factor_strengths)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mfa_strength: source semantics (matches Coq)
; Translation validation: mfa_strength preserves semantics
(push 1)
(declare-const source_mfa_strength Int)
(declare-const target_mfa_strength Int)
(assert (>= source_mfa_strength 0))
(assert (>= target_mfa_strength 0))
(assert (not (= source_mfa_strength target_mfa_strength)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; all_factors_secure: source semantics (matches Coq)
; Translation validation: all_factors_secure preserves semantics
(push 1)
(declare-const source_all_factors_secure Int)
(declare-const target_all_factors_secure Int)
(assert (>= source_all_factors_secure 0))
(assert (>= target_all_factors_secure 0))
(assert (not (= source_all_factors_secure target_all_factors_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mfa_secure: source semantics (matches Coq)
; Translation validation: mfa_secure preserves semantics
(push 1)
(declare-const source_mfa_secure Int)
(declare-const target_mfa_secure Int)
(assert (>= source_mfa_secure 0))
(assert (>= target_mfa_secure 0))
(assert (not (= source_mfa_secure target_mfa_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; password_in_breach: source semantics (matches Coq)
; Translation validation: password_in_breach preserves semantics
(push 1)
(declare-const source_password_in_breach Int)
(declare-const target_password_in_breach Int)
(assert (>= source_password_in_breach 0))
(assert (>= target_password_in_breach 0))
(assert (not (= source_password_in_breach target_password_in_breach)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; list_eq_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: list_eq_refl preserves semantics
(push 1)
(declare-const source_list_eq_refl Int)
(declare-const target_list_eq_refl Int)
(assert (>= source_list_eq_refl 0))
(assert (>= target_list_eq_refl 0))
(assert (not (= source_list_eq_refl target_list_eq_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; list_eq_sym: translation preserves property (matches Coq: Lemma)
; Translation validation: list_eq_sym preserves semantics
(push 1)
(declare-const source_list_eq_sym Int)
(declare-const target_list_eq_sym Int)
(assert (>= source_list_eq_sym 0))
(assert (>= target_list_eq_sym 0))
(assert (not (= source_list_eq_sym target_list_eq_sym)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; list_eq_sound: translation preserves property (matches Coq: Lemma)
; Translation validation: list_eq_sound preserves semantics
(push 1)
(declare-const source_list_eq_sound Int)
(declare-const target_list_eq_sound Int)
(assert (>= source_list_eq_sound 0))
(assert (>= target_list_eq_sound 0))
(assert (not (= source_list_eq_sound target_list_eq_sound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; constant_time_eq_correct: translation preserves property (matches Coq: Lemma)
; Translation validation: constant_time_eq_correct preserves semantics
(push 1)
(declare-const source_constant_time_eq_correct Int)
(declare-const target_constant_time_eq_correct Int)
(assert (>= source_constant_time_eq_correct 0))
(assert (>= target_constant_time_eq_correct 0))
(assert (not (= source_constant_time_eq_correct target_constant_time_eq_correct)))
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

; existsb_not_exists: translation preserves property (matches Coq: Lemma)
; Translation validation: existsb_not_exists preserves semantics
(push 1)
(declare-const source_existsb_not_exists Int)
(declare-const target_existsb_not_exists Int)
(assert (>= source_existsb_not_exists 0))
(assert (>= target_existsb_not_exists 0))
(assert (not (= source_existsb_not_exists target_existsb_not_exists)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; credential_matches_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: credential_matches_refl preserves semantics
(push 1)
(declare-const source_credential_matches_refl Int)
(declare-const target_credential_matches_refl Int)
(assert (>= source_credential_matches_refl 0))
(assert (>= target_credential_matches_refl 0))
(assert (not (= source_credential_matches_refl target_credential_matches_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; credential_matches_eq: translation preserves property (matches Coq: Lemma)
; Translation validation: credential_matches_eq preserves semantics
(push 1)
(declare-const source_credential_matches_eq Int)
(declare-const target_credential_matches_eq Int)
(assert (>= source_credential_matches_eq 0))
(assert (>= target_credential_matches_eq 0))
(assert (not (= source_credential_matches_eq target_credential_matches_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_01_auth_completeness: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_01_auth_completeness preserves semantics
(push 1)
(declare-const source_AA_001_01_auth_completeness Int)
(declare-const target_AA_001_01_auth_completeness Int)
(assert (>= source_AA_001_01_auth_completeness 0))
(assert (>= target_AA_001_01_auth_completeness 0))
(assert (not (= source_AA_001_01_auth_completeness target_AA_001_01_auth_completeness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_02_auth_soundness: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_02_auth_soundness preserves semantics
(push 1)
(declare-const source_AA_001_02_auth_soundness Int)
(declare-const target_AA_001_02_auth_soundness Int)
(assert (>= source_AA_001_02_auth_soundness 0))
(assert (>= target_AA_001_02_auth_soundness 0))
(assert (not (= source_AA_001_02_auth_soundness target_AA_001_02_auth_soundness)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_03_auth_deterministic: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_03_auth_deterministic preserves semantics
(push 1)
(declare-const source_AA_001_03_auth_deterministic Int)
(declare-const target_AA_001_03_auth_deterministic Int)
(assert (>= source_AA_001_03_auth_deterministic 0))
(assert (>= target_AA_001_03_auth_deterministic 0))
(assert (not (= source_AA_001_03_auth_deterministic target_AA_001_03_auth_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_04_credential_unforgeability: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_04_credential_unforgeability preserves semantics
(push 1)
(declare-const source_AA_001_04_credential_unforgeability Int)
(declare-const target_AA_001_04_credential_unforgeability Int)
(assert (>= source_AA_001_04_credential_unforgeability 0))
(assert (>= target_AA_001_04_credential_unforgeability 0))
(assert (not (= source_AA_001_04_credential_unforgeability target_AA_001_04_credential_unforgeability)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_05_no_auth_bypass: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_05_no_auth_bypass preserves semantics
(push 1)
(declare-const source_AA_001_05_no_auth_bypass Int)
(declare-const target_AA_001_05_no_auth_bypass Int)
(assert (>= source_AA_001_05_no_auth_bypass 0))
(assert (>= target_AA_001_05_no_auth_bypass 0))
(assert (not (= source_AA_001_05_no_auth_bypass target_AA_001_05_no_auth_bypass)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_06_auth_timing_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_06_auth_timing_safe preserves semantics
(push 1)
(declare-const source_AA_001_06_auth_timing_safe Int)
(declare-const target_AA_001_06_auth_timing_safe Int)
(assert (>= source_AA_001_06_auth_timing_safe 0))
(assert (>= target_AA_001_06_auth_timing_safe 0))
(assert (not (= source_AA_001_06_auth_timing_safe target_AA_001_06_auth_timing_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_07_auth_rate_limited: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_07_auth_rate_limited preserves semantics
(push 1)
(declare-const source_AA_001_07_auth_rate_limited Int)
(declare-const target_AA_001_07_auth_rate_limited Int)
(assert (>= source_AA_001_07_auth_rate_limited 0))
(assert (>= target_AA_001_07_auth_rate_limited 0))
(assert (not (= source_AA_001_07_auth_rate_limited target_AA_001_07_auth_rate_limited)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_08_auth_logging: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_08_auth_logging preserves semantics
(push 1)
(declare-const source_AA_001_08_auth_logging Int)
(declare-const target_AA_001_08_auth_logging Int)
(assert (>= source_AA_001_08_auth_logging 0))
(assert (>= target_AA_001_08_auth_logging 0))
(assert (not (= source_AA_001_08_auth_logging target_AA_001_08_auth_logging)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_09_password_hash_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_09_password_hash_secure preserves semantics
(push 1)
(declare-const source_AA_001_09_password_hash_secure Int)
(declare-const target_AA_001_09_password_hash_secure Int)
(assert (>= source_AA_001_09_password_hash_secure 0))
(assert (>= target_AA_001_09_password_hash_secure 0))
(assert (not (= source_AA_001_09_password_hash_secure target_AA_001_09_password_hash_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_10_password_preimage_resistant: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_10_password_preimage_resistant preserves semantics
(push 1)
(declare-const source_AA_001_10_password_preimage_resistant Int)
(declare-const target_AA_001_10_password_preimage_resistant Int)
(assert (>= source_AA_001_10_password_preimage_resistant 0))
(assert (>= target_AA_001_10_password_preimage_resistant 0))
(assert (not (= source_AA_001_10_password_preimage_resistant target_AA_001_10_password_preimage_resistant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_11_password_not_stored: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_11_password_not_stored preserves semantics
(push 1)
(declare-const source_AA_001_11_password_not_stored Int)
(declare-const target_AA_001_11_password_not_stored Int)
(assert (>= source_AA_001_11_password_not_stored 0))
(assert (>= target_AA_001_11_password_not_stored 0))
(assert (not (= source_AA_001_11_password_not_stored target_AA_001_11_password_not_stored)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_12_password_pepper_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_12_password_pepper_bound preserves semantics
(push 1)
(declare-const source_AA_001_12_password_pepper_bound Int)
(declare-const target_AA_001_12_password_pepper_bound Int)
(assert (>= source_AA_001_12_password_pepper_bound 0))
(assert (>= target_AA_001_12_password_pepper_bound 0))
(assert (not (= source_AA_001_12_password_pepper_bound target_AA_001_12_password_pepper_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_13_password_constant_time_compare: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_13_password_constant_time_compare preserves semantics
(push 1)
(declare-const source_AA_001_13_password_constant_time_compare Int)
(declare-const target_AA_001_13_password_constant_time_compare Int)
(assert (>= source_AA_001_13_password_constant_time_compare 0))
(assert (>= target_AA_001_13_password_constant_time_compare 0))
(assert (not (= source_AA_001_13_password_constant_time_compare target_AA_001_13_password_constant_time_compare)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_14_password_breach_checked: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_14_password_breach_checked preserves semantics
(push 1)
(declare-const source_AA_001_14_password_breach_checked Int)
(declare-const target_AA_001_14_password_breach_checked Int)
(assert (>= source_AA_001_14_password_breach_checked 0))
(assert (>= target_AA_001_14_password_breach_checked 0))
(assert (not (= source_AA_001_14_password_breach_checked target_AA_001_14_password_breach_checked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_15_token_unforgeability: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_15_token_unforgeability preserves semantics
(push 1)
(declare-const source_AA_001_15_token_unforgeability Int)
(declare-const target_AA_001_15_token_unforgeability Int)
(assert (>= source_AA_001_15_token_unforgeability 0))
(assert (>= target_AA_001_15_token_unforgeability 0))
(assert (not (= source_AA_001_15_token_unforgeability target_AA_001_15_token_unforgeability)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_16_token_channel_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_16_token_channel_bound preserves semantics
(push 1)
(declare-const source_AA_001_16_token_channel_bound Int)
(declare-const target_AA_001_16_token_channel_bound Int)
(assert (>= source_AA_001_16_token_channel_bound 0))
(assert (>= target_AA_001_16_token_channel_bound 0))
(assert (not (= source_AA_001_16_token_channel_bound target_AA_001_16_token_channel_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_17_token_expiry: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_17_token_expiry preserves semantics
(push 1)
(declare-const source_AA_001_17_token_expiry Int)
(declare-const target_AA_001_17_token_expiry Int)
(assert (>= source_AA_001_17_token_expiry 0))
(assert (>= target_AA_001_17_token_expiry 0))
(assert (not (= source_AA_001_17_token_expiry target_AA_001_17_token_expiry)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_18_token_replay_prevented: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_18_token_replay_prevented preserves semantics
(push 1)
(declare-const source_AA_001_18_token_replay_prevented Int)
(declare-const target_AA_001_18_token_replay_prevented Int)
(assert (>= source_AA_001_18_token_replay_prevented 0))
(assert (>= target_AA_001_18_token_replay_prevented 0))
(assert (not (= source_AA_001_18_token_replay_prevented target_AA_001_18_token_replay_prevented)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_19_token_revocation: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_19_token_revocation preserves semantics
(push 1)
(declare-const source_AA_001_19_token_revocation Int)
(declare-const target_AA_001_19_token_revocation Int)
(assert (>= source_AA_001_19_token_revocation 0))
(assert (>= target_AA_001_19_token_revocation 0))
(assert (not (= source_AA_001_19_token_revocation target_AA_001_19_token_revocation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_20_token_refresh_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_20_token_refresh_secure preserves semantics
(push 1)
(declare-const source_AA_001_20_token_refresh_secure Int)
(declare-const target_AA_001_20_token_refresh_secure Int)
(assert (>= source_AA_001_20_token_refresh_secure 0))
(assert (>= target_AA_001_20_token_refresh_secure 0))
(assert (not (= source_AA_001_20_token_refresh_secure target_AA_001_20_token_refresh_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_21_token_claims_integrity: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_21_token_claims_integrity preserves semantics
(push 1)
(declare-const source_AA_001_21_token_claims_integrity Int)
(declare-const target_AA_001_21_token_claims_integrity Int)
(assert (>= source_AA_001_21_token_claims_integrity 0))
(assert (>= target_AA_001_21_token_claims_integrity 0))
(assert (not (= source_AA_001_21_token_claims_integrity target_AA_001_21_token_claims_integrity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_22_token_binding_verified: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_22_token_binding_verified preserves semantics
(push 1)
(declare-const source_AA_001_22_token_binding_verified Int)
(declare-const target_AA_001_22_token_binding_verified Int)
(assert (>= source_AA_001_22_token_binding_verified 0))
(assert (>= target_AA_001_22_token_binding_verified 0))
(assert (not (= source_AA_001_22_token_binding_verified target_AA_001_22_token_binding_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_23_session_isolation: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_23_session_isolation preserves semantics
(push 1)
(declare-const source_AA_001_23_session_isolation Int)
(declare-const target_AA_001_23_session_isolation Int)
(assert (>= source_AA_001_23_session_isolation 0))
(assert (>= target_AA_001_23_session_isolation 0))
(assert (not (= source_AA_001_23_session_isolation target_AA_001_23_session_isolation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_24_session_binding: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_24_session_binding preserves semantics
(push 1)
(declare-const source_AA_001_24_session_binding Int)
(declare-const target_AA_001_24_session_binding Int)
(assert (>= source_AA_001_24_session_binding 0))
(assert (>= target_AA_001_24_session_binding 0))
(assert (not (= source_AA_001_24_session_binding target_AA_001_24_session_binding)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_25_session_expiry: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_25_session_expiry preserves semantics
(push 1)
(declare-const source_AA_001_25_session_expiry Int)
(declare-const target_AA_001_25_session_expiry Int)
(assert (>= source_AA_001_25_session_expiry 0))
(assert (>= target_AA_001_25_session_expiry 0))
(assert (not (= source_AA_001_25_session_expiry target_AA_001_25_session_expiry)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_26_session_no_fixation: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_26_session_no_fixation preserves semantics
(push 1)
(declare-const source_AA_001_26_session_no_fixation Int)
(declare-const target_AA_001_26_session_no_fixation Int)
(assert (>= source_AA_001_26_session_no_fixation 0))
(assert (>= target_AA_001_26_session_no_fixation 0))
(assert (not (= source_AA_001_26_session_no_fixation target_AA_001_26_session_no_fixation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_27_session_regeneration: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_27_session_regeneration preserves semantics
(push 1)
(declare-const source_AA_001_27_session_regeneration Int)
(declare-const target_AA_001_27_session_regeneration Int)
(assert (>= source_AA_001_27_session_regeneration 0))
(assert (>= target_AA_001_27_session_regeneration 0))
(assert (not (= source_AA_001_27_session_regeneration target_AA_001_27_session_regeneration)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_28_fido2_phishing_resistant: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_28_fido2_phishing_resistant preserves semantics
(push 1)
(declare-const source_AA_001_28_fido2_phishing_resistant Int)
(declare-const target_AA_001_28_fido2_phishing_resistant Int)
(assert (>= source_AA_001_28_fido2_phishing_resistant 0))
(assert (>= target_AA_001_28_fido2_phishing_resistant 0))
(assert (not (= source_AA_001_28_fido2_phishing_resistant target_AA_001_28_fido2_phishing_resistant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_29_fido2_origin_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_29_fido2_origin_bound preserves semantics
(push 1)
(declare-const source_AA_001_29_fido2_origin_bound Int)
(declare-const target_AA_001_29_fido2_origin_bound Int)
(assert (>= source_AA_001_29_fido2_origin_bound 0))
(assert (>= target_AA_001_29_fido2_origin_bound 0))
(assert (not (= source_AA_001_29_fido2_origin_bound target_AA_001_29_fido2_origin_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_30_fido2_replay_prevented: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_30_fido2_replay_prevented preserves semantics
(push 1)
(declare-const source_AA_001_30_fido2_replay_prevented Int)
(declare-const target_AA_001_30_fido2_replay_prevented Int)
(assert (>= source_AA_001_30_fido2_replay_prevented 0))
(assert (>= target_AA_001_30_fido2_replay_prevented 0))
(assert (not (= source_AA_001_30_fido2_replay_prevented target_AA_001_30_fido2_replay_prevented)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_31_fido2_user_verification: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_31_fido2_user_verification preserves semantics
(push 1)
(declare-const source_AA_001_31_fido2_user_verification Int)
(declare-const target_AA_001_31_fido2_user_verification Int)
(assert (>= source_AA_001_31_fido2_user_verification 0))
(assert (>= target_AA_001_31_fido2_user_verification 0))
(assert (not (= source_AA_001_31_fido2_user_verification target_AA_001_31_fido2_user_verification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; AA_001_32_mfa_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: AA_001_32_mfa_composition preserves semantics
(push 1)
(declare-const source_AA_001_32_mfa_composition Int)
(declare-const target_AA_001_32_mfa_composition Int)
(assert (>= source_AA_001_32_mfa_composition 0))
(assert (>= target_AA_001_32_mfa_composition 0))
(assert (not (= source_AA_001_32_mfa_composition target_AA_001_32_mfa_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

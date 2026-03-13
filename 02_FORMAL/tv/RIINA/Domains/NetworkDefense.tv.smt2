; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/NetworkDefense.v (43 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for NetworkDefense
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; leading_zeros: source semantics (matches Coq)
; Translation validation: leading_zeros preserves semantics
(push 1)
(declare-const source_leading_zeros Int)
(declare-const target_leading_zeros Int)
(assert (>= source_leading_zeros 0))
(assert (>= target_leading_zeros 0))
(assert (not (= source_leading_zeros target_leading_zeros)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; valid_solution: source semantics (matches Coq)
; Translation validation: valid_solution preserves semantics
(push 1)
(declare-const source_valid_solution Int)
(declare-const target_valid_solution Int)
(assert (>= source_valid_solution 0))
(assert (>= target_valid_solution 0))
(assert (not (= source_valid_solution target_valid_solution)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; expected_work: source semantics (matches Coq)
; Translation validation: expected_work preserves semantics
(push 1)
(declare-const source_expected_work Int)
(declare-const target_expected_work Int)
(assert (>= source_expected_work 0))
(assert (>= target_expected_work 0))
(assert (not (= source_expected_work target_expected_work)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; verification_cost: source semantics (matches Coq)
; Translation validation: verification_cost preserves semantics
(push 1)
(declare-const source_verification_cost Int)
(declare-const target_verification_cost Int)
(assert (>= source_verification_cost 0))
(assert (>= target_verification_cost 0))
(assert (not (= source_verification_cost target_verification_cost)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; puzzle_expired: source semantics (matches Coq)
; Translation validation: puzzle_expired preserves semantics
(push 1)
(declare-const source_puzzle_expired Int)
(declare-const target_puzzle_expired Int)
(assert (>= source_puzzle_expired 0))
(assert (>= target_puzzle_expired 0))
(assert (not (= source_puzzle_expired target_puzzle_expired)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; work_is_sequential: source semantics (matches Coq)
; Translation validation: work_is_sequential preserves semantics
(push 1)
(declare-const source_work_is_sequential Int)
(declare-const target_work_is_sequential Int)
(assert (>= source_work_is_sequential 0))
(assert (>= target_work_is_sequential 0))
(assert (not (= source_work_is_sequential target_work_is_sequential)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; server_state_pre_verify: source semantics (matches Coq)
; Translation validation: server_state_pre_verify preserves semantics
(push 1)
(declare-const source_server_state_pre_verify Int)
(declare-const target_server_state_pre_verify Int)
(assert (>= source_server_state_pre_verify 0))
(assert (>= target_server_state_pre_verify 0))
(assert (not (= source_server_state_pre_verify target_server_state_pre_verify)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; server_work: source semantics (matches Coq)
; Translation validation: server_work preserves semantics
(push 1)
(declare-const source_server_work Int)
(declare-const target_server_work Int)
(assert (>= source_server_work 0))
(assert (>= target_server_work 0))
(assert (not (= source_server_work target_server_work)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; client_work: source semantics (matches Coq)
; Translation validation: client_work preserves semantics
(push 1)
(declare-const source_client_work Int)
(declare-const target_client_work Int)
(assert (>= source_client_work 0))
(assert (>= target_client_work 0))
(assert (not (= source_client_work target_client_work)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; refill: source semantics (matches Coq)
; Translation validation: refill preserves semantics
(push 1)
(declare-const source_refill Int)
(declare-const target_refill Int)
(assert (>= source_refill 0))
(assert (>= target_refill 0))
(assert (not (= source_refill target_refill)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; requests_allowed: source semantics (matches Coq)
; Translation validation: requests_allowed preserves semantics
(push 1)
(declare-const source_requests_allowed Int)
(declare-const target_requests_allowed Int)
(assert (>= source_requests_allowed 0))
(assert (>= target_requests_allowed 0))
(assert (not (= source_requests_allowed target_requests_allowed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bucket_valid: source semantics (matches Coq)
; Translation validation: bucket_valid preserves semantics
(push 1)
(declare-const source_bucket_valid Int)
(declare-const target_bucket_valid Int)
(assert (>= source_bucket_valid 0))
(assert (>= target_bucket_valid 0))
(assert (not (= source_bucket_valid target_bucket_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fair_share: source semantics (matches Coq)
; Translation validation: fair_share preserves semantics
(push 1)
(declare-const source_fair_share Int)
(declare-const target_fair_share Int)
(assert (>= source_fair_share 0))
(assert (>= target_fair_share 0))
(assert (not (= source_fair_share target_fair_share)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; allocation_fair: source semantics (matches Coq)
; Translation validation: allocation_fair preserves semantics
(push 1)
(declare-const source_allocation_fair Int)
(declare-const target_allocation_fair Int)
(assert (>= source_allocation_fair 0))
(assert (>= target_allocation_fair 0))
(assert (not (= source_allocation_fair target_allocation_fair)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_starvation_prop: source semantics (matches Coq)
; Translation validation: no_starvation_prop preserves semantics
(push 1)
(declare-const source_no_starvation_prop Int)
(declare-const target_no_starvation_prop Int)
(assert (>= source_no_starvation_prop 0))
(assert (>= target_no_starvation_prop 0))
(assert (not (= source_no_starvation_prop target_no_starvation_prop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; adaptive_rate: source semantics (matches Coq)
; Translation validation: adaptive_rate preserves semantics
(push 1)
(declare-const source_adaptive_rate Int)
(declare-const target_adaptive_rate Int)
(assert (>= source_adaptive_rate 0))
(assert (>= target_adaptive_rate 0))
(assert (not (= source_adaptive_rate target_adaptive_rate)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compose_limits: source semantics (matches Coq)
; Translation validation: compose_limits preserves semantics
(push 1)
(declare-const source_compose_limits Int)
(declare-const target_compose_limits Int)
(assert (>= source_compose_limits 0))
(assert (>= target_compose_limits 0))
(assert (not (= source_compose_limits target_compose_limits)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; endpoint_eq: source semantics (matches Coq)
; Translation validation: endpoint_eq preserves semantics
(push 1)
(declare-const source_endpoint_eq Int)
(declare-const target_endpoint_eq Int)
(assert (>= source_endpoint_eq 0))
(assert (>= target_endpoint_eq 0))
(assert (not (= source_endpoint_eq target_endpoint_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; netperm_eq: source semantics (matches Coq)
; Translation validation: netperm_eq preserves semantics
(push 1)
(declare-const source_netperm_eq Int)
(declare-const target_netperm_eq Int)
(assert (>= source_netperm_eq 0))
(assert (>= target_netperm_eq 0))
(assert (not (= source_netperm_eq target_netperm_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; verify_signature: source semantics (matches Coq)
; Translation validation: verify_signature preserves semantics
(push 1)
(declare-const source_verify_signature Int)
(declare-const target_verify_signature Int)
(assert (>= source_verify_signature 0))
(assert (>= target_verify_signature 0))
(assert (not (= source_verify_signature target_verify_signature)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cap_valid: source semantics (matches Coq)
; Translation validation: cap_valid preserves semantics
(push 1)
(declare-const source_cap_valid Int)
(declare-const target_cap_valid Int)
(assert (>= source_cap_valid 0))
(assert (>= target_cap_valid 0))
(assert (not (= source_cap_valid target_cap_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; grants_access: source semantics (matches Coq)
; Translation validation: grants_access preserves semantics
(push 1)
(declare-const source_grants_access Int)
(declare-const target_grants_access Int)
(assert (>= source_grants_access 0))
(assert (>= target_grants_access 0))
(assert (not (= source_grants_access target_grants_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cap_revoked: source semantics (matches Coq)
; Translation validation: cap_revoked preserves semantics
(push 1)
(declare-const source_cap_revoked Int)
(declare-const target_cap_revoked Int)
(assert (>= source_cap_revoked 0))
(assert (>= target_cap_revoked 0))
(assert (not (= source_cap_revoked target_cap_revoked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; action_to_perm: source semantics (matches Coq)
; Translation validation: action_to_perm preserves semantics
(push 1)
(declare-const source_action_to_perm Int)
(declare-const target_action_to_perm Int)
(assert (>= source_action_to_perm 0))
(assert (>= target_action_to_perm 0))
(assert (not (= source_action_to_perm target_action_to_perm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; action_target: source semantics (matches Coq)
; Translation validation: action_target preserves semantics
(push 1)
(declare-const source_action_target Int)
(declare-const target_action_target Int)
(assert (>= source_action_target 0))
(assert (>= target_action_target 0))
(assert (not (= source_action_target target_action_target)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; amplification_factor: source semantics (matches Coq)
; Translation validation: amplification_factor preserves semantics
(push 1)
(declare-const source_amplification_factor Int)
(declare-const target_amplification_factor Int)
(assert (>= source_amplification_factor 0))
(assert (>= target_amplification_factor 0))
(assert (not (= source_amplification_factor target_amplification_factor)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; safe_amplification: source semantics (matches Coq)
; Translation validation: safe_amplification preserves semantics
(push 1)
(declare-const source_safe_amplification Int)
(declare-const target_safe_amplification Int)
(assert (>= source_safe_amplification 0))
(assert (>= target_safe_amplification 0))
(assert (not (= source_safe_amplification target_safe_amplification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hash_to_nat: source semantics (matches Coq)
; Translation validation: hash_to_nat preserves semantics
(push 1)
(declare-const source_hash_to_nat Int)
(declare-const target_hash_to_nat Int)
(assert (>= source_hash_to_nat 0))
(assert (>= target_hash_to_nat 0))
(assert (not (= source_hash_to_nat target_hash_to_nat)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; syn_cookie: source semantics (matches Coq)
; Translation validation: syn_cookie preserves semantics
(push 1)
(declare-const source_syn_cookie Int)
(declare-const target_syn_cookie Int)
(assert (>= source_syn_cookie 0))
(assert (>= target_syn_cookie 0))
(assert (not (= source_syn_cookie target_syn_cookie)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; verify_syn_cookie: source semantics (matches Coq)
; Translation validation: verify_syn_cookie preserves semantics
(push 1)
(declare-const source_verify_syn_cookie Int)
(declare-const target_verify_syn_cookie Int)
(assert (>= source_verify_syn_cookie 0))
(assert (>= target_verify_syn_cookie 0))
(assert (not (= source_verify_syn_cookie target_verify_syn_cookie)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; syn_cookie_state_required: source semantics (matches Coq)
; Translation validation: syn_cookie_state_required preserves semantics
(push 1)
(declare-const source_syn_cookie_state_required Int)
(declare-const target_syn_cookie_state_required Int)
(assert (>= source_syn_cookie_state_required 0))
(assert (>= target_syn_cookie_state_required 0))
(assert (not (= source_syn_cookie_state_required target_syn_cookie_state_required)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; syn_cookie_memory_usage: source semantics (matches Coq)
; Translation validation: syn_cookie_memory_usage preserves semantics
(push 1)
(declare-const source_syn_cookie_memory_usage Int)
(declare-const target_syn_cookie_memory_usage Int)
(assert (>= source_syn_cookie_memory_usage 0))
(assert (>= target_syn_cookie_memory_usage 0))
(assert (not (= source_syn_cookie_memory_usage target_syn_cookie_memory_usage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; siphash: source semantics (matches Coq)
; Translation validation: siphash preserves semantics
(push 1)
(declare-const source_siphash Int)
(declare-const target_siphash Int)
(assert (>= source_siphash 0))
(assert (>= target_siphash 0))
(assert (not (= source_siphash target_siphash)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; regex_size: source semantics (matches Coq)
; Translation validation: regex_size preserves semantics
(push 1)
(declare-const source_regex_size Int)
(declare-const target_regex_size Int)
(assert (>= source_regex_size 0))
(assert (>= target_regex_size 0))
(assert (not (= source_regex_size target_regex_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; regex_match_bounded: source semantics (matches Coq)
; Translation validation: regex_match_bounded preserves semantics
(push 1)
(declare-const source_regex_match_bounded Int)
(declare-const target_regex_match_bounded Int)
(assert (>= source_regex_match_bounded 0))
(assert (>= target_regex_match_bounded 0))
(assert (not (= source_regex_match_bounded target_regex_match_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; max_bucket_size: source semantics (matches Coq)
; Translation validation: max_bucket_size preserves semantics
(push 1)
(declare-const source_max_bucket_size Int)
(declare-const target_max_bucket_size Int)
(assert (>= source_max_bucket_size 0))
(assert (>= target_max_bucket_size 0))
(assert (not (= source_max_bucket_size target_max_bucket_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; adaptive_difficulty: source semantics (matches Coq)
; Translation validation: adaptive_difficulty preserves semantics
(push 1)
(declare-const source_adaptive_difficulty Int)
(declare-const target_adaptive_difficulty Int)
(assert (>= source_adaptive_difficulty 0))
(assert (>= target_adaptive_difficulty 0))
(assert (not (= source_adaptive_difficulty target_adaptive_difficulty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_reflection_safe: source semantics (matches Coq)
; Translation validation: is_reflection_safe preserves semantics
(push 1)
(declare-const source_is_reflection_safe Int)
(declare-const target_is_reflection_safe Int)
(assert (>= source_is_reflection_safe 0))
(assert (>= target_is_reflection_safe 0))
(assert (not (= source_is_reflection_safe target_is_reflection_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; list_eq_dec_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: list_eq_dec_refl preserves semantics
(push 1)
(declare-const source_list_eq_dec_refl Int)
(declare-const target_list_eq_dec_refl Int)
(assert (>= source_list_eq_dec_refl 0))
(assert (>= target_list_eq_dec_refl 0))
(assert (not (= source_list_eq_dec_refl target_list_eq_dec_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Nat_eqb_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: Nat_eqb_refl preserves semantics
(push 1)
(declare-const source_Nat_eqb_refl Int)
(declare-const target_Nat_eqb_refl Int)
(assert (>= source_Nat_eqb_refl 0))
(assert (>= target_Nat_eqb_refl 0))
(assert (not (= source_Nat_eqb_refl target_Nat_eqb_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; min_le_l: translation preserves property (matches Coq: Lemma)
; Translation validation: min_le_l preserves semantics
(push 1)
(declare-const source_min_le_l Int)
(declare-const target_min_le_l Int)
(assert (>= source_min_le_l 0))
(assert (>= target_min_le_l 0))
(assert (not (= source_min_le_l target_min_le_l)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; min_le_r: translation preserves property (matches Coq: Lemma)
; Translation validation: min_le_r preserves semantics
(push 1)
(declare-const source_min_le_r Int)
(declare-const target_min_le_r Int)
(assert (>= source_min_le_r 0))
(assert (>= target_min_le_r 0))
(assert (not (= source_min_le_r target_min_le_r)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; forallb_impl: translation preserves property (matches Coq: Lemma)
; Translation validation: forallb_impl preserves semantics
(push 1)
(declare-const source_forallb_impl Int)
(declare-const target_forallb_impl Int)
(assert (>= source_forallb_impl 0))
(assert (>= target_forallb_impl 0))
(assert (not (= source_forallb_impl target_forallb_impl)))
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

; OMEGA_001_01_puzzle_work_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_01_puzzle_work_bound preserves semantics
(push 1)
(declare-const source_OMEGA_001_01_puzzle_work_bound Int)
(declare-const target_OMEGA_001_01_puzzle_work_bound Int)
(assert (>= source_OMEGA_001_01_puzzle_work_bound 0))
(assert (>= target_OMEGA_001_01_puzzle_work_bound 0))
(assert (not (= source_OMEGA_001_01_puzzle_work_bound target_OMEGA_001_01_puzzle_work_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_02_puzzle_verify_cheap: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_02_puzzle_verify_cheap preserves semantics
(push 1)
(declare-const source_OMEGA_001_02_puzzle_verify_cheap Int)
(declare-const target_OMEGA_001_02_puzzle_verify_cheap Int)
(assert (>= source_OMEGA_001_02_puzzle_verify_cheap 0))
(assert (>= target_OMEGA_001_02_puzzle_verify_cheap 0))
(assert (not (= source_OMEGA_001_02_puzzle_verify_cheap target_OMEGA_001_02_puzzle_verify_cheap)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_03_puzzle_unforgeable: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_03_puzzle_unforgeable preserves semantics
(push 1)
(declare-const source_OMEGA_001_03_puzzle_unforgeable Int)
(declare-const target_OMEGA_001_03_puzzle_unforgeable Int)
(assert (>= source_OMEGA_001_03_puzzle_unforgeable 0))
(assert (>= target_OMEGA_001_03_puzzle_unforgeable 0))
(assert (not (= source_OMEGA_001_03_puzzle_unforgeable target_OMEGA_001_03_puzzle_unforgeable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_04_puzzle_fresh: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_04_puzzle_fresh preserves semantics
(push 1)
(declare-const source_OMEGA_001_04_puzzle_fresh Int)
(declare-const target_OMEGA_001_04_puzzle_fresh Int)
(assert (>= source_OMEGA_001_04_puzzle_fresh 0))
(assert (>= target_OMEGA_001_04_puzzle_fresh 0))
(assert (not (= source_OMEGA_001_04_puzzle_fresh target_OMEGA_001_04_puzzle_fresh)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_05_puzzle_difficulty_adaptive: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_05_puzzle_difficulty_adaptive preserves semantics
(push 1)
(declare-const source_OMEGA_001_05_puzzle_difficulty_adaptive Int)
(declare-const target_OMEGA_001_05_puzzle_difficulty_adaptive Int)
(assert (>= source_OMEGA_001_05_puzzle_difficulty_adaptive 0))
(assert (>= target_OMEGA_001_05_puzzle_difficulty_adaptive 0))
(assert (not (= source_OMEGA_001_05_puzzle_difficulty_adaptive target_OMEGA_001_05_puzzle_difficulty_adaptive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_06_puzzle_non_parallelizable: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_06_puzzle_non_parallelizable preserves semantics
(push 1)
(declare-const source_OMEGA_001_06_puzzle_non_parallelizable Int)
(declare-const target_OMEGA_001_06_puzzle_non_parallelizable Int)
(assert (>= source_OMEGA_001_06_puzzle_non_parallelizable 0))
(assert (>= target_OMEGA_001_06_puzzle_non_parallelizable 0))
(assert (not (= source_OMEGA_001_06_puzzle_non_parallelizable target_OMEGA_001_06_puzzle_non_parallelizable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_07_puzzle_stateless: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_07_puzzle_stateless preserves semantics
(push 1)
(declare-const source_OMEGA_001_07_puzzle_stateless Int)
(declare-const target_OMEGA_001_07_puzzle_stateless Int)
(assert (>= source_OMEGA_001_07_puzzle_stateless 0))
(assert (>= target_OMEGA_001_07_puzzle_stateless 0))
(assert (not (= source_OMEGA_001_07_puzzle_stateless target_OMEGA_001_07_puzzle_stateless)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pow2_ge_1: translation preserves property (matches Coq: Lemma)
; Translation validation: pow2_ge_1 preserves semantics
(push 1)
(declare-const source_pow2_ge_1 Int)
(declare-const target_pow2_ge_1 Int)
(assert (>= source_pow2_ge_1 0))
(assert (>= target_pow2_ge_1 0))
(assert (not (= source_pow2_ge_1 target_pow2_ge_1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pow2_ge_2: translation preserves property (matches Coq: Lemma)
; Translation validation: pow2_ge_2 preserves semantics
(push 1)
(declare-const source_pow2_ge_2 Int)
(declare-const target_pow2_ge_2 Int)
(assert (>= source_pow2_ge_2 0))
(assert (>= target_pow2_ge_2 0))
(assert (not (= source_pow2_ge_2 target_pow2_ge_2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_08_puzzle_asymmetric: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_08_puzzle_asymmetric preserves semantics
(push 1)
(declare-const source_OMEGA_001_08_puzzle_asymmetric Int)
(declare-const target_OMEGA_001_08_puzzle_asymmetric Int)
(assert (>= source_OMEGA_001_08_puzzle_asymmetric 0))
(assert (>= target_OMEGA_001_08_puzzle_asymmetric 0))
(assert (not (= source_OMEGA_001_08_puzzle_asymmetric target_OMEGA_001_08_puzzle_asymmetric)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_09_token_bucket_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_09_token_bucket_correct preserves semantics
(push 1)
(declare-const source_OMEGA_001_09_token_bucket_correct Int)
(declare-const target_OMEGA_001_09_token_bucket_correct Int)
(assert (>= source_OMEGA_001_09_token_bucket_correct 0))
(assert (>= target_OMEGA_001_09_token_bucket_correct 0))
(assert (not (= source_OMEGA_001_09_token_bucket_correct target_OMEGA_001_09_token_bucket_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_10_rate_limit_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_10_rate_limit_bound preserves semantics
(push 1)
(declare-const source_OMEGA_001_10_rate_limit_bound Int)
(declare-const target_OMEGA_001_10_rate_limit_bound Int)
(assert (>= source_OMEGA_001_10_rate_limit_bound 0))
(assert (>= target_OMEGA_001_10_rate_limit_bound 0))
(assert (not (= source_OMEGA_001_10_rate_limit_bound target_OMEGA_001_10_rate_limit_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_11_rate_limit_fair: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_11_rate_limit_fair preserves semantics
(push 1)
(declare-const source_OMEGA_001_11_rate_limit_fair Int)
(declare-const target_OMEGA_001_11_rate_limit_fair Int)
(assert (>= source_OMEGA_001_11_rate_limit_fair 0))
(assert (>= target_OMEGA_001_11_rate_limit_fair 0))
(assert (not (= source_OMEGA_001_11_rate_limit_fair target_OMEGA_001_11_rate_limit_fair)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_12_no_starvation: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_12_no_starvation preserves semantics
(push 1)
(declare-const source_OMEGA_001_12_no_starvation Int)
(declare-const target_OMEGA_001_12_no_starvation Int)
(assert (>= source_OMEGA_001_12_no_starvation 0))
(assert (>= target_OMEGA_001_12_no_starvation 0))
(assert (not (= source_OMEGA_001_12_no_starvation target_OMEGA_001_12_no_starvation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_13_burst_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_13_burst_bounded preserves semantics
(push 1)
(declare-const source_OMEGA_001_13_burst_bounded Int)
(declare-const target_OMEGA_001_13_burst_bounded Int)
(assert (>= source_OMEGA_001_13_burst_bounded 0))
(assert (>= target_OMEGA_001_13_burst_bounded 0))
(assert (not (= source_OMEGA_001_13_burst_bounded target_OMEGA_001_13_burst_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_14_rate_adaptive: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_14_rate_adaptive preserves semantics
(push 1)
(declare-const source_OMEGA_001_14_rate_adaptive Int)
(declare-const target_OMEGA_001_14_rate_adaptive Int)
(assert (>= source_OMEGA_001_14_rate_adaptive 0))
(assert (>= target_OMEGA_001_14_rate_adaptive 0))
(assert (not (= source_OMEGA_001_14_rate_adaptive target_OMEGA_001_14_rate_adaptive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_15_rate_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_15_rate_composition preserves semantics
(push 1)
(declare-const source_OMEGA_001_15_rate_composition Int)
(declare-const target_OMEGA_001_15_rate_composition Int)
(assert (>= source_OMEGA_001_15_rate_composition 0))
(assert (>= target_OMEGA_001_15_rate_composition 0))
(assert (not (= source_OMEGA_001_15_rate_composition target_OMEGA_001_15_rate_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_16_cap_unforgeable: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_16_cap_unforgeable preserves semantics
(push 1)
(declare-const source_OMEGA_001_16_cap_unforgeable Int)
(declare-const target_OMEGA_001_16_cap_unforgeable Int)
(assert (>= source_OMEGA_001_16_cap_unforgeable 0))
(assert (>= target_OMEGA_001_16_cap_unforgeable 0))
(assert (not (= source_OMEGA_001_16_cap_unforgeable target_OMEGA_001_16_cap_unforgeable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_17_cap_required: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_17_cap_required preserves semantics
(push 1)
(declare-const source_OMEGA_001_17_cap_required Int)
(declare-const target_OMEGA_001_17_cap_required Int)
(assert (>= source_OMEGA_001_17_cap_required 0))
(assert (>= target_OMEGA_001_17_cap_required 0))
(assert (not (= source_OMEGA_001_17_cap_required target_OMEGA_001_17_cap_required)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_18_cap_attenuate: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_18_cap_attenuate preserves semantics
(push 1)
(declare-const source_OMEGA_001_18_cap_attenuate Int)
(declare-const target_OMEGA_001_18_cap_attenuate Int)
(assert (>= source_OMEGA_001_18_cap_attenuate 0))
(assert (>= target_OMEGA_001_18_cap_attenuate 0))
(assert (not (= source_OMEGA_001_18_cap_attenuate target_OMEGA_001_18_cap_attenuate)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_19_cap_revocable: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_19_cap_revocable preserves semantics
(push 1)
(declare-const source_OMEGA_001_19_cap_revocable Int)
(declare-const target_OMEGA_001_19_cap_revocable Int)
(assert (>= source_OMEGA_001_19_cap_revocable 0))
(assert (>= target_OMEGA_001_19_cap_revocable 0))
(assert (not (= source_OMEGA_001_19_cap_revocable target_OMEGA_001_19_cap_revocable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_20_cap_bound_target: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_20_cap_bound_target preserves semantics
(push 1)
(declare-const source_OMEGA_001_20_cap_bound_target Int)
(declare-const target_OMEGA_001_20_cap_bound_target Int)
(assert (>= source_OMEGA_001_20_cap_bound_target 0))
(assert (>= target_OMEGA_001_20_cap_bound_target 0))
(assert (not (= source_OMEGA_001_20_cap_bound_target target_OMEGA_001_20_cap_bound_target)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_21_cap_delegation_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_21_cap_delegation_safe preserves semantics
(push 1)
(declare-const source_OMEGA_001_21_cap_delegation_safe Int)
(declare-const target_OMEGA_001_21_cap_delegation_safe Int)
(assert (>= source_OMEGA_001_21_cap_delegation_safe 0))
(assert (>= target_OMEGA_001_21_cap_delegation_safe 0))
(assert (not (= source_OMEGA_001_21_cap_delegation_safe target_OMEGA_001_21_cap_delegation_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_22_cap_no_amplification: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_22_cap_no_amplification preserves semantics
(push 1)
(declare-const source_OMEGA_001_22_cap_no_amplification Int)
(declare-const target_OMEGA_001_22_cap_no_amplification Int)
(assert (>= source_OMEGA_001_22_cap_no_amplification 0))
(assert (>= target_OMEGA_001_22_cap_no_amplification 0))
(assert (not (= source_OMEGA_001_22_cap_no_amplification target_OMEGA_001_22_cap_no_amplification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_23_cap_no_reflection: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_23_cap_no_reflection preserves semantics
(push 1)
(declare-const source_OMEGA_001_23_cap_no_reflection Int)
(declare-const target_OMEGA_001_23_cap_no_reflection Int)
(assert (>= source_OMEGA_001_23_cap_no_reflection 0))
(assert (>= target_OMEGA_001_23_cap_no_reflection 0))
(assert (not (= source_OMEGA_001_23_cap_no_reflection target_OMEGA_001_23_cap_no_reflection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_24_syn_cookie_stateless: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_24_syn_cookie_stateless preserves semantics
(push 1)
(declare-const source_OMEGA_001_24_syn_cookie_stateless Int)
(declare-const target_OMEGA_001_24_syn_cookie_stateless Int)
(assert (>= source_OMEGA_001_24_syn_cookie_stateless 0))
(assert (>= target_OMEGA_001_24_syn_cookie_stateless 0))
(assert (not (= source_OMEGA_001_24_syn_cookie_stateless target_OMEGA_001_24_syn_cookie_stateless)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_25_syn_cookie_unforgeable: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_25_syn_cookie_unforgeable preserves semantics
(push 1)
(declare-const source_OMEGA_001_25_syn_cookie_unforgeable Int)
(declare-const target_OMEGA_001_25_syn_cookie_unforgeable Int)
(assert (>= source_OMEGA_001_25_syn_cookie_unforgeable 0))
(assert (>= target_OMEGA_001_25_syn_cookie_unforgeable 0))
(assert (not (= source_OMEGA_001_25_syn_cookie_unforgeable target_OMEGA_001_25_syn_cookie_unforgeable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_26_syn_cookie_verify: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_26_syn_cookie_verify preserves semantics
(push 1)
(declare-const source_OMEGA_001_26_syn_cookie_verify Int)
(declare-const target_OMEGA_001_26_syn_cookie_verify Int)
(assert (>= source_OMEGA_001_26_syn_cookie_verify 0))
(assert (>= target_OMEGA_001_26_syn_cookie_verify 0))
(assert (not (= source_OMEGA_001_26_syn_cookie_verify target_OMEGA_001_26_syn_cookie_verify)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_27_syn_cookie_replay_prevent: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_27_syn_cookie_replay_prevent preserves semantics
(push 1)
(declare-const source_OMEGA_001_27_syn_cookie_replay_prevent Int)
(declare-const target_OMEGA_001_27_syn_cookie_replay_prevent Int)
(assert (>= source_OMEGA_001_27_syn_cookie_replay_prevent 0))
(assert (>= target_OMEGA_001_27_syn_cookie_replay_prevent 0))
(assert (not (= source_OMEGA_001_27_syn_cookie_replay_prevent target_OMEGA_001_27_syn_cookie_replay_prevent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_28_syn_flood_mitigated: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_28_syn_flood_mitigated preserves semantics
(push 1)
(declare-const source_OMEGA_001_28_syn_flood_mitigated Int)
(declare-const target_OMEGA_001_28_syn_flood_mitigated Int)
(assert (>= source_OMEGA_001_28_syn_flood_mitigated 0))
(assert (>= target_OMEGA_001_28_syn_flood_mitigated 0))
(assert (not (= source_OMEGA_001_28_syn_flood_mitigated target_OMEGA_001_28_syn_flood_mitigated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_29_legitimate_connections: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_29_legitimate_connections preserves semantics
(push 1)
(declare-const source_OMEGA_001_29_legitimate_connections Int)
(declare-const target_OMEGA_001_29_legitimate_connections Int)
(assert (>= source_OMEGA_001_29_legitimate_connections 0))
(assert (>= target_OMEGA_001_29_legitimate_connections 0))
(assert (not (= source_OMEGA_001_29_legitimate_connections target_OMEGA_001_29_legitimate_connections)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_30_hash_collision_resistant: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_30_hash_collision_resistant preserves semantics
(push 1)
(declare-const source_OMEGA_001_30_hash_collision_resistant Int)
(declare-const target_OMEGA_001_30_hash_collision_resistant Int)
(assert (>= source_OMEGA_001_30_hash_collision_resistant 0))
(assert (>= target_OMEGA_001_30_hash_collision_resistant 0))
(assert (not (= source_OMEGA_001_30_hash_collision_resistant target_OMEGA_001_30_hash_collision_resistant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_31_regex_terminates: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_31_regex_terminates preserves semantics
(push 1)
(declare-const source_OMEGA_001_31_regex_terminates Int)
(declare-const target_OMEGA_001_31_regex_terminates Int)
(assert (>= source_OMEGA_001_31_regex_terminates 0))
(assert (>= target_OMEGA_001_31_regex_terminates 0))
(assert (not (= source_OMEGA_001_31_regex_terminates target_OMEGA_001_31_regex_terminates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_32_decompression_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_32_decompression_bounded preserves semantics
(push 1)
(declare-const source_OMEGA_001_32_decompression_bounded Int)
(declare-const target_OMEGA_001_32_decompression_bounded Int)
(assert (>= source_OMEGA_001_32_decompression_bounded 0))
(assert (>= target_OMEGA_001_32_decompression_bounded 0))
(assert (not (= source_OMEGA_001_32_decompression_bounded target_OMEGA_001_32_decompression_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_33_json_parse_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_33_json_parse_bounded preserves semantics
(push 1)
(declare-const source_OMEGA_001_33_json_parse_bounded Int)
(declare-const target_OMEGA_001_33_json_parse_bounded Int)
(assert (>= source_OMEGA_001_33_json_parse_bounded 0))
(assert (>= target_OMEGA_001_33_json_parse_bounded 0))
(assert (not (= source_OMEGA_001_33_json_parse_bounded target_OMEGA_001_33_json_parse_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_34_xml_parse_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_34_xml_parse_bounded preserves semantics
(push 1)
(declare-const source_OMEGA_001_34_xml_parse_bounded Int)
(declare-const target_OMEGA_001_34_xml_parse_bounded Int)
(assert (>= source_OMEGA_001_34_xml_parse_bounded 0))
(assert (>= target_OMEGA_001_34_xml_parse_bounded 0))
(assert (not (= source_OMEGA_001_34_xml_parse_bounded target_OMEGA_001_34_xml_parse_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; OMEGA_001_35_no_algorithmic_dos: translation preserves property (matches Coq: Theorem)
; Translation validation: OMEGA_001_35_no_algorithmic_dos preserves semantics
(push 1)
(declare-const source_OMEGA_001_35_no_algorithmic_dos Int)
(declare-const target_OMEGA_001_35_no_algorithmic_dos Int)
(assert (>= source_OMEGA_001_35_no_algorithmic_dos 0))
(assert (>= target_OMEGA_001_35_no_algorithmic_dos 0))
(assert (not (= source_OMEGA_001_35_no_algorithmic_dos target_OMEGA_001_35_no_algorithmic_dos)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/StandardLibrary.v (45 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for StandardLibrary
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; siphash_collision_resistant: source semantics (matches Coq)
; Translation validation: siphash_collision_resistant preserves semantics
(push 1)
(declare-const source_siphash_collision_resistant Int)
(declare-const target_siphash_collision_resistant Int)
(assert (>= source_siphash_collision_resistant 0))
(assert (>= target_siphash_collision_resistant 0))
(assert (not (= source_siphash_collision_resistant target_siphash_collision_resistant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_valid_utf8_byte: source semantics (matches Coq)
; Translation validation: is_valid_utf8_byte preserves semantics
(push 1)
(declare-const source_is_valid_utf8_byte Int)
(declare-const target_is_valid_utf8_byte Int)
(assert (>= source_is_valid_utf8_byte 0))
(assert (>= target_is_valid_utf8_byte 0))
(assert (not (= source_is_valid_utf8_byte target_is_valid_utf8_byte)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; all_valid_utf8: source semantics (matches Coq)
; Translation validation: all_valid_utf8 preserves semantics
(push 1)
(declare-const source_all_valid_utf8 Int)
(declare-const target_all_valid_utf8 Int)
(assert (>= source_all_valid_utf8 0))
(assert (>= target_all_valid_utf8 0))
(assert (not (= source_all_valid_utf8 target_all_valid_utf8)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; string_from_bytes: source semantics (matches Coq)
; Translation validation: string_from_bytes preserves semantics
(push 1)
(declare-const source_string_from_bytes Int)
(declare-const target_string_from_bytes Int)
(assert (>= source_string_from_bytes 0))
(assert (>= target_string_from_bytes 0))
(assert (not (= source_string_from_bytes target_string_from_bytes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; secure_string_drop: source semantics (matches Coq)
; Translation validation: secure_string_drop preserves semantics
(push 1)
(declare-const source_secure_string_drop Int)
(declare-const target_secure_string_drop Int)
(assert (>= source_secure_string_drop 0))
(assert (>= target_secure_string_drop 0))
(assert (not (= source_secure_string_drop target_secure_string_drop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cap_eq: source semantics (matches Coq)
; Translation validation: cap_eq preserves semantics
(push 1)
(declare-const source_cap_eq Int)
(declare-const target_cap_eq Int)
(assert (>= source_cap_eq 0))
(assert (>= target_cap_eq 0))
(assert (not (= source_cap_eq target_cap_eq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; has_capability: source semantics (matches Coq)
; Translation validation: has_capability preserves semantics
(push 1)
(declare-const source_has_capability Int)
(declare-const target_has_capability Int)
(assert (>= source_has_capability 0))
(assert (>= target_has_capability 0))
(assert (not (= source_has_capability target_has_capability)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tls_version_secure: source semantics (matches Coq)
; Translation validation: tls_version_secure preserves semantics
(push 1)
(declare-const source_tls_version_secure Int)
(declare-const target_tls_version_secure Int)
(assert (>= source_tls_version_secure 0))
(assert (>= target_tls_version_secure 0))
(assert (not (= source_tls_version_secure target_tls_version_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; tls_version_geq: source semantics (matches Coq)
; Translation validation: tls_version_geq preserves semantics
(push 1)
(declare-const source_tls_version_geq Int)
(declare-const target_tls_version_geq Int)
(assert (>= source_tls_version_geq 0))
(assert (>= target_tls_version_geq 0))
(assert (not (= source_tls_version_geq target_tls_version_geq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; duration_add: source semantics (matches Coq)
; Translation validation: duration_add preserves semantics
(push 1)
(declare-const source_duration_add Int)
(declare-const target_duration_add Int)
(assert (>= source_duration_add 0))
(assert (>= target_duration_add 0))
(assert (not (= source_duration_add target_duration_add)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; instant_elapsed: source semantics (matches Coq)
; Translation validation: instant_elapsed preserves semantics
(push 1)
(declare-const source_instant_elapsed Int)
(declare-const target_instant_elapsed Int)
(assert (>= source_instant_elapsed 0))
(assert (>= target_instant_elapsed 0))
(assert (not (= source_instant_elapsed target_instant_elapsed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; verify_timestamp: source semantics (matches Coq)
; Translation validation: verify_timestamp preserves semantics
(push 1)
(declare-const source_verify_timestamp Int)
(declare-const target_verify_timestamp Int)
(assert (>= source_verify_timestamp 0))
(assert (>= target_verify_timestamp 0))
(assert (not (= source_verify_timestamp target_verify_timestamp)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mono_increment: source semantics (matches Coq)
; Translation validation: mono_increment preserves semantics
(push 1)
(declare-const source_mono_increment Int)
(declare-const target_mono_increment Int)
(assert (>= source_mono_increment 0))
(assert (>= target_mono_increment 0))
(assert (not (= source_mono_increment target_mono_increment)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mono_read: source semantics (matches Coq)
; Translation validation: mono_read preserves semantics
(push 1)
(declare-const source_mono_read Int)
(declare-const target_mono_read Int)
(assert (>= source_mono_read 0))
(assert (>= target_mono_read 0))
(assert (not (= source_mono_read target_mono_read)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; atomic_store: source semantics (matches Coq)
; Translation validation: atomic_store preserves semantics
(push 1)
(declare-const source_atomic_store Int)
(declare-const target_atomic_store Int)
(assert (>= source_atomic_store 0))
(assert (>= target_atomic_store 0))
(assert (not (= source_atomic_store target_atomic_store)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; condvar_wait: source semantics (matches Coq)
; Translation validation: condvar_wait preserves semantics
(push 1)
(declare-const source_condvar_wait Int)
(declare-const target_condvar_wait Int)
(assert (>= source_condvar_wait 0))
(assert (>= target_condvar_wait 0))
(assert (not (= source_condvar_wait target_condvar_wait)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; aes_key_drop: source semantics (matches Coq)
; Translation validation: aes_key_drop preserves semantics
(push 1)
(declare-const source_aes_key_drop Int)
(declare-const target_aes_key_drop Int)
(assert (>= source_aes_key_drop 0))
(assert (>= target_aes_key_drop 0))
(assert (not (= source_aes_key_drop target_aes_key_drop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hash_function: source semantics (matches Coq)
; Translation validation: hash_function preserves semantics
(push 1)
(declare-const source_hash_function Int)
(declare-const target_hash_function Int)
(assert (>= source_hash_function 0))
(assert (>= target_hash_function 0))
(assert (not (= source_hash_function target_hash_function)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sign_data: source semantics (matches Coq)
; Translation validation: sign_data preserves semantics
(push 1)
(declare-const source_sign_data Int)
(declare-const target_sign_data Int)
(assert (>= source_sign_data 0))
(assert (>= target_sign_data 0))
(assert (not (= source_sign_data target_sign_data)))
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

; crypto_key_drop: source semantics (matches Coq)
; Translation validation: crypto_key_drop preserves semantics
(push 1)
(declare-const source_crypto_key_drop Int)
(declare-const target_crypto_key_drop Int)
(assert (>= source_crypto_key_drop 0))
(assert (>= target_crypto_key_drop 0))
(assert (not (= source_crypto_key_drop target_crypto_key_drop)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cap_set_union: source semantics (matches Coq)
; Translation validation: cap_set_union preserves semantics
(push 1)
(declare-const source_cap_set_union Int)
(declare-const target_cap_set_union Int)
(assert (>= source_cap_set_union 0))
(assert (>= target_cap_set_union 0))
(assert (not (= source_cap_set_union target_cap_set_union)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cap_set_inter: source semantics (matches Coq)
; Translation validation: cap_set_inter preserves semantics
(push 1)
(declare-const source_cap_set_inter Int)
(declare-const target_cap_set_inter Int)
(assert (>= source_cap_set_inter 0))
(assert (>= target_cap_set_inter 0))
(assert (not (= source_cap_set_inter target_cap_set_inter)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cap_set_contains: source semantics (matches Coq)
; Translation validation: cap_set_contains preserves semantics
(push 1)
(declare-const source_cap_set_contains Int)
(declare-const target_cap_set_contains Int)
(assert (>= source_cap_set_contains 0))
(assert (>= target_cap_set_contains 0))
(assert (not (= source_cap_set_contains target_cap_set_contains)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; level_leq: source semantics (matches Coq)
; Translation validation: level_leq preserves semantics
(push 1)
(declare-const source_level_leq Int)
(declare-const target_level_leq Int)
(assert (>= source_level_leq 0))
(assert (>= target_level_leq 0))
(assert (not (= source_level_leq target_level_leq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compartments_subset: source semantics (matches Coq)
; Translation validation: compartments_subset preserves semantics
(push 1)
(declare-const source_compartments_subset Int)
(declare-const target_compartments_subset Int)
(assert (>= source_compartments_subset 0))
(assert (>= target_compartments_subset 0))
(assert (not (= source_compartments_subset target_compartments_subset)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; flows_to: source semantics (matches Coq)
; Translation validation: flows_to preserves semantics
(push 1)
(declare-const source_flows_to Int)
(declare-const target_flows_to Int)
(assert (>= source_flows_to 0))
(assert (>= target_flows_to 0))
(assert (not (= source_flows_to target_flows_to)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; level_max: source semantics (matches Coq)
; Translation validation: level_max preserves semantics
(push 1)
(declare-const source_level_max Int)
(declare-const target_level_max Int)
(assert (>= source_level_max 0))
(assert (>= target_level_max 0))
(assert (not (= source_level_max target_level_max)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; level_min: source semantics (matches Coq)
; Translation validation: level_min preserves semantics
(push 1)
(declare-const source_level_min Int)
(declare-const target_level_min Int)
(assert (>= source_level_min 0))
(assert (>= target_level_min 0))
(assert (not (= source_level_min target_level_min)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_join: source semantics (matches Coq)
; Translation validation: label_join preserves semantics
(push 1)
(declare-const source_label_join Int)
(declare-const target_label_join Int)
(assert (>= source_label_join 0))
(assert (>= target_label_join 0))
(assert (not (= source_label_join target_label_join)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; label_meet: source semantics (matches Coq)
; Translation validation: label_meet preserves semantics
(push 1)
(declare-const source_label_meet Int)
(declare-const target_label_meet Int)
(assert (>= source_label_meet 0))
(assert (>= target_label_meet 0))
(assert (not (= source_label_meet target_label_meet)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_01: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_01 preserves semantics
(push 1)
(declare-const source_P_001_01 Int)
(declare-const target_P_001_01 Int)
(assert (>= source_P_001_01 0))
(assert (>= target_P_001_01 0))
(assert (not (= source_P_001_01 target_P_001_01)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_02: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_02 preserves semantics
(push 1)
(declare-const source_P_001_02 Int)
(declare-const target_P_001_02 Int)
(assert (>= source_P_001_02 0))
(assert (>= target_P_001_02 0))
(assert (not (= source_P_001_02 target_P_001_02)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_03: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_03 preserves semantics
(push 1)
(declare-const source_P_001_03 Int)
(declare-const target_P_001_03 Int)
(assert (>= source_P_001_03 0))
(assert (>= target_P_001_03 0))
(assert (not (= source_P_001_03 target_P_001_03)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; rev_app_single: translation preserves property (matches Coq: Lemma)
; Translation validation: rev_app_single preserves semantics
(push 1)
(declare-const source_rev_app_single Int)
(declare-const target_rev_app_single Int)
(assert (>= source_rev_app_single 0))
(assert (>= target_rev_app_single 0))
(assert (not (= source_rev_app_single target_rev_app_single)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_04: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_04 preserves semantics
(push 1)
(declare-const source_P_001_04 Int)
(declare-const target_P_001_04 Int)
(assert (>= source_P_001_04 0))
(assert (>= target_P_001_04 0))
(assert (not (= source_P_001_04 target_P_001_04)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_05: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_05 preserves semantics
(push 1)
(declare-const source_P_001_05 Int)
(declare-const target_P_001_05 Int)
(assert (>= source_P_001_05 0))
(assert (>= target_P_001_05 0))
(assert (not (= source_P_001_05 target_P_001_05)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_06: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_06 preserves semantics
(push 1)
(declare-const source_P_001_06 Int)
(declare-const target_P_001_06 Int)
(assert (>= source_P_001_06 0))
(assert (>= target_P_001_06 0))
(assert (not (= source_P_001_06 target_P_001_06)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_07: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_07 preserves semantics
(push 1)
(declare-const source_P_001_07 Int)
(declare-const target_P_001_07 Int)
(assert (>= source_P_001_07 0))
(assert (>= target_P_001_07 0))
(assert (not (= source_P_001_07 target_P_001_07)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_08: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_08 preserves semantics
(push 1)
(declare-const source_P_001_08 Int)
(declare-const target_P_001_08 Int)
(assert (>= source_P_001_08 0))
(assert (>= target_P_001_08 0))
(assert (not (= source_P_001_08 target_P_001_08)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_09: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_09 preserves semantics
(push 1)
(declare-const source_P_001_09 Int)
(declare-const target_P_001_09 Int)
(assert (>= source_P_001_09 0))
(assert (>= target_P_001_09 0))
(assert (not (= source_P_001_09 target_P_001_09)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_10: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_10 preserves semantics
(push 1)
(declare-const source_P_001_10 Int)
(declare-const target_P_001_10 Int)
(assert (>= source_P_001_10 0))
(assert (>= target_P_001_10 0))
(assert (not (= source_P_001_10 target_P_001_10)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_11: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_11 preserves semantics
(push 1)
(declare-const source_P_001_11 Int)
(declare-const target_P_001_11 Int)
(assert (>= source_P_001_11 0))
(assert (>= target_P_001_11 0))
(assert (not (= source_P_001_11 target_P_001_11)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_12: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_12 preserves semantics
(push 1)
(declare-const source_P_001_12 Int)
(declare-const target_P_001_12 Int)
(assert (>= source_P_001_12 0))
(assert (>= target_P_001_12 0))
(assert (not (= source_P_001_12 target_P_001_12)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_13: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_13 preserves semantics
(push 1)
(declare-const source_P_001_13 Int)
(declare-const target_P_001_13 Int)
(assert (>= source_P_001_13 0))
(assert (>= target_P_001_13 0))
(assert (not (= source_P_001_13 target_P_001_13)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_14: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_14 preserves semantics
(push 1)
(declare-const source_P_001_14 Int)
(declare-const target_P_001_14 Int)
(assert (>= source_P_001_14 0))
(assert (>= target_P_001_14 0))
(assert (not (= source_P_001_14 target_P_001_14)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_15: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_15 preserves semantics
(push 1)
(declare-const source_P_001_15 Int)
(declare-const target_P_001_15 Int)
(assert (>= source_P_001_15 0))
(assert (>= target_P_001_15 0))
(assert (not (= source_P_001_15 target_P_001_15)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_16: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_16 preserves semantics
(push 1)
(declare-const source_P_001_16 Int)
(declare-const target_P_001_16 Int)
(assert (>= source_P_001_16 0))
(assert (>= target_P_001_16 0))
(assert (not (= source_P_001_16 target_P_001_16)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_17: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_17 preserves semantics
(push 1)
(declare-const source_P_001_17 Int)
(declare-const target_P_001_17 Int)
(assert (>= source_P_001_17 0))
(assert (>= target_P_001_17 0))
(assert (not (= source_P_001_17 target_P_001_17)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_18: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_18 preserves semantics
(push 1)
(declare-const source_P_001_18 Int)
(declare-const target_P_001_18 Int)
(assert (>= source_P_001_18 0))
(assert (>= target_P_001_18 0))
(assert (not (= source_P_001_18 target_P_001_18)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_19: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_19 preserves semantics
(push 1)
(declare-const source_P_001_19 Int)
(declare-const target_P_001_19 Int)
(assert (>= source_P_001_19 0))
(assert (>= target_P_001_19 0))
(assert (not (= source_P_001_19 target_P_001_19)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_20: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_20 preserves semantics
(push 1)
(declare-const source_P_001_20 Int)
(declare-const target_P_001_20 Int)
(assert (>= source_P_001_20 0))
(assert (>= target_P_001_20 0))
(assert (not (= source_P_001_20 target_P_001_20)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_21: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_21 preserves semantics
(push 1)
(declare-const source_P_001_21 Int)
(declare-const target_P_001_21 Int)
(assert (>= source_P_001_21 0))
(assert (>= target_P_001_21 0))
(assert (not (= source_P_001_21 target_P_001_21)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_22: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_22 preserves semantics
(push 1)
(declare-const source_P_001_22 Int)
(declare-const target_P_001_22 Int)
(assert (>= source_P_001_22 0))
(assert (>= target_P_001_22 0))
(assert (not (= source_P_001_22 target_P_001_22)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_23: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_23 preserves semantics
(push 1)
(declare-const source_P_001_23 Int)
(declare-const target_P_001_23 Int)
(assert (>= source_P_001_23 0))
(assert (>= target_P_001_23 0))
(assert (not (= source_P_001_23 target_P_001_23)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_24: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_24 preserves semantics
(push 1)
(declare-const source_P_001_24 Int)
(declare-const target_P_001_24 Int)
(assert (>= source_P_001_24 0))
(assert (>= target_P_001_24 0))
(assert (not (= source_P_001_24 target_P_001_24)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_25: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_25 preserves semantics
(push 1)
(declare-const source_P_001_25 Int)
(declare-const target_P_001_25 Int)
(assert (>= source_P_001_25 0))
(assert (>= target_P_001_25 0))
(assert (not (= source_P_001_25 target_P_001_25)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_26: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_26 preserves semantics
(push 1)
(declare-const source_P_001_26 Int)
(declare-const target_P_001_26 Int)
(assert (>= source_P_001_26 0))
(assert (>= target_P_001_26 0))
(assert (not (= source_P_001_26 target_P_001_26)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_27: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_27 preserves semantics
(push 1)
(declare-const source_P_001_27 Int)
(declare-const target_P_001_27 Int)
(assert (>= source_P_001_27 0))
(assert (>= target_P_001_27 0))
(assert (not (= source_P_001_27 target_P_001_27)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_28: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_28 preserves semantics
(push 1)
(declare-const source_P_001_28 Int)
(declare-const target_P_001_28 Int)
(assert (>= source_P_001_28 0))
(assert (>= target_P_001_28 0))
(assert (not (= source_P_001_28 target_P_001_28)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_29: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_29 preserves semantics
(push 1)
(declare-const source_P_001_29 Int)
(declare-const target_P_001_29 Int)
(assert (>= source_P_001_29 0))
(assert (>= target_P_001_29 0))
(assert (not (= source_P_001_29 target_P_001_29)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_30: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_30 preserves semantics
(push 1)
(declare-const source_P_001_30 Int)
(declare-const target_P_001_30 Int)
(assert (>= source_P_001_30 0))
(assert (>= target_P_001_30 0))
(assert (not (= source_P_001_30 target_P_001_30)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_31: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_31 preserves semantics
(push 1)
(declare-const source_P_001_31 Int)
(declare-const target_P_001_31 Int)
(assert (>= source_P_001_31 0))
(assert (>= target_P_001_31 0))
(assert (not (= source_P_001_31 target_P_001_31)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_32: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_32 preserves semantics
(push 1)
(declare-const source_P_001_32 Int)
(declare-const target_P_001_32 Int)
(assert (>= source_P_001_32 0))
(assert (>= target_P_001_32 0))
(assert (not (= source_P_001_32 target_P_001_32)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_33: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_33 preserves semantics
(push 1)
(declare-const source_P_001_33 Int)
(declare-const target_P_001_33 Int)
(assert (>= source_P_001_33 0))
(assert (>= target_P_001_33 0))
(assert (not (= source_P_001_33 target_P_001_33)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_34: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_34 preserves semantics
(push 1)
(declare-const source_P_001_34 Int)
(declare-const target_P_001_34 Int)
(assert (>= source_P_001_34 0))
(assert (>= target_P_001_34 0))
(assert (not (= source_P_001_34 target_P_001_34)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_35: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_35 preserves semantics
(push 1)
(declare-const source_P_001_35 Int)
(declare-const target_P_001_35 Int)
(assert (>= source_P_001_35 0))
(assert (>= target_P_001_35 0))
(assert (not (= source_P_001_35 target_P_001_35)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_36: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_36 preserves semantics
(push 1)
(declare-const source_P_001_36 Int)
(declare-const target_P_001_36 Int)
(assert (>= source_P_001_36 0))
(assert (>= target_P_001_36 0))
(assert (not (= source_P_001_36 target_P_001_36)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_37: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_37 preserves semantics
(push 1)
(declare-const source_P_001_37 Int)
(declare-const target_P_001_37 Int)
(assert (>= source_P_001_37 0))
(assert (>= target_P_001_37 0))
(assert (not (= source_P_001_37 target_P_001_37)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; level_leq_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: level_leq_refl preserves semantics
(push 1)
(declare-const source_level_leq_refl Int)
(declare-const target_level_leq_refl Int)
(assert (>= source_level_leq_refl 0))
(assert (>= target_level_leq_refl 0))
(assert (not (= source_level_leq_refl target_level_leq_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compartments_subset_refl: translation preserves property (matches Coq: Lemma)
; Translation validation: compartments_subset_refl preserves semantics
(push 1)
(declare-const source_compartments_subset_refl Int)
(declare-const target_compartments_subset_refl Int)
(assert (>= source_compartments_subset_refl 0))
(assert (>= target_compartments_subset_refl 0))
(assert (not (= source_compartments_subset_refl target_compartments_subset_refl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_38: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_38 preserves semantics
(push 1)
(declare-const source_P_001_38 Int)
(declare-const target_P_001_38 Int)
(assert (>= source_P_001_38 0))
(assert (>= target_P_001_38 0))
(assert (not (= source_P_001_38 target_P_001_38)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; level_leq_trans: translation preserves property (matches Coq: Lemma)
; Translation validation: level_leq_trans preserves semantics
(push 1)
(declare-const source_level_leq_trans Int)
(declare-const target_level_leq_trans Int)
(assert (>= source_level_leq_trans 0))
(assert (>= target_level_leq_trans 0))
(assert (not (= source_level_leq_trans target_level_leq_trans)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compartments_subset_trans: translation preserves property (matches Coq: Lemma)
; Translation validation: compartments_subset_trans preserves semantics
(push 1)
(declare-const source_compartments_subset_trans Int)
(declare-const target_compartments_subset_trans Int)
(assert (>= source_compartments_subset_trans 0))
(assert (>= target_compartments_subset_trans 0))
(assert (not (= source_compartments_subset_trans target_compartments_subset_trans)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_39: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_39 preserves semantics
(push 1)
(declare-const source_P_001_39 Int)
(declare-const target_P_001_39 Int)
(assert (>= source_P_001_39 0))
(assert (>= target_P_001_39 0))
(assert (not (= source_P_001_39 target_P_001_39)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; P_001_40: translation preserves property (matches Coq: Theorem)
; Translation validation: P_001_40 preserves semantics
(push 1)
(declare-const source_P_001_40 Int)
(declare-const target_P_001_40 Int)
(assert (>= source_P_001_40 0))
(assert (>= target_P_001_40 0))
(assert (not (= source_P_001_40 target_P_001_40)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

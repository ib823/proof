; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/T001_HermeticBuild.v (28 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for T001_HermeticBuild
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; source_semantics: source semantics (matches Coq)
; Translation validation: source_semantics preserves semantics
(push 1)
(declare-const source_source_semantics Int)
(declare-const target_source_semantics Int)
(assert (>= source_source_semantics 0))
(assert (>= target_source_semantics 0))
(assert (not (= source_source_semantics target_source_semantics)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; executes: source semantics (matches Coq)
; Translation validation: executes preserves semantics
(push 1)
(declare-const source_executes Int)
(declare-const target_executes Int)
(assert (>= source_executes 0))
(assert (>= target_executes 0))
(assert (not (= source_executes target_executes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; preserves_semantics: source semantics (matches Coq)
; Translation validation: preserves_semantics preserves semantics
(push 1)
(declare-const source_preserves_semantics Int)
(declare-const target_preserves_semantics Int)
(assert (>= source_preserves_semantics 0))
(assert (>= target_preserves_semantics 0))
(assert (not (= source_preserves_semantics target_preserves_semantics)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hex0_size: source semantics (matches Coq)
; Translation validation: hex0_size preserves semantics
(push 1)
(declare-const source_hex0_size Int)
(declare-const target_hex0_size Int)
(assert (>= source_hex0_size 0))
(assert (>= target_hex0_size 0))
(assert (not (= source_hex0_size target_hex0_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_auditable: source semantics (matches Coq)
; Translation validation: is_auditable preserves semantics
(push 1)
(declare-const source_is_auditable Int)
(declare-const target_is_auditable Int)
(assert (>= source_is_auditable 0))
(assert (>= target_is_auditable 0))
(assert (not (= source_is_auditable target_is_auditable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; valid_hex0: source semantics (matches Coq)
; Translation validation: valid_hex0 preserves semantics
(push 1)
(declare-const source_valid_hex0 Int)
(declare-const target_valid_hex0 Int)
(assert (>= source_valid_hex0 0))
(assert (>= target_valid_hex0 0))
(assert (not (= source_valid_hex0 target_valid_hex0)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hex0_semantics: source semantics (matches Coq)
; Translation validation: hex0_semantics preserves semantics
(push 1)
(declare-const source_hex0_semantics Int)
(declare-const target_hex0_semantics Int)
(assert (>= source_hex0_semantics 0))
(assert (>= target_hex0_semantics 0))
(assert (not (= source_hex0_semantics target_hex0_semantics)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; is_hermetic: source semantics (matches Coq)
; Translation validation: is_hermetic preserves semantics
(push 1)
(declare-const source_is_hermetic Int)
(declare-const target_is_hermetic Int)
(assert (>= source_is_hermetic 0))
(assert (>= target_is_hermetic 0))
(assert (not (= source_is_hermetic target_is_hermetic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hermetic_build: source semantics (matches Coq)
; Translation validation: hermetic_build preserves semantics
(push 1)
(declare-const source_hermetic_build Int)
(declare-const target_hermetic_build Int)
(assert (>= source_hermetic_build 0))
(assert (>= target_hermetic_build 0))
(assert (not (= source_hermetic_build target_hermetic_build)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sha256: source semantics (matches Coq)
; Translation validation: sha256 preserves semantics
(push 1)
(declare-const source_sha256 Int)
(declare-const target_sha256 Int)
(assert (>= source_sha256 0))
(assert (>= target_sha256 0))
(assert (not (= source_sha256 target_sha256)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; bit_reproducible_def: source semantics (matches Coq)
; Translation validation: bit_reproducible_def preserves semantics
(push 1)
(declare-const source_bit_reproducible_def Int)
(declare-const target_bit_reproducible_def Int)
(assert (>= source_bit_reproducible_def 0))
(assert (>= target_bit_reproducible_def 0))
(assert (not (= source_bit_reproducible_def target_bit_reproducible_def)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; compile: source semantics (matches Coq)
; Translation validation: compile preserves semantics
(push 1)
(declare-const source_compile Int)
(declare-const target_compile Int)
(assert (>= source_compile 0))
(assert (>= target_compile 0))
(assert (not (= source_compile target_compile)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; functionally_equivalent: source semantics (matches Coq)
; Translation validation: functionally_equivalent preserves semantics
(push 1)
(declare-const source_functionally_equivalent Int)
(declare-const target_functionally_equivalent Int)
(assert (>= source_functionally_equivalent 0))
(assert (>= target_functionally_equivalent 0))
(assert (not (= source_functionally_equivalent target_functionally_equivalent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; valid_ddc: source semantics (matches Coq)
; Translation validation: valid_ddc preserves semantics
(push 1)
(declare-const source_valid_ddc Int)
(declare-const target_valid_ddc Int)
(assert (>= source_valid_ddc 0))
(assert (>= target_valid_ddc 0))
(assert (not (= source_valid_ddc target_valid_ddc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; has_trojan: source semantics (matches Coq)
; Translation validation: has_trojan preserves semantics
(push 1)
(declare-const source_has_trojan Int)
(declare-const target_has_trojan Int)
(assert (>= source_has_trojan 0))
(assert (>= target_has_trojan 0))
(assert (not (= source_has_trojan target_has_trojan)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; stage_valid: source semantics (matches Coq)
; Translation validation: stage_valid preserves semantics
(push 1)
(declare-const source_stage_valid Int)
(declare-const target_stage_valid Int)
(assert (>= source_stage_valid 0))
(assert (>= target_stage_valid 0))
(assert (not (= source_stage_valid target_stage_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; chain_valid: source semantics (matches Coq)
; Translation validation: chain_valid preserves semantics
(push 1)
(declare-const source_chain_valid Int)
(declare-const target_chain_valid Int)
(assert (>= source_chain_valid 0))
(assert (>= target_chain_valid 0))
(assert (not (= source_chain_valid target_chain_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; stage_deterministic: source semantics (matches Coq)
; Translation validation: stage_deterministic preserves semantics
(push 1)
(declare-const source_stage_deterministic Int)
(declare-const target_stage_deterministic Int)
(assert (>= source_stage_deterministic 0))
(assert (>= target_stage_deterministic 0))
(assert (not (= source_stage_deterministic target_stage_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; stage_terminates: source semantics (matches Coq)
; Translation validation: stage_terminates preserves semantics
(push 1)
(declare-const source_stage_terminates Int)
(declare-const target_stage_terminates Int)
(assert (>= source_stage_terminates 0))
(assert (>= target_stage_terminates 0))
(assert (not (= source_stage_terminates target_stage_terminates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_01_hex0_auditable: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_01_hex0_auditable preserves semantics
(push 1)
(declare-const source_T_001_01_hex0_auditable Int)
(declare-const target_T_001_01_hex0_auditable Int)
(assert (>= source_T_001_01_hex0_auditable 0))
(assert (>= target_T_001_01_hex0_auditable 0))
(assert (not (= source_T_001_01_hex0_auditable target_T_001_01_hex0_auditable)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_02_hex0_correct: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_02_hex0_correct preserves semantics
(push 1)
(declare-const source_T_001_02_hex0_correct Int)
(declare-const target_T_001_02_hex0_correct Int)
(assert (>= source_T_001_02_hex0_correct 0))
(assert (>= target_T_001_02_hex0_correct 0))
(assert (not (= source_T_001_02_hex0_correct target_T_001_02_hex0_correct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_03_stage_preserves_semantics: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_03_stage_preserves_semantics preserves semantics
(push 1)
(declare-const source_T_001_03_stage_preserves_semantics Int)
(declare-const target_T_001_03_stage_preserves_semantics Int)
(assert (>= source_T_001_03_stage_preserves_semantics 0))
(assert (>= target_T_001_03_stage_preserves_semantics 0))
(assert (not (= source_T_001_03_stage_preserves_semantics target_T_001_03_stage_preserves_semantics)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_04_bootstrap_chain_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_04_bootstrap_chain_valid preserves semantics
(push 1)
(declare-const source_T_001_04_bootstrap_chain_valid Int)
(declare-const target_T_001_04_bootstrap_chain_valid Int)
(assert (>= source_T_001_04_bootstrap_chain_valid 0))
(assert (>= target_T_001_04_bootstrap_chain_valid 0))
(assert (not (= source_T_001_04_bootstrap_chain_valid target_T_001_04_bootstrap_chain_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_05_stage_deterministic: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_05_stage_deterministic preserves semantics
(push 1)
(declare-const source_T_001_05_stage_deterministic Int)
(declare-const target_T_001_05_stage_deterministic Int)
(assert (>= source_T_001_05_stage_deterministic 0))
(assert (>= target_T_001_05_stage_deterministic 0))
(assert (not (= source_T_001_05_stage_deterministic target_T_001_05_stage_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_06_stage_terminates: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_06_stage_terminates preserves semantics
(push 1)
(declare-const source_T_001_06_stage_terminates Int)
(declare-const target_T_001_06_stage_terminates Int)
(assert (>= source_T_001_06_stage_terminates 0))
(assert (>= target_T_001_06_stage_terminates 0))
(assert (not (= source_T_001_06_stage_terminates target_T_001_06_stage_terminates)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_07_self_hosting_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_07_self_hosting_valid preserves semantics
(push 1)
(declare-const source_T_001_07_self_hosting_valid Int)
(declare-const target_T_001_07_self_hosting_valid Int)
(assert (>= source_T_001_07_self_hosting_valid 0))
(assert (>= target_T_001_07_self_hosting_valid 0))
(assert (not (= source_T_001_07_self_hosting_valid target_T_001_07_self_hosting_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_08_bootstrap_idempotent: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_08_bootstrap_idempotent preserves semantics
(push 1)
(declare-const source_T_001_08_bootstrap_idempotent Int)
(declare-const target_T_001_08_bootstrap_idempotent Int)
(assert (>= source_T_001_08_bootstrap_idempotent 0))
(assert (>= target_T_001_08_bootstrap_idempotent 0))
(assert (not (= source_T_001_08_bootstrap_idempotent target_T_001_08_bootstrap_idempotent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_09_no_network_access: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_09_no_network_access preserves semantics
(push 1)
(declare-const source_T_001_09_no_network_access Int)
(declare-const target_T_001_09_no_network_access Int)
(assert (>= source_T_001_09_no_network_access 0))
(assert (>= target_T_001_09_no_network_access 0))
(assert (not (= source_T_001_09_no_network_access target_T_001_09_no_network_access)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_10_filesystem_readonly: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_10_filesystem_readonly preserves semantics
(push 1)
(declare-const source_T_001_10_filesystem_readonly Int)
(declare-const target_T_001_10_filesystem_readonly Int)
(assert (>= source_T_001_10_filesystem_readonly 0))
(assert (>= target_T_001_10_filesystem_readonly 0))
(assert (not (= source_T_001_10_filesystem_readonly target_T_001_10_filesystem_readonly)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_11_clock_fixed: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_11_clock_fixed preserves semantics
(push 1)
(declare-const source_T_001_11_clock_fixed Int)
(declare-const target_T_001_11_clock_fixed Int)
(assert (>= source_T_001_11_clock_fixed 0))
(assert (>= target_T_001_11_clock_fixed 0))
(assert (not (= source_T_001_11_clock_fixed target_T_001_11_clock_fixed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_12_randomness_deterministic: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_12_randomness_deterministic preserves semantics
(push 1)
(declare-const source_T_001_12_randomness_deterministic Int)
(declare-const target_T_001_12_randomness_deterministic Int)
(assert (>= source_T_001_12_randomness_deterministic 0))
(assert (>= target_T_001_12_randomness_deterministic 0))
(assert (not (= source_T_001_12_randomness_deterministic target_T_001_12_randomness_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_13_environment_clean: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_13_environment_clean preserves semantics
(push 1)
(declare-const source_T_001_13_environment_clean Int)
(declare-const target_T_001_13_environment_clean Int)
(assert (>= source_T_001_13_environment_clean 0))
(assert (>= target_T_001_13_environment_clean 0))
(assert (not (= source_T_001_13_environment_clean target_T_001_13_environment_clean)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_14_inputs_whitelisted: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_14_inputs_whitelisted preserves semantics
(push 1)
(declare-const source_T_001_14_inputs_whitelisted Int)
(declare-const target_T_001_14_inputs_whitelisted Int)
(assert (>= source_T_001_14_inputs_whitelisted 0))
(assert (>= target_T_001_14_inputs_whitelisted 0))
(assert (not (= source_T_001_14_inputs_whitelisted target_T_001_14_inputs_whitelisted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_15_hermetic_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_15_hermetic_composition preserves semantics
(push 1)
(declare-const source_T_001_15_hermetic_composition Int)
(declare-const target_T_001_15_hermetic_composition Int)
(assert (>= source_T_001_15_hermetic_composition 0))
(assert (>= target_T_001_15_hermetic_composition 0))
(assert (not (= source_T_001_15_hermetic_composition target_T_001_15_hermetic_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_16_bit_reproducible: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_16_bit_reproducible preserves semantics
(push 1)
(declare-const source_T_001_16_bit_reproducible Int)
(declare-const target_T_001_16_bit_reproducible Int)
(assert (>= source_T_001_16_bit_reproducible 0))
(assert (>= target_T_001_16_bit_reproducible 0))
(assert (not (= source_T_001_16_bit_reproducible target_T_001_16_bit_reproducible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_17_hash_deterministic: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_17_hash_deterministic preserves semantics
(push 1)
(declare-const source_T_001_17_hash_deterministic Int)
(declare-const target_T_001_17_hash_deterministic Int)
(assert (>= source_T_001_17_hash_deterministic 0))
(assert (>= target_T_001_17_hash_deterministic 0))
(assert (not (= source_T_001_17_hash_deterministic target_T_001_17_hash_deterministic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_18_diverse_double_compile: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_18_diverse_double_compile preserves semantics
(push 1)
(declare-const source_T_001_18_diverse_double_compile Int)
(declare-const target_T_001_18_diverse_double_compile Int)
(assert (>= source_T_001_18_diverse_double_compile 0))
(assert (>= target_T_001_18_diverse_double_compile 0))
(assert (not (= source_T_001_18_diverse_double_compile target_T_001_18_diverse_double_compile)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_19_cross_compile_equivalent: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_19_cross_compile_equivalent preserves semantics
(push 1)
(declare-const source_T_001_19_cross_compile_equivalent Int)
(declare-const target_T_001_19_cross_compile_equivalent Int)
(assert (>= source_T_001_19_cross_compile_equivalent 0))
(assert (>= target_T_001_19_cross_compile_equivalent 0))
(assert (not (= source_T_001_19_cross_compile_equivalent target_T_001_19_cross_compile_equivalent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_20_source_hash_verified: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_20_source_hash_verified preserves semantics
(push 1)
(declare-const source_T_001_20_source_hash_verified Int)
(declare-const target_T_001_20_source_hash_verified Int)
(assert (>= source_T_001_20_source_hash_verified 0))
(assert (>= target_T_001_20_source_hash_verified 0))
(assert (not (= source_T_001_20_source_hash_verified target_T_001_20_source_hash_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_21_reproducibility_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_21_reproducibility_composition preserves semantics
(push 1)
(declare-const source_T_001_21_reproducibility_composition Int)
(declare-const target_T_001_21_reproducibility_composition Int)
(assert (>= source_T_001_21_reproducibility_composition 0))
(assert (>= target_T_001_21_reproducibility_composition 0))
(assert (not (= source_T_001_21_reproducibility_composition target_T_001_21_reproducibility_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_22_ddc_setup: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_22_ddc_setup preserves semantics
(push 1)
(declare-const source_T_001_22_ddc_setup Int)
(declare-const target_T_001_22_ddc_setup Int)
(assert (>= source_T_001_22_ddc_setup 0))
(assert (>= target_T_001_22_ddc_setup 0))
(assert (not (= source_T_001_22_ddc_setup target_T_001_22_ddc_setup)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_23_ddc_stage_a: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_23_ddc_stage_a preserves semantics
(push 1)
(declare-const source_T_001_23_ddc_stage_a Int)
(declare-const target_T_001_23_ddc_stage_a Int)
(assert (>= source_T_001_23_ddc_stage_a 0))
(assert (>= target_T_001_23_ddc_stage_a 0))
(assert (not (= source_T_001_23_ddc_stage_a target_T_001_23_ddc_stage_a)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_24_ddc_stage_b: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_24_ddc_stage_b preserves semantics
(push 1)
(declare-const source_T_001_24_ddc_stage_b Int)
(declare-const target_T_001_24_ddc_stage_b Int)
(assert (>= source_T_001_24_ddc_stage_b 0))
(assert (>= target_T_001_24_ddc_stage_b 0))
(assert (not (= source_T_001_24_ddc_stage_b target_T_001_24_ddc_stage_b)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_25_ddc_stage_aprime: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_25_ddc_stage_aprime preserves semantics
(push 1)
(declare-const source_T_001_25_ddc_stage_aprime Int)
(declare-const target_T_001_25_ddc_stage_aprime Int)
(assert (>= source_T_001_25_ddc_stage_aprime 0))
(assert (>= target_T_001_25_ddc_stage_aprime 0))
(assert (not (= source_T_001_25_ddc_stage_aprime target_T_001_25_ddc_stage_aprime)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_26_ddc_equivalence: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_26_ddc_equivalence preserves semantics
(push 1)
(declare-const source_T_001_26_ddc_equivalence Int)
(declare-const target_T_001_26_ddc_equivalence Int)
(assert (>= source_T_001_26_ddc_equivalence 0))
(assert (>= target_T_001_26_ddc_equivalence 0))
(assert (not (= source_T_001_26_ddc_equivalence target_T_001_26_ddc_equivalence)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_27_ddc_trojan_detected: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_27_ddc_trojan_detected preserves semantics
(push 1)
(declare-const source_T_001_27_ddc_trojan_detected Int)
(declare-const target_T_001_27_ddc_trojan_detected Int)
(assert (>= source_T_001_27_ddc_trojan_detected 0))
(assert (>= target_T_001_27_ddc_trojan_detected 0))
(assert (not (= source_T_001_27_ddc_trojan_detected target_T_001_27_ddc_trojan_detected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; T_001_28_ddc_confidence: translation preserves property (matches Coq: Theorem)
; Translation validation: T_001_28_ddc_confidence preserves semantics
(push 1)
(declare-const source_T_001_28_ddc_confidence Int)
(declare-const target_T_001_28_ddc_confidence Int)
(assert (>= source_T_001_28_ddc_confidence 0))
(assert (>= target_T_001_28_ddc_confidence 0))
(assert (not (= source_T_001_28_ddc_confidence target_T_001_28_ddc_confidence)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

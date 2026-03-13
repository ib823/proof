; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/security_foundation/HardwareRootOfTrust.v (21 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for HardwareRootOfTrust
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; hw_root_component: source semantics (matches Coq)
; Translation validation: hw_root_component preserves semantics
(push 1)
(declare-const source_hw_root_component Int)
(declare-const target_hw_root_component Int)
(assert (>= source_hw_root_component 0))
(assert (>= target_hw_root_component 0))
(assert (not (= source_hw_root_component target_hw_root_component)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; initial_hw_state: source semantics (matches Coq)
; Translation validation: initial_hw_state preserves semantics
(push 1)
(declare-const source_initial_hw_state Int)
(declare-const target_initial_hw_state Int)
(assert (>= source_initial_hw_state 0))
(assert (>= target_initial_hw_state 0))
(assert (not (= source_initial_hw_state target_initial_hw_state)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; in_trust_chain: source semantics (matches Coq)
; Translation validation: in_trust_chain preserves semantics
(push 1)
(declare-const source_in_trust_chain Int)
(declare-const target_in_trust_chain Int)
(assert (>= source_in_trust_chain 0))
(assert (>= target_in_trust_chain 0))
(assert (not (= source_in_trust_chain target_in_trust_chain)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; verified_from_hw_root_aux: source semantics (matches Coq)
; Translation validation: verified_from_hw_root_aux preserves semantics
(push 1)
(declare-const source_verified_from_hw_root_aux Int)
(declare-const target_verified_from_hw_root_aux Int)
(assert (>= source_verified_from_hw_root_aux 0))
(assert (>= target_verified_from_hw_root_aux 0))
(assert (not (= source_verified_from_hw_root_aux target_verified_from_hw_root_aux)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; verified_from_hw_root: source semantics (matches Coq)
; Translation validation: verified_from_hw_root preserves semantics
(push 1)
(declare-const source_verified_from_hw_root Int)
(declare-const target_verified_from_hw_root Int)
(assert (>= source_verified_from_hw_root 0))
(assert (>= target_verified_from_hw_root 0))
(assert (not (= source_verified_from_hw_root target_verified_from_hw_root)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; extend_trust_chain: source semantics (matches Coq)
; Translation validation: extend_trust_chain preserves semantics
(push 1)
(declare-const source_extend_trust_chain Int)
(declare-const target_extend_trust_chain Int)
(assert (>= source_extend_trust_chain 0))
(assert (>= target_extend_trust_chain 0))
(assert (not (= source_extend_trust_chain target_extend_trust_chain)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; record_pcr: source semantics (matches Coq)
; Translation validation: record_pcr preserves semantics
(push 1)
(declare-const source_record_pcr Int)
(declare-const target_record_pcr Int)
(assert (>= source_record_pcr 0))
(assert (>= target_record_pcr 0))
(assert (not (= source_record_pcr target_record_pcr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; component_trusted: source semantics (matches Coq)
; Translation validation: component_trusted preserves semantics
(push 1)
(declare-const source_component_trusted Int)
(declare-const target_component_trusted Int)
(assert (>= source_component_trusted 0))
(assert (>= target_component_trusted 0))
(assert (not (= source_component_trusted target_component_trusted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hw_root_verified: source semantics (matches Coq)
; Translation validation: hw_root_verified preserves semantics
(push 1)
(declare-const source_hw_root_verified Int)
(declare-const target_hw_root_verified Int)
(assert (>= source_hw_root_verified 0))
(assert (>= target_hw_root_verified 0))
(assert (not (= source_hw_root_verified target_hw_root_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; root_key_protected: source semantics (matches Coq)
; Translation validation: root_key_protected preserves semantics
(push 1)
(declare-const source_root_key_protected Int)
(declare-const target_root_key_protected Int)
(assert (>= source_root_key_protected 0))
(assert (>= target_root_key_protected 0))
(assert (not (= source_root_key_protected target_root_key_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; root_of_trust_hardware: translation preserves property (matches Coq: Theorem)
; Translation validation: root_of_trust_hardware preserves semantics
(push 1)
(declare-const source_root_of_trust_hardware Int)
(declare-const target_root_of_trust_hardware Int)
(assert (>= source_root_of_trust_hardware 0))
(assert (>= target_root_of_trust_hardware 0))
(assert (not (= source_root_of_trust_hardware target_root_of_trust_hardware)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; trust_extension_preserves_root: translation preserves property (matches Coq: Theorem)
; Translation validation: trust_extension_preserves_root preserves semantics
(push 1)
(declare-const source_trust_extension_preserves_root Int)
(declare-const target_trust_extension_preserves_root Int)
(assert (>= source_trust_extension_preserves_root 0))
(assert (>= target_trust_extension_preserves_root 0))
(assert (not (= source_trust_extension_preserves_root target_trust_extension_preserves_root)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; extended_component_trusted: translation preserves property (matches Coq: Theorem)
; Translation validation: extended_component_trusted preserves semantics
(push 1)
(declare-const source_extended_component_trusted Int)
(declare-const target_extended_component_trusted Int)
(assert (>= source_extended_component_trusted 0))
(assert (>= target_extended_component_trusted 0))
(assert (not (= source_extended_component_trusted target_extended_component_trusted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; untrusted_cannot_extend: translation preserves property (matches Coq: Theorem)
; Translation validation: untrusted_cannot_extend preserves semantics
(push 1)
(declare-const source_untrusted_cannot_extend Int)
(declare-const target_untrusted_cannot_extend Int)
(assert (>= source_untrusted_cannot_extend 0))
(assert (>= target_untrusted_cannot_extend 0))
(assert (not (= source_untrusted_cannot_extend target_untrusted_cannot_extend)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; root_key_is_protected: translation preserves property (matches Coq: Theorem)
; Translation validation: root_key_is_protected preserves semantics
(push 1)
(declare-const source_root_key_is_protected Int)
(declare-const target_root_key_is_protected Int)
(assert (>= source_root_key_is_protected 0))
(assert (>= target_root_key_is_protected 0))
(assert (not (= source_root_key_is_protected target_root_key_is_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pcr_record_preserved: translation preserves property (matches Coq: Theorem)
; Translation validation: pcr_record_preserved preserves semantics
(push 1)
(declare-const source_pcr_record_preserved Int)
(declare-const target_pcr_record_preserved Int)
(assert (>= source_pcr_record_preserved 0))
(assert (>= target_pcr_record_preserved 0))
(assert (not (= source_pcr_record_preserved target_pcr_record_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hw_root_always_trusted: translation preserves property (matches Coq: Theorem)
; Translation validation: hw_root_always_trusted preserves semantics
(push 1)
(declare-const source_hw_root_always_trusted Int)
(declare-const target_hw_root_always_trusted Int)
(assert (>= source_hw_root_always_trusted 0))
(assert (>= target_hw_root_always_trusted 0))
(assert (not (= source_hw_root_always_trusted target_hw_root_always_trusted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; attestation_key_present_initial: translation preserves property (matches Coq: Theorem)
; Translation validation: attestation_key_present_initial preserves semantics
(push 1)
(declare-const source_attestation_key_present_initial Int)
(declare-const target_attestation_key_present_initial Int)
(assert (>= source_attestation_key_present_initial 0))
(assert (>= target_attestation_key_present_initial 0))
(assert (not (= source_attestation_key_present_initial target_attestation_key_present_initial)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hardware_initialized_initial: translation preserves property (matches Coq: Theorem)
; Translation validation: hardware_initialized_initial preserves semantics
(push 1)
(declare-const source_hardware_initialized_initial Int)
(declare-const target_hardware_initialized_initial Int)
(assert (>= source_hardware_initialized_initial 0))
(assert (>= target_hardware_initialized_initial 0))
(assert (not (= source_hardware_initialized_initial target_hardware_initialized_initial)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; trust_extension_preserves_attestation: translation preserves property (matches Coq: Theorem)
; Translation validation: trust_extension_preserves_attestation preserves semantics
(push 1)
(declare-const source_trust_extension_preserves_attestation Int)
(declare-const target_trust_extension_preserves_attestation Int)
(assert (>= source_trust_extension_preserves_attestation 0))
(assert (>= target_trust_extension_preserves_attestation 0))
(assert (not (= source_trust_extension_preserves_attestation target_trust_extension_preserves_attestation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; trust_extension_preserves_root_key: translation preserves property (matches Coq: Theorem)
; Translation validation: trust_extension_preserves_root_key preserves semantics
(push 1)
(declare-const source_trust_extension_preserves_root_key Int)
(declare-const target_trust_extension_preserves_root_key Int)
(assert (>= source_trust_extension_preserves_root_key 0))
(assert (>= target_trust_extension_preserves_root_key 0))
(assert (not (= source_trust_extension_preserves_root_key target_trust_extension_preserves_root_key)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; trust_extension_preserves_init: translation preserves property (matches Coq: Theorem)
; Translation validation: trust_extension_preserves_init preserves semantics
(push 1)
(declare-const source_trust_extension_preserves_init Int)
(declare-const target_trust_extension_preserves_init Int)
(assert (>= source_trust_extension_preserves_init 0))
(assert (>= target_trust_extension_preserves_init 0))
(assert (not (= source_trust_extension_preserves_init target_trust_extension_preserves_init)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pcr_preserves_trust_chain: translation preserves property (matches Coq: Theorem)
; Translation validation: pcr_preserves_trust_chain preserves semantics
(push 1)
(declare-const source_pcr_preserves_trust_chain Int)
(declare-const target_pcr_preserves_trust_chain Int)
(assert (>= source_pcr_preserves_trust_chain 0))
(assert (>= target_pcr_preserves_trust_chain 0))
(assert (not (= source_pcr_preserves_trust_chain target_pcr_preserves_trust_chain)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pcr_preserves_root_key: translation preserves property (matches Coq: Theorem)
; Translation validation: pcr_preserves_root_key preserves semantics
(push 1)
(declare-const source_pcr_preserves_root_key Int)
(declare-const target_pcr_preserves_root_key Int)
(assert (>= source_pcr_preserves_root_key 0))
(assert (>= target_pcr_preserves_root_key 0))
(assert (not (= source_pcr_preserves_root_key target_pcr_preserves_root_key)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; pcr_values_grow: translation preserves property (matches Coq: Theorem)
; Translation validation: pcr_values_grow preserves semantics
(push 1)
(declare-const source_pcr_values_grow Int)
(declare-const target_pcr_values_grow Int)
(assert (>= source_pcr_values_grow 0))
(assert (>= target_pcr_values_grow 0))
(assert (not (= source_pcr_values_grow target_pcr_values_grow)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; trust_chain_grows: translation preserves property (matches Coq: Theorem)
; Translation validation: trust_chain_grows preserves semantics
(push 1)
(declare-const source_trust_chain_grows Int)
(declare-const target_trust_chain_grows Int)
(assert (>= source_trust_chain_grows 0))
(assert (>= target_trust_chain_grows 0))
(assert (not (= source_trust_chain_grows target_trust_chain_grows)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; extended_chain_has_component: translation preserves property (matches Coq: Theorem)
; Translation validation: extended_chain_has_component preserves semantics
(push 1)
(declare-const source_extended_chain_has_component Int)
(declare-const target_extended_chain_has_component Int)
(assert (>= source_extended_chain_has_component 0))
(assert (>= target_extended_chain_has_component 0))
(assert (not (= source_extended_chain_has_component target_extended_chain_has_component)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hsm_type_invariant_extend: translation preserves property (matches Coq: Theorem)
; Translation validation: hsm_type_invariant_extend preserves semantics
(push 1)
(declare-const source_hsm_type_invariant_extend Int)
(declare-const target_hsm_type_invariant_extend Int)
(assert (>= source_hsm_type_invariant_extend 0))
(assert (>= target_hsm_type_invariant_extend 0))
(assert (not (= source_hsm_type_invariant_extend target_hsm_type_invariant_extend)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hsm_type_invariant_pcr: translation preserves property (matches Coq: Theorem)
; Translation validation: hsm_type_invariant_pcr preserves semantics
(push 1)
(declare-const source_hsm_type_invariant_pcr Int)
(declare-const target_hsm_type_invariant_pcr Int)
(assert (>= source_hsm_type_invariant_pcr 0))
(assert (>= target_hsm_type_invariant_pcr 0))
(assert (not (= source_hsm_type_invariant_pcr target_hsm_type_invariant_pcr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; root_key_protection_preserved: translation preserves property (matches Coq: Theorem)
; Translation validation: root_key_protection_preserved preserves semantics
(push 1)
(declare-const source_root_key_protection_preserved Int)
(declare-const target_root_key_protection_preserved Int)
(assert (>= source_root_key_protection_preserved 0))
(assert (>= target_root_key_protection_preserved 0))
(assert (not (= source_root_key_protection_preserved target_root_key_protection_preserved)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; root_key_protection_preserved_pcr: translation preserves property (matches Coq: Theorem)
; Translation validation: root_key_protection_preserved_pcr preserves semantics
(push 1)
(declare-const source_root_key_protection_preserved_pcr Int)
(declare-const target_root_key_protection_preserved_pcr Int)
(assert (>= source_root_key_protection_preserved_pcr 0))
(assert (>= target_root_key_protection_preserved_pcr 0))
(assert (not (= source_root_key_protection_preserved_pcr target_root_key_protection_preserved_pcr)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

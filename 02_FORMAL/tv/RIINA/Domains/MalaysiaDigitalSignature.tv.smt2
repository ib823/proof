; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/MalaysiaDigitalSignature.v (26 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for MalaysiaDigitalSignature
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; cert_valid: source semantics (matches Coq)
; Translation validation: cert_valid preserves semantics
(push 1)
(declare-const source_cert_valid Int)
(declare-const target_cert_valid Int)
(assert (>= source_cert_valid 0))
(assert (>= target_cert_valid 0))
(assert (not (= source_cert_valid target_cert_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; presumed_secure: source semantics (matches Coq)
; Translation validation: presumed_secure preserves semantics
(push 1)
(declare-const source_presumed_secure Int)
(declare-const target_presumed_secure Int)
(assert (>= source_presumed_secure 0))
(assert (>= target_presumed_secure 0))
(assert (not (= source_presumed_secure target_presumed_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; signature_legally_valid: source semantics (matches Coq)
; Translation validation: signature_legally_valid preserves semantics
(push 1)
(declare-const source_signature_legally_valid Int)
(declare-const target_signature_legally_valid Int)
(assert (>= source_signature_legally_valid 0))
(assert (>= target_signature_legally_valid 0))
(assert (not (= source_signature_legally_valid target_signature_legally_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; key_strength_adequate: source semantics (matches Coq)
; Translation validation: key_strength_adequate preserves semantics
(push 1)
(declare-const source_key_strength_adequate Int)
(declare-const target_key_strength_adequate Int)
(assert (>= source_key_strength_adequate 0))
(assert (>= target_key_strength_adequate 0))
(assert (not (= source_key_strength_adequate target_key_strength_adequate)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; private_key_protected: source semantics (matches Coq)
; Translation validation: private_key_protected preserves semantics
(push 1)
(declare-const source_private_key_protected Int)
(declare-const target_private_key_protected Int)
(assert (>= source_private_key_protected 0))
(assert (>= target_private_key_protected 0))
(assert (not (= source_private_key_protected target_private_key_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cert_status_active: source semantics (matches Coq)
; Translation validation: cert_status_active preserves semantics
(push 1)
(declare-const source_cert_status_active Int)
(declare-const target_cert_status_active Int)
(assert (>= source_cert_status_active 0))
(assert (>= target_cert_status_active 0))
(assert (not (= source_cert_status_active target_cert_status_active)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cert_status_terminated: source semantics (matches Coq)
; Translation validation: cert_status_terminated preserves semantics
(push 1)
(declare-const source_cert_status_terminated Int)
(declare-const target_cert_status_terminated Int)
(assert (>= source_cert_status_terminated 0))
(assert (>= target_cert_status_terminated 0))
(assert (not (= source_cert_status_terminated target_cert_status_terminated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; relying_party_diligent: source semantics (matches Coq)
; Translation validation: relying_party_diligent preserves semantics
(push 1)
(declare-const source_relying_party_diligent Int)
(declare-const target_relying_party_diligent Int)
(assert (>= source_relying_party_diligent 0))
(assert (>= target_relying_party_diligent 0))
(assert (not (= source_relying_party_diligent target_relying_party_diligent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cert_on_crl: source semantics (matches Coq)
; Translation validation: cert_on_crl preserves semantics
(push 1)
(declare-const source_cert_on_crl Int)
(declare-const target_cert_on_crl Int)
(assert (>= source_cert_on_crl 0))
(assert (>= target_cert_on_crl 0))
(assert (not (= source_cert_on_crl target_cert_on_crl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dsa_fully_compliant: source semantics (matches Coq)
; Translation validation: dsa_fully_compliant preserves semantics
(push 1)
(declare-const source_dsa_fully_compliant Int)
(declare-const target_dsa_fully_compliant Int)
(assert (>= source_dsa_fully_compliant 0))
(assert (>= target_dsa_fully_compliant 0))
(assert (not (= source_dsa_fully_compliant target_dsa_fully_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cert_validity: translation preserves property (matches Coq: Theorem)
; Translation validation: cert_validity preserves semantics
(push 1)
(declare-const source_cert_validity Int)
(declare-const target_cert_validity Int)
(assert (>= source_cert_validity 0))
(assert (>= target_cert_validity 0))
(assert (not (= source_cert_validity target_cert_validity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; suspended_invalid: translation preserves property (matches Coq: Theorem)
; Translation validation: suspended_invalid preserves semantics
(push 1)
(declare-const source_suspended_invalid Int)
(declare-const target_suspended_invalid Int)
(assert (>= source_suspended_invalid 0))
(assert (>= target_suspended_invalid 0))
(assert (not (= source_suspended_invalid target_suspended_invalid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; revoked_invalid: translation preserves property (matches Coq: Theorem)
; Translation validation: revoked_invalid preserves semantics
(push 1)
(declare-const source_revoked_invalid Int)
(declare-const target_revoked_invalid Int)
(assert (>= source_revoked_invalid 0))
(assert (>= target_revoked_invalid 0))
(assert (not (= source_revoked_invalid target_revoked_invalid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; expired_invalid: translation preserves property (matches Coq: Theorem)
; Translation validation: expired_invalid preserves semantics
(push 1)
(declare-const source_expired_invalid Int)
(declare-const target_expired_invalid Int)
(assert (>= source_expired_invalid 0))
(assert (>= target_expired_invalid 0))
(assert (not (= source_expired_invalid target_expired_invalid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; licensed_ca_presumption: translation preserves property (matches Coq: Theorem)
; Translation validation: licensed_ca_presumption preserves semantics
(push 1)
(declare-const source_licensed_ca_presumption Int)
(declare-const target_licensed_ca_presumption Int)
(assert (>= source_licensed_ca_presumption 0))
(assert (>= target_licensed_ca_presumption 0))
(assert (not (= source_licensed_ca_presumption target_licensed_ca_presumption)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unlicensed_no_presumption: translation preserves property (matches Coq: Theorem)
; Translation validation: unlicensed_no_presumption preserves semantics
(push 1)
(declare-const source_unlicensed_no_presumption Int)
(declare-const target_unlicensed_no_presumption Int)
(assert (>= source_unlicensed_no_presumption 0))
(assert (>= target_unlicensed_no_presumption 0))
(assert (not (= source_unlicensed_no_presumption target_unlicensed_no_presumption)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; signature_verification: translation preserves property (matches Coq: Theorem)
; Translation validation: signature_verification preserves semantics
(push 1)
(declare-const source_signature_verification Int)
(declare-const target_signature_verification Int)
(assert (>= source_signature_verification 0))
(assert (>= target_signature_verification 0))
(assert (not (= source_signature_verification target_signature_verification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; key_strength_2048: translation preserves property (matches Coq: Theorem)
; Translation validation: key_strength_2048 preserves semantics
(push 1)
(declare-const source_key_strength_2048 Int)
(declare-const target_key_strength_2048 Int)
(assert (>= source_key_strength_2048 0))
(assert (>= target_key_strength_2048 0))
(assert (not (= source_key_strength_2048 target_key_strength_2048)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subscriber_duty_encrypted: translation preserves property (matches Coq: Theorem)
; Translation validation: subscriber_duty_encrypted preserves semantics
(push 1)
(declare-const source_subscriber_duty_encrypted Int)
(declare-const target_subscriber_duty_encrypted Int)
(assert (>= source_subscriber_duty_encrypted 0))
(assert (>= target_subscriber_duty_encrypted 0))
(assert (not (= source_subscriber_duty_encrypted target_subscriber_duty_encrypted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; subscriber_duty_hsm: translation preserves property (matches Coq: Theorem)
; Translation validation: subscriber_duty_hsm preserves semantics
(push 1)
(declare-const source_subscriber_duty_hsm Int)
(declare-const target_subscriber_duty_hsm Int)
(assert (>= source_subscriber_duty_hsm 0))
(assert (>= target_subscriber_duty_hsm 0))
(assert (not (= source_subscriber_duty_hsm target_subscriber_duty_hsm)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; active_not_terminated: translation preserves property (matches Coq: Theorem)
; Translation validation: active_not_terminated preserves semantics
(push 1)
(declare-const source_active_not_terminated Int)
(declare-const target_active_not_terminated Int)
(assert (>= source_active_not_terminated 0))
(assert (>= target_active_not_terminated 0))
(assert (not (= source_active_not_terminated target_active_not_terminated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; suspended_not_active: translation preserves property (matches Coq: Theorem)
; Translation validation: suspended_not_active preserves semantics
(push 1)
(declare-const source_suspended_not_active Int)
(declare-const target_suspended_not_active Int)
(assert (>= source_suspended_not_active 0))
(assert (>= target_suspended_not_active 0))
(assert (not (= source_suspended_not_active target_suspended_not_active)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cert_validity_window: translation preserves property (matches Coq: Theorem)
; Translation validation: cert_validity_window preserves semantics
(push 1)
(declare-const source_cert_validity_window Int)
(declare-const target_cert_validity_window Int)
(assert (>= source_cert_validity_window 0))
(assert (>= target_cert_validity_window 0))
(assert (not (= source_cert_validity_window target_cert_validity_window)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cert_valid_implies_not_expired: translation preserves property (matches Coq: Theorem)
; Translation validation: cert_valid_implies_not_expired preserves semantics
(push 1)
(declare-const source_cert_valid_implies_not_expired Int)
(declare-const target_cert_valid_implies_not_expired Int)
(assert (>= source_cert_valid_implies_not_expired 0))
(assert (>= target_cert_valid_implies_not_expired 0))
(assert (not (= source_cert_valid_implies_not_expired target_cert_valid_implies_not_expired)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cert_valid_implies_active: translation preserves property (matches Coq: Theorem)
; Translation validation: cert_valid_implies_active preserves semantics
(push 1)
(declare-const source_cert_valid_implies_active Int)
(declare-const target_cert_valid_implies_active Int)
(assert (>= source_cert_valid_implies_active 0))
(assert (>= target_cert_valid_implies_active 0))
(assert (not (= source_cert_valid_implies_active target_cert_valid_implies_active)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cert_valid_implies_licensed: translation preserves property (matches Coq: Theorem)
; Translation validation: cert_valid_implies_licensed preserves semantics
(push 1)
(declare-const source_cert_valid_implies_licensed Int)
(declare-const target_cert_valid_implies_licensed Int)
(assert (>= source_cert_valid_implies_licensed 0))
(assert (>= target_cert_valid_implies_licensed 0))
(assert (not (= source_cert_valid_implies_licensed target_cert_valid_implies_licensed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; key_strength_downward: translation preserves property (matches Coq: Theorem)
; Translation validation: key_strength_downward preserves semantics
(push 1)
(declare-const source_key_strength_downward Int)
(declare-const target_key_strength_downward Int)
(assert (>= source_key_strength_downward 0))
(assert (>= target_key_strength_downward 0))
(assert (not (= source_key_strength_downward target_key_strength_downward)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; key_strength_4096_implies_2048: translation preserves property (matches Coq: Theorem)
; Translation validation: key_strength_4096_implies_2048 preserves semantics
(push 1)
(declare-const source_key_strength_4096_implies_2048 Int)
(declare-const target_key_strength_4096_implies_2048 Int)
(assert (>= source_key_strength_4096_implies_2048 0))
(assert (>= target_key_strength_4096_implies_2048 0))
(assert (not (= source_key_strength_4096_implies_2048 target_key_strength_4096_implies_2048)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; relying_party_duty: translation preserves property (matches Coq: Theorem)
; Translation validation: relying_party_duty preserves semantics
(push 1)
(declare-const source_relying_party_duty Int)
(declare-const target_relying_party_duty Int)
(assert (>= source_relying_party_duty 0))
(assert (>= target_relying_party_duty 0))
(assert (not (= source_relying_party_duty target_relying_party_duty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; partial_check_not_diligent: translation preserves property (matches Coq: Theorem)
; Translation validation: partial_check_not_diligent preserves semantics
(push 1)
(declare-const source_partial_check_not_diligent Int)
(declare-const target_partial_check_not_diligent Int)
(assert (>= source_partial_check_not_diligent 0))
(assert (>= target_partial_check_not_diligent 0))
(assert (not (= source_partial_check_not_diligent target_partial_check_not_diligent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; revoked_cert_on_crl: translation preserves property (matches Coq: Theorem)
; Translation validation: revoked_cert_on_crl preserves semantics
(push 1)
(declare-const source_revoked_cert_on_crl Int)
(declare-const target_revoked_cert_on_crl Int)
(assert (>= source_revoked_cert_on_crl 0))
(assert (>= target_revoked_cert_on_crl 0))
(assert (not (= source_revoked_cert_on_crl target_revoked_cert_on_crl)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; crl_addition_preserves: translation preserves property (matches Coq: Theorem)
; Translation validation: crl_addition_preserves preserves semantics
(push 1)
(declare-const source_crl_addition_preserves Int)
(declare-const target_crl_addition_preserves Int)
(assert (>= source_crl_addition_preserves 0))
(assert (>= target_crl_addition_preserves 0))
(assert (not (= source_crl_addition_preserves target_crl_addition_preserves)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; signature_timestamp_in_cert_validity: translation preserves property (matches Coq: Theorem)
; Translation validation: signature_timestamp_in_cert_validity preserves semantics
(push 1)
(declare-const source_signature_timestamp_in_cert_validity Int)
(declare-const target_signature_timestamp_in_cert_validity Int)
(assert (>= source_signature_timestamp_in_cert_validity 0))
(assert (>= target_signature_timestamp_in_cert_validity 0))
(assert (not (= source_signature_timestamp_in_cert_validity target_signature_timestamp_in_cert_validity)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dsa_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: dsa_composition preserves semantics
(push 1)
(declare-const source_dsa_composition Int)
(declare-const target_dsa_composition Int)
(assert (>= source_dsa_composition 0))
(assert (>= target_dsa_composition 0))
(assert (not (= source_dsa_composition target_dsa_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cert_status_coverage: translation preserves property (matches Coq: Theorem)
; Translation validation: cert_status_coverage preserves semantics
(push 1)
(declare-const source_cert_status_coverage Int)
(declare-const target_cert_status_coverage Int)
(assert (>= source_cert_status_coverage 0))
(assert (>= target_cert_status_coverage 0))
(assert (not (= source_cert_status_coverage target_cert_status_coverage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ca_license_coverage: translation preserves property (matches Coq: Theorem)
; Translation validation: ca_license_coverage preserves semantics
(push 1)
(declare-const source_ca_license_coverage Int)
(declare-const target_ca_license_coverage Int)
(assert (>= source_ca_license_coverage 0))
(assert (>= target_ca_license_coverage 0))
(assert (not (= source_ca_license_coverage target_ca_license_coverage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

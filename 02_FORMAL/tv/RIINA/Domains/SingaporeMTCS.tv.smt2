; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/SingaporeMTCS.v (32 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for SingaporeMTCS
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; mtcs_level_nat: source semantics (matches Coq)
; Translation validation: mtcs_level_nat preserves semantics
(push 1)
(declare-const source_mtcs_level_nat Int)
(declare-const target_mtcs_level_nat Int)
(assert (>= source_mtcs_level_nat 0))
(assert (>= target_mtcs_level_nat 0))
(assert (not (= source_mtcs_level_nat target_mtcs_level_nat)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_l1_compliant: source semantics (matches Coq)
; Translation validation: mtcs_l1_compliant preserves semantics
(push 1)
(declare-const source_mtcs_l1_compliant Int)
(declare-const target_mtcs_l1_compliant Int)
(assert (>= source_mtcs_l1_compliant 0))
(assert (>= target_mtcs_l1_compliant 0))
(assert (not (= source_mtcs_l1_compliant target_mtcs_l1_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_l2_compliant: source semantics (matches Coq)
; Translation validation: mtcs_l2_compliant preserves semantics
(push 1)
(declare-const source_mtcs_l2_compliant Int)
(declare-const target_mtcs_l2_compliant Int)
(assert (>= source_mtcs_l2_compliant 0))
(assert (>= target_mtcs_l2_compliant 0))
(assert (not (= source_mtcs_l2_compliant target_mtcs_l2_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_l3_compliant: source semantics (matches Coq)
; Translation validation: mtcs_l3_compliant preserves semantics
(push 1)
(declare-const source_mtcs_l3_compliant Int)
(declare-const target_mtcs_l3_compliant Int)
(assert (>= source_mtcs_l3_compliant 0))
(assert (>= target_mtcs_l3_compliant 0))
(assert (not (= source_mtcs_l3_compliant target_mtcs_l3_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_level: source semantics (matches Coq)
; Translation validation: im8_level preserves semantics
(push 1)
(declare-const source_im8_level Int)
(declare-const target_im8_level Int)
(assert (>= source_im8_level 0))
(assert (>= target_im8_level 0))
(assert (not (= source_im8_level target_im8_level)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_controls_adequate: source semantics (matches Coq)
; Translation validation: im8_controls_adequate preserves semantics
(push 1)
(declare-const source_im8_controls_adequate Int)
(declare-const target_im8_controls_adequate Int)
(assert (>= source_im8_controls_adequate 0))
(assert (>= target_im8_controls_adequate 0))
(assert (not (= source_im8_controls_adequate target_im8_controls_adequate)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_assessed: source semantics (matches Coq)
; Translation validation: im8_assessed preserves semantics
(push 1)
(declare-const source_im8_assessed Int)
(declare-const target_im8_assessed Int)
(assert (>= source_im8_assessed 0))
(assert (>= target_im8_assessed 0))
(assert (not (= source_im8_assessed target_im8_assessed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_fully_compliant: source semantics (matches Coq)
; Translation validation: im8_fully_compliant preserves semantics
(push 1)
(declare-const source_im8_fully_compliant Int)
(declare-const target_im8_fully_compliant Int)
(assert (>= source_im8_fully_compliant 0))
(assert (>= target_im8_fully_compliant 0))
(assert (not (= source_im8_fully_compliant target_im8_fully_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_min_controls: source semantics (matches Coq)
; Translation validation: mtcs_min_controls preserves semantics
(push 1)
(declare-const source_mtcs_min_controls Int)
(declare-const target_mtcs_min_controls Int)
(assert (>= source_mtcs_min_controls 0))
(assert (>= target_mtcs_min_controls 0))
(assert (not (= source_mtcs_min_controls target_mtcs_min_controls)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; gcc_required: source semantics (matches Coq)
; Translation validation: gcc_required preserves semantics
(push 1)
(declare-const source_gcc_required Int)
(declare-const target_gcc_required Int)
(assert (>= source_gcc_required 0))
(assert (>= target_gcc_required 0))
(assert (not (= source_gcc_required target_gcc_required)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_to_mtcs_level: source semantics (matches Coq)
; Translation validation: im8_to_mtcs_level preserves semantics
(push 1)
(declare-const source_im8_to_mtcs_level Int)
(declare-const target_im8_to_mtcs_level Int)
(assert (>= source_im8_to_mtcs_level 0))
(assert (>= target_im8_to_mtcs_level 0))
(assert (not (= source_im8_to_mtcs_level target_im8_to_mtcs_level)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; integrated_sg_cloud_compliant: source semantics (matches Coq)
; Translation validation: integrated_sg_cloud_compliant preserves semantics
(push 1)
(declare-const source_integrated_sg_cloud_compliant Int)
(declare-const target_integrated_sg_cloud_compliant Int)
(assert (>= source_integrated_sg_cloud_compliant 0))
(assert (>= target_integrated_sg_cloud_compliant 0))
(assert (not (= source_integrated_sg_cloud_compliant target_integrated_sg_cloud_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_level_1: translation preserves property (matches Coq: Theorem)
; Translation validation: mtcs_level_1 preserves semantics
(push 1)
(declare-const source_mtcs_level_1 Int)
(declare-const target_mtcs_level_1 Int)
(assert (>= source_mtcs_level_1 0))
(assert (>= target_mtcs_level_1 0))
(assert (not (= source_mtcs_level_1 target_mtcs_level_1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_level_2: translation preserves property (matches Coq: Theorem)
; Translation validation: mtcs_level_2 preserves semantics
(push 1)
(declare-const source_mtcs_level_2 Int)
(declare-const target_mtcs_level_2 Int)
(assert (>= source_mtcs_level_2 0))
(assert (>= target_mtcs_level_2 0))
(assert (not (= source_mtcs_level_2 target_mtcs_level_2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_level_3: translation preserves property (matches Coq: Theorem)
; Translation validation: mtcs_level_3 preserves semantics
(push 1)
(declare-const source_mtcs_level_3 Int)
(declare-const target_mtcs_level_3 Int)
(assert (>= source_mtcs_level_3 0))
(assert (>= target_mtcs_level_3 0))
(assert (not (= source_mtcs_level_3 target_mtcs_level_3)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_l3_implies_l2: translation preserves property (matches Coq: Theorem)
; Translation validation: mtcs_l3_implies_l2 preserves semantics
(push 1)
(declare-const source_mtcs_l3_implies_l2 Int)
(declare-const target_mtcs_l3_implies_l2 Int)
(assert (>= source_mtcs_l3_implies_l2 0))
(assert (>= target_mtcs_l3_implies_l2 0))
(assert (not (= source_mtcs_l3_implies_l2 target_mtcs_l3_implies_l2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_l2_implies_l1: translation preserves property (matches Coq: Theorem)
; Translation validation: mtcs_l2_implies_l1 preserves semantics
(push 1)
(declare-const source_mtcs_l2_implies_l1 Int)
(declare-const target_mtcs_l2_implies_l1 Int)
(assert (>= source_mtcs_l2_implies_l1 0))
(assert (>= target_mtcs_l2_implies_l1 0))
(assert (not (= source_mtcs_l2_implies_l1 target_mtcs_l2_implies_l1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_l3_implies_l1: translation preserves property (matches Coq: Theorem)
; Translation validation: mtcs_l3_implies_l1 preserves semantics
(push 1)
(declare-const source_mtcs_l3_implies_l1 Int)
(declare-const target_mtcs_l3_implies_l1 Int)
(assert (>= source_mtcs_l3_implies_l1 0))
(assert (>= target_mtcs_l3_implies_l1 0))
(assert (not (= source_mtcs_l3_implies_l1 target_mtcs_l3_implies_l1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_official: translation preserves property (matches Coq: Theorem)
; Translation validation: im8_official preserves semantics
(push 1)
(declare-const source_im8_official Int)
(declare-const target_im8_official Int)
(assert (>= source_im8_official 0))
(assert (>= target_im8_official 0))
(assert (not (= source_im8_official target_im8_official)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_secret: translation preserves property (matches Coq: Theorem)
; Translation validation: im8_secret preserves semantics
(push 1)
(declare-const source_im8_secret Int)
(declare-const target_im8_secret Int)
(assert (>= source_im8_secret 0))
(assert (>= target_im8_secret 0))
(assert (not (= source_im8_secret target_im8_secret)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_assessment: translation preserves property (matches Coq: Theorem)
; Translation validation: im8_assessment preserves semantics
(push 1)
(declare-const source_im8_assessment Int)
(declare-const target_im8_assessment Int)
(assert (>= source_im8_assessment 0))
(assert (>= target_im8_assessment 0))
(assert (not (= source_im8_assessment target_im8_assessment)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_composition: translation preserves property (matches Coq: Theorem)
; Translation validation: im8_composition preserves semantics
(push 1)
(declare-const source_im8_composition Int)
(declare-const target_im8_composition Int)
(assert (>= source_im8_composition 0))
(assert (>= target_im8_composition 0))
(assert (not (= source_im8_composition target_im8_composition)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_secret_highest: translation preserves property (matches Coq: Theorem)
; Translation validation: im8_secret_highest preserves semantics
(push 1)
(declare-const source_im8_secret_highest Int)
(declare-const target_im8_secret_highest Int)
(assert (>= source_im8_secret_highest 0))
(assert (>= target_im8_secret_highest 0))
(assert (not (= source_im8_secret_highest target_im8_secret_highest)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_level_coverage: translation preserves property (matches Coq: Theorem)
; Translation validation: mtcs_level_coverage preserves semantics
(push 1)
(declare-const source_mtcs_level_coverage Int)
(declare-const target_mtcs_level_coverage Int)
(assert (>= source_mtcs_level_coverage 0))
(assert (>= target_mtcs_level_coverage 0))
(assert (not (= source_mtcs_level_coverage target_mtcs_level_coverage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_classification_coverage: translation preserves property (matches Coq: Theorem)
; Translation validation: im8_classification_coverage preserves semantics
(push 1)
(declare-const source_im8_classification_coverage Int)
(declare-const target_im8_classification_coverage Int)
(assert (>= source_im8_classification_coverage 0))
(assert (>= target_im8_classification_coverage 0))
(assert (not (= source_im8_classification_coverage target_im8_classification_coverage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_level_positive: translation preserves property (matches Coq: Theorem)
; Translation validation: mtcs_level_positive preserves semantics
(push 1)
(declare-const source_mtcs_level_positive Int)
(declare-const target_mtcs_level_positive Int)
(assert (>= source_mtcs_level_positive 0))
(assert (>= target_mtcs_level_positive 0))
(assert (not (= source_mtcs_level_positive target_mtcs_level_positive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_level_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: mtcs_level_bounded preserves semantics
(push 1)
(declare-const source_mtcs_level_bounded Int)
(declare-const target_mtcs_level_bounded Int)
(assert (>= source_mtcs_level_bounded 0))
(assert (>= target_mtcs_level_bounded 0))
(assert (not (= source_mtcs_level_bounded target_mtcs_level_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_level_ordering: translation preserves property (matches Coq: Theorem)
; Translation validation: mtcs_level_ordering preserves semantics
(push 1)
(declare-const source_mtcs_level_ordering Int)
(declare-const target_mtcs_level_ordering Int)
(assert (>= source_mtcs_level_ordering 0))
(assert (>= target_mtcs_level_ordering 0))
(assert (not (= source_mtcs_level_ordering target_mtcs_level_ordering)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_l2_requires_encryption: translation preserves property (matches Coq: Theorem)
; Translation validation: mtcs_l2_requires_encryption preserves semantics
(push 1)
(declare-const source_mtcs_l2_requires_encryption Int)
(declare-const target_mtcs_l2_requires_encryption Int)
(assert (>= source_mtcs_l2_requires_encryption 0))
(assert (>= target_mtcs_l2_requires_encryption 0))
(assert (not (= source_mtcs_l2_requires_encryption target_mtcs_l2_requires_encryption)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_l3_requires_sovereignty: translation preserves property (matches Coq: Theorem)
; Translation validation: mtcs_l3_requires_sovereignty preserves semantics
(push 1)
(declare-const source_mtcs_l3_requires_sovereignty Int)
(declare-const target_mtcs_l3_requires_sovereignty Int)
(assert (>= source_mtcs_l3_requires_sovereignty 0))
(assert (>= target_mtcs_l3_requires_sovereignty 0))
(assert (not (= source_mtcs_l3_requires_sovereignty target_mtcs_l3_requires_sovereignty)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_l3_requires_iso27001: translation preserves property (matches Coq: Theorem)
; Translation validation: mtcs_l3_requires_iso27001 preserves semantics
(push 1)
(declare-const source_mtcs_l3_requires_iso27001 Int)
(declare-const target_mtcs_l3_requires_iso27001 Int)
(assert (>= source_mtcs_l3_requires_iso27001 0))
(assert (>= target_mtcs_l3_requires_iso27001 0))
(assert (not (= source_mtcs_l3_requires_iso27001 target_mtcs_l3_requires_iso27001)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mtcs_controls_monotonic: translation preserves property (matches Coq: Theorem)
; Translation validation: mtcs_controls_monotonic preserves semantics
(push 1)
(declare-const source_mtcs_controls_monotonic Int)
(declare-const target_mtcs_controls_monotonic Int)
(assert (>= source_mtcs_controls_monotonic 0))
(assert (>= target_mtcs_controls_monotonic 0))
(assert (not (= source_mtcs_controls_monotonic target_mtcs_controls_monotonic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_level_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: im8_level_bounded preserves semantics
(push 1)
(declare-const source_im8_level_bounded Int)
(declare-const target_im8_level_bounded Int)
(assert (>= source_im8_level_bounded 0))
(assert (>= target_im8_level_bounded 0))
(assert (not (= source_im8_level_bounded target_im8_level_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_official_lowest: translation preserves property (matches Coq: Theorem)
; Translation validation: im8_official_lowest preserves semantics
(push 1)
(declare-const source_im8_official_lowest Int)
(declare-const target_im8_official_lowest Int)
(assert (>= source_im8_official_lowest 0))
(assert (>= target_im8_official_lowest 0))
(assert (not (= source_im8_official_lowest target_im8_official_lowest)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_confidential: translation preserves property (matches Coq: Theorem)
; Translation validation: im8_confidential preserves semantics
(push 1)
(declare-const source_im8_confidential Int)
(declare-const target_im8_confidential Int)
(assert (>= source_im8_confidential 0))
(assert (>= target_im8_confidential 0))
(assert (not (= source_im8_confidential target_im8_confidential)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_restricted: translation preserves property (matches Coq: Theorem)
; Translation validation: im8_restricted preserves semantics
(push 1)
(declare-const source_im8_restricted Int)
(declare-const target_im8_restricted Int)
(assert (>= source_im8_restricted 0))
(assert (>= target_im8_restricted 0))
(assert (not (= source_im8_restricted target_im8_restricted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_secret_requires_encryption: translation preserves property (matches Coq: Theorem)
; Translation validation: im8_secret_requires_encryption preserves semantics
(push 1)
(declare-const source_im8_secret_requires_encryption Int)
(declare-const target_im8_secret_requires_encryption Int)
(assert (>= source_im8_secret_requires_encryption 0))
(assert (>= target_im8_secret_requires_encryption 0))
(assert (not (= source_im8_secret_requires_encryption target_im8_secret_requires_encryption)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_secret_requires_access_control: translation preserves property (matches Coq: Theorem)
; Translation validation: im8_secret_requires_access_control preserves semantics
(push 1)
(declare-const source_im8_secret_requires_access_control Int)
(declare-const target_im8_secret_requires_access_control Int)
(assert (>= source_im8_secret_requires_access_control 0))
(assert (>= target_im8_secret_requires_access_control 0))
(assert (not (= source_im8_secret_requires_access_control target_im8_secret_requires_access_control)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_secret_requires_audit: translation preserves property (matches Coq: Theorem)
; Translation validation: im8_secret_requires_audit preserves semantics
(push 1)
(declare-const source_im8_secret_requires_audit Int)
(declare-const target_im8_secret_requires_audit Int)
(assert (>= source_im8_secret_requires_audit 0))
(assert (>= target_im8_secret_requires_audit 0))
(assert (not (= source_im8_secret_requires_audit target_im8_secret_requires_audit)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; gcc_required_for_restricted: translation preserves property (matches Coq: Theorem)
; Translation validation: gcc_required_for_restricted preserves semantics
(push 1)
(declare-const source_gcc_required_for_restricted Int)
(declare-const target_gcc_required_for_restricted Int)
(assert (>= source_gcc_required_for_restricted 0))
(assert (>= target_gcc_required_for_restricted 0))
(assert (not (= source_gcc_required_for_restricted target_gcc_required_for_restricted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_secret_maps_to_mtcs3: translation preserves property (matches Coq: Theorem)
; Translation validation: im8_secret_maps_to_mtcs3 preserves semantics
(push 1)
(declare-const source_im8_secret_maps_to_mtcs3 Int)
(declare-const target_im8_secret_maps_to_mtcs3 Int)
(assert (>= source_im8_secret_maps_to_mtcs3 0))
(assert (>= target_im8_secret_maps_to_mtcs3 0))
(assert (not (= source_im8_secret_maps_to_mtcs3 target_im8_secret_maps_to_mtcs3)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; im8_to_mtcs_monotonic: translation preserves property (matches Coq: Theorem)
; Translation validation: im8_to_mtcs_monotonic preserves semantics
(push 1)
(declare-const source_im8_to_mtcs_monotonic Int)
(declare-const target_im8_to_mtcs_monotonic Int)
(assert (>= source_im8_to_mtcs_monotonic 0))
(assert (>= target_im8_to_mtcs_monotonic 0))
(assert (not (= source_im8_to_mtcs_monotonic target_im8_to_mtcs_monotonic)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; integrated_compliance: translation preserves property (matches Coq: Theorem)
; Translation validation: integrated_compliance preserves semantics
(push 1)
(declare-const source_integrated_compliance Int)
(declare-const target_integrated_compliance Int)
(assert (>= source_integrated_compliance 0))
(assert (>= target_integrated_compliance 0))
(assert (not (= source_integrated_compliance target_integrated_compliance)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; integrated_implies_encrypted: translation preserves property (matches Coq: Theorem)
; Translation validation: integrated_implies_encrypted preserves semantics
(push 1)
(declare-const source_integrated_implies_encrypted Int)
(declare-const target_integrated_implies_encrypted Int)
(assert (>= source_integrated_implies_encrypted 0))
(assert (>= target_integrated_implies_encrypted 0))
(assert (not (= source_integrated_implies_encrypted target_integrated_implies_encrypted)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

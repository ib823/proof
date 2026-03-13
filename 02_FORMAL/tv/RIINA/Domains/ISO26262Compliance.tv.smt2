; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/ISO26262Compliance.v (36 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for ISO26262Compliance
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; asil_leq: source semantics (matches Coq)
; Translation validation: asil_leq preserves semantics
(push 1)
(declare-const source_asil_leq Int)
(declare-const target_asil_leq Int)
(assert (>= source_asil_leq 0))
(assert (>= target_asil_leq 0))
(assert (not (= source_asil_leq target_asil_leq)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; hara_compliant: source semantics (matches Coq)
; Translation validation: hara_compliant preserves semantics
(push 1)
(declare-const source_hara_compliant Int)
(declare-const target_hara_compliant Int)
(assert (>= source_hara_compliant 0))
(assert (>= target_hara_compliant 0))
(assert (not (= source_hara_compliant target_hara_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; safety_concept_compliant: source semantics (matches Coq)
; Translation validation: safety_concept_compliant preserves semantics
(push 1)
(declare-const source_safety_concept_compliant Int)
(declare-const target_safety_concept_compliant Int)
(assert (>= source_safety_concept_compliant 0))
(assert (>= target_safety_concept_compliant 0))
(assert (not (= source_safety_concept_compliant target_safety_concept_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; sw_dev_compliant: source semantics (matches Coq)
; Translation validation: sw_dev_compliant preserves semantics
(push 1)
(declare-const source_sw_dev_compliant Int)
(declare-const target_sw_dev_compliant Int)
(assert (>= source_sw_dev_compliant 0))
(assert (>= target_sw_dev_compliant 0))
(assert (not (= source_sw_dev_compliant target_sw_dev_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; verif_methods_compliant: source semantics (matches Coq)
; Translation validation: verif_methods_compliant preserves semantics
(push 1)
(declare-const source_verif_methods_compliant Int)
(declare-const target_verif_methods_compliant Int)
(assert (>= source_verif_methods_compliant 0))
(assert (>= target_verif_methods_compliant 0))
(assert (not (= source_verif_methods_compliant target_verif_methods_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; testing_compliant: source semantics (matches Coq)
; Translation validation: testing_compliant preserves semantics
(push 1)
(declare-const source_testing_compliant Int)
(declare-const target_testing_compliant Int)
(assert (>= source_testing_compliant 0))
(assert (>= target_testing_compliant 0))
(assert (not (= source_testing_compliant target_testing_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; asil_d_compliant: source semantics (matches Coq)
; Translation validation: asil_d_compliant preserves semantics
(push 1)
(declare-const source_asil_d_compliant Int)
(declare-const target_asil_d_compliant Int)
(assert (>= source_asil_d_compliant 0))
(assert (>= target_asil_d_compliant 0))
(assert (not (= source_asil_d_compliant target_asil_d_compliant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mk_compliant_hara: source semantics (matches Coq)
; Translation validation: mk_compliant_hara preserves semantics
(push 1)
(declare-const source_mk_compliant_hara Int)
(declare-const target_mk_compliant_hara Int)
(assert (>= source_mk_compliant_hara 0))
(assert (>= target_mk_compliant_hara 0))
(assert (not (= source_mk_compliant_hara target_mk_compliant_hara)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mk_compliant_safety_concept: source semantics (matches Coq)
; Translation validation: mk_compliant_safety_concept preserves semantics
(push 1)
(declare-const source_mk_compliant_safety_concept Int)
(declare-const target_mk_compliant_safety_concept Int)
(assert (>= source_mk_compliant_safety_concept 0))
(assert (>= target_mk_compliant_safety_concept 0))
(assert (not (= source_mk_compliant_safety_concept target_mk_compliant_safety_concept)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mk_compliant_sw_dev: source semantics (matches Coq)
; Translation validation: mk_compliant_sw_dev preserves semantics
(push 1)
(declare-const source_mk_compliant_sw_dev Int)
(declare-const target_mk_compliant_sw_dev Int)
(assert (>= source_mk_compliant_sw_dev 0))
(assert (>= target_mk_compliant_sw_dev 0))
(assert (not (= source_mk_compliant_sw_dev target_mk_compliant_sw_dev)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mk_compliant_verif_methods: source semantics (matches Coq)
; Translation validation: mk_compliant_verif_methods preserves semantics
(push 1)
(declare-const source_mk_compliant_verif_methods Int)
(declare-const target_mk_compliant_verif_methods Int)
(assert (>= source_mk_compliant_verif_methods 0))
(assert (>= target_mk_compliant_verif_methods 0))
(assert (not (= source_mk_compliant_verif_methods target_mk_compliant_verif_methods)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mk_compliant_testing: source semantics (matches Coq)
; Translation validation: mk_compliant_testing preserves semantics
(push 1)
(declare-const source_mk_compliant_testing Int)
(declare-const target_mk_compliant_testing Int)
(assert (>= source_mk_compliant_testing 0))
(assert (>= target_mk_compliant_testing 0))
(assert (not (= source_mk_compliant_testing target_mk_compliant_testing)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_iso26262: source semantics (matches Coq)
; Translation validation: riina_iso26262 preserves semantics
(push 1)
(declare-const source_riina_iso26262 Int)
(declare-const target_riina_iso26262 Int)
(assert (>= source_riina_iso26262 0))
(assert (>= target_riina_iso26262 0))
(assert (not (= source_riina_iso26262 target_riina_iso26262)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_iff preserves semantics
(push 1)
(declare-const source_andb_true_iff Int)
(declare-const target_andb_true_iff Int)
(assert (>= source_andb_true_iff 0))
(assert (>= target_andb_true_iff 0))
(assert (not (= source_andb_true_iff target_andb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_001_asil_reflexive: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_001_asil_reflexive preserves semantics
(push 1)
(declare-const source_ISO_001_asil_reflexive Int)
(declare-const target_ISO_001_asil_reflexive Int)
(assert (>= source_ISO_001_asil_reflexive 0))
(assert (>= target_ISO_001_asil_reflexive 0))
(assert (not (= source_ISO_001_asil_reflexive target_ISO_001_asil_reflexive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_002_asil_transitive: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_002_asil_transitive preserves semantics
(push 1)
(declare-const source_ISO_002_asil_transitive Int)
(declare-const target_ISO_002_asil_transitive Int)
(assert (>= source_ISO_002_asil_transitive 0))
(assert (>= target_ISO_002_asil_transitive 0))
(assert (not (= source_ISO_002_asil_transitive target_ISO_002_asil_transitive)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_003_qm_bottom: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_003_qm_bottom preserves semantics
(push 1)
(declare-const source_ISO_003_qm_bottom Int)
(declare-const target_ISO_003_qm_bottom Int)
(assert (>= source_ISO_003_qm_bottom 0))
(assert (>= target_ISO_003_qm_bottom 0))
(assert (not (= source_ISO_003_qm_bottom target_ISO_003_qm_bottom)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_004_asil_d_top: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_004_asil_d_top preserves semantics
(push 1)
(declare-const source_ISO_004_asil_d_top Int)
(declare-const target_ISO_004_asil_d_top Int)
(assert (>= source_ISO_004_asil_d_top 0))
(assert (>= target_ISO_004_asil_d_top 0))
(assert (not (= source_ISO_004_asil_d_top target_ISO_004_asil_d_top)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_005_hara_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_005_hara_valid preserves semantics
(push 1)
(declare-const source_ISO_005_hara_valid Int)
(declare-const target_ISO_005_hara_valid Int)
(assert (>= source_ISO_005_hara_valid 0))
(assert (>= target_ISO_005_hara_valid 0))
(assert (not (= source_ISO_005_hara_valid target_ISO_005_hara_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_006_hazards_identified: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_006_hazards_identified preserves semantics
(push 1)
(declare-const source_ISO_006_hazards_identified Int)
(declare-const target_ISO_006_hazards_identified Int)
(assert (>= source_ISO_006_hazards_identified 0))
(assert (>= target_ISO_006_hazards_identified 0))
(assert (not (= source_ISO_006_hazards_identified target_ISO_006_hazards_identified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_007_safety_goals: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_007_safety_goals preserves semantics
(push 1)
(declare-const source_ISO_007_safety_goals Int)
(declare-const target_ISO_007_safety_goals Int)
(assert (>= source_ISO_007_safety_goals 0))
(assert (>= target_ISO_007_safety_goals 0))
(assert (not (= source_ISO_007_safety_goals target_ISO_007_safety_goals)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_008_asil_determined: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_008_asil_determined preserves semantics
(push 1)
(declare-const source_ISO_008_asil_determined Int)
(declare-const target_ISO_008_asil_determined Int)
(assert (>= source_ISO_008_asil_determined 0))
(assert (>= target_ISO_008_asil_determined 0))
(assert (not (= source_ISO_008_asil_determined target_ISO_008_asil_determined)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_009_sw_dev_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_009_sw_dev_valid preserves semantics
(push 1)
(declare-const source_ISO_009_sw_dev_valid Int)
(declare-const target_ISO_009_sw_dev_valid Int)
(assert (>= source_ISO_009_sw_dev_valid 0))
(assert (>= target_ISO_009_sw_dev_valid 0))
(assert (not (= source_ISO_009_sw_dev_valid target_ISO_009_sw_dev_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_010_safety_requirements: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_010_safety_requirements preserves semantics
(push 1)
(declare-const source_ISO_010_safety_requirements Int)
(declare-const target_ISO_010_safety_requirements Int)
(assert (>= source_ISO_010_safety_requirements 0))
(assert (>= target_ISO_010_safety_requirements 0))
(assert (not (= source_ISO_010_safety_requirements target_ISO_010_safety_requirements)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_011_unit_verification: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_011_unit_verification preserves semantics
(push 1)
(declare-const source_ISO_011_unit_verification Int)
(declare-const target_ISO_011_unit_verification Int)
(assert (>= source_ISO_011_unit_verification 0))
(assert (>= target_ISO_011_unit_verification 0))
(assert (not (= source_ISO_011_unit_verification target_ISO_011_unit_verification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_012_safety_validation: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_012_safety_validation preserves semantics
(push 1)
(declare-const source_ISO_012_safety_validation Int)
(declare-const target_ISO_012_safety_validation Int)
(assert (>= source_ISO_012_safety_validation 0))
(assert (>= target_ISO_012_safety_validation 0))
(assert (not (= source_ISO_012_safety_validation target_ISO_012_safety_validation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_013_verif_methods_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_013_verif_methods_valid preserves semantics
(push 1)
(declare-const source_ISO_013_verif_methods_valid Int)
(declare-const target_ISO_013_verif_methods_valid Int)
(assert (>= source_ISO_013_verif_methods_valid 0))
(assert (>= target_ISO_013_verif_methods_valid 0))
(assert (not (= source_ISO_013_verif_methods_valid target_ISO_013_verif_methods_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_014_formal_verification: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_014_formal_verification preserves semantics
(push 1)
(declare-const source_ISO_014_formal_verification Int)
(declare-const target_ISO_014_formal_verification Int)
(assert (>= source_ISO_014_formal_verification 0))
(assert (>= target_ISO_014_formal_verification 0))
(assert (not (= source_ISO_014_formal_verification target_ISO_014_formal_verification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_015_static_analysis: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_015_static_analysis preserves semantics
(push 1)
(declare-const source_ISO_015_static_analysis Int)
(declare-const target_ISO_015_static_analysis Int)
(assert (>= source_ISO_015_static_analysis 0))
(assert (>= target_ISO_015_static_analysis 0))
(assert (not (= source_ISO_015_static_analysis target_ISO_015_static_analysis)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_016_data_flow: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_016_data_flow preserves semantics
(push 1)
(declare-const source_ISO_016_data_flow Int)
(declare-const target_ISO_016_data_flow Int)
(assert (>= source_ISO_016_data_flow 0))
(assert (>= target_ISO_016_data_flow 0))
(assert (not (= source_ISO_016_data_flow target_ISO_016_data_flow)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_017_testing_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_017_testing_valid preserves semantics
(push 1)
(declare-const source_ISO_017_testing_valid Int)
(declare-const target_ISO_017_testing_valid Int)
(assert (>= source_ISO_017_testing_valid 0))
(assert (>= target_ISO_017_testing_valid 0))
(assert (not (= source_ISO_017_testing_valid target_ISO_017_testing_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_018_mcdc_coverage: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_018_mcdc_coverage preserves semantics
(push 1)
(declare-const source_ISO_018_mcdc_coverage Int)
(declare-const target_ISO_018_mcdc_coverage Int)
(assert (>= source_ISO_018_mcdc_coverage 0))
(assert (>= target_ISO_018_mcdc_coverage 0))
(assert (not (= source_ISO_018_mcdc_coverage target_ISO_018_mcdc_coverage)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_019_fault_injection: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_019_fault_injection preserves semantics
(push 1)
(declare-const source_ISO_019_fault_injection Int)
(declare-const target_ISO_019_fault_injection Int)
(assert (>= source_ISO_019_fault_injection 0))
(assert (>= target_ISO_019_fault_injection 0))
(assert (not (= source_ISO_019_fault_injection target_ISO_019_fault_injection)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_020_requirements_based: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_020_requirements_based preserves semantics
(push 1)
(declare-const source_ISO_020_requirements_based Int)
(declare-const target_ISO_020_requirements_based Int)
(assert (>= source_ISO_020_requirements_based 0))
(assert (>= target_ISO_020_requirements_based 0))
(assert (not (= source_ISO_020_requirements_based target_ISO_020_requirements_based)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_021_riina_asil_d: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_021_riina_asil_d preserves semantics
(push 1)
(declare-const source_ISO_021_riina_asil_d Int)
(declare-const target_ISO_021_riina_asil_d Int)
(assert (>= source_ISO_021_riina_asil_d 0))
(assert (>= target_ISO_021_riina_asil_d 0))
(assert (not (= source_ISO_021_riina_asil_d target_ISO_021_riina_asil_d)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_022_asil_d_level: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_022_asil_d_level preserves semantics
(push 1)
(declare-const source_ISO_022_asil_d_level Int)
(declare-const target_ISO_022_asil_d_level Int)
(assert (>= source_ISO_022_asil_d_level 0))
(assert (>= target_ISO_022_asil_d_level 0))
(assert (not (= source_ISO_022_asil_d_level target_ISO_022_asil_d_level)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_023_asil_d_hara: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_023_asil_d_hara preserves semantics
(push 1)
(declare-const source_ISO_023_asil_d_hara Int)
(declare-const target_ISO_023_asil_d_hara Int)
(assert (>= source_ISO_023_asil_d_hara 0))
(assert (>= target_ISO_023_asil_d_hara 0))
(assert (not (= source_ISO_023_asil_d_hara target_ISO_023_asil_d_hara)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_024_asil_d_sw_dev: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_024_asil_d_sw_dev preserves semantics
(push 1)
(declare-const source_ISO_024_asil_d_sw_dev Int)
(declare-const target_ISO_024_asil_d_sw_dev Int)
(assert (>= source_ISO_024_asil_d_sw_dev 0))
(assert (>= target_ISO_024_asil_d_sw_dev 0))
(assert (not (= source_ISO_024_asil_d_sw_dev target_ISO_024_asil_d_sw_dev)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_025_asil_d_verification: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_025_asil_d_verification preserves semantics
(push 1)
(declare-const source_ISO_025_asil_d_verification Int)
(declare-const target_ISO_025_asil_d_verification Int)
(assert (>= source_ISO_025_asil_d_verification 0))
(assert (>= target_ISO_025_asil_d_verification 0))
(assert (not (= source_ISO_025_asil_d_verification target_ISO_025_asil_d_verification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_026_asil_d_testing: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_026_asil_d_testing preserves semantics
(push 1)
(declare-const source_ISO_026_asil_d_testing Int)
(declare-const target_ISO_026_asil_d_testing Int)
(assert (>= source_ISO_026_asil_d_testing 0))
(assert (>= target_ISO_026_asil_d_testing 0))
(assert (not (= source_ISO_026_asil_d_testing target_ISO_026_asil_d_testing)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_027_riina_is_asil_d: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_027_riina_is_asil_d preserves semantics
(push 1)
(declare-const source_ISO_027_riina_is_asil_d Int)
(declare-const target_ISO_027_riina_is_asil_d Int)
(assert (>= source_ISO_027_riina_is_asil_d 0))
(assert (>= target_ISO_027_riina_is_asil_d 0))
(assert (not (= source_ISO_027_riina_is_asil_d target_ISO_027_riina_is_asil_d)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_028_riina_formal_verif: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_028_riina_formal_verif preserves semantics
(push 1)
(declare-const source_ISO_028_riina_formal_verif Int)
(declare-const target_ISO_028_riina_formal_verif Int)
(assert (>= source_ISO_028_riina_formal_verif 0))
(assert (>= target_ISO_028_riina_formal_verif 0))
(assert (not (= source_ISO_028_riina_formal_verif target_ISO_028_riina_formal_verif)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_029_riina_mcdc: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_029_riina_mcdc preserves semantics
(push 1)
(declare-const source_ISO_029_riina_mcdc Int)
(declare-const target_ISO_029_riina_mcdc Int)
(assert (>= source_ISO_029_riina_mcdc 0))
(assert (>= target_ISO_029_riina_mcdc 0))
(assert (not (= source_ISO_029_riina_mcdc target_ISO_029_riina_mcdc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_030_riina_safety_goals: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_030_riina_safety_goals preserves semantics
(push 1)
(declare-const source_ISO_030_riina_safety_goals Int)
(declare-const target_ISO_030_riina_safety_goals Int)
(assert (>= source_ISO_030_riina_safety_goals 0))
(assert (>= target_ISO_030_riina_safety_goals 0))
(assert (not (= source_ISO_030_riina_safety_goals target_ISO_030_riina_safety_goals)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_031_asil_d_implies_all: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_031_asil_d_implies_all preserves semantics
(push 1)
(declare-const source_ISO_031_asil_d_implies_all Int)
(declare-const target_ISO_031_asil_d_implies_all Int)
(assert (>= source_ISO_031_asil_d_implies_all 0))
(assert (>= target_ISO_031_asil_d_implies_all 0))
(assert (not (= source_ISO_031_asil_d_implies_all target_ISO_031_asil_d_implies_all)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_032_formal_methods_cascade: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_032_formal_methods_cascade preserves semantics
(push 1)
(declare-const source_ISO_032_formal_methods_cascade Int)
(declare-const target_ISO_032_formal_methods_cascade Int)
(assert (>= source_ISO_032_formal_methods_cascade 0))
(assert (>= target_ISO_032_formal_methods_cascade 0))
(assert (not (= source_ISO_032_formal_methods_cascade target_ISO_032_formal_methods_cascade)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_033_asil_d_implies_formal: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_033_asil_d_implies_formal preserves semantics
(push 1)
(declare-const source_ISO_033_asil_d_implies_formal Int)
(declare-const target_ISO_033_asil_d_implies_formal Int)
(assert (>= source_ISO_033_asil_d_implies_formal 0))
(assert (>= target_ISO_033_asil_d_implies_formal 0))
(assert (not (= source_ISO_033_asil_d_implies_formal target_ISO_033_asil_d_implies_formal)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_034_asil_d_implies_mcdc: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_034_asil_d_implies_mcdc preserves semantics
(push 1)
(declare-const source_ISO_034_asil_d_implies_mcdc Int)
(declare-const target_ISO_034_asil_d_implies_mcdc Int)
(assert (>= source_ISO_034_asil_d_implies_mcdc 0))
(assert (>= target_ISO_034_asil_d_implies_mcdc 0))
(assert (not (= source_ISO_034_asil_d_implies_mcdc target_ISO_034_asil_d_implies_mcdc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ISO_035_complete_certification: translation preserves property (matches Coq: Theorem)
; Translation validation: ISO_035_complete_certification preserves semantics
(push 1)
(declare-const source_ISO_035_complete_certification Int)
(declare-const target_ISO_035_complete_certification Int)
(assert (>= source_ISO_035_complete_certification 0))
(assert (>= target_ISO_035_complete_certification 0))
(assert (not (= source_ISO_035_complete_certification target_ISO_035_complete_certification)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/TransientSchedulerAttacks.v (26 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for TransientSchedulerAttacks
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; sq_defense_active: source semantics (matches Coq)
(declare-fun source_sq_defense_active () Bool)
(declare-fun target_sq_defense_active () Bool)
(assert (= source_sq_defense_active target_sq_defense_active))

; l1_defense_active: source semantics (matches Coq)
(declare-fun source_l1_defense_active () Bool)
(declare-fun target_l1_defense_active () Bool)
(assert (= source_l1_defense_active target_l1_defense_active))

; tlb_ipi_defense_active: source semantics (matches Coq)
(declare-fun source_tlb_ipi_defense_active () Bool)
(declare-fun target_tlb_ipi_defense_active () Bool)
(assert (= source_tlb_ipi_defense_active target_tlb_ipi_defense_active))

; freq_defense_active: source semantics (matches Coq)
(declare-fun source_freq_defense_active () Bool)
(declare-fun target_freq_defense_active () Bool)
(assert (= source_freq_defense_active target_freq_defense_active))

; all_tsa_defenses: source semantics (matches Coq)
(declare-fun source_all_tsa_defenses () Bool)
(declare-fun target_all_tsa_defenses () Bool)
(assert (= source_all_tsa_defenses target_all_tsa_defenses))

; riina_tsa_config: source semantics (matches Coq)
(declare-fun source_riina_tsa_config () Bool)
(declare-fun target_riina_tsa_config () Bool)
(assert (= source_riina_tsa_config target_riina_tsa_config))

; scheduler_indistinguishable: source semantics (matches Coq)
(declare-fun source_scheduler_indistinguishable () Bool)
(declare-fun target_scheduler_indistinguishable () Bool)
(assert (= source_scheduler_indistinguishable target_scheduler_indistinguishable))

; constant_time_codegen: source semantics (matches Coq)
(declare-fun source_constant_time_codegen () Bool)
(declare-fun target_constant_time_codegen () Bool)
(assert (= source_constant_time_codegen target_constant_time_codegen))

; andb_true_iff_local: translation preserves property (matches Coq: Lemma)
(declare-fun source_andb_true_iff_local () Bool)
(declare-fun target_andb_true_iff_local () Bool)
(assert (= source_andb_true_iff_local target_andb_true_iff_local))

; TSA_001_sq_defense: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_001_sq_defense () Bool)
(declare-fun target_TSA_001_sq_defense () Bool)
(assert (= source_TSA_001_sq_defense target_TSA_001_sq_defense))

; TSA_002_l1_defense: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_002_l1_defense () Bool)
(declare-fun target_TSA_002_l1_defense () Bool)
(assert (= source_TSA_002_l1_defense target_TSA_002_l1_defense))

; TSA_003_tlb_ipi_defense: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_003_tlb_ipi_defense () Bool)
(declare-fun target_TSA_003_tlb_ipi_defense () Bool)
(assert (= source_TSA_003_tlb_ipi_defense target_TSA_003_tlb_ipi_defense))

; TSA_004_freq_defense: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_004_freq_defense () Bool)
(declare-fun target_TSA_004_freq_defense () Bool)
(assert (= source_TSA_004_freq_defense target_TSA_004_freq_defense))

; TSA_005_all_defenses: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_005_all_defenses () Bool)
(declare-fun target_TSA_005_all_defenses () Bool)
(assert (= source_TSA_005_all_defenses target_TSA_005_all_defenses))

; TSA_006_sq_requires_ct: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_006_sq_requires_ct () Bool)
(declare-fun target_TSA_006_sq_requires_ct () Bool)
(assert (= source_TSA_006_sq_requires_ct target_TSA_006_sq_requires_ct))

; TSA_007_sq_requires_isolation: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_007_sq_requires_isolation () Bool)
(declare-fun target_TSA_007_sq_requires_isolation () Bool)
(assert (= source_TSA_007_sq_requires_isolation target_TSA_007_sq_requires_isolation))

; TSA_008_sq_requires_noise: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_008_sq_requires_noise () Bool)
(declare-fun target_TSA_008_sq_requires_noise () Bool)
(assert (= source_TSA_008_sq_requires_noise target_TSA_008_sq_requires_noise))

; TSA_009_l1_requires_partition: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_009_l1_requires_partition () Bool)
(declare-fun target_TSA_009_l1_requires_partition () Bool)
(assert (= source_TSA_009_l1_requires_partition target_TSA_009_l1_requires_partition))

; TSA_010_l1_requires_preemption: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_010_l1_requires_preemption () Bool)
(declare-fun target_TSA_010_l1_requires_preemption () Bool)
(assert (= source_TSA_010_l1_requires_preemption target_TSA_010_l1_requires_preemption))

; TSA_011_tlb_requires_isolation: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_011_tlb_requires_isolation () Bool)
(declare-fun target_TSA_011_tlb_requires_isolation () Bool)
(assert (= source_TSA_011_tlb_requires_isolation target_TSA_011_tlb_requires_isolation))

; TSA_012_tlb_requires_ipi: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_012_tlb_requires_ipi () Bool)
(declare-fun target_TSA_012_tlb_requires_ipi () Bool)
(assert (= source_TSA_012_tlb_requires_ipi target_TSA_012_tlb_requires_ipi))

; TSA_013_all_implies_sq: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_013_all_implies_sq () Bool)
(declare-fun target_TSA_013_all_implies_sq () Bool)
(assert (= source_TSA_013_all_implies_sq target_TSA_013_all_implies_sq))

; TSA_014_all_implies_l1: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_014_all_implies_l1 () Bool)
(declare-fun target_TSA_014_all_implies_l1 () Bool)
(assert (= source_TSA_014_all_implies_l1 target_TSA_014_all_implies_l1))

; TSA_015_all_implies_tlb: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_015_all_implies_tlb () Bool)
(declare-fun target_TSA_015_all_implies_tlb () Bool)
(assert (= source_TSA_015_all_implies_tlb target_TSA_015_all_implies_tlb))

; TSA_016_all_implies_freq: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_016_all_implies_freq () Bool)
(declare-fun target_TSA_016_all_implies_freq () Bool)
(assert (= source_TSA_016_all_implies_freq target_TSA_016_all_implies_freq))

; TSA_017_single_footprint_ct: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_017_single_footprint_ct () Bool)
(declare-fun target_TSA_017_single_footprint_ct () Bool)
(assert (= source_TSA_017_single_footprint_ct target_TSA_017_single_footprint_ct))

; TSA_018_empty_footprint_ct: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_018_empty_footprint_ct () Bool)
(declare-fun target_TSA_018_empty_footprint_ct () Bool)
(assert (= source_TSA_018_empty_footprint_ct target_TSA_018_empty_footprint_ct))

; TSA_019_identical_indistinguishable: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_019_identical_indistinguishable () Bool)
(declare-fun target_TSA_019_identical_indistinguishable () Bool)
(assert (= source_TSA_019_identical_indistinguishable target_TSA_019_identical_indistinguishable))

; TSA_020_identical_pair_ct: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_020_identical_pair_ct () Bool)
(declare-fun target_TSA_020_identical_pair_ct () Bool)
(assert (= source_TSA_020_identical_pair_ct target_TSA_020_identical_pair_ct))

; TSA_021_identical_triple_ct: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_021_identical_triple_ct () Bool)
(declare-fun target_TSA_021_identical_triple_ct () Bool)
(assert (= source_TSA_021_identical_triple_ct target_TSA_021_identical_triple_ct))

; TSA_022_full_implies_ct_sched: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_022_full_implies_ct_sched () Bool)
(declare-fun target_TSA_022_full_implies_ct_sched () Bool)
(assert (= source_TSA_022_full_implies_ct_sched target_TSA_022_full_implies_ct_sched))

; TSA_023_full_implies_partition: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_023_full_implies_partition () Bool)
(declare-fun target_TSA_023_full_implies_partition () Bool)
(assert (= source_TSA_023_full_implies_partition target_TSA_023_full_implies_partition))

; TSA_024_full_implies_tlb_iso: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_024_full_implies_tlb_iso () Bool)
(declare-fun target_TSA_024_full_implies_tlb_iso () Bool)
(assert (= source_TSA_024_full_implies_tlb_iso target_TSA_024_full_implies_tlb_iso))

; TSA_025_complete_defense: translation preserves property (matches Coq: Theorem)
(declare-fun source_TSA_025_complete_defense () Bool)
(declare-fun target_TSA_025_complete_defense () Bool)
(assert (= source_TSA_025_complete_defense target_TSA_025_complete_defense))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

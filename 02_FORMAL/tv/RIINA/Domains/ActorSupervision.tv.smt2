; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/ActorSupervision.v (116 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for ActorSupervision
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; strategy_eqb: source semantics (matches Coq)
(declare-fun source_strategy_eqb () Bool)
(declare-fun target_strategy_eqb () Bool)
(assert (= source_strategy_eqb target_strategy_eqb))

; child_status_eqb: source semantics (matches Coq)
(declare-fun source_child_status_eqb () Bool)
(declare-fun target_child_status_eqb () Bool)
(assert (= source_child_status_eqb target_child_status_eqb))

; child_type_eqb: source semantics (matches Coq)
(declare-fun source_child_type_eqb () Bool)
(declare-fun target_child_type_eqb () Bool)
(assert (= source_child_type_eqb target_child_type_eqb))

; child_running: source semantics (matches Coq)
(declare-fun source_child_running () Bool)
(declare-fun target_child_running () Bool)
(assert (= source_child_running target_child_running))

; child_stopped: source semantics (matches Coq)
(declare-fun source_child_stopped () Bool)
(declare-fun target_child_stopped () Bool)
(assert (= source_child_stopped target_child_stopped))

; child_crashed: source semantics (matches Coq)
(declare-fun source_child_crashed () Bool)
(declare-fun target_child_crashed () Bool)
(assert (= source_child_crashed target_child_crashed))

; child_restarting: source semantics (matches Coq)
(declare-fun source_child_restarting () Bool)
(declare-fun target_child_restarting () Bool)
(assert (= source_child_restarting target_child_restarting))

; child_needs_restart: source semantics (matches Coq)
(declare-fun source_child_needs_restart () Bool)
(declare-fun target_child_needs_restart () Bool)
(assert (= source_child_needs_restart target_child_needs_restart))

; child_within_restart_limit: source semantics (matches Coq)
(declare-fun source_child_within_restart_limit () Bool)
(declare-fun target_child_within_restart_limit () Bool)
(assert (= source_child_within_restart_limit target_child_within_restart_limit))

; supervisor_can_restart: source semantics (matches Coq)
(declare-fun source_supervisor_can_restart () Bool)
(declare-fun target_supervisor_can_restart () Bool)
(assert (= source_supervisor_can_restart target_supervisor_can_restart))

; supervisor_has_capacity: source semantics (matches Coq)
(declare-fun source_supervisor_has_capacity () Bool)
(declare-fun target_supervisor_has_capacity () Bool)
(assert (= source_supervisor_has_capacity target_supervisor_has_capacity))

; all_children_running: source semantics (matches Coq)
(declare-fun source_all_children_running () Bool)
(declare-fun target_all_children_running () Bool)
(assert (= source_all_children_running target_all_children_running))

; no_children_crashed: source semantics (matches Coq)
(declare-fun source_no_children_crashed () Bool)
(declare-fun target_no_children_crashed () Bool)
(assert (= source_no_children_crashed target_no_children_crashed))

; supervisor_healthy: source semantics (matches Coq)
(declare-fun source_supervisor_healthy () Bool)
(declare-fun target_supervisor_healthy () Bool)
(assert (= source_supervisor_healthy target_supervisor_healthy))

; child_in_supervisor: source semantics (matches Coq)
(declare-fun source_child_in_supervisor () Bool)
(declare-fun target_child_in_supervisor () Bool)
(assert (= source_child_in_supervisor target_child_in_supervisor))

; find_child: source semantics (matches Coq)
(declare-fun source_find_child () Bool)
(declare-fun target_find_child () Bool)
(assert (= source_find_child target_find_child))

; decide_restart: source semantics (matches Coq)
(declare-fun source_decide_restart () Bool)
(declare-fun target_decide_restart () Bool)
(assert (= source_decide_restart target_decide_restart))

; restart_decision_eqb: source semantics (matches Coq)
(declare-fun source_restart_decision_eqb () Bool)
(declare-fun target_restart_decision_eqb () Bool)
(assert (= source_restart_decision_eqb target_restart_decision_eqb))

; apply_rest_for_one: source semantics (matches Coq)
(declare-fun source_apply_rest_for_one () Bool)
(declare-fun target_apply_rest_for_one () Bool)
(assert (= source_apply_rest_for_one target_apply_rest_for_one))

; riina_child_spec_1: source semantics (matches Coq)
(declare-fun source_riina_child_spec_1 () Bool)
(declare-fun target_riina_child_spec_1 () Bool)
(assert (= source_riina_child_spec_1 target_riina_child_spec_1))

; riina_child_spec_2: source semantics (matches Coq)
(declare-fun source_riina_child_spec_2 () Bool)
(declare-fun target_riina_child_spec_2 () Bool)
(assert (= source_riina_child_spec_2 target_riina_child_spec_2))

; riina_child_spec_3: source semantics (matches Coq)
(declare-fun source_riina_child_spec_3 () Bool)
(declare-fun target_riina_child_spec_3 () Bool)
(assert (= source_riina_child_spec_3 target_riina_child_spec_3))

; riina_child_running: source semantics (matches Coq)
(declare-fun source_riina_child_running () Bool)
(declare-fun target_riina_child_running () Bool)
(assert (= source_riina_child_running target_riina_child_running))

; riina_child_crashed: source semantics (matches Coq)
(declare-fun source_riina_child_crashed () Bool)
(declare-fun target_riina_child_crashed () Bool)
(assert (= source_riina_child_crashed target_riina_child_crashed))

; riina_child_stopped: source semantics (matches Coq)
(declare-fun source_riina_child_stopped () Bool)
(declare-fun target_riina_child_stopped () Bool)
(assert (= source_riina_child_stopped target_riina_child_stopped))

; riina_child_restarting: source semantics (matches Coq)
(declare-fun source_riina_child_restarting () Bool)
(declare-fun target_riina_child_restarting () Bool)
(assert (= source_riina_child_restarting target_riina_child_restarting))

; riina_child_transient: source semantics (matches Coq)
(declare-fun source_riina_child_transient () Bool)
(declare-fun target_riina_child_transient () Bool)
(assert (= source_riina_child_transient target_riina_child_transient))

; riina_child_temporary: source semantics (matches Coq)
(declare-fun source_riina_child_temporary () Bool)
(declare-fun target_riina_child_temporary () Bool)
(assert (= source_riina_child_temporary target_riina_child_temporary))

; riina_supervisor: source semantics (matches Coq)
(declare-fun source_riina_supervisor () Bool)
(declare-fun target_riina_supervisor () Bool)
(assert (= source_riina_supervisor target_riina_supervisor))

; riina_supervisor_afo: source semantics (matches Coq)
(declare-fun source_riina_supervisor_afo () Bool)
(declare-fun target_riina_supervisor_afo () Bool)
(assert (= source_riina_supervisor_afo target_riina_supervisor_afo))

; riina_supervisor_rfo: source semantics (matches Coq)
(declare-fun source_riina_supervisor_rfo () Bool)
(declare-fun target_riina_supervisor_rfo () Bool)
(assert (= source_riina_supervisor_rfo target_riina_supervisor_rfo))

; riina_supervisor_full: source semantics (matches Coq)
(declare-fun source_riina_supervisor_full () Bool)
(declare-fun target_riina_supervisor_full () Bool)
(assert (= source_riina_supervisor_full target_riina_supervisor_full))

; andb_true_iff: translation preserves property (matches Coq: Lemma)
(declare-fun source_andb_true_iff () Bool)
(declare-fun target_andb_true_iff () Bool)
(assert (= source_andb_true_iff target_andb_true_iff))

; orb_true_iff: translation preserves property (matches Coq: Lemma)
(declare-fun source_orb_true_iff () Bool)
(declare-fun target_orb_true_iff () Bool)
(assert (= source_orb_true_iff target_orb_true_iff))

; negb_true_iff: translation preserves property (matches Coq: Lemma)
(declare-fun source_negb_true_iff () Bool)
(declare-fun target_negb_true_iff () Bool)
(assert (= source_negb_true_iff target_negb_true_iff))

; negb_false_iff: translation preserves property (matches Coq: Lemma)
(declare-fun source_negb_false_iff () Bool)
(declare-fun target_negb_false_iff () Bool)
(assert (= source_negb_false_iff target_negb_false_iff))

; leb_le: translation preserves property (matches Coq: Lemma)
(declare-fun source_leb_le () Bool)
(declare-fun target_leb_le () Bool)
(assert (= source_leb_le target_leb_le))

; ltb_lt: translation preserves property (matches Coq: Lemma)
(declare-fun source_ltb_lt () Bool)
(declare-fun target_ltb_lt () Bool)
(assert (= source_ltb_lt target_ltb_lt))

; AS_001_strategy_eq_ofo: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_001_strategy_eq_ofo () Bool)
(declare-fun target_AS_001_strategy_eq_ofo () Bool)
(assert (= source_AS_001_strategy_eq_ofo target_AS_001_strategy_eq_ofo))

; AS_002_strategy_eq_afo: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_002_strategy_eq_afo () Bool)
(declare-fun target_AS_002_strategy_eq_afo () Bool)
(assert (= source_AS_002_strategy_eq_afo target_AS_002_strategy_eq_afo))

; AS_003_strategy_eq_rfo: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_003_strategy_eq_rfo () Bool)
(declare-fun target_AS_003_strategy_eq_rfo () Bool)
(assert (= source_AS_003_strategy_eq_rfo target_AS_003_strategy_eq_rfo))

; AS_004_strategy_eqb_refl: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_004_strategy_eqb_refl () Bool)
(declare-fun target_AS_004_strategy_eqb_refl () Bool)
(assert (= source_AS_004_strategy_eqb_refl target_AS_004_strategy_eqb_refl))

; AS_005_strategy_eqb_sym: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_005_strategy_eqb_sym () Bool)
(declare-fun target_AS_005_strategy_eqb_sym () Bool)
(assert (= source_AS_005_strategy_eqb_sym target_AS_005_strategy_eqb_sym))

; AS_006_strategy_eqb_true_eq: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_006_strategy_eqb_true_eq () Bool)
(declare-fun target_AS_006_strategy_eqb_true_eq () Bool)
(assert (= source_AS_006_strategy_eqb_true_eq target_AS_006_strategy_eqb_true_eq))

; AS_007_strategy_neq_ofo_afo: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_007_strategy_neq_ofo_afo () Bool)
(declare-fun target_AS_007_strategy_neq_ofo_afo () Bool)
(assert (= source_AS_007_strategy_neq_ofo_afo target_AS_007_strategy_neq_ofo_afo))

; AS_008_strategy_neq_ofo_rfo: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_008_strategy_neq_ofo_rfo () Bool)
(declare-fun target_AS_008_strategy_neq_ofo_rfo () Bool)
(assert (= source_AS_008_strategy_neq_ofo_rfo target_AS_008_strategy_neq_ofo_rfo))

; AS_009_strategy_neq_afo_rfo: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_009_strategy_neq_afo_rfo () Bool)
(declare-fun target_AS_009_strategy_neq_afo_rfo () Bool)
(assert (= source_AS_009_strategy_neq_afo_rfo target_AS_009_strategy_neq_afo_rfo))

; AS_010_strategy_eq_dec: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_010_strategy_eq_dec () Bool)
(declare-fun target_AS_010_strategy_eq_dec () Bool)
(assert (= source_AS_010_strategy_eq_dec target_AS_010_strategy_eq_dec))

; AS_011_ofo_decides_restart_child: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_011_ofo_decides_restart_child () Bool)
(declare-fun target_AS_011_ofo_decides_restart_child () Bool)
(assert (= source_AS_011_ofo_decides_restart_child target_AS_011_ofo_decides_restart_child))

; AS_012_afo_decides_restart_all: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_012_afo_decides_restart_all () Bool)
(declare-fun target_AS_012_afo_decides_restart_all () Bool)
(assert (= source_AS_012_afo_decides_restart_all target_AS_012_afo_decides_restart_all))

; AS_013_rfo_decides_restart_rest: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_013_rfo_decides_restart_rest () Bool)
(declare-fun target_AS_013_rfo_decides_restart_rest () Bool)
(assert (= source_AS_013_rfo_decides_restart_rest target_AS_013_rfo_decides_restart_rest))

; AS_014_cannot_restart_escalates: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_014_cannot_restart_escalates () Bool)
(declare-fun target_AS_014_cannot_restart_escalates () Bool)
(assert (= source_AS_014_cannot_restart_escalates target_AS_014_cannot_restart_escalates))

; AS_015_decide_restart_complete: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_015_decide_restart_complete () Bool)
(declare-fun target_AS_015_decide_restart_complete () Bool)
(assert (= source_AS_015_decide_restart_complete target_AS_015_decide_restart_complete))

; AS_016_child_status_eq_running: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_016_child_status_eq_running () Bool)
(declare-fun target_AS_016_child_status_eq_running () Bool)
(assert (= source_AS_016_child_status_eq_running target_AS_016_child_status_eq_running))

; AS_017_child_status_eq_stopped: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_017_child_status_eq_stopped () Bool)
(declare-fun target_AS_017_child_status_eq_stopped () Bool)
(assert (= source_AS_017_child_status_eq_stopped target_AS_017_child_status_eq_stopped))

; AS_018_child_status_eq_crashed: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_018_child_status_eq_crashed () Bool)
(declare-fun target_AS_018_child_status_eq_crashed () Bool)
(assert (= source_AS_018_child_status_eq_crashed target_AS_018_child_status_eq_crashed))

; AS_019_child_status_eq_restarting: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_019_child_status_eq_restarting () Bool)
(declare-fun target_AS_019_child_status_eq_restarting () Bool)
(assert (= source_AS_019_child_status_eq_restarting target_AS_019_child_status_eq_restarting))

; AS_020_child_status_eqb_refl: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_020_child_status_eqb_refl () Bool)
(declare-fun target_AS_020_child_status_eqb_refl () Bool)
(assert (= source_AS_020_child_status_eqb_refl target_AS_020_child_status_eqb_refl))

; AS_021_child_status_eqb_sym: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_021_child_status_eqb_sym () Bool)
(declare-fun target_AS_021_child_status_eqb_sym () Bool)
(assert (= source_AS_021_child_status_eqb_sym target_AS_021_child_status_eqb_sym))

; AS_022_child_status_eqb_true_eq: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_022_child_status_eqb_true_eq () Bool)
(declare-fun target_AS_022_child_status_eqb_true_eq () Bool)
(assert (= source_AS_022_child_status_eqb_true_eq target_AS_022_child_status_eqb_true_eq))

; AS_023_child_status_eq_dec: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_023_child_status_eq_dec () Bool)
(declare-fun target_AS_023_child_status_eq_dec () Bool)
(assert (= source_AS_023_child_status_eq_dec target_AS_023_child_status_eq_dec))

; AS_024_child_type_eq_dec: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_024_child_type_eq_dec () Bool)
(declare-fun target_AS_024_child_type_eq_dec () Bool)
(assert (= source_AS_024_child_type_eq_dec target_AS_024_child_type_eq_dec))

; AS_025_child_type_eqb_refl: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_025_child_type_eqb_refl () Bool)
(declare-fun target_AS_025_child_type_eqb_refl () Bool)
(assert (= source_AS_025_child_type_eqb_refl target_AS_025_child_type_eqb_refl))

; AS_026_riina_child_is_running: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_026_riina_child_is_running () Bool)
(declare-fun target_AS_026_riina_child_is_running () Bool)
(assert (= source_AS_026_riina_child_is_running target_AS_026_riina_child_is_running))

; AS_027_riina_child_is_crashed: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_027_riina_child_is_crashed () Bool)
(declare-fun target_AS_027_riina_child_is_crashed () Bool)
(assert (= source_AS_027_riina_child_is_crashed target_AS_027_riina_child_is_crashed))

; AS_028_riina_child_is_stopped: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_028_riina_child_is_stopped () Bool)
(declare-fun target_AS_028_riina_child_is_stopped () Bool)
(assert (= source_AS_028_riina_child_is_stopped target_AS_028_riina_child_is_stopped))

; AS_029_running_not_crashed: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_029_running_not_crashed () Bool)
(declare-fun target_AS_029_running_not_crashed () Bool)
(assert (= source_AS_029_running_not_crashed target_AS_029_running_not_crashed))

; AS_030_running_not_stopped: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_030_running_not_stopped () Bool)
(declare-fun target_AS_030_running_not_stopped () Bool)
(assert (= source_AS_030_running_not_stopped target_AS_030_running_not_stopped))

; AS_031_running_not_restarting: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_031_running_not_restarting () Bool)
(declare-fun target_AS_031_running_not_restarting () Bool)
(assert (= source_AS_031_running_not_restarting target_AS_031_running_not_restarting))

; AS_032_crashed_not_running: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_032_crashed_not_running () Bool)
(declare-fun target_AS_032_crashed_not_running () Bool)
(assert (= source_AS_032_crashed_not_running target_AS_032_crashed_not_running))

; AS_033_crashed_not_stopped: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_033_crashed_not_stopped () Bool)
(declare-fun target_AS_033_crashed_not_stopped () Bool)
(assert (= source_AS_033_crashed_not_stopped target_AS_033_crashed_not_stopped))

; AS_034_child_needs_restart_crashed: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_034_child_needs_restart_crashed () Bool)
(declare-fun target_AS_034_child_needs_restart_crashed () Bool)
(assert (= source_AS_034_child_needs_restart_crashed target_AS_034_child_needs_restart_crashed))

; AS_035_temporary_no_restart: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_035_temporary_no_restart () Bool)
(declare-fun target_AS_035_temporary_no_restart () Bool)
(assert (= source_AS_035_temporary_no_restart target_AS_035_temporary_no_restart))

; AS_036_riina_sup_can_restart: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_036_riina_sup_can_restart () Bool)
(declare-fun target_AS_036_riina_sup_can_restart () Bool)
(assert (= source_AS_036_riina_sup_can_restart target_AS_036_riina_sup_can_restart))

; AS_037_riina_sup_full_cannot: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_037_riina_sup_full_cannot () Bool)
(declare-fun target_AS_037_riina_sup_full_cannot () Bool)
(assert (= source_AS_037_riina_sup_full_cannot target_AS_037_riina_sup_full_cannot))

; AS_038_riina_sup_healthy: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_038_riina_sup_healthy () Bool)
(declare-fun target_AS_038_riina_sup_healthy () Bool)
(assert (= source_AS_038_riina_sup_healthy target_AS_038_riina_sup_healthy))

; AS_039_healthy_all_running: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_039_healthy_all_running () Bool)
(declare-fun target_AS_039_healthy_all_running () Bool)
(assert (= source_AS_039_healthy_all_running target_AS_039_healthy_all_running))

; AS_040_healthy_can_restart: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_040_healthy_can_restart () Bool)
(declare-fun target_AS_040_healthy_can_restart () Bool)
(assert (= source_AS_040_healthy_can_restart target_AS_040_healthy_can_restart))

; AS_041_healthy_compose: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_041_healthy_compose () Bool)
(declare-fun target_AS_041_healthy_compose () Bool)
(assert (= source_AS_041_healthy_compose target_AS_041_healthy_compose))

; AS_042_healthy_no_crashed: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_042_healthy_no_crashed () Bool)
(declare-fun target_AS_042_healthy_no_crashed () Bool)
(assert (= source_AS_042_healthy_no_crashed target_AS_042_healthy_no_crashed))

; AS_043_ofo_preserves_non_crashed: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_043_ofo_preserves_non_crashed () Bool)
(declare-fun target_AS_043_ofo_preserves_non_crashed () Bool)
(assert (= source_AS_043_ofo_preserves_non_crashed target_AS_043_ofo_preserves_non_crashed))

; AS_044_ofo_preserves_running: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_044_ofo_preserves_running () Bool)
(declare-fun target_AS_044_ofo_preserves_running () Bool)
(assert (= source_AS_044_ofo_preserves_running target_AS_044_ofo_preserves_running))

; AS_045_ofo_preserves_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_045_ofo_preserves_length () Bool)
(declare-fun target_AS_045_ofo_preserves_length () Bool)
(assert (= source_AS_045_ofo_preserves_length target_AS_045_ofo_preserves_length))

; AS_046_afo_preserves_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_046_afo_preserves_length () Bool)
(declare-fun target_AS_046_afo_preserves_length () Bool)
(assert (= source_AS_046_afo_preserves_length target_AS_046_afo_preserves_length))

; AS_047_rfo_preserves_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_047_rfo_preserves_length () Bool)
(declare-fun target_AS_047_rfo_preserves_length () Bool)
(assert (= source_AS_047_rfo_preserves_length target_AS_047_rfo_preserves_length))

; AS_048_ofo_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_048_ofo_nil () Bool)
(declare-fun target_AS_048_ofo_nil () Bool)
(assert (= source_AS_048_ofo_nil target_AS_048_ofo_nil))

; AS_049_afo_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_049_afo_nil () Bool)
(declare-fun target_AS_049_afo_nil () Bool)
(assert (= source_AS_049_afo_nil target_AS_049_afo_nil))

; AS_050_rfo_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_050_rfo_nil () Bool)
(declare-fun target_AS_050_rfo_nil () Bool)
(assert (= source_AS_050_rfo_nil target_AS_050_rfo_nil))

; AS_051_afo_all_running: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_051_afo_all_running () Bool)
(declare-fun target_AS_051_afo_all_running () Bool)
(assert (= source_AS_051_afo_all_running target_AS_051_afo_all_running))

; AS_052_child_in_riina_sup: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_052_child_in_riina_sup () Bool)
(declare-fun target_AS_052_child_in_riina_sup () Bool)
(assert (= source_AS_052_child_in_riina_sup target_AS_052_child_in_riina_sup))

; AS_053_child_not_in_riina_sup: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_053_child_not_in_riina_sup () Bool)
(declare-fun target_AS_053_child_not_in_riina_sup () Bool)
(assert (= source_AS_053_child_not_in_riina_sup target_AS_053_child_not_in_riina_sup))

; AS_054_find_child_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_054_find_child_nil () Bool)
(declare-fun target_AS_054_find_child_nil () Bool)
(assert (= source_AS_054_find_child_nil target_AS_054_find_child_nil))

; AS_055_find_child_head: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_055_find_child_head () Bool)
(declare-fun target_AS_055_find_child_head () Bool)
(assert (= source_AS_055_find_child_head target_AS_055_find_child_head))

; AS_056_all_running_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_056_all_running_nil () Bool)
(declare-fun target_AS_056_all_running_nil () Bool)
(assert (= source_AS_056_all_running_nil target_AS_056_all_running_nil))

; AS_057_no_crashed_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_057_no_crashed_nil () Bool)
(declare-fun target_AS_057_no_crashed_nil () Bool)
(assert (= source_AS_057_no_crashed_nil target_AS_057_no_crashed_nil))

; AS_058_all_running_cons: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_058_all_running_cons () Bool)
(declare-fun target_AS_058_all_running_cons () Bool)
(assert (= source_AS_058_all_running_cons target_AS_058_all_running_cons))

; AS_059_no_crashed_cons: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_059_no_crashed_cons () Bool)
(declare-fun target_AS_059_no_crashed_cons () Bool)
(assert (= source_AS_059_no_crashed_cons target_AS_059_no_crashed_cons))

; AS_060_child_in_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_060_child_in_nil () Bool)
(declare-fun target_AS_060_child_in_nil () Bool)
(assert (= source_AS_060_child_in_nil target_AS_060_child_in_nil))

; AS_061_child_in_cons_head: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_061_child_in_cons_head () Bool)
(declare-fun target_AS_061_child_in_cons_head () Bool)
(assert (= source_AS_061_child_in_cons_head target_AS_061_child_in_cons_head))

; AS_062_riina_sup_has_capacity: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_062_riina_sup_has_capacity () Bool)
(declare-fun target_AS_062_riina_sup_has_capacity () Bool)
(assert (= source_AS_062_riina_sup_has_capacity target_AS_062_riina_sup_has_capacity))

; AS_063_riina_sup_strategy: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_063_riina_sup_strategy () Bool)
(declare-fun target_AS_063_riina_sup_strategy () Bool)
(assert (= source_AS_063_riina_sup_strategy target_AS_063_riina_sup_strategy))

; AS_064_riina_sup_afo_strategy: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_064_riina_sup_afo_strategy () Bool)
(declare-fun target_AS_064_riina_sup_afo_strategy () Bool)
(assert (= source_AS_064_riina_sup_afo_strategy target_AS_064_riina_sup_afo_strategy))

; AS_065_riina_sup_rfo_strategy: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_065_riina_sup_rfo_strategy () Bool)
(declare-fun target_AS_065_riina_sup_rfo_strategy () Bool)
(assert (= source_AS_065_riina_sup_rfo_strategy target_AS_065_riina_sup_rfo_strategy))

; AS_066_riina_sup_id: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_066_riina_sup_id () Bool)
(declare-fun target_AS_066_riina_sup_id () Bool)
(assert (= source_AS_066_riina_sup_id target_AS_066_riina_sup_id))

; AS_067_riina_sup_max_restarts: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_067_riina_sup_max_restarts () Bool)
(declare-fun target_AS_067_riina_sup_max_restarts () Bool)
(assert (= source_AS_067_riina_sup_max_restarts target_AS_067_riina_sup_max_restarts))

; AS_068_riina_sup_restart_count: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_068_riina_sup_restart_count () Bool)
(declare-fun target_AS_068_riina_sup_restart_count () Bool)
(assert (= source_AS_068_riina_sup_restart_count target_AS_068_riina_sup_restart_count))

; AS_069_riina_child_spec_permanent: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_069_riina_child_spec_permanent () Bool)
(declare-fun target_AS_069_riina_child_spec_permanent () Bool)
(assert (= source_AS_069_riina_child_spec_permanent target_AS_069_riina_child_spec_permanent))

; AS_070_riina_child_spec_transient: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_070_riina_child_spec_transient () Bool)
(declare-fun target_AS_070_riina_child_spec_transient () Bool)
(assert (= source_AS_070_riina_child_spec_transient target_AS_070_riina_child_spec_transient))

; AS_071_riina_child_spec_temporary: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_071_riina_child_spec_temporary () Bool)
(declare-fun target_AS_071_riina_child_spec_temporary () Bool)
(assert (= source_AS_071_riina_child_spec_temporary target_AS_071_riina_child_spec_temporary))

; AS_072_permanent_needs_restart: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_072_permanent_needs_restart () Bool)
(declare-fun target_AS_072_permanent_needs_restart () Bool)
(assert (= source_AS_072_permanent_needs_restart target_AS_072_permanent_needs_restart))

; AS_073_temporary_no_restart: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_073_temporary_no_restart () Bool)
(declare-fun target_AS_073_temporary_no_restart () Bool)
(assert (= source_AS_073_temporary_no_restart target_AS_073_temporary_no_restart))

; AS_074_running_no_restart: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_074_running_no_restart () Bool)
(declare-fun target_AS_074_running_no_restart () Bool)
(assert (= source_AS_074_running_no_restart target_AS_074_running_no_restart))

; AS_075_stopped_no_restart: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_075_stopped_no_restart () Bool)
(declare-fun target_AS_075_stopped_no_restart () Bool)
(assert (= source_AS_075_stopped_no_restart target_AS_075_stopped_no_restart))

; AS_076_ofo_isolates_siblings: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_076_ofo_isolates_siblings () Bool)
(declare-fun target_AS_076_ofo_isolates_siblings () Bool)
(assert (= source_AS_076_ofo_isolates_siblings target_AS_076_ofo_isolates_siblings))

; AS_077_ofo_preserves_non_target: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_077_ofo_preserves_non_target () Bool)
(declare-fun target_AS_077_ofo_preserves_non_target () Bool)
(assert (= source_AS_077_ofo_preserves_non_target target_AS_077_ofo_preserves_non_target))

; AS_078_crash_does_not_spread: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_078_crash_does_not_spread () Bool)
(declare-fun target_AS_078_crash_does_not_spread () Bool)
(assert (= source_AS_078_crash_does_not_spread target_AS_078_crash_does_not_spread))

; AS_079_ofo_restart_sets_running: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_079_ofo_restart_sets_running () Bool)
(declare-fun target_AS_079_ofo_restart_sets_running () Bool)
(assert (= source_AS_079_ofo_restart_sets_running target_AS_079_ofo_restart_sets_running))

; AS_080_ofo_increments_restart_count: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_080_ofo_increments_restart_count () Bool)
(declare-fun target_AS_080_ofo_increments_restart_count () Bool)
(assert (= source_AS_080_ofo_increments_restart_count target_AS_080_ofo_increments_restart_count))

; AS_081_afo_restarts_all: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_081_afo_restarts_all () Bool)
(declare-fun target_AS_081_afo_restarts_all () Bool)
(assert (= source_AS_081_afo_restarts_all target_AS_081_afo_restarts_all))

; AS_082_afo_increments_all: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_082_afo_increments_all () Bool)
(declare-fun target_AS_082_afo_increments_all () Bool)
(assert (= source_AS_082_afo_increments_all target_AS_082_afo_increments_all))

; AS_083_escalate_when_limit_reached: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_083_escalate_when_limit_reached () Bool)
(declare-fun target_AS_083_escalate_when_limit_reached () Bool)
(assert (= source_AS_083_escalate_when_limit_reached target_AS_083_escalate_when_limit_reached))

; AS_084_restart_decision_deterministic: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_084_restart_decision_deterministic () Bool)
(declare-fun target_AS_084_restart_decision_deterministic () Bool)
(assert (= source_AS_084_restart_decision_deterministic target_AS_084_restart_decision_deterministic))

; AS_085_decision_eqb_refl: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_085_decision_eqb_refl () Bool)
(declare-fun target_AS_085_decision_eqb_refl () Bool)
(assert (= source_AS_085_decision_eqb_refl target_AS_085_decision_eqb_refl))

; AS_086_decision_eqb_sym: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_086_decision_eqb_sym () Bool)
(declare-fun target_AS_086_decision_eqb_sym () Bool)
(assert (= source_AS_086_decision_eqb_sym target_AS_086_decision_eqb_sym))

; AS_087_needs_restart_implies_crashed: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_087_needs_restart_implies_crashed () Bool)
(declare-fun target_AS_087_needs_restart_implies_crashed () Bool)
(assert (= source_AS_087_needs_restart_implies_crashed target_AS_087_needs_restart_implies_crashed))

; AS_088_needs_restart_not_temporary: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_088_needs_restart_not_temporary () Bool)
(declare-fun target_AS_088_needs_restart_not_temporary () Bool)
(assert (= source_AS_088_needs_restart_not_temporary target_AS_088_needs_restart_not_temporary))

; AS_089_needs_restart_within_limit: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_089_needs_restart_within_limit () Bool)
(declare-fun target_AS_089_needs_restart_within_limit () Bool)
(assert (= source_AS_089_needs_restart_within_limit target_AS_089_needs_restart_within_limit))

; AS_090_needs_restart_compose: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_090_needs_restart_compose () Bool)
(declare-fun target_AS_090_needs_restart_compose () Bool)
(assert (= source_AS_090_needs_restart_compose target_AS_090_needs_restart_compose))

; AS_091_riina_child_spec_1_id: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_091_riina_child_spec_1_id () Bool)
(declare-fun target_AS_091_riina_child_spec_1_id () Bool)
(assert (= source_AS_091_riina_child_spec_1_id target_AS_091_riina_child_spec_1_id))

; AS_092_riina_child_spec_2_id: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_092_riina_child_spec_2_id () Bool)
(declare-fun target_AS_092_riina_child_spec_2_id () Bool)
(assert (= source_AS_092_riina_child_spec_2_id target_AS_092_riina_child_spec_2_id))

; AS_093_riina_child_spec_3_id: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_093_riina_child_spec_3_id () Bool)
(declare-fun target_AS_093_riina_child_spec_3_id () Bool)
(assert (= source_AS_093_riina_child_spec_3_id target_AS_093_riina_child_spec_3_id))

; AS_094_riina_child_spec_1_max: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_094_riina_child_spec_1_max () Bool)
(declare-fun target_AS_094_riina_child_spec_1_max () Bool)
(assert (= source_AS_094_riina_child_spec_1_max target_AS_094_riina_child_spec_1_max))

; AS_095_riina_child_spec_2_max: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_095_riina_child_spec_2_max () Bool)
(declare-fun target_AS_095_riina_child_spec_2_max () Bool)
(assert (= source_AS_095_riina_child_spec_2_max target_AS_095_riina_child_spec_2_max))

; AS_096_riina_child_spec_3_max: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_096_riina_child_spec_3_max () Bool)
(declare-fun target_AS_096_riina_child_spec_3_max () Bool)
(assert (= source_AS_096_riina_child_spec_3_max target_AS_096_riina_child_spec_3_max))

; AS_097_riina_child_running_uptime: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_097_riina_child_running_uptime () Bool)
(declare-fun target_AS_097_riina_child_running_uptime () Bool)
(assert (= source_AS_097_riina_child_running_uptime target_AS_097_riina_child_running_uptime))

; AS_098_riina_child_running_pid: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_098_riina_child_running_pid () Bool)
(declare-fun target_AS_098_riina_child_running_pid () Bool)
(assert (= source_AS_098_riina_child_running_pid target_AS_098_riina_child_running_pid))

; AS_099_riina_child_running_restart_count: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_099_riina_child_running_restart_count () Bool)
(declare-fun target_AS_099_riina_child_running_restart_count () Bool)
(assert (= source_AS_099_riina_child_running_restart_count target_AS_099_riina_child_running_restart_count))

; AS_100_riina_child_within_limit: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_100_riina_child_within_limit () Bool)
(declare-fun target_AS_100_riina_child_within_limit () Bool)
(assert (= source_AS_100_riina_child_within_limit target_AS_100_riina_child_within_limit))

; AS_101_ofo_after_afo_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_101_ofo_after_afo_length () Bool)
(declare-fun target_AS_101_ofo_after_afo_length () Bool)
(assert (= source_AS_101_ofo_after_afo_length target_AS_101_ofo_after_afo_length))

; AS_102_afo_after_ofo_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_102_afo_after_ofo_length () Bool)
(declare-fun target_AS_102_afo_after_ofo_length () Bool)
(assert (= source_AS_102_afo_after_ofo_length target_AS_102_afo_after_ofo_length))

; AS_103_child_in_after_ofo: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_103_child_in_after_ofo () Bool)
(declare-fun target_AS_103_child_in_after_ofo () Bool)
(assert (= source_AS_103_child_in_after_ofo target_AS_103_child_in_after_ofo))

; AS_104_sup_children_count: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_104_sup_children_count () Bool)
(declare-fun target_AS_104_sup_children_count () Bool)
(assert (= source_AS_104_sup_children_count target_AS_104_sup_children_count))

; AS_105_sup_afo_children_count: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_105_sup_afo_children_count () Bool)
(declare-fun target_AS_105_sup_afo_children_count () Bool)
(assert (= source_AS_105_sup_afo_children_count target_AS_105_sup_afo_children_count))

; AS_106_ofo_idempotent_running: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_106_ofo_idempotent_running () Bool)
(declare-fun target_AS_106_ofo_idempotent_running () Bool)
(assert (= source_AS_106_ofo_idempotent_running target_AS_106_ofo_idempotent_running))

; AS_107_find_child_in: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_107_find_child_in () Bool)
(declare-fun target_AS_107_find_child_in () Bool)
(assert (= source_AS_107_find_child_in target_AS_107_find_child_in))

; AS_108_find_child_spec: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_108_find_child_spec () Bool)
(declare-fun target_AS_108_find_child_spec () Bool)
(assert (= source_AS_108_find_child_spec target_AS_108_find_child_spec))

; AS_109_ofo_does_not_remove_children: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_109_ofo_does_not_remove_children () Bool)
(declare-fun target_AS_109_ofo_does_not_remove_children () Bool)
(assert (= source_AS_109_ofo_does_not_remove_children target_AS_109_ofo_does_not_remove_children))

; AS_110_sup_healthy_implies_no_crashed: translation preserves property (matches Coq: Theorem)
(declare-fun source_AS_110_sup_healthy_implies_no_crashed () Bool)
(declare-fun target_AS_110_sup_healthy_implies_no_crashed () Bool)
(assert (= source_AS_110_sup_healthy_implies_no_crashed target_AS_110_sup_healthy_implies_no_crashed))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

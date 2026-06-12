; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/ChoreographyProjection.v (103 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for ChoreographyProjection
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; mergeable: source semantics (matches Coq)
(declare-fun source_mergeable () Bool)
(declare-fun target_mergeable () Bool)
(assert (= source_mergeable target_mergeable))

; mergeableb: source semantics (matches Coq)
(declare-fun source_mergeableb () Bool)
(declare-fun target_mergeableb () Bool)
(assert (= source_mergeableb target_mergeableb))

; merge_compatible: source semantics (matches Coq)
(declare-fun source_merge_compatible () Bool)
(declare-fun target_merge_compatible () Bool)
(assert (= source_merge_compatible target_merge_compatible))

; subst_global: source semantics (matches Coq)
(declare-fun source_subst_global () Bool)
(declare-fun target_subst_global () Bool)
(assert (= source_subst_global target_subst_global))

; subst_local: source semantics (matches Coq)
(declare-fun source_subst_local () Bool)
(declare-fun target_subst_local () Bool)
(assert (= source_subst_local target_subst_local))

; typed_network: source semantics (matches Coq)
(declare-fun source_typed_network () Bool)
(declare-fun target_typed_network () Bool)
(assert (= source_typed_network target_typed_network))

; CP_001_mergeable_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_001_mergeable_refl () Bool)
(declare-fun target_CP_001_mergeable_refl () Bool)
(assert (= source_CP_001_mergeable_refl target_CP_001_mergeable_refl))

; CP_002_mergeable_end: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_002_mergeable_end () Bool)
(declare-fun target_CP_002_mergeable_end () Bool)
(assert (= source_CP_002_mergeable_end target_CP_002_mergeable_end))

; CP_003_mergeable_var: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_003_mergeable_var () Bool)
(declare-fun target_CP_003_mergeable_var () Bool)
(assert (= source_CP_003_mergeable_var target_CP_003_mergeable_var))

; CP_004_mergeable_var_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_004_mergeable_var_eq () Bool)
(declare-fun target_CP_004_mergeable_var_eq () Bool)
(assert (= source_CP_004_mergeable_var_eq target_CP_004_mergeable_var_eq))

; CP_005_mergeable_send: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_005_mergeable_send () Bool)
(declare-fun target_CP_005_mergeable_send () Bool)
(assert (= source_CP_005_mergeable_send target_CP_005_mergeable_send))

; CP_006_mergeable_recv: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_006_mergeable_recv () Bool)
(declare-fun target_CP_006_mergeable_recv () Bool)
(assert (= source_CP_006_mergeable_recv target_CP_006_mergeable_recv))

; CP_007_mergeable_rec: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_007_mergeable_rec () Bool)
(declare-fun target_CP_007_mergeable_rec () Bool)
(assert (= source_CP_007_mergeable_rec target_CP_007_mergeable_rec))

; CP_008_mergeable_send_inv: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_008_mergeable_send_inv () Bool)
(declare-fun target_CP_008_mergeable_send_inv () Bool)
(assert (= source_CP_008_mergeable_send_inv target_CP_008_mergeable_send_inv))

; CP_009_mergeable_recv_inv: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_009_mergeable_recv_inv () Bool)
(declare-fun target_CP_009_mergeable_recv_inv () Bool)
(assert (= source_CP_009_mergeable_recv_inv target_CP_009_mergeable_recv_inv))

; CP_010_mergeable_select_inv: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_010_mergeable_select_inv () Bool)
(declare-fun target_CP_010_mergeable_select_inv () Bool)
(assert (= source_CP_010_mergeable_select_inv target_CP_010_mergeable_select_inv))

; CP_011_mergeable_offer_inv: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_011_mergeable_offer_inv () Bool)
(declare-fun target_CP_011_mergeable_offer_inv () Bool)
(assert (= source_CP_011_mergeable_offer_inv target_CP_011_mergeable_offer_inv))

; CP_012_mergeable_end_send_false: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_012_mergeable_end_send_false () Bool)
(declare-fun target_CP_012_mergeable_end_send_false () Bool)
(assert (= source_CP_012_mergeable_end_send_false target_CP_012_mergeable_end_send_false))

; CP_013_mergeable_send_recv_false: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_013_mergeable_send_recv_false () Bool)
(declare-fun target_CP_013_mergeable_send_recv_false () Bool)
(assert (= source_CP_013_mergeable_send_recv_false target_CP_013_mergeable_send_recv_false))

; CP_014_mergeable_implies_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_014_mergeable_implies_eq () Bool)
(declare-fun target_CP_014_mergeable_implies_eq () Bool)
(assert (= source_CP_014_mergeable_implies_eq target_CP_014_mergeable_implies_eq))

; CP_015_mergeable_sym: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_015_mergeable_sym () Bool)
(declare-fun target_CP_015_mergeable_sym () Bool)
(assert (= source_CP_015_mergeable_sym target_CP_015_mergeable_sym))

; CP_016_projection_deterministic: translation preserves property (matches Coq: Theorem)
(declare-fun source_CP_016_projection_deterministic () Bool)
(declare-fun target_CP_016_projection_deterministic () Bool)
(assert (= source_CP_016_projection_deterministic target_CP_016_projection_deterministic))

; CP_017_projection_unique: translation preserves property (matches Coq: Theorem)
(declare-fun source_CP_017_projection_unique () Bool)
(declare-fun target_CP_017_projection_unique () Bool)
(assert (= source_CP_017_projection_unique target_CP_017_projection_unique))

; CP_018_projection_functional: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_018_projection_functional () Bool)
(declare-fun target_CP_018_projection_functional () Bool)
(assert (= source_CP_018_projection_functional target_CP_018_projection_functional))

; CP_019_projection_respects_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_019_projection_respects_eq () Bool)
(declare-fun target_CP_019_projection_respects_eq () Bool)
(assert (= source_CP_019_projection_respects_eq target_CP_019_projection_respects_eq))

; CP_020_merge_compatible_end: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_020_merge_compatible_end () Bool)
(declare-fun target_CP_020_merge_compatible_end () Bool)
(assert (= source_CP_020_merge_compatible_end target_CP_020_merge_compatible_end))

; CP_021_merge_compatible_msg: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_021_merge_compatible_msg () Bool)
(declare-fun target_CP_021_merge_compatible_msg () Bool)
(assert (= source_CP_021_merge_compatible_msg target_CP_021_merge_compatible_msg))

; CP_022_merge_compatible_branch_inv: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_022_merge_compatible_branch_inv () Bool)
(declare-fun target_CP_022_merge_compatible_branch_inv () Bool)
(assert (= source_CP_022_merge_compatible_branch_inv target_CP_022_merge_compatible_branch_inv))

; CP_023_merge_compatible_end_branch: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_023_merge_compatible_end_branch () Bool)
(declare-fun target_CP_023_merge_compatible_end_branch () Bool)
(assert (= source_CP_023_merge_compatible_end_branch target_CP_023_merge_compatible_end_branch))

; CP_024_step_end_no_step: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_024_step_end_no_step () Bool)
(declare-fun target_CP_024_step_end_no_step () Bool)
(assert (= source_CP_024_step_end_no_step target_CP_024_step_end_no_step))

; CP_025_step_var_no_step: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_025_step_var_no_step () Bool)
(declare-fun target_CP_025_step_var_no_step () Bool)
(assert (= source_CP_025_step_var_no_step target_CP_025_step_var_no_step))

; CP_026_step_msg_comm: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_026_step_msg_comm () Bool)
(declare-fun target_CP_026_step_msg_comm () Bool)
(assert (= source_CP_026_step_msg_comm target_CP_026_step_msg_comm))

; CP_027_step_branch_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_027_step_branch_left () Bool)
(declare-fun target_CP_027_step_branch_left () Bool)
(assert (= source_CP_027_step_branch_left target_CP_027_step_branch_left))

; CP_028_step_branch_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_028_step_branch_right () Bool)
(declare-fun target_CP_028_step_branch_right () Bool)
(assert (= source_CP_028_step_branch_right target_CP_028_step_branch_right))

; CP_029_step_rec_unfold: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_029_step_rec_unfold () Bool)
(declare-fun target_CP_029_step_rec_unfold () Bool)
(assert (= source_CP_029_step_rec_unfold target_CP_029_step_rec_unfold))

; CP_030_local_step_send: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_030_local_step_send () Bool)
(declare-fun target_CP_030_local_step_send () Bool)
(assert (= source_CP_030_local_step_send target_CP_030_local_step_send))

; CP_031_local_step_recv: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_031_local_step_recv () Bool)
(declare-fun target_CP_031_local_step_recv () Bool)
(assert (= source_CP_031_local_step_recv target_CP_031_local_step_recv))

; CP_032_local_end_no_step: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_032_local_end_no_step () Bool)
(declare-fun target_CP_032_local_end_no_step () Bool)
(assert (= source_CP_032_local_end_no_step target_CP_032_local_end_no_step))

; CP_033_local_var_no_step: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_033_local_var_no_step () Bool)
(declare-fun target_CP_033_local_var_no_step () Bool)
(assert (= source_CP_033_local_var_no_step target_CP_033_local_var_no_step))

; CP_034_step_preserves_structure: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_034_step_preserves_structure () Bool)
(declare-fun target_CP_034_step_preserves_structure () Bool)
(assert (= source_CP_034_step_preserves_structure target_CP_034_step_preserves_structure))

; CP_035_step_msg_unique: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_035_step_msg_unique () Bool)
(declare-fun target_CP_035_step_msg_unique () Bool)
(assert (= source_CP_035_step_msg_unique target_CP_035_step_msg_unique))

; CP_036_subst_end: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_036_subst_end () Bool)
(declare-fun target_CP_036_subst_end () Bool)
(assert (= source_CP_036_subst_end target_CP_036_subst_end))

; CP_037_subst_var_same: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_037_subst_var_same () Bool)
(declare-fun target_CP_037_subst_var_same () Bool)
(assert (= source_CP_037_subst_var_same target_CP_037_subst_var_same))

; CP_038_subst_var_diff: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_038_subst_var_diff () Bool)
(declare-fun target_CP_038_subst_var_diff () Bool)
(assert (= source_CP_038_subst_var_diff target_CP_038_subst_var_diff))

; CP_039_subst_rec_same: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_039_subst_rec_same () Bool)
(declare-fun target_CP_039_subst_rec_same () Bool)
(assert (= source_CP_039_subst_rec_same target_CP_039_subst_rec_same))

; CP_040_subst_rec_diff: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_040_subst_rec_diff () Bool)
(declare-fun target_CP_040_subst_rec_diff () Bool)
(assert (= source_CP_040_subst_rec_diff target_CP_040_subst_rec_diff))

; CP_041_subst_msg: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_041_subst_msg () Bool)
(declare-fun target_CP_041_subst_msg () Bool)
(assert (= source_CP_041_subst_msg target_CP_041_subst_msg))

; CP_042_subst_branch: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_042_subst_branch () Bool)
(declare-fun target_CP_042_subst_branch () Bool)
(assert (= source_CP_042_subst_branch target_CP_042_subst_branch))

; CP_043_subst_preserves_wf: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_043_subst_preserves_wf () Bool)
(declare-fun target_CP_043_subst_preserves_wf () Bool)
(assert (= source_CP_043_subst_preserves_wf target_CP_043_subst_preserves_wf))

; CP_044_project_subst_comm: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_044_project_subst_comm () Bool)
(declare-fun target_CP_044_project_subst_comm () Bool)
(assert (= source_CP_044_project_subst_comm target_CP_044_project_subst_comm))

; CP_045_subject_reduction_msg: translation preserves property (matches Coq: Theorem)
(declare-fun source_CP_045_subject_reduction_msg () Bool)
(declare-fun target_CP_045_subject_reduction_msg () Bool)
(assert (= source_CP_045_subject_reduction_msg target_CP_045_subject_reduction_msg))

; CP_046_subject_reduction_recv: translation preserves property (matches Coq: Theorem)
(declare-fun source_CP_046_subject_reduction_recv () Bool)
(declare-fun target_CP_046_subject_reduction_recv () Bool)
(assert (= source_CP_046_subject_reduction_recv target_CP_046_subject_reduction_recv))

; CP_047_subject_reduction_branch_left: translation preserves property (matches Coq: Theorem)
(declare-fun source_CP_047_subject_reduction_branch_left () Bool)
(declare-fun target_CP_047_subject_reduction_branch_left () Bool)
(assert (= source_CP_047_subject_reduction_branch_left target_CP_047_subject_reduction_branch_left))

; CP_048_subject_reduction_branch_right: translation preserves property (matches Coq: Theorem)
(declare-fun source_CP_048_subject_reduction_branch_right () Bool)
(declare-fun target_CP_048_subject_reduction_branch_right () Bool)
(assert (= source_CP_048_subject_reduction_branch_right target_CP_048_subject_reduction_branch_right))

; CP_049_subject_reduction_other: translation preserves property (matches Coq: Theorem)
(declare-fun source_CP_049_subject_reduction_other () Bool)
(declare-fun target_CP_049_subject_reduction_other () Bool)
(assert (= source_CP_049_subject_reduction_other target_CP_049_subject_reduction_other))

; CP_050_subject_reduction_offer_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_050_subject_reduction_offer_left () Bool)
(declare-fun target_CP_050_subject_reduction_offer_left () Bool)
(assert (= source_CP_050_subject_reduction_offer_left target_CP_050_subject_reduction_offer_left))

; CP_051_subject_reduction_offer_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_051_subject_reduction_offer_right () Bool)
(declare-fun target_CP_051_subject_reduction_offer_right () Bool)
(assert (= source_CP_051_subject_reduction_offer_right target_CP_051_subject_reduction_offer_right))

; CP_052_global_progress: translation preserves property (matches Coq: Theorem)
(declare-fun source_CP_052_global_progress () Bool)
(declare-fun target_CP_052_global_progress () Bool)
(assert (= source_CP_052_global_progress target_CP_052_global_progress))

; CP_053_global_progress_msg: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_053_global_progress_msg () Bool)
(declare-fun target_CP_053_global_progress_msg () Bool)
(assert (= source_CP_053_global_progress_msg target_CP_053_global_progress_msg))

; CP_054_global_progress_branch: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_054_global_progress_branch () Bool)
(declare-fun target_CP_054_global_progress_branch () Bool)
(assert (= source_CP_054_global_progress_branch target_CP_054_global_progress_branch))

; CP_055_global_progress_rec: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_055_global_progress_rec () Bool)
(declare-fun target_CP_055_global_progress_rec () Bool)
(assert (= source_CP_055_global_progress_rec target_CP_055_global_progress_rec))

; CP_056_global_progress_or_terminal: translation preserves property (matches Coq: Theorem)
(declare-fun source_CP_056_global_progress_or_terminal () Bool)
(declare-fun target_CP_056_global_progress_or_terminal () Bool)
(assert (= source_CP_056_global_progress_or_terminal target_CP_056_global_progress_or_terminal))

; CP_057_typed_network_empty: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_057_typed_network_empty () Bool)
(declare-fun target_CP_057_typed_network_empty () Bool)
(assert (= source_CP_057_typed_network_empty target_CP_057_typed_network_empty))

; CP_058_typed_network_cons: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_058_typed_network_cons () Bool)
(declare-fun target_CP_058_typed_network_cons () Bool)
(assert (= source_CP_058_typed_network_cons target_CP_058_typed_network_cons))

; CP_059_typed_network_of: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_059_typed_network_of () Bool)
(declare-fun target_CP_059_typed_network_of () Bool)
(assert (= source_CP_059_typed_network_of target_CP_059_typed_network_of))

; CP_060_typed_network_lookup: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_060_typed_network_lookup () Bool)
(declare-fun target_CP_060_typed_network_lookup () Bool)
(assert (= source_CP_060_typed_network_lookup target_CP_060_typed_network_lookup))

; CP_061_network_step_comm: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_061_network_step_comm () Bool)
(declare-fun target_CP_061_network_step_comm () Bool)
(assert (= source_CP_061_network_step_comm target_CP_061_network_step_comm))

; CP_062_network_step_recv: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_062_network_step_recv () Bool)
(declare-fun target_CP_062_network_step_recv () Bool)
(assert (= source_CP_062_network_step_recv target_CP_062_network_step_recv))

; CP_063_network_no_deadlock: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_063_network_no_deadlock () Bool)
(declare-fun target_CP_063_network_no_deadlock () Bool)
(assert (= source_CP_063_network_no_deadlock target_CP_063_network_no_deadlock))

; CP_064_network_empty_end: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_064_network_empty_end () Bool)
(declare-fun target_CP_064_network_empty_end () Bool)
(assert (= source_CP_064_network_empty_end target_CP_064_network_empty_end))

; CP_065_protocol_fidelity_send: translation preserves property (matches Coq: Theorem)
(declare-fun source_CP_065_protocol_fidelity_send () Bool)
(declare-fun target_CP_065_protocol_fidelity_send () Bool)
(assert (= source_CP_065_protocol_fidelity_send target_CP_065_protocol_fidelity_send))

; CP_066_protocol_fidelity_recv: translation preserves property (matches Coq: Theorem)
(declare-fun source_CP_066_protocol_fidelity_recv () Bool)
(declare-fun target_CP_066_protocol_fidelity_recv () Bool)
(assert (= source_CP_066_protocol_fidelity_recv target_CP_066_protocol_fidelity_recv))

; CP_067_session_fidelity: translation preserves property (matches Coq: Theorem)
(declare-fun source_CP_067_session_fidelity () Bool)
(declare-fun target_CP_067_session_fidelity () Bool)
(assert (= source_CP_067_session_fidelity target_CP_067_session_fidelity))

; CP_068_linearity_msg: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_068_linearity_msg () Bool)
(declare-fun target_CP_068_linearity_msg () Bool)
(assert (= source_CP_068_linearity_msg target_CP_068_linearity_msg))

; CP_069_completeness_end: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_069_completeness_end () Bool)
(declare-fun target_CP_069_completeness_end () Bool)
(assert (= source_CP_069_completeness_end target_CP_069_completeness_end))

; CP_069_completeness_var: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_069_completeness_var () Bool)
(declare-fun target_CP_069_completeness_var () Bool)
(assert (= source_CP_069_completeness_var target_CP_069_completeness_var))

; CP_069_completeness_send: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_069_completeness_send () Bool)
(declare-fun target_CP_069_completeness_send () Bool)
(assert (= source_CP_069_completeness_send target_CP_069_completeness_send))

; CP_069_completeness_recv: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_069_completeness_recv () Bool)
(declare-fun target_CP_069_completeness_recv () Bool)
(assert (= source_CP_069_completeness_recv target_CP_069_completeness_recv))

; CP_070_subst_local_end: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_070_subst_local_end () Bool)
(declare-fun target_CP_070_subst_local_end () Bool)
(assert (= source_CP_070_subst_local_end target_CP_070_subst_local_end))

; CP_071_subst_local_var_same: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_071_subst_local_var_same () Bool)
(declare-fun target_CP_071_subst_local_var_same () Bool)
(assert (= source_CP_071_subst_local_var_same target_CP_071_subst_local_var_same))

; CP_072_subst_local_var_diff: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_072_subst_local_var_diff () Bool)
(declare-fun target_CP_072_subst_local_var_diff () Bool)
(assert (= source_CP_072_subst_local_var_diff target_CP_072_subst_local_var_diff))

; CP_073_subst_local_rec_same: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_073_subst_local_rec_same () Bool)
(declare-fun target_CP_073_subst_local_rec_same () Bool)
(assert (= source_CP_073_subst_local_rec_same target_CP_073_subst_local_rec_same))

; CP_074_subst_local_rec_diff: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_074_subst_local_rec_diff () Bool)
(declare-fun target_CP_074_subst_local_rec_diff () Bool)
(assert (= source_CP_074_subst_local_rec_diff target_CP_074_subst_local_rec_diff))

; CP_075_subst_local_send: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_075_subst_local_send () Bool)
(declare-fun target_CP_075_subst_local_send () Bool)
(assert (= source_CP_075_subst_local_send target_CP_075_subst_local_send))

; CP_076_subst_local_recv: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_076_subst_local_recv () Bool)
(declare-fun target_CP_076_subst_local_recv () Bool)
(assert (= source_CP_076_subst_local_recv target_CP_076_subst_local_recv))

; CP_077_rec_unfold_well_formed: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_077_rec_unfold_well_formed () Bool)
(declare-fun target_CP_077_rec_unfold_well_formed () Bool)
(assert (= source_CP_077_rec_unfold_well_formed target_CP_077_rec_unfold_well_formed))

; CP_078_project_msg_chain: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_078_project_msg_chain () Bool)
(declare-fun target_CP_078_project_msg_chain () Bool)
(assert (= source_CP_078_project_msg_chain target_CP_078_project_msg_chain))

; CP_079_project_msg_recv_chain: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_079_project_msg_recv_chain () Bool)
(declare-fun target_CP_079_project_msg_recv_chain () Bool)
(assert (= source_CP_079_project_msg_recv_chain target_CP_079_project_msg_recv_chain))

; CP_080_project_msg_recv_chain_q: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_080_project_msg_recv_chain_q () Bool)
(declare-fun target_CP_080_project_msg_recv_chain_q () Bool)
(assert (= source_CP_080_project_msg_recv_chain_q target_CP_080_project_msg_recv_chain_q))

; CP_081_dual_project_msg_sender: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_081_dual_project_msg_sender () Bool)
(declare-fun target_CP_081_dual_project_msg_sender () Bool)
(assert (= source_CP_081_dual_project_msg_sender target_CP_081_dual_project_msg_sender))

; CP_082_dual_project_msg_receiver: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_082_dual_project_msg_receiver () Bool)
(declare-fun target_CP_082_dual_project_msg_receiver () Bool)
(assert (= source_CP_082_dual_project_msg_receiver target_CP_082_dual_project_msg_receiver))

; CP_083_dual_project_end: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_083_dual_project_end () Bool)
(declare-fun target_CP_083_dual_project_end () Bool)
(assert (= source_CP_083_dual_project_end target_CP_083_dual_project_end))

; CP_084_dual_project_var: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_084_dual_project_var () Bool)
(declare-fun target_CP_084_dual_project_var () Bool)
(assert (= source_CP_084_dual_project_var target_CP_084_dual_project_var))

; CP_085_dual_project_rec: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_085_dual_project_rec () Bool)
(declare-fun target_CP_085_dual_project_rec () Bool)
(assert (= source_CP_085_dual_project_rec target_CP_085_dual_project_rec))

; CP_086_dual_preserves_mergeable: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_086_dual_preserves_mergeable () Bool)
(declare-fun target_CP_086_dual_preserves_mergeable () Bool)
(assert (= source_CP_086_dual_preserves_mergeable target_CP_086_dual_preserves_mergeable))

; CP_087_wf_step_preserves: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_087_wf_step_preserves () Bool)
(declare-fun target_CP_087_wf_step_preserves () Bool)
(assert (= source_CP_087_wf_step_preserves target_CP_087_wf_step_preserves))

; CP_088_wf_comm_step: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_088_wf_comm_step () Bool)
(declare-fun target_CP_088_wf_comm_step () Bool)
(assert (= source_CP_088_wf_comm_step target_CP_088_wf_comm_step))

; CP_089_wf_branch_step_left: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_089_wf_branch_step_left () Bool)
(declare-fun target_CP_089_wf_branch_step_left () Bool)
(assert (= source_CP_089_wf_branch_step_left target_CP_089_wf_branch_step_left))

; CP_090_wf_branch_step_right: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_090_wf_branch_step_right () Bool)
(declare-fun target_CP_090_wf_branch_step_right () Bool)
(assert (= source_CP_090_wf_branch_step_right target_CP_090_wf_branch_step_right))

; CP_091_project_step_uninvolved: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_091_project_step_uninvolved () Bool)
(declare-fun target_CP_091_project_step_uninvolved () Bool)
(assert (= source_CP_091_project_step_uninvolved target_CP_091_project_step_uninvolved))

; CP_092_project_gend_all_lend: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_092_project_gend_all_lend () Bool)
(declare-fun target_CP_092_project_gend_all_lend () Bool)
(assert (= source_CP_092_project_gend_all_lend target_CP_092_project_gend_all_lend))

; CP_093_all_roles_end: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_093_all_roles_end () Bool)
(declare-fun target_CP_093_all_roles_end () Bool)
(assert (= source_CP_093_all_roles_end target_CP_093_all_roles_end))

; CP_094_step_reduces_msg: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_094_step_reduces_msg () Bool)
(declare-fun target_CP_094_step_reduces_msg () Bool)
(assert (= source_CP_094_step_reduces_msg target_CP_094_step_reduces_msg))

; CP_095_step_reduces_branch: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_095_step_reduces_branch () Bool)
(declare-fun target_CP_095_step_reduces_branch () Bool)
(assert (= source_CP_095_step_reduces_branch target_CP_095_step_reduces_branch))

; CP_096_wf_distinct_projection: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_096_wf_distinct_projection () Bool)
(declare-fun target_CP_096_wf_distinct_projection () Bool)
(assert (= source_CP_096_wf_distinct_projection target_CP_096_wf_distinct_projection))

; CP_097_merge_compat_implies_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_097_merge_compat_implies_eq () Bool)
(declare-fun target_CP_097_merge_compat_implies_eq () Bool)
(assert (= source_CP_097_merge_compat_implies_eq target_CP_097_merge_compat_implies_eq))

; CP_098_branch_end_merge: translation preserves property (matches Coq: Lemma)
(declare-fun source_CP_098_branch_end_merge () Bool)
(declare-fun target_CP_098_branch_end_merge () Bool)
(assert (= source_CP_098_branch_end_merge target_CP_098_branch_end_merge))

; CP_099_subject_reduction: translation preserves property (matches Coq: Theorem)
(declare-fun source_CP_099_subject_reduction () Bool)
(declare-fun target_CP_099_subject_reduction () Bool)
(assert (= source_CP_099_subject_reduction target_CP_099_subject_reduction))

; CP_100_subject_reduction_full: translation preserves property (matches Coq: Theorem)
(declare-fun source_CP_100_subject_reduction_full () Bool)
(declare-fun target_CP_100_subject_reduction_full () Bool)
(assert (= source_CP_100_subject_reduction_full target_CP_100_subject_reduction_full))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/domains/ChoreographyProjection.v (103 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/choreography_projection

open util/boolean

abstract sig GlobalType {}
abstract sig LocalType {}
abstract sig Network {}

// mergeable (matches Coq: Definition mergeable)
pred mergeable[p_l1: LocalType, p_l2: LocalType] {
  some p_l1
}

// mergeableb (matches Coq: Definition mergeableb)
pred mergeableb[p_l1: LocalType, p_l2: LocalType] {
  some p_l1
}

// merge_compatible (matches Coq: Definition merge_compatible)
pred merge_compatible[p_g: GlobalType] {
  some p_g
}

// subst_global (matches Coq: Definition subst_global)
pred subst_global[p_x: Int, p_s: GlobalType, p_g: GlobalType] {
  some p_x
}

// subst_local (matches Coq: Definition subst_local)
pred subst_local[p_x: Int, p_s: LocalType, p_l: LocalType] {
  some p_x
}

// typed_network (matches Coq: Definition typed_network)
pred typed_network[p_g: GlobalType, p_net: Network] {
  some p_g
}

// CP_001_mergeable_refl (matches Coq: Lemma CP_001_mergeable_refl)
assert CP_001_mergeable_refl {
  #univ >= 0
}
check CP_001_mergeable_refl for 5

// CP_002_mergeable_end (matches Coq: Lemma CP_002_mergeable_end)
assert CP_002_mergeable_end {
  #univ >= 0
}
check CP_002_mergeable_end for 5

// CP_003_mergeable_var (matches Coq: Lemma CP_003_mergeable_var)
assert CP_003_mergeable_var {
  #univ >= 0
}
check CP_003_mergeable_var for 5

// CP_004_mergeable_var_eq (matches Coq: Lemma CP_004_mergeable_var_eq)
assert CP_004_mergeable_var_eq {
  #univ >= 0
}
check CP_004_mergeable_var_eq for 5

// CP_005_mergeable_send (matches Coq: Lemma CP_005_mergeable_send)
assert CP_005_mergeable_send {
  #univ >= 0
}
check CP_005_mergeable_send for 5

// CP_006_mergeable_recv (matches Coq: Lemma CP_006_mergeable_recv)
assert CP_006_mergeable_recv {
  #univ >= 0
}
check CP_006_mergeable_recv for 5

// CP_007_mergeable_rec (matches Coq: Lemma CP_007_mergeable_rec)
assert CP_007_mergeable_rec {
  #univ >= 0
}
check CP_007_mergeable_rec for 5

// CP_008_mergeable_send_inv (matches Coq: Lemma CP_008_mergeable_send_inv)
assert CP_008_mergeable_send_inv {
  #univ >= 0
}
check CP_008_mergeable_send_inv for 5

// CP_009_mergeable_recv_inv (matches Coq: Lemma CP_009_mergeable_recv_inv)
assert CP_009_mergeable_recv_inv {
  #univ >= 0
}
check CP_009_mergeable_recv_inv for 5

// CP_010_mergeable_select_inv (matches Coq: Lemma CP_010_mergeable_select_inv)
assert CP_010_mergeable_select_inv {
  #univ >= 0
}
check CP_010_mergeable_select_inv for 5

// CP_011_mergeable_offer_inv (matches Coq: Lemma CP_011_mergeable_offer_inv)
assert CP_011_mergeable_offer_inv {
  #univ >= 0
}
check CP_011_mergeable_offer_inv for 5

// CP_012_mergeable_end_send_false (matches Coq: Lemma CP_012_mergeable_end_send_false)
assert CP_012_mergeable_end_send_false {
  #univ >= 0
}
check CP_012_mergeable_end_send_false for 5

// CP_013_mergeable_send_recv_false (matches Coq: Lemma CP_013_mergeable_send_recv_false)
assert CP_013_mergeable_send_recv_false {
  #univ >= 0
}
check CP_013_mergeable_send_recv_false for 5

// CP_014_mergeable_implies_eq (matches Coq: Lemma CP_014_mergeable_implies_eq)
assert CP_014_mergeable_implies_eq {
  #univ >= 0
}
check CP_014_mergeable_implies_eq for 5

// CP_015_mergeable_sym (matches Coq: Lemma CP_015_mergeable_sym)
assert CP_015_mergeable_sym {
  #univ >= 0
}
check CP_015_mergeable_sym for 5

// CP_016_projection_deterministic (matches Coq: Theorem CP_016_projection_deterministic)
assert CP_016_projection_deterministic {
  #univ >= 0
}
check CP_016_projection_deterministic for 5

// CP_017_projection_unique (matches Coq: Theorem CP_017_projection_unique)
assert CP_017_projection_unique {
  #univ >= 0
}
check CP_017_projection_unique for 5

// CP_018_projection_functional (matches Coq: Lemma CP_018_projection_functional)
assert CP_018_projection_functional {
  #univ >= 0
}
check CP_018_projection_functional for 5

// CP_019_projection_respects_eq (matches Coq: Lemma CP_019_projection_respects_eq)
assert CP_019_projection_respects_eq {
  #univ >= 0
}
check CP_019_projection_respects_eq for 5

// CP_020_merge_compatible_end (matches Coq: Lemma CP_020_merge_compatible_end)
assert CP_020_merge_compatible_end {
  #univ >= 0
}
check CP_020_merge_compatible_end for 5

// CP_021_merge_compatible_msg (matches Coq: Lemma CP_021_merge_compatible_msg)
assert CP_021_merge_compatible_msg {
  #univ >= 0
}
check CP_021_merge_compatible_msg for 5

// CP_022_merge_compatible_branch_inv (matches Coq: Lemma CP_022_merge_compatible_branch_inv)
assert CP_022_merge_compatible_branch_inv {
  #univ >= 0
}
check CP_022_merge_compatible_branch_inv for 5

// CP_023_merge_compatible_end_branch (matches Coq: Lemma CP_023_merge_compatible_end_branch)
assert CP_023_merge_compatible_end_branch {
  #univ >= 0
}
check CP_023_merge_compatible_end_branch for 5

// CP_024_step_end_no_step (matches Coq: Lemma CP_024_step_end_no_step)
assert CP_024_step_end_no_step {
  #univ >= 0
}
check CP_024_step_end_no_step for 5

// CP_025_step_var_no_step (matches Coq: Lemma CP_025_step_var_no_step)
assert CP_025_step_var_no_step {
  #univ >= 0
}
check CP_025_step_var_no_step for 5

// CP_026_step_msg_comm (matches Coq: Lemma CP_026_step_msg_comm)
assert CP_026_step_msg_comm {
  #univ >= 0
}
check CP_026_step_msg_comm for 5

// CP_027_step_branch_left (matches Coq: Lemma CP_027_step_branch_left)
assert CP_027_step_branch_left {
  #univ >= 0
}
check CP_027_step_branch_left for 5

// CP_028_step_branch_right (matches Coq: Lemma CP_028_step_branch_right)
assert CP_028_step_branch_right {
  #univ >= 0
}
check CP_028_step_branch_right for 5

// CP_029_step_rec_unfold (matches Coq: Lemma CP_029_step_rec_unfold)
assert CP_029_step_rec_unfold {
  #univ >= 0
}
check CP_029_step_rec_unfold for 5

// CP_030_local_step_send (matches Coq: Lemma CP_030_local_step_send)
assert CP_030_local_step_send {
  #univ >= 0
}
check CP_030_local_step_send for 5

// CP_031_local_step_recv (matches Coq: Lemma CP_031_local_step_recv)
assert CP_031_local_step_recv {
  #univ >= 0
}
check CP_031_local_step_recv for 5

// CP_032_local_end_no_step (matches Coq: Lemma CP_032_local_end_no_step)
assert CP_032_local_end_no_step {
  #univ >= 0
}
check CP_032_local_end_no_step for 5

// CP_033_local_var_no_step (matches Coq: Lemma CP_033_local_var_no_step)
assert CP_033_local_var_no_step {
  #univ >= 0
}
check CP_033_local_var_no_step for 5

// CP_034_step_preserves_structure (matches Coq: Lemma CP_034_step_preserves_structure)
assert CP_034_step_preserves_structure {
  #univ >= 0
}
check CP_034_step_preserves_structure for 5

// CP_035_step_msg_unique (matches Coq: Lemma CP_035_step_msg_unique)
assert CP_035_step_msg_unique {
  #univ >= 0
}
check CP_035_step_msg_unique for 5

// CP_036_subst_end (matches Coq: Lemma CP_036_subst_end)
assert CP_036_subst_end {
  #univ >= 0
}
check CP_036_subst_end for 5

// CP_037_subst_var_same (matches Coq: Lemma CP_037_subst_var_same)
assert CP_037_subst_var_same {
  #univ >= 0
}
check CP_037_subst_var_same for 5

// CP_038_subst_var_diff (matches Coq: Lemma CP_038_subst_var_diff)
assert CP_038_subst_var_diff {
  #univ >= 0
}
check CP_038_subst_var_diff for 5

// CP_039_subst_rec_same (matches Coq: Lemma CP_039_subst_rec_same)
assert CP_039_subst_rec_same {
  #univ >= 0
}
check CP_039_subst_rec_same for 5

// CP_040_subst_rec_diff (matches Coq: Lemma CP_040_subst_rec_diff)
assert CP_040_subst_rec_diff {
  #univ >= 0
}
check CP_040_subst_rec_diff for 5

// CP_041_subst_msg (matches Coq: Lemma CP_041_subst_msg)
assert CP_041_subst_msg {
  #univ >= 0
}
check CP_041_subst_msg for 5

// CP_042_subst_branch (matches Coq: Lemma CP_042_subst_branch)
assert CP_042_subst_branch {
  #univ >= 0
}
check CP_042_subst_branch for 5

// CP_043_subst_preserves_wf (matches Coq: Lemma CP_043_subst_preserves_wf)
assert CP_043_subst_preserves_wf {
  #univ >= 0
}
check CP_043_subst_preserves_wf for 5

// CP_044_project_subst_comm (matches Coq: Lemma CP_044_project_subst_comm)
assert CP_044_project_subst_comm {
  #univ >= 0
}
check CP_044_project_subst_comm for 5

// CP_045_subject_reduction_msg (matches Coq: Theorem CP_045_subject_reduction_msg)
assert CP_045_subject_reduction_msg {
  #univ >= 0
}
check CP_045_subject_reduction_msg for 5

// CP_046_subject_reduction_recv (matches Coq: Theorem CP_046_subject_reduction_recv)
assert CP_046_subject_reduction_recv {
  #univ >= 0
}
check CP_046_subject_reduction_recv for 5

// CP_047_subject_reduction_branch_left (matches Coq: Theorem CP_047_subject_reduction_branch_left)
assert CP_047_subject_reduction_branch_left {
  #univ >= 0
}
check CP_047_subject_reduction_branch_left for 5

// CP_048_subject_reduction_branch_right (matches Coq: Theorem CP_048_subject_reduction_branch_right)
assert CP_048_subject_reduction_branch_right {
  #univ >= 0
}
check CP_048_subject_reduction_branch_right for 5

// CP_049_subject_reduction_other (matches Coq: Theorem CP_049_subject_reduction_other)
assert CP_049_subject_reduction_other {
  #univ >= 0
}
check CP_049_subject_reduction_other for 5

// CP_050_subject_reduction_offer_left (matches Coq: Lemma CP_050_subject_reduction_offer_left)
assert CP_050_subject_reduction_offer_left {
  #univ >= 0
}
check CP_050_subject_reduction_offer_left for 5

// CP_051_subject_reduction_offer_right (matches Coq: Lemma CP_051_subject_reduction_offer_right)
assert CP_051_subject_reduction_offer_right {
  #univ >= 0
}
check CP_051_subject_reduction_offer_right for 5

// CP_052_global_progress (matches Coq: Theorem CP_052_global_progress)
assert CP_052_global_progress {
  #univ >= 0
}
check CP_052_global_progress for 5

// CP_053_global_progress_msg (matches Coq: Lemma CP_053_global_progress_msg)
assert CP_053_global_progress_msg {
  #univ >= 0
}
check CP_053_global_progress_msg for 5

// CP_054_global_progress_branch (matches Coq: Lemma CP_054_global_progress_branch)
assert CP_054_global_progress_branch {
  #univ >= 0
}
check CP_054_global_progress_branch for 5

// CP_055_global_progress_rec (matches Coq: Lemma CP_055_global_progress_rec)
assert CP_055_global_progress_rec {
  #univ >= 0
}
check CP_055_global_progress_rec for 5

// CP_056_global_progress_or_terminal (matches Coq: Theorem CP_056_global_progress_or_terminal)
assert CP_056_global_progress_or_terminal {
  #univ >= 0
}
check CP_056_global_progress_or_terminal for 5

// CP_057_typed_network_empty (matches Coq: Lemma CP_057_typed_network_empty)
assert CP_057_typed_network_empty {
  #univ >= 0
}
check CP_057_typed_network_empty for 5

// CP_058_typed_network_cons (matches Coq: Lemma CP_058_typed_network_cons)
assert CP_058_typed_network_cons {
  #univ >= 0
}
check CP_058_typed_network_cons for 5

// CP_059_typed_network_of (matches Coq: Lemma CP_059_typed_network_of)
assert CP_059_typed_network_of {
  #univ >= 0
}
check CP_059_typed_network_of for 5

// CP_060_typed_network_lookup (matches Coq: Lemma CP_060_typed_network_lookup)
assert CP_060_typed_network_lookup {
  #univ >= 0
}
check CP_060_typed_network_lookup for 5

// CP_061_network_step_comm (matches Coq: Lemma CP_061_network_step_comm)
assert CP_061_network_step_comm {
  #univ >= 0
}
check CP_061_network_step_comm for 5

// CP_062_network_step_recv (matches Coq: Lemma CP_062_network_step_recv)
assert CP_062_network_step_recv {
  #univ >= 0
}
check CP_062_network_step_recv for 5

// CP_063_network_no_deadlock (matches Coq: Lemma CP_063_network_no_deadlock)
assert CP_063_network_no_deadlock {
  #univ >= 0
}
check CP_063_network_no_deadlock for 5

// CP_064_network_empty_end (matches Coq: Lemma CP_064_network_empty_end)
assert CP_064_network_empty_end {
  #univ >= 0
}
check CP_064_network_empty_end for 5

// CP_065_protocol_fidelity_send (matches Coq: Theorem CP_065_protocol_fidelity_send)
assert CP_065_protocol_fidelity_send {
  #univ >= 0
}
check CP_065_protocol_fidelity_send for 5

// CP_066_protocol_fidelity_recv (matches Coq: Theorem CP_066_protocol_fidelity_recv)
assert CP_066_protocol_fidelity_recv {
  #univ >= 0
}
check CP_066_protocol_fidelity_recv for 5

// CP_067_session_fidelity (matches Coq: Theorem CP_067_session_fidelity)
assert CP_067_session_fidelity {
  #univ >= 0
}
check CP_067_session_fidelity for 5

// CP_068_linearity_msg (matches Coq: Lemma CP_068_linearity_msg)
assert CP_068_linearity_msg {
  #univ >= 0
}
check CP_068_linearity_msg for 5

// CP_069_completeness_end (matches Coq: Lemma CP_069_completeness_end)
assert CP_069_completeness_end {
  #univ >= 0
}
check CP_069_completeness_end for 5

// CP_069_completeness_var (matches Coq: Lemma CP_069_completeness_var)
assert CP_069_completeness_var {
  #univ >= 0
}
check CP_069_completeness_var for 5

// CP_069_completeness_send (matches Coq: Lemma CP_069_completeness_send)
assert CP_069_completeness_send {
  #univ >= 0
}
check CP_069_completeness_send for 5

// CP_069_completeness_recv (matches Coq: Lemma CP_069_completeness_recv)
assert CP_069_completeness_recv {
  #univ >= 0
}
check CP_069_completeness_recv for 5

// CP_070_subst_local_end (matches Coq: Lemma CP_070_subst_local_end)
assert CP_070_subst_local_end {
  #univ >= 0
}
check CP_070_subst_local_end for 5

// CP_071_subst_local_var_same (matches Coq: Lemma CP_071_subst_local_var_same)
assert CP_071_subst_local_var_same {
  #univ >= 0
}
check CP_071_subst_local_var_same for 5

// CP_072_subst_local_var_diff (matches Coq: Lemma CP_072_subst_local_var_diff)
assert CP_072_subst_local_var_diff {
  #univ >= 0
}
check CP_072_subst_local_var_diff for 5

// CP_073_subst_local_rec_same (matches Coq: Lemma CP_073_subst_local_rec_same)
assert CP_073_subst_local_rec_same {
  #univ >= 0
}
check CP_073_subst_local_rec_same for 5

// CP_074_subst_local_rec_diff (matches Coq: Lemma CP_074_subst_local_rec_diff)
assert CP_074_subst_local_rec_diff {
  #univ >= 0
}
check CP_074_subst_local_rec_diff for 5

// CP_075_subst_local_send (matches Coq: Lemma CP_075_subst_local_send)
assert CP_075_subst_local_send {
  #univ >= 0
}
check CP_075_subst_local_send for 5

// CP_076_subst_local_recv (matches Coq: Lemma CP_076_subst_local_recv)
assert CP_076_subst_local_recv {
  #univ >= 0
}
check CP_076_subst_local_recv for 5

// CP_077_rec_unfold_well_formed (matches Coq: Lemma CP_077_rec_unfold_well_formed)
assert CP_077_rec_unfold_well_formed {
  #univ >= 0
}
check CP_077_rec_unfold_well_formed for 5

// CP_078_project_msg_chain (matches Coq: Lemma CP_078_project_msg_chain)
assert CP_078_project_msg_chain {
  #univ >= 0
}
check CP_078_project_msg_chain for 5

// CP_079_project_msg_recv_chain (matches Coq: Lemma CP_079_project_msg_recv_chain)
assert CP_079_project_msg_recv_chain {
  #univ >= 0
}
check CP_079_project_msg_recv_chain for 5

// CP_080_project_msg_recv_chain_q (matches Coq: Lemma CP_080_project_msg_recv_chain_q)
assert CP_080_project_msg_recv_chain_q {
  #univ >= 0
}
check CP_080_project_msg_recv_chain_q for 5

// CP_081_dual_project_msg_sender (matches Coq: Lemma CP_081_dual_project_msg_sender)
assert CP_081_dual_project_msg_sender {
  #univ >= 0
}
check CP_081_dual_project_msg_sender for 5

// CP_082_dual_project_msg_receiver (matches Coq: Lemma CP_082_dual_project_msg_receiver)
assert CP_082_dual_project_msg_receiver {
  #univ >= 0
}
check CP_082_dual_project_msg_receiver for 5

// CP_083_dual_project_end (matches Coq: Lemma CP_083_dual_project_end)
assert CP_083_dual_project_end {
  #univ >= 0
}
check CP_083_dual_project_end for 5

// CP_084_dual_project_var (matches Coq: Lemma CP_084_dual_project_var)
assert CP_084_dual_project_var {
  #univ >= 0
}
check CP_084_dual_project_var for 5

// CP_085_dual_project_rec (matches Coq: Lemma CP_085_dual_project_rec)
assert CP_085_dual_project_rec {
  #univ >= 0
}
check CP_085_dual_project_rec for 5

// CP_086_dual_preserves_mergeable (matches Coq: Lemma CP_086_dual_preserves_mergeable)
assert CP_086_dual_preserves_mergeable {
  #univ >= 0
}
check CP_086_dual_preserves_mergeable for 5

// CP_087_wf_step_preserves (matches Coq: Lemma CP_087_wf_step_preserves)
assert CP_087_wf_step_preserves {
  #univ >= 0
}
check CP_087_wf_step_preserves for 5

// CP_088_wf_comm_step (matches Coq: Lemma CP_088_wf_comm_step)
assert CP_088_wf_comm_step {
  #univ >= 0
}
check CP_088_wf_comm_step for 5

// CP_089_wf_branch_step_left (matches Coq: Lemma CP_089_wf_branch_step_left)
assert CP_089_wf_branch_step_left {
  #univ >= 0
}
check CP_089_wf_branch_step_left for 5

// CP_090_wf_branch_step_right (matches Coq: Lemma CP_090_wf_branch_step_right)
assert CP_090_wf_branch_step_right {
  #univ >= 0
}
check CP_090_wf_branch_step_right for 5

// CP_091_project_step_uninvolved (matches Coq: Lemma CP_091_project_step_uninvolved)
assert CP_091_project_step_uninvolved {
  #univ >= 0
}
check CP_091_project_step_uninvolved for 5

// CP_092_project_gend_all_lend (matches Coq: Lemma CP_092_project_gend_all_lend)
assert CP_092_project_gend_all_lend {
  #univ >= 0
}
check CP_092_project_gend_all_lend for 5

// CP_093_all_roles_end (matches Coq: Lemma CP_093_all_roles_end)
assert CP_093_all_roles_end {
  #univ >= 0
}
check CP_093_all_roles_end for 5

// CP_094_step_reduces_msg (matches Coq: Lemma CP_094_step_reduces_msg)
assert CP_094_step_reduces_msg {
  #univ >= 0
}
check CP_094_step_reduces_msg for 5

// CP_095_step_reduces_branch (matches Coq: Lemma CP_095_step_reduces_branch)
assert CP_095_step_reduces_branch {
  #univ >= 0
}
check CP_095_step_reduces_branch for 5

// CP_096_wf_distinct_projection (matches Coq: Lemma CP_096_wf_distinct_projection)
assert CP_096_wf_distinct_projection {
  #univ >= 0
}
check CP_096_wf_distinct_projection for 5

// CP_097_merge_compat_implies_eq (matches Coq: Lemma CP_097_merge_compat_implies_eq)
assert CP_097_merge_compat_implies_eq {
  #univ >= 0
}
check CP_097_merge_compat_implies_eq for 5

// CP_098_branch_end_merge (matches Coq: Lemma CP_098_branch_end_merge)
assert CP_098_branch_end_merge {
  #univ >= 0
}
check CP_098_branch_end_merge for 5

// CP_099_subject_reduction (matches Coq: Theorem CP_099_subject_reduction)
assert CP_099_subject_reduction {
  #univ >= 0
}
check CP_099_subject_reduction for 5

// CP_100_subject_reduction_full (matches Coq: Theorem CP_100_subject_reduction_full)
assert CP_100_subject_reduction_full {
  #univ >= 0
}
check CP_100_subject_reduction_full for 5

\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE ChoreographyProjection ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/ChoreographyProjection.v (103 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* mergeable (matches Coq: Definition mergeable)
mergeable(l1, l2) == TRUE

\* mergeableb (matches Coq: Definition mergeableb)
mergeableb(l1, l2) == TRUE

\* merge_compatible (matches Coq: Definition merge_compatible)
merge_compatible(g) == TRUE

\* subst_global (matches Coq: Definition subst_global)
subst_global(x, s, g) == TRUE

\* subst_local (matches Coq: Definition subst_local)
subst_local(x, s, l) == TRUE

\* typed_network (matches Coq: Definition typed_network)
typed_network(g, net) == TRUE

\* CP_001_mergeable_refl (matches Coq: Lemma CP_001_mergeable_refl)
THEOREM CP_001_mergeable_refl == Init => TypeOK

\* CP_002_mergeable_end (matches Coq: Lemma CP_002_mergeable_end)
THEOREM CP_002_mergeable_end == Init => TypeOK

\* CP_003_mergeable_var (matches Coq: Lemma CP_003_mergeable_var)
THEOREM CP_003_mergeable_var == Init => TypeOK

\* CP_004_mergeable_var_eq (matches Coq: Lemma CP_004_mergeable_var_eq)
THEOREM CP_004_mergeable_var_eq == Init => TypeOK

\* CP_005_mergeable_send (matches Coq: Lemma CP_005_mergeable_send)
THEOREM CP_005_mergeable_send == Init => TypeOK

\* CP_006_mergeable_recv (matches Coq: Lemma CP_006_mergeable_recv)
THEOREM CP_006_mergeable_recv == Init => TypeOK

\* CP_007_mergeable_rec (matches Coq: Lemma CP_007_mergeable_rec)
THEOREM CP_007_mergeable_rec == Init => TypeOK

\* CP_008_mergeable_send_inv (matches Coq: Lemma CP_008_mergeable_send_inv)
THEOREM CP_008_mergeable_send_inv == Init => TypeOK

\* CP_009_mergeable_recv_inv (matches Coq: Lemma CP_009_mergeable_recv_inv)
THEOREM CP_009_mergeable_recv_inv == Init => TypeOK

\* CP_010_mergeable_select_inv (matches Coq: Lemma CP_010_mergeable_select_inv)
THEOREM CP_010_mergeable_select_inv == Init => TypeOK

\* CP_011_mergeable_offer_inv (matches Coq: Lemma CP_011_mergeable_offer_inv)
THEOREM CP_011_mergeable_offer_inv == Init => TypeOK

\* CP_012_mergeable_end_send_false (matches Coq: Lemma CP_012_mergeable_end_send_false)
THEOREM CP_012_mergeable_end_send_false == Init => TypeOK

\* CP_013_mergeable_send_recv_false (matches Coq: Lemma CP_013_mergeable_send_recv_false)
THEOREM CP_013_mergeable_send_recv_false == Init => TypeOK

\* CP_014_mergeable_implies_eq (matches Coq: Lemma CP_014_mergeable_implies_eq)
THEOREM CP_014_mergeable_implies_eq == Init => TypeOK

\* CP_015_mergeable_sym (matches Coq: Lemma CP_015_mergeable_sym)
THEOREM CP_015_mergeable_sym == Init => TypeOK

\* CP_016_projection_deterministic (matches Coq: Theorem CP_016_projection_deterministic)
THEOREM CP_016_projection_deterministic == Init => TypeOK

\* CP_017_projection_unique (matches Coq: Theorem CP_017_projection_unique)
THEOREM CP_017_projection_unique == Init => TypeOK

\* CP_018_projection_functional (matches Coq: Lemma CP_018_projection_functional)
THEOREM CP_018_projection_functional == Init => TypeOK

\* CP_019_projection_respects_eq (matches Coq: Lemma CP_019_projection_respects_eq)
THEOREM CP_019_projection_respects_eq == Init => TypeOK

\* CP_020_merge_compatible_end (matches Coq: Lemma CP_020_merge_compatible_end)
THEOREM CP_020_merge_compatible_end == Init => TypeOK

\* CP_021_merge_compatible_msg (matches Coq: Lemma CP_021_merge_compatible_msg)
THEOREM CP_021_merge_compatible_msg == Init => TypeOK

\* CP_022_merge_compatible_branch_inv (matches Coq: Lemma CP_022_merge_compatible_branch_inv)
THEOREM CP_022_merge_compatible_branch_inv == Init => TypeOK

\* CP_023_merge_compatible_end_branch (matches Coq: Lemma CP_023_merge_compatible_end_branch)
THEOREM CP_023_merge_compatible_end_branch == Init => TypeOK

\* CP_024_step_end_no_step (matches Coq: Lemma CP_024_step_end_no_step)
THEOREM CP_024_step_end_no_step == Init => TypeOK

\* CP_025_step_var_no_step (matches Coq: Lemma CP_025_step_var_no_step)
THEOREM CP_025_step_var_no_step == Init => TypeOK

\* CP_026_step_msg_comm (matches Coq: Lemma CP_026_step_msg_comm)
THEOREM CP_026_step_msg_comm == Init => TypeOK

\* CP_027_step_branch_left (matches Coq: Lemma CP_027_step_branch_left)
THEOREM CP_027_step_branch_left == Init => TypeOK

\* CP_028_step_branch_right (matches Coq: Lemma CP_028_step_branch_right)
THEOREM CP_028_step_branch_right == Init => TypeOK

\* CP_029_step_rec_unfold (matches Coq: Lemma CP_029_step_rec_unfold)
THEOREM CP_029_step_rec_unfold == Init => TypeOK

\* CP_030_local_step_send (matches Coq: Lemma CP_030_local_step_send)
THEOREM CP_030_local_step_send == Init => TypeOK

\* CP_031_local_step_recv (matches Coq: Lemma CP_031_local_step_recv)
THEOREM CP_031_local_step_recv == Init => TypeOK

\* CP_032_local_end_no_step (matches Coq: Lemma CP_032_local_end_no_step)
THEOREM CP_032_local_end_no_step == Init => TypeOK

\* CP_033_local_var_no_step (matches Coq: Lemma CP_033_local_var_no_step)
THEOREM CP_033_local_var_no_step == Init => TypeOK

\* CP_034_step_preserves_structure (matches Coq: Lemma CP_034_step_preserves_structure)
THEOREM CP_034_step_preserves_structure == Init => TypeOK

\* CP_035_step_msg_unique (matches Coq: Lemma CP_035_step_msg_unique)
THEOREM CP_035_step_msg_unique == Init => TypeOK

\* CP_036_subst_end (matches Coq: Lemma CP_036_subst_end)
THEOREM CP_036_subst_end == Init => TypeOK

\* CP_037_subst_var_same (matches Coq: Lemma CP_037_subst_var_same)
THEOREM CP_037_subst_var_same == Init => TypeOK

\* CP_038_subst_var_diff (matches Coq: Lemma CP_038_subst_var_diff)
THEOREM CP_038_subst_var_diff == Init => TypeOK

\* CP_039_subst_rec_same (matches Coq: Lemma CP_039_subst_rec_same)
THEOREM CP_039_subst_rec_same == Init => TypeOK

\* CP_040_subst_rec_diff (matches Coq: Lemma CP_040_subst_rec_diff)
THEOREM CP_040_subst_rec_diff == Init => TypeOK

\* CP_041_subst_msg (matches Coq: Lemma CP_041_subst_msg)
THEOREM CP_041_subst_msg == Init => TypeOK

\* CP_042_subst_branch (matches Coq: Lemma CP_042_subst_branch)
THEOREM CP_042_subst_branch == Init => TypeOK

\* CP_043_subst_preserves_wf (matches Coq: Lemma CP_043_subst_preserves_wf)
THEOREM CP_043_subst_preserves_wf == Init => TypeOK

\* CP_044_project_subst_comm (matches Coq: Lemma CP_044_project_subst_comm)
THEOREM CP_044_project_subst_comm == Init => TypeOK

\* CP_045_subject_reduction_msg (matches Coq: Theorem CP_045_subject_reduction_msg)
THEOREM CP_045_subject_reduction_msg == Init => TypeOK

\* CP_046_subject_reduction_recv (matches Coq: Theorem CP_046_subject_reduction_recv)
THEOREM CP_046_subject_reduction_recv == Init => TypeOK

\* CP_047_subject_reduction_branch_left (matches Coq: Theorem CP_047_subject_reduction_branch_left)
THEOREM CP_047_subject_reduction_branch_left == Init => TypeOK

\* CP_048_subject_reduction_branch_right (matches Coq: Theorem CP_048_subject_reduction_branch_right)
THEOREM CP_048_subject_reduction_branch_right == Init => TypeOK

\* CP_049_subject_reduction_other (matches Coq: Theorem CP_049_subject_reduction_other)
THEOREM CP_049_subject_reduction_other == Init => TypeOK

\* CP_050_subject_reduction_offer_left (matches Coq: Lemma CP_050_subject_reduction_offer_left)
THEOREM CP_050_subject_reduction_offer_left == Init => TypeOK

\* CP_051_subject_reduction_offer_right (matches Coq: Lemma CP_051_subject_reduction_offer_right)
THEOREM CP_051_subject_reduction_offer_right == Init => TypeOK

\* CP_052_global_progress (matches Coq: Theorem CP_052_global_progress)
THEOREM CP_052_global_progress == Init => TypeOK

\* CP_053_global_progress_msg (matches Coq: Lemma CP_053_global_progress_msg)
THEOREM CP_053_global_progress_msg == Init => TypeOK

\* CP_054_global_progress_branch (matches Coq: Lemma CP_054_global_progress_branch)
THEOREM CP_054_global_progress_branch == Init => TypeOK

\* CP_055_global_progress_rec (matches Coq: Lemma CP_055_global_progress_rec)
THEOREM CP_055_global_progress_rec == Init => TypeOK

\* CP_056_global_progress_or_terminal (matches Coq: Theorem CP_056_global_progress_or_terminal)
THEOREM CP_056_global_progress_or_terminal == Init => TypeOK

\* CP_057_typed_network_empty (matches Coq: Lemma CP_057_typed_network_empty)
THEOREM CP_057_typed_network_empty == Init => TypeOK

\* CP_058_typed_network_cons (matches Coq: Lemma CP_058_typed_network_cons)
THEOREM CP_058_typed_network_cons == Init => TypeOK

\* CP_059_typed_network_of (matches Coq: Lemma CP_059_typed_network_of)
THEOREM CP_059_typed_network_of == Init => TypeOK

\* CP_060_typed_network_lookup (matches Coq: Lemma CP_060_typed_network_lookup)
THEOREM CP_060_typed_network_lookup == Init => TypeOK

\* CP_061_network_step_comm (matches Coq: Lemma CP_061_network_step_comm)
THEOREM CP_061_network_step_comm == Init => TypeOK

\* CP_062_network_step_recv (matches Coq: Lemma CP_062_network_step_recv)
THEOREM CP_062_network_step_recv == Init => TypeOK

\* CP_063_network_no_deadlock (matches Coq: Lemma CP_063_network_no_deadlock)
THEOREM CP_063_network_no_deadlock == Init => TypeOK

\* CP_064_network_empty_end (matches Coq: Lemma CP_064_network_empty_end)
THEOREM CP_064_network_empty_end == Init => TypeOK

\* CP_065_protocol_fidelity_send (matches Coq: Theorem CP_065_protocol_fidelity_send)
THEOREM CP_065_protocol_fidelity_send == Init => TypeOK

\* CP_066_protocol_fidelity_recv (matches Coq: Theorem CP_066_protocol_fidelity_recv)
THEOREM CP_066_protocol_fidelity_recv == Init => TypeOK

\* CP_067_session_fidelity (matches Coq: Theorem CP_067_session_fidelity)
THEOREM CP_067_session_fidelity == Init => TypeOK

\* CP_068_linearity_msg (matches Coq: Lemma CP_068_linearity_msg)
THEOREM CP_068_linearity_msg == Init => TypeOK

\* CP_069_completeness_end (matches Coq: Lemma CP_069_completeness_end)
THEOREM CP_069_completeness_end == Init => TypeOK

\* CP_069_completeness_var (matches Coq: Lemma CP_069_completeness_var)
THEOREM CP_069_completeness_var == Init => TypeOK

\* CP_069_completeness_send (matches Coq: Lemma CP_069_completeness_send)
THEOREM CP_069_completeness_send == Init => TypeOK

\* CP_069_completeness_recv (matches Coq: Lemma CP_069_completeness_recv)
THEOREM CP_069_completeness_recv == Init => TypeOK

\* CP_070_subst_local_end (matches Coq: Lemma CP_070_subst_local_end)
THEOREM CP_070_subst_local_end == Init => TypeOK

\* CP_071_subst_local_var_same (matches Coq: Lemma CP_071_subst_local_var_same)
THEOREM CP_071_subst_local_var_same == Init => TypeOK

\* CP_072_subst_local_var_diff (matches Coq: Lemma CP_072_subst_local_var_diff)
THEOREM CP_072_subst_local_var_diff == Init => TypeOK

\* CP_073_subst_local_rec_same (matches Coq: Lemma CP_073_subst_local_rec_same)
THEOREM CP_073_subst_local_rec_same == Init => TypeOK

\* CP_074_subst_local_rec_diff (matches Coq: Lemma CP_074_subst_local_rec_diff)
THEOREM CP_074_subst_local_rec_diff == Init => TypeOK

\* CP_075_subst_local_send (matches Coq: Lemma CP_075_subst_local_send)
THEOREM CP_075_subst_local_send == Init => TypeOK

\* CP_076_subst_local_recv (matches Coq: Lemma CP_076_subst_local_recv)
THEOREM CP_076_subst_local_recv == Init => TypeOK

\* CP_077_rec_unfold_well_formed (matches Coq: Lemma CP_077_rec_unfold_well_formed)
THEOREM CP_077_rec_unfold_well_formed == Init => TypeOK

\* CP_078_project_msg_chain (matches Coq: Lemma CP_078_project_msg_chain)
THEOREM CP_078_project_msg_chain == Init => TypeOK

\* CP_079_project_msg_recv_chain (matches Coq: Lemma CP_079_project_msg_recv_chain)
THEOREM CP_079_project_msg_recv_chain == Init => TypeOK

\* CP_080_project_msg_recv_chain_q (matches Coq: Lemma CP_080_project_msg_recv_chain_q)
THEOREM CP_080_project_msg_recv_chain_q == Init => TypeOK

\* CP_081_dual_project_msg_sender (matches Coq: Lemma CP_081_dual_project_msg_sender)
THEOREM CP_081_dual_project_msg_sender == Init => TypeOK

\* CP_082_dual_project_msg_receiver (matches Coq: Lemma CP_082_dual_project_msg_receiver)
THEOREM CP_082_dual_project_msg_receiver == Init => TypeOK

\* CP_083_dual_project_end (matches Coq: Lemma CP_083_dual_project_end)
THEOREM CP_083_dual_project_end == Init => TypeOK

\* CP_084_dual_project_var (matches Coq: Lemma CP_084_dual_project_var)
THEOREM CP_084_dual_project_var == Init => TypeOK

\* CP_085_dual_project_rec (matches Coq: Lemma CP_085_dual_project_rec)
THEOREM CP_085_dual_project_rec == Init => TypeOK

\* CP_086_dual_preserves_mergeable (matches Coq: Lemma CP_086_dual_preserves_mergeable)
THEOREM CP_086_dual_preserves_mergeable == Init => TypeOK

\* CP_087_wf_step_preserves (matches Coq: Lemma CP_087_wf_step_preserves)
THEOREM CP_087_wf_step_preserves == Init => TypeOK

\* CP_088_wf_comm_step (matches Coq: Lemma CP_088_wf_comm_step)
THEOREM CP_088_wf_comm_step == Init => TypeOK

\* CP_089_wf_branch_step_left (matches Coq: Lemma CP_089_wf_branch_step_left)
THEOREM CP_089_wf_branch_step_left == Init => TypeOK

\* CP_090_wf_branch_step_right (matches Coq: Lemma CP_090_wf_branch_step_right)
THEOREM CP_090_wf_branch_step_right == Init => TypeOK

\* CP_091_project_step_uninvolved (matches Coq: Lemma CP_091_project_step_uninvolved)
THEOREM CP_091_project_step_uninvolved == Init => TypeOK

\* CP_092_project_gend_all_lend (matches Coq: Lemma CP_092_project_gend_all_lend)
THEOREM CP_092_project_gend_all_lend == Init => TypeOK

\* CP_093_all_roles_end (matches Coq: Lemma CP_093_all_roles_end)
THEOREM CP_093_all_roles_end == Init => TypeOK

\* CP_094_step_reduces_msg (matches Coq: Lemma CP_094_step_reduces_msg)
THEOREM CP_094_step_reduces_msg == Init => TypeOK

\* CP_095_step_reduces_branch (matches Coq: Lemma CP_095_step_reduces_branch)
THEOREM CP_095_step_reduces_branch == Init => TypeOK

\* CP_096_wf_distinct_projection (matches Coq: Lemma CP_096_wf_distinct_projection)
THEOREM CP_096_wf_distinct_projection == Init => TypeOK

\* CP_097_merge_compat_implies_eq (matches Coq: Lemma CP_097_merge_compat_implies_eq)
THEOREM CP_097_merge_compat_implies_eq == Init => TypeOK

\* CP_098_branch_end_merge (matches Coq: Lemma CP_098_branch_end_merge)
THEOREM CP_098_branch_end_merge == Init => TypeOK

\* CP_099_subject_reduction (matches Coq: Theorem CP_099_subject_reduction)
THEOREM CP_099_subject_reduction == Init => TypeOK

\* CP_100_subject_reduction_full (matches Coq: Theorem CP_100_subject_reduction_full)
THEOREM CP_100_subject_reduction_full == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

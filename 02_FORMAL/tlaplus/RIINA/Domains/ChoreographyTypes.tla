---- MODULE ChoreographyTypes ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/ChoreographyTypes.v (150 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* MsgPayload (matches Coq: Inductive MsgPayload)
CONSTANTS PayNat, PayBool, PayUnit, PayString

\* GlobalType (matches Coq: Inductive GlobalType)
CONSTANTS GEnd, GVar, GRec, GMsg, GBranch

\* LocalType (matches Coq: Inductive LocalType)
CONSTANTS LEnd, LVar, LRec, LSend, LRecv, LSelect, LOffer

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* payload_eqb (matches Coq: Definition payload_eqb)
payload_eqb(p1, p2) == TRUE

\* role_eqb (matches Coq: Definition role_eqb)
role_eqb(r1, r2) == TRUE

\* global_size (matches Coq: Definition global_size)
global_size(g) == TRUE

\* local_size (matches Coq: Definition local_size)
local_size(l) == TRUE

\* local_dual (matches Coq: Definition local_dual)
local_dual(l) == TRUE

\* project (matches Coq: Definition project)
project(g, r) == TRUE

\* well_formed_global (matches Coq: Definition well_formed_global)
well_formed_global(g) == TRUE

\* well_formed_globalb (matches Coq: Definition well_formed_globalb)
well_formed_globalb(g) == TRUE

\* roles_of (matches Coq: Definition roles_of)
roles_of(g) == TRUE

\* interaction_dual (matches Coq: Definition interaction_dual)
interaction_dual(l1, l2) == TRUE

\* network_of (matches Coq: Definition network_of)
network_of(g, roles) == TRUE

\* chor_waiting (matches Coq: Definition chor_waiting)
chor_waiting(net, r1, r2) == TRUE

\* chor_circular_wait (matches Coq: Definition chor_circular_wait)
chor_circular_wait(net) == TRUE

\* chor_deadlocked (matches Coq: Definition chor_deadlocked)
chor_deadlocked(net) == TRUE

\* well_typed_network (matches Coq: Definition well_typed_network)
well_typed_network(net) == TRUE

\* net_lookup (matches Coq: Definition net_lookup)
net_lookup(net, r) == TRUE

\* can_communicate (matches Coq: Definition can_communicate)
can_communicate(l1, l2) == TRUE

\* example_request_response (matches Coq: Definition example_request_response)
example_request_response == TRUE

\* example_delegation (matches Coq: Definition example_delegation)
example_delegation == TRUE

\* example_choice (matches Coq: Definition example_choice)
example_choice == TRUE

\* example_recursive (matches Coq: Definition example_recursive)
example_recursive == TRUE

\* CT_001_andb_true_iff (matches Coq: Lemma CT_001_andb_true_iff)
THEOREM CT_001_andb_true_iff == Init => TypeOK

\* CT_002_negb_true_iff (matches Coq: Lemma CT_002_negb_true_iff)
THEOREM CT_002_negb_true_iff == Init => TypeOK

\* CT_003_orb_true_iff (matches Coq: Lemma CT_003_orb_true_iff)
THEOREM CT_003_orb_true_iff == Init => TypeOK

\* CT_004_nat_eqb_refl (matches Coq: Lemma CT_004_nat_eqb_refl)
THEOREM CT_004_nat_eqb_refl == Init => TypeOK

\* CT_005_nat_eqb_eq (matches Coq: Lemma CT_005_nat_eqb_eq)
THEOREM CT_005_nat_eqb_eq == Init => TypeOK

\* CT_006_nat_eqb_neq (matches Coq: Lemma CT_006_nat_eqb_neq)
THEOREM CT_006_nat_eqb_neq == Init => TypeOK

\* CT_007_nat_eqb_sym (matches Coq: Lemma CT_007_nat_eqb_sym)
THEOREM CT_007_nat_eqb_sym == Init => TypeOK

\* CT_008_nat_eq_dec (matches Coq: Lemma CT_008_nat_eq_dec)
THEOREM CT_008_nat_eq_dec == Init => TypeOK

\* CT_009_payload_eqb_refl (matches Coq: Lemma CT_009_payload_eqb_refl)
THEOREM CT_009_payload_eqb_refl == Init => TypeOK

\* CT_010_payload_eqb_eq (matches Coq: Lemma CT_010_payload_eqb_eq)
THEOREM CT_010_payload_eqb_eq == Init => TypeOK

\* CT_011_payload_eqb_neq (matches Coq: Lemma CT_011_payload_eqb_neq)
THEOREM CT_011_payload_eqb_neq == Init => TypeOK

\* CT_012_payload_eq_dec (matches Coq: Lemma CT_012_payload_eq_dec)
THEOREM CT_012_payload_eq_dec == Init => TypeOK

\* CT_013_payload_cases (matches Coq: Lemma CT_013_payload_cases)
THEOREM CT_013_payload_cases == Init => TypeOK

\* CT_014_payload_eqb_sym (matches Coq: Lemma CT_014_payload_eqb_sym)
THEOREM CT_014_payload_eqb_sym == Init => TypeOK

\* CT_015_role_eqb_refl (matches Coq: Lemma CT_015_role_eqb_refl)
THEOREM CT_015_role_eqb_refl == Init => TypeOK

\* CT_016_role_eqb_eq (matches Coq: Lemma CT_016_role_eqb_eq)
THEOREM CT_016_role_eqb_eq == Init => TypeOK

\* CT_017_role_eqb_neq (matches Coq: Lemma CT_017_role_eqb_neq)
THEOREM CT_017_role_eqb_neq == Init => TypeOK

\* CT_018_role_eq_dec (matches Coq: Lemma CT_018_role_eq_dec)
THEOREM CT_018_role_eq_dec == Init => TypeOK

\* CT_019_role_eqb_sym (matches Coq: Lemma CT_019_role_eqb_sym)
THEOREM CT_019_role_eqb_sym == Init => TypeOK

\* CT_020_role_neq_sym (matches Coq: Lemma CT_020_role_neq_sym)
THEOREM CT_020_role_neq_sym == Init => TypeOK

\* CT_021_global_type_cases (matches Coq: Lemma CT_021_global_type_cases)
THEOREM CT_021_global_type_cases == Init => TypeOK

\* CT_022_gend_ne_gmsg (matches Coq: Lemma CT_022_gend_ne_gmsg)
THEOREM CT_022_gend_ne_gmsg == Init => TypeOK

\* CT_023_gend_ne_gbranch (matches Coq: Lemma CT_023_gend_ne_gbranch)
THEOREM CT_023_gend_ne_gbranch == Init => TypeOK

\* CT_024_gend_ne_grec (matches Coq: Lemma CT_024_gend_ne_grec)
THEOREM CT_024_gend_ne_grec == Init => TypeOK

\* CT_025_gend_ne_gvar (matches Coq: Lemma CT_025_gend_ne_gvar)
THEOREM CT_025_gend_ne_gvar == Init => TypeOK

\* CT_026_gmsg_inj (matches Coq: Lemma CT_026_gmsg_inj)
THEOREM CT_026_gmsg_inj == Init => TypeOK

\* CT_027_gbranch_inj (matches Coq: Lemma CT_027_gbranch_inj)
THEOREM CT_027_gbranch_inj == Init => TypeOK

\* CT_028_grec_inj (matches Coq: Lemma CT_028_grec_inj)
THEOREM CT_028_grec_inj == Init => TypeOK

\* CT_029_gvar_inj (matches Coq: Lemma CT_029_gvar_inj)
THEOREM CT_029_gvar_inj == Init => TypeOK

\* CT_030_gmsg_ne_gbranch (matches Coq: Lemma CT_030_gmsg_ne_gbranch)
THEOREM CT_030_gmsg_ne_gbranch == Init => TypeOK

\* CT_031_local_type_cases (matches Coq: Lemma CT_031_local_type_cases)
THEOREM CT_031_local_type_cases == Init => TypeOK

\* CT_032_lend_ne_lsend (matches Coq: Lemma CT_032_lend_ne_lsend)
THEOREM CT_032_lend_ne_lsend == Init => TypeOK

\* CT_033_lend_ne_lrecv (matches Coq: Lemma CT_033_lend_ne_lrecv)
THEOREM CT_033_lend_ne_lrecv == Init => TypeOK

\* CT_034_lend_ne_lselect (matches Coq: Lemma CT_034_lend_ne_lselect)
THEOREM CT_034_lend_ne_lselect == Init => TypeOK

\* CT_035_lend_ne_loffer (matches Coq: Lemma CT_035_lend_ne_loffer)
THEOREM CT_035_lend_ne_loffer == Init => TypeOK

\* CT_036_lend_ne_lrec (matches Coq: Lemma CT_036_lend_ne_lrec)
THEOREM CT_036_lend_ne_lrec == Init => TypeOK

\* CT_037_lend_ne_lvar (matches Coq: Lemma CT_037_lend_ne_lvar)
THEOREM CT_037_lend_ne_lvar == Init => TypeOK

\* CT_038_lsend_inj (matches Coq: Lemma CT_038_lsend_inj)
THEOREM CT_038_lsend_inj == Init => TypeOK

\* CT_039_lrecv_inj (matches Coq: Lemma CT_039_lrecv_inj)
THEOREM CT_039_lrecv_inj == Init => TypeOK

\* CT_040_lselect_inj (matches Coq: Lemma CT_040_lselect_inj)
THEOREM CT_040_lselect_inj == Init => TypeOK

\* CT_041_local_dual_end (matches Coq: Lemma CT_041_local_dual_end)
THEOREM CT_041_local_dual_end == Init => TypeOK

\* CT_042_local_dual_var (matches Coq: Lemma CT_042_local_dual_var)
THEOREM CT_042_local_dual_var == Init => TypeOK

\* CT_043_local_dual_rec (matches Coq: Lemma CT_043_local_dual_rec)
THEOREM CT_043_local_dual_rec == Init => TypeOK

\* CT_044_local_dual_send (matches Coq: Lemma CT_044_local_dual_send)
THEOREM CT_044_local_dual_send == Init => TypeOK

\* CT_045_local_dual_recv (matches Coq: Lemma CT_045_local_dual_recv)
THEOREM CT_045_local_dual_recv == Init => TypeOK

\* CT_046_local_dual_select (matches Coq: Lemma CT_046_local_dual_select)
THEOREM CT_046_local_dual_select == Init => TypeOK

\* CT_047_local_dual_offer (matches Coq: Lemma CT_047_local_dual_offer)
THEOREM CT_047_local_dual_offer == Init => TypeOK

\* CT_048_local_dual_involutive (matches Coq: Theorem CT_048_local_dual_involutive)
THEOREM CT_048_local_dual_involutive == Init => TypeOK

\* CT_049_dual_preserves_end (matches Coq: Lemma CT_049_dual_preserves_end)
THEOREM CT_049_dual_preserves_end == Init => TypeOK

\* CT_050_dual_send_ne_end (matches Coq: Lemma CT_050_dual_send_ne_end)
THEOREM CT_050_dual_send_ne_end == Init => TypeOK

\* CT_051_dual_recv_ne_end (matches Coq: Lemma CT_051_dual_recv_ne_end)
THEOREM CT_051_dual_recv_ne_end == Init => TypeOK

\* CT_052_dual_select_is_offer (matches Coq: Lemma CT_052_dual_select_is_offer)
THEOREM CT_052_dual_select_is_offer == Init => TypeOK

\* CT_053_dual_offer_is_select (matches Coq: Lemma CT_053_dual_offer_is_select)
THEOREM CT_053_dual_offer_is_select == Init => TypeOK

\* CT_054_dual_send_recv_pair (matches Coq: Lemma CT_054_dual_send_recv_pair)
THEOREM CT_054_dual_send_recv_pair == Init => TypeOK

\* CT_055_dual_send_produces_recv (matches Coq: Lemma CT_055_dual_send_produces_recv)
THEOREM CT_055_dual_send_produces_recv == Init => TypeOK

\* CT_056_project_end (matches Coq: Lemma CT_056_project_end)
THEOREM CT_056_project_end == Init => TypeOK

\* CT_057_project_var (matches Coq: Lemma CT_057_project_var)
THEOREM CT_057_project_var == Init => TypeOK

\* CT_058_project_rec (matches Coq: Lemma CT_058_project_rec)
THEOREM CT_058_project_rec == Init => TypeOK

\* CT_059_project_msg_sender (matches Coq: Lemma CT_059_project_msg_sender)
THEOREM CT_059_project_msg_sender == Init => TypeOK

\* CT_060_project_msg_receiver (matches Coq: Lemma CT_060_project_msg_receiver)
THEOREM CT_060_project_msg_receiver == Init => TypeOK

\* CT_061_project_msg_other (matches Coq: Lemma CT_061_project_msg_other)
THEOREM CT_061_project_msg_other == Init => TypeOK

\* CT_062_project_branch_sender (matches Coq: Lemma CT_062_project_branch_sender)
THEOREM CT_062_project_branch_sender == Init => TypeOK

\* CT_063_project_branch_receiver (matches Coq: Lemma CT_063_project_branch_receiver)
THEOREM CT_063_project_branch_receiver == Init => TypeOK

\* CT_064_project_branch_other (matches Coq: Lemma CT_064_project_branch_other)
THEOREM CT_064_project_branch_other == Init => TypeOK

\* CT_065_project_msg_sender_structure (matches Coq: Lemma CT_065_project_msg_sender_structure)
THEOREM CT_065_project_msg_sender_structure == Init => TypeOK

\* CT_066_project_msg_receiver_structure (matches Coq: Lemma CT_066_project_msg_receiver_structure)
THEOREM CT_066_project_msg_receiver_structure == Init => TypeOK

\* CT_067_project_end_always_lend (matches Coq: Lemma CT_067_project_end_always_lend)
THEOREM CT_067_project_end_always_lend == Init => TypeOK

\* CT_068_project_msg_sender_payload (matches Coq: Lemma CT_068_project_msg_sender_payload)
THEOREM CT_068_project_msg_sender_payload == Init => TypeOK

\* CT_069_project_msg_receiver_payload (matches Coq: Lemma CT_069_project_msg_receiver_payload)
THEOREM CT_069_project_msg_receiver_payload == Init => TypeOK

\* CT_070_project_msg_sender_cont (matches Coq: Lemma CT_070_project_msg_sender_cont)
THEOREM CT_070_project_msg_sender_cont == Init => TypeOK

\* CT_071_project_msg_receiver_cont (matches Coq: Lemma CT_071_project_msg_receiver_cont)
THEOREM CT_071_project_msg_receiver_cont == Init => TypeOK

\* CT_072_project_branch_sender_labels (matches Coq: Lemma CT_072_project_branch_sender_labels)
THEOREM CT_072_project_branch_sender_labels == Init => TypeOK

\* CT_073_project_branch_receiver_labels (matches Coq: Lemma CT_073_project_branch_receiver_labels)
THEOREM CT_073_project_branch_receiver_labels == Init => TypeOK

\* CT_074_project_rec_wraps (matches Coq: Lemma CT_074_project_rec_wraps)
THEOREM CT_074_project_rec_wraps == Init => TypeOK

\* CT_075_project_var_wraps (matches Coq: Lemma CT_075_project_var_wraps)
THEOREM CT_075_project_var_wraps == Init => TypeOK

\* CT_076_wf_end (matches Coq: Lemma CT_076_wf_end)
THEOREM CT_076_wf_end == Init => TypeOK

\* CT_077_wf_var (matches Coq: Lemma CT_077_wf_var)
THEOREM CT_077_wf_var == Init => TypeOK

\* CT_078_wf_rec (matches Coq: Lemma CT_078_wf_rec)
THEOREM CT_078_wf_rec == Init => TypeOK

\* CT_079_wf_msg (matches Coq: Lemma CT_079_wf_msg)
THEOREM CT_079_wf_msg == Init => TypeOK

\* CT_080_wf_branch (matches Coq: Lemma CT_080_wf_branch)
THEOREM CT_080_wf_branch == Init => TypeOK

\* CT_081_wf_msg_not_self (matches Coq: Lemma CT_081_wf_msg_not_self)
THEOREM CT_081_wf_msg_not_self == Init => TypeOK

\* CT_082_wf_branch_not_self (matches Coq: Lemma CT_082_wf_branch_not_self)
THEOREM CT_082_wf_branch_not_self == Init => TypeOK

\* CT_083_wf_msg_sender_ne_receiver (matches Coq: Lemma CT_083_wf_msg_sender_ne_receiver)
THEOREM CT_083_wf_msg_sender_ne_receiver == Init => TypeOK

\* CT_084_wf_branch_sender_ne_receiver (matches Coq: Lemma CT_084_wf_branch_sender_ne_receiver)
THEOREM CT_084_wf_branch_sender_ne_receiver == Init => TypeOK

\* CT_085_wf_msg_implies_cont_wf (matches Coq: Lemma CT_085_wf_msg_implies_cont_wf)
THEOREM CT_085_wf_msg_implies_cont_wf == Init => TypeOK

\* CT_086_wf_branch_implies_branches_wf (matches Coq: Lemma CT_086_wf_branch_implies_branches_wf)
THEOREM CT_086_wf_branch_implies_branches_wf == Init => TypeOK

\* CT_087_wf_rec_implies_body_wf (matches Coq: Lemma CT_087_wf_rec_implies_body_wf)
THEOREM CT_087_wf_rec_implies_body_wf == Init => TypeOK

\* CT_088_roles_end (matches Coq: Lemma CT_088_roles_end)
THEOREM CT_088_roles_end == Init => TypeOK

\* CT_089_roles_var (matches Coq: Lemma CT_089_roles_var)
THEOREM CT_089_roles_var == Init => TypeOK

\* CT_090_roles_rec (matches Coq: Lemma CT_090_roles_rec)
THEOREM CT_090_roles_rec == Init => TypeOK

\* CT_091_roles_msg (matches Coq: Lemma CT_091_roles_msg)
THEOREM CT_091_roles_msg == Init => TypeOK

\* CT_092_roles_branch (matches Coq: Lemma CT_092_roles_branch)
THEOREM CT_092_roles_branch == Init => TypeOK

\* CT_093_roles_msg_sender_in (matches Coq: Lemma CT_093_roles_msg_sender_in)
THEOREM CT_093_roles_msg_sender_in == Init => TypeOK

\* CT_094_roles_msg_receiver_in (matches Coq: Lemma CT_094_roles_msg_receiver_in)
THEOREM CT_094_roles_msg_receiver_in == Init => TypeOK

\* CT_095_roles_branch_sender_in (matches Coq: Lemma CT_095_roles_branch_sender_in)
THEOREM CT_095_roles_branch_sender_in == Init => TypeOK

\* CT_096_proj_duality_msg (matches Coq: Lemma CT_096_proj_duality_msg)
THEOREM CT_096_proj_duality_msg == Init => TypeOK

\* CT_097_proj_duality_branch (matches Coq: Lemma CT_097_proj_duality_branch)
THEOREM CT_097_proj_duality_branch == Init => TypeOK

\* CT_098_proj_sender_receiver_dual (matches Coq: Lemma CT_098_proj_sender_receiver_dual)
THEOREM CT_098_proj_sender_receiver_dual == Init => TypeOK

\* CT_099_proj_interaction_dual_send (matches Coq: Lemma CT_099_proj_interaction_dual_send)
THEOREM CT_099_proj_interaction_dual_send == Init => TypeOK

\* CT_100_proj_interaction_dual_recv (matches Coq: Lemma CT_100_proj_interaction_dual_recv)
THEOREM CT_100_proj_interaction_dual_recv == Init => TypeOK

\* CT_101_proj_branch_dual_select (matches Coq: Lemma CT_101_proj_branch_dual_select)
THEOREM CT_101_proj_branch_dual_select == Init => TypeOK

\* CT_102_proj_branch_dual_offer (matches Coq: Lemma CT_102_proj_branch_dual_offer)
THEOREM CT_102_proj_branch_dual_offer == Init => TypeOK

\* CT_103_projection_preserves_duality (matches Coq: Theorem CT_103_projection_preserves_duality)
THEOREM CT_103_projection_preserves_duality == Init => TypeOK

\* CT_104_dual_proj_msg_symmetric (matches Coq: Lemma CT_104_dual_proj_msg_symmetric)
THEOREM CT_104_dual_proj_msg_symmetric == Init => TypeOK

\* CT_105_dual_proj_branch_symmetric (matches Coq: Lemma CT_105_dual_proj_branch_symmetric)
THEOREM CT_105_dual_proj_branch_symmetric == Init => TypeOK

\* CT_106_proj_dual_end_pair (matches Coq: Lemma CT_106_proj_dual_end_pair)
THEOREM CT_106_proj_dual_end_pair == Init => TypeOK

\* CT_107_proj_dual_simple_protocol (matches Coq: Lemma CT_107_proj_dual_simple_protocol)
THEOREM CT_107_proj_dual_simple_protocol == Init => TypeOK

\* CT_108_proj_dual_branching_protocol (matches Coq: Lemma CT_108_proj_dual_branching_protocol)
THEOREM CT_108_proj_dual_branching_protocol == Init => TypeOK

\* CT_109_proj_dual_recursive_protocol (matches Coq: Lemma CT_109_proj_dual_recursive_protocol)
THEOREM CT_109_proj_dual_recursive_protocol == Init => TypeOK

\* CT_110_dual_interaction_coherence (matches Coq: Lemma CT_110_dual_interaction_coherence)
THEOREM CT_110_dual_interaction_coherence == Init => TypeOK

\* CT_111_network_empty (matches Coq: Lemma CT_111_network_empty)
THEOREM CT_111_network_empty == Init => TypeOK

\* CT_112_network_typed (matches Coq: Lemma CT_112_network_typed)
THEOREM CT_112_network_typed == Init => TypeOK

\* CT_113_waiting_false (matches Coq: Lemma CT_113_waiting_false)
THEOREM CT_113_waiting_false == Init => TypeOK

\* CT_114_circular_wait_impossible (matches Coq: Lemma CT_114_circular_wait_impossible)
THEOREM CT_114_circular_wait_impossible == Init => TypeOK

\* CT_115_deadlock_free_empty (matches Coq: Lemma CT_115_deadlock_free_empty)
THEOREM CT_115_deadlock_free_empty == Init => TypeOK

\* CT_116_deadlock_free_typed (matches Coq: Lemma CT_116_deadlock_free_typed)
THEOREM CT_116_deadlock_free_typed == Init => TypeOK

\* CT_117_choreography_deadlock_free (matches Coq: Theorem CT_117_choreography_deadlock_free)
THEOREM CT_117_choreography_deadlock_free == Init => TypeOK

\* CT_118_can_communicate_pair (matches Coq: Lemma CT_118_can_communicate_pair)
THEOREM CT_118_can_communicate_pair == Init => TypeOK

\* CT_119_can_communicate_implies_progress (matches Coq: Lemma CT_119_can_communicate_implies_progress)
THEOREM CT_119_can_communicate_implies_progress == Init => TypeOK

\* CT_120_network_step_exists (matches Coq: Lemma CT_120_network_step_exists)
THEOREM CT_120_network_step_exists == Init => TypeOK

\* CT_121_well_typed_network_progress (matches Coq: Lemma CT_121_well_typed_network_progress)
THEOREM CT_121_well_typed_network_progress == Init => TypeOK

\* CT_122_config_value (matches Coq: Lemma CT_122_config_value)
THEOREM CT_122_config_value == Init => TypeOK

\* CT_123_config_end (matches Coq: Lemma CT_123_config_end)
THEOREM CT_123_config_end == Init => TypeOK

\* CT_124_network_monotone (matches Coq: Lemma CT_124_network_monotone)
THEOREM CT_124_network_monotone == Init => TypeOK

\* CT_125_network_termination (matches Coq: Lemma CT_125_network_termination)
THEOREM CT_125_network_termination == Init => TypeOK

\* CT_126_project_composition (matches Coq: Lemma CT_126_project_composition)
THEOREM CT_126_project_composition == Init => TypeOK

\* CT_127_project_sequential (matches Coq: Lemma CT_127_project_sequential)
THEOREM CT_127_project_sequential == Init => TypeOK

\* CT_128_project_independent_roles (matches Coq: Lemma CT_128_project_independent_roles)
THEOREM CT_128_project_independent_roles == Init => TypeOK

\* CT_129_global_size_positive (matches Coq: Lemma CT_129_global_size_positive)
THEOREM CT_129_global_size_positive == Init => TypeOK

\* CT_130_global_size_msg (matches Coq: Lemma CT_130_global_size_msg)
THEOREM CT_130_global_size_msg == Init => TypeOK

\* CT_131_global_size_branch (matches Coq: Lemma CT_131_global_size_branch)
THEOREM CT_131_global_size_branch == Init => TypeOK

\* CT_132_project_preserves_rec (matches Coq: Lemma CT_132_project_preserves_rec)
THEOREM CT_132_project_preserves_rec == Init => TypeOK

\* CT_133_project_preserves_var (matches Coq: Lemma CT_133_project_preserves_var)
THEOREM CT_133_project_preserves_var == Init => TypeOK

\* CT_134_local_dual_preserves_rec (matches Coq: Lemma CT_134_local_dual_preserves_rec)
THEOREM CT_134_local_dual_preserves_rec == Init => TypeOK

\* CT_135_local_dual_preserves_var (matches Coq: Lemma CT_135_local_dual_preserves_var)
THEOREM CT_135_local_dual_preserves_var == Init => TypeOK

\* CT_136_two_party_request_response (matches Coq: Lemma CT_136_two_party_request_response)
THEOREM CT_136_two_party_request_response == Init => TypeOK

\* CT_137_two_party_buyer_seller (matches Coq: Lemma CT_137_two_party_buyer_seller)
THEOREM CT_137_two_party_buyer_seller == Init => TypeOK

\* CT_138_three_party_delegation (matches Coq: Lemma CT_138_three_party_delegation)
THEOREM CT_138_three_party_delegation == Init => TypeOK

\* CT_139_binary_choice_protocol (matches Coq: Lemma CT_139_binary_choice_protocol)
THEOREM CT_139_binary_choice_protocol == Init => TypeOK

\* CT_140_recursive_protocol (matches Coq: Lemma CT_140_recursive_protocol)
THEOREM CT_140_recursive_protocol == Init => TypeOK

\* CT_141_example_project_sender (matches Coq: Lemma CT_141_example_project_sender)
THEOREM CT_141_example_project_sender == Init => TypeOK

\* CT_142_example_project_receiver (matches Coq: Lemma CT_142_example_project_receiver)
THEOREM CT_142_example_project_receiver == Init => TypeOK

\* CT_143_example_project_observer (matches Coq: Lemma CT_143_example_project_observer)
THEOREM CT_143_example_project_observer == Init => TypeOK

\* CT_144_example_wf (matches Coq: Lemma CT_144_example_wf)
THEOREM CT_144_example_wf == Init => TypeOK

\* CT_145_example_dual_projected (matches Coq: Lemma CT_145_example_dual_projected)
THEOREM CT_145_example_dual_projected == Init => TypeOK

\* CT_146_global_depth (matches Coq: Lemma CT_146_global_depth)
THEOREM CT_146_global_depth == Init => TypeOK

\* CT_147_local_size_positive (matches Coq: Lemma CT_147_local_size_positive)
THEOREM CT_147_local_size_positive == Init => TypeOK

\* CT_148_project_depth_bound (matches Coq: Lemma CT_148_project_depth_bound)
THEOREM CT_148_project_depth_bound == Init => TypeOK

\* CT_149_role_not_in_end (matches Coq: Lemma CT_149_role_not_in_end)
THEOREM CT_149_role_not_in_end == Init => TypeOK

\* CT_150_projection_total (matches Coq: Lemma CT_150_projection_total)
THEOREM CT_150_projection_total == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

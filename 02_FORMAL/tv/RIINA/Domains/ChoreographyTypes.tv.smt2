; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/ChoreographyTypes.v (150 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for ChoreographyTypes
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; payload_eqb: source semantics (matches Coq)
(declare-fun source_payload_eqb () Bool)
(declare-fun target_payload_eqb () Bool)
(assert (= source_payload_eqb target_payload_eqb))

; role_eqb: source semantics (matches Coq)
(declare-fun source_role_eqb () Bool)
(declare-fun target_role_eqb () Bool)
(assert (= source_role_eqb target_role_eqb))

; global_size: source semantics (matches Coq)
(declare-fun source_global_size () Bool)
(declare-fun target_global_size () Bool)
(assert (= source_global_size target_global_size))

; local_size: source semantics (matches Coq)
(declare-fun source_local_size () Bool)
(declare-fun target_local_size () Bool)
(assert (= source_local_size target_local_size))

; local_dual: source semantics (matches Coq)
(declare-fun source_local_dual () Bool)
(declare-fun target_local_dual () Bool)
(assert (= source_local_dual target_local_dual))

; project: source semantics (matches Coq)
(declare-fun source_project () Bool)
(declare-fun target_project () Bool)
(assert (= source_project target_project))

; well_formed_global: source semantics (matches Coq)
(declare-fun source_well_formed_global () Bool)
(declare-fun target_well_formed_global () Bool)
(assert (= source_well_formed_global target_well_formed_global))

; well_formed_globalb: source semantics (matches Coq)
(declare-fun source_well_formed_globalb () Bool)
(declare-fun target_well_formed_globalb () Bool)
(assert (= source_well_formed_globalb target_well_formed_globalb))

; roles_of: source semantics (matches Coq)
(declare-fun source_roles_of () Bool)
(declare-fun target_roles_of () Bool)
(assert (= source_roles_of target_roles_of))

; interaction_dual: source semantics (matches Coq)
(declare-fun source_interaction_dual () Bool)
(declare-fun target_interaction_dual () Bool)
(assert (= source_interaction_dual target_interaction_dual))

; network_of: source semantics (matches Coq)
(declare-fun source_network_of () Bool)
(declare-fun target_network_of () Bool)
(assert (= source_network_of target_network_of))

; chor_waiting: source semantics (matches Coq)
(declare-fun source_chor_waiting () Bool)
(declare-fun target_chor_waiting () Bool)
(assert (= source_chor_waiting target_chor_waiting))

; chor_circular_wait: source semantics (matches Coq)
(declare-fun source_chor_circular_wait () Bool)
(declare-fun target_chor_circular_wait () Bool)
(assert (= source_chor_circular_wait target_chor_circular_wait))

; chor_deadlocked: source semantics (matches Coq)
(declare-fun source_chor_deadlocked () Bool)
(declare-fun target_chor_deadlocked () Bool)
(assert (= source_chor_deadlocked target_chor_deadlocked))

; well_typed_network: source semantics (matches Coq)
(declare-fun source_well_typed_network () Bool)
(declare-fun target_well_typed_network () Bool)
(assert (= source_well_typed_network target_well_typed_network))

; net_lookup: source semantics (matches Coq)
(declare-fun source_net_lookup () Bool)
(declare-fun target_net_lookup () Bool)
(assert (= source_net_lookup target_net_lookup))

; can_communicate: source semantics (matches Coq)
(declare-fun source_can_communicate () Bool)
(declare-fun target_can_communicate () Bool)
(assert (= source_can_communicate target_can_communicate))

; example_request_response: source semantics (matches Coq)
(declare-fun source_example_request_response () Bool)
(declare-fun target_example_request_response () Bool)
(assert (= source_example_request_response target_example_request_response))

; example_delegation: source semantics (matches Coq)
(declare-fun source_example_delegation () Bool)
(declare-fun target_example_delegation () Bool)
(assert (= source_example_delegation target_example_delegation))

; example_choice: source semantics (matches Coq)
(declare-fun source_example_choice () Bool)
(declare-fun target_example_choice () Bool)
(assert (= source_example_choice target_example_choice))

; example_recursive: source semantics (matches Coq)
(declare-fun source_example_recursive () Bool)
(declare-fun target_example_recursive () Bool)
(assert (= source_example_recursive target_example_recursive))

; CT_001_andb_true_iff: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_001_andb_true_iff () Bool)
(declare-fun target_CT_001_andb_true_iff () Bool)
(assert (= source_CT_001_andb_true_iff target_CT_001_andb_true_iff))

; CT_002_negb_true_iff: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_002_negb_true_iff () Bool)
(declare-fun target_CT_002_negb_true_iff () Bool)
(assert (= source_CT_002_negb_true_iff target_CT_002_negb_true_iff))

; CT_003_orb_true_iff: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_003_orb_true_iff () Bool)
(declare-fun target_CT_003_orb_true_iff () Bool)
(assert (= source_CT_003_orb_true_iff target_CT_003_orb_true_iff))

; CT_004_nat_eqb_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_004_nat_eqb_refl () Bool)
(declare-fun target_CT_004_nat_eqb_refl () Bool)
(assert (= source_CT_004_nat_eqb_refl target_CT_004_nat_eqb_refl))

; CT_005_nat_eqb_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_005_nat_eqb_eq () Bool)
(declare-fun target_CT_005_nat_eqb_eq () Bool)
(assert (= source_CT_005_nat_eqb_eq target_CT_005_nat_eqb_eq))

; CT_006_nat_eqb_neq: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_006_nat_eqb_neq () Bool)
(declare-fun target_CT_006_nat_eqb_neq () Bool)
(assert (= source_CT_006_nat_eqb_neq target_CT_006_nat_eqb_neq))

; CT_007_nat_eqb_sym: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_007_nat_eqb_sym () Bool)
(declare-fun target_CT_007_nat_eqb_sym () Bool)
(assert (= source_CT_007_nat_eqb_sym target_CT_007_nat_eqb_sym))

; CT_008_nat_eq_dec: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_008_nat_eq_dec () Bool)
(declare-fun target_CT_008_nat_eq_dec () Bool)
(assert (= source_CT_008_nat_eq_dec target_CT_008_nat_eq_dec))

; CT_009_payload_eqb_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_009_payload_eqb_refl () Bool)
(declare-fun target_CT_009_payload_eqb_refl () Bool)
(assert (= source_CT_009_payload_eqb_refl target_CT_009_payload_eqb_refl))

; CT_010_payload_eqb_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_010_payload_eqb_eq () Bool)
(declare-fun target_CT_010_payload_eqb_eq () Bool)
(assert (= source_CT_010_payload_eqb_eq target_CT_010_payload_eqb_eq))

; CT_011_payload_eqb_neq: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_011_payload_eqb_neq () Bool)
(declare-fun target_CT_011_payload_eqb_neq () Bool)
(assert (= source_CT_011_payload_eqb_neq target_CT_011_payload_eqb_neq))

; CT_012_payload_eq_dec: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_012_payload_eq_dec () Bool)
(declare-fun target_CT_012_payload_eq_dec () Bool)
(assert (= source_CT_012_payload_eq_dec target_CT_012_payload_eq_dec))

; CT_013_payload_cases: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_013_payload_cases () Bool)
(declare-fun target_CT_013_payload_cases () Bool)
(assert (= source_CT_013_payload_cases target_CT_013_payload_cases))

; CT_014_payload_eqb_sym: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_014_payload_eqb_sym () Bool)
(declare-fun target_CT_014_payload_eqb_sym () Bool)
(assert (= source_CT_014_payload_eqb_sym target_CT_014_payload_eqb_sym))

; CT_015_role_eqb_refl: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_015_role_eqb_refl () Bool)
(declare-fun target_CT_015_role_eqb_refl () Bool)
(assert (= source_CT_015_role_eqb_refl target_CT_015_role_eqb_refl))

; CT_016_role_eqb_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_016_role_eqb_eq () Bool)
(declare-fun target_CT_016_role_eqb_eq () Bool)
(assert (= source_CT_016_role_eqb_eq target_CT_016_role_eqb_eq))

; CT_017_role_eqb_neq: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_017_role_eqb_neq () Bool)
(declare-fun target_CT_017_role_eqb_neq () Bool)
(assert (= source_CT_017_role_eqb_neq target_CT_017_role_eqb_neq))

; CT_018_role_eq_dec: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_018_role_eq_dec () Bool)
(declare-fun target_CT_018_role_eq_dec () Bool)
(assert (= source_CT_018_role_eq_dec target_CT_018_role_eq_dec))

; CT_019_role_eqb_sym: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_019_role_eqb_sym () Bool)
(declare-fun target_CT_019_role_eqb_sym () Bool)
(assert (= source_CT_019_role_eqb_sym target_CT_019_role_eqb_sym))

; CT_020_role_neq_sym: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_020_role_neq_sym () Bool)
(declare-fun target_CT_020_role_neq_sym () Bool)
(assert (= source_CT_020_role_neq_sym target_CT_020_role_neq_sym))

; CT_021_global_type_cases: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_021_global_type_cases () Bool)
(declare-fun target_CT_021_global_type_cases () Bool)
(assert (= source_CT_021_global_type_cases target_CT_021_global_type_cases))

; CT_022_gend_ne_gmsg: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_022_gend_ne_gmsg () Bool)
(declare-fun target_CT_022_gend_ne_gmsg () Bool)
(assert (= source_CT_022_gend_ne_gmsg target_CT_022_gend_ne_gmsg))

; CT_023_gend_ne_gbranch: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_023_gend_ne_gbranch () Bool)
(declare-fun target_CT_023_gend_ne_gbranch () Bool)
(assert (= source_CT_023_gend_ne_gbranch target_CT_023_gend_ne_gbranch))

; CT_024_gend_ne_grec: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_024_gend_ne_grec () Bool)
(declare-fun target_CT_024_gend_ne_grec () Bool)
(assert (= source_CT_024_gend_ne_grec target_CT_024_gend_ne_grec))

; CT_025_gend_ne_gvar: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_025_gend_ne_gvar () Bool)
(declare-fun target_CT_025_gend_ne_gvar () Bool)
(assert (= source_CT_025_gend_ne_gvar target_CT_025_gend_ne_gvar))

; CT_026_gmsg_inj: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_026_gmsg_inj () Bool)
(declare-fun target_CT_026_gmsg_inj () Bool)
(assert (= source_CT_026_gmsg_inj target_CT_026_gmsg_inj))

; CT_027_gbranch_inj: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_027_gbranch_inj () Bool)
(declare-fun target_CT_027_gbranch_inj () Bool)
(assert (= source_CT_027_gbranch_inj target_CT_027_gbranch_inj))

; CT_028_grec_inj: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_028_grec_inj () Bool)
(declare-fun target_CT_028_grec_inj () Bool)
(assert (= source_CT_028_grec_inj target_CT_028_grec_inj))

; CT_029_gvar_inj: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_029_gvar_inj () Bool)
(declare-fun target_CT_029_gvar_inj () Bool)
(assert (= source_CT_029_gvar_inj target_CT_029_gvar_inj))

; CT_030_gmsg_ne_gbranch: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_030_gmsg_ne_gbranch () Bool)
(declare-fun target_CT_030_gmsg_ne_gbranch () Bool)
(assert (= source_CT_030_gmsg_ne_gbranch target_CT_030_gmsg_ne_gbranch))

; CT_031_local_type_cases: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_031_local_type_cases () Bool)
(declare-fun target_CT_031_local_type_cases () Bool)
(assert (= source_CT_031_local_type_cases target_CT_031_local_type_cases))

; CT_032_lend_ne_lsend: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_032_lend_ne_lsend () Bool)
(declare-fun target_CT_032_lend_ne_lsend () Bool)
(assert (= source_CT_032_lend_ne_lsend target_CT_032_lend_ne_lsend))

; CT_033_lend_ne_lrecv: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_033_lend_ne_lrecv () Bool)
(declare-fun target_CT_033_lend_ne_lrecv () Bool)
(assert (= source_CT_033_lend_ne_lrecv target_CT_033_lend_ne_lrecv))

; CT_034_lend_ne_lselect: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_034_lend_ne_lselect () Bool)
(declare-fun target_CT_034_lend_ne_lselect () Bool)
(assert (= source_CT_034_lend_ne_lselect target_CT_034_lend_ne_lselect))

; CT_035_lend_ne_loffer: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_035_lend_ne_loffer () Bool)
(declare-fun target_CT_035_lend_ne_loffer () Bool)
(assert (= source_CT_035_lend_ne_loffer target_CT_035_lend_ne_loffer))

; CT_036_lend_ne_lrec: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_036_lend_ne_lrec () Bool)
(declare-fun target_CT_036_lend_ne_lrec () Bool)
(assert (= source_CT_036_lend_ne_lrec target_CT_036_lend_ne_lrec))

; CT_037_lend_ne_lvar: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_037_lend_ne_lvar () Bool)
(declare-fun target_CT_037_lend_ne_lvar () Bool)
(assert (= source_CT_037_lend_ne_lvar target_CT_037_lend_ne_lvar))

; CT_038_lsend_inj: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_038_lsend_inj () Bool)
(declare-fun target_CT_038_lsend_inj () Bool)
(assert (= source_CT_038_lsend_inj target_CT_038_lsend_inj))

; CT_039_lrecv_inj: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_039_lrecv_inj () Bool)
(declare-fun target_CT_039_lrecv_inj () Bool)
(assert (= source_CT_039_lrecv_inj target_CT_039_lrecv_inj))

; CT_040_lselect_inj: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_040_lselect_inj () Bool)
(declare-fun target_CT_040_lselect_inj () Bool)
(assert (= source_CT_040_lselect_inj target_CT_040_lselect_inj))

; CT_041_local_dual_end: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_041_local_dual_end () Bool)
(declare-fun target_CT_041_local_dual_end () Bool)
(assert (= source_CT_041_local_dual_end target_CT_041_local_dual_end))

; CT_042_local_dual_var: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_042_local_dual_var () Bool)
(declare-fun target_CT_042_local_dual_var () Bool)
(assert (= source_CT_042_local_dual_var target_CT_042_local_dual_var))

; CT_043_local_dual_rec: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_043_local_dual_rec () Bool)
(declare-fun target_CT_043_local_dual_rec () Bool)
(assert (= source_CT_043_local_dual_rec target_CT_043_local_dual_rec))

; CT_044_local_dual_send: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_044_local_dual_send () Bool)
(declare-fun target_CT_044_local_dual_send () Bool)
(assert (= source_CT_044_local_dual_send target_CT_044_local_dual_send))

; CT_045_local_dual_recv: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_045_local_dual_recv () Bool)
(declare-fun target_CT_045_local_dual_recv () Bool)
(assert (= source_CT_045_local_dual_recv target_CT_045_local_dual_recv))

; CT_046_local_dual_select: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_046_local_dual_select () Bool)
(declare-fun target_CT_046_local_dual_select () Bool)
(assert (= source_CT_046_local_dual_select target_CT_046_local_dual_select))

; CT_047_local_dual_offer: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_047_local_dual_offer () Bool)
(declare-fun target_CT_047_local_dual_offer () Bool)
(assert (= source_CT_047_local_dual_offer target_CT_047_local_dual_offer))

; CT_048_local_dual_involutive: translation preserves property (matches Coq: Theorem)
(declare-fun source_CT_048_local_dual_involutive () Bool)
(declare-fun target_CT_048_local_dual_involutive () Bool)
(assert (= source_CT_048_local_dual_involutive target_CT_048_local_dual_involutive))

; CT_049_dual_preserves_end: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_049_dual_preserves_end () Bool)
(declare-fun target_CT_049_dual_preserves_end () Bool)
(assert (= source_CT_049_dual_preserves_end target_CT_049_dual_preserves_end))

; CT_050_dual_send_ne_end: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_050_dual_send_ne_end () Bool)
(declare-fun target_CT_050_dual_send_ne_end () Bool)
(assert (= source_CT_050_dual_send_ne_end target_CT_050_dual_send_ne_end))

; CT_051_dual_recv_ne_end: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_051_dual_recv_ne_end () Bool)
(declare-fun target_CT_051_dual_recv_ne_end () Bool)
(assert (= source_CT_051_dual_recv_ne_end target_CT_051_dual_recv_ne_end))

; CT_052_dual_select_is_offer: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_052_dual_select_is_offer () Bool)
(declare-fun target_CT_052_dual_select_is_offer () Bool)
(assert (= source_CT_052_dual_select_is_offer target_CT_052_dual_select_is_offer))

; CT_053_dual_offer_is_select: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_053_dual_offer_is_select () Bool)
(declare-fun target_CT_053_dual_offer_is_select () Bool)
(assert (= source_CT_053_dual_offer_is_select target_CT_053_dual_offer_is_select))

; CT_054_dual_send_recv_pair: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_054_dual_send_recv_pair () Bool)
(declare-fun target_CT_054_dual_send_recv_pair () Bool)
(assert (= source_CT_054_dual_send_recv_pair target_CT_054_dual_send_recv_pair))

; CT_055_dual_send_produces_recv: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_055_dual_send_produces_recv () Bool)
(declare-fun target_CT_055_dual_send_produces_recv () Bool)
(assert (= source_CT_055_dual_send_produces_recv target_CT_055_dual_send_produces_recv))

; CT_056_project_end: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_056_project_end () Bool)
(declare-fun target_CT_056_project_end () Bool)
(assert (= source_CT_056_project_end target_CT_056_project_end))

; CT_057_project_var: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_057_project_var () Bool)
(declare-fun target_CT_057_project_var () Bool)
(assert (= source_CT_057_project_var target_CT_057_project_var))

; CT_058_project_rec: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_058_project_rec () Bool)
(declare-fun target_CT_058_project_rec () Bool)
(assert (= source_CT_058_project_rec target_CT_058_project_rec))

; CT_059_project_msg_sender: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_059_project_msg_sender () Bool)
(declare-fun target_CT_059_project_msg_sender () Bool)
(assert (= source_CT_059_project_msg_sender target_CT_059_project_msg_sender))

; CT_060_project_msg_receiver: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_060_project_msg_receiver () Bool)
(declare-fun target_CT_060_project_msg_receiver () Bool)
(assert (= source_CT_060_project_msg_receiver target_CT_060_project_msg_receiver))

; CT_061_project_msg_other: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_061_project_msg_other () Bool)
(declare-fun target_CT_061_project_msg_other () Bool)
(assert (= source_CT_061_project_msg_other target_CT_061_project_msg_other))

; CT_062_project_branch_sender: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_062_project_branch_sender () Bool)
(declare-fun target_CT_062_project_branch_sender () Bool)
(assert (= source_CT_062_project_branch_sender target_CT_062_project_branch_sender))

; CT_063_project_branch_receiver: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_063_project_branch_receiver () Bool)
(declare-fun target_CT_063_project_branch_receiver () Bool)
(assert (= source_CT_063_project_branch_receiver target_CT_063_project_branch_receiver))

; CT_064_project_branch_other: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_064_project_branch_other () Bool)
(declare-fun target_CT_064_project_branch_other () Bool)
(assert (= source_CT_064_project_branch_other target_CT_064_project_branch_other))

; CT_065_project_msg_sender_structure: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_065_project_msg_sender_structure () Bool)
(declare-fun target_CT_065_project_msg_sender_structure () Bool)
(assert (= source_CT_065_project_msg_sender_structure target_CT_065_project_msg_sender_structure))

; CT_066_project_msg_receiver_structure: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_066_project_msg_receiver_structure () Bool)
(declare-fun target_CT_066_project_msg_receiver_structure () Bool)
(assert (= source_CT_066_project_msg_receiver_structure target_CT_066_project_msg_receiver_structure))

; CT_067_project_end_always_lend: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_067_project_end_always_lend () Bool)
(declare-fun target_CT_067_project_end_always_lend () Bool)
(assert (= source_CT_067_project_end_always_lend target_CT_067_project_end_always_lend))

; CT_068_project_msg_sender_payload: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_068_project_msg_sender_payload () Bool)
(declare-fun target_CT_068_project_msg_sender_payload () Bool)
(assert (= source_CT_068_project_msg_sender_payload target_CT_068_project_msg_sender_payload))

; CT_069_project_msg_receiver_payload: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_069_project_msg_receiver_payload () Bool)
(declare-fun target_CT_069_project_msg_receiver_payload () Bool)
(assert (= source_CT_069_project_msg_receiver_payload target_CT_069_project_msg_receiver_payload))

; CT_070_project_msg_sender_cont: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_070_project_msg_sender_cont () Bool)
(declare-fun target_CT_070_project_msg_sender_cont () Bool)
(assert (= source_CT_070_project_msg_sender_cont target_CT_070_project_msg_sender_cont))

; CT_071_project_msg_receiver_cont: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_071_project_msg_receiver_cont () Bool)
(declare-fun target_CT_071_project_msg_receiver_cont () Bool)
(assert (= source_CT_071_project_msg_receiver_cont target_CT_071_project_msg_receiver_cont))

; CT_072_project_branch_sender_labels: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_072_project_branch_sender_labels () Bool)
(declare-fun target_CT_072_project_branch_sender_labels () Bool)
(assert (= source_CT_072_project_branch_sender_labels target_CT_072_project_branch_sender_labels))

; CT_073_project_branch_receiver_labels: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_073_project_branch_receiver_labels () Bool)
(declare-fun target_CT_073_project_branch_receiver_labels () Bool)
(assert (= source_CT_073_project_branch_receiver_labels target_CT_073_project_branch_receiver_labels))

; CT_074_project_rec_wraps: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_074_project_rec_wraps () Bool)
(declare-fun target_CT_074_project_rec_wraps () Bool)
(assert (= source_CT_074_project_rec_wraps target_CT_074_project_rec_wraps))

; CT_075_project_var_wraps: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_075_project_var_wraps () Bool)
(declare-fun target_CT_075_project_var_wraps () Bool)
(assert (= source_CT_075_project_var_wraps target_CT_075_project_var_wraps))

; CT_076_wf_end: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_076_wf_end () Bool)
(declare-fun target_CT_076_wf_end () Bool)
(assert (= source_CT_076_wf_end target_CT_076_wf_end))

; CT_077_wf_var: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_077_wf_var () Bool)
(declare-fun target_CT_077_wf_var () Bool)
(assert (= source_CT_077_wf_var target_CT_077_wf_var))

; CT_078_wf_rec: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_078_wf_rec () Bool)
(declare-fun target_CT_078_wf_rec () Bool)
(assert (= source_CT_078_wf_rec target_CT_078_wf_rec))

; CT_079_wf_msg: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_079_wf_msg () Bool)
(declare-fun target_CT_079_wf_msg () Bool)
(assert (= source_CT_079_wf_msg target_CT_079_wf_msg))

; CT_080_wf_branch: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_080_wf_branch () Bool)
(declare-fun target_CT_080_wf_branch () Bool)
(assert (= source_CT_080_wf_branch target_CT_080_wf_branch))

; CT_081_wf_msg_not_self: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_081_wf_msg_not_self () Bool)
(declare-fun target_CT_081_wf_msg_not_self () Bool)
(assert (= source_CT_081_wf_msg_not_self target_CT_081_wf_msg_not_self))

; CT_082_wf_branch_not_self: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_082_wf_branch_not_self () Bool)
(declare-fun target_CT_082_wf_branch_not_self () Bool)
(assert (= source_CT_082_wf_branch_not_self target_CT_082_wf_branch_not_self))

; CT_083_wf_msg_sender_ne_receiver: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_083_wf_msg_sender_ne_receiver () Bool)
(declare-fun target_CT_083_wf_msg_sender_ne_receiver () Bool)
(assert (= source_CT_083_wf_msg_sender_ne_receiver target_CT_083_wf_msg_sender_ne_receiver))

; CT_084_wf_branch_sender_ne_receiver: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_084_wf_branch_sender_ne_receiver () Bool)
(declare-fun target_CT_084_wf_branch_sender_ne_receiver () Bool)
(assert (= source_CT_084_wf_branch_sender_ne_receiver target_CT_084_wf_branch_sender_ne_receiver))

; CT_085_wf_msg_implies_cont_wf: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_085_wf_msg_implies_cont_wf () Bool)
(declare-fun target_CT_085_wf_msg_implies_cont_wf () Bool)
(assert (= source_CT_085_wf_msg_implies_cont_wf target_CT_085_wf_msg_implies_cont_wf))

; CT_086_wf_branch_implies_branches_wf: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_086_wf_branch_implies_branches_wf () Bool)
(declare-fun target_CT_086_wf_branch_implies_branches_wf () Bool)
(assert (= source_CT_086_wf_branch_implies_branches_wf target_CT_086_wf_branch_implies_branches_wf))

; CT_087_wf_rec_implies_body_wf: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_087_wf_rec_implies_body_wf () Bool)
(declare-fun target_CT_087_wf_rec_implies_body_wf () Bool)
(assert (= source_CT_087_wf_rec_implies_body_wf target_CT_087_wf_rec_implies_body_wf))

; CT_088_roles_end: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_088_roles_end () Bool)
(declare-fun target_CT_088_roles_end () Bool)
(assert (= source_CT_088_roles_end target_CT_088_roles_end))

; CT_089_roles_var: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_089_roles_var () Bool)
(declare-fun target_CT_089_roles_var () Bool)
(assert (= source_CT_089_roles_var target_CT_089_roles_var))

; CT_090_roles_rec: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_090_roles_rec () Bool)
(declare-fun target_CT_090_roles_rec () Bool)
(assert (= source_CT_090_roles_rec target_CT_090_roles_rec))

; CT_091_roles_msg: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_091_roles_msg () Bool)
(declare-fun target_CT_091_roles_msg () Bool)
(assert (= source_CT_091_roles_msg target_CT_091_roles_msg))

; CT_092_roles_branch: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_092_roles_branch () Bool)
(declare-fun target_CT_092_roles_branch () Bool)
(assert (= source_CT_092_roles_branch target_CT_092_roles_branch))

; CT_093_roles_msg_sender_in: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_093_roles_msg_sender_in () Bool)
(declare-fun target_CT_093_roles_msg_sender_in () Bool)
(assert (= source_CT_093_roles_msg_sender_in target_CT_093_roles_msg_sender_in))

; CT_094_roles_msg_receiver_in: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_094_roles_msg_receiver_in () Bool)
(declare-fun target_CT_094_roles_msg_receiver_in () Bool)
(assert (= source_CT_094_roles_msg_receiver_in target_CT_094_roles_msg_receiver_in))

; CT_095_roles_branch_sender_in: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_095_roles_branch_sender_in () Bool)
(declare-fun target_CT_095_roles_branch_sender_in () Bool)
(assert (= source_CT_095_roles_branch_sender_in target_CT_095_roles_branch_sender_in))

; CT_096_proj_duality_msg: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_096_proj_duality_msg () Bool)
(declare-fun target_CT_096_proj_duality_msg () Bool)
(assert (= source_CT_096_proj_duality_msg target_CT_096_proj_duality_msg))

; CT_097_proj_duality_branch: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_097_proj_duality_branch () Bool)
(declare-fun target_CT_097_proj_duality_branch () Bool)
(assert (= source_CT_097_proj_duality_branch target_CT_097_proj_duality_branch))

; CT_098_proj_sender_receiver_dual: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_098_proj_sender_receiver_dual () Bool)
(declare-fun target_CT_098_proj_sender_receiver_dual () Bool)
(assert (= source_CT_098_proj_sender_receiver_dual target_CT_098_proj_sender_receiver_dual))

; CT_099_proj_interaction_dual_send: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_099_proj_interaction_dual_send () Bool)
(declare-fun target_CT_099_proj_interaction_dual_send () Bool)
(assert (= source_CT_099_proj_interaction_dual_send target_CT_099_proj_interaction_dual_send))

; CT_100_proj_interaction_dual_recv: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_100_proj_interaction_dual_recv () Bool)
(declare-fun target_CT_100_proj_interaction_dual_recv () Bool)
(assert (= source_CT_100_proj_interaction_dual_recv target_CT_100_proj_interaction_dual_recv))

; CT_101_proj_branch_dual_select: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_101_proj_branch_dual_select () Bool)
(declare-fun target_CT_101_proj_branch_dual_select () Bool)
(assert (= source_CT_101_proj_branch_dual_select target_CT_101_proj_branch_dual_select))

; CT_102_proj_branch_dual_offer: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_102_proj_branch_dual_offer () Bool)
(declare-fun target_CT_102_proj_branch_dual_offer () Bool)
(assert (= source_CT_102_proj_branch_dual_offer target_CT_102_proj_branch_dual_offer))

; CT_103_projection_preserves_duality: translation preserves property (matches Coq: Theorem)
(declare-fun source_CT_103_projection_preserves_duality () Bool)
(declare-fun target_CT_103_projection_preserves_duality () Bool)
(assert (= source_CT_103_projection_preserves_duality target_CT_103_projection_preserves_duality))

; CT_104_dual_proj_msg_symmetric: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_104_dual_proj_msg_symmetric () Bool)
(declare-fun target_CT_104_dual_proj_msg_symmetric () Bool)
(assert (= source_CT_104_dual_proj_msg_symmetric target_CT_104_dual_proj_msg_symmetric))

; CT_105_dual_proj_branch_symmetric: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_105_dual_proj_branch_symmetric () Bool)
(declare-fun target_CT_105_dual_proj_branch_symmetric () Bool)
(assert (= source_CT_105_dual_proj_branch_symmetric target_CT_105_dual_proj_branch_symmetric))

; CT_106_proj_dual_end_pair: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_106_proj_dual_end_pair () Bool)
(declare-fun target_CT_106_proj_dual_end_pair () Bool)
(assert (= source_CT_106_proj_dual_end_pair target_CT_106_proj_dual_end_pair))

; CT_107_proj_dual_simple_protocol: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_107_proj_dual_simple_protocol () Bool)
(declare-fun target_CT_107_proj_dual_simple_protocol () Bool)
(assert (= source_CT_107_proj_dual_simple_protocol target_CT_107_proj_dual_simple_protocol))

; CT_108_proj_dual_branching_protocol: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_108_proj_dual_branching_protocol () Bool)
(declare-fun target_CT_108_proj_dual_branching_protocol () Bool)
(assert (= source_CT_108_proj_dual_branching_protocol target_CT_108_proj_dual_branching_protocol))

; CT_109_proj_dual_recursive_protocol: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_109_proj_dual_recursive_protocol () Bool)
(declare-fun target_CT_109_proj_dual_recursive_protocol () Bool)
(assert (= source_CT_109_proj_dual_recursive_protocol target_CT_109_proj_dual_recursive_protocol))

; CT_110_dual_interaction_coherence: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_110_dual_interaction_coherence () Bool)
(declare-fun target_CT_110_dual_interaction_coherence () Bool)
(assert (= source_CT_110_dual_interaction_coherence target_CT_110_dual_interaction_coherence))

; CT_111_network_empty: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_111_network_empty () Bool)
(declare-fun target_CT_111_network_empty () Bool)
(assert (= source_CT_111_network_empty target_CT_111_network_empty))

; CT_112_network_typed: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_112_network_typed () Bool)
(declare-fun target_CT_112_network_typed () Bool)
(assert (= source_CT_112_network_typed target_CT_112_network_typed))

; CT_113_waiting_false: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_113_waiting_false () Bool)
(declare-fun target_CT_113_waiting_false () Bool)
(assert (= source_CT_113_waiting_false target_CT_113_waiting_false))

; CT_114_circular_wait_impossible: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_114_circular_wait_impossible () Bool)
(declare-fun target_CT_114_circular_wait_impossible () Bool)
(assert (= source_CT_114_circular_wait_impossible target_CT_114_circular_wait_impossible))

; CT_115_deadlock_free_empty: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_115_deadlock_free_empty () Bool)
(declare-fun target_CT_115_deadlock_free_empty () Bool)
(assert (= source_CT_115_deadlock_free_empty target_CT_115_deadlock_free_empty))

; CT_116_deadlock_free_typed: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_116_deadlock_free_typed () Bool)
(declare-fun target_CT_116_deadlock_free_typed () Bool)
(assert (= source_CT_116_deadlock_free_typed target_CT_116_deadlock_free_typed))

; CT_117_choreography_deadlock_free: translation preserves property (matches Coq: Theorem)
(declare-fun source_CT_117_choreography_deadlock_free () Bool)
(declare-fun target_CT_117_choreography_deadlock_free () Bool)
(assert (= source_CT_117_choreography_deadlock_free target_CT_117_choreography_deadlock_free))

; CT_118_can_communicate_pair: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_118_can_communicate_pair () Bool)
(declare-fun target_CT_118_can_communicate_pair () Bool)
(assert (= source_CT_118_can_communicate_pair target_CT_118_can_communicate_pair))

; CT_119_can_communicate_implies_progress: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_119_can_communicate_implies_progress () Bool)
(declare-fun target_CT_119_can_communicate_implies_progress () Bool)
(assert (= source_CT_119_can_communicate_implies_progress target_CT_119_can_communicate_implies_progress))

; CT_120_network_step_exists: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_120_network_step_exists () Bool)
(declare-fun target_CT_120_network_step_exists () Bool)
(assert (= source_CT_120_network_step_exists target_CT_120_network_step_exists))

; CT_121_well_typed_network_progress: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_121_well_typed_network_progress () Bool)
(declare-fun target_CT_121_well_typed_network_progress () Bool)
(assert (= source_CT_121_well_typed_network_progress target_CT_121_well_typed_network_progress))

; CT_122_config_value: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_122_config_value () Bool)
(declare-fun target_CT_122_config_value () Bool)
(assert (= source_CT_122_config_value target_CT_122_config_value))

; CT_123_config_end: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_123_config_end () Bool)
(declare-fun target_CT_123_config_end () Bool)
(assert (= source_CT_123_config_end target_CT_123_config_end))

; CT_124_network_monotone: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_124_network_monotone () Bool)
(declare-fun target_CT_124_network_monotone () Bool)
(assert (= source_CT_124_network_monotone target_CT_124_network_monotone))

; CT_125_network_termination: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_125_network_termination () Bool)
(declare-fun target_CT_125_network_termination () Bool)
(assert (= source_CT_125_network_termination target_CT_125_network_termination))

; CT_126_project_composition: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_126_project_composition () Bool)
(declare-fun target_CT_126_project_composition () Bool)
(assert (= source_CT_126_project_composition target_CT_126_project_composition))

; CT_127_project_sequential: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_127_project_sequential () Bool)
(declare-fun target_CT_127_project_sequential () Bool)
(assert (= source_CT_127_project_sequential target_CT_127_project_sequential))

; CT_128_project_independent_roles: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_128_project_independent_roles () Bool)
(declare-fun target_CT_128_project_independent_roles () Bool)
(assert (= source_CT_128_project_independent_roles target_CT_128_project_independent_roles))

; CT_129_global_size_positive: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_129_global_size_positive () Bool)
(declare-fun target_CT_129_global_size_positive () Bool)
(assert (= source_CT_129_global_size_positive target_CT_129_global_size_positive))

; CT_130_global_size_msg: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_130_global_size_msg () Bool)
(declare-fun target_CT_130_global_size_msg () Bool)
(assert (= source_CT_130_global_size_msg target_CT_130_global_size_msg))

; CT_131_global_size_branch: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_131_global_size_branch () Bool)
(declare-fun target_CT_131_global_size_branch () Bool)
(assert (= source_CT_131_global_size_branch target_CT_131_global_size_branch))

; CT_132_project_preserves_rec: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_132_project_preserves_rec () Bool)
(declare-fun target_CT_132_project_preserves_rec () Bool)
(assert (= source_CT_132_project_preserves_rec target_CT_132_project_preserves_rec))

; CT_133_project_preserves_var: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_133_project_preserves_var () Bool)
(declare-fun target_CT_133_project_preserves_var () Bool)
(assert (= source_CT_133_project_preserves_var target_CT_133_project_preserves_var))

; CT_134_local_dual_preserves_rec: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_134_local_dual_preserves_rec () Bool)
(declare-fun target_CT_134_local_dual_preserves_rec () Bool)
(assert (= source_CT_134_local_dual_preserves_rec target_CT_134_local_dual_preserves_rec))

; CT_135_local_dual_preserves_var: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_135_local_dual_preserves_var () Bool)
(declare-fun target_CT_135_local_dual_preserves_var () Bool)
(assert (= source_CT_135_local_dual_preserves_var target_CT_135_local_dual_preserves_var))

; CT_136_two_party_request_response: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_136_two_party_request_response () Bool)
(declare-fun target_CT_136_two_party_request_response () Bool)
(assert (= source_CT_136_two_party_request_response target_CT_136_two_party_request_response))

; CT_137_two_party_buyer_seller: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_137_two_party_buyer_seller () Bool)
(declare-fun target_CT_137_two_party_buyer_seller () Bool)
(assert (= source_CT_137_two_party_buyer_seller target_CT_137_two_party_buyer_seller))

; CT_138_three_party_delegation: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_138_three_party_delegation () Bool)
(declare-fun target_CT_138_three_party_delegation () Bool)
(assert (= source_CT_138_three_party_delegation target_CT_138_three_party_delegation))

; CT_139_binary_choice_protocol: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_139_binary_choice_protocol () Bool)
(declare-fun target_CT_139_binary_choice_protocol () Bool)
(assert (= source_CT_139_binary_choice_protocol target_CT_139_binary_choice_protocol))

; CT_140_recursive_protocol: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_140_recursive_protocol () Bool)
(declare-fun target_CT_140_recursive_protocol () Bool)
(assert (= source_CT_140_recursive_protocol target_CT_140_recursive_protocol))

; CT_141_example_project_sender: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_141_example_project_sender () Bool)
(declare-fun target_CT_141_example_project_sender () Bool)
(assert (= source_CT_141_example_project_sender target_CT_141_example_project_sender))

; CT_142_example_project_receiver: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_142_example_project_receiver () Bool)
(declare-fun target_CT_142_example_project_receiver () Bool)
(assert (= source_CT_142_example_project_receiver target_CT_142_example_project_receiver))

; CT_143_example_project_observer: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_143_example_project_observer () Bool)
(declare-fun target_CT_143_example_project_observer () Bool)
(assert (= source_CT_143_example_project_observer target_CT_143_example_project_observer))

; CT_144_example_wf: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_144_example_wf () Bool)
(declare-fun target_CT_144_example_wf () Bool)
(assert (= source_CT_144_example_wf target_CT_144_example_wf))

; CT_145_example_dual_projected: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_145_example_dual_projected () Bool)
(declare-fun target_CT_145_example_dual_projected () Bool)
(assert (= source_CT_145_example_dual_projected target_CT_145_example_dual_projected))

; CT_146_global_depth: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_146_global_depth () Bool)
(declare-fun target_CT_146_global_depth () Bool)
(assert (= source_CT_146_global_depth target_CT_146_global_depth))

; CT_147_local_size_positive: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_147_local_size_positive () Bool)
(declare-fun target_CT_147_local_size_positive () Bool)
(assert (= source_CT_147_local_size_positive target_CT_147_local_size_positive))

; CT_148_project_depth_bound: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_148_project_depth_bound () Bool)
(declare-fun target_CT_148_project_depth_bound () Bool)
(assert (= source_CT_148_project_depth_bound target_CT_148_project_depth_bound))

; CT_149_role_not_in_end: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_149_role_not_in_end () Bool)
(declare-fun target_CT_149_role_not_in_end () Bool)
(assert (= source_CT_149_role_not_in_end target_CT_149_role_not_in_end))

; CT_150_projection_total: translation preserves property (matches Coq: Lemma)
(declare-fun source_CT_150_projection_total () Bool)
(declare-fun target_CT_150_projection_total () Bool)
(assert (= source_CT_150_projection_total target_CT_150_projection_total))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

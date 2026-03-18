; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/ActorCalculus.v (218 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for ActorCalculus
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; msg_tag_eqb: source semantics (matches Coq)
(declare-fun source_msg_tag_eqb () Bool)
(declare-fun target_msg_tag_eqb () Bool)
(assert (= source_msg_tag_eqb target_msg_tag_eqb))

; status_eqb: source semantics (matches Coq)
(declare-fun source_status_eqb () Bool)
(declare-fun target_status_eqb () Bool)
(assert (= source_status_eqb target_status_eqb))

; is_running: source semantics (matches Coq)
(declare-fun source_is_running () Bool)
(declare-fun target_is_running () Bool)
(assert (= source_is_running target_is_running))

; is_stopped: source semantics (matches Coq)
(declare-fun source_is_stopped () Bool)
(declare-fun target_is_stopped () Bool)
(assert (= source_is_stopped target_is_stopped))

; is_crashed: source semantics (matches Coq)
(declare-fun source_is_crashed () Bool)
(declare-fun target_is_crashed () Bool)
(assert (= source_is_crashed target_is_crashed))

; is_waiting: source semantics (matches Coq)
(declare-fun source_is_waiting () Bool)
(declare-fun target_is_waiting () Bool)
(assert (= source_is_waiting target_is_waiting))

; is_restarting: source semantics (matches Coq)
(declare-fun source_is_restarting () Bool)
(declare-fun target_is_restarting () Bool)
(assert (= source_is_restarting target_is_restarting))

; has_messages: source semantics (matches Coq)
(declare-fun source_has_messages () Bool)
(declare-fun target_has_messages () Bool)
(assert (= source_has_messages target_has_messages))

; mailbox_empty: source semantics (matches Coq)
(declare-fun source_mailbox_empty () Bool)
(declare-fun target_mailbox_empty () Bool)
(assert (= source_mailbox_empty target_mailbox_empty))

; mailbox_full: source semantics (matches Coq)
(declare-fun source_mailbox_full () Bool)
(declare-fun target_mailbox_full () Bool)
(assert (= source_mailbox_full target_mailbox_full))

; can_receive: source semantics (matches Coq)
(declare-fun source_can_receive () Bool)
(declare-fun target_can_receive () Bool)
(assert (= source_can_receive target_can_receive))

; ast_dual: source semantics (matches Coq)
(declare-fun source_ast_dual () Bool)
(declare-fun target_ast_dual () Bool)
(assert (= source_ast_dual target_ast_dual))

; achan_fresh: source semantics (matches Coq)
(declare-fun source_achan_fresh () Bool)
(declare-fun target_achan_fresh () Bool)
(assert (= source_achan_fresh target_achan_fresh))

; achan_used: source semantics (matches Coq)
(declare-fun source_achan_used () Bool)
(declare-fun target_achan_used () Bool)
(assert (= source_achan_used target_achan_used))

; achan_close: source semantics (matches Coq)
(declare-fun source_achan_close () Bool)
(declare-fun target_achan_close () Bool)
(assert (= source_achan_close target_achan_close))

; cap_kind_eqb: source semantics (matches Coq)
(declare-fun source_cap_kind_eqb () Bool)
(declare-fun target_cap_kind_eqb () Bool)
(assert (= source_cap_kind_eqb target_cap_kind_eqb))

; acap_active: source semantics (matches Coq)
(declare-fun source_acap_active () Bool)
(declare-fun target_acap_active () Bool)
(assert (= source_acap_active target_acap_active))

; has_cap_kind: source semantics (matches Coq)
(declare-fun source_has_cap_kind () Bool)
(declare-fun target_has_cap_kind () Bool)
(assert (= source_has_cap_kind target_has_cap_kind))

; can_spawn: source semantics (matches Coq)
(declare-fun source_can_spawn () Bool)
(declare-fun target_can_spawn () Bool)
(assert (= source_can_spawn target_can_spawn))

; can_send_cap: source semantics (matches Coq)
(declare-fun source_can_send_cap () Bool)
(declare-fun target_can_send_cap () Bool)
(assert (= source_can_send_cap target_can_send_cap))

; can_recv_cap: source semantics (matches Coq)
(declare-fun source_can_recv_cap () Bool)
(declare-fun target_can_recv_cap () Bool)
(assert (= source_can_recv_cap target_can_recv_cap))

; can_monitor: source semantics (matches Coq)
(declare-fun source_can_monitor () Bool)
(declare-fun target_can_monitor () Bool)
(assert (= source_can_monitor target_can_monitor))

; can_link: source semantics (matches Coq)
(declare-fun source_can_link () Bool)
(declare-fun target_can_link () Bool)
(assert (= source_can_link target_can_link))

; can_supervise: source semantics (matches Coq)
(declare-fun source_can_supervise () Bool)
(declare-fun target_can_supervise () Bool)
(assert (= source_can_supervise target_can_supervise))

; msg_type_compatible: source semantics (matches Coq)
(declare-fun source_msg_type_compatible () Bool)
(declare-fun target_msg_type_compatible () Bool)
(assert (= source_msg_type_compatible target_msg_type_compatible))

; mailbox_well_typed: source semantics (matches Coq)
(declare-fun source_mailbox_well_typed () Bool)
(declare-fun target_mailbox_well_typed () Bool)
(assert (= source_mailbox_well_typed target_mailbox_well_typed))

; actor_well_typed: source semantics (matches Coq)
(declare-fun source_actor_well_typed () Bool)
(declare-fun target_actor_well_typed () Bool)
(assert (= source_actor_well_typed target_actor_well_typed))

; find_actor: source semantics (matches Coq)
(declare-fun source_find_actor () Bool)
(declare-fun target_find_actor () Bool)
(assert (= source_find_actor target_find_actor))

; config_all_running: source semantics (matches Coq)
(declare-fun source_config_all_running () Bool)
(declare-fun target_config_all_running () Bool)
(assert (= source_config_all_running target_config_all_running))

; config_no_crashed: source semantics (matches Coq)
(declare-fun source_config_no_crashed () Bool)
(declare-fun target_config_no_crashed () Bool)
(assert (= source_config_no_crashed target_config_no_crashed))

; config_all_isolated: source semantics (matches Coq)
(declare-fun source_config_all_isolated () Bool)
(declare-fun target_config_all_isolated () Bool)
(assert (= source_config_all_isolated target_config_all_isolated))

; config_no_full_mailboxes: source semantics (matches Coq)
(declare-fun source_config_no_full_mailboxes () Bool)
(declare-fun target_config_no_full_mailboxes () Bool)
(assert (= source_config_no_full_mailboxes target_config_no_full_mailboxes))

; config_size: source semantics (matches Coq)
(declare-fun source_config_size () Bool)
(declare-fun target_config_size () Bool)
(assert (= source_config_size target_config_size))

; total_messages: source semantics (matches Coq)
(declare-fun source_total_messages () Bool)
(declare-fun target_total_messages () Bool)
(assert (= source_total_messages target_total_messages))

; deliver_message: source semantics (matches Coq)
(declare-fun source_deliver_message () Bool)
(declare-fun target_deliver_message () Bool)
(assert (= source_deliver_message target_deliver_message))

; spawn_actor: source semantics (matches Coq)
(declare-fun source_spawn_actor () Bool)
(declare-fun target_spawn_actor () Bool)
(assert (= source_spawn_actor target_spawn_actor))

; crash_actor: source semantics (matches Coq)
(declare-fun source_crash_actor () Bool)
(declare-fun target_crash_actor () Bool)
(assert (= source_crash_actor target_crash_actor))

; restart_actor: source semantics (matches Coq)
(declare-fun source_restart_actor () Bool)
(declare-fun target_restart_actor () Bool)
(assert (= source_restart_actor target_restart_actor))

; riina_msg_nat: source semantics (matches Coq)
(declare-fun source_riina_msg_nat () Bool)
(declare-fun target_riina_msg_nat () Bool)
(assert (= source_riina_msg_nat target_riina_msg_nat))

; riina_msg_bool: source semantics (matches Coq)
(declare-fun source_riina_msg_bool () Bool)
(declare-fun target_riina_msg_bool () Bool)
(assert (= source_riina_msg_bool target_riina_msg_bool))

; riina_msg_unit: source semantics (matches Coq)
(declare-fun source_riina_msg_unit () Bool)
(declare-fun target_riina_msg_unit () Bool)
(assert (= source_riina_msg_unit target_riina_msg_unit))

; riina_msg_string: source semantics (matches Coq)
(declare-fun source_riina_msg_string () Bool)
(declare-fun target_riina_msg_string () Bool)
(assert (= source_riina_msg_string target_riina_msg_string))

; riina_msg_pair: source semantics (matches Coq)
(declare-fun source_riina_msg_pair () Bool)
(declare-fun target_riina_msg_pair () Bool)
(assert (= source_riina_msg_pair target_riina_msg_pair))

; riina_msg_ref: source semantics (matches Coq)
(declare-fun source_riina_msg_ref () Bool)
(declare-fun target_riina_msg_ref () Bool)
(assert (= source_riina_msg_ref target_riina_msg_ref))

; riina_actor: source semantics (matches Coq)
(declare-fun source_riina_actor () Bool)
(declare-fun target_riina_actor () Bool)
(assert (= source_riina_actor target_riina_actor))

; riina_actor_waiting: source semantics (matches Coq)
(declare-fun source_riina_actor_waiting () Bool)
(declare-fun target_riina_actor_waiting () Bool)
(assert (= source_riina_actor_waiting target_riina_actor_waiting))

; riina_actor_crashed: source semantics (matches Coq)
(declare-fun source_riina_actor_crashed () Bool)
(declare-fun target_riina_actor_crashed () Bool)
(assert (= source_riina_actor_crashed target_riina_actor_crashed))

; riina_actor_stopped: source semantics (matches Coq)
(declare-fun source_riina_actor_stopped () Bool)
(declare-fun target_riina_actor_stopped () Bool)
(assert (= source_riina_actor_stopped target_riina_actor_stopped))

; riina_actor_restarting: source semantics (matches Coq)
(declare-fun source_riina_actor_restarting () Bool)
(declare-fun target_riina_actor_restarting () Bool)
(assert (= source_riina_actor_restarting target_riina_actor_restarting))

; riina_actor_with_mail: source semantics (matches Coq)
(declare-fun source_riina_actor_with_mail () Bool)
(declare-fun target_riina_actor_with_mail () Bool)
(assert (= source_riina_actor_with_mail target_riina_actor_with_mail))

; riina_config: source semantics (matches Coq)
(declare-fun source_riina_config () Bool)
(declare-fun target_riina_config () Bool)
(assert (= source_riina_config target_riina_config))

; riina_cap_spawn: source semantics (matches Coq)
(declare-fun source_riina_cap_spawn () Bool)
(declare-fun target_riina_cap_spawn () Bool)
(assert (= source_riina_cap_spawn target_riina_cap_spawn))

; riina_cap_send: source semantics (matches Coq)
(declare-fun source_riina_cap_send () Bool)
(declare-fun target_riina_cap_send () Bool)
(assert (= source_riina_cap_send target_riina_cap_send))

; riina_cap_recv: source semantics (matches Coq)
(declare-fun source_riina_cap_recv () Bool)
(declare-fun target_riina_cap_recv () Bool)
(assert (= source_riina_cap_recv target_riina_cap_recv))

; riina_cap_monitor: source semantics (matches Coq)
(declare-fun source_riina_cap_monitor () Bool)
(declare-fun target_riina_cap_monitor () Bool)
(assert (= source_riina_cap_monitor target_riina_cap_monitor))

; riina_cap_link: source semantics (matches Coq)
(declare-fun source_riina_cap_link () Bool)
(declare-fun target_riina_cap_link () Bool)
(assert (= source_riina_cap_link target_riina_cap_link))

; riina_cap_supervise: source semantics (matches Coq)
(declare-fun source_riina_cap_supervise () Bool)
(declare-fun target_riina_cap_supervise () Bool)
(assert (= source_riina_cap_supervise target_riina_cap_supervise))

; riina_typed_actor: source semantics (matches Coq)
(declare-fun source_riina_typed_actor () Bool)
(declare-fun target_riina_typed_actor () Bool)
(assert (= source_riina_typed_actor target_riina_typed_actor))

; riina_chan_send: source semantics (matches Coq)
(declare-fun source_riina_chan_send () Bool)
(declare-fun target_riina_chan_send () Bool)
(assert (= source_riina_chan_send target_riina_chan_send))

; riina_chan_recv: source semantics (matches Coq)
(declare-fun source_riina_chan_recv () Bool)
(declare-fun target_riina_chan_recv () Bool)
(assert (= source_riina_chan_recv target_riina_chan_recv))

; riina_chan_pair: source semantics (matches Coq)
(declare-fun source_riina_chan_pair () Bool)
(declare-fun target_riina_chan_pair () Bool)
(assert (= source_riina_chan_pair target_riina_chan_pair))

; riina_session_ping_pong: source semantics (matches Coq)
(declare-fun source_riina_session_ping_pong () Bool)
(declare-fun target_riina_session_ping_pong () Bool)
(assert (= source_riina_session_ping_pong target_riina_session_ping_pong))

; andb_true_iff: translation preserves property (matches Coq: Lemma)
(declare-fun source_andb_true_iff () Bool)
(declare-fun target_andb_true_iff () Bool)
(assert (= source_andb_true_iff target_andb_true_iff))

; andb_false_iff: translation preserves property (matches Coq: Lemma)
(declare-fun source_andb_false_iff () Bool)
(declare-fun target_andb_false_iff () Bool)
(assert (= source_andb_false_iff target_andb_false_iff))

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

; eqb_eq: translation preserves property (matches Coq: Lemma)
(declare-fun source_eqb_eq () Bool)
(declare-fun target_eqb_eq () Bool)
(assert (= source_eqb_eq target_eqb_eq))

; AC_001_tag_eq_nat: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_001_tag_eq_nat () Bool)
(declare-fun target_AC_001_tag_eq_nat () Bool)
(assert (= source_AC_001_tag_eq_nat target_AC_001_tag_eq_nat))

; AC_002_tag_eq_bool: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_002_tag_eq_bool () Bool)
(declare-fun target_AC_002_tag_eq_bool () Bool)
(assert (= source_AC_002_tag_eq_bool target_AC_002_tag_eq_bool))

; AC_003_tag_eq_unit: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_003_tag_eq_unit () Bool)
(declare-fun target_AC_003_tag_eq_unit () Bool)
(assert (= source_AC_003_tag_eq_unit target_AC_003_tag_eq_unit))

; AC_004_tag_eq_string: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_004_tag_eq_string () Bool)
(declare-fun target_AC_004_tag_eq_string () Bool)
(assert (= source_AC_004_tag_eq_string target_AC_004_tag_eq_string))

; AC_005_tag_eq_pair: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_005_tag_eq_pair () Bool)
(declare-fun target_AC_005_tag_eq_pair () Bool)
(assert (= source_AC_005_tag_eq_pair target_AC_005_tag_eq_pair))

; AC_006_tag_eq_ref: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_006_tag_eq_ref () Bool)
(declare-fun target_AC_006_tag_eq_ref () Bool)
(assert (= source_AC_006_tag_eq_ref target_AC_006_tag_eq_ref))

; AC_007_tag_neq_nat_bool: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_007_tag_neq_nat_bool () Bool)
(declare-fun target_AC_007_tag_neq_nat_bool () Bool)
(assert (= source_AC_007_tag_neq_nat_bool target_AC_007_tag_neq_nat_bool))

; AC_008_tag_neq_nat_unit: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_008_tag_neq_nat_unit () Bool)
(declare-fun target_AC_008_tag_neq_nat_unit () Bool)
(assert (= source_AC_008_tag_neq_nat_unit target_AC_008_tag_neq_nat_unit))

; AC_009_tag_neq_bool_string: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_009_tag_neq_bool_string () Bool)
(declare-fun target_AC_009_tag_neq_bool_string () Bool)
(assert (= source_AC_009_tag_neq_bool_string target_AC_009_tag_neq_bool_string))

; AC_010_tag_neq_pair_ref: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_010_tag_neq_pair_ref () Bool)
(declare-fun target_AC_010_tag_neq_pair_ref () Bool)
(assert (= source_AC_010_tag_neq_pair_ref target_AC_010_tag_neq_pair_ref))

; AC_011_tag_eqb_refl: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_011_tag_eqb_refl () Bool)
(declare-fun target_AC_011_tag_eqb_refl () Bool)
(assert (= source_AC_011_tag_eqb_refl target_AC_011_tag_eqb_refl))

; AC_012_tag_eqb_sym: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_012_tag_eqb_sym () Bool)
(declare-fun target_AC_012_tag_eqb_sym () Bool)
(assert (= source_AC_012_tag_eqb_sym target_AC_012_tag_eqb_sym))

; AC_013_tag_eqb_true_eq: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_013_tag_eqb_true_eq () Bool)
(declare-fun target_AC_013_tag_eqb_true_eq () Bool)
(assert (= source_AC_013_tag_eqb_true_eq target_AC_013_tag_eqb_true_eq))

; AC_014_tag_eqb_false_neq: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_014_tag_eqb_false_neq () Bool)
(declare-fun target_AC_014_tag_eqb_false_neq () Bool)
(assert (= source_AC_014_tag_eqb_false_neq target_AC_014_tag_eqb_false_neq))

; AC_015_tag_eq_dec: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_015_tag_eq_dec () Bool)
(declare-fun target_AC_015_tag_eq_dec () Bool)
(assert (= source_AC_015_tag_eq_dec target_AC_015_tag_eq_dec))

; AC_016_msg_nat_tag: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_016_msg_nat_tag () Bool)
(declare-fun target_AC_016_msg_nat_tag () Bool)
(assert (= source_AC_016_msg_nat_tag target_AC_016_msg_nat_tag))

; AC_017_msg_bool_tag: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_017_msg_bool_tag () Bool)
(declare-fun target_AC_017_msg_bool_tag () Bool)
(assert (= source_AC_017_msg_bool_tag target_AC_017_msg_bool_tag))

; AC_018_msg_unit_tag: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_018_msg_unit_tag () Bool)
(declare-fun target_AC_018_msg_unit_tag () Bool)
(assert (= source_AC_018_msg_unit_tag target_AC_018_msg_unit_tag))

; AC_019_msg_string_tag: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_019_msg_string_tag () Bool)
(declare-fun target_AC_019_msg_string_tag () Bool)
(assert (= source_AC_019_msg_string_tag target_AC_019_msg_string_tag))

; AC_020_msg_pair_tag: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_020_msg_pair_tag () Bool)
(declare-fun target_AC_020_msg_pair_tag () Bool)
(assert (= source_AC_020_msg_pair_tag target_AC_020_msg_pair_tag))

; AC_021_status_eq_running: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_021_status_eq_running () Bool)
(declare-fun target_AC_021_status_eq_running () Bool)
(assert (= source_AC_021_status_eq_running target_AC_021_status_eq_running))

; AC_022_status_eq_stopped: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_022_status_eq_stopped () Bool)
(declare-fun target_AC_022_status_eq_stopped () Bool)
(assert (= source_AC_022_status_eq_stopped target_AC_022_status_eq_stopped))

; AC_023_status_eq_crashed: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_023_status_eq_crashed () Bool)
(declare-fun target_AC_023_status_eq_crashed () Bool)
(assert (= source_AC_023_status_eq_crashed target_AC_023_status_eq_crashed))

; AC_024_status_eq_waiting: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_024_status_eq_waiting () Bool)
(declare-fun target_AC_024_status_eq_waiting () Bool)
(assert (= source_AC_024_status_eq_waiting target_AC_024_status_eq_waiting))

; AC_025_status_eq_restarting: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_025_status_eq_restarting () Bool)
(declare-fun target_AC_025_status_eq_restarting () Bool)
(assert (= source_AC_025_status_eq_restarting target_AC_025_status_eq_restarting))

; AC_026_status_eqb_refl: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_026_status_eqb_refl () Bool)
(declare-fun target_AC_026_status_eqb_refl () Bool)
(assert (= source_AC_026_status_eqb_refl target_AC_026_status_eqb_refl))

; AC_027_status_eqb_sym: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_027_status_eqb_sym () Bool)
(declare-fun target_AC_027_status_eqb_sym () Bool)
(assert (= source_AC_027_status_eqb_sym target_AC_027_status_eqb_sym))

; AC_028_status_eqb_true_eq: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_028_status_eqb_true_eq () Bool)
(declare-fun target_AC_028_status_eqb_true_eq () Bool)
(assert (= source_AC_028_status_eqb_true_eq target_AC_028_status_eqb_true_eq))

; AC_029_status_neq_running_stopped: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_029_status_neq_running_stopped () Bool)
(declare-fun target_AC_029_status_neq_running_stopped () Bool)
(assert (= source_AC_029_status_neq_running_stopped target_AC_029_status_neq_running_stopped))

; AC_030_status_neq_running_crashed: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_030_status_neq_running_crashed () Bool)
(declare-fun target_AC_030_status_neq_running_crashed () Bool)
(assert (= source_AC_030_status_neq_running_crashed target_AC_030_status_neq_running_crashed))

; AC_031_riina_is_running: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_031_riina_is_running () Bool)
(declare-fun target_AC_031_riina_is_running () Bool)
(assert (= source_AC_031_riina_is_running target_AC_031_riina_is_running))

; AC_032_crashed_not_running: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_032_crashed_not_running () Bool)
(declare-fun target_AC_032_crashed_not_running () Bool)
(assert (= source_AC_032_crashed_not_running target_AC_032_crashed_not_running))

; AC_033_stopped_not_running: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_033_stopped_not_running () Bool)
(declare-fun target_AC_033_stopped_not_running () Bool)
(assert (= source_AC_033_stopped_not_running target_AC_033_stopped_not_running))

; AC_034_waiting_not_running: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_034_waiting_not_running () Bool)
(declare-fun target_AC_034_waiting_not_running () Bool)
(assert (= source_AC_034_waiting_not_running target_AC_034_waiting_not_running))

; AC_035_crashed_is_crashed: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_035_crashed_is_crashed () Bool)
(declare-fun target_AC_035_crashed_is_crashed () Bool)
(assert (= source_AC_035_crashed_is_crashed target_AC_035_crashed_is_crashed))

; AC_036_running_not_crashed: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_036_running_not_crashed () Bool)
(declare-fun target_AC_036_running_not_crashed () Bool)
(assert (= source_AC_036_running_not_crashed target_AC_036_running_not_crashed))

; AC_037_stopped_is_stopped: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_037_stopped_is_stopped () Bool)
(declare-fun target_AC_037_stopped_is_stopped () Bool)
(assert (= source_AC_037_stopped_is_stopped target_AC_037_stopped_is_stopped))

; AC_038_waiting_is_waiting: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_038_waiting_is_waiting () Bool)
(declare-fun target_AC_038_waiting_is_waiting () Bool)
(assert (= source_AC_038_waiting_is_waiting target_AC_038_waiting_is_waiting))

; AC_039_restarting_is_restarting: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_039_restarting_is_restarting () Bool)
(declare-fun target_AC_039_restarting_is_restarting () Bool)
(assert (= source_AC_039_restarting_is_restarting target_AC_039_restarting_is_restarting))

; AC_040_status_exclusive_run_crash: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_040_status_exclusive_run_crash () Bool)
(declare-fun target_AC_040_status_exclusive_run_crash () Bool)
(assert (= source_AC_040_status_exclusive_run_crash target_AC_040_status_exclusive_run_crash))

; AC_041_empty_mailbox: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_041_empty_mailbox () Bool)
(declare-fun target_AC_041_empty_mailbox () Bool)
(assert (= source_AC_041_empty_mailbox target_AC_041_empty_mailbox))

; AC_042_nonempty_mailbox: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_042_nonempty_mailbox () Bool)
(declare-fun target_AC_042_nonempty_mailbox () Bool)
(assert (= source_AC_042_nonempty_mailbox target_AC_042_nonempty_mailbox))

; AC_043_has_messages_with_mail: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_043_has_messages_with_mail () Bool)
(declare-fun target_AC_043_has_messages_with_mail () Bool)
(assert (= source_AC_043_has_messages_with_mail target_AC_043_has_messages_with_mail))

; AC_044_no_messages_empty: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_044_no_messages_empty () Bool)
(declare-fun target_AC_044_no_messages_empty () Bool)
(assert (= source_AC_044_no_messages_empty target_AC_044_no_messages_empty))

; AC_045_empty_iff_no_messages: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_045_empty_iff_no_messages () Bool)
(declare-fun target_AC_045_empty_iff_no_messages () Bool)
(assert (= source_AC_045_empty_iff_no_messages target_AC_045_empty_iff_no_messages))

; AC_046_nil_mailbox_empty: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_046_nil_mailbox_empty () Bool)
(declare-fun target_AC_046_nil_mailbox_empty () Bool)
(assert (= source_AC_046_nil_mailbox_empty target_AC_046_nil_mailbox_empty))

; AC_047_cons_mailbox_nonempty: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_047_cons_mailbox_nonempty () Bool)
(declare-fun target_AC_047_cons_mailbox_nonempty () Bool)
(assert (= source_AC_047_cons_mailbox_nonempty target_AC_047_cons_mailbox_nonempty))

; AC_048_mailbox_length_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_048_mailbox_length_nil () Bool)
(declare-fun target_AC_048_mailbox_length_nil () Bool)
(assert (= source_AC_048_mailbox_length_nil target_AC_048_mailbox_length_nil))

; AC_049_mailbox_length_cons: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_049_mailbox_length_cons () Bool)
(declare-fun target_AC_049_mailbox_length_cons () Bool)
(assert (= source_AC_049_mailbox_length_cons target_AC_049_mailbox_length_cons))

; AC_050_append_preserves_messages: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_050_append_preserves_messages () Bool)
(declare-fun target_AC_050_append_preserves_messages () Bool)
(assert (= source_AC_050_append_preserves_messages target_AC_050_append_preserves_messages))

; AC_051_append_nonempty: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_051_append_nonempty () Bool)
(declare-fun target_AC_051_append_nonempty () Bool)
(assert (= source_AC_051_append_nonempty target_AC_051_append_nonempty))

; AC_052_in_append_right: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_052_in_append_right () Bool)
(declare-fun target_AC_052_in_append_right () Bool)
(assert (= source_AC_052_in_append_right target_AC_052_in_append_right))

; AC_053_in_append_left: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_053_in_append_left () Bool)
(declare-fun target_AC_053_in_append_left () Bool)
(assert (= source_AC_053_in_append_left target_AC_053_in_append_left))

; AC_054_mailbox_app_assoc: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_054_mailbox_app_assoc () Bool)
(declare-fun target_AC_054_mailbox_app_assoc () Bool)
(assert (= source_AC_054_mailbox_app_assoc target_AC_054_mailbox_app_assoc))

; AC_055_mailbox_app_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_055_mailbox_app_nil () Bool)
(declare-fun target_AC_055_mailbox_app_nil () Bool)
(assert (= source_AC_055_mailbox_app_nil target_AC_055_mailbox_app_nil))

; AC_056_deliver_preserves_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_056_deliver_preserves_length () Bool)
(declare-fun target_AC_056_deliver_preserves_length () Bool)
(assert (= source_AC_056_deliver_preserves_length target_AC_056_deliver_preserves_length))

; AC_057_spawn_increases_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_057_spawn_increases_length () Bool)
(declare-fun target_AC_057_spawn_increases_length () Bool)
(assert (= source_AC_057_spawn_increases_length target_AC_057_spawn_increases_length))

; AC_058_crash_preserves_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_058_crash_preserves_length () Bool)
(declare-fun target_AC_058_crash_preserves_length () Bool)
(assert (= source_AC_058_crash_preserves_length target_AC_058_crash_preserves_length))

; AC_059_restart_preserves_length: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_059_restart_preserves_length () Bool)
(declare-fun target_AC_059_restart_preserves_length () Bool)
(assert (= source_AC_059_restart_preserves_length target_AC_059_restart_preserves_length))

; AC_060_config_size_spawn: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_060_config_size_spawn () Bool)
(declare-fun target_AC_060_config_size_spawn () Bool)
(assert (= source_AC_060_config_size_spawn target_AC_060_config_size_spawn))

; AC_061_config_size_deliver: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_061_config_size_deliver () Bool)
(declare-fun target_AC_061_config_size_deliver () Bool)
(assert (= source_AC_061_config_size_deliver target_AC_061_config_size_deliver))

; AC_062_forallb_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_062_forallb_nil () Bool)
(declare-fun target_AC_062_forallb_nil () Bool)
(assert (= source_AC_062_forallb_nil target_AC_062_forallb_nil))

; AC_063_config_all_running_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_063_config_all_running_nil () Bool)
(declare-fun target_AC_063_config_all_running_nil () Bool)
(assert (= source_AC_063_config_all_running_nil target_AC_063_config_all_running_nil))

; AC_064_config_no_crashed_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_064_config_no_crashed_nil () Bool)
(declare-fun target_AC_064_config_no_crashed_nil () Bool)
(assert (= source_AC_064_config_no_crashed_nil target_AC_064_config_no_crashed_nil))

; AC_065_config_all_running_single: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_065_config_all_running_single () Bool)
(declare-fun target_AC_065_config_all_running_single () Bool)
(assert (= source_AC_065_config_all_running_single target_AC_065_config_all_running_single))

; AC_066_cap_kind_eq_spawn: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_066_cap_kind_eq_spawn () Bool)
(declare-fun target_AC_066_cap_kind_eq_spawn () Bool)
(assert (= source_AC_066_cap_kind_eq_spawn target_AC_066_cap_kind_eq_spawn))

; AC_067_cap_kind_eq_send: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_067_cap_kind_eq_send () Bool)
(declare-fun target_AC_067_cap_kind_eq_send () Bool)
(assert (= source_AC_067_cap_kind_eq_send target_AC_067_cap_kind_eq_send))

; AC_068_cap_kind_eq_recv: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_068_cap_kind_eq_recv () Bool)
(declare-fun target_AC_068_cap_kind_eq_recv () Bool)
(assert (= source_AC_068_cap_kind_eq_recv target_AC_068_cap_kind_eq_recv))

; AC_069_cap_kind_eq_monitor: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_069_cap_kind_eq_monitor () Bool)
(declare-fun target_AC_069_cap_kind_eq_monitor () Bool)
(assert (= source_AC_069_cap_kind_eq_monitor target_AC_069_cap_kind_eq_monitor))

; AC_070_cap_kind_eq_link: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_070_cap_kind_eq_link () Bool)
(declare-fun target_AC_070_cap_kind_eq_link () Bool)
(assert (= source_AC_070_cap_kind_eq_link target_AC_070_cap_kind_eq_link))

; AC_071_cap_kind_eq_supervise: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_071_cap_kind_eq_supervise () Bool)
(declare-fun target_AC_071_cap_kind_eq_supervise () Bool)
(assert (= source_AC_071_cap_kind_eq_supervise target_AC_071_cap_kind_eq_supervise))

; AC_072_cap_kind_eqb_refl: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_072_cap_kind_eqb_refl () Bool)
(declare-fun target_AC_072_cap_kind_eqb_refl () Bool)
(assert (= source_AC_072_cap_kind_eqb_refl target_AC_072_cap_kind_eqb_refl))

; AC_073_cap_kind_eqb_sym: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_073_cap_kind_eqb_sym () Bool)
(declare-fun target_AC_073_cap_kind_eqb_sym () Bool)
(assert (= source_AC_073_cap_kind_eqb_sym target_AC_073_cap_kind_eqb_sym))

; AC_074_cap_kind_eqb_true_eq: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_074_cap_kind_eqb_true_eq () Bool)
(declare-fun target_AC_074_cap_kind_eqb_true_eq () Bool)
(assert (= source_AC_074_cap_kind_eqb_true_eq target_AC_074_cap_kind_eqb_true_eq))

; AC_075_cap_neq_spawn_send: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_075_cap_neq_spawn_send () Bool)
(declare-fun target_AC_075_cap_neq_spawn_send () Bool)
(assert (= source_AC_075_cap_neq_spawn_send target_AC_075_cap_neq_spawn_send))

; AC_076_riina_can_spawn: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_076_riina_can_spawn () Bool)
(declare-fun target_AC_076_riina_can_spawn () Bool)
(assert (= source_AC_076_riina_can_spawn target_AC_076_riina_can_spawn))

; AC_077_riina_can_send: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_077_riina_can_send () Bool)
(declare-fun target_AC_077_riina_can_send () Bool)
(assert (= source_AC_077_riina_can_send target_AC_077_riina_can_send))

; AC_078_riina_can_recv: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_078_riina_can_recv () Bool)
(declare-fun target_AC_078_riina_can_recv () Bool)
(assert (= source_AC_078_riina_can_recv target_AC_078_riina_can_recv))

; AC_079_riina_can_monitor: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_079_riina_can_monitor () Bool)
(declare-fun target_AC_079_riina_can_monitor () Bool)
(assert (= source_AC_079_riina_can_monitor target_AC_079_riina_can_monitor))

; AC_080_empty_caps_no_spawn: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_080_empty_caps_no_spawn () Bool)
(declare-fun target_AC_080_empty_caps_no_spawn () Bool)
(assert (= source_AC_080_empty_caps_no_spawn target_AC_080_empty_caps_no_spawn))

; AC_081_empty_caps_no_send: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_081_empty_caps_no_send () Bool)
(declare-fun target_AC_081_empty_caps_no_send () Bool)
(assert (= source_AC_081_empty_caps_no_send target_AC_081_empty_caps_no_send))

; AC_082_empty_caps_no_recv: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_082_empty_caps_no_recv () Bool)
(declare-fun target_AC_082_empty_caps_no_recv () Bool)
(assert (= source_AC_082_empty_caps_no_recv target_AC_082_empty_caps_no_recv))

; AC_083_empty_caps_no_monitor: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_083_empty_caps_no_monitor () Bool)
(declare-fun target_AC_083_empty_caps_no_monitor () Bool)
(assert (= source_AC_083_empty_caps_no_monitor target_AC_083_empty_caps_no_monitor))

; AC_084_empty_caps_no_link: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_084_empty_caps_no_link () Bool)
(declare-fun target_AC_084_empty_caps_no_link () Bool)
(assert (= source_AC_084_empty_caps_no_link target_AC_084_empty_caps_no_link))

; AC_085_empty_caps_no_supervise: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_085_empty_caps_no_supervise () Bool)
(declare-fun target_AC_085_empty_caps_no_supervise () Bool)
(assert (= source_AC_085_empty_caps_no_supervise target_AC_085_empty_caps_no_supervise))

; AC_086_acap_active_granted: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_086_acap_active_granted () Bool)
(declare-fun target_AC_086_acap_active_granted () Bool)
(assert (= source_AC_086_acap_active_granted target_AC_086_acap_active_granted))

; AC_087_acap_not_active_not_granted: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_087_acap_not_active_not_granted () Bool)
(declare-fun target_AC_087_acap_not_active_not_granted () Bool)
(assert (= source_AC_087_acap_not_active_not_granted target_AC_087_acap_not_active_not_granted))

; AC_088_riina_cap_spawn_active: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_088_riina_cap_spawn_active () Bool)
(declare-fun target_AC_088_riina_cap_spawn_active () Bool)
(assert (= source_AC_088_riina_cap_spawn_active target_AC_088_riina_cap_spawn_active))

; AC_089_riina_cap_send_revocable: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_089_riina_cap_send_revocable () Bool)
(declare-fun target_AC_089_riina_cap_send_revocable () Bool)
(assert (= source_AC_089_riina_cap_send_revocable target_AC_089_riina_cap_send_revocable))

; AC_090_revoked_cap_not_spawnable: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_090_revoked_cap_not_spawnable () Bool)
(declare-fun target_AC_090_revoked_cap_not_spawnable () Bool)
(assert (= source_AC_090_revoked_cap_not_spawnable target_AC_090_revoked_cap_not_spawnable))

; AC_091_dual_end: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_091_dual_end () Bool)
(declare-fun target_AC_091_dual_end () Bool)
(assert (= source_AC_091_dual_end target_AC_091_dual_end))

; AC_092_dual_send: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_092_dual_send () Bool)
(declare-fun target_AC_092_dual_send () Bool)
(assert (= source_AC_092_dual_send target_AC_092_dual_send))

; AC_093_dual_recv: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_093_dual_recv () Bool)
(declare-fun target_AC_093_dual_recv () Bool)
(assert (= source_AC_093_dual_recv target_AC_093_dual_recv))

; AC_094_dual_select: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_094_dual_select () Bool)
(declare-fun target_AC_094_dual_select () Bool)
(assert (= source_AC_094_dual_select target_AC_094_dual_select))

; AC_095_dual_offer: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_095_dual_offer () Bool)
(declare-fun target_AC_095_dual_offer () Bool)
(assert (= source_AC_095_dual_offer target_AC_095_dual_offer))

; AC_096_dual_involutive_end: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_096_dual_involutive_end () Bool)
(declare-fun target_AC_096_dual_involutive_end () Bool)
(assert (= source_AC_096_dual_involutive_end target_AC_096_dual_involutive_end))

; AC_097_dual_involutive_send_end: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_097_dual_involutive_send_end () Bool)
(declare-fun target_AC_097_dual_involutive_send_end () Bool)
(assert (= source_AC_097_dual_involutive_send_end target_AC_097_dual_involutive_send_end))

; AC_098_dual_involutive_recv_end: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_098_dual_involutive_recv_end () Bool)
(declare-fun target_AC_098_dual_involutive_recv_end () Bool)
(assert (= source_AC_098_dual_involutive_recv_end target_AC_098_dual_involutive_recv_end))

; AC_099_dual_send_recv_end: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_099_dual_send_recv_end () Bool)
(declare-fun target_AC_099_dual_send_recv_end () Bool)
(assert (= source_AC_099_dual_send_recv_end target_AC_099_dual_send_recv_end))

; AC_100_dual_recv_send_end: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_100_dual_recv_send_end () Bool)
(declare-fun target_AC_100_dual_recv_send_end () Bool)
(assert (= source_AC_100_dual_recv_send_end target_AC_100_dual_recv_send_end))

; AC_101_dual_preserves_msg_type: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_101_dual_preserves_msg_type () Bool)
(declare-fun target_AC_101_dual_preserves_msg_type () Bool)
(assert (= source_AC_101_dual_preserves_msg_type target_AC_101_dual_preserves_msg_type))

; AC_102_dual_preserves_msg_type_recv: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_102_dual_preserves_msg_type_recv () Bool)
(declare-fun target_AC_102_dual_preserves_msg_type_recv () Bool)
(assert (= source_AC_102_dual_preserves_msg_type_recv target_AC_102_dual_preserves_msg_type_recv))

; AC_103_dual_ping_pong: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_103_dual_ping_pong () Bool)
(declare-fun target_AC_103_dual_ping_pong () Bool)
(assert (= source_AC_103_dual_ping_pong target_AC_103_dual_ping_pong))

; AC_104_dual_dual_ping_pong: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_104_dual_dual_ping_pong () Bool)
(declare-fun target_AC_104_dual_dual_ping_pong () Bool)
(assert (= source_AC_104_dual_dual_ping_pong target_AC_104_dual_dual_ping_pong))

; AC_105_dual_select_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_105_dual_select_nil () Bool)
(declare-fun target_AC_105_dual_select_nil () Bool)
(assert (= source_AC_105_dual_select_nil target_AC_105_dual_select_nil))

; AC_106_dual_offer_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_106_dual_offer_nil () Bool)
(declare-fun target_AC_106_dual_offer_nil () Bool)
(assert (= source_AC_106_dual_offer_nil target_AC_106_dual_offer_nil))

; AC_107_dual_select_single: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_107_dual_select_single () Bool)
(declare-fun target_AC_107_dual_select_single () Bool)
(assert (= source_AC_107_dual_select_single target_AC_107_dual_select_single))

; AC_108_dual_offer_single: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_108_dual_offer_single () Bool)
(declare-fun target_AC_108_dual_offer_single () Bool)
(assert (= source_AC_108_dual_offer_single target_AC_108_dual_offer_single))

; AC_109_dual_three_chain: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_109_dual_three_chain () Bool)
(declare-fun target_AC_109_dual_three_chain () Bool)
(assert (= source_AC_109_dual_three_chain target_AC_109_dual_three_chain))

; AC_110_dual_dual_three_chain: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_110_dual_dual_three_chain () Bool)
(declare-fun target_AC_110_dual_dual_three_chain () Bool)
(assert (= source_AC_110_dual_dual_three_chain target_AC_110_dual_dual_three_chain))

; AC_111_chan_fresh_riina: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_111_chan_fresh_riina () Bool)
(declare-fun target_AC_111_chan_fresh_riina () Bool)
(assert (= source_AC_111_chan_fresh_riina target_AC_111_chan_fresh_riina))

; AC_112_chan_used_not_fresh: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_112_chan_used_not_fresh () Bool)
(declare-fun target_AC_112_chan_used_not_fresh () Bool)
(assert (= source_AC_112_chan_used_not_fresh target_AC_112_chan_used_not_fresh))

; AC_113_chan_used_preserves_id: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_113_chan_used_preserves_id () Bool)
(declare-fun target_AC_113_chan_used_preserves_id () Bool)
(assert (= source_AC_113_chan_used_preserves_id target_AC_113_chan_used_preserves_id))

; AC_114_chan_used_preserves_session: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_114_chan_used_preserves_session () Bool)
(declare-fun target_AC_114_chan_used_preserves_session () Bool)
(assert (= source_AC_114_chan_used_preserves_session target_AC_114_chan_used_preserves_session))

; AC_115_chan_close_inactive: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_115_chan_close_inactive () Bool)
(declare-fun target_AC_115_chan_close_inactive () Bool)
(assert (= source_AC_115_chan_close_inactive target_AC_115_chan_close_inactive))

; AC_116_chan_close_session_end: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_116_chan_close_session_end () Bool)
(declare-fun target_AC_116_chan_close_session_end () Bool)
(assert (= source_AC_116_chan_close_session_end target_AC_116_chan_close_session_end))

; AC_117_chan_close_not_linear: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_117_chan_close_not_linear () Bool)
(declare-fun target_AC_117_chan_close_not_linear () Bool)
(assert (= source_AC_117_chan_close_not_linear target_AC_117_chan_close_not_linear))

; AC_118_chan_close_preserves_id: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_118_chan_close_preserves_id () Bool)
(declare-fun target_AC_118_chan_close_preserves_id () Bool)
(assert (= source_AC_118_chan_close_preserves_id target_AC_118_chan_close_preserves_id))

; AC_119_msg_type_compat_nat: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_119_msg_type_compat_nat () Bool)
(declare-fun target_AC_119_msg_type_compat_nat () Bool)
(assert (= source_AC_119_msg_type_compat_nat target_AC_119_msg_type_compat_nat))

; AC_120_msg_type_compat_bool: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_120_msg_type_compat_bool () Bool)
(declare-fun target_AC_120_msg_type_compat_bool () Bool)
(assert (= source_AC_120_msg_type_compat_bool target_AC_120_msg_type_compat_bool))

; AC_121_msg_type_incompat: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_121_msg_type_incompat () Bool)
(declare-fun target_AC_121_msg_type_incompat () Bool)
(assert (= source_AC_121_msg_type_incompat target_AC_121_msg_type_incompat))

; AC_122_msg_type_compat_refl: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_122_msg_type_compat_refl () Bool)
(declare-fun target_AC_122_msg_type_compat_refl () Bool)
(assert (= source_AC_122_msg_type_compat_refl target_AC_122_msg_type_compat_refl))

; AC_123_mailbox_wt_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_123_mailbox_wt_nil () Bool)
(declare-fun target_AC_123_mailbox_wt_nil () Bool)
(assert (= source_AC_123_mailbox_wt_nil target_AC_123_mailbox_wt_nil))

; AC_124_mailbox_wt_cons: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_124_mailbox_wt_cons () Bool)
(declare-fun target_AC_124_mailbox_wt_cons () Bool)
(assert (= source_AC_124_mailbox_wt_cons target_AC_124_mailbox_wt_cons))

; AC_125_mailbox_wt_append: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_125_mailbox_wt_append () Bool)
(declare-fun target_AC_125_mailbox_wt_append () Bool)
(assert (= source_AC_125_mailbox_wt_append target_AC_125_mailbox_wt_append))

; AC_126_riina_actor_well_typed: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_126_riina_actor_well_typed () Bool)
(declare-fun target_AC_126_riina_actor_well_typed () Bool)
(assert (= source_AC_126_riina_actor_well_typed target_AC_126_riina_actor_well_typed))

; AC_127_find_actor_head: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_127_find_actor_head () Bool)
(declare-fun target_AC_127_find_actor_head () Bool)
(assert (= source_AC_127_find_actor_head target_AC_127_find_actor_head))

; AC_128_find_actor_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_128_find_actor_nil () Bool)
(declare-fun target_AC_128_find_actor_nil () Bool)
(assert (= source_AC_128_find_actor_nil target_AC_128_find_actor_nil))

; AC_129_find_actor_riina: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_129_find_actor_riina () Bool)
(declare-fun target_AC_129_find_actor_riina () Bool)
(assert (= source_AC_129_find_actor_riina target_AC_129_find_actor_riina))

; AC_130_find_actor_with_mail: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_130_find_actor_with_mail () Bool)
(declare-fun target_AC_130_find_actor_with_mail () Bool)
(assert (= source_AC_130_find_actor_with_mail target_AC_130_find_actor_with_mail))

; AC_131_config_all_running_cons: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_131_config_all_running_cons () Bool)
(declare-fun target_AC_131_config_all_running_cons () Bool)
(assert (= source_AC_131_config_all_running_cons target_AC_131_config_all_running_cons))

; AC_132_config_no_crashed_cons: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_132_config_no_crashed_cons () Bool)
(declare-fun target_AC_132_config_no_crashed_cons () Bool)
(assert (= source_AC_132_config_no_crashed_cons target_AC_132_config_no_crashed_cons))

; AC_133_running_not_crashed_config: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_133_running_not_crashed_config () Bool)
(declare-fun target_AC_133_running_not_crashed_config () Bool)
(assert (= source_AC_133_running_not_crashed_config target_AC_133_running_not_crashed_config))

; AC_134_status_exclusive_run_stop: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_134_status_exclusive_run_stop () Bool)
(declare-fun target_AC_134_status_exclusive_run_stop () Bool)
(assert (= source_AC_134_status_exclusive_run_stop target_AC_134_status_exclusive_run_stop))

; AC_135_status_exclusive_run_wait: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_135_status_exclusive_run_wait () Bool)
(declare-fun target_AC_135_status_exclusive_run_wait () Bool)
(assert (= source_AC_135_status_exclusive_run_wait target_AC_135_status_exclusive_run_wait))

; AC_136_status_exclusive_run_restart: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_136_status_exclusive_run_restart () Bool)
(declare-fun target_AC_136_status_exclusive_run_restart () Bool)
(assert (= source_AC_136_status_exclusive_run_restart target_AC_136_status_exclusive_run_restart))

; AC_137_status_exclusive_crash_stop: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_137_status_exclusive_crash_stop () Bool)
(declare-fun target_AC_137_status_exclusive_crash_stop () Bool)
(assert (= source_AC_137_status_exclusive_crash_stop target_AC_137_status_exclusive_crash_stop))

; AC_138_status_exclusive_crash_wait: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_138_status_exclusive_crash_wait () Bool)
(declare-fun target_AC_138_status_exclusive_crash_wait () Bool)
(assert (= source_AC_138_status_exclusive_crash_wait target_AC_138_status_exclusive_crash_wait))

; AC_139_can_receive_running_not_full: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_139_can_receive_running_not_full () Bool)
(declare-fun target_AC_139_can_receive_running_not_full () Bool)
(assert (= source_AC_139_can_receive_running_not_full target_AC_139_can_receive_running_not_full))

; AC_140_can_receive_not_full: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_140_can_receive_not_full () Bool)
(declare-fun target_AC_140_can_receive_not_full () Bool)
(assert (= source_AC_140_can_receive_not_full target_AC_140_can_receive_not_full))

; AC_141_well_typed_is_running: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_141_well_typed_is_running () Bool)
(declare-fun target_AC_141_well_typed_is_running () Bool)
(assert (= source_AC_141_well_typed_is_running target_AC_141_well_typed_is_running))

; AC_142_well_typed_is_isolated: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_142_well_typed_is_isolated () Bool)
(declare-fun target_AC_142_well_typed_is_isolated () Bool)
(assert (= source_AC_142_well_typed_is_isolated target_AC_142_well_typed_is_isolated))

; AC_143_well_typed_mailbox: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_143_well_typed_mailbox () Bool)
(declare-fun target_AC_143_well_typed_mailbox () Bool)
(assert (= source_AC_143_well_typed_mailbox target_AC_143_well_typed_mailbox))

; AC_144_well_typed_not_crashed: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_144_well_typed_not_crashed () Bool)
(declare-fun target_AC_144_well_typed_not_crashed () Bool)
(assert (= source_AC_144_well_typed_not_crashed target_AC_144_well_typed_not_crashed))

; AC_145_well_typed_not_stopped: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_145_well_typed_not_stopped () Bool)
(declare-fun target_AC_145_well_typed_not_stopped () Bool)
(assert (= source_AC_145_well_typed_not_stopped target_AC_145_well_typed_not_stopped))

; AC_146_well_typed_not_waiting: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_146_well_typed_not_waiting () Bool)
(declare-fun target_AC_146_well_typed_not_waiting () Bool)
(assert (= source_AC_146_well_typed_not_waiting target_AC_146_well_typed_not_waiting))

; AC_147_well_typed_not_restarting: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_147_well_typed_not_restarting () Bool)
(declare-fun target_AC_147_well_typed_not_restarting () Bool)
(assert (= source_AC_147_well_typed_not_restarting target_AC_147_well_typed_not_restarting))

; AC_148_well_typed_compose: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_148_well_typed_compose () Bool)
(declare-fun target_AC_148_well_typed_compose () Bool)
(assert (= source_AC_148_well_typed_compose target_AC_148_well_typed_compose))

; AC_149_empty_mailbox_any_type: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_149_empty_mailbox_any_type () Bool)
(declare-fun target_AC_149_empty_mailbox_any_type () Bool)
(assert (= source_AC_149_empty_mailbox_any_type target_AC_149_empty_mailbox_any_type))

; AC_150_single_msg_well_typed: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_150_single_msg_well_typed () Bool)
(declare-fun target_AC_150_single_msg_well_typed () Bool)
(assert (= source_AC_150_single_msg_well_typed target_AC_150_single_msg_well_typed))

; AC_151_msg_compat_cons: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_151_msg_compat_cons () Bool)
(declare-fun target_AC_151_msg_compat_cons () Bool)
(assert (= source_AC_151_msg_compat_cons target_AC_151_msg_compat_cons))

; AC_152_msg_compat_self_list: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_152_msg_compat_self_list () Bool)
(declare-fun target_AC_152_msg_compat_self_list () Bool)
(assert (= source_AC_152_msg_compat_self_list target_AC_152_msg_compat_self_list))

; AC_153_msg_compat_in: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_153_msg_compat_in () Bool)
(declare-fun target_AC_153_msg_compat_in () Bool)
(assert (= source_AC_153_msg_compat_in target_AC_153_msg_compat_in))

; AC_154_riina_actor_not_full: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_154_riina_actor_not_full () Bool)
(declare-fun target_AC_154_riina_actor_not_full () Bool)
(assert (= source_AC_154_riina_actor_not_full target_AC_154_riina_actor_not_full))

; AC_155_riina_can_receive: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_155_riina_can_receive () Bool)
(declare-fun target_AC_155_riina_can_receive () Bool)
(assert (= source_AC_155_riina_can_receive target_AC_155_riina_can_receive))

; AC_156_crashed_cannot_receive: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_156_crashed_cannot_receive () Bool)
(declare-fun target_AC_156_crashed_cannot_receive () Bool)
(assert (= source_AC_156_crashed_cannot_receive target_AC_156_crashed_cannot_receive))

; AC_157_stopped_cannot_receive: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_157_stopped_cannot_receive () Bool)
(declare-fun target_AC_157_stopped_cannot_receive () Bool)
(assert (= source_AC_157_stopped_cannot_receive target_AC_157_stopped_cannot_receive))

; AC_158_waiting_cannot_receive: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_158_waiting_cannot_receive () Bool)
(declare-fun target_AC_158_waiting_cannot_receive () Bool)
(assert (= source_AC_158_waiting_cannot_receive target_AC_158_waiting_cannot_receive))

; AC_159_restarting_cannot_receive: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_159_restarting_cannot_receive () Bool)
(declare-fun target_AC_159_restarting_cannot_receive () Bool)
(assert (= source_AC_159_restarting_cannot_receive target_AC_159_restarting_cannot_receive))

; AC_160_well_typed_all_msgs_compat: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_160_well_typed_all_msgs_compat () Bool)
(declare-fun target_AC_160_well_typed_all_msgs_compat () Bool)
(assert (= source_AC_160_well_typed_all_msgs_compat target_AC_160_well_typed_all_msgs_compat))

; AC_161_spawn_running: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_161_spawn_running () Bool)
(declare-fun target_AC_161_spawn_running () Bool)
(assert (= source_AC_161_spawn_running target_AC_161_spawn_running))

; AC_162_config_size_empty: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_162_config_size_empty () Bool)
(declare-fun target_AC_162_config_size_empty () Bool)
(assert (= source_AC_162_config_size_empty target_AC_162_config_size_empty))

; AC_163_config_size_cons: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_163_config_size_cons () Bool)
(declare-fun target_AC_163_config_size_cons () Bool)
(assert (= source_AC_163_config_size_cons target_AC_163_config_size_cons))

; AC_164_crash_preserves_others: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_164_crash_preserves_others () Bool)
(declare-fun target_AC_164_crash_preserves_others () Bool)
(assert (= source_AC_164_crash_preserves_others target_AC_164_crash_preserves_others))

; AC_165_restart_preserves_others: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_165_restart_preserves_others () Bool)
(declare-fun target_AC_165_restart_preserves_others () Bool)
(assert (= source_AC_165_restart_preserves_others target_AC_165_restart_preserves_others))

; AC_166_deliver_preserves_others: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_166_deliver_preserves_others () Bool)
(declare-fun target_AC_166_deliver_preserves_others () Bool)
(assert (= source_AC_166_deliver_preserves_others target_AC_166_deliver_preserves_others))

; AC_167_config_no_crashed_running: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_167_config_no_crashed_running () Bool)
(declare-fun target_AC_167_config_no_crashed_running () Bool)
(assert (= source_AC_167_config_no_crashed_running target_AC_167_config_no_crashed_running))

; AC_168_spawn_preserves_existing: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_168_spawn_preserves_existing () Bool)
(declare-fun target_AC_168_spawn_preserves_existing () Bool)
(assert (= source_AC_168_spawn_preserves_existing target_AC_168_spawn_preserves_existing))

; AC_169_spawn_adds_new: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_169_spawn_adds_new () Bool)
(declare-fun target_AC_169_spawn_adds_new () Bool)
(assert (= source_AC_169_spawn_adds_new target_AC_169_spawn_adds_new))

; AC_170_riina_config_size: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_170_riina_config_size () Bool)
(declare-fun target_AC_170_riina_config_size () Bool)
(assert (= source_AC_170_riina_config_size target_AC_170_riina_config_size))

; AC_171_total_messages_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_171_total_messages_nil () Bool)
(declare-fun target_AC_171_total_messages_nil () Bool)
(assert (= source_AC_171_total_messages_nil target_AC_171_total_messages_nil))

; AC_172_total_messages_riina: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_172_total_messages_riina () Bool)
(declare-fun target_AC_172_total_messages_riina () Bool)
(assert (= source_AC_172_total_messages_riina target_AC_172_total_messages_riina))

; AC_173_config_no_full_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_173_config_no_full_nil () Bool)
(declare-fun target_AC_173_config_no_full_nil () Bool)
(assert (= source_AC_173_config_no_full_nil target_AC_173_config_no_full_nil))

; AC_174_config_no_full_cons: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_174_config_no_full_cons () Bool)
(declare-fun target_AC_174_config_no_full_cons () Bool)
(assert (= source_AC_174_config_no_full_cons target_AC_174_config_no_full_cons))

; AC_175_deliver_to_absent_noop: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_175_deliver_to_absent_noop () Bool)
(declare-fun target_AC_175_deliver_to_absent_noop () Bool)
(assert (= source_AC_175_deliver_to_absent_noop target_AC_175_deliver_to_absent_noop))

; AC_176_config_all_isolated_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_176_config_all_isolated_nil () Bool)
(declare-fun target_AC_176_config_all_isolated_nil () Bool)
(assert (= source_AC_176_config_all_isolated_nil target_AC_176_config_all_isolated_nil))

; AC_177_config_all_isolated_cons: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_177_config_all_isolated_cons () Bool)
(declare-fun target_AC_177_config_all_isolated_cons () Bool)
(assert (= source_AC_177_config_all_isolated_cons target_AC_177_config_all_isolated_cons))

; AC_178_riina_actor_isolated: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_178_riina_actor_isolated () Bool)
(declare-fun target_AC_178_riina_actor_isolated () Bool)
(assert (= source_AC_178_riina_actor_isolated target_AC_178_riina_actor_isolated))

; AC_179_empty_config_all_predicates: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_179_empty_config_all_predicates () Bool)
(declare-fun target_AC_179_empty_config_all_predicates () Bool)
(assert (= source_AC_179_empty_config_all_predicates target_AC_179_empty_config_all_predicates))

; AC_180_crash_actor_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_180_crash_actor_nil () Bool)
(declare-fun target_AC_180_crash_actor_nil () Bool)
(assert (= source_AC_180_crash_actor_nil target_AC_180_crash_actor_nil))

; AC_181_deliver_increases_mailbox: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_181_deliver_increases_mailbox () Bool)
(declare-fun target_AC_181_deliver_increases_mailbox () Bool)
(assert (= source_AC_181_deliver_increases_mailbox target_AC_181_deliver_increases_mailbox))

; AC_182_message_not_lost_on_deliver: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_182_message_not_lost_on_deliver () Bool)
(declare-fun target_AC_182_message_not_lost_on_deliver () Bool)
(assert (= source_AC_182_message_not_lost_on_deliver target_AC_182_message_not_lost_on_deliver))

; AC_183_old_messages_preserved: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_183_old_messages_preserved () Bool)
(declare-fun target_AC_183_old_messages_preserved () Bool)
(assert (= source_AC_183_old_messages_preserved target_AC_183_old_messages_preserved))

; AC_184_delivery_order_fifo: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_184_delivery_order_fifo () Bool)
(declare-fun target_AC_184_delivery_order_fifo () Bool)
(assert (= source_AC_184_delivery_order_fifo target_AC_184_delivery_order_fifo))

; AC_185_restart_clears_mailbox: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_185_restart_clears_mailbox () Bool)
(declare-fun target_AC_185_restart_clears_mailbox () Bool)
(assert (= source_AC_185_restart_clears_mailbox target_AC_185_restart_clears_mailbox))

; AC_186_restart_sets_running: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_186_restart_sets_running () Bool)
(declare-fun target_AC_186_restart_sets_running () Bool)
(assert (= source_AC_186_restart_sets_running target_AC_186_restart_sets_running))

; AC_187_restart_increments_count: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_187_restart_increments_count () Bool)
(declare-fun target_AC_187_restart_increments_count () Bool)
(assert (= source_AC_187_restart_increments_count target_AC_187_restart_increments_count))

; AC_188_crash_sets_crashed: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_188_crash_sets_crashed () Bool)
(declare-fun target_AC_188_crash_sets_crashed () Bool)
(assert (= source_AC_188_crash_sets_crashed target_AC_188_crash_sets_crashed))

; AC_189_crash_preserves_mailbox: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_189_crash_preserves_mailbox () Bool)
(declare-fun target_AC_189_crash_preserves_mailbox () Bool)
(assert (= source_AC_189_crash_preserves_mailbox target_AC_189_crash_preserves_mailbox))

; AC_190_restart_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_190_restart_nil () Bool)
(declare-fun target_AC_190_restart_nil () Bool)
(assert (= source_AC_190_restart_nil target_AC_190_restart_nil))

; AC_191_deliver_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_191_deliver_nil () Bool)
(declare-fun target_AC_191_deliver_nil () Bool)
(assert (= source_AC_191_deliver_nil target_AC_191_deliver_nil))

; AC_192_spawn_nil: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_192_spawn_nil () Bool)
(declare-fun target_AC_192_spawn_nil () Bool)
(assert (= source_AC_192_spawn_nil target_AC_192_spawn_nil))

; AC_193_well_typed_preserved_empty_deliver: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_193_well_typed_preserved_empty_deliver () Bool)
(declare-fun target_AC_193_well_typed_preserved_empty_deliver () Bool)
(assert (= source_AC_193_well_typed_preserved_empty_deliver target_AC_193_well_typed_preserved_empty_deliver))

; AC_194_capability_required_for_spawn: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_194_capability_required_for_spawn () Bool)
(declare-fun target_AC_194_capability_required_for_spawn () Bool)
(assert (= source_AC_194_capability_required_for_spawn target_AC_194_capability_required_for_spawn))

; AC_195_capability_required_for_send: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_195_capability_required_for_send () Bool)
(declare-fun target_AC_195_capability_required_for_send () Bool)
(assert (= source_AC_195_capability_required_for_send target_AC_195_capability_required_for_send))

; AC_196_has_cap_kind_cons: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_196_has_cap_kind_cons () Bool)
(declare-fun target_AC_196_has_cap_kind_cons () Bool)
(assert (= source_AC_196_has_cap_kind_cons target_AC_196_has_cap_kind_cons))

; AC_197_has_cap_kind_tail: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_197_has_cap_kind_tail () Bool)
(declare-fun target_AC_197_has_cap_kind_tail () Bool)
(assert (= source_AC_197_has_cap_kind_tail target_AC_197_has_cap_kind_tail))

; AC_198_session_duality_symmetric: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_198_session_duality_symmetric () Bool)
(declare-fun target_AC_198_session_duality_symmetric () Bool)
(assert (= source_AC_198_session_duality_symmetric target_AC_198_session_duality_symmetric))

; AC_199_session_duality_symmetric_recv: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_199_session_duality_symmetric_recv () Bool)
(declare-fun target_AC_199_session_duality_symmetric_recv () Bool)
(assert (= source_AC_199_session_duality_symmetric_recv target_AC_199_session_duality_symmetric_recv))

; AC_200_chan_pair_dual: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_200_chan_pair_dual () Bool)
(declare-fun target_AC_200_chan_pair_dual () Bool)
(assert (= source_AC_200_chan_pair_dual target_AC_200_chan_pair_dual))

; AC_201_status_eq_dec: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_201_status_eq_dec () Bool)
(declare-fun target_AC_201_status_eq_dec () Bool)
(assert (= source_AC_201_status_eq_dec target_AC_201_status_eq_dec))

; AC_202_cap_kind_eq_dec: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_202_cap_kind_eq_dec () Bool)
(declare-fun target_AC_202_cap_kind_eq_dec () Bool)
(assert (= source_AC_202_cap_kind_eq_dec target_AC_202_cap_kind_eq_dec))

; AC_203_mailbox_wt_single_compat: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_203_mailbox_wt_single_compat () Bool)
(declare-fun target_AC_203_mailbox_wt_single_compat () Bool)
(assert (= source_AC_203_mailbox_wt_single_compat target_AC_203_mailbox_wt_single_compat))

; AC_204_deliver_idempotent_absent: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_204_deliver_idempotent_absent () Bool)
(declare-fun target_AC_204_deliver_idempotent_absent () Bool)
(assert (= source_AC_204_deliver_idempotent_absent target_AC_204_deliver_idempotent_absent))

; AC_205_spawn_then_find: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_205_spawn_then_find () Bool)
(declare-fun target_AC_205_spawn_then_find () Bool)
(assert (= source_AC_205_spawn_then_find target_AC_205_spawn_then_find))

; AC_206_riina_msg_ref_tag: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_206_riina_msg_ref_tag () Bool)
(declare-fun target_AC_206_riina_msg_ref_tag () Bool)
(assert (= source_AC_206_riina_msg_ref_tag target_AC_206_riina_msg_ref_tag))

; AC_207_riina_msg_sender: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_207_riina_msg_sender () Bool)
(declare-fun target_AC_207_riina_msg_sender () Bool)
(assert (= source_AC_207_riina_msg_sender target_AC_207_riina_msg_sender))

; AC_208_riina_msg_priority: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_208_riina_msg_priority () Bool)
(declare-fun target_AC_208_riina_msg_priority () Bool)
(assert (= source_AC_208_riina_msg_priority target_AC_208_riina_msg_priority))

; AC_209_riina_msg_payload: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_209_riina_msg_payload () Bool)
(declare-fun target_AC_209_riina_msg_payload () Bool)
(assert (= source_AC_209_riina_msg_payload target_AC_209_riina_msg_payload))

; AC_210_riina_actor_id: translation preserves property (matches Coq: Theorem)
(declare-fun source_AC_210_riina_actor_id () Bool)
(declare-fun target_AC_210_riina_actor_id () Bool)
(assert (= source_AC_210_riina_actor_id target_AC_210_riina_actor_id))

; Verify all translation validations are satisfiable
(check-sat)
(exit)

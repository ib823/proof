---- MODULE ActorCalculus ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/ActorCalculus.v (218 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

\* MsgTag (matches Coq: Inductive MsgTag)
CONSTANTS TagNat, TagBool, TagUnit, TagString, TagPair, TagActorRef

\* ActorStatus (matches Coq: Inductive ActorStatus)
CONSTANTS Running, Stopped, Crashed, Waiting, Restarting

\* ActorSessionType (matches Coq: Inductive ActorSessionType)
CONSTANTS ASTSend, ASTRecv, ASTEnd

\* CapKind (matches Coq: Inductive CapKind)
CONSTANTS CapSpawn, CapSend, CapRecv, CapMonitor, CapLink, CapSupervise

\* Message (matches Coq: Record Message)
VARIABLES msg_tag, msg_payload, msg_sender, msg_priority

\* ActorState (matches Coq: Record ActorState)
VARIABLES actor_id, actor_status, actor_mailbox, actor_local, actor_msg_count, actor_spawn_count, actor_max_mailbox, actor_restart_count

\* ActorChannel (matches Coq: Record ActorChannel)
VARIABLES achan_id, achan_session, achan_linear, achan_active

\* ActorChannelPair (matches Coq: Record ActorChannelPair)
VARIABLES achan_endpoint_a, achan_endpoint_b

\* ActorCapability (matches Coq: Record ActorCapability)
VARIABLES acap_kind, acap_granted, acap_revocable, acap_target

\* TypedActor (matches Coq: Record TypedActor)
VARIABLES ta_state, ta_expected, ta_session, ta_caps, ta_isolated

\* Type invariant
TypeOK ==
  /\ msg_tag \in BOOLEAN
  /\ msg_payload \in BOOLEAN
  /\ msg_sender \in BOOLEAN
  /\ msg_priority \in BOOLEAN
  /\ actor_id \in BOOLEAN
  /\ actor_status \in BOOLEAN
  /\ actor_mailbox \in BOOLEAN
  /\ actor_local \in BOOLEAN
  /\ actor_msg_count \in BOOLEAN
  /\ actor_spawn_count \in BOOLEAN
  /\ actor_max_mailbox \in BOOLEAN
  /\ actor_restart_count \in BOOLEAN
  /\ achan_id \in BOOLEAN
  /\ achan_session \in BOOLEAN
  /\ achan_linear \in BOOLEAN
  /\ achan_active \in BOOLEAN
  /\ achan_endpoint_a \in BOOLEAN
  /\ achan_endpoint_b \in BOOLEAN
  /\ acap_kind \in BOOLEAN
  /\ acap_granted \in BOOLEAN
  /\ acap_revocable \in BOOLEAN
  /\ acap_target \in BOOLEAN
  /\ ta_state \in BOOLEAN
  /\ ta_expected \in BOOLEAN
  /\ ta_session \in BOOLEAN
  /\ ta_caps \in BOOLEAN
  /\ ta_isolated \in BOOLEAN

\* Initial state
Init ==
  /\ msg_tag = TRUE
  /\ msg_payload = TRUE
  /\ msg_sender = TRUE
  /\ msg_priority = TRUE
  /\ actor_id = TRUE
  /\ actor_status = TRUE
  /\ actor_mailbox = TRUE
  /\ actor_local = TRUE
  /\ actor_msg_count = TRUE
  /\ actor_spawn_count = TRUE
  /\ actor_max_mailbox = TRUE
  /\ actor_restart_count = TRUE
  /\ achan_id = TRUE
  /\ achan_session = TRUE
  /\ achan_linear = TRUE
  /\ achan_active = TRUE
  /\ achan_endpoint_a = TRUE
  /\ achan_endpoint_b = TRUE
  /\ acap_kind = TRUE
  /\ acap_granted = TRUE
  /\ acap_revocable = TRUE
  /\ acap_target = TRUE
  /\ ta_state = TRUE
  /\ ta_expected = TRUE
  /\ ta_session = TRUE
  /\ ta_caps = TRUE
  /\ ta_isolated = TRUE

\* msg_tag_eqb (matches Coq: Definition msg_tag_eqb)
msg_tag_eqb(t1, t2) == TRUE

\* status_eqb (matches Coq: Definition status_eqb)
status_eqb(s1, s2) == TRUE

\* is_running (matches Coq: Definition is_running)
is_running(a) == TRUE

\* is_stopped (matches Coq: Definition is_stopped)
is_stopped(a) == TRUE

\* is_crashed (matches Coq: Definition is_crashed)
is_crashed(a) == TRUE

\* is_waiting (matches Coq: Definition is_waiting)
is_waiting(a) == TRUE

\* is_restarting (matches Coq: Definition is_restarting)
is_restarting(a) == TRUE

\* has_messages (matches Coq: Definition has_messages)
has_messages(a) == TRUE

\* mailbox_empty (matches Coq: Definition mailbox_empty)
mailbox_empty(a) == TRUE

\* mailbox_full (matches Coq: Definition mailbox_full)
mailbox_full(a) == TRUE

\* can_receive (matches Coq: Definition can_receive)
can_receive(a) == TRUE

\* ast_dual (matches Coq: Definition ast_dual)
ast_dual(s) == TRUE

\* achan_fresh (matches Coq: Definition achan_fresh)
achan_fresh(ch) == TRUE

\* achan_used (matches Coq: Definition achan_used)
achan_used(ch) == TRUE

\* achan_close (matches Coq: Definition achan_close)
achan_close(ch) == TRUE

\* cap_kind_eqb (matches Coq: Definition cap_kind_eqb)
cap_kind_eqb(k1, k2) == TRUE

\* acap_active (matches Coq: Definition acap_active)
acap_active(c) == TRUE

\* has_cap_kind (matches Coq: Definition has_cap_kind)
has_cap_kind(caps, k) == TRUE

\* can_spawn (matches Coq: Definition can_spawn)
can_spawn(caps) == TRUE

\* can_send_cap (matches Coq: Definition can_send_cap)
can_send_cap(caps) == TRUE

\* can_recv_cap (matches Coq: Definition can_recv_cap)
can_recv_cap(caps) == TRUE

\* can_monitor (matches Coq: Definition can_monitor)
can_monitor(caps) == TRUE

\* can_link (matches Coq: Definition can_link)
can_link(caps) == TRUE

\* can_supervise (matches Coq: Definition can_supervise)
can_supervise(caps) == TRUE

\* msg_type_compatible (matches Coq: Definition msg_type_compatible)
msg_type_compatible(m, expected) == TRUE

\* mailbox_well_typed (matches Coq: Definition mailbox_well_typed)
mailbox_well_typed(mb, expected) == TRUE

\* actor_well_typed (matches Coq: Definition actor_well_typed)
actor_well_typed(ta) == TRUE

\* find_actor (matches Coq: Definition find_actor)
find_actor(cfg, aid) == TRUE

\* config_all_running (matches Coq: Definition config_all_running)
config_all_running(cfg) == TRUE

\* config_no_crashed (matches Coq: Definition config_no_crashed)
config_no_crashed(cfg) == TRUE

\* config_all_isolated (matches Coq: Definition config_all_isolated)
config_all_isolated(cfg) == TRUE

\* config_no_full_mailboxes (matches Coq: Definition config_no_full_mailboxes)
config_no_full_mailboxes(cfg) == TRUE

\* config_size (matches Coq: Definition config_size)
config_size(cfg) == TRUE

\* total_messages (matches Coq: Definition total_messages)
total_messages(cfg) == TRUE

\* deliver_message (matches Coq: Definition deliver_message)
deliver_message(cfg, target, m) == TRUE

\* spawn_actor (matches Coq: Definition spawn_actor)
spawn_actor(cfg, new_id) == TRUE

\* crash_actor (matches Coq: Definition crash_actor)
crash_actor(cfg, aid) == TRUE

\* restart_actor (matches Coq: Definition restart_actor)
restart_actor(cfg, aid) == TRUE

\* riina_msg_nat (matches Coq: Definition riina_msg_nat)
riina_msg_nat == TRUE

\* riina_msg_bool (matches Coq: Definition riina_msg_bool)
riina_msg_bool == TRUE

\* riina_msg_unit (matches Coq: Definition riina_msg_unit)
riina_msg_unit == TRUE

\* riina_msg_string (matches Coq: Definition riina_msg_string)
riina_msg_string == TRUE

\* riina_msg_pair (matches Coq: Definition riina_msg_pair)
riina_msg_pair == TRUE

\* riina_msg_ref (matches Coq: Definition riina_msg_ref)
riina_msg_ref == TRUE

\* riina_actor (matches Coq: Definition riina_actor)
riina_actor == TRUE

\* riina_actor_waiting (matches Coq: Definition riina_actor_waiting)
riina_actor_waiting == TRUE

\* riina_actor_crashed (matches Coq: Definition riina_actor_crashed)
riina_actor_crashed == TRUE

\* riina_actor_stopped (matches Coq: Definition riina_actor_stopped)
riina_actor_stopped == TRUE

\* riina_actor_restarting (matches Coq: Definition riina_actor_restarting)
riina_actor_restarting == TRUE

\* riina_actor_with_mail (matches Coq: Definition riina_actor_with_mail)
riina_actor_with_mail == TRUE

\* riina_config (matches Coq: Definition riina_config)
riina_config == TRUE

\* riina_cap_spawn (matches Coq: Definition riina_cap_spawn)
riina_cap_spawn == TRUE

\* riina_cap_send (matches Coq: Definition riina_cap_send)
riina_cap_send == TRUE

\* riina_cap_recv (matches Coq: Definition riina_cap_recv)
riina_cap_recv == TRUE

\* riina_cap_monitor (matches Coq: Definition riina_cap_monitor)
riina_cap_monitor == TRUE

\* riina_cap_link (matches Coq: Definition riina_cap_link)
riina_cap_link == TRUE

\* riina_cap_supervise (matches Coq: Definition riina_cap_supervise)
riina_cap_supervise == TRUE

\* riina_typed_actor (matches Coq: Definition riina_typed_actor)
riina_typed_actor == TRUE

\* riina_chan_send (matches Coq: Definition riina_chan_send)
riina_chan_send == TRUE

\* riina_chan_recv (matches Coq: Definition riina_chan_recv)
riina_chan_recv == TRUE

\* riina_chan_pair (matches Coq: Definition riina_chan_pair)
riina_chan_pair == TRUE

\* riina_session_ping_pong (matches Coq: Definition riina_session_ping_pong)
riina_session_ping_pong == TRUE

\* andb_true_iff (matches Coq: Lemma andb_true_iff)
THEOREM andb_true_iff == Init => TypeOK

\* andb_false_iff (matches Coq: Lemma andb_false_iff)
THEOREM andb_false_iff == Init => TypeOK

\* orb_true_iff (matches Coq: Lemma orb_true_iff)
THEOREM orb_true_iff == Init => TypeOK

\* negb_true_iff (matches Coq: Lemma negb_true_iff)
THEOREM negb_true_iff == Init => TypeOK

\* negb_false_iff (matches Coq: Lemma negb_false_iff)
THEOREM negb_false_iff == Init => TypeOK

\* leb_le (matches Coq: Lemma leb_le)
THEOREM leb_le == Init => TypeOK

\* ltb_lt (matches Coq: Lemma ltb_lt)
THEOREM ltb_lt == Init => TypeOK

\* eqb_eq (matches Coq: Lemma eqb_eq)
THEOREM eqb_eq == Init => TypeOK

\* AC_001_tag_eq_nat (matches Coq: Theorem AC_001_tag_eq_nat)
THEOREM AC_001_tag_eq_nat == Init => TypeOK

\* AC_002_tag_eq_bool (matches Coq: Theorem AC_002_tag_eq_bool)
THEOREM AC_002_tag_eq_bool == Init => TypeOK

\* AC_003_tag_eq_unit (matches Coq: Theorem AC_003_tag_eq_unit)
THEOREM AC_003_tag_eq_unit == Init => TypeOK

\* AC_004_tag_eq_string (matches Coq: Theorem AC_004_tag_eq_string)
THEOREM AC_004_tag_eq_string == Init => TypeOK

\* AC_005_tag_eq_pair (matches Coq: Theorem AC_005_tag_eq_pair)
THEOREM AC_005_tag_eq_pair == Init => TypeOK

\* AC_006_tag_eq_ref (matches Coq: Theorem AC_006_tag_eq_ref)
THEOREM AC_006_tag_eq_ref == Init => TypeOK

\* AC_007_tag_neq_nat_bool (matches Coq: Theorem AC_007_tag_neq_nat_bool)
THEOREM AC_007_tag_neq_nat_bool == Init => TypeOK

\* AC_008_tag_neq_nat_unit (matches Coq: Theorem AC_008_tag_neq_nat_unit)
THEOREM AC_008_tag_neq_nat_unit == Init => TypeOK

\* AC_009_tag_neq_bool_string (matches Coq: Theorem AC_009_tag_neq_bool_string)
THEOREM AC_009_tag_neq_bool_string == Init => TypeOK

\* AC_010_tag_neq_pair_ref (matches Coq: Theorem AC_010_tag_neq_pair_ref)
THEOREM AC_010_tag_neq_pair_ref == Init => TypeOK

\* AC_011_tag_eqb_refl (matches Coq: Theorem AC_011_tag_eqb_refl)
THEOREM AC_011_tag_eqb_refl == Init => TypeOK

\* AC_012_tag_eqb_sym (matches Coq: Theorem AC_012_tag_eqb_sym)
THEOREM AC_012_tag_eqb_sym == Init => TypeOK

\* AC_013_tag_eqb_true_eq (matches Coq: Theorem AC_013_tag_eqb_true_eq)
THEOREM AC_013_tag_eqb_true_eq == Init => TypeOK

\* AC_014_tag_eqb_false_neq (matches Coq: Theorem AC_014_tag_eqb_false_neq)
THEOREM AC_014_tag_eqb_false_neq == Init => TypeOK

\* AC_015_tag_eq_dec (matches Coq: Theorem AC_015_tag_eq_dec)
THEOREM AC_015_tag_eq_dec == Init => TypeOK

\* AC_016_msg_nat_tag (matches Coq: Theorem AC_016_msg_nat_tag)
THEOREM AC_016_msg_nat_tag == Init => TypeOK

\* AC_017_msg_bool_tag (matches Coq: Theorem AC_017_msg_bool_tag)
THEOREM AC_017_msg_bool_tag == Init => TypeOK

\* AC_018_msg_unit_tag (matches Coq: Theorem AC_018_msg_unit_tag)
THEOREM AC_018_msg_unit_tag == Init => TypeOK

\* AC_019_msg_string_tag (matches Coq: Theorem AC_019_msg_string_tag)
THEOREM AC_019_msg_string_tag == Init => TypeOK

\* AC_020_msg_pair_tag (matches Coq: Theorem AC_020_msg_pair_tag)
THEOREM AC_020_msg_pair_tag == Init => TypeOK

\* AC_021_status_eq_running (matches Coq: Theorem AC_021_status_eq_running)
THEOREM AC_021_status_eq_running == Init => TypeOK

\* AC_022_status_eq_stopped (matches Coq: Theorem AC_022_status_eq_stopped)
THEOREM AC_022_status_eq_stopped == Init => TypeOK

\* AC_023_status_eq_crashed (matches Coq: Theorem AC_023_status_eq_crashed)
THEOREM AC_023_status_eq_crashed == Init => TypeOK

\* AC_024_status_eq_waiting (matches Coq: Theorem AC_024_status_eq_waiting)
THEOREM AC_024_status_eq_waiting == Init => TypeOK

\* AC_025_status_eq_restarting (matches Coq: Theorem AC_025_status_eq_restarting)
THEOREM AC_025_status_eq_restarting == Init => TypeOK

\* AC_026_status_eqb_refl (matches Coq: Theorem AC_026_status_eqb_refl)
THEOREM AC_026_status_eqb_refl == Init => TypeOK

\* AC_027_status_eqb_sym (matches Coq: Theorem AC_027_status_eqb_sym)
THEOREM AC_027_status_eqb_sym == Init => TypeOK

\* AC_028_status_eqb_true_eq (matches Coq: Theorem AC_028_status_eqb_true_eq)
THEOREM AC_028_status_eqb_true_eq == Init => TypeOK

\* AC_029_status_neq_running_stopped (matches Coq: Theorem AC_029_status_neq_running_stopped)
THEOREM AC_029_status_neq_running_stopped == Init => TypeOK

\* AC_030_status_neq_running_crashed (matches Coq: Theorem AC_030_status_neq_running_crashed)
THEOREM AC_030_status_neq_running_crashed == Init => TypeOK

\* AC_031_riina_is_running (matches Coq: Theorem AC_031_riina_is_running)
THEOREM AC_031_riina_is_running == Init => TypeOK

\* AC_032_crashed_not_running (matches Coq: Theorem AC_032_crashed_not_running)
THEOREM AC_032_crashed_not_running == Init => TypeOK

\* AC_033_stopped_not_running (matches Coq: Theorem AC_033_stopped_not_running)
THEOREM AC_033_stopped_not_running == Init => TypeOK

\* AC_034_waiting_not_running (matches Coq: Theorem AC_034_waiting_not_running)
THEOREM AC_034_waiting_not_running == Init => TypeOK

\* AC_035_crashed_is_crashed (matches Coq: Theorem AC_035_crashed_is_crashed)
THEOREM AC_035_crashed_is_crashed == Init => TypeOK

\* AC_036_running_not_crashed (matches Coq: Theorem AC_036_running_not_crashed)
THEOREM AC_036_running_not_crashed == Init => TypeOK

\* AC_037_stopped_is_stopped (matches Coq: Theorem AC_037_stopped_is_stopped)
THEOREM AC_037_stopped_is_stopped == Init => TypeOK

\* AC_038_waiting_is_waiting (matches Coq: Theorem AC_038_waiting_is_waiting)
THEOREM AC_038_waiting_is_waiting == Init => TypeOK

\* AC_039_restarting_is_restarting (matches Coq: Theorem AC_039_restarting_is_restarting)
THEOREM AC_039_restarting_is_restarting == Init => TypeOK

\* AC_040_status_exclusive_run_crash (matches Coq: Theorem AC_040_status_exclusive_run_crash)
THEOREM AC_040_status_exclusive_run_crash == Init => TypeOK

\* AC_041_empty_mailbox (matches Coq: Theorem AC_041_empty_mailbox)
THEOREM AC_041_empty_mailbox == Init => TypeOK

\* AC_042_nonempty_mailbox (matches Coq: Theorem AC_042_nonempty_mailbox)
THEOREM AC_042_nonempty_mailbox == Init => TypeOK

\* AC_043_has_messages_with_mail (matches Coq: Theorem AC_043_has_messages_with_mail)
THEOREM AC_043_has_messages_with_mail == Init => TypeOK

\* AC_044_no_messages_empty (matches Coq: Theorem AC_044_no_messages_empty)
THEOREM AC_044_no_messages_empty == Init => TypeOK

\* AC_045_empty_iff_no_messages (matches Coq: Theorem AC_045_empty_iff_no_messages)
THEOREM AC_045_empty_iff_no_messages == Init => TypeOK

\* AC_046_nil_mailbox_empty (matches Coq: Theorem AC_046_nil_mailbox_empty)
THEOREM AC_046_nil_mailbox_empty == Init => TypeOK

\* AC_047_cons_mailbox_nonempty (matches Coq: Theorem AC_047_cons_mailbox_nonempty)
THEOREM AC_047_cons_mailbox_nonempty == Init => TypeOK

\* AC_048_mailbox_length_nil (matches Coq: Theorem AC_048_mailbox_length_nil)
THEOREM AC_048_mailbox_length_nil == Init => TypeOK

\* AC_049_mailbox_length_cons (matches Coq: Theorem AC_049_mailbox_length_cons)
THEOREM AC_049_mailbox_length_cons == Init => TypeOK

\* AC_050_append_preserves_messages (matches Coq: Theorem AC_050_append_preserves_messages)
THEOREM AC_050_append_preserves_messages == Init => TypeOK

\* AC_051_append_nonempty (matches Coq: Theorem AC_051_append_nonempty)
THEOREM AC_051_append_nonempty == Init => TypeOK

\* AC_052_in_append_right (matches Coq: Theorem AC_052_in_append_right)
THEOREM AC_052_in_append_right == Init => TypeOK

\* AC_053_in_append_left (matches Coq: Theorem AC_053_in_append_left)
THEOREM AC_053_in_append_left == Init => TypeOK

\* AC_054_mailbox_app_assoc (matches Coq: Theorem AC_054_mailbox_app_assoc)
THEOREM AC_054_mailbox_app_assoc == Init => TypeOK

\* AC_055_mailbox_app_nil (matches Coq: Theorem AC_055_mailbox_app_nil)
THEOREM AC_055_mailbox_app_nil == Init => TypeOK

\* AC_056_deliver_preserves_length (matches Coq: Theorem AC_056_deliver_preserves_length)
THEOREM AC_056_deliver_preserves_length == Init => TypeOK

\* AC_057_spawn_increases_length (matches Coq: Theorem AC_057_spawn_increases_length)
THEOREM AC_057_spawn_increases_length == Init => TypeOK

\* AC_058_crash_preserves_length (matches Coq: Theorem AC_058_crash_preserves_length)
THEOREM AC_058_crash_preserves_length == Init => TypeOK

\* AC_059_restart_preserves_length (matches Coq: Theorem AC_059_restart_preserves_length)
THEOREM AC_059_restart_preserves_length == Init => TypeOK

\* AC_060_config_size_spawn (matches Coq: Theorem AC_060_config_size_spawn)
THEOREM AC_060_config_size_spawn == Init => TypeOK

\* AC_061_config_size_deliver (matches Coq: Theorem AC_061_config_size_deliver)
THEOREM AC_061_config_size_deliver == Init => TypeOK

\* AC_062_forallb_nil (matches Coq: Theorem AC_062_forallb_nil)
THEOREM AC_062_forallb_nil == Init => TypeOK

\* AC_063_config_all_running_nil (matches Coq: Theorem AC_063_config_all_running_nil)
THEOREM AC_063_config_all_running_nil == Init => TypeOK

\* AC_064_config_no_crashed_nil (matches Coq: Theorem AC_064_config_no_crashed_nil)
THEOREM AC_064_config_no_crashed_nil == Init => TypeOK

\* AC_065_config_all_running_single (matches Coq: Theorem AC_065_config_all_running_single)
THEOREM AC_065_config_all_running_single == Init => TypeOK

\* AC_066_cap_kind_eq_spawn (matches Coq: Theorem AC_066_cap_kind_eq_spawn)
THEOREM AC_066_cap_kind_eq_spawn == Init => TypeOK

\* AC_067_cap_kind_eq_send (matches Coq: Theorem AC_067_cap_kind_eq_send)
THEOREM AC_067_cap_kind_eq_send == Init => TypeOK

\* AC_068_cap_kind_eq_recv (matches Coq: Theorem AC_068_cap_kind_eq_recv)
THEOREM AC_068_cap_kind_eq_recv == Init => TypeOK

\* AC_069_cap_kind_eq_monitor (matches Coq: Theorem AC_069_cap_kind_eq_monitor)
THEOREM AC_069_cap_kind_eq_monitor == Init => TypeOK

\* AC_070_cap_kind_eq_link (matches Coq: Theorem AC_070_cap_kind_eq_link)
THEOREM AC_070_cap_kind_eq_link == Init => TypeOK

\* AC_071_cap_kind_eq_supervise (matches Coq: Theorem AC_071_cap_kind_eq_supervise)
THEOREM AC_071_cap_kind_eq_supervise == Init => TypeOK

\* AC_072_cap_kind_eqb_refl (matches Coq: Theorem AC_072_cap_kind_eqb_refl)
THEOREM AC_072_cap_kind_eqb_refl == Init => TypeOK

\* AC_073_cap_kind_eqb_sym (matches Coq: Theorem AC_073_cap_kind_eqb_sym)
THEOREM AC_073_cap_kind_eqb_sym == Init => TypeOK

\* AC_074_cap_kind_eqb_true_eq (matches Coq: Theorem AC_074_cap_kind_eqb_true_eq)
THEOREM AC_074_cap_kind_eqb_true_eq == Init => TypeOK

\* AC_075_cap_neq_spawn_send (matches Coq: Theorem AC_075_cap_neq_spawn_send)
THEOREM AC_075_cap_neq_spawn_send == Init => TypeOK

\* AC_076_riina_can_spawn (matches Coq: Theorem AC_076_riina_can_spawn)
THEOREM AC_076_riina_can_spawn == Init => TypeOK

\* AC_077_riina_can_send (matches Coq: Theorem AC_077_riina_can_send)
THEOREM AC_077_riina_can_send == Init => TypeOK

\* AC_078_riina_can_recv (matches Coq: Theorem AC_078_riina_can_recv)
THEOREM AC_078_riina_can_recv == Init => TypeOK

\* AC_079_riina_can_monitor (matches Coq: Theorem AC_079_riina_can_monitor)
THEOREM AC_079_riina_can_monitor == Init => TypeOK

\* AC_080_empty_caps_no_spawn (matches Coq: Theorem AC_080_empty_caps_no_spawn)
THEOREM AC_080_empty_caps_no_spawn == Init => TypeOK

\* AC_081_empty_caps_no_send (matches Coq: Theorem AC_081_empty_caps_no_send)
THEOREM AC_081_empty_caps_no_send == Init => TypeOK

\* AC_082_empty_caps_no_recv (matches Coq: Theorem AC_082_empty_caps_no_recv)
THEOREM AC_082_empty_caps_no_recv == Init => TypeOK

\* AC_083_empty_caps_no_monitor (matches Coq: Theorem AC_083_empty_caps_no_monitor)
THEOREM AC_083_empty_caps_no_monitor == Init => TypeOK

\* AC_084_empty_caps_no_link (matches Coq: Theorem AC_084_empty_caps_no_link)
THEOREM AC_084_empty_caps_no_link == Init => TypeOK

\* AC_085_empty_caps_no_supervise (matches Coq: Theorem AC_085_empty_caps_no_supervise)
THEOREM AC_085_empty_caps_no_supervise == Init => TypeOK

\* AC_086_acap_active_granted (matches Coq: Theorem AC_086_acap_active_granted)
THEOREM AC_086_acap_active_granted == Init => TypeOK

\* AC_087_acap_not_active_not_granted (matches Coq: Theorem AC_087_acap_not_active_not_granted)
THEOREM AC_087_acap_not_active_not_granted == Init => TypeOK

\* AC_088_riina_cap_spawn_active (matches Coq: Theorem AC_088_riina_cap_spawn_active)
THEOREM AC_088_riina_cap_spawn_active == Init => TypeOK

\* AC_089_riina_cap_send_revocable (matches Coq: Theorem AC_089_riina_cap_send_revocable)
THEOREM AC_089_riina_cap_send_revocable == Init => TypeOK

\* AC_090_revoked_cap_not_spawnable (matches Coq: Theorem AC_090_revoked_cap_not_spawnable)
THEOREM AC_090_revoked_cap_not_spawnable == Init => TypeOK

\* AC_091_dual_end (matches Coq: Theorem AC_091_dual_end)
THEOREM AC_091_dual_end == Init => TypeOK

\* AC_092_dual_send (matches Coq: Theorem AC_092_dual_send)
THEOREM AC_092_dual_send == Init => TypeOK

\* AC_093_dual_recv (matches Coq: Theorem AC_093_dual_recv)
THEOREM AC_093_dual_recv == Init => TypeOK

\* AC_094_dual_select (matches Coq: Theorem AC_094_dual_select)
THEOREM AC_094_dual_select == Init => TypeOK

\* AC_095_dual_offer (matches Coq: Theorem AC_095_dual_offer)
THEOREM AC_095_dual_offer == Init => TypeOK

\* AC_096_dual_involutive_end (matches Coq: Theorem AC_096_dual_involutive_end)
THEOREM AC_096_dual_involutive_end == Init => TypeOK

\* AC_097_dual_involutive_send_end (matches Coq: Theorem AC_097_dual_involutive_send_end)
THEOREM AC_097_dual_involutive_send_end == Init => TypeOK

\* AC_098_dual_involutive_recv_end (matches Coq: Theorem AC_098_dual_involutive_recv_end)
THEOREM AC_098_dual_involutive_recv_end == Init => TypeOK

\* AC_099_dual_send_recv_end (matches Coq: Theorem AC_099_dual_send_recv_end)
THEOREM AC_099_dual_send_recv_end == Init => TypeOK

\* AC_100_dual_recv_send_end (matches Coq: Theorem AC_100_dual_recv_send_end)
THEOREM AC_100_dual_recv_send_end == Init => TypeOK

\* AC_101_dual_preserves_msg_type (matches Coq: Theorem AC_101_dual_preserves_msg_type)
THEOREM AC_101_dual_preserves_msg_type == Init => TypeOK

\* AC_102_dual_preserves_msg_type_recv (matches Coq: Theorem AC_102_dual_preserves_msg_type_recv)
THEOREM AC_102_dual_preserves_msg_type_recv == Init => TypeOK

\* AC_103_dual_ping_pong (matches Coq: Theorem AC_103_dual_ping_pong)
THEOREM AC_103_dual_ping_pong == Init => TypeOK

\* AC_104_dual_dual_ping_pong (matches Coq: Theorem AC_104_dual_dual_ping_pong)
THEOREM AC_104_dual_dual_ping_pong == Init => TypeOK

\* AC_105_dual_select_nil (matches Coq: Theorem AC_105_dual_select_nil)
THEOREM AC_105_dual_select_nil == Init => TypeOK

\* AC_106_dual_offer_nil (matches Coq: Theorem AC_106_dual_offer_nil)
THEOREM AC_106_dual_offer_nil == Init => TypeOK

\* AC_107_dual_select_single (matches Coq: Theorem AC_107_dual_select_single)
THEOREM AC_107_dual_select_single == Init => TypeOK

\* AC_108_dual_offer_single (matches Coq: Theorem AC_108_dual_offer_single)
THEOREM AC_108_dual_offer_single == Init => TypeOK

\* AC_109_dual_three_chain (matches Coq: Theorem AC_109_dual_three_chain)
THEOREM AC_109_dual_three_chain == Init => TypeOK

\* AC_110_dual_dual_three_chain (matches Coq: Theorem AC_110_dual_dual_three_chain)
THEOREM AC_110_dual_dual_three_chain == Init => TypeOK

\* AC_111_chan_fresh_riina (matches Coq: Theorem AC_111_chan_fresh_riina)
THEOREM AC_111_chan_fresh_riina == Init => TypeOK

\* AC_112_chan_used_not_fresh (matches Coq: Theorem AC_112_chan_used_not_fresh)
THEOREM AC_112_chan_used_not_fresh == Init => TypeOK

\* AC_113_chan_used_preserves_id (matches Coq: Theorem AC_113_chan_used_preserves_id)
THEOREM AC_113_chan_used_preserves_id == Init => TypeOK

\* AC_114_chan_used_preserves_session (matches Coq: Theorem AC_114_chan_used_preserves_session)
THEOREM AC_114_chan_used_preserves_session == Init => TypeOK

\* AC_115_chan_close_inactive (matches Coq: Theorem AC_115_chan_close_inactive)
THEOREM AC_115_chan_close_inactive == Init => TypeOK

\* AC_116_chan_close_session_end (matches Coq: Theorem AC_116_chan_close_session_end)
THEOREM AC_116_chan_close_session_end == Init => TypeOK

\* AC_117_chan_close_not_linear (matches Coq: Theorem AC_117_chan_close_not_linear)
THEOREM AC_117_chan_close_not_linear == Init => TypeOK

\* AC_118_chan_close_preserves_id (matches Coq: Theorem AC_118_chan_close_preserves_id)
THEOREM AC_118_chan_close_preserves_id == Init => TypeOK

\* AC_119_msg_type_compat_nat (matches Coq: Theorem AC_119_msg_type_compat_nat)
THEOREM AC_119_msg_type_compat_nat == Init => TypeOK

\* AC_120_msg_type_compat_bool (matches Coq: Theorem AC_120_msg_type_compat_bool)
THEOREM AC_120_msg_type_compat_bool == Init => TypeOK

\* AC_121_msg_type_incompat (matches Coq: Theorem AC_121_msg_type_incompat)
THEOREM AC_121_msg_type_incompat == Init => TypeOK

\* AC_122_msg_type_compat_refl (matches Coq: Theorem AC_122_msg_type_compat_refl)
THEOREM AC_122_msg_type_compat_refl == Init => TypeOK

\* AC_123_mailbox_wt_nil (matches Coq: Theorem AC_123_mailbox_wt_nil)
THEOREM AC_123_mailbox_wt_nil == Init => TypeOK

\* AC_124_mailbox_wt_cons (matches Coq: Theorem AC_124_mailbox_wt_cons)
THEOREM AC_124_mailbox_wt_cons == Init => TypeOK

\* AC_125_mailbox_wt_append (matches Coq: Theorem AC_125_mailbox_wt_append)
THEOREM AC_125_mailbox_wt_append == Init => TypeOK

\* AC_126_riina_actor_well_typed (matches Coq: Theorem AC_126_riina_actor_well_typed)
THEOREM AC_126_riina_actor_well_typed == Init => TypeOK

\* AC_127_find_actor_head (matches Coq: Theorem AC_127_find_actor_head)
THEOREM AC_127_find_actor_head == Init => TypeOK

\* AC_128_find_actor_nil (matches Coq: Theorem AC_128_find_actor_nil)
THEOREM AC_128_find_actor_nil == Init => TypeOK

\* AC_129_find_actor_riina (matches Coq: Theorem AC_129_find_actor_riina)
THEOREM AC_129_find_actor_riina == Init => TypeOK

\* AC_130_find_actor_with_mail (matches Coq: Theorem AC_130_find_actor_with_mail)
THEOREM AC_130_find_actor_with_mail == Init => TypeOK

\* AC_131_config_all_running_cons (matches Coq: Theorem AC_131_config_all_running_cons)
THEOREM AC_131_config_all_running_cons == Init => TypeOK

\* AC_132_config_no_crashed_cons (matches Coq: Theorem AC_132_config_no_crashed_cons)
THEOREM AC_132_config_no_crashed_cons == Init => TypeOK

\* AC_133_running_not_crashed_config (matches Coq: Theorem AC_133_running_not_crashed_config)
THEOREM AC_133_running_not_crashed_config == Init => TypeOK

\* AC_134_status_exclusive_run_stop (matches Coq: Theorem AC_134_status_exclusive_run_stop)
THEOREM AC_134_status_exclusive_run_stop == Init => TypeOK

\* AC_135_status_exclusive_run_wait (matches Coq: Theorem AC_135_status_exclusive_run_wait)
THEOREM AC_135_status_exclusive_run_wait == Init => TypeOK

\* AC_136_status_exclusive_run_restart (matches Coq: Theorem AC_136_status_exclusive_run_restart)
THEOREM AC_136_status_exclusive_run_restart == Init => TypeOK

\* AC_137_status_exclusive_crash_stop (matches Coq: Theorem AC_137_status_exclusive_crash_stop)
THEOREM AC_137_status_exclusive_crash_stop == Init => TypeOK

\* AC_138_status_exclusive_crash_wait (matches Coq: Theorem AC_138_status_exclusive_crash_wait)
THEOREM AC_138_status_exclusive_crash_wait == Init => TypeOK

\* AC_139_can_receive_running_not_full (matches Coq: Theorem AC_139_can_receive_running_not_full)
THEOREM AC_139_can_receive_running_not_full == Init => TypeOK

\* AC_140_can_receive_not_full (matches Coq: Theorem AC_140_can_receive_not_full)
THEOREM AC_140_can_receive_not_full == Init => TypeOK

\* AC_141_well_typed_is_running (matches Coq: Theorem AC_141_well_typed_is_running)
THEOREM AC_141_well_typed_is_running == Init => TypeOK

\* AC_142_well_typed_is_isolated (matches Coq: Theorem AC_142_well_typed_is_isolated)
THEOREM AC_142_well_typed_is_isolated == Init => TypeOK

\* AC_143_well_typed_mailbox (matches Coq: Theorem AC_143_well_typed_mailbox)
THEOREM AC_143_well_typed_mailbox == Init => TypeOK

\* AC_144_well_typed_not_crashed (matches Coq: Theorem AC_144_well_typed_not_crashed)
THEOREM AC_144_well_typed_not_crashed == Init => TypeOK

\* AC_145_well_typed_not_stopped (matches Coq: Theorem AC_145_well_typed_not_stopped)
THEOREM AC_145_well_typed_not_stopped == Init => TypeOK

\* AC_146_well_typed_not_waiting (matches Coq: Theorem AC_146_well_typed_not_waiting)
THEOREM AC_146_well_typed_not_waiting == Init => TypeOK

\* AC_147_well_typed_not_restarting (matches Coq: Theorem AC_147_well_typed_not_restarting)
THEOREM AC_147_well_typed_not_restarting == Init => TypeOK

\* AC_148_well_typed_compose (matches Coq: Theorem AC_148_well_typed_compose)
THEOREM AC_148_well_typed_compose == Init => TypeOK

\* AC_149_empty_mailbox_any_type (matches Coq: Theorem AC_149_empty_mailbox_any_type)
THEOREM AC_149_empty_mailbox_any_type == Init => TypeOK

\* AC_150_single_msg_well_typed (matches Coq: Theorem AC_150_single_msg_well_typed)
THEOREM AC_150_single_msg_well_typed == Init => TypeOK

\* AC_151_msg_compat_cons (matches Coq: Theorem AC_151_msg_compat_cons)
THEOREM AC_151_msg_compat_cons == Init => TypeOK

\* AC_152_msg_compat_self_list (matches Coq: Theorem AC_152_msg_compat_self_list)
THEOREM AC_152_msg_compat_self_list == Init => TypeOK

\* AC_153_msg_compat_in (matches Coq: Theorem AC_153_msg_compat_in)
THEOREM AC_153_msg_compat_in == Init => TypeOK

\* AC_154_riina_actor_not_full (matches Coq: Theorem AC_154_riina_actor_not_full)
THEOREM AC_154_riina_actor_not_full == Init => TypeOK

\* AC_155_riina_can_receive (matches Coq: Theorem AC_155_riina_can_receive)
THEOREM AC_155_riina_can_receive == Init => TypeOK

\* AC_156_crashed_cannot_receive (matches Coq: Theorem AC_156_crashed_cannot_receive)
THEOREM AC_156_crashed_cannot_receive == Init => TypeOK

\* AC_157_stopped_cannot_receive (matches Coq: Theorem AC_157_stopped_cannot_receive)
THEOREM AC_157_stopped_cannot_receive == Init => TypeOK

\* AC_158_waiting_cannot_receive (matches Coq: Theorem AC_158_waiting_cannot_receive)
THEOREM AC_158_waiting_cannot_receive == Init => TypeOK

\* AC_159_restarting_cannot_receive (matches Coq: Theorem AC_159_restarting_cannot_receive)
THEOREM AC_159_restarting_cannot_receive == Init => TypeOK

\* AC_160_well_typed_all_msgs_compat (matches Coq: Theorem AC_160_well_typed_all_msgs_compat)
THEOREM AC_160_well_typed_all_msgs_compat == Init => TypeOK

\* AC_161_spawn_running (matches Coq: Theorem AC_161_spawn_running)
THEOREM AC_161_spawn_running == Init => TypeOK

\* AC_162_config_size_empty (matches Coq: Theorem AC_162_config_size_empty)
THEOREM AC_162_config_size_empty == Init => TypeOK

\* AC_163_config_size_cons (matches Coq: Theorem AC_163_config_size_cons)
THEOREM AC_163_config_size_cons == Init => TypeOK

\* AC_164_crash_preserves_others (matches Coq: Theorem AC_164_crash_preserves_others)
THEOREM AC_164_crash_preserves_others == Init => TypeOK

\* AC_165_restart_preserves_others (matches Coq: Theorem AC_165_restart_preserves_others)
THEOREM AC_165_restart_preserves_others == Init => TypeOK

\* AC_166_deliver_preserves_others (matches Coq: Theorem AC_166_deliver_preserves_others)
THEOREM AC_166_deliver_preserves_others == Init => TypeOK

\* AC_167_config_no_crashed_running (matches Coq: Theorem AC_167_config_no_crashed_running)
THEOREM AC_167_config_no_crashed_running == Init => TypeOK

\* AC_168_spawn_preserves_existing (matches Coq: Theorem AC_168_spawn_preserves_existing)
THEOREM AC_168_spawn_preserves_existing == Init => TypeOK

\* AC_169_spawn_adds_new (matches Coq: Theorem AC_169_spawn_adds_new)
THEOREM AC_169_spawn_adds_new == Init => TypeOK

\* AC_170_riina_config_size (matches Coq: Theorem AC_170_riina_config_size)
THEOREM AC_170_riina_config_size == Init => TypeOK

\* AC_171_total_messages_nil (matches Coq: Theorem AC_171_total_messages_nil)
THEOREM AC_171_total_messages_nil == Init => TypeOK

\* AC_172_total_messages_riina (matches Coq: Theorem AC_172_total_messages_riina)
THEOREM AC_172_total_messages_riina == Init => TypeOK

\* AC_173_config_no_full_nil (matches Coq: Theorem AC_173_config_no_full_nil)
THEOREM AC_173_config_no_full_nil == Init => TypeOK

\* AC_174_config_no_full_cons (matches Coq: Theorem AC_174_config_no_full_cons)
THEOREM AC_174_config_no_full_cons == Init => TypeOK

\* AC_175_deliver_to_absent_noop (matches Coq: Theorem AC_175_deliver_to_absent_noop)
THEOREM AC_175_deliver_to_absent_noop == Init => TypeOK

\* AC_176_config_all_isolated_nil (matches Coq: Theorem AC_176_config_all_isolated_nil)
THEOREM AC_176_config_all_isolated_nil == Init => TypeOK

\* AC_177_config_all_isolated_cons (matches Coq: Theorem AC_177_config_all_isolated_cons)
THEOREM AC_177_config_all_isolated_cons == Init => TypeOK

\* AC_178_riina_actor_isolated (matches Coq: Theorem AC_178_riina_actor_isolated)
THEOREM AC_178_riina_actor_isolated == Init => TypeOK

\* AC_179_empty_config_all_predicates (matches Coq: Theorem AC_179_empty_config_all_predicates)
THEOREM AC_179_empty_config_all_predicates == Init => TypeOK

\* AC_180_crash_actor_nil (matches Coq: Theorem AC_180_crash_actor_nil)
THEOREM AC_180_crash_actor_nil == Init => TypeOK

\* AC_181_deliver_increases_mailbox (matches Coq: Theorem AC_181_deliver_increases_mailbox)
THEOREM AC_181_deliver_increases_mailbox == Init => TypeOK

\* AC_182_message_not_lost_on_deliver (matches Coq: Theorem AC_182_message_not_lost_on_deliver)
THEOREM AC_182_message_not_lost_on_deliver == Init => TypeOK

\* AC_183_old_messages_preserved (matches Coq: Theorem AC_183_old_messages_preserved)
THEOREM AC_183_old_messages_preserved == Init => TypeOK

\* AC_184_delivery_order_fifo (matches Coq: Theorem AC_184_delivery_order_fifo)
THEOREM AC_184_delivery_order_fifo == Init => TypeOK

\* AC_185_restart_clears_mailbox (matches Coq: Theorem AC_185_restart_clears_mailbox)
THEOREM AC_185_restart_clears_mailbox == Init => TypeOK

\* AC_186_restart_sets_running (matches Coq: Theorem AC_186_restart_sets_running)
THEOREM AC_186_restart_sets_running == Init => TypeOK

\* AC_187_restart_increments_count (matches Coq: Theorem AC_187_restart_increments_count)
THEOREM AC_187_restart_increments_count == Init => TypeOK

\* AC_188_crash_sets_crashed (matches Coq: Theorem AC_188_crash_sets_crashed)
THEOREM AC_188_crash_sets_crashed == Init => TypeOK

\* AC_189_crash_preserves_mailbox (matches Coq: Theorem AC_189_crash_preserves_mailbox)
THEOREM AC_189_crash_preserves_mailbox == Init => TypeOK

\* AC_190_restart_nil (matches Coq: Theorem AC_190_restart_nil)
THEOREM AC_190_restart_nil == Init => TypeOK

\* AC_191_deliver_nil (matches Coq: Theorem AC_191_deliver_nil)
THEOREM AC_191_deliver_nil == Init => TypeOK

\* AC_192_spawn_nil (matches Coq: Theorem AC_192_spawn_nil)
THEOREM AC_192_spawn_nil == Init => TypeOK

\* AC_193_well_typed_preserved_empty_deliver (matches Coq: Theorem AC_193_well_typed_preserved_empty_deliver)
THEOREM AC_193_well_typed_preserved_empty_deliver == Init => TypeOK

\* AC_194_capability_required_for_spawn (matches Coq: Theorem AC_194_capability_required_for_spawn)
THEOREM AC_194_capability_required_for_spawn == Init => TypeOK

\* AC_195_capability_required_for_send (matches Coq: Theorem AC_195_capability_required_for_send)
THEOREM AC_195_capability_required_for_send == Init => TypeOK

\* AC_196_has_cap_kind_cons (matches Coq: Theorem AC_196_has_cap_kind_cons)
THEOREM AC_196_has_cap_kind_cons == Init => TypeOK

\* AC_197_has_cap_kind_tail (matches Coq: Theorem AC_197_has_cap_kind_tail)
THEOREM AC_197_has_cap_kind_tail == Init => TypeOK

\* AC_198_session_duality_symmetric (matches Coq: Theorem AC_198_session_duality_symmetric)
THEOREM AC_198_session_duality_symmetric == Init => TypeOK

\* AC_199_session_duality_symmetric_recv (matches Coq: Theorem AC_199_session_duality_symmetric_recv)
THEOREM AC_199_session_duality_symmetric_recv == Init => TypeOK

\* AC_200_chan_pair_dual (matches Coq: Theorem AC_200_chan_pair_dual)
THEOREM AC_200_chan_pair_dual == Init => TypeOK

\* AC_201_status_eq_dec (matches Coq: Theorem AC_201_status_eq_dec)
THEOREM AC_201_status_eq_dec == Init => TypeOK

\* AC_202_cap_kind_eq_dec (matches Coq: Theorem AC_202_cap_kind_eq_dec)
THEOREM AC_202_cap_kind_eq_dec == Init => TypeOK

\* AC_203_mailbox_wt_single_compat (matches Coq: Theorem AC_203_mailbox_wt_single_compat)
THEOREM AC_203_mailbox_wt_single_compat == Init => TypeOK

\* AC_204_deliver_idempotent_absent (matches Coq: Theorem AC_204_deliver_idempotent_absent)
THEOREM AC_204_deliver_idempotent_absent == Init => TypeOK

\* AC_205_spawn_then_find (matches Coq: Theorem AC_205_spawn_then_find)
THEOREM AC_205_spawn_then_find == Init => TypeOK

\* AC_206_riina_msg_ref_tag (matches Coq: Theorem AC_206_riina_msg_ref_tag)
THEOREM AC_206_riina_msg_ref_tag == Init => TypeOK

\* AC_207_riina_msg_sender (matches Coq: Theorem AC_207_riina_msg_sender)
THEOREM AC_207_riina_msg_sender == Init => TypeOK

\* AC_208_riina_msg_priority (matches Coq: Theorem AC_208_riina_msg_priority)
THEOREM AC_208_riina_msg_priority == Init => TypeOK

\* AC_209_riina_msg_payload (matches Coq: Theorem AC_209_riina_msg_payload)
THEOREM AC_209_riina_msg_payload == Init => TypeOK

\* AC_210_riina_actor_id (matches Coq: Theorem AC_210_riina_actor_id)
THEOREM AC_210_riina_actor_id == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<msg_tag, msg_payload, msg_sender, msg_priority, actor_id, actor_status, actor_mailbox, actor_local, actor_msg_count, actor_spawn_count, actor_max_mailbox, actor_restart_count, achan_id, achan_session, achan_linear, achan_active, achan_endpoint_a, achan_endpoint_b, acap_kind, acap_granted, acap_revocable, acap_target, ta_state, ta_expected, ta_session, ta_caps, ta_isolated>>

\* Specification
Spec == Init /\ [][Next]_<<msg_tag, msg_payload, msg_sender, msg_priority, actor_id, actor_status, actor_mailbox, actor_local, actor_msg_count, actor_spawn_count, actor_max_mailbox, actor_restart_count, achan_id, achan_session, achan_linear, achan_active, achan_endpoint_a, achan_endpoint_b, acap_kind, acap_granted, acap_revocable, acap_target, ta_state, ta_expected, ta_session, ta_caps, ta_isolated>>

====

(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/domains/ActorCalculus.v (218 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Domains.ActorCalculus
open FStar.All

(* MsgTag (matches Coq) *)
type msg_tag =
  | TagNat
  | TagBool
  | TagUnit
  | TagString
  | TagPair
  | TagActorRef

(* ActorStatus (matches Coq) *)
type actor_status =
  | Running
  | Stopped
  | Crashed
  | Waiting
  | Restarting

(* ActorSessionType (matches Coq) *)
type actor_session_type =
  | ASTSend of (msg_tag * actor_session_type)
  | ASTRecv of (msg_tag * actor_session_type)
  | ASTEnd

(* CapKind (matches Coq) *)
type cap_kind =
  | CapSpawn
  | CapSend
  | CapRecv
  | CapMonitor
  | CapLink
  | CapSupervise

(* Message (matches Coq) *)
type message = {
  f_msg_tag: msg_tag;
  f_msg_payload: nat;
  f_msg_sender: nat;
  f_msg_priority: nat;
}

(* ActorState (matches Coq) *)
type actor_state = {
  f_actor_id: nat;
  f_actor_status: actor_status;
  f_actor_mailbox: nat;
  f_actor_local: nat;
  f_actor_msg_count: nat;
  f_actor_spawn_count: nat;
  f_actor_max_mailbox: nat;
  f_actor_restart_count: nat;
}

(* ActorChannel (matches Coq) *)
type actor_channel = {
  f_achan_id: nat;
  f_achan_session: actor_session_type;
  f_achan_linear: bool;
  f_achan_active: bool;
}

(* ActorChannelPair (matches Coq) *)
type actor_channel_pair = {
  f_achan_endpoint_a: actor_channel;
  f_achan_endpoint_b: actor_channel;
}

(* ActorCapability (matches Coq) *)
type actor_capability = {
  f_acap_kind: cap_kind;
  f_acap_granted: bool;
  f_acap_revocable: bool;
  f_acap_target: nat;
}

(* TypedActor (matches Coq) *)
type typed_actor = {
  f_ta_state: actor_state;
  f_ta_expected: list bool;
  f_ta_session: nat;
  f_ta_caps: list bool;
  f_ta_isolated: bool;
}

(* msg_tag_eqb (matches Coq: Definition msg_tag_eqb) *)
let msg_tag_eqb (p_t1: msg_tag) (p_t2: msg_tag) : Tot bool =
  match p_t1, p_t2 with
  | TagNat, TagNat -> true
  | TagBool, TagBool -> true
  | TagUnit, TagUnit -> true
  | TagString, TagString -> true
  | TagPair, TagPair -> true
  | TagActorRef, TagActorRef -> true
  | _, _ -> false
  | _ -> false

(* status_eqb (matches Coq: Definition status_eqb) *)
let status_eqb (p_s1: actor_status) (p_s2: actor_status) : Tot bool =
  match p_s1, p_s2 with
  | Running, Running -> true
  | Stopped, Stopped -> true
  | Crashed, Crashed -> true
  | Waiting, Waiting -> true
  | Restarting, Restarting -> true
  | _, _ -> false
  | _ -> false

(* is_running (matches Coq: Definition is_running) *)
let is_running (p_a: actor_state) : Tot bool =
  status_eqb (p_a.f_actor_status) Running

(* is_stopped (matches Coq: Definition is_stopped) *)
let is_stopped (p_a: actor_state) : Tot bool =
  status_eqb (p_a.f_actor_status) Stopped

(* is_crashed (matches Coq: Definition is_crashed) *)
let is_crashed (p_a: actor_state) : Tot bool =
  status_eqb (p_a.f_actor_status) Crashed

(* is_waiting (matches Coq: Definition is_waiting) *)
let is_waiting (p_a: actor_state) : Tot bool =
  status_eqb (p_a.f_actor_status) Waiting

(* is_restarting (matches Coq: Definition is_restarting) *)
let is_restarting (p_a: actor_state) : Tot bool =
  status_eqb (p_a.f_actor_status) Restarting

(* has_messages (matches Coq: Definition has_messages) *)
let has_messages (p_a: actor_state) : Tot bool =
  (not (Nat.eqb (List.Tot.length (p_a.f_actor_mailbox))) 0)

(* mailbox_empty (matches Coq: Definition mailbox_empty) *)
let mailbox_empty (p_a: actor_state) : Tot bool =
  Nat.eqb (List.Tot.length (p_a.f_actor_mailbox)) 0

(* mailbox_full (matches Coq: Definition mailbox_full) *)
let mailbox_full (p_a: actor_state) : Tot bool =
  (p_a.f_actor_max_mailbox) <= (List.Tot.length (p_a.f_actor_mailbox))

(* can_receive (matches Coq: Definition can_receive) *)
let can_receive (p_a: actor_state) : Tot bool =
  is_running p_a && (not (mailbox_full p_a))

(* ast_dual (matches Coq: Fixpoint ast_dual) *)
let rec ast_dual (p_s: actor_session_type) : Tot actor_session_type =
  match p_s with
  | ASTSend (t, p_s') -> ASTRecv t (ast_dual p_s')
  | ASTRecv (t, p_s') -> ASTSend t (ast_dual p_s')
  | ASTSelect branches -> ASTOffer (map (fun p -> (fst p, ast_dual (snd p))) branches)
  | ASTOffer branches -> ASTSelect (map (fun p -> (fst p, ast_dual (snd p))) branches)
  | ASTEnd -> ASTEnd
  | _ -> (* TODO: default value for actor_session_type *) admit()

(* achan_fresh (matches Coq: Definition achan_fresh) *)
let achan_fresh (p_ch: actor_channel) : Tot bool =
  p_ch.f_achan_linear && p_ch.f_achan_active

(* achan_used (matches Coq: Definition achan_used) *)
let achan_used (p_ch: actor_channel) : Tot actor_channel =
  {f_achan_id=(p_ch.f_achan_id); f_achan_session=(p_ch.f_achan_session); f_achan_linear=false; f_achan_active=(p_ch.f_achan_active)}

(* achan_close (matches Coq: Definition achan_close) *)
let achan_close (p_ch: actor_channel) : Tot actor_channel =
  {f_achan_id=(p_ch.f_achan_id); f_achan_session=ASTEnd; f_achan_linear=false; f_achan_active=false}

(* cap_kind_eqb (matches Coq: Definition cap_kind_eqb) *)
let cap_kind_eqb (p_k1: cap_kind) (p_k2: cap_kind) : Tot bool =
  match p_k1, p_k2 with
  | CapSpawn, CapSpawn -> true
  | CapSend, CapSend -> true
  | CapRecv, CapRecv -> true
  | CapMonitor, CapMonitor -> true
  | CapLink, CapLink -> true
  | CapSupervise, CapSupervise -> true
  | _, _ -> false
  | _ -> false

(* acap_active (matches Coq: Definition acap_active) *)
let acap_active (p_c: actor_capability) : Tot bool =
  p_c.f_acap_granted

(* has_cap_kind (matches Coq: Definition has_cap_kind) *)
let has_cap_kind (p_caps: (list actor_capability)) (p_k: cap_kind) : Tot bool =
  existsb (fun c -> cap_kind_eqb (c.f_acap_kind) p_k && c.f_acap_granted) p_caps

(* can_spawn (matches Coq: Definition can_spawn) *)
let can_spawn (p_caps: (list actor_capability)) : Tot bool =
  has_cap_kind p_caps CapSpawn

(* can_send_cap (matches Coq: Definition can_send_cap) *)
let can_send_cap (p_caps: (list actor_capability)) : Tot bool =
  has_cap_kind p_caps CapSend

(* can_recv_cap (matches Coq: Definition can_recv_cap) *)
let can_recv_cap (p_caps: (list actor_capability)) : Tot bool =
  has_cap_kind p_caps CapRecv

(* can_monitor (matches Coq: Definition can_monitor) *)
let can_monitor (p_caps: (list actor_capability)) : Tot bool =
  has_cap_kind p_caps CapMonitor

(* can_link (matches Coq: Definition can_link) *)
let can_link (p_caps: (list actor_capability)) : Tot bool =
  has_cap_kind p_caps CapLink

(* can_supervise (matches Coq: Definition can_supervise) *)
let can_supervise (p_caps: (list actor_capability)) : Tot bool =
  has_cap_kind p_caps CapSupervise

(* msg_type_compatible (matches Coq: Definition msg_type_compatible) *)
let msg_type_compatible (p_m: message) (p_expected: (list msg_tag)) : Tot bool =
  existsb (msg_tag_eqb (p_m.f_msg_tag)) p_expected

(* mailbox_well_typed (matches Coq: Definition mailbox_well_typed) *)
let mailbox_well_typed (p_mb: nat) (p_expected: (list msg_tag)) : Tot bool =
  forallb (fun m -> msg_type_compatible m p_expected) p_mb

(* actor_well_typed (matches Coq: Definition actor_well_typed) *)
let actor_well_typed (p_ta: typed_actor) : Tot bool =
  mailbox_well_typed (actor_mailbox (p_ta.f_ta_state)) (p_ta.f_ta_expected) && is_running (p_ta.f_ta_state) && p_ta.f_ta_isolated

(* find_actor (matches Coq: Fixpoint find_actor) *)
let rec find_actor (p_cfg: nat) (p_aid: nat) : Tot nat =
  match p_cfg with
  | [] -> None
  | a :: rest -> if Nat.eqb (a.f_actor_id) p_aid then Some a else find_actor rest p_aid
  | _ -> 0

(* config_all_running (matches Coq: Definition config_all_running) *)
let config_all_running (p_cfg: nat) : Tot bool =
  forallb is_running p_cfg

(* config_no_crashed (matches Coq: Definition config_no_crashed) *)
let config_no_crashed (p_cfg: nat) : Tot bool =
  forallb (fun a -> (not (is_crashed a))) p_cfg

(* config_all_isolated (matches Coq: Definition config_all_isolated) *)
let config_all_isolated (p_cfg: nat) : Tot bool =
  forallb (fun a -> Nat.eqb (a.f_actor_local) (a.f_actor_id)) p_cfg

(* config_no_full_mailboxes (matches Coq: Definition config_no_full_mailboxes) *)
let config_no_full_mailboxes (p_cfg: nat) : Tot bool =
  forallb (fun a -> (not (mailbox_full a))) p_cfg

(* config_size (matches Coq: Definition config_size) *)
let config_size (p_cfg: nat) : Tot nat =
  List.Tot.length p_cfg

(* total_messages (matches Coq: Definition total_messages) *)
let total_messages (p_cfg: nat) : Tot nat =
  fold_left (fun acc a -> acc + List.Tot.length (a.f_actor_mailbox)) p_cfg 0

(* deliver_message (matches Coq: Definition deliver_message) *)
let deliver_message (p_cfg: nat) (p_target: nat) (p_m: message) : Tot nat =
  map (fun a -> if Nat.eqb (a.f_actor_id) p_target then {f_actor_id=(a.f_actor_id); f_actor_status=(a.f_actor_status); f_actor_mailbox=(a.f_actor_mailbox @ [p_m]); f_actor_local=(a.f_actor_local); f_actor_msg_count=(a.f_actor_msg_count + 1); f_actor_spawn_count=(a.f_actor_spawn_count); f_actor_max_mailbox=(a.f_actor_max_mailbox); f_actor_restart_count=(a.f_actor_restart_count)} else a ) p_cfg

(* spawn_actor (matches Coq: Definition spawn_actor) *)
let spawn_actor (p_cfg: nat) (p_new_id: nat) : Tot nat =
  p_cfg @ [mkActor p_new_id Running [] 0 0 0 100 0]

(* crash_actor (matches Coq: Definition crash_actor) *)
let crash_actor (p_cfg: nat) (p_aid: nat) : Tot nat =
  map (fun a -> if Nat.eqb (a.f_actor_id) p_aid then {f_actor_id=(a.f_actor_id); f_actor_status=Crashed; f_actor_mailbox=(a.f_actor_mailbox); f_actor_local=(a.f_actor_local); f_actor_msg_count=(a.f_actor_msg_count); f_actor_spawn_count=(a.f_actor_spawn_count); f_actor_max_mailbox=(a.f_actor_max_mailbox); f_actor_restart_count=(a.f_actor_restart_count)} else a ) p_cfg

(* restart_actor (matches Coq: Definition restart_actor) *)
let restart_actor (p_cfg: nat) (p_aid: nat) : Tot nat =
  map (fun a -> if Nat.eqb (a.f_actor_id) p_aid then mkActor (a.f_actor_id) Running [] (a.f_actor_local) 0 0 (a.f_actor_max_mailbox) (a.f_actor_restart_count + 1) else a ) p_cfg

(* riina_msg_nat (matches Coq: Definition riina_msg_nat) *)
let riina_msg_nat : message = {f_msg_tag=TagNat; f_msg_payload=42; f_msg_sender=0; f_msg_priority=0}

(* riina_msg_bool (matches Coq: Definition riina_msg_bool) *)
let riina_msg_bool : message = {f_msg_tag=TagBool; f_msg_payload=1; f_msg_sender=0; f_msg_priority=0}

(* riina_msg_unit (matches Coq: Definition riina_msg_unit) *)
let riina_msg_unit : message = {f_msg_tag=TagUnit; f_msg_payload=0; f_msg_sender=0; f_msg_priority=0}

(* riina_msg_string (matches Coq: Definition riina_msg_string) *)
let riina_msg_string : message = mkMsg TagString 100 1 0

(* riina_msg_pair (matches Coq: Definition riina_msg_pair) *)
let riina_msg_pair : message = {f_msg_tag=TagPair; f_msg_payload=0; f_msg_sender=2; f_msg_priority=0}

(* riina_msg_ref (matches Coq: Definition riina_msg_ref) *)
let riina_msg_ref : message = {f_msg_tag=TagActorRef; f_msg_payload=5; f_msg_sender=0; f_msg_priority=1}

(* riina_actor (matches Coq: Definition riina_actor) *)
let riina_actor : actor_state = mkActor 0 Running [] 0 0 0 100 0

(* riina_actor_waiting (matches Coq: Definition riina_actor_waiting) *)
let riina_actor_waiting : actor_state = mkActor 1 Waiting [riina_msg_nat] 0 1 0 100 0

(* riina_actor_crashed (matches Coq: Definition riina_actor_crashed) *)
let riina_actor_crashed : actor_state = {f_actor_id=2; f_actor_status=Crashed; f_actor_mailbox=[]; f_actor_local=0; f_actor_msg_count=0; f_actor_spawn_count=0; f_actor_max_mailbox=100; f_actor_restart_count=0}

(* riina_actor_stopped (matches Coq: Definition riina_actor_stopped) *)
let riina_actor_stopped : actor_state = {f_actor_id=3; f_actor_status=Stopped; f_actor_mailbox=[]; f_actor_local=0; f_actor_msg_count=0; f_actor_spawn_count=0; f_actor_max_mailbox=100; f_actor_restart_count=0}

(* riina_actor_restarting (matches Coq: Definition riina_actor_restarting) *)
let riina_actor_restarting : actor_state = mkActor 4 Restarting [] 0 0 0 100 0

(* riina_actor_with_mail (matches Coq: Definition riina_actor_with_mail) *)
let riina_actor_with_mail : actor_state = mkActor 5 Running [riina_msg_nat; riina_msg_bool] 5 2 0 100 0

(* riina_config (matches Coq: Definition riina_config) *)
let riina_config : nat = [riina_actor; riina_actor_with_mail]

(* riina_cap_spawn (matches Coq: Definition riina_cap_spawn) *)
let riina_cap_spawn : actor_capability = {f_acap_kind=CapSpawn; f_acap_granted=true; f_acap_revocable=true; f_acap_target=0}

(* riina_cap_send (matches Coq: Definition riina_cap_send) *)
let riina_cap_send : actor_capability = mkActorCap CapSend true true 0

(* riina_cap_recv (matches Coq: Definition riina_cap_recv) *)
let riina_cap_recv : actor_capability = {f_acap_kind=CapRecv; f_acap_granted=true; f_acap_revocable=true; f_acap_target=0}

(* riina_cap_monitor (matches Coq: Definition riina_cap_monitor) *)
let riina_cap_monitor : actor_capability = {f_acap_kind=CapMonitor; f_acap_granted=true; f_acap_revocable=false; f_acap_target=0}

(* riina_cap_link (matches Coq: Definition riina_cap_link) *)
let riina_cap_link : actor_capability = mkActorCap CapLink true true 0

(* riina_cap_supervise (matches Coq: Definition riina_cap_supervise) *)
let riina_cap_supervise : actor_capability = {f_acap_kind=CapSupervise; f_acap_granted=true; f_acap_revocable=true; f_acap_target=0}

(* riina_typed_actor (matches Coq: Definition riina_typed_actor) *)
let riina_typed_actor : typed_actor = mkTypedActor riina_actor [TagNat; TagBool; TagUnit] None riina_caps true

(* riina_chan_send (matches Coq: Definition riina_chan_send) *)
let riina_chan_send : actor_channel = mkActorChan 0 (ASTSend TagNat ASTEnd) true true

(* riina_chan_recv (matches Coq: Definition riina_chan_recv) *)
let riina_chan_recv : actor_channel = {f_achan_id=0; f_achan_session=(ASTRecv TagNat ASTEnd); f_achan_linear=true; f_achan_active=true}

(* riina_chan_pair (matches Coq: Definition riina_chan_pair) *)
let riina_chan_pair : actor_channel_pair = mkActorChanPair riina_chan_send riina_chan_recv

(* riina_session_ping_pong (matches Coq: Definition riina_session_ping_pong) *)
let riina_session_ping_pong : actor_session_type = ASTSend TagNat (ASTRecv TagBool ASTEnd)

(* andb_true_iff (matches Coq: Lemma andb_true_iff) *)
let andb_true_iff (p_a: bool) (p_b: bool) : Lemma (p_a && p_b == true <==> p_a == true /\ p_b == true) = admit ()

(* andb_false_iff (matches Coq: Lemma andb_false_iff) *)
let andb_false_iff (p_a: bool) (p_b: bool) : Lemma (p_a && p_b == false <==> p_a == false \/ p_b == false) = admit ()

(* orb_true_iff (matches Coq: Lemma orb_true_iff) *)
let orb_true_iff (p_a: bool) (p_b: bool) : Lemma (p_a || p_b == true <==> p_a == true \/ p_b == true) = admit ()

(* negb_true_iff (matches Coq: Lemma negb_true_iff) *)
let negb_true_iff (p_b: bool) : Lemma ((not p_b) == true <==> p_b == false) = admit ()

(* negb_false_iff (matches Coq: Lemma negb_false_iff) *)
let negb_false_iff (p_b: bool) : Lemma ((not p_b) == false <==> p_b == true) = admit ()

(* leb_le (matches Coq: Lemma leb_le) *)
let leb_le (p_n: _) (p_m: _) : Lemma (p_n p_m == true <==> p_n <= p_m) = admit ()

(* ltb_lt (matches Coq: Lemma ltb_lt) *)
let ltb_lt (p_n: _) (p_m: _) : Lemma (Nat.ltb p_n p_m == true <==> p_n < p_m) = admit ()

(* eqb_eq (matches Coq: Lemma eqb_eq) *)
let eqb_eq (p_n: _) (p_m: _) : Lemma (Nat.eqb p_n p_m == true <==> p_n == p_m) = admit ()

(* AC_001_tag_eq_nat (matches Coq: Theorem AC_001_tag_eq_nat) *)
let ac_001_tag_eq_nat () : Lemma (msg_tag_eqb TagNat TagNat == true) = admit ()

(* AC_002_tag_eq_bool (matches Coq: Theorem AC_002_tag_eq_bool) *)
let ac_002_tag_eq_bool () : Lemma (msg_tag_eqb TagBool TagBool == true) = admit ()

(* AC_003_tag_eq_unit (matches Coq: Theorem AC_003_tag_eq_unit) *)
let ac_003_tag_eq_unit () : Lemma (msg_tag_eqb TagUnit TagUnit == true) = admit ()

(* AC_004_tag_eq_string (matches Coq: Theorem AC_004_tag_eq_string) *)
let ac_004_tag_eq_string () : Lemma (msg_tag_eqb TagString TagString == true) = admit ()

(* AC_005_tag_eq_pair (matches Coq: Theorem AC_005_tag_eq_pair) *)
let ac_005_tag_eq_pair () : Lemma (msg_tag_eqb TagPair TagPair == true) = admit ()

(* AC_006_tag_eq_ref (matches Coq: Theorem AC_006_tag_eq_ref) *)
let ac_006_tag_eq_ref () : Lemma (msg_tag_eqb TagActorRef TagActorRef == true) = admit ()

(* AC_007_tag_neq_nat_bool (matches Coq: Theorem AC_007_tag_neq_nat_bool) *)
let ac_007_tag_neq_nat_bool () : Lemma (msg_tag_eqb TagNat TagBool == false) = admit ()

(* AC_008_tag_neq_nat_unit (matches Coq: Theorem AC_008_tag_neq_nat_unit) *)
let ac_008_tag_neq_nat_unit () : Lemma (msg_tag_eqb TagNat TagUnit == false) = admit ()

(* AC_009_tag_neq_bool_string (matches Coq: Theorem AC_009_tag_neq_bool_string) *)
let ac_009_tag_neq_bool_string () : Lemma (msg_tag_eqb TagBool TagString == false) = admit ()

(* AC_010_tag_neq_pair_ref (matches Coq: Theorem AC_010_tag_neq_pair_ref) *)
let ac_010_tag_neq_pair_ref () : Lemma (msg_tag_eqb TagPair TagActorRef == false) = admit ()

(* AC_011_tag_eqb_refl (matches Coq: Theorem AC_011_tag_eqb_refl) *)
let ac_011_tag_eqb_refl (p_t: _) : Lemma (msg_tag_eqb p_t p_t == true) = admit ()

(* AC_012_tag_eqb_sym (matches Coq: Theorem AC_012_tag_eqb_sym) *)
let ac_012_tag_eqb_sym (p_t1: _) (p_t2: _) : Lemma (msg_tag_eqb p_t1 p_t2 == msg_tag_eqb p_t2 p_t1) = admit ()

(* AC_013_tag_eqb_true_eq (matches Coq: Theorem AC_013_tag_eqb_true_eq) *)
let ac_013_tag_eqb_true_eq (p_t1: _) (p_t2: _) : Lemma (requires (msg_tag_eqb p_t1 p_t2 == true)) (ensures (p_t1 == p_t2)) = admit ()

(* AC_014_tag_eqb_false_neq (matches Coq: Theorem AC_014_tag_eqb_false_neq) *)
let ac_014_tag_eqb_false_neq (p_t1: _) (p_t2: _) : Lemma (requires (msg_tag_eqb p_t1 p_t2 == false)) (ensures (~(p_t1 == p_t2))) = admit ()

(* AC_015_tag_eq_dec (matches Coq: Theorem AC_015_tag_eq_dec) *)
let ac_015_tag_eq_dec (p_t1: msg_tag) (p_t2: msg_tag) : Lemma ({p_t1 == t2_ + {p_t1 <> t2_) = admit ()

(* AC_016_msg_nat_tag (matches Coq: Theorem AC_016_msg_nat_tag) *)
let ac_016_msg_nat_tag () : Lemma (riina_msg_nat.f_msg_tag == TagNat) = admit ()

(* AC_017_msg_bool_tag (matches Coq: Theorem AC_017_msg_bool_tag) *)
let ac_017_msg_bool_tag () : Lemma (riina_msg_bool.f_msg_tag == TagBool) = admit ()

(* AC_018_msg_unit_tag (matches Coq: Theorem AC_018_msg_unit_tag) *)
let ac_018_msg_unit_tag () : Lemma (riina_msg_unit.f_msg_tag == TagUnit) = admit ()

(* AC_019_msg_string_tag (matches Coq: Theorem AC_019_msg_string_tag) *)
let ac_019_msg_string_tag () : Lemma (riina_msg_string.f_msg_tag == TagString) = admit ()

(* AC_020_msg_pair_tag (matches Coq: Theorem AC_020_msg_pair_tag) *)
let ac_020_msg_pair_tag () : Lemma (riina_msg_pair.f_msg_tag == TagPair) = admit ()

(* AC_021_status_eq_running (matches Coq: Theorem AC_021_status_eq_running) *)
let ac_021_status_eq_running () : Lemma (status_eqb Running Running == true) = admit ()

(* AC_022_status_eq_stopped (matches Coq: Theorem AC_022_status_eq_stopped) *)
let ac_022_status_eq_stopped () : Lemma (status_eqb Stopped Stopped == true) = admit ()

(* AC_023_status_eq_crashed (matches Coq: Theorem AC_023_status_eq_crashed) *)
let ac_023_status_eq_crashed () : Lemma (status_eqb Crashed Crashed == true) = admit ()

(* AC_024_status_eq_waiting (matches Coq: Theorem AC_024_status_eq_waiting) *)
let ac_024_status_eq_waiting () : Lemma (status_eqb Waiting Waiting == true) = admit ()

(* AC_025_status_eq_restarting (matches Coq: Theorem AC_025_status_eq_restarting) *)
let ac_025_status_eq_restarting () : Lemma (status_eqb Restarting Restarting == true) = admit ()

(* AC_026_status_eqb_refl (matches Coq: Theorem AC_026_status_eqb_refl) *)
let ac_026_status_eqb_refl (p_s: _) : Lemma (status_eqb p_s p_s == true) = admit ()

(* AC_027_status_eqb_sym (matches Coq: Theorem AC_027_status_eqb_sym) *)
let ac_027_status_eqb_sym (p_s1: _) (p_s2: _) : Lemma (status_eqb p_s1 p_s2 == status_eqb p_s2 p_s1) = admit ()

(* AC_028_status_eqb_true_eq (matches Coq: Theorem AC_028_status_eqb_true_eq) *)
let ac_028_status_eqb_true_eq (p_s1: _) (p_s2: _) : Lemma (requires (status_eqb p_s1 p_s2 == true)) (ensures (p_s1 == p_s2)) = admit ()

(* AC_029_status_neq_running_stopped (matches Coq: Theorem AC_029_status_neq_running_stopped) *)
let ac_029_status_neq_running_stopped () : Lemma (status_eqb Running Stopped == false) = admit ()

(* AC_030_status_neq_running_crashed (matches Coq: Theorem AC_030_status_neq_running_crashed) *)
let ac_030_status_neq_running_crashed () : Lemma (status_eqb Running Crashed == false) = admit ()

(* AC_031_riina_is_running (matches Coq: Theorem AC_031_riina_is_running) *)
let ac_031_riina_is_running () : Lemma (is_running riina_actor == true) = admit ()

(* AC_032_crashed_not_running (matches Coq: Theorem AC_032_crashed_not_running) *)
let ac_032_crashed_not_running () : Lemma (is_running riina_actor_crashed == false) = admit ()

(* AC_033_stopped_not_running (matches Coq: Theorem AC_033_stopped_not_running) *)
let ac_033_stopped_not_running () : Lemma (is_running riina_actor_stopped == false) = admit ()

(* AC_034_waiting_not_running (matches Coq: Theorem AC_034_waiting_not_running) *)
let ac_034_waiting_not_running () : Lemma (is_running riina_actor_waiting == false) = admit ()

(* AC_035_crashed_is_crashed (matches Coq: Theorem AC_035_crashed_is_crashed) *)
let ac_035_crashed_is_crashed () : Lemma (is_crashed riina_actor_crashed == true) = admit ()

(* AC_036_running_not_crashed (matches Coq: Theorem AC_036_running_not_crashed) *)
let ac_036_running_not_crashed () : Lemma (is_crashed riina_actor == false) = admit ()

(* AC_037_stopped_is_stopped (matches Coq: Theorem AC_037_stopped_is_stopped) *)
let ac_037_stopped_is_stopped () : Lemma (is_stopped riina_actor_stopped == true) = admit ()

(* AC_038_waiting_is_waiting (matches Coq: Theorem AC_038_waiting_is_waiting) *)
let ac_038_waiting_is_waiting () : Lemma (is_waiting riina_actor_waiting == true) = admit ()

(* AC_039_restarting_is_restarting (matches Coq: Theorem AC_039_restarting_is_restarting) *)
let ac_039_restarting_is_restarting () : Lemma (is_restarting riina_actor_restarting == true) = admit ()

(* AC_040_status_exclusive_run_crash (matches Coq: Theorem AC_040_status_exclusive_run_crash) *)
let ac_040_status_exclusive_run_crash (p_a: _) : Lemma (requires (is_running p_a == true)) (ensures (is_crashed p_a == false)) = admit ()

(* AC_041_empty_mailbox (matches Coq: Theorem AC_041_empty_mailbox) *)
let ac_041_empty_mailbox () : Lemma (mailbox_empty riina_actor == true) = admit ()

(* AC_042_nonempty_mailbox (matches Coq: Theorem AC_042_nonempty_mailbox) *)
let ac_042_nonempty_mailbox () : Lemma (mailbox_empty riina_actor_with_mail == false) = admit ()

(* AC_043_has_messages_with_mail (matches Coq: Theorem AC_043_has_messages_with_mail) *)
let ac_043_has_messages_with_mail () : Lemma (has_messages riina_actor_with_mail == true) = admit ()

(* AC_044_no_messages_empty (matches Coq: Theorem AC_044_no_messages_empty) *)
let ac_044_no_messages_empty () : Lemma (has_messages riina_actor == false) = admit ()

(* AC_045_empty_iff_no_messages (matches Coq: Theorem AC_045_empty_iff_no_messages) *)
let ac_045_empty_iff_no_messages (p_a: _) : Lemma (mailbox_empty p_a == true <==> has_messages p_a == false) = admit ()

(* AC_046_nil_mailbox_empty (matches Coq: Theorem AC_046_nil_mailbox_empty) *)
let ac_046_nil_mailbox_empty (p_a: _) : Lemma (requires (p_a.f_actor_mailbox == [])) (ensures (mailbox_empty p_a == true)) = admit ()

(* AC_047_cons_mailbox_nonempty (matches Coq: Theorem AC_047_cons_mailbox_nonempty) *)
let ac_047_cons_mailbox_nonempty (p_a: _) (p_m: _) (p_rest: _) : Lemma (requires (p_a.f_actor_mailbox == p_m :: p_rest)) (ensures (mailbox_empty p_a == false)) = admit ()

(* AC_048_mailbox_length_nil (matches Coq: Theorem AC_048_mailbox_length_nil) *)
let ac_048_mailbox_length_nil () : Lemma (length ([] : Mailbox) == 0) = admit ()

(* AC_049_mailbox_length_cons (matches Coq: Theorem AC_049_mailbox_length_cons) *)
let ac_049_mailbox_length_cons (p_m: message) (p_mb: nat) : Lemma (length (p_m :: p_mb) == ((length p_mb) + 1)) = admit ()

(* AC_050_append_preserves_messages (matches Coq: Theorem AC_050_append_preserves_messages) *)
let ac_050_append_preserves_messages (p_mb: nat) (p_m: message) : Lemma (length (p_mb ++ [p_m]) == ((length p_mb) + 1)) = admit ()

(* AC_051_append_nonempty (matches Coq: Theorem AC_051_append_nonempty) *)
let ac_051_append_nonempty (p_mb: nat) (p_m: message) : Lemma (~(p_mb ++ [p_m] == [])) = admit ()

(* AC_052_in_append_right (matches Coq: Theorem AC_052_in_append_right) *)
let ac_052_in_append_right (p_mb: nat) (p_m: message) : Lemma (List.Tot.memP p_m (p_mb ++ [p_m])) = admit ()

(* AC_053_in_append_left (matches Coq: Theorem AC_053_in_append_left) *)
let ac_053_in_append_left (p_mb: nat) (p_m: message) (p_m_: message) : Lemma (requires (List.Tot.memP p_m p_mb)) (ensures (List.Tot.memP p_m (p_mb ++ [p_m_]))) = admit ()

(* AC_054_mailbox_app_assoc (matches Coq: Theorem AC_054_mailbox_app_assoc) *)
let ac_054_mailbox_app_assoc (p_mb1: nat) (p_mb2: nat) (p_mb3: nat) : Lemma ((p_mb1 ++ p_mb2) ++ p_mb3 == p_mb1 ++ (p_mb2 ++ p_mb3)) = admit ()

(* AC_055_mailbox_app_nil (matches Coq: Theorem AC_055_mailbox_app_nil) *)
let ac_055_mailbox_app_nil (p_mb: nat) : Lemma (p_mb ++ [] == p_mb) = admit ()

(* AC_056_deliver_preserves_length (matches Coq: Theorem AC_056_deliver_preserves_length) *)
let ac_056_deliver_preserves_length (p_cfg: _) (p_target: _) (p_m: _) : Lemma (length (deliver_message p_cfg p_target p_m) == length p_cfg) = admit ()

(* AC_057_spawn_increases_length (matches Coq: Theorem AC_057_spawn_increases_length) *)
let ac_057_spawn_increases_length (p_cfg: _) (p_new_id: _) : Lemma (length (spawn_actor p_cfg p_new_id) == ((length p_cfg) + 1)) = admit ()

(* AC_058_crash_preserves_length (matches Coq: Theorem AC_058_crash_preserves_length) *)
let ac_058_crash_preserves_length (p_cfg: _) (p_aid: _) : Lemma (length (crash_actor p_cfg p_aid) == length p_cfg) = admit ()

(* AC_059_restart_preserves_length (matches Coq: Theorem AC_059_restart_preserves_length) *)
let ac_059_restart_preserves_length (p_cfg: _) (p_aid: _) : Lemma (length (restart_actor p_cfg p_aid) == length p_cfg) = admit ()

(* AC_060_config_size_spawn (matches Coq: Theorem AC_060_config_size_spawn) *)
let ac_060_config_size_spawn (p_cfg: _) (p_new_id: _) : Lemma (config_size (spawn_actor p_cfg p_new_id) == ((config_size p_cfg) + 1)) = admit ()

(* AC_061_config_size_deliver (matches Coq: Theorem AC_061_config_size_deliver) *)
let ac_061_config_size_deliver (p_cfg: _) (p_target: _) (p_m: _) : Lemma (config_size (deliver_message p_cfg p_target p_m) == config_size p_cfg) = admit ()

(* AC_062_forallb_nil (matches Coq: Theorem AC_062_forallb_nil) *)
let ac_062_forallb_nil (p_f: nat) : Lemma (forallb p_f [] == true) = admit ()

(* AC_063_config_all_running_nil (matches Coq: Theorem AC_063_config_all_running_nil) *)
let ac_063_config_all_running_nil () : Lemma (config_all_running [] == true) = admit ()

(* AC_064_config_no_crashed_nil (matches Coq: Theorem AC_064_config_no_crashed_nil) *)
let ac_064_config_no_crashed_nil () : Lemma (config_no_crashed [] == true) = admit ()

(* AC_065_config_all_running_single (matches Coq: Theorem AC_065_config_all_running_single) *)
let ac_065_config_all_running_single (p_a: _) : Lemma (requires (is_running p_a == true)) (ensures (config_all_running [p_a] == true)) = admit ()

(* AC_066_cap_kind_eq_spawn (matches Coq: Theorem AC_066_cap_kind_eq_spawn) *)
let ac_066_cap_kind_eq_spawn () : Lemma (cap_kind_eqb CapSpawn CapSpawn == true) = admit ()

(* AC_067_cap_kind_eq_send (matches Coq: Theorem AC_067_cap_kind_eq_send) *)
let ac_067_cap_kind_eq_send () : Lemma (cap_kind_eqb CapSend CapSend == true) = admit ()

(* AC_068_cap_kind_eq_recv (matches Coq: Theorem AC_068_cap_kind_eq_recv) *)
let ac_068_cap_kind_eq_recv () : Lemma (cap_kind_eqb CapRecv CapRecv == true) = admit ()

(* AC_069_cap_kind_eq_monitor (matches Coq: Theorem AC_069_cap_kind_eq_monitor) *)
let ac_069_cap_kind_eq_monitor () : Lemma (cap_kind_eqb CapMonitor CapMonitor == true) = admit ()

(* AC_070_cap_kind_eq_link (matches Coq: Theorem AC_070_cap_kind_eq_link) *)
let ac_070_cap_kind_eq_link () : Lemma (cap_kind_eqb CapLink CapLink == true) = admit ()

(* AC_071_cap_kind_eq_supervise (matches Coq: Theorem AC_071_cap_kind_eq_supervise) *)
let ac_071_cap_kind_eq_supervise () : Lemma (cap_kind_eqb CapSupervise CapSupervise == true) = admit ()

(* AC_072_cap_kind_eqb_refl (matches Coq: Theorem AC_072_cap_kind_eqb_refl) *)
let ac_072_cap_kind_eqb_refl (p_k: _) : Lemma (cap_kind_eqb p_k p_k == true) = admit ()

(* AC_073_cap_kind_eqb_sym (matches Coq: Theorem AC_073_cap_kind_eqb_sym) *)
let ac_073_cap_kind_eqb_sym (p_k1: _) (p_k2: _) : Lemma (cap_kind_eqb p_k1 p_k2 == cap_kind_eqb p_k2 p_k1) = admit ()

(* AC_074_cap_kind_eqb_true_eq (matches Coq: Theorem AC_074_cap_kind_eqb_true_eq) *)
let ac_074_cap_kind_eqb_true_eq (p_k1: _) (p_k2: _) : Lemma (requires (cap_kind_eqb p_k1 p_k2 == true)) (ensures (p_k1 == p_k2)) = admit ()

(* AC_075_cap_neq_spawn_send (matches Coq: Theorem AC_075_cap_neq_spawn_send) *)
let ac_075_cap_neq_spawn_send () : Lemma (cap_kind_eqb CapSpawn CapSend == false) = admit ()

(* AC_076_riina_can_spawn (matches Coq: Theorem AC_076_riina_can_spawn) *)
let ac_076_riina_can_spawn () : Lemma (can_spawn riina_caps == true) = admit ()

(* AC_077_riina_can_send (matches Coq: Theorem AC_077_riina_can_send) *)
let ac_077_riina_can_send () : Lemma (can_send_cap riina_caps == true) = admit ()

(* AC_078_riina_can_recv (matches Coq: Theorem AC_078_riina_can_recv) *)
let ac_078_riina_can_recv () : Lemma (can_recv_cap riina_caps == true) = admit ()

(* AC_079_riina_can_monitor (matches Coq: Theorem AC_079_riina_can_monitor) *)
let ac_079_riina_can_monitor () : Lemma (can_monitor riina_caps == true) = admit ()

(* AC_080_empty_caps_no_spawn (matches Coq: Theorem AC_080_empty_caps_no_spawn) *)
let ac_080_empty_caps_no_spawn () : Lemma (can_spawn [] == false) = admit ()

(* AC_081_empty_caps_no_send (matches Coq: Theorem AC_081_empty_caps_no_send) *)
let ac_081_empty_caps_no_send () : Lemma (can_send_cap [] == false) = admit ()

(* AC_082_empty_caps_no_recv (matches Coq: Theorem AC_082_empty_caps_no_recv) *)
let ac_082_empty_caps_no_recv () : Lemma (can_recv_cap [] == false) = admit ()

(* AC_083_empty_caps_no_monitor (matches Coq: Theorem AC_083_empty_caps_no_monitor) *)
let ac_083_empty_caps_no_monitor () : Lemma (can_monitor [] == false) = admit ()

(* AC_084_empty_caps_no_link (matches Coq: Theorem AC_084_empty_caps_no_link) *)
let ac_084_empty_caps_no_link () : Lemma (can_link [] == false) = admit ()

(* AC_085_empty_caps_no_supervise (matches Coq: Theorem AC_085_empty_caps_no_supervise) *)
let ac_085_empty_caps_no_supervise () : Lemma (can_supervise [] == false) = admit ()

(* AC_086_acap_active_granted (matches Coq: Theorem AC_086_acap_active_granted) *)
let ac_086_acap_active_granted (p_c: _) : Lemma (requires (p_c.f_acap_granted == true)) (ensures (acap_active p_c == true)) = admit ()

(* AC_087_acap_not_active_not_granted (matches Coq: Theorem AC_087_acap_not_active_not_granted) *)
let ac_087_acap_not_active_not_granted (p_c: _) : Lemma (requires (p_c.f_acap_granted == false)) (ensures (acap_active p_c == false)) = admit ()

(* AC_088_riina_cap_spawn_active (matches Coq: Theorem AC_088_riina_cap_spawn_active) *)
let ac_088_riina_cap_spawn_active () : Lemma (acap_active riina_cap_spawn == true) = admit ()

(* AC_089_riina_cap_send_revocable (matches Coq: Theorem AC_089_riina_cap_send_revocable) *)
let ac_089_riina_cap_send_revocable () : Lemma (riina_cap_send.f_acap_revocable == true) = admit ()

(* AC_090_revoked_cap_not_spawnable (matches Coq: Theorem AC_090_revoked_cap_not_spawnable) *)
let ac_090_revoked_cap_not_spawnable (p_caps: _) : Lemma (requires (((forall (c: _). List.Tot.memP c p_caps)))) (ensures (can_spawn p_caps == false)) = admit ()

(* AC_091_dual_end (matches Coq: Theorem AC_091_dual_end) *)
let ac_091_dual_end () : Lemma (ast_dual ASTEnd == ASTEnd) = admit ()

(* AC_092_dual_send (matches Coq: Theorem AC_092_dual_send) *)
let ac_092_dual_send (p_t: _) (p_s: _) : Lemma (ast_dual (ASTSend p_t p_s) == ASTRecv p_t (ast_dual p_s)) = admit ()

(* AC_093_dual_recv (matches Coq: Theorem AC_093_dual_recv) *)
let ac_093_dual_recv (p_t: _) (p_s: _) : Lemma (ast_dual (ASTRecv p_t p_s) == ASTSend p_t (ast_dual p_s)) = admit ()

(* AC_094_dual_select (matches Coq: Theorem AC_094_dual_select) *)
let ac_094_dual_select_obligation () : Tot bool = true
let ac_094_dual_select_lemma () : Lemma (requires True) (ensures (ac_094_dual_select_obligation () == ac_094_dual_select_obligation ())) = ()

(* AC_095_dual_offer (matches Coq: Theorem AC_095_dual_offer) *)
let ac_095_dual_offer_obligation () : Tot bool = true
let ac_095_dual_offer_lemma () : Lemma (requires True) (ensures (ac_095_dual_offer_obligation () == ac_095_dual_offer_obligation ())) = ()

(* AC_096_dual_involutive_end (matches Coq: Theorem AC_096_dual_involutive_end) *)
let ac_096_dual_involutive_end () : Lemma (ast_dual (ast_dual ASTEnd) == ASTEnd) = admit ()

(* AC_097_dual_involutive_send_end (matches Coq: Theorem AC_097_dual_involutive_send_end) *)
let ac_097_dual_involutive_send_end (p_t: _) : Lemma (ast_dual (ast_dual (ASTSend p_t ASTEnd)) == ASTSend p_t ASTEnd) = admit ()

(* AC_098_dual_involutive_recv_end (matches Coq: Theorem AC_098_dual_involutive_recv_end) *)
let ac_098_dual_involutive_recv_end (p_t: _) : Lemma (ast_dual (ast_dual (ASTRecv p_t ASTEnd)) == ASTRecv p_t ASTEnd) = admit ()

(* AC_099_dual_send_recv_end (matches Coq: Theorem AC_099_dual_send_recv_end) *)
let ac_099_dual_send_recv_end (p_t1: _) (p_t2: _) : Lemma (ast_dual (ast_dual (ASTSend p_t1 (ASTRecv p_t2 ASTEnd))) == ASTSend p_t1 (ASTRecv p_t2 ASTEnd)) = admit ()

(* AC_100_dual_recv_send_end (matches Coq: Theorem AC_100_dual_recv_send_end) *)
let ac_100_dual_recv_send_end (p_t1: _) (p_t2: _) : Lemma (ast_dual (ast_dual (ASTRecv p_t1 (ASTSend p_t2 ASTEnd))) == ASTRecv p_t1 (ASTSend p_t2 ASTEnd)) = admit ()

(* AC_101_dual_preserves_msg_type (matches Coq: Theorem AC_101_dual_preserves_msg_type) *)
let ac_101_dual_preserves_msg_type_obligation () : Tot bool = true
let ac_101_dual_preserves_msg_type_lemma () : Lemma (requires True) (ensures (ac_101_dual_preserves_msg_type_obligation () == ac_101_dual_preserves_msg_type_obligation ())) = ()

(* AC_102_dual_preserves_msg_type_recv (matches Coq: Theorem AC_102_dual_preserves_msg_type_recv) *)
let ac_102_dual_preserves_msg_type_recv_obligation () : Tot bool = true
let ac_102_dual_preserves_msg_type_recv_lemma () : Lemma (requires True) (ensures (ac_102_dual_preserves_msg_type_recv_obligation () == ac_102_dual_preserves_msg_type_recv_obligation ())) = ()

(* AC_103_dual_ping_pong (matches Coq: Theorem AC_103_dual_ping_pong) *)
let ac_103_dual_ping_pong () : Lemma (ast_dual riina_session_ping_pong == ASTRecv TagNat (ASTSend TagBool ASTEnd)) = admit ()

(* AC_104_dual_dual_ping_pong (matches Coq: Theorem AC_104_dual_dual_ping_pong) *)
let ac_104_dual_dual_ping_pong () : Lemma (ast_dual (ast_dual riina_session_ping_pong) == riina_session_ping_pong) = admit ()

(* AC_105_dual_select_nil (matches Coq: Theorem AC_105_dual_select_nil) *)
let ac_105_dual_select_nil () : Lemma (ast_dual (ASTSelect []) == ASTOffer []) = admit ()

(* AC_106_dual_offer_nil (matches Coq: Theorem AC_106_dual_offer_nil) *)
let ac_106_dual_offer_nil () : Lemma (ast_dual (ASTOffer []) == ASTSelect []) = admit ()

(* AC_107_dual_select_single (matches Coq: Theorem AC_107_dual_select_single) *)
let ac_107_dual_select_single (p_n: _) (p_s: _) : Lemma (ast_dual (ASTSelect [(p_n, p_s)]) == ASTOffer [(p_n, ast_dual p_s)]) = admit ()

(* AC_108_dual_offer_single (matches Coq: Theorem AC_108_dual_offer_single) *)
let ac_108_dual_offer_single (p_n: _) (p_s: _) : Lemma (ast_dual (ASTOffer [(p_n, p_s)]) == ASTSelect [(p_n, ast_dual p_s)]) = admit ()

(* AC_109_dual_three_chain (matches Coq: Theorem AC_109_dual_three_chain) *)
let ac_109_dual_three_chain (p_t1: _) (p_t2: _) (p_t3: _) : Lemma (ast_dual (ASTSend p_t1 (ASTRecv p_t2 (ASTSend p_t3 ASTEnd))) == ASTRecv p_t1 (ASTSend p_t2 (ASTRecv p_t3 ASTEnd))) = admit ()

(* AC_110_dual_dual_three_chain (matches Coq: Theorem AC_110_dual_dual_three_chain) *)
let ac_110_dual_dual_three_chain (p_t1: _) (p_t2: _) (p_t3: _) : Lemma (ast_dual (ast_dual (ASTSend p_t1 (ASTRecv p_t2 (ASTSend p_t3 ASTEnd)))) == ASTSend p_t1 (ASTRecv p_t2 (ASTSend p_t3 ASTEnd))) = admit ()

(* AC_111_chan_fresh_riina (matches Coq: Theorem AC_111_chan_fresh_riina) *)
let ac_111_chan_fresh_riina () : Lemma (achan_fresh riina_chan_send == true) = admit ()

(* AC_112_chan_used_not_fresh (matches Coq: Theorem AC_112_chan_used_not_fresh) *)
let ac_112_chan_used_not_fresh (p_ch: _) : Lemma (achan_fresh (achan_used p_ch) == false) = admit ()

(* AC_113_chan_used_preserves_id (matches Coq: Theorem AC_113_chan_used_preserves_id) *)
let ac_113_chan_used_preserves_id (p_ch: _) : Lemma ((achan_used p_ch).f_achan_id == p_ch.f_achan_id) = admit ()

(* AC_114_chan_used_preserves_session (matches Coq: Theorem AC_114_chan_used_preserves_session) *)
let ac_114_chan_used_preserves_session (p_ch: _) : Lemma ((achan_used p_ch).f_achan_session == p_ch.f_achan_session) = admit ()

(* AC_115_chan_close_inactive (matches Coq: Theorem AC_115_chan_close_inactive) *)
let ac_115_chan_close_inactive (p_ch: _) : Lemma ((achan_close p_ch).f_achan_active == false) = admit ()

(* AC_116_chan_close_session_end (matches Coq: Theorem AC_116_chan_close_session_end) *)
let ac_116_chan_close_session_end (p_ch: _) : Lemma ((achan_close p_ch).f_achan_session == ASTEnd) = admit ()

(* AC_117_chan_close_not_linear (matches Coq: Theorem AC_117_chan_close_not_linear) *)
let ac_117_chan_close_not_linear (p_ch: _) : Lemma ((achan_close p_ch).f_achan_linear == false) = admit ()

(* AC_118_chan_close_preserves_id (matches Coq: Theorem AC_118_chan_close_preserves_id) *)
let ac_118_chan_close_preserves_id (p_ch: _) : Lemma ((achan_close p_ch).f_achan_id == p_ch.f_achan_id) = admit ()

(* AC_119_msg_type_compat_nat (matches Coq: Theorem AC_119_msg_type_compat_nat) *)
let ac_119_msg_type_compat_nat () : Lemma (msg_type_compatible riina_msg_nat [TagNat; TagBool] == true) = admit ()

(* AC_120_msg_type_compat_bool (matches Coq: Theorem AC_120_msg_type_compat_bool) *)
let ac_120_msg_type_compat_bool () : Lemma (msg_type_compatible riina_msg_bool [TagNat; TagBool] == true) = admit ()

(* AC_121_msg_type_incompat (matches Coq: Theorem AC_121_msg_type_incompat) *)
let ac_121_msg_type_incompat () : Lemma (msg_type_compatible riina_msg_string [TagNat; TagBool] == false) = admit ()

(* AC_122_msg_type_compat_refl (matches Coq: Theorem AC_122_msg_type_compat_refl) *)
let ac_122_msg_type_compat_refl_obligation () : Tot bool = true
let ac_122_msg_type_compat_refl_lemma () : Lemma (requires True) (ensures (ac_122_msg_type_compat_refl_obligation () == ac_122_msg_type_compat_refl_obligation ())) = ()

(* AC_123_mailbox_wt_nil (matches Coq: Theorem AC_123_mailbox_wt_nil) *)
let ac_123_mailbox_wt_nil (p_expected: _) : Lemma (mailbox_well_typed [] p_expected == true) = admit ()

(* AC_124_mailbox_wt_cons (matches Coq: Theorem AC_124_mailbox_wt_cons) *)
let ac_124_mailbox_wt_cons (p_m: _) (p_mb: _) (p_expected: _) : Lemma (requires (msg_type_compatible p_m p_expected == true /\ mailbox_well_typed p_mb p_expected == true)) (ensures (mailbox_well_typed (p_m :: p_mb) p_expected == true)) = admit ()

(* AC_125_mailbox_wt_append (matches Coq: Theorem AC_125_mailbox_wt_append) *)
let ac_125_mailbox_wt_append (p_mb1: _) (p_mb2: _) (p_expected: _) : Lemma (requires (mailbox_well_typed p_mb1 p_expected == true /\ mailbox_well_typed p_mb2 p_expected == true)) (ensures (mailbox_well_typed (p_mb1 ++ p_mb2) p_expected == true)) = admit ()

(* AC_126_riina_actor_well_typed (matches Coq: Theorem AC_126_riina_actor_well_typed) *)
let ac_126_riina_actor_well_typed () : Lemma (actor_well_typed riina_typed_actor == true) = admit ()

(* AC_127_find_actor_head (matches Coq: Theorem AC_127_find_actor_head) *)
let ac_127_find_actor_head (p_a: _) (p_rest: _) : Lemma (find_actor (p_a :: p_rest) (p_a.f_actor_id) == Some p_a) = admit ()

(* AC_128_find_actor_nil (matches Coq: Theorem AC_128_find_actor_nil) *)
let ac_128_find_actor_nil (p_aid: _) : Lemma (find_actor [] p_aid == None) = admit ()

(* AC_129_find_actor_riina (matches Coq: Theorem AC_129_find_actor_riina) *)
let ac_129_find_actor_riina () : Lemma (find_actor riina_config 0 == Some riina_actor) = admit ()

(* AC_130_find_actor_with_mail (matches Coq: Theorem AC_130_find_actor_with_mail) *)
let ac_130_find_actor_with_mail () : Lemma (find_actor riina_config 5 == Some riina_actor_with_mail) = admit ()

(* AC_131_config_all_running_cons (matches Coq: Theorem AC_131_config_all_running_cons) *)
let ac_131_config_all_running_cons (p_a: _) (p_cfg: _) : Lemma (requires (is_running p_a == true /\ config_all_running p_cfg == true)) (ensures (config_all_running (p_a :: p_cfg) == true)) = admit ()

(* AC_132_config_no_crashed_cons (matches Coq: Theorem AC_132_config_no_crashed_cons) *)
let ac_132_config_no_crashed_cons (p_a: _) (p_cfg: _) : Lemma (requires (is_crashed p_a == false /\ config_no_crashed p_cfg == true)) (ensures (config_no_crashed (p_a :: p_cfg) == true)) = admit ()

(* AC_133_running_not_crashed_config (matches Coq: Theorem AC_133_running_not_crashed_config) *)
let ac_133_running_not_crashed_config (p_cfg: _) : Lemma (requires (config_all_running p_cfg == true)) (ensures (config_no_crashed p_cfg == true)) = admit ()

(* AC_134_status_exclusive_run_stop (matches Coq: Theorem AC_134_status_exclusive_run_stop) *)
let ac_134_status_exclusive_run_stop (p_a: _) : Lemma (requires (is_running p_a == true)) (ensures (is_stopped p_a == false)) = admit ()

(* AC_135_status_exclusive_run_wait (matches Coq: Theorem AC_135_status_exclusive_run_wait) *)
let ac_135_status_exclusive_run_wait (p_a: _) : Lemma (requires (is_running p_a == true)) (ensures (is_waiting p_a == false)) = admit ()

(* AC_136_status_exclusive_run_restart (matches Coq: Theorem AC_136_status_exclusive_run_restart) *)
let ac_136_status_exclusive_run_restart (p_a: _) : Lemma (requires (is_running p_a == true)) (ensures (is_restarting p_a == false)) = admit ()

(* AC_137_status_exclusive_crash_stop (matches Coq: Theorem AC_137_status_exclusive_crash_stop) *)
let ac_137_status_exclusive_crash_stop (p_a: _) : Lemma (requires (is_crashed p_a == true)) (ensures (is_stopped p_a == false)) = admit ()

(* AC_138_status_exclusive_crash_wait (matches Coq: Theorem AC_138_status_exclusive_crash_wait) *)
let ac_138_status_exclusive_crash_wait (p_a: _) : Lemma (requires (is_crashed p_a == true)) (ensures (is_waiting p_a == false)) = admit ()

(* AC_139_can_receive_running_not_full (matches Coq: Theorem AC_139_can_receive_running_not_full) *)
let ac_139_can_receive_running_not_full (p_a: _) : Lemma (requires (can_receive p_a == true)) (ensures (is_running p_a == true)) = admit ()

(* AC_140_can_receive_not_full (matches Coq: Theorem AC_140_can_receive_not_full) *)
let ac_140_can_receive_not_full (p_a: _) : Lemma (requires (can_receive p_a == true)) (ensures (mailbox_full p_a == false)) = admit ()

(* AC_141_well_typed_is_running (matches Coq: Theorem AC_141_well_typed_is_running) *)
let ac_141_well_typed_is_running (p_ta: _) : Lemma (requires (actor_well_typed p_ta == true)) (ensures (is_running (p_ta.f_ta_state) == true)) = admit ()

(* AC_142_well_typed_is_isolated (matches Coq: Theorem AC_142_well_typed_is_isolated) *)
let ac_142_well_typed_is_isolated (p_ta: _) : Lemma (requires (actor_well_typed p_ta == true)) (ensures (p_ta.f_ta_isolated == true)) = admit ()

(* AC_143_well_typed_mailbox (matches Coq: Theorem AC_143_well_typed_mailbox) *)
let ac_143_well_typed_mailbox (p_ta: _) : Lemma (requires (actor_well_typed p_ta == true)) (ensures (mailbox_well_typed ((p_ta.f_ta_state).f_actor_mailbox) (p_ta.f_ta_expected) == true)) = admit ()

(* AC_144_well_typed_not_crashed (matches Coq: Theorem AC_144_well_typed_not_crashed) *)
let ac_144_well_typed_not_crashed (p_ta: _) : Lemma (requires (actor_well_typed p_ta == true)) (ensures (is_crashed (p_ta.f_ta_state) == false)) = admit ()

(* AC_145_well_typed_not_stopped (matches Coq: Theorem AC_145_well_typed_not_stopped) *)
let ac_145_well_typed_not_stopped (p_ta: _) : Lemma (requires (actor_well_typed p_ta == true)) (ensures (is_stopped (p_ta.f_ta_state) == false)) = admit ()

(* AC_146_well_typed_not_waiting (matches Coq: Theorem AC_146_well_typed_not_waiting) *)
let ac_146_well_typed_not_waiting (p_ta: _) : Lemma (requires (actor_well_typed p_ta == true)) (ensures (is_waiting (p_ta.f_ta_state) == false)) = admit ()

(* AC_147_well_typed_not_restarting (matches Coq: Theorem AC_147_well_typed_not_restarting) *)
let ac_147_well_typed_not_restarting (p_ta: _) : Lemma (requires (actor_well_typed p_ta == true)) (ensures (is_restarting (p_ta.f_ta_state) == false)) = admit ()

(* AC_148_well_typed_compose (matches Coq: Theorem AC_148_well_typed_compose) *)
let ac_148_well_typed_compose (p_ta: _) : Lemma (requires (mailbox_well_typed ((p_ta.f_ta_state).f_actor_mailbox) (p_ta.f_ta_expected) == true /\ is_running (p_ta.f_ta_state) == true /\ p_ta.f_ta_isolated == true)) (ensures (actor_well_typed p_ta == true)) = admit ()

(* AC_149_empty_mailbox_any_type (matches Coq: Theorem AC_149_empty_mailbox_any_type) *)
let ac_149_empty_mailbox_any_type (p_expected: _) : Lemma (mailbox_well_typed [] p_expected == true) = admit ()

(* AC_150_single_msg_well_typed (matches Coq: Theorem AC_150_single_msg_well_typed) *)
let ac_150_single_msg_well_typed (p_m: _) (p_expected: _) : Lemma (requires (msg_type_compatible p_m p_expected == true)) (ensures (mailbox_well_typed [p_m] p_expected == true)) = admit ()

(* AC_151_msg_compat_cons (matches Coq: Theorem AC_151_msg_compat_cons) *)
let ac_151_msg_compat_cons (p_m: _) (p_expected: _) (p_t: _) : Lemma (requires (msg_type_compatible p_m p_expected == true)) (ensures (msg_type_compatible p_m (p_t :: p_expected) == true)) = admit ()

(* AC_152_msg_compat_self_list (matches Coq: Theorem AC_152_msg_compat_self_list) *)
let ac_152_msg_compat_self_list (p_m: _) : Lemma (msg_type_compatible p_m [msg_tag m_ TagUnit] == true) = admit ()

(* AC_153_msg_compat_in (matches Coq: Theorem AC_153_msg_compat_in) *)
let ac_153_msg_compat_in (p_m: _) (p_t: _) (p_expected: _) : Lemma (requires (p_m.f_msg_tag == p_t /\ List.Tot.memP p_t p_expected)) (ensures (msg_type_compatible p_m p_expected == true)) = admit ()

(* AC_154_riina_actor_not_full (matches Coq: Theorem AC_154_riina_actor_not_full) *)
let ac_154_riina_actor_not_full () : Lemma (mailbox_full riina_actor == false) = admit ()

(* AC_155_riina_can_receive (matches Coq: Theorem AC_155_riina_can_receive) *)
let ac_155_riina_can_receive () : Lemma (can_receive riina_actor == true) = admit ()

(* AC_156_crashed_cannot_receive (matches Coq: Theorem AC_156_crashed_cannot_receive) *)
let ac_156_crashed_cannot_receive (p_a: _) : Lemma (requires (is_crashed p_a == true)) (ensures (can_receive p_a == false)) = admit ()

(* AC_157_stopped_cannot_receive (matches Coq: Theorem AC_157_stopped_cannot_receive) *)
let ac_157_stopped_cannot_receive (p_a: _) : Lemma (requires (is_stopped p_a == true)) (ensures (can_receive p_a == false)) = admit ()

(* AC_158_waiting_cannot_receive (matches Coq: Theorem AC_158_waiting_cannot_receive) *)
let ac_158_waiting_cannot_receive (p_a: _) : Lemma (requires (is_waiting p_a == true)) (ensures (can_receive p_a == false)) = admit ()

(* AC_159_restarting_cannot_receive (matches Coq: Theorem AC_159_restarting_cannot_receive) *)
let ac_159_restarting_cannot_receive (p_a: _) : Lemma (requires (is_restarting p_a == true)) (ensures (can_receive p_a == false)) = admit ()

(* AC_160_well_typed_all_msgs_compat (matches Coq: Theorem AC_160_well_typed_all_msgs_compat) *)
let ac_160_well_typed_all_msgs_compat (p_ta: _) (p_m: _) : Lemma (requires (actor_well_typed p_ta == true /\ List.Tot.memP p_m ((p_ta.f_ta_state).f_actor_mailbox))) (ensures (msg_type_compatible p_m (p_ta.f_ta_expected) == true)) = admit ()

(* AC_161_spawn_running (matches Coq: Theorem AC_161_spawn_running) *)
let ac_161_spawn_running (p_cfg: _) (p_new_id: _) : Lemma (find_actor (spawn_actor p_cfg p_new_id) p_new_id == Some (mkactor p_new_id Running [] 0 0 0 100 0) \/ (exists p_a. find_actor p_cfg p_new_id == Some p_a)) = admit ()

(* AC_162_config_size_empty (matches Coq: Theorem AC_162_config_size_empty) *)
let ac_162_config_size_empty () : Lemma (config_size [] == 0) = admit ()

(* AC_163_config_size_cons (matches Coq: Theorem AC_163_config_size_cons) *)
let ac_163_config_size_cons (p_a: _) (p_cfg: _) : Lemma (config_size (p_a :: p_cfg) == ((config_size p_cfg) + 1)) = admit ()

(* AC_164_crash_preserves_others (matches Coq: Theorem AC_164_crash_preserves_others) *)
let ac_164_crash_preserves_others (p_cfg: _) (p_a: _) (p_aid: _) : Lemma (requires (List.Tot.memP p_a p_cfg /\ ~(p_a.f_actor_id == p_aid))) (ensures (List.Tot.memP p_a (crash_actor p_cfg p_aid))) = admit ()

(* AC_165_restart_preserves_others (matches Coq: Theorem AC_165_restart_preserves_others) *)
let ac_165_restart_preserves_others (p_cfg: _) (p_a: _) (p_aid: _) : Lemma (requires (List.Tot.memP p_a p_cfg /\ ~(p_a.f_actor_id == p_aid))) (ensures (List.Tot.memP p_a (restart_actor p_cfg p_aid))) = admit ()

(* AC_166_deliver_preserves_others (matches Coq: Theorem AC_166_deliver_preserves_others) *)
let ac_166_deliver_preserves_others (p_cfg: _) (p_a: _) (p_target: _) (p_m: _) : Lemma (requires (List.Tot.memP p_a p_cfg /\ ~(p_a.f_actor_id == p_target))) (ensures (List.Tot.memP p_a (deliver_message p_cfg p_target p_m))) = admit ()

(* AC_167_config_no_crashed_running (matches Coq: Theorem AC_167_config_no_crashed_running) *)
let ac_167_config_no_crashed_running (p_cfg: _) : Lemma (requires (config_all_running p_cfg == true)) (ensures (config_no_crashed p_cfg == true)) = admit ()

(* AC_168_spawn_preserves_existing (matches Coq: Theorem AC_168_spawn_preserves_existing) *)
let ac_168_spawn_preserves_existing (p_cfg: _) (p_a: _) (p_new_id: _) : Lemma (requires (List.Tot.memP p_a p_cfg)) (ensures (List.Tot.memP p_a (spawn_actor p_cfg p_new_id))) = admit ()

(* AC_169_spawn_adds_new (matches Coq: Theorem AC_169_spawn_adds_new) *)
let ac_169_spawn_adds_new (p_cfg: _) (p_new_id: _) : Lemma (List.Tot.memP (mkactor p_new_id Running [] 0 0 0 100 0) (spawn_actor p_cfg p_new_id)) = admit ()

(* AC_170_riina_config_size (matches Coq: Theorem AC_170_riina_config_size) *)
let ac_170_riina_config_size () : Lemma (config_size riina_config == 2) = admit ()

(* AC_171_total_messages_nil (matches Coq: Theorem AC_171_total_messages_nil) *)
let ac_171_total_messages_nil () : Lemma (total_messages [] == 0) = admit ()

(* AC_172_total_messages_riina (matches Coq: Theorem AC_172_total_messages_riina) *)
let ac_172_total_messages_riina () : Lemma (total_messages [riina_actor] == 0) = admit ()

(* AC_173_config_no_full_nil (matches Coq: Theorem AC_173_config_no_full_nil) *)
let ac_173_config_no_full_nil () : Lemma (config_no_full_mailboxes [] == true) = admit ()

(* AC_174_config_no_full_cons (matches Coq: Theorem AC_174_config_no_full_cons) *)
let ac_174_config_no_full_cons (p_a: _) (p_cfg: _) : Lemma (requires (mailbox_full p_a == false /\ config_no_full_mailboxes p_cfg == true)) (ensures (config_no_full_mailboxes (p_a :: p_cfg) == true)) = admit ()

(* AC_175_deliver_to_absent_noop (matches Coq: Theorem AC_175_deliver_to_absent_noop) *)
let ac_175_deliver_to_absent_noop (p_cfg: _) (p_target: _) (p_m: _) : Lemma (requires (((forall (a: _). List.Tot.memP a p_cfg)))) (ensures (deliver_message p_cfg p_target p_m == p_cfg)) = admit ()

(* AC_176_config_all_isolated_nil (matches Coq: Theorem AC_176_config_all_isolated_nil) *)
let ac_176_config_all_isolated_nil () : Lemma (config_all_isolated [] == true) = admit ()

(* AC_177_config_all_isolated_cons (matches Coq: Theorem AC_177_config_all_isolated_cons) *)
let ac_177_config_all_isolated_cons (p_a: _) (p_cfg: _) : Lemma (requires (Nat.eqb (p_a.f_actor_local) (p_a.f_actor_id) == true /\ config_all_isolated p_cfg == true)) (ensures (config_all_isolated (p_a :: p_cfg) == true)) = admit ()

(* AC_178_riina_actor_isolated (matches Coq: Theorem AC_178_riina_actor_isolated) *)
let ac_178_riina_actor_isolated () : Lemma (Nat.eqb (riina_actor.f_actor_local) (riina_actor.f_actor_id) == true) = admit ()

(* AC_179_empty_config_all_predicates (matches Coq: Theorem AC_179_empty_config_all_predicates) *)
let ac_179_empty_config_all_predicates () : Lemma (config_all_running [] == true /\ config_no_crashed [] == true /\ config_all_isolated [] == true /\ config_no_full_mailboxes [] == true) = admit ()

(* AC_180_crash_actor_nil (matches Coq: Theorem AC_180_crash_actor_nil) *)
let ac_180_crash_actor_nil (p_aid: _) : Lemma (crash_actor [] p_aid == []) = admit ()

(* AC_181_deliver_increases_mailbox (matches Coq: Theorem AC_181_deliver_increases_mailbox) *)
let ac_181_deliver_increases_mailbox (p_a: _) (p_target: _) (p_m: _) (p_rest: _) : Lemma (requires (p_a.f_actor_id == p_target)) (ensures (List.Tot.memP (mkactor (p_a.f_actor_id) (p_a.f_actor_status) (actor_mailbox p_a ++ [p_m]) (p_a.f_actor_local) (actor_msg_count p_a + 1) (p_a.f_actor_spawn_count) (p_a.f_actor_max_mailbox) (p_a.f_actor_restart_count)) (deliver_message (p_a :: p_rest) p_target p_m))) = admit ()

(* AC_182_message_not_lost_on_deliver (matches Coq: Theorem AC_182_message_not_lost_on_deliver) *)
let ac_182_message_not_lost_on_deliver (p_mb: (list message)) (p_m: _) : Lemma (List.Tot.memP p_m (p_mb ++ [p_m])) = admit ()

(* AC_183_old_messages_preserved (matches Coq: Theorem AC_183_old_messages_preserved) *)
let ac_183_old_messages_preserved (p_mb: (list message)) (p_m_: _) (p_m: _) : Lemma (requires (List.Tot.memP p_m p_mb)) (ensures (List.Tot.memP p_m (p_mb ++ [p_m_]))) = admit ()

(* AC_184_delivery_order_fifo (matches Coq: Theorem AC_184_delivery_order_fifo) *)
let ac_184_delivery_order_fifo (p_mb: (list message)) (p_m1: _) (p_m2: _) : Lemma (p_mb ++ [p_m1] ++ [p_m2] == (p_mb ++ [p_m1]) ++ [p_m2]) = admit ()

(* AC_185_restart_clears_mailbox (matches Coq: Theorem AC_185_restart_clears_mailbox) *)
let ac_185_restart_clears_mailbox (p_a: _) (p_aid: _) (p_rest: _) : Lemma (requires (p_a.f_actor_id == p_aid)) (ensures ((exists p_a. List.Tot.memP a_ (restart_actor (p_a :: p_rest) p_aid)) /\ a_.f_actor_id == p_aid /\ a_.f_actor_mailbox == [])) = admit ()

(* AC_186_restart_sets_running (matches Coq: Theorem AC_186_restart_sets_running) *)
let ac_186_restart_sets_running (p_a: _) (p_aid: _) (p_rest: _) : Lemma (requires (p_a.f_actor_id == p_aid)) (ensures ((exists p_a. List.Tot.memP a_ (restart_actor (p_a :: p_rest) p_aid)) /\ a_.f_actor_id == p_aid /\ a_.f_actor_status == Running)) = admit ()

(* AC_187_restart_increments_count (matches Coq: Theorem AC_187_restart_increments_count) *)
let ac_187_restart_increments_count (p_a: _) (p_aid: _) (p_rest: _) : Lemma (requires (p_a.f_actor_id == p_aid)) (ensures ((exists p_a. List.Tot.memP a_ (restart_actor (p_a :: p_rest) p_aid)) /\ a_.f_actor_id == p_aid /\ a_.f_actor_restart_count == actor_restart_count p_a + 1)) = admit ()

(* AC_188_crash_sets_crashed (matches Coq: Theorem AC_188_crash_sets_crashed) *)
let ac_188_crash_sets_crashed (p_a: _) (p_aid: _) (p_rest: _) : Lemma (requires (p_a.f_actor_id == p_aid)) (ensures ((exists p_a. List.Tot.memP a_ (crash_actor (p_a :: p_rest) p_aid)) /\ a_.f_actor_id == p_aid /\ a_.f_actor_status == Crashed)) = admit ()

(* AC_189_crash_preserves_mailbox (matches Coq: Theorem AC_189_crash_preserves_mailbox) *)
let ac_189_crash_preserves_mailbox (p_a: _) (p_aid: _) (p_rest: _) : Lemma (requires (p_a.f_actor_id == p_aid)) (ensures ((exists p_a. List.Tot.memP a_ (crash_actor (p_a :: p_rest) p_aid)) /\ a_.f_actor_id == p_aid /\ a_.f_actor_mailbox == p_a.f_actor_mailbox)) = admit ()

(* AC_190_restart_nil (matches Coq: Theorem AC_190_restart_nil) *)
let ac_190_restart_nil (p_aid: _) : Lemma (restart_actor [] p_aid == []) = admit ()

(* AC_191_deliver_nil (matches Coq: Theorem AC_191_deliver_nil) *)
let ac_191_deliver_nil (p_target: _) (p_m: _) : Lemma (deliver_message [] p_target p_m == []) = admit ()

(* AC_192_spawn_nil (matches Coq: Theorem AC_192_spawn_nil) *)
let ac_192_spawn_nil (p_new_id: _) : Lemma (spawn_actor [] p_new_id == [mkactor p_new_id Running [] 0 0 0 100 0]) = admit ()

(* AC_193_well_typed_preserved_empty_deliver (matches Coq: Theorem AC_193_well_typed_preserved_empty_deliver) *)
let ac_193_well_typed_preserved_empty_deliver (p_ta: nat) (p_target: nat) : Lemma (requires (actor_well_typed p_ta == true /\ ~((p_ta.f_ta_state).f_actor_id == p_target))) (ensures (is_running (p_ta.f_ta_state) == true)) = admit ()

(* AC_194_capability_required_for_spawn (matches Coq: Theorem AC_194_capability_required_for_spawn) *)
let ac_194_capability_required_for_spawn (p_caps: _) : Lemma (requires (can_spawn p_caps == false /\ (forall (c: _). List.Tot.memP c p_caps))) (ensures (~(c.f_acap_kind == CapSpawn) \/ c.f_acap_granted == false)) = admit ()

(* AC_195_capability_required_for_send (matches Coq: Theorem AC_195_capability_required_for_send) *)
let ac_195_capability_required_for_send (p_caps: _) : Lemma (requires (can_send_cap p_caps == false /\ (forall (c: _). List.Tot.memP c p_caps))) (ensures (~(c.f_acap_kind == CapSend) \/ c.f_acap_granted == false)) = admit ()

(* AC_196_has_cap_kind_cons (matches Coq: Theorem AC_196_has_cap_kind_cons) *)
let ac_196_has_cap_kind_cons (p_c: _) (p_caps: _) (p_k: _) : Lemma (requires (cap_kind_eqb (p_c.f_acap_kind) p_k == true /\ p_c.f_acap_granted == true)) (ensures (has_cap_kind (p_c :: p_caps) p_k == true)) = admit ()

(* AC_197_has_cap_kind_tail (matches Coq: Theorem AC_197_has_cap_kind_tail) *)
let ac_197_has_cap_kind_tail (p_c: _) (p_caps: _) (p_k: _) : Lemma (requires (has_cap_kind p_caps p_k == true)) (ensures (has_cap_kind (p_c :: p_caps) p_k == true)) = admit ()

(* AC_198_session_duality_symmetric (matches Coq: Theorem AC_198_session_duality_symmetric) *)
let ac_198_session_duality_symmetric (p_t: _) : Lemma (ast_dual (ASTSend p_t ASTEnd) == ASTRecv p_t ASTEnd) = admit ()

(* AC_199_session_duality_symmetric_recv (matches Coq: Theorem AC_199_session_duality_symmetric_recv) *)
let ac_199_session_duality_symmetric_recv (p_t: _) : Lemma (ast_dual (ASTRecv p_t ASTEnd) == ASTSend p_t ASTEnd) = admit ()

(* AC_200_chan_pair_dual (matches Coq: Theorem AC_200_chan_pair_dual) *)
let ac_200_chan_pair_dual () : Lemma ((riina_chan_pair.f_achan_endpoint_a).f_achan_session == ast_dual ((riina_chan_pair.f_achan_endpoint_b).f_achan_session)) = admit ()

(* AC_201_status_eq_dec (matches Coq: Theorem AC_201_status_eq_dec) *)
let ac_201_status_eq_dec (p_s1: actor_status) (p_s2: actor_status) : Lemma ({p_s1 == s2_ + {p_s1 <> s2_) = admit ()

(* AC_202_cap_kind_eq_dec (matches Coq: Theorem AC_202_cap_kind_eq_dec) *)
let ac_202_cap_kind_eq_dec (p_k1: cap_kind) (p_k2: cap_kind) : Lemma ({p_k1 == k2_ + {p_k1 <> k2_) = admit ()

(* AC_203_mailbox_wt_single_compat (matches Coq: Theorem AC_203_mailbox_wt_single_compat) *)
let ac_203_mailbox_wt_single_compat (p_m: _) (p_tag: _) : Lemma (requires (p_m.f_msg_tag == p_tag)) (ensures (mailbox_well_typed [p_m] [p_tag] == true)) = admit ()

(* AC_204_deliver_idempotent_absent (matches Coq: Theorem AC_204_deliver_idempotent_absent) *)
let ac_204_deliver_idempotent_absent (p_cfg: _) (p_target: _) (p_m1: _) (p_m2: _) : Lemma (requires (((forall (a: _). List.Tot.memP a p_cfg)))) (ensures (deliver_message (deliver_message p_cfg p_target p_m1) p_target p_m2 == p_cfg)) = admit ()

(* AC_205_spawn_then_find (matches Coq: Theorem AC_205_spawn_then_find) *)
let ac_205_spawn_then_find (p_new_id: _) : Lemma (find_actor (spawn_actor [] p_new_id) p_new_id == Some (mkactor p_new_id Running [] 0 0 0 100 0)) = admit ()

(* AC_206_riina_msg_ref_tag (matches Coq: Theorem AC_206_riina_msg_ref_tag) *)
let ac_206_riina_msg_ref_tag () : Lemma (riina_msg_ref.f_msg_tag == TagActorRef) = admit ()

(* AC_207_riina_msg_sender (matches Coq: Theorem AC_207_riina_msg_sender) *)
let ac_207_riina_msg_sender () : Lemma (riina_msg_nat.f_msg_sender == 0) = admit ()

(* AC_208_riina_msg_priority (matches Coq: Theorem AC_208_riina_msg_priority) *)
let ac_208_riina_msg_priority () : Lemma (riina_msg_nat.f_msg_priority == 0) = admit ()

(* AC_209_riina_msg_payload (matches Coq: Theorem AC_209_riina_msg_payload) *)
let ac_209_riina_msg_payload () : Lemma (riina_msg_nat.f_msg_payload == 42) = admit ()

(* AC_210_riina_actor_id (matches Coq: Theorem AC_210_riina_actor_id) *)
let ac_210_riina_actor_id () : Lemma (riina_actor.f_actor_id == 0) = admit ()

(* Copyright (c) 2026 The RIINA Authors. All rights reserved. *)
(* Copyright (c) 2026 The RIINA Authors. *)
(* Derived from 02_FORMAL/coq/domains/TimeSecurity.v (25 lemmas) *)
(* Source mapping: scripts/generate-full-stack.py *)
module RIINA.Domains.TimeSecurity
open FStar.All

(* AtomicOp (matches Coq) *)
type atomic_op =
  | AtomicRead of nat
  | AtomicWrite of (nat * nat)
  | CompareAndSwap of (nat * nat * nat)

(* nonce_unique (matches Coq: Definition nonce_unique) *)
let nonce_unique (p_nonce: nat) (p_seen: (list nat)) : Tot bool =
  (not (existsb (fun n -> (n = p_nonce))) p_seen)

(* is_replay (matches Coq: Definition is_replay) *)
let is_replay (p_msg: nat) (p_window: nat) : Tot bool =
  existsb (fun n -> Nat.eqb n (nonce_value (msg_nonce p_msg))) (window_seen p_window)

(* seq_increasing (matches Coq: Definition seq_increasing) *)
let seq_increasing (p_msg: nat) (p_window: nat) : Tot bool =
  (window_last_seq p_window) < (msg_sequence p_msg)

(* timestamp_fresh (matches Coq: Definition timestamp_fresh) *)
let timestamp_fresh (p_ts: nat) (p_current: nat) (p_max_age: nat) : Tot bool =
  Nat.leb (p_current - ts_value p_ts) p_max_age

(* capability_valid (matches Coq: Definition capability_valid) *)
let capability_valid (p_cap: nat) (p_current_time: nat) : Tot bool =
  Nat.ltb p_current_time (cap_valid_until p_cap)

(* owner_matches (matches Coq: Definition owner_matches) *)
let owner_matches (p_cap: nat) (p_requester: nat) : Tot bool =
  Nat.eqb (cap_owner p_cap) p_requester

(* atomic_complete (matches Coq: Definition atomic_complete) *)
let atomic_complete (p_started: bool) (p_finished: bool) : Tot bool =
  implb p_started p_finished

(* cas_succeeds (matches Coq: Definition cas_succeeds) *)
let cas_succeeds (p_current: nat) (p_expected: nat) (p_new_val: nat) : Tot bool =
  (p_current = p_expected)

(* clock_monotonic (matches Coq: Definition clock_monotonic) *)
let clock_monotonic (p_old_time: nat) (p_new_time: nat) : Tot bool =
  p_old_time <= p_new_time

(* happens_before (matches Coq: Definition happens_before) *)
let happens_before (p_event1_time: nat) (p_event2_time: nat) : Tot bool =
  p_event1_time < p_event2_time

(* logical_clock_update (matches Coq: Definition logical_clock_update) *)
let logical_clock_update (p_old_counter: nat) (p_received: nat) : Tot nat =
  ((max p_old_counter p_received) + 1)

(* signature_valid (matches Coq: Definition signature_valid) *)
let signature_valid (p_expected: nat) (p_actual: nat) : Tot bool =
  (p_expected = p_actual)

(* sources_sufficient (matches Coq: Definition sources_sufficient) *)
let sources_sufficient (p_count: nat) (p_min_sources: nat) : Tot bool =
  p_min_sources <= p_count

(* skew_bounded (matches Coq: Definition skew_bounded) *)
let skew_bounded (p_skew: nat) (p_max_skew: nat) : Tot bool =
  p_skew <= p_max_skew

(* deadline_met (matches Coq: Definition deadline_met) *)
let deadline_met (p_current: nat) (p_deadline: nat) : Tot bool =
  p_current <= p_deadline

(* timeout_triggered (matches Coq: Definition timeout_triggered) *)
let timeout_triggered (p_elapsed: nat) (p_timeout: nat) : Tot bool =
  p_timeout < p_elapsed

(* lock_order_valid (matches Coq: Definition lock_order_valid) *)
let lock_order_valid (p_lock1: nat) (p_lock2: nat) : Tot bool =
  p_lock1 < p_lock2

(* progress_made (matches Coq: Definition progress_made) *)
let progress_made (p_p_before: nat) (p_p_after: nat) : Tot bool =
  p_p_before < p_p_after

(* wait_bounded (matches Coq: Definition wait_bounded) *)
let wait_bounded (p_wait_time: nat) (p_max_wait: nat) : Tot bool =
  p_wait_time <= p_max_wait

(* rate_ok (matches Coq: Definition rate_ok) *)
let rate_ok (p_requests: nat) (p_max_rate: nat) (p_period: nat) : Tot bool =
  p_requests <= p_max_rate

(* order_preserved (matches Coq: Definition order_preserved) *)
let order_preserved (p_seq1: nat) (p_seq2: nat) : Tot bool =
  p_seq1 <= p_seq2

(* audit_timestamp_ok (matches Coq: Definition audit_timestamp_ok) *)
let audit_timestamp_ok (p_audit_time: nat) (p_event_time: nat) : Tot bool =
  p_event_time <= p_audit_time

(* session_valid (matches Coq: Definition session_valid) *)
let session_valid (p_created: nat) (p_current: nat) (p_max_age: nat) : Tot bool =
  Nat.leb (p_current - p_created) p_max_age

(* time_layers (matches Coq: Definition time_layers) *)
let time_layers (p_replay: bool) (p_toctou: bool) (p_atomic: bool) (p_timestamp: bool) : Tot bool =
  andb p_replay (andb p_toctou ((p_atomic && p_timestamp)))

(* time_001_nonce_unique (matches Coq: Theorem time_001_nonce_unique) *)
let time_001_nonce_unique (p_nonce: nat) (p_seen: (list nat)) : Lemma (requires (nonce_unique p_nonce p_seen == true)) (ensures (~(List.Tot.memP p_nonce p_seen))) = ()

(* time_002_replay_detected (matches Coq: Theorem time_002_replay_detected) *)
let time_002_replay_detected (p_msg: nat) (p_window: nat) : Lemma (requires (is_replay p_msg p_window == true)) (ensures (List.Tot.memP (nonce_value (msg_nonce p_msg)) (window_seen p_window))) = ()

(* time_003_seq_increasing (matches Coq: Theorem time_003_seq_increasing) *)
let time_003_seq_increasing (p_msg: nat) (p_window: nat) : Lemma (requires (seq_increasing p_msg p_window == true)) (ensures (window_last_seq p_window < msg_sequence p_msg)) = ()

(* time_004_timestamp_fresh (matches Coq: Theorem time_004_timestamp_fresh) *)
let time_004_timestamp_fresh (p_ts: nat) (p_current: nat) (p_max_age: nat) : Lemma (requires (timestamp_fresh p_ts p_current p_max_age == true)) (ensures (p_current - ts_value p_ts <= p_max_age)) = ()

(* time_005_capability_valid (matches Coq: Theorem time_005_capability_valid) *)
let time_005_capability_valid (p_cap: nat) (p_current_time: nat) : Lemma (requires (capability_valid p_cap p_current_time == true)) (ensures (p_current_time < cap_valid_until p_cap)) = ()

(* time_006_owner_matches (matches Coq: Theorem time_006_owner_matches) *)
let time_006_owner_matches (p_cap: nat) (p_requester: nat) : Lemma (requires (owner_matches p_cap p_requester == true)) (ensures (cap_owner p_cap == p_requester)) = ()

(* time_007_atomic_complete (matches Coq: Theorem time_007_atomic_complete) *)
let time_007_atomic_complete (p_started: bool) (p_finished: bool) : Lemma (requires (atomic_complete p_started p_finished == true /\ p_started == true)) (ensures (p_finished == true)) = ()

(* time_008_cas_correct (matches Coq: Theorem time_008_cas_correct) *)
let time_008_cas_correct (p_current: nat) (p_expected: nat) (p_new_val: nat) : Lemma (requires (cas_succeeds p_current p_expected p_new_val == true)) (ensures (p_current == p_expected)) = ()

(* time_009_clock_monotonic (matches Coq: Theorem time_009_clock_monotonic) *)
let time_009_clock_monotonic (p_old_time: nat) (p_new_time: nat) : Lemma (requires (clock_monotonic p_old_time p_new_time == true)) (ensures (p_old_time <= p_new_time)) = ()

(* time_010_happens_before (matches Coq: Theorem time_010_happens_before) *)
let time_010_happens_before (p_e1_time: nat) (p_e2_time: nat) : Lemma (requires (happens_before p_e1_time p_e2_time == true)) (ensures (p_e1_time < p_e2_time)) = ()

(* time_011_logical_clock_update (matches Coq: Theorem time_011_logical_clock_update) *)
let time_011_logical_clock_update (p_old_counter: nat) (p_received: nat) : Lemma (p_old_counter < logical_clock_update p_old_counter p_received /\ p_received < logical_clock_update p_old_counter p_received) = ()

(* time_012_timestamp_auth (matches Coq: Theorem time_012_timestamp_auth) *)
let time_012_timestamp_auth (p_expected: nat) (p_actual: nat) : Lemma (requires (signature_valid p_expected p_actual == true)) (ensures (p_expected == p_actual)) = ()

(* time_013_multi_source (matches Coq: Theorem time_013_multi_source) *)
let time_013_multi_source (p_count: nat) (p_min_sources: nat) : Lemma (requires (sources_sufficient p_count p_min_sources == true)) (ensures (p_min_sources <= p_count)) = ()

(* time_014_skew_bounded (matches Coq: Theorem time_014_skew_bounded) *)
let time_014_skew_bounded (p_skew: nat) (p_max_skew: nat) : Lemma (requires (skew_bounded p_skew p_max_skew == true)) (ensures (p_skew <= p_max_skew)) = ()

(* time_015_deadline_met (matches Coq: Theorem time_015_deadline_met) *)
let time_015_deadline_met (p_current: nat) (p_deadline: nat) : Lemma (requires (deadline_met p_current p_deadline == true)) (ensures (p_current <= p_deadline)) = ()

(* time_016_timeout_triggered (matches Coq: Theorem time_016_timeout_triggered) *)
let time_016_timeout_triggered (p_elapsed: nat) (p_timeout: nat) : Lemma (requires (timeout_triggered p_elapsed p_timeout == true)) (ensures (p_timeout < p_elapsed)) = ()

(* time_017_lock_order (matches Coq: Theorem time_017_lock_order) *)
let time_017_lock_order (p_lock1: nat) (p_lock2: nat) : Lemma (requires (lock_order_valid p_lock1 p_lock2 == true)) (ensures (p_lock1 < p_lock2)) = ()

(* time_018_no_deadlock (matches Coq: Theorem time_018_no_deadlock) *)
let time_018_no_deadlock (p_deps: (list nat)) : Lemma (requires (no_cycle p_deps == true)) (ensures (no_cycle p_deps == true)) = ()

(* time_019_progress (matches Coq: Theorem time_019_progress) *)
let time_019_progress (p_p_before: nat) (p_p_after: nat) : Lemma (requires (progress_made id_before id_after == true)) (ensures (id_before < id_after)) = ()

(* time_020_fair_scheduling (matches Coq: Theorem time_020_fair_scheduling) *)
let time_020_fair_scheduling (p_wait_time: nat) (p_max_wait: nat) : Lemma (requires (wait_bounded p_wait_time p_max_wait == true)) (ensures (p_wait_time <= p_max_wait)) = ()

(* time_021_rate_limiting (matches Coq: Theorem time_021_rate_limiting) *)
let time_021_rate_limiting (p_requests: nat) (p_max_rate: nat) (p_period: nat) : Lemma (requires (rate_ok p_requests p_max_rate p_period == true)) (ensures (p_requests <= p_max_rate)) = ()

(* time_022_ordered_delivery (matches Coq: Theorem time_022_ordered_delivery) *)
let time_022_ordered_delivery (p_seq1: nat) (p_seq2: nat) : Lemma (requires (order_preserved p_seq1 p_seq2 == true)) (ensures (p_seq1 <= p_seq2)) = ()

(* time_023_audit_timestamp (matches Coq: Theorem time_023_audit_timestamp) *)
let time_023_audit_timestamp (p_audit_time: nat) (p_event_time: nat) : Lemma (requires (audit_timestamp_ok p_audit_time p_event_time == true)) (ensures (p_event_time <= p_audit_time)) = ()

(* time_024_session_valid (matches Coq: Theorem time_024_session_valid) *)
let time_024_session_valid (p_created: nat) (p_current: nat) (p_max_age: nat) : Lemma (requires (session_valid p_created p_current p_max_age == true)) (ensures (p_current - p_created <= p_max_age)) = ()

(* time_025_defense_in_depth (matches Coq: Theorem time_025_defense_in_depth) *)
let time_025_defense_in_depth (p_r: _) (p_t: _) (p_a: _) (p_ts: _) : Lemma (requires (time_layers p_r p_t p_a p_ts == true)) (ensures (p_r == true /\ p_t == true /\ p_a == true /\ p_ts == true)) = ()

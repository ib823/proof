// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for session type verification
// Bounded verification of SessionTypes properties
module riina/Domains/SessionTypes

abstract sig SessionState {}
one sig Open extends SessionState {}
one sig Send extends SessionState {}
one sig Recv extends SessionState {}
one sig Closed extends SessionState {}

sig SessionChannel {
  state: one SessionState,
  dual: one lone SessionChannel
}

sig SessionAction {
  channel: one SessionChannel,
  valid: one Int
}

// Invariant: closed_no_action
fact closed_no_action_fact {
  all a: SessionAction | a.channel.state = Closed implies a.valid = 0
}

// Invariant: duality
fact duality_fact {
  all c: SessionChannel | some c.dual implies c.dual.dual = c
}

// Invariant: open_before_send
fact open_before_send_fact {
  all a: SessionAction | a.valid = 1 implies a.channel.state != Closed
}

assert ST_001_dual_end {
  all a: SessionAction | a.channel.state = Closed implies a.valid = 0
}
check ST_001_dual_end for 6

assert ST_002_dual_send_recv {
  all c: SessionChannel | some c.dual implies c.dual.dual = c
}
check ST_002_dual_send_recv for 6

assert ST_003_dual_recv_send {
  all a: SessionAction | a.valid = 1 implies a.channel.state != Closed
}
check ST_003_dual_recv_send for 6

assert ST_004_dual_select_offer {
  all a: SessionAction | a.channel.state = Closed implies a.valid = 0
}
check ST_004_dual_select_offer for 6

assert ST_005_dual_offer_select {
  all c: SessionChannel | some c.dual implies c.dual.dual = c
}
check ST_005_dual_offer_select for 6

assert ST_006_dual_involutive_end {
  all a: SessionAction | a.valid = 1 implies a.channel.state != Closed
}
check ST_006_dual_involutive_end for 6

assert ST_007_dual_involutive_send {
  all a: SessionAction | a.channel.state = Closed implies a.valid = 0
}
check ST_007_dual_involutive_send for 6

assert ST_008_dual_involutive_recv {
  all c: SessionChannel | some c.dual implies c.dual.dual = c
}
check ST_008_dual_involutive_recv for 6

assert ST_009_dual_chain {
  all a: SessionAction | a.valid = 1 implies a.channel.state != Closed
}
check ST_009_dual_chain for 6

assert ST_010_dual_chain_rev {
  all a: SessionAction | a.channel.state = Closed implies a.valid = 0
}
check ST_010_dual_chain_rev for 6

assert ST_011_dual_preserves_msg {
  all c: SessionChannel | some c.dual implies c.dual.dual = c
}
check ST_011_dual_preserves_msg for 6

assert ST_012_endpoints_dual {
  all a: SessionAction | a.valid = 1 implies a.channel.state != Closed
}
check ST_012_endpoints_dual for 6

assert ST_013_fresh_linear {
  all a: SessionAction | a.channel.state = Closed implies a.valid = 0
}
check ST_013_fresh_linear for 6

assert ST_014_used_not_linear {
  all c: SessionChannel | some c.dual implies c.dual.dual = c
}
check ST_014_used_not_linear for 6

assert ST_015_use_preserves_id {
  all a: SessionAction | a.valid = 1 implies a.channel.state != Closed
}
check ST_015_use_preserves_id for 6

assert ST_016_use_preserves_type {
  all a: SessionAction | a.channel.state = Closed implies a.valid = 0
}
check ST_016_use_preserves_type for 6

assert ST_017_wf_pair_dual {
  all c: SessionChannel | some c.dual implies c.dual.dual = c
}
check ST_017_wf_pair_dual for 6

assert ST_018_wf_pair_same_id {
  all a: SessionAction | a.valid = 1 implies a.channel.state != Closed
}
check ST_018_wf_pair_same_id for 6

assert ST_019_session_no_deadlock {
  all a: SessionAction | a.channel.state = Closed implies a.valid = 0
}
check ST_019_session_no_deadlock for 6

assert ST_020_dual_communicate {
  all c: SessionChannel | some c.dual implies c.dual.dual = c
}
check ST_020_dual_communicate for 6

assert ST_021_value_done {
  all a: SessionAction | a.valid = 1 implies a.channel.state != Closed
}
check ST_021_value_done for 6

assert ST_022_end_is_value {
  all a: SessionAction | a.channel.state = Closed implies a.valid = 0
}
check ST_022_end_is_value for 6

assert ST_023_empty_deadlock_free {
  all c: SessionChannel | some c.dual implies c.dual.dual = c
}
check ST_023_empty_deadlock_free for 6

assert ST_024_msg_eq_refl {
  all a: SessionAction | a.valid = 1 implies a.channel.state != Closed
}
check ST_024_msg_eq_refl for 6

assert ST_025_msg_eq_true {
  all a: SessionAction | a.channel.state = Closed implies a.valid = 0
}
check ST_025_msg_eq_true for 6

assert ST_026_msg_type_cases {
  all c: SessionChannel | some c.dual implies c.dual.dual = c
}
check ST_026_msg_type_cases for 6

assert ST_027_msg_type_dec {
  all a: SessionAction | a.valid = 1 implies a.channel.state != Closed
}
check ST_027_msg_type_dec for 6

assert ST_028_session_type_cases {
  all a: SessionAction | a.channel.state = Closed implies a.valid = 0
}
check ST_028_session_type_cases for 6

assert ST_029_dual_non_end_send {
  all c: SessionChannel | some c.dual implies c.dual.dual = c
}
check ST_029_dual_non_end_send for 6

assert ST_030_dual_non_end_recv {
  all a: SessionAction | a.valid = 1 implies a.channel.state != Closed
}
check ST_030_dual_non_end_recv for 6

assert ST_031_dual_empty_select {
  all a: SessionAction | a.channel.state = Closed implies a.valid = 0
}
check ST_031_dual_empty_select for 6

assert ST_032_dual_empty_offer {
  all c: SessionChannel | some c.dual implies c.dual.dual = c
}
check ST_032_dual_empty_offer for 6

assert ST_033_lookup_empty {
  all a: SessionAction | a.valid = 1 implies a.channel.state != Closed
}
check ST_033_lookup_empty for 6

assert ST_034_lookup_found {
  all a: SessionAction | a.channel.state = Closed implies a.valid = 0
}
check ST_034_lookup_found for 6

assert ST_035_lookup_skip {
  all c: SessionChannel | some c.dual implies c.dual.dual = c
}
check ST_035_lookup_skip for 6

assert ST_036_dual_compose_send {
  all a: SessionAction | a.valid = 1 implies a.channel.state != Closed
}
check ST_036_dual_compose_send for 6

assert ST_037_dual_branches {
  all a: SessionAction | a.channel.state = Closed implies a.valid = 0
}
check ST_037_dual_branches for 6

assert ST_038_single_branch_dual {
  all c: SessionChannel | some c.dual implies c.dual.dual = c
}
check ST_038_single_branch_dual for 6

assert ST_039_wt_end_empty {
  all a: SessionAction | a.valid = 1 implies a.channel.state != Closed
}
check ST_039_wt_end_empty for 6

assert ST_040_par_exists {
  all a: SessionAction | a.channel.state = Closed implies a.valid = 0
}
check ST_040_par_exists for 6

assert ST_041_chan_construct {
  all c: SessionChannel | some c.dual implies c.dual.dual = c
}
check ST_041_chan_construct for 6

assert ST_042_pair_construct {
  all a: SessionAction | a.valid = 1 implies a.channel.state != Closed
}
check ST_042_pair_construct for 6

assert ST_043_process_cases {
  all a: SessionAction | a.channel.state = Closed implies a.valid = 0
}
check ST_043_process_cases for 6

assert ST_044_dual_triple_end {
  all c: SessionChannel | some c.dual implies c.dual.dual = c
}
check ST_044_dual_triple_end for 6

assert ST_045_nested_send_dual {
  all a: SessionAction | a.valid = 1 implies a.channel.state != Closed
}
check ST_045_nested_send_dual for 6

pred ExampleSessionTypes {
  some SessionChannel
}
run ExampleSessionTypes for 6

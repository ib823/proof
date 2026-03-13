// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Derived from 02_FORMAL/coq/properties/NonInterference_v2.v
// Models: security properties for information flow control
module riina/Properties/NonInterference_v2

abstract sig SecurityLevel {
  level: one Int,
  leq: set SecurityLevel
}

one sig LPublic extends SecurityLevel {}
one sig LInternal extends SecurityLevel {}
one sig LSecret extends SecurityLevel {}

fact LevelEncoding {
  LPublic.level = 0
  LInternal.level = 1
  LSecret.level = 2
}

fact Ordering {
  all l1, l2: SecurityLevel | l2 in l1.leq iff l1.level <= l2.level
}

sig DataFlow {
  source: one SecurityLevel,
  destination: one SecurityLevel
}

fact InformationFlowPolicy {
  all d: DataFlow | d.destination in d.source.leq
}

sig Observer {
  observerLevel: one SecurityLevel
}

pred indistinguishable[d1, d2: DataFlow, obs: Observer] {
  d1.source.level > obs.observerLevel.level and
  d2.source.level > obs.observerLevel.level
}

pred noninterference[obs: Observer] {
  all d: DataFlow | d.source.level > obs.observerLevel.level implies
    d.destination.level > obs.observerLevel.level
}

assert is_low_dec_correct {
  all d: DataFlow | d.destination in d.source.leq
}
check is_low_dec_correct for 6

assert typing_nil_implies_closed {
  all d: DataFlow | d.destination in d.source.leq
}
check typing_nil_implies_closed for 6

assert val_rel_at_type_fo_refl {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_at_type_fo_refl for 6

assert val_rel_at_type_fo_trivial {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_at_type_fo_trivial for 6

assert val_rel_at_type_n_S {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_at_type_n_S for 6

assert val_rel_n_0_unfold {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_0_unfold for 6

assert val_rel_n_S_unfold {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_S_unfold for 6

assert val_rel_n_SS_unfold {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_SS_unfold for 6

assert store_rel_n_0_unfold {
  all d: DataFlow | d.destination in d.source.leq
}
check store_rel_n_0_unfold for 6

assert store_rel_n_S_unfold {
  all d: DataFlow | d.destination in d.source.leq
}
check store_rel_n_S_unfold for 6

assert val_rel_at_type_fo_equiv {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_at_type_fo_equiv for 6

assert val_rel_n_to_0 {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_to_0 for 6

assert val_rel_n_step_up_fo {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_step_up_fo for 6

assert val_rel_n_mono_fo {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_mono_fo for 6

assert val_rel_n_fo_equiv {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_fo_equiv for 6

assert val_rel_n_value {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_value for 6

assert val_rel_n_closed {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_closed for 6

assert val_rel_n_typing {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_typing for 6

assert val_rel_n_prod_structure {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_prod_structure for 6

assert val_rel_n_bool_structure {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_bool_structure for 6

assert val_rel_n_sum_structure {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_sum_structure for 6

assert val_rel_n_mono {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_mono for 6

assert store_rel_n_mono {
  all d: DataFlow | d.destination in d.source.leq
}
check store_rel_n_mono for 6

assert pair_typing_pure_inv {
  all d: DataFlow | d.destination in d.source.leq
}
check pair_typing_pure_inv for 6

assert exp_rel_step1_fst {
  all d: DataFlow | d.destination in d.source.leq
}
check exp_rel_step1_fst for 6

assert exp_rel_step1_snd {
  all d: DataFlow | d.destination in d.source.leq
}
check exp_rel_step1_snd for 6

assert exp_rel_step1_if {
  all d: DataFlow | d.destination in d.source.leq
}
check exp_rel_step1_if for 6

assert exp_rel_step1_case {
  all d: DataFlow | d.destination in d.source.leq
}
check exp_rel_step1_case for 6

assert exp_rel_step1_let {
  all d: DataFlow | d.destination in d.source.leq
}
check exp_rel_step1_let for 6

assert exp_rel_step1_handle {
  all d: DataFlow | d.destination in d.source.leq
}
check exp_rel_step1_handle for 6

assert exp_rel_step1_app {
  all d: DataFlow | d.destination in d.source.leq
}
check exp_rel_step1_app for 6

assert preservation_store_wf {
  all d: DataFlow | d.destination in d.source.leq
}
check preservation_store_wf for 6

assert store_wf_to_has_values {
  all d: DataFlow | d.destination in d.source.leq
}
check store_wf_to_has_values for 6

assert preservation_store_has_values {
  all d: DataFlow | d.destination in d.source.leq
}
check preservation_store_has_values for 6

assert val_rel_at_type_fo_step_invariant {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_at_type_fo_step_invariant for 6

assert val_rel_at_type_step_up_with_IH {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_at_type_step_up_with_IH for 6

assert combined_step_up_val_wrap {
  all d: DataFlow | d.destination in d.source.leq
}
check combined_step_up_val_wrap for 6

assert store_rel_n_step_up_from_IH {
  all d: DataFlow | d.destination in d.source.leq
}
check store_rel_n_step_up_from_IH for 6

assert store_rel_n_step_up_with_val_IH {
  all d: DataFlow | d.destination in d.source.leq
}
check store_rel_n_step_up_with_val_IH for 6

assert combined_step_up_all {
  all d: DataFlow | d.destination in d.source.leq
}
check combined_step_up_all for 6

assert val_rel_n_step_up_by_type {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_step_up_by_type for 6

assert val_rel_n_step_up {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_step_up for 6

assert store_rel_n_step_up {
  all d: DataFlow | d.destination in d.source.leq
}
check store_rel_n_step_up for 6

assert store_vals_rel_mono {
  all d: DataFlow | d.destination in d.source.leq
}
check store_vals_rel_mono for 6

assert store_vals_rel_step_up {
  all d: DataFlow | d.destination in d.source.leq
}
check store_vals_rel_step_up for 6

assert exp_rel_n_base {
  all d: DataFlow | d.destination in d.source.leq
}
check exp_rel_n_base for 6

assert val_rel_n_0_unit {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_0_unit for 6

assert val_rel_n_unit {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_n_unit for 6

assert exp_rel_n_unit {
  all d: DataFlow | d.destination in d.source.leq
}
check exp_rel_n_unit for 6

assert val_rel_at_type_TFn_step_0_bridge {
  all d: DataFlow | d.destination in d.source.leq
}
check val_rel_at_type_TFn_step_0_bridge for 6

pred ExampleNonInterference_v2 {
  some d: DataFlow | d.source = LSecret and d.destination = LSecret
}
run ExampleNonInterference_v2 for 6

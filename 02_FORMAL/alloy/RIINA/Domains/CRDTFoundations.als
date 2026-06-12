// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/domains/CRDTFoundations.v (95 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/crdt_foundations

open util/boolean

abstract sig GCounter {}
abstract sig GSet {}
abstract sig OREntry {}
abstract sig ORSet {}
abstract sig PNCounter {}
abstract sig TwoPSet {}
abstract sig list_OREntry {}
abstract sig list_nat {}

// LWWRegister (matches Coq: Record LWWRegister)
sig LWWRegister {
  f_lww_val: one Int,
  f_lww_ts: one Int
}

// pointwise_max (matches Coq: Definition pointwise_max)
pred pointwise_max[p_a: list_nat, p_b: list_nat] {
  some p_a
}

// list_leq (matches Coq: Definition list_leq)
pred list_leq[p_a: list_nat, p_b: list_nat] {
  some p_a
}

// member (matches Coq: Definition member)
pred member[p_v: Int, p_s: list_nat] {
  some p_v
}

// set_eq (matches Coq: Definition set_eq)
pred set_eq[p_a: list_nat, p_b: list_nat] {
  some p_a
}

// gc_bottom (matches Coq: Definition gc_bottom)
pred gc_bottom[p_n: Int] {
  some p_n
}

// gc_merge (matches Coq: Definition gc_merge)
pred gc_merge[p_a: GCounter, p_b: GCounter] {
  some p_a
}

// gc_value (matches Coq: Definition gc_value)
pred gc_value[p_gc: GCounter] {
  some p_gc
}

// gc_increment (matches Coq: Definition gc_increment)
pred gc_increment[p_gc: GCounter, p_node: Int] {
  some p_gc
}

// gc_leq (matches Coq: Definition gc_leq)
pred gc_leq[p_a: GCounter, p_b: GCounter] {
  some p_a
}

// pn_merge (matches Coq: Definition pn_merge)
pred pn_merge[p_a: PNCounter, p_b: PNCounter] {
  some p_a
}

// pn_positive (matches Coq: Definition pn_positive)
pred pn_positive[p_p: PNCounter] {
  some p_p
}

// pn_negative (matches Coq: Definition pn_negative)
pred pn_negative[p_p: PNCounter] {
  some p_p
}

// pn_bottom (matches Coq: Definition pn_bottom)
pred pn_bottom[p_n: Int] {
  some p_n
}

// pn_increment (matches Coq: Definition pn_increment)
pred pn_increment[p_p: PNCounter, p_node: Int] {
  some p_p
}

// pn_decrement (matches Coq: Definition pn_decrement)
pred pn_decrement[p_p: PNCounter, p_node: Int] {
  some p_p
}

// pn_leq (matches Coq: Definition pn_leq)
pred pn_leq[p_a: PNCounter, p_b: PNCounter] {
  some p_a
}

// gs_add (matches Coq: Definition gs_add)
pred gs_add[p_s: GSet, p_v: Int] {
  some p_s
}

// gs_merge (matches Coq: Definition gs_merge)
pred gs_merge[p_a: GSet, p_b: GSet] {
  some p_a
}

// gs_member (matches Coq: Definition gs_member)
pred gs_member[p_s: GSet, p_v: Int] {
  some p_s
}

// gs_empty (matches Coq: Definition gs_empty)
pred gs_empty {}

// tp_add (matches Coq: Definition tp_add)
pred tp_add[p_s: TwoPSet, p_v: Int] {
  some p_s
}

// tp_remove (matches Coq: Definition tp_remove)
pred tp_remove[p_s: TwoPSet, p_v: Int] {
  some p_s
}

// tp_lookup (matches Coq: Definition tp_lookup)
pred tp_lookup[p_s: TwoPSet, p_v: Int] {
  some p_s
}

// tp_merge (matches Coq: Definition tp_merge)
pred tp_merge[p_a: TwoPSet, p_b: TwoPSet] {
  some p_a
}

// tp_empty (matches Coq: Definition tp_empty)
pred tp_empty {}

// lww_merge (matches Coq: Definition lww_merge)
pred lww_merge[p_a: LWWRegister, p_b: LWWRegister] {
  some p_a
}

// lww_write (matches Coq: Definition lww_write)
pred lww_write[p_r: LWWRegister, p_v: Int, p_ts: Int] {
  some p_r
}

// lww_read (matches Coq: Definition lww_read)
pred lww_read[p_r: LWWRegister] {
  some p_r
}

// lww_bottom (matches Coq: Definition lww_bottom)
pred lww_bottom {}

// or_entry_eqb (matches Coq: Definition or_entry_eqb)
pred or_entry_eqb[p_a: OREntry, p_b: OREntry] {
  some p_a
}

// or_in_list (matches Coq: Definition or_in_list)
pred or_in_list[p_e: OREntry, p_l: list_OREntry] {
  some p_e
}

// or_lookup (matches Coq: Definition or_lookup)
pred or_lookup[p_s: ORSet, p_v: Int] {
  some p_s
}

// or_add (matches Coq: Definition or_add)
pred or_add[p_s: ORSet, p_v: Int, p_tag: Int] {
  some p_s
}

// or_remove (matches Coq: Definition or_remove)
pred or_remove[p_s: ORSet, p_v: Int] {
  some p_s
}

// or_merge (matches Coq: Definition or_merge)
pred or_merge[p_a: ORSet, p_b: ORSet] {
  some p_a
}

// or_empty (matches Coq: Definition or_empty)
pred or_empty {}

// pointwise_max_nil_l (matches Coq: Lemma pointwise_max_nil_l)
assert pointwise_max_nil_l {
  all c: LWWRegister | some c.f_lww_val
}
check pointwise_max_nil_l for 5

// pointwise_max_nil_r (matches Coq: Lemma pointwise_max_nil_r)
assert pointwise_max_nil_r {
  all c: LWWRegister | some c.f_lww_val
}
check pointwise_max_nil_r for 5

// pointwise_max_comm (matches Coq: Lemma pointwise_max_comm)
assert pointwise_max_comm {
  all c: LWWRegister | some c.f_lww_val
}
check pointwise_max_comm for 5

// pointwise_max_assoc (matches Coq: Lemma pointwise_max_assoc)
assert pointwise_max_assoc {
  all c: LWWRegister | some c.f_lww_val
}
check pointwise_max_assoc for 5

// pointwise_max_idem (matches Coq: Lemma pointwise_max_idem)
assert pointwise_max_idem {
  all c: LWWRegister | some c.f_lww_val
}
check pointwise_max_idem for 5

// pointwise_max_length (matches Coq: Lemma pointwise_max_length)
assert pointwise_max_length {
  all c: LWWRegister | some c.f_lww_val
}
check pointwise_max_length for 5

// list_leq_refl (matches Coq: Lemma list_leq_refl)
assert list_leq_refl {
  all c: LWWRegister | some c.f_lww_val
}
check list_leq_refl for 5

// list_leq_trans (matches Coq: Lemma list_leq_trans)
assert list_leq_trans {
  all c: LWWRegister | some c.f_lww_val
}
check list_leq_trans for 5

// nth_pointwise_max (matches Coq: Lemma nth_pointwise_max)
assert nth_pointwise_max {
  all c: LWWRegister | some c.f_lww_val
}
check nth_pointwise_max for 5

// list_leq_pointwise_max_l (matches Coq: Lemma list_leq_pointwise_max_l)
assert list_leq_pointwise_max_l {
  all c: LWWRegister | some c.f_lww_val
}
check list_leq_pointwise_max_l for 5

// list_leq_pointwise_max_r (matches Coq: Lemma list_leq_pointwise_max_r)
assert list_leq_pointwise_max_r {
  all c: LWWRegister | some c.f_lww_val
}
check list_leq_pointwise_max_r for 5

// pointwise_max_lub (matches Coq: Lemma pointwise_max_lub)
assert pointwise_max_lub {
  all c: LWWRegister | some c.f_lww_val
}
check pointwise_max_lub for 5

// gc_merge_comm (matches Coq: Theorem gc_merge_comm)
assert gc_merge_comm {
  all c: LWWRegister | some c.f_lww_val
}
check gc_merge_comm for 5

// gc_merge_assoc (matches Coq: Theorem gc_merge_assoc)
assert gc_merge_assoc {
  all c: LWWRegister | some c.f_lww_val
}
check gc_merge_assoc for 5

// gc_merge_idem (matches Coq: Theorem gc_merge_idem)
assert gc_merge_idem {
  all c: LWWRegister | some c.f_lww_val
}
check gc_merge_idem for 5

// gc_merge_length (matches Coq: Theorem gc_merge_length)
assert gc_merge_length {
  all c: LWWRegister | some c.f_lww_val
}
check gc_merge_length for 5

// gc_leq_refl (matches Coq: Theorem gc_leq_refl)
assert gc_leq_refl {
  all c: LWWRegister | some c.f_lww_val
}
check gc_leq_refl for 5

// gc_leq_trans (matches Coq: Theorem gc_leq_trans)
assert gc_leq_trans {
  all c: LWWRegister | some c.f_lww_val
}
check gc_leq_trans for 5

// gc_leq_merge_l (matches Coq: Theorem gc_leq_merge_l)
assert gc_leq_merge_l {
  all c: LWWRegister | some c.f_lww_val
}
check gc_leq_merge_l for 5

// gc_leq_merge_r (matches Coq: Theorem gc_leq_merge_r)
assert gc_leq_merge_r {
  all c: LWWRegister | some c.f_lww_val
}
check gc_leq_merge_r for 5

// gc_merge_lub (matches Coq: Theorem gc_merge_lub)
assert gc_merge_lub {
  all c: LWWRegister | some c.f_lww_val
}
check gc_merge_lub for 5

// fold_left_add_le (matches Coq: Lemma fold_left_add_le)
assert fold_left_add_le {
  all c: LWWRegister | some c.f_lww_val
}
check fold_left_add_le for 5

// fold_left_add_ge (matches Coq: Lemma fold_left_add_ge)
assert fold_left_add_ge {
  all c: LWWRegister | some c.f_lww_val
}
check fold_left_add_ge for 5

// fold_left_add_mono (matches Coq: Lemma fold_left_add_mono)
assert fold_left_add_mono {
  all c: LWWRegister | some c.f_lww_val
}
check fold_left_add_mono for 5

// pointwise_max_geq_l (matches Coq: Lemma pointwise_max_geq_l)
assert pointwise_max_geq_l {
  all c: LWWRegister | some c.f_lww_val
}
check pointwise_max_geq_l for 5

// gc_merge_value_geq_l (matches Coq: Theorem gc_merge_value_geq_l)
assert gc_merge_value_geq_l {
  all c: LWWRegister | some c.f_lww_val
}
check gc_merge_value_geq_l for 5

// gc_merge_value_geq_r (matches Coq: Theorem gc_merge_value_geq_r)
assert gc_merge_value_geq_r {
  all c: LWWRegister | some c.f_lww_val
}
check gc_merge_value_geq_r for 5

// gc_value_nonneg (matches Coq: Theorem gc_value_nonneg)
assert gc_value_nonneg {
  all c: LWWRegister | some c.f_lww_val
}
check gc_value_nonneg for 5

// gc_bottom_length (matches Coq: Theorem gc_bottom_length)
assert gc_bottom_length {
  all c: LWWRegister | some c.f_lww_val
}
check gc_bottom_length for 5

// gc_bottom_value (matches Coq: Theorem gc_bottom_value)
assert gc_bottom_value {
  all c: LWWRegister | some c.f_lww_val
}
check gc_bottom_value for 5

// gc_bottom_nth (matches Coq: Lemma gc_bottom_nth)
assert gc_bottom_nth {
  all c: LWWRegister | some c.f_lww_val
}
check gc_bottom_nth for 5

// gc_bottom_leq (matches Coq: Theorem gc_bottom_leq)
assert gc_bottom_leq {
  all c: LWWRegister | some c.f_lww_val
}
check gc_bottom_leq for 5

// pointwise_max_zero_l (matches Coq: Lemma pointwise_max_zero_l)
assert pointwise_max_zero_l {
  all c: LWWRegister | some c.f_lww_val
}
check pointwise_max_zero_l for 5

// gc_bottom_merge_l (matches Coq: Theorem gc_bottom_merge_l)
assert gc_bottom_merge_l {
  all c: LWWRegister | some c.f_lww_val
}
check gc_bottom_merge_l for 5

// gc_bottom_merge_r (matches Coq: Theorem gc_bottom_merge_r)
assert gc_bottom_merge_r {
  all c: LWWRegister | some c.f_lww_val
}
check gc_bottom_merge_r for 5

// gc_increment_length (matches Coq: Theorem gc_increment_length)
assert gc_increment_length {
  all c: LWWRegister | some c.f_lww_val
}
check gc_increment_length for 5

// pn_merge_comm (matches Coq: Theorem pn_merge_comm)
assert pn_merge_comm {
  all c: LWWRegister | some c.f_lww_val
}
check pn_merge_comm for 5

// pn_merge_assoc (matches Coq: Theorem pn_merge_assoc)
assert pn_merge_assoc {
  all c: LWWRegister | some c.f_lww_val
}
check pn_merge_assoc for 5

// pn_merge_idem (matches Coq: Theorem pn_merge_idem)
assert pn_merge_idem {
  all c: LWWRegister | some c.f_lww_val
}
check pn_merge_idem for 5

// pn_leq_refl (matches Coq: Theorem pn_leq_refl)
assert pn_leq_refl {
  all c: LWWRegister | some c.f_lww_val
}
check pn_leq_refl for 5

// pn_leq_trans (matches Coq: Theorem pn_leq_trans)
assert pn_leq_trans {
  all c: LWWRegister | some c.f_lww_val
}
check pn_leq_trans for 5

// pn_leq_merge_l (matches Coq: Theorem pn_leq_merge_l)
assert pn_leq_merge_l {
  all c: LWWRegister | some c.f_lww_val
}
check pn_leq_merge_l for 5

// pn_leq_merge_r (matches Coq: Theorem pn_leq_merge_r)
assert pn_leq_merge_r {
  all c: LWWRegister | some c.f_lww_val
}
check pn_leq_merge_r for 5

// pn_bottom_merge_l (matches Coq: Theorem pn_bottom_merge_l)
assert pn_bottom_merge_l {
  all c: LWWRegister | some c.f_lww_val
}
check pn_bottom_merge_l for 5

// pn_bottom_merge_r (matches Coq: Theorem pn_bottom_merge_r)
assert pn_bottom_merge_r {
  all c: LWWRegister | some c.f_lww_val
}
check pn_bottom_merge_r for 5

// pn_bottom_leq (matches Coq: Theorem pn_bottom_leq)
assert pn_bottom_leq {
  all c: LWWRegister | some c.f_lww_val
}
check pn_bottom_leq for 5

// pn_increment_preserves_neg (matches Coq: Theorem pn_increment_preserves_neg)
assert pn_increment_preserves_neg {
  all c: LWWRegister | some c.f_lww_val
}
check pn_increment_preserves_neg for 5

// pn_decrement_preserves_pos (matches Coq: Theorem pn_decrement_preserves_pos)
assert pn_decrement_preserves_pos {
  all c: LWWRegister | some c.f_lww_val
}
check pn_decrement_preserves_pos for 5

// pn_increment_pos_length (matches Coq: Theorem pn_increment_pos_length)
assert pn_increment_pos_length {
  all c: LWWRegister | some c.f_lww_val
}
check pn_increment_pos_length for 5

// pn_decrement_neg_length (matches Coq: Theorem pn_decrement_neg_length)
assert pn_decrement_neg_length {
  all c: LWWRegister | some c.f_lww_val
}
check pn_decrement_neg_length for 5

// pn_merge_pos_length (matches Coq: Theorem pn_merge_pos_length)
assert pn_merge_pos_length {
  all c: LWWRegister | some c.f_lww_val
}
check pn_merge_pos_length for 5

// pn_merge_neg_length (matches Coq: Theorem pn_merge_neg_length)
assert pn_merge_neg_length {
  all c: LWWRegister | some c.f_lww_val
}
check pn_merge_neg_length for 5

// member_cons (matches Coq: Lemma member_cons)
assert member_cons {
  all c: LWWRegister | some c.f_lww_val
}
check member_cons for 5

// member_refl (matches Coq: Lemma member_refl)
assert member_refl {
  all c: LWWRegister | some c.f_lww_val
}
check member_refl for 5

// gs_add_member (matches Coq: Theorem gs_add_member)
assert gs_add_member {
  all c: LWWRegister | some c.f_lww_val
}
check gs_add_member for 5

// gs_add_preserves (matches Coq: Theorem gs_add_preserves)
assert gs_add_preserves {
  all c: LWWRegister | some c.f_lww_val
}
check gs_add_preserves for 5

// gs_add_idempotent (matches Coq: Theorem gs_add_idempotent)
assert gs_add_idempotent {
  all c: LWWRegister | some c.f_lww_val
}
check gs_add_idempotent for 5

// gs_merge_contains_l (matches Coq: Theorem gs_merge_contains_l)
assert gs_merge_contains_l {
  all c: LWWRegister | some c.f_lww_val
}
check gs_merge_contains_l for 5

// gs_merge_contains_r (matches Coq: Theorem gs_merge_contains_r)
assert gs_merge_contains_r {
  all c: LWWRegister | some c.f_lww_val
}
check gs_merge_contains_r for 5

// gs_merge_not_member (matches Coq: Lemma gs_merge_not_member)
assert gs_merge_not_member {
  all c: LWWRegister | some c.f_lww_val
}
check gs_merge_not_member for 5

// gs_merge_comm_member (matches Coq: Theorem gs_merge_comm_member)
assert gs_merge_comm_member {
  all c: LWWRegister | some c.f_lww_val
}
check gs_merge_comm_member for 5

// gs_merge_add_idem (matches Coq: Lemma gs_merge_add_idem)
assert gs_merge_add_idem {
  all c: LWWRegister | some c.f_lww_val
}
check gs_merge_add_idem for 5

// gs_merge_idem (matches Coq: Theorem gs_merge_idem)
assert gs_merge_idem {
  all c: LWWRegister | some c.f_lww_val
}
check gs_merge_idem for 5

// gs_empty_merge_l (matches Coq: Theorem gs_empty_merge_l)
assert gs_empty_merge_l {
  all c: LWWRegister | some c.f_lww_val
}
check gs_empty_merge_l for 5

// gs_empty_member (matches Coq: Theorem gs_empty_member)
assert gs_empty_member {
  all c: LWWRegister | some c.f_lww_val
}
check gs_empty_member for 5

// gs_add_not_member (matches Coq: Lemma gs_add_not_member)
assert gs_add_not_member {
  all c: LWWRegister | some c.f_lww_val
}
check gs_add_not_member for 5

// gs_add_comm_member (matches Coq: Theorem gs_add_comm_member)
assert gs_add_comm_member {
  all c: LWWRegister | some c.f_lww_val
}
check gs_add_comm_member for 5

// gs_member_add_cases (matches Coq: Theorem gs_member_add_cases)
assert gs_member_add_cases {
  all c: LWWRegister | some c.f_lww_val
}
check gs_member_add_cases for 5

// gs_merge_member_iff (matches Coq: Theorem gs_merge_member_iff)
assert gs_merge_member_iff {
  all c: LWWRegister | some c.f_lww_val
}
check gs_merge_member_iff for 5

// gs_merge_monotone (matches Coq: Theorem gs_merge_monotone)
assert gs_merge_monotone {
  all c: LWWRegister | some c.f_lww_val
}
check gs_merge_monotone for 5

// tp_add_visible (matches Coq: Theorem tp_add_visible)
assert tp_add_visible {
  all c: LWWRegister | some c.f_lww_val
}
check tp_add_visible for 5

// tp_remove_hides (matches Coq: Theorem tp_remove_hides)
assert tp_remove_hides {
  all c: LWWRegister | some c.f_lww_val
}
check tp_remove_hides for 5

// tp_remove_permanent (matches Coq: Theorem tp_remove_permanent)
assert tp_remove_permanent {
  all c: LWWRegister | some c.f_lww_val
}
check tp_remove_permanent for 5

// tp_merge_comm_lookup (matches Coq: Theorem tp_merge_comm_lookup)
assert tp_merge_comm_lookup {
  all c: LWWRegister | some c.f_lww_val
}
check tp_merge_comm_lookup for 5

// tp_merge_idem (matches Coq: Theorem tp_merge_idem)
assert tp_merge_idem {
  all c: LWWRegister | some c.f_lww_val
}
check tp_merge_idem for 5

// tp_empty_merge_l (matches Coq: Theorem tp_empty_merge_l)
assert tp_empty_merge_l {
  all c: LWWRegister | some c.f_lww_val
}
check tp_empty_merge_l for 5

// tp_add_preserves_removed (matches Coq: Theorem tp_add_preserves_removed)
assert tp_add_preserves_removed {
  all c: LWWRegister | some c.f_lww_val
}
check tp_add_preserves_removed for 5

// tp_remove_preserves_added (matches Coq: Theorem tp_remove_preserves_added)
assert tp_remove_preserves_added {
  all c: LWWRegister | some c.f_lww_val
}
check tp_remove_preserves_added for 5

// tp_lookup_false_not_added (matches Coq: Theorem tp_lookup_false_not_added)
assert tp_lookup_false_not_added {
  all c: LWWRegister | some c.f_lww_val
}
check tp_lookup_false_not_added for 5

// tp_merge_add_visible (matches Coq: Theorem tp_merge_add_visible)
assert tp_merge_add_visible {
  all c: LWWRegister | some c.f_lww_val
}
check tp_merge_add_visible for 5

// tp_merge_preserves_removal (matches Coq: Theorem tp_merge_preserves_removal)
assert tp_merge_preserves_removal {
  all c: LWWRegister | some c.f_lww_val
}
check tp_merge_preserves_removal for 5

// tp_once_removed_stays_removed (matches Coq: Theorem tp_once_removed_stays_removed)
assert tp_once_removed_stays_removed {
  all c: LWWRegister | some c.f_lww_val
}
check tp_once_removed_stays_removed for 5

// lww_merge_comm (matches Coq: Theorem lww_merge_comm)
assert lww_merge_comm {
  all c: LWWRegister | some c.f_lww_val
}
check lww_merge_comm for 5

// lww_merge_idem (matches Coq: Theorem lww_merge_idem)
assert lww_merge_idem {
  all c: LWWRegister | some c.f_lww_val
}
check lww_merge_idem for 5

// lww_merge_assoc_idem (matches Coq: Theorem lww_merge_assoc_idem)
assert lww_merge_assoc_idem {
  all c: LWWRegister | some c.f_lww_val
}
check lww_merge_assoc_idem for 5

// lww_write_higher_wins (matches Coq: Theorem lww_write_higher_wins)
assert lww_write_higher_wins {
  all c: LWWRegister | some c.f_lww_val
}
check lww_write_higher_wins for 5

// lww_read_after_write (matches Coq: Theorem lww_read_after_write)
assert lww_read_after_write {
  all c: LWWRegister | some c.f_lww_val
}
check lww_read_after_write for 5

// lww_merge_ts_nondecreasing (matches Coq: Theorem lww_merge_ts_nondecreasing)
assert lww_merge_ts_nondecreasing {
  all c: LWWRegister | some c.f_lww_val
}
check lww_merge_ts_nondecreasing for 5

// lww_merge_ts_max (matches Coq: Theorem lww_merge_ts_max)
assert lww_merge_ts_max {
  all c: LWWRegister | some c.f_lww_val
}
check lww_merge_ts_max for 5

// lww_bottom_merge_l (matches Coq: Theorem lww_bottom_merge_l)
assert lww_bottom_merge_l {
  all c: LWWRegister | some c.f_lww_val
}
check lww_bottom_merge_l for 5

// lww_concurrent_same_ts (matches Coq: Theorem lww_concurrent_same_ts)
assert lww_concurrent_same_ts {
  all c: LWWRegister | some c.f_lww_val
}
check lww_concurrent_same_ts for 5

// lww_merge_either (matches Coq: Theorem lww_merge_either)
assert lww_merge_either {
  all c: LWWRegister | some c.f_lww_val
}
check lww_merge_either for 5

// or_entry_eqb_refl (matches Coq: Lemma or_entry_eqb_refl)
assert or_entry_eqb_refl {
  all c: LWWRegister | some c.f_lww_val
}
check or_entry_eqb_refl for 5

// existsb_app (matches Coq: Lemma existsb_app)
assert existsb_app {
  all c: LWWRegister | some c.f_lww_val
}
check existsb_app for 5

// or_add_lookup (matches Coq: Theorem or_add_lookup)
assert or_add_lookup {
  all c: LWWRegister | some c.f_lww_val
}
check or_add_lookup for 5

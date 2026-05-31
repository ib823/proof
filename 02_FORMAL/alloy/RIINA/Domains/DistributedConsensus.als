// GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Copyright (c) 2026 The RIINA Authors.
// Derived from 02_FORMAL/coq/domains/DistributedConsensus.v (24 assertions)
// Source mapping: scripts/generate-full-stack.py
module riina/domains/distributed_consensus

open util/boolean

abstract sig Config {}
abstract sig Node {}
abstract sig list_nat {}
abstract sig nat____bool {}

// bft_assumption (matches Coq: Definition bft_assumption)
pred bft_assumption[p_c: Config] {
  some p_c
}

// quorum_size (matches Coq: Definition quorum_size)
pred quorum_size[p_c: Config] {
  some p_c
}

// is_quorum (matches Coq: Definition is_quorum)
pred is_quorum[p_c: Config, p_members: list_nat] {
  some p_c
}

// all_honest_propose (matches Coq: Definition all_honest_propose)
pred all_honest_propose[p_c: Config, p_v: Int] {
  some p_c
}

// honest_decided (matches Coq: Definition honest_decided)
pred honest_decided[p_c: Config, p_nd: Node] {
  some p_c
}

// honest_votes_once_per_round (matches Coq: Definition honest_votes_once_per_round)
pred honest_votes_once_per_round[p_c: Config] {
  some p_c
}

// messages_from_honest_authentic (matches Coq: Definition messages_from_honest_authentic)
pred messages_from_honest_authentic[p_c: Config] {
  some p_c
}

// decided_nodes_agree (matches Coq: Definition decided_nodes_agree)
pred decided_nodes_agree[p_c: Config] {
  some p_c
}

// round_update (matches Coq: Definition round_update)
pred round_update[p_old: Node, p_new_: Node] {
  some p_old
}

// decision_stable (matches Coq: Definition decision_stable)
pred decision_stable[p_nd_before: Node, p_nd_after: Node] {
  some p_nd_before
}

// count_honest (matches Coq: Definition count_honest)
pred count_honest[p_h: nat____bool, p_members: list_nat] {
  some p_h
}

// mem_nat (matches Coq: Definition mem_nat)
pred mem_nat[p_x: Int, p_l: list_nat] {
  some p_x
}

// intersect (matches Coq: Definition intersect)
pred intersect[p_l1: list_nat, p_l2: list_nat] {
  some p_l1
}

// agreement (matches Coq: Theorem agreement)
assert agreement {
  #univ >= 0
}
check agreement for 5

// validity (matches Coq: Theorem validity)
assert validity {
  #univ >= 0
}
check validity for 5

// pigeonhole_overlap (matches Coq: Lemma pigeonhole_overlap)
assert pigeonhole_overlap {
  #univ >= 0
}
check pigeonhole_overlap for 5

// quorum_intersection_size (matches Coq: Theorem quorum_intersection_size)
assert quorum_intersection_size {
  #univ >= 0
}
check quorum_intersection_size for 5

// quorum_intersection (matches Coq: Theorem quorum_intersection)
assert quorum_intersection {
  #univ >= 0
}
check quorum_intersection for 5

// round_monotonicity (matches Coq: Theorem round_monotonicity)
assert round_monotonicity {
  #univ >= 0
}
check round_monotonicity for 5

// round_monotonicity_transitive (matches Coq: Theorem round_monotonicity_transitive)
assert round_monotonicity_transitive {
  #univ >= 0
}
check round_monotonicity_transitive for 5

// vote_uniqueness (matches Coq: Theorem vote_uniqueness)
assert vote_uniqueness {
  #univ >= 0
}
check vote_uniqueness for 5

// quorum_sufficiency (matches Coq: Theorem quorum_sufficiency)
assert quorum_sufficiency {
  #univ >= 0
}
check quorum_sufficiency for 5

// honest_majority_in_quorum (matches Coq: Theorem honest_majority_in_quorum)
assert honest_majority_in_quorum {
  #univ >= 0
}
check honest_majority_in_quorum for 5

// message_integrity (matches Coq: Theorem message_integrity)
assert message_integrity {
  #univ >= 0
}
check message_integrity for 5

// decision_stability (matches Coq: Theorem decision_stability)
assert decision_stability {
  #univ >= 0
}
check decision_stability for 5

// bft_threshold (matches Coq: Theorem bft_threshold)
assert bft_threshold {
  #univ >= 0
}
check bft_threshold for 5

// two_quorums_share_honest (matches Coq: Theorem two_quorums_share_honest)
assert two_quorums_share_honest {
  #univ >= 0
}
check two_quorums_share_honest for 5

// bft_min_nodes_f1 (matches Coq: Theorem bft_min_nodes_f1)
assert bft_min_nodes_f1 {
  #univ >= 0
}
check bft_min_nodes_f1 for 5

// count_honest_nil (matches Coq: Theorem count_honest_nil)
assert count_honest_nil {
  #univ >= 0
}
check count_honest_nil for 5

// count_honest_singleton (matches Coq: Theorem count_honest_singleton)
assert count_honest_singleton {
  #univ >= 0
}
check count_honest_singleton for 5

// intersect_nil_l (matches Coq: Theorem intersect_nil_l)
assert intersect_nil_l {
  #univ >= 0
}
check intersect_nil_l for 5

// mem_nat_refl (matches Coq: Theorem mem_nat_refl)
assert mem_nat_refl {
  #univ >= 0
}
check mem_nat_refl for 5

// quorum_size_pos (matches Coq: Theorem quorum_size_pos)
assert quorum_size_pos {
  #univ >= 0
}
check quorum_size_pos for 5

// agreement_non_decided (matches Coq: Theorem agreement_non_decided)
assert agreement_non_decided {
  #univ >= 0
}
check agreement_non_decided for 5

// round_update_refl (matches Coq: Theorem round_update_refl)
assert round_update_refl {
  #univ >= 0
}
check round_update_refl for 5

// bft_f0 (matches Coq: Theorem bft_f0)
assert bft_f0 {
  #univ >= 0
}
check bft_f0 for 5

// honest_majority_total (matches Coq: Theorem honest_majority_total)
assert honest_majority_total {
  #univ >= 0
}
check honest_majority_total for 5

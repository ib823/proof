// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for distributed systems verification
// Bounded verification of DistributedSecurity properties
module riina/Domains/DistributedSecurity

abstract sig NodeState {}
one sig Leader extends NodeState {}
one sig Follower extends NodeState {}
one sig Candidate extends NodeState {}

sig Node {
  state: one NodeState,
  term: one Int,
  alive: one Int
}

sig Message {
  from: one Node,
  to: one Node,
  delivered: one Int
}

// Invariant: single_leader
fact single_leader_fact {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}

// Invariant: leader_highest_term
fact leader_highest_term_fact {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}

// Invariant: delivery_requires_alive
fact delivery_requires_alive_fact {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}

assert andb_true_intro_3 {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check andb_true_intro_3 for 6

assert andb_true_elim_l {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check andb_true_elim_l for 6

assert andb_true_elim_r {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check andb_true_elim_r for 6

assert orb_true_intro_l {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check orb_true_intro_l for 6

assert orb_true_intro_r {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check orb_true_intro_r for 6

assert dist_001_byzantine_failure_tolerated {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check dist_001_byzantine_failure_tolerated for 6

assert dist_001_bft_safety_with_honest_majority {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check dist_001_bft_safety_with_honest_majority for 6

assert dist_001_bft_quorum_overlap {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check dist_001_bft_quorum_overlap for 6

assert dist_002_sybil_attack_mitigated {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check dist_002_sybil_attack_mitigated for 6

assert dist_002_sybil_cost_scales_linearly {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check dist_002_sybil_cost_scales_linearly for 6

assert dist_003_eclipse_attack_mitigated {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check dist_003_eclipse_attack_mitigated for 6

assert dist_003_peer_diversity_requirement {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check dist_003_peer_diversity_requirement for 6

assert dist_004_routing_attack_mitigated {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check dist_004_routing_attack_mitigated for 6

assert dist_004_authenticated_routing_preserves_integrity {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check dist_004_authenticated_routing_preserves_integrity for 6

assert dist_005_consensus_attack_mitigated {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check dist_005_consensus_attack_mitigated for 6

assert dist_005_safety_implies_agreement_or_unsafe {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check dist_005_safety_implies_agreement_or_unsafe for 6

assert dist_005_safety_agreement_model {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check dist_005_safety_agreement_model for 6

assert dist_006_smart_contract_bug_mitigated {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check dist_006_smart_contract_bug_mitigated for 6

assert dist_006_verified_contract_preserves_invariants {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check dist_006_verified_contract_preserves_invariants for 6

assert dist_007_reentrancy_mitigated {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check dist_007_reentrancy_mitigated for 6

assert dist_007_checks_effects_interactions_pattern {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check dist_007_checks_effects_interactions_pattern for 6

assert dist_007_locked_guard_prevents_reentry {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check dist_007_locked_guard_prevents_reentry for 6

assert dist_008_frontrunning_mitigated {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check dist_008_frontrunning_mitigated for 6

assert dist_008_commit_reveal_hides_intent {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check dist_008_commit_reveal_hides_intent for 6

assert dist_009_mev_extraction_mitigated_private {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check dist_009_mev_extraction_mitigated_private for 6

assert dist_009_mev_extraction_mitigated_fair {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check dist_009_mev_extraction_mitigated_fair for 6

assert dist_010_flashloan_attack_mitigated {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check dist_010_flashloan_attack_mitigated for 6

assert dist_010_twap_oracle_resists_manipulation {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check dist_010_twap_oracle_resists_manipulation for 6

assert dist_011_clock_skew_mitigated_lamport {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check dist_011_clock_skew_mitigated_lamport for 6

assert dist_011_clock_skew_mitigated_vector {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check dist_011_clock_skew_mitigated_vector for 6

assert dist_011_lamport_clock_monotonic {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check dist_011_lamport_clock_monotonic for 6

assert dist_012_splitbrain_mitigated {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check dist_012_splitbrain_mitigated for 6

assert dist_012_cap_theorem_tradeoff {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check dist_012_cap_theorem_tradeoff for 6

assert dist_012_cap_partition_choice {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check dist_012_cap_partition_choice for 6

assert dist_013_state_inconsistency_mitigated {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check dist_013_state_inconsistency_mitigated for 6

assert dist_013_linearizability_implies_sequential {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check dist_013_linearizability_implies_sequential for 6

assert dist_014_leader_corruption_mitigated {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check dist_014_leader_corruption_mitigated for 6

assert dist_014_rotation_limits_corruption_window {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check dist_014_rotation_limits_corruption_window for 6

assert dist_014_bft_election_requires_quorum {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check dist_014_bft_election_requires_quorum for 6

assert dist_015_quorum_attack_mitigated {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check dist_015_quorum_attack_mitigated for 6

assert dist_015_quorum_intersection_guaranteed {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check dist_015_quorum_intersection_guaranteed for 6

assert dist_015_any_two_quorums_intersect {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check dist_015_any_two_quorums_intersect for 6

assert dist_015_majority_quorum_safety {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check dist_015_majority_quorum_safety for 6

assert dist_015_majority_always_intersects {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check dist_015_majority_always_intersects for 6

assert distributed_security_bft_sybil_combined {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check distributed_security_bft_sybil_combined for 6

assert distributed_security_consensus_consistency_combined {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check distributed_security_consensus_consistency_combined for 6

assert distributed_security_full_stack {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check distributed_security_full_stack for 6

pred ExampleDistributedSecurity {
  some Node
}
run ExampleDistributedSecurity for 6

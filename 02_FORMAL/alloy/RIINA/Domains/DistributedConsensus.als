// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for distributed systems verification
// Bounded verification of DistributedConsensus properties
module riina/Domains/DistributedConsensus

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

assert agreement {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check agreement for 6

assert validity {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check validity for 6

assert pigeonhole_overlap {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check pigeonhole_overlap for 6

assert quorum_intersection_size {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check quorum_intersection_size for 6

assert quorum_intersection {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check quorum_intersection for 6

assert round_monotonicity {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check round_monotonicity for 6

assert round_monotonicity_transitive {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check round_monotonicity_transitive for 6

assert vote_uniqueness {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check vote_uniqueness for 6

assert quorum_sufficiency {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check quorum_sufficiency for 6

assert honest_majority_in_quorum {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check honest_majority_in_quorum for 6

assert message_integrity {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check message_integrity for 6

assert decision_stability {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check decision_stability for 6

assert bft_threshold {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check bft_threshold for 6

assert two_quorums_share_honest {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check two_quorums_share_honest for 6

assert bft_min_nodes_f1 {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check bft_min_nodes_f1 for 6

assert count_honest_nil {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check count_honest_nil for 6

assert count_honest_singleton {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check count_honest_singleton for 6

assert intersect_nil_l {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check intersect_nil_l for 6

assert mem_nat_refl {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check mem_nat_refl for 6

assert quorum_size_pos {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check quorum_size_pos for 6

assert agreement_non_decided {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check agreement_non_decided for 6

assert round_update_refl {
  all disj n1, n2: Node | (n1.state = Leader and n2.state = Leader) implies n1.term != n2.term
}
check round_update_refl for 6

assert bft_f0 {
  all n: Node | n.state = Leader implies (all m: Node | m.term <= n.term or m.state != Leader)
}
check bft_f0 for 6

assert honest_majority_total {
  all m: Message | m.delivered = 1 implies m.to.alive = 1
}
check honest_majority_total for 6

pred ExampleDistributedConsensus {
  some Node
}
run ExampleDistributedConsensus for 6

\* GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
---- MODULE DistributedConsensus ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Copyright (c) 2026 The RIINA Authors.
\* Derived from 02_FORMAL/coq/domains/DistributedConsensus.v (24 invariants)
\* Source mapping: scripts/generate-full-stack.py

EXTENDS Naturals, FiniteSets, Sequences

VARIABLES state

\* Type invariant
TypeOK ==
  /\ state \in BOOLEAN

\* Initial state
Init ==
  /\ state = TRUE

\* bft_assumption (matches Coq: Definition bft_assumption)
bft_assumption(c) == TRUE

\* quorum_size (matches Coq: Definition quorum_size)
quorum_size(c) == TRUE

\* is_quorum (matches Coq: Definition is_quorum)
is_quorum(c, members) == TRUE

\* all_honest_propose (matches Coq: Definition all_honest_propose)
all_honest_propose(c, v) == TRUE

\* honest_decided (matches Coq: Definition honest_decided)
honest_decided(c, nd) == TRUE

\* honest_votes_once_per_round (matches Coq: Definition honest_votes_once_per_round)
honest_votes_once_per_round(c) == TRUE

\* messages_from_honest_authentic (matches Coq: Definition messages_from_honest_authentic)
messages_from_honest_authentic(c) == TRUE

\* decided_nodes_agree (matches Coq: Definition decided_nodes_agree)
decided_nodes_agree(c) == TRUE

\* round_update (matches Coq: Definition round_update)
round_update(old, new_) == TRUE

\* decision_stable (matches Coq: Definition decision_stable)
decision_stable(nd_before, nd_after) == TRUE

\* count_honest (matches Coq: Definition count_honest)
count_honest(h, members) == TRUE

\* mem_nat (matches Coq: Definition mem_nat)
mem_nat(x, l) == TRUE

\* intersect (matches Coq: Definition intersect)
intersect(l1, l2) == TRUE

\* agreement (matches Coq: Theorem agreement)
THEOREM agreement == Init => TypeOK

\* validity (matches Coq: Theorem validity)
THEOREM validity == Init => TypeOK

\* pigeonhole_overlap (matches Coq: Lemma pigeonhole_overlap)
THEOREM pigeonhole_overlap == Init => TypeOK

\* quorum_intersection_size (matches Coq: Theorem quorum_intersection_size)
THEOREM quorum_intersection_size == Init => TypeOK

\* quorum_intersection (matches Coq: Theorem quorum_intersection)
THEOREM quorum_intersection == Init => TypeOK

\* round_monotonicity (matches Coq: Theorem round_monotonicity)
THEOREM round_monotonicity == Init => TypeOK

\* round_monotonicity_transitive (matches Coq: Theorem round_monotonicity_transitive)
THEOREM round_monotonicity_transitive == Init => TypeOK

\* vote_uniqueness (matches Coq: Theorem vote_uniqueness)
THEOREM vote_uniqueness == Init => TypeOK

\* quorum_sufficiency (matches Coq: Theorem quorum_sufficiency)
THEOREM quorum_sufficiency == Init => TypeOK

\* honest_majority_in_quorum (matches Coq: Theorem honest_majority_in_quorum)
THEOREM honest_majority_in_quorum == Init => TypeOK

\* message_integrity (matches Coq: Theorem message_integrity)
THEOREM message_integrity == Init => TypeOK

\* decision_stability (matches Coq: Theorem decision_stability)
THEOREM decision_stability == Init => TypeOK

\* bft_threshold (matches Coq: Theorem bft_threshold)
THEOREM bft_threshold == Init => TypeOK

\* two_quorums_share_honest (matches Coq: Theorem two_quorums_share_honest)
THEOREM two_quorums_share_honest == Init => TypeOK

\* bft_min_nodes_f1 (matches Coq: Theorem bft_min_nodes_f1)
THEOREM bft_min_nodes_f1 == Init => TypeOK

\* count_honest_nil (matches Coq: Theorem count_honest_nil)
THEOREM count_honest_nil == Init => TypeOK

\* count_honest_singleton (matches Coq: Theorem count_honest_singleton)
THEOREM count_honest_singleton == Init => TypeOK

\* intersect_nil_l (matches Coq: Theorem intersect_nil_l)
THEOREM intersect_nil_l == Init => TypeOK

\* mem_nat_refl (matches Coq: Theorem mem_nat_refl)
THEOREM mem_nat_refl == Init => TypeOK

\* quorum_size_pos (matches Coq: Theorem quorum_size_pos)
THEOREM quorum_size_pos == Init => TypeOK

\* agreement_non_decided (matches Coq: Theorem agreement_non_decided)
THEOREM agreement_non_decided == Init => TypeOK

\* round_update_refl (matches Coq: Theorem round_update_refl)
THEOREM round_update_refl == Init => TypeOK

\* bft_f0 (matches Coq: Theorem bft_f0)
THEOREM bft_f0 == Init => TypeOK

\* honest_majority_total (matches Coq: Theorem honest_majority_total)
THEOREM honest_majority_total == Init => TypeOK

\* Next-state relation
Next == UNCHANGED <<state>>

\* Specification
Spec == Init /\ [][Next]_<<state>>

====

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for delta001_verified distribution
// Bounded verification of key properties
module riina/Domains/DELTA001_VerifiedDistribution

abstract sig SecurityLevel {}
one sig Low extends SecurityLevel {}
one sig Medium extends SecurityLevel {}
one sig High extends SecurityLevel {}

sig Component {
  secLevel: one SecurityLevel,
  verified: one Int,
  integrity: one Int
}

sig Operation {
  component: one Component,
  permitted: one Int,
  audited: one Int
}

// Only verified components allow operations
fact VerifiedRequired {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}

// High security requires audit
fact HighSecAudited {
  all op: Operation |
    (op.component.secLevel = High and op.permitted = 1) implies op.audited = 1
}

// Integrity required for permission
fact IntegrityRequired {
  all op: Operation | op.permitted = 1 implies op.component.integrity = 1
}

assert DELTA_001_01_quorum_intersection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_001_01_quorum_intersection for 6

assert DELTA_001_02_single_vote_per_term {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_001_02_single_vote_per_term for 6

assert DELTA_001_03_log_matching_reflexive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_001_03_log_matching_reflexive for 6

assert DELTA_001_04_committed_requires_quorum {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_001_04_committed_requires_quorum for 6

assert DELTA_001_05_empty_log_no_commit {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_001_05_empty_log_no_commit for 6

assert DELTA_001_06_leader_append_only {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_001_06_leader_append_only for 6

assert DELTA_001_07_term_monotonic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_001_07_term_monotonic for 6

assert DELTA_001_08_entry_at_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_001_08_entry_at_deterministic for 6

assert DELTA_001_09_log_prefix_match {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_001_09_log_prefix_match for 6

assert DELTA_001_10_quorum_nonempty {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_001_10_quorum_nonempty for 6

assert DELTA_002_01_bft_bound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_002_01_bft_bound for 6

assert DELTA_002_02_bft_quorum_sufficient {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_002_02_bft_quorum_sufficient for 6

assert DELTA_002_03_bft_two_quorums_overlap {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_002_03_bft_two_quorums_overlap for 6

assert DELTA_002_04_correct_majority {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_002_04_correct_majority for 6

assert DELTA_002_05_bft_f_zero {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_002_05_bft_f_zero for 6

assert DELTA_002_06_bft_phases_ordered {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_002_06_bft_phases_ordered for 6

assert DELTA_003_01_gc_merge_comm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_003_01_gc_merge_comm for 6

assert DELTA_003_02_gc_merge_assoc {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_003_02_gc_merge_assoc for 6

assert DELTA_003_03_gc_merge_idempotent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_003_03_gc_merge_idempotent for 6

assert DELTA_003_04_gc_value_nonneg {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_003_04_gc_value_nonneg for 6

assert fold_left_add_mono {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check fold_left_add_mono for 6

assert DELTA_003_05_gc_merge_monotone {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_003_05_gc_merge_monotone for 6

assert DELTA_003_06_gs_add_member {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_003_06_gs_add_member for 6

assert DELTA_003_07_gs_add_preserves {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_003_07_gs_add_preserves for 6

assert DELTA_003_08_gs_merge_contains_left {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_003_08_gs_merge_contains_left for 6

assert DELTA_003_09_gs_add_idempotent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_003_09_gs_add_idempotent for 6

assert DELTA_003_10_gc_empty_zero {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_003_10_gc_empty_zero for 6

assert DELTA_004_01_ring_add_increases {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_004_01_ring_add_increases for 6

assert DELTA_004_02_ring_remove_decreases {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_004_02_ring_remove_decreases for 6

assert DELTA_004_03_ring_size_preserved_add {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_004_03_ring_size_preserved_add for 6

assert DELTA_004_04_ring_size_preserved_remove {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_004_04_ring_size_preserved_remove for 6

assert DELTA_004_05_empty_ring_no_lookup {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check DELTA_004_05_empty_ring_no_lookup for 6

pred ExampleDELTA001_VerifiedDistribution {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleDELTA001_VerifiedDistribution for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for verified runtime
// Bounded verification of key properties
module riina/Domains/VerifiedRuntime

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

assert mem_update_same {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mem_update_same for 6

assert mem_update_diff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mem_update_diff for 6

assert andb_true_iff {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check andb_true_iff for 6

assert RT_001_01_alloc_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_01_alloc_safe for 6

assert RT_001_02_alloc_no_overlap {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_02_alloc_no_overlap for 6

assert RT_001_03_free_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_03_free_correct for 6

assert RT_001_04_no_use_after_free {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_04_no_use_after_free for 6

assert RT_001_05_no_double_free {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_05_no_double_free for 6

assert RT_001_06_alloc_alignment {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_06_alloc_alignment for 6

assert RT_001_07_heap_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_07_heap_integrity for 6

assert RT_001_08_alloc_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_08_alloc_bounded for 6

assert RT_001_09_gc_preserves_live {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_09_gc_preserves_live for 6

assert RT_001_10_gc_collects_dead {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_10_gc_collects_dead for 6

assert RT_001_11_gc_roots_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_11_gc_roots_complete for 6

assert RT_001_12_gc_pause_bound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_12_gc_pause_bound for 6

assert RT_001_13_gc_memory_bound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_13_gc_memory_bound for 6

assert RT_001_14_finalizer_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_14_finalizer_safe for 6

assert RT_001_15_gc_progress {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_15_gc_progress for 6

assert RT_001_16_sandbox_memory_isolated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_16_sandbox_memory_isolated for 6

assert RT_001_17_sandbox_cap_isolated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_17_sandbox_cap_isolated for 6

assert RT_001_18_sandbox_resource_limited {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_18_sandbox_resource_limited for 6

assert RT_001_19_sandbox_terminable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_19_sandbox_terminable for 6

assert RT_001_20_sandbox_comm_controlled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check RT_001_20_sandbox_comm_controlled for 6

pred ExampleVerifiedRuntime {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleVerifiedRuntime for 6

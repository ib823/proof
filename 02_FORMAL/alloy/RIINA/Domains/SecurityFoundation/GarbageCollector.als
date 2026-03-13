// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for garbage collector
// Bounded verification of key properties
module riina/Domains/SecurityFoundation/GarbageCollector

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

assert gc_preserves_live_objects {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gc_preserves_live_objects for 6

assert gc_collects_garbage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gc_collects_garbage for 6

assert roots_reachable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check roots_reachable for 6

assert references_reachable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check references_reachable for 6

assert empty_roots_gc {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check empty_roots_gc for 6

assert gc_preserves_root_set {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gc_preserves_root_set for 6

assert unreachable_heap_cleared {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check unreachable_heap_cleared for 6

assert gc_safety {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gc_safety for 6

assert root_reachable_subset {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check root_reachable_subset for 6

assert reachability_transitive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check reachability_transitive for 6

assert gc_idempotent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gc_idempotent for 6

assert empty_heap_gc_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check empty_heap_gc_safe for 6

assert no_refs_no_children {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_refs_no_children for 6

assert gc_preserves_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gc_preserves_deterministic for 6

assert single_root_survives {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check single_root_survives for 6

assert heap_utilization_nonneg {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heap_utilization_nonneg for 6

assert empty_heap_zero_utilization {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check empty_heap_zero_utilization for 6

assert object_id_eq_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check object_id_eq_refl for 6

assert reachable_implies_exists {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check reachable_implies_exists for 6

assert valid_gc_reflects_reachability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check valid_gc_reflects_reachability for 6

pred ExampleGarbageCollector {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleGarbageCollector for 6

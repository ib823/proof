// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for x001_concurrency model
// Bounded verification of key properties
module riina/Domains/X001_ConcurrencyModel

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

assert X_001_01_shared_xor_mutable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_01_shared_xor_mutable for 6

assert X_001_02_ownership_exclusive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_02_ownership_exclusive for 6

assert X_001_03_no_concurrent_write {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_03_no_concurrent_write for 6

assert X_001_04_no_write_during_read {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_04_no_write_during_read for 6

assert X_001_05_race_freedom {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_05_race_freedom for 6

assert X_001_06_race_freedom_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_06_race_freedom_composition for 6

assert X_001_07_atomic_operations {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_07_atomic_operations for 6

assert X_001_08_lock_protects {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_08_lock_protects for 6

assert X_001_09_session_type_dual {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_09_session_type_dual for 6

assert X_001_09b_dual_send_recv {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_09b_dual_send_recv for 6

assert X_001_09c_dual_compose {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_09c_dual_compose for 6

assert X_001_10_session_fidelity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_10_session_fidelity for 6

assert X_001_11_session_progress {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_11_session_progress for 6

assert X_001_12_session_safety {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_12_session_safety for 6

assert X_001_13_channel_linear {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_13_channel_linear for 6

assert X_001_14_no_channel_reuse {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_14_no_channel_reuse for 6

assert X_001_15_send_recv_match {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_15_send_recv_match for 6

assert X_001_16_select_offer_match {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_16_select_offer_match for 6

assert X_001_17_session_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_17_session_composition for 6

assert X_001_17b_dual_base_involutive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_17b_dual_base_involutive for 6

assert X_001_17c_dual_chain {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_17c_dual_chain for 6

assert X_001_18_no_circular_wait {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_18_no_circular_wait for 6

assert X_001_19_lock_ordering {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_19_lock_ordering for 6

assert X_001_20_session_deadlock_free {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_20_session_deadlock_free for 6

assert X_001_21_resource_ordering {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_21_resource_ordering for 6

assert X_001_22_timeout_prevents_deadlock {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_22_timeout_prevents_deadlock for 6

assert X_001_23_deadlock_detection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_23_deadlock_detection for 6

assert X_001_24_livelock_freedom {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_24_livelock_freedom for 6

assert X_001_25_starvation_freedom {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_25_starvation_freedom for 6

assert X_001_26_mutex_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_26_mutex_correct for 6

assert X_001_27_rwlock_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_27_rwlock_correct for 6

assert X_001_28_barrier_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_28_barrier_correct for 6

assert X_001_29_semaphore_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_29_semaphore_correct for 6

assert X_001_30_condvar_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_30_condvar_correct for 6

assert X_001_31_global_type_projectable {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_31_global_type_projectable for 6

assert X_001_32_multiparty_safety {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_32_multiparty_safety for 6

assert X_001_33_multiparty_progress {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_33_multiparty_progress for 6

assert X_001_34_role_conformance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_34_role_conformance for 6

assert X_001_35_multiparty_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check X_001_35_multiparty_composition for 6

pred ExampleX001_ConcurrencyModel {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleX001_ConcurrencyModel for 6

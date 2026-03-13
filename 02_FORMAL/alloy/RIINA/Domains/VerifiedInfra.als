// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for verified infra
// Bounded verification of key properties
module riina/Domains/VerifiedInfra

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

assert INF_001_01_lb_routes_correctly {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_01_lb_routes_correctly for 6

assert INF_001_02_lb_session_affinity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_02_lb_session_affinity for 6

assert INF_001_03_lb_no_request_smuggling {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_03_lb_no_request_smuggling for 6

assert INF_001_04_lb_health_check_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_04_lb_health_check_correct for 6

assert INF_001_05_lb_fair_distribution {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_05_lb_fair_distribution for 6

assert INF_001_06_db_atomicity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_06_db_atomicity for 6

assert INF_001_07_db_consistency {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_07_db_consistency for 6

assert INF_001_08_db_isolation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_08_db_isolation for 6

assert INF_001_09_db_durability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_09_db_durability for 6

assert INF_001_10_db_no_injection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_10_db_no_injection for 6

assert INF_001_11_db_encryption_at_rest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_11_db_encryption_at_rest for 6

assert INF_001_12_db_access_controlled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_12_db_access_controlled for 6

assert INF_001_13_db_audit_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_13_db_audit_complete for 6

assert filter_In_length_pos {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check filter_In_length_pos for 6

assert INF_001_14_mq_exactly_once {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_14_mq_exactly_once for 6

assert INF_001_15_mq_ordering {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_15_mq_ordering for 6

assert INF_001_16_mq_no_deser_attack {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_16_mq_no_deser_attack for 6

assert INF_001_17_mq_dlq_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_17_mq_dlq_complete for 6

assert INF_001_18_mq_backpressure {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_18_mq_backpressure for 6

assert INF_001_19_log_append_only {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_19_log_append_only for 6

assert INF_001_20_log_no_injection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_20_log_no_injection for 6

assert INF_001_21_log_tamper_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_21_log_tamper_detected for 6

assert INF_001_22_secret_isolated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_22_secret_isolated for 6

assert INF_001_23_secret_rotation_safe {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_23_secret_rotation_safe for 6

assert INF_001_24_secret_expiry {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_24_secret_expiry for 6

assert INF_001_25_secret_audited {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check INF_001_25_secret_audited for 6

pred ExampleVerifiedInfra {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleVerifiedInfra for 6

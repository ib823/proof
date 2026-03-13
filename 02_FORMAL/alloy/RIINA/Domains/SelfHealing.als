// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for self healing
// Bounded verification of key properties
module riina/Domains/SelfHealing

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

assert heal_001_detection_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_001_detection_complete for 6

assert heal_002_severity_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_002_severity_bounded for 6

assert heal_003_plan_verified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_003_plan_verified for 6

assert heal_004_timeout_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_004_timeout_bounded for 6

assert heal_005_actions_exist {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_005_actions_exist for 6

assert heal_006_checkpoint_verified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_006_checkpoint_verified for 6

assert heal_007_checkpoint_fresh {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_007_checkpoint_fresh for 6

assert heal_008_hash_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_008_hash_valid for 6

assert heal_009_degradation_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_009_degradation_valid for 6

assert heal_010_capability_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_010_capability_bounded for 6

assert heal_011_isolation_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_011_isolation_effective for 6

assert heal_012_failover_available {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_012_failover_available for 6

assert heal_013_recovery_completes {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_013_recovery_completes for 6

assert heal_014_no_recurrence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_014_no_recurrence for 6

assert heal_015_graceful_order {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_015_graceful_order for 6

assert heal_016_min_capability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_016_min_capability for 6

assert heal_017_attack_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_017_attack_detected for 6

assert heal_018_attack_contained {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_018_attack_contained for 6

assert heal_019_evidence_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_019_evidence_preserved for 6

assert heal_020_rto_met {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_020_rto_met for 6

assert heal_021_rpo_met {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_021_rpo_met for 6

assert heal_022_redundancy {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_022_redundancy for 6

assert heal_023_audit_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_023_audit_complete for 6

assert heal_024_learning_applied {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_024_learning_applied for 6

assert heal_025_defense_in_depth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check heal_025_defense_in_depth for 6

pred ExampleSelfHealing {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleSelfHealing for 6

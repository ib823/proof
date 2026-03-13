// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for malaysia bursa gov
// Bounded verification of key properties
module riina/Domains/MalaysiaBursaGov

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

assert bursa_governance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bursa_governance for 6

assert bursa_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bursa_integrity for 6

assert bursa_data_protection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bursa_data_protection for 6

assert bursa_connectivity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bursa_connectivity for 6

assert bursa_bcp {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bursa_bcp for 6

assert bursa_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bursa_composition for 6

assert participant_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check participant_coverage for 6

assert bursa_risk {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bursa_risk for 6

assert bursa_compliant_implies_governance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bursa_compliant_implies_governance for 6

assert bursa_compliant_implies_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bursa_compliant_implies_integrity for 6

assert bursa_compliant_implies_data_protection {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bursa_compliant_implies_data_protection for 6

assert bursa_compliant_implies_connectivity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bursa_compliant_implies_connectivity for 6

assert bursa_compliant_implies_bcp {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bursa_compliant_implies_bcp for 6

assert governance_violation_blocks_compliance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check governance_violation_blocks_compliance for 6

assert integrity_violation_blocks_compliance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check integrity_violation_blocks_compliance for 6

assert data_violation_blocks_compliance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check data_violation_blocks_compliance for 6

assert connectivity_violation_blocks_compliance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check connectivity_violation_blocks_compliance for 6

assert bcp_violation_blocks_compliance {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bcp_violation_blocks_compliance for 6

assert trading_system_availability {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check trading_system_availability for 6

assert trading_system_resilience {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check trading_system_resilience for 6

assert insufficient_uptime {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check insufficient_uptime for 6

assert bursa_composition_v2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bursa_composition_v2 for 6

assert bursa_v2_implies_v1 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bursa_v2_implies_v1 for 6

pred ExampleMalaysiaBursaGov {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleMalaysiaBursaGov for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for malaysia scgtrm
// Bounded verification of key properties
module riina/Domains/MalaysiaSCGTRM

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

assert gtrm_req_1 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gtrm_req_1 for 6

assert gtrm_req_2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gtrm_req_2 for 6

assert gtrm_req_3 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gtrm_req_3 for 6

assert gtrm_req_4 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gtrm_req_4 for 6

assert gtrm_req_5 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gtrm_req_5 for 6

assert gtrm_req_6 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gtrm_req_6 for 6

assert gtrm_req_7 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gtrm_req_7 for 6

assert gtrm_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gtrm_composition for 6

assert cm_entity_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cm_entity_coverage for 6

assert pentest_expired {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pentest_expired for 6

assert pentest_recently_done {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pentest_recently_done for 6

assert gtrm_full_implies_board {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gtrm_full_implies_board for 6

assert gtrm_full_implies_risk {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gtrm_full_implies_risk for 6

assert gtrm_full_implies_pentest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gtrm_full_implies_pentest for 6

assert gtrm_full_implies_ai {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gtrm_full_implies_ai for 6

assert gtrm_full_implies_vendor {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gtrm_full_implies_vendor for 6

assert gtrm_full_implies_incident {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gtrm_full_implies_incident for 6

assert gtrm_full_implies_data {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check gtrm_full_implies_data for 6

assert sc_incident_reporting {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sc_incident_reporting for 6

assert sc_incident_late {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sc_incident_late for 6

assert ai_model_risk_complete {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ai_model_risk_complete for 6

assert ai_not_validated_not_managed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ai_not_validated_not_managed for 6

assert cm_cloud_fully_assessed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cm_cloud_fully_assessed for 6

assert cm_cloud_missing_exit_strategy {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cm_cloud_missing_exit_strategy for 6

pred ExampleMalaysiaSCGTRM {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleMalaysiaSCGTRM for 6

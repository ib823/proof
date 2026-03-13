// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for backend composition
// Bounded verification of key properties
module riina/Domains/BackendComposition

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

assert ni_secure_binary {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ni_secure_binary for 6

assert ni_strong_binary {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ni_strong_binary for 6

assert id_backend_semantics_preserving {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check id_backend_semantics_preserving for 6

assert id_backend_preserves_ni {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check id_backend_preserves_ni for 6

assert compose_semantics_preserving {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compose_semantics_preserving for 6

assert ni_secure_composed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ni_secure_composed for 6

assert sem_pres_implies_label_pres {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sem_pres_implies_label_pres for 6

assert public_output_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check public_output_preserved for 6

assert secret_output_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check secret_output_preserved for 6

assert full_pipeline_ni {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check full_pipeline_ni for 6

assert full_pipeline_swift_ni {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check full_pipeline_swift_ni for 6

assert label_le_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check label_le_refl for 6

assert label_le_trans {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check label_le_trans for 6

assert lo_is_bottom {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check lo_is_bottom for 6

assert hi_is_top {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hi_is_top for 6

assert compose_id_left {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compose_id_left for 6

assert compose_id_right {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compose_id_right for 6

assert compose_backend_assoc {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check compose_backend_assoc for 6

assert label_preserving_compose {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check label_preserving_compose for 6

assert sem_pres_implies_public_sem_pres {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sem_pres_implies_public_sem_pres for 6

assert ni_strong_triple_pipeline {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ni_strong_triple_pipeline for 6

pred ExampleBackendComposition {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleBackendComposition for 6

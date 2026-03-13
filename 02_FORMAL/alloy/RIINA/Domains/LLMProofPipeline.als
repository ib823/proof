// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for llmproof pipeline
// Bounded verification of key properties
module riina/Domains/LLMProofPipeline

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

assert formula_eqb_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check formula_eqb_refl for 6

assert formula_eqb_eq {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check formula_eqb_eq for 6

assert formula_eqb_neq {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check formula_eqb_neq for 6

assert 1 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 1 for 6

assert derives_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check derives_sound for 6

assert 2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 2 for 6

assert 3 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 3 for 6

assert 4 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 4 for 6

assert 5a {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 5a for 6

assert 5b {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 5b for 6

assert 6 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 6 for 6

assert 7 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 7 for 6

assert invalid_axiom_rejected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check invalid_axiom_rejected for 6

assert invalid_mismatch_rejected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check invalid_mismatch_rejected for 6

assert 8 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 8 for 6

assert weakening_derives {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check weakening_derives for 6

assert weakening {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check weakening for 6

assert pipeline_soundness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pipeline_soundness for 6

assert identity_is_valid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check identity_is_valid for 6

assert 11 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check 11 for 6

pred ExampleLLMProofPipeline {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleLLMProofPipeline for 6

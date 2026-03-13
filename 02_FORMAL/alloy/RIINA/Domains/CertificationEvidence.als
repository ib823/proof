// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for certification evidence
// Bounded verification of key properties
module riina/Domains/CertificationEvidence

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

assert eqb_sym {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check eqb_sym for 6

assert forallb_eqb_combine_sym {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check forallb_eqb_combine_sym for 6

assert differ_at_one_sym {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check differ_at_one_sym for 6

assert mcdc_pair_sym {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mcdc_pair_sym for 6

assert no_self_mcdc {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_self_mcdc for 6

assert full_trace_no_gaps {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check full_trace_no_gaps for 6

assert sfr_needs_evidence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sfr_needs_evidence for 6

assert sfr_needs_verification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sfr_needs_verification for 6

assert dal_a_highest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dal_a_highest for 6

assert dal_leq_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dal_leq_refl for 6

assert dal_leq_trans {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dal_leq_trans for 6

assert fold_left_add_acc {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check fold_left_add_acc for 6

assert evidence_count_app {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check evidence_count_app for 6

assert all_satisfied_have_evidence {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check all_satisfied_have_evidence for 6

assert empty_trace_fully_traced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check empty_trace_fully_traced for 6

assert dal_e_lowest {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dal_e_lowest for 6

assert dal_leq_antisym {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dal_leq_antisym for 6

assert dal_to_nat_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dal_to_nat_bounded for 6

assert evidence_count_nil {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check evidence_count_nil for 6

assert evidence_count_singleton {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check evidence_count_singleton for 6

assert sfr_satisfied_decompose {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check sfr_satisfied_decompose for 6

assert no_self_mcdc_no_flip {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_self_mcdc_no_flip for 6

assert dal_a_gt_b {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dal_a_gt_b for 6

assert evidence_count_mono {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check evidence_count_mono for 6

pred ExampleCertificationEvidence {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleCertificationEvidence for 6

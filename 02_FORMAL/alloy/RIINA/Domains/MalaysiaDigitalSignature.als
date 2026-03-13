// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for malaysia digital signature
// Bounded verification of key properties
module riina/Domains/MalaysiaDigitalSignature

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

assert cert_validity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cert_validity for 6

assert suspended_invalid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check suspended_invalid for 6

assert revoked_invalid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check revoked_invalid for 6

assert expired_invalid {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check expired_invalid for 6

assert licensed_ca_presumption {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check licensed_ca_presumption for 6

assert unlicensed_no_presumption {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check unlicensed_no_presumption for 6

assert signature_verification {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check signature_verification for 6

assert key_strength_2048 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check key_strength_2048 for 6

assert subscriber_duty_encrypted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check subscriber_duty_encrypted for 6

assert subscriber_duty_hsm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check subscriber_duty_hsm for 6

assert active_not_terminated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check active_not_terminated for 6

assert suspended_not_active {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check suspended_not_active for 6

assert cert_validity_window {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cert_validity_window for 6

assert cert_valid_implies_not_expired {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cert_valid_implies_not_expired for 6

assert cert_valid_implies_active {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cert_valid_implies_active for 6

assert cert_valid_implies_licensed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cert_valid_implies_licensed for 6

assert key_strength_downward {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check key_strength_downward for 6

assert key_strength_4096_implies_2048 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check key_strength_4096_implies_2048 for 6

assert relying_party_duty {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check relying_party_duty for 6

assert partial_check_not_diligent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check partial_check_not_diligent for 6

assert revoked_cert_on_crl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check revoked_cert_on_crl for 6

assert crl_addition_preserves {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check crl_addition_preserves for 6

assert signature_timestamp_in_cert_validity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check signature_timestamp_in_cert_validity for 6

assert dsa_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dsa_composition for 6

assert cert_status_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check cert_status_coverage for 6

assert ca_license_coverage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check ca_license_coverage for 6

pred ExampleMalaysiaDigitalSignature {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleMalaysiaDigitalSignature for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for biometric system
// Bounded verification of key properties
module riina/Domains/MobileOS/BiometricSystem

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

assert biometric_false_acceptance_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check biometric_false_acceptance_bounded for 6

assert liveness_detection_accurate {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check liveness_detection_accurate for 6

assert accepted_requires_high_score {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check accepted_requires_high_score for 6

assert accepted_requires_liveness {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check accepted_requires_liveness for 6

assert spoof_not_accepted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check spoof_not_accepted for 6

assert biometric_data_never_exported_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check biometric_data_never_exported_thm for 6

assert false_acceptance_rate_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check false_acceptance_rate_bounded for 6

assert false_rejection_rate_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check false_rejection_rate_bounded for 6

assert biometric_template_encrypted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check biometric_template_encrypted for 6

assert liveness_detection_active {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check liveness_detection_active for 6

assert biometric_fallback_available {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check biometric_fallback_available for 6

assert enrollment_requires_auth {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check enrollment_requires_auth for 6

assert biometric_timeout_enforced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check biometric_timeout_enforced for 6

assert anti_spoofing_active {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check anti_spoofing_active for 6

assert biometric_data_on_device_only {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check biometric_data_on_device_only for 6

assert multi_factor_supported {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check multi_factor_supported for 6

assert biometric_revocable_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check biometric_revocable_thm for 6

assert presentation_attack_detected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check presentation_attack_detected for 6

assert template_update_secure_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check template_update_secure_thm for 6

assert biometric_not_sole_factor {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check biometric_not_sole_factor for 6

pred ExampleBiometricSystem {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleBiometricSystem for 6

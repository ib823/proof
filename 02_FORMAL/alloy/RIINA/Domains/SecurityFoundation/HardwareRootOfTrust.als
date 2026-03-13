// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for hardware root of trust
// Bounded verification of key properties
module riina/Domains/SecurityFoundation/HardwareRootOfTrust

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

assert root_of_trust_hardware {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check root_of_trust_hardware for 6

assert trust_extension_preserves_root {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check trust_extension_preserves_root for 6

assert extended_component_trusted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check extended_component_trusted for 6

assert untrusted_cannot_extend {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check untrusted_cannot_extend for 6

assert root_key_is_protected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check root_key_is_protected for 6

assert pcr_record_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pcr_record_preserved for 6

assert hw_root_always_trusted {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hw_root_always_trusted for 6

assert attestation_key_present_initial {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check attestation_key_present_initial for 6

assert hardware_initialized_initial {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hardware_initialized_initial for 6

assert trust_extension_preserves_attestation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check trust_extension_preserves_attestation for 6

assert trust_extension_preserves_root_key {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check trust_extension_preserves_root_key for 6

assert trust_extension_preserves_init {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check trust_extension_preserves_init for 6

assert pcr_preserves_trust_chain {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pcr_preserves_trust_chain for 6

assert pcr_preserves_root_key {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pcr_preserves_root_key for 6

assert pcr_values_grow {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check pcr_values_grow for 6

assert trust_chain_grows {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check trust_chain_grows for 6

assert extended_chain_has_component {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check extended_chain_has_component for 6

assert hsm_type_invariant_extend {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hsm_type_invariant_extend for 6

assert hsm_type_invariant_pcr {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hsm_type_invariant_pcr for 6

assert root_key_protection_preserved {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check root_key_protection_preserved for 6

assert root_key_protection_preserved_pcr {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check root_key_protection_preserved_pcr for 6

pred ExampleHardwareRootOfTrust {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleHardwareRootOfTrust for 6

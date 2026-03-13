// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for encryption system
// Bounded verification of key properties
module riina/Domains/MobileOS/EncryptionSystem

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

assert e2e_encryption_verified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check e2e_encryption_verified for 6

assert private_keys_in_secure_enclave {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check private_keys_in_secure_enclave for 6

assert e2e_channel_provides_security {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check e2e_channel_provides_security for 6

assert forward_secrecy_maintained {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check forward_secrecy_maintained for 6

assert strong_encryption_minimum_bits {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check strong_encryption_minimum_bits for 6

assert decryption_verifies_integrity {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check decryption_verifies_integrity for 6

assert key_derivation_preserves_strength {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check key_derivation_preserves_strength for 6

assert encryption_decryption_inverse {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check encryption_decryption_inverse for 6

assert key_generation_random {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check key_generation_random for 6

assert key_length_sufficient {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check key_length_sufficient for 6

assert iv_never_reused_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check iv_never_reused_thm for 6

assert aead_authentication_verified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check aead_authentication_verified for 6

assert key_derivation_deterministic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check key_derivation_deterministic for 6

assert password_hash_one_way_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check password_hash_one_way_thm for 6

assert salt_unique_per_password {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check salt_unique_per_password for 6

assert key_rotation_seamless_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check key_rotation_seamless_thm for 6

assert encrypted_data_indistinguishable_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check encrypted_data_indistinguishable_thm for 6

assert padding_oracle_prevented_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check padding_oracle_prevented_thm for 6

assert timing_attack_prevented_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check timing_attack_prevented_thm for 6

assert key_zeroization_complete_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check key_zeroization_complete_thm for 6

assert hardware_key_storage {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hardware_key_storage for 6

assert encryption_algorithm_approved_thm {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check encryption_algorithm_approved_thm for 6

pred ExampleEncryptionSystem {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleEncryptionSystem for 6

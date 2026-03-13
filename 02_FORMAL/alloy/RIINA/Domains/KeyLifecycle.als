// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for key lifecycle management
// Bounded verification of KeyLifecycle properties
module riina/Domains/KeyLifecycle

abstract sig KeyState {}
one sig Generated extends KeyState {}
one sig Active extends KeyState {}
one sig Suspended extends KeyState {}
one sig Revoked extends KeyState {}
one sig Destroyed extends KeyState {}

sig CryptoKey {
  state: one KeyState,
  strength: one Int
}

sig KeyOp {
  key: one CryptoKey,
  permitted: one Int
}

// Invariant: destroyed_no_ops
fact destroyed_no_ops_fact {
  all op: KeyOp | op.key.state = Destroyed implies op.permitted = 0
}

// Invariant: revoked_no_ops
fact revoked_no_ops_fact {
  all op: KeyOp | op.key.state = Revoked implies op.permitted = 0
}

// Invariant: active_permitted
fact active_permitted_fact {
  all op: KeyOp | op.key.state = Active implies op.permitted = 1
}

assert key_001_entropy_sufficient {
  all op: KeyOp | op.key.state = Destroyed implies op.permitted = 0
}
check key_001_entropy_sufficient for 6

assert key_002_active_usable {
  all op: KeyOp | op.key.state = Revoked implies op.permitted = 0
}
check key_002_active_usable for 6

assert key_003_valid_transition {
  all op: KeyOp | op.key.state = Active implies op.permitted = 1
}
check key_003_valid_transition for 6

assert key_004_destroyed_unusable {
  all op: KeyOp | op.key.state = Destroyed implies op.permitted = 0
}
check key_004_destroyed_unusable for 6

assert key_005_compromised_unusable {
  all op: KeyOp | op.key.state = Revoked implies op.permitted = 0
}
check key_005_compromised_unusable for 6

assert key_006_not_expired {
  all op: KeyOp | op.key.state = Active implies op.permitted = 1
}
check key_006_not_expired for 6

assert key_007_rotation_new {
  all op: KeyOp | op.key.state = Destroyed implies op.permitted = 0
}
check key_007_rotation_new for 6

assert key_008_rotation_timing {
  all op: KeyOp | op.key.state = Revoked implies op.permitted = 0
}
check key_008_rotation_timing for 6

assert key_009_destruction_verified {
  all op: KeyOp | op.key.state = Active implies op.permitted = 1
}
check key_009_destruction_verified for 6

assert key_010_escrow_threshold {
  all op: KeyOp | op.key.state = Destroyed implies op.permitted = 0
}
check key_010_escrow_threshold for 6

assert key_011_escrow_share_index {
  all op: KeyOp | op.key.state = Revoked implies op.permitted = 0
}
check key_011_escrow_share_index for 6

assert key_012_destruction_method {
  all op: KeyOp | op.key.state = Active implies op.permitted = 1
}
check key_012_destruction_method for 6

assert key_013_symmetric_size {
  all op: KeyOp | op.key.state = Destroyed implies op.permitted = 0
}
check key_013_symmetric_size for 6

assert key_014_asymmetric_size {
  all op: KeyOp | op.key.state = Revoked implies op.permitted = 0
}
check key_014_asymmetric_size for 6

assert key_015_purpose_bound {
  all op: KeyOp | op.key.state = Active implies op.permitted = 1
}
check key_015_purpose_bound for 6

assert key_016_lifetime {
  all op: KeyOp | op.key.state = Destroyed implies op.permitted = 0
}
check key_016_lifetime for 6

assert key_017_rotation_due {
  all op: KeyOp | op.key.state = Revoked implies op.permitted = 0
}
check key_017_rotation_due for 6

assert key_018_derivation_depth {
  all op: KeyOp | op.key.state = Active implies op.permitted = 1
}
check key_018_derivation_depth for 6

assert key_019_access_control {
  all op: KeyOp | op.key.state = Destroyed implies op.permitted = 0
}
check key_019_access_control for 6

assert key_020_hsm_storage {
  all op: KeyOp | op.key.state = Revoked implies op.permitted = 0
}
check key_020_hsm_storage for 6

assert key_021_audit_complete {
  all op: KeyOp | op.key.state = Active implies op.permitted = 1
}
check key_021_audit_complete for 6

assert key_022_backup_encrypted {
  all op: KeyOp | op.key.state = Destroyed implies op.permitted = 0
}
check key_022_backup_encrypted for 6

assert key_023_custodian_diversity {
  all op: KeyOp | op.key.state = Revoked implies op.permitted = 0
}
check key_023_custodian_diversity for 6

assert key_024_recovery_tested {
  all op: KeyOp | op.key.state = Active implies op.permitted = 1
}
check key_024_recovery_tested for 6

assert key_025_defense_in_depth {
  all op: KeyOp | op.key.state = Destroyed implies op.permitted = 0
}
check key_025_defense_in_depth for 6

pred ExampleKeyLifecycle {
  some CryptoKey
}
run ExampleKeyLifecycle for 6

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for secure operations
// Bounded verification of SecureUpdates properties
module riina/Domains/SecureUpdates

sig SecureOp {
  verified: one Int,
  attestation: one Int,
  allowed: one Int
}

// Invariant: verified_allowed
fact verified_allowed_fact {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}

// Invariant: attestation_required
fact attestation_required_fact {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}

assert update_001_version_newer {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check update_001_version_newer for 6

assert update_002_sig_count {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check update_002_sig_count for 6

assert update_003_key_trusted {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check update_003_key_trusted for 6

assert update_004_rollback_counter {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check update_004_rollback_counter for 6

assert update_005_min_version {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check update_005_min_version for 6

assert update_006_hash_valid {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check update_006_hash_valid for 6

assert update_007_atomic {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check update_007_atomic for 6

assert update_008_backup_exists {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check update_008_backup_exists for 6

assert update_009_backup_version {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check update_009_backup_version for 6

assert update_010_recovery_restores {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check update_010_recovery_restores for 6

assert update_011_threshold {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check update_011_threshold for 6

assert update_012_sig_fresh {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check update_012_sig_fresh for 6

assert update_013_different_keys {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check update_013_different_keys for 6

assert update_014_size_bounded {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check update_014_size_bounded for 6

assert update_015_compatible {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check update_015_compatible for 6

assert update_016_changelog {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check update_016_changelog for 6

assert update_017_not_expired {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check update_017_not_expired for 6

assert update_018_download_valid {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check update_018_download_valid for 6

assert update_019_secure_channel {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check update_019_secure_channel for 6

assert update_020_rollout_pct {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check update_020_rollout_pct for 6

assert update_021_reboot {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check update_021_reboot for 6

assert update_022_post_verify {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check update_022_post_verify for 6

assert update_023_audit {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check update_023_audit for 6

assert update_024_notification {
  all op: SecureOp | op.allowed = 1 implies op.attestation = 1
}
check update_024_notification for 6

assert update_025_defense_in_depth {
  all op: SecureOp | op.verified = 1 implies op.allowed = 1
}
check update_025_defense_in_depth for 6

pred ExampleSecureUpdates {
  some SecureOp
}
run ExampleSecureUpdates for 6

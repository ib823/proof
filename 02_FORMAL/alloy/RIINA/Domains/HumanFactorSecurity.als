// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for human factor security
// Bounded verification of key properties
module riina/Domains/HumanFactorSecurity

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

assert bool_eq_true {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check bool_eq_true for 6

assert advanced_training_implies_basic {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check advanced_training_implies_basic for 6

assert multi_party_is_adequate {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check multi_party_is_adequate for 6

assert mantrap_implies_controlled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mantrap_implies_controlled for 6

assert immutable_implies_automated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check immutable_implies_automated for 6

assert zero_trust_is_strong {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check zero_trust_is_strong for 6

assert hum_001_phishing_mitigated_by_webauthn {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_001_phishing_mitigated_by_webauthn for 6

assert hum_001_phishing_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_001_phishing_control_effective for 6

assert hum_002_spear_phishing_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_002_spear_phishing_mitigated for 6

assert hum_002_spear_phishing_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_002_spear_phishing_control_effective for 6

assert hum_003_whaling_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_003_whaling_mitigated for 6

assert hum_003_whaling_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_003_whaling_control_effective for 6

assert hum_004_vishing_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_004_vishing_mitigated for 6

assert hum_004_vishing_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_004_vishing_control_effective for 6

assert hum_005_smishing_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_005_smishing_mitigated for 6

assert hum_005_smishing_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_005_smishing_control_effective for 6

assert hum_006_pretexting_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_006_pretexting_mitigated for 6

assert hum_006_pretexting_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_006_pretexting_control_effective for 6

assert hum_007_baiting_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_007_baiting_mitigated for 6

assert hum_007_baiting_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_007_baiting_control_effective for 6

assert hum_008_tailgating_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_008_tailgating_mitigated for 6

assert hum_008_tailgating_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_008_tailgating_control_effective for 6

assert hum_009_dumpster_diving_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_009_dumpster_diving_mitigated for 6

assert hum_009_dumpster_diving_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_009_dumpster_diving_control_effective for 6

assert hum_010_shoulder_surfing_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_010_shoulder_surfing_mitigated for 6

assert hum_010_shoulder_surfing_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_010_shoulder_surfing_control_effective for 6

assert hum_011_insider_threat_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_011_insider_threat_mitigated for 6

assert hum_011_insider_threat_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_011_insider_threat_control_effective for 6

assert hum_012_coercion_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_012_coercion_mitigated for 6

assert hum_012_coercion_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_012_coercion_control_effective for 6

assert hum_013_bribery_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_013_bribery_mitigated for 6

assert hum_013_bribery_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_013_bribery_control_effective for 6

assert hum_014_blackmail_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_014_blackmail_mitigated for 6

assert hum_014_blackmail_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_014_blackmail_control_effective for 6

assert hum_015_social_engineering_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_015_social_engineering_mitigated for 6

assert hum_015_social_engineering_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_015_social_engineering_control_effective for 6

assert hum_016_credential_sharing_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_016_credential_sharing_mitigated for 6

assert hum_016_credential_sharing_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_016_credential_sharing_control_effective for 6

assert hum_017_weak_passwords_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_017_weak_passwords_mitigated for 6

assert hum_017_weak_passwords_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_017_weak_passwords_control_effective for 6

assert hum_018_password_reuse_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_018_password_reuse_mitigated for 6

assert hum_018_password_reuse_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_018_password_reuse_control_effective for 6

assert hum_019_unsafe_behavior_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_019_unsafe_behavior_mitigated for 6

assert hum_019_unsafe_behavior_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_019_unsafe_behavior_control_effective for 6

assert hum_020_configuration_error_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_020_configuration_error_mitigated for 6

assert hum_020_configuration_error_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_020_configuration_error_control_effective for 6

assert hum_021_sock_puppet_campaign_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_021_sock_puppet_campaign_mitigated for 6

assert hum_021_sock_puppet_campaign_control_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check hum_021_sock_puppet_campaign_control_effective for 6

assert all_human_threats_mitigated {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check all_human_threats_mitigated for 6

assert example_state_is_phishing_resistant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check example_state_is_phishing_resistant for 6

assert example_state_mitigates_phishing {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check example_state_mitigates_phishing for 6

assert training_enhances_defenses {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check training_enhances_defenses for 6

assert verification_provides_layered_defense {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check verification_provides_layered_defense for 6

assert physical_logical_complement {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check physical_logical_complement for 6

pred ExampleHumanFactorSecurity {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleHumanFactorSecurity for 6

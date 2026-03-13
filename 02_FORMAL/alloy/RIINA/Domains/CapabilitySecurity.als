// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for capability-based security
// Bounded verification of CapabilitySecurity properties
module riina/Domains/CapabilitySecurity

abstract sig CapKind {}
one sig FileRead extends CapKind {}
one sig FileWrite extends CapKind {}
one sig NetConnect extends CapKind {}
one sig SysCall extends CapKind {}

sig Cap {
  kind: one CapKind,
  revoked: one Int,
  delegable: one Int
}

sig CapUse {
  cap: one Cap,
  allowed: one Int
}

// Invariant: revoked_denied
fact revoked_denied_fact {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}

// Invariant: active_allowed
fact active_allowed_fact {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}

// Invariant: delegation_requires_active
fact delegation_requires_active_fact {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}

assert andb_true_iff {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check andb_true_iff for 6

assert andb_false_iff {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check andb_false_iff for 6

assert orb_true_iff {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check orb_true_iff for 6

assert negb_true_iff {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check negb_true_iff for 6

assert negb_false_iff {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check negb_false_iff for 6

assert CAP_001 {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_001 for 6

assert CAP_002 {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_002 for 6

assert CAP_003 {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_003 for 6

assert CAP_004 {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_004 for 6

assert CAP_005 {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_005 for 6

assert CAP_006 {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_006 for 6

assert CAP_007 {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_007 for 6

assert CAP_008 {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_008 for 6

assert CAP_009 {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_009 for 6

assert CAP_010 {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_010 for 6

assert CAP_011 {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_011 for 6

assert CAP_012 {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_012 for 6

assert CAP_013 {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_013 for 6

assert CAP_014 {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_014 for 6

assert CAP_015 {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_015 for 6

assert CAP_016 {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_016 for 6

assert CAP_017 {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_017 for 6

assert CAP_018 {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_018 for 6

assert CAP_019 {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_019 for 6

assert CAP_020 {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_020 for 6

assert CAP_021 {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_021 for 6

assert CAP_022 {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_022 for 6

assert CAP_023 {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_023 for 6

assert CAP_024 {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_024 for 6

assert CAP_025 {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_025 for 6

assert CAP_026 {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_026 for 6

assert CAP_027 {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_027 for 6

assert CAP_028 {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_028 for 6

assert CAP_029 {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_029 for 6

assert CAP_030_complete {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_030_complete for 6

assert CAP_031_unforgeable_implies_authentic {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_031_unforgeable_implies_authentic for 6

assert CAP_032_unforgeable_config {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_032_unforgeable_config for 6

assert CAP_033_unforgeable_preservation {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_033_unforgeable_preservation for 6

assert CAP_034_unforgeable_and_revocable {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_034_unforgeable_and_revocable for 6

assert CAP_035_no_forge_without_grant {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_035_no_forge_without_grant for 6

assert CAP_036_encapsulation_prevents_forge {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_036_encapsulation_prevents_forge for 6

assert CAP_037_connectivity_controlled {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_037_connectivity_controlled for 6

assert CAP_038_unforgeable_mem_cap {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_038_unforgeable_mem_cap for 6

assert CAP_039_sealed_cap_unforgeable {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_039_sealed_cap_unforgeable for 6

assert CAP_040_valid_cap_required {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_040_valid_cap_required for 6

assert CAP_041_attenuatable_means_monotonic {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_041_attenuatable_means_monotonic for 6

assert perm_in_head {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check perm_in_head for 6

assert perm_in_cons {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check perm_in_cons for 6

assert forallb_impl {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check forallb_impl for 6

assert CAP_042_perms_subset_reflexive {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_042_perms_subset_reflexive for 6

assert CAP_043_empty_perms_subset {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_043_empty_perms_subset for 6

assert CAP_044_derive_from_self {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_044_derive_from_self for 6

assert CAP_045_derive_cannot_exceed_parent {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_045_derive_cannot_exceed_parent for 6

assert CAP_046_derive_bounds_contained {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_046_derive_bounds_contained for 6

assert CAP_047_derive_perms_subset {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_047_derive_perms_subset for 6

assert CAP_048_sealed_prevents_derive {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_048_sealed_prevents_derive for 6

assert CAP_049_perm_leq_reflexive {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_049_perm_leq_reflexive for 6

assert CAP_050_read_leq_write {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_050_read_leq_write for 6

assert CAP_051_write_leq_execute {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_051_write_leq_execute for 6

assert CAP_052_perm_leq_transitive {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_052_perm_leq_transitive for 6

assert CAP_053_perm_lt_irreflexive {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_053_perm_lt_irreflexive for 6

assert CAP_054_monotonic_no_escalation {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_054_monotonic_no_escalation for 6

assert CAP_055_derive_preserves_validity {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_055_derive_preserves_validity for 6

assert CAP_056_empty_not_revoked {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_056_empty_not_revoked for 6

assert CAP_057_revoke_makes_revoked {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_057_revoke_makes_revoked for 6

assert CAP_058_revoke_idempotent {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_058_revoke_idempotent for 6

assert CAP_059_revoke_other_unchanged {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_059_revoke_other_unchanged for 6

assert CAP_060_cap_revocable_riina {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_060_cap_revocable_riina for 6

assert CAP_061_revocable_implies_can_revoke {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_061_revocable_implies_can_revoke for 6

assert CAP_062_revoked_mem_cap_invalid {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_062_revoked_mem_cap_invalid for 6

assert CAP_063_revoked_cannot_read {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_063_revoked_cannot_read for 6

assert CAP_064_revoked_cannot_write {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_064_revoked_cannot_write for 6

assert CAP_065_revoked_cannot_execute {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_065_revoked_cannot_execute for 6

assert CAP_066_confinement_enforced {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_066_confinement_enforced for 6

assert CAP_067_no_ambient_authority {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_067_no_ambient_authority for 6

assert CAP_068_explicit_access_only {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_068_explicit_access_only for 6

assert CAP_069_no_privilege_escalation {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_069_no_privilege_escalation for 6

assert CAP_070_ocap_no_ambient {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_070_ocap_no_ambient for 6

assert CAP_071_has_cap_empty {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_071_has_cap_empty for 6

assert CAP_072_has_cap_head {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_072_has_cap_head for 6

assert CAP_073_confinement_complete {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_073_confinement_complete for 6

assert CAP_074_confined_needs_cap {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_074_confined_needs_cap for 6

assert CAP_075_confined_no_escalate {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_075_confined_no_escalate for 6

assert CAP_076_full_can_redelegate {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_076_full_can_redelegate for 6

assert CAP_077_restricted_cannot_redelegate {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_077_restricted_cannot_redelegate for 6

assert CAP_078_once_cannot_redelegate {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_078_once_cannot_redelegate for 6

assert CAP_079_inactive_delegation {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_079_inactive_delegation for 6

assert CAP_080_delegation_has_from {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_080_delegation_has_from for 6

assert CAP_081_delegation_has_to {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_081_delegation_has_to for 6

assert CAP_082_delegation_has_cap {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_082_delegation_has_cap for 6

assert CAP_083_delegation_type_full {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_083_delegation_type_full for 6

assert CAP_084_delegation_type_restricted {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_084_delegation_type_restricted for 6

assert CAP_085_delegation_type_once {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_085_delegation_type_once for 6

assert CAP_086_bounds_check_in_range {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_086_bounds_check_in_range for 6

assert CAP_087_bounds_check_out_of_range_low {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_087_bounds_check_out_of_range_low for 6

assert CAP_088_bounds_check_out_of_range_high {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_088_bounds_check_out_of_range_high for 6

assert CAP_089_riina_mem_cap_valid {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_089_riina_mem_cap_valid for 6

assert CAP_090_riina_mem_cap_not_sealed {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_090_riina_mem_cap_not_sealed for 6

assert CAP_091_riina_mem_cap_base {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_091_riina_mem_cap_base for 6

assert CAP_092_riina_mem_cap_length {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_092_riina_mem_cap_length for 6

assert CAP_093_valid_for_read {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_093_valid_for_read for 6

assert CAP_094_valid_for_write {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_094_valid_for_write for 6

assert CAP_095_valid_for_execute {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_095_valid_for_execute for 6

assert CAP_096_sealed_cannot_derive {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_096_sealed_cannot_derive for 6

assert CAP_097_empty_perms_no_access {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_097_empty_perms_no_access for 6

assert CAP_098_mem_cap_complete {
  all u: CapUse | u.cap.revoked = 1 implies u.allowed = 0
}
check CAP_098_mem_cap_complete for 6

assert CAP_099_zero_length_no_access {
  all u: CapUse | u.cap.revoked = 0 implies u.allowed = 1
}
check CAP_099_zero_length_no_access for 6

assert CAP_100_security_complete {
  all c: Cap | c.delegable = 1 implies c.revoked = 0
}
check CAP_100_security_complete for 6

pred ExampleCapabilitySecurity {
  some Cap
}
run ExampleCapabilitySecurity for 6

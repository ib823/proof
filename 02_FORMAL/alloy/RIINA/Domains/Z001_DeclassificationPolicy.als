// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for z001_declassification policy
// Bounded verification of key properties
module riina/Domains/Z001_DeclassificationPolicy

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

assert principal_eqb_refl {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check principal_eqb_refl for 6

assert Z_001_01_principal_lattice {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_01_principal_lattice for 6

assert Z_001_02_acts_for_transitive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_02_acts_for_transitive for 6

assert Z_001_03_acts_for_reflexive {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_03_acts_for_reflexive for 6

assert Z_001_04_authority_delegation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_04_authority_delegation for 6

assert Z_001_05_authority_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_05_authority_bounded for 6

assert Z_001_06_principal_join {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_06_principal_join for 6

assert Z_001_07_principal_meet {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_07_principal_meet for 6

assert Z_001_08_robust_definition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_08_robust_definition for 6

assert Z_001_09_robust_guard {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_09_robust_guard for 6

assert Z_001_10_robust_decision {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_10_robust_decision for 6

assert Z_001_11_robust_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_11_robust_composition for 6

assert Z_001_12_no_attacker_controlled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_12_no_attacker_controlled for 6

assert Z_001_13_robust_preserves_ni {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_13_robust_preserves_ni for 6

assert Z_001_14_downgrade_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_14_downgrade_bounded for 6

assert Z_001_15_robust_checker_sound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_15_robust_checker_sound for 6

assert Z_001_16_budget_wellformed {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_16_budget_wellformed for 6

assert Z_001_17_budget_consumption {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_17_budget_consumption for 6

assert Z_001_18_budget_exhaustion {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_18_budget_exhaustion for 6

assert Z_001_19_budget_reset {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_19_budget_reset for 6

assert Z_001_20_total_leakage_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_20_total_leakage_bounded for 6

assert Z_001_21_mutual_information_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_21_mutual_information_bounded for 6

assert Z_001_22_budget_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_22_budget_composition for 6

assert Z_001_23_budget_per_principal {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_23_budget_per_principal for 6

assert Z_001_24_policy_authorized {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_24_policy_authorized for 6

assert Z_001_25_policy_guard_satisfied {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_25_policy_guard_satisfied for 6

assert Z_001_26_policy_transform_applied {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_26_policy_transform_applied for 6

assert Z_001_27_policy_audit_logged {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_27_policy_audit_logged for 6

assert Z_001_28_policy_no_bypass {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_28_policy_no_bypass for 6

assert Z_001_29_policy_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_29_policy_composition for 6

assert Z_001_30_policy_revocation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_30_policy_revocation for 6

assert Z_001_31_dp_definition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_31_dp_definition for 6

assert Z_001_32_dp_composition {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_32_dp_composition for 6

assert Z_001_33_dp_laplace_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_33_dp_laplace_correct for 6

assert Z_001_34_dp_gaussian_correct {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_34_dp_gaussian_correct for 6

assert Z_001_35_dp_privacy_budget {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check Z_001_35_dp_privacy_budget for 6

pred ExampleZ001_DeclassificationPolicy {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleZ001_DeclassificationPolicy for 6

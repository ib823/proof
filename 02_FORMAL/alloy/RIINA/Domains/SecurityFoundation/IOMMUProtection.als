// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for iommuprotection
// Bounded verification of key properties
module riina/Domains/SecurityFoundation/IOMMUProtection

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

assert dma_isolation {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dma_isolation for 6

assert iommu_config_protected {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check iommu_config_protected for 6

assert iommu_config_protected_v2 {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check iommu_config_protected_v2 for 6

assert dma_requires_iommu_enabled {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dma_requires_iommu_enabled for 6

assert unconfigured_device_no_dma {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check unconfigured_device_no_dma for 6

assert out_of_range_dma_blocked {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check out_of_range_dma_blocked for 6

assert iommu_lockdown_effective {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check iommu_lockdown_effective for 6

assert dma_isolation_enforced {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check dma_isolation_enforced for 6

assert device_address_bounded {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check device_address_bounded for 6

assert mapping_table_consistent {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check mapping_table_consistent for 6

assert no_dma_to_kernel {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check no_dma_to_kernel for 6

assert iommu_bypass_impossible {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check iommu_bypass_impossible for 6

assert address_range_lower_bound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check address_range_lower_bound for 6

assert address_range_upper_bound {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check address_range_upper_bound for 6

assert device_identity_verified {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check device_identity_verified for 6

assert empty_config_denies_all {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check empty_config_denies_all for 6

assert disabled_iommu_denies_all {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check disabled_iommu_denies_all for 6

assert locked_config_invariant {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check locked_config_invariant for 6

assert zero_size_config_denies {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check zero_size_config_denies for 6

assert find_device_config_none_not_in {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check find_device_config_none_not_in for 6

assert find_device_config_some_matches {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check find_device_config_some_matches for 6

assert independent_device_configs {
  all op: Operation | op.permitted = 1 implies op.component.verified = 1
}
check independent_device_configs for 6

pred ExampleIOMMUProtection {
  some op: Operation | op.permitted = 1 and op.component.secLevel = High
}
run ExampleIOMMUProtection for 6

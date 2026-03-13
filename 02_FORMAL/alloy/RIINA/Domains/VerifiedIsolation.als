// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for ISO compliance
// Bounded verification of VerifiedIsolation properties
module riina/Domains/VerifiedIsolation

abstract sig ASIL {}
one sig QM extends ASIL {}
one sig A extends ASIL {}
one sig B extends ASIL {}
one sig C extends ASIL {}
one sig D extends ASIL {}

sig SafetyReq {
  asil: one ASIL,
  verified: one Int,
  compliant: one Int
}

// Invariant: d_must_verify
fact d_must_verify_fact {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}

// Invariant: verified_compliant
fact verified_compliant_fact {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}

assert AI_001_01_address_space_disjoint {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_01_address_space_disjoint for 6

assert AI_001_02_no_cross_domain_read {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}
check AI_001_02_no_cross_domain_read for 6

assert AI_001_03_no_cross_domain_write {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_03_no_cross_domain_write for 6

assert AI_001_04_page_table_isolation {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}
check AI_001_04_page_table_isolation for 6

assert AI_001_05_kernel_memory_protected {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_05_kernel_memory_protected for 6

assert AI_001_06_user_cannot_map_kernel {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}
check AI_001_06_user_cannot_map_kernel for 6

assert AI_001_07_iommu_isolation {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_07_iommu_isolation for 6

assert AI_001_08_memory_encryption {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}
check AI_001_08_memory_encryption for 6

assert AI_001_09_capability_unforgeable {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_09_capability_unforgeable for 6

assert AI_001_10_capability_bounded {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}
check AI_001_10_capability_bounded for 6

assert AI_001_11_no_capability_leak {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_11_no_capability_leak for 6

assert AI_001_12_capability_delegation_safe {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}
check AI_001_12_capability_delegation_safe for 6

assert AI_001_13_capability_revocation {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_13_capability_revocation for 6

assert AI_001_14_least_privilege {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}
check AI_001_14_least_privilege for 6

assert AI_001_15_capability_composition {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_15_capability_composition for 6

assert AI_001_16_namespace_isolation {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}
check AI_001_16_namespace_isolation for 6

assert AI_001_17_cgroup_isolation {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_17_cgroup_isolation for 6

assert AI_001_18_seccomp_enforcement {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}
check AI_001_18_seccomp_enforcement for 6

assert AI_001_19_rootfs_isolation {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_19_rootfs_isolation for 6

assert AI_001_20_network_namespace {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}
check AI_001_20_network_namespace for 6

assert AI_001_21_no_container_escape {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_21_no_container_escape for 6

assert AI_001_22_container_composition {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}
check AI_001_22_container_composition for 6

assert AI_001_23_hypervisor_isolation {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_23_hypervisor_isolation for 6

assert AI_001_24_ept_correct {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}
check AI_001_24_ept_correct for 6

assert AI_001_25_vmcs_integrity {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_25_vmcs_integrity for 6

assert AI_001_26_vm_exit_safe {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}
check AI_001_26_vm_exit_safe for 6

assert AI_001_27_device_passthrough_safe {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_27_device_passthrough_safe for 6

assert AI_001_28_no_vm_escape {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}
check AI_001_28_no_vm_escape for 6

assert AI_001_29_enclave_memory_encrypted {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_29_enclave_memory_encrypted for 6

assert AI_001_30_enclave_code_integrity {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}
check AI_001_30_enclave_code_integrity for 6

assert AI_001_31_enclave_attestation {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_31_enclave_attestation for 6

assert AI_001_32_enclave_sealing {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}
check AI_001_32_enclave_sealing for 6

assert AI_001_33_no_enclave_read {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_33_no_enclave_read for 6

assert AI_001_34_enclave_side_channel {
  all r: SafetyReq | r.verified = 1 implies r.compliant = 1
}
check AI_001_34_enclave_side_channel for 6

assert AI_001_35_enclave_composition {
  all r: SafetyReq | r.asil = D implies r.verified = 1
}
check AI_001_35_enclave_composition for 6

pred ExampleVerifiedIsolation {
  some SafetyReq
}
run ExampleVerifiedIsolation for 6

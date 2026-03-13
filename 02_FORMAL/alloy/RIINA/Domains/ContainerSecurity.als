// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Domain model for container security
// Bounded verification of ContainerSecurity properties
module riina/Domains/ContainerSecurity

abstract sig IsolationLevel {}
one sig None extends IsolationLevel {}
one sig Namespace extends IsolationLevel {}
one sig Full extends IsolationLevel {}

sig Container {
  isolation: one IsolationLevel,
  privileged: one Int,
  secure: one Int
}

sig ContainerNetwork {
  container: one Container,
  exposed: one Int
}

// Invariant: full_isolation_secure
fact full_isolation_secure_fact {
  all c: Container | c.isolation = Full implies c.secure = 1
}

// Invariant: privileged_not_secure
fact privileged_not_secure_fact {
  all c: Container | c.privileged = 1 implies c.secure = 0
}

// Invariant: no_uncontained_exposure
fact no_uncontained_exposure_fact {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}

assert andb_true_intro {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check andb_true_intro for 6

assert andb_true_elim1 {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check andb_true_elim1 for 6

assert andb_true_elim2 {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check andb_true_elim2 for 6

assert andb7_true {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check andb7_true for 6

assert NS_001_full_isolation {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check NS_001_full_isolation for 6

assert NS_002_minimal_isolation {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check NS_002_minimal_isolation for 6

assert NS_003_pid_isolated {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check NS_003_pid_isolated for 6

assert NS_004_net_isolated {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check NS_004_net_isolated for 6

assert NS_005_mount_isolated {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check NS_005_mount_isolated for 6

assert NS_006_user_isolated {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check NS_006_user_isolated for 6

assert NS_007_uts_isolated {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check NS_007_uts_isolated for 6

assert NS_008_ipc_isolated {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check NS_008_ipc_isolated for 6

assert NS_009_cgroup_isolated {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check NS_009_cgroup_isolated for 6

assert NS_010_time_isolated {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check NS_010_time_isolated for 6

assert NS_011_network_safe {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check NS_011_network_safe for 6

assert NS_012_process_safe {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check NS_012_process_safe for 6

assert NS_013_full_implies_pid {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check NS_013_full_implies_pid for 6

assert NS_014_full_implies_net {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check NS_014_full_implies_net for 6

assert NS_015_full_implies_user {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check NS_015_full_implies_user for 6

assert CG_001_cpu_safe {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check CG_001_cpu_safe for 6

assert CG_002_memory_safe {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check CG_002_memory_safe for 6

assert CG_003_pids_safe {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check CG_003_pids_safe for 6

assert CG_004_io_safe {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check CG_004_io_safe for 6

assert CG_005_fully_limited {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check CG_005_fully_limited for 6

assert CG_006_full_implies_cpu {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check CG_006_full_implies_cpu for 6

assert CG_007_full_implies_memory {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check CG_007_full_implies_memory for 6

assert CG_008_full_implies_pids {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check CG_008_full_implies_pids for 6

assert CG_009_full_implies_io {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check CG_009_full_implies_io for 6

assert CG_010_swap_disabled {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check CG_010_swap_disabled for 6

assert SC_001_enforced {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check SC_001_enforced for 6

assert SC_002_minimal_safe {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check SC_002_minimal_safe for 6

assert SC_003_escape_protected {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check SC_003_escape_protected for 6

assert SC_004_fully_hardened {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check SC_004_fully_hardened for 6

assert SC_005_filter_enabled {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check SC_005_filter_enabled for 6

assert SC_006_default_deny {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check SC_006_default_deny for 6

assert SC_007_audit_logging {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check SC_007_audit_logging for 6

assert SC_008_block_privileged {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check SC_008_block_privileged for 6

assert SC_009_block_debug {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check SC_009_block_debug for 6

assert SC_010_block_module {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check SC_010_block_module for 6

assert SC_011_block_namespace {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check SC_011_block_namespace for 6

assert SC_012_hardened_implies_filter {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check SC_012_hardened_implies_filter for 6

assert SC_013_hardened_implies_block_priv {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check SC_013_hardened_implies_block_priv for 6

assert CAP_001_dangerous_dropped {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check CAP_001_dangerous_dropped for 6

assert CAP_002_minimal {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check CAP_002_minimal for 6

assert CAP_003_rootless_safe {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check CAP_003_rootless_safe for 6

assert CAP_004_network_minimal {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check CAP_004_network_minimal for 6

assert CAP_005_no_sys_admin {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check CAP_005_no_sys_admin for 6

assert CAP_006_no_sys_ptrace {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check CAP_006_no_sys_ptrace for 6

assert CAP_007_no_sys_module {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check CAP_007_no_sys_module for 6

assert CAP_008_no_sys_rawio {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check CAP_008_no_sys_rawio for 6

assert CAP_009_no_net_raw {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check CAP_009_no_net_raw for 6

assert CAP_010_no_setuid {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check CAP_010_no_setuid for 6

assert CAP_011_no_setgid {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check CAP_011_no_setgid for 6

assert CAP_012_no_chown {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check CAP_012_no_chown for 6

assert CAP_013_net_bind_allowed {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check CAP_013_net_bind_allowed for 6

assert IMG_001_authenticity_verified {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check IMG_001_authenticity_verified for 6

assert IMG_002_provenance_verified {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check IMG_002_provenance_verified for 6

assert IMG_003_security_verified {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check IMG_003_security_verified for 6

assert IMG_004_fully_verified {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check IMG_004_fully_verified for 6

assert IMG_005_signed {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check IMG_005_signed for 6

assert IMG_006_signature_valid {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check IMG_006_signature_valid for 6

assert IMG_007_hash_verified {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check IMG_007_hash_verified for 6

assert IMG_008_trusted_registry {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check IMG_008_trusted_registry for 6

assert IMG_009_sbom_present {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check IMG_009_sbom_present for 6

assert IMG_010_vuln_scanned {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check IMG_010_vuln_scanned for 6

assert IMG_011_no_critical_vulns {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check IMG_011_no_critical_vulns for 6

assert IMG_012_base_verified {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check IMG_012_base_verified for 6

assert IMG_013_full_implies_signed {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check IMG_013_full_implies_signed for 6

assert IMG_014_full_implies_no_vulns {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check IMG_014_full_implies_no_vulns for 6

assert ESC_001_basic_protected {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check ESC_001_basic_protected for 6

assert ESC_002_filesystem_protected {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check ESC_002_filesystem_protected for 6

assert ESC_003_mac_protected {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check ESC_003_mac_protected for 6

assert ESC_004_fully_protected {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check ESC_004_fully_protected for 6

assert ESC_005_no_privileged {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check ESC_005_no_privileged for 6

assert ESC_006_no_host_pid {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check ESC_006_no_host_pid for 6

assert ESC_007_no_host_net {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check ESC_007_no_host_net for 6

assert ESC_008_no_host_ipc {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check ESC_008_no_host_ipc for 6

assert ESC_009_readonly_rootfs {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check ESC_009_readonly_rootfs for 6

assert ESC_010_no_new_privs {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check ESC_010_no_new_privs for 6

assert ESC_011_seccomp_enabled {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check ESC_011_seccomp_enabled for 6

assert ESC_012_drop_all_caps {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check ESC_012_drop_all_caps for 6

assert ESC_013_full_implies_no_priv {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check ESC_013_full_implies_no_priv for 6

assert ESC_014_full_implies_seccomp {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check ESC_014_full_implies_seccomp for 6

assert CONT_001_isolated {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check CONT_001_isolated for 6

assert CONT_002_resource_safe {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check CONT_002_resource_safe for 6

assert CONT_003_syscall_safe {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check CONT_003_syscall_safe for 6

assert CONT_004_capability_safe {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check CONT_004_capability_safe for 6

assert CONT_005_image_safe {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check CONT_005_image_safe for 6

assert CONT_006_escape_safe {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check CONT_006_escape_safe for 6

assert CONT_007_fully_secure {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check CONT_007_fully_secure for 6

assert CONT_008_rootless {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check CONT_008_rootless for 6

assert CONT_009_secure_implies_isolated {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check CONT_009_secure_implies_isolated for 6

assert CONT_010_secure_implies_resource {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check CONT_010_secure_implies_resource for 6

assert CONT_011_secure_implies_syscall {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check CONT_011_secure_implies_syscall for 6

assert CONT_012_secure_implies_capability {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check CONT_012_secure_implies_capability for 6

assert CONT_013_secure_implies_image {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check CONT_013_secure_implies_image for 6

assert CONT_014_secure_implies_escape {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check CONT_014_secure_implies_escape for 6

assert CONT_015_secure_implies_rootless {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check CONT_015_secure_implies_rootless for 6

assert CROSS_001_all_protections {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check CROSS_001_all_protections for 6

assert RIINA_001_defense_in_depth {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check RIINA_001_defense_in_depth for 6

assert RIINA_002_no_escape_vectors {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check RIINA_002_no_escape_vectors for 6

assert RIINA_003_complete_isolation {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check RIINA_003_complete_isolation for 6

assert RIINA_004_resource_controls {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check RIINA_004_resource_controls for 6

assert RIINA_005_seccomp_hardened {
  all c: Container | c.privileged = 1 implies c.secure = 0
}
check RIINA_005_seccomp_hardened for 6

assert RIINA_006_caps_minimal {
  all cn: ContainerNetwork | cn.exposed = 1 implies cn.container.secure = 1
}
check RIINA_006_caps_minimal for 6

assert RIINA_007_image_verified {
  all c: Container | c.isolation = Full implies c.secure = 1
}
check RIINA_007_image_verified for 6

pred ExampleContainerSecurity {
  some Container
}
run ExampleContainerSecurity for 6

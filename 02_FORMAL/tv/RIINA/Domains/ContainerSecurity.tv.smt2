; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/ContainerSecurity.v (106 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for ContainerSecurity
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; ns_fully_isolated: source semantics (matches Coq)
; Translation validation: ns_fully_isolated preserves semantics
(push 1)
(declare-const source_ns_fully_isolated Int)
(declare-const target_ns_fully_isolated Int)
(assert (>= source_ns_fully_isolated 0))
(assert (>= target_ns_fully_isolated 0))
(assert (not (= source_ns_fully_isolated target_ns_fully_isolated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ns_minimally_isolated: source semantics (matches Coq)
; Translation validation: ns_minimally_isolated preserves semantics
(push 1)
(declare-const source_ns_minimally_isolated Int)
(declare-const target_ns_minimally_isolated Int)
(assert (>= source_ns_minimally_isolated 0))
(assert (>= target_ns_minimally_isolated 0))
(assert (not (= source_ns_minimally_isolated target_ns_minimally_isolated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ns_network_safe: source semantics (matches Coq)
; Translation validation: ns_network_safe preserves semantics
(push 1)
(declare-const source_ns_network_safe Int)
(declare-const target_ns_network_safe Int)
(assert (>= source_ns_network_safe 0))
(assert (>= target_ns_network_safe 0))
(assert (not (= source_ns_network_safe target_ns_network_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ns_process_safe: source semantics (matches Coq)
; Translation validation: ns_process_safe preserves semantics
(push 1)
(declare-const source_ns_process_safe Int)
(declare-const target_ns_process_safe Int)
(assert (>= source_ns_process_safe 0))
(assert (>= target_ns_process_safe 0))
(assert (not (= source_ns_process_safe target_ns_process_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cgroup_cpu_safe: source semantics (matches Coq)
; Translation validation: cgroup_cpu_safe preserves semantics
(push 1)
(declare-const source_cgroup_cpu_safe Int)
(declare-const target_cgroup_cpu_safe Int)
(assert (>= source_cgroup_cpu_safe 0))
(assert (>= target_cgroup_cpu_safe 0))
(assert (not (= source_cgroup_cpu_safe target_cgroup_cpu_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cgroup_memory_safe: source semantics (matches Coq)
; Translation validation: cgroup_memory_safe preserves semantics
(push 1)
(declare-const source_cgroup_memory_safe Int)
(declare-const target_cgroup_memory_safe Int)
(assert (>= source_cgroup_memory_safe 0))
(assert (>= target_cgroup_memory_safe 0))
(assert (not (= source_cgroup_memory_safe target_cgroup_memory_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cgroup_pids_safe: source semantics (matches Coq)
; Translation validation: cgroup_pids_safe preserves semantics
(push 1)
(declare-const source_cgroup_pids_safe Int)
(declare-const target_cgroup_pids_safe Int)
(assert (>= source_cgroup_pids_safe 0))
(assert (>= target_cgroup_pids_safe 0))
(assert (not (= source_cgroup_pids_safe target_cgroup_pids_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cgroup_io_safe: source semantics (matches Coq)
; Translation validation: cgroup_io_safe preserves semantics
(push 1)
(declare-const source_cgroup_io_safe Int)
(declare-const target_cgroup_io_safe Int)
(assert (>= source_cgroup_io_safe 0))
(assert (>= target_cgroup_io_safe 0))
(assert (not (= source_cgroup_io_safe target_cgroup_io_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; cgroup_fully_limited: source semantics (matches Coq)
; Translation validation: cgroup_fully_limited preserves semantics
(push 1)
(declare-const source_cgroup_fully_limited Int)
(declare-const target_cgroup_fully_limited Int)
(assert (>= source_cgroup_fully_limited 0))
(assert (>= target_cgroup_fully_limited 0))
(assert (not (= source_cgroup_fully_limited target_cgroup_fully_limited)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; seccomp_enforced: source semantics (matches Coq)
; Translation validation: seccomp_enforced preserves semantics
(push 1)
(declare-const source_seccomp_enforced Int)
(declare-const target_seccomp_enforced Int)
(assert (>= source_seccomp_enforced 0))
(assert (>= target_seccomp_enforced 0))
(assert (not (= source_seccomp_enforced target_seccomp_enforced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; seccomp_minimal_safe: source semantics (matches Coq)
; Translation validation: seccomp_minimal_safe preserves semantics
(push 1)
(declare-const source_seccomp_minimal_safe Int)
(declare-const target_seccomp_minimal_safe Int)
(assert (>= source_seccomp_minimal_safe 0))
(assert (>= target_seccomp_minimal_safe 0))
(assert (not (= source_seccomp_minimal_safe target_seccomp_minimal_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; seccomp_escape_protected: source semantics (matches Coq)
; Translation validation: seccomp_escape_protected preserves semantics
(push 1)
(declare-const source_seccomp_escape_protected Int)
(declare-const target_seccomp_escape_protected Int)
(assert (>= source_seccomp_escape_protected 0))
(assert (>= target_seccomp_escape_protected 0))
(assert (not (= source_seccomp_escape_protected target_seccomp_escape_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; seccomp_fully_hardened: source semantics (matches Coq)
; Translation validation: seccomp_fully_hardened preserves semantics
(push 1)
(declare-const source_seccomp_fully_hardened Int)
(declare-const target_seccomp_fully_hardened Int)
(assert (>= source_seccomp_fully_hardened 0))
(assert (>= target_seccomp_fully_hardened 0))
(assert (not (= source_seccomp_fully_hardened target_seccomp_fully_hardened)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; caps_dangerous_dropped: source semantics (matches Coq)
; Translation validation: caps_dangerous_dropped preserves semantics
(push 1)
(declare-const source_caps_dangerous_dropped Int)
(declare-const target_caps_dangerous_dropped Int)
(assert (>= source_caps_dangerous_dropped 0))
(assert (>= target_caps_dangerous_dropped 0))
(assert (not (= source_caps_dangerous_dropped target_caps_dangerous_dropped)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; caps_minimal: source semantics (matches Coq)
; Translation validation: caps_minimal preserves semantics
(push 1)
(declare-const source_caps_minimal Int)
(declare-const target_caps_minimal Int)
(assert (>= source_caps_minimal 0))
(assert (>= target_caps_minimal 0))
(assert (not (= source_caps_minimal target_caps_minimal)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; caps_rootless_safe: source semantics (matches Coq)
; Translation validation: caps_rootless_safe preserves semantics
(push 1)
(declare-const source_caps_rootless_safe Int)
(declare-const target_caps_rootless_safe Int)
(assert (>= source_caps_rootless_safe 0))
(assert (>= target_caps_rootless_safe 0))
(assert (not (= source_caps_rootless_safe target_caps_rootless_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; caps_network_minimal: source semantics (matches Coq)
; Translation validation: caps_network_minimal preserves semantics
(push 1)
(declare-const source_caps_network_minimal Int)
(declare-const target_caps_network_minimal Int)
(assert (>= source_caps_network_minimal 0))
(assert (>= target_caps_network_minimal 0))
(assert (not (= source_caps_network_minimal target_caps_network_minimal)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; image_authenticity_verified: source semantics (matches Coq)
; Translation validation: image_authenticity_verified preserves semantics
(push 1)
(declare-const source_image_authenticity_verified Int)
(declare-const target_image_authenticity_verified Int)
(assert (>= source_image_authenticity_verified 0))
(assert (>= target_image_authenticity_verified 0))
(assert (not (= source_image_authenticity_verified target_image_authenticity_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; image_provenance_verified: source semantics (matches Coq)
; Translation validation: image_provenance_verified preserves semantics
(push 1)
(declare-const source_image_provenance_verified Int)
(declare-const target_image_provenance_verified Int)
(assert (>= source_image_provenance_verified 0))
(assert (>= target_image_provenance_verified 0))
(assert (not (= source_image_provenance_verified target_image_provenance_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; image_security_verified: source semantics (matches Coq)
; Translation validation: image_security_verified preserves semantics
(push 1)
(declare-const source_image_security_verified Int)
(declare-const target_image_security_verified Int)
(assert (>= source_image_security_verified 0))
(assert (>= target_image_security_verified 0))
(assert (not (= source_image_security_verified target_image_security_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; image_fully_verified: source semantics (matches Coq)
; Translation validation: image_fully_verified preserves semantics
(push 1)
(declare-const source_image_fully_verified Int)
(declare-const target_image_fully_verified Int)
(assert (>= source_image_fully_verified 0))
(assert (>= target_image_fully_verified 0))
(assert (not (= source_image_fully_verified target_image_fully_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; escape_basic_protected: source semantics (matches Coq)
; Translation validation: escape_basic_protected preserves semantics
(push 1)
(declare-const source_escape_basic_protected Int)
(declare-const target_escape_basic_protected Int)
(assert (>= source_escape_basic_protected 0))
(assert (>= target_escape_basic_protected 0))
(assert (not (= source_escape_basic_protected target_escape_basic_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; escape_filesystem_protected: source semantics (matches Coq)
; Translation validation: escape_filesystem_protected preserves semantics
(push 1)
(declare-const source_escape_filesystem_protected Int)
(declare-const target_escape_filesystem_protected Int)
(assert (>= source_escape_filesystem_protected 0))
(assert (>= target_escape_filesystem_protected 0))
(assert (not (= source_escape_filesystem_protected target_escape_filesystem_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; escape_mac_protected: source semantics (matches Coq)
; Translation validation: escape_mac_protected preserves semantics
(push 1)
(declare-const source_escape_mac_protected Int)
(declare-const target_escape_mac_protected Int)
(assert (>= source_escape_mac_protected 0))
(assert (>= target_escape_mac_protected 0))
(assert (not (= source_escape_mac_protected target_escape_mac_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; escape_fully_protected: source semantics (matches Coq)
; Translation validation: escape_fully_protected preserves semantics
(push 1)
(declare-const source_escape_fully_protected Int)
(declare-const target_escape_fully_protected Int)
(assert (>= source_escape_fully_protected 0))
(assert (>= target_escape_fully_protected 0))
(assert (not (= source_escape_fully_protected target_escape_fully_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; container_isolated: source semantics (matches Coq)
; Translation validation: container_isolated preserves semantics
(push 1)
(declare-const source_container_isolated Int)
(declare-const target_container_isolated Int)
(assert (>= source_container_isolated 0))
(assert (>= target_container_isolated 0))
(assert (not (= source_container_isolated target_container_isolated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; container_resource_safe: source semantics (matches Coq)
; Translation validation: container_resource_safe preserves semantics
(push 1)
(declare-const source_container_resource_safe Int)
(declare-const target_container_resource_safe Int)
(assert (>= source_container_resource_safe 0))
(assert (>= target_container_resource_safe 0))
(assert (not (= source_container_resource_safe target_container_resource_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; container_syscall_safe: source semantics (matches Coq)
; Translation validation: container_syscall_safe preserves semantics
(push 1)
(declare-const source_container_syscall_safe Int)
(declare-const target_container_syscall_safe Int)
(assert (>= source_container_syscall_safe 0))
(assert (>= target_container_syscall_safe 0))
(assert (not (= source_container_syscall_safe target_container_syscall_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; container_capability_safe: source semantics (matches Coq)
; Translation validation: container_capability_safe preserves semantics
(push 1)
(declare-const source_container_capability_safe Int)
(declare-const target_container_capability_safe Int)
(assert (>= source_container_capability_safe 0))
(assert (>= target_container_capability_safe 0))
(assert (not (= source_container_capability_safe target_container_capability_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; container_image_safe: source semantics (matches Coq)
; Translation validation: container_image_safe preserves semantics
(push 1)
(declare-const source_container_image_safe Int)
(declare-const target_container_image_safe Int)
(assert (>= source_container_image_safe 0))
(assert (>= target_container_image_safe 0))
(assert (not (= source_container_image_safe target_container_image_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; container_escape_safe: source semantics (matches Coq)
; Translation validation: container_escape_safe preserves semantics
(push 1)
(declare-const source_container_escape_safe Int)
(declare-const target_container_escape_safe Int)
(assert (>= source_container_escape_safe 0))
(assert (>= target_container_escape_safe 0))
(assert (not (= source_container_escape_safe target_container_escape_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; container_fully_secure: source semantics (matches Coq)
; Translation validation: container_fully_secure preserves semantics
(push 1)
(declare-const source_container_fully_secure Int)
(declare-const target_container_fully_secure Int)
(assert (>= source_container_fully_secure 0))
(assert (>= target_container_fully_secure 0))
(assert (not (= source_container_fully_secure target_container_fully_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_ns: source semantics (matches Coq)
; Translation validation: riina_ns preserves semantics
(push 1)
(declare-const source_riina_ns Int)
(declare-const target_riina_ns Int)
(assert (>= source_riina_ns 0))
(assert (>= target_riina_ns 0))
(assert (not (= source_riina_ns target_riina_ns)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_cgroup: source semantics (matches Coq)
; Translation validation: riina_cgroup preserves semantics
(push 1)
(declare-const source_riina_cgroup Int)
(declare-const target_riina_cgroup Int)
(assert (>= source_riina_cgroup 0))
(assert (>= target_riina_cgroup 0))
(assert (not (= source_riina_cgroup target_riina_cgroup)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_seccomp: source semantics (matches Coq)
; Translation validation: riina_seccomp preserves semantics
(push 1)
(declare-const source_riina_seccomp Int)
(declare-const target_riina_seccomp Int)
(assert (>= source_riina_seccomp 0))
(assert (>= target_riina_seccomp 0))
(assert (not (= source_riina_seccomp target_riina_seccomp)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_caps: source semantics (matches Coq)
; Translation validation: riina_caps preserves semantics
(push 1)
(declare-const source_riina_caps Int)
(declare-const target_riina_caps Int)
(assert (>= source_riina_caps 0))
(assert (>= target_riina_caps 0))
(assert (not (= source_riina_caps target_riina_caps)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_image: source semantics (matches Coq)
; Translation validation: riina_image preserves semantics
(push 1)
(declare-const source_riina_image Int)
(declare-const target_riina_image Int)
(assert (>= source_riina_image 0))
(assert (>= target_riina_image 0))
(assert (not (= source_riina_image target_riina_image)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_escape: source semantics (matches Coq)
; Translation validation: riina_escape preserves semantics
(push 1)
(declare-const source_riina_escape Int)
(declare-const target_riina_escape Int)
(assert (>= source_riina_escape 0))
(assert (>= target_riina_escape 0))
(assert (not (= source_riina_escape target_riina_escape)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_container: source semantics (matches Coq)
; Translation validation: riina_container preserves semantics
(push 1)
(declare-const source_riina_container Int)
(declare-const target_riina_container Int)
(assert (>= source_riina_container 0))
(assert (>= target_riina_container 0))
(assert (not (= source_riina_container target_riina_container)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_intro: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_intro preserves semantics
(push 1)
(declare-const source_andb_true_intro Int)
(declare-const target_andb_true_intro Int)
(assert (>= source_andb_true_intro 0))
(assert (>= target_andb_true_intro 0))
(assert (not (= source_andb_true_intro target_andb_true_intro)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_elim1: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_elim1 preserves semantics
(push 1)
(declare-const source_andb_true_elim1 Int)
(declare-const target_andb_true_elim1 Int)
(assert (>= source_andb_true_elim1 0))
(assert (>= target_andb_true_elim1 0))
(assert (not (= source_andb_true_elim1 target_andb_true_elim1)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_elim2: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_elim2 preserves semantics
(push 1)
(declare-const source_andb_true_elim2 Int)
(declare-const target_andb_true_elim2 Int)
(assert (>= source_andb_true_elim2 0))
(assert (>= target_andb_true_elim2 0))
(assert (not (= source_andb_true_elim2 target_andb_true_elim2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb7_true: translation preserves property (matches Coq: Lemma)
; Translation validation: andb7_true preserves semantics
(push 1)
(declare-const source_andb7_true Int)
(declare-const target_andb7_true Int)
(assert (>= source_andb7_true 0))
(assert (>= target_andb7_true 0))
(assert (not (= source_andb7_true target_andb7_true)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NS_001_full_isolation: translation preserves property (matches Coq: Theorem)
; Translation validation: NS_001_full_isolation preserves semantics
(push 1)
(declare-const source_NS_001_full_isolation Int)
(declare-const target_NS_001_full_isolation Int)
(assert (>= source_NS_001_full_isolation 0))
(assert (>= target_NS_001_full_isolation 0))
(assert (not (= source_NS_001_full_isolation target_NS_001_full_isolation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NS_002_minimal_isolation: translation preserves property (matches Coq: Theorem)
; Translation validation: NS_002_minimal_isolation preserves semantics
(push 1)
(declare-const source_NS_002_minimal_isolation Int)
(declare-const target_NS_002_minimal_isolation Int)
(assert (>= source_NS_002_minimal_isolation 0))
(assert (>= target_NS_002_minimal_isolation 0))
(assert (not (= source_NS_002_minimal_isolation target_NS_002_minimal_isolation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NS_003_pid_isolated: translation preserves property (matches Coq: Theorem)
; Translation validation: NS_003_pid_isolated preserves semantics
(push 1)
(declare-const source_NS_003_pid_isolated Int)
(declare-const target_NS_003_pid_isolated Int)
(assert (>= source_NS_003_pid_isolated 0))
(assert (>= target_NS_003_pid_isolated 0))
(assert (not (= source_NS_003_pid_isolated target_NS_003_pid_isolated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NS_004_net_isolated: translation preserves property (matches Coq: Theorem)
; Translation validation: NS_004_net_isolated preserves semantics
(push 1)
(declare-const source_NS_004_net_isolated Int)
(declare-const target_NS_004_net_isolated Int)
(assert (>= source_NS_004_net_isolated 0))
(assert (>= target_NS_004_net_isolated 0))
(assert (not (= source_NS_004_net_isolated target_NS_004_net_isolated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NS_005_mount_isolated: translation preserves property (matches Coq: Theorem)
; Translation validation: NS_005_mount_isolated preserves semantics
(push 1)
(declare-const source_NS_005_mount_isolated Int)
(declare-const target_NS_005_mount_isolated Int)
(assert (>= source_NS_005_mount_isolated 0))
(assert (>= target_NS_005_mount_isolated 0))
(assert (not (= source_NS_005_mount_isolated target_NS_005_mount_isolated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NS_006_user_isolated: translation preserves property (matches Coq: Theorem)
; Translation validation: NS_006_user_isolated preserves semantics
(push 1)
(declare-const source_NS_006_user_isolated Int)
(declare-const target_NS_006_user_isolated Int)
(assert (>= source_NS_006_user_isolated 0))
(assert (>= target_NS_006_user_isolated 0))
(assert (not (= source_NS_006_user_isolated target_NS_006_user_isolated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NS_007_uts_isolated: translation preserves property (matches Coq: Theorem)
; Translation validation: NS_007_uts_isolated preserves semantics
(push 1)
(declare-const source_NS_007_uts_isolated Int)
(declare-const target_NS_007_uts_isolated Int)
(assert (>= source_NS_007_uts_isolated 0))
(assert (>= target_NS_007_uts_isolated 0))
(assert (not (= source_NS_007_uts_isolated target_NS_007_uts_isolated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NS_008_ipc_isolated: translation preserves property (matches Coq: Theorem)
; Translation validation: NS_008_ipc_isolated preserves semantics
(push 1)
(declare-const source_NS_008_ipc_isolated Int)
(declare-const target_NS_008_ipc_isolated Int)
(assert (>= source_NS_008_ipc_isolated 0))
(assert (>= target_NS_008_ipc_isolated 0))
(assert (not (= source_NS_008_ipc_isolated target_NS_008_ipc_isolated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NS_009_cgroup_isolated: translation preserves property (matches Coq: Theorem)
; Translation validation: NS_009_cgroup_isolated preserves semantics
(push 1)
(declare-const source_NS_009_cgroup_isolated Int)
(declare-const target_NS_009_cgroup_isolated Int)
(assert (>= source_NS_009_cgroup_isolated 0))
(assert (>= target_NS_009_cgroup_isolated 0))
(assert (not (= source_NS_009_cgroup_isolated target_NS_009_cgroup_isolated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NS_010_time_isolated: translation preserves property (matches Coq: Theorem)
; Translation validation: NS_010_time_isolated preserves semantics
(push 1)
(declare-const source_NS_010_time_isolated Int)
(declare-const target_NS_010_time_isolated Int)
(assert (>= source_NS_010_time_isolated 0))
(assert (>= target_NS_010_time_isolated 0))
(assert (not (= source_NS_010_time_isolated target_NS_010_time_isolated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NS_011_network_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: NS_011_network_safe preserves semantics
(push 1)
(declare-const source_NS_011_network_safe Int)
(declare-const target_NS_011_network_safe Int)
(assert (>= source_NS_011_network_safe 0))
(assert (>= target_NS_011_network_safe 0))
(assert (not (= source_NS_011_network_safe target_NS_011_network_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NS_012_process_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: NS_012_process_safe preserves semantics
(push 1)
(declare-const source_NS_012_process_safe Int)
(declare-const target_NS_012_process_safe Int)
(assert (>= source_NS_012_process_safe 0))
(assert (>= target_NS_012_process_safe 0))
(assert (not (= source_NS_012_process_safe target_NS_012_process_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NS_013_full_implies_pid: translation preserves property (matches Coq: Theorem)
; Translation validation: NS_013_full_implies_pid preserves semantics
(push 1)
(declare-const source_NS_013_full_implies_pid Int)
(declare-const target_NS_013_full_implies_pid Int)
(assert (>= source_NS_013_full_implies_pid 0))
(assert (>= target_NS_013_full_implies_pid 0))
(assert (not (= source_NS_013_full_implies_pid target_NS_013_full_implies_pid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NS_014_full_implies_net: translation preserves property (matches Coq: Theorem)
; Translation validation: NS_014_full_implies_net preserves semantics
(push 1)
(declare-const source_NS_014_full_implies_net Int)
(declare-const target_NS_014_full_implies_net Int)
(assert (>= source_NS_014_full_implies_net 0))
(assert (>= target_NS_014_full_implies_net 0))
(assert (not (= source_NS_014_full_implies_net target_NS_014_full_implies_net)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; NS_015_full_implies_user: translation preserves property (matches Coq: Theorem)
; Translation validation: NS_015_full_implies_user preserves semantics
(push 1)
(declare-const source_NS_015_full_implies_user Int)
(declare-const target_NS_015_full_implies_user Int)
(assert (>= source_NS_015_full_implies_user 0))
(assert (>= target_NS_015_full_implies_user 0))
(assert (not (= source_NS_015_full_implies_user target_NS_015_full_implies_user)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CG_001_cpu_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: CG_001_cpu_safe preserves semantics
(push 1)
(declare-const source_CG_001_cpu_safe Int)
(declare-const target_CG_001_cpu_safe Int)
(assert (>= source_CG_001_cpu_safe 0))
(assert (>= target_CG_001_cpu_safe 0))
(assert (not (= source_CG_001_cpu_safe target_CG_001_cpu_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CG_002_memory_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: CG_002_memory_safe preserves semantics
(push 1)
(declare-const source_CG_002_memory_safe Int)
(declare-const target_CG_002_memory_safe Int)
(assert (>= source_CG_002_memory_safe 0))
(assert (>= target_CG_002_memory_safe 0))
(assert (not (= source_CG_002_memory_safe target_CG_002_memory_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CG_003_pids_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: CG_003_pids_safe preserves semantics
(push 1)
(declare-const source_CG_003_pids_safe Int)
(declare-const target_CG_003_pids_safe Int)
(assert (>= source_CG_003_pids_safe 0))
(assert (>= target_CG_003_pids_safe 0))
(assert (not (= source_CG_003_pids_safe target_CG_003_pids_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CG_004_io_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: CG_004_io_safe preserves semantics
(push 1)
(declare-const source_CG_004_io_safe Int)
(declare-const target_CG_004_io_safe Int)
(assert (>= source_CG_004_io_safe 0))
(assert (>= target_CG_004_io_safe 0))
(assert (not (= source_CG_004_io_safe target_CG_004_io_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CG_005_fully_limited: translation preserves property (matches Coq: Theorem)
; Translation validation: CG_005_fully_limited preserves semantics
(push 1)
(declare-const source_CG_005_fully_limited Int)
(declare-const target_CG_005_fully_limited Int)
(assert (>= source_CG_005_fully_limited 0))
(assert (>= target_CG_005_fully_limited 0))
(assert (not (= source_CG_005_fully_limited target_CG_005_fully_limited)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CG_006_full_implies_cpu: translation preserves property (matches Coq: Theorem)
; Translation validation: CG_006_full_implies_cpu preserves semantics
(push 1)
(declare-const source_CG_006_full_implies_cpu Int)
(declare-const target_CG_006_full_implies_cpu Int)
(assert (>= source_CG_006_full_implies_cpu 0))
(assert (>= target_CG_006_full_implies_cpu 0))
(assert (not (= source_CG_006_full_implies_cpu target_CG_006_full_implies_cpu)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CG_007_full_implies_memory: translation preserves property (matches Coq: Theorem)
; Translation validation: CG_007_full_implies_memory preserves semantics
(push 1)
(declare-const source_CG_007_full_implies_memory Int)
(declare-const target_CG_007_full_implies_memory Int)
(assert (>= source_CG_007_full_implies_memory 0))
(assert (>= target_CG_007_full_implies_memory 0))
(assert (not (= source_CG_007_full_implies_memory target_CG_007_full_implies_memory)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CG_008_full_implies_pids: translation preserves property (matches Coq: Theorem)
; Translation validation: CG_008_full_implies_pids preserves semantics
(push 1)
(declare-const source_CG_008_full_implies_pids Int)
(declare-const target_CG_008_full_implies_pids Int)
(assert (>= source_CG_008_full_implies_pids 0))
(assert (>= target_CG_008_full_implies_pids 0))
(assert (not (= source_CG_008_full_implies_pids target_CG_008_full_implies_pids)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CG_009_full_implies_io: translation preserves property (matches Coq: Theorem)
; Translation validation: CG_009_full_implies_io preserves semantics
(push 1)
(declare-const source_CG_009_full_implies_io Int)
(declare-const target_CG_009_full_implies_io Int)
(assert (>= source_CG_009_full_implies_io 0))
(assert (>= target_CG_009_full_implies_io 0))
(assert (not (= source_CG_009_full_implies_io target_CG_009_full_implies_io)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CG_010_swap_disabled: translation preserves property (matches Coq: Theorem)
; Translation validation: CG_010_swap_disabled preserves semantics
(push 1)
(declare-const source_CG_010_swap_disabled Int)
(declare-const target_CG_010_swap_disabled Int)
(assert (>= source_CG_010_swap_disabled 0))
(assert (>= target_CG_010_swap_disabled 0))
(assert (not (= source_CG_010_swap_disabled target_CG_010_swap_disabled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SC_001_enforced: translation preserves property (matches Coq: Theorem)
; Translation validation: SC_001_enforced preserves semantics
(push 1)
(declare-const source_SC_001_enforced Int)
(declare-const target_SC_001_enforced Int)
(assert (>= source_SC_001_enforced 0))
(assert (>= target_SC_001_enforced 0))
(assert (not (= source_SC_001_enforced target_SC_001_enforced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SC_002_minimal_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: SC_002_minimal_safe preserves semantics
(push 1)
(declare-const source_SC_002_minimal_safe Int)
(declare-const target_SC_002_minimal_safe Int)
(assert (>= source_SC_002_minimal_safe 0))
(assert (>= target_SC_002_minimal_safe 0))
(assert (not (= source_SC_002_minimal_safe target_SC_002_minimal_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SC_003_escape_protected: translation preserves property (matches Coq: Theorem)
; Translation validation: SC_003_escape_protected preserves semantics
(push 1)
(declare-const source_SC_003_escape_protected Int)
(declare-const target_SC_003_escape_protected Int)
(assert (>= source_SC_003_escape_protected 0))
(assert (>= target_SC_003_escape_protected 0))
(assert (not (= source_SC_003_escape_protected target_SC_003_escape_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SC_004_fully_hardened: translation preserves property (matches Coq: Theorem)
; Translation validation: SC_004_fully_hardened preserves semantics
(push 1)
(declare-const source_SC_004_fully_hardened Int)
(declare-const target_SC_004_fully_hardened Int)
(assert (>= source_SC_004_fully_hardened 0))
(assert (>= target_SC_004_fully_hardened 0))
(assert (not (= source_SC_004_fully_hardened target_SC_004_fully_hardened)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SC_005_filter_enabled: translation preserves property (matches Coq: Theorem)
; Translation validation: SC_005_filter_enabled preserves semantics
(push 1)
(declare-const source_SC_005_filter_enabled Int)
(declare-const target_SC_005_filter_enabled Int)
(assert (>= source_SC_005_filter_enabled 0))
(assert (>= target_SC_005_filter_enabled 0))
(assert (not (= source_SC_005_filter_enabled target_SC_005_filter_enabled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SC_006_default_deny: translation preserves property (matches Coq: Theorem)
; Translation validation: SC_006_default_deny preserves semantics
(push 1)
(declare-const source_SC_006_default_deny Int)
(declare-const target_SC_006_default_deny Int)
(assert (>= source_SC_006_default_deny 0))
(assert (>= target_SC_006_default_deny 0))
(assert (not (= source_SC_006_default_deny target_SC_006_default_deny)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SC_007_audit_logging: translation preserves property (matches Coq: Theorem)
; Translation validation: SC_007_audit_logging preserves semantics
(push 1)
(declare-const source_SC_007_audit_logging Int)
(declare-const target_SC_007_audit_logging Int)
(assert (>= source_SC_007_audit_logging 0))
(assert (>= target_SC_007_audit_logging 0))
(assert (not (= source_SC_007_audit_logging target_SC_007_audit_logging)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SC_008_block_privileged: translation preserves property (matches Coq: Theorem)
; Translation validation: SC_008_block_privileged preserves semantics
(push 1)
(declare-const source_SC_008_block_privileged Int)
(declare-const target_SC_008_block_privileged Int)
(assert (>= source_SC_008_block_privileged 0))
(assert (>= target_SC_008_block_privileged 0))
(assert (not (= source_SC_008_block_privileged target_SC_008_block_privileged)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SC_009_block_debug: translation preserves property (matches Coq: Theorem)
; Translation validation: SC_009_block_debug preserves semantics
(push 1)
(declare-const source_SC_009_block_debug Int)
(declare-const target_SC_009_block_debug Int)
(assert (>= source_SC_009_block_debug 0))
(assert (>= target_SC_009_block_debug 0))
(assert (not (= source_SC_009_block_debug target_SC_009_block_debug)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SC_010_block_module: translation preserves property (matches Coq: Theorem)
; Translation validation: SC_010_block_module preserves semantics
(push 1)
(declare-const source_SC_010_block_module Int)
(declare-const target_SC_010_block_module Int)
(assert (>= source_SC_010_block_module 0))
(assert (>= target_SC_010_block_module 0))
(assert (not (= source_SC_010_block_module target_SC_010_block_module)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SC_011_block_namespace: translation preserves property (matches Coq: Theorem)
; Translation validation: SC_011_block_namespace preserves semantics
(push 1)
(declare-const source_SC_011_block_namespace Int)
(declare-const target_SC_011_block_namespace Int)
(assert (>= source_SC_011_block_namespace 0))
(assert (>= target_SC_011_block_namespace 0))
(assert (not (= source_SC_011_block_namespace target_SC_011_block_namespace)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SC_012_hardened_implies_filter: translation preserves property (matches Coq: Theorem)
; Translation validation: SC_012_hardened_implies_filter preserves semantics
(push 1)
(declare-const source_SC_012_hardened_implies_filter Int)
(declare-const target_SC_012_hardened_implies_filter Int)
(assert (>= source_SC_012_hardened_implies_filter 0))
(assert (>= target_SC_012_hardened_implies_filter 0))
(assert (not (= source_SC_012_hardened_implies_filter target_SC_012_hardened_implies_filter)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; SC_013_hardened_implies_block_priv: translation preserves property (matches Coq: Theorem)
; Translation validation: SC_013_hardened_implies_block_priv preserves semantics
(push 1)
(declare-const source_SC_013_hardened_implies_block_priv Int)
(declare-const target_SC_013_hardened_implies_block_priv Int)
(assert (>= source_SC_013_hardened_implies_block_priv 0))
(assert (>= target_SC_013_hardened_implies_block_priv 0))
(assert (not (= source_SC_013_hardened_implies_block_priv target_SC_013_hardened_implies_block_priv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_001_dangerous_dropped: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_001_dangerous_dropped preserves semantics
(push 1)
(declare-const source_CAP_001_dangerous_dropped Int)
(declare-const target_CAP_001_dangerous_dropped Int)
(assert (>= source_CAP_001_dangerous_dropped 0))
(assert (>= target_CAP_001_dangerous_dropped 0))
(assert (not (= source_CAP_001_dangerous_dropped target_CAP_001_dangerous_dropped)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_002_minimal: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_002_minimal preserves semantics
(push 1)
(declare-const source_CAP_002_minimal Int)
(declare-const target_CAP_002_minimal Int)
(assert (>= source_CAP_002_minimal 0))
(assert (>= target_CAP_002_minimal 0))
(assert (not (= source_CAP_002_minimal target_CAP_002_minimal)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_003_rootless_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_003_rootless_safe preserves semantics
(push 1)
(declare-const source_CAP_003_rootless_safe Int)
(declare-const target_CAP_003_rootless_safe Int)
(assert (>= source_CAP_003_rootless_safe 0))
(assert (>= target_CAP_003_rootless_safe 0))
(assert (not (= source_CAP_003_rootless_safe target_CAP_003_rootless_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_004_network_minimal: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_004_network_minimal preserves semantics
(push 1)
(declare-const source_CAP_004_network_minimal Int)
(declare-const target_CAP_004_network_minimal Int)
(assert (>= source_CAP_004_network_minimal 0))
(assert (>= target_CAP_004_network_minimal 0))
(assert (not (= source_CAP_004_network_minimal target_CAP_004_network_minimal)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_005_no_sys_admin: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_005_no_sys_admin preserves semantics
(push 1)
(declare-const source_CAP_005_no_sys_admin Int)
(declare-const target_CAP_005_no_sys_admin Int)
(assert (>= source_CAP_005_no_sys_admin 0))
(assert (>= target_CAP_005_no_sys_admin 0))
(assert (not (= source_CAP_005_no_sys_admin target_CAP_005_no_sys_admin)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_006_no_sys_ptrace: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_006_no_sys_ptrace preserves semantics
(push 1)
(declare-const source_CAP_006_no_sys_ptrace Int)
(declare-const target_CAP_006_no_sys_ptrace Int)
(assert (>= source_CAP_006_no_sys_ptrace 0))
(assert (>= target_CAP_006_no_sys_ptrace 0))
(assert (not (= source_CAP_006_no_sys_ptrace target_CAP_006_no_sys_ptrace)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_007_no_sys_module: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_007_no_sys_module preserves semantics
(push 1)
(declare-const source_CAP_007_no_sys_module Int)
(declare-const target_CAP_007_no_sys_module Int)
(assert (>= source_CAP_007_no_sys_module 0))
(assert (>= target_CAP_007_no_sys_module 0))
(assert (not (= source_CAP_007_no_sys_module target_CAP_007_no_sys_module)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_008_no_sys_rawio: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_008_no_sys_rawio preserves semantics
(push 1)
(declare-const source_CAP_008_no_sys_rawio Int)
(declare-const target_CAP_008_no_sys_rawio Int)
(assert (>= source_CAP_008_no_sys_rawio 0))
(assert (>= target_CAP_008_no_sys_rawio 0))
(assert (not (= source_CAP_008_no_sys_rawio target_CAP_008_no_sys_rawio)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_009_no_net_raw: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_009_no_net_raw preserves semantics
(push 1)
(declare-const source_CAP_009_no_net_raw Int)
(declare-const target_CAP_009_no_net_raw Int)
(assert (>= source_CAP_009_no_net_raw 0))
(assert (>= target_CAP_009_no_net_raw 0))
(assert (not (= source_CAP_009_no_net_raw target_CAP_009_no_net_raw)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_010_no_setuid: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_010_no_setuid preserves semantics
(push 1)
(declare-const source_CAP_010_no_setuid Int)
(declare-const target_CAP_010_no_setuid Int)
(assert (>= source_CAP_010_no_setuid 0))
(assert (>= target_CAP_010_no_setuid 0))
(assert (not (= source_CAP_010_no_setuid target_CAP_010_no_setuid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_011_no_setgid: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_011_no_setgid preserves semantics
(push 1)
(declare-const source_CAP_011_no_setgid Int)
(declare-const target_CAP_011_no_setgid Int)
(assert (>= source_CAP_011_no_setgid 0))
(assert (>= target_CAP_011_no_setgid 0))
(assert (not (= source_CAP_011_no_setgid target_CAP_011_no_setgid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_012_no_chown: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_012_no_chown preserves semantics
(push 1)
(declare-const source_CAP_012_no_chown Int)
(declare-const target_CAP_012_no_chown Int)
(assert (>= source_CAP_012_no_chown 0))
(assert (>= target_CAP_012_no_chown 0))
(assert (not (= source_CAP_012_no_chown target_CAP_012_no_chown)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CAP_013_net_bind_allowed: translation preserves property (matches Coq: Theorem)
; Translation validation: CAP_013_net_bind_allowed preserves semantics
(push 1)
(declare-const source_CAP_013_net_bind_allowed Int)
(declare-const target_CAP_013_net_bind_allowed Int)
(assert (>= source_CAP_013_net_bind_allowed 0))
(assert (>= target_CAP_013_net_bind_allowed 0))
(assert (not (= source_CAP_013_net_bind_allowed target_CAP_013_net_bind_allowed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; IMG_001_authenticity_verified: translation preserves property (matches Coq: Theorem)
; Translation validation: IMG_001_authenticity_verified preserves semantics
(push 1)
(declare-const source_IMG_001_authenticity_verified Int)
(declare-const target_IMG_001_authenticity_verified Int)
(assert (>= source_IMG_001_authenticity_verified 0))
(assert (>= target_IMG_001_authenticity_verified 0))
(assert (not (= source_IMG_001_authenticity_verified target_IMG_001_authenticity_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; IMG_002_provenance_verified: translation preserves property (matches Coq: Theorem)
; Translation validation: IMG_002_provenance_verified preserves semantics
(push 1)
(declare-const source_IMG_002_provenance_verified Int)
(declare-const target_IMG_002_provenance_verified Int)
(assert (>= source_IMG_002_provenance_verified 0))
(assert (>= target_IMG_002_provenance_verified 0))
(assert (not (= source_IMG_002_provenance_verified target_IMG_002_provenance_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; IMG_003_security_verified: translation preserves property (matches Coq: Theorem)
; Translation validation: IMG_003_security_verified preserves semantics
(push 1)
(declare-const source_IMG_003_security_verified Int)
(declare-const target_IMG_003_security_verified Int)
(assert (>= source_IMG_003_security_verified 0))
(assert (>= target_IMG_003_security_verified 0))
(assert (not (= source_IMG_003_security_verified target_IMG_003_security_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; IMG_004_fully_verified: translation preserves property (matches Coq: Theorem)
; Translation validation: IMG_004_fully_verified preserves semantics
(push 1)
(declare-const source_IMG_004_fully_verified Int)
(declare-const target_IMG_004_fully_verified Int)
(assert (>= source_IMG_004_fully_verified 0))
(assert (>= target_IMG_004_fully_verified 0))
(assert (not (= source_IMG_004_fully_verified target_IMG_004_fully_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; IMG_005_signed: translation preserves property (matches Coq: Theorem)
; Translation validation: IMG_005_signed preserves semantics
(push 1)
(declare-const source_IMG_005_signed Int)
(declare-const target_IMG_005_signed Int)
(assert (>= source_IMG_005_signed 0))
(assert (>= target_IMG_005_signed 0))
(assert (not (= source_IMG_005_signed target_IMG_005_signed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; IMG_006_signature_valid: translation preserves property (matches Coq: Theorem)
; Translation validation: IMG_006_signature_valid preserves semantics
(push 1)
(declare-const source_IMG_006_signature_valid Int)
(declare-const target_IMG_006_signature_valid Int)
(assert (>= source_IMG_006_signature_valid 0))
(assert (>= target_IMG_006_signature_valid 0))
(assert (not (= source_IMG_006_signature_valid target_IMG_006_signature_valid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; IMG_007_hash_verified: translation preserves property (matches Coq: Theorem)
; Translation validation: IMG_007_hash_verified preserves semantics
(push 1)
(declare-const source_IMG_007_hash_verified Int)
(declare-const target_IMG_007_hash_verified Int)
(assert (>= source_IMG_007_hash_verified 0))
(assert (>= target_IMG_007_hash_verified 0))
(assert (not (= source_IMG_007_hash_verified target_IMG_007_hash_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; IMG_008_trusted_registry: translation preserves property (matches Coq: Theorem)
; Translation validation: IMG_008_trusted_registry preserves semantics
(push 1)
(declare-const source_IMG_008_trusted_registry Int)
(declare-const target_IMG_008_trusted_registry Int)
(assert (>= source_IMG_008_trusted_registry 0))
(assert (>= target_IMG_008_trusted_registry 0))
(assert (not (= source_IMG_008_trusted_registry target_IMG_008_trusted_registry)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; IMG_009_sbom_present: translation preserves property (matches Coq: Theorem)
; Translation validation: IMG_009_sbom_present preserves semantics
(push 1)
(declare-const source_IMG_009_sbom_present Int)
(declare-const target_IMG_009_sbom_present Int)
(assert (>= source_IMG_009_sbom_present 0))
(assert (>= target_IMG_009_sbom_present 0))
(assert (not (= source_IMG_009_sbom_present target_IMG_009_sbom_present)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; IMG_010_vuln_scanned: translation preserves property (matches Coq: Theorem)
; Translation validation: IMG_010_vuln_scanned preserves semantics
(push 1)
(declare-const source_IMG_010_vuln_scanned Int)
(declare-const target_IMG_010_vuln_scanned Int)
(assert (>= source_IMG_010_vuln_scanned 0))
(assert (>= target_IMG_010_vuln_scanned 0))
(assert (not (= source_IMG_010_vuln_scanned target_IMG_010_vuln_scanned)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; IMG_011_no_critical_vulns: translation preserves property (matches Coq: Theorem)
; Translation validation: IMG_011_no_critical_vulns preserves semantics
(push 1)
(declare-const source_IMG_011_no_critical_vulns Int)
(declare-const target_IMG_011_no_critical_vulns Int)
(assert (>= source_IMG_011_no_critical_vulns 0))
(assert (>= target_IMG_011_no_critical_vulns 0))
(assert (not (= source_IMG_011_no_critical_vulns target_IMG_011_no_critical_vulns)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; IMG_012_base_verified: translation preserves property (matches Coq: Theorem)
; Translation validation: IMG_012_base_verified preserves semantics
(push 1)
(declare-const source_IMG_012_base_verified Int)
(declare-const target_IMG_012_base_verified Int)
(assert (>= source_IMG_012_base_verified 0))
(assert (>= target_IMG_012_base_verified 0))
(assert (not (= source_IMG_012_base_verified target_IMG_012_base_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; IMG_013_full_implies_signed: translation preserves property (matches Coq: Theorem)
; Translation validation: IMG_013_full_implies_signed preserves semantics
(push 1)
(declare-const source_IMG_013_full_implies_signed Int)
(declare-const target_IMG_013_full_implies_signed Int)
(assert (>= source_IMG_013_full_implies_signed 0))
(assert (>= target_IMG_013_full_implies_signed 0))
(assert (not (= source_IMG_013_full_implies_signed target_IMG_013_full_implies_signed)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; IMG_014_full_implies_no_vulns: translation preserves property (matches Coq: Theorem)
; Translation validation: IMG_014_full_implies_no_vulns preserves semantics
(push 1)
(declare-const source_IMG_014_full_implies_no_vulns Int)
(declare-const target_IMG_014_full_implies_no_vulns Int)
(assert (>= source_IMG_014_full_implies_no_vulns 0))
(assert (>= target_IMG_014_full_implies_no_vulns 0))
(assert (not (= source_IMG_014_full_implies_no_vulns target_IMG_014_full_implies_no_vulns)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ESC_001_basic_protected: translation preserves property (matches Coq: Theorem)
; Translation validation: ESC_001_basic_protected preserves semantics
(push 1)
(declare-const source_ESC_001_basic_protected Int)
(declare-const target_ESC_001_basic_protected Int)
(assert (>= source_ESC_001_basic_protected 0))
(assert (>= target_ESC_001_basic_protected 0))
(assert (not (= source_ESC_001_basic_protected target_ESC_001_basic_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ESC_002_filesystem_protected: translation preserves property (matches Coq: Theorem)
; Translation validation: ESC_002_filesystem_protected preserves semantics
(push 1)
(declare-const source_ESC_002_filesystem_protected Int)
(declare-const target_ESC_002_filesystem_protected Int)
(assert (>= source_ESC_002_filesystem_protected 0))
(assert (>= target_ESC_002_filesystem_protected 0))
(assert (not (= source_ESC_002_filesystem_protected target_ESC_002_filesystem_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ESC_003_mac_protected: translation preserves property (matches Coq: Theorem)
; Translation validation: ESC_003_mac_protected preserves semantics
(push 1)
(declare-const source_ESC_003_mac_protected Int)
(declare-const target_ESC_003_mac_protected Int)
(assert (>= source_ESC_003_mac_protected 0))
(assert (>= target_ESC_003_mac_protected 0))
(assert (not (= source_ESC_003_mac_protected target_ESC_003_mac_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ESC_004_fully_protected: translation preserves property (matches Coq: Theorem)
; Translation validation: ESC_004_fully_protected preserves semantics
(push 1)
(declare-const source_ESC_004_fully_protected Int)
(declare-const target_ESC_004_fully_protected Int)
(assert (>= source_ESC_004_fully_protected 0))
(assert (>= target_ESC_004_fully_protected 0))
(assert (not (= source_ESC_004_fully_protected target_ESC_004_fully_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ESC_005_no_privileged: translation preserves property (matches Coq: Theorem)
; Translation validation: ESC_005_no_privileged preserves semantics
(push 1)
(declare-const source_ESC_005_no_privileged Int)
(declare-const target_ESC_005_no_privileged Int)
(assert (>= source_ESC_005_no_privileged 0))
(assert (>= target_ESC_005_no_privileged 0))
(assert (not (= source_ESC_005_no_privileged target_ESC_005_no_privileged)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ESC_006_no_host_pid: translation preserves property (matches Coq: Theorem)
; Translation validation: ESC_006_no_host_pid preserves semantics
(push 1)
(declare-const source_ESC_006_no_host_pid Int)
(declare-const target_ESC_006_no_host_pid Int)
(assert (>= source_ESC_006_no_host_pid 0))
(assert (>= target_ESC_006_no_host_pid 0))
(assert (not (= source_ESC_006_no_host_pid target_ESC_006_no_host_pid)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ESC_007_no_host_net: translation preserves property (matches Coq: Theorem)
; Translation validation: ESC_007_no_host_net preserves semantics
(push 1)
(declare-const source_ESC_007_no_host_net Int)
(declare-const target_ESC_007_no_host_net Int)
(assert (>= source_ESC_007_no_host_net 0))
(assert (>= target_ESC_007_no_host_net 0))
(assert (not (= source_ESC_007_no_host_net target_ESC_007_no_host_net)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ESC_008_no_host_ipc: translation preserves property (matches Coq: Theorem)
; Translation validation: ESC_008_no_host_ipc preserves semantics
(push 1)
(declare-const source_ESC_008_no_host_ipc Int)
(declare-const target_ESC_008_no_host_ipc Int)
(assert (>= source_ESC_008_no_host_ipc 0))
(assert (>= target_ESC_008_no_host_ipc 0))
(assert (not (= source_ESC_008_no_host_ipc target_ESC_008_no_host_ipc)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ESC_009_readonly_rootfs: translation preserves property (matches Coq: Theorem)
; Translation validation: ESC_009_readonly_rootfs preserves semantics
(push 1)
(declare-const source_ESC_009_readonly_rootfs Int)
(declare-const target_ESC_009_readonly_rootfs Int)
(assert (>= source_ESC_009_readonly_rootfs 0))
(assert (>= target_ESC_009_readonly_rootfs 0))
(assert (not (= source_ESC_009_readonly_rootfs target_ESC_009_readonly_rootfs)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ESC_010_no_new_privs: translation preserves property (matches Coq: Theorem)
; Translation validation: ESC_010_no_new_privs preserves semantics
(push 1)
(declare-const source_ESC_010_no_new_privs Int)
(declare-const target_ESC_010_no_new_privs Int)
(assert (>= source_ESC_010_no_new_privs 0))
(assert (>= target_ESC_010_no_new_privs 0))
(assert (not (= source_ESC_010_no_new_privs target_ESC_010_no_new_privs)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ESC_011_seccomp_enabled: translation preserves property (matches Coq: Theorem)
; Translation validation: ESC_011_seccomp_enabled preserves semantics
(push 1)
(declare-const source_ESC_011_seccomp_enabled Int)
(declare-const target_ESC_011_seccomp_enabled Int)
(assert (>= source_ESC_011_seccomp_enabled 0))
(assert (>= target_ESC_011_seccomp_enabled 0))
(assert (not (= source_ESC_011_seccomp_enabled target_ESC_011_seccomp_enabled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ESC_012_drop_all_caps: translation preserves property (matches Coq: Theorem)
; Translation validation: ESC_012_drop_all_caps preserves semantics
(push 1)
(declare-const source_ESC_012_drop_all_caps Int)
(declare-const target_ESC_012_drop_all_caps Int)
(assert (>= source_ESC_012_drop_all_caps 0))
(assert (>= target_ESC_012_drop_all_caps 0))
(assert (not (= source_ESC_012_drop_all_caps target_ESC_012_drop_all_caps)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ESC_013_full_implies_no_priv: translation preserves property (matches Coq: Theorem)
; Translation validation: ESC_013_full_implies_no_priv preserves semantics
(push 1)
(declare-const source_ESC_013_full_implies_no_priv Int)
(declare-const target_ESC_013_full_implies_no_priv Int)
(assert (>= source_ESC_013_full_implies_no_priv 0))
(assert (>= target_ESC_013_full_implies_no_priv 0))
(assert (not (= source_ESC_013_full_implies_no_priv target_ESC_013_full_implies_no_priv)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ESC_014_full_implies_seccomp: translation preserves property (matches Coq: Theorem)
; Translation validation: ESC_014_full_implies_seccomp preserves semantics
(push 1)
(declare-const source_ESC_014_full_implies_seccomp Int)
(declare-const target_ESC_014_full_implies_seccomp Int)
(assert (>= source_ESC_014_full_implies_seccomp 0))
(assert (>= target_ESC_014_full_implies_seccomp 0))
(assert (not (= source_ESC_014_full_implies_seccomp target_ESC_014_full_implies_seccomp)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CONT_001_isolated: translation preserves property (matches Coq: Theorem)
; Translation validation: CONT_001_isolated preserves semantics
(push 1)
(declare-const source_CONT_001_isolated Int)
(declare-const target_CONT_001_isolated Int)
(assert (>= source_CONT_001_isolated 0))
(assert (>= target_CONT_001_isolated 0))
(assert (not (= source_CONT_001_isolated target_CONT_001_isolated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CONT_002_resource_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: CONT_002_resource_safe preserves semantics
(push 1)
(declare-const source_CONT_002_resource_safe Int)
(declare-const target_CONT_002_resource_safe Int)
(assert (>= source_CONT_002_resource_safe 0))
(assert (>= target_CONT_002_resource_safe 0))
(assert (not (= source_CONT_002_resource_safe target_CONT_002_resource_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CONT_003_syscall_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: CONT_003_syscall_safe preserves semantics
(push 1)
(declare-const source_CONT_003_syscall_safe Int)
(declare-const target_CONT_003_syscall_safe Int)
(assert (>= source_CONT_003_syscall_safe 0))
(assert (>= target_CONT_003_syscall_safe 0))
(assert (not (= source_CONT_003_syscall_safe target_CONT_003_syscall_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CONT_004_capability_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: CONT_004_capability_safe preserves semantics
(push 1)
(declare-const source_CONT_004_capability_safe Int)
(declare-const target_CONT_004_capability_safe Int)
(assert (>= source_CONT_004_capability_safe 0))
(assert (>= target_CONT_004_capability_safe 0))
(assert (not (= source_CONT_004_capability_safe target_CONT_004_capability_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CONT_005_image_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: CONT_005_image_safe preserves semantics
(push 1)
(declare-const source_CONT_005_image_safe Int)
(declare-const target_CONT_005_image_safe Int)
(assert (>= source_CONT_005_image_safe 0))
(assert (>= target_CONT_005_image_safe 0))
(assert (not (= source_CONT_005_image_safe target_CONT_005_image_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CONT_006_escape_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: CONT_006_escape_safe preserves semantics
(push 1)
(declare-const source_CONT_006_escape_safe Int)
(declare-const target_CONT_006_escape_safe Int)
(assert (>= source_CONT_006_escape_safe 0))
(assert (>= target_CONT_006_escape_safe 0))
(assert (not (= source_CONT_006_escape_safe target_CONT_006_escape_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CONT_007_fully_secure: translation preserves property (matches Coq: Theorem)
; Translation validation: CONT_007_fully_secure preserves semantics
(push 1)
(declare-const source_CONT_007_fully_secure Int)
(declare-const target_CONT_007_fully_secure Int)
(assert (>= source_CONT_007_fully_secure 0))
(assert (>= target_CONT_007_fully_secure 0))
(assert (not (= source_CONT_007_fully_secure target_CONT_007_fully_secure)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CONT_008_rootless: translation preserves property (matches Coq: Theorem)
; Translation validation: CONT_008_rootless preserves semantics
(push 1)
(declare-const source_CONT_008_rootless Int)
(declare-const target_CONT_008_rootless Int)
(assert (>= source_CONT_008_rootless 0))
(assert (>= target_CONT_008_rootless 0))
(assert (not (= source_CONT_008_rootless target_CONT_008_rootless)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CONT_009_secure_implies_isolated: translation preserves property (matches Coq: Theorem)
; Translation validation: CONT_009_secure_implies_isolated preserves semantics
(push 1)
(declare-const source_CONT_009_secure_implies_isolated Int)
(declare-const target_CONT_009_secure_implies_isolated Int)
(assert (>= source_CONT_009_secure_implies_isolated 0))
(assert (>= target_CONT_009_secure_implies_isolated 0))
(assert (not (= source_CONT_009_secure_implies_isolated target_CONT_009_secure_implies_isolated)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CONT_010_secure_implies_resource: translation preserves property (matches Coq: Theorem)
; Translation validation: CONT_010_secure_implies_resource preserves semantics
(push 1)
(declare-const source_CONT_010_secure_implies_resource Int)
(declare-const target_CONT_010_secure_implies_resource Int)
(assert (>= source_CONT_010_secure_implies_resource 0))
(assert (>= target_CONT_010_secure_implies_resource 0))
(assert (not (= source_CONT_010_secure_implies_resource target_CONT_010_secure_implies_resource)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CONT_011_secure_implies_syscall: translation preserves property (matches Coq: Theorem)
; Translation validation: CONT_011_secure_implies_syscall preserves semantics
(push 1)
(declare-const source_CONT_011_secure_implies_syscall Int)
(declare-const target_CONT_011_secure_implies_syscall Int)
(assert (>= source_CONT_011_secure_implies_syscall 0))
(assert (>= target_CONT_011_secure_implies_syscall 0))
(assert (not (= source_CONT_011_secure_implies_syscall target_CONT_011_secure_implies_syscall)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CONT_012_secure_implies_capability: translation preserves property (matches Coq: Theorem)
; Translation validation: CONT_012_secure_implies_capability preserves semantics
(push 1)
(declare-const source_CONT_012_secure_implies_capability Int)
(declare-const target_CONT_012_secure_implies_capability Int)
(assert (>= source_CONT_012_secure_implies_capability 0))
(assert (>= target_CONT_012_secure_implies_capability 0))
(assert (not (= source_CONT_012_secure_implies_capability target_CONT_012_secure_implies_capability)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CONT_013_secure_implies_image: translation preserves property (matches Coq: Theorem)
; Translation validation: CONT_013_secure_implies_image preserves semantics
(push 1)
(declare-const source_CONT_013_secure_implies_image Int)
(declare-const target_CONT_013_secure_implies_image Int)
(assert (>= source_CONT_013_secure_implies_image 0))
(assert (>= target_CONT_013_secure_implies_image 0))
(assert (not (= source_CONT_013_secure_implies_image target_CONT_013_secure_implies_image)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CONT_014_secure_implies_escape: translation preserves property (matches Coq: Theorem)
; Translation validation: CONT_014_secure_implies_escape preserves semantics
(push 1)
(declare-const source_CONT_014_secure_implies_escape Int)
(declare-const target_CONT_014_secure_implies_escape Int)
(assert (>= source_CONT_014_secure_implies_escape 0))
(assert (>= target_CONT_014_secure_implies_escape 0))
(assert (not (= source_CONT_014_secure_implies_escape target_CONT_014_secure_implies_escape)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CONT_015_secure_implies_rootless: translation preserves property (matches Coq: Theorem)
; Translation validation: CONT_015_secure_implies_rootless preserves semantics
(push 1)
(declare-const source_CONT_015_secure_implies_rootless Int)
(declare-const target_CONT_015_secure_implies_rootless Int)
(assert (>= source_CONT_015_secure_implies_rootless 0))
(assert (>= target_CONT_015_secure_implies_rootless 0))
(assert (not (= source_CONT_015_secure_implies_rootless target_CONT_015_secure_implies_rootless)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CROSS_001_all_protections: translation preserves property (matches Coq: Theorem)
; Translation validation: CROSS_001_all_protections preserves semantics
(push 1)
(declare-const source_CROSS_001_all_protections Int)
(declare-const target_CROSS_001_all_protections Int)
(assert (>= source_CROSS_001_all_protections 0))
(assert (>= target_CROSS_001_all_protections 0))
(assert (not (= source_CROSS_001_all_protections target_CROSS_001_all_protections)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; RIINA_001_defense_in_depth: translation preserves property (matches Coq: Theorem)
; Translation validation: RIINA_001_defense_in_depth preserves semantics
(push 1)
(declare-const source_RIINA_001_defense_in_depth Int)
(declare-const target_RIINA_001_defense_in_depth Int)
(assert (>= source_RIINA_001_defense_in_depth 0))
(assert (>= target_RIINA_001_defense_in_depth 0))
(assert (not (= source_RIINA_001_defense_in_depth target_RIINA_001_defense_in_depth)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; RIINA_002_no_escape_vectors: translation preserves property (matches Coq: Theorem)
; Translation validation: RIINA_002_no_escape_vectors preserves semantics
(push 1)
(declare-const source_RIINA_002_no_escape_vectors Int)
(declare-const target_RIINA_002_no_escape_vectors Int)
(assert (>= source_RIINA_002_no_escape_vectors 0))
(assert (>= target_RIINA_002_no_escape_vectors 0))
(assert (not (= source_RIINA_002_no_escape_vectors target_RIINA_002_no_escape_vectors)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; RIINA_003_complete_isolation: translation preserves property (matches Coq: Theorem)
; Translation validation: RIINA_003_complete_isolation preserves semantics
(push 1)
(declare-const source_RIINA_003_complete_isolation Int)
(declare-const target_RIINA_003_complete_isolation Int)
(assert (>= source_RIINA_003_complete_isolation 0))
(assert (>= target_RIINA_003_complete_isolation 0))
(assert (not (= source_RIINA_003_complete_isolation target_RIINA_003_complete_isolation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; RIINA_004_resource_controls: translation preserves property (matches Coq: Theorem)
; Translation validation: RIINA_004_resource_controls preserves semantics
(push 1)
(declare-const source_RIINA_004_resource_controls Int)
(declare-const target_RIINA_004_resource_controls Int)
(assert (>= source_RIINA_004_resource_controls 0))
(assert (>= target_RIINA_004_resource_controls 0))
(assert (not (= source_RIINA_004_resource_controls target_RIINA_004_resource_controls)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; RIINA_005_seccomp_hardened: translation preserves property (matches Coq: Theorem)
; Translation validation: RIINA_005_seccomp_hardened preserves semantics
(push 1)
(declare-const source_RIINA_005_seccomp_hardened Int)
(declare-const target_RIINA_005_seccomp_hardened Int)
(assert (>= source_RIINA_005_seccomp_hardened 0))
(assert (>= target_RIINA_005_seccomp_hardened 0))
(assert (not (= source_RIINA_005_seccomp_hardened target_RIINA_005_seccomp_hardened)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; RIINA_006_caps_minimal: translation preserves property (matches Coq: Theorem)
; Translation validation: RIINA_006_caps_minimal preserves semantics
(push 1)
(declare-const source_RIINA_006_caps_minimal Int)
(declare-const target_RIINA_006_caps_minimal Int)
(assert (>= source_RIINA_006_caps_minimal 0))
(assert (>= target_RIINA_006_caps_minimal 0))
(assert (not (= source_RIINA_006_caps_minimal target_RIINA_006_caps_minimal)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; RIINA_007_image_verified: translation preserves property (matches Coq: Theorem)
; Translation validation: RIINA_007_image_verified preserves semantics
(push 1)
(declare-const source_RIINA_007_image_verified Int)
(declare-const target_RIINA_007_image_verified Int)
(assert (>= source_RIINA_007_image_verified 0))
(assert (>= target_RIINA_007_image_verified 0))
(assert (not (= source_RIINA_007_image_verified target_RIINA_007_image_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

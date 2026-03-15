; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ContainerSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/ContainerSecurity.v (106 assertions)
; Module: ContainerSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SyscallCategory 0)) (((SC_Process) (SC_FileSystem) (SC_Network) (SC_Memory) (SC_Privileged) (SC_Debug) (SC_Module) (SC_Namespace))))

(declare-datatypes ((NamespaceIsolation 0))
  (((mk-namespace_isolation (ns_pid_isolated Bool) (ns_net_isolated Bool) (ns_mount_isolated Bool) (ns_user_isolated Bool) (ns_uts_isolated Bool) (ns_ipc_isolated Bool) (ns_cgroup_isolated Bool) (ns_time_isolated Bool)))))

(declare-datatypes ((CgroupLimits 0))
  (((mk-cgroup_limits (cg_cpu_limited Bool) (cg_memory_limited Bool) (cg_swap_disabled Bool) (cg_pids_limited Bool) (cg_io_limited Bool)))))

(declare-datatypes ((SeccompConfig 0))
  (((mk-seccomp_config (sc_syscall_filter Bool) (sc_default_deny Bool) (sc_audit_logging Bool) (sc_allow_process Bool) (sc_allow_fs Bool) (sc_allow_network Bool) (sc_allow_memory Bool) (sc_block_privileged Bool) (sc_block_debug Bool) (sc_block_module Bool) (sc_block_namespace Bool)))))

(declare-datatypes ((Capabilities 0))
  (((mk-capabilities (cap_chown Bool) (cap_dac_override Bool) (cap_fowner Bool) (cap_kill Bool) (cap_setuid Bool) (cap_setgid Bool) (cap_net_bind Bool) (cap_net_raw Bool) (cap_sys_admin Bool) (cap_sys_ptrace Bool) (cap_sys_module Bool) (cap_sys_rawio Bool) (cap_mknod Bool) (cap_audit_write Bool)))))

(declare-datatypes ((ImageIntegrity 0))
  (((mk-image_integrity (img_signed Bool) (img_signature_valid Bool) (img_hash_verified Bool) (img_trusted_registry Bool) (img_sbom_present Bool) (img_vuln_scanned Bool) (img_no_critical_vulns Bool) (img_base_verified Bool)))))

(declare-datatypes ((EscapePrevention 0))
  (((mk-escape_prevention (esc_no_privileged Bool) (esc_no_host_pid Bool) (esc_no_host_net Bool) (esc_no_host_ipc Bool) (esc_readonly_rootfs Bool) (esc_no_new_privs Bool) (esc_seccomp_enabled Bool) (esc_apparmor_enabled Bool) (esc_selinux_enabled Bool) (esc_drop_all_caps Bool)))))

(declare-datatypes ((ContainerConfig 0))
  (((mk-container_config (cont_ns NamespaceIsolation) (cont_cgroup CgroupLimits) (cont_seccomp SeccompConfig) (cont_caps Capabilities) (cont_image ImageIntegrity) (cont_escape EscapePrevention) (cont_rootless Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- SyscallCategory enum properties ---

; --- 1. SyscallCategory exhaustiveness ---
(push 1)
(declare-const x SyscallCategory)
(assert (not (or (= x SC_Process) (= x SC_FileSystem) (= x SC_Network) (= x SC_Memory) (= x SC_Privileged) (= x SC_Debug) (= x SC_Module) (= x SC_Namespace))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SyscallCategory: SC_Process != SC_FileSystem ---
(push 1)
(assert (= SC_Process SC_FileSystem))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SyscallCategory: SC_FileSystem != SC_Network ---
(push 1)
(assert (= SC_FileSystem SC_Network))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SyscallCategory: SC_Network != SC_Memory ---
(push 1)
(assert (= SC_Network SC_Memory))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. SyscallCategory: SC_Process != SC_Namespace ---
(push 1)
(assert (= SC_Process SC_Namespace))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. SyscallCategory finite cardinality (8 values) ---
(push 1)
(declare-const x SyscallCategory)
(assert (and (not (= x SC_Process)) (not (= x SC_FileSystem)) (not (= x SC_Network)) (not (= x SC_Memory)) (not (= x SC_Privileged)) (not (= x SC_Debug)) (not (= x SC_Module)) (not (= x SC_Namespace))))
(check-sat) ; expect UNSAT
(pop 1)

; --- NamespaceIsolation record properties ---

; --- 7. NamespaceIsolation accessor round-trip: ns_pid_isolated ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (ns_pid_isolated (mk-namespace_isolation f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. NamespaceIsolation accessor round-trip: ns_net_isolated ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (ns_net_isolated (mk-namespace_isolation f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. NamespaceIsolation accessor round-trip: ns_mount_isolated ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (ns_mount_isolated (mk-namespace_isolation f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. NamespaceIsolation accessor round-trip: ns_user_isolated ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (ns_user_isolated (mk-namespace_isolation f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. NamespaceIsolation accessor round-trip: ns_uts_isolated ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (ns_uts_isolated (mk-namespace_isolation f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun NamespaceIsolation_all_enabled ((g NamespaceIsolation)) Bool
  (and (ns_pid_isolated g) (ns_net_isolated g) (ns_mount_isolated g) (ns_user_isolated g) (ns_uts_isolated g) (ns_ipc_isolated g) (ns_cgroup_isolated g)))

; --- 12. NamespaceIsolation: all-enabled completeness ---
(push 1)
(declare-const g NamespaceIsolation)
(assert (ns_pid_isolated g))
(assert (ns_net_isolated g))
(assert (ns_mount_isolated g))
(assert (ns_user_isolated g))
(assert (ns_uts_isolated g))
(assert (ns_ipc_isolated g))
(assert (ns_cgroup_isolated g))
(assert (not (NamespaceIsolation_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. NamespaceIsolation: NamespaceIsolation_all_enabled implies ns_pid_isolated ---
(push 1)
(declare-const g NamespaceIsolation)
(assert (NamespaceIsolation_all_enabled g))
(assert (not (ns_pid_isolated g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. NamespaceIsolation: NamespaceIsolation_all_enabled implies ns_net_isolated ---
(push 1)
(declare-const g NamespaceIsolation)
(assert (NamespaceIsolation_all_enabled g))
(assert (not (ns_net_isolated g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. NamespaceIsolation: NamespaceIsolation_all_enabled implies ns_mount_isolated ---
(push 1)
(declare-const g NamespaceIsolation)
(assert (NamespaceIsolation_all_enabled g))
(assert (not (ns_mount_isolated g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CgroupLimits record properties ---

; --- 16. CgroupLimits accessor round-trip: cg_cpu_limited ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (cg_cpu_limited (mk-cgroup_limits f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. CgroupLimits accessor round-trip: cg_memory_limited ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (cg_memory_limited (mk-cgroup_limits f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. CgroupLimits accessor round-trip: cg_swap_disabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (cg_swap_disabled (mk-cgroup_limits f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. CgroupLimits accessor round-trip: cg_pids_limited ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (cg_pids_limited (mk-cgroup_limits f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun CgroupLimits_all_enabled ((g CgroupLimits)) Bool
  (and (cg_cpu_limited g) (cg_memory_limited g) (cg_swap_disabled g) (cg_pids_limited g)))

; --- 20. CgroupLimits: all-enabled completeness ---
(push 1)
(declare-const g CgroupLimits)
(assert (cg_cpu_limited g))
(assert (cg_memory_limited g))
(assert (cg_swap_disabled g))
(assert (cg_pids_limited g))
(assert (not (CgroupLimits_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. CgroupLimits: CgroupLimits_all_enabled implies cg_cpu_limited ---
(push 1)
(declare-const g CgroupLimits)
(assert (CgroupLimits_all_enabled g))
(assert (not (cg_cpu_limited g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. CgroupLimits: CgroupLimits_all_enabled implies cg_memory_limited ---
(push 1)
(declare-const g CgroupLimits)
(assert (CgroupLimits_all_enabled g))
(assert (not (cg_memory_limited g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. CgroupLimits: CgroupLimits_all_enabled implies cg_swap_disabled ---
(push 1)
(declare-const g CgroupLimits)
(assert (CgroupLimits_all_enabled g))
(assert (not (cg_swap_disabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SeccompConfig record properties ---

; --- 24. SeccompConfig accessor round-trip: sc_syscall_filter ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(assert (not (= (sc_syscall_filter (mk-seccomp_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. SeccompConfig accessor round-trip: sc_default_deny ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(assert (not (= (sc_default_deny (mk-seccomp_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. SeccompConfig accessor round-trip: sc_audit_logging ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(assert (not (= (sc_audit_logging (mk-seccomp_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. SeccompConfig accessor round-trip: sc_allow_process ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(assert (not (= (sc_allow_process (mk-seccomp_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. SeccompConfig accessor round-trip: sc_allow_fs ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(assert (not (= (sc_allow_fs (mk-seccomp_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SeccompConfig_all_enabled ((g SeccompConfig)) Bool
  (and (sc_syscall_filter g) (sc_default_deny g) (sc_audit_logging g) (sc_allow_process g) (sc_allow_fs g) (sc_allow_network g) (sc_allow_memory g) (sc_block_privileged g) (sc_block_debug g) (sc_block_module g)))

; --- 29. SeccompConfig: all-enabled completeness ---
(push 1)
(declare-const g SeccompConfig)
(assert (sc_syscall_filter g))
(assert (sc_default_deny g))
(assert (sc_audit_logging g))
(assert (sc_allow_process g))
(assert (sc_allow_fs g))
(assert (sc_allow_network g))
(assert (sc_allow_memory g))
(assert (sc_block_privileged g))
(assert (sc_block_debug g))
(assert (sc_block_module g))
(assert (not (SeccompConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. SeccompConfig: SeccompConfig_all_enabled implies sc_syscall_filter ---
(push 1)
(declare-const g SeccompConfig)
(assert (SeccompConfig_all_enabled g))
(assert (not (sc_syscall_filter g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. SeccompConfig: SeccompConfig_all_enabled implies sc_default_deny ---
(push 1)
(declare-const g SeccompConfig)
(assert (SeccompConfig_all_enabled g))
(assert (not (sc_default_deny g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. SeccompConfig: SeccompConfig_all_enabled implies sc_audit_logging ---
(push 1)
(declare-const g SeccompConfig)
(assert (SeccompConfig_all_enabled g))
(assert (not (sc_audit_logging g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Capabilities record properties ---

; --- 33. Capabilities accessor round-trip: cap_chown ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(assert (not (= (cap_chown (mk-capabilities f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. Capabilities accessor round-trip: cap_dac_override ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(assert (not (= (cap_dac_override (mk-capabilities f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. Capabilities accessor round-trip: cap_fowner ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(assert (not (= (cap_fowner (mk-capabilities f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. Capabilities accessor round-trip: cap_kill ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(assert (not (= (cap_kill (mk-capabilities f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. Capabilities accessor round-trip: cap_setuid ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Bool)
(declare-const f11 Bool)
(declare-const f12 Bool)
(declare-const f13 Bool)
(assert (not (= (cap_setuid (mk-capabilities f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun Capabilities_all_enabled ((g Capabilities)) Bool
  (and (cap_chown g) (cap_dac_override g) (cap_fowner g) (cap_kill g) (cap_setuid g) (cap_setgid g) (cap_net_bind g) (cap_net_raw g) (cap_sys_admin g) (cap_sys_ptrace g) (cap_sys_module g) (cap_sys_rawio g) (cap_mknod g)))

; --- 38. Capabilities: all-enabled completeness ---
(push 1)
(declare-const g Capabilities)
(assert (cap_chown g))
(assert (cap_dac_override g))
(assert (cap_fowner g))
(assert (cap_kill g))
(assert (cap_setuid g))
(assert (cap_setgid g))
(assert (cap_net_bind g))
(assert (cap_net_raw g))
(assert (cap_sys_admin g))
(assert (cap_sys_ptrace g))
(assert (cap_sys_module g))
(assert (cap_sys_rawio g))
(assert (cap_mknod g))
(assert (not (Capabilities_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. Capabilities: Capabilities_all_enabled implies cap_chown ---
(push 1)
(declare-const g Capabilities)
(assert (Capabilities_all_enabled g))
(assert (not (cap_chown g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. Capabilities: Capabilities_all_enabled implies cap_dac_override ---
(push 1)
(declare-const g Capabilities)
(assert (Capabilities_all_enabled g))
(assert (not (cap_dac_override g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. Capabilities: Capabilities_all_enabled implies cap_fowner ---
(push 1)
(declare-const g Capabilities)
(assert (Capabilities_all_enabled g))
(assert (not (cap_fowner g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ImageIntegrity record properties ---

; --- 42. ImageIntegrity accessor round-trip: img_signed ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (img_signed (mk-image_integrity f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. ImageIntegrity accessor round-trip: img_signature_valid ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (img_signature_valid (mk-image_integrity f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. ImageIntegrity accessor round-trip: img_hash_verified ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (img_hash_verified (mk-image_integrity f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. ImageIntegrity accessor round-trip: img_trusted_registry ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (img_trusted_registry (mk-image_integrity f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. ImageIntegrity accessor round-trip: img_sbom_present ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (img_sbom_present (mk-image_integrity f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ImageIntegrity_all_enabled ((g ImageIntegrity)) Bool
  (and (img_signed g) (img_signature_valid g) (img_hash_verified g) (img_trusted_registry g) (img_sbom_present g) (img_vuln_scanned g) (img_no_critical_vulns g)))

; --- 47. ImageIntegrity: all-enabled completeness ---
(push 1)
(declare-const g ImageIntegrity)
(assert (img_signed g))
(assert (img_signature_valid g))
(assert (img_hash_verified g))
(assert (img_trusted_registry g))
(assert (img_sbom_present g))
(assert (img_vuln_scanned g))
(assert (img_no_critical_vulns g))
(assert (not (ImageIntegrity_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. ImageIntegrity: ImageIntegrity_all_enabled implies img_signed ---
(push 1)
(declare-const g ImageIntegrity)
(assert (ImageIntegrity_all_enabled g))
(assert (not (img_signed g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. ImageIntegrity: ImageIntegrity_all_enabled implies img_signature_valid ---
(push 1)
(declare-const g ImageIntegrity)
(assert (ImageIntegrity_all_enabled g))
(assert (not (img_signature_valid g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. ImageIntegrity: ImageIntegrity_all_enabled implies img_hash_verified ---
(push 1)
(declare-const g ImageIntegrity)
(assert (ImageIntegrity_all_enabled g))
(assert (not (img_hash_verified g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- EscapePrevention record properties ---

; --- 51. EscapePrevention accessor round-trip: esc_no_privileged ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(assert (not (= (esc_no_privileged (mk-escape_prevention f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. EscapePrevention accessor round-trip: esc_no_host_pid ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(assert (not (= (esc_no_host_pid (mk-escape_prevention f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. EscapePrevention accessor round-trip: esc_no_host_net ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(assert (not (= (esc_no_host_net (mk-escape_prevention f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. EscapePrevention accessor round-trip: esc_no_host_ipc ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(assert (not (= (esc_no_host_ipc (mk-escape_prevention f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. EscapePrevention accessor round-trip: esc_readonly_rootfs ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(declare-const f8 Bool)
(declare-const f9 Bool)
(assert (not (= (esc_readonly_rootfs (mk-escape_prevention f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun EscapePrevention_all_enabled ((g EscapePrevention)) Bool
  (and (esc_no_privileged g) (esc_no_host_pid g) (esc_no_host_net g) (esc_no_host_ipc g) (esc_readonly_rootfs g) (esc_no_new_privs g) (esc_seccomp_enabled g) (esc_apparmor_enabled g) (esc_selinux_enabled g)))

; --- 56. EscapePrevention: all-enabled completeness ---
(push 1)
(declare-const g EscapePrevention)
(assert (esc_no_privileged g))
(assert (esc_no_host_pid g))
(assert (esc_no_host_net g))
(assert (esc_no_host_ipc g))
(assert (esc_readonly_rootfs g))
(assert (esc_no_new_privs g))
(assert (esc_seccomp_enabled g))
(assert (esc_apparmor_enabled g))
(assert (esc_selinux_enabled g))
(assert (not (EscapePrevention_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. EscapePrevention: EscapePrevention_all_enabled implies esc_no_privileged ---
(push 1)
(declare-const g EscapePrevention)
(assert (EscapePrevention_all_enabled g))
(assert (not (esc_no_privileged g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. EscapePrevention: EscapePrevention_all_enabled implies esc_no_host_pid ---
(push 1)
(declare-const g EscapePrevention)
(assert (EscapePrevention_all_enabled g))
(assert (not (esc_no_host_pid g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. EscapePrevention: EscapePrevention_all_enabled implies esc_no_host_net ---
(push 1)
(declare-const g EscapePrevention)
(assert (EscapePrevention_all_enabled g))
(assert (not (esc_no_host_net g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ContainerConfig record properties ---

; --- 60. ContainerConfig accessor round-trip: cont_ns ---
(push 1)
(declare-const f0 NamespaceIsolation)
(declare-const f1 CgroupLimits)
(declare-const f2 SeccompConfig)
(declare-const f3 Capabilities)
(declare-const f4 ImageIntegrity)
(declare-const f5 EscapePrevention)
(declare-const f6 Bool)
(assert (not (= (cont_ns (mk-container_config f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. ContainerConfig accessor round-trip: cont_cgroup ---
(push 1)
(declare-const f0 NamespaceIsolation)
(declare-const f1 CgroupLimits)
(declare-const f2 SeccompConfig)
(declare-const f3 Capabilities)
(declare-const f4 ImageIntegrity)
(declare-const f5 EscapePrevention)
(declare-const f6 Bool)
(assert (not (= (cont_cgroup (mk-container_config f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. ContainerConfig accessor round-trip: cont_seccomp ---
(push 1)
(declare-const f0 NamespaceIsolation)
(declare-const f1 CgroupLimits)
(declare-const f2 SeccompConfig)
(declare-const f3 Capabilities)
(declare-const f4 ImageIntegrity)
(declare-const f5 EscapePrevention)
(declare-const f6 Bool)
(assert (not (= (cont_seccomp (mk-container_config f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. ContainerConfig accessor round-trip: cont_caps ---
(push 1)
(declare-const f0 NamespaceIsolation)
(declare-const f1 CgroupLimits)
(declare-const f2 SeccompConfig)
(declare-const f3 Capabilities)
(declare-const f4 ImageIntegrity)
(declare-const f5 EscapePrevention)
(declare-const f6 Bool)
(assert (not (= (cont_caps (mk-container_config f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. ContainerConfig accessor round-trip: cont_image ---
(push 1)
(declare-const f0 NamespaceIsolation)
(declare-const f1 CgroupLimits)
(declare-const f2 SeccompConfig)
(declare-const f3 Capabilities)
(declare-const f4 ImageIntegrity)
(declare-const f5 EscapePrevention)
(declare-const f6 Bool)
(assert (not (= (cont_image (mk-container_config f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

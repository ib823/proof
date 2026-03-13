---- MODULE ContainerSecurity ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/ContainerSecurity.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* SyscallCategory (matches Coq: Inductive SyscallCategory)
CONSTANTS SC_Process, SC_FileSystem, SC_Network, SC_Memory, SC_Privileged, SC_Debug, SC_Module, SC_Namespace

SyscallCategorySet == {SC_Process, SC_FileSystem, SC_Network, SC_Memory, SC_Privileged, SC_Debug, SC_Module, SC_Namespace}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* NamespaceIsolation (matches Coq: Record NamespaceIsolation)
VARIABLES ns_pid_isolated, ns_net_isolated, ns_mount_isolated, ns_user_isolated, ns_uts_isolated, ns_ipc_isolated, ns_cgroup_isolated, ns_time_isolated

\* CgroupLimits (matches Coq: Record CgroupLimits)
VARIABLES cg_cpu_limited, cg_memory_limited, cg_swap_disabled, cg_pids_limited, cg_io_limited

\* SeccompConfig (matches Coq: Record SeccompConfig)
VARIABLES sc_syscall_filter, sc_default_deny, sc_audit_logging, sc_allow_process, sc_allow_fs, sc_allow_network, sc_allow_memory, sc_block_privileged, sc_block_debug, sc_block_module, sc_block_namespace

\* Capabilities (matches Coq: Record Capabilities)
VARIABLES cap_chown, cap_dac_override, cap_fowner, cap_kill, cap_setuid, cap_setgid, cap_net_bind, cap_net_raw, cap_sys_admin, cap_sys_ptrace, cap_sys_module, cap_sys_rawio, cap_mknod, cap_audit_write

\* ImageIntegrity (matches Coq: Record ImageIntegrity)
VARIABLES img_signed, img_signature_valid, img_hash_verified, img_trusted_registry, img_sbom_present, img_vuln_scanned, img_no_critical_vulns, img_base_verified

vars == <<ns_pid_isolated, ns_net_isolated, ns_mount_isolated, ns_user_isolated, ns_uts_isolated, ns_ipc_isolated, ns_cgroup_isolated, ns_time_isolated, cg_cpu_limited, cg_memory_limited, cg_swap_disabled, cg_pids_limited, cg_io_limited, sc_syscall_filter, sc_default_deny, sc_audit_logging, sc_allow_process, sc_allow_fs, sc_allow_network, sc_allow_memory, sc_block_privileged, sc_block_debug, sc_block_module, sc_block_namespace, cap_chown, cap_dac_override, cap_fowner, cap_kill, cap_setuid, cap_setgid, cap_net_bind, cap_net_raw, cap_sys_admin, cap_sys_ptrace, cap_sys_module, cap_sys_rawio, cap_mknod, cap_audit_write, img_signed, img_signature_valid, img_hash_verified, img_trusted_registry, img_sbom_present, img_vuln_scanned, img_no_critical_vulns, img_base_verified>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ ns_pid_isolated \in BOOLEAN
  /\ ns_net_isolated \in BOOLEAN
  /\ ns_mount_isolated \in BOOLEAN
  /\ ns_user_isolated \in BOOLEAN
  /\ ns_uts_isolated \in BOOLEAN
  /\ ns_ipc_isolated \in BOOLEAN
  /\ ns_cgroup_isolated \in BOOLEAN
  /\ ns_time_isolated \in Nat
  /\ cg_cpu_limited \in BOOLEAN
  /\ cg_memory_limited \in BOOLEAN
  /\ cg_swap_disabled \in BOOLEAN
  /\ cg_pids_limited \in BOOLEAN
  /\ cg_io_limited \in Nat
  /\ sc_syscall_filter \in BOOLEAN
  /\ sc_default_deny \in BOOLEAN
  /\ sc_audit_logging \in BOOLEAN
  /\ sc_allow_process \in BOOLEAN
  /\ sc_allow_fs \in BOOLEAN
  /\ sc_allow_network \in BOOLEAN
  /\ sc_allow_memory \in BOOLEAN
  /\ sc_block_privileged \in BOOLEAN
  /\ sc_block_debug \in BOOLEAN
  /\ sc_block_module \in BOOLEAN
  /\ sc_block_namespace \in BOOLEAN
  /\ cap_chown \in BOOLEAN
  /\ cap_dac_override \in BOOLEAN
  /\ cap_fowner \in BOOLEAN
  /\ cap_kill \in BOOLEAN
  /\ cap_setuid \in BOOLEAN
  /\ cap_setgid \in BOOLEAN
  /\ cap_net_bind \in BOOLEAN
  /\ cap_net_raw \in BOOLEAN
  /\ cap_sys_admin \in BOOLEAN
  /\ cap_sys_ptrace \in BOOLEAN
  /\ cap_sys_module \in BOOLEAN
  /\ cap_sys_rawio \in BOOLEAN
  /\ cap_mknod \in BOOLEAN
  /\ cap_audit_write \in BOOLEAN
  /\ img_signed \in BOOLEAN
  /\ img_signature_valid \in BOOLEAN
  /\ img_hash_verified \in BOOLEAN
  /\ img_trusted_registry \in BOOLEAN
  /\ img_sbom_present \in BOOLEAN
  /\ img_vuln_scanned \in BOOLEAN
  /\ img_no_critical_vulns \in BOOLEAN
  /\ img_base_verified \in BOOLEAN

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ ns_pid_isolated = FALSE
  /\ ns_net_isolated = FALSE
  /\ ns_mount_isolated = FALSE
  /\ ns_user_isolated = FALSE
  /\ ns_uts_isolated = FALSE
  /\ ns_ipc_isolated = FALSE
  /\ ns_cgroup_isolated = FALSE
  /\ ns_time_isolated = 0
  /\ cg_cpu_limited = FALSE
  /\ cg_memory_limited = FALSE
  /\ cg_swap_disabled = FALSE
  /\ cg_pids_limited = FALSE
  /\ cg_io_limited = 0
  /\ sc_syscall_filter = FALSE
  /\ sc_default_deny = FALSE
  /\ sc_audit_logging = FALSE
  /\ sc_allow_process = FALSE
  /\ sc_allow_fs = FALSE
  /\ sc_allow_network = FALSE
  /\ sc_allow_memory = FALSE
  /\ sc_block_privileged = FALSE
  /\ sc_block_debug = FALSE
  /\ sc_block_module = FALSE
  /\ sc_block_namespace = FALSE
  /\ cap_chown = FALSE
  /\ cap_dac_override = FALSE
  /\ cap_fowner = FALSE
  /\ cap_kill = FALSE
  /\ cap_setuid = FALSE
  /\ cap_setgid = FALSE
  /\ cap_net_bind = FALSE
  /\ cap_net_raw = FALSE
  /\ cap_sys_admin = FALSE
  /\ cap_sys_ptrace = FALSE
  /\ cap_sys_module = FALSE
  /\ cap_sys_rawio = FALSE
  /\ cap_mknod = FALSE
  /\ cap_audit_write = FALSE
  /\ img_signed = FALSE
  /\ img_signature_valid = FALSE
  /\ img_hash_verified = FALSE
  /\ img_trusted_registry = FALSE
  /\ img_sbom_present = FALSE
  /\ img_vuln_scanned = FALSE
  /\ img_no_critical_vulns = FALSE
  /\ img_base_verified = FALSE

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* ns_fully_isolated (matches Coq: Definition ns_fully_isolated)
ns_fully_isolated(n) ==
  ns_pid_isolated /\ ns_net_isolated /\ ns_mount_isolated /\ ns_user_isolated /\ ns_uts_isolated /\ ns_ipc_isolated /\ ns_cgroup_isolated /\ ns_time_isolated

\* ns_minimally_isolated (matches Coq: Definition ns_minimally_isolated)
ns_minimally_isolated(n) ==
  ns_pid_isolated /\ ns_net_isolated /\ ns_mount_isolated /\ ns_user_isolated

\* ns_network_safe (matches Coq: Definition ns_network_safe)
ns_network_safe(n) ==
  ns_net_isolated /\ ns_uts_isolated

\* ns_process_safe (matches Coq: Definition ns_process_safe)
ns_process_safe(n) ==
  ns_pid_isolated /\ ns_ipc_isolated /\ ns_cgroup_isolated

\* cgroup_cpu_safe (matches Coq: Definition cgroup_cpu_safe)
cgroup_cpu_safe(c) ==
  cg_cpu_limited(c)

\* cgroup_memory_safe (matches Coq: Definition cgroup_memory_safe)
cgroup_memory_safe(c) ==
  cg_memory_limited /\ cg_swap_disabled

\* cgroup_pids_safe (matches Coq: Definition cgroup_pids_safe)
cgroup_pids_safe(c) ==
  cg_pids_limited(c)

\* cgroup_io_safe (matches Coq: Definition cgroup_io_safe)
cgroup_io_safe(c) ==
  cg_io_limited(c)

\* cgroup_fully_limited (matches Coq: Definition cgroup_fully_limited)
cgroup_fully_limited(c) ==
  cg_cpu_limited /\ cg_memory_limited /\ cg_swap_disabled /\ cg_pids_limited /\ cg_io_limited

\* seccomp_enforced (matches Coq: Definition seccomp_enforced)
seccomp_enforced(s) ==
  sc_syscall_filter /\ sc_default_deny /\ sc_audit_logging

\* seccomp_minimal_safe (matches Coq: Definition seccomp_minimal_safe)
seccomp_minimal_safe(s) ==
  sc_syscall_filter /\ sc_block_privileged /\ sc_block_debug

\* seccomp_escape_protected (matches Coq: Definition seccomp_escape_protected)
seccomp_escape_protected(s) ==
  sc_block_privileged /\ sc_block_module /\ sc_block_namespace

\* seccomp_fully_hardened (matches Coq: Definition seccomp_fully_hardened)
seccomp_fully_hardened(s) ==
  seccomp_enforced /\ seccomp_escape_protected /\ sc_block_debug

\* caps_dangerous_dropped (matches Coq: Definition caps_dangerous_dropped)
caps_dangerous_dropped(c) ==
  negb (cap_sys_admin c) /\ negb (cap_sys_ptrace c) /\ negb (cap_sys_module c) /\ negb (cap_sys_rawio c)

\* caps_minimal (matches Coq: Definition caps_minimal)
caps_minimal(c) ==
  caps_dangerous_dropped /\ negb (cap_net_raw c) /\ negb (cap_dac_override c) /\ negb (cap_mknod c)

\* caps_rootless_safe (matches Coq: Definition caps_rootless_safe)
caps_rootless_safe(c) ==
  caps_minimal /\ negb (cap_setuid c) /\ negb (cap_setgid c) /\ negb (cap_chown c)

\* caps_network_minimal (matches Coq: Definition caps_network_minimal)
caps_network_minimal(c) ==
  negb (cap_net_raw c) /\ cap_net_bind

\* image_authenticity_verified (matches Coq: Definition image_authenticity_verified)
image_authenticity_verified(i) ==
  img_signed /\ img_signature_valid /\ img_hash_verified

\* image_provenance_verified (matches Coq: Definition image_provenance_verified)
image_provenance_verified(i) ==
  img_trusted_registry /\ img_sbom_present /\ img_base_verified

\* image_security_verified (matches Coq: Definition image_security_verified)
image_security_verified(i) ==
  img_vuln_scanned /\ img_no_critical_vulns

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateNamespaceIsolation ==
  /\ ns_pid_isolated' \in BOOLEAN
  /\ ns_net_isolated' \in BOOLEAN
  /\ ns_mount_isolated' \in BOOLEAN
  /\ ns_user_isolated' \in BOOLEAN
  /\ ns_uts_isolated' \in BOOLEAN
  /\ ns_ipc_isolated' \in BOOLEAN
  /\ ns_cgroup_isolated' \in BOOLEAN
  /\ ns_time_isolated' \in 0..100
  /\ UNCHANGED <<cg_cpu_limited, cg_memory_limited, cg_swap_disabled, cg_pids_limited, cg_io_limited, sc_syscall_filter, sc_default_deny, sc_audit_logging, sc_allow_process, sc_allow_fs, sc_allow_network, sc_allow_memory, sc_block_privileged, sc_block_debug, sc_block_module, sc_block_namespace, cap_chown, cap_dac_override, cap_fowner, cap_kill, cap_setuid, cap_setgid, cap_net_bind, cap_net_raw, cap_sys_admin, cap_sys_ptrace, cap_sys_module, cap_sys_rawio, cap_mknod, cap_audit_write, img_signed, img_signature_valid, img_hash_verified, img_trusted_registry, img_sbom_present, img_vuln_scanned, img_no_critical_vulns, img_base_verified>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateNamespaceIsolation \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* andb_true_intro
THEOREM andb_true_intro ==
  \A a \in Nat, b \in Nat, bool \in Nat :
      a = true => a && b = true

\* andb_true_elim1
THEOREM andb_true_elim1 ==
  \A a \in Nat, b \in Nat, bool \in Nat :
      a && b = true => a = true

\* andb_true_elim2
THEOREM andb_true_elim2 ==
  \A a \in Nat, b \in Nat, bool \in Nat :
      a && b = true => b = true

\* andb7_true
THEOREM andb7_true ==
  \A a \in Nat, b \in Nat, c \in Nat, d \in Nat, e \in Nat, f \in Nat, g \in Nat, bool \in Nat :
      a && b && c && d && e && f && g = true => a = true /\ b = true /\ c = true /\ d = true /\ e = true /\ f = true /\ g = true

\* NS_001_full_isolation
THEOREM NS_001_full_isolation ==
  ns_fully_isolated(riina_ns) = TRUE

\* NS_002_minimal_isolation
THEOREM NS_002_minimal_isolation ==
  ns_minimally_isolated(riina_ns) = TRUE

\* NS_003_pid_isolated
THEOREM NS_003_pid_isolated ==
  ns_pid_isolated(riina_ns) = TRUE

\* NS_004_net_isolated
THEOREM NS_004_net_isolated ==
  ns_net_isolated(riina_ns) = TRUE

\* NS_005_mount_isolated
THEOREM NS_005_mount_isolated ==
  ns_mount_isolated(riina_ns) = TRUE

\* NS_006_user_isolated
THEOREM NS_006_user_isolated ==
  ns_user_isolated(riina_ns) = TRUE

\* NS_007_uts_isolated
THEOREM NS_007_uts_isolated ==
  ns_uts_isolated(riina_ns) = TRUE

\* NS_008_ipc_isolated
THEOREM NS_008_ipc_isolated ==
  ns_ipc_isolated(riina_ns) = TRUE

\* NS_009_cgroup_isolated
THEOREM NS_009_cgroup_isolated ==
  ns_cgroup_isolated(riina_ns) = TRUE

\* NS_010_time_isolated
THEOREM NS_010_time_isolated ==
  ns_time_isolated(riina_ns) = TRUE

\* NS_011_network_safe
THEOREM NS_011_network_safe ==
  ns_network_safe(riina_ns) = TRUE

\* NS_012_process_safe
THEOREM NS_012_process_safe ==
  ns_process_safe(riina_ns) = TRUE

\* NS_013_full_implies_pid
THEOREM NS_013_full_implies_pid ==
  \A n \in Nat :
      ns_fully_isolated(n) => ns_pid_isolated(n)

\* NS_014_full_implies_net
THEOREM NS_014_full_implies_net ==
  \A n \in Nat :
      ns_fully_isolated(n) => ns_net_isolated(n)

\* NS_015_full_implies_user
THEOREM NS_015_full_implies_user ==
  \A n \in Nat :
      ns_fully_isolated(n) => ns_user_isolated(n)

\* CG_001_cpu_safe
THEOREM CG_001_cpu_safe ==
  cgroup_cpu_safe(riina_cgroup) = TRUE

\* CG_002_memory_safe
THEOREM CG_002_memory_safe ==
  cgroup_memory_safe(riina_cgroup) = TRUE

\* CG_003_pids_safe
THEOREM CG_003_pids_safe ==
  cgroup_pids_safe(riina_cgroup) = TRUE

\* CG_004_io_safe
THEOREM CG_004_io_safe ==
  cgroup_io_safe(riina_cgroup) = TRUE

\* CG_005_fully_limited
THEOREM CG_005_fully_limited ==
  cgroup_fully_limited(riina_cgroup) = TRUE

\* CG_006_full_implies_cpu
THEOREM CG_006_full_implies_cpu ==
  \A c \in Nat :
      cgroup_fully_limited(c) => cgroup_cpu_safe(c)

\* 81 additional theorems proven in Coq source

====

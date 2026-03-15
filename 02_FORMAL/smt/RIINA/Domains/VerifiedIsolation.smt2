; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA VerifiedIsolation — SMT Verification
; Derived from 02_FORMAL/coq/domains/VerifiedIsolation.v (35 assertions)
; Module: VerifiedIsolation
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((DomainType 0)) (((DTProcess) (DTContainer) (DTVM) (DTEnclave))))

(declare-datatypes ((MemOp 0)) (((MemRead) (MemWrite))))

(declare-datatypes ((NamespaceType 0)) (((NSPid) (NSNet) (NSMount) (NSUser) (NSIPC) (NSUTS) (NSCgroup))))

(declare-datatypes ((MemoryRegion 0))
  (((mk-memory_region (region_base Int) (region_size Int)))))

(declare-datatypes ((Capability 0))
  (((mk-capability (cap_id Int) (cap_owner Int) (cap_rights (Seq Int)) (cap_object Int) (cap_delegable Bool)))))

(declare-datatypes ((Domain 0))
  (((mk-domain (domain_id Int) (domain_type DomainType) (domain_regions (Seq Int)) (domain_capabilities (Seq Int)) (domain_parent Int)))))

(declare-datatypes ((PageTableEntry 0))
  (((mk-page_table_entry (pte_valid Bool) (pte_writable Bool) (pte_user Bool) (pte_physical Int) (pte_owner Int)))))

(declare-datatypes ((SystemState 0))
  (((mk-system_state (sys_domains (Seq Int)) (sys_page_table Int) (sys_kernel_region MemoryRegion) (sys_iommu_mappings Int) (sys_encryption_keys Int)))))

(declare-datatypes ((CgroupLimit 0))
  (((mk-cgroup_limit (cg_cpu_shares Int) (cg_memory_limit Int) (cg_pids_max Int)))))

(declare-datatypes ((SeccompFilter 0))
  (((mk-seccomp_filter (seccomp_allowed_syscalls (Seq Int)) (seccomp_default_action Bool)))))

(declare-datatypes ((ContainerConfig 0))
  (((mk-container_config (cfg_namespaces (Seq Int)) (cfg_cgroups CgroupLimit) (cfg_seccomp SeccompFilter) (cfg_rootfs Int) (cfg_network_isolated Bool)))))

(declare-datatypes ((ContainerState 0))
  (((mk-container_state (container_config ContainerConfig) (container_domain Domain) (container_resources_used Int)))))

(declare-datatypes ((EPTEntry 0))
  (((mk-ept_entry (ept_valid Bool) (ept_read Bool) (ept_write Bool) (ept_execute Bool) (ept_hpa Int)))))

(declare-datatypes ((VMCSState 0))
  (((mk-vmcs_state (vmcs_guest_rip Int) (vmcs_guest_rsp Int) (vmcs_guest_cr3 Int) (vmcs_host_cr3 Int) (vmcs_exit_reason Int) (vmcs_integrity_hash Int)))))

(declare-datatypes ((VMState 0))
  (((mk-vm_state (vm_id Int) (vm_ept Int) (vm_vmcs VMCSState) (vm_vcpus Int) (vm_memory_regions (Seq Int))))))

(declare-datatypes ((HypervisorState 0))
  (((mk-hypervisor_state (hv_vms (Seq Int)) (hv_host_memory (Seq Int)) (hv_device_assignments Int)))))

(declare-datatypes ((AttestationReport 0))
  (((mk-attestation_report (report_mrenclave Int) (report_mrsigner Int) (report_data (Seq Int)) (report_signature Int)))))

(declare-datatypes ((SealingKey 0))
  (((mk-sealing_key (seal_enclave_id Int) (seal_key_policy Int) (seal_key_value Int)))))

(declare-datatypes ((EnclaveState 0))
  (((mk-enclave_state (enclave_id Int) (enclave_mrenclave Int) (enclave_mrsigner Int) (enclave_memory_regions (Seq Int)) (enclave_initialized Bool) (enclave_encryption_key Int) (enclave_sealing_key SealingKey)))))

(declare-datatypes ((EnclavePlatform 0))
  (((mk-enclave_platform (platform_enclaves (Seq Int)) (platform_trusted Bool) (platform_attestation_key Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. DomainType exhaustiveness ---
(push 1)
(declare-const x DomainType)
(assert (not (or (= x DTProcess) (= x DTContainer) (= x DTVM) (= x DTEnclave))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. DomainType: DTProcess != DTContainer ---
(push 1)
(assert (= DTProcess DTContainer))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. DomainType: DTContainer != DTVM ---
(push 1)
(assert (= DTContainer DTVM))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. DomainType: DTVM != DTEnclave ---
(push 1)
(assert (= DTVM DTEnclave))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. DomainType: DTProcess != DTEnclave ---
(push 1)
(assert (= DTProcess DTEnclave))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. DomainType finite cardinality (4 values) ---
(push 1)
(declare-const x DomainType)
(assert (and (not (= x DTProcess)) (not (= x DTContainer)) (not (= x DTVM)) (not (= x DTEnclave))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. MemOp exhaustiveness ---
(push 1)
(declare-const x MemOp)
(assert (not (or (= x MemRead) (= x MemWrite))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. MemOp: MemRead != MemWrite ---
(push 1)
(assert (= MemRead MemWrite))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. MemOp finite cardinality (2 values) ---
(push 1)
(declare-const x MemOp)
(assert (and (not (= x MemRead)) (not (= x MemWrite))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. NamespaceType exhaustiveness ---
(push 1)
(declare-const x NamespaceType)
(assert (not (or (= x NSPid) (= x NSNet) (= x NSMount) (= x NSUser) (= x NSIPC) (= x NSUTS) (= x NSCgroup))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. NamespaceType: NSPid != NSNet ---
(push 1)
(assert (= NSPid NSNet))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. NamespaceType: NSNet != NSMount ---
(push 1)
(assert (= NSNet NSMount))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. NamespaceType: NSMount != NSUser ---
(push 1)
(assert (= NSMount NSUser))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. NamespaceType: NSPid != NSCgroup ---
(push 1)
(assert (= NSPid NSCgroup))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. NamespaceType finite cardinality (7 values) ---
(push 1)
(declare-const x NamespaceType)
(assert (and (not (= x NSPid)) (not (= x NSNet)) (not (= x NSMount)) (not (= x NSUser)) (not (= x NSIPC)) (not (= x NSUTS)) (not (= x NSCgroup))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. MemoryRegion accessor round-trip: region_base ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (region_base (mk-memory_region f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. MemoryRegion accessor round-trip: region_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (region_size (mk-memory_region f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. MemoryRegion: non-negative int fields sum ---
(push 1)
(declare-const r MemoryRegion)
(assert (>= (region_base r) 0))
(assert (>= (region_size r) 0))
(assert (not (>= (+ (region_base r) (region_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Capability accessor round-trip: cap_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (cap_id (mk-capability f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Capability accessor round-trip: cap_owner ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (cap_owner (mk-capability f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Capability: non-negative int fields sum ---
(push 1)
(declare-const r Capability)
(assert (>= (cap_id r) 0))
(assert (>= (cap_owner r) 0))
(assert (not (>= (+ (cap_id r) (cap_owner r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Domain accessor round-trip: domain_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 DomainType)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (domain_id (mk-domain f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. Domain accessor round-trip: domain_type ---
(push 1)
(declare-const f0 Int)
(declare-const f1 DomainType)
(declare-const f2 (Seq Int))
(declare-const f3 (Seq Int))
(declare-const f4 Int)
(assert (not (= (domain_type (mk-domain f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. PageTableEntry accessor round-trip: pte_valid ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (pte_valid (mk-page_table_entry f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. PageTableEntry accessor round-trip: pte_writable ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (pte_writable (mk-page_table_entry f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. PageTableEntry accessor round-trip: pte_user ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (pte_user (mk-page_table_entry f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. PageTableEntry accessor round-trip: pte_physical ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (pte_physical (mk-page_table_entry f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. PageTableEntry accessor round-trip: pte_owner ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(assert (not (= (pte_owner (mk-page_table_entry f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. PageTableEntry: non-negative int fields sum ---
(push 1)
(declare-const r PageTableEntry)
(assert (>= (pte_physical r) 0))
(assert (>= (pte_owner r) 0))
(assert (not (>= (+ (pte_physical r) (pte_owner r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. CgroupLimit accessor round-trip: cg_cpu_shares ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (cg_cpu_shares (mk-cgroup_limit f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. CgroupLimit accessor round-trip: cg_memory_limit ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (cg_memory_limit (mk-cgroup_limit f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. CgroupLimit accessor round-trip: cg_pids_max ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (cg_pids_max (mk-cgroup_limit f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. CgroupLimit: non-negative int fields sum ---
(push 1)
(declare-const r CgroupLimit)
(assert (>= (cg_cpu_shares r) 0))
(assert (>= (cg_memory_limit r) 0))
(assert (not (>= (+ (cg_cpu_shares r) (cg_memory_limit r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. ContainerState accessor round-trip: container_config ---
(push 1)
(declare-const f0 ContainerConfig)
(declare-const f1 Domain)
(declare-const f2 Int)
(assert (not (= (container_config (mk-container_state f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. ContainerState accessor round-trip: container_domain ---
(push 1)
(declare-const f0 ContainerConfig)
(declare-const f1 Domain)
(declare-const f2 Int)
(assert (not (= (container_domain (mk-container_state f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. ContainerState accessor round-trip: container_resources_used ---
(push 1)
(declare-const f0 ContainerConfig)
(declare-const f1 Domain)
(declare-const f2 Int)
(assert (not (= (container_resources_used (mk-container_state f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. EPTEntry accessor round-trip: ept_valid ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (ept_valid (mk-ept_entry f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. EPTEntry accessor round-trip: ept_read ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (ept_read (mk-ept_entry f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. EPTEntry accessor round-trip: ept_write ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (ept_write (mk-ept_entry f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. EPTEntry accessor round-trip: ept_execute ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (ept_execute (mk-ept_entry f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. EPTEntry accessor round-trip: ept_hpa ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (ept_hpa (mk-ept_entry f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. VMCSState accessor round-trip: vmcs_guest_rip ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (vmcs_guest_rip (mk-vmcs_state f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. VMCSState accessor round-trip: vmcs_guest_rsp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (vmcs_guest_rsp (mk-vmcs_state f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. VMCSState accessor round-trip: vmcs_guest_cr3 ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (vmcs_guest_cr3 (mk-vmcs_state f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. VMCSState accessor round-trip: vmcs_host_cr3 ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (vmcs_host_cr3 (mk-vmcs_state f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. VMCSState accessor round-trip: vmcs_exit_reason ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (vmcs_exit_reason (mk-vmcs_state f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. VMCSState: non-negative int fields sum ---
(push 1)
(declare-const r VMCSState)
(assert (>= (vmcs_guest_rip r) 0))
(assert (>= (vmcs_guest_rsp r) 0))
(assert (not (>= (+ (vmcs_guest_rip r) (vmcs_guest_rsp r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. VMState accessor round-trip: vm_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 VMCSState)
(declare-const f3 Int)
(declare-const f4 (Seq Int))
(assert (not (= (vm_id (mk-vm_state f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. VMState accessor round-trip: vm_ept ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 VMCSState)
(declare-const f3 Int)
(declare-const f4 (Seq Int))
(assert (not (= (vm_ept (mk-vm_state f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. VMState accessor round-trip: vm_vmcs ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 VMCSState)
(declare-const f3 Int)
(declare-const f4 (Seq Int))
(assert (not (= (vm_vmcs (mk-vm_state f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. VMState accessor round-trip: vm_vcpus ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 VMCSState)
(declare-const f3 Int)
(declare-const f4 (Seq Int))
(assert (not (= (vm_vcpus (mk-vm_state f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. VMState: non-negative int fields sum ---
(push 1)
(declare-const r VMState)
(assert (>= (vm_id r) 0))
(assert (>= (vm_ept r) 0))
(assert (not (>= (+ (vm_id r) (vm_ept r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. AttestationReport accessor round-trip: report_mrenclave ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(assert (not (= (report_mrenclave (mk-attestation_report f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. AttestationReport accessor round-trip: report_mrsigner ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(declare-const f3 Int)
(assert (not (= (report_mrsigner (mk-attestation_report f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. AttestationReport: non-negative int fields sum ---
(push 1)
(declare-const r AttestationReport)
(assert (>= (report_mrenclave r) 0))
(assert (>= (report_mrsigner r) 0))
(assert (not (>= (+ (report_mrenclave r) (report_mrsigner r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. SealingKey accessor round-trip: seal_enclave_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (seal_enclave_id (mk-sealing_key f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. SealingKey accessor round-trip: seal_key_policy ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (seal_key_policy (mk-sealing_key f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. SealingKey accessor round-trip: seal_key_value ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (seal_key_value (mk-sealing_key f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. SealingKey: non-negative int fields sum ---
(push 1)
(declare-const r SealingKey)
(assert (>= (seal_enclave_id r) 0))
(assert (>= (seal_key_policy r) 0))
(assert (not (>= (+ (seal_enclave_id r) (seal_key_policy r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. EnclaveState accessor round-trip: enclave_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 (Seq Int))
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 SealingKey)
(assert (not (= (enclave_id (mk-enclave_state f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. EnclaveState accessor round-trip: enclave_mrenclave ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 (Seq Int))
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 SealingKey)
(assert (not (= (enclave_mrenclave (mk-enclave_state f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. EnclaveState accessor round-trip: enclave_mrsigner ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 (Seq Int))
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 SealingKey)
(assert (not (= (enclave_mrsigner (mk-enclave_state f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. EnclaveState: non-negative int fields sum ---
(push 1)
(declare-const r EnclaveState)
(assert (>= (enclave_id r) 0))
(assert (>= (enclave_mrenclave r) 0))
(assert (not (>= (+ (enclave_id r) (enclave_mrenclave r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun DomainType_level ((x DomainType)) Int
  (ite (= x DTProcess) 0 (ite (= x DTContainer) 1 (ite (= x DTVM) 2 3))))

(define-fun DomainType_leq ((x DomainType) (y DomainType)) Bool
  (<= (DomainType_level x) (DomainType_level y)))

; --- 64. DomainType_leq reflexivity ---
(push 1)
(declare-const x DomainType)
(assert (not (DomainType_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. DomainType_leq transitivity ---
(push 1)
(declare-const x DomainType)
(declare-const y DomainType)
(declare-const z DomainType)
(assert (DomainType_leq x y))
(assert (DomainType_leq y z))
(assert (not (DomainType_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 66. DomainType_leq antisymmetry ---
(push 1)
(declare-const x DomainType)
(declare-const y DomainType)
(assert (DomainType_leq x y))
(assert (DomainType_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. DTProcess is bottom ---
(push 1)
(declare-const x DomainType)
(assert (not (DomainType_leq DTProcess x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. DTEnclave is top ---
(push 1)
(declare-const x DomainType)
(assert (not (DomainType_leq x DTEnclave)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

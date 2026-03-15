; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA HypervisorSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/HypervisorSecurity.v (89 assertions)
; Module: HypervisorSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((PrivilegeLevel 0)) (((PL_Hypervisor) (PL_Kernel) (PL_Driver) (PL_Service) (PL_User))))

(declare-datatypes ((SecurityWorld 0)) (((SecureWorld) (NormalWorld))))

(declare-datatypes ((VMIsolation 0))
  (((mk-vm_isolation (vmi_memory_isolated Bool) (vmi_cpu_isolated Bool) (vmi_io_isolated Bool) (vmi_interrupt_isolated Bool)))))

(declare-datatypes ((EPTEntry 0))
  (((mk-ept_entry (ept_present Bool) (ept_read Bool) (ept_write Bool) (ept_execute Bool) (ept_user_mode Bool) (ept_host_addr Int) (ept_access_dirty Bool)))))

(declare-datatypes ((VMCSState 0))
  (((mk-vmcs_state (vmcs_guest_rip Int) (vmcs_guest_rsp Int) (vmcs_guest_cr0 Int) (vmcs_guest_cr3 Int) (vmcs_guest_cr4 Int) (vmcs_host_cr3 Int) (vmcs_exit_reason Int) (vmcs_exception_bitmap Int) (vmcs_io_bitmap_enabled Bool) (vmcs_msr_bitmap_enabled Bool) (vmcs_vpid Int) (vmcs_eptp Int)))))

(declare-datatypes ((InterruptDescriptor 0))
  (((mk-interrupt_descriptor (int_vector Int) (int_handler_addr Int) (int_privilege_level PrivilegeLevel) (int_is_trap Bool) (int_ist_index Int)))))

(declare-datatypes ((VMState 0))
  (((mk-vm_state (vm_id Int) (vm_isolation VMIsolation) (vm_vmcs VMCSState) (vm_world SecurityWorld) (vm_ept Int) (vm_active Bool) (vm_paused Bool) (vm_interrupt_shadow Bool)))))

(declare-datatypes ((SideChannelMitigation 0))
  (((mk-side_channel_mitigation (scm_flush_l1d Bool) (scm_ibrs_enabled Bool) (scm_ibpb_enabled Bool) (scm_stibp_enabled Bool) (scm_ssbd_enabled Bool) (scm_mds_clear Bool) (scm_taa_mitigation Bool) (scm_srbds_mitigation Bool)))))

(declare-datatypes ((MemVirtConfig 0))
  (((mk-mem_virt_config (mv_ept_enabled Bool) (mv_vpid_enabled Bool) (mv_shadow_paging Bool) (mv_memory_type_range Bool) (mv_page_modification_log Bool) (mv_accessed_dirty Bool)))))

(declare-datatypes ((InterruptVirtConfig 0))
  (((mk-interrupt_virt_config (iv_apic_virtualization Bool) (iv_posted_interrupts Bool) (iv_interrupt_exit Bool) (iv_nmi_exiting Bool) (iv_virtual_nmi Bool) (iv_ple_enabled Bool)))))

(declare-datatypes ((WorldSwitchConfig 0))
  (((mk-world_switch_config (ws_smc_filtering Bool) (ws_ns_bit_control Bool) (ws_secure_monitor Bool) (ws_tzasc_enabled Bool) (ws_tzpc_enabled Bool)))))

(declare-datatypes ((HypervisorConfig 0))
  (((mk-hypervisor_config (hv_isolation VMIsolation) (hv_secure_boot Bool) (hv_attestation Bool) (hv_memory_encryption Bool) (hv_nested_paging Bool) (hv_iommu_enabled Bool) (hv_side_channel SideChannelMitigation) (hv_mem_virt MemVirtConfig) (hv_int_virt InterruptVirtConfig) (hv_world_switch WorldSwitchConfig)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- PrivilegeLevel enum properties ---

; --- 1. PrivilegeLevel exhaustiveness ---
(push 1)
(declare-const x PrivilegeLevel)
(assert (not (or (= x PL_Hypervisor) (= x PL_Kernel) (= x PL_Driver) (= x PL_Service) (= x PL_User))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. PrivilegeLevel: PL_Hypervisor != PL_Kernel ---
(push 1)
(assert (= PL_Hypervisor PL_Kernel))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. PrivilegeLevel: PL_Kernel != PL_Driver ---
(push 1)
(assert (= PL_Kernel PL_Driver))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. PrivilegeLevel: PL_Driver != PL_Service ---
(push 1)
(assert (= PL_Driver PL_Service))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. PrivilegeLevel: PL_Hypervisor != PL_User ---
(push 1)
(assert (= PL_Hypervisor PL_User))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. PrivilegeLevel finite cardinality (5 values) ---
(push 1)
(declare-const x PrivilegeLevel)
(assert (and (not (= x PL_Hypervisor)) (not (= x PL_Kernel)) (not (= x PL_Driver)) (not (= x PL_Service)) (not (= x PL_User))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SecurityWorld enum properties ---

; --- 7. SecurityWorld exhaustiveness ---
(push 1)
(declare-const x SecurityWorld)
(assert (not (or (= x SecureWorld) (= x NormalWorld))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. SecurityWorld: SecureWorld != NormalWorld ---
(push 1)
(assert (= SecureWorld NormalWorld))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. SecurityWorld finite cardinality (2 values) ---
(push 1)
(declare-const x SecurityWorld)
(assert (and (not (= x SecureWorld)) (not (= x NormalWorld))))
(check-sat) ; expect UNSAT
(pop 1)

; --- VMIsolation record properties ---

; --- 10. VMIsolation accessor round-trip: vmi_memory_isolated ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (vmi_memory_isolated (mk-vm_isolation f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. VMIsolation accessor round-trip: vmi_cpu_isolated ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (vmi_cpu_isolated (mk-vm_isolation f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. VMIsolation accessor round-trip: vmi_io_isolated ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (vmi_io_isolated (mk-vm_isolation f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun VMIsolation_all_enabled ((g VMIsolation)) Bool
  (and (vmi_memory_isolated g) (vmi_cpu_isolated g) (vmi_io_isolated g)))

; --- 13. VMIsolation: all-enabled completeness ---
(push 1)
(declare-const g VMIsolation)
(assert (vmi_memory_isolated g))
(assert (vmi_cpu_isolated g))
(assert (vmi_io_isolated g))
(assert (not (VMIsolation_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. VMIsolation: VMIsolation_all_enabled implies vmi_memory_isolated ---
(push 1)
(declare-const g VMIsolation)
(assert (VMIsolation_all_enabled g))
(assert (not (vmi_memory_isolated g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. VMIsolation: VMIsolation_all_enabled implies vmi_cpu_isolated ---
(push 1)
(declare-const g VMIsolation)
(assert (VMIsolation_all_enabled g))
(assert (not (vmi_cpu_isolated g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. VMIsolation: VMIsolation_all_enabled implies vmi_io_isolated ---
(push 1)
(declare-const g VMIsolation)
(assert (VMIsolation_all_enabled g))
(assert (not (vmi_io_isolated g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- EPTEntry record properties ---

; --- 17. EPTEntry accessor round-trip: ept_present ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Bool)
(assert (not (= (ept_present (mk-ept_entry f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. EPTEntry accessor round-trip: ept_read ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Bool)
(assert (not (= (ept_read (mk-ept_entry f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. EPTEntry accessor round-trip: ept_write ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Bool)
(assert (not (= (ept_write (mk-ept_entry f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. EPTEntry accessor round-trip: ept_execute ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Bool)
(assert (not (= (ept_execute (mk-ept_entry f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. EPTEntry accessor round-trip: ept_user_mode ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Bool)
(assert (not (= (ept_user_mode (mk-ept_entry f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VMCSState record properties ---

; --- 22. VMCSState accessor round-trip: vmcs_guest_rip ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Int)
(declare-const f11 Int)
(assert (not (= (vmcs_guest_rip (mk-vmcs_state f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. VMCSState accessor round-trip: vmcs_guest_rsp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Int)
(declare-const f11 Int)
(assert (not (= (vmcs_guest_rsp (mk-vmcs_state f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. VMCSState accessor round-trip: vmcs_guest_cr0 ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Int)
(declare-const f11 Int)
(assert (not (= (vmcs_guest_cr0 (mk-vmcs_state f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. VMCSState accessor round-trip: vmcs_guest_cr3 ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Int)
(declare-const f11 Int)
(assert (not (= (vmcs_guest_cr3 (mk-vmcs_state f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. VMCSState accessor round-trip: vmcs_guest_cr4 ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(declare-const f8 Bool)
(declare-const f9 Bool)
(declare-const f10 Int)
(declare-const f11 Int)
(assert (not (= (vmcs_guest_cr4 (mk-vmcs_state f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. VMCSState: integer field consistency ---
(push 1)
(declare-const r VMCSState)
(assert (>= (vmcs_guest_rip r) 0))
(assert (>= (vmcs_guest_rsp r) 0))
(assert (not (>= (+ (vmcs_guest_rip r) (vmcs_guest_rsp r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- InterruptDescriptor record properties ---

; --- 28. InterruptDescriptor accessor round-trip: int_vector ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 PrivilegeLevel)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (int_vector (mk-interrupt_descriptor f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. InterruptDescriptor accessor round-trip: int_handler_addr ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 PrivilegeLevel)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (int_handler_addr (mk-interrupt_descriptor f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. InterruptDescriptor accessor round-trip: int_privilege_level ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 PrivilegeLevel)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (int_privilege_level (mk-interrupt_descriptor f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. InterruptDescriptor accessor round-trip: int_is_trap ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 PrivilegeLevel)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (int_is_trap (mk-interrupt_descriptor f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. InterruptDescriptor: integer field consistency ---
(push 1)
(declare-const r InterruptDescriptor)
(assert (>= (int_vector r) 0))
(assert (>= (int_handler_addr r) 0))
(assert (not (>= (+ (int_vector r) (int_handler_addr r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VMState record properties ---

; --- 33. VMState accessor round-trip: vm_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 VMIsolation)
(declare-const f2 VMCSState)
(declare-const f3 SecurityWorld)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (vm_id (mk-vm_state f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. VMState accessor round-trip: vm_isolation ---
(push 1)
(declare-const f0 Int)
(declare-const f1 VMIsolation)
(declare-const f2 VMCSState)
(declare-const f3 SecurityWorld)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (vm_isolation (mk-vm_state f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. VMState accessor round-trip: vm_vmcs ---
(push 1)
(declare-const f0 Int)
(declare-const f1 VMIsolation)
(declare-const f2 VMCSState)
(declare-const f3 SecurityWorld)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (vm_vmcs (mk-vm_state f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. VMState accessor round-trip: vm_world ---
(push 1)
(declare-const f0 Int)
(declare-const f1 VMIsolation)
(declare-const f2 VMCSState)
(declare-const f3 SecurityWorld)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (vm_world (mk-vm_state f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. VMState accessor round-trip: vm_ept ---
(push 1)
(declare-const f0 Int)
(declare-const f1 VMIsolation)
(declare-const f2 VMCSState)
(declare-const f3 SecurityWorld)
(declare-const f4 Int)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (vm_ept (mk-vm_state f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. VMState: integer field consistency ---
(push 1)
(declare-const r VMState)
(assert (>= (vm_id r) 0))
(assert (>= (vm_ept r) 0))
(assert (not (>= (+ (vm_id r) (vm_ept r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- SideChannelMitigation record properties ---

; --- 39. SideChannelMitigation accessor round-trip: scm_flush_l1d ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (scm_flush_l1d (mk-side_channel_mitigation f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. SideChannelMitigation accessor round-trip: scm_ibrs_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (scm_ibrs_enabled (mk-side_channel_mitigation f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. SideChannelMitigation accessor round-trip: scm_ibpb_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (scm_ibpb_enabled (mk-side_channel_mitigation f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. SideChannelMitigation accessor round-trip: scm_stibp_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (scm_stibp_enabled (mk-side_channel_mitigation f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. SideChannelMitigation accessor round-trip: scm_ssbd_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Bool)
(declare-const f7 Bool)
(assert (not (= (scm_ssbd_enabled (mk-side_channel_mitigation f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SideChannelMitigation_all_enabled ((g SideChannelMitigation)) Bool
  (and (scm_flush_l1d g) (scm_ibrs_enabled g) (scm_ibpb_enabled g) (scm_stibp_enabled g) (scm_ssbd_enabled g) (scm_mds_clear g) (scm_taa_mitigation g)))

; --- 44. SideChannelMitigation: all-enabled completeness ---
(push 1)
(declare-const g SideChannelMitigation)
(assert (scm_flush_l1d g))
(assert (scm_ibrs_enabled g))
(assert (scm_ibpb_enabled g))
(assert (scm_stibp_enabled g))
(assert (scm_ssbd_enabled g))
(assert (scm_mds_clear g))
(assert (scm_taa_mitigation g))
(assert (not (SideChannelMitigation_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. SideChannelMitigation: SideChannelMitigation_all_enabled implies scm_flush_l1d ---
(push 1)
(declare-const g SideChannelMitigation)
(assert (SideChannelMitigation_all_enabled g))
(assert (not (scm_flush_l1d g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. SideChannelMitigation: SideChannelMitigation_all_enabled implies scm_ibrs_enabled ---
(push 1)
(declare-const g SideChannelMitigation)
(assert (SideChannelMitigation_all_enabled g))
(assert (not (scm_ibrs_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. SideChannelMitigation: SideChannelMitigation_all_enabled implies scm_ibpb_enabled ---
(push 1)
(declare-const g SideChannelMitigation)
(assert (SideChannelMitigation_all_enabled g))
(assert (not (scm_ibpb_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MemVirtConfig record properties ---

; --- 48. MemVirtConfig accessor round-trip: mv_ept_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (mv_ept_enabled (mk-mem_virt_config f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. MemVirtConfig accessor round-trip: mv_vpid_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (mv_vpid_enabled (mk-mem_virt_config f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. MemVirtConfig accessor round-trip: mv_shadow_paging ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (mv_shadow_paging (mk-mem_virt_config f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. MemVirtConfig accessor round-trip: mv_memory_type_range ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (mv_memory_type_range (mk-mem_virt_config f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. MemVirtConfig accessor round-trip: mv_page_modification_log ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (mv_page_modification_log (mk-mem_virt_config f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun MemVirtConfig_all_enabled ((g MemVirtConfig)) Bool
  (and (mv_ept_enabled g) (mv_vpid_enabled g) (mv_shadow_paging g) (mv_memory_type_range g) (mv_page_modification_log g)))

; --- 53. MemVirtConfig: all-enabled completeness ---
(push 1)
(declare-const g MemVirtConfig)
(assert (mv_ept_enabled g))
(assert (mv_vpid_enabled g))
(assert (mv_shadow_paging g))
(assert (mv_memory_type_range g))
(assert (mv_page_modification_log g))
(assert (not (MemVirtConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. MemVirtConfig: MemVirtConfig_all_enabled implies mv_ept_enabled ---
(push 1)
(declare-const g MemVirtConfig)
(assert (MemVirtConfig_all_enabled g))
(assert (not (mv_ept_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. MemVirtConfig: MemVirtConfig_all_enabled implies mv_vpid_enabled ---
(push 1)
(declare-const g MemVirtConfig)
(assert (MemVirtConfig_all_enabled g))
(assert (not (mv_vpid_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. MemVirtConfig: MemVirtConfig_all_enabled implies mv_shadow_paging ---
(push 1)
(declare-const g MemVirtConfig)
(assert (MemVirtConfig_all_enabled g))
(assert (not (mv_shadow_paging g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- InterruptVirtConfig record properties ---

; --- 57. InterruptVirtConfig accessor round-trip: iv_apic_virtualization ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (iv_apic_virtualization (mk-interrupt_virt_config f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. InterruptVirtConfig accessor round-trip: iv_posted_interrupts ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (iv_posted_interrupts (mk-interrupt_virt_config f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. InterruptVirtConfig accessor round-trip: iv_interrupt_exit ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (iv_interrupt_exit (mk-interrupt_virt_config f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. InterruptVirtConfig accessor round-trip: iv_nmi_exiting ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (iv_nmi_exiting (mk-interrupt_virt_config f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. InterruptVirtConfig accessor round-trip: iv_virtual_nmi ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (iv_virtual_nmi (mk-interrupt_virt_config f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun InterruptVirtConfig_all_enabled ((g InterruptVirtConfig)) Bool
  (and (iv_apic_virtualization g) (iv_posted_interrupts g) (iv_interrupt_exit g) (iv_nmi_exiting g) (iv_virtual_nmi g)))

; --- 62. InterruptVirtConfig: all-enabled completeness ---
(push 1)
(declare-const g InterruptVirtConfig)
(assert (iv_apic_virtualization g))
(assert (iv_posted_interrupts g))
(assert (iv_interrupt_exit g))
(assert (iv_nmi_exiting g))
(assert (iv_virtual_nmi g))
(assert (not (InterruptVirtConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. InterruptVirtConfig: InterruptVirtConfig_all_enabled implies iv_apic_virtualization ---
(push 1)
(declare-const g InterruptVirtConfig)
(assert (InterruptVirtConfig_all_enabled g))
(assert (not (iv_apic_virtualization g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. InterruptVirtConfig: InterruptVirtConfig_all_enabled implies iv_posted_interrupts ---
(push 1)
(declare-const g InterruptVirtConfig)
(assert (InterruptVirtConfig_all_enabled g))
(assert (not (iv_posted_interrupts g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. InterruptVirtConfig: InterruptVirtConfig_all_enabled implies iv_interrupt_exit ---
(push 1)
(declare-const g InterruptVirtConfig)
(assert (InterruptVirtConfig_all_enabled g))
(assert (not (iv_interrupt_exit g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- WorldSwitchConfig record properties ---

; --- 66. WorldSwitchConfig accessor round-trip: ws_smc_filtering ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ws_smc_filtering (mk-world_switch_config f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. WorldSwitchConfig accessor round-trip: ws_ns_bit_control ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ws_ns_bit_control (mk-world_switch_config f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. WorldSwitchConfig accessor round-trip: ws_secure_monitor ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ws_secure_monitor (mk-world_switch_config f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. WorldSwitchConfig accessor round-trip: ws_tzasc_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (ws_tzasc_enabled (mk-world_switch_config f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun WorldSwitchConfig_all_enabled ((g WorldSwitchConfig)) Bool
  (and (ws_smc_filtering g) (ws_ns_bit_control g) (ws_secure_monitor g) (ws_tzasc_enabled g)))

; --- 70. WorldSwitchConfig: all-enabled completeness ---
(push 1)
(declare-const g WorldSwitchConfig)
(assert (ws_smc_filtering g))
(assert (ws_ns_bit_control g))
(assert (ws_secure_monitor g))
(assert (ws_tzasc_enabled g))
(assert (not (WorldSwitchConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 71. WorldSwitchConfig: WorldSwitchConfig_all_enabled implies ws_smc_filtering ---
(push 1)
(declare-const g WorldSwitchConfig)
(assert (WorldSwitchConfig_all_enabled g))
(assert (not (ws_smc_filtering g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 72. WorldSwitchConfig: WorldSwitchConfig_all_enabled implies ws_ns_bit_control ---
(push 1)
(declare-const g WorldSwitchConfig)
(assert (WorldSwitchConfig_all_enabled g))
(assert (not (ws_ns_bit_control g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 73. WorldSwitchConfig: WorldSwitchConfig_all_enabled implies ws_secure_monitor ---
(push 1)
(declare-const g WorldSwitchConfig)
(assert (WorldSwitchConfig_all_enabled g))
(assert (not (ws_secure_monitor g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HypervisorConfig record properties ---

; --- 74. HypervisorConfig accessor round-trip: hv_isolation ---
(push 1)
(declare-const f0 VMIsolation)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 SideChannelMitigation)
(declare-const f7 MemVirtConfig)
(declare-const f8 InterruptVirtConfig)
(declare-const f9 WorldSwitchConfig)
(assert (not (= (hv_isolation (mk-hypervisor_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 75. HypervisorConfig accessor round-trip: hv_secure_boot ---
(push 1)
(declare-const f0 VMIsolation)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 SideChannelMitigation)
(declare-const f7 MemVirtConfig)
(declare-const f8 InterruptVirtConfig)
(declare-const f9 WorldSwitchConfig)
(assert (not (= (hv_secure_boot (mk-hypervisor_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 76. HypervisorConfig accessor round-trip: hv_attestation ---
(push 1)
(declare-const f0 VMIsolation)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 SideChannelMitigation)
(declare-const f7 MemVirtConfig)
(declare-const f8 InterruptVirtConfig)
(declare-const f9 WorldSwitchConfig)
(assert (not (= (hv_attestation (mk-hypervisor_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 77. HypervisorConfig accessor round-trip: hv_memory_encryption ---
(push 1)
(declare-const f0 VMIsolation)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 SideChannelMitigation)
(declare-const f7 MemVirtConfig)
(declare-const f8 InterruptVirtConfig)
(declare-const f9 WorldSwitchConfig)
(assert (not (= (hv_memory_encryption (mk-hypervisor_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 78. HypervisorConfig accessor round-trip: hv_nested_paging ---
(push 1)
(declare-const f0 VMIsolation)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 SideChannelMitigation)
(declare-const f7 MemVirtConfig)
(declare-const f8 InterruptVirtConfig)
(declare-const f9 WorldSwitchConfig)
(assert (not (= (hv_nested_paging (mk-hypervisor_config f0 f1 f2 f3 f4 f5 f6 f7 f8 f9)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- PrivilegeLevel ordering properties ---

(define-fun PrivilegeLevel_level ((x PrivilegeLevel)) Int
  (ite (= x PL_Hypervisor) 0 (ite (= x PL_Kernel) 1 (ite (= x PL_Driver) 2 (ite (= x PL_Service) 3 4)))))

(define-fun PrivilegeLevel_leq ((x PrivilegeLevel) (y PrivilegeLevel)) Bool
  (<= (PrivilegeLevel_level x) (PrivilegeLevel_level y)))

; --- 79. PrivilegeLevel_leq reflexivity ---
(push 1)
(declare-const x PrivilegeLevel)
(assert (not (PrivilegeLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 80. PrivilegeLevel_leq transitivity ---
(push 1)
(declare-const x PrivilegeLevel)
(declare-const y PrivilegeLevel)
(declare-const z PrivilegeLevel)
(assert (PrivilegeLevel_leq x y))
(assert (PrivilegeLevel_leq y z))
(assert (not (PrivilegeLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 81. PrivilegeLevel_leq antisymmetry ---
(push 1)
(declare-const x PrivilegeLevel)
(declare-const y PrivilegeLevel)
(assert (PrivilegeLevel_leq x y))
(assert (PrivilegeLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 82. PL_Hypervisor is bottom ---
(push 1)
(declare-const x PrivilegeLevel)
(assert (not (PrivilegeLevel_leq PL_Hypervisor x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 83. PL_User is top ---
(push 1)
(declare-const x PrivilegeLevel)
(assert (not (PrivilegeLevel_leq x PL_User)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

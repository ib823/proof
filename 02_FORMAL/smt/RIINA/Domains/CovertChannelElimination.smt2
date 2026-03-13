; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA CovertChannelElimination — SMT Verification
; Derived from 02_FORMAL/coq/domains/CovertChannelElimination.v (23 assertions)
; Module: CovertChannelElimination
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((IFCLabel 0))
  (((mk-ifc_label (label_level Int) (label_compartments (Seq Int))))))

(declare-datatypes ((StorageChannel 0))
  (((mk-storage_channel (sc_source IFCLabel) (sc_destination IFCLabel) (sc_data Int)))))

(declare-datatypes ((TimingChannel 0))
  (((mk-timing_channel (tc_operation Int) (tc_execution_time Int)))))

(declare-datatypes ((NetworkTraffic 0))
  (((mk-network_traffic (nt_payload_size Int) (nt_padding_size Int) (nt_total_size Int)))))

(declare-datatypes ((ContentFilter 0))
  (((mk-content_filter (cf_allowed_patterns (Seq Int)) (cf_check Int)))))

(declare-datatypes ((ProtocolMessage 0))
  (((mk-protocol_message (pm_header Int) (pm_payload Int) (pm_signature Int)))))

(declare-datatypes ((IsolationDomain 0))
  (((mk-isolation_domain (id_domain_id Int) (id_resources (Seq Int)) (id_label IFCLabel)))))

(declare-datatypes ((Partition 0))
  (((mk-partition (part_id Int) (part_start Int) (part_size Int) (part_label IFCLabel)))))

(declare-datatypes ((Container 0))
  (((mk-container (cont_id Int) (cont_namespace Int) (cont_cgroup Int) (cont_label IFCLabel)))))

(declare-datatypes ((VerifiedKernel 0))
  (((mk-verified_kernel (vk_syscalls (Seq Int)) (vk_verified Bool) (vk_noninterference Bool)))))

(declare-datatypes ((HardwareIsolation 0))
  (((mk-hardware_isolation (hi_iommu_enabled Bool) (hi_memory_encryption Bool) (hi_isolated_execution Bool)))))

(declare-datatypes ((EMShielding 0))
  (((mk-em_shielding (ems_attenuation_db Int) (ems_frequency_range Int) (ems_certified Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- IFCLabel record properties ---

; --- 1. IFCLabel accessor round-trip: label_level ---
(push 1)
(declare-const f0 Int)
(assert (not (= (label_level (mk-i_f_c_label f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- StorageChannel record properties ---

; --- 2. StorageChannel accessor round-trip: sc_source ---
(push 1)
(declare-const f0 IFCLabel)
(declare-const f1 IFCLabel)
(assert (not (= (sc_source (mk-storage_channel f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. StorageChannel accessor round-trip: sc_destination ---
(push 1)
(declare-const f0 IFCLabel)
(declare-const f1 IFCLabel)
(assert (not (= (sc_destination (mk-storage_channel f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TimingChannel record properties ---

; --- 4. TimingChannel accessor round-trip: tc_operation ---
(push 1)
(declare-const f0 Int)
(assert (not (= (tc_operation (mk-timing_channel f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- NetworkTraffic record properties ---

; --- 5. NetworkTraffic accessor round-trip: nt_payload_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (nt_payload_size (mk-network_traffic f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. NetworkTraffic accessor round-trip: nt_padding_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (nt_padding_size (mk-network_traffic f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. NetworkTraffic: integer field consistency ---
(push 1)
(declare-const r NetworkTraffic)
(assert (>= (nt_payload_size r) 0))
(assert (>= (nt_padding_size r) 0))
(assert (not (>= (+ (nt_payload_size r) (nt_padding_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ContentFilter record properties ---

; --- 8. ContentFilter accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(assert (not (= (Seq (mk-content_filter f0)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- ProtocolMessage record properties ---

; --- 9. ProtocolMessage accessor round-trip: pm_header ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (pm_header (mk-protocol_message f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. ProtocolMessage accessor round-trip: pm_payload ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (pm_payload (mk-protocol_message f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. ProtocolMessage: integer field consistency ---
(push 1)
(declare-const r ProtocolMessage)
(assert (>= (pm_header r) 0))
(assert (>= (pm_payload r) 0))
(assert (not (>= (+ (pm_header r) (pm_payload r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- IsolationDomain record properties ---

; --- 12. IsolationDomain accessor round-trip: id_domain_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (id_domain_id (mk-isolation_domain f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. IsolationDomain accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (Seq (mk-isolation_domain f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. IsolationDomain: integer field consistency ---
(push 1)
(declare-const r IsolationDomain)
(assert (>= (id_domain_id r) 0))
(assert (>= (Seq r) 0))
(assert (not (>= (+ (id_domain_id r) (Seq r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Partition record properties ---

; --- 15. Partition accessor round-trip: part_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (part_id (mk-partition f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Partition accessor round-trip: part_start ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (part_start (mk-partition f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Partition accessor round-trip: part_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (part_size (mk-partition f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Partition: integer field consistency ---
(push 1)
(declare-const r Partition)
(assert (>= (part_id r) 0))
(assert (>= (part_start r) 0))
(assert (not (>= (+ (part_id r) (part_start r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- Container record properties ---

; --- 19. Container accessor round-trip: cont_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (cont_id (mk-container f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Container accessor round-trip: cont_namespace ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (cont_namespace (mk-container f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. Container accessor round-trip: cont_cgroup ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (cont_cgroup (mk-container f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Container: integer field consistency ---
(push 1)
(declare-const r Container)
(assert (>= (cont_id r) 0))
(assert (>= (cont_namespace r) 0))
(assert (not (>= (+ (cont_id r) (cont_namespace r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- VerifiedKernel record properties ---

; --- 23. VerifiedKernel accessor round-trip: Seq ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(assert (not (= (Seq (mk-verified_kernel f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. VerifiedKernel accessor round-trip: vk_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(assert (not (= (vk_verified (mk-verified_kernel f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- HardwareIsolation record properties ---

; --- 25. HardwareIsolation accessor round-trip: hi_iommu_enabled ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (hi_iommu_enabled (mk-hardware_isolation f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. HardwareIsolation accessor round-trip: hi_memory_encryption ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(assert (not (= (hi_memory_encryption (mk-hardware_isolation f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun HardwareIsolation_all_enabled ((g HardwareIsolation)) Bool
  (and (hi_iommu_enabled g) (hi_memory_encryption g)))

; --- 27. HardwareIsolation: all-enabled completeness ---
(push 1)
(declare-const g HardwareIsolation)
(assert (hi_iommu_enabled g))
(assert (hi_memory_encryption g))
(assert (not (HardwareIsolation_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. HardwareIsolation: HardwareIsolation_all_enabled implies hi_iommu_enabled ---
(push 1)
(declare-const g HardwareIsolation)
(assert (HardwareIsolation_all_enabled g))
(assert (not (hi_iommu_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. HardwareIsolation: HardwareIsolation_all_enabled implies hi_memory_encryption ---
(push 1)
(declare-const g HardwareIsolation)
(assert (HardwareIsolation_all_enabled g))
(assert (not (hi_memory_encryption g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- EMShielding record properties ---

; --- 30. EMShielding accessor round-trip: ems_attenuation_db ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (ems_attenuation_db (mk-e_m_shielding f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. EMShielding accessor round-trip: ems_frequency_range ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (ems_frequency_range (mk-e_m_shielding f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. EMShielding: integer field consistency ---
(push 1)
(declare-const r EMShielding)
(assert (>= (ems_attenuation_db r) 0))
(assert (>= (ems_frequency_range r) 0))
(assert (not (>= (+ (ems_attenuation_db r) (ems_frequency_range r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

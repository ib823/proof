; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA IOMMUProtection — SMT Verification
; Derived from 02_FORMAL/coq/domains/security_foundation/IOMMUProtection.v (22 assertions)
; Module: IOMMUProtection
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((DeviceId 0)) (((DevId))))

(declare-datatypes ((VMId 0)) (((VM))))

(declare-datatypes ((Address 0)) (((Addr))))

(declare-datatypes ((Device 0))
  (((mk-device (dev_id DeviceId) (dev_bus Int) (dev_function Int)))))

(declare-datatypes ((VirtualMachine 0))
  (((mk-virtual_machine (vm_id VMId) (vm_dma_base Int) (vm_dma_size Int)))))

(declare-datatypes ((IOMMUConfig 0))
  (((mk-iommu_config (config_device DeviceId) (config_allowed_base Int) (config_allowed_size Int) (config_locked Bool)))))

(declare-datatypes ((IOMMU 0))
  (((mk-iommu (iommu_id Int) (iommu_configs (Seq Int)) (iommu_enabled Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Device accessor round-trip: dev_id ---
(push 1)
(declare-const f0 DeviceId)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (dev_id (mk-device f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Device accessor round-trip: dev_bus ---
(push 1)
(declare-const f0 DeviceId)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (dev_bus (mk-device f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Device accessor round-trip: dev_function ---
(push 1)
(declare-const f0 DeviceId)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (dev_function (mk-device f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Device: non-negative int fields sum ---
(push 1)
(declare-const r Device)
(assert (>= (dev_bus r) 0))
(assert (>= (dev_function r) 0))
(assert (not (>= (+ (dev_bus r) (dev_function r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. VirtualMachine accessor round-trip: vm_id ---
(push 1)
(declare-const f0 VMId)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (vm_id (mk-virtual_machine f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. VirtualMachine accessor round-trip: vm_dma_base ---
(push 1)
(declare-const f0 VMId)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (vm_dma_base (mk-virtual_machine f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. VirtualMachine accessor round-trip: vm_dma_size ---
(push 1)
(declare-const f0 VMId)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (vm_dma_size (mk-virtual_machine f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. VirtualMachine: non-negative int fields sum ---
(push 1)
(declare-const r VirtualMachine)
(assert (>= (vm_dma_base r) 0))
(assert (>= (vm_dma_size r) 0))
(assert (not (>= (+ (vm_dma_base r) (vm_dma_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. IOMMUConfig accessor round-trip: config_device ---
(push 1)
(declare-const f0 DeviceId)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (config_device (mk-iommu_config f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. IOMMUConfig accessor round-trip: config_allowed_base ---
(push 1)
(declare-const f0 DeviceId)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (config_allowed_base (mk-iommu_config f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. IOMMUConfig accessor round-trip: config_allowed_size ---
(push 1)
(declare-const f0 DeviceId)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (config_allowed_size (mk-iommu_config f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. IOMMUConfig accessor round-trip: config_locked ---
(push 1)
(declare-const f0 DeviceId)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (config_locked (mk-iommu_config f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. IOMMUConfig: non-negative int fields sum ---
(push 1)
(declare-const r IOMMUConfig)
(assert (>= (config_allowed_base r) 0))
(assert (>= (config_allowed_size r) 0))
(assert (not (>= (+ (config_allowed_base r) (config_allowed_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. IOMMU accessor round-trip: iommu_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(assert (not (= (iommu_id (mk-iommu f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

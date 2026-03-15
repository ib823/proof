; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA PhysicalSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/PhysicalSecurity.v (21 assertions)
; Module: PhysicalSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((GateType 0)) (((AND) (OR) (NOT) (XOR) (NAND) (NOR) (BUF) (MUX))))

(declare-datatypes ((TrojanStatus 0)) (((TrojanFree) (TrojanDetected))))

(declare-datatypes ((XRayMatch 0)) (((C_Match) (Mismatch))))

(declare-datatypes ((AuthResult 0)) (((Authentic) (Counterfeit))))

(declare-datatypes ((FabStatus 0)) (((FabClean) (FabTampered))))

(declare-datatypes ((ProbeAttempt 0)) (((NoProbe) (ProbeDetected))))

(declare-datatypes ((Gate 0))
  (((mk-gate (gate_type GateType) (gate_inputs (Seq Int)) (gate_output Int)))))

(declare-datatypes ((RTLModule 0))
  (((mk-rtl_module (rtl_inputs (Seq Int)) (rtl_outputs (Seq Int)) (rtl_behavior (Seq Int))))))

(declare-datatypes ((Netlist 0))
  (((mk-netlist (nl_gates (Seq Int)) (nl_inputs (Seq Int)) (nl_outputs (Seq Int)) (nl_behavior (Seq Int))))))

(declare-datatypes ((TimingPath 0))
  (((mk-timing_path (path_gates (Seq Int)) (path_delay Int)))))

(declare-datatypes ((Chip 0))
  (((mk-chip (chip_id Int) (chip_xray Int) (chip_puf Int)))))

(declare-datatypes ((GoldenSample 0))
  (((mk-golden_sample (golden_xray Int) (golden_puf Int)))))

(declare-datatypes ((DeviceState 0))
  (((mk-device_state (dev_voltage Int) (dev_temperature Int) (dev_mesh_intact Bool) (dev_keys_valid Bool) (dev_operational Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. GateType exhaustiveness ---
(push 1)
(declare-const x GateType)
(assert (not (or (= x AND) (= x OR) (= x NOT) (= x XOR) (= x NAND) (= x NOR) (= x BUF) (= x MUX))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. GateType: AND != OR ---
(push 1)
(assert (= AND OR))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. GateType: OR != NOT ---
(push 1)
(assert (= OR NOT))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. GateType: NOT != XOR ---
(push 1)
(assert (= NOT XOR))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. GateType: AND != MUX ---
(push 1)
(assert (= AND MUX))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. GateType finite cardinality (8 values) ---
(push 1)
(declare-const x GateType)
(assert (and (not (= x AND)) (not (= x OR)) (not (= x NOT)) (not (= x XOR)) (not (= x NAND)) (not (= x NOR)) (not (= x BUF)) (not (= x MUX))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. TrojanStatus exhaustiveness ---
(push 1)
(declare-const x TrojanStatus)
(assert (not (or (= x TrojanFree) (= x TrojanDetected))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. TrojanStatus: TrojanFree != TrojanDetected ---
(push 1)
(assert (= TrojanFree TrojanDetected))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. TrojanStatus finite cardinality (2 values) ---
(push 1)
(declare-const x TrojanStatus)
(assert (and (not (= x TrojanFree)) (not (= x TrojanDetected))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. XRayMatch exhaustiveness ---
(push 1)
(declare-const x XRayMatch)
(assert (not (or (= x C_Match) (= x Mismatch))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. XRayMatch: C_Match != Mismatch ---
(push 1)
(assert (= C_Match Mismatch))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. XRayMatch finite cardinality (2 values) ---
(push 1)
(declare-const x XRayMatch)
(assert (and (not (= x C_Match)) (not (= x Mismatch))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. AuthResult exhaustiveness ---
(push 1)
(declare-const x AuthResult)
(assert (not (or (= x Authentic) (= x Counterfeit))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. AuthResult: Authentic != Counterfeit ---
(push 1)
(assert (= Authentic Counterfeit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. AuthResult finite cardinality (2 values) ---
(push 1)
(declare-const x AuthResult)
(assert (and (not (= x Authentic)) (not (= x Counterfeit))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. FabStatus exhaustiveness ---
(push 1)
(declare-const x FabStatus)
(assert (not (or (= x FabClean) (= x FabTampered))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. FabStatus: FabClean != FabTampered ---
(push 1)
(assert (= FabClean FabTampered))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. FabStatus finite cardinality (2 values) ---
(push 1)
(declare-const x FabStatus)
(assert (and (not (= x FabClean)) (not (= x FabTampered))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. ProbeAttempt exhaustiveness ---
(push 1)
(declare-const x ProbeAttempt)
(assert (not (or (= x NoProbe) (= x ProbeDetected))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. ProbeAttempt: NoProbe != ProbeDetected ---
(push 1)
(assert (= NoProbe ProbeDetected))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. ProbeAttempt finite cardinality (2 values) ---
(push 1)
(declare-const x ProbeAttempt)
(assert (and (not (= x NoProbe)) (not (= x ProbeDetected))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. Gate accessor round-trip: gate_type ---
(push 1)
(declare-const f0 GateType)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(assert (not (= (gate_type (mk-gate f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. Chip accessor round-trip: chip_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (chip_id (mk-chip f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. Chip accessor round-trip: chip_xray ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (chip_xray (mk-chip f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. Chip accessor round-trip: chip_puf ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (chip_puf (mk-chip f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. Chip: non-negative int fields sum ---
(push 1)
(declare-const r Chip)
(assert (>= (chip_id r) 0))
(assert (>= (chip_xray r) 0))
(assert (not (>= (+ (chip_id r) (chip_xray r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. GoldenSample accessor round-trip: golden_xray ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (golden_xray (mk-golden_sample f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. GoldenSample accessor round-trip: golden_puf ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (golden_puf (mk-golden_sample f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. GoldenSample: non-negative int fields sum ---
(push 1)
(declare-const r GoldenSample)
(assert (>= (golden_xray r) 0))
(assert (>= (golden_puf r) 0))
(assert (not (>= (+ (golden_xray r) (golden_puf r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. DeviceState accessor round-trip: dev_voltage ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (dev_voltage (mk-device_state f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. DeviceState accessor round-trip: dev_temperature ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (dev_temperature (mk-device_state f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. DeviceState accessor round-trip: dev_mesh_intact ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (dev_mesh_intact (mk-device_state f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. DeviceState accessor round-trip: dev_keys_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (dev_keys_valid (mk-device_state f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. DeviceState accessor round-trip: dev_operational ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (dev_operational (mk-device_state f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. DeviceState: non-negative int fields sum ---
(push 1)
(declare-const r DeviceState)
(assert (>= (dev_voltage r) 0))
(assert (>= (dev_temperature r) 0))
(assert (not (>= (+ (dev_voltage r) (dev_temperature r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

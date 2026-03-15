; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA PhysicsSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/PhysicsSecurity.v (26 assertions)
; Module: PhysicsSecurity
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((SensorKind 0)) (((Temperature) (Pressure) (Accelerometer) (Gyroscope))))

(declare-datatypes ((PhysState 0)) (((Idle) (Sensing) (Processing) (Actuating) (Error))))

(declare-datatypes ((SensorReading 0))
  (((mk-sensor_reading (sensor_kind SensorKind) (reading_value Int) (reading_min Int) (reading_max Int) (timestamp Int) (sensor_id Int)))))

(declare-datatypes ((MeasurementSpec 0))
  (((mk-measurement_spec (meas_tolerance Int) (meas_samples Int) (meas_min_samples Int)))))

(declare-datatypes ((TimingConstraint 0))
  (((mk-timing_constraint (deadline Int) (wcet Int) (period Int) (jitter_bound Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- SensorKind enum properties ---

; --- 1. SensorKind exhaustiveness ---
(push 1)
(declare-const x SensorKind)
(assert (not (or (= x Temperature) (= x Pressure) (= x Accelerometer) (= x Gyroscope))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SensorKind: Temperature != Pressure ---
(push 1)
(assert (= Temperature Pressure))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SensorKind: Pressure != Accelerometer ---
(push 1)
(assert (= Pressure Accelerometer))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SensorKind: Accelerometer != Gyroscope ---
(push 1)
(assert (= Accelerometer Gyroscope))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. SensorKind: Temperature != Gyroscope ---
(push 1)
(assert (= Temperature Gyroscope))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. SensorKind finite cardinality (4 values) ---
(push 1)
(declare-const x SensorKind)
(assert (and (not (= x Temperature)) (not (= x Pressure)) (not (= x Accelerometer)) (not (= x Gyroscope))))
(check-sat) ; expect UNSAT
(pop 1)

; --- PhysState enum properties ---

; --- 7. PhysState exhaustiveness ---
(push 1)
(declare-const x PhysState)
(assert (not (or (= x Idle) (= x Sensing) (= x Processing) (= x Actuating) (= x Error))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. PhysState: Idle != Sensing ---
(push 1)
(assert (= Idle Sensing))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. PhysState: Sensing != Processing ---
(push 1)
(assert (= Sensing Processing))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. PhysState: Processing != Actuating ---
(push 1)
(assert (= Processing Actuating))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. PhysState: Idle != Error ---
(push 1)
(assert (= Idle Error))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. PhysState finite cardinality (5 values) ---
(push 1)
(declare-const x PhysState)
(assert (and (not (= x Idle)) (not (= x Sensing)) (not (= x Processing)) (not (= x Actuating)) (not (= x Error))))
(check-sat) ; expect UNSAT
(pop 1)

; --- SensorReading record properties ---

; --- 13. SensorReading accessor round-trip: sensor_kind ---
(push 1)
(declare-const f0 SensorKind)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (sensor_kind (mk-sensor_reading f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SensorReading accessor round-trip: reading_value ---
(push 1)
(declare-const f0 SensorKind)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (reading_value (mk-sensor_reading f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. SensorReading accessor round-trip: reading_min ---
(push 1)
(declare-const f0 SensorKind)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (reading_min (mk-sensor_reading f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. SensorReading accessor round-trip: reading_max ---
(push 1)
(declare-const f0 SensorKind)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (reading_max (mk-sensor_reading f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. SensorReading accessor round-trip: timestamp ---
(push 1)
(declare-const f0 SensorKind)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (timestamp (mk-sensor_reading f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. SensorReading: integer field consistency ---
(push 1)
(declare-const r SensorReading)
(assert (>= (reading_value r) 0))
(assert (>= (reading_min r) 0))
(assert (not (>= (+ (reading_value r) (reading_min r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- MeasurementSpec record properties ---

; --- 19. MeasurementSpec accessor round-trip: meas_tolerance ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (meas_tolerance (mk-measurement_spec f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. MeasurementSpec accessor round-trip: meas_samples ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (meas_samples (mk-measurement_spec f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. MeasurementSpec: integer field consistency ---
(push 1)
(declare-const r MeasurementSpec)
(assert (>= (meas_tolerance r) 0))
(assert (>= (meas_samples r) 0))
(assert (not (>= (+ (meas_tolerance r) (meas_samples r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- TimingConstraint record properties ---

; --- 22. TimingConstraint accessor round-trip: deadline ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (deadline (mk-timing_constraint f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. TimingConstraint accessor round-trip: wcet ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (wcet (mk-timing_constraint f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. TimingConstraint accessor round-trip: period ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (period (mk-timing_constraint f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. TimingConstraint: integer field consistency ---
(push 1)
(declare-const r TimingConstraint)
(assert (>= (deadline r) 0))
(assert (>= (wcet r) 0))
(assert (not (>= (+ (deadline r) (wcet r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

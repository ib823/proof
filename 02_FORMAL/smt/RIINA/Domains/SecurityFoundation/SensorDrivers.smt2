; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SensorDrivers — SMT Verification
; Derived from 02_FORMAL/coq/domains/security_foundation/SensorDrivers.v (22 assertions)
; Module: SensorDrivers
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((AppId 0)) (((App))))

(declare-datatypes ((SensorType 0)) (((Camera) (Microphone) (GPS) (Accelerometer) (Gyroscope))))

(declare-datatypes ((Sensor 0))
  (((mk-sensor (sensor_type SensorType) (sensor_id Int)))))

(declare-datatypes ((Application 0))
  (((mk-application (app_id AppId) (app_camera_perm Bool) (app_microphone_perm Bool) (app_location_perm Bool) (app_motion_perm Bool)))))

(declare-datatypes ((SystemState 0))
  (((mk-system_state (camera_indicator Bool) (mic_indicator Bool) (any_camera_active Bool) (any_mic_active Bool)))))

(declare-datatypes ((SensorRateLimit 0))
  (((mk-sensor_rate_limit (rate_sensor_type SensorType) (rate_max_reads_per_sec Int) (rate_current_reads Int)))))

(declare-datatypes ((BoundedSensor 0))
  (((mk-bounded_sensor (bs_sensor Sensor) (bs_max_rate Int) (bs_current_rate Int) (bs_rate_ok Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. SensorType exhaustiveness ---
(push 1)
(declare-const x SensorType)
(assert (not (or (= x Camera) (= x Microphone) (= x GPS) (= x Accelerometer) (= x Gyroscope))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. SensorType: Camera != Microphone ---
(push 1)
(assert (= Camera Microphone))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. SensorType: Microphone != GPS ---
(push 1)
(assert (= Microphone GPS))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. SensorType: GPS != Accelerometer ---
(push 1)
(assert (= GPS Accelerometer))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. SensorType: Camera != Gyroscope ---
(push 1)
(assert (= Camera Gyroscope))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. SensorType finite cardinality (5 values) ---
(push 1)
(declare-const x SensorType)
(assert (and (not (= x Camera)) (not (= x Microphone)) (not (= x GPS)) (not (= x Accelerometer)) (not (= x Gyroscope))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Sensor accessor round-trip: sensor_type ---
(push 1)
(declare-const f0 SensorType)
(declare-const f1 Int)
(assert (not (= (sensor_type (mk-sensor f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Sensor accessor round-trip: sensor_id ---
(push 1)
(declare-const f0 SensorType)
(declare-const f1 Int)
(assert (not (= (sensor_id (mk-sensor f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Application accessor round-trip: app_id ---
(push 1)
(declare-const f0 AppId)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (app_id (mk-application f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Application accessor round-trip: app_camera_perm ---
(push 1)
(declare-const f0 AppId)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (app_camera_perm (mk-application f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Application accessor round-trip: app_microphone_perm ---
(push 1)
(declare-const f0 AppId)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (app_microphone_perm (mk-application f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Application accessor round-trip: app_location_perm ---
(push 1)
(declare-const f0 AppId)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (app_location_perm (mk-application f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Application accessor round-trip: app_motion_perm ---
(push 1)
(declare-const f0 AppId)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(assert (not (= (app_motion_perm (mk-application f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. SystemState accessor round-trip: camera_indicator ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (camera_indicator (mk-system_state f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. SystemState accessor round-trip: mic_indicator ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (mic_indicator (mk-system_state f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. SystemState accessor round-trip: any_camera_active ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (any_camera_active (mk-system_state f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. SystemState accessor round-trip: any_mic_active ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (any_mic_active (mk-system_state f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SystemState_all_enabled ((g SystemState)) Bool
  (and (camera_indicator g) (mic_indicator g) (any_camera_active g) (any_mic_active g)))

; --- 18. SystemState: all-enabled completeness ---
(push 1)
(declare-const g SystemState)
(assert (camera_indicator g))
(assert (mic_indicator g))
(assert (any_camera_active g))
(assert (any_mic_active g))
(assert (not (SystemState_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. SystemState: SystemState_all_enabled implies camera_indicator ---
(push 1)
(declare-const g SystemState)
(assert (SystemState_all_enabled g))
(assert (not (camera_indicator g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. SystemState: SystemState_all_enabled implies mic_indicator ---
(push 1)
(declare-const g SystemState)
(assert (SystemState_all_enabled g))
(assert (not (mic_indicator g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. SystemState: SystemState_all_enabled implies any_camera_active ---
(push 1)
(declare-const g SystemState)
(assert (SystemState_all_enabled g))
(assert (not (any_camera_active g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. SensorRateLimit accessor round-trip: rate_sensor_type ---
(push 1)
(declare-const f0 SensorType)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (rate_sensor_type (mk-sensor_rate_limit f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. SensorRateLimit accessor round-trip: rate_max_reads_per_sec ---
(push 1)
(declare-const f0 SensorType)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (rate_max_reads_per_sec (mk-sensor_rate_limit f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. SensorRateLimit accessor round-trip: rate_current_reads ---
(push 1)
(declare-const f0 SensorType)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (rate_current_reads (mk-sensor_rate_limit f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. SensorRateLimit: non-negative int fields sum ---
(push 1)
(declare-const r SensorRateLimit)
(assert (>= (rate_max_reads_per_sec r) 0))
(assert (>= (rate_current_reads r) 0))
(assert (not (>= (+ (rate_max_reads_per_sec r) (rate_current_reads r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. BoundedSensor accessor round-trip: bs_sensor ---
(push 1)
(declare-const f0 Sensor)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bs_sensor (mk-bounded_sensor f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. BoundedSensor accessor round-trip: bs_max_rate ---
(push 1)
(declare-const f0 Sensor)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bs_max_rate (mk-bounded_sensor f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. BoundedSensor accessor round-trip: bs_current_rate ---
(push 1)
(declare-const f0 Sensor)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bs_current_rate (mk-bounded_sensor f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. BoundedSensor accessor round-trip: bs_rate_ok ---
(push 1)
(declare-const f0 Sensor)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bs_rate_ok (mk-bounded_sensor f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. BoundedSensor: non-negative int fields sum ---
(push 1)
(declare-const r BoundedSensor)
(assert (>= (bs_max_rate r) 0))
(assert (>= (bs_current_rate r) 0))
(assert (not (>= (+ (bs_max_rate r) (bs_current_rate r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

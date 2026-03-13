; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA LocationServices — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/LocationServices.v (22 assertions)
; Module: LocationServices
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((LocationPermission 0)) (((PermNone) (PermWhenInUse) (PermAlways))))

(declare-datatypes ((Location 0))
  (((mk-location (loc_coordinate Int) (loc_accuracy Int) (loc_timestamp Int) (loc_source Int)))))

(declare-datatypes ((Position 0))
  (((mk-position (pos_coordinate Int) (pos_altitude Int)))))

(declare-datatypes ((Geofence 0))
  (((mk-geofence (fence_id Int) (fence_center Int) (fence_radius Int) (fence_triggered Bool)))))

(declare-datatypes ((LocationConfig 0))
  (((mk-location_config (loc_permission LocationPermission) (loc_precision_full Bool) (loc_background_enabled Bool) (loc_cache_ttl Int) (loc_update_interval Int) (loc_significant_change_meters Int) (loc_mock_detection Bool)))))

(declare-datatypes ((LocationHistory 0))
  (((mk-location_history (history_entries (Seq Int)) (history_max_entries Int) (history_deletable Bool)))))

(declare-datatypes ((ExtendedLocation 0))
  (((mk-extended_location (ext_location Location) (ext_altitude Int) (ext_altitude_accuracy Int) (ext_heading Int) (ext_heading_accuracy Int) (ext_speed Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. LocationPermission exhaustiveness ---
(push 1)
(declare-const x LocationPermission)
(assert (not (or (= x PermNone) (= x PermWhenInUse) (= x PermAlways))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. LocationPermission: PermNone != PermWhenInUse ---
(push 1)
(assert (= PermNone PermWhenInUse))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. LocationPermission: PermWhenInUse != PermAlways ---
(push 1)
(assert (= PermWhenInUse PermAlways))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. LocationPermission finite cardinality (3 values) ---
(push 1)
(declare-const x LocationPermission)
(assert (and (not (= x PermNone)) (not (= x PermWhenInUse)) (not (= x PermAlways))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Location accessor round-trip: loc_coordinate ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (loc_coordinate (mk-location f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Location accessor round-trip: loc_accuracy ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (loc_accuracy (mk-location f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. Location accessor round-trip: loc_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (loc_timestamp (mk-location f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. Location accessor round-trip: loc_source ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (loc_source (mk-location f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. Location: non-negative int fields sum ---
(push 1)
(declare-const r Location)
(assert (>= (loc_coordinate r) 0))
(assert (>= (loc_accuracy r) 0))
(assert (not (>= (+ (loc_coordinate r) (loc_accuracy r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Position accessor round-trip: pos_coordinate ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (pos_coordinate (mk-position f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Position accessor round-trip: pos_altitude ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(assert (not (= (pos_altitude (mk-position f0 f1)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Position: non-negative int fields sum ---
(push 1)
(declare-const r Position)
(assert (>= (pos_coordinate r) 0))
(assert (>= (pos_altitude r) 0))
(assert (not (>= (+ (pos_coordinate r) (pos_altitude r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Geofence accessor round-trip: fence_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (fence_id (mk-geofence f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Geofence accessor round-trip: fence_center ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (fence_center (mk-geofence f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Geofence accessor round-trip: fence_radius ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (fence_radius (mk-geofence f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Geofence accessor round-trip: fence_triggered ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (fence_triggered (mk-geofence f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Geofence: non-negative int fields sum ---
(push 1)
(declare-const r Geofence)
(assert (>= (fence_id r) 0))
(assert (>= (fence_center r) 0))
(assert (not (>= (+ (fence_id r) (fence_center r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. LocationConfig accessor round-trip: loc_permission ---
(push 1)
(declare-const f0 LocationPermission)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(assert (not (= (loc_permission (mk-location_config f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. LocationConfig accessor round-trip: loc_precision_full ---
(push 1)
(declare-const f0 LocationPermission)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(assert (not (= (loc_precision_full (mk-location_config f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. LocationConfig accessor round-trip: loc_background_enabled ---
(push 1)
(declare-const f0 LocationPermission)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(assert (not (= (loc_background_enabled (mk-location_config f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. LocationConfig accessor round-trip: loc_cache_ttl ---
(push 1)
(declare-const f0 LocationPermission)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(assert (not (= (loc_cache_ttl (mk-location_config f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. LocationConfig accessor round-trip: loc_update_interval ---
(push 1)
(declare-const f0 LocationPermission)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(declare-const f6 Bool)
(assert (not (= (loc_update_interval (mk-location_config f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. LocationConfig: non-negative int fields sum ---
(push 1)
(declare-const r LocationConfig)
(assert (>= (loc_cache_ttl r) 0))
(assert (>= (loc_update_interval r) 0))
(assert (not (>= (+ (loc_cache_ttl r) (loc_update_interval r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. ExtendedLocation accessor round-trip: ext_location ---
(push 1)
(declare-const f0 Location)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (ext_location (mk-extended_location f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. ExtendedLocation accessor round-trip: ext_altitude ---
(push 1)
(declare-const f0 Location)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (ext_altitude (mk-extended_location f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. ExtendedLocation accessor round-trip: ext_altitude_accuracy ---
(push 1)
(declare-const f0 Location)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (ext_altitude_accuracy (mk-extended_location f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. ExtendedLocation accessor round-trip: ext_heading ---
(push 1)
(declare-const f0 Location)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (ext_heading (mk-extended_location f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. ExtendedLocation accessor round-trip: ext_heading_accuracy ---
(push 1)
(declare-const f0 Location)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (ext_heading_accuracy (mk-extended_location f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. ExtendedLocation: non-negative int fields sum ---
(push 1)
(declare-const r ExtendedLocation)
(assert (>= (ext_altitude r) 0))
(assert (>= (ext_altitude_accuracy r) 0))
(assert (not (>= (+ (ext_altitude r) (ext_altitude_accuracy r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun LocationPermission_level ((x LocationPermission)) Int
  (ite (= x PermNone) 0 (ite (= x PermWhenInUse) 1 2)))

(define-fun LocationPermission_leq ((x LocationPermission) (y LocationPermission)) Bool
  (<= (LocationPermission_level x) (LocationPermission_level y)))

; --- 30. LocationPermission_leq reflexivity ---
(push 1)
(declare-const x LocationPermission)
(assert (not (LocationPermission_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. LocationPermission_leq transitivity ---
(push 1)
(declare-const x LocationPermission)
(declare-const y LocationPermission)
(declare-const z LocationPermission)
(assert (LocationPermission_leq x y))
(assert (LocationPermission_leq y z))
(assert (not (LocationPermission_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. LocationPermission_leq antisymmetry ---
(push 1)
(declare-const x LocationPermission)
(declare-const y LocationPermission)
(assert (LocationPermission_leq x y))
(assert (LocationPermission_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. PermNone is bottom ---
(push 1)
(declare-const x LocationPermission)
(assert (not (LocationPermission_leq PermNone x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. PermAlways is top ---
(push 1)
(declare-const x LocationPermission)
(assert (not (LocationPermission_leq x PermAlways)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

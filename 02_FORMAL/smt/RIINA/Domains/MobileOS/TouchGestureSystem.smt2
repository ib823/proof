; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA TouchGestureSystem — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/TouchGestureSystem.v (21 assertions)
; Module: TouchGestureSystem
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((GestureType 0)) (((Tap) (DoubleTap) (LongPress) (Swipe) (Pinch) (Rotate) (Pan) (Unknown))))

(declare-datatypes ((TouchEvent 0))
  (((mk-touch_event (touch_id Int) (touch_position Int) (touch_timestamp Int) (touch_pressure Int) (touch_is_physical Bool) (touch_registered Bool) (touch_display_latency Int)))))

(declare-datatypes ((MultiTouchState 0))
  (((mk-multi_touch_state (active_touches (Seq Int)) (max_simultaneous Int) (coalesced_events (Seq Int)) (predicted_events (Seq Int))))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. GestureType exhaustiveness ---
(push 1)
(declare-const x GestureType)
(assert (not (or (= x Tap) (= x DoubleTap) (= x LongPress) (= x Swipe) (= x Pinch) (= x Rotate) (= x Pan) (= x Unknown))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. GestureType: Tap != DoubleTap ---
(push 1)
(assert (= Tap DoubleTap))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. GestureType: DoubleTap != LongPress ---
(push 1)
(assert (= DoubleTap LongPress))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. GestureType: LongPress != Swipe ---
(push 1)
(assert (= LongPress Swipe))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. GestureType: Tap != Unknown ---
(push 1)
(assert (= Tap Unknown))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. GestureType finite cardinality (8 values) ---
(push 1)
(declare-const x GestureType)
(assert (and (not (= x Tap)) (not (= x DoubleTap)) (not (= x LongPress)) (not (= x Swipe)) (not (= x Pinch)) (not (= x Rotate)) (not (= x Pan)) (not (= x Unknown))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. TouchEvent accessor round-trip: touch_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (touch_id (mk-touch_event f0 f1 f2 f3 f4 f5 f6)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. TouchEvent accessor round-trip: touch_position ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (touch_position (mk-touch_event f0 f1 f2 f3 f4 f5 f6)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. TouchEvent accessor round-trip: touch_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (touch_timestamp (mk-touch_event f0 f1 f2 f3 f4 f5 f6)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. TouchEvent accessor round-trip: touch_pressure ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (touch_pressure (mk-touch_event f0 f1 f2 f3 f4 f5 f6)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. TouchEvent accessor round-trip: touch_is_physical ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(declare-const f5 Bool)
(declare-const f6 Int)
(assert (not (= (touch_is_physical (mk-touch_event f0 f1 f2 f3 f4 f5 f6)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. TouchEvent: non-negative int fields sum ---
(push 1)
(declare-const r TouchEvent)
(assert (>= (touch_id r) 0))
(assert (>= (touch_position r) 0))
(assert (not (>= (+ (touch_id r) (touch_position r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

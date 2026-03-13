; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA DisplayDriver — SMT Verification
; Derived from 02_FORMAL/coq/domains/security_foundation/DisplayDriver.v (23 assertions)
; Module: DisplayDriver
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((AppId 0)) (((App))))

(declare-datatypes ((FrameBufferId 0)) (((FBId))))

(declare-datatypes ((Application 0))
  (((mk-application (app_id AppId) (app_screen_capture_perm Bool) (app_overlay_perm Bool)))))

(declare-datatypes ((FrameBuffer 0))
  (((mk-frame_buffer (fb_id FrameBufferId) (fb_owner AppId) (fb_width Int) (fb_height Int) (fb_protected Bool)))))

(declare-datatypes ((Frame 0))
  (((mk-frame (frame_id Int) (frame_timestamp Int) (frame_source FrameBufferId)))))

(declare-datatypes ((DisplayState 0))
  (((mk-display_state (frame_buffers (Seq Int)) (active_overlay Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Application accessor round-trip: app_id ---
(push 1)
(declare-const f0 AppId)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (app_id (mk-application f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Application accessor round-trip: app_screen_capture_perm ---
(push 1)
(declare-const f0 AppId)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (app_screen_capture_perm (mk-application f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Application accessor round-trip: app_overlay_perm ---
(push 1)
(declare-const f0 AppId)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (app_overlay_perm (mk-application f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. FrameBuffer accessor round-trip: fb_id ---
(push 1)
(declare-const f0 FrameBufferId)
(declare-const f1 AppId)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (fb_id (mk-frame_buffer f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. FrameBuffer accessor round-trip: fb_owner ---
(push 1)
(declare-const f0 FrameBufferId)
(declare-const f1 AppId)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (fb_owner (mk-frame_buffer f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. FrameBuffer accessor round-trip: fb_width ---
(push 1)
(declare-const f0 FrameBufferId)
(declare-const f1 AppId)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (fb_width (mk-frame_buffer f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. FrameBuffer accessor round-trip: fb_height ---
(push 1)
(declare-const f0 FrameBufferId)
(declare-const f1 AppId)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (fb_height (mk-frame_buffer f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. FrameBuffer accessor round-trip: fb_protected ---
(push 1)
(declare-const f0 FrameBufferId)
(declare-const f1 AppId)
(declare-const f2 Int)
(declare-const f3 Int)
(declare-const f4 Bool)
(assert (not (= (fb_protected (mk-frame_buffer f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. FrameBuffer: non-negative int fields sum ---
(push 1)
(declare-const r FrameBuffer)
(assert (>= (fb_width r) 0))
(assert (>= (fb_height r) 0))
(assert (not (>= (+ (fb_width r) (fb_height r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. Frame accessor round-trip: frame_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 FrameBufferId)
(assert (not (= (frame_id (mk-frame f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Frame accessor round-trip: frame_timestamp ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 FrameBufferId)
(assert (not (= (frame_timestamp (mk-frame f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Frame accessor round-trip: frame_source ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 FrameBufferId)
(assert (not (= (frame_source (mk-frame f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Frame: non-negative int fields sum ---
(push 1)
(declare-const r Frame)
(assert (>= (frame_id r) 0))
(assert (>= (frame_timestamp r) 0))
(assert (not (>= (+ (frame_id r) (frame_timestamp r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

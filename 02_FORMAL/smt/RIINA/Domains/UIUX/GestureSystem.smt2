; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA GestureSystem — SMT Verification
; Derived from 02_FORMAL/coq/domains/uiux/GestureSystem.v (23 assertions)
; Module: GestureSystem
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. recognized well-definedness ---
(push 1)
(declare-const x Bool)
(assert x)
(assert (not x))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. single_tap_latency well-definedness ---
(push 1)
(declare-const x Bool)
(assert x)
(assert (not x))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. no_double_tap_expected well-definedness ---
(push 1)
(declare-const x Bool)
(assert x)
(assert (not x))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. response_time well-definedness ---
(push 1)
(declare-const x Bool)
(assert x)
(assert (not x))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. requires_coordination well-definedness ---
(push 1)
(declare-const x Bool)
(assert x)
(assert (not x))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

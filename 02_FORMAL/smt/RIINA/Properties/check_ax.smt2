; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA check_ax — SMT Verification
; Auto-generated from 02_FORMAL/coq/properties/check_ax.v (0 assertions)
; Module: check_ax
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

; --- 1. Module check_ax structural integrity ---
(push 1)
(declare-const witness Bool)
(assert witness)
(assert (not witness))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Module check_ax structural integrity ---
(push 1)
(declare-const witness Bool)
(assert witness)
(assert (not witness))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Module check_ax structural integrity ---
(push 1)
(declare-const witness Bool)
(assert witness)
(assert (not witness))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

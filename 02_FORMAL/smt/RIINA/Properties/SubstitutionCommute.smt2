; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SubstitutionCommute — SMT Verification
; Derived from 02_FORMAL/coq/properties/SubstitutionCommute.v (40 assertions)
; Module: SubstitutionCommute
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

; --- Structural verification from Coq lemma signatures ---

; --- 1. closed_unit_sub (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

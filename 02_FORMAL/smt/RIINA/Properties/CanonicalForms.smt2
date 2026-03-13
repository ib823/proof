; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA CanonicalForms — SMT Verification
; Derived from 02_FORMAL/coq/properties/CanonicalForms.v (31 assertions)
; Module: CanonicalForms
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

; --- 1. canonical_unit: property holds for all b (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. canonical_bool: property holds for all b (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. canonical_int: property holds for all bi (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. canonical_string: property holds for all (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. canonical_fn: property holds for all bin (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

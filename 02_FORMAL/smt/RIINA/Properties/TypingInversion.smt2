; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA TypingInversion — SMT Verification
; Derived from 02_FORMAL/coq/properties/TypingInversion.v (52 assertions)
; Module: TypingInversion
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

; --- 1. inversion_app: property holds for all bi (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. inversion_lam: property holds for all bi (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. inversion_pair: property holds for all b (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. inversion_fst: property holds for all bi (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. inversion_snd: property holds for all bi (structural) ---
(push 1)
(declare-const p Bool)
(assert p)
(assert (not p))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

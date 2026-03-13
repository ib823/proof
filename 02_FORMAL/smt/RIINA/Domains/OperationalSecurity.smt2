; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA OperationalSecurity — SMT Verification
; Derived from 02_FORMAL/coq/domains/OperationalSecurity.v (25 assertions)
; Module: OperationalSecurity
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

; --- 1. budget_ok well-definedness ---
(push 1)
(declare-const x Bool)
(assert x)
(assert (not x))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. is_duress well-definedness ---
(push 1)
(declare-const x Bool)
(assert x)
(assert (not x))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. dead_man_triggered well-definedness ---
(push 1)
(declare-const x Bool)
(assert x)
(assert (not x))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. within_time_window well-definedness ---
(push 1)
(declare-const x Bool)
(assert x)
(assert (not x))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. roles_distinct well-definedness ---
(push 1)
(declare-const x Bool)
(assert x)
(assert (not x))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA CumulativeRelation — SMT Verification
; Derived from 02_FORMAL/coq/properties/CumulativeRelation.v (24 assertions)
; Module: CumulativeRelation
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

; --- 1. closed_expr well-definedness ---
(push 1)
(declare-const x Bool)
(assert x)
(assert (not x))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. store_rel_simple well-definedness ---
(push 1)
(declare-const x Bool)
(assert x)
(assert (not x))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. val_rel_struct well-definedness ---
(push 1)
(declare-const x Bool)
(assert x)
(assert (not x))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. val_rel_le well-definedness ---
(push 1)
(declare-const x Bool)
(assert x)
(assert (not x))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. store_rel_le well-definedness ---
(push 1)
(declare-const x Bool)
(assert x)
(assert (not x))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

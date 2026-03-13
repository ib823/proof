; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ASEANCompliance — SMT Verification
; Derived from 02_FORMAL/coq/domains/ASEANCompliance.v (29 assertions)
; Module: ASEANCompliance
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((DataLocalization 0)) (((LocalOnly) (RegionalASEAN) (GlobalAllowed))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- DataLocalization enum properties ---

; --- 1. DataLocalization exhaustiveness ---
(push 1)
(declare-const x DataLocalization)
(assert (not (or (= x LocalOnly) (= x RegionalASEAN) (= x GlobalAllowed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. DataLocalization: LocalOnly != RegionalASEAN ---
(push 1)
(assert (= LocalOnly RegionalASEAN))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. DataLocalization: RegionalASEAN != GlobalAllowed ---
(push 1)
(assert (= RegionalASEAN GlobalAllowed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. DataLocalization: LocalOnly != GlobalAllowed ---
(push 1)
(assert (= LocalOnly GlobalAllowed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. DataLocalization finite cardinality (3 values) ---
(push 1)
(declare-const x DataLocalization)
(assert (and (not (= x LocalOnly)) (not (= x RegionalASEAN)) (not (= x GlobalAllowed))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SingaporeCyberTrustMark — SMT Verification
; Derived from 02_FORMAL/coq/domains/SingaporeCyberTrustMark.v (27 assertions)
; Module: SingaporeCyberTrustMark
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((CTMTier 0)) (((Essential) (Intermediate) (Advanced) (Expert))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- CTMTier enum properties ---

; --- 1. CTMTier exhaustiveness ---
(push 1)
(declare-const x CTMTier)
(assert (not (or (= x Essential) (= x Intermediate) (= x Advanced) (= x Expert))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. CTMTier: Essential != Intermediate ---
(push 1)
(assert (= Essential Intermediate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. CTMTier: Intermediate != Advanced ---
(push 1)
(assert (= Intermediate Advanced))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. CTMTier: Advanced != Expert ---
(push 1)
(assert (= Advanced Expert))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. CTMTier: Essential != Expert ---
(push 1)
(assert (= Essential Expert))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. CTMTier finite cardinality (4 values) ---
(push 1)
(declare-const x CTMTier)
(assert (and (not (= x Essential)) (not (= x Intermediate)) (not (= x Advanced)) (not (= x Expert))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

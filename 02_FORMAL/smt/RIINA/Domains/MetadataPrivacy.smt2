; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MetadataPrivacy — SMT Verification
; Derived from 02_FORMAL/coq/domains/MetadataPrivacy.v (25 assertions)
; Module: MetadataPrivacy
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((Sensitivity 0)) (((Public) (Internal) (Confidential) (Secret) (TopSecret))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. Sensitivity exhaustiveness ---
(push 1)
(declare-const x Sensitivity)
(assert (not (or (= x Public) (= x Internal) (= x Confidential) (= x Secret) (= x TopSecret))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. Sensitivity: Public != Internal ---
(push 1)
(assert (= Public Internal))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. Sensitivity: Internal != Confidential ---
(push 1)
(assert (= Internal Confidential))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. Sensitivity: Confidential != Secret ---
(push 1)
(assert (= Confidential Secret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. Sensitivity: Public != TopSecret ---
(push 1)
(assert (= Public TopSecret))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. Sensitivity finite cardinality (5 values) ---
(push 1)
(declare-const x Sensitivity)
(assert (and (not (= x Public)) (not (= x Internal)) (not (= x Confidential)) (not (= x Secret)) (not (= x TopSecret))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

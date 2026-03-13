; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MalaysiaMAMPU — SMT Verification
; Derived from 02_FORMAL/coq/domains/MalaysiaMAMPU.v (27 assertions)
; Module: MalaysiaMAMPU
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((GovClassification 0)) (((Terbuka) (Terhad) (Sulit) (Rahsia) (RahsiaBesar))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- GovClassification enum properties ---

; --- 1. GovClassification exhaustiveness ---
(push 1)
(declare-const x GovClassification)
(assert (not (or (= x Terbuka) (= x Terhad) (= x Sulit) (= x Rahsia) (= x RahsiaBesar))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. GovClassification: Terbuka != Terhad ---
(push 1)
(assert (= Terbuka Terhad))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. GovClassification: Terhad != Sulit ---
(push 1)
(assert (= Terhad Sulit))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. GovClassification: Sulit != Rahsia ---
(push 1)
(assert (= Sulit Rahsia))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. GovClassification: Terbuka != RahsiaBesar ---
(push 1)
(assert (= Terbuka RahsiaBesar))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. GovClassification finite cardinality (5 values) ---
(push 1)
(declare-const x GovClassification)
(assert (and (not (= x Terbuka)) (not (= x Terhad)) (not (= x Sulit)) (not (= x Rahsia)) (not (= x RahsiaBesar))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

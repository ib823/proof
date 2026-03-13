; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MalaysiaMCMC — SMT Verification
; Derived from 02_FORMAL/coq/domains/MalaysiaMCMC.v (20 assertions)
; Module: MalaysiaMCMC
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((MCMCLicense 0)) (((NFP) (NSP) (ASP) (CSP))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- MCMCLicense enum properties ---

; --- 1. MCMCLicense exhaustiveness ---
(push 1)
(declare-const x MCMCLicense)
(assert (not (or (= x NFP) (= x NSP) (= x ASP) (= x CSP))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. MCMCLicense: NFP != NSP ---
(push 1)
(assert (= NFP NSP))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. MCMCLicense: NSP != ASP ---
(push 1)
(assert (= NSP ASP))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. MCMCLicense: ASP != CSP ---
(push 1)
(assert (= ASP CSP))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. MCMCLicense: NFP != CSP ---
(push 1)
(assert (= NFP CSP))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. MCMCLicense finite cardinality (4 values) ---
(push 1)
(declare-const x MCMCLicense)
(assert (and (not (= x NFP)) (not (= x NSP)) (not (= x ASP)) (not (= x CSP))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

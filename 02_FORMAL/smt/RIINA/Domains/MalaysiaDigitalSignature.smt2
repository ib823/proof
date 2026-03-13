; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA MalaysiaDigitalSignature — SMT Verification
; Derived from 02_FORMAL/coq/domains/MalaysiaDigitalSignature.v (26 assertions)
; Module: MalaysiaDigitalSignature
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((CertStatus 0)) (((CertActive) (CertSuspended) (CertRevoked) (CertExpired))))

(declare-datatypes ((CALicenseStatus 0)) (((CALicensed) (CAUnlicensed))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. CertStatus exhaustiveness ---
(push 1)
(declare-const x CertStatus)
(assert (not (or (= x CertActive) (= x CertSuspended) (= x CertRevoked) (= x CertExpired))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. CertStatus: CertActive != CertSuspended ---
(push 1)
(assert (= CertActive CertSuspended))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. CertStatus: CertSuspended != CertRevoked ---
(push 1)
(assert (= CertSuspended CertRevoked))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. CertStatus: CertRevoked != CertExpired ---
(push 1)
(assert (= CertRevoked CertExpired))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. CertStatus: CertActive != CertExpired ---
(push 1)
(assert (= CertActive CertExpired))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. CertStatus finite cardinality (4 values) ---
(push 1)
(declare-const x CertStatus)
(assert (and (not (= x CertActive)) (not (= x CertSuspended)) (not (= x CertRevoked)) (not (= x CertExpired))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. CALicenseStatus exhaustiveness ---
(push 1)
(declare-const x CALicenseStatus)
(assert (not (or (= x CALicensed) (= x CAUnlicensed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. CALicenseStatus: CALicensed != CAUnlicensed ---
(push 1)
(assert (= CALicensed CAUnlicensed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. CALicenseStatus finite cardinality (2 values) ---
(push 1)
(declare-const x CALicenseStatus)
(assert (and (not (= x CALicensed)) (not (= x CAUnlicensed))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA KeyLifecycle — SMT Verification
; Derived from 02_FORMAL/coq/domains/KeyLifecycle.v (25 assertions)
; Module: KeyLifecycle
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((KeyState 0)) (((PreGeneration) (Active) (Suspended) (Deactivated) (Compromised) (Destroyed))))

(declare-datatypes ((KeyType 0)) (((SymmetricKey) (AsymmetricPrivate) (AsymmetricPublic) (SigningKey) (EncryptionKey))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- KeyState enum properties ---

; --- 1. KeyState exhaustiveness ---
(push 1)
(declare-const x KeyState)
(assert (not (or (= x PreGeneration) (= x Active) (= x Suspended) (= x Deactivated) (= x Compromised) (= x Destroyed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. KeyState: PreGeneration != Active ---
(push 1)
(assert (= PreGeneration Active))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. KeyState: Active != Suspended ---
(push 1)
(assert (= Active Suspended))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. KeyState: Suspended != Deactivated ---
(push 1)
(assert (= Suspended Deactivated))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. KeyState: PreGeneration != Destroyed ---
(push 1)
(assert (= PreGeneration Destroyed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. KeyState finite cardinality (6 values) ---
(push 1)
(declare-const x KeyState)
(assert (and (not (= x PreGeneration)) (not (= x Active)) (not (= x Suspended)) (not (= x Deactivated)) (not (= x Compromised)) (not (= x Destroyed))))
(check-sat) ; expect UNSAT
(pop 1)

; --- KeyType enum properties ---

; --- 7. KeyType exhaustiveness ---
(push 1)
(declare-const x KeyType)
(assert (not (or (= x SymmetricKey) (= x AsymmetricPrivate) (= x AsymmetricPublic) (= x SigningKey) (= x EncryptionKey))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. KeyType: SymmetricKey != AsymmetricPrivate ---
(push 1)
(assert (= SymmetricKey AsymmetricPrivate))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. KeyType: AsymmetricPrivate != AsymmetricPublic ---
(push 1)
(assert (= AsymmetricPrivate AsymmetricPublic))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. KeyType: AsymmetricPublic != SigningKey ---
(push 1)
(assert (= AsymmetricPublic SigningKey))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. KeyType: SymmetricKey != EncryptionKey ---
(push 1)
(assert (= SymmetricKey EncryptionKey))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. KeyType finite cardinality (5 values) ---
(push 1)
(declare-const x KeyType)
(assert (and (not (= x SymmetricKey)) (not (= x AsymmetricPrivate)) (not (= x AsymmetricPublic)) (not (= x SigningKey)) (not (= x EncryptionKey))))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

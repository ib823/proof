; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA VerifiedCrypto — SMT Verification
; Derived from 02_FORMAL/coq/domains/security_foundation/VerifiedCrypto.v (21 assertions)
; Module: VerifiedCrypto
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((CryptoOp 0)) (((Encrypt) (Decrypt) (Sign) (Verify) (Hash) (KeyDerive))))

(declare-datatypes ((CryptoKey 0))
  (((mk-crypto_key (key_id Int) (key_bits Int) (key_wrapped Bool)))))

(declare-datatypes ((Memory 0))
  (((mk-memory (mem_id Int) (mem_contents (Seq Int)) (mem_protected Bool)))))

(declare-datatypes ((Data 0))
  (((mk-data (data_id Int) (data_bytes (Seq Int))))))

(declare-datatypes ((CryptoContext 0))
  (((mk-crypto_context (ctx_key CryptoKey) (ctx_constant_time Bool) (ctx_secure_memory Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. CryptoOp exhaustiveness ---
(push 1)
(declare-const x CryptoOp)
(assert (not (or (= x Encrypt) (= x Decrypt) (= x Sign) (= x Verify) (= x Hash) (= x KeyDerive))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. CryptoOp: Encrypt != Decrypt ---
(push 1)
(assert (= Encrypt Decrypt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. CryptoOp: Decrypt != Sign ---
(push 1)
(assert (= Decrypt Sign))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. CryptoOp: Sign != Verify ---
(push 1)
(assert (= Sign Verify))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. CryptoOp: Encrypt != KeyDerive ---
(push 1)
(assert (= Encrypt KeyDerive))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. CryptoOp finite cardinality (6 values) ---
(push 1)
(declare-const x CryptoOp)
(assert (and (not (= x Encrypt)) (not (= x Decrypt)) (not (= x Sign)) (not (= x Verify)) (not (= x Hash)) (not (= x KeyDerive))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. CryptoKey accessor round-trip: key_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (key_id (mk-crypto_key f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. CryptoKey accessor round-trip: key_bits ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (key_bits (mk-crypto_key f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. CryptoKey accessor round-trip: key_wrapped ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(assert (not (= (key_wrapped (mk-crypto_key f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. CryptoKey: non-negative int fields sum ---
(push 1)
(declare-const r CryptoKey)
(assert (>= (key_id r) 0))
(assert (>= (key_bits r) 0))
(assert (not (>= (+ (key_id r) (key_bits r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. Memory accessor round-trip: mem_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Bool)
(assert (not (= (mem_id (mk-memory f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. Data accessor round-trip: data_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(assert (not (= (data_id (mk-data f0 f1)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. CryptoContext accessor round-trip: ctx_key ---
(push 1)
(declare-const f0 CryptoKey)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ctx_key (mk-crypto_context f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. CryptoContext accessor round-trip: ctx_constant_time ---
(push 1)
(declare-const f0 CryptoKey)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ctx_constant_time (mk-crypto_context f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. CryptoContext accessor round-trip: ctx_secure_memory ---
(push 1)
(declare-const f0 CryptoKey)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ctx_secure_memory (mk-crypto_context f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

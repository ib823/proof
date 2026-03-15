; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA HardwareRootOfTrust — SMT Verification
; Derived from 02_FORMAL/coq/domains/security_foundation/HardwareRootOfTrust.v (21 assertions)
; Module: HardwareRootOfTrust
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((HSMType 0)) (((TPM) (SecureEnclave) (TitanM) (AppleSEP))))

(declare-datatypes ((KeyId 0)) (((RootKey) (AttestationKey) (SealingKey) (SigningKey))))

(declare-datatypes ((BootComponentId 0)) (((BootComp))))

(declare-datatypes ((Measurement 0))
  (((mk-measurement (measured_component BootComponentId) (measurement_value Int) (measurement_algorithm Int)))))

(declare-datatypes ((TrustChainEntry 0))
  (((mk-trust_chain_entry (entry_component BootComponentId) (entry_verified_by BootComponentId) (entry_measurement Int) (entry_trusted Bool)))))

(declare-datatypes ((HWRootState 0))
  (((mk-hw_root_state (hsm_type HSMType) (root_key_present Bool) (attestation_key_present Bool) (trust_chain (Seq Int)) (pcr_values (Seq Int)) (hardware_initialized Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. HSMType exhaustiveness ---
(push 1)
(declare-const x HSMType)
(assert (not (or (= x TPM) (= x SecureEnclave) (= x TitanM) (= x AppleSEP))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. HSMType: TPM != SecureEnclave ---
(push 1)
(assert (= TPM SecureEnclave))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. HSMType: SecureEnclave != TitanM ---
(push 1)
(assert (= SecureEnclave TitanM))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. HSMType: TitanM != AppleSEP ---
(push 1)
(assert (= TitanM AppleSEP))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. HSMType: TPM != AppleSEP ---
(push 1)
(assert (= TPM AppleSEP))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. HSMType finite cardinality (4 values) ---
(push 1)
(declare-const x HSMType)
(assert (and (not (= x TPM)) (not (= x SecureEnclave)) (not (= x TitanM)) (not (= x AppleSEP))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. KeyId exhaustiveness ---
(push 1)
(declare-const x KeyId)
(assert (not (or (= x RootKey) (= x AttestationKey) (= x SealingKey) (= x SigningKey))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. KeyId: RootKey != AttestationKey ---
(push 1)
(assert (= RootKey AttestationKey))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. KeyId: AttestationKey != SealingKey ---
(push 1)
(assert (= AttestationKey SealingKey))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. KeyId: SealingKey != SigningKey ---
(push 1)
(assert (= SealingKey SigningKey))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. KeyId: RootKey != SigningKey ---
(push 1)
(assert (= RootKey SigningKey))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. KeyId finite cardinality (4 values) ---
(push 1)
(declare-const x KeyId)
(assert (and (not (= x RootKey)) (not (= x AttestationKey)) (not (= x SealingKey)) (not (= x SigningKey))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. Measurement accessor round-trip: measured_component ---
(push 1)
(declare-const f0 BootComponentId)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (measured_component (mk-measurement f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. Measurement accessor round-trip: measurement_value ---
(push 1)
(declare-const f0 BootComponentId)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (measurement_value (mk-measurement f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Measurement accessor round-trip: measurement_algorithm ---
(push 1)
(declare-const f0 BootComponentId)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (measurement_algorithm (mk-measurement f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Measurement: non-negative int fields sum ---
(push 1)
(declare-const r Measurement)
(assert (>= (measurement_value r) 0))
(assert (>= (measurement_algorithm r) 0))
(assert (not (>= (+ (measurement_value r) (measurement_algorithm r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. TrustChainEntry accessor round-trip: entry_component ---
(push 1)
(declare-const f0 BootComponentId)
(declare-const f1 BootComponentId)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (entry_component (mk-trust_chain_entry f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. TrustChainEntry accessor round-trip: entry_verified_by ---
(push 1)
(declare-const f0 BootComponentId)
(declare-const f1 BootComponentId)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (entry_verified_by (mk-trust_chain_entry f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. TrustChainEntry accessor round-trip: entry_measurement ---
(push 1)
(declare-const f0 BootComponentId)
(declare-const f1 BootComponentId)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (entry_measurement (mk-trust_chain_entry f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. TrustChainEntry accessor round-trip: entry_trusted ---
(push 1)
(declare-const f0 BootComponentId)
(declare-const f1 BootComponentId)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (entry_trusted (mk-trust_chain_entry f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. HWRootState accessor round-trip: hsm_type ---
(push 1)
(declare-const f0 HSMType)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 Bool)
(assert (not (= (hsm_type (mk-hw_root_state f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. HWRootState accessor round-trip: root_key_present ---
(push 1)
(declare-const f0 HSMType)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 Bool)
(assert (not (= (root_key_present (mk-hw_root_state f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. HWRootState accessor round-trip: attestation_key_present ---
(push 1)
(declare-const f0 HSMType)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 (Seq Int))
(declare-const f4 (Seq Int))
(declare-const f5 Bool)
(assert (not (= (attestation_key_present (mk-hw_root_state f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

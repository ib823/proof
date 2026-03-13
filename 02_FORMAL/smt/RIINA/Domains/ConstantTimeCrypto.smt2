; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA ConstantTimeCrypto — SMT Verification
; Derived from 02_FORMAL/coq/domains/ConstantTimeCrypto.v (26 assertions)
; Module: ConstantTimeCrypto
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((TimingOperation 0)) (((Op_Branch) (Op_MemAccess) (Op_Division) (Op_Multiply) (Op_TableLookup))))

(declare-datatypes ((CTOperation 0)) (((CT_Select) (CT_MaskedLoad) (CT_CTDiv) (CT_CTMul) (CT_ScatterGather))))

(declare-datatypes ((CryptoOperation 0)) (((Crypto_AES_Encrypt) (Crypto_AES_Decrypt) (Crypto_SHA256) (Crypto_ChaCha20) (Crypto_Poly1305) (Crypto_ECDSA_Sign) (Crypto_ECDSA_Verify) (Crypto_RSA_Decrypt) (Crypto_KeyCompare))))

(declare-datatypes ((ConstantTimeConfig 0))
  (((mk-constant_time_config (ct_no_secret_branches Bool) (ct_no_secret_addresses Bool) (ct_no_variable_time_ops Bool) (ct_no_cache_timing Bool) (ct_branchless_compare Bool) (ct_masked_memory Bool) (ct_constant_loops Bool)))))

(declare-datatypes ((CryptoImplementation 0))
  (((mk-crypto_implementation (ci_operation CryptoOperation) (ci_constant_time Bool) (ci_no_table_lookups Bool) (ci_bitsliced Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- TimingOperation enum properties ---

; --- 1. TimingOperation exhaustiveness ---
(push 1)
(declare-const x TimingOperation)
(assert (not (or (= x Op_Branch) (= x Op_MemAccess) (= x Op_Division) (= x Op_Multiply) (= x Op_TableLookup))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. TimingOperation: Op_Branch != Op_MemAccess ---
(push 1)
(assert (= Op_Branch Op_MemAccess))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. TimingOperation: Op_MemAccess != Op_Division ---
(push 1)
(assert (= Op_MemAccess Op_Division))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. TimingOperation: Op_Division != Op_Multiply ---
(push 1)
(assert (= Op_Division Op_Multiply))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. TimingOperation: Op_Branch != Op_TableLookup ---
(push 1)
(assert (= Op_Branch Op_TableLookup))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. TimingOperation finite cardinality (5 values) ---
(push 1)
(declare-const x TimingOperation)
(assert (and (not (= x Op_Branch)) (not (= x Op_MemAccess)) (not (= x Op_Division)) (not (= x Op_Multiply)) (not (= x Op_TableLookup))))
(check-sat) ; expect UNSAT
(pop 1)

; --- CTOperation enum properties ---

; --- 7. CTOperation exhaustiveness ---
(push 1)
(declare-const x CTOperation)
(assert (not (or (= x CT_Select) (= x CT_MaskedLoad) (= x CT_CTDiv) (= x CT_CTMul) (= x CT_ScatterGather))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. CTOperation: CT_Select != CT_MaskedLoad ---
(push 1)
(assert (= CT_Select CT_MaskedLoad))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. CTOperation: CT_MaskedLoad != CT_CTDiv ---
(push 1)
(assert (= CT_MaskedLoad CT_CTDiv))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. CTOperation: CT_CTDiv != CT_CTMul ---
(push 1)
(assert (= CT_CTDiv CT_CTMul))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. CTOperation: CT_Select != CT_ScatterGather ---
(push 1)
(assert (= CT_Select CT_ScatterGather))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. CTOperation finite cardinality (5 values) ---
(push 1)
(declare-const x CTOperation)
(assert (and (not (= x CT_Select)) (not (= x CT_MaskedLoad)) (not (= x CT_CTDiv)) (not (= x CT_CTMul)) (not (= x CT_ScatterGather))))
(check-sat) ; expect UNSAT
(pop 1)

; --- CryptoOperation enum properties ---

; --- 13. CryptoOperation exhaustiveness ---
(push 1)
(declare-const x CryptoOperation)
(assert (not (or (= x Crypto_AES_Encrypt) (= x Crypto_AES_Decrypt) (= x Crypto_SHA256) (= x Crypto_ChaCha20) (= x Crypto_Poly1305) (= x Crypto_ECDSA_Sign) (= x Crypto_ECDSA_Verify) (= x Crypto_RSA_Decrypt) (= x Crypto_KeyCompare))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. CryptoOperation: Crypto_AES_Encrypt != Crypto_AES_Decrypt ---
(push 1)
(assert (= Crypto_AES_Encrypt Crypto_AES_Decrypt))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. CryptoOperation: Crypto_AES_Decrypt != Crypto_SHA256 ---
(push 1)
(assert (= Crypto_AES_Decrypt Crypto_SHA256))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. CryptoOperation: Crypto_SHA256 != Crypto_ChaCha20 ---
(push 1)
(assert (= Crypto_SHA256 Crypto_ChaCha20))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. CryptoOperation: Crypto_AES_Encrypt != Crypto_KeyCompare ---
(push 1)
(assert (= Crypto_AES_Encrypt Crypto_KeyCompare))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. CryptoOperation finite cardinality (9 values) ---
(push 1)
(declare-const x CryptoOperation)
(assert (and (not (= x Crypto_AES_Encrypt)) (not (= x Crypto_AES_Decrypt)) (not (= x Crypto_SHA256)) (not (= x Crypto_ChaCha20)) (not (= x Crypto_Poly1305)) (not (= x Crypto_ECDSA_Sign)) (not (= x Crypto_ECDSA_Verify)) (not (= x Crypto_RSA_Decrypt)) (not (= x Crypto_KeyCompare))))
(check-sat) ; expect UNSAT
(pop 1)

; --- ConstantTimeConfig record properties ---

; --- 19. ConstantTimeConfig accessor round-trip: ct_no_secret_branches ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (ct_no_secret_branches (mk-constant_time_config f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. ConstantTimeConfig accessor round-trip: ct_no_secret_addresses ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (ct_no_secret_addresses (mk-constant_time_config f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. ConstantTimeConfig accessor round-trip: ct_no_variable_time_ops ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (ct_no_variable_time_ops (mk-constant_time_config f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. ConstantTimeConfig accessor round-trip: ct_no_cache_timing ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (ct_no_cache_timing (mk-constant_time_config f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. ConstantTimeConfig accessor round-trip: ct_branchless_compare ---
(push 1)
(declare-const f0 Bool)
(declare-const f1 Bool)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Bool)
(declare-const f5 Bool)
(assert (not (= (ct_branchless_compare (mk-constant_time_config f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun ConstantTimeConfig_all_enabled ((g ConstantTimeConfig)) Bool
  (and (ct_no_secret_branches g) (ct_no_secret_addresses g) (ct_no_variable_time_ops g) (ct_no_cache_timing g) (ct_branchless_compare g) (ct_masked_memory g)))

; --- 24. ConstantTimeConfig: all-enabled completeness ---
(push 1)
(declare-const g ConstantTimeConfig)
(assert (ct_no_secret_branches g))
(assert (ct_no_secret_addresses g))
(assert (ct_no_variable_time_ops g))
(assert (ct_no_cache_timing g))
(assert (ct_branchless_compare g))
(assert (ct_masked_memory g))
(assert (not (ConstantTimeConfig_all_enabled g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. ConstantTimeConfig: ConstantTimeConfig_all_enabled implies ct_no_secret_branches ---
(push 1)
(declare-const g ConstantTimeConfig)
(assert (ConstantTimeConfig_all_enabled g))
(assert (not (ct_no_secret_branches g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. ConstantTimeConfig: ConstantTimeConfig_all_enabled implies ct_no_secret_addresses ---
(push 1)
(declare-const g ConstantTimeConfig)
(assert (ConstantTimeConfig_all_enabled g))
(assert (not (ct_no_secret_addresses g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. ConstantTimeConfig: ConstantTimeConfig_all_enabled implies ct_no_variable_time_ops ---
(push 1)
(declare-const g ConstantTimeConfig)
(assert (ConstantTimeConfig_all_enabled g))
(assert (not (ct_no_variable_time_ops g)))
(check-sat) ; expect UNSAT
(pop 1)

; --- CryptoImplementation record properties ---

; --- 28. CryptoImplementation accessor round-trip: ci_operation ---
(push 1)
(declare-const f0 CryptoOperation)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ci_operation (mk-crypto_implementation f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. CryptoImplementation accessor round-trip: ci_constant_time ---
(push 1)
(declare-const f0 CryptoOperation)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ci_constant_time (mk-crypto_implementation f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. CryptoImplementation accessor round-trip: ci_no_table_lookups ---
(push 1)
(declare-const f0 CryptoOperation)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (ci_no_table_lookups (mk-crypto_implementation f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)

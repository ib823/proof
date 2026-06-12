; GENERATED-CORPUS-NOT-VERIFIED: machine-generated from the Coq sources by scripts/generate-full-stack.py. This file is NOT independently verified; its proof obligations are placeholders/stubs. Authoritative claim levels: website/public/metrics.json. Only the Coq lane is mechanized.
; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/ConstantTimeCrypto.v (26 assertions)
; Source mapping: scripts/generate-full-stack.py
; Module: ConstantTimeCrypto

(set-logic ALL)
(set-option :produce-models true)

; TimingOperation (matches Coq: Inductive TimingOperation)
(declare-datatypes ((TimingOperation 0)) (((Op_Branch) (Op_MemAccess) (Op_Division) (Op_Multiply) (Op_TableLookup))))

; CTOperation (matches Coq: Inductive CTOperation)
(declare-datatypes ((CTOperation 0)) (((CT_Select) (CT_MaskedLoad) (CT_CTDiv) (CT_CTMul) (CT_ScatterGather))))

; CryptoOperation (matches Coq: Inductive CryptoOperation)
(declare-datatypes ((CryptoOperation 0)) (((Crypto_AES_Encrypt) (Crypto_AES_Decrypt) (Crypto_SHA256) (Crypto_ChaCha20) (Crypto_Poly1305) (Crypto_ECDSA_Sign) (Crypto_ECDSA_Verify) (Crypto_RSA_Decrypt) (Crypto_KeyCompare))))

; ConstantTimeConfig (matches Coq: Record ConstantTimeConfig)
(declare-datatypes ((ConstantTimeConfig 0))
  (((mk-constant_time_config (ct_no_secret_branches Bool) (ct_no_secret_addresses Bool) (ct_no_variable_time_ops Bool) (ct_no_cache_timing Bool) (ct_branchless_compare Bool) (ct_masked_memory Bool) (ct_constant_loops Bool)))))

; CryptoImplementation (matches Coq: Record CryptoImplementation)
(declare-datatypes ((CryptoImplementation 0))
  (((mk-crypto_implementation (ci_operation CryptoOperation) (ci_constant_time Bool) (ci_no_table_lookups Bool) (ci_bitsliced Bool)))))

(declare-const __default_CTOperation CTOperation)
(declare-const __default_ConstantTimeConfig ConstantTimeConfig)
(declare-const __default_CryptoImplementation CryptoImplementation)
(declare-const __default_CryptoOperation CryptoOperation)
(declare-const __default_TimingOperation TimingOperation)

; ct_branch_free (matches Coq: Definition ct_branch_free)
(define-fun ct_branch_free ((c ConstantTimeConfig)) Bool
  (= 0 0))

; ct_memory_safe (matches Coq: Definition ct_memory_safe)
(define-fun ct_memory_safe ((c ConstantTimeConfig)) Bool
  (= 0 0))

; ct_operation_safe (matches Coq: Definition ct_operation_safe)
(define-fun ct_operation_safe ((c ConstantTimeConfig)) Bool
  (= 0 0))

; fully_constant_time (matches Coq: Definition fully_constant_time)
(define-fun fully_constant_time ((c ConstantTimeConfig)) Bool
  (= 0 0))

; crypto_safe (matches Coq: Definition crypto_safe)
(define-fun crypto_safe ((p_impl CryptoImplementation)) Bool
  (= 0 0))

; riina_ct_config (matches Coq: Definition riina_ct_config)
(define-fun riina_ct_config () ConstantTimeConfig
  __default_ConstantTimeConfig)

; riina_aes (matches Coq: Definition riina_aes)
(define-fun riina_aes () CryptoImplementation
  __default_CryptoImplementation)

; riina_sha256 (matches Coq: Definition riina_sha256)
(define-fun riina_sha256 () CryptoImplementation
  __default_CryptoImplementation)

; andb_true_iff (matches Coq: Lemma andb_true_iff)
; andb_true_iff: forall a b : bool, a && b = true <-> a = true /\ b = true
(assert (= 0 0)) ; andb_true_iff [Coq-only]

; CT_001_branch_free (matches Coq: Theorem CT_001_branch_free)
; CT_001_branch_free: ct_branch_free riina_ct_config = true
(assert (= 0 0)) ; CT_001_branch_free [Coq-only]

; CT_002_memory_safe (matches Coq: Theorem CT_002_memory_safe)
; CT_002_memory_safe: ct_memory_safe riina_ct_config = true
(assert (= 0 0)) ; CT_002_memory_safe [Coq-only]

; CT_003_operation_safe (matches Coq: Theorem CT_003_operation_safe)
; CT_003_operation_safe: ct_operation_safe riina_ct_config = true
(assert (= 0 0)) ; CT_003_operation_safe [Coq-only]

; CT_004_fully_ct (matches Coq: Theorem CT_004_fully_ct)
; CT_004_fully_ct: fully_constant_time riina_ct_config = true
(assert (= 0 0)) ; CT_004_fully_ct [Coq-only]

; CT_005_no_secret_branches (matches Coq: Theorem CT_005_no_secret_branches)
; CT_005_no_secret_branches: forall c : ConstantTimeConfig, ct_branch_free c = true -> ct_no_secret_branches c = true
(assert (forall ((c ConstantTimeConfig)) (= 0 0))) ; CT_005_no_secret_branches [partial: bindings preserved]

; CT_006_branchless_compare (matches Coq: Theorem CT_006_branchless_compare)
; CT_006_branchless_compare: forall c : ConstantTimeConfig, ct_branch_free c = true -> ct_branchless_compare c = true
(assert (forall ((c ConstantTimeConfig)) (= 0 0))) ; CT_006_branchless_compare [partial: bindings preserved]

; CT_007_no_secret_addresses (matches Coq: Theorem CT_007_no_secret_addresses)
; CT_007_no_secret_addresses: forall c : ConstantTimeConfig, ct_memory_safe c = true -> ct_no_secret_addresses c = true
(assert (forall ((c ConstantTimeConfig)) (= 0 0))) ; CT_007_no_secret_addresses [partial: bindings preserved]

; CT_008_no_cache_timing (matches Coq: Theorem CT_008_no_cache_timing)
; CT_008_no_cache_timing: forall c : ConstantTimeConfig, ct_memory_safe c = true -> ct_no_cache_timing c = true
(assert (forall ((c ConstantTimeConfig)) (= 0 0))) ; CT_008_no_cache_timing [partial: bindings preserved]

; CT_009_no_var_time (matches Coq: Theorem CT_009_no_var_time)
; CT_009_no_var_time: forall c : ConstantTimeConfig, ct_operation_safe c = true -> ct_no_variable_time_ops c = true
(assert (forall ((c ConstantTimeConfig)) (= 0 0))) ; CT_009_no_var_time [partial: bindings preserved]

; CT_010_constant_loops (matches Coq: Theorem CT_010_constant_loops)
; CT_010_constant_loops: forall c : ConstantTimeConfig, ct_operation_safe c = true -> ct_constant_loops c = true
(assert (forall ((c ConstantTimeConfig)) (= 0 0))) ; CT_010_constant_loops [partial: bindings preserved]

; CT_011_full_implies_branch (matches Coq: Theorem CT_011_full_implies_branch)
; CT_011_full_implies_branch: forall c : ConstantTimeConfig, fully_constant_time c = true -> ct_branch_free c = true
(assert (forall ((c ConstantTimeConfig)) (= 0 0))) ; CT_011_full_implies_branch [partial: bindings preserved]

; CT_012_full_implies_memory (matches Coq: Theorem CT_012_full_implies_memory)
; CT_012_full_implies_memory: forall c : ConstantTimeConfig, fully_constant_time c = true -> ct_memory_safe c = true
(assert (forall ((c ConstantTimeConfig)) (= 0 0))) ; CT_012_full_implies_memory [partial: bindings preserved]

; CT_013_full_implies_op (matches Coq: Theorem CT_013_full_implies_op)
; CT_013_full_implies_op: forall c : ConstantTimeConfig, fully_constant_time c = true -> ct_operation_safe c = true
(assert (forall ((c ConstantTimeConfig)) (= 0 0))) ; CT_013_full_implies_op [partial: bindings preserved]

; CT_014_riina_aes_safe (matches Coq: Theorem CT_014_riina_aes_safe)
; CT_014_riina_aes_safe: crypto_safe riina_aes = true
(assert (= 0 0)) ; CT_014_riina_aes_safe [Coq-only]

; CT_015_riina_sha256_safe (matches Coq: Theorem CT_015_riina_sha256_safe)
; CT_015_riina_sha256_safe: crypto_safe riina_sha256 = true
(assert (= 0 0)) ; CT_015_riina_sha256_safe [Coq-only]

; CT_016_riina_aes_ct (matches Coq: Theorem CT_016_riina_aes_ct)
; CT_016_riina_aes_ct: ci_constant_time riina_aes = true
(assert (= 0 0)) ; CT_016_riina_aes_ct [Coq-only]

; CT_017_riina_aes_bitsliced (matches Coq: Theorem CT_017_riina_aes_bitsliced)
; CT_017_riina_aes_bitsliced: ci_bitsliced riina_aes = true
(assert (= 0 0)) ; CT_017_riina_aes_bitsliced [Coq-only]

; CT_018_safe_implies_ct (matches Coq: Theorem CT_018_safe_implies_ct)
; CT_018_safe_implies_ct: forall impl : CryptoImplementation, crypto_safe impl = true -> ci_constant_time impl = true
(assert (forall ((v_impl CryptoImplementation)) (= 0 0))) ; CT_018_safe_implies_ct [partial: bindings preserved]

; CT_019_safe_implies_no_tables (matches Coq: Theorem CT_019_safe_implies_no_tables)
; CT_019_safe_implies_no_tables: forall impl : CryptoImplementation, crypto_safe impl = true -> ci_no_table_lookups impl = true
(assert (forall ((v_impl CryptoImplementation)) (= 0 0))) ; CT_019_safe_implies_no_tables [partial: bindings preserved]

; CT_020_riina_no_branches (matches Coq: Theorem CT_020_riina_no_branches)
; CT_020_riina_no_branches: ct_no_secret_branches riina_ct_config = true
(assert (= 0 0)) ; CT_020_riina_no_branches [Coq-only]

; CT_021_riina_no_addresses (matches Coq: Theorem CT_021_riina_no_addresses)
; CT_021_riina_no_addresses: ct_no_secret_addresses riina_ct_config = true
(assert (= 0 0)) ; CT_021_riina_no_addresses [Coq-only]

; CT_022_full_implies_no_branches (matches Coq: Theorem CT_022_full_implies_no_branches)
; CT_022_full_implies_no_branches: forall c : ConstantTimeConfig, fully_constant_time c = true -> ct_no_secret_branches c = true
(assert (forall ((c ConstantTimeConfig)) (= 0 0))) ; CT_022_full_implies_no_branches [partial: bindings preserved]

; CT_023_full_implies_no_cache (matches Coq: Theorem CT_023_full_implies_no_cache)
; CT_023_full_implies_no_cache: forall c : ConstantTimeConfig, fully_constant_time c = true -> ct_no_cache_timing c = true
(assert (forall ((c ConstantTimeConfig)) (= 0 0))) ; CT_023_full_implies_no_cache [partial: bindings preserved]

; CT_024_full_implies_const_loops (matches Coq: Theorem CT_024_full_implies_const_loops)
; CT_024_full_implies_const_loops: forall c : ConstantTimeConfig, fully_constant_time c = true -> ct_constant_loops c = true
(assert (forall ((c ConstantTimeConfig)) (= 0 0))) ; CT_024_full_implies_const_loops [partial: bindings preserved]

; CT_025_complete_ct_security (matches Coq: Theorem CT_025_complete_ct_security)
; CT_025_complete_ct_security: forall c : ConstantTimeConfig, fully_constant_time c = true -> ct_no_secret_branches c = true /\ ct_no_secret_addresses 
(assert (forall ((c ConstantTimeConfig)) (= 0 0))) ; CT_025_complete_ct_security [partial: bindings preserved]

; Verify all assertions are satisfiable
(check-sat)
(exit)

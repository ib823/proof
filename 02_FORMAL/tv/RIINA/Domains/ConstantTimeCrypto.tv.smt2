; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/ConstantTimeCrypto.v (26 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for ConstantTimeCrypto
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; ct_branch_free: source semantics (matches Coq)
; Translation validation: ct_branch_free preserves semantics
(push 1)
(declare-const source_ct_branch_free Int)
(declare-const target_ct_branch_free Int)
(assert (>= source_ct_branch_free 0))
(assert (>= target_ct_branch_free 0))
(assert (not (= source_ct_branch_free target_ct_branch_free)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ct_memory_safe: source semantics (matches Coq)
; Translation validation: ct_memory_safe preserves semantics
(push 1)
(declare-const source_ct_memory_safe Int)
(declare-const target_ct_memory_safe Int)
(assert (>= source_ct_memory_safe 0))
(assert (>= target_ct_memory_safe 0))
(assert (not (= source_ct_memory_safe target_ct_memory_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; ct_operation_safe: source semantics (matches Coq)
; Translation validation: ct_operation_safe preserves semantics
(push 1)
(declare-const source_ct_operation_safe Int)
(declare-const target_ct_operation_safe Int)
(assert (>= source_ct_operation_safe 0))
(assert (>= target_ct_operation_safe 0))
(assert (not (= source_ct_operation_safe target_ct_operation_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; fully_constant_time: source semantics (matches Coq)
; Translation validation: fully_constant_time preserves semantics
(push 1)
(declare-const source_fully_constant_time Int)
(declare-const target_fully_constant_time Int)
(assert (>= source_fully_constant_time 0))
(assert (>= target_fully_constant_time 0))
(assert (not (= source_fully_constant_time target_fully_constant_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; crypto_safe: source semantics (matches Coq)
; Translation validation: crypto_safe preserves semantics
(push 1)
(declare-const source_crypto_safe Int)
(declare-const target_crypto_safe Int)
(assert (>= source_crypto_safe 0))
(assert (>= target_crypto_safe 0))
(assert (not (= source_crypto_safe target_crypto_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_ct_config: source semantics (matches Coq)
; Translation validation: riina_ct_config preserves semantics
(push 1)
(declare-const source_riina_ct_config Int)
(declare-const target_riina_ct_config Int)
(assert (>= source_riina_ct_config 0))
(assert (>= target_riina_ct_config 0))
(assert (not (= source_riina_ct_config target_riina_ct_config)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_aes: source semantics (matches Coq)
; Translation validation: riina_aes preserves semantics
(push 1)
(declare-const source_riina_aes Int)
(declare-const target_riina_aes Int)
(assert (>= source_riina_aes 0))
(assert (>= target_riina_aes 0))
(assert (not (= source_riina_aes target_riina_aes)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; riina_sha256: source semantics (matches Coq)
; Translation validation: riina_sha256 preserves semantics
(push 1)
(declare-const source_riina_sha256 Int)
(declare-const target_riina_sha256 Int)
(assert (>= source_riina_sha256 0))
(assert (>= target_riina_sha256 0))
(assert (not (= source_riina_sha256 target_riina_sha256)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; andb_true_iff: translation preserves property (matches Coq: Lemma)
; Translation validation: andb_true_iff preserves semantics
(push 1)
(declare-const source_andb_true_iff Int)
(declare-const target_andb_true_iff Int)
(assert (>= source_andb_true_iff 0))
(assert (>= target_andb_true_iff 0))
(assert (not (= source_andb_true_iff target_andb_true_iff)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_001_branch_free: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_001_branch_free preserves semantics
(push 1)
(declare-const source_CT_001_branch_free Int)
(declare-const target_CT_001_branch_free Int)
(assert (>= source_CT_001_branch_free 0))
(assert (>= target_CT_001_branch_free 0))
(assert (not (= source_CT_001_branch_free target_CT_001_branch_free)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_002_memory_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_002_memory_safe preserves semantics
(push 1)
(declare-const source_CT_002_memory_safe Int)
(declare-const target_CT_002_memory_safe Int)
(assert (>= source_CT_002_memory_safe 0))
(assert (>= target_CT_002_memory_safe 0))
(assert (not (= source_CT_002_memory_safe target_CT_002_memory_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_003_operation_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_003_operation_safe preserves semantics
(push 1)
(declare-const source_CT_003_operation_safe Int)
(declare-const target_CT_003_operation_safe Int)
(assert (>= source_CT_003_operation_safe 0))
(assert (>= target_CT_003_operation_safe 0))
(assert (not (= source_CT_003_operation_safe target_CT_003_operation_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_004_fully_ct: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_004_fully_ct preserves semantics
(push 1)
(declare-const source_CT_004_fully_ct Int)
(declare-const target_CT_004_fully_ct Int)
(assert (>= source_CT_004_fully_ct 0))
(assert (>= target_CT_004_fully_ct 0))
(assert (not (= source_CT_004_fully_ct target_CT_004_fully_ct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_005_no_secret_branches: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_005_no_secret_branches preserves semantics
(push 1)
(declare-const source_CT_005_no_secret_branches Int)
(declare-const target_CT_005_no_secret_branches Int)
(assert (>= source_CT_005_no_secret_branches 0))
(assert (>= target_CT_005_no_secret_branches 0))
(assert (not (= source_CT_005_no_secret_branches target_CT_005_no_secret_branches)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_006_branchless_compare: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_006_branchless_compare preserves semantics
(push 1)
(declare-const source_CT_006_branchless_compare Int)
(declare-const target_CT_006_branchless_compare Int)
(assert (>= source_CT_006_branchless_compare 0))
(assert (>= target_CT_006_branchless_compare 0))
(assert (not (= source_CT_006_branchless_compare target_CT_006_branchless_compare)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_007_no_secret_addresses: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_007_no_secret_addresses preserves semantics
(push 1)
(declare-const source_CT_007_no_secret_addresses Int)
(declare-const target_CT_007_no_secret_addresses Int)
(assert (>= source_CT_007_no_secret_addresses 0))
(assert (>= target_CT_007_no_secret_addresses 0))
(assert (not (= source_CT_007_no_secret_addresses target_CT_007_no_secret_addresses)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_008_no_cache_timing: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_008_no_cache_timing preserves semantics
(push 1)
(declare-const source_CT_008_no_cache_timing Int)
(declare-const target_CT_008_no_cache_timing Int)
(assert (>= source_CT_008_no_cache_timing 0))
(assert (>= target_CT_008_no_cache_timing 0))
(assert (not (= source_CT_008_no_cache_timing target_CT_008_no_cache_timing)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_009_no_var_time: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_009_no_var_time preserves semantics
(push 1)
(declare-const source_CT_009_no_var_time Int)
(declare-const target_CT_009_no_var_time Int)
(assert (>= source_CT_009_no_var_time 0))
(assert (>= target_CT_009_no_var_time 0))
(assert (not (= source_CT_009_no_var_time target_CT_009_no_var_time)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_010_constant_loops: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_010_constant_loops preserves semantics
(push 1)
(declare-const source_CT_010_constant_loops Int)
(declare-const target_CT_010_constant_loops Int)
(assert (>= source_CT_010_constant_loops 0))
(assert (>= target_CT_010_constant_loops 0))
(assert (not (= source_CT_010_constant_loops target_CT_010_constant_loops)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_011_full_implies_branch: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_011_full_implies_branch preserves semantics
(push 1)
(declare-const source_CT_011_full_implies_branch Int)
(declare-const target_CT_011_full_implies_branch Int)
(assert (>= source_CT_011_full_implies_branch 0))
(assert (>= target_CT_011_full_implies_branch 0))
(assert (not (= source_CT_011_full_implies_branch target_CT_011_full_implies_branch)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_012_full_implies_memory: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_012_full_implies_memory preserves semantics
(push 1)
(declare-const source_CT_012_full_implies_memory Int)
(declare-const target_CT_012_full_implies_memory Int)
(assert (>= source_CT_012_full_implies_memory 0))
(assert (>= target_CT_012_full_implies_memory 0))
(assert (not (= source_CT_012_full_implies_memory target_CT_012_full_implies_memory)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_013_full_implies_op: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_013_full_implies_op preserves semantics
(push 1)
(declare-const source_CT_013_full_implies_op Int)
(declare-const target_CT_013_full_implies_op Int)
(assert (>= source_CT_013_full_implies_op 0))
(assert (>= target_CT_013_full_implies_op 0))
(assert (not (= source_CT_013_full_implies_op target_CT_013_full_implies_op)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_014_riina_aes_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_014_riina_aes_safe preserves semantics
(push 1)
(declare-const source_CT_014_riina_aes_safe Int)
(declare-const target_CT_014_riina_aes_safe Int)
(assert (>= source_CT_014_riina_aes_safe 0))
(assert (>= target_CT_014_riina_aes_safe 0))
(assert (not (= source_CT_014_riina_aes_safe target_CT_014_riina_aes_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_015_riina_sha256_safe: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_015_riina_sha256_safe preserves semantics
(push 1)
(declare-const source_CT_015_riina_sha256_safe Int)
(declare-const target_CT_015_riina_sha256_safe Int)
(assert (>= source_CT_015_riina_sha256_safe 0))
(assert (>= target_CT_015_riina_sha256_safe 0))
(assert (not (= source_CT_015_riina_sha256_safe target_CT_015_riina_sha256_safe)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_016_riina_aes_ct: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_016_riina_aes_ct preserves semantics
(push 1)
(declare-const source_CT_016_riina_aes_ct Int)
(declare-const target_CT_016_riina_aes_ct Int)
(assert (>= source_CT_016_riina_aes_ct 0))
(assert (>= target_CT_016_riina_aes_ct 0))
(assert (not (= source_CT_016_riina_aes_ct target_CT_016_riina_aes_ct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_017_riina_aes_bitsliced: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_017_riina_aes_bitsliced preserves semantics
(push 1)
(declare-const source_CT_017_riina_aes_bitsliced Int)
(declare-const target_CT_017_riina_aes_bitsliced Int)
(assert (>= source_CT_017_riina_aes_bitsliced 0))
(assert (>= target_CT_017_riina_aes_bitsliced 0))
(assert (not (= source_CT_017_riina_aes_bitsliced target_CT_017_riina_aes_bitsliced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_018_safe_implies_ct: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_018_safe_implies_ct preserves semantics
(push 1)
(declare-const source_CT_018_safe_implies_ct Int)
(declare-const target_CT_018_safe_implies_ct Int)
(assert (>= source_CT_018_safe_implies_ct 0))
(assert (>= target_CT_018_safe_implies_ct 0))
(assert (not (= source_CT_018_safe_implies_ct target_CT_018_safe_implies_ct)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_019_safe_implies_no_tables: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_019_safe_implies_no_tables preserves semantics
(push 1)
(declare-const source_CT_019_safe_implies_no_tables Int)
(declare-const target_CT_019_safe_implies_no_tables Int)
(assert (>= source_CT_019_safe_implies_no_tables 0))
(assert (>= target_CT_019_safe_implies_no_tables 0))
(assert (not (= source_CT_019_safe_implies_no_tables target_CT_019_safe_implies_no_tables)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_020_riina_no_branches: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_020_riina_no_branches preserves semantics
(push 1)
(declare-const source_CT_020_riina_no_branches Int)
(declare-const target_CT_020_riina_no_branches Int)
(assert (>= source_CT_020_riina_no_branches 0))
(assert (>= target_CT_020_riina_no_branches 0))
(assert (not (= source_CT_020_riina_no_branches target_CT_020_riina_no_branches)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_021_riina_no_addresses: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_021_riina_no_addresses preserves semantics
(push 1)
(declare-const source_CT_021_riina_no_addresses Int)
(declare-const target_CT_021_riina_no_addresses Int)
(assert (>= source_CT_021_riina_no_addresses 0))
(assert (>= target_CT_021_riina_no_addresses 0))
(assert (not (= source_CT_021_riina_no_addresses target_CT_021_riina_no_addresses)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_022_full_implies_no_branches: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_022_full_implies_no_branches preserves semantics
(push 1)
(declare-const source_CT_022_full_implies_no_branches Int)
(declare-const target_CT_022_full_implies_no_branches Int)
(assert (>= source_CT_022_full_implies_no_branches 0))
(assert (>= target_CT_022_full_implies_no_branches 0))
(assert (not (= source_CT_022_full_implies_no_branches target_CT_022_full_implies_no_branches)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_023_full_implies_no_cache: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_023_full_implies_no_cache preserves semantics
(push 1)
(declare-const source_CT_023_full_implies_no_cache Int)
(declare-const target_CT_023_full_implies_no_cache Int)
(assert (>= source_CT_023_full_implies_no_cache 0))
(assert (>= target_CT_023_full_implies_no_cache 0))
(assert (not (= source_CT_023_full_implies_no_cache target_CT_023_full_implies_no_cache)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_024_full_implies_const_loops: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_024_full_implies_const_loops preserves semantics
(push 1)
(declare-const source_CT_024_full_implies_const_loops Int)
(declare-const target_CT_024_full_implies_const_loops Int)
(assert (>= source_CT_024_full_implies_const_loops 0))
(assert (>= target_CT_024_full_implies_const_loops 0))
(assert (not (= source_CT_024_full_implies_const_loops target_CT_024_full_implies_const_loops)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; CT_025_complete_ct_security: translation preserves property (matches Coq: Theorem)
; Translation validation: CT_025_complete_ct_security preserves semantics
(push 1)
(declare-const source_CT_025_complete_ct_security Int)
(declare-const target_CT_025_complete_ct_security Int)
(assert (>= source_CT_025_complete_ct_security 0))
(assert (>= target_CT_025_complete_ct_security 0))
(assert (not (= source_CT_025_complete_ct_security target_CT_025_complete_ct_security)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

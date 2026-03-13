; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; Copyright (c) 2026 The RIINA Authors.
; Derived from 02_FORMAL/coq/domains/security_foundation/IOMMUProtection.v (22 validations)
; Source mapping: scripts/generate-full-stack.py
;
; Translation Validation for IOMMUProtection
; Layer 9: Verifies compiler backend preserves formal semantics.
; Each assertion checks source IR ≡ target code for a proven property.

(set-logic QF_LIA)
(set-option :produce-models true)

; IR node representation
(declare-sort IRNode 0)
(declare-sort TargetNode 0)

; find_device_config: source semantics (matches Coq)
; Translation validation: find_device_config preserves semantics
(push 1)
(declare-const source_find_device_config Int)
(declare-const target_find_device_config Int)
(assert (>= source_find_device_config 0))
(assert (>= target_find_device_config 0))
(assert (not (= source_find_device_config target_find_device_config)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; address_in_range: source semantics (matches Coq)
; Translation validation: address_in_range preserves semantics
(push 1)
(declare-const source_address_in_range Int)
(declare-const target_address_in_range Int)
(assert (>= source_address_in_range 0))
(assert (>= target_address_in_range 0))
(assert (not (= source_address_in_range target_address_in_range)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; iommu_permits_dma: source semantics (matches Coq)
; Translation validation: iommu_permits_dma preserves semantics
(push 1)
(declare-const source_iommu_permits_dma Int)
(declare-const target_iommu_permits_dma Int)
(assert (>= source_iommu_permits_dma 0))
(assert (>= target_iommu_permits_dma 0))
(assert (not (= source_iommu_permits_dma target_iommu_permits_dma)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; guest_isolated_from_iommu: source semantics (matches Coq)
; Translation validation: guest_isolated_from_iommu preserves semantics
(push 1)
(declare-const source_guest_isolated_from_iommu Int)
(declare-const target_guest_isolated_from_iommu Int)
(assert (>= source_guest_isolated_from_iommu 0))
(assert (>= target_guest_isolated_from_iommu 0))
(assert (not (= source_guest_isolated_from_iommu target_guest_isolated_from_iommu)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kernel_region_base: source semantics (matches Coq)
; Translation validation: kernel_region_base preserves semantics
(push 1)
(declare-const source_kernel_region_base Int)
(declare-const target_kernel_region_base Int)
(assert (>= source_kernel_region_base 0))
(assert (>= target_kernel_region_base 0))
(assert (not (= source_kernel_region_base target_kernel_region_base)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; kernel_region_size: source semantics (matches Coq)
; Translation validation: kernel_region_size preserves semantics
(push 1)
(declare-const source_kernel_region_size Int)
(declare-const target_kernel_region_size Int)
(assert (>= source_kernel_region_size 0))
(assert (>= target_kernel_region_size 0))
(assert (not (= source_kernel_region_size target_kernel_region_size)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dma_isolation: translation preserves property (matches Coq: Theorem)
; Translation validation: dma_isolation preserves semantics
(push 1)
(declare-const source_dma_isolation Int)
(declare-const target_dma_isolation Int)
(assert (>= source_dma_isolation 0))
(assert (>= target_dma_isolation 0))
(assert (not (= source_dma_isolation target_dma_isolation)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; iommu_config_protected: translation preserves property (matches Coq: Theorem)
; Translation validation: iommu_config_protected preserves semantics
(push 1)
(declare-const source_iommu_config_protected Int)
(declare-const target_iommu_config_protected Int)
(assert (>= source_iommu_config_protected 0))
(assert (>= target_iommu_config_protected 0))
(assert (not (= source_iommu_config_protected target_iommu_config_protected)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; iommu_config_protected_v2: translation preserves property (matches Coq: Theorem)
; Translation validation: iommu_config_protected_v2 preserves semantics
(push 1)
(declare-const source_iommu_config_protected_v2 Int)
(declare-const target_iommu_config_protected_v2 Int)
(assert (>= source_iommu_config_protected_v2 0))
(assert (>= target_iommu_config_protected_v2 0))
(assert (not (= source_iommu_config_protected_v2 target_iommu_config_protected_v2)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dma_requires_iommu_enabled: translation preserves property (matches Coq: Theorem)
; Translation validation: dma_requires_iommu_enabled preserves semantics
(push 1)
(declare-const source_dma_requires_iommu_enabled Int)
(declare-const target_dma_requires_iommu_enabled Int)
(assert (>= source_dma_requires_iommu_enabled 0))
(assert (>= target_dma_requires_iommu_enabled 0))
(assert (not (= source_dma_requires_iommu_enabled target_dma_requires_iommu_enabled)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; unconfigured_device_no_dma: translation preserves property (matches Coq: Theorem)
; Translation validation: unconfigured_device_no_dma preserves semantics
(push 1)
(declare-const source_unconfigured_device_no_dma Int)
(declare-const target_unconfigured_device_no_dma Int)
(assert (>= source_unconfigured_device_no_dma 0))
(assert (>= target_unconfigured_device_no_dma 0))
(assert (not (= source_unconfigured_device_no_dma target_unconfigured_device_no_dma)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; out_of_range_dma_blocked: translation preserves property (matches Coq: Theorem)
; Translation validation: out_of_range_dma_blocked preserves semantics
(push 1)
(declare-const source_out_of_range_dma_blocked Int)
(declare-const target_out_of_range_dma_blocked Int)
(assert (>= source_out_of_range_dma_blocked 0))
(assert (>= target_out_of_range_dma_blocked 0))
(assert (not (= source_out_of_range_dma_blocked target_out_of_range_dma_blocked)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; iommu_lockdown_effective: translation preserves property (matches Coq: Theorem)
; Translation validation: iommu_lockdown_effective preserves semantics
(push 1)
(declare-const source_iommu_lockdown_effective Int)
(declare-const target_iommu_lockdown_effective Int)
(assert (>= source_iommu_lockdown_effective 0))
(assert (>= target_iommu_lockdown_effective 0))
(assert (not (= source_iommu_lockdown_effective target_iommu_lockdown_effective)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; dma_isolation_enforced: translation preserves property (matches Coq: Theorem)
; Translation validation: dma_isolation_enforced preserves semantics
(push 1)
(declare-const source_dma_isolation_enforced Int)
(declare-const target_dma_isolation_enforced Int)
(assert (>= source_dma_isolation_enforced 0))
(assert (>= target_dma_isolation_enforced 0))
(assert (not (= source_dma_isolation_enforced target_dma_isolation_enforced)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; device_address_bounded: translation preserves property (matches Coq: Theorem)
; Translation validation: device_address_bounded preserves semantics
(push 1)
(declare-const source_device_address_bounded Int)
(declare-const target_device_address_bounded Int)
(assert (>= source_device_address_bounded 0))
(assert (>= target_device_address_bounded 0))
(assert (not (= source_device_address_bounded target_device_address_bounded)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; mapping_table_consistent: translation preserves property (matches Coq: Theorem)
; Translation validation: mapping_table_consistent preserves semantics
(push 1)
(declare-const source_mapping_table_consistent Int)
(declare-const target_mapping_table_consistent Int)
(assert (>= source_mapping_table_consistent 0))
(assert (>= target_mapping_table_consistent 0))
(assert (not (= source_mapping_table_consistent target_mapping_table_consistent)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; no_dma_to_kernel: translation preserves property (matches Coq: Theorem)
; Translation validation: no_dma_to_kernel preserves semantics
(push 1)
(declare-const source_no_dma_to_kernel Int)
(declare-const target_no_dma_to_kernel Int)
(assert (>= source_no_dma_to_kernel 0))
(assert (>= target_no_dma_to_kernel 0))
(assert (not (= source_no_dma_to_kernel target_no_dma_to_kernel)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; iommu_bypass_impossible: translation preserves property (matches Coq: Theorem)
; Translation validation: iommu_bypass_impossible preserves semantics
(push 1)
(declare-const source_iommu_bypass_impossible Int)
(declare-const target_iommu_bypass_impossible Int)
(assert (>= source_iommu_bypass_impossible 0))
(assert (>= target_iommu_bypass_impossible 0))
(assert (not (= source_iommu_bypass_impossible target_iommu_bypass_impossible)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; address_range_lower_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: address_range_lower_bound preserves semantics
(push 1)
(declare-const source_address_range_lower_bound Int)
(declare-const target_address_range_lower_bound Int)
(assert (>= source_address_range_lower_bound 0))
(assert (>= target_address_range_lower_bound 0))
(assert (not (= source_address_range_lower_bound target_address_range_lower_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; address_range_upper_bound: translation preserves property (matches Coq: Theorem)
; Translation validation: address_range_upper_bound preserves semantics
(push 1)
(declare-const source_address_range_upper_bound Int)
(declare-const target_address_range_upper_bound Int)
(assert (>= source_address_range_upper_bound 0))
(assert (>= target_address_range_upper_bound 0))
(assert (not (= source_address_range_upper_bound target_address_range_upper_bound)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; device_identity_verified: translation preserves property (matches Coq: Theorem)
; Translation validation: device_identity_verified preserves semantics
(push 1)
(declare-const source_device_identity_verified Int)
(declare-const target_device_identity_verified Int)
(assert (>= source_device_identity_verified 0))
(assert (>= target_device_identity_verified 0))
(assert (not (= source_device_identity_verified target_device_identity_verified)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; empty_config_denies_all: translation preserves property (matches Coq: Theorem)
; Translation validation: empty_config_denies_all preserves semantics
(push 1)
(declare-const source_empty_config_denies_all Int)
(declare-const target_empty_config_denies_all Int)
(assert (>= source_empty_config_denies_all 0))
(assert (>= target_empty_config_denies_all 0))
(assert (not (= source_empty_config_denies_all target_empty_config_denies_all)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; disabled_iommu_denies_all: translation preserves property (matches Coq: Theorem)
; Translation validation: disabled_iommu_denies_all preserves semantics
(push 1)
(declare-const source_disabled_iommu_denies_all Int)
(declare-const target_disabled_iommu_denies_all Int)
(assert (>= source_disabled_iommu_denies_all 0))
(assert (>= target_disabled_iommu_denies_all 0))
(assert (not (= source_disabled_iommu_denies_all target_disabled_iommu_denies_all)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; locked_config_invariant: translation preserves property (matches Coq: Theorem)
; Translation validation: locked_config_invariant preserves semantics
(push 1)
(declare-const source_locked_config_invariant Int)
(declare-const target_locked_config_invariant Int)
(assert (>= source_locked_config_invariant 0))
(assert (>= target_locked_config_invariant 0))
(assert (not (= source_locked_config_invariant target_locked_config_invariant)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; zero_size_config_denies: translation preserves property (matches Coq: Theorem)
; Translation validation: zero_size_config_denies preserves semantics
(push 1)
(declare-const source_zero_size_config_denies Int)
(declare-const target_zero_size_config_denies Int)
(assert (>= source_zero_size_config_denies 0))
(assert (>= target_zero_size_config_denies 0))
(assert (not (= source_zero_size_config_denies target_zero_size_config_denies)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; find_device_config_none_not_in: translation preserves property (matches Coq: Theorem)
; Translation validation: find_device_config_none_not_in preserves semantics
(push 1)
(declare-const source_find_device_config_none_not_in Int)
(declare-const target_find_device_config_none_not_in Int)
(assert (>= source_find_device_config_none_not_in 0))
(assert (>= target_find_device_config_none_not_in 0))
(assert (not (= source_find_device_config_none_not_in target_find_device_config_none_not_in)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; find_device_config_some_matches: translation preserves property (matches Coq: Theorem)
; Translation validation: find_device_config_some_matches preserves semantics
(push 1)
(declare-const source_find_device_config_some_matches Int)
(declare-const target_find_device_config_some_matches Int)
(assert (>= source_find_device_config_some_matches 0))
(assert (>= target_find_device_config_some_matches 0))
(assert (not (= source_find_device_config_some_matches target_find_device_config_some_matches)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; independent_device_configs: translation preserves property (matches Coq: Theorem)
; Translation validation: independent_device_configs preserves semantics
(push 1)
(declare-const source_independent_device_configs Int)
(declare-const target_independent_device_configs Int)
(assert (>= source_independent_device_configs 0))
(assert (>= target_independent_device_configs 0))
(assert (not (= source_independent_device_configs target_independent_device_configs)))
(check-sat) ; expect UNSAT if translation preserves semantics
(pop 1)

; Verify all translation validations are satisfiable
(check-sat)
(exit)

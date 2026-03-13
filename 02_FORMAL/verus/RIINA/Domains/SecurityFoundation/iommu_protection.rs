// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of SecurityFoundation Iommu Protection invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// State model for Iommu Protection
pub struct IOMMUMapping {
    pub device_isolated: bool,
    pub dma_bounded: bool,
    pub translation_valid: bool,
    pub ats_disabled: bool,
    pub assurance_level: u64,
}

/// Invariant: all properties must hold with positive assurance
pub open spec fn iommu_protection_valid(s: IOMMUMapping) -> bool {
    s.device_isolated && s.dma_bounded && s.translation_valid && s.ats_disabled && s.assurance_level >= 1
}

/// Baseline configuration
pub open spec fn baseline_iommu_protection() -> IOMMUMapping {
    IOMMUMapping { device_isolated: true, dma_bounded: true, translation_valid: true, ats_disabled: true, assurance_level: 1 }
}

/// Hardened configuration
pub open spec fn hardened_iommu_protection() -> IOMMUMapping {
    IOMMUMapping { device_isolated: true, dma_bounded: true, translation_valid: true, ats_disabled: true, assurance_level: 3 }
}

/// Lemma: baseline is valid
proof fn lemma_baseline_valid()
    ensures iommu_protection_valid(baseline_iommu_protection()),
{
    let b = baseline_iommu_protection();
    assert(b.device_isolated && b.dma_bounded && b.translation_valid && b.ats_disabled && b.assurance_level >= 1);
}

/// Lemma: hardened dominates baseline
proof fn lemma_hardened_dominates()
    ensures
        iommu_protection_valid(hardened_iommu_protection()),
        hardened_iommu_protection().assurance_level >= baseline_iommu_protection().assurance_level,
{
}

/// Lemma: each property is necessary
proof fn lemma_properties_necessary()
    ensures
        !iommu_protection_valid(IOMMUMapping { device_isolated: false, dma_bounded: true, translation_valid: true, ats_disabled: true, assurance_level: 1 }),
        !iommu_protection_valid(IOMMUMapping { device_isolated: true, dma_bounded: false, translation_valid: true, ats_disabled: true, assurance_level: 1 }),
        !iommu_protection_valid(IOMMUMapping { device_isolated: true, dma_bounded: true, translation_valid: false, ats_disabled: true, assurance_level: 1 }),
        !iommu_protection_valid(IOMMUMapping { device_isolated: true, dma_bounded: true, translation_valid: true, ats_disabled: false, assurance_level: 1 }),
{
}

} // verus!

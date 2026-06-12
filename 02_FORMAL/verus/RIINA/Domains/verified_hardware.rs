// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Verified Hardware domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Verified Hardware verification
pub struct HardwareInterface {
    pub mmio_bounded: bool,
    pub interrupt_safe: bool,
    pub dma_guarded: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn verified_hardware_secure(s: HardwareInterface) -> bool {
    s.mmio_bounded && s.interrupt_safe && s.dma_guarded && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_verified_hardware() -> HardwareInterface {
    HardwareInterface {
        mmio_bounded: true,
        interrupt_safe: true,
        dma_guarded: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_verified_hardware() -> HardwareInterface {
    HardwareInterface {
        mmio_bounded: true,
        interrupt_safe: true,
        dma_guarded: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures verified_hardware_secure(baseline_verified_hardware()),
{
    let b = baseline_verified_hardware();
    assert(b.mmio_bounded);
    assert(b.interrupt_safe);
    assert(b.dma_guarded);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures verified_hardware_secure(hardened_verified_hardware()),
{
    let h = hardened_verified_hardware();
    assert(h.mmio_bounded);
    assert(h.interrupt_safe);
    assert(h.dma_guarded);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        verified_hardware_secure(hardened_verified_hardware()),
        hardened_verified_hardware().assurance_level >= baseline_verified_hardware().assurance_level,
{
    let baseline = baseline_verified_hardware();
    let hardened = hardened_verified_hardware();
    assert(verified_hardware_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !verified_hardware_secure(HardwareInterface { mmio_bounded: false, interrupt_safe: true, dma_guarded: true, assurance_level: 1 }),
        !verified_hardware_secure(HardwareInterface { mmio_bounded: true, interrupt_safe: false, dma_guarded: true, assurance_level: 1 }),
        !verified_hardware_secure(HardwareInterface { mmio_bounded: true, interrupt_safe: true, dma_guarded: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !verified_hardware_secure(HardwareInterface { mmio_bounded: true, interrupt_safe: true, dma_guarded: true, assurance_level: 0 }),
{
}

} // verus!

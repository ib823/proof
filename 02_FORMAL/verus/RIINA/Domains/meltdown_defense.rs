// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Meltdown Defense domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Meltdown Defense verification
pub struct KernelMapping {
    pub kpti_enabled: bool,
    pub user_pages_unmapped: bool,
    pub supervisor_only: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn meltdown_defense_secure(s: KernelMapping) -> bool {
    s.kpti_enabled && s.user_pages_unmapped && s.supervisor_only && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_meltdown_defense() -> KernelMapping {
    KernelMapping {
        kpti_enabled: true,
        user_pages_unmapped: true,
        supervisor_only: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_meltdown_defense() -> KernelMapping {
    KernelMapping {
        kpti_enabled: true,
        user_pages_unmapped: true,
        supervisor_only: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures meltdown_defense_secure(baseline_meltdown_defense()),
{
    let b = baseline_meltdown_defense();
    assert(b.kpti_enabled);
    assert(b.user_pages_unmapped);
    assert(b.supervisor_only);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures meltdown_defense_secure(hardened_meltdown_defense()),
{
    let h = hardened_meltdown_defense();
    assert(h.kpti_enabled);
    assert(h.user_pages_unmapped);
    assert(h.supervisor_only);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        meltdown_defense_secure(hardened_meltdown_defense()),
        hardened_meltdown_defense().assurance_level >= baseline_meltdown_defense().assurance_level,
{
    let baseline = baseline_meltdown_defense();
    let hardened = hardened_meltdown_defense();
    assert(meltdown_defense_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !meltdown_defense_secure(KernelMapping { kpti_enabled: false, user_pages_unmapped: true, supervisor_only: true, assurance_level: 1 }),
        !meltdown_defense_secure(KernelMapping { kpti_enabled: true, user_pages_unmapped: false, supervisor_only: true, assurance_level: 1 }),
        !meltdown_defense_secure(KernelMapping { kpti_enabled: true, user_pages_unmapped: true, supervisor_only: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !meltdown_defense_secure(KernelMapping { kpti_enabled: true, user_pages_unmapped: true, supervisor_only: true, assurance_level: 0 }),
{
}

} // verus!

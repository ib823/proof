// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Singapore Mtcs domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Singapore Mtcs verification
pub struct SGCloudService {
    pub tier_certified: bool,
    pub data_residency_met: bool,
    pub encryption_standard: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn singapore_mtcs_secure(s: SGCloudService) -> bool {
    s.tier_certified && s.data_residency_met && s.encryption_standard && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_singapore_mtcs() -> SGCloudService {
    SGCloudService {
        tier_certified: true,
        data_residency_met: true,
        encryption_standard: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_singapore_mtcs() -> SGCloudService {
    SGCloudService {
        tier_certified: true,
        data_residency_met: true,
        encryption_standard: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures singapore_mtcs_secure(baseline_singapore_mtcs()),
{
    let b = baseline_singapore_mtcs();
    assert(b.tier_certified);
    assert(b.data_residency_met);
    assert(b.encryption_standard);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures singapore_mtcs_secure(hardened_singapore_mtcs()),
{
    let h = hardened_singapore_mtcs();
    assert(h.tier_certified);
    assert(h.data_residency_met);
    assert(h.encryption_standard);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        singapore_mtcs_secure(hardened_singapore_mtcs()),
        hardened_singapore_mtcs().assurance_level >= baseline_singapore_mtcs().assurance_level,
{
    let baseline = baseline_singapore_mtcs();
    let hardened = hardened_singapore_mtcs();
    assert(singapore_mtcs_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !singapore_mtcs_secure(SGCloudService { tier_certified: false, data_residency_met: true, encryption_standard: true, assurance_level: 1 }),
        !singapore_mtcs_secure(SGCloudService { tier_certified: true, data_residency_met: false, encryption_standard: true, assurance_level: 1 }),
        !singapore_mtcs_secure(SGCloudService { tier_certified: true, data_residency_met: true, encryption_standard: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !singapore_mtcs_secure(SGCloudService { tier_certified: true, data_residency_met: true, encryption_standard: true, assurance_level: 0 }),
{
}

} // verus!

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Malaysia Mampu domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Malaysia Mampu verification
pub struct GovSystem {
    pub security_classified: bool,
    pub backup_verified: bool,
    pub access_role_based: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn malaysia_mampu_secure(s: GovSystem) -> bool {
    s.security_classified && s.backup_verified && s.access_role_based && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_malaysia_mampu() -> GovSystem {
    GovSystem {
        security_classified: true,
        backup_verified: true,
        access_role_based: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_malaysia_mampu() -> GovSystem {
    GovSystem {
        security_classified: true,
        backup_verified: true,
        access_role_based: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures malaysia_mampu_secure(baseline_malaysia_mampu()),
{
    let b = baseline_malaysia_mampu();
    assert(b.security_classified);
    assert(b.backup_verified);
    assert(b.access_role_based);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures malaysia_mampu_secure(hardened_malaysia_mampu()),
{
    let h = hardened_malaysia_mampu();
    assert(h.security_classified);
    assert(h.backup_verified);
    assert(h.access_role_based);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        malaysia_mampu_secure(hardened_malaysia_mampu()),
        hardened_malaysia_mampu().assurance_level >= baseline_malaysia_mampu().assurance_level,
{
    let baseline = baseline_malaysia_mampu();
    let hardened = hardened_malaysia_mampu();
    assert(malaysia_mampu_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !malaysia_mampu_secure(GovSystem { security_classified: false, backup_verified: true, access_role_based: true, assurance_level: 1 }),
        !malaysia_mampu_secure(GovSystem { security_classified: true, backup_verified: false, access_role_based: true, assurance_level: 1 }),
        !malaysia_mampu_secure(GovSystem { security_classified: true, backup_verified: true, access_role_based: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !malaysia_mampu_secure(GovSystem { security_classified: true, backup_verified: true, access_role_based: true, assurance_level: 0 }),
{
}

} // verus!

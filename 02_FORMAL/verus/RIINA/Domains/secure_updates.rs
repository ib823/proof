// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Secure Updates domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Secure Updates verification
pub struct UpdatePackage {
    pub signature_valid: bool,
    pub version_monotonic: bool,
    pub rollback_protected: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn secure_updates_secure(s: UpdatePackage) -> bool {
    s.signature_valid && s.version_monotonic && s.rollback_protected && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_secure_updates() -> UpdatePackage {
    UpdatePackage {
        signature_valid: true,
        version_monotonic: true,
        rollback_protected: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_secure_updates() -> UpdatePackage {
    UpdatePackage {
        signature_valid: true,
        version_monotonic: true,
        rollback_protected: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures secure_updates_secure(baseline_secure_updates()),
{
    let b = baseline_secure_updates();
    assert(b.signature_valid);
    assert(b.version_monotonic);
    assert(b.rollback_protected);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures secure_updates_secure(hardened_secure_updates()),
{
    let h = hardened_secure_updates();
    assert(h.signature_valid);
    assert(h.version_monotonic);
    assert(h.rollback_protected);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        secure_updates_secure(hardened_secure_updates()),
        hardened_secure_updates().assurance_level >= baseline_secure_updates().assurance_level,
{
    let baseline = baseline_secure_updates();
    let hardened = hardened_secure_updates();
    assert(secure_updates_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !secure_updates_secure(UpdatePackage { signature_valid: false, version_monotonic: true, rollback_protected: true, assurance_level: 1 }),
        !secure_updates_secure(UpdatePackage { signature_valid: true, version_monotonic: false, rollback_protected: true, assurance_level: 1 }),
        !secure_updates_secure(UpdatePackage { signature_valid: true, version_monotonic: true, rollback_protected: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !secure_updates_secure(UpdatePackage { signature_valid: true, version_monotonic: true, rollback_protected: true, assurance_level: 0 }),
{
}

} // verus!

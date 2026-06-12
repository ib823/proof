// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Key Lifecycle domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Key Lifecycle verification
pub struct CryptoKey {
    pub generated_securely: bool,
    pub rotation_scheduled: bool,
    pub destroyed_on_expiry: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn key_lifecycle_secure(s: CryptoKey) -> bool {
    s.generated_securely && s.rotation_scheduled && s.destroyed_on_expiry && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_key_lifecycle() -> CryptoKey {
    CryptoKey {
        generated_securely: true,
        rotation_scheduled: true,
        destroyed_on_expiry: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_key_lifecycle() -> CryptoKey {
    CryptoKey {
        generated_securely: true,
        rotation_scheduled: true,
        destroyed_on_expiry: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures key_lifecycle_secure(baseline_key_lifecycle()),
{
    let b = baseline_key_lifecycle();
    assert(b.generated_securely);
    assert(b.rotation_scheduled);
    assert(b.destroyed_on_expiry);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures key_lifecycle_secure(hardened_key_lifecycle()),
{
    let h = hardened_key_lifecycle();
    assert(h.generated_securely);
    assert(h.rotation_scheduled);
    assert(h.destroyed_on_expiry);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        key_lifecycle_secure(hardened_key_lifecycle()),
        hardened_key_lifecycle().assurance_level >= baseline_key_lifecycle().assurance_level,
{
    let baseline = baseline_key_lifecycle();
    let hardened = hardened_key_lifecycle();
    assert(key_lifecycle_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !key_lifecycle_secure(CryptoKey { generated_securely: false, rotation_scheduled: true, destroyed_on_expiry: true, assurance_level: 1 }),
        !key_lifecycle_secure(CryptoKey { generated_securely: true, rotation_scheduled: false, destroyed_on_expiry: true, assurance_level: 1 }),
        !key_lifecycle_secure(CryptoKey { generated_securely: true, rotation_scheduled: true, destroyed_on_expiry: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !key_lifecycle_secure(CryptoKey { generated_securely: true, rotation_scheduled: true, destroyed_on_expiry: true, assurance_level: 0 }),
{
}

} // verus!

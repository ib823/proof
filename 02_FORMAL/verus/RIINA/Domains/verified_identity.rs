// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Verified Identity domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Verified Identity verification
pub struct IdentityClaim {
    pub credential_verified: bool,
    pub attribute_authentic: bool,
    pub session_bound: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn verified_identity_secure(s: IdentityClaim) -> bool {
    s.credential_verified && s.attribute_authentic && s.session_bound && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_verified_identity() -> IdentityClaim {
    IdentityClaim {
        credential_verified: true,
        attribute_authentic: true,
        session_bound: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_verified_identity() -> IdentityClaim {
    IdentityClaim {
        credential_verified: true,
        attribute_authentic: true,
        session_bound: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures verified_identity_secure(baseline_verified_identity()),
{
    let b = baseline_verified_identity();
    assert(b.credential_verified);
    assert(b.attribute_authentic);
    assert(b.session_bound);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures verified_identity_secure(hardened_verified_identity()),
{
    let h = hardened_verified_identity();
    assert(h.credential_verified);
    assert(h.attribute_authentic);
    assert(h.session_bound);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        verified_identity_secure(hardened_verified_identity()),
        hardened_verified_identity().assurance_level >= baseline_verified_identity().assurance_level,
{
    let baseline = baseline_verified_identity();
    let hardened = hardened_verified_identity();
    assert(verified_identity_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !verified_identity_secure(IdentityClaim { credential_verified: false, attribute_authentic: true, session_bound: true, assurance_level: 1 }),
        !verified_identity_secure(IdentityClaim { credential_verified: true, attribute_authentic: false, session_bound: true, assurance_level: 1 }),
        !verified_identity_secure(IdentityClaim { credential_verified: true, attribute_authentic: true, session_bound: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !verified_identity_secure(IdentityClaim { credential_verified: true, attribute_authentic: true, session_bound: true, assurance_level: 0 }),
{
}

} // verus!

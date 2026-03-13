// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Authentication Security domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Authentication Security verification
pub struct AuthSession {
    pub credential_hashed: bool,
    pub session_bounded: bool,
    pub mfa_required: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn authentication_security_secure(s: AuthSession) -> bool {
    s.credential_hashed && s.session_bounded && s.mfa_required && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_authentication_security() -> AuthSession {
    AuthSession {
        credential_hashed: true,
        session_bounded: true,
        mfa_required: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_authentication_security() -> AuthSession {
    AuthSession {
        credential_hashed: true,
        session_bounded: true,
        mfa_required: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures authentication_security_secure(baseline_authentication_security()),
{
    let b = baseline_authentication_security();
    assert(b.credential_hashed);
    assert(b.session_bounded);
    assert(b.mfa_required);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures authentication_security_secure(hardened_authentication_security()),
{
    let h = hardened_authentication_security();
    assert(h.credential_hashed);
    assert(h.session_bounded);
    assert(h.mfa_required);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        authentication_security_secure(hardened_authentication_security()),
        hardened_authentication_security().assurance_level >= baseline_authentication_security().assurance_level,
{
    let baseline = baseline_authentication_security();
    let hardened = hardened_authentication_security();
    assert(authentication_security_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !authentication_security_secure(AuthSession { credential_hashed: false, session_bounded: true, mfa_required: true, assurance_level: 1 }),
        !authentication_security_secure(AuthSession { credential_hashed: true, session_bounded: false, mfa_required: true, assurance_level: 1 }),
        !authentication_security_secure(AuthSession { credential_hashed: true, session_bounded: true, mfa_required: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !authentication_security_secure(AuthSession { credential_hashed: true, session_bounded: true, mfa_required: true, assurance_level: 0 }),
{
}

} // verus!

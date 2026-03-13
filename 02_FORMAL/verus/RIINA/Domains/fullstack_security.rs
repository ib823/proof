// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Fullstack Security domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Fullstack Security verification
pub struct FullStackApp {
    pub frontend_sanitized: bool,
    pub api_authenticated: bool,
    pub db_parameterized: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn fullstack_security_secure(s: FullStackApp) -> bool {
    s.frontend_sanitized && s.api_authenticated && s.db_parameterized && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_fullstack_security() -> FullStackApp {
    FullStackApp {
        frontend_sanitized: true,
        api_authenticated: true,
        db_parameterized: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_fullstack_security() -> FullStackApp {
    FullStackApp {
        frontend_sanitized: true,
        api_authenticated: true,
        db_parameterized: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures fullstack_security_secure(baseline_fullstack_security()),
{
    let b = baseline_fullstack_security();
    assert(b.frontend_sanitized);
    assert(b.api_authenticated);
    assert(b.db_parameterized);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures fullstack_security_secure(hardened_fullstack_security()),
{
    let h = hardened_fullstack_security();
    assert(h.frontend_sanitized);
    assert(h.api_authenticated);
    assert(h.db_parameterized);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        fullstack_security_secure(hardened_fullstack_security()),
        hardened_fullstack_security().assurance_level >= baseline_fullstack_security().assurance_level,
{
    let baseline = baseline_fullstack_security();
    let hardened = hardened_fullstack_security();
    assert(fullstack_security_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !fullstack_security_secure(FullStackApp { frontend_sanitized: false, api_authenticated: true, db_parameterized: true, assurance_level: 1 }),
        !fullstack_security_secure(FullStackApp { frontend_sanitized: true, api_authenticated: false, db_parameterized: true, assurance_level: 1 }),
        !fullstack_security_secure(FullStackApp { frontend_sanitized: true, api_authenticated: true, db_parameterized: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !fullstack_security_secure(FullStackApp { frontend_sanitized: true, api_authenticated: true, db_parameterized: true, assurance_level: 0 }),
{
}

} // verus!

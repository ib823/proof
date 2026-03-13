// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Injection Prevention domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Injection Prevention verification
pub struct UserInput {
    pub sanitized: bool,
    pub parameterized: bool,
    pub no_metachar_injection: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn injection_prevention_secure(s: UserInput) -> bool {
    s.sanitized && s.parameterized && s.no_metachar_injection && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_injection_prevention() -> UserInput {
    UserInput {
        sanitized: true,
        parameterized: true,
        no_metachar_injection: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_injection_prevention() -> UserInput {
    UserInput {
        sanitized: true,
        parameterized: true,
        no_metachar_injection: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures injection_prevention_secure(baseline_injection_prevention()),
{
    let b = baseline_injection_prevention();
    assert(b.sanitized);
    assert(b.parameterized);
    assert(b.no_metachar_injection);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures injection_prevention_secure(hardened_injection_prevention()),
{
    let h = hardened_injection_prevention();
    assert(h.sanitized);
    assert(h.parameterized);
    assert(h.no_metachar_injection);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        injection_prevention_secure(hardened_injection_prevention()),
        hardened_injection_prevention().assurance_level >= baseline_injection_prevention().assurance_level,
{
    let baseline = baseline_injection_prevention();
    let hardened = hardened_injection_prevention();
    assert(injection_prevention_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !injection_prevention_secure(UserInput { sanitized: false, parameterized: true, no_metachar_injection: true, assurance_level: 1 }),
        !injection_prevention_secure(UserInput { sanitized: true, parameterized: false, no_metachar_injection: true, assurance_level: 1 }),
        !injection_prevention_secure(UserInput { sanitized: true, parameterized: true, no_metachar_injection: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !injection_prevention_secure(UserInput { sanitized: true, parameterized: true, no_metachar_injection: true, assurance_level: 0 }),
{
}

} // verus!

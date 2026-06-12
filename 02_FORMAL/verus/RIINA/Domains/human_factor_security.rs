// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Human Factor Security domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Human Factor Security verification
pub struct SecurityUX {
    pub error_message_safe: bool,
    pub default_secure: bool,
    pub phishing_resistant: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn human_factor_security_secure(s: SecurityUX) -> bool {
    s.error_message_safe && s.default_secure && s.phishing_resistant && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_human_factor_security() -> SecurityUX {
    SecurityUX {
        error_message_safe: true,
        default_secure: true,
        phishing_resistant: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_human_factor_security() -> SecurityUX {
    SecurityUX {
        error_message_safe: true,
        default_secure: true,
        phishing_resistant: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures human_factor_security_secure(baseline_human_factor_security()),
{
    let b = baseline_human_factor_security();
    assert(b.error_message_safe);
    assert(b.default_secure);
    assert(b.phishing_resistant);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures human_factor_security_secure(hardened_human_factor_security()),
{
    let h = hardened_human_factor_security();
    assert(h.error_message_safe);
    assert(h.default_secure);
    assert(h.phishing_resistant);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        human_factor_security_secure(hardened_human_factor_security()),
        hardened_human_factor_security().assurance_level >= baseline_human_factor_security().assurance_level,
{
    let baseline = baseline_human_factor_security();
    let hardened = hardened_human_factor_security();
    assert(human_factor_security_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !human_factor_security_secure(SecurityUX { error_message_safe: false, default_secure: true, phishing_resistant: true, assurance_level: 1 }),
        !human_factor_security_secure(SecurityUX { error_message_safe: true, default_secure: false, phishing_resistant: true, assurance_level: 1 }),
        !human_factor_security_secure(SecurityUX { error_message_safe: true, default_secure: true, phishing_resistant: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !human_factor_security_secure(SecurityUX { error_message_safe: true, default_secure: true, phishing_resistant: true, assurance_level: 0 }),
{
}

} // verus!

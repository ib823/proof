// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Singapore Cyber Trust Mark domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Singapore Cyber Trust Mark verification
pub struct SGCyberTrust {
    pub mark_awarded: bool,
    pub assessment_passed: bool,
    pub renewal_tracked: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn singapore_cyber_trust_mark_secure(s: SGCyberTrust) -> bool {
    s.mark_awarded && s.assessment_passed && s.renewal_tracked && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_singapore_cyber_trust_mark() -> SGCyberTrust {
    SGCyberTrust {
        mark_awarded: true,
        assessment_passed: true,
        renewal_tracked: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_singapore_cyber_trust_mark() -> SGCyberTrust {
    SGCyberTrust {
        mark_awarded: true,
        assessment_passed: true,
        renewal_tracked: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures singapore_cyber_trust_mark_secure(baseline_singapore_cyber_trust_mark()),
{
    let b = baseline_singapore_cyber_trust_mark();
    assert(b.mark_awarded);
    assert(b.assessment_passed);
    assert(b.renewal_tracked);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures singapore_cyber_trust_mark_secure(hardened_singapore_cyber_trust_mark()),
{
    let h = hardened_singapore_cyber_trust_mark();
    assert(h.mark_awarded);
    assert(h.assessment_passed);
    assert(h.renewal_tracked);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        singapore_cyber_trust_mark_secure(hardened_singapore_cyber_trust_mark()),
        hardened_singapore_cyber_trust_mark().assurance_level >= baseline_singapore_cyber_trust_mark().assurance_level,
{
    let baseline = baseline_singapore_cyber_trust_mark();
    let hardened = hardened_singapore_cyber_trust_mark();
    assert(singapore_cyber_trust_mark_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !singapore_cyber_trust_mark_secure(SGCyberTrust { mark_awarded: false, assessment_passed: true, renewal_tracked: true, assurance_level: 1 }),
        !singapore_cyber_trust_mark_secure(SGCyberTrust { mark_awarded: true, assessment_passed: false, renewal_tracked: true, assurance_level: 1 }),
        !singapore_cyber_trust_mark_secure(SGCyberTrust { mark_awarded: true, assessment_passed: true, renewal_tracked: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !singapore_cyber_trust_mark_secure(SGCyberTrust { mark_awarded: true, assessment_passed: true, renewal_tracked: true, assurance_level: 0 }),
{
}

} // verus!

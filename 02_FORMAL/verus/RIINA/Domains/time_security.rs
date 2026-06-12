// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Time Security domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Time Security verification
pub struct TimeSource {
    pub monotonic: bool,
    pub bounded_drift: bool,
    pub ntp_authenticated: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn time_security_secure(s: TimeSource) -> bool {
    s.monotonic && s.bounded_drift && s.ntp_authenticated && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_time_security() -> TimeSource {
    TimeSource {
        monotonic: true,
        bounded_drift: true,
        ntp_authenticated: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_time_security() -> TimeSource {
    TimeSource {
        monotonic: true,
        bounded_drift: true,
        ntp_authenticated: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures time_security_secure(baseline_time_security()),
{
    let b = baseline_time_security();
    assert(b.monotonic);
    assert(b.bounded_drift);
    assert(b.ntp_authenticated);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures time_security_secure(hardened_time_security()),
{
    let h = hardened_time_security();
    assert(h.monotonic);
    assert(h.bounded_drift);
    assert(h.ntp_authenticated);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        time_security_secure(hardened_time_security()),
        hardened_time_security().assurance_level >= baseline_time_security().assurance_level,
{
    let baseline = baseline_time_security();
    let hardened = hardened_time_security();
    assert(time_security_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !time_security_secure(TimeSource { monotonic: false, bounded_drift: true, ntp_authenticated: true, assurance_level: 1 }),
        !time_security_secure(TimeSource { monotonic: true, bounded_drift: false, ntp_authenticated: true, assurance_level: 1 }),
        !time_security_secure(TimeSource { monotonic: true, bounded_drift: true, ntp_authenticated: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !time_security_secure(TimeSource { monotonic: true, bounded_drift: true, ntp_authenticated: true, assurance_level: 0 }),
{
}

} // verus!

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Malaysia Cybersecurity Act domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Malaysia Cybersecurity Act verification
pub struct CyberIncident {
    pub reported_timely: bool,
    pub ncii_protected: bool,
    pub license_valid: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn malaysia_cybersecurity_act_secure(s: CyberIncident) -> bool {
    s.reported_timely && s.ncii_protected && s.license_valid && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_malaysia_cybersecurity_act() -> CyberIncident {
    CyberIncident {
        reported_timely: true,
        ncii_protected: true,
        license_valid: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_malaysia_cybersecurity_act() -> CyberIncident {
    CyberIncident {
        reported_timely: true,
        ncii_protected: true,
        license_valid: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures malaysia_cybersecurity_act_secure(baseline_malaysia_cybersecurity_act()),
{
    let b = baseline_malaysia_cybersecurity_act();
    assert(b.reported_timely);
    assert(b.ncii_protected);
    assert(b.license_valid);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures malaysia_cybersecurity_act_secure(hardened_malaysia_cybersecurity_act()),
{
    let h = hardened_malaysia_cybersecurity_act();
    assert(h.reported_timely);
    assert(h.ncii_protected);
    assert(h.license_valid);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        malaysia_cybersecurity_act_secure(hardened_malaysia_cybersecurity_act()),
        hardened_malaysia_cybersecurity_act().assurance_level >= baseline_malaysia_cybersecurity_act().assurance_level,
{
    let baseline = baseline_malaysia_cybersecurity_act();
    let hardened = hardened_malaysia_cybersecurity_act();
    assert(malaysia_cybersecurity_act_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !malaysia_cybersecurity_act_secure(CyberIncident { reported_timely: false, ncii_protected: true, license_valid: true, assurance_level: 1 }),
        !malaysia_cybersecurity_act_secure(CyberIncident { reported_timely: true, ncii_protected: false, license_valid: true, assurance_level: 1 }),
        !malaysia_cybersecurity_act_secure(CyberIncident { reported_timely: true, ncii_protected: true, license_valid: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !malaysia_cybersecurity_act_secure(CyberIncident { reported_timely: true, ncii_protected: true, license_valid: true, assurance_level: 0 }),
{
}

} // verus!

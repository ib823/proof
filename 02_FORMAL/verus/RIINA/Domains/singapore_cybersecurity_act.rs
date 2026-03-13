// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Singapore Cybersecurity Act domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Singapore Cybersecurity Act verification
pub struct SGCriticalInfra {
    pub cii_designated: bool,
    pub audit_completed: bool,
    pub incident_reported: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn singapore_cybersecurity_act_secure(s: SGCriticalInfra) -> bool {
    s.cii_designated && s.audit_completed && s.incident_reported && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_singapore_cybersecurity_act() -> SGCriticalInfra {
    SGCriticalInfra {
        cii_designated: true,
        audit_completed: true,
        incident_reported: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_singapore_cybersecurity_act() -> SGCriticalInfra {
    SGCriticalInfra {
        cii_designated: true,
        audit_completed: true,
        incident_reported: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures singapore_cybersecurity_act_secure(baseline_singapore_cybersecurity_act()),
{
    let b = baseline_singapore_cybersecurity_act();
    assert(b.cii_designated);
    assert(b.audit_completed);
    assert(b.incident_reported);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures singapore_cybersecurity_act_secure(hardened_singapore_cybersecurity_act()),
{
    let h = hardened_singapore_cybersecurity_act();
    assert(h.cii_designated);
    assert(h.audit_completed);
    assert(h.incident_reported);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        singapore_cybersecurity_act_secure(hardened_singapore_cybersecurity_act()),
        hardened_singapore_cybersecurity_act().assurance_level >= baseline_singapore_cybersecurity_act().assurance_level,
{
    let baseline = baseline_singapore_cybersecurity_act();
    let hardened = hardened_singapore_cybersecurity_act();
    assert(singapore_cybersecurity_act_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !singapore_cybersecurity_act_secure(SGCriticalInfra { cii_designated: false, audit_completed: true, incident_reported: true, assurance_level: 1 }),
        !singapore_cybersecurity_act_secure(SGCriticalInfra { cii_designated: true, audit_completed: false, incident_reported: true, assurance_level: 1 }),
        !singapore_cybersecurity_act_secure(SGCriticalInfra { cii_designated: true, audit_completed: true, incident_reported: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !singapore_cybersecurity_act_secure(SGCriticalInfra { cii_designated: true, audit_completed: true, incident_reported: true, assurance_level: 0 }),
{
}

} // verus!

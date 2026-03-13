// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Psi001  Operational Security domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Psi001  Operational Security verification
pub struct OpsSecurity {
    pub incident_response_tested: bool,
    pub secrets_managed: bool,
    pub access_audited: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn psi001__operational_security_secure(s: OpsSecurity) -> bool {
    s.incident_response_tested && s.secrets_managed && s.access_audited && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_psi001__operational_security() -> OpsSecurity {
    OpsSecurity {
        incident_response_tested: true,
        secrets_managed: true,
        access_audited: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_psi001__operational_security() -> OpsSecurity {
    OpsSecurity {
        incident_response_tested: true,
        secrets_managed: true,
        access_audited: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures psi001__operational_security_secure(baseline_psi001__operational_security()),
{
    let b = baseline_psi001__operational_security();
    assert(b.incident_response_tested);
    assert(b.secrets_managed);
    assert(b.access_audited);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures psi001__operational_security_secure(hardened_psi001__operational_security()),
{
    let h = hardened_psi001__operational_security();
    assert(h.incident_response_tested);
    assert(h.secrets_managed);
    assert(h.access_audited);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        psi001__operational_security_secure(hardened_psi001__operational_security()),
        hardened_psi001__operational_security().assurance_level >= baseline_psi001__operational_security().assurance_level,
{
    let baseline = baseline_psi001__operational_security();
    let hardened = hardened_psi001__operational_security();
    assert(psi001__operational_security_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !psi001__operational_security_secure(OpsSecurity { incident_response_tested: false, secrets_managed: true, access_audited: true, assurance_level: 1 }),
        !psi001__operational_security_secure(OpsSecurity { incident_response_tested: true, secrets_managed: false, access_audited: true, assurance_level: 1 }),
        !psi001__operational_security_secure(OpsSecurity { incident_response_tested: true, secrets_managed: true, access_audited: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !psi001__operational_security_secure(OpsSecurity { incident_response_tested: true, secrets_managed: true, access_audited: true, assurance_level: 0 }),
{
}

} // verus!

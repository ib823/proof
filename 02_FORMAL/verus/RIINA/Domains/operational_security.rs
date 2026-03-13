// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Operational Security domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Operational Security verification
pub struct OpsPolicy {
    pub access_reviewed: bool,
    pub secrets_rotated: bool,
    pub alerts_triaged: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn operational_security_secure(s: OpsPolicy) -> bool {
    s.access_reviewed && s.secrets_rotated && s.alerts_triaged && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_operational_security() -> OpsPolicy {
    OpsPolicy {
        access_reviewed: true,
        secrets_rotated: true,
        alerts_triaged: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_operational_security() -> OpsPolicy {
    OpsPolicy {
        access_reviewed: true,
        secrets_rotated: true,
        alerts_triaged: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures operational_security_secure(baseline_operational_security()),
{
    let b = baseline_operational_security();
    assert(b.access_reviewed);
    assert(b.secrets_rotated);
    assert(b.alerts_triaged);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures operational_security_secure(hardened_operational_security()),
{
    let h = hardened_operational_security();
    assert(h.access_reviewed);
    assert(h.secrets_rotated);
    assert(h.alerts_triaged);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        operational_security_secure(hardened_operational_security()),
        hardened_operational_security().assurance_level >= baseline_operational_security().assurance_level,
{
    let baseline = baseline_operational_security();
    let hardened = hardened_operational_security();
    assert(operational_security_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !operational_security_secure(OpsPolicy { access_reviewed: false, secrets_rotated: true, alerts_triaged: true, assurance_level: 1 }),
        !operational_security_secure(OpsPolicy { access_reviewed: true, secrets_rotated: false, alerts_triaged: true, assurance_level: 1 }),
        !operational_security_secure(OpsPolicy { access_reviewed: true, secrets_rotated: true, alerts_triaged: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !operational_security_secure(OpsPolicy { access_reviewed: true, secrets_rotated: true, alerts_triaged: true, assurance_level: 0 }),
{
}

} // verus!

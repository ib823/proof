// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Verified Infra domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Verified Infra verification
pub struct InfraComponent {
    pub provisioned_securely: bool,
    pub monitored: bool,
    pub patched_timely: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn verified_infra_secure(s: InfraComponent) -> bool {
    s.provisioned_securely && s.monitored && s.patched_timely && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_verified_infra() -> InfraComponent {
    InfraComponent {
        provisioned_securely: true,
        monitored: true,
        patched_timely: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_verified_infra() -> InfraComponent {
    InfraComponent {
        provisioned_securely: true,
        monitored: true,
        patched_timely: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures verified_infra_secure(baseline_verified_infra()),
{
    let b = baseline_verified_infra();
    assert(b.provisioned_securely);
    assert(b.monitored);
    assert(b.patched_timely);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures verified_infra_secure(hardened_verified_infra()),
{
    let h = hardened_verified_infra();
    assert(h.provisioned_securely);
    assert(h.monitored);
    assert(h.patched_timely);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        verified_infra_secure(hardened_verified_infra()),
        hardened_verified_infra().assurance_level >= baseline_verified_infra().assurance_level,
{
    let baseline = baseline_verified_infra();
    let hardened = hardened_verified_infra();
    assert(verified_infra_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !verified_infra_secure(InfraComponent { provisioned_securely: false, monitored: true, patched_timely: true, assurance_level: 1 }),
        !verified_infra_secure(InfraComponent { provisioned_securely: true, monitored: false, patched_timely: true, assurance_level: 1 }),
        !verified_infra_secure(InfraComponent { provisioned_securely: true, monitored: true, patched_timely: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !verified_infra_secure(InfraComponent { provisioned_securely: true, monitored: true, patched_timely: true, assurance_level: 0 }),
{
}

} // verus!

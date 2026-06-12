// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Verified Compliance domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Verified Compliance verification
pub struct ComplianceReport {
    pub controls_tested: bool,
    pub evidence_linked: bool,
    pub gap_identified: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn verified_compliance_secure(s: ComplianceReport) -> bool {
    s.controls_tested && s.evidence_linked && s.gap_identified && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_verified_compliance() -> ComplianceReport {
    ComplianceReport {
        controls_tested: true,
        evidence_linked: true,
        gap_identified: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_verified_compliance() -> ComplianceReport {
    ComplianceReport {
        controls_tested: true,
        evidence_linked: true,
        gap_identified: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures verified_compliance_secure(baseline_verified_compliance()),
{
    let b = baseline_verified_compliance();
    assert(b.controls_tested);
    assert(b.evidence_linked);
    assert(b.gap_identified);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures verified_compliance_secure(hardened_verified_compliance()),
{
    let h = hardened_verified_compliance();
    assert(h.controls_tested);
    assert(h.evidence_linked);
    assert(h.gap_identified);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        verified_compliance_secure(hardened_verified_compliance()),
        hardened_verified_compliance().assurance_level >= baseline_verified_compliance().assurance_level,
{
    let baseline = baseline_verified_compliance();
    let hardened = hardened_verified_compliance();
    assert(verified_compliance_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !verified_compliance_secure(ComplianceReport { controls_tested: false, evidence_linked: true, gap_identified: true, assurance_level: 1 }),
        !verified_compliance_secure(ComplianceReport { controls_tested: true, evidence_linked: false, gap_identified: true, assurance_level: 1 }),
        !verified_compliance_secure(ComplianceReport { controls_tested: true, evidence_linked: true, gap_identified: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !verified_compliance_secure(ComplianceReport { controls_tested: true, evidence_linked: true, gap_identified: true, assurance_level: 0 }),
{
}

} // verus!

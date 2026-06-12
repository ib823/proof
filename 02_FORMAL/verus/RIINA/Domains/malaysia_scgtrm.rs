// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Malaysia Scgtrm domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Malaysia Scgtrm verification
pub struct CapitalMarket {
    pub fit_proper_assessed: bool,
    pub aml_compliant: bool,
    pub reporting_timely: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn malaysia_scgtrm_secure(s: CapitalMarket) -> bool {
    s.fit_proper_assessed && s.aml_compliant && s.reporting_timely && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_malaysia_scgtrm() -> CapitalMarket {
    CapitalMarket {
        fit_proper_assessed: true,
        aml_compliant: true,
        reporting_timely: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_malaysia_scgtrm() -> CapitalMarket {
    CapitalMarket {
        fit_proper_assessed: true,
        aml_compliant: true,
        reporting_timely: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures malaysia_scgtrm_secure(baseline_malaysia_scgtrm()),
{
    let b = baseline_malaysia_scgtrm();
    assert(b.fit_proper_assessed);
    assert(b.aml_compliant);
    assert(b.reporting_timely);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures malaysia_scgtrm_secure(hardened_malaysia_scgtrm()),
{
    let h = hardened_malaysia_scgtrm();
    assert(h.fit_proper_assessed);
    assert(h.aml_compliant);
    assert(h.reporting_timely);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        malaysia_scgtrm_secure(hardened_malaysia_scgtrm()),
        hardened_malaysia_scgtrm().assurance_level >= baseline_malaysia_scgtrm().assurance_level,
{
    let baseline = baseline_malaysia_scgtrm();
    let hardened = hardened_malaysia_scgtrm();
    assert(malaysia_scgtrm_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !malaysia_scgtrm_secure(CapitalMarket { fit_proper_assessed: false, aml_compliant: true, reporting_timely: true, assurance_level: 1 }),
        !malaysia_scgtrm_secure(CapitalMarket { fit_proper_assessed: true, aml_compliant: false, reporting_timely: true, assurance_level: 1 }),
        !malaysia_scgtrm_secure(CapitalMarket { fit_proper_assessed: true, aml_compliant: true, reporting_timely: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !malaysia_scgtrm_secure(CapitalMarket { fit_proper_assessed: true, aml_compliant: true, reporting_timely: true, assurance_level: 0 }),
{
}

} // verus!

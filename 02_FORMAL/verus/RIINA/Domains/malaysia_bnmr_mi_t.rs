// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Malaysia Bnmr Mi T domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Malaysia Bnmr Mi T verification
pub struct FinancialSystem {
    pub risk_assessed: bool,
    pub controls_tested: bool,
    pub incident_reported: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn malaysia_bnmr_mi_t_secure(s: FinancialSystem) -> bool {
    s.risk_assessed && s.controls_tested && s.incident_reported && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_malaysia_bnmr_mi_t() -> FinancialSystem {
    FinancialSystem {
        risk_assessed: true,
        controls_tested: true,
        incident_reported: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_malaysia_bnmr_mi_t() -> FinancialSystem {
    FinancialSystem {
        risk_assessed: true,
        controls_tested: true,
        incident_reported: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures malaysia_bnmr_mi_t_secure(baseline_malaysia_bnmr_mi_t()),
{
    let b = baseline_malaysia_bnmr_mi_t();
    assert(b.risk_assessed);
    assert(b.controls_tested);
    assert(b.incident_reported);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures malaysia_bnmr_mi_t_secure(hardened_malaysia_bnmr_mi_t()),
{
    let h = hardened_malaysia_bnmr_mi_t();
    assert(h.risk_assessed);
    assert(h.controls_tested);
    assert(h.incident_reported);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        malaysia_bnmr_mi_t_secure(hardened_malaysia_bnmr_mi_t()),
        hardened_malaysia_bnmr_mi_t().assurance_level >= baseline_malaysia_bnmr_mi_t().assurance_level,
{
    let baseline = baseline_malaysia_bnmr_mi_t();
    let hardened = hardened_malaysia_bnmr_mi_t();
    assert(malaysia_bnmr_mi_t_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !malaysia_bnmr_mi_t_secure(FinancialSystem { risk_assessed: false, controls_tested: true, incident_reported: true, assurance_level: 1 }),
        !malaysia_bnmr_mi_t_secure(FinancialSystem { risk_assessed: true, controls_tested: false, incident_reported: true, assurance_level: 1 }),
        !malaysia_bnmr_mi_t_secure(FinancialSystem { risk_assessed: true, controls_tested: true, incident_reported: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !malaysia_bnmr_mi_t_secure(FinancialSystem { risk_assessed: true, controls_tested: true, incident_reported: true, assurance_level: 0 }),
{
}

} // verus!

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Singapore Mas Trm domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Singapore Mas Trm verification
pub struct SGFinTech {
    pub risk_framework_adopted: bool,
    pub outsourcing_managed: bool,
    pub bcm_tested: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn singapore_mas_trm_secure(s: SGFinTech) -> bool {
    s.risk_framework_adopted && s.outsourcing_managed && s.bcm_tested && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_singapore_mas_trm() -> SGFinTech {
    SGFinTech {
        risk_framework_adopted: true,
        outsourcing_managed: true,
        bcm_tested: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_singapore_mas_trm() -> SGFinTech {
    SGFinTech {
        risk_framework_adopted: true,
        outsourcing_managed: true,
        bcm_tested: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures singapore_mas_trm_secure(baseline_singapore_mas_trm()),
{
    let b = baseline_singapore_mas_trm();
    assert(b.risk_framework_adopted);
    assert(b.outsourcing_managed);
    assert(b.bcm_tested);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures singapore_mas_trm_secure(hardened_singapore_mas_trm()),
{
    let h = hardened_singapore_mas_trm();
    assert(h.risk_framework_adopted);
    assert(h.outsourcing_managed);
    assert(h.bcm_tested);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        singapore_mas_trm_secure(hardened_singapore_mas_trm()),
        hardened_singapore_mas_trm().assurance_level >= baseline_singapore_mas_trm().assurance_level,
{
    let baseline = baseline_singapore_mas_trm();
    let hardened = hardened_singapore_mas_trm();
    assert(singapore_mas_trm_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !singapore_mas_trm_secure(SGFinTech { risk_framework_adopted: false, outsourcing_managed: true, bcm_tested: true, assurance_level: 1 }),
        !singapore_mas_trm_secure(SGFinTech { risk_framework_adopted: true, outsourcing_managed: false, bcm_tested: true, assurance_level: 1 }),
        !singapore_mas_trm_secure(SGFinTech { risk_framework_adopted: true, outsourcing_managed: true, bcm_tested: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !singapore_mas_trm_secure(SGFinTech { risk_framework_adopted: true, outsourcing_managed: true, bcm_tested: true, assurance_level: 0 }),
{
}

} // verus!

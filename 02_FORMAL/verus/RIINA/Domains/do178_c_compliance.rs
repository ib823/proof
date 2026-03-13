// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Do178 C Compliance domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Do178 C Compliance verification
pub struct DO178CObjective {
    pub dal_assigned: bool,
    pub mc_dc_achieved: bool,
    pub traceability_bidirectional: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn do178_c_compliance_secure(s: DO178CObjective) -> bool {
    s.dal_assigned && s.mc_dc_achieved && s.traceability_bidirectional && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_do178_c_compliance() -> DO178CObjective {
    DO178CObjective {
        dal_assigned: true,
        mc_dc_achieved: true,
        traceability_bidirectional: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_do178_c_compliance() -> DO178CObjective {
    DO178CObjective {
        dal_assigned: true,
        mc_dc_achieved: true,
        traceability_bidirectional: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures do178_c_compliance_secure(baseline_do178_c_compliance()),
{
    let b = baseline_do178_c_compliance();
    assert(b.dal_assigned);
    assert(b.mc_dc_achieved);
    assert(b.traceability_bidirectional);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures do178_c_compliance_secure(hardened_do178_c_compliance()),
{
    let h = hardened_do178_c_compliance();
    assert(h.dal_assigned);
    assert(h.mc_dc_achieved);
    assert(h.traceability_bidirectional);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        do178_c_compliance_secure(hardened_do178_c_compliance()),
        hardened_do178_c_compliance().assurance_level >= baseline_do178_c_compliance().assurance_level,
{
    let baseline = baseline_do178_c_compliance();
    let hardened = hardened_do178_c_compliance();
    assert(do178_c_compliance_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !do178_c_compliance_secure(DO178CObjective { dal_assigned: false, mc_dc_achieved: true, traceability_bidirectional: true, assurance_level: 1 }),
        !do178_c_compliance_secure(DO178CObjective { dal_assigned: true, mc_dc_achieved: false, traceability_bidirectional: true, assurance_level: 1 }),
        !do178_c_compliance_secure(DO178CObjective { dal_assigned: true, mc_dc_achieved: true, traceability_bidirectional: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !do178_c_compliance_secure(DO178CObjective { dal_assigned: true, mc_dc_achieved: true, traceability_bidirectional: true, assurance_level: 0 }),
{
}

} // verus!

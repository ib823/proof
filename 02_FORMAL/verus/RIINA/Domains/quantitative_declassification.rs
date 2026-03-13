// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Quantitative Declassification domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Quantitative Declassification verification
pub struct DeclassPolicy {
    pub budget_positive: bool,
    pub leakage_bounded: bool,
    pub audit_logged: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn quantitative_declassification_secure(s: DeclassPolicy) -> bool {
    s.budget_positive && s.leakage_bounded && s.audit_logged && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_quantitative_declassification() -> DeclassPolicy {
    DeclassPolicy {
        budget_positive: true,
        leakage_bounded: true,
        audit_logged: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_quantitative_declassification() -> DeclassPolicy {
    DeclassPolicy {
        budget_positive: true,
        leakage_bounded: true,
        audit_logged: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures quantitative_declassification_secure(baseline_quantitative_declassification()),
{
    let b = baseline_quantitative_declassification();
    assert(b.budget_positive);
    assert(b.leakage_bounded);
    assert(b.audit_logged);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures quantitative_declassification_secure(hardened_quantitative_declassification()),
{
    let h = hardened_quantitative_declassification();
    assert(h.budget_positive);
    assert(h.leakage_bounded);
    assert(h.audit_logged);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        quantitative_declassification_secure(hardened_quantitative_declassification()),
        hardened_quantitative_declassification().assurance_level >= baseline_quantitative_declassification().assurance_level,
{
    let baseline = baseline_quantitative_declassification();
    let hardened = hardened_quantitative_declassification();
    assert(quantitative_declassification_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !quantitative_declassification_secure(DeclassPolicy { budget_positive: false, leakage_bounded: true, audit_logged: true, assurance_level: 1 }),
        !quantitative_declassification_secure(DeclassPolicy { budget_positive: true, leakage_bounded: false, audit_logged: true, assurance_level: 1 }),
        !quantitative_declassification_secure(DeclassPolicy { budget_positive: true, leakage_bounded: true, audit_logged: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !quantitative_declassification_secure(DeclassPolicy { budget_positive: true, leakage_bounded: true, audit_logged: true, assurance_level: 0 }),
{
}

} // verus!

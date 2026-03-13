// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Singapore Pdpa domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Singapore Pdpa verification
pub struct SGPersonalData {
    pub consent_obtained: bool,
    pub notification_given: bool,
    pub dpo_appointed: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn singapore_pdpa_secure(s: SGPersonalData) -> bool {
    s.consent_obtained && s.notification_given && s.dpo_appointed && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_singapore_pdpa() -> SGPersonalData {
    SGPersonalData {
        consent_obtained: true,
        notification_given: true,
        dpo_appointed: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_singapore_pdpa() -> SGPersonalData {
    SGPersonalData {
        consent_obtained: true,
        notification_given: true,
        dpo_appointed: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures singapore_pdpa_secure(baseline_singapore_pdpa()),
{
    let b = baseline_singapore_pdpa();
    assert(b.consent_obtained);
    assert(b.notification_given);
    assert(b.dpo_appointed);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures singapore_pdpa_secure(hardened_singapore_pdpa()),
{
    let h = hardened_singapore_pdpa();
    assert(h.consent_obtained);
    assert(h.notification_given);
    assert(h.dpo_appointed);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        singapore_pdpa_secure(hardened_singapore_pdpa()),
        hardened_singapore_pdpa().assurance_level >= baseline_singapore_pdpa().assurance_level,
{
    let baseline = baseline_singapore_pdpa();
    let hardened = hardened_singapore_pdpa();
    assert(singapore_pdpa_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !singapore_pdpa_secure(SGPersonalData { consent_obtained: false, notification_given: true, dpo_appointed: true, assurance_level: 1 }),
        !singapore_pdpa_secure(SGPersonalData { consent_obtained: true, notification_given: false, dpo_appointed: true, assurance_level: 1 }),
        !singapore_pdpa_secure(SGPersonalData { consent_obtained: true, notification_given: true, dpo_appointed: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !singapore_pdpa_secure(SGPersonalData { consent_obtained: true, notification_given: true, dpo_appointed: true, assurance_level: 0 }),
{
}

} // verus!

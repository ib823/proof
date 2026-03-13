// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Malaysia Bursa Gov domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Malaysia Bursa Gov verification
pub struct ListedEntity {
    pub disclosure_timely: bool,
    pub governance_documented: bool,
    pub audit_independent: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn malaysia_bursa_gov_secure(s: ListedEntity) -> bool {
    s.disclosure_timely && s.governance_documented && s.audit_independent && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_malaysia_bursa_gov() -> ListedEntity {
    ListedEntity {
        disclosure_timely: true,
        governance_documented: true,
        audit_independent: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_malaysia_bursa_gov() -> ListedEntity {
    ListedEntity {
        disclosure_timely: true,
        governance_documented: true,
        audit_independent: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures malaysia_bursa_gov_secure(baseline_malaysia_bursa_gov()),
{
    let b = baseline_malaysia_bursa_gov();
    assert(b.disclosure_timely);
    assert(b.governance_documented);
    assert(b.audit_independent);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures malaysia_bursa_gov_secure(hardened_malaysia_bursa_gov()),
{
    let h = hardened_malaysia_bursa_gov();
    assert(h.disclosure_timely);
    assert(h.governance_documented);
    assert(h.audit_independent);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        malaysia_bursa_gov_secure(hardened_malaysia_bursa_gov()),
        hardened_malaysia_bursa_gov().assurance_level >= baseline_malaysia_bursa_gov().assurance_level,
{
    let baseline = baseline_malaysia_bursa_gov();
    let hardened = hardened_malaysia_bursa_gov();
    assert(malaysia_bursa_gov_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !malaysia_bursa_gov_secure(ListedEntity { disclosure_timely: false, governance_documented: true, audit_independent: true, assurance_level: 1 }),
        !malaysia_bursa_gov_secure(ListedEntity { disclosure_timely: true, governance_documented: false, audit_independent: true, assurance_level: 1 }),
        !malaysia_bursa_gov_secure(ListedEntity { disclosure_timely: true, governance_documented: true, audit_independent: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !malaysia_bursa_gov_secure(ListedEntity { disclosure_timely: true, governance_documented: true, audit_independent: true, assurance_level: 0 }),
{
}

} // verus!

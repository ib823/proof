// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Verified Audit domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Verified Audit verification
pub struct AuditEntry {
    pub tamper_evident: bool,
    pub chronological: bool,
    pub attributable: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn verified_audit_secure(s: AuditEntry) -> bool {
    s.tamper_evident && s.chronological && s.attributable && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_verified_audit() -> AuditEntry {
    AuditEntry {
        tamper_evident: true,
        chronological: true,
        attributable: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_verified_audit() -> AuditEntry {
    AuditEntry {
        tamper_evident: true,
        chronological: true,
        attributable: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures verified_audit_secure(baseline_verified_audit()),
{
    let b = baseline_verified_audit();
    assert(b.tamper_evident);
    assert(b.chronological);
    assert(b.attributable);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures verified_audit_secure(hardened_verified_audit()),
{
    let h = hardened_verified_audit();
    assert(h.tamper_evident);
    assert(h.chronological);
    assert(h.attributable);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        verified_audit_secure(hardened_verified_audit()),
        hardened_verified_audit().assurance_level >= baseline_verified_audit().assurance_level,
{
    let baseline = baseline_verified_audit();
    let hardened = hardened_verified_audit();
    assert(verified_audit_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !verified_audit_secure(AuditEntry { tamper_evident: false, chronological: true, attributable: true, assurance_level: 1 }),
        !verified_audit_secure(AuditEntry { tamper_evident: true, chronological: false, attributable: true, assurance_level: 1 }),
        !verified_audit_secure(AuditEntry { tamper_evident: true, chronological: true, attributable: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !verified_audit_secure(AuditEntry { tamper_evident: true, chronological: true, attributable: true, assurance_level: 0 }),
{
}

} // verus!

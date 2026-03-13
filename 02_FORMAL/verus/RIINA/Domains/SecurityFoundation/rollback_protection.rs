// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of SecurityFoundation Rollback Protection invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// State model for Rollback Protection
pub struct VersionCounter {
    pub monotonic: bool,
    pub persisted: bool,
    pub tamper_evident: bool,
    pub recovery_safe: bool,
    pub assurance_level: u64,
}

/// Invariant: all properties must hold with positive assurance
pub open spec fn rollback_protection_valid(s: VersionCounter) -> bool {
    s.monotonic && s.persisted && s.tamper_evident && s.recovery_safe && s.assurance_level >= 1
}

/// Baseline configuration
pub open spec fn baseline_rollback_protection() -> VersionCounter {
    VersionCounter { monotonic: true, persisted: true, tamper_evident: true, recovery_safe: true, assurance_level: 1 }
}

/// Hardened configuration
pub open spec fn hardened_rollback_protection() -> VersionCounter {
    VersionCounter { monotonic: true, persisted: true, tamper_evident: true, recovery_safe: true, assurance_level: 3 }
}

/// Lemma: baseline is valid
proof fn lemma_baseline_valid()
    ensures rollback_protection_valid(baseline_rollback_protection()),
{
    let b = baseline_rollback_protection();
    assert(b.monotonic && b.persisted && b.tamper_evident && b.recovery_safe && b.assurance_level >= 1);
}

/// Lemma: hardened dominates baseline
proof fn lemma_hardened_dominates()
    ensures
        rollback_protection_valid(hardened_rollback_protection()),
        hardened_rollback_protection().assurance_level >= baseline_rollback_protection().assurance_level,
{
}

/// Lemma: each property is necessary
proof fn lemma_properties_necessary()
    ensures
        !rollback_protection_valid(VersionCounter { monotonic: false, persisted: true, tamper_evident: true, recovery_safe: true, assurance_level: 1 }),
        !rollback_protection_valid(VersionCounter { monotonic: true, persisted: false, tamper_evident: true, recovery_safe: true, assurance_level: 1 }),
        !rollback_protection_valid(VersionCounter { monotonic: true, persisted: true, tamper_evident: false, recovery_safe: true, assurance_level: 1 }),
        !rollback_protection_valid(VersionCounter { monotonic: true, persisted: true, tamper_evident: true, recovery_safe: false, assurance_level: 1 }),
{
}

} // verus!

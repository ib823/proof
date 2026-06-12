// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of SecurityFoundation Hardware Root Of Trust invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// State model for Hardware Root Of Trust
pub struct RootOfTrust {
    pub fuse_locked: bool,
    pub key_derived: bool,
    pub attestation_fresh: bool,
    pub anti_rollback_enforced: bool,
    pub assurance_level: u64,
}

/// Invariant: all properties must hold with positive assurance
pub open spec fn hardware_root_of_trust_valid(s: RootOfTrust) -> bool {
    s.fuse_locked && s.key_derived && s.attestation_fresh && s.anti_rollback_enforced && s.assurance_level >= 1
}

/// Baseline configuration
pub open spec fn baseline_hardware_root_of_trust() -> RootOfTrust {
    RootOfTrust { fuse_locked: true, key_derived: true, attestation_fresh: true, anti_rollback_enforced: true, assurance_level: 1 }
}

/// Hardened configuration
pub open spec fn hardened_hardware_root_of_trust() -> RootOfTrust {
    RootOfTrust { fuse_locked: true, key_derived: true, attestation_fresh: true, anti_rollback_enforced: true, assurance_level: 3 }
}

/// Lemma: baseline is valid
proof fn lemma_baseline_valid()
    ensures hardware_root_of_trust_valid(baseline_hardware_root_of_trust()),
{
    let b = baseline_hardware_root_of_trust();
    assert(b.fuse_locked && b.key_derived && b.attestation_fresh && b.anti_rollback_enforced && b.assurance_level >= 1);
}

/// Lemma: hardened dominates baseline
proof fn lemma_hardened_dominates()
    ensures
        hardware_root_of_trust_valid(hardened_hardware_root_of_trust()),
        hardened_hardware_root_of_trust().assurance_level >= baseline_hardware_root_of_trust().assurance_level,
{
}

/// Lemma: each property is necessary
proof fn lemma_properties_necessary()
    ensures
        !hardware_root_of_trust_valid(RootOfTrust { fuse_locked: false, key_derived: true, attestation_fresh: true, anti_rollback_enforced: true, assurance_level: 1 }),
        !hardware_root_of_trust_valid(RootOfTrust { fuse_locked: true, key_derived: false, attestation_fresh: true, anti_rollback_enforced: true, assurance_level: 1 }),
        !hardware_root_of_trust_valid(RootOfTrust { fuse_locked: true, key_derived: true, attestation_fresh: false, anti_rollback_enforced: true, assurance_level: 1 }),
        !hardware_root_of_trust_valid(RootOfTrust { fuse_locked: true, key_derived: true, attestation_fresh: true, anti_rollback_enforced: false, assurance_level: 1 }),
{
}

} // verus!

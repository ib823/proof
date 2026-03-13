// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Verified Network domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Verified Network verification
pub struct NetworkOp {
    pub packet_authenticated: bool,
    pub sequence_monotonic: bool,
    pub congestion_controlled: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn verified_network_secure(s: NetworkOp) -> bool {
    s.packet_authenticated && s.sequence_monotonic && s.congestion_controlled && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_verified_network() -> NetworkOp {
    NetworkOp {
        packet_authenticated: true,
        sequence_monotonic: true,
        congestion_controlled: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_verified_network() -> NetworkOp {
    NetworkOp {
        packet_authenticated: true,
        sequence_monotonic: true,
        congestion_controlled: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures verified_network_secure(baseline_verified_network()),
{
    let b = baseline_verified_network();
    assert(b.packet_authenticated);
    assert(b.sequence_monotonic);
    assert(b.congestion_controlled);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures verified_network_secure(hardened_verified_network()),
{
    let h = hardened_verified_network();
    assert(h.packet_authenticated);
    assert(h.sequence_monotonic);
    assert(h.congestion_controlled);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        verified_network_secure(hardened_verified_network()),
        hardened_verified_network().assurance_level >= baseline_verified_network().assurance_level,
{
    let baseline = baseline_verified_network();
    let hardened = hardened_verified_network();
    assert(verified_network_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !verified_network_secure(NetworkOp { packet_authenticated: false, sequence_monotonic: true, congestion_controlled: true, assurance_level: 1 }),
        !verified_network_secure(NetworkOp { packet_authenticated: true, sequence_monotonic: false, congestion_controlled: true, assurance_level: 1 }),
        !verified_network_secure(NetworkOp { packet_authenticated: true, sequence_monotonic: true, congestion_controlled: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !verified_network_secure(NetworkOp { packet_authenticated: true, sequence_monotonic: true, congestion_controlled: true, assurance_level: 0 }),
{
}

} // verus!

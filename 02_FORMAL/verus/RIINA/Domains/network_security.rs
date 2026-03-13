// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Network Security domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Network Security verification
pub struct NetworkPacket {
    pub encrypted: bool,
    pub authenticated: bool,
    pub replay_protected: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn network_security_secure(s: NetworkPacket) -> bool {
    s.encrypted && s.authenticated && s.replay_protected && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_network_security() -> NetworkPacket {
    NetworkPacket {
        encrypted: true,
        authenticated: true,
        replay_protected: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_network_security() -> NetworkPacket {
    NetworkPacket {
        encrypted: true,
        authenticated: true,
        replay_protected: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures network_security_secure(baseline_network_security()),
{
    let b = baseline_network_security();
    assert(b.encrypted);
    assert(b.authenticated);
    assert(b.replay_protected);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures network_security_secure(hardened_network_security()),
{
    let h = hardened_network_security();
    assert(h.encrypted);
    assert(h.authenticated);
    assert(h.replay_protected);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        network_security_secure(hardened_network_security()),
        hardened_network_security().assurance_level >= baseline_network_security().assurance_level,
{
    let baseline = baseline_network_security();
    let hardened = hardened_network_security();
    assert(network_security_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !network_security_secure(NetworkPacket { encrypted: false, authenticated: true, replay_protected: true, assurance_level: 1 }),
        !network_security_secure(NetworkPacket { encrypted: true, authenticated: false, replay_protected: true, assurance_level: 1 }),
        !network_security_secure(NetworkPacket { encrypted: true, authenticated: true, replay_protected: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !network_security_secure(NetworkPacket { encrypted: true, authenticated: true, replay_protected: true, assurance_level: 0 }),
{
}

} // verus!

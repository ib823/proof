// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Verified Protocols domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Verified Protocols verification
pub struct ProtocolExchange {
    pub handshake_complete: bool,
    pub key_agreed: bool,
    pub forward_secrecy: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn verified_protocols_secure(s: ProtocolExchange) -> bool {
    s.handshake_complete && s.key_agreed && s.forward_secrecy && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_verified_protocols() -> ProtocolExchange {
    ProtocolExchange {
        handshake_complete: true,
        key_agreed: true,
        forward_secrecy: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_verified_protocols() -> ProtocolExchange {
    ProtocolExchange {
        handshake_complete: true,
        key_agreed: true,
        forward_secrecy: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures verified_protocols_secure(baseline_verified_protocols()),
{
    let b = baseline_verified_protocols();
    assert(b.handshake_complete);
    assert(b.key_agreed);
    assert(b.forward_secrecy);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures verified_protocols_secure(hardened_verified_protocols()),
{
    let h = hardened_verified_protocols();
    assert(h.handshake_complete);
    assert(h.key_agreed);
    assert(h.forward_secrecy);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        verified_protocols_secure(hardened_verified_protocols()),
        hardened_verified_protocols().assurance_level >= baseline_verified_protocols().assurance_level,
{
    let baseline = baseline_verified_protocols();
    let hardened = hardened_verified_protocols();
    assert(verified_protocols_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !verified_protocols_secure(ProtocolExchange { handshake_complete: false, key_agreed: true, forward_secrecy: true, assurance_level: 1 }),
        !verified_protocols_secure(ProtocolExchange { handshake_complete: true, key_agreed: false, forward_secrecy: true, assurance_level: 1 }),
        !verified_protocols_secure(ProtocolExchange { handshake_complete: true, key_agreed: true, forward_secrecy: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !verified_protocols_secure(ProtocolExchange { handshake_complete: true, key_agreed: true, forward_secrecy: true, assurance_level: 0 }),
{
}

} // verus!

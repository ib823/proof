// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Verified Network Stack domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Verified Network Stack verification
pub struct ProtocolLayer {
    pub encapsulation_correct: bool,
    pub checksum_valid: bool,
    pub flow_controlled: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn verified_network_stack_secure(s: ProtocolLayer) -> bool {
    s.encapsulation_correct && s.checksum_valid && s.flow_controlled && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_verified_network_stack() -> ProtocolLayer {
    ProtocolLayer {
        encapsulation_correct: true,
        checksum_valid: true,
        flow_controlled: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_verified_network_stack() -> ProtocolLayer {
    ProtocolLayer {
        encapsulation_correct: true,
        checksum_valid: true,
        flow_controlled: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures verified_network_stack_secure(baseline_verified_network_stack()),
{
    let b = baseline_verified_network_stack();
    assert(b.encapsulation_correct);
    assert(b.checksum_valid);
    assert(b.flow_controlled);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures verified_network_stack_secure(hardened_verified_network_stack()),
{
    let h = hardened_verified_network_stack();
    assert(h.encapsulation_correct);
    assert(h.checksum_valid);
    assert(h.flow_controlled);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        verified_network_stack_secure(hardened_verified_network_stack()),
        hardened_verified_network_stack().assurance_level >= baseline_verified_network_stack().assurance_level,
{
    let baseline = baseline_verified_network_stack();
    let hardened = hardened_verified_network_stack();
    assert(verified_network_stack_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !verified_network_stack_secure(ProtocolLayer { encapsulation_correct: false, checksum_valid: true, flow_controlled: true, assurance_level: 1 }),
        !verified_network_stack_secure(ProtocolLayer { encapsulation_correct: true, checksum_valid: false, flow_controlled: true, assurance_level: 1 }),
        !verified_network_stack_secure(ProtocolLayer { encapsulation_correct: true, checksum_valid: true, flow_controlled: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !verified_network_stack_secure(ProtocolLayer { encapsulation_correct: true, checksum_valid: true, flow_controlled: true, assurance_level: 0 }),
{
}

} // verus!

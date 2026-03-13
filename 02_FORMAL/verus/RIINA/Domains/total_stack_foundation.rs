// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Total Stack Foundation domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Total Stack Foundation verification
pub struct StackLayer {
    pub layer_verified: bool,
    pub interface_typed: bool,
    pub composition_sound: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn total_stack_foundation_secure(s: StackLayer) -> bool {
    s.layer_verified && s.interface_typed && s.composition_sound && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_total_stack_foundation() -> StackLayer {
    StackLayer {
        layer_verified: true,
        interface_typed: true,
        composition_sound: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_total_stack_foundation() -> StackLayer {
    StackLayer {
        layer_verified: true,
        interface_typed: true,
        composition_sound: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures total_stack_foundation_secure(baseline_total_stack_foundation()),
{
    let b = baseline_total_stack_foundation();
    assert(b.layer_verified);
    assert(b.interface_typed);
    assert(b.composition_sound);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures total_stack_foundation_secure(hardened_total_stack_foundation()),
{
    let h = hardened_total_stack_foundation();
    assert(h.layer_verified);
    assert(h.interface_typed);
    assert(h.composition_sound);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        total_stack_foundation_secure(hardened_total_stack_foundation()),
        hardened_total_stack_foundation().assurance_level >= baseline_total_stack_foundation().assurance_level,
{
    let baseline = baseline_total_stack_foundation();
    let hardened = hardened_total_stack_foundation();
    assert(total_stack_foundation_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !total_stack_foundation_secure(StackLayer { layer_verified: false, interface_typed: true, composition_sound: true, assurance_level: 1 }),
        !total_stack_foundation_secure(StackLayer { layer_verified: true, interface_typed: false, composition_sound: true, assurance_level: 1 }),
        !total_stack_foundation_secure(StackLayer { layer_verified: true, interface_typed: true, composition_sound: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !total_stack_foundation_secure(StackLayer { layer_verified: true, interface_typed: true, composition_sound: true, assurance_level: 0 }),
{
}

} // verus!

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of SecurityFoundation Interrupt Virtualization invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// State model for Interrupt Virtualization
pub struct VirtualInterrupt {
    pub priority_preserved: bool,
    pub delivery_guaranteed: bool,
    pub injection_safe: bool,
    pub masking_correct: bool,
    pub assurance_level: u64,
}

/// Invariant: all properties must hold with positive assurance
pub open spec fn interrupt_virtualization_valid(s: VirtualInterrupt) -> bool {
    s.priority_preserved && s.delivery_guaranteed && s.injection_safe && s.masking_correct && s.assurance_level >= 1
}

/// Baseline configuration
pub open spec fn baseline_interrupt_virtualization() -> VirtualInterrupt {
    VirtualInterrupt { priority_preserved: true, delivery_guaranteed: true, injection_safe: true, masking_correct: true, assurance_level: 1 }
}

/// Hardened configuration
pub open spec fn hardened_interrupt_virtualization() -> VirtualInterrupt {
    VirtualInterrupt { priority_preserved: true, delivery_guaranteed: true, injection_safe: true, masking_correct: true, assurance_level: 3 }
}

/// Lemma: baseline is valid
proof fn lemma_baseline_valid()
    ensures interrupt_virtualization_valid(baseline_interrupt_virtualization()),
{
    let b = baseline_interrupt_virtualization();
    assert(b.priority_preserved && b.delivery_guaranteed && b.injection_safe && b.masking_correct && b.assurance_level >= 1);
}

/// Lemma: hardened dominates baseline
proof fn lemma_hardened_dominates()
    ensures
        interrupt_virtualization_valid(hardened_interrupt_virtualization()),
        hardened_interrupt_virtualization().assurance_level >= baseline_interrupt_virtualization().assurance_level,
{
}

/// Lemma: each property is necessary
proof fn lemma_properties_necessary()
    ensures
        !interrupt_virtualization_valid(VirtualInterrupt { priority_preserved: false, delivery_guaranteed: true, injection_safe: true, masking_correct: true, assurance_level: 1 }),
        !interrupt_virtualization_valid(VirtualInterrupt { priority_preserved: true, delivery_guaranteed: false, injection_safe: true, masking_correct: true, assurance_level: 1 }),
        !interrupt_virtualization_valid(VirtualInterrupt { priority_preserved: true, delivery_guaranteed: true, injection_safe: false, masking_correct: true, assurance_level: 1 }),
        !interrupt_virtualization_valid(VirtualInterrupt { priority_preserved: true, delivery_guaranteed: true, injection_safe: true, masking_correct: false, assurance_level: 1 }),
{
}

} // verus!

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Hypervisor Security domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Hypervisor Security verification
pub struct VMGuest {
    pub memory_isolated: bool,
    pub interrupt_virtualized: bool,
    pub io_mediated: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn hypervisor_security_secure(s: VMGuest) -> bool {
    s.memory_isolated && s.interrupt_virtualized && s.io_mediated && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_hypervisor_security() -> VMGuest {
    VMGuest {
        memory_isolated: true,
        interrupt_virtualized: true,
        io_mediated: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_hypervisor_security() -> VMGuest {
    VMGuest {
        memory_isolated: true,
        interrupt_virtualized: true,
        io_mediated: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures hypervisor_security_secure(baseline_hypervisor_security()),
{
    let b = baseline_hypervisor_security();
    assert(b.memory_isolated);
    assert(b.interrupt_virtualized);
    assert(b.io_mediated);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures hypervisor_security_secure(hardened_hypervisor_security()),
{
    let h = hardened_hypervisor_security();
    assert(h.memory_isolated);
    assert(h.interrupt_virtualized);
    assert(h.io_mediated);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        hypervisor_security_secure(hardened_hypervisor_security()),
        hardened_hypervisor_security().assurance_level >= baseline_hypervisor_security().assurance_level,
{
    let baseline = baseline_hypervisor_security();
    let hardened = hardened_hypervisor_security();
    assert(hypervisor_security_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !hypervisor_security_secure(VMGuest { memory_isolated: false, interrupt_virtualized: true, io_mediated: true, assurance_level: 1 }),
        !hypervisor_security_secure(VMGuest { memory_isolated: true, interrupt_virtualized: false, io_mediated: true, assurance_level: 1 }),
        !hypervisor_security_secure(VMGuest { memory_isolated: true, interrupt_virtualized: true, io_mediated: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !hypervisor_security_secure(VMGuest { memory_isolated: true, interrupt_virtualized: true, io_mediated: true, assurance_level: 0 }),
{
}

} // verus!

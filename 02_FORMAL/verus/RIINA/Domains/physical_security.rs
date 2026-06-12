// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Physical Security domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Physical Security verification
pub struct PhysicalDevice {
    pub tamper_resistant: bool,
    pub environmental_monitored: bool,
    pub access_logged: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn physical_security_secure(s: PhysicalDevice) -> bool {
    s.tamper_resistant && s.environmental_monitored && s.access_logged && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_physical_security() -> PhysicalDevice {
    PhysicalDevice {
        tamper_resistant: true,
        environmental_monitored: true,
        access_logged: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_physical_security() -> PhysicalDevice {
    PhysicalDevice {
        tamper_resistant: true,
        environmental_monitored: true,
        access_logged: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures physical_security_secure(baseline_physical_security()),
{
    let b = baseline_physical_security();
    assert(b.tamper_resistant);
    assert(b.environmental_monitored);
    assert(b.access_logged);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures physical_security_secure(hardened_physical_security()),
{
    let h = hardened_physical_security();
    assert(h.tamper_resistant);
    assert(h.environmental_monitored);
    assert(h.access_logged);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        physical_security_secure(hardened_physical_security()),
        hardened_physical_security().assurance_level >= baseline_physical_security().assurance_level,
{
    let baseline = baseline_physical_security();
    let hardened = hardened_physical_security();
    assert(physical_security_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !physical_security_secure(PhysicalDevice { tamper_resistant: false, environmental_monitored: true, access_logged: true, assurance_level: 1 }),
        !physical_security_secure(PhysicalDevice { tamper_resistant: true, environmental_monitored: false, access_logged: true, assurance_level: 1 }),
        !physical_security_secure(PhysicalDevice { tamper_resistant: true, environmental_monitored: true, access_logged: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !physical_security_secure(PhysicalDevice { tamper_resistant: true, environmental_monitored: true, access_logged: true, assurance_level: 0 }),
{
}

} // verus!

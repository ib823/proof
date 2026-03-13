// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of S001  Hardware Contracts domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for S001  Hardware Contracts verification
pub struct HWContract {
    pub timing_specified: bool,
    pub power_bounded: bool,
    pub interface_stable: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn s001__hardware_contracts_secure(s: HWContract) -> bool {
    s.timing_specified && s.power_bounded && s.interface_stable && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_s001__hardware_contracts() -> HWContract {
    HWContract {
        timing_specified: true,
        power_bounded: true,
        interface_stable: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_s001__hardware_contracts() -> HWContract {
    HWContract {
        timing_specified: true,
        power_bounded: true,
        interface_stable: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures s001__hardware_contracts_secure(baseline_s001__hardware_contracts()),
{
    let b = baseline_s001__hardware_contracts();
    assert(b.timing_specified);
    assert(b.power_bounded);
    assert(b.interface_stable);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures s001__hardware_contracts_secure(hardened_s001__hardware_contracts()),
{
    let h = hardened_s001__hardware_contracts();
    assert(h.timing_specified);
    assert(h.power_bounded);
    assert(h.interface_stable);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        s001__hardware_contracts_secure(hardened_s001__hardware_contracts()),
        hardened_s001__hardware_contracts().assurance_level >= baseline_s001__hardware_contracts().assurance_level,
{
    let baseline = baseline_s001__hardware_contracts();
    let hardened = hardened_s001__hardware_contracts();
    assert(s001__hardware_contracts_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !s001__hardware_contracts_secure(HWContract { timing_specified: false, power_bounded: true, interface_stable: true, assurance_level: 1 }),
        !s001__hardware_contracts_secure(HWContract { timing_specified: true, power_bounded: false, interface_stable: true, assurance_level: 1 }),
        !s001__hardware_contracts_secure(HWContract { timing_specified: true, power_bounded: true, interface_stable: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !s001__hardware_contracts_secure(HWContract { timing_specified: true, power_bounded: true, interface_stable: true, assurance_level: 0 }),
{
}

} // verus!

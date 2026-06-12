// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Omega001  Network Defense domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Omega001  Network Defense verification
pub struct NetworkDefense {
    pub perimeter_monitored: bool,
    pub ids_active: bool,
    pub response_automated: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn omega001__network_defense_secure(s: NetworkDefense) -> bool {
    s.perimeter_monitored && s.ids_active && s.response_automated && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_omega001__network_defense() -> NetworkDefense {
    NetworkDefense {
        perimeter_monitored: true,
        ids_active: true,
        response_automated: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_omega001__network_defense() -> NetworkDefense {
    NetworkDefense {
        perimeter_monitored: true,
        ids_active: true,
        response_automated: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures omega001__network_defense_secure(baseline_omega001__network_defense()),
{
    let b = baseline_omega001__network_defense();
    assert(b.perimeter_monitored);
    assert(b.ids_active);
    assert(b.response_automated);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures omega001__network_defense_secure(hardened_omega001__network_defense()),
{
    let h = hardened_omega001__network_defense();
    assert(h.perimeter_monitored);
    assert(h.ids_active);
    assert(h.response_automated);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        omega001__network_defense_secure(hardened_omega001__network_defense()),
        hardened_omega001__network_defense().assurance_level >= baseline_omega001__network_defense().assurance_level,
{
    let baseline = baseline_omega001__network_defense();
    let hardened = hardened_omega001__network_defense();
    assert(omega001__network_defense_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !omega001__network_defense_secure(NetworkDefense { perimeter_monitored: false, ids_active: true, response_automated: true, assurance_level: 1 }),
        !omega001__network_defense_secure(NetworkDefense { perimeter_monitored: true, ids_active: false, response_automated: true, assurance_level: 1 }),
        !omega001__network_defense_secure(NetworkDefense { perimeter_monitored: true, ids_active: true, response_automated: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !omega001__network_defense_secure(NetworkDefense { perimeter_monitored: true, ids_active: true, response_automated: true, assurance_level: 0 }),
{
}

} // verus!

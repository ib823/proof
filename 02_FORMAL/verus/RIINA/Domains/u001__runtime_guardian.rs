// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of U001  Runtime Guardian domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for U001  Runtime Guardian verification
pub struct RuntimeGuard {
    pub invariant_checked: bool,
    pub violation_caught: bool,
    pub recovery_safe: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn u001__runtime_guardian_secure(s: RuntimeGuard) -> bool {
    s.invariant_checked && s.violation_caught && s.recovery_safe && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_u001__runtime_guardian() -> RuntimeGuard {
    RuntimeGuard {
        invariant_checked: true,
        violation_caught: true,
        recovery_safe: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_u001__runtime_guardian() -> RuntimeGuard {
    RuntimeGuard {
        invariant_checked: true,
        violation_caught: true,
        recovery_safe: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures u001__runtime_guardian_secure(baseline_u001__runtime_guardian()),
{
    let b = baseline_u001__runtime_guardian();
    assert(b.invariant_checked);
    assert(b.violation_caught);
    assert(b.recovery_safe);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures u001__runtime_guardian_secure(hardened_u001__runtime_guardian()),
{
    let h = hardened_u001__runtime_guardian();
    assert(h.invariant_checked);
    assert(h.violation_caught);
    assert(h.recovery_safe);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        u001__runtime_guardian_secure(hardened_u001__runtime_guardian()),
        hardened_u001__runtime_guardian().assurance_level >= baseline_u001__runtime_guardian().assurance_level,
{
    let baseline = baseline_u001__runtime_guardian();
    let hardened = hardened_u001__runtime_guardian();
    assert(u001__runtime_guardian_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !u001__runtime_guardian_secure(RuntimeGuard { invariant_checked: false, violation_caught: true, recovery_safe: true, assurance_level: 1 }),
        !u001__runtime_guardian_secure(RuntimeGuard { invariant_checked: true, violation_caught: false, recovery_safe: true, assurance_level: 1 }),
        !u001__runtime_guardian_secure(RuntimeGuard { invariant_checked: true, violation_caught: true, recovery_safe: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !u001__runtime_guardian_secure(RuntimeGuard { invariant_checked: true, violation_caught: true, recovery_safe: true, assurance_level: 0 }),
{
}

} // verus!

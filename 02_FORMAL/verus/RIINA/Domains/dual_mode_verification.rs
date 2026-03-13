// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Dual Mode Verification domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Dual Mode Verification verification
pub struct VerifyMode {
    pub fast_mode_sound: bool,
    pub full_mode_complete: bool,
    pub mode_switch_safe: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn dual_mode_verification_secure(s: VerifyMode) -> bool {
    s.fast_mode_sound && s.full_mode_complete && s.mode_switch_safe && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_dual_mode_verification() -> VerifyMode {
    VerifyMode {
        fast_mode_sound: true,
        full_mode_complete: true,
        mode_switch_safe: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_dual_mode_verification() -> VerifyMode {
    VerifyMode {
        fast_mode_sound: true,
        full_mode_complete: true,
        mode_switch_safe: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures dual_mode_verification_secure(baseline_dual_mode_verification()),
{
    let b = baseline_dual_mode_verification();
    assert(b.fast_mode_sound);
    assert(b.full_mode_complete);
    assert(b.mode_switch_safe);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures dual_mode_verification_secure(hardened_dual_mode_verification()),
{
    let h = hardened_dual_mode_verification();
    assert(h.fast_mode_sound);
    assert(h.full_mode_complete);
    assert(h.mode_switch_safe);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        dual_mode_verification_secure(hardened_dual_mode_verification()),
        hardened_dual_mode_verification().assurance_level >= baseline_dual_mode_verification().assurance_level,
{
    let baseline = baseline_dual_mode_verification();
    let hardened = hardened_dual_mode_verification();
    assert(dual_mode_verification_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !dual_mode_verification_secure(VerifyMode { fast_mode_sound: false, full_mode_complete: true, mode_switch_safe: true, assurance_level: 1 }),
        !dual_mode_verification_secure(VerifyMode { fast_mode_sound: true, full_mode_complete: false, mode_switch_safe: true, assurance_level: 1 }),
        !dual_mode_verification_secure(VerifyMode { fast_mode_sound: true, full_mode_complete: true, mode_switch_safe: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !dual_mode_verification_secure(VerifyMode { fast_mode_sound: true, full_mode_complete: true, mode_switch_safe: true, assurance_level: 0 }),
{
}

} // verus!

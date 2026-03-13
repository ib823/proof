// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Hardware Security domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Hardware Security verification
pub struct HardwareModule {
    pub tamper_evident: bool,
    pub side_channel_resistant: bool,
    pub fuse_locked: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn hardware_security_secure(s: HardwareModule) -> bool {
    s.tamper_evident && s.side_channel_resistant && s.fuse_locked && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_hardware_security() -> HardwareModule {
    HardwareModule {
        tamper_evident: true,
        side_channel_resistant: true,
        fuse_locked: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_hardware_security() -> HardwareModule {
    HardwareModule {
        tamper_evident: true,
        side_channel_resistant: true,
        fuse_locked: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures hardware_security_secure(baseline_hardware_security()),
{
    let b = baseline_hardware_security();
    assert(b.tamper_evident);
    assert(b.side_channel_resistant);
    assert(b.fuse_locked);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures hardware_security_secure(hardened_hardware_security()),
{
    let h = hardened_hardware_security();
    assert(h.tamper_evident);
    assert(h.side_channel_resistant);
    assert(h.fuse_locked);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        hardware_security_secure(hardened_hardware_security()),
        hardened_hardware_security().assurance_level >= baseline_hardware_security().assurance_level,
{
    let baseline = baseline_hardware_security();
    let hardened = hardened_hardware_security();
    assert(hardware_security_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !hardware_security_secure(HardwareModule { tamper_evident: false, side_channel_resistant: true, fuse_locked: true, assurance_level: 1 }),
        !hardware_security_secure(HardwareModule { tamper_evident: true, side_channel_resistant: false, fuse_locked: true, assurance_level: 1 }),
        !hardware_security_secure(HardwareModule { tamper_evident: true, side_channel_resistant: true, fuse_locked: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !hardware_security_secure(HardwareModule { tamper_evident: true, side_channel_resistant: true, fuse_locked: true, assurance_level: 0 }),
{
}

} // verus!

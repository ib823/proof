// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Tooling Ide domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Tooling Ide verification
pub struct IDEAction {
    pub refactoring_sound: bool,
    pub completion_type_safe: bool,
    pub diagnostic_accurate: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn tooling_ide_secure(s: IDEAction) -> bool {
    s.refactoring_sound && s.completion_type_safe && s.diagnostic_accurate && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_tooling_ide() -> IDEAction {
    IDEAction {
        refactoring_sound: true,
        completion_type_safe: true,
        diagnostic_accurate: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_tooling_ide() -> IDEAction {
    IDEAction {
        refactoring_sound: true,
        completion_type_safe: true,
        diagnostic_accurate: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures tooling_ide_secure(baseline_tooling_ide()),
{
    let b = baseline_tooling_ide();
    assert(b.refactoring_sound);
    assert(b.completion_type_safe);
    assert(b.diagnostic_accurate);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures tooling_ide_secure(hardened_tooling_ide()),
{
    let h = hardened_tooling_ide();
    assert(h.refactoring_sound);
    assert(h.completion_type_safe);
    assert(h.diagnostic_accurate);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        tooling_ide_secure(hardened_tooling_ide()),
        hardened_tooling_ide().assurance_level >= baseline_tooling_ide().assurance_level,
{
    let baseline = baseline_tooling_ide();
    let hardened = hardened_tooling_ide();
    assert(tooling_ide_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !tooling_ide_secure(IDEAction { refactoring_sound: false, completion_type_safe: true, diagnostic_accurate: true, assurance_level: 1 }),
        !tooling_ide_secure(IDEAction { refactoring_sound: true, completion_type_safe: false, diagnostic_accurate: true, assurance_level: 1 }),
        !tooling_ide_secure(IDEAction { refactoring_sound: true, completion_type_safe: true, diagnostic_accurate: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !tooling_ide_secure(IDEAction { refactoring_sound: true, completion_type_safe: true, diagnostic_accurate: true, assurance_level: 0 }),
{
}

} // verus!

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Module Systems domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Module Systems verification
pub struct Module {
    pub signature_matches: bool,
    pub abstraction_preserved: bool,
    pub linking_sound: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn module_systems_secure(s: Module) -> bool {
    s.signature_matches && s.abstraction_preserved && s.linking_sound && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_module_systems() -> Module {
    Module {
        signature_matches: true,
        abstraction_preserved: true,
        linking_sound: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_module_systems() -> Module {
    Module {
        signature_matches: true,
        abstraction_preserved: true,
        linking_sound: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures module_systems_secure(baseline_module_systems()),
{
    let b = baseline_module_systems();
    assert(b.signature_matches);
    assert(b.abstraction_preserved);
    assert(b.linking_sound);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures module_systems_secure(hardened_module_systems()),
{
    let h = hardened_module_systems();
    assert(h.signature_matches);
    assert(h.abstraction_preserved);
    assert(h.linking_sound);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        module_systems_secure(hardened_module_systems()),
        hardened_module_systems().assurance_level >= baseline_module_systems().assurance_level,
{
    let baseline = baseline_module_systems();
    let hardened = hardened_module_systems();
    assert(module_systems_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !module_systems_secure(Module { signature_matches: false, abstraction_preserved: true, linking_sound: true, assurance_level: 1 }),
        !module_systems_secure(Module { signature_matches: true, abstraction_preserved: false, linking_sound: true, assurance_level: 1 }),
        !module_systems_secure(Module { signature_matches: true, abstraction_preserved: true, linking_sound: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !module_systems_secure(Module { signature_matches: true, abstraction_preserved: true, linking_sound: true, assurance_level: 0 }),
{
}

} // verus!

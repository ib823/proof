// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of T001  Hermetic Build domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for T001  Hermetic Build verification
pub struct BuildArtifact {
    pub inputs_pinned: bool,
    pub reproducible: bool,
    pub provenance_recorded: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn t001__hermetic_build_secure(s: BuildArtifact) -> bool {
    s.inputs_pinned && s.reproducible && s.provenance_recorded && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_t001__hermetic_build() -> BuildArtifact {
    BuildArtifact {
        inputs_pinned: true,
        reproducible: true,
        provenance_recorded: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_t001__hermetic_build() -> BuildArtifact {
    BuildArtifact {
        inputs_pinned: true,
        reproducible: true,
        provenance_recorded: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures t001__hermetic_build_secure(baseline_t001__hermetic_build()),
{
    let b = baseline_t001__hermetic_build();
    assert(b.inputs_pinned);
    assert(b.reproducible);
    assert(b.provenance_recorded);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures t001__hermetic_build_secure(hardened_t001__hermetic_build()),
{
    let h = hardened_t001__hermetic_build();
    assert(h.inputs_pinned);
    assert(h.reproducible);
    assert(h.provenance_recorded);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        t001__hermetic_build_secure(hardened_t001__hermetic_build()),
        hardened_t001__hermetic_build().assurance_level >= baseline_t001__hermetic_build().assurance_level,
{
    let baseline = baseline_t001__hermetic_build();
    let hardened = hardened_t001__hermetic_build();
    assert(t001__hermetic_build_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !t001__hermetic_build_secure(BuildArtifact { inputs_pinned: false, reproducible: true, provenance_recorded: true, assurance_level: 1 }),
        !t001__hermetic_build_secure(BuildArtifact { inputs_pinned: true, reproducible: false, provenance_recorded: true, assurance_level: 1 }),
        !t001__hermetic_build_secure(BuildArtifact { inputs_pinned: true, reproducible: true, provenance_recorded: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !t001__hermetic_build_secure(BuildArtifact { inputs_pinned: true, reproducible: true, provenance_recorded: true, assurance_level: 0 }),
{
}

} // verus!

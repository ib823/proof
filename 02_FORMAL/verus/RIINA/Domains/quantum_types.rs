// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Quantum Types domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Quantum Types verification
pub struct QuantumState {
    pub no_cloning: bool,
    pub measurement_destructive: bool,
    pub entanglement_tracked: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn quantum_types_secure(s: QuantumState) -> bool {
    s.no_cloning && s.measurement_destructive && s.entanglement_tracked && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_quantum_types() -> QuantumState {
    QuantumState {
        no_cloning: true,
        measurement_destructive: true,
        entanglement_tracked: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_quantum_types() -> QuantumState {
    QuantumState {
        no_cloning: true,
        measurement_destructive: true,
        entanglement_tracked: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures quantum_types_secure(baseline_quantum_types()),
{
    let b = baseline_quantum_types();
    assert(b.no_cloning);
    assert(b.measurement_destructive);
    assert(b.entanglement_tracked);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures quantum_types_secure(hardened_quantum_types()),
{
    let h = hardened_quantum_types();
    assert(h.no_cloning);
    assert(h.measurement_destructive);
    assert(h.entanglement_tracked);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        quantum_types_secure(hardened_quantum_types()),
        hardened_quantum_types().assurance_level >= baseline_quantum_types().assurance_level,
{
    let baseline = baseline_quantum_types();
    let hardened = hardened_quantum_types();
    assert(quantum_types_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !quantum_types_secure(QuantumState { no_cloning: false, measurement_destructive: true, entanglement_tracked: true, assurance_level: 1 }),
        !quantum_types_secure(QuantumState { no_cloning: true, measurement_destructive: false, entanglement_tracked: true, assurance_level: 1 }),
        !quantum_types_secure(QuantumState { no_cloning: true, measurement_destructive: true, entanglement_tracked: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !quantum_types_secure(QuantumState { no_cloning: true, measurement_destructive: true, entanglement_tracked: true, assurance_level: 0 }),
{
}

} // verus!

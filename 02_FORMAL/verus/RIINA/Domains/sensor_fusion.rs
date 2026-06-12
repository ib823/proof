// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Sensor Fusion domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Sensor Fusion verification
pub struct SensorArray {
    pub redundant_sources: bool,
    pub outlier_rejected: bool,
    pub consensus_reached: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn sensor_fusion_secure(s: SensorArray) -> bool {
    s.redundant_sources && s.outlier_rejected && s.consensus_reached && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_sensor_fusion() -> SensorArray {
    SensorArray {
        redundant_sources: true,
        outlier_rejected: true,
        consensus_reached: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_sensor_fusion() -> SensorArray {
    SensorArray {
        redundant_sources: true,
        outlier_rejected: true,
        consensus_reached: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures sensor_fusion_secure(baseline_sensor_fusion()),
{
    let b = baseline_sensor_fusion();
    assert(b.redundant_sources);
    assert(b.outlier_rejected);
    assert(b.consensus_reached);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures sensor_fusion_secure(hardened_sensor_fusion()),
{
    let h = hardened_sensor_fusion();
    assert(h.redundant_sources);
    assert(h.outlier_rejected);
    assert(h.consensus_reached);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        sensor_fusion_secure(hardened_sensor_fusion()),
        hardened_sensor_fusion().assurance_level >= baseline_sensor_fusion().assurance_level,
{
    let baseline = baseline_sensor_fusion();
    let hardened = hardened_sensor_fusion();
    assert(sensor_fusion_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !sensor_fusion_secure(SensorArray { redundant_sources: false, outlier_rejected: true, consensus_reached: true, assurance_level: 1 }),
        !sensor_fusion_secure(SensorArray { redundant_sources: true, outlier_rejected: false, consensus_reached: true, assurance_level: 1 }),
        !sensor_fusion_secure(SensorArray { redundant_sources: true, outlier_rejected: true, consensus_reached: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !sensor_fusion_secure(SensorArray { redundant_sources: true, outlier_rejected: true, consensus_reached: true, assurance_level: 0 }),
{
}

} // verus!

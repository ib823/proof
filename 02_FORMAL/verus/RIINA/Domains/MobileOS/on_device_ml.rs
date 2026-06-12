// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of MobileOS On Device Ml invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// State model for On Device Ml
pub struct MLInference {
    pub model_quantized: bool,
    pub input_shape_valid: bool,
    pub latency_bounded: bool,
    pub battery_impact_limited: bool,
    pub assurance_level: u64,
}

/// Invariant: all properties must hold with positive assurance
pub open spec fn on_device_ml_valid(s: MLInference) -> bool {
    s.model_quantized && s.input_shape_valid && s.latency_bounded && s.battery_impact_limited && s.assurance_level >= 1
}

/// Baseline configuration
pub open spec fn baseline_on_device_ml() -> MLInference {
    MLInference { model_quantized: true, input_shape_valid: true, latency_bounded: true, battery_impact_limited: true, assurance_level: 1 }
}

/// Hardened configuration
pub open spec fn hardened_on_device_ml() -> MLInference {
    MLInference { model_quantized: true, input_shape_valid: true, latency_bounded: true, battery_impact_limited: true, assurance_level: 3 }
}

/// Lemma: baseline is valid
proof fn lemma_baseline_valid()
    ensures on_device_ml_valid(baseline_on_device_ml()),
{
    let b = baseline_on_device_ml();
    assert(b.model_quantized && b.input_shape_valid && b.latency_bounded && b.battery_impact_limited && b.assurance_level >= 1);
}

/// Lemma: hardened is valid and dominates baseline
proof fn lemma_hardened_dominates()
    ensures
        on_device_ml_valid(hardened_on_device_ml()),
        hardened_on_device_ml().assurance_level >= baseline_on_device_ml().assurance_level,
{
}

/// Lemma: each property is individually necessary
proof fn lemma_properties_necessary()
    ensures
        !on_device_ml_valid(MLInference { model_quantized: false, input_shape_valid: true, latency_bounded: true, battery_impact_limited: true, assurance_level: 1 }),
        !on_device_ml_valid(MLInference { model_quantized: true, input_shape_valid: false, latency_bounded: true, battery_impact_limited: true, assurance_level: 1 }),
        !on_device_ml_valid(MLInference { model_quantized: true, input_shape_valid: true, latency_bounded: false, battery_impact_limited: true, assurance_level: 1 }),
        !on_device_ml_valid(MLInference { model_quantized: true, input_shape_valid: true, latency_bounded: true, battery_impact_limited: false, assurance_level: 1 }),
{
}

} // verus!

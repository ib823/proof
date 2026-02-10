// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! RIINA Effect System Runtime
#![forbid(unsafe_code)]
/// Capability primitives for effect-gated execution.
pub mod capability;
/// Runtime enforcement of declared effect policies.
pub mod effect_gate;
/// Proof-carrying metadata structures for effect validation.
pub mod proof_bundle;

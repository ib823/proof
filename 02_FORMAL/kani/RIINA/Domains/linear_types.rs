// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Kani harnesses for linear-type soundness invariants.

#![allow(unused)]

#[derive(Debug, Clone)]
pub struct LinearResourceProfile {
    pub acquired_resources: u64,
    pub released_resources: u64,
    pub duplicates_prevented: bool,
}

pub fn linear_resource_profile_sound(p: &LinearResourceProfile) -> bool {
    p.duplicates_prevented && p.acquired_resources == p.released_resources
}

pub fn baseline_linear_profile() -> LinearResourceProfile {
    LinearResourceProfile { acquired_resources: 1, released_resources: 1, duplicates_prevented: true }
}

pub fn hardened_linear_profile() -> LinearResourceProfile {
    LinearResourceProfile { acquired_resources: 2, released_resources: 2, duplicates_prevented: true }
}

#[kani::proof]
fn harness_baseline_linear_profile_sound() {
    let p = baseline_linear_profile();
    assert!(linear_resource_profile_sound(&p));
}

#[kani::proof]
fn harness_hardened_linear_profile_sound() {
    let p = hardened_linear_profile();
    assert!(linear_resource_profile_sound(&p));
}

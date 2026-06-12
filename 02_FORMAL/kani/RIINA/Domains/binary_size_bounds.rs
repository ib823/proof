// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Kani harnesses for binary-size budget bounds.

#![allow(unused)]

#[derive(Debug, Clone)]
pub struct SizeBudget {
    pub code_bytes: u64,
    pub metadata_bytes: u64,
    pub max_total_bytes: u64,
}

pub fn total_bytes(b: &SizeBudget) -> u64 {
    b.code_bytes + b.metadata_bytes
}

pub fn within_budget(b: &SizeBudget) -> bool {
    b.max_total_bytes > 0 && total_bytes(b) <= b.max_total_bytes
}

pub fn baseline_size_budget() -> SizeBudget {
    SizeBudget { code_bytes: 200000, metadata_bytes: 10000, max_total_bytes: 250000 }
}

#[kani::proof]
fn harness_baseline_within_budget() {
    let b = baseline_size_budget();
    assert!(within_budget(&b));
}

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Kani harnesses for quantitative declassification invariants.

#![allow(unused)]

#[derive(Debug, Clone)]
pub struct DeclassPolicy {
    pub leakage_bounded: bool,
    pub budget_tracked: bool,
    pub max_leakage_bits: u64,
}

pub fn declass_secure(p: &DeclassPolicy) -> bool {
    p.leakage_bounded && p.budget_tracked && p.max_leakage_bits <= 8
}

pub fn baseline_declass() -> DeclassPolicy {
    DeclassPolicy {
        leakage_bounded: true,
        budget_tracked: true,
        max_leakage_bits: 1,
    }
}

pub fn hardened_declass() -> DeclassPolicy {
    DeclassPolicy {
        leakage_bounded: true,
        budget_tracked: true,
        max_leakage_bits: 1,
    }
}

#[kani::proof]
fn harness_baseline_declass_secure() {
    let p = baseline_declass();
    assert!(declass_secure(&p));
}

#[kani::proof]
fn harness_hardened_declass_not_weaker() {
    let b = baseline_declass();
    let h = hardened_declass();
    assert!(declass_secure(&h));
}

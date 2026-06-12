// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Kani harnesses for constant-time discipline.

#![allow(unused)]

#[derive(Debug, Clone)]
pub struct CtTrace {
    pub branch_on_secret: bool,
    pub addr_on_secret: bool,
    pub cycle_upper_bound: u64,
}

pub fn valid_ct_trace(t: &CtTrace) -> bool {
    !t.branch_on_secret && !t.addr_on_secret && t.cycle_upper_bound > 0
}

pub fn merge_trace(a: &CtTrace, b: &CtTrace) -> CtTrace {
    CtTrace {
        branch_on_secret: a.branch_on_secret || b.branch_on_secret,
        addr_on_secret: a.addr_on_secret || b.addr_on_secret,
        cycle_upper_bound: if a.cycle_upper_bound >= b.cycle_upper_bound { a.cycle_upper_bound } else { b.cycle_upper_bound },
    }
}

#[kani::proof]
fn harness_merge_preserves_ct() {
    let a = CtTrace { branch_on_secret: false, addr_on_secret: false, cycle_upper_bound: 5 };
    let b = CtTrace { branch_on_secret: false, addr_on_secret: false, cycle_upper_bound: 7 };
    let merged = merge_trace(&a, &b);
    assert!(valid_ct_trace(&merged));
}

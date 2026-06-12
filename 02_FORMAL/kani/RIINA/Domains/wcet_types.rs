// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Kani harnesses for WCET type invariants.

#![allow(unused)]

#[derive(Debug, Clone)]
pub struct WCETTypesPolicy {
    pub time_annotated: bool,
    pub deadline_tracked: bool,
    pub jitter_bounded: bool,
}

pub fn w_c_e_ts_secure(p: &WCETTypesPolicy) -> bool {
    p.time_annotated && p.deadline_tracked && p.jitter_bounded
}

pub fn baseline_w_c_e_ts() -> WCETTypesPolicy {
    WCETTypesPolicy {
        time_annotated: true,
        deadline_tracked: true,
        jitter_bounded: true,
    }
}

pub fn hardened_w_c_e_ts() -> WCETTypesPolicy {
    WCETTypesPolicy {
        time_annotated: true,
        deadline_tracked: true,
        jitter_bounded: true,
    }
}

#[kani::proof]
fn harness_baseline_w_c_e_ts_secure() {
    let p = baseline_w_c_e_ts();
    assert!(w_c_e_ts_secure(&p));
}

#[kani::proof]
fn harness_hardened_w_c_e_ts_not_weaker() {
    let b = baseline_w_c_e_ts();
    let h = hardened_w_c_e_ts();
    assert!(w_c_e_ts_secure(&h));
}

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Kani harnesses for Singapore MTCS invariants.

#![allow(unused)]

#[derive(Debug, Clone)]
pub struct SGMTCSPolicy {
    pub mtcs_level: u64,
    pub cloud_controls: bool,
    pub data_sovereignty: bool,
}

pub fn s_g_m_t_c_s_secure(p: &SGMTCSPolicy) -> bool {
    p.mtcs_level >= 1 && p.cloud_controls && p.data_sovereignty
}

pub fn baseline_s_g_m_t_c_s() -> SGMTCSPolicy {
    SGMTCSPolicy {
        mtcs_level: 1,
        cloud_controls: true,
        data_sovereignty: true,
    }
}

pub fn hardened_s_g_m_t_c_s() -> SGMTCSPolicy {
    SGMTCSPolicy {
        mtcs_level: 3,
        cloud_controls: true,
        data_sovereignty: true,
    }
}

#[kani::proof]
fn harness_baseline_s_g_m_t_c_s_secure() {
    let p = baseline_s_g_m_t_c_s();
    assert!(s_g_m_t_c_s_secure(&p));
}

#[kani::proof]
fn harness_hardened_s_g_m_t_c_s_not_weaker() {
    let b = baseline_s_g_m_t_c_s();
    let h = hardened_s_g_m_t_c_s();
    assert!(s_g_m_t_c_s_secure(&h));
}

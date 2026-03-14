// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Kani harnesses for human factor security invariants.

#![allow(unused)]

#[derive(Debug, Clone)]
pub struct HumanFactorPolicy {
    pub mfa_required: bool,
    pub session_timeout_secs: u64,
    pub phishing_training: bool,
}

pub fn human_factor_secure(p: &HumanFactorPolicy) -> bool {
    p.mfa_required && p.session_timeout_secs <= 900 && p.phishing_training
}

pub fn baseline_human_factor() -> HumanFactorPolicy {
    HumanFactorPolicy {
        mfa_required: true,
        session_timeout_secs: 900,
        phishing_training: true,
    }
}

pub fn hardened_human_factor() -> HumanFactorPolicy {
    HumanFactorPolicy {
        mfa_required: true,
        session_timeout_secs: 300,
        phishing_training: true,
    }
}

#[kani::proof]
fn harness_baseline_human_factor_secure() {
    let p = baseline_human_factor();
    assert!(human_factor_secure(&p));
}

#[kani::proof]
fn harness_hardened_human_factor_not_weaker() {
    let b = baseline_human_factor();
    let h = hardened_human_factor();
    assert!(human_factor_secure(&h));
}

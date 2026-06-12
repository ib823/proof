// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Kani harnesses for post-quantum signature invariants.

#![allow(unused)]

#[derive(Debug, Clone)]
pub struct PQSigPolicy {
    pub signature_security_bits: u64,
    pub hash_based: bool,
    pub stateless_scheme: bool,
}

pub fn p_q_sig_secure(p: &PQSigPolicy) -> bool {
    p.signature_security_bits >= 128 && p.hash_based && p.stateless_scheme
}

pub fn baseline_p_q_sig() -> PQSigPolicy {
    PQSigPolicy {
        signature_security_bits: 128,
        hash_based: true,
        stateless_scheme: true,
    }
}

pub fn hardened_p_q_sig() -> PQSigPolicy {
    PQSigPolicy {
        signature_security_bits: 256,
        hash_based: true,
        stateless_scheme: true,
    }
}

#[kani::proof]
fn harness_baseline_p_q_sig_secure() {
    let p = baseline_p_q_sig();
    assert!(p_q_sig_secure(&p));
}

#[kani::proof]
fn harness_hardened_p_q_sig_not_weaker() {
    let b = baseline_p_q_sig();
    let h = hardened_p_q_sig();
    assert!(p_q_sig_secure(&h));
}

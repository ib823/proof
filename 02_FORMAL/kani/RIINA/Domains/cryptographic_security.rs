// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Manually curated Kani harnesses for cryptographic policy floors.

#![allow(unused)]

#[derive(Debug, Clone)]
pub struct CryptoPolicy {
    pub key_bits: u64,
    pub tag_bits: u64,
    pub unique_nonce: bool,
    pub forward_secrecy: bool,
}

pub fn valid_crypto_policy(p: &CryptoPolicy) -> bool {
    p.key_bits >= 256 && p.tag_bits >= 128 && p.unique_nonce
}

pub fn baseline_crypto_policy() -> CryptoPolicy {
    CryptoPolicy {
        key_bits: 256,
        tag_bits: 128,
        unique_nonce: true,
        forward_secrecy: true,
    }
}

pub fn hardened_crypto_policy() -> CryptoPolicy {
    CryptoPolicy {
        key_bits: 384,
        tag_bits: 192,
        unique_nonce: true,
        forward_secrecy: true,
    }
}

#[kani::proof]
fn harness_baseline_crypto_valid() {
    let p = baseline_crypto_policy();
    assert!(valid_crypto_policy(&p));
}

#[kani::proof]
fn harness_hardened_crypto_valid() {
    let p = hardened_crypto_policy();
    assert!(valid_crypto_policy(&p));
}

#[kani::proof]
fn harness_hardened_key_not_weaker() {
    assert!(hardened_crypto_policy().key_bits >= baseline_crypto_policy().key_bits);
}

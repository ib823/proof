// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of SecurityFoundation Verified Crypto invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// State model for Verified Crypto
pub struct CryptoState {
    pub key_zeroized_on_drop: bool,
    pub rng_seeded: bool,
    pub algorithm_approved: bool,
    pub side_channel_mitigated: bool,
    pub assurance_level: u64,
}

/// Invariant: all properties must hold with positive assurance
pub open spec fn verified_crypto_valid(s: CryptoState) -> bool {
    s.key_zeroized_on_drop && s.rng_seeded && s.algorithm_approved && s.side_channel_mitigated && s.assurance_level >= 1
}

/// Baseline configuration
pub open spec fn baseline_verified_crypto() -> CryptoState {
    CryptoState { key_zeroized_on_drop: true, rng_seeded: true, algorithm_approved: true, side_channel_mitigated: true, assurance_level: 1 }
}

/// Hardened configuration
pub open spec fn hardened_verified_crypto() -> CryptoState {
    CryptoState { key_zeroized_on_drop: true, rng_seeded: true, algorithm_approved: true, side_channel_mitigated: true, assurance_level: 3 }
}

/// Lemma: baseline is valid
proof fn lemma_baseline_valid()
    ensures verified_crypto_valid(baseline_verified_crypto()),
{
    let b = baseline_verified_crypto();
    assert(b.key_zeroized_on_drop && b.rng_seeded && b.algorithm_approved && b.side_channel_mitigated && b.assurance_level >= 1);
}

/// Lemma: hardened dominates baseline
proof fn lemma_hardened_dominates()
    ensures
        verified_crypto_valid(hardened_verified_crypto()),
        hardened_verified_crypto().assurance_level >= baseline_verified_crypto().assurance_level,
{
}

/// Lemma: each property is necessary
proof fn lemma_properties_necessary()
    ensures
        !verified_crypto_valid(CryptoState { key_zeroized_on_drop: false, rng_seeded: true, algorithm_approved: true, side_channel_mitigated: true, assurance_level: 1 }),
        !verified_crypto_valid(CryptoState { key_zeroized_on_drop: true, rng_seeded: false, algorithm_approved: true, side_channel_mitigated: true, assurance_level: 1 }),
        !verified_crypto_valid(CryptoState { key_zeroized_on_drop: true, rng_seeded: true, algorithm_approved: false, side_channel_mitigated: true, assurance_level: 1 }),
        !verified_crypto_valid(CryptoState { key_zeroized_on_drop: true, rng_seeded: true, algorithm_approved: true, side_channel_mitigated: false, assurance_level: 1 }),
{
}

} // verus!

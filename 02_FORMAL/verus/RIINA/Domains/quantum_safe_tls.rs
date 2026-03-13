// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Quantum Safe Tls domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Quantum Safe Tls verification
pub struct TLSSession {
    pub hybrid_kex: bool,
    pub pq_cipher_suite: bool,
    pub backward_compatible: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn quantum_safe_tls_secure(s: TLSSession) -> bool {
    s.hybrid_kex && s.pq_cipher_suite && s.backward_compatible && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_quantum_safe_tls() -> TLSSession {
    TLSSession {
        hybrid_kex: true,
        pq_cipher_suite: true,
        backward_compatible: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_quantum_safe_tls() -> TLSSession {
    TLSSession {
        hybrid_kex: true,
        pq_cipher_suite: true,
        backward_compatible: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures quantum_safe_tls_secure(baseline_quantum_safe_tls()),
{
    let b = baseline_quantum_safe_tls();
    assert(b.hybrid_kex);
    assert(b.pq_cipher_suite);
    assert(b.backward_compatible);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures quantum_safe_tls_secure(hardened_quantum_safe_tls()),
{
    let h = hardened_quantum_safe_tls();
    assert(h.hybrid_kex);
    assert(h.pq_cipher_suite);
    assert(h.backward_compatible);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        quantum_safe_tls_secure(hardened_quantum_safe_tls()),
        hardened_quantum_safe_tls().assurance_level >= baseline_quantum_safe_tls().assurance_level,
{
    let baseline = baseline_quantum_safe_tls();
    let hardened = hardened_quantum_safe_tls();
    assert(quantum_safe_tls_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !quantum_safe_tls_secure(TLSSession { hybrid_kex: false, pq_cipher_suite: true, backward_compatible: true, assurance_level: 1 }),
        !quantum_safe_tls_secure(TLSSession { hybrid_kex: true, pq_cipher_suite: false, backward_compatible: true, assurance_level: 1 }),
        !quantum_safe_tls_secure(TLSSession { hybrid_kex: true, pq_cipher_suite: true, backward_compatible: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !quantum_safe_tls_secure(TLSSession { hybrid_kex: true, pq_cipher_suite: true, backward_compatible: true, assurance_level: 0 }),
{
}

} // verus!

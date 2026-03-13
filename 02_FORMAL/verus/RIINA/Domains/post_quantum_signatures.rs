// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Post Quantum Signatures domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Post Quantum Signatures verification
pub struct PQSignature {
    pub euf_cma_secure: bool,
    pub signature_compact: bool,
    pub key_gen_deterministic: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn post_quantum_signatures_secure(s: PQSignature) -> bool {
    s.euf_cma_secure && s.signature_compact && s.key_gen_deterministic && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_post_quantum_signatures() -> PQSignature {
    PQSignature {
        euf_cma_secure: true,
        signature_compact: true,
        key_gen_deterministic: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_post_quantum_signatures() -> PQSignature {
    PQSignature {
        euf_cma_secure: true,
        signature_compact: true,
        key_gen_deterministic: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures post_quantum_signatures_secure(baseline_post_quantum_signatures()),
{
    let b = baseline_post_quantum_signatures();
    assert(b.euf_cma_secure);
    assert(b.signature_compact);
    assert(b.key_gen_deterministic);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures post_quantum_signatures_secure(hardened_post_quantum_signatures()),
{
    let h = hardened_post_quantum_signatures();
    assert(h.euf_cma_secure);
    assert(h.signature_compact);
    assert(h.key_gen_deterministic);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        post_quantum_signatures_secure(hardened_post_quantum_signatures()),
        hardened_post_quantum_signatures().assurance_level >= baseline_post_quantum_signatures().assurance_level,
{
    let baseline = baseline_post_quantum_signatures();
    let hardened = hardened_post_quantum_signatures();
    assert(post_quantum_signatures_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !post_quantum_signatures_secure(PQSignature { euf_cma_secure: false, signature_compact: true, key_gen_deterministic: true, assurance_level: 1 }),
        !post_quantum_signatures_secure(PQSignature { euf_cma_secure: true, signature_compact: false, key_gen_deterministic: true, assurance_level: 1 }),
        !post_quantum_signatures_secure(PQSignature { euf_cma_secure: true, signature_compact: true, key_gen_deterministic: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !post_quantum_signatures_secure(PQSignature { euf_cma_secure: true, signature_compact: true, key_gen_deterministic: true, assurance_level: 0 }),
{
}

} // verus!

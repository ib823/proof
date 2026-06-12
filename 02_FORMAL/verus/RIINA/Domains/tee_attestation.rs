// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Tee Attestation domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Tee Attestation verification
pub struct EnclaveAttestation {
    pub measurement_valid: bool,
    pub quote_fresh: bool,
    pub report_bound_to_enclave: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn tee_attestation_secure(s: EnclaveAttestation) -> bool {
    s.measurement_valid && s.quote_fresh && s.report_bound_to_enclave && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_tee_attestation() -> EnclaveAttestation {
    EnclaveAttestation {
        measurement_valid: true,
        quote_fresh: true,
        report_bound_to_enclave: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_tee_attestation() -> EnclaveAttestation {
    EnclaveAttestation {
        measurement_valid: true,
        quote_fresh: true,
        report_bound_to_enclave: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures tee_attestation_secure(baseline_tee_attestation()),
{
    let b = baseline_tee_attestation();
    assert(b.measurement_valid);
    assert(b.quote_fresh);
    assert(b.report_bound_to_enclave);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures tee_attestation_secure(hardened_tee_attestation()),
{
    let h = hardened_tee_attestation();
    assert(h.measurement_valid);
    assert(h.quote_fresh);
    assert(h.report_bound_to_enclave);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        tee_attestation_secure(hardened_tee_attestation()),
        hardened_tee_attestation().assurance_level >= baseline_tee_attestation().assurance_level,
{
    let baseline = baseline_tee_attestation();
    let hardened = hardened_tee_attestation();
    assert(tee_attestation_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !tee_attestation_secure(EnclaveAttestation { measurement_valid: false, quote_fresh: true, report_bound_to_enclave: true, assurance_level: 1 }),
        !tee_attestation_secure(EnclaveAttestation { measurement_valid: true, quote_fresh: false, report_bound_to_enclave: true, assurance_level: 1 }),
        !tee_attestation_secure(EnclaveAttestation { measurement_valid: true, quote_fresh: true, report_bound_to_enclave: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !tee_attestation_secure(EnclaveAttestation { measurement_valid: true, quote_fresh: true, report_bound_to_enclave: true, assurance_level: 0 }),
{
}

} // verus!

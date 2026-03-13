// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Malaysia Digital Signature domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Malaysia Digital Signature verification
pub struct DigitalSignature {
    pub certificate_valid: bool,
    pub ca_licensed: bool,
    pub timestamp_included: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn malaysia_digital_signature_secure(s: DigitalSignature) -> bool {
    s.certificate_valid && s.ca_licensed && s.timestamp_included && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_malaysia_digital_signature() -> DigitalSignature {
    DigitalSignature {
        certificate_valid: true,
        ca_licensed: true,
        timestamp_included: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_malaysia_digital_signature() -> DigitalSignature {
    DigitalSignature {
        certificate_valid: true,
        ca_licensed: true,
        timestamp_included: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures malaysia_digital_signature_secure(baseline_malaysia_digital_signature()),
{
    let b = baseline_malaysia_digital_signature();
    assert(b.certificate_valid);
    assert(b.ca_licensed);
    assert(b.timestamp_included);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures malaysia_digital_signature_secure(hardened_malaysia_digital_signature()),
{
    let h = hardened_malaysia_digital_signature();
    assert(h.certificate_valid);
    assert(h.ca_licensed);
    assert(h.timestamp_included);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        malaysia_digital_signature_secure(hardened_malaysia_digital_signature()),
        hardened_malaysia_digital_signature().assurance_level >= baseline_malaysia_digital_signature().assurance_level,
{
    let baseline = baseline_malaysia_digital_signature();
    let hardened = hardened_malaysia_digital_signature();
    assert(malaysia_digital_signature_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !malaysia_digital_signature_secure(DigitalSignature { certificate_valid: false, ca_licensed: true, timestamp_included: true, assurance_level: 1 }),
        !malaysia_digital_signature_secure(DigitalSignature { certificate_valid: true, ca_licensed: false, timestamp_included: true, assurance_level: 1 }),
        !malaysia_digital_signature_secure(DigitalSignature { certificate_valid: true, ca_licensed: true, timestamp_included: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !malaysia_digital_signature_secure(DigitalSignature { certificate_valid: true, ca_licensed: true, timestamp_included: true, assurance_level: 0 }),
{
}

} // verus!

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Verus verification of Certification Evidence domain invariants.

#![allow(unused)]
use vstd::prelude::*;

verus! {

/// Core state for Certification Evidence verification
pub struct CertEvidence {
    pub traceability_complete: bool,
    pub review_documented: bool,
    pub artifact_signed: bool,
    pub assurance_level: u64,
}

/// Security invariant: all controls must be active with positive assurance
pub open spec fn certification_evidence_secure(s: CertEvidence) -> bool {
    s.traceability_complete && s.review_documented && s.artifact_signed && s.assurance_level >= 1
}

/// Baseline configuration: minimum viable security posture
pub open spec fn baseline_certification_evidence() -> CertEvidence {
    CertEvidence {
        traceability_complete: true,
        review_documented: true,
        artifact_signed: true,
        assurance_level: 1,
    }
}

/// Hardened configuration: elevated security posture
pub open spec fn hardened_certification_evidence() -> CertEvidence {
    CertEvidence {
        traceability_complete: true,
        review_documented: true,
        artifact_signed: true,
        assurance_level: 3,
    }
}

/// Lemma: baseline configuration satisfies security invariant
proof fn lemma_baseline_secure()
    ensures certification_evidence_secure(baseline_certification_evidence()),
{
    let b = baseline_certification_evidence();
    assert(b.traceability_complete);
    assert(b.review_documented);
    assert(b.artifact_signed);
    assert(b.assurance_level >= 1);
}

/// Lemma: hardened configuration satisfies security invariant
proof fn lemma_hardened_secure()
    ensures certification_evidence_secure(hardened_certification_evidence()),
{
    let h = hardened_certification_evidence();
    assert(h.traceability_complete);
    assert(h.review_documented);
    assert(h.artifact_signed);
    assert(h.assurance_level >= 1);
}

/// Lemma: hardened configuration is at least as strong as baseline
proof fn lemma_hardened_not_weaker()
    ensures
        certification_evidence_secure(hardened_certification_evidence()),
        hardened_certification_evidence().assurance_level >= baseline_certification_evidence().assurance_level,
{
    let baseline = baseline_certification_evidence();
    let hardened = hardened_certification_evidence();
    assert(certification_evidence_secure(hardened));
    assert(hardened.assurance_level >= baseline.assurance_level);
}

/// Lemma: disabling any control breaks the invariant
proof fn lemma_control_necessary()
    ensures
        !certification_evidence_secure(CertEvidence { traceability_complete: false, review_documented: true, artifact_signed: true, assurance_level: 1 }),
        !certification_evidence_secure(CertEvidence { traceability_complete: true, review_documented: false, artifact_signed: true, assurance_level: 1 }),
        !certification_evidence_secure(CertEvidence { traceability_complete: true, review_documented: true, artifact_signed: false, assurance_level: 1 }),
{
}

/// Lemma: zero assurance breaks the invariant even with all controls
proof fn lemma_assurance_necessary()
    ensures
        !certification_evidence_secure(CertEvidence { traceability_complete: true, review_documented: true, artifact_signed: true, assurance_level: 0 }),
{
}

} // verus!

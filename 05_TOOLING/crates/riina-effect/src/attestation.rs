// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Runtime attestation evidence primitives for Dimension 14.

use riina_core::constant_time::ConstantTimeEq;
use riina_core::crypto::sha2::Sha256;
use riina_core::zeroize::Zeroize;

/// Supported attestation evidence kinds.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum AttestationKind {
    /// Software fallback attestation based on keyed digest.
    SoftwareSha256,
}

impl AttestationKind {
    #[must_use]
    pub const fn as_u8(self) -> u8 {
        match self {
            Self::SoftwareSha256 => 1,
        }
    }
}

/// Runtime attestation evidence object.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct AttestationEvidence {
    /// Attestation mechanism kind.
    pub kind: AttestationKind,
    /// Provider identity digest.
    pub provider_id: [u8; 32],
    /// Timestamp used for evidence generation.
    pub timestamp_unix: u64,
    /// Anti-replay nonce.
    pub nonce: [u8; 32],
    /// Measurement over payload.
    pub measurement: [u8; 32],
    /// Provider-authenticated quote digest.
    pub quote: [u8; 32],
}

impl AttestationEvidence {
    /// Canonical payload bytes suitable for proof-chain ingestion.
    #[must_use]
    pub fn to_payload(&self) -> Vec<u8> {
        let mut out = Vec::with_capacity(1 + 32 + 8 + 32 + 32 + 32);
        out.push(self.kind.as_u8());
        out.extend_from_slice(&self.provider_id);
        out.extend_from_slice(&self.timestamp_unix.to_be_bytes());
        out.extend_from_slice(&self.nonce);
        out.extend_from_slice(&self.measurement);
        out.extend_from_slice(&self.quote);
        out
    }
}

/// Runtime attestation provider contract.
pub trait AttestationProvider {
    /// Produce evidence for payload + nonce + timestamp.
    fn attest(&self, payload: &[u8], nonce: [u8; 32], timestamp_unix: u64) -> AttestationEvidence;

    /// Verify provider-specific evidence against payload.
    fn verify(&self, payload: &[u8], evidence: &AttestationEvidence) -> bool;
}

/// Software fallback provider (deterministic, testable).
///
/// This is intentionally not hardware-backed; it is the executable local lane.
#[derive(Debug, Clone)]
pub struct SoftwareAttestationProvider {
    provider_id: [u8; 32],
    provider_key: [u8; 32],
}

impl SoftwareAttestationProvider {
    /// Construct a provider from key + label.
    #[must_use]
    pub fn new(provider_key: [u8; 32], provider_label: &str) -> Self {
        Self {
            provider_id: Sha256::hash(provider_label.as_bytes()),
            provider_key,
        }
    }

    fn quote_input(
        &self,
        measurement: [u8; 32],
        nonce: [u8; 32],
        timestamp_unix: u64,
    ) -> [u8; 32] {
        let mut input = Vec::with_capacity(1 + 32 + 32 + 32 + 8 + 32);
        input.push(AttestationKind::SoftwareSha256.as_u8());
        input.extend_from_slice(&self.provider_id);
        input.extend_from_slice(&measurement);
        input.extend_from_slice(&nonce);
        input.extend_from_slice(&timestamp_unix.to_be_bytes());
        input.extend_from_slice(&self.provider_key);
        Sha256::hash(&input)
    }
}

impl AttestationProvider for SoftwareAttestationProvider {
    fn attest(&self, payload: &[u8], nonce: [u8; 32], timestamp_unix: u64) -> AttestationEvidence {
        let measurement = Sha256::hash(payload);
        let quote = self.quote_input(measurement, nonce, timestamp_unix);
        AttestationEvidence {
            kind: AttestationKind::SoftwareSha256,
            provider_id: self.provider_id,
            timestamp_unix,
            nonce,
            measurement,
            quote,
        }
    }

    fn verify(&self, payload: &[u8], evidence: &AttestationEvidence) -> bool {
        if evidence.kind != AttestationKind::SoftwareSha256 {
            return false;
        }
        if !evidence.provider_id.ct_eq(&self.provider_id) {
            return false;
        }
        let expected_measurement = Sha256::hash(payload);
        if !evidence.measurement.ct_eq(&expected_measurement) {
            return false;
        }
        let expected_quote =
            self.quote_input(evidence.measurement, evidence.nonce, evidence.timestamp_unix);
        evidence.quote.ct_eq(&expected_quote)
    }
}

impl Drop for SoftwareAttestationProvider {
    fn drop(&mut self) {
        self.provider_key.zeroize();
    }
}

#[cfg(test)]
mod tests {
    use super::{AttestationProvider, SoftwareAttestationProvider};

    fn provider() -> SoftwareAttestationProvider {
        SoftwareAttestationProvider::new([0x42u8; 32], "riina.software.attestation")
    }

    #[test]
    fn software_attestation_roundtrip() {
        let provider = provider();
        let payload = b"runtime-bundle-head";
        let nonce = [0xABu8; 32];
        let ev = provider.attest(payload, nonce, 1_700_000_001);
        assert!(provider.verify(payload, &ev));
    }

    #[test]
    fn software_attestation_detects_tamper() {
        let provider = provider();
        let payload = b"runtime-bundle-head";
        let nonce = [0xABu8; 32];
        let mut ev = provider.attest(payload, nonce, 1_700_000_001);
        ev.quote[0] ^= 0x55;
        assert!(!provider.verify(payload, &ev));
    }
}

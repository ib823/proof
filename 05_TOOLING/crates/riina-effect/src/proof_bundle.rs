// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Runtime proof-bundle and integrity-chain primitives (Dimension 14 core).

use riina_core::constant_time::ConstantTimeEq;
use riina_core::crypto::sha2::Sha256;

/// Runtime proof bundle schema version.
pub const RUNTIME_PROOF_BUNDLE_VERSION: u32 = 1;

/// Event classes tracked by the runtime proof chain.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RuntimeEventKind {
    /// Effect gate decision.
    EffectDecision,
    /// Explicit state transition checkpoint.
    StateTransition,
    /// Constant-time runtime sample.
    ConstantTimeSample,
    /// Zeroization witness record.
    ZeroizationWitness,
    /// Hardware attestation extension record.
    AttestationExtension,
}

impl RuntimeEventKind {
    /// Stable wire encoding used in event-hash computation.
    #[must_use]
    pub const fn as_u8(self) -> u8 {
        match self {
            Self::EffectDecision => 1,
            Self::StateTransition => 2,
            Self::ConstantTimeSample => 3,
            Self::ZeroizationWitness => 4,
            Self::AttestationExtension => 5,
        }
    }
}

/// One immutable step in the runtime integrity chain.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct RuntimeEvent {
    /// Monotonic event sequence number.
    pub sequence: u64,
    /// Event timestamp (unix seconds).
    pub timestamp_unix: u64,
    /// Event class.
    pub kind: RuntimeEventKind,
    /// Digest of event payload bytes.
    pub payload_hash: [u8; 32],
    /// Previous chain head.
    pub previous_hash: [u8; 32],
    /// Current event digest.
    pub event_hash: [u8; 32],
}

/// Verification errors for runtime proof chains.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ProofBundleError {
    /// Event sequence exceeded representable range.
    SequenceOverflow,
    /// Previous hash link mismatch.
    BrokenChainLink,
    /// Event digest mismatch.
    InvalidEventHash,
}

/// Runtime proof bundle anchored to one program identity.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct RuntimeProofBundle {
    /// Schema version.
    pub version: u32,
    /// Program identity digest (binary/proof-manifest identity anchor).
    pub program_hash: [u8; 32],
    /// Ordered event list.
    pub events: Vec<RuntimeEvent>,
    /// Current chain head.
    pub chain_head: [u8; 32],
}

impl RuntimeProofBundle {
    /// Construct a new empty runtime proof bundle.
    #[must_use]
    pub fn new(program_identity: &[u8]) -> Self {
        Self {
            version: RUNTIME_PROOF_BUNDLE_VERSION,
            program_hash: Sha256::hash(program_identity),
            events: Vec::new(),
            chain_head: [0u8; 32],
        }
    }

    /// Append one event and advance the chain head.
    pub fn append_event(
        &mut self,
        timestamp_unix: u64,
        kind: RuntimeEventKind,
        payload: &[u8],
    ) -> Result<&RuntimeEvent, ProofBundleError> {
        let sequence =
            u64::try_from(self.events.len()).map_err(|_| ProofBundleError::SequenceOverflow)?;
        let payload_hash = Sha256::hash(payload);
        let previous_hash = self.chain_head;
        let event_hash = compute_event_hash(
            self.version,
            self.program_hash,
            sequence,
            timestamp_unix,
            kind,
            payload_hash,
            previous_hash,
        );

        self.events.push(RuntimeEvent {
            sequence,
            timestamp_unix,
            kind,
            payload_hash,
            previous_hash,
            event_hash,
        });
        self.chain_head = event_hash;

        self.events.last().ok_or(ProofBundleError::SequenceOverflow)
    }

    /// Verify the entire chain from genesis to head.
    pub fn verify_chain(&self) -> Result<(), ProofBundleError> {
        let mut expected_previous = [0u8; 32];
        for event in &self.events {
            if !event.previous_hash.ct_eq(&expected_previous) {
                return Err(ProofBundleError::BrokenChainLink);
            }
            let expected_hash = compute_event_hash(
                self.version,
                self.program_hash,
                event.sequence,
                event.timestamp_unix,
                event.kind,
                event.payload_hash,
                event.previous_hash,
            );
            if !event.event_hash.ct_eq(&expected_hash) {
                return Err(ProofBundleError::InvalidEventHash);
            }
            expected_previous = event.event_hash;
        }
        if !self.chain_head.ct_eq(&expected_previous) {
            return Err(ProofBundleError::BrokenChainLink);
        }
        Ok(())
    }

    /// Stable digest of the full bundle state.
    #[must_use]
    pub fn bundle_digest(&self) -> [u8; 32] {
        let mut inbuf = Vec::with_capacity(4 + 32 + 8 + 32);
        inbuf.extend_from_slice(&self.version.to_be_bytes());
        inbuf.extend_from_slice(&self.program_hash);
        inbuf.extend_from_slice(&(self.events.len() as u64).to_be_bytes());
        inbuf.extend_from_slice(&self.chain_head);
        Sha256::hash(&inbuf)
    }
}

fn compute_event_hash(
    version: u32,
    program_hash: [u8; 32],
    sequence: u64,
    timestamp_unix: u64,
    kind: RuntimeEventKind,
    payload_hash: [u8; 32],
    previous_hash: [u8; 32],
) -> [u8; 32] {
    let mut input = Vec::with_capacity(4 + 32 + 8 + 8 + 1 + 32 + 32);
    input.extend_from_slice(&version.to_be_bytes());
    input.extend_from_slice(&program_hash);
    input.extend_from_slice(&sequence.to_be_bytes());
    input.extend_from_slice(&timestamp_unix.to_be_bytes());
    input.push(kind.as_u8());
    input.extend_from_slice(&payload_hash);
    input.extend_from_slice(&previous_hash);
    Sha256::hash(&input)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn chain_roundtrip_verifies() {
        let mut bundle = RuntimeProofBundle::new(b"riina-program:v1");
        let append_1 = bundle.append_event(
            1_700_000_001,
            RuntimeEventKind::EffectDecision,
            b"effect:allow",
        );
        assert!(append_1.is_ok());
        let append_2 = bundle.append_event(
            1_700_000_002,
            RuntimeEventKind::ConstantTimeSample,
            b"ct:t=42",
        );
        assert!(append_2.is_ok());
        assert!(bundle.verify_chain().is_ok());
        assert_ne!(bundle.bundle_digest(), [0u8; 32]);
    }

    #[test]
    fn chain_detects_tamper() {
        let mut bundle = RuntimeProofBundle::new(b"riina-program:v1");
        let append = bundle.append_event(
            1_700_000_001,
            RuntimeEventKind::EffectDecision,
            b"effect:allow",
        );
        assert!(append.is_ok());
        if let Some(first) = bundle.events.first_mut() {
            first.payload_hash[0] ^= 0x55;
        } else {
            return;
        }
        assert_eq!(
            bundle.verify_chain(),
            Err(ProofBundleError::InvalidEventHash)
        );
    }
}

// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Runtime proof-bundle and integrity-chain primitives (Dimension 14 core).
//!
//! # What verification establishes (read before relying on it)
//!
//! * [`RuntimeProofBundle::verify_chain`] checks the SHA-256 hash chain:
//!   links, per-event digests, sequence numbers, schema version, and that the
//!   bundle is non-empty. The chain is **unkeyed**, so this is *integrity
//!   only*: anyone can compute a perfectly consistent bundle for any program
//!   and any events. It detects corruption and partial edits, not forgery.
//! * [`RuntimeProofBundle::verify_for_program`] additionally pins the bundle
//!   to the program the verifier EXPECTS (the bundle's own `program_hash` is
//!   attacker-chosen data until compared against something trusted).
//! * [`RuntimeProofBundle::verify_authenticated`] additionally checks an
//!   HMAC-SHA256 tag ([`RuntimeProofBundle::authentication_tag`]) under a key
//!   shared between the producer and the verifier. Only this mode gives
//!   *authenticity*: a party without the key cannot produce a bundle that
//!   passes. (Symmetric: anyone holding the key can also produce one.)
//!
//! Until 2026-10 the only check was the unkeyed chain, with no expected
//! program identity, and an empty all-zero bundle verified.

use riina_core::constant_time::ConstantTimeEq;
use riina_core::crypto::hmac::HmacSha256;
use riina_core::crypto::sha2::Sha256;

/// Runtime proof bundle schema version.
pub const RUNTIME_PROOF_BUNDLE_VERSION: u32 = 1;

/// Minimum HMAC key length accepted by the authenticated mode (128 bits).
pub const MIN_AUTH_KEY_LEN: usize = 16;

/// Domain separator for the bundle authentication tag.
const AUTH_TAG_DOMAIN: &[u8] = b"riina.runtime-proof-bundle.auth.v1";

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
    /// The bundle records no events — there is nothing to attest.
    EmptyBundle,
    /// An event's sequence number is not its position in the chain.
    SequenceMismatch,
    /// The bundle's schema version is not one this verifier understands.
    UnsupportedVersion,
    /// The bundle is anchored to a different program than the one expected.
    ProgramMismatch,
    /// The authentication key is shorter than [`MIN_AUTH_KEY_LEN`].
    KeyTooShort,
    /// The HMAC-SHA256 authentication tag does not verify.
    AuthenticationFailed,
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
            program_hash: Self::program_hash_for(program_identity),
            events: Vec::new(),
            chain_head: [0u8; 32],
        }
    }

    /// The `program_hash` a bundle created with [`Self::new`] for
    /// `program_identity` carries — what a verifier should expect.
    #[must_use]
    pub fn program_hash_for(program_identity: &[u8]) -> [u8; 32] {
        Sha256::hash(program_identity)
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

    /// Verify the entire chain from genesis to head — INTEGRITY ONLY (see the
    /// module docs): an unkeyed chain anyone can recompute. Rejects an empty
    /// bundle, an unknown schema version, and out-of-order sequence numbers.
    pub fn verify_chain(&self) -> Result<(), ProofBundleError> {
        if self.version != RUNTIME_PROOF_BUNDLE_VERSION {
            return Err(ProofBundleError::UnsupportedVersion);
        }
        if self.events.is_empty() {
            return Err(ProofBundleError::EmptyBundle);
        }
        let mut expected_previous = [0u8; 32];
        for (index, event) in self.events.iter().enumerate() {
            if u64::try_from(index).ok() != Some(event.sequence) {
                return Err(ProofBundleError::SequenceMismatch);
            }
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

    /// [`Self::verify_chain`] plus: the bundle must be anchored to
    /// `expected_program_hash`, which the VERIFIER supplies from a trusted
    /// source. Still integrity only — see [`Self::verify_authenticated`].
    pub fn verify_for_program(
        &self,
        expected_program_hash: &[u8; 32],
    ) -> Result<(), ProofBundleError> {
        if !self.program_hash.ct_eq(expected_program_hash) {
            return Err(ProofBundleError::ProgramMismatch);
        }
        self.verify_chain()
    }

    /// HMAC-SHA256 authentication tag over the bundle under `key`.
    ///
    /// The MAC covers a domain separator, the schema version, the program
    /// hash, the event count and the chain head; the chain head commits to
    /// every event through the hash chain, which [`Self::verify_authenticated`]
    /// re-verifies before checking the tag.
    pub fn authentication_tag(&self, key: &[u8]) -> Result<[u8; 32], ProofBundleError> {
        if key.len() < MIN_AUTH_KEY_LEN {
            return Err(ProofBundleError::KeyTooShort);
        }
        Ok(HmacSha256::mac(key, &self.auth_message()))
    }

    /// Full verification: [`Self::verify_for_program`] AND a constant-time
    /// check of the HMAC-SHA256 `tag` under `key`. This is the only mode in
    /// which a bundle is evidence that a key holder produced it.
    pub fn verify_authenticated(
        &self,
        expected_program_hash: &[u8; 32],
        key: &[u8],
        tag: &[u8; 32],
    ) -> Result<(), ProofBundleError> {
        if key.len() < MIN_AUTH_KEY_LEN {
            return Err(ProofBundleError::KeyTooShort);
        }
        self.verify_for_program(expected_program_hash)?;
        if HmacSha256::verify(key, &self.auth_message(), tag) {
            Ok(())
        } else {
            Err(ProofBundleError::AuthenticationFailed)
        }
    }

    fn auth_message(&self) -> Vec<u8> {
        let mut msg = Vec::with_capacity(AUTH_TAG_DOMAIN.len() + 4 + 32 + 8 + 32);
        msg.extend_from_slice(AUTH_TAG_DOMAIN);
        msg.extend_from_slice(&self.version.to_be_bytes());
        msg.extend_from_slice(&self.program_hash);
        msg.extend_from_slice(&(self.events.len() as u64).to_be_bytes());
        msg.extend_from_slice(&self.chain_head);
        msg
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

    fn sample(identity: &[u8]) -> RuntimeProofBundle {
        let mut bundle = RuntimeProofBundle::new(identity);
        assert!(bundle
            .append_event(1, RuntimeEventKind::EffectDecision, b"allow")
            .is_ok());
        assert!(bundle
            .append_event(2, RuntimeEventKind::StateTransition, b"s1")
            .is_ok());
        bundle
    }

    /// Regression (audit M3): the empty all-zero bundle used to verify.
    #[test]
    fn empty_bundle_is_rejected() {
        let empty = RuntimeProofBundle {
            version: RUNTIME_PROOF_BUNDLE_VERSION,
            program_hash: [0u8; 32],
            events: Vec::new(),
            chain_head: [0u8; 32],
        };
        assert_eq!(empty.verify_chain(), Err(ProofBundleError::EmptyBundle));
        assert_eq!(
            RuntimeProofBundle::new(b"p").verify_chain(),
            Err(ProofBundleError::EmptyBundle)
        );
    }

    /// The bundle's own program_hash is attacker data until it is compared
    /// with what the verifier expects.
    #[test]
    fn verify_for_program_pins_the_program() {
        let bundle = sample(b"riina-program:v1");
        let expected = RuntimeProofBundle::program_hash_for(b"riina-program:v1");
        assert!(bundle.verify_for_program(&expected).is_ok());
        let other = RuntimeProofBundle::program_hash_for(b"riina-program:v2");
        assert_eq!(
            bundle.verify_for_program(&other),
            Err(ProofBundleError::ProgramMismatch)
        );
    }

    #[test]
    fn out_of_order_sequence_and_unknown_version_are_rejected() {
        let mut bundle = sample(b"p");
        bundle.events[1].sequence = 7;
        assert_eq!(bundle.verify_chain(), Err(ProofBundleError::SequenceMismatch));
        let mut bundle = sample(b"p");
        bundle.version = 99;
        assert_eq!(bundle.verify_chain(), Err(ProofBundleError::UnsupportedVersion));
    }

    /// An unkeyed chain can be FABRICATED by anyone (the forgery is just the
    /// producer's own code) — that is why authenticated mode exists. A
    /// fabricated bundle passes `verify_for_program` but not
    /// `verify_authenticated` without the key.
    #[test]
    fn fabricated_bundle_fails_authenticated_verification() {
        let key = [0x5Au8; 32];
        let expected = RuntimeProofBundle::program_hash_for(b"prod");
        let genuine = sample(b"prod");
        let tag = genuine.authentication_tag(&key).unwrap_or([0u8; 32]);
        assert!(genuine.verify_authenticated(&expected, &key, &tag).is_ok());

        // Attacker without the key: a consistent chain with forged events.
        let mut forged = RuntimeProofBundle::new(b"prod");
        assert!(forged
            .append_event(1, RuntimeEventKind::EffectDecision, b"deny->allow")
            .is_ok());
        assert!(forged.verify_for_program(&expected).is_ok(), "integrity-only accepts it");
        for guess in [tag, [0u8; 32]] {
            assert_eq!(
                forged.verify_authenticated(&expected, &key, &guess),
                Err(ProofBundleError::AuthenticationFailed)
            );
        }
        // Any edit to a genuine bundle breaks the tag (or the chain).
        let mut edited = genuine.clone();
        edited.events.pop();
        edited.chain_head = edited.events[0].event_hash;
        assert_eq!(
            edited.verify_authenticated(&expected, &key, &tag),
            Err(ProofBundleError::AuthenticationFailed)
        );
        // Wrong key / short key.
        assert_eq!(
            genuine.verify_authenticated(&expected, &[0x5Bu8; 32], &tag),
            Err(ProofBundleError::AuthenticationFailed)
        );
        assert_eq!(
            genuine.verify_authenticated(&expected, b"short", &tag),
            Err(ProofBundleError::KeyTooShort)
        );
        assert_eq!(genuine.authentication_tag(b""), Err(ProofBundleError::KeyTooShort));
    }
}

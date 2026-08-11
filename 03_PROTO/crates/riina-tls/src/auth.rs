// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Peer authentication — RFC 7250 raw public keys + RFC 8446 §4.4.3
//! CertificateVerify, with a pinned trust store.
//!
//! Increment 3 of the TLS port. Increments 1–2 gave real AEAD and a real
//! ECDHE handshake, but that handshake was **anonymous**: it stopped an
//! eavesdropper and did nothing against an active machine-in-the-middle. This
//! module supplies the missing half — proof that the peer holds a private key
//! the verifier already trusts — which is what finally lets
//! [`crate::handshake::ConnectedEvidence::tls_connected`] be true.
//!
//! # Trust model (read this before believing anything)
//!
//! Authentication here is **raw-public-key pinning**, not PKI:
//!
//!   * The credential is the peer's bare Ed25519 public key, which is
//!     [RFC 7250]'s `RawPublicKey` certificate type — a standardised TLS
//!     alternative to X.509, widely used where a CA hierarchy is unwanted.
//!   * Trust is a **pinned set** ([`TrustStore`]): a key is trusted iff the
//!     verifier was told to trust it. There is **no** certificate chain, no
//!     CA, no name binding, no expiry, and **no revocation** — pinning a
//!     compromised key can only be undone by un-pinning it.
//!   * Therefore `cert_chain_verified` means "the peer proved possession of a
//!     pinned key", NOT "a chain validated to a root". X.509 parsing, chain
//!     building, name/SAN checks and revocation are all future work. A
//!     deployment that needs PKI semantics does not get them here.
//!
//! What this DOES buy, and it is the point of the increment: an active MITM
//! who substitutes its own key cannot complete the handshake against a client
//! that authenticates — proven by `mitm_with_substituted_key_is_rejected`.
//!
//! # Downgrade protection
//!
//! A client that carries a trust store **requires** authentication and a
//! server that carries an identity **requires** its peer to want it: a
//! mismatch is a hard [`crate::TlsError::HandshakeFailed`], never a silent
//! fallback to the anonymous mode. Allowing the fallback would hand a MITM a
//! trivial downgrade, which would make the whole increment decorative.
//!
//! [RFC 7250]: https://www.rfc-editor.org/rfc/rfc7250

use crate::TlsError;
use riina_core::crypto::ed25519::{
    Ed25519SigningKey, Ed25519VerifyingKey, PUBLIC_KEY_SIZE, SIGNATURE_SIZE,
};

/// Length of a raw-public-key credential (RFC 7250) — an Ed25519 public key.
pub const CREDENTIAL_LEN: usize = PUBLIC_KEY_SIZE;
/// Length of the CertificateVerify signature.
pub const SIGNATURE_LEN: usize = SIGNATURE_SIZE;

/// RFC 8446 §4.4.3 context string for a server's CertificateVerify.
const SERVER_CONTEXT: &[u8] = b"TLS 1.3, server CertificateVerify";

/// Build the exact byte string RFC 8446 §4.4.3 signs:
///
/// ```text
/// 0x20 repeated 64 times
/// || context string
/// || 0x00 separator
/// || Transcript-Hash(Handshake Context, Certificate)
/// ```
///
/// The 64-space prefix and context string are not decoration: they domain-
/// separate this signature from other protocols' (and from a client's own
/// CertificateVerify), which is what stops a signature made in one context
/// being replayed as if made in another.
#[must_use]
pub fn certificate_verify_payload(transcript_hash: &[u8]) -> Vec<u8> {
    let mut m = Vec::with_capacity(64 + SERVER_CONTEXT.len() + 1 + transcript_hash.len());
    m.extend_from_slice(&[0x20u8; 64]);
    m.extend_from_slice(SERVER_CONTEXT);
    m.push(0x00);
    m.extend_from_slice(transcript_hash);
    m
}

/// A long-term signing identity — the private half of a raw-public-key
/// credential. Wraps `riina-core`'s Ed25519 (deterministic RFC 8032 signing,
/// so it consumes no randomness once the seed is fixed).
pub struct Identity {
    signing: Ed25519SigningKey,
}

impl Identity {
    /// Build from a 32-byte seed. The seed MUST come from the OS CSPRNG for a
    /// real deployment (see [`crate::handshake::os_entropy_32`]); a fixed seed
    /// is for tests and known-answer vectors only.
    #[must_use]
    pub fn from_seed(seed: &[u8; 32]) -> Self {
        Self {
            signing: Ed25519SigningKey::from_seed(seed),
        }
    }

    /// The public credential to send to peers and to pin in their stores.
    #[must_use]
    pub fn credential(&self) -> [u8; CREDENTIAL_LEN] {
        *self.signing.public_key_bytes()
    }

    /// Sign the §4.4.3 payload over `transcript_hash`.
    #[must_use]
    pub fn certificate_verify(&self, transcript_hash: &[u8]) -> [u8; SIGNATURE_LEN] {
        self.signing.sign(&certificate_verify_payload(transcript_hash))
    }
}

/// The set of peer credentials this side is willing to trust (pinning).
///
/// Empty by default — and an empty store trusts **nothing**, so a handshake
/// that requires authentication against it always fails. That is deliberate:
/// the failure mode of "forgot to pin anything" must be refusal, never
/// acceptance.
#[derive(Debug, Clone, Default)]
pub struct TrustStore {
    trusted: Vec<[u8; CREDENTIAL_LEN]>,
}

impl TrustStore {
    #[must_use]
    pub fn new() -> Self {
        Self::default()
    }

    /// Pin a credential.
    pub fn trust(&mut self, credential: [u8; CREDENTIAL_LEN]) {
        if !self.trusted.contains(&credential) {
            self.trusted.push(credential);
        }
    }

    #[must_use]
    pub fn is_empty(&self) -> bool {
        self.trusted.is_empty()
    }

    #[must_use]
    pub fn len(&self) -> usize {
        self.trusted.len()
    }

    /// Is this credential pinned?
    ///
    /// Public keys are not secrets, so a data-dependent comparison here leaks
    /// nothing an attacker does not already hold; the security-relevant
    /// constant-time work is inside Ed25519 verification in `riina-core`.
    #[must_use]
    pub fn is_trusted(&self, credential: &[u8; CREDENTIAL_LEN]) -> bool {
        self.trusted.contains(credential)
    }
}

/// Verify a peer's CertificateVerify against a pinned credential.
///
/// Order matters and is deliberate: **pinning is checked first**, so an
/// untrusted key is rejected before its signature is even considered — a
/// perfectly valid signature from a key nobody trusts must not pass.
///
/// # Errors
/// [`TlsError::HandshakeFailed`] if the credential is not pinned, is not a
/// valid Ed25519 point, or the signature does not verify over the §4.4.3
/// payload.
pub fn verify_peer(
    store: &TrustStore,
    credential: &[u8; CREDENTIAL_LEN],
    transcript_hash: &[u8],
    signature: &[u8; SIGNATURE_LEN],
) -> Result<(), TlsError> {
    if !store.is_trusted(credential) {
        return Err(TlsError::HandshakeFailed);
    }
    let vk = Ed25519VerifyingKey::from_bytes(credential).map_err(|_| TlsError::HandshakeFailed)?;
    vk.verify(&certificate_verify_payload(transcript_hash), signature)
        .map_err(|_| TlsError::HandshakeFailed)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn signature_verifies_against_pinned_credential() {
        let id = Identity::from_seed(&[3u8; 32]);
        let mut store = TrustStore::new();
        store.trust(id.credential());
        let th = [9u8; 32];
        let sig = id.certificate_verify(&th);
        assert!(verify_peer(&store, &id.credential(), &th, &sig).is_ok());
    }

    /// A valid signature from a key nobody pinned must NOT pass — this is the
    /// difference between "someone signed it" and "someone I trust signed it".
    #[test]
    fn untrusted_credential_is_rejected_even_with_a_valid_signature() {
        let stranger = Identity::from_seed(&[4u8; 32]);
        let th = [9u8; 32];
        let sig = stranger.certificate_verify(&th);
        // Empty store…
        let empty = TrustStore::new();
        assert_eq!(
            verify_peer(&empty, &stranger.credential(), &th, &sig).err(),
            Some(TlsError::HandshakeFailed)
        );
        // …and a store that pins somebody else.
        let mut other = TrustStore::new();
        other.trust(Identity::from_seed(&[5u8; 32]).credential());
        assert_eq!(
            verify_peer(&other, &stranger.credential(), &th, &sig).err(),
            Some(TlsError::HandshakeFailed)
        );
    }

    /// Binding to the transcript: a signature over a different transcript is
    /// rejected, so a recorded signature cannot be replayed into another
    /// handshake.
    #[test]
    fn signature_over_a_different_transcript_is_rejected() {
        let id = Identity::from_seed(&[3u8; 32]);
        let mut store = TrustStore::new();
        store.trust(id.credential());
        let sig = id.certificate_verify(&[1u8; 32]);
        assert_eq!(
            verify_peer(&store, &id.credential(), &[2u8; 32], &sig).err(),
            Some(TlsError::HandshakeFailed)
        );
    }

    #[test]
    fn tampered_signature_is_rejected() {
        let id = Identity::from_seed(&[3u8; 32]);
        let mut store = TrustStore::new();
        store.trust(id.credential());
        let th = [9u8; 32];
        let mut sig = id.certificate_verify(&th);
        sig[0] ^= 0x01;
        assert_eq!(
            verify_peer(&store, &id.credential(), &th, &sig).err(),
            Some(TlsError::HandshakeFailed)
        );
    }

    /// The §4.4.3 payload really is the RFC's construction: 64 spaces, the
    /// context string, a zero separator, then the transcript hash.
    #[test]
    fn payload_matches_rfc_8446_4_4_3() {
        let th = [0xABu8; 32];
        let p = certificate_verify_payload(&th);
        assert_eq!(&p[..64], &[0x20u8; 64]);
        assert_eq!(&p[64..64 + SERVER_CONTEXT.len()], SERVER_CONTEXT);
        assert_eq!(p[64 + SERVER_CONTEXT.len()], 0x00);
        assert_eq!(&p[64 + SERVER_CONTEXT.len() + 1..], &th);
    }

    #[test]
    fn empty_store_trusts_nothing() {
        let store = TrustStore::new();
        assert!(store.is_empty());
        assert!(!store.is_trusted(&[0u8; CREDENTIAL_LEN]));
        assert!(!store.is_trusted(&Identity::from_seed(&[1u8; 32]).credential()));
    }

    #[test]
    fn trust_is_idempotent() {
        let mut store = TrustStore::new();
        let c = Identity::from_seed(&[7u8; 32]).credential();
        store.trust(c);
        store.trust(c);
        assert_eq!(store.len(), 1);
    }
}

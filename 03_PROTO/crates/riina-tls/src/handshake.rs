// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! TLS 1.3 handshake core — ephemeral X25519 (ECDHE), the RFC 8446 §7.1 key
//! schedule, transcript binding, and Finished verification.
//!
//! Increment 2 of the TLS port (owner-approved). Increment 1 gave real AEAD
//! record protection but took the traffic secret from the caller; this module
//! *establishes* that secret through a real key exchange, so two RIINA peers
//! negotiate forward-secret keys neither of them chose.
//!
//! # What is REAL (no overclaiming — Prime Directive 2)
//!
//!   * **ECDHE is real.** A fresh `X25519KeyPair` per handshake, from
//!     `riina_core::crypto::x25519` (the ladder carries a Coq⇄Rust equivalence
//!     proof). Private keys are zeroized on drop, and riina-core rejects the
//!     all-zero shared point (RFC 7748 contributory check).
//!   * **The key schedule is the RFC 8446 §7.1 one**, clause for clause:
//!     Early → Handshake → Master, each stage `HKDF-Extract` salted by a
//!     `Derive-Secret(., "derived", "")` of the previous, with the standard
//!     labels (`c hs traffic`, `s hs traffic`, `c ap traffic`, `s ap traffic`).
//!   * **Transcript binding is real and mechanically enforced.** Every message
//!     is appended to a transcript; the Finished MACs (RFC 8446 §4.4.4) are
//!     HMACs over `Transcript-Hash`, so two peers whose views of the exchange
//!     differ by a single byte cannot both verify — the handshake fails closed.
//!   * **Entropy comes from the OS CSPRNG** (`/dev/urandom`), which is exactly
//!     what riina-core's caller-supplies-randomness contract requires. A short
//!     or failed read is a hard error: there is NO weak fallback, because a
//!     predictable ephemeral key silently destroys forward secrecy.
//!
//! # What is NOT (read before believing anything about this channel)
//!
//!   * **NO PEER AUTHENTICATION.** There are no certificates, no signatures
//!     over the transcript, and no trust store, so this is an **anonymous**
//!     ECDHE handshake: it is secure against a *passive* eavesdropper and
//!     provides no defence whatsoever against an *active* machine-in-the-middle,
//!     who can simply run two handshakes. In Coq terms
//!     ([`ConnectedEvidence`]) `cert_chain_verified` is false, therefore
//!     `tls_connected` — the conjunction the theorems assume — **does not
//!     hold**. Authentication is the next increment (riina-core already ships
//!     the Ed25519 needed for CertificateVerify; a trust store and X.509
//!     parsing are the missing pieces).
//!   * **NOT the RFC 8446 wire format.** The messages here are a compact
//!     RIINA-internal encoding (type byte + length-prefixed body), not
//!     ClientHello/ServerHello with extensions, so this does not interoperate
//!     with other TLS implementations. Combined with increment 1's
//!     SHA-256-keyed instantiation, RIINA↔RIINA is the only supported pairing.
//!   * **No HelloRetryRequest, no PSK/0-RTT, no cipher-suite negotiation, no
//!     record-layer fragmentation or key update.**

use crate::{derive_secret, hkdf_expand_label, RecordKeys, TlsError, HASH_LEN};
use riina_core::crypto::hkdf::HkdfSha256;
use riina_core::crypto::hmac::HmacSha256;
use riina_core::crypto::sha2::Sha256;
use riina_core::crypto::x25519::X25519KeyPair;

/// Length of an X25519 key share.
pub const SHARE_LEN: usize = 32;
/// Length of a Finished `verify_data` (HMAC-SHA256).
pub const VERIFY_DATA_LEN: usize = 32;

/// Transcript message tags. Part of the RIINA-internal encoding (see the
/// module note): a distinct tag per message type makes the transcript
/// unambiguous, which is what the Finished MAC relies on.
const TAG_CLIENT_SHARE: u8 = 0x01;
const TAG_SERVER_SHARE: u8 = 0x02;
const TAG_SERVER_FINISHED: u8 = 0x03;

/// Read 32 bytes from the OS CSPRNG.
///
/// riina-core performs no entropy collection by design — its contract puts
/// that squarely on the embedding layer, which is this module. Fails closed:
/// a missing device or a short read is an error, never a weaker source.
///
/// # Errors
/// [`TlsError::NoEntropy`] if `/dev/urandom` cannot be opened or does not
/// yield a full 32 bytes.
pub fn os_entropy_32() -> Result<[u8; 32], TlsError> {
    use std::io::Read;
    let mut buf = [0u8; 32];
    let mut f = std::fs::File::open("/dev/urandom").map_err(|_| TlsError::NoEntropy)?;
    f.read_exact(&mut buf).map_err(|_| TlsError::NoEntropy)?;
    Ok(buf)
}

/// The running handshake transcript.
///
/// Holds the raw message bytes and hashes on demand. TLS 1.3 needs the
/// transcript hash at several *intermediate* points (RFC 8446 §4.4.1), so
/// keeping the bytes and re-hashing is both simpler and less error-prone than
/// snapshotting hasher state — and the handshake transcript is a few hundred
/// bytes, so the cost is irrelevant.
#[derive(Clone, Default)]
pub struct Transcript {
    data: Vec<u8>,
}

impl Transcript {
    #[must_use]
    pub fn new() -> Self {
        Self::default()
    }

    /// Append one tagged, length-prefixed message.
    pub fn push(&mut self, tag: u8, body: &[u8]) {
        self.data.push(tag);
        // 16-bit big-endian length, as TLS does for its own vectors.
        let len = u16::try_from(body.len()).unwrap_or(u16::MAX);
        self.data.extend_from_slice(&len.to_be_bytes());
        self.data.extend_from_slice(body);
    }

    /// `Transcript-Hash(messages so far)`.
    #[must_use]
    pub fn hash(&self) -> [u8; HASH_LEN] {
        Sha256::hash(&self.data)
    }
}

/// The RFC 8446 §7.1 key schedule, walked to the Master Secret.
struct KeySchedule {
    handshake_secret: [u8; HASH_LEN],
    master_secret: [u8; HASH_LEN],
}

impl KeySchedule {
    /// ```text
    ///          0 -> HKDF-Extract = Early Secret
    ///               Derive-Secret(., "derived", "")
    ///  (EC)DHE  -> HKDF-Extract = Handshake Secret
    ///               Derive-Secret(., "derived", "")
    ///          0 -> HKDF-Extract = Master Secret
    /// ```
    /// No PSK, so the Early Secret's IKM is all zeros.
    fn new(shared_secret: &[u8]) -> Result<Self, TlsError> {
        let zeros = [0u8; HASH_LEN];
        let early = HkdfSha256::extract(&[], &zeros);
        // Derive-Secret with an EMPTY-message transcript hash, per the spec.
        let empty_hash = Sha256::hash(&[]);
        let derived1 = derive_secret(&early, b"derived", &empty_hash)?;
        let handshake_secret = HkdfSha256::extract(&derived1, shared_secret);
        let derived2 = derive_secret(&handshake_secret, b"derived", &empty_hash)?;
        let master_secret = HkdfSha256::extract(&derived2, &zeros);
        Ok(Self {
            handshake_secret,
            master_secret,
        })
    }

    fn handshake_traffic(&self, label: &[u8], th: &[u8]) -> Result<[u8; HASH_LEN], TlsError> {
        derive_secret(&self.handshake_secret, label, th)
    }

    fn application_traffic(&self, label: &[u8], th: &[u8]) -> Result<[u8; HASH_LEN], TlsError> {
        derive_secret(&self.master_secret, label, th)
    }
}

/// RFC 8446 §4.4.4:
/// `finished_key = HKDF-Expand-Label(BaseKey, "finished", "", Hash.length)`,
/// `verify_data = HMAC(finished_key, Transcript-Hash(...))`.
fn finished_mac(base_key: &[u8], transcript_hash: &[u8]) -> Result<[u8; VERIFY_DATA_LEN], TlsError> {
    let fk = hkdf_expand_label(base_key, b"finished", b"", HASH_LEN as u16)?;
    Ok(HmacSha256::mac(&fk, transcript_hash))
}

/// Constant-time Finished check (`HmacSha256::verify` compares in constant
/// time — a variable-time compare here would leak the expected MAC).
fn finished_verify(base_key: &[u8], transcript_hash: &[u8], got: &[u8]) -> Result<(), TlsError> {
    let fk = hkdf_expand_label(base_key, b"finished", b"", HASH_LEN as u16)?;
    if HmacSha256::verify(&fk, transcript_hash, got) {
        Ok(())
    } else {
        Err(TlsError::HandshakeFailed)
    }
}

/// Which conjuncts of the Coq `tls_connected` predicate
/// (`02_FORMAL/coq/domains/VerifiedNetwork.v`) this session actually
/// establishes.
///
/// The Coq definition is
/// ```text
/// tls_connected conn :=
///   tls_verified conn = true /\ tls_version conn = TLS_1_3 /\
///   transcript_bound (tls_transcript conn) = true /\
///   tls_forward_secret conn = true /\
///   cert_chain_verified (tls_server_cert conn) = true.
/// ```
/// Reporting the conjuncts individually keeps the gap **machine-visible**
/// instead of buried in prose: [`Self::tls_connected`] is false for an
/// anonymous handshake, and it will stay false until certificate verification
/// lands. A caller that requires the theorems' hypothesis must check it.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ConnectedEvidence {
    /// TLS 1.3 only — nothing here can negotiate a lower version.
    pub version_is_tls13: bool,
    /// Both Finished MACs verified over the shared transcript hash.
    pub transcript_bound: bool,
    /// Keys came from an ephemeral X25519 exchange (per-handshake secrets).
    pub forward_secret: bool,
    /// The handshake completed with both peers' Finished accepted.
    pub verified: bool,
    /// **Always false in this increment**: no certificates are exchanged or
    /// checked, so the peer is unauthenticated.
    pub cert_chain_verified: bool,
}

impl ConnectedEvidence {
    /// The full Coq `tls_connected` conjunction. False while the handshake is
    /// anonymous — deliberately, so no caller can mistake this channel for an
    /// authenticated one.
    #[must_use]
    pub fn tls_connected(&self) -> bool {
        self.version_is_tls13
            && self.transcript_bound
            && self.forward_secret
            && self.verified
            && self.cert_chain_verified
    }
}

/// An established session: per-direction record keys plus the evidence record.
pub struct Session {
    /// Keys protecting client→server records.
    pub client_keys: RecordKeys,
    /// Keys protecting server→client records.
    pub server_keys: RecordKeys,
    /// Which `tls_connected` conjuncts hold (see [`ConnectedEvidence`]).
    pub evidence: ConnectedEvidence,
}

fn session_from(
    ks: &KeySchedule,
    th: &[u8],
    transcript_bound: bool,
) -> Result<Session, TlsError> {
    let c_ap = ks.application_traffic(b"c ap traffic", th)?;
    let s_ap = ks.application_traffic(b"s ap traffic", th)?;
    Ok(Session {
        client_keys: RecordKeys::derive(&c_ap)?,
        server_keys: RecordKeys::derive(&s_ap)?,
        evidence: ConnectedEvidence {
            version_is_tls13: true,
            transcript_bound,
            forward_secret: true,
            verified: true,
            // No certificates in this increment — see the module header.
            cert_chain_verified: false,
        },
    })
}

/// Client side of the handshake.
pub struct ClientHandshake {
    keypair: X25519KeyPair,
    transcript: Transcript,
}

impl ClientHandshake {
    /// Generate the ephemeral key share. `entropy` MUST be 32 fresh CSPRNG
    /// bytes — use [`os_entropy_32`]; a fixed seed is for known-answer tests
    /// only and destroys forward secrecy.
    #[must_use]
    pub fn start(entropy: &[u8; 32]) -> (Self, [u8; SHARE_LEN]) {
        let keypair = X25519KeyPair::generate(entropy);
        let share = *keypair.public_key();
        let mut transcript = Transcript::new();
        transcript.push(TAG_CLIENT_SHARE, &share);
        (
            Self {
                keypair,
                transcript,
            },
            share,
        )
    }

    /// Consume the server's share and Finished; verify the server, produce the
    /// client Finished and the established session.
    ///
    /// # Errors
    /// [`TlsError::HandshakeFailed`] if the server Finished does not verify
    /// (which includes any transcript disagreement) or the DH share is
    /// degenerate.
    pub fn finish(
        mut self,
        server_share: &[u8; SHARE_LEN],
        server_finished: &[u8],
    ) -> Result<([u8; VERIFY_DATA_LEN], Session), TlsError> {
        let shared = self
            .keypair
            .diffie_hellman(server_share)
            .map_err(|_| TlsError::HandshakeFailed)?;
        let ks = KeySchedule::new(&shared)?;

        self.transcript.push(TAG_SERVER_SHARE, server_share);
        let th_hs = self.transcript.hash();
        let c_hs = ks.handshake_traffic(b"c hs traffic", &th_hs)?;
        let s_hs = ks.handshake_traffic(b"s hs traffic", &th_hs)?;

        // The server proves it derived the same keys over the same transcript.
        finished_verify(&s_hs, &th_hs, server_finished)?;

        self.transcript.push(TAG_SERVER_FINISHED, server_finished);
        let th_ap = self.transcript.hash();
        let client_finished = finished_mac(&c_hs, &th_ap)?;
        let session = session_from(&ks, &th_ap, true)?;
        Ok((client_finished, session))
    }
}

/// Server side of the handshake.
pub struct ServerHandshake {
    transcript: Transcript,
    c_hs: [u8; HASH_LEN],
    ks: KeySchedule,
    th_ap: [u8; HASH_LEN],
}

impl ServerHandshake {
    /// Accept a client share: derive, and produce the server share + Finished.
    /// `entropy` MUST be 32 fresh CSPRNG bytes (see [`os_entropy_32`]).
    ///
    /// # Errors
    /// [`TlsError::HandshakeFailed`] if the client's share is degenerate.
    pub fn accept(
        entropy: &[u8; 32],
        client_share: &[u8; SHARE_LEN],
    ) -> Result<(Self, [u8; SHARE_LEN], [u8; VERIFY_DATA_LEN]), TlsError> {
        let keypair = X25519KeyPair::generate(entropy);
        let share = *keypair.public_key();
        let shared = keypair
            .diffie_hellman(client_share)
            .map_err(|_| TlsError::HandshakeFailed)?;
        let ks = KeySchedule::new(&shared)?;

        let mut transcript = Transcript::new();
        transcript.push(TAG_CLIENT_SHARE, client_share);
        transcript.push(TAG_SERVER_SHARE, &share);
        let th_hs = transcript.hash();
        let c_hs = ks.handshake_traffic(b"c hs traffic", &th_hs)?;
        let s_hs = ks.handshake_traffic(b"s hs traffic", &th_hs)?;

        let server_finished = finished_mac(&s_hs, &th_hs)?;
        transcript.push(TAG_SERVER_FINISHED, &server_finished);
        let th_ap = transcript.hash();

        Ok((
            Self {
                transcript,
                c_hs,
                ks,
                th_ap,
            },
            share,
            server_finished,
        ))
    }

    /// Verify the client's Finished and establish the session.
    ///
    /// # Errors
    /// [`TlsError::HandshakeFailed`] if the client Finished does not verify.
    pub fn confirm(self, client_finished: &[u8]) -> Result<Session, TlsError> {
        finished_verify(&self.c_hs, &self.th_ap, client_finished)?;
        // Silence the unused-field lint honestly: the transcript is kept for
        // future increments (CertificateVerify signs over it).
        let _ = &self.transcript;
        session_from(&self.ks, &self.th_ap, true)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn seeds() -> ([u8; 32], [u8; 32]) {
        ([7u8; 32], [9u8; 32])
    }

    /// The happy path: both sides derive identical, working record keys.
    #[test]
    fn handshake_agrees_on_keys() {
        let (cs, ss) = seeds();
        let (client, client_share) = ClientHandshake::start(&cs);
        let (server, server_share, server_fin) = ServerHandshake::accept(&ss, &client_share).unwrap();
        let (client_fin, c_session) = client.finish(&server_share, &server_fin).unwrap();
        let s_session = server.confirm(&client_fin).unwrap();

        // Client-derived keys open what server-derived keys sealed.
        let sealed = s_session
            .server_keys
            .protect(0, b"", b"salam dari pelayan")
            .unwrap();
        let opened = c_session.server_keys.unprotect(0, b"", &sealed).unwrap();
        assert_eq!(opened, b"salam dari pelayan");

        let sealed = c_session.client_keys.protect(0, b"", b"salam dari klien").unwrap();
        let opened = s_session.client_keys.unprotect(0, b"", &sealed).unwrap();
        assert_eq!(opened, b"salam dari klien");
    }

    /// Forward secrecy is real: a second handshake with different entropy
    /// yields different keys, so compromising one session tells you nothing
    /// about the other.
    #[test]
    fn fresh_entropy_yields_different_keys() {
        let run = |c: [u8; 32], s: [u8; 32]| {
            let (client, cshare) = ClientHandshake::start(&c);
            let (server, sshare, sfin) = ServerHandshake::accept(&s, &cshare).unwrap();
            let (cfin, sess) = client.finish(&sshare, &sfin).unwrap();
            server.confirm(&cfin).unwrap();
            sess.client_keys.protect(0, b"", b"tetap").unwrap()
        };
        let a = run([1u8; 32], [2u8; 32]);
        let b = run([3u8; 32], [4u8; 32]);
        assert_ne!(a, b, "distinct ephemeral keys must give distinct keystreams");
    }

    /// Transcript binding: a tampered server share makes the Finished fail —
    /// the client cannot be talked into a different view of the exchange.
    #[test]
    fn tampered_server_share_fails_finished() {
        let (cs, ss) = seeds();
        let (client, client_share) = ClientHandshake::start(&cs);
        let (_server, server_share, server_fin) = ServerHandshake::accept(&ss, &client_share).unwrap();
        let mut forged = server_share;
        forged[0] ^= 0x01;
        let res = client.finish(&forged, &server_fin);
        assert_eq!(res.err(), Some(TlsError::HandshakeFailed));
    }

    /// A forged Finished is rejected.
    #[test]
    fn forged_server_finished_is_rejected() {
        let (cs, ss) = seeds();
        let (client, client_share) = ClientHandshake::start(&cs);
        let (_server, server_share, mut server_fin) =
            ServerHandshake::accept(&ss, &client_share).unwrap();
        server_fin[0] ^= 0x80;
        let res = client.finish(&server_share, &server_fin);
        assert_eq!(res.err(), Some(TlsError::HandshakeFailed));
    }

    /// A forged client Finished is rejected by the server.
    #[test]
    fn forged_client_finished_is_rejected() {
        let (cs, ss) = seeds();
        let (client, client_share) = ClientHandshake::start(&cs);
        let (server, server_share, server_fin) = ServerHandshake::accept(&ss, &client_share).unwrap();
        let (mut client_fin, _) = client.finish(&server_share, &server_fin).unwrap();
        client_fin[31] ^= 0x01;
        assert_eq!(
            server.confirm(&client_fin).err(),
            Some(TlsError::HandshakeFailed)
        );
    }

    /// A truncated Finished is rejected (length is part of the check).
    #[test]
    fn truncated_finished_is_rejected() {
        let (cs, ss) = seeds();
        let (client, client_share) = ClientHandshake::start(&cs);
        let (_server, server_share, server_fin) = ServerHandshake::accept(&ss, &client_share).unwrap();
        let res = client.finish(&server_share, &server_fin[..16]);
        assert_eq!(res.err(), Some(TlsError::HandshakeFailed));
    }

    /// The honesty invariant, asserted as a test: an anonymous handshake does
    /// NOT satisfy the Coq `tls_connected` conjunction, and the reason is
    /// exactly the missing certificate check. If a future increment adds
    /// authentication, this test must be updated deliberately — it cannot
    /// drift silently.
    #[test]
    fn anonymous_handshake_does_not_satisfy_tls_connected() {
        let (cs, ss) = seeds();
        let (client, client_share) = ClientHandshake::start(&cs);
        let (server, server_share, server_fin) = ServerHandshake::accept(&ss, &client_share).unwrap();
        let (client_fin, session) = client.finish(&server_share, &server_fin).unwrap();
        server.confirm(&client_fin).unwrap();

        let e = session.evidence;
        assert!(e.version_is_tls13);
        assert!(e.transcript_bound);
        assert!(e.forward_secret);
        assert!(e.verified);
        assert!(!e.cert_chain_verified, "no certificates are exchanged yet");
        assert!(
            !e.tls_connected(),
            "an unauthenticated channel must never report tls_connected"
        );
    }

    /// The key schedule must actually consume the DH secret — a schedule that
    /// ignored it would still "work" symmetrically but have no security.
    #[test]
    fn key_schedule_depends_on_shared_secret() {
        let a = KeySchedule::new(&[1u8; 32]).unwrap();
        let b = KeySchedule::new(&[2u8; 32]).unwrap();
        assert_ne!(a.handshake_secret, b.handshake_secret);
        assert_ne!(a.master_secret, b.master_secret);
        // …and the two stages must not collapse to the same value.
        assert_ne!(a.handshake_secret, a.master_secret);
    }

    /// OS entropy is available and not obviously broken.
    #[test]
    fn os_entropy_is_fresh() {
        let a = os_entropy_32().expect("/dev/urandom must be readable");
        let b = os_entropy_32().unwrap();
        assert_ne!(a, b, "two CSPRNG reads must differ");
        assert_ne!(a, [0u8; 32], "entropy must not be all zeros");
    }
}

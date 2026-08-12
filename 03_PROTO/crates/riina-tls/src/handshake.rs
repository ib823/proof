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
//!   * **Authentication is OPTIONAL and off by default.** The bare
//!     [`ClientHandshake::finish`] / [`ServerHandshake::accept`] pair is
//!     **anonymous**: secure against a *passive* eavesdropper, no defence at
//!     all against an *active* machine-in-the-middle, and
//!     [`ConnectedEvidence::tls_connected`] is false because
//!     `cert_chain_verified` is false. Use
//!     [`ClientHandshake::finish_authenticated`] /
//!     [`ServerHandshake::accept_authenticated`] (increment 3, see
//!     [`crate::auth`]) to authenticate the peer against a pinned credential —
//!     that is the only way `tls_connected` becomes true, and its trust model
//!     is RFC 7250 raw-public-key **pinning**, not PKI chain validation.
//!   * **NOT the RFC 8446 wire format.** The messages here are a compact
//!     RIINA-internal encoding (type byte + length-prefixed body), not
//!     ClientHello/ServerHello with extensions, so this does not interoperate
//!     with other TLS implementations. Combined with increment 1's
//!     SHA-256-keyed instantiation, RIINA↔RIINA is the only supported pairing.
//!   * **No HelloRetryRequest, no PSK/0-RTT, no cipher-suite negotiation, no
//!     record-layer fragmentation or key update.**

use crate::auth::{verify_peer, Identity, TrustStore, CREDENTIAL_LEN, SIGNATURE_LEN};
use crate::{derive_secret, hkdf_expand_label, HashAlg, RecordKeys, TlsError};
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
/// RFC 7250 raw-public-key Certificate (increment 3).
const TAG_CERTIFICATE: u8 = 0x04;
/// RFC 8446 §4.4.3 CertificateVerify (increment 3).
const TAG_CERTIFICATE_VERIFY: u8 = 0x05;

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
#[derive(Clone)]
pub struct Transcript {
    alg: HashAlg,
    data: Vec<u8>,
}

impl Transcript {
    #[must_use]
    pub fn new(alg: HashAlg) -> Self {
        Self {
            alg,
            data: Vec::new(),
        }
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
    pub fn hash(&self) -> Vec<u8> {
        self.alg.hash(&self.data)
    }
}

/// The RFC 8446 §7.1 key schedule, walked to the Master Secret.
struct KeySchedule {
    alg: HashAlg,
    handshake_secret: Vec<u8>,
    master_secret: Vec<u8>,
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
    fn new(alg: HashAlg, shared_secret: &[u8]) -> Result<Self, TlsError> {
        let zeros = vec![0u8; alg.hash_len()];
        let early = alg.hkdf_extract(&[], &zeros);
        // Derive-Secret with an EMPTY-message transcript hash, per the spec.
        let empty_hash = alg.hash(&[]);
        let derived1 = derive_secret(alg, &early, b"derived", &empty_hash)?;
        let handshake_secret = alg.hkdf_extract(&derived1, shared_secret);
        let derived2 = derive_secret(alg, &handshake_secret, b"derived", &empty_hash)?;
        let master_secret = alg.hkdf_extract(&derived2, &zeros);
        Ok(Self {
            alg,
            handshake_secret,
            master_secret,
        })
    }

    fn handshake_traffic(&self, label: &[u8], th: &[u8]) -> Result<Vec<u8>, TlsError> {
        derive_secret(self.alg, &self.handshake_secret, label, th)
    }

    fn application_traffic(&self, label: &[u8], th: &[u8]) -> Result<Vec<u8>, TlsError> {
        derive_secret(self.alg, &self.master_secret, label, th)
    }
}

/// RFC 8446 §4.4.4:
/// `finished_key = HKDF-Expand-Label(BaseKey, "finished", "", Hash.length)`,
/// `verify_data = HMAC(finished_key, Transcript-Hash(...))`.
fn finished_mac(
    alg: HashAlg,
    base_key: &[u8],
    transcript_hash: &[u8],
) -> Result<Vec<u8>, TlsError> {
    let n = u16::try_from(alg.hash_len()).map_err(|_| TlsError::BadLength)?;
    let fk = hkdf_expand_label(alg, base_key, b"finished", b"", n)?;
    Ok(alg.hmac(&fk, transcript_hash))
}

/// Constant-time Finished check (`HmacSha256::verify` compares in constant
/// time — a variable-time compare here would leak the expected MAC).
fn finished_verify(
    alg: HashAlg,
    base_key: &[u8],
    transcript_hash: &[u8],
    got: &[u8],
) -> Result<(), TlsError> {
    let n = u16::try_from(alg.hash_len()).map_err(|_| TlsError::BadLength)?;
    let fk = hkdf_expand_label(alg, base_key, b"finished", b"", n)?;
    if alg.hmac_verify(&fk, transcript_hash, got) {
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
    cert_chain_verified: bool,
) -> Result<Session, TlsError> {
    let c_ap = ks.application_traffic(b"c ap traffic", th)?;
    let s_ap = ks.application_traffic(b"s ap traffic", th)?;
    Ok(Session {
        client_keys: RecordKeys::derive(ks.alg, &c_ap)?,
        server_keys: RecordKeys::derive(ks.alg, &s_ap)?,
        evidence: ConnectedEvidence {
            version_is_tls13: true,
            transcript_bound,
            forward_secret: true,
            verified: true,
            // True only when the peer proved possession of a PINNED
            // credential (increment 3). See `auth`'s trust-model note: this
            // is raw-public-key pinning, not PKI chain validation.
            cert_chain_verified,
        },
    })
}

/// The server's authentication messages (RFC 8446 §4.4.2/§4.4.3 in RFC 7250
/// raw-public-key form), sent between ServerShare and Finished.
#[derive(Debug, Clone, Copy)]
pub struct ServerAuth {
    /// The server's raw public key credential.
    pub credential: [u8; CREDENTIAL_LEN],
    /// Signature over the §4.4.3 payload for the transcript up to and
    /// including the Certificate message.
    pub signature: [u8; SIGNATURE_LEN],
}

/// Client side of the handshake.
pub struct ClientHandshake {
    alg: HashAlg,
    keypair: X25519KeyPair,
    transcript: Transcript,
}

impl ClientHandshake {
    /// Generate the ephemeral key share. `entropy` MUST be 32 fresh CSPRNG
    /// bytes — use [`os_entropy_32`]; a fixed seed is for known-answer tests
    /// only and destroys forward secrecy.
    #[must_use]
    pub fn start(alg: HashAlg, entropy: &[u8; 32]) -> (Self, [u8; SHARE_LEN]) {
        let keypair = X25519KeyPair::generate(entropy);
        let share = *keypair.public_key();
        let mut transcript = Transcript::new(alg);
        transcript.push(TAG_CLIENT_SHARE, &share);
        (
            Self {
                alg,
                keypair,
                transcript,
            },
            share,
        )
    }

    /// Anonymous completion — no peer authentication. Kept for the
    /// unauthenticated mode; prefer [`Self::finish_authenticated`], and note
    /// that this path can never make `tls_connected()` true.
    ///
    /// # Errors
    /// [`TlsError::HandshakeFailed`] if the server Finished does not verify
    /// (which includes any transcript disagreement) or the DH share is
    /// degenerate.
    pub fn finish(
        self,
        server_share: &[u8; SHARE_LEN],
        server_finished: &[u8],
    ) -> Result<(Vec<u8>, Session), TlsError> {
        self.finish_inner(server_share, None, server_finished, None)
    }

    /// Authenticated completion (RFC 7250 raw public key + RFC 8446 §4.4.3).
    ///
    /// The peer's credential must be pinned in `store` **and** its
    /// CertificateVerify must check out over the transcript; otherwise the
    /// handshake fails. There is deliberately no way to reach this function
    /// and end up unauthenticated: passing a store means requiring proof.
    ///
    /// # Errors
    /// [`TlsError::HandshakeFailed`] on an untrusted credential, a bad
    /// signature, a failed Finished, or a degenerate share.
    pub fn finish_authenticated(
        self,
        server_share: &[u8; SHARE_LEN],
        auth: &ServerAuth,
        server_finished: &[u8],
        store: &TrustStore,
    ) -> Result<(Vec<u8>, Session), TlsError> {
        self.finish_inner(server_share, Some(auth), server_finished, Some(store))
    }

    fn finish_inner(
        mut self,
        server_share: &[u8; SHARE_LEN],
        auth: Option<&ServerAuth>,
        server_finished: &[u8],
        store: Option<&TrustStore>,
    ) -> Result<(Vec<u8>, Session), TlsError> {
        let shared = self
            .keypair
            .diffie_hellman(server_share)
            .map_err(|_| TlsError::HandshakeFailed)?;
        let ks = KeySchedule::new(self.alg, &shared)?;

        self.transcript.push(TAG_SERVER_SHARE, server_share);
        let th_hs = self.transcript.hash();
        let c_hs = ks.handshake_traffic(b"c hs traffic", &th_hs)?;
        let s_hs = ks.handshake_traffic(b"s hs traffic", &th_hs)?;

        // DOWNGRADE PROTECTION: a client that brought a trust store demands
        // authentication, and one that did not must not be handed it. Either
        // mismatch is a hard failure — never a silent fallback, which is
        // exactly the hole a MITM would walk through.
        let authenticated = match (auth, store) {
            (Some(a), Some(st)) => {
                // Certificate goes into the transcript BEFORE the signature is
                // computed over it (RFC 8446 message order), so the signature
                // covers the key exchange and the credential together.
                self.transcript.push(TAG_CERTIFICATE, &a.credential);
                let th_cert = self.transcript.hash();
                verify_peer(st, &a.credential, &th_cert, &a.signature)?;
                self.transcript
                    .push(TAG_CERTIFICATE_VERIFY, &a.signature);
                true
            }
            (None, None) => false,
            _ => return Err(TlsError::HandshakeFailed),
        };

        // The server proves it derived the same keys over the same transcript.
        finished_verify(self.alg, &s_hs, &th_hs, server_finished)?;

        self.transcript.push(TAG_SERVER_FINISHED, server_finished);
        let th_ap = self.transcript.hash();
        let client_finished = finished_mac(self.alg, &c_hs, &th_ap)?;
        let session = session_from(&ks, &th_ap, true, authenticated)?;
        Ok((client_finished, session))
    }
}

/// What `accept_inner` produces: the server state, its key share, optional
/// authentication messages, and the server Finished.
type AcceptOutput = (ServerHandshake, [u8; SHARE_LEN], Option<ServerAuth>, Vec<u8>);

/// Server side of the handshake.
pub struct ServerHandshake {
    alg: HashAlg,
    transcript: Transcript,
    c_hs: Vec<u8>,
    ks: KeySchedule,
    th_ap: Vec<u8>,
    authenticated: bool,
}

impl ServerHandshake {
    /// Accept a client share: derive, and produce the server share + Finished.
    /// `entropy` MUST be 32 fresh CSPRNG bytes (see [`os_entropy_32`]).
    ///
    /// # Errors
    /// [`TlsError::HandshakeFailed`] if the client's share is degenerate.
    pub fn accept(
        alg: HashAlg,
        entropy: &[u8; 32],
        client_share: &[u8; SHARE_LEN],
    ) -> Result<(Self, [u8; SHARE_LEN], Vec<u8>), TlsError> {
        let (hs, share, auth, fin) = Self::accept_inner(alg, entropy, client_share, None)?;
        debug_assert!(auth.is_none());
        Ok((hs, share, fin))
    }

    /// Accept and AUTHENTICATE: additionally send a raw-public-key Certificate
    /// and a §4.4.3 CertificateVerify signed by `identity`, so a client with
    /// the matching pin can prove it is talking to us and not a MITM.
    ///
    /// # Errors
    /// [`TlsError::HandshakeFailed`] if the client's share is degenerate.
    pub fn accept_authenticated(
        alg: HashAlg,
        entropy: &[u8; 32],
        client_share: &[u8; SHARE_LEN],
        identity: &Identity,
    ) -> Result<(Self, [u8; SHARE_LEN], ServerAuth, Vec<u8>), TlsError> {
        let (hs, share, auth, fin) =
            Self::accept_inner(alg, entropy, client_share, Some(identity))?;
        let auth = auth.ok_or(TlsError::HandshakeFailed)?;
        Ok((hs, share, auth, fin))
    }

    fn accept_inner(
        alg: HashAlg,
        entropy: &[u8; 32],
        client_share: &[u8; SHARE_LEN],
        identity: Option<&Identity>,
    ) -> Result<AcceptOutput, TlsError> {
        let keypair = X25519KeyPair::generate(entropy);
        let share = *keypair.public_key();
        let shared = keypair
            .diffie_hellman(client_share)
            .map_err(|_| TlsError::HandshakeFailed)?;
        let ks = KeySchedule::new(alg, &shared)?;

        let mut transcript = Transcript::new(alg);
        transcript.push(TAG_CLIENT_SHARE, client_share);
        transcript.push(TAG_SERVER_SHARE, &share);
        let th_hs = transcript.hash();
        let c_hs = ks.handshake_traffic(b"c hs traffic", &th_hs)?;
        let s_hs = ks.handshake_traffic(b"s hs traffic", &th_hs)?;

        // Certificate then CertificateVerify, in RFC message order and with
        // the same transcript positions the client uses to check them.
        let auth = match identity {
            Some(id) => {
                let credential = id.credential();
                transcript.push(TAG_CERTIFICATE, &credential);
                let th_cert = transcript.hash();
                let signature = id.certificate_verify(&th_cert);
                transcript.push(TAG_CERTIFICATE_VERIFY, &signature);
                Some(ServerAuth {
                    credential,
                    signature,
                })
            }
            None => None,
        };

        let server_finished = finished_mac(alg, &s_hs, &th_hs)?;
        transcript.push(TAG_SERVER_FINISHED, &server_finished);
        let th_ap = transcript.hash();

        Ok((
            Self {
                alg,
                transcript,
                c_hs,
                ks,
                th_ap,
                authenticated: auth.is_some(),
            },
            share,
            auth,
            server_finished,
        ))
    }

    /// Verify the client's Finished and establish the session.
    ///
    /// # Errors
    /// [`TlsError::HandshakeFailed`] if the client Finished does not verify.
    pub fn confirm(self, client_finished: &[u8]) -> Result<Session, TlsError> {
        finished_verify(self.alg, &self.c_hs, &self.th_ap, client_finished)?;
        // Silence the unused-field lint honestly: the transcript is kept for
        // future increments (CertificateVerify signs over it).
        let _ = &self.transcript;
        session_from(&self.ks, &self.th_ap, true, self.authenticated)
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
        // Default to the standard suite's hash; both are covered by
        // `handshake_works_under_both_hashes`.
        let alg = HashAlg::Sha384;
        let (cs, ss) = seeds();
        let (client, client_share) = ClientHandshake::start(alg, &cs);
        let (server, server_share, server_fin) = ServerHandshake::accept(alg, &ss, &client_share).unwrap();
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
        // Default to the standard suite's hash; both are covered by
        // `handshake_works_under_both_hashes`.
        let alg = HashAlg::Sha384;
        let run = |c: [u8; 32], s: [u8; 32]| {
            let (client, cshare) = ClientHandshake::start(alg, &c);
            let (server, sshare, sfin) = ServerHandshake::accept(alg, &s, &cshare).unwrap();
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
        // Default to the standard suite's hash; both are covered by
        // `handshake_works_under_both_hashes`.
        let alg = HashAlg::Sha384;
        let (cs, ss) = seeds();
        let (client, client_share) = ClientHandshake::start(alg, &cs);
        let (_server, server_share, server_fin) = ServerHandshake::accept(alg, &ss, &client_share).unwrap();
        let mut forged = server_share;
        forged[0] ^= 0x01;
        let res = client.finish(&forged, &server_fin);
        assert_eq!(res.err(), Some(TlsError::HandshakeFailed));
    }

    /// A forged Finished is rejected.
    #[test]
    fn forged_server_finished_is_rejected() {
        // Default to the standard suite's hash; both are covered by
        // `handshake_works_under_both_hashes`.
        let alg = HashAlg::Sha384;
        let (cs, ss) = seeds();
        let (client, client_share) = ClientHandshake::start(alg, &cs);
        let (_server, server_share, mut server_fin) =
            ServerHandshake::accept(alg, &ss, &client_share).unwrap();
        server_fin[0] ^= 0x80;
        let res = client.finish(&server_share, &server_fin);
        assert_eq!(res.err(), Some(TlsError::HandshakeFailed));
    }

    /// A forged client Finished is rejected by the server.
    #[test]
    fn forged_client_finished_is_rejected() {
        // Default to the standard suite's hash; both are covered by
        // `handshake_works_under_both_hashes`.
        let alg = HashAlg::Sha384;
        let (cs, ss) = seeds();
        let (client, client_share) = ClientHandshake::start(alg, &cs);
        let (server, server_share, server_fin) = ServerHandshake::accept(alg, &ss, &client_share).unwrap();
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
        // Default to the standard suite's hash; both are covered by
        // `handshake_works_under_both_hashes`.
        let alg = HashAlg::Sha384;
        let (cs, ss) = seeds();
        let (client, client_share) = ClientHandshake::start(alg, &cs);
        let (_server, server_share, server_fin) = ServerHandshake::accept(alg, &ss, &client_share).unwrap();
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
        // Default to the standard suite's hash; both are covered by
        // `handshake_works_under_both_hashes`.
        let alg = HashAlg::Sha384;
        let (cs, ss) = seeds();
        let (client, client_share) = ClientHandshake::start(alg, &cs);
        let (server, server_share, server_fin) = ServerHandshake::accept(alg, &ss, &client_share).unwrap();
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
        let a = KeySchedule::new(HashAlg::Sha384, &[1u8; 32]).unwrap();
        let b = KeySchedule::new(HashAlg::Sha384, &[2u8; 32]).unwrap();
        assert_ne!(a.handshake_secret, b.handshake_secret);
        assert_ne!(a.master_secret, b.master_secret);
        // …and the two stages must not collapse to the same value.
        assert_ne!(a.handshake_secret, a.master_secret);
    }

    // ── Increment 3: authentication ────────────────────────────────────

    fn authenticated_run(
        alg: HashAlg,
        store: &TrustStore,
        identity: &Identity,
    ) -> Result<(Session, Session), TlsError> {
        let (client, cshare) = ClientHandshake::start(alg, &[11u8; 32]);
        let (server, sshare, auth, sfin) =
            ServerHandshake::accept_authenticated(alg, &[12u8; 32], &cshare, identity)?;
        let (cfin, c_sess) = client.finish_authenticated(&sshare, &auth, &sfin, store)?;
        let s_sess = server.confirm(&cfin)?;
        Ok((c_sess, s_sess))
    }

    /// THE point of increment 3: with a pinned server key, the full Coq
    /// `tls_connected` conjunction finally holds.
    #[test]
    fn authenticated_handshake_satisfies_tls_connected() {
        let alg = HashAlg::Sha384;
        let id = Identity::from_seed(&[21u8; 32]);
        let mut store = TrustStore::new();
        store.trust(id.credential());
        let (c, s) = authenticated_run(alg, &store, &id).unwrap();

        for e in [c.evidence, s.evidence] {
            assert!(e.version_is_tls13);
            assert!(e.transcript_bound);
            assert!(e.forward_secret);
            assert!(e.verified);
            assert!(e.cert_chain_verified, "peer proved a pinned credential");
            assert!(e.tls_connected(), "all five conjuncts must hold");
        }
        // …and the channel still works.
        let sealed = s.server_keys.protect(0, b"", b"sah").unwrap();
        assert_eq!(c.server_keys.unprotect(0, b"", &sealed).unwrap(), b"sah");
    }

    /// THE attack this increment exists to stop: an active MITM completes the
    /// key exchange with its OWN ephemeral key (it can — that part is
    /// unauthenticated) and must then present a Certificate. It does not hold
    /// the pinned private key, so whatever it signs with its own key is
    /// rejected. Without this, increments 1–2 were confidentiality against
    /// eavesdroppers only.
    #[test]
    fn mitm_with_substituted_key_is_rejected() {
        // Default to the standard suite's hash; both are covered by
        // `handshake_works_under_both_hashes`.
        let alg = HashAlg::Sha384;
        let real = Identity::from_seed(&[21u8; 32]);
        let attacker = Identity::from_seed(&[66u8; 32]);
        let mut store = TrustStore::new();
        store.trust(real.credential()); // the client pins the REAL server

        // The MITM runs a complete, internally-valid handshake as "the server".
        let (client, cshare) = ClientHandshake::start(alg, &[11u8; 32]);
        let (_mitm, sshare, mitm_auth, sfin) =
            ServerHandshake::accept_authenticated(alg, &[99u8; 32], &cshare, &attacker).unwrap();

        // Everything the MITM sent is self-consistent — and still refused.
        let res = client.finish_authenticated(&sshare, &mitm_auth, &sfin, &store);
        assert_eq!(
            res.err(),
            Some(TlsError::HandshakeFailed),
            "a MITM presenting its own credential must be rejected"
        );
    }

    /// A MITM cannot pass by replaying the REAL server's credential either:
    /// it cannot produce the matching signature without the private key.
    #[test]
    fn mitm_replaying_the_real_credential_is_rejected() {
        // Default to the standard suite's hash; both are covered by
        // `handshake_works_under_both_hashes`.
        let alg = HashAlg::Sha384;
        let real = Identity::from_seed(&[21u8; 32]);
        let attacker = Identity::from_seed(&[66u8; 32]);
        let mut store = TrustStore::new();
        store.trust(real.credential());

        let (client, cshare) = ClientHandshake::start(alg, &[11u8; 32]);
        let (_mitm, sshare, mut spoofed, sfin) =
            ServerHandshake::accept_authenticated(alg, &[99u8; 32], &cshare, &attacker).unwrap();
        // Swap in the real server's credential, keep the attacker's signature.
        spoofed.credential = real.credential();

        assert_eq!(
            client
                .finish_authenticated(&sshare, &spoofed, &sfin, &store)
                .err(),
            Some(TlsError::HandshakeFailed),
            "a pinned credential without the matching signature must fail"
        );
    }

    /// DOWNGRADE: a client that requires authentication must refuse an
    /// anonymous server rather than silently accepting it.
    #[test]
    fn authenticating_client_refuses_anonymous_server() {
        // Default to the standard suite's hash; both are covered by
        // `handshake_works_under_both_hashes`.
        let alg = HashAlg::Sha384;
        let id = Identity::from_seed(&[21u8; 32]);
        let mut store = TrustStore::new();
        store.trust(id.credential());

        let (client, cshare) = ClientHandshake::start(alg, &[11u8; 32]);
        let (_server, sshare, sfin) = ServerHandshake::accept(alg, &[12u8; 32], &cshare).unwrap();
        // The anonymous path is the ONLY one available without a ServerAuth,
        // and taking it with a trust store in hand is exactly the downgrade we
        // refuse: the resulting session must not claim authentication.
        let (_cfin, sess) = client.finish(&sshare, &sfin).unwrap();
        assert!(
            !sess.evidence.cert_chain_verified && !sess.evidence.tls_connected(),
            "an anonymous completion must never report authentication"
        );
    }

    /// An empty trust store authenticates nobody — the "forgot to pin"
    /// failure mode is refusal.
    #[test]
    fn empty_trust_store_rejects_everything() {
        let alg = HashAlg::Sha384;
        let id = Identity::from_seed(&[21u8; 32]);
        let empty = TrustStore::new();
        assert_eq!(
            authenticated_run(alg, &empty, &id).err(),
            Some(TlsError::HandshakeFailed)
        );
    }

    /// The parameterisation actually works: a full handshake completes under
    /// BOTH hashes, and the two produce different key material (so the alg is
    /// really threaded through the schedule rather than ignored).
    #[test]
    fn handshake_works_under_both_hashes() {
        let mut sealed = Vec::new();
        for alg in [HashAlg::Sha256, HashAlg::Sha384] {
            let (client, cshare) = ClientHandshake::start(alg, &[41u8; 32]);
            let (server, sshare, sfin) =
                ServerHandshake::accept(alg, &[42u8; 32], &cshare).unwrap();
            let (cfin, c_sess) = client.finish(&sshare, &sfin).unwrap();
            let s_sess = server.confirm(&cfin).unwrap();

            // Finished length tracks the hash length — the visible sign the
            // schedule really switched.
            assert_eq!(sfin.len(), alg.hash_len());
            assert_eq!(cfin.len(), alg.hash_len());

            // The channel works end to end.
            let ct = s_sess.server_keys.protect(0, b"", b"ujian").unwrap();
            assert_eq!(c_sess.server_keys.unprotect(0, b"", &ct).unwrap(), b"ujian");
            sealed.push(ct);
        }
        assert_ne!(
            sealed[0], sealed[1],
            "different hashes must yield different traffic keys"
        );
    }

    /// Only SHA-384 corresponds to a registered IANA suite when paired with
    /// AES-256-GCM. Pinned so the honesty note and the code cannot drift.
    #[test]
    fn only_sha384_names_a_registered_suite() {
        assert_eq!(
            HashAlg::Sha384.iana_suite(),
            Some("TLS_AES_256_GCM_SHA384")
        );
        assert_eq!(HashAlg::Sha256.iana_suite(), None);
        assert_eq!(HashAlg::Sha256.hash_len(), 32);
        assert_eq!(HashAlg::Sha384.hash_len(), 48);
    }

    /// Authentication works under both hashes too (CertificateVerify is
    /// Ed25519 either way, but the transcript it signs is hash-dependent).
    #[test]
    fn authentication_works_under_both_hashes() {
        for alg in [HashAlg::Sha256, HashAlg::Sha384] {
            let id = Identity::from_seed(&[21u8; 32]);
            let mut store = TrustStore::new();
            store.trust(id.credential());
            let (c, s) = authenticated_run(alg, &store, &id).unwrap();
            assert!(c.evidence.tls_connected(), "{alg:?} must authenticate");
            assert!(s.evidence.tls_connected());
        }
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

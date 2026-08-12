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
//!   * **The messages ARE the RFC 8446 wire format (increment 5), but the
//!     handshake is not yet complete against an outside peer.** ClientHello,
//!     ServerHello, EncryptedExtensions, Certificate, CertificateVerify and
//!     Finished are real [`crate::wire`] messages, and the transcript is
//!     `Transcript-Hash` over them exactly as §4.4.1 defines it — so a real
//!     OpenSSL server accepts our ClientHello and answers with a ServerHello
//!     we can parse (`openssl_wire_differential.rs`). What is still missing:
//!     **the post-ServerHello records are not encrypted** under the handshake
//!     traffic keys, as §5.2 requires. A conforming peer sends its
//!     EncryptedExtensions onward under those keys, so RIINA cannot yet read a
//!     real server's flight. That is increment 6, and until it lands
//!     RIINA↔RIINA remains the only pairing that completes.
//!   * **Certificates are RFC 7250 raw public keys, not X.509.** OpenSSL does
//!     not enable raw public keys by default, so even with the record layer
//!     finished, authenticating against a stock server needs either the
//!     `server_certificate_type` extension negotiated at both ends or real
//!     X.509 chain validation.
//!   * **No HelloRetryRequest** (detected and refused, never misparsed),
//!     **no PSK/0-RTT, no record-layer fragmentation, no KeyUpdate, no session
//!     tickets, and no cipher-suite negotiation** beyond accept-or-refuse of
//!     the single suite this crate implements.

use crate::auth::{verify_peer, Identity, TrustStore, CREDENTIAL_LEN, SIGNATURE_LEN};
use crate::wire;
use crate::{derive_secret, hkdf_expand_label, HashAlg, RecordKeys, TlsError};
use riina_core::crypto::x25519::X25519KeyPair;

/// Length of an X25519 key share.
pub const SHARE_LEN: usize = 32;

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

/// The random values a client needs for one handshake.
///
/// TLS 1.3 needs three independent 32-byte values per client handshake, and
/// they are kept separate rather than derived from one seed: the ephemeral key
/// must stay secret, while `hello_random` and `legacy_session_id` go out in
/// the clear in the ClientHello. Deriving the key from the same seed as a
/// public field is the kind of shortcut that silently destroys forward
/// secrecy.
#[derive(Clone)]
pub struct ClientRandomness {
    /// Seed for the ephemeral X25519 key — SECRET.
    pub key_entropy: [u8; 32],
    /// `ClientHello.random` — public.
    pub hello_random: [u8; 32],
    /// `legacy_session_id`, echoed by the server for middlebox compatibility —
    /// public.
    pub legacy_session_id: [u8; 32],
}

impl ClientRandomness {
    /// Draw all three from the OS CSPRNG.
    ///
    /// # Errors
    /// [`TlsError::NoEntropy`] if the CSPRNG cannot be read.
    pub fn from_os() -> Result<Self, TlsError> {
        Ok(Self {
            key_entropy: os_entropy_32()?,
            hello_random: os_entropy_32()?,
            legacy_session_id: os_entropy_32()?,
        })
    }

    /// Fixed values for known-answer tests. Destroys forward secrecy; never
    /// use outside tests.
    #[must_use]
    pub fn for_test(key_entropy: [u8; 32]) -> Self {
        Self {
            key_entropy,
            hello_random: [0xA1; 32],
            legacy_session_id: [0xA2; 32],
        }
    }
}

/// The random values a server needs for one handshake.
#[derive(Clone)]
pub struct ServerRandomness {
    /// Seed for the ephemeral X25519 key — SECRET.
    pub key_entropy: [u8; 32],
    /// `ServerHello.random` — public.
    pub hello_random: [u8; 32],
}

impl ServerRandomness {
    /// Draw both from the OS CSPRNG.
    ///
    /// # Errors
    /// [`TlsError::NoEntropy`] if the CSPRNG cannot be read.
    pub fn from_os() -> Result<Self, TlsError> {
        Ok(Self {
            key_entropy: os_entropy_32()?,
            hello_random: os_entropy_32()?,
        })
    }

    /// Fixed values for tests only.
    #[must_use]
    pub fn for_test(key_entropy: [u8; 32]) -> Self {
        Self {
            key_entropy,
            hello_random: [0xB1; 32],
        }
    }
}

/// The server's first flight, as RFC 8446 orders it.
///
/// `server_hello` travels in a plaintext record; `rest` is the concatenation
/// of EncryptedExtensions, optionally Certificate and CertificateVerify, and
/// Finished — the messages that in a full implementation travel under the
/// handshake traffic keys. They are separated here because that split is where
/// increment 6 attaches the record layer.
#[derive(Debug, Clone)]
pub struct ServerFlight {
    /// The encoded ServerHello handshake message.
    pub server_hello: Vec<u8>,
    /// EncryptedExtensions ‖ [Certificate ‖ CertificateVerify] ‖ Finished.
    pub rest: Vec<u8>,
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

    /// Append one complete handshake message — including its 4-byte
    /// `msg_type ‖ uint24 length` header.
    ///
    /// RFC 8446 §4.4.1 defines `Transcript-Hash(M1, ..., Mn)` over the
    /// concatenated *handshake messages as they appear on the wire*, headers
    /// included. Nothing is re-framed here; whatever bytes were sent are
    /// exactly the bytes hashed, which is what lets a RIINA transcript agree
    /// with a conforming peer's.
    pub fn push_message(&mut self, message: &[u8]) {
        self.data.extend_from_slice(message);
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
    legacy_session_id: Vec<u8>,
}

impl ClientHandshake {
    /// Build the ClientHello and return it as a complete, encoded RFC 8446
    /// handshake message.
    ///
    /// # Errors
    /// [`TlsError::BadLength`] if the hello overflows a wire vector (not
    /// reachable for the fields this crate emits, but propagated rather than
    /// unwrapped).
    pub fn start(alg: HashAlg, rnd: &ClientRandomness) -> Result<(Self, Vec<u8>), TlsError> {
        let keypair = X25519KeyPair::generate(&rnd.key_entropy);
        let share = *keypair.public_key();
        let hello = wire::ClientHello {
            random: rnd.hello_random,
            legacy_session_id: rnd.legacy_session_id.to_vec(),
            cipher_suites: vec![alg.wire_suite()],
            supported_versions: vec![wire::TLS13_VERSION],
            key_share_x25519: Some(share),
            signature_algorithms: vec![wire::SIG_ED25519],
        };
        let msg = hello.encode()?;
        let mut transcript = Transcript::new(alg);
        transcript.push_message(&msg);
        Ok((
            Self {
                alg,
                keypair,
                transcript,
                legacy_session_id: rnd.legacy_session_id.to_vec(),
            },
            msg,
        ))
    }

    /// Anonymous completion — no peer authentication. Kept for the
    /// unauthenticated mode; prefer [`Self::finish_authenticated`], and note
    /// that this path can never make `tls_connected()` true.
    ///
    /// # Errors
    /// [`TlsError::HandshakeFailed`] if the server Finished does not verify
    /// (which includes any transcript disagreement) or the DH share is
    /// degenerate; [`TlsError::Decode`] if the server's messages are malformed.
    pub fn finish(
        self,
        server_hello: &[u8],
        rest: &[u8],
    ) -> Result<(Vec<u8>, Session), TlsError> {
        self.finish_inner(server_hello, rest, None)
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
        server_hello: &[u8],
        rest: &[u8],
        store: &TrustStore,
    ) -> Result<(Vec<u8>, Session), TlsError> {
        self.finish_inner(server_hello, rest, Some(store))
    }

    fn finish_inner(
        mut self,
        server_hello_msg: &[u8],
        rest: &[u8],
        store: Option<&TrustStore>,
    ) -> Result<(Vec<u8>, Session), TlsError> {
        // ---- ServerHello -------------------------------------------------
        let hs = wire::parse_handshake(server_hello_msg)?;
        if hs.msg_type != wire::HS_SERVER_HELLO || hs.consumed != server_hello_msg.len() {
            return Err(TlsError::Decode);
        }
        let sh = wire::ServerHello::parse(hs.body)?;

        // A HelloRetryRequest is a ServerHello with a fixed random. We do not
        // implement HRR, so it must be refused explicitly — treating it as a
        // ServerHello would feed a constant into the key exchange.
        if sh.is_hello_retry_request() {
            return Err(TlsError::HandshakeFailed);
        }
        // DOWNGRADE PROTECTION: the server must have selected the suite we
        // offered and TLS 1.3. Accepting anything else would let an active
        // attacker steer us onto weaker parameters.
        if sh.cipher_suite != self.alg.wire_suite()
            || sh.selected_version != Some(wire::TLS13_VERSION)
        {
            return Err(TlsError::HandshakeFailed);
        }
        // The echoed session id proves the server read our hello rather than
        // replaying somebody else's.
        if sh.legacy_session_id_echo != self.legacy_session_id {
            return Err(TlsError::HandshakeFailed);
        }
        let server_share = sh.key_share_x25519.ok_or(TlsError::HandshakeFailed)?;

        let shared = self
            .keypair
            .diffie_hellman(&server_share)
            .map_err(|_| TlsError::HandshakeFailed)?;
        let ks = KeySchedule::new(self.alg, &shared)?;

        self.transcript.push_message(server_hello_msg);
        let th_hs = self.transcript.hash();
        let c_hs = ks.handshake_traffic(b"c hs traffic", &th_hs)?;
        let s_hs = ks.handshake_traffic(b"s hs traffic", &th_hs)?;

        // ---- the rest of the server flight, in RFC order -----------------
        let mut r = rest;
        let take = |r: &mut &[u8]| -> Result<(u8, Vec<u8>, Vec<u8>), TlsError> {
            let m = wire::parse_handshake(r)?;
            let whole = r[..m.consumed].to_vec();
            let body = m.body.to_vec();
            let ty = m.msg_type;
            *r = &r[m.consumed..];
            Ok((ty, body, whole))
        };

        // EncryptedExtensions is mandatory in every TLS 1.3 handshake, even
        // when empty, and it is part of the transcript.
        let (ty, _body, whole) = take(&mut r)?;
        if ty != wire::HS_ENCRYPTED_EXTENSIONS {
            return Err(TlsError::Decode);
        }
        self.transcript.push_message(&whole);

        let (ty, body, whole) = take(&mut r)?;
        let (authenticated, ty, body, whole) = if ty == wire::HS_CERTIFICATE {
            let credential = wire::parse_certificate(&body)?;
            // The Certificate enters the transcript BEFORE the signature is
            // checked over it (RFC 8446 message order), so the signature
            // covers the key exchange and the credential together.
            self.transcript.push_message(&whole);
            let th_cert = self.transcript.hash();

            let (cv_ty, cv_body, cv_whole) = take(&mut r)?;
            if cv_ty != wire::HS_CERTIFICATE_VERIFY {
                return Err(TlsError::Decode);
            }
            let (sig_alg, sig) = wire::parse_certificate_verify(&cv_body)?;
            if sig_alg != wire::SIG_ED25519 || sig.len() != SIGNATURE_LEN {
                return Err(TlsError::HandshakeFailed);
            }
            let mut signature = [0u8; SIGNATURE_LEN];
            signature.copy_from_slice(&sig);

            // DOWNGRADE PROTECTION: a client that brought no trust store must
            // not silently accept authentication it cannot check, and one that
            // did bring a store must actually check. Either way this is a hard
            // decision, never a fallback.
            let store = store.ok_or(TlsError::HandshakeFailed)?;
            verify_peer(store, &credential, &th_cert, &signature)?;
            self.transcript.push_message(&cv_whole);

            let (f_ty, f_body, f_whole) = take(&mut r)?;
            (true, f_ty, f_body, f_whole)
        } else {
            // No Certificate: the server is anonymous, so a client that
            // required authentication must refuse.
            if store.is_some() {
                return Err(TlsError::HandshakeFailed);
            }
            (false, ty, body, whole)
        };

        if ty != wire::HS_FINISHED {
            return Err(TlsError::Decode);
        }
        if !r.is_empty() {
            return Err(TlsError::Decode);
        }

        // The server proves it derived the same keys over the same transcript.
        let th_before_server_finished = self.transcript.hash();
        finished_verify(self.alg, &s_hs, &th_before_server_finished, &body)?;

        self.transcript.push_message(&whole);
        let th_ap = self.transcript.hash();
        let client_finished = finished_mac(self.alg, &c_hs, &th_ap)?;
        let client_finished_msg = wire::encode_finished(&client_finished)?;
        let session = session_from(&ks, &th_ap, true, authenticated)?;
        Ok((client_finished_msg, session))
    }
}

/// Server side of the handshake.
pub struct ServerHandshake {
    alg: HashAlg,
    c_hs: Vec<u8>,
    ks: KeySchedule,
    th_ap: Vec<u8>,
    authenticated: bool,
}

impl ServerHandshake {
    /// Accept a ClientHello: negotiate, and produce the whole server flight.
    ///
    /// # Errors
    /// [`TlsError::Decode`] if the hello is malformed;
    /// [`TlsError::HandshakeFailed`] if it offers nothing we support or its
    /// share is degenerate.
    pub fn accept(
        alg: HashAlg,
        rnd: &ServerRandomness,
        client_hello_msg: &[u8],
    ) -> Result<(Self, ServerFlight), TlsError> {
        Self::accept_inner(alg, rnd, client_hello_msg, None)
    }

    /// Accept and AUTHENTICATE: additionally send a raw-public-key Certificate
    /// and a §4.4.3 CertificateVerify signed by `identity`, so a client with
    /// the matching pin can prove it is talking to us and not a MITM.
    ///
    /// # Errors
    /// As [`Self::accept`].
    pub fn accept_authenticated(
        alg: HashAlg,
        rnd: &ServerRandomness,
        client_hello_msg: &[u8],
        identity: &Identity,
    ) -> Result<(Self, ServerFlight), TlsError> {
        Self::accept_inner(alg, rnd, client_hello_msg, Some(identity))
    }

    fn accept_inner(
        alg: HashAlg,
        rnd: &ServerRandomness,
        client_hello_msg: &[u8],
        identity: Option<&Identity>,
    ) -> Result<(Self, ServerFlight), TlsError> {
        // ---- ClientHello -------------------------------------------------
        let hs = wire::parse_handshake(client_hello_msg)?;
        if hs.msg_type != wire::HS_CLIENT_HELLO || hs.consumed != client_hello_msg.len() {
            return Err(TlsError::Decode);
        }
        let ch = wire::ClientHello::parse(hs.body)?;
        if !ch.offers_tls13() || !ch.offers_suite(alg.wire_suite()) {
            return Err(TlsError::HandshakeFailed);
        }
        let client_share = ch.key_share_x25519.ok_or(TlsError::HandshakeFailed)?;

        let keypair = X25519KeyPair::generate(&rnd.key_entropy);
        let share = *keypair.public_key();
        let shared = keypair
            .diffie_hellman(&client_share)
            .map_err(|_| TlsError::HandshakeFailed)?;
        let ks = KeySchedule::new(alg, &shared)?;

        let mut transcript = Transcript::new(alg);
        transcript.push_message(client_hello_msg);

        // ---- ServerHello -------------------------------------------------
        let server_hello = wire::ServerHello {
            random: rnd.hello_random,
            legacy_session_id_echo: ch.legacy_session_id.clone(),
            cipher_suite: alg.wire_suite(),
            key_share_x25519: Some(share),
            selected_version: Some(wire::TLS13_VERSION),
        }
        .encode()?;
        transcript.push_message(&server_hello);

        let th_hs = transcript.hash();
        let c_hs = ks.handshake_traffic(b"c hs traffic", &th_hs)?;
        let s_hs = ks.handshake_traffic(b"s hs traffic", &th_hs)?;

        // ---- EncryptedExtensions ‖ [Certificate ‖ CertificateVerify] -----
        let mut rest = Vec::new();
        let ee = wire::encode_encrypted_extensions()?;
        transcript.push_message(&ee);
        rest.extend_from_slice(&ee);

        if let Some(id) = identity {
            let credential = id.credential();
            let cert_msg = wire::encode_certificate(&credential)?;
            transcript.push_message(&cert_msg);
            rest.extend_from_slice(&cert_msg);

            let th_cert = transcript.hash();
            let signature = id.certificate_verify(&th_cert);
            let cv_msg = wire::encode_certificate_verify(wire::SIG_ED25519, &signature)?;
            transcript.push_message(&cv_msg);
            rest.extend_from_slice(&cv_msg);
        }

        // ---- Finished ----------------------------------------------------
        let th_before_finished = transcript.hash();
        let server_finished = finished_mac(alg, &s_hs, &th_before_finished)?;
        let fin_msg = wire::encode_finished(&server_finished)?;
        transcript.push_message(&fin_msg);
        rest.extend_from_slice(&fin_msg);

        let th_ap = transcript.hash();

        Ok((
            Self {
                alg,
                c_hs,
                ks,
                th_ap,
                authenticated: identity.is_some(),
            },
            ServerFlight { server_hello, rest },
        ))
    }

    /// Verify the client's Finished message and establish the session.
    ///
    /// # Errors
    /// [`TlsError::Decode`] if the message is not a well-formed Finished;
    /// [`TlsError::HandshakeFailed`] if it does not verify.
    pub fn confirm(self, client_finished_msg: &[u8]) -> Result<Session, TlsError> {
        let m = wire::parse_handshake(client_finished_msg)?;
        if m.msg_type != wire::HS_FINISHED || m.consumed != client_finished_msg.len() {
            return Err(TlsError::Decode);
        }
        finished_verify(self.alg, &self.c_hs, &self.th_ap, m.body)?;
        session_from(&self.ks, &self.th_ap, true, self.authenticated)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn rnds() -> (ClientRandomness, ServerRandomness) {
        (
            ClientRandomness::for_test([7u8; 32]),
            ServerRandomness::for_test([9u8; 32]),
        )
    }

    /// Drive a complete anonymous handshake, returning both sessions.
    fn run(alg: HashAlg) -> (Session, Session) {
        let (cr, sr) = rnds();
        let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (server, flight) = ServerHandshake::accept(alg, &sr, &hello).unwrap();
        let (cfin, c) = client.finish(&flight.server_hello, &flight.rest).unwrap();
        let s = server.confirm(&cfin).unwrap();
        (c, s)
    }

    /// Rebuild a ServerHello with one field altered, so tampering tests change
    /// the *meaning* of the message rather than corrupting its framing.
    fn remake_server_hello(msg: &[u8], f: impl FnOnce(&mut wire::ServerHello)) -> Vec<u8> {
        let hs = wire::parse_handshake(msg).unwrap();
        let mut sh = wire::ServerHello::parse(hs.body).unwrap();
        f(&mut sh);
        sh.encode().unwrap()
    }

    /// The happy path: both sides derive identical, working record keys.
    #[test]
    fn handshake_agrees_on_keys() {
        // Default to the standard suite's hash; both are covered by
        // `handshake_works_under_both_hashes`.
        let (c_session, s_session) = run(HashAlg::Sha384);

        // Client-derived keys open what server-derived keys sealed.
        let sealed = s_session
            .server_keys
            .protect(0, b"", b"salam dari pelayan")
            .unwrap();
        let opened = c_session.server_keys.unprotect(0, b"", &sealed).unwrap();
        assert_eq!(opened, b"salam dari pelayan");

        let sealed = c_session
            .client_keys
            .protect(0, b"", b"salam dari klien")
            .unwrap();
        let opened = s_session.client_keys.unprotect(0, b"", &sealed).unwrap();
        assert_eq!(opened, b"salam dari klien");
    }

    /// The messages really are RFC 8446 wire format now — the ClientHello the
    /// handshake emits parses as one, and offers exactly what we negotiate on.
    #[test]
    fn client_hello_on_the_wire_is_rfc_8446() {
        let alg = HashAlg::Sha384;
        let (cr, _) = rnds();
        let (_client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let hs = wire::parse_handshake(&hello).unwrap();
        assert_eq!(hs.msg_type, wire::HS_CLIENT_HELLO);
        assert_eq!(
            hs.consumed,
            hello.len(),
            "the message must be self-delimiting"
        );
        let ch = wire::ClientHello::parse(hs.body).unwrap();
        assert!(ch.offers_tls13());
        assert!(ch.offers_suite(wire::TLS_AES_256_GCM_SHA384));
        assert_eq!(ch.key_share_x25519.unwrap().len(), SHARE_LEN);
        assert_eq!(ch.signature_algorithms, vec![wire::SIG_ED25519]);
        assert_eq!(ch.random, cr.hello_random);
    }

    /// The server flight is the RFC's message sequence, in order.
    #[test]
    fn server_flight_is_the_rfc_message_sequence() {
        let alg = HashAlg::Sha384;
        let (cr, sr) = rnds();
        let id = Identity::from_seed(&[21u8; 32]);
        let (_client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (_server, flight) =
            ServerHandshake::accept_authenticated(alg, &sr, &hello, &id).unwrap();

        let hs = wire::parse_handshake(&flight.server_hello).unwrap();
        assert_eq!(hs.msg_type, wire::HS_SERVER_HELLO);

        let mut r = &flight.rest[..];
        let mut types = Vec::new();
        while !r.is_empty() {
            let m = wire::parse_handshake(r).unwrap();
            types.push(m.msg_type);
            r = &r[m.consumed..];
        }
        assert_eq!(
            types,
            vec![
                wire::HS_ENCRYPTED_EXTENSIONS,
                wire::HS_CERTIFICATE,
                wire::HS_CERTIFICATE_VERIFY,
                wire::HS_FINISHED,
            ],
            "RFC 8446 4.4 order: EE, Certificate, CertificateVerify, Finished"
        );
    }

    /// EncryptedExtensions is mandatory even when empty, and it is part of the
    /// transcript. A server that skipped it would desynchronise every
    /// conforming peer's Finished, so its absence must be an error.
    #[test]
    fn missing_encrypted_extensions_is_rejected() {
        let alg = HashAlg::Sha384;
        let (cr, sr) = rnds();
        let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (_server, flight) = ServerHandshake::accept(alg, &sr, &hello).unwrap();
        // Strip the leading EncryptedExtensions message.
        let ee = wire::parse_handshake(&flight.rest).unwrap();
        let without = flight.rest[ee.consumed..].to_vec();
        assert!(client.finish(&flight.server_hello, &without).is_err());
    }

    /// Forward secrecy is real: a second handshake with different entropy
    /// yields different keys, so compromising one session tells you nothing
    /// about the other.
    #[test]
    fn fresh_entropy_yields_different_keys() {
        let alg = HashAlg::Sha384;
        let go = |c: [u8; 32], s: [u8; 32]| {
            let cr = ClientRandomness::for_test(c);
            let sr = ServerRandomness::for_test(s);
            let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
            let (server, flight) = ServerHandshake::accept(alg, &sr, &hello).unwrap();
            let (cfin, sess) = client.finish(&flight.server_hello, &flight.rest).unwrap();
            server.confirm(&cfin).unwrap();
            sess.client_keys.protect(0, b"", b"tetap").unwrap()
        };
        let a = go([1u8; 32], [2u8; 32]);
        let b = go([3u8; 32], [4u8; 32]);
        assert_ne!(a, b, "distinct ephemeral keys must give distinct keystreams");
    }

    /// Transcript binding: a tampered server share makes the handshake fail —
    /// the client cannot be talked into a different view of the exchange.
    #[test]
    fn tampered_server_share_fails_finished() {
        let alg = HashAlg::Sha384;
        let (cr, sr) = rnds();
        let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (_server, flight) = ServerHandshake::accept(alg, &sr, &hello).unwrap();
        let forged = remake_server_hello(&flight.server_hello, |sh| {
            let mut k = sh.key_share_x25519.unwrap();
            k[0] ^= 0x01;
            sh.key_share_x25519 = Some(k);
        });
        assert_eq!(
            client.finish(&forged, &flight.rest).err(),
            Some(TlsError::HandshakeFailed)
        );
    }

    /// DOWNGRADE: a ServerHello selecting a suite we never offered is refused
    /// before any key material is used.
    #[test]
    fn server_selecting_an_unoffered_suite_is_rejected() {
        let alg = HashAlg::Sha384;
        let (cr, sr) = rnds();
        let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (_server, flight) = ServerHandshake::accept(alg, &sr, &hello).unwrap();
        let forged = remake_server_hello(&flight.server_hello, |sh| {
            sh.cipher_suite = wire::TLS_AES_128_GCM_SHA256;
        });
        assert_eq!(
            client.finish(&forged, &flight.rest).err(),
            Some(TlsError::HandshakeFailed)
        );
    }

    /// DOWNGRADE: a ServerHello that does not select TLS 1.3 is refused.
    #[test]
    fn server_not_selecting_tls13_is_rejected() {
        let alg = HashAlg::Sha384;
        let (cr, sr) = rnds();
        let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (_server, flight) = ServerHandshake::accept(alg, &sr, &hello).unwrap();
        let forged = remake_server_hello(&flight.server_hello, |sh| {
            sh.selected_version = Some(0x0303);
        });
        assert_eq!(
            client.finish(&forged, &flight.rest).err(),
            Some(TlsError::HandshakeFailed)
        );
    }

    /// The session-id echo binds the reply to OUR hello: a ServerHello echoing
    /// somebody else's id is refused, which is what stops a recorded server
    /// flight being replayed at us.
    #[test]
    fn mismatched_session_id_echo_is_rejected() {
        let alg = HashAlg::Sha384;
        let (cr, sr) = rnds();
        let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (_server, flight) = ServerHandshake::accept(alg, &sr, &hello).unwrap();
        let forged = remake_server_hello(&flight.server_hello, |sh| {
            sh.legacy_session_id_echo = vec![0xEE; 32];
        });
        assert_eq!(
            client.finish(&forged, &flight.rest).err(),
            Some(TlsError::HandshakeFailed)
        );
    }

    /// A HelloRetryRequest is a ServerHello with a fixed random. We do not
    /// implement HRR, so it must be refused explicitly rather than fed into
    /// the key exchange as if the constant were a peer random.
    #[test]
    fn hello_retry_request_is_refused() {
        let alg = HashAlg::Sha384;
        let (cr, sr) = rnds();
        let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (_server, flight) = ServerHandshake::accept(alg, &sr, &hello).unwrap();
        let hrr = remake_server_hello(&flight.server_hello, |sh| {
            sh.random = wire::HELLO_RETRY_REQUEST_RANDOM;
        });
        assert_eq!(
            client.finish(&hrr, &flight.rest).err(),
            Some(TlsError::HandshakeFailed)
        );
    }

    /// A forged server Finished is rejected.
    #[test]
    fn forged_server_finished_is_rejected() {
        let alg = HashAlg::Sha384;
        let (cr, sr) = rnds();
        let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (_server, flight) = ServerHandshake::accept(alg, &sr, &hello).unwrap();
        let mut rest = flight.rest.clone();
        // Flip a bit inside the last message's body (the verify_data).
        let n = rest.len();
        rest[n - 1] ^= 0x80;
        assert_eq!(
            client.finish(&flight.server_hello, &rest).err(),
            Some(TlsError::HandshakeFailed)
        );
    }

    /// A forged client Finished is rejected by the server.
    #[test]
    fn forged_client_finished_is_rejected() {
        let alg = HashAlg::Sha384;
        let (cr, sr) = rnds();
        let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (server, flight) = ServerHandshake::accept(alg, &sr, &hello).unwrap();
        let (mut cfin, _) = client.finish(&flight.server_hello, &flight.rest).unwrap();
        let n = cfin.len();
        cfin[n - 1] ^= 0x01;
        assert_eq!(server.confirm(&cfin).err(), Some(TlsError::HandshakeFailed));
    }

    /// Length is part of the check, in two distinct ways: a Finished whose
    /// FRAMING is truncated fails to decode, and one that is well-framed but
    /// carries a short verify_data fails the MAC. Neither may pass.
    #[test]
    fn truncated_finished_is_rejected() {
        let alg = HashAlg::Sha384;
        let (cr, sr) = rnds();

        let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (_server, flight) = ServerHandshake::accept(alg, &sr, &hello).unwrap();
        let chopped = flight.rest[..flight.rest.len() - 16].to_vec();
        assert_eq!(
            client.finish(&flight.server_hello, &chopped).err(),
            Some(TlsError::Decode),
            "truncated framing must fail to decode"
        );

        let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (_server, flight) = ServerHandshake::accept(alg, &sr, &hello).unwrap();
        // Re-frame the flight with a short (but well-formed) Finished.
        let mut r = &flight.rest[..];
        let mut rebuilt = Vec::new();
        while !r.is_empty() {
            let m = wire::parse_handshake(r).unwrap();
            if m.msg_type == wire::HS_FINISHED {
                rebuilt.extend_from_slice(&wire::encode_finished(&m.body[..16]).unwrap());
            } else {
                rebuilt.extend_from_slice(&r[..m.consumed]);
            }
            r = &r[m.consumed..];
        }
        assert_eq!(
            client.finish(&flight.server_hello, &rebuilt).err(),
            Some(TlsError::HandshakeFailed),
            "a short verify_data must fail the MAC"
        );
    }

    /// Trailing bytes after the server flight are refused rather than ignored:
    /// a parser that tolerates them accepts two different flights as the same.
    #[test]
    fn trailing_bytes_after_the_flight_are_rejected() {
        let alg = HashAlg::Sha384;
        let (cr, sr) = rnds();
        let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (_server, flight) = ServerHandshake::accept(alg, &sr, &hello).unwrap();
        let mut rest = flight.rest.clone();
        rest.push(0x00);
        assert_eq!(
            client.finish(&flight.server_hello, &rest).err(),
            Some(TlsError::Decode)
        );
    }

    /// A malformed ClientHello is refused by the server rather than parsed
    /// optimistically.
    #[test]
    fn server_rejects_a_malformed_client_hello() {
        let alg = HashAlg::Sha384;
        let (_, sr) = rnds();
        assert!(ServerHandshake::accept(alg, &sr, b"not a handshake").is_err());
        assert!(ServerHandshake::accept(alg, &sr, &[]).is_err());
    }

    /// A client offering only a suite we do not implement gets a refusal, not
    /// a silent substitution.
    #[test]
    fn server_rejects_a_hello_without_a_shared_suite() {
        let (cr, sr) = rnds();
        // The client offers the SHA-256 private code point; the server wants
        // the registered SHA-384 suite.
        let (_client, hello) = ClientHandshake::start(HashAlg::Sha256, &cr).unwrap();
        assert_eq!(
            ServerHandshake::accept(HashAlg::Sha384, &sr, &hello).err(),
            Some(TlsError::HandshakeFailed)
        );
    }

    /// The honesty invariant, asserted as a test: an anonymous handshake does
    /// NOT satisfy the Coq `tls_connected` conjunction, and the reason is
    /// exactly the missing certificate check.
    #[test]
    fn anonymous_handshake_does_not_satisfy_tls_connected() {
        let (session, _) = run(HashAlg::Sha384);
        let e = session.evidence;
        assert!(e.version_is_tls13);
        assert!(e.transcript_bound);
        assert!(e.forward_secret);
        assert!(e.verified);
        assert!(!e.cert_chain_verified, "no certificates are exchanged here");
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

    // -- Authentication --------------------------------------------------

    fn authenticated_run(
        alg: HashAlg,
        store: &TrustStore,
        identity: &Identity,
    ) -> Result<(Session, Session), TlsError> {
        let cr = ClientRandomness::for_test([11u8; 32]);
        let sr = ServerRandomness::for_test([12u8; 32]);
        let (client, hello) = ClientHandshake::start(alg, &cr)?;
        let (server, flight) = ServerHandshake::accept_authenticated(alg, &sr, &hello, identity)?;
        let (cfin, c_sess) =
            client.finish_authenticated(&flight.server_hello, &flight.rest, store)?;
        let s_sess = server.confirm(&cfin)?;
        Ok((c_sess, s_sess))
    }

    /// With a pinned server key, the full Coq `tls_connected` conjunction
    /// finally holds.
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
        let sealed = s.server_keys.protect(0, b"", b"sah").unwrap();
        assert_eq!(c.server_keys.unprotect(0, b"", &sealed).unwrap(), b"sah");
    }

    /// THE attack authentication exists to stop: an active MITM completes the
    /// key exchange with its OWN ephemeral key (it can — that part is
    /// unauthenticated) and must then present a Certificate. It does not hold
    /// the pinned private key, so whatever it signs is rejected.
    #[test]
    fn mitm_with_substituted_key_is_rejected() {
        let alg = HashAlg::Sha384;
        let real = Identity::from_seed(&[21u8; 32]);
        let attacker = Identity::from_seed(&[66u8; 32]);
        let mut store = TrustStore::new();
        store.trust(real.credential()); // the client pins the REAL server

        let cr = ClientRandomness::for_test([11u8; 32]);
        let sr = ServerRandomness::for_test([99u8; 32]);
        let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (_mitm, flight) =
            ServerHandshake::accept_authenticated(alg, &sr, &hello, &attacker).unwrap();

        // Everything the MITM sent is self-consistent — and still refused.
        assert_eq!(
            client
                .finish_authenticated(&flight.server_hello, &flight.rest, &store)
                .err(),
            Some(TlsError::HandshakeFailed),
            "a MITM presenting its own credential must be rejected"
        );
    }

    /// A MITM cannot pass by replaying the REAL server's credential either:
    /// it cannot produce the matching signature without the private key.
    #[test]
    fn mitm_replaying_the_real_credential_is_rejected() {
        let alg = HashAlg::Sha384;
        let real = Identity::from_seed(&[21u8; 32]);
        let attacker = Identity::from_seed(&[66u8; 32]);
        let mut store = TrustStore::new();
        store.trust(real.credential());

        let cr = ClientRandomness::for_test([11u8; 32]);
        let sr = ServerRandomness::for_test([99u8; 32]);
        let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (_mitm, flight) =
            ServerHandshake::accept_authenticated(alg, &sr, &hello, &attacker).unwrap();

        // Swap the Certificate for one carrying the REAL server's credential,
        // keeping the attacker's signature.
        let mut r = &flight.rest[..];
        let mut spoofed = Vec::new();
        while !r.is_empty() {
            let m = wire::parse_handshake(r).unwrap();
            if m.msg_type == wire::HS_CERTIFICATE {
                spoofed.extend_from_slice(&wire::encode_certificate(&real.credential()).unwrap());
            } else {
                spoofed.extend_from_slice(&r[..m.consumed]);
            }
            r = &r[m.consumed..];
        }

        assert_eq!(
            client
                .finish_authenticated(&flight.server_hello, &spoofed, &store)
                .err(),
            Some(TlsError::HandshakeFailed),
            "a pinned credential without the matching signature must fail"
        );
    }

    /// DOWNGRADE: a client that requires authentication must refuse an
    /// anonymous server rather than silently accepting it.
    #[test]
    fn authenticating_client_refuses_anonymous_server() {
        let alg = HashAlg::Sha384;
        let id = Identity::from_seed(&[21u8; 32]);
        let mut store = TrustStore::new();
        store.trust(id.credential());

        let (cr, sr) = rnds();
        let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (_server, flight) = ServerHandshake::accept(alg, &sr, &hello).unwrap();
        assert_eq!(
            client
                .finish_authenticated(&flight.server_hello, &flight.rest, &store)
                .err(),
            Some(TlsError::HandshakeFailed),
            "a client demanding authentication must not accept an anonymous flight"
        );

        // And the anonymous path, taken deliberately, must not claim it either.
        let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (_server, flight) = ServerHandshake::accept(alg, &sr, &hello).unwrap();
        let (_cfin, sess) = client.finish(&flight.server_hello, &flight.rest).unwrap();
        assert!(
            !sess.evidence.cert_chain_verified && !sess.evidence.tls_connected(),
            "an anonymous completion must never report authentication"
        );
    }

    /// DOWNGRADE, the other direction: a client with no trust store must not
    /// silently accept a Certificate it cannot check.
    #[test]
    fn anonymous_client_refuses_an_authenticated_server() {
        let alg = HashAlg::Sha384;
        let id = Identity::from_seed(&[21u8; 32]);
        let (cr, sr) = rnds();
        let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
        let (_server, flight) =
            ServerHandshake::accept_authenticated(alg, &sr, &hello, &id).unwrap();
        assert_eq!(
            client.finish(&flight.server_hello, &flight.rest).err(),
            Some(TlsError::HandshakeFailed)
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
    /// BOTH hashes, and the two produce different key material.
    #[test]
    fn handshake_works_under_both_hashes() {
        let mut sealed = Vec::new();
        for alg in [HashAlg::Sha256, HashAlg::Sha384] {
            let cr = ClientRandomness::for_test([41u8; 32]);
            let sr = ServerRandomness::for_test([42u8; 32]);
            let (client, hello) = ClientHandshake::start(alg, &cr).unwrap();
            let (server, flight) = ServerHandshake::accept(alg, &sr, &hello).unwrap();
            let (cfin, c_sess) = client.finish(&flight.server_hello, &flight.rest).unwrap();
            let s_sess = server.confirm(&cfin).unwrap();

            // Finished verify_data length tracks the hash — the visible sign
            // the schedule really switched.
            let cm = wire::parse_handshake(&cfin).unwrap();
            assert_eq!(cm.body.len(), alg.hash_len());

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
    /// AES-256-GCM, and the wire code points reflect that: SHA-256 gets a
    /// private-use number rather than squatting on 0x1302.
    #[test]
    fn only_sha384_names_a_registered_suite() {
        assert_eq!(HashAlg::Sha384.iana_suite(), Some("TLS_AES_256_GCM_SHA384"));
        assert_eq!(HashAlg::Sha256.iana_suite(), None);
        assert_eq!(HashAlg::Sha256.hash_len(), 32);
        assert_eq!(HashAlg::Sha384.hash_len(), 48);

        assert_eq!(HashAlg::Sha384.wire_suite(), wire::TLS_AES_256_GCM_SHA384);
        assert_eq!(
            HashAlg::Sha256.wire_suite(),
            wire::RIINA_AES_256_GCM_SHA256_PRIVATE
        );
        assert!(
            (0xFF00..=0xFFFF).contains(&HashAlg::Sha256.wire_suite()),
            "the unregistered pairing must use the private-use range"
        );
        assert_eq!(
            HashAlg::from_wire_suite(wire::TLS_AES_256_GCM_SHA384),
            Some(HashAlg::Sha384)
        );
        assert_eq!(HashAlg::from_wire_suite(wire::TLS_AES_128_GCM_SHA256), None);
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

    /// OS entropy is available and not obviously broken, and the randomness
    /// bundles draw independent values rather than repeating one read.
    #[test]
    fn os_entropy_is_fresh() {
        let a = os_entropy_32().expect("/dev/urandom must be readable");
        let b = os_entropy_32().unwrap();
        assert_ne!(a, b, "two CSPRNG reads must differ");
        assert_ne!(a, [0u8; 32], "entropy must not be all zeros");

        let r = ClientRandomness::from_os().unwrap();
        assert_ne!(
            r.key_entropy, r.hello_random,
            "the secret key seed must not equal a public field"
        );
        assert_ne!(r.key_entropy, r.legacy_session_id);
        assert_ne!(r.hello_random, r.legacy_session_id);
    }
}

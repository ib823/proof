// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! RFC 8446 wire format — records, handshake framing, and the Hello messages.
//!
//! Increment 4 of the TLS port. Increments 1–3 built real record protection, a
//! real ECDHE handshake and real peer authentication, but every message rode a
//! compact RIINA-internal encoding. That made RIINA↔RIINA the only possible
//! pairing: correct cryptography spoken in a private dialect. This module
//! supplies the dialect everyone else speaks.
//!
//! # What is REAL here
//!
//!   * **Byte-exact RFC 8446 structures**, built with length-prefixed vector
//!     writers that patch their own lengths ([`Writer::vec8`]/[`vec16`]/
//!     [`vec24`]) rather than counting by hand. Hand-counted lengths are the
//!     classic source of wire bugs, and a wrong one is invisible in a
//!     round-trip test that uses the same wrong count on both sides.
//!   * **Validated against a real OpenSSL 3.0 ClientHello**, not against a
//!     vector transcribed from a document. `tests/openssl_wire_differential.rs`
//!     makes OpenSSL generate a ClientHello and parses it with this code; the
//!     inverse direction feeds *our* ClientHello to `openssl s_server` and
//!     requires a ServerHello back rather than an alert. A wire format is a
//!     claim about what other implementations accept, so it is tested against
//!     one.
//!   * **Strict parsing.** Truncation, inconsistent inner/outer lengths,
//!     trailing bytes after a structure, and over-long records are all
//!     rejected. Unknown *extensions* are skipped (as the RFC requires), but
//!     unknown *structure* is never guessed at.
//!
//! # What is NOT
//!
//!   * **RIINA does not interoperate yet, and this module does not change
//!     that.** It is the codec only. [`crate::handshake`] still exchanges the
//!     RIINA-internal encoding and still computes its transcript over it, so
//!     nothing on the live path emits or accepts these structures. Wiring the
//!     handshake onto this codec — full messages over the wire instead of bare
//!     key shares, EncryptedExtensions in the transcript, and handshake-phase
//!     records under the handshake keys — is the next increment. Until then
//!     the honest claim is "RIINA can read and write RFC 8446 messages", not
//!     "RIINA speaks TLS".
//!   * **Encoding only.** No key exchange, no negotiation policy, no state
//!     machine, no alert generation.
//!   * **No HelloRetryRequest, no PSK/0-RTT, no fragmentation across records,
//!     no KeyUpdate, no session tickets.** HRR is *detected* and rejected
//!     ([`ServerHello::is_hello_retry_request`]) rather than silently
//!     misparsed as a ServerHello — misreading an HRR would derive keys from a
//!     random that was never a key share, and fail later with a useless error.
//!   * **Certificates are RFC 7250 raw public keys**, not X.509 chains. See
//!     [`crate::auth`] for what that trust model does and does not buy. A peer
//!     that requires X.509 will not accept our Certificate message.

use crate::TlsError;

// ---------------------------------------------------------------------------
// Constants (RFC 8446 §4, §5, and the IANA TLS registries)
// ---------------------------------------------------------------------------

/// ContentType (RFC 8446 §5.1).
pub const CT_CHANGE_CIPHER_SPEC: u8 = 20;
/// ContentType alert.
pub const CT_ALERT: u8 = 21;
/// ContentType handshake.
pub const CT_HANDSHAKE: u8 = 22;
/// ContentType application_data.
pub const CT_APPLICATION_DATA: u8 = 23;

/// `legacy_record_version` / `legacy_version` — always 0x0303 ("TLS 1.2") on
/// the wire in TLS 1.3; the real version travels in `supported_versions`.
pub const LEGACY_VERSION: u16 = 0x0303;
/// The TLS 1.3 version code, as it appears in `supported_versions`.
pub const TLS13_VERSION: u16 = 0x0304;

/// `TLS_AES_256_GCM_SHA384` — the one registered suite this crate implements.
pub const TLS_AES_256_GCM_SHA384: u16 = 0x1302;
/// `TLS_AES_128_GCM_SHA256`, recognised for negotiation refusal only.
pub const TLS_AES_128_GCM_SHA256: u16 = 0x1301;

/// NamedGroup `x25519`.
pub const GROUP_X25519: u16 = 0x001d;
/// SignatureScheme `ed25519`.
pub const SIG_ED25519: u16 = 0x0807;

/// HandshakeType (RFC 8446 §4).
pub const HS_CLIENT_HELLO: u8 = 1;
/// HandshakeType server_hello.
pub const HS_SERVER_HELLO: u8 = 2;
/// HandshakeType encrypted_extensions.
pub const HS_ENCRYPTED_EXTENSIONS: u8 = 8;
/// HandshakeType certificate.
pub const HS_CERTIFICATE: u8 = 11;
/// HandshakeType certificate_verify.
pub const HS_CERTIFICATE_VERIFY: u8 = 15;
/// HandshakeType finished.
pub const HS_FINISHED: u8 = 20;

/// ExtensionType supported_groups.
pub const EXT_SUPPORTED_GROUPS: u16 = 10;
/// ExtensionType signature_algorithms.
pub const EXT_SIGNATURE_ALGORITHMS: u16 = 13;
/// ExtensionType supported_versions.
pub const EXT_SUPPORTED_VERSIONS: u16 = 43;
/// ExtensionType key_share.
pub const EXT_KEY_SHARE: u16 = 51;

/// Maximum `TLSPlaintext.length` (RFC 8446 §5.1): 2^14.
pub const MAX_PLAINTEXT: usize = 1 << 14;
/// Maximum `TLSCiphertext.length` (§5.2): 2^14 + 256, allowing for the content
/// type byte, padding and the AEAD tag.
pub const MAX_CIPHERTEXT: usize = (1 << 14) + 256;

/// The fixed `ServerHello.random` that marks a HelloRetryRequest
/// (RFC 8446 §4.1.3). The RFC gives it as a literal constant and notes it is
/// `SHA-256("HelloRetryRequest")`; `hello_retry_random_is_the_rfc_constant`
/// recomputes that hash rather than trusting this array to have been
/// transcribed correctly.
pub const HELLO_RETRY_REQUEST_RANDOM: [u8; 32] = [
    0xcf, 0x21, 0xad, 0x74, 0xe5, 0x9a, 0x61, 0x11, 0xbe, 0x1d, 0x8c, 0x02, 0x1e, 0x65, 0xb8, 0x91,
    0xc2, 0xa2, 0x11, 0x16, 0x7a, 0xbb, 0x8c, 0x5e, 0x07, 0x9e, 0x09, 0xe2, 0xc8, 0xa8, 0x33, 0x9c,
];

/// The DER `SubjectPublicKeyInfo` prefix for an Ed25519 key: `SEQUENCE {
/// SEQUENCE { OID 1.3.101.112 }, BIT STRING (0 unused bits) }`. Prefixing a
/// raw 32-byte key with this yields the 44-byte SPKI that RFC 7250 puts in a
/// Certificate message. Verified against `openssl pkey -pubout -outform DER`
/// by `ed25519_spki_matches_openssl` in `tests/openssl_wire_differential.rs`,
/// not transcribed from memory.
pub const ED25519_SPKI_PREFIX: [u8; 12] = [
    0x30, 0x2a, 0x30, 0x05, 0x06, 0x03, 0x2b, 0x65, 0x70, 0x03, 0x21, 0x00,
];
/// Length of a full Ed25519 `SubjectPublicKeyInfo`.
pub const ED25519_SPKI_LEN: usize = ED25519_SPKI_PREFIX.len() + 32;

// ---------------------------------------------------------------------------
// Byte-level readers and writers
// ---------------------------------------------------------------------------

/// A strict cursor over a byte slice.
///
/// Every accessor is bounds-checked and returns [`TlsError::Decode`] rather
/// than panicking: this parses attacker-controlled input, so an index panic
/// would be a remote denial of service.
pub struct Reader<'a> {
    buf: &'a [u8],
    pos: usize,
}

impl<'a> Reader<'a> {
    #[must_use]
    pub fn new(buf: &'a [u8]) -> Self {
        Self { buf, pos: 0 }
    }

    /// Bytes not yet consumed.
    #[must_use]
    pub fn remaining(&self) -> usize {
        self.buf.len() - self.pos
    }

    /// How many bytes have been consumed so far.
    #[must_use]
    pub fn position(&self) -> usize {
        self.pos
    }

    /// # Errors
    /// [`TlsError::Decode`] on truncation.
    pub fn take(&mut self, n: usize) -> Result<&'a [u8], TlsError> {
        if self.remaining() < n {
            return Err(TlsError::Decode);
        }
        let s = &self.buf[self.pos..self.pos + n];
        self.pos += n;
        Ok(s)
    }

    /// # Errors
    /// [`TlsError::Decode`] on truncation.
    pub fn u8(&mut self) -> Result<u8, TlsError> {
        Ok(self.take(1)?[0])
    }

    /// # Errors
    /// [`TlsError::Decode`] on truncation.
    pub fn u16(&mut self) -> Result<u16, TlsError> {
        let b = self.take(2)?;
        Ok(u16::from_be_bytes([b[0], b[1]]))
    }

    /// A 24-bit big-endian length, as TLS uses for handshake bodies.
    ///
    /// # Errors
    /// [`TlsError::Decode`] on truncation.
    pub fn u24(&mut self) -> Result<u32, TlsError> {
        let b = self.take(3)?;
        Ok(u32::from_be_bytes([0, b[0], b[1], b[2]]))
    }

    /// An `opaque x<0..255>` vector.
    ///
    /// # Errors
    /// [`TlsError::Decode`] on truncation.
    pub fn vec8(&mut self) -> Result<&'a [u8], TlsError> {
        let n = self.u8()? as usize;
        self.take(n)
    }

    /// An `opaque x<0..2^16-1>` vector.
    ///
    /// # Errors
    /// [`TlsError::Decode`] on truncation.
    pub fn vec16(&mut self) -> Result<&'a [u8], TlsError> {
        let n = self.u16()? as usize;
        self.take(n)
    }

    /// An `opaque x<0..2^24-1>` vector.
    ///
    /// # Errors
    /// [`TlsError::Decode`] on truncation.
    pub fn vec24(&mut self) -> Result<&'a [u8], TlsError> {
        let n = self.u24()? as usize;
        self.take(n)
    }

    /// Require that the input is fully consumed.
    ///
    /// Trailing bytes mean the sender and we disagree about the structure, so
    /// they are an error rather than something to ignore — a parser that
    /// tolerates trailing data will happily accept two different messages as
    /// the same one.
    ///
    /// # Errors
    /// [`TlsError::Decode`] if any bytes remain.
    pub fn expect_end(&self) -> Result<(), TlsError> {
        if self.remaining() == 0 {
            Ok(())
        } else {
            Err(TlsError::Decode)
        }
    }
}

/// A byte-string builder for TLS structures.
///
/// The `vec*` helpers reserve the length field, run the body closure, then
/// patch the true length in. Lengths are therefore never computed by hand,
/// which removes the single most common class of wire-format bug.
#[derive(Default)]
pub struct Writer {
    buf: Vec<u8>,
}

impl Writer {
    #[must_use]
    pub fn new() -> Self {
        Self::default()
    }

    #[must_use]
    pub fn into_vec(self) -> Vec<u8> {
        self.buf
    }

    #[must_use]
    pub fn len(&self) -> usize {
        self.buf.len()
    }

    #[must_use]
    pub fn is_empty(&self) -> bool {
        self.buf.is_empty()
    }

    pub fn u8(&mut self, v: u8) {
        self.buf.push(v);
    }

    pub fn u16(&mut self, v: u16) {
        self.buf.extend_from_slice(&v.to_be_bytes());
    }

    pub fn u24(&mut self, v: u32) {
        self.buf.extend_from_slice(&v.to_be_bytes()[1..]);
    }

    pub fn bytes(&mut self, b: &[u8]) {
        self.buf.extend_from_slice(b);
    }

    /// Write an `opaque x<0..255>` whose body is produced by `f`.
    ///
    /// # Errors
    /// [`TlsError::BadLength`] if the body exceeds 255 bytes.
    pub fn vec8(&mut self, f: impl FnOnce(&mut Self) -> Result<(), TlsError>) -> Result<(), TlsError> {
        let at = self.buf.len();
        self.buf.push(0);
        f(self)?;
        let n = self.buf.len() - at - 1;
        self.buf[at] = u8::try_from(n).map_err(|_| TlsError::BadLength)?;
        Ok(())
    }

    /// Write an `opaque x<0..2^16-1>` whose body is produced by `f`.
    ///
    /// # Errors
    /// [`TlsError::BadLength`] if the body exceeds 65535 bytes.
    pub fn vec16(
        &mut self,
        f: impl FnOnce(&mut Self) -> Result<(), TlsError>,
    ) -> Result<(), TlsError> {
        let at = self.buf.len();
        self.buf.extend_from_slice(&[0, 0]);
        f(self)?;
        let n = u16::try_from(self.buf.len() - at - 2).map_err(|_| TlsError::BadLength)?;
        self.buf[at..at + 2].copy_from_slice(&n.to_be_bytes());
        Ok(())
    }

    /// Write an `opaque x<0..2^24-1>` whose body is produced by `f`.
    ///
    /// # Errors
    /// [`TlsError::BadLength`] if the body exceeds 2^24-1 bytes.
    pub fn vec24(
        &mut self,
        f: impl FnOnce(&mut Self) -> Result<(), TlsError>,
    ) -> Result<(), TlsError> {
        let at = self.buf.len();
        self.buf.extend_from_slice(&[0, 0, 0]);
        f(self)?;
        let n = self.buf.len() - at - 3;
        if n > 0x00ff_ffff {
            return Err(TlsError::BadLength);
        }
        let be = (n as u32).to_be_bytes();
        self.buf[at..at + 3].copy_from_slice(&be[1..]);
        Ok(())
    }
}

// ---------------------------------------------------------------------------
// Record layer (RFC 8446 §5.1–5.2)
// ---------------------------------------------------------------------------

/// Frame a fragment as a `TLSPlaintext` record.
///
/// ```text
/// struct {
///     ContentType type;
///     ProtocolVersion legacy_record_version;   // 0x0303
///     uint16 length;
///     opaque fragment[TLSPlaintext.length];
/// } TLSPlaintext;
/// ```
///
/// # Errors
/// [`TlsError::BadLength`] if `fragment` exceeds [`MAX_PLAINTEXT`]. This crate
/// does not fragment across records, so an over-long body is a caller error
/// rather than something to silently split.
pub fn encode_record(content_type: u8, fragment: &[u8]) -> Result<Vec<u8>, TlsError> {
    if fragment.len() > MAX_PLAINTEXT {
        return Err(TlsError::BadLength);
    }
    let mut w = Writer::new();
    w.u8(content_type);
    w.u16(LEGACY_VERSION);
    w.vec16(|w| {
        w.bytes(fragment);
        Ok(())
    })?;
    Ok(w.into_vec())
}

/// One parsed record: its content type, its fragment, and how many bytes of
/// the input it consumed (so a caller can walk a stream of records).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Record<'a> {
    /// The `ContentType` octet.
    pub content_type: u8,
    /// The record body, still protected if this was a `TLSCiphertext`.
    pub fragment: &'a [u8],
    /// Total bytes consumed, including the 5-byte header.
    pub consumed: usize,
}

/// Parse one record from the front of `buf`.
///
/// The length bound applied is [`MAX_CIPHERTEXT`] rather than
/// [`MAX_PLAINTEXT`], because a *protected* record legitimately carries the
/// extra content-type byte, padding and AEAD tag. Applying the plaintext bound
/// here would reject valid traffic from a conforming peer.
///
/// # Errors
/// [`TlsError::Decode`] if the header is truncated, the body is incomplete, or
/// the declared length exceeds [`MAX_CIPHERTEXT`].
pub fn parse_record(buf: &[u8]) -> Result<Record<'_>, TlsError> {
    let mut r = Reader::new(buf);
    let content_type = r.u8()?;
    let _legacy = r.u16()?;
    let len = r.u16()? as usize;
    if len > MAX_CIPHERTEXT {
        return Err(TlsError::Decode);
    }
    let fragment = r.take(len)?;
    Ok(Record {
        content_type,
        fragment,
        consumed: r.position(),
    })
}

/// Build a `TLSInnerPlaintext` (RFC 8446 §5.2): the real content, then the
/// real content type, then `padding` zero bytes.
///
/// The content type moves *inside* the encryption precisely so a network
/// observer cannot tell handshake records from application data; the outer
/// header always says `application_data`.
#[must_use]
pub fn inner_plaintext(content: &[u8], content_type: u8, padding: usize) -> Vec<u8> {
    let mut v = Vec::with_capacity(content.len() + 1 + padding);
    v.extend_from_slice(content);
    v.push(content_type);
    v.resize(v.len() + padding, 0);
    v
}

/// Split a decrypted `TLSInnerPlaintext` back into (content, content_type).
///
/// Per §5.2 the padding is stripped by scanning back from the end for the last
/// non-zero octet, which is the content type. A record that is entirely zeros
/// has no content type and is rejected.
///
/// # Errors
/// [`TlsError::Decode`] if the buffer is empty or contains only padding.
pub fn split_inner_plaintext(buf: &[u8]) -> Result<(&[u8], u8), TlsError> {
    let end = buf
        .iter()
        .rposition(|&b| b != 0)
        .ok_or(TlsError::Decode)?;
    Ok((&buf[..end], buf[end]))
}

/// The 5-byte record header that a protected record uses as its AEAD
/// additional data (RFC 8446 §5.2): the outer header, with the *ciphertext*
/// length.
///
/// Binding the header as AAD is what stops an attacker rewriting the length or
/// content type of a record without detection.
#[must_use]
pub fn record_aad(ciphertext_len: usize) -> [u8; 5] {
    let n = (ciphertext_len as u16).to_be_bytes();
    [
        CT_APPLICATION_DATA,
        (LEGACY_VERSION >> 8) as u8,
        (LEGACY_VERSION & 0xff) as u8,
        n[0],
        n[1],
    ]
}

// ---------------------------------------------------------------------------
// Handshake message framing (RFC 8446 §4)
// ---------------------------------------------------------------------------

/// Frame a handshake body as `msg_type || uint24 length || body`.
///
/// # Errors
/// [`TlsError::BadLength`] if the body exceeds 2^24-1 bytes.
pub fn encode_handshake(msg_type: u8, body: &[u8]) -> Result<Vec<u8>, TlsError> {
    let mut w = Writer::new();
    w.u8(msg_type);
    w.vec24(|w| {
        w.bytes(body);
        Ok(())
    })?;
    Ok(w.into_vec())
}

/// A parsed handshake message header plus its body.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct HandshakeMsg<'a> {
    /// The `HandshakeType` octet.
    pub msg_type: u8,
    /// The message body, excluding the 4-byte header.
    pub body: &'a [u8],
    /// Total bytes consumed, including the 4-byte header.
    pub consumed: usize,
}

/// Parse one handshake message from the front of `buf`.
///
/// # Errors
/// [`TlsError::Decode`] on truncation or an incomplete body.
pub fn parse_handshake(buf: &[u8]) -> Result<HandshakeMsg<'_>, TlsError> {
    let mut r = Reader::new(buf);
    let msg_type = r.u8()?;
    let body = r.vec24()?;
    Ok(HandshakeMsg {
        msg_type,
        body,
        consumed: r.position(),
    })
}

// ---------------------------------------------------------------------------
// Extensions
// ---------------------------------------------------------------------------

/// Walk an `Extension extensions<...>` block, calling `f(ext_type, ext_data)`.
///
/// Unknown extension types are passed to `f` like any other; it is the
/// caller's business to ignore what it does not implement, which is what
/// RFC 8446 §4.2 requires of a conforming peer. What is *not* tolerated is a
/// malformed extension block — an inner length that runs past the end is an
/// error, not something to salvage.
///
/// # Errors
/// [`TlsError::Decode`] on a malformed block.
pub fn for_each_extension(
    body: &[u8],
    mut f: impl FnMut(u16, &[u8]) -> Result<(), TlsError>,
) -> Result<(), TlsError> {
    let mut r = Reader::new(body);
    while r.remaining() > 0 {
        let ext_type = r.u16()?;
        let ext_data = r.vec16()?;
        f(ext_type, ext_data)?;
    }
    Ok(())
}

/// Parse a `key_share` extension carrying client shares (the ClientHello
/// form), returning the x25519 share if one is offered.
///
/// # Errors
/// [`TlsError::Decode`] on a malformed extension.
fn parse_client_key_share(data: &[u8]) -> Result<Option<[u8; 32]>, TlsError> {
    let mut r = Reader::new(data);
    let list = r.vec16()?;
    r.expect_end()?;
    let mut lr = Reader::new(list);
    let mut found = None;
    while lr.remaining() > 0 {
        let group = lr.u16()?;
        let ke = lr.vec16()?;
        // Take the FIRST x25519 share. A peer that sends two shares for the
        // same group is malformed, but preferring the first is the safe
        // reading — never let a later entry silently replace one already used.
        if group == GROUP_X25519 && found.is_none() && ke.len() == 32 {
            let mut s = [0u8; 32];
            s.copy_from_slice(ke);
            found = Some(s);
        }
    }
    Ok(found)
}

/// Parse a `key_share` extension carrying a single server share (the
/// ServerHello form).
fn parse_server_key_share(data: &[u8]) -> Result<Option<[u8; 32]>, TlsError> {
    let mut r = Reader::new(data);
    let group = r.u16()?;
    let ke = r.vec16()?;
    r.expect_end()?;
    if group == GROUP_X25519 && ke.len() == 32 {
        let mut s = [0u8; 32];
        s.copy_from_slice(ke);
        Ok(Some(s))
    } else {
        Ok(None)
    }
}

// ---------------------------------------------------------------------------
// ClientHello (RFC 8446 §4.1.2)
// ---------------------------------------------------------------------------

/// A parsed ClientHello, reduced to the fields this implementation acts on.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ClientHello {
    /// `Random` — 32 bytes, opaque to us.
    pub random: [u8; 32],
    /// `legacy_session_id`, echoed verbatim in our ServerHello for middlebox
    /// compatibility.
    pub legacy_session_id: Vec<u8>,
    /// Offered cipher suites, in the client's preference order.
    pub cipher_suites: Vec<u16>,
    /// Versions from the `supported_versions` extension.
    pub supported_versions: Vec<u16>,
    /// The client's x25519 share, if it offered one.
    pub key_share_x25519: Option<[u8; 32]>,
    /// Offered signature schemes.
    pub signature_algorithms: Vec<u16>,
}

impl ClientHello {
    /// Does this hello offer TLS 1.3?
    ///
    /// Only the extension counts. `legacy_version` is frozen at 0x0303 by
    /// RFC 8446 §4.1.2 and says nothing about what the client supports, so
    /// reading it would accept a TLS 1.2-only client as 1.3-capable.
    #[must_use]
    pub fn offers_tls13(&self) -> bool {
        self.supported_versions.contains(&TLS13_VERSION)
    }

    /// Does this hello offer `suite`?
    #[must_use]
    pub fn offers_suite(&self, suite: u16) -> bool {
        self.cipher_suites.contains(&suite)
    }

    /// Encode this hello as a complete handshake message (with its 4-byte
    /// header), ready to place in a record and to feed to the transcript.
    ///
    /// # Errors
    /// [`TlsError::BadLength`] if any field overflows its vector bound.
    pub fn encode(&self) -> Result<Vec<u8>, TlsError> {
        let mut w = Writer::new();
        w.u16(LEGACY_VERSION);
        w.bytes(&self.random);
        w.vec8(|w| {
            w.bytes(&self.legacy_session_id);
            Ok(())
        })?;
        w.vec16(|w| {
            for s in &self.cipher_suites {
                w.u16(*s);
            }
            Ok(())
        })?;
        // legacy_compression_methods: exactly one method, "null". TLS 1.3
        // forbids compression; the vector survives only for the wire shape.
        w.vec8(|w| {
            w.u8(0);
            Ok(())
        })?;
        w.vec16(|w| {
            // supported_versions
            w.u16(EXT_SUPPORTED_VERSIONS);
            w.vec16(|w| {
                w.vec8(|w| {
                    for v in &self.supported_versions {
                        w.u16(*v);
                    }
                    Ok(())
                })
            })?;
            // supported_groups
            w.u16(EXT_SUPPORTED_GROUPS);
            w.vec16(|w| {
                w.vec16(|w| {
                    w.u16(GROUP_X25519);
                    Ok(())
                })
            })?;
            // signature_algorithms
            w.u16(EXT_SIGNATURE_ALGORITHMS);
            w.vec16(|w| {
                w.vec16(|w| {
                    for s in &self.signature_algorithms {
                        w.u16(*s);
                    }
                    Ok(())
                })
            })?;
            // key_share
            if let Some(share) = &self.key_share_x25519 {
                w.u16(EXT_KEY_SHARE);
                w.vec16(|w| {
                    w.vec16(|w| {
                        w.u16(GROUP_X25519);
                        w.vec16(|w| {
                            w.bytes(share);
                            Ok(())
                        })
                    })
                })?;
            }
            Ok(())
        })?;
        encode_handshake(HS_CLIENT_HELLO, &w.into_vec())
    }

    /// Parse a ClientHello **body** (the bytes after the 4-byte handshake
    /// header).
    ///
    /// # Errors
    /// [`TlsError::Decode`] on any structural problem.
    pub fn parse(body: &[u8]) -> Result<Self, TlsError> {
        let mut r = Reader::new(body);
        let _legacy_version = r.u16()?;
        let random_b = r.take(32)?;
        let mut random = [0u8; 32];
        random.copy_from_slice(random_b);
        let legacy_session_id = r.vec8()?.to_vec();
        let suites_b = r.vec16()?;
        if suites_b.len() % 2 != 0 {
            return Err(TlsError::Decode);
        }
        let cipher_suites = suites_b
            .chunks_exact(2)
            .map(|c| u16::from_be_bytes([c[0], c[1]]))
            .collect();
        let _compression = r.vec8()?;
        let ext_b = r.vec16()?;
        r.expect_end()?;

        let mut supported_versions = Vec::new();
        let mut key_share_x25519 = None;
        let mut signature_algorithms = Vec::new();
        for_each_extension(ext_b, |ext_type, data| {
            match ext_type {
                EXT_SUPPORTED_VERSIONS => {
                    let mut er = Reader::new(data);
                    let list = er.vec8()?;
                    er.expect_end()?;
                    if list.len() % 2 != 0 {
                        return Err(TlsError::Decode);
                    }
                    supported_versions = list
                        .chunks_exact(2)
                        .map(|c| u16::from_be_bytes([c[0], c[1]]))
                        .collect();
                }
                EXT_KEY_SHARE => key_share_x25519 = parse_client_key_share(data)?,
                EXT_SIGNATURE_ALGORITHMS => {
                    let mut er = Reader::new(data);
                    let list = er.vec16()?;
                    er.expect_end()?;
                    if list.len() % 2 != 0 {
                        return Err(TlsError::Decode);
                    }
                    signature_algorithms = list
                        .chunks_exact(2)
                        .map(|c| u16::from_be_bytes([c[0], c[1]]))
                        .collect();
                }
                // Everything else (server_name, ALPN, session_ticket, …) is
                // ignored by design — §4.2 requires unknown extensions be
                // skipped, and skipping is safe because nothing here depends
                // on them.
                _ => {}
            }
            Ok(())
        })?;

        Ok(Self {
            random,
            legacy_session_id,
            cipher_suites,
            supported_versions,
            key_share_x25519,
            signature_algorithms,
        })
    }
}

// ---------------------------------------------------------------------------
// ServerHello (RFC 8446 §4.1.3)
// ---------------------------------------------------------------------------

/// A parsed ServerHello.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ServerHello {
    /// `Random`, or [`HELLO_RETRY_REQUEST_RANDOM`] for an HRR.
    pub random: [u8; 32],
    /// The client's session id, echoed back.
    pub legacy_session_id_echo: Vec<u8>,
    /// The selected cipher suite.
    pub cipher_suite: u16,
    /// The server's x25519 share, if it selected that group.
    pub key_share_x25519: Option<[u8; 32]>,
    /// The version from `supported_versions`, if present.
    pub selected_version: Option<u16>,
}

impl ServerHello {
    /// Is this actually a HelloRetryRequest wearing a ServerHello's clothes?
    ///
    /// RFC 8446 §4.1.4 encodes HRR as a ServerHello with a fixed random. A
    /// parser that misses this treats the constant as a peer random and
    /// carries on into key derivation, so the check is not optional.
    #[must_use]
    pub fn is_hello_retry_request(&self) -> bool {
        self.random == HELLO_RETRY_REQUEST_RANDOM
    }

    /// Encode as a complete handshake message.
    ///
    /// # Errors
    /// [`TlsError::BadLength`] on a field that overflows its bound.
    pub fn encode(&self) -> Result<Vec<u8>, TlsError> {
        let mut w = Writer::new();
        w.u16(LEGACY_VERSION);
        w.bytes(&self.random);
        w.vec8(|w| {
            w.bytes(&self.legacy_session_id_echo);
            Ok(())
        })?;
        w.u16(self.cipher_suite);
        w.u8(0); // legacy_compression_method
        w.vec16(|w| {
            w.u16(EXT_SUPPORTED_VERSIONS);
            w.vec16(|w| {
                w.u16(self.selected_version.unwrap_or(TLS13_VERSION));
                Ok(())
            })?;
            if let Some(share) = &self.key_share_x25519 {
                w.u16(EXT_KEY_SHARE);
                w.vec16(|w| {
                    w.u16(GROUP_X25519);
                    w.vec16(|w| {
                        w.bytes(share);
                        Ok(())
                    })
                })?;
            }
            Ok(())
        })?;
        encode_handshake(HS_SERVER_HELLO, &w.into_vec())
    }

    /// Parse a ServerHello **body**.
    ///
    /// # Errors
    /// [`TlsError::Decode`] on any structural problem.
    pub fn parse(body: &[u8]) -> Result<Self, TlsError> {
        let mut r = Reader::new(body);
        let _legacy_version = r.u16()?;
        let random_b = r.take(32)?;
        let mut random = [0u8; 32];
        random.copy_from_slice(random_b);
        let legacy_session_id_echo = r.vec8()?.to_vec();
        let cipher_suite = r.u16()?;
        let _compression = r.u8()?;
        let ext_b = r.vec16()?;
        r.expect_end()?;

        let mut key_share_x25519 = None;
        let mut selected_version = None;
        for_each_extension(ext_b, |ext_type, data| {
            match ext_type {
                EXT_SUPPORTED_VERSIONS => {
                    let mut er = Reader::new(data);
                    selected_version = Some(er.u16()?);
                    er.expect_end()?;
                }
                EXT_KEY_SHARE => key_share_x25519 = parse_server_key_share(data)?,
                _ => {}
            }
            Ok(())
        })?;

        Ok(Self {
            random,
            legacy_session_id_echo,
            cipher_suite,
            key_share_x25519,
            selected_version,
        })
    }
}

// ---------------------------------------------------------------------------
// Certificate / CertificateVerify / Finished
// ---------------------------------------------------------------------------

/// Wrap a raw 32-byte Ed25519 public key as a DER `SubjectPublicKeyInfo`.
#[must_use]
pub fn ed25519_spki(raw: &[u8; 32]) -> Vec<u8> {
    let mut v = Vec::with_capacity(ED25519_SPKI_LEN);
    v.extend_from_slice(&ED25519_SPKI_PREFIX);
    v.extend_from_slice(raw);
    v
}

/// Recover the raw 32-byte key from an Ed25519 `SubjectPublicKeyInfo`.
///
/// The whole prefix is checked, not just the length: accepting any 44-byte
/// blob would let a peer hand us an RSA or P-256 key and have it silently
/// treated as Ed25519.
///
/// # Errors
/// [`TlsError::Decode`] if the length or the DER prefix does not match.
pub fn ed25519_from_spki(spki: &[u8]) -> Result<[u8; 32], TlsError> {
    if spki.len() != ED25519_SPKI_LEN || spki[..ED25519_SPKI_PREFIX.len()] != ED25519_SPKI_PREFIX {
        return Err(TlsError::Decode);
    }
    let mut raw = [0u8; 32];
    raw.copy_from_slice(&spki[ED25519_SPKI_PREFIX.len()..]);
    Ok(raw)
}

/// Encode a Certificate message (RFC 8446 §4.4.2) carrying a single RFC 7250
/// raw public key.
///
/// # Errors
/// [`TlsError::BadLength`] on an overflowing vector.
pub fn encode_certificate(raw_public_key: &[u8; 32]) -> Result<Vec<u8>, TlsError> {
    let mut w = Writer::new();
    // certificate_request_context: empty in a server Certificate that was not
    // sent in response to a CertificateRequest.
    w.vec8(|_| Ok(()))?;
    w.vec24(|w| {
        w.vec24(|w| {
            w.bytes(&ed25519_spki(raw_public_key));
            Ok(())
        })?;
        // Per-entry extensions: none.
        w.vec16(|_| Ok(()))
    })?;
    encode_handshake(HS_CERTIFICATE, &w.into_vec())
}

/// Parse a Certificate **body**, returning the first entry's raw public key.
///
/// # Errors
/// [`TlsError::Decode`] if the structure is malformed, the list is empty, or
/// the first entry is not an Ed25519 SPKI.
pub fn parse_certificate(body: &[u8]) -> Result<[u8; 32], TlsError> {
    let mut r = Reader::new(body);
    let _context = r.vec8()?;
    let list = r.vec24()?;
    r.expect_end()?;
    let mut lr = Reader::new(list);
    if lr.remaining() == 0 {
        return Err(TlsError::Decode);
    }
    let spki = lr.vec24()?;
    let _entry_exts = lr.vec16()?;
    ed25519_from_spki(spki)
}

/// Encode a CertificateVerify message (RFC 8446 §4.4.3).
///
/// # Errors
/// [`TlsError::BadLength`] on an overflowing signature vector.
pub fn encode_certificate_verify(algorithm: u16, signature: &[u8]) -> Result<Vec<u8>, TlsError> {
    let mut w = Writer::new();
    w.u16(algorithm);
    w.vec16(|w| {
        w.bytes(signature);
        Ok(())
    })?;
    encode_handshake(HS_CERTIFICATE_VERIFY, &w.into_vec())
}

/// Parse a CertificateVerify **body** into (algorithm, signature).
///
/// # Errors
/// [`TlsError::Decode`] on a malformed structure.
pub fn parse_certificate_verify(body: &[u8]) -> Result<(u16, Vec<u8>), TlsError> {
    let mut r = Reader::new(body);
    let algorithm = r.u16()?;
    let signature = r.vec16()?.to_vec();
    r.expect_end()?;
    Ok((algorithm, signature))
}

/// Encode a Finished message (RFC 8446 §4.4.4): the bare `verify_data`.
///
/// # Errors
/// [`TlsError::BadLength`] if the MAC is implausibly long.
pub fn encode_finished(verify_data: &[u8]) -> Result<Vec<u8>, TlsError> {
    encode_handshake(HS_FINISHED, verify_data)
}

/// Encode an EncryptedExtensions message (RFC 8446 §4.3.1) with no extensions.
///
/// The message is mandatory in every TLS 1.3 handshake even when it carries
/// nothing, and it is part of the transcript — omitting it would desynchronise
/// the Finished MACs against any conforming peer.
///
/// # Errors
/// [`TlsError::BadLength`] is not reachable for this fixed body, but is
/// propagated rather than unwrapped.
pub fn encode_encrypted_extensions() -> Result<Vec<u8>, TlsError> {
    let mut w = Writer::new();
    w.vec16(|_| Ok(()))?;
    encode_handshake(HS_ENCRYPTED_EXTENSIONS, &w.into_vec())
}

#[cfg(test)]
mod tests {
    use super::*;

    // -- Writers patch their own lengths ------------------------------------

    #[test]
    fn vec_writers_patch_the_true_length() {
        let mut w = Writer::new();
        w.vec8(|w| {
            w.bytes(&[1, 2, 3]);
            Ok(())
        })
        .unwrap();
        assert_eq!(w.into_vec(), vec![3, 1, 2, 3]);

        let mut w = Writer::new();
        w.vec16(|w| {
            w.bytes(&[0xaa; 300]);
            Ok(())
        })
        .unwrap();
        let v = w.into_vec();
        assert_eq!(&v[..2], &[0x01, 0x2c]); // 300
        assert_eq!(v.len(), 302);

        let mut w = Writer::new();
        w.vec24(|w| {
            w.bytes(&[7; 5]);
            Ok(())
        })
        .unwrap();
        assert_eq!(&w.into_vec()[..3], &[0, 0, 5]);
    }

    #[test]
    fn vec8_rejects_an_overlong_body() {
        let mut w = Writer::new();
        assert_eq!(
            w.vec8(|w| {
                w.bytes(&[0u8; 256]);
                Ok(())
            }),
            Err(TlsError::BadLength)
        );
    }

    #[test]
    fn nested_vectors_get_independent_lengths() {
        // The inner length must count only the inner body, not the outer
        // header — an off-by-two here is the classic wire bug.
        let mut w = Writer::new();
        w.vec16(|w| {
            w.vec8(|w| {
                w.bytes(&[9, 9]);
                Ok(())
            })
        })
        .unwrap();
        assert_eq!(w.into_vec(), vec![0x00, 0x03, 0x02, 9, 9]);
    }

    // -- Reader is strict ---------------------------------------------------

    #[test]
    fn reader_rejects_truncation_instead_of_panicking() {
        let mut r = Reader::new(&[0x00]);
        assert_eq!(r.u16(), Err(TlsError::Decode));
        let mut r = Reader::new(&[0x05, 0x01]);
        assert_eq!(r.vec8(), Err(TlsError::Decode));
    }

    #[test]
    fn reader_rejects_trailing_bytes() {
        let mut r = Reader::new(&[1, 2, 3]);
        r.take(2).unwrap();
        assert_eq!(r.expect_end(), Err(TlsError::Decode));
        r.take(1).unwrap();
        assert!(r.expect_end().is_ok());
    }

    // -- Records ------------------------------------------------------------

    #[test]
    fn record_roundtrip_and_header_shape() {
        let rec = encode_record(CT_HANDSHAKE, b"hello").unwrap();
        assert_eq!(rec[0], CT_HANDSHAKE);
        assert_eq!(&rec[1..3], &[0x03, 0x03]);
        assert_eq!(&rec[3..5], &[0x00, 0x05]);
        let p = parse_record(&rec).unwrap();
        assert_eq!(p.content_type, CT_HANDSHAKE);
        assert_eq!(p.fragment, b"hello");
        assert_eq!(p.consumed, rec.len());
    }

    #[test]
    fn record_rejects_an_overlong_plaintext() {
        let big = vec![0u8; MAX_PLAINTEXT + 1];
        assert_eq!(
            encode_record(CT_APPLICATION_DATA, &big),
            Err(TlsError::BadLength)
        );
    }

    /// A protected record may exceed the *plaintext* bound (content type +
    /// padding + tag), so the parser must use the ciphertext bound. Applying
    /// the wrong one here would reject conforming peers at the top of the
    /// size range.
    #[test]
    fn parser_admits_ciphertext_sized_records() {
        let mut hdr = vec![CT_APPLICATION_DATA, 0x03, 0x03];
        hdr.extend_from_slice(&(MAX_CIPHERTEXT as u16).to_be_bytes());
        hdr.resize(hdr.len() + MAX_CIPHERTEXT, 0u8);
        assert!(parse_record(&hdr).is_ok());

        let mut too_big = vec![CT_APPLICATION_DATA, 0x03, 0x03];
        too_big.extend_from_slice(&((MAX_CIPHERTEXT + 1) as u16).to_be_bytes());
        too_big.resize(too_big.len() + MAX_CIPHERTEXT + 1, 0u8);
        assert_eq!(parse_record(&too_big), Err(TlsError::Decode));
    }

    #[test]
    fn parse_record_reports_consumed_so_a_stream_can_be_walked() {
        let a = encode_record(CT_HANDSHAKE, b"one").unwrap();
        let b = encode_record(CT_APPLICATION_DATA, b"twotwo").unwrap();
        let mut stream = a.clone();
        stream.extend_from_slice(&b);
        let r1 = parse_record(&stream).unwrap();
        assert_eq!(r1.fragment, b"one");
        let r2 = parse_record(&stream[r1.consumed..]).unwrap();
        assert_eq!(r2.fragment, b"twotwo");
        assert_eq!(r2.content_type, CT_APPLICATION_DATA);
    }

    // -- Inner plaintext ----------------------------------------------------

    #[test]
    fn inner_plaintext_roundtrip_with_padding() {
        for pad in [0usize, 1, 17] {
            let ip = inner_plaintext(b"body", CT_HANDSHAKE, pad);
            assert_eq!(ip.len(), 4 + 1 + pad);
            let (content, ct) = split_inner_plaintext(&ip).unwrap();
            assert_eq!(content, b"body");
            assert_eq!(ct, CT_HANDSHAKE);
        }
    }

    /// Content that itself ends in zero bytes must still round-trip: the
    /// content type separates it from the padding, so the scan stops at the
    /// type octet and never eats real content.
    #[test]
    fn inner_plaintext_preserves_trailing_zero_content() {
        let ip = inner_plaintext(&[1, 0, 0, 0], CT_APPLICATION_DATA, 5);
        let (content, ct) = split_inner_plaintext(&ip).unwrap();
        assert_eq!(content, &[1, 0, 0, 0]);
        assert_eq!(ct, CT_APPLICATION_DATA);
    }

    #[test]
    fn all_zero_inner_plaintext_is_rejected() {
        assert_eq!(split_inner_plaintext(&[0, 0, 0]), Err(TlsError::Decode));
        assert_eq!(split_inner_plaintext(&[]), Err(TlsError::Decode));
    }

    #[test]
    fn record_aad_matches_the_outer_header() {
        let body = vec![0xABu8; 40];
        let rec = encode_record(CT_APPLICATION_DATA, &body).unwrap();
        assert_eq!(record_aad(body.len()), rec[..5]);
    }

    // -- Handshake framing --------------------------------------------------

    #[test]
    fn handshake_framing_roundtrip() {
        let m = encode_handshake(HS_FINISHED, &[0xEE; 48]).unwrap();
        assert_eq!(m[0], HS_FINISHED);
        assert_eq!(&m[1..4], &[0x00, 0x00, 0x30]); // 48
        let p = parse_handshake(&m).unwrap();
        assert_eq!(p.msg_type, HS_FINISHED);
        assert_eq!(p.body.len(), 48);
        assert_eq!(p.consumed, 52);
    }

    // -- ClientHello --------------------------------------------------------

    fn sample_client_hello() -> ClientHello {
        ClientHello {
            random: [0x11; 32],
            legacy_session_id: vec![0x22; 32],
            cipher_suites: vec![TLS_AES_256_GCM_SHA384],
            supported_versions: vec![TLS13_VERSION],
            key_share_x25519: Some([0x33; 32]),
            signature_algorithms: vec![SIG_ED25519],
        }
    }

    #[test]
    fn client_hello_roundtrip() {
        let ch = sample_client_hello();
        let msg = ch.encode().unwrap();
        let p = parse_handshake(&msg).unwrap();
        assert_eq!(p.msg_type, HS_CLIENT_HELLO);
        assert_eq!(p.consumed, msg.len());
        let back = ClientHello::parse(p.body).unwrap();
        assert_eq!(back.random, ch.random);
        assert_eq!(back.legacy_session_id, ch.legacy_session_id);
        assert_eq!(back.cipher_suites, ch.cipher_suites);
        assert_eq!(back.supported_versions, ch.supported_versions);
        assert_eq!(back.key_share_x25519, ch.key_share_x25519);
        assert_eq!(back.signature_algorithms, ch.signature_algorithms);
        assert!(back.offers_tls13());
        assert!(back.offers_suite(TLS_AES_256_GCM_SHA384));
    }

    /// `legacy_version` must NOT be read as the offered version. A client that
    /// writes 0x0303 there and omits `supported_versions` is TLS 1.2, and
    /// treating it as 1.3 is a downgrade waiting to happen.
    #[test]
    fn tls13_is_decided_by_the_extension_not_legacy_version() {
        let mut ch = sample_client_hello();
        ch.supported_versions = vec![0x0303];
        let msg = ch.encode().unwrap();
        let back = ClientHello::parse(parse_handshake(&msg).unwrap().body).unwrap();
        assert!(!back.offers_tls13());
        // …and the legacy field on the wire still says 0x0303 either way.
        let body = parse_handshake(&msg).unwrap().body;
        assert_eq!(&body[..2], &[0x03, 0x03]);
    }

    #[test]
    fn client_hello_rejects_truncation_at_every_prefix() {
        let ch = sample_client_hello();
        let msg = ch.encode().unwrap();
        let body = parse_handshake(&msg).unwrap().body;
        // Every proper prefix must fail to parse rather than panic or succeed.
        for n in 0..body.len() {
            assert!(
                ClientHello::parse(&body[..n]).is_err(),
                "prefix of length {n} parsed as a whole ClientHello"
            );
        }
        assert!(ClientHello::parse(body).is_ok());
    }

    #[test]
    fn client_hello_rejects_trailing_bytes() {
        let ch = sample_client_hello();
        let msg = ch.encode().unwrap();
        let mut body = parse_handshake(&msg).unwrap().body.to_vec();
        body.push(0x00);
        assert_eq!(ClientHello::parse(&body), Err(TlsError::Decode));
    }

    #[test]
    fn unknown_extensions_are_skipped_not_fatal() {
        // Hand-build an extensions block: an unknown type, then key_share.
        let mut w = Writer::new();
        w.u16(0xFEED);
        w.vec16(|w| {
            w.bytes(b"who knows");
            Ok(())
        })
        .unwrap();
        w.u16(EXT_SUPPORTED_VERSIONS);
        w.vec16(|w| {
            w.vec8(|w| {
                w.u16(TLS13_VERSION);
                Ok(())
            })
        })
        .unwrap();
        let ext = w.into_vec();

        let mut seen = Vec::new();
        for_each_extension(&ext, |t, _| {
            seen.push(t);
            Ok(())
        })
        .unwrap();
        assert_eq!(seen, vec![0xFEED, EXT_SUPPORTED_VERSIONS]);
    }

    #[test]
    fn malformed_extension_block_is_rejected() {
        // Declares 9 bytes of extension data but supplies 2.
        let bad = [0xFE, 0xED, 0x00, 0x09, 0x01, 0x02];
        assert_eq!(
            for_each_extension(&bad, |_, _| Ok(())),
            Err(TlsError::Decode)
        );
    }

    // -- ServerHello --------------------------------------------------------

    #[test]
    fn server_hello_roundtrip() {
        let sh = ServerHello {
            random: [0x44; 32],
            legacy_session_id_echo: vec![0x22; 32],
            cipher_suite: TLS_AES_256_GCM_SHA384,
            key_share_x25519: Some([0x55; 32]),
            selected_version: Some(TLS13_VERSION),
        };
        let msg = sh.encode().unwrap();
        let p = parse_handshake(&msg).unwrap();
        assert_eq!(p.msg_type, HS_SERVER_HELLO);
        let back = ServerHello::parse(p.body).unwrap();
        assert_eq!(back.random, sh.random);
        assert_eq!(back.legacy_session_id_echo, sh.legacy_session_id_echo);
        assert_eq!(back.cipher_suite, TLS_AES_256_GCM_SHA384);
        assert_eq!(back.key_share_x25519, sh.key_share_x25519);
        assert_eq!(back.selected_version, Some(TLS13_VERSION));
        assert!(!back.is_hello_retry_request());
    }

    /// The HRR random is the RFC's constant, and the RFC states it equals
    /// SHA-256("HelloRetryRequest"). Recompute it rather than trusting the
    /// array above to have been typed correctly.
    #[test]
    fn hello_retry_random_is_the_rfc_constant() {
        use riina_core::crypto::sha2::Sha256;
        assert_eq!(
            Sha256::hash(b"HelloRetryRequest").as_slice(),
            &HELLO_RETRY_REQUEST_RANDOM
        );
    }

    #[test]
    fn hello_retry_request_is_detected_not_mistaken_for_a_server_hello() {
        let hrr = ServerHello {
            random: HELLO_RETRY_REQUEST_RANDOM,
            legacy_session_id_echo: vec![],
            cipher_suite: TLS_AES_256_GCM_SHA384,
            key_share_x25519: None,
            selected_version: Some(TLS13_VERSION),
        };
        let msg = hrr.encode().unwrap();
        let back = ServerHello::parse(parse_handshake(&msg).unwrap().body).unwrap();
        assert!(back.is_hello_retry_request());
    }

    // -- Certificate / CertificateVerify ------------------------------------

    #[test]
    fn certificate_roundtrip_via_spki() {
        let raw = [0x66u8; 32];
        let msg = encode_certificate(&raw).unwrap();
        let p = parse_handshake(&msg).unwrap();
        assert_eq!(p.msg_type, HS_CERTIFICATE);
        assert_eq!(parse_certificate(p.body).unwrap(), raw);
    }

    #[test]
    fn spki_prefix_is_checked_not_just_the_length() {
        let mut spki = ed25519_spki(&[0x77; 32]);
        assert_eq!(spki.len(), ED25519_SPKI_LEN);
        // Corrupt the algorithm OID: same length, different algorithm.
        spki[6] = 0x2c;
        assert_eq!(ed25519_from_spki(&spki), Err(TlsError::Decode));
        // …and a right-length blob of the wrong shape is refused too.
        assert_eq!(ed25519_from_spki(&[0u8; ED25519_SPKI_LEN]), Err(TlsError::Decode));
    }

    #[test]
    fn empty_certificate_list_is_rejected() {
        let mut w = Writer::new();
        w.vec8(|_| Ok(())).unwrap();
        w.vec24(|_| Ok(())).unwrap();
        assert_eq!(parse_certificate(&w.into_vec()), Err(TlsError::Decode));
    }

    #[test]
    fn certificate_verify_roundtrip() {
        let sig = [0x88u8; 64];
        let msg = encode_certificate_verify(SIG_ED25519, &sig).unwrap();
        let p = parse_handshake(&msg).unwrap();
        assert_eq!(p.msg_type, HS_CERTIFICATE_VERIFY);
        let (alg, got) = parse_certificate_verify(p.body).unwrap();
        assert_eq!(alg, SIG_ED25519);
        assert_eq!(got, sig);
    }

    #[test]
    fn finished_and_encrypted_extensions_frame_correctly() {
        let f = encode_finished(&[0x99; 48]).unwrap();
        let p = parse_handshake(&f).unwrap();
        assert_eq!(p.msg_type, HS_FINISHED);
        assert_eq!(p.body, [0x99u8; 48]);

        let ee = encode_encrypted_extensions().unwrap();
        let p = parse_handshake(&ee).unwrap();
        assert_eq!(p.msg_type, HS_ENCRYPTED_EXTENSIONS);
        assert_eq!(p.body, [0x00, 0x00]); // an empty extensions vector
    }
}

// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! TLS 1.3 record protection (RFC 8446 §5.2–5.3, §7.1) — REAL AEAD.
//!
//! This is the FIRST increment of the TLS record-crypto port (owner-approved
//! 2026-08-09). It implements the record-protection *mechanism* of TLS 1.3 on
//! the **proven** primitives in `riina-core`:
//!   * key derivation — HKDF-Expand-Label / Derive-Secret (RFC 8446 §7.1),
//!     built on `riina_core::crypto::hkdf::HkdfSha256`;
//!   * per-record nonce — static IV XOR big-endian sequence number
//!     (RFC 8446 §5.3);
//!   * AEAD — `riina_core::crypto::gcm::Aes256Gcm`
//!     (`encrypt`/`decrypt`, real GF(2^128) GHASH + CTR).
//!
//! What is REAL vs what is NOT (no overclaiming — Prime Directive 2):
//!   * REAL: bytes are genuinely AEAD-sealed and opened; tampering,
//!     wrong-sequence, and wrong-key all fail authentication. Two RIINA peers
//!     that share a traffic secret get a confidential, integrity-protected
//!     channel over the verified TCP sockets (`riina-os` net).
//!   * **The cryptographic suite is now standard; the wire format is not.**
//!     This module is parameterised over [`HashAlg`], and the default
//!     everywhere in RIINA is SHA-384 — so the algorithms in play are exactly
//!     those of the IANA-registered **`TLS_AES_256_GCM_SHA384`**: AES-256-GCM
//!     record protection, an HKDF-SHA384 key schedule, SHA-384 transcripts and
//!     HMAC-SHA384 Finished. (The SHA-256 variant is retained for the existing
//!     tests but, paired with AES-256-GCM, names *no* registered suite.)
//!
//!     **Interop is closer but still incomplete.** As of increment 5 the
//!     handshake speaks the real RFC 8446 message format ([`wire`]), and a
//!     stock OpenSSL server accepts RIINA's ClientHello and answers with a
//!     ServerHello RIINA parses. What remains is the **record layer**: the
//!     messages after ServerHello must be encrypted under the handshake
//!     traffic keys (§5.2), and RIINA does not do that yet, so a real server's
//!     flight is unreadable to it. Beyond that, RIINA authenticates with
//!     RFC 7250 raw public keys, which OpenSSL does not enable by default.
//!     Stating this precisely because "supports TLS_AES_256_GCM_SHA384" would
//!     otherwise imply a completed handshake that does not exist.
//!   * No handshake in THIS module — callers may supply a traffic secret
//!     directly. The handshake that establishes one (ephemeral X25519, the
//!     §7.1 key schedule, transcript binding and Finished) landed as
//!     increment 2 in [`handshake`]; read that module's header for what it
//!     does and does NOT provide (notably: it is anonymous — no certificate
//!     verification, so it does not withstand an active MITM).
//!
//! Law 8: the only dependency is first-party `riina-core`. No `unsafe`.

#![forbid(unsafe_code)]

pub mod auth;
pub mod handshake;
pub mod wire;

use riina_core::crypto::gcm::{Aes256Gcm, KEY_SIZE, NONCE_SIZE, TAG_SIZE};
use riina_core::crypto::hkdf::{HkdfSha256, HkdfSha384};
use riina_core::crypto::hmac::{HmacSha256, HmacSha384};
use riina_core::crypto::sha2::{Sha256, Sha384};

/// The largest hash output this module handles (SHA-384 → 48). Used to size
/// stack buffers; the *active* length is always [`HashAlg::hash_len`].
pub const MAX_HASH_LEN: usize = 48;

/// Which hash the TLS key schedule runs on.
///
/// TLS 1.3 does not have a free choice here: the hash is fixed by the cipher
/// suite. Of the IANA-registered suites, the one this crate can instantiate is
/// **`TLS_AES_256_GCM_SHA384`** — AES-256-GCM paired with SHA-384. The
/// SHA-256 variant is retained because it is what increments 1–3 shipped and
/// what existing sessions/tests use, but note it corresponds to **no
/// registered suite** (IANA pairs AES-256-GCM only with SHA-384; SHA-256 goes
/// with AES-128-GCM and ChaCha20-Poly1305, neither of which riina-core has).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum HashAlg {
    /// SHA-256 schedule. Non-standard with AES-256-GCM — RIINA↔RIINA only.
    Sha256,
    /// SHA-384 schedule — the hash of the registered `TLS_AES_256_GCM_SHA384`.
    Sha384,
}

impl HashAlg {
    /// Digest length in bytes (`Hash.length` in RFC 8446).
    #[must_use]
    pub const fn hash_len(self) -> usize {
        match self {
            Self::Sha256 => 32,
            Self::Sha384 => 48,
        }
    }

    /// The IANA cipher-suite name this hash pairs with in this crate, or
    /// `None` when the pairing is not a registered suite.
    #[must_use]
    pub const fn iana_suite(self) -> Option<&'static str> {
        match self {
            Self::Sha384 => Some("TLS_AES_256_GCM_SHA384"),
            Self::Sha256 => None,
        }
    }

    /// The cipher-suite code point to put on the wire for this hash.
    ///
    /// SHA-384 gets the registered `TLS_AES_256_GCM_SHA384` (0x1302). SHA-256
    /// paired with AES-256-GCM is not a registered suite, so it gets a code
    /// point from the IANA **Reserved for Private Use** range rather than
    /// borrowing 0x1302 — squatting on a registered number would make RIINA
    /// announce a suite whose algorithms it is not actually using, which is a
    /// far worse failure than being non-interoperable honestly.
    #[must_use]
    pub const fn wire_suite(self) -> u16 {
        match self {
            Self::Sha384 => wire::TLS_AES_256_GCM_SHA384,
            Self::Sha256 => wire::RIINA_AES_256_GCM_SHA256_PRIVATE,
        }
    }

    /// The hash a wire cipher-suite code point selects, if this crate knows it.
    #[must_use]
    pub const fn from_wire_suite(suite: u16) -> Option<Self> {
        match suite {
            wire::TLS_AES_256_GCM_SHA384 => Some(Self::Sha384),
            wire::RIINA_AES_256_GCM_SHA256_PRIVATE => Some(Self::Sha256),
            _ => None,
        }
    }

    /// `Transcript-Hash` / `Hash(...)`.
    #[must_use]
    pub fn hash(self, data: &[u8]) -> Vec<u8> {
        match self {
            Self::Sha256 => Sha256::hash(data).to_vec(),
            Self::Sha384 => Sha384::hash(data).to_vec(),
        }
    }

    /// HMAC under this hash (the Finished MAC and HKDF's PRF).
    #[must_use]
    pub fn hmac(self, key: &[u8], data: &[u8]) -> Vec<u8> {
        match self {
            Self::Sha256 => HmacSha256::mac(key, data).to_vec(),
            Self::Sha384 => HmacSha384::mac(key, data).to_vec(),
        }
    }

    /// Constant-time HMAC verification — a variable-time compare would leak
    /// the expected MAC.
    #[must_use]
    pub fn hmac_verify(self, key: &[u8], data: &[u8], tag: &[u8]) -> bool {
        match self {
            Self::Sha256 => HmacSha256::verify(key, data, tag),
            Self::Sha384 => HmacSha384::verify(key, data, tag),
        }
    }

    /// HKDF-Extract.
    #[must_use]
    pub fn hkdf_extract(self, salt: &[u8], ikm: &[u8]) -> Vec<u8> {
        match self {
            Self::Sha256 => HkdfSha256::extract(salt, ikm).to_vec(),
            Self::Sha384 => HkdfSha384::extract(salt, ikm).to_vec(),
        }
    }

    /// HKDF-Expand into `out`.
    ///
    /// # Errors
    /// [`TlsError::BadLength`] if `out` exceeds the RFC 5869 255-block bound.
    pub fn hkdf_expand(self, prk: &[u8], info: &[u8], out: &mut [u8]) -> Result<(), TlsError> {
        match self {
            Self::Sha256 => HkdfSha256::expand(prk, info, out).map_err(|_| TlsError::BadLength),
            Self::Sha384 => HkdfSha384::expand(prk, info, out).map_err(|_| TlsError::BadLength),
        }
    }
}

/// Record-protection errors. Deliberately coarse — a TLS peer must not learn
/// *why* a record failed to open (padding-oracle discipline), so open failures
/// collapse to a single `BadRecord`.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TlsError {
    /// AEAD open failed: bad tag, wrong key, wrong sequence, or truncation —
    /// deliberately indistinguishable.
    BadRecord,
    /// A derive/expand length was out of the HKDF range.
    BadLength,
    /// A handshake step failed: Finished did not verify (which includes any
    /// transcript disagreement) or a key share was degenerate. Coarse on
    /// purpose — a peer must not learn which.
    HandshakeFailed,
    /// The OS CSPRNG could not be read. Fails closed: there is deliberately no
    /// weaker fallback, since a predictable ephemeral key destroys forward
    /// secrecy silently.
    NoEntropy,
    /// A wire structure did not parse: truncation, an inconsistent length, an
    /// unexpected trailing byte, or a field of the wrong shape. Distinct from
    /// [`Self::BadRecord`] because it describes *parsing* a structure, not
    /// opening an AEAD — there is no padding-oracle concern in reporting that
    /// a peer's bytes were malformed, and collapsing the two would make
    /// debugging a wire mismatch needlessly blind.
    Decode,
}

/// RFC 8446 §7.1 HKDF-Expand-Label.
///
/// ```text
/// HKDF-Expand-Label(Secret, Label, Context, Length) =
///     HKDF-Expand(Secret, HkdfLabel, Length)
/// struct {
///     uint16 length = Length;
///     opaque label<7..255> = "tls13 " + Label;
///     opaque context<0..255> = Context;
/// } HkdfLabel;
/// ```
///
/// # Errors
/// [`TlsError::BadLength`] if `length` exceeds the HKDF-SHA256 output bound or
/// the label/context violate the RFC length limits.
pub fn hkdf_expand_label(
    alg: HashAlg,
    secret: &[u8],
    label: &[u8],
    context: &[u8],
    length: u16,
) -> Result<Vec<u8>, TlsError> {
    // "tls13 " prefix (6 bytes) + label; the whole thing is opaque<7..255>.
    let full_label_len = 6 + label.len();
    if !(7..=255).contains(&full_label_len) || context.len() > 255 {
        return Err(TlsError::BadLength);
    }
    let mut info = Vec::with_capacity(2 + 1 + full_label_len + 1 + context.len());
    info.extend_from_slice(&length.to_be_bytes());
    info.push(full_label_len as u8);
    info.extend_from_slice(b"tls13 ");
    info.extend_from_slice(label);
    info.push(context.len() as u8);
    info.extend_from_slice(context);

    let mut out = vec![0u8; length as usize];
    alg.hkdf_expand(secret, &info, &mut out)?;
    Ok(out)
}

/// RFC 8446 §7.1 Derive-Secret(Secret, Label, Messages) =
/// HKDF-Expand-Label(Secret, Label, Transcript-Hash(Messages), Hash.length).
/// The caller passes the already-computed transcript hash.
///
/// # Errors
/// [`TlsError::BadLength`] on an out-of-range label.
pub fn derive_secret(
    alg: HashAlg,
    secret: &[u8],
    label: &[u8],
    transcript_hash: &[u8],
) -> Result<Vec<u8>, TlsError> {
    hkdf_expand_label(
        alg,
        secret,
        label,
        transcript_hash,
        u16::try_from(alg.hash_len()).map_err(|_| TlsError::BadLength)?,
    )
}

/// The per-direction record-protection key material, derived from a traffic
/// secret (RFC 8446 §7.3): `key = Expand-Label(secret,"key","",key_len)` and
/// `iv = Expand-Label(secret,"iv","",iv_len)`.
#[derive(Clone)]
pub struct RecordKeys {
    key: [u8; KEY_SIZE],
    iv: [u8; NONCE_SIZE],
}

impl RecordKeys {
    /// Derive from a `HASH_LEN`-byte traffic secret.
    ///
    /// # Errors
    /// [`TlsError::BadLength`] should not occur for the fixed lengths here, but
    /// is propagated rather than panicked.
    pub fn derive(alg: HashAlg, traffic_secret: &[u8]) -> Result<Self, TlsError> {
        let key_v = hkdf_expand_label(alg, traffic_secret, b"key", b"", KEY_SIZE as u16)?;
        let iv_v = hkdf_expand_label(alg, traffic_secret, b"iv", b"", NONCE_SIZE as u16)?;
        let mut key = [0u8; KEY_SIZE];
        let mut iv = [0u8; NONCE_SIZE];
        key.copy_from_slice(&key_v);
        iv.copy_from_slice(&iv_v);
        Ok(Self { key, iv })
    }

    /// RFC 8446 §5.3 per-record nonce: the 64-bit big-endian sequence number,
    /// left-padded to the IV length, XORed with the static IV.
    fn nonce(&self, seq: u64) -> [u8; NONCE_SIZE] {
        let mut n = self.iv;
        let seq_be = seq.to_be_bytes(); // 8 bytes
        // XOR into the RIGHTMOST 8 bytes (the left NONCE_SIZE-8 bytes are the
        // IV unchanged — the padding is implicit zero, so XOR is a no-op there).
        for i in 0..8 {
            n[NONCE_SIZE - 8 + i] ^= seq_be[i];
        }
        n
    }

    /// Seal `plaintext` as an application-data record body: returns
    /// `ciphertext || tag`. `aad` is the TLS record header (RFC 8446 §5.2);
    /// callers that have no header yet may pass `&[]` for a headerless AEAD
    /// channel (still authenticated).
    ///
    /// # Errors
    /// [`TlsError::BadRecord`] if the underlying AEAD rejects the parameters
    /// (should not happen for valid inputs).
    pub fn protect(&self, seq: u64, aad: &[u8], plaintext: &[u8]) -> Result<Vec<u8>, TlsError> {
        let cipher = Aes256Gcm::new(&self.key);
        let nonce = self.nonce(seq);
        let mut out = vec![0u8; plaintext.len() + TAG_SIZE];
        cipher
            .encrypt(&nonce, aad, plaintext, &mut out)
            .map_err(|_| TlsError::BadRecord)?;
        Ok(out)
    }

    /// Open a protected record body (`ciphertext || tag`) → plaintext.
    ///
    /// # Errors
    /// [`TlsError::BadRecord`] on any failure — bad tag, wrong key, wrong
    /// sequence, or truncation — deliberately indistinguishable.
    pub fn unprotect(&self, seq: u64, aad: &[u8], record: &[u8]) -> Result<Vec<u8>, TlsError> {
        if record.len() < TAG_SIZE {
            return Err(TlsError::BadRecord);
        }
        let cipher = Aes256Gcm::new(&self.key);
        let nonce = self.nonce(seq);
        let mut out = vec![0u8; record.len() - TAG_SIZE];
        cipher
            .decrypt(&nonce, aad, record, &mut out)
            .map_err(|_| TlsError::BadRecord)?;
        Ok(out)
    }
}

#[cfg(test)]
mod tests {
    /// These record-layer tests are hash-agnostic in substance; run them under
    /// the standard suite's hash. `hash_alg_switch_changes_derivation` covers
    /// the difference between the two.
    const ALG: HashAlg = HashAlg::Sha384;

    use super::*;

    // A fixed 32-byte "traffic secret" for the tests (not secret here).
    const SECRET: [u8; 32] = [
        0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
        0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e,
        0x1f, 0x20,
    ];

    #[test]
    fn expand_label_structure_and_determinism() {
        // Same inputs → same output; different label → different output.
        let a = hkdf_expand_label(ALG, &SECRET, b"key", b"", 32).unwrap();
        let b = hkdf_expand_label(ALG, &SECRET, b"key", b"", 32).unwrap();
        let c = hkdf_expand_label(ALG, &SECRET, b"iv", b"", 32).unwrap();
        assert_eq!(a, b, "deterministic");
        assert_ne!(a, c, "label is bound into the derivation");
        assert_eq!(a.len(), 32);
    }

    #[test]
    fn expand_label_rejects_out_of_range() {
        // Empty label → full label "tls13 " = 6 < 7 minimum.
        assert_eq!(
            hkdf_expand_label(ALG, &SECRET, b"", b"", 32),
            Err(TlsError::BadLength)
        );
        // Context > 255.
        assert_eq!(
            hkdf_expand_label(ALG, &SECRET, b"key", &[0u8; 256], 32),
            Err(TlsError::BadLength)
        );
    }

    #[test]
    fn key_and_iv_are_distinct_and_sized() {
        let k = RecordKeys::derive(ALG, &SECRET).unwrap();
        assert_eq!(k.key.len(), KEY_SIZE);
        assert_eq!(k.iv.len(), NONCE_SIZE);
        // key and iv derive from different labels, so their common prefix must
        // not be identical.
        assert_ne!(&k.key[..NONCE_SIZE], &k.iv[..]);
    }

    #[test]
    fn nonce_xors_sequence_into_the_low_bytes() {
        let k = RecordKeys::derive(ALG, &SECRET).unwrap();
        let n0 = k.nonce(0);
        assert_eq!(n0, k.iv, "seq 0 leaves the IV unchanged");
        let n1 = k.nonce(1);
        // Only the last byte differs, by 1.
        assert_eq!(n1[NONCE_SIZE - 1], k.iv[NONCE_SIZE - 1] ^ 1);
        assert_eq!(&n1[..NONCE_SIZE - 1], &k.iv[..NONCE_SIZE - 1]);
    }

    #[test]
    fn protect_unprotect_roundtrip() {
        let k = RecordKeys::derive(ALG, &SECRET).unwrap();
        let aad = b"\x17\x03\x03\x00\x2a"; // a plausible TLS record header
        let msg = b"salam dunia dari RIINA";
        let sealed = k.protect(7, aad, msg).unwrap();
        assert_eq!(sealed.len(), msg.len() + TAG_SIZE, "adds exactly one tag");
        assert_ne!(&sealed[..msg.len()], &msg[..], "body is actually encrypted");
        let opened = k.unprotect(7, aad, &sealed).unwrap();
        assert_eq!(opened, msg);
    }

    #[test]
    fn tamper_is_rejected() {
        let k = RecordKeys::derive(ALG, &SECRET).unwrap();
        let mut sealed = k.protect(1, b"", b"secret payload").unwrap();
        sealed[0] ^= 0x01; // flip a ciphertext bit
        assert_eq!(k.unprotect(1, b"", &sealed), Err(TlsError::BadRecord));
    }

    #[test]
    fn wrong_sequence_is_rejected() {
        // The nonce binds the sequence number, so opening at the wrong seq
        // fails authentication — this is TLS's replay/reorder protection.
        let k = RecordKeys::derive(ALG, &SECRET).unwrap();
        let sealed = k.protect(4, b"", b"in order").unwrap();
        assert_eq!(k.unprotect(5, b"", &sealed), Err(TlsError::BadRecord));
        assert_eq!(k.unprotect(4, b"", &sealed).unwrap(), b"in order");
    }

    #[test]
    fn wrong_aad_is_rejected() {
        let k = RecordKeys::derive(ALG, &SECRET).unwrap();
        let sealed = k.protect(0, b"header-A", b"body").unwrap();
        assert_eq!(k.unprotect(0, b"header-B", &sealed), Err(TlsError::BadRecord));
    }

    #[test]
    fn wrong_key_is_rejected() {
        let k1 = RecordKeys::derive(ALG, &SECRET).unwrap();
        let mut other = SECRET;
        other[0] ^= 0xff;
        let k2 = RecordKeys::derive(ALG, &other).unwrap();
        let sealed = k1.protect(0, b"", b"for k1 only").unwrap();
        assert_eq!(k2.unprotect(0, b"", &sealed), Err(TlsError::BadRecord));
    }

    #[test]
    fn truncated_record_is_rejected() {
        let k = RecordKeys::derive(ALG, &SECRET).unwrap();
        assert_eq!(k.unprotect(0, b"", b"short"), Err(TlsError::BadRecord));
    }
}

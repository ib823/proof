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
//!   * NOT a wire-interoperable named ciphersuite YET. IANA pairs AES-256-GCM
//!     with SHA-384 (`TLS_AES_256_GCM_SHA384`), whereas this module is keyed
//!     by an HKDF-**SHA256** schedule — self-consistent RIINA↔RIINA, but it
//!     will NOT interoperate with OpenSSL et al.
//!
//!     **Status update (2026-08-11):** the missing primitives now exist —
//!     riina-core ships `Sha384` (FIPS 180-4 KATs), `HmacSha384` (RFC 4231
//!     KATs) and `HkdfSha384`. So the remaining work is no longer "add the
//!     crypto" but **parameterising this module over the hash**: `HASH_LEN`,
//!     `derive_secret`, `RecordKeys`, the key schedule, the transcript and
//!     the Finished MAC are all hard-wired to SHA-256 today. That refactor is
//!     the next increment; until it lands, wire interop remains unavailable
//!     and this note is the accurate statement of why.
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

use riina_core::crypto::gcm::{Aes256Gcm, KEY_SIZE, NONCE_SIZE, TAG_SIZE};
use riina_core::crypto::hkdf::HkdfSha256;

/// The hash output length of the KDF (SHA-256 → 32). In a fully standard
/// TLS_AES_256_GCM_SHA384 this would be 48; see the module honesty note.
pub const HASH_LEN: usize = 32;

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
    HkdfSha256::expand(secret, &info, &mut out).map_err(|_| TlsError::BadLength)?;
    Ok(out)
}

/// RFC 8446 §7.1 Derive-Secret(Secret, Label, Messages) =
/// HKDF-Expand-Label(Secret, Label, Transcript-Hash(Messages), Hash.length).
/// The caller passes the already-computed transcript hash.
///
/// # Errors
/// [`TlsError::BadLength`] on an out-of-range label.
pub fn derive_secret(
    secret: &[u8],
    label: &[u8],
    transcript_hash: &[u8],
) -> Result<[u8; HASH_LEN], TlsError> {
    let v = hkdf_expand_label(secret, label, transcript_hash, HASH_LEN as u16)?;
    let mut out = [0u8; HASH_LEN];
    out.copy_from_slice(&v);
    Ok(out)
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
    pub fn derive(traffic_secret: &[u8]) -> Result<Self, TlsError> {
        let key_v = hkdf_expand_label(traffic_secret, b"key", b"", KEY_SIZE as u16)?;
        let iv_v = hkdf_expand_label(traffic_secret, b"iv", b"", NONCE_SIZE as u16)?;
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
        let a = hkdf_expand_label(&SECRET, b"key", b"", 32).unwrap();
        let b = hkdf_expand_label(&SECRET, b"key", b"", 32).unwrap();
        let c = hkdf_expand_label(&SECRET, b"iv", b"", 32).unwrap();
        assert_eq!(a, b, "deterministic");
        assert_ne!(a, c, "label is bound into the derivation");
        assert_eq!(a.len(), 32);
    }

    #[test]
    fn expand_label_rejects_out_of_range() {
        // Empty label → full label "tls13 " = 6 < 7 minimum.
        assert_eq!(
            hkdf_expand_label(&SECRET, b"", b"", 32),
            Err(TlsError::BadLength)
        );
        // Context > 255.
        assert_eq!(
            hkdf_expand_label(&SECRET, b"key", &[0u8; 256], 32),
            Err(TlsError::BadLength)
        );
    }

    #[test]
    fn key_and_iv_are_distinct_and_sized() {
        let k = RecordKeys::derive(&SECRET).unwrap();
        assert_eq!(k.key.len(), KEY_SIZE);
        assert_eq!(k.iv.len(), NONCE_SIZE);
        // key and iv derive from different labels, so their common prefix must
        // not be identical.
        assert_ne!(&k.key[..NONCE_SIZE], &k.iv[..]);
    }

    #[test]
    fn nonce_xors_sequence_into_the_low_bytes() {
        let k = RecordKeys::derive(&SECRET).unwrap();
        let n0 = k.nonce(0);
        assert_eq!(n0, k.iv, "seq 0 leaves the IV unchanged");
        let n1 = k.nonce(1);
        // Only the last byte differs, by 1.
        assert_eq!(n1[NONCE_SIZE - 1], k.iv[NONCE_SIZE - 1] ^ 1);
        assert_eq!(&n1[..NONCE_SIZE - 1], &k.iv[..NONCE_SIZE - 1]);
    }

    #[test]
    fn protect_unprotect_roundtrip() {
        let k = RecordKeys::derive(&SECRET).unwrap();
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
        let k = RecordKeys::derive(&SECRET).unwrap();
        let mut sealed = k.protect(1, b"", b"secret payload").unwrap();
        sealed[0] ^= 0x01; // flip a ciphertext bit
        assert_eq!(k.unprotect(1, b"", &sealed), Err(TlsError::BadRecord));
    }

    #[test]
    fn wrong_sequence_is_rejected() {
        // The nonce binds the sequence number, so opening at the wrong seq
        // fails authentication — this is TLS's replay/reorder protection.
        let k = RecordKeys::derive(&SECRET).unwrap();
        let sealed = k.protect(4, b"", b"in order").unwrap();
        assert_eq!(k.unprotect(5, b"", &sealed), Err(TlsError::BadRecord));
        assert_eq!(k.unprotect(4, b"", &sealed).unwrap(), b"in order");
    }

    #[test]
    fn wrong_aad_is_rejected() {
        let k = RecordKeys::derive(&SECRET).unwrap();
        let sealed = k.protect(0, b"header-A", b"body").unwrap();
        assert_eq!(k.unprotect(0, b"header-B", &sealed), Err(TlsError::BadRecord));
    }

    #[test]
    fn wrong_key_is_rejected() {
        let k1 = RecordKeys::derive(&SECRET).unwrap();
        let mut other = SECRET;
        other[0] ^= 0xff;
        let k2 = RecordKeys::derive(&other).unwrap();
        let sealed = k1.protect(0, b"", b"for k1 only").unwrap();
        assert_eq!(k2.unprotect(0, b"", &sealed), Err(TlsError::BadRecord));
    }

    #[test]
    fn truncated_record_is_rejected() {
        let k = RecordKeys::derive(&SECRET).unwrap();
        assert_eq!(k.unprotect(0, b"", b"short"), Err(TlsError::BadRecord));
    }
}

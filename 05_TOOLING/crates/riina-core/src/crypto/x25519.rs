// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! X25519 Key Exchange Implementation
//!
//! This module implements X25519 (Curve25519 ECDH) as specified in RFC 7748.
//!
//! # Law 2: Cryptographic Non-Negotiables
//!
//! X25519 is used in hybrid key encapsulation alongside ML-KEM-768.
//! The combination provides security against both classical and quantum adversaries.
//!
//! # Status: IMPLEMENTATION COMPLETE (Task 1.2)
//!
//! This module provides:
//! - Constant-time field arithmetic in GF(2^255-19) ✓
//! - Montgomery ladder scalar multiplication ✓
//! - Proper key clamping ✓
//! - RFC 7748 compliance: validated against the Section 5.2 vector 1 and the
//!   Section 6.1 Diffie-Hellman vectors (see tests). All-zero (small-order)
//!   shared-secret outputs are rejected per Section 6.1.

use super::montgomery;
use crate::crypto::{CryptoError, CryptoResult};

/// X25519 private key size (32 bytes)
pub const PRIVATE_KEY_SIZE: usize = 32;
/// X25519 public key size (32 bytes)
pub const PUBLIC_KEY_SIZE: usize = 32;
/// X25519 shared secret size (32 bytes)
pub const SHARED_SECRET_SIZE: usize = 32;

/// X25519 key pair
pub struct X25519KeyPair {
    /// Private key (clamped scalar)
    private_key: [u8; PRIVATE_KEY_SIZE],
    /// Public key (point on curve)
    public_key: [u8; PUBLIC_KEY_SIZE],
}

impl X25519KeyPair {
    /// Generate a new key pair from random bytes
    ///
    /// # Arguments
    /// * `random` - 32 bytes of cryptographically secure random data
    ///
    /// # Panics
    /// Panics if random is not exactly 32 bytes.
    #[must_use]
    pub fn generate(random: &[u8; 32]) -> Self {
        let mut private_key = *random;

        // Key clamping as per RFC 7748
        private_key[0] &= 0xF8; // Clear bits 0, 1, 2
        private_key[31] &= 127; // Clear bit 255
        private_key[31] |= 64; // Set bit 254

        // Compute public key = private_key * G (basepoint)
        let public_key = montgomery::x25519_base(&private_key);

        Self {
            private_key,
            public_key,
        }
    }

    /// Get the public key
    #[must_use]
    pub fn public_key(&self) -> &[u8; PUBLIC_KEY_SIZE] {
        &self.public_key
    }

    /// Perform Diffie-Hellman key exchange
    ///
    /// # Arguments
    /// * `peer_public_key` - The peer's public key
    ///
    /// # Returns
    /// The 32-byte shared secret
    ///
    /// # Errors
    /// Returns `KeyGenerationFailed` if the result is the all-zero point.
    pub fn diffie_hellman(
        &self,
        peer_public_key: &[u8; PUBLIC_KEY_SIZE],
    ) -> CryptoResult<[u8; SHARED_SECRET_SIZE]> {
        let shared_secret = montgomery::x25519(&self.private_key, peer_public_key);

        // Check for all-zero result (contributory behavior, RFC 7748 recommends rejecting)
        let is_zero = shared_secret.iter().all(|&b| b == 0);
        if is_zero {
            return Err(CryptoError::KeyGenerationFailed);
        }

        Ok(shared_secret)
    }
}

impl Drop for X25519KeyPair {
    fn drop(&mut self) {
        // Zeroize private key (Law 4)
        use crate::zeroize::Zeroize;
        self.private_key.zeroize();
    }
}

/// Compute X25519 shared secret (standalone function)
///
/// # Arguments
/// * `private_key` - Your 32-byte private key
/// * `public_key` - Peer's 32-byte public key
///
/// # Returns
/// The 32-byte shared secret
///
/// # Errors
/// Returns error if computation fails or results in all-zero point.
pub fn x25519(
    private_key: &[u8; PRIVATE_KEY_SIZE],
    public_key: &[u8; PUBLIC_KEY_SIZE],
) -> CryptoResult<[u8; SHARED_SECRET_SIZE]> {
    let shared_secret = montgomery::x25519(private_key, public_key);

    // Check for all-zero result
    let is_zero = shared_secret.iter().all(|&b| b == 0);
    if is_zero {
        return Err(CryptoError::KeyGenerationFailed);
    }

    Ok(shared_secret)
}

/// Compute X25519 public key from private key
///
/// # Arguments
/// * `private_key` - Your 32-byte private key (will be clamped)
///
/// # Returns
/// The 32-byte public key
pub fn x25519_base(private_key: &[u8; PRIVATE_KEY_SIZE]) -> [u8; PUBLIC_KEY_SIZE] {
    montgomery::x25519_base(private_key)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_x25519_key_clamping() {
        let random = [0xffu8; 32];
        let keypair = X25519KeyPair::generate(&random);

        // Verify clamping was applied
        assert_eq!(
            keypair.private_key[0] & 7,
            0,
            "bits 0,1,2 should be cleared"
        );
        assert_eq!(
            keypair.private_key[31] & 128,
            0,
            "bit 255 should be cleared"
        );
        assert_eq!(keypair.private_key[31] & 64, 64, "bit 254 should be set");
    }

    // RFC 7748 Section 5.2 test vector 1 (authoritative).
    #[test]
    fn test_x25519_rfc7748_vector1() {
        let scalar: [u8; 32] = [
            0xa5, 0x46, 0xe3, 0x6b, 0xf0, 0x52, 0x7c, 0x9d, 0x3b, 0x16, 0x15, 0x4b, 0x82, 0x46,
            0x5e, 0xdd, 0x62, 0x14, 0x4c, 0x0a, 0xc1, 0xfc, 0x5a, 0x18, 0x50, 0x6a, 0x22, 0x44,
            0xba, 0x44, 0x9a, 0xc4,
        ];
        let u_coordinate: [u8; 32] = [
            0xe6, 0xdb, 0x68, 0x67, 0x58, 0x30, 0x30, 0xdb, 0x35, 0x94, 0xc1, 0xa4, 0x24, 0xb1,
            0x5f, 0x7c, 0x72, 0x66, 0x24, 0xec, 0x26, 0xb3, 0x35, 0x3b, 0x10, 0xa9, 0x03, 0xa6,
            0xd0, 0xab, 0x1c, 0x4c,
        ];
        let expected: [u8; 32] = [
            0xc3, 0xda, 0x55, 0x37, 0x9d, 0xe9, 0xc6, 0x90, 0x8e, 0x94, 0xea, 0x4d, 0xf2, 0x8d,
            0x08, 0x4f, 0x32, 0xec, 0xcf, 0x03, 0x49, 0x1c, 0x71, 0xf7, 0x54, 0xb4, 0x07, 0x55,
            0x77, 0xa2, 0x85, 0x52,
        ];

        let result = x25519(&scalar, &u_coordinate).unwrap();
        assert_eq!(result, expected);
    }

    /// Authoritative RFC 7748 Section 6.1 Diffie-Hellman vectors (well-known
    /// provenance). Resolves whether x25519_base is actually correct (the
    /// montgomery `vector2_basepoint` test uses a non-RFC expected value).
    #[test]
    fn test_x25519_rfc7748_section6_diffie_hellman() {
        let a: [u8; 32] = [
            0x77, 0x07, 0x6d, 0x0a, 0x73, 0x18, 0xa5, 0x7d, 0x3c, 0x16, 0xc1, 0x72, 0x51, 0xb2,
            0x66, 0x45, 0xdf, 0x4c, 0x2f, 0x87, 0xeb, 0xc0, 0x99, 0x2a, 0xb1, 0x77, 0xfb, 0xa5,
            0x1d, 0xb9, 0x2c, 0x2a,
        ];
        let ka: [u8; 32] = [
            0x85, 0x20, 0xf0, 0x09, 0x89, 0x30, 0xa7, 0x54, 0x74, 0x8b, 0x7d, 0xdc, 0xb4, 0x3e,
            0xf7, 0x5a, 0x0d, 0xbf, 0x3a, 0x0d, 0x26, 0x38, 0x1a, 0xf4, 0xeb, 0xa4, 0xa9, 0x8e,
            0xaa, 0x9b, 0x4e, 0x6a,
        ];
        let b: [u8; 32] = [
            0x5d, 0xab, 0x08, 0x7e, 0x62, 0x4a, 0x8a, 0x4b, 0x79, 0xe1, 0x7f, 0x8b, 0x83, 0x80,
            0x0e, 0xe6, 0x6f, 0x3b, 0xb1, 0x29, 0x26, 0x18, 0xb6, 0xfd, 0x1c, 0x2f, 0x8b, 0x27,
            0xff, 0x88, 0xe0, 0xeb,
        ];
        let kb: [u8; 32] = [
            0xde, 0x9e, 0xdb, 0x7d, 0x7b, 0x7d, 0xc1, 0xb4, 0xd3, 0x5b, 0x61, 0xc2, 0xec, 0xe4,
            0x35, 0x37, 0x3f, 0x83, 0x43, 0xc8, 0x5b, 0x78, 0x67, 0x4d, 0xad, 0xfc, 0x7e, 0x14,
            0x6f, 0x88, 0x2b, 0x4f,
        ];
        let k: [u8; 32] = [
            0x4a, 0x5d, 0x9d, 0x5b, 0xa4, 0xce, 0x2d, 0xe1, 0x72, 0x8e, 0x3b, 0xf4, 0x80, 0x35,
            0x0f, 0x25, 0xe0, 0x7e, 0x21, 0xc9, 0x47, 0xd1, 0x9e, 0x33, 0x76, 0xf0, 0x9b, 0x3c,
            0x1e, 0x16, 0x17, 0x42,
        ];
        assert_eq!(x25519_base(&a), ka, "Alice public KA = X25519(a, 9)");
        assert_eq!(x25519_base(&b), kb, "Bob public KB = X25519(b, 9)");
        assert_eq!(x25519(&a, &kb).unwrap(), k, "shared = X25519(a, KB)");
        assert_eq!(x25519(&b, &ka).unwrap(), k, "shared = X25519(b, KA)");
    }

    /// RFC 7748 §6.1 contributory behavior: a small-order peer u-coordinate that
    /// drives the shared secret to the all-zero point must be rejected (otherwise
    /// an attacker forces a known shared secret). u = 0 is the order-2 point; a
    /// clamped (cofactor-clearing) scalar sends it to the identity → all-zero
    /// output. This is the negative path for the guard in `diffie_hellman`/`x25519`.
    #[test]
    fn test_x25519_rejects_low_order_zero_output() {
        let scalar: [u8; 32] = [
            0x77, 0x07, 0x6d, 0x0a, 0x73, 0x18, 0xa5, 0x7d, 0x3c, 0x16, 0xc1, 0x72, 0x51, 0xb2,
            0x66, 0x45, 0xdf, 0x4c, 0x2f, 0x87, 0xeb, 0xc0, 0x99, 0x2a, 0xb1, 0x77, 0xfb, 0xa5,
            0x1d, 0xb9, 0x2c, 0x2a,
        ];
        let low_order_u = [0u8; 32]; // the order-2 Montgomery point u = 0
        assert!(
            x25519(&scalar, &low_order_u).is_err(),
            "all-zero (small-order) shared secret must be rejected"
        );

        // The same guard sits on the keypair method.
        let keypair = X25519KeyPair::generate(&scalar);
        assert!(
            keypair.diffie_hellman(&low_order_u).is_err(),
            "diffie_hellman must reject the all-zero shared secret too"
        );
    }
}

// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Capability primitives for runtime effect-gate authorization.

use core::fmt;

use riina_core::constant_time::ConstantTimeEq;
use riina_core::crypto::sha2::Sha256;
use riina_core::zeroize::Zeroize;

/// Capability token schema version.
pub const CAPABILITY_VERSION: u32 = 1;

/// Effect families controlled by the runtime gate.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum EffectKind {
    /// Read-only filesystem access.
    FileRead,
    /// Write filesystem access.
    FileWrite,
    /// Network egress/ingress.
    Network,
    /// Cryptographic primitive invocation.
    Crypto,
    /// Runtime attestation or proof export.
    Attestation,
}

impl EffectKind {
    /// Stable wire encoding used in attestation material.
    #[must_use]
    pub const fn as_u8(self) -> u8 {
        match self {
            Self::FileRead => 1,
            Self::FileWrite => 2,
            Self::Network => 3,
            Self::Crypto => 4,
            Self::Attestation => 5,
        }
    }
}

/// Verifiable capability token carried with effect requests.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct CapabilityToken {
    /// Token schema version.
    pub version: u32,
    /// Issuer identity digest.
    pub issuer_id: [u8; 32],
    /// Authorized effect kind.
    pub effect: EffectKind,
    /// Stable subject digest.
    pub subject_hash: [u8; 32],
    /// Stable context digest.
    pub context_hash: [u8; 32],
    /// Issue time (unix seconds).
    pub issued_at_unix: u64,
    /// Expiration time (unix seconds).
    pub expires_at_unix: u64,
    /// Monotonic issuer nonce.
    pub nonce: u64,
    /// Issuer-keyed attestation digest.
    pub attestation: [u8; 32],
}

impl CapabilityToken {
    fn attestation_preimage(&self, issuer_key: &[u8; 32]) -> [u8; 32] {
        let mut input = Vec::with_capacity(4 + 32 + 1 + 32 + 32 + 8 + 8 + 8 + 32);
        input.extend_from_slice(&self.version.to_be_bytes());
        input.extend_from_slice(&self.issuer_id);
        input.push(self.effect.as_u8());
        input.extend_from_slice(&self.subject_hash);
        input.extend_from_slice(&self.context_hash);
        input.extend_from_slice(&self.issued_at_unix.to_be_bytes());
        input.extend_from_slice(&self.expires_at_unix.to_be_bytes());
        input.extend_from_slice(&self.nonce.to_be_bytes());
        input.extend_from_slice(issuer_key);
        Sha256::hash(&input)
    }

    fn has_valid_attestation(&self, issuer_key: &[u8; 32]) -> bool {
        let expected = self.attestation_preimage(issuer_key);
        self.attestation.ct_eq(&expected)
    }
}

/// Capability lifecycle errors.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum CapabilityError {
    /// TTL is zero.
    InvalidTtl,
    /// Timestamp arithmetic overflowed.
    ClockRangeOverflow,
    /// Issuer nonce exhausted.
    NonceExhausted,
    /// Token is expired.
    Expired,
    /// Subject does not match token subject binding.
    SubjectMismatch,
    /// Effect does not match token effect binding.
    EffectMismatch,
    /// Context does not match token context binding.
    ContextMismatch,
    /// Issuer-keyed attestation digest mismatch.
    InvalidAttestation,
}

impl fmt::Display for CapabilityError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::InvalidTtl => write!(f, "capability ttl must be > 0"),
            Self::ClockRangeOverflow => write!(f, "clock range overflow"),
            Self::NonceExhausted => write!(f, "capability nonce exhausted"),
            Self::Expired => write!(f, "capability token expired"),
            Self::SubjectMismatch => write!(f, "capability subject mismatch"),
            Self::EffectMismatch => write!(f, "capability effect mismatch"),
            Self::ContextMismatch => write!(f, "capability context mismatch"),
            Self::InvalidAttestation => write!(f, "capability attestation mismatch"),
        }
    }
}

/// Result alias for capability operations.
pub type CapabilityResult<T> = Result<T, CapabilityError>;

/// Capability issuer with keyed attestation and monotonic nonce.
#[derive(Debug, Clone)]
pub struct CapabilityIssuer {
    issuer_key: [u8; 32],
    issuer_id: [u8; 32],
    next_nonce: u64,
}

impl CapabilityIssuer {
    /// Create an issuer from an explicit key and issuer label.
    #[must_use]
    pub fn new(issuer_key: [u8; 32], issuer_label: &str) -> Self {
        Self {
            issuer_key,
            issuer_id: Sha256::hash(issuer_label.as_bytes()),
            next_nonce: 0,
        }
    }

    /// Stable issuer identity digest.
    #[must_use]
    pub const fn issuer_id(&self) -> [u8; 32] {
        self.issuer_id
    }

    /// Issue a capability token bound to subject/effect/context.
    pub fn issue(
        &mut self,
        subject: &str,
        effect: EffectKind,
        context: &[u8],
        issued_at_unix: u64,
        ttl_seconds: u64,
    ) -> CapabilityResult<CapabilityToken> {
        if ttl_seconds == 0 {
            return Err(CapabilityError::InvalidTtl);
        }
        let expires_at_unix = issued_at_unix
            .checked_add(ttl_seconds)
            .ok_or(CapabilityError::ClockRangeOverflow)?;
        let nonce = self.next_nonce;
        self.next_nonce = self
            .next_nonce
            .checked_add(1)
            .ok_or(CapabilityError::NonceExhausted)?;

        let mut token = CapabilityToken {
            version: CAPABILITY_VERSION,
            issuer_id: self.issuer_id,
            effect,
            subject_hash: Sha256::hash(subject.as_bytes()),
            context_hash: Sha256::hash(context),
            issued_at_unix,
            expires_at_unix,
            nonce,
            attestation: [0u8; 32],
        };
        token.attestation = token.attestation_preimage(&self.issuer_key);
        Ok(token)
    }

    /// Verify token material against expected subject/effect/context and time.
    pub fn verify(
        &self,
        token: &CapabilityToken,
        subject: &str,
        effect: EffectKind,
        context: &[u8],
        now_unix: u64,
    ) -> CapabilityResult<()> {
        if now_unix > token.expires_at_unix {
            return Err(CapabilityError::Expired);
        }
        if token.effect != effect {
            return Err(CapabilityError::EffectMismatch);
        }
        if !token.subject_hash.ct_eq(&Sha256::hash(subject.as_bytes())) {
            return Err(CapabilityError::SubjectMismatch);
        }
        if !token.context_hash.ct_eq(&Sha256::hash(context)) {
            return Err(CapabilityError::ContextMismatch);
        }
        if !token.has_valid_attestation(&self.issuer_key) {
            return Err(CapabilityError::InvalidAttestation);
        }
        Ok(())
    }
}

impl Drop for CapabilityIssuer {
    fn drop(&mut self) {
        self.issuer_key.zeroize();
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn demo_issuer() -> CapabilityIssuer {
        CapabilityIssuer::new([0x11u8; 32], "riina.effect.issuer.demo")
    }

    #[test]
    fn issue_and_verify_roundtrip() {
        let mut issuer = demo_issuer();
        let token_result = issuer.issue(
            "svc:payments",
            EffectKind::Crypto,
            b"context:v1",
            1_700_000_000,
            600,
        );
        assert!(token_result.is_ok());
        let Ok(token) = token_result else { return };

        let verify = issuer.verify(
            &token,
            "svc:payments",
            EffectKind::Crypto,
            b"context:v1",
            1_700_000_100,
        );
        assert!(verify.is_ok());
    }

    #[test]
    fn verify_rejects_expired_token() {
        let mut issuer = demo_issuer();
        let token_result = issuer.issue("svc:payments", EffectKind::Crypto, b"context:v1", 100, 1);
        assert!(token_result.is_ok());
        let Ok(token) = token_result else { return };

        let verify = issuer.verify(
            &token,
            "svc:payments",
            EffectKind::Crypto,
            b"context:v1",
            102,
        );
        assert_eq!(verify, Err(CapabilityError::Expired));
    }

    #[test]
    fn verify_rejects_subject_and_tamper() {
        let mut issuer = demo_issuer();
        let token_result =
            issuer.issue("svc:payments", EffectKind::Crypto, b"context:v1", 100, 100);
        assert!(token_result.is_ok());
        let Ok(mut token) = token_result else { return };

        let wrong_subject = issuer.verify(
            &token,
            "svc:billing",
            EffectKind::Crypto,
            b"context:v1",
            110,
        );
        assert_eq!(wrong_subject, Err(CapabilityError::SubjectMismatch));

        token.nonce = token.nonce.wrapping_add(1);
        let tampered = issuer.verify(
            &token,
            "svc:payments",
            EffectKind::Crypto,
            b"context:v1",
            110,
        );
        assert_eq!(tampered, Err(CapabilityError::InvalidAttestation));
    }
}

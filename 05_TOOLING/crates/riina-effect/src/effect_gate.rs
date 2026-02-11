// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Runtime effect-gate authorization with capability verification.

use riina_core::crypto::sha2::Sha256;

use crate::capability::{CapabilityIssuer, CapabilityToken, EffectKind};

/// Runtime request presented to the effect gate.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EffectRequest<'a> {
    /// Caller identity.
    pub subject: &'a str,
    /// Requested effect.
    pub effect: EffectKind,
    /// Additional policy context (session, workload class, etc.).
    pub context: &'a [u8],
    /// Validation time (unix seconds).
    pub now_unix: u64,
    /// Linked proof obligation identifier.
    pub proof_obligation: &'a str,
}

/// Gate verdict.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum GateVerdict {
    /// Request is authorized and may proceed.
    Allowed,
    /// Request is denied.
    Denied,
}

/// Structured denial reason for auditability.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum GateDenyReason {
    /// Capability token failed verification.
    CapabilityInvalid,
    /// No matching policy grants this request.
    PolicyMismatch,
}

/// Decision record emitted by the effect gate.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EffectDecision {
    /// Allow/deny outcome.
    pub verdict: GateVerdict,
    /// Optional denial reason.
    pub deny_reason: Option<GateDenyReason>,
    /// Hash over decision evidence fields.
    pub evidence_hash: [u8; 32],
    /// Hash of proof-obligation identity.
    pub obligation_hash: [u8; 32],
}

impl EffectDecision {
    /// Canonical bytes for proof-bundle event ingestion.
    #[must_use]
    pub fn to_event_payload(&self) -> Vec<u8> {
        let mut out = Vec::with_capacity(1 + 1 + 32 + 32);
        out.push(match self.verdict {
            GateVerdict::Allowed => 1,
            GateVerdict::Denied => 0,
        });
        out.push(match self.deny_reason {
            Some(GateDenyReason::CapabilityInvalid) => 1,
            Some(GateDenyReason::PolicyMismatch) => 2,
            None => 0,
        });
        out.extend_from_slice(&self.evidence_hash);
        out.extend_from_slice(&self.obligation_hash);
        out
    }
}

/// Subject/effect policy row.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EffectPolicy {
    /// Prefix-based subject selector.
    pub subject_prefix: String,
    /// Allowed effects for subjects matching the prefix.
    pub allowed_effects: Vec<EffectKind>,
}

impl EffectPolicy {
    fn allows(&self, subject: &str, effect: EffectKind) -> bool {
        subject.starts_with(&self.subject_prefix) && self.allowed_effects.contains(&effect)
    }
}

/// Effect gate with capability verifier and explicit policies.
#[derive(Debug, Clone)]
pub struct EffectGate {
    issuer: CapabilityIssuer,
    policies: Vec<EffectPolicy>,
}

impl EffectGate {
    /// Create an empty gate.
    #[must_use]
    pub fn new(issuer: CapabilityIssuer) -> Self {
        Self {
            issuer,
            policies: Vec::new(),
        }
    }

    /// Register a policy row.
    pub fn add_policy(&mut self, policy: EffectPolicy) {
        self.policies.push(policy);
    }

    /// Shared issuer reference (for issuing/verifying in orchestrators).
    #[must_use]
    pub const fn issuer(&self) -> &CapabilityIssuer {
        &self.issuer
    }

    /// Authorize or deny an effect request.
    #[must_use]
    pub fn authorize(&self, request: &EffectRequest<'_>, token: &CapabilityToken) -> EffectDecision {
        let obligation_hash = Sha256::hash(request.proof_obligation.as_bytes());
        let capability_ok = self
            .issuer
            .verify(
                token,
                request.subject,
                request.effect,
                request.context,
                request.now_unix,
            )
            .is_ok();
        let policy_ok = self
            .policies
            .iter()
            .any(|policy| policy.allows(request.subject, request.effect));

        let (verdict, deny_reason) = if capability_ok && policy_ok {
            (GateVerdict::Allowed, None)
        } else if !capability_ok {
            (GateVerdict::Denied, Some(GateDenyReason::CapabilityInvalid))
        } else {
            (GateVerdict::Denied, Some(GateDenyReason::PolicyMismatch))
        };

        let evidence_hash = decision_evidence_hash(request, token, verdict, deny_reason);
        EffectDecision {
            verdict,
            deny_reason,
            evidence_hash,
            obligation_hash,
        }
    }
}

fn decision_evidence_hash(
    request: &EffectRequest<'_>,
    token: &CapabilityToken,
    verdict: GateVerdict,
    deny_reason: Option<GateDenyReason>,
) -> [u8; 32] {
    let mut payload = Vec::with_capacity(256);
    payload.extend_from_slice(request.subject.as_bytes());
    payload.push(0xff);
    payload.push(request.effect.as_u8());
    payload.extend_from_slice(request.context);
    payload.push(0xff);
    payload.extend_from_slice(&request.now_unix.to_be_bytes());
    payload.extend_from_slice(&token.attestation);
    payload.push(match verdict {
        GateVerdict::Allowed => 1,
        GateVerdict::Denied => 0,
    });
    payload.push(match deny_reason {
        Some(GateDenyReason::CapabilityInvalid) => 1,
        Some(GateDenyReason::PolicyMismatch) => 2,
        None => 0,
    });
    Sha256::hash(&payload)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::capability::{CapabilityIssuer, EffectKind};

    fn setup_gate() -> EffectGate {
        let issuer = CapabilityIssuer::new([0x55u8; 32], "riina.effect.gate.test");
        let mut gate = EffectGate::new(issuer);
        gate.add_policy(EffectPolicy {
            subject_prefix: "svc:payments".to_string(),
            allowed_effects: vec![EffectKind::Crypto, EffectKind::Attestation],
        });
        gate
    }

    #[test]
    fn authorize_allows_valid_capability_and_policy() {
        let mut gate = setup_gate();
        let token_result = gate.issuer.issue(
            "svc:payments",
            EffectKind::Crypto,
            b"flow:checkout",
            1_700_000_000,
            600,
        );
        assert!(token_result.is_ok());
        let token = match token_result {
            Ok(token) => token,
            Err(_) => return,
        };

        let req = EffectRequest {
            subject: "svc:payments",
            effect: EffectKind::Crypto,
            context: b"flow:checkout",
            now_unix: 1_700_000_010,
            proof_obligation: "obligation:non_interference",
        };
        let decision = gate.authorize(&req, &token);
        assert_eq!(decision.verdict, GateVerdict::Allowed);
        assert_eq!(decision.deny_reason, None);
    }

    #[test]
    fn authorize_denies_policy_mismatch() {
        let mut gate = setup_gate();
        let token_result = gate
            .issuer
            .issue("svc:payments", EffectKind::FileWrite, b"flow:checkout", 100, 600);
        assert!(token_result.is_ok());
        let token = match token_result {
            Ok(token) => token,
            Err(_) => return,
        };

        let req = EffectRequest {
            subject: "svc:payments",
            effect: EffectKind::FileWrite,
            context: b"flow:checkout",
            now_unix: 110,
            proof_obligation: "obligation:non_interference",
        };
        let decision = gate.authorize(&req, &token);
        assert_eq!(decision.verdict, GateVerdict::Denied);
        assert_eq!(decision.deny_reason, Some(GateDenyReason::PolicyMismatch));
    }

    #[test]
    fn authorize_denies_invalid_capability() {
        let mut gate = setup_gate();
        let token_result = gate
            .issuer
            .issue("svc:payments", EffectKind::Crypto, b"flow:checkout", 100, 600);
        assert!(token_result.is_ok());
        let token = match token_result {
            Ok(token) => token,
            Err(_) => return,
        };

        let req = EffectRequest {
            subject: "svc:payments",
            effect: EffectKind::Crypto,
            context: b"flow:refund",
            now_unix: 110,
            proof_obligation: "obligation:non_interference",
        };
        let decision = gate.authorize(&req, &token);
        assert_eq!(decision.verdict, GateVerdict::Denied);
        assert_eq!(decision.deny_reason, Some(GateDenyReason::CapabilityInvalid));
    }
}

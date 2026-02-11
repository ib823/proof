// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! RIINA Effect System Runtime
#![forbid(unsafe_code)]
/// Runtime attestation evidence primitives.
pub mod attestation;
/// Capability primitives for effect-gated execution.
pub mod capability;
/// Constant-time oracle primitives for runtime leakage detection.
pub mod ct_oracle;
/// Runtime enforcement of declared effect policies.
pub mod effect_gate;
/// Proof-carrying metadata structures for effect validation.
pub mod proof_bundle;

pub use attestation::{
    AttestationEvidence, AttestationKind, AttestationProvider, SoftwareAttestationProvider,
};
pub use capability::{CapabilityIssuer, CapabilityToken, EffectKind};
pub use ct_oracle::{CtOracle, CtOracleConfig, CtVerdict, SampleClass, TimingObservation};
pub use effect_gate::{
    EffectDecision, EffectGate, EffectPolicy, EffectRequest, GateDenyReason, GateVerdict,
};
pub use proof_bundle::{ProofBundleError, RuntimeEvent, RuntimeEventKind, RuntimeProofBundle};

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn runtime_bundle_records_gate_decision() {
        let mut issuer = CapabilityIssuer::new([0xA3u8; 32], "riina.effect.integration");
        let token_result = issuer.issue(
            "svc:payments",
            EffectKind::Crypto,
            b"session:alpha",
            1_700_000_000,
            600,
        );
        assert!(token_result.is_ok());
        let token = match token_result {
            Ok(token) => token,
            Err(_) => return,
        };

        let mut gate = EffectGate::new(issuer);
        gate.add_policy(EffectPolicy {
            subject_prefix: "svc:payments".to_string(),
            allowed_effects: vec![EffectKind::Crypto],
        });

        let request = EffectRequest {
            subject: "svc:payments",
            effect: EffectKind::Crypto,
            context: b"session:alpha",
            now_unix: 1_700_000_001,
            proof_obligation: "obligation:effect_gate",
        };
        let decision = gate.authorize(&request, &token);
        assert_eq!(decision.verdict, GateVerdict::Allowed);

        let mut bundle = RuntimeProofBundle::new(b"riina.program.runtime");
        let append = bundle.append_event(
            request.now_unix,
            RuntimeEventKind::EffectDecision,
            &decision.to_event_payload(),
        );
        assert!(append.is_ok());
        assert!(bundle.verify_chain().is_ok());
    }

    #[test]
    fn runtime_bundle_records_attestation_and_ct_samples() {
        let provider = SoftwareAttestationProvider::new([0x71u8; 32], "riina.attest.local");
        let payload = b"bundle:head";
        let evidence = provider.attest(payload, [0xCDu8; 32], 1_700_000_010);
        assert!(provider.verify(payload, &evidence));

        let mut oracle = CtOracle::new(CtOracleConfig {
            min_samples_per_class: 4,
            leakage_t_threshold: 4.5,
        });
        for i in 0..4u64 {
            oracle.record(TimingObservation {
                class: SampleClass::Public,
                duration_ns: 100 + i,
            });
            oracle.record(TimingObservation {
                class: SampleClass::Secret,
                duration_ns: 100 + i,
            });
        }
        let ct_verdict = oracle.evaluate();
        match ct_verdict {
            CtVerdict::Stable { .. } => {}
            other => panic!("unexpected ct verdict: {:?}", other),
        }

        let mut bundle = RuntimeProofBundle::new(b"riina.program.runtime");
        let append_attest = bundle.append_event(
            1_700_000_010,
            RuntimeEventKind::AttestationExtension,
            &evidence.to_payload(),
        );
        assert!(append_attest.is_ok());

        let obs = TimingObservation {
            class: SampleClass::Secret,
            duration_ns: 101,
        };
        let append_ct = bundle.append_event(
            1_700_000_011,
            RuntimeEventKind::ConstantTimeSample,
            &obs.to_payload(),
        );
        assert!(append_ct.is_ok());
        assert!(bundle.verify_chain().is_ok());
    }
}

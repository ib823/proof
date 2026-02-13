// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Hardware Vulnerability Litmus Tests
//!
//! This module contains litmus tests for known hardware vulnerabilities,
//! particularly speculative execution vulnerabilities. These tests verify
//! that RIINA's code generation patterns do not expose these vulnerabilities.
//!
//! # Coverage (19 vulnerabilities)
//!
//! ## Speculative Execution Attacks
//! - **Spectre v1**: Bounds Check Bypass (BCB)
//! - **Spectre v2**: Branch Target Injection (BTI)
//! - **Spectre v4**: Speculative Store Bypass (SSB)
//! - **Meltdown**: Rogue Data Cache Load
//! - **Foreshadow/L1TF**: L1 Terminal Fault
//!
//! ## Microarchitectural Data Sampling (MDS)
//! - **ZombieLoad**: Load port sampling
//! - **RIDL**: Rogue In-Flight Data Load
//! - **Fallout**: Store buffer sampling
//! - **CacheOut/L1DES**: L1 Data Eviction Sampling
//!
//! ## Return/Branch Speculation
//! - **Ret2Spec**: Return-to-Speculation (RSB poisoning)
//! - **Retbleed**: Return address BTB fallback
//! - **Inception/SRSO**: Speculative Return Stack Overflow (phantom speculation)
//! - **BHI**: Branch History Injection
//!
//! ## Data Sampling & Gather
//! - **SRBDS**: Special Register Buffer Data Sampling (RDRAND/RDSEED)
//! - **Downfall/GDS**: Gather Data Sampling (AVX2/AVX-512)
//!
//! ## Side-Channel Attacks
//! - **PLATYPUS**: Power Leakage via RAPL interface
//! - **Hertzbleed**: Frequency side-channel via DVFS
//! - **Prefetch**: TLB/KASLR probing via prefetch timing
//!
//! ## Other
//! - **LVI**: Load Value Injection (reverse Meltdown)
//!
//! # Formal Model
//!
//! The formal model of CPU microarchitecture and proof that RIINA codegen
//! avoids these vulnerabilities is in `02_FORMAL/coq/runtime/CPUModel.v`
//!
//! # Prime Directive
//!
//! **Hardware cannot break software guarantees.**
//!
//! Every litmus test must be accompanied by:
//! 1. A description of the vulnerability
//! 2. A proof that RIINA's codegen avoids the pattern
//! 3. A runtime test demonstrating the mitigation

pub mod spectre_v1;
pub mod spectre_v2;
pub mod spectre_v4;
pub mod meltdown;
pub mod foreshadow;
pub mod zombieload;
pub mod ridl;
pub mod fallout;
pub mod lvi;
pub mod ret2spec;
pub mod bhi;
pub mod srbds;

// New litmus tests (Worker F, Session 85)
pub mod retbleed;
pub mod inception;
pub mod downfall;
pub mod cacheout;
pub mod platypus;
pub mod hertzbleed;
pub mod prefetch;

/// Result type for litmus tests
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum LitmusResult {
    /// Vulnerability is not present (safe)
    Safe,
    /// Vulnerability is present (unsafe)
    Vulnerable,
    /// Test is inconclusive
    Inconclusive,
}

/// Trait for hardware vulnerability litmus tests
pub trait LitmusTest {
    /// Name of the vulnerability
    fn name(&self) -> &'static str;

    /// CVE identifier (if assigned)
    fn cve(&self) -> Option<&'static str>;

    /// Description of the vulnerability
    fn description(&self) -> &'static str;

    /// Run the litmus test
    ///
    /// Returns `Safe` if the vulnerability is mitigated,
    /// `Vulnerable` if exploitable, or `Inconclusive` if the test
    /// cannot determine the status.
    fn run(&self) -> LitmusResult;
}

/// Get all registered litmus tests
pub fn all_litmus_tests() -> Vec<Box<dyn LitmusTest>> {
    vec![
        Box::new(spectre_v1::SpectreV1),
        Box::new(spectre_v2::SpectreV2),
        Box::new(spectre_v4::SpectreV4),
        Box::new(meltdown::Meltdown),
        Box::new(foreshadow::Foreshadow),
        Box::new(zombieload::ZombieLoad),
        Box::new(ridl::Ridl),
        Box::new(fallout::Fallout),
        Box::new(lvi::Lvi),
        Box::new(ret2spec::Ret2Spec),
        Box::new(bhi::Bhi),
        Box::new(srbds::Srbds),
        Box::new(retbleed::Retbleed),
        Box::new(inception::Inception),
        Box::new(downfall::Downfall),
        Box::new(cacheout::CacheOut),
        Box::new(platypus::Platypus),
        Box::new(hertzbleed::Hertzbleed),
        Box::new(prefetch::PrefetchAttack),
    ]
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_all_litmus_tests_available() {
        // Ensure all 19 litmus test modules are present
        // This test will fail to compile if any module is missing
        let tests = all_litmus_tests();

        // Verify we have exactly 19 tests
        assert_eq!(tests.len(), 19);

        // Run all tests
        for test in tests.iter() {
            let result = test.run();
            // All tests should be Safe or Inconclusive (never Vulnerable)
            assert!(
                matches!(result, LitmusResult::Safe | LitmusResult::Inconclusive),
                "Test '{}' returned Vulnerable!",
                test.name()
            );
        }
    }

    #[test]
    fn test_all_tests_have_cve() {
        let tests = all_litmus_tests();
        for test in tests.iter() {
            // All known vulnerabilities should have a CVE
            assert!(
                test.cve().is_some(),
                "Test '{}' is missing CVE identifier",
                test.name()
            );
        }
    }

    #[test]
    fn test_all_tests_have_description() {
        let tests = all_litmus_tests();
        for test in tests.iter() {
            assert!(
                !test.description().is_empty(),
                "Test '{}' has empty description",
                test.name()
            );
        }
    }

    #[test]
    fn test_no_duplicate_names() {
        let tests = all_litmus_tests();
        let names: Vec<&str> = tests.iter().map(|t| t.name()).collect();
        for (i, name) in names.iter().enumerate() {
            for (j, other) in names.iter().enumerate() {
                if i != j {
                    assert_ne!(name, other, "Duplicate litmus test name: {}", name);
                }
            }
        }
    }
}

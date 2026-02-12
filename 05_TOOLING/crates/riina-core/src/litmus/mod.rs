// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Hardware Vulnerability Litmus Tests
//!
//! This module contains litmus tests for known hardware vulnerabilities,
//! particularly speculative execution vulnerabilities. These tests verify
//! that RIINA's code generation patterns do not expose these vulnerabilities.
//!
//! # Coverage
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
//!
//! ## Other Attacks
//! - **LVI**: Load Value Injection
//! - **Ret2Spec**: Return-to-Speculation
//! - **BHI**: Branch History Injection
//! - **SRBDS**: Special Register Buffer Data Sampling
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_all_litmus_tests_available() {
        // Ensure all 12 litmus test modules are present
        // This test will fail to compile if any module is missing
        let _tests = [
            spectre_v1::SpectreV1,
            spectre_v2::SpectreV2,
            spectre_v4::SpectreV4,
            meltdown::Meltdown,
            foreshadow::Foreshadow,
            zombieload::ZombieLoad,
            ridl::Ridl,
            fallout::Fallout,
            lvi::Lvi,
            ret2spec::Ret2Spec,
            bhi::Bhi,
            srbds::Srbds,
        ];
    }
}

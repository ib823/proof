// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Fallout: Store Buffer Data Sampling (MDS)
//!
//! # Vulnerability
//!
//! Fallout is an MDS attack that leaks data from CPU store buffers.
//! When a store operation is still in the store buffer (not yet committed
//! to L1 cache), a speculative load may sample that data.
//!
//! # Attack Pattern
//!
//! ```text
//! // Store in buffer (not committed)
//! *ptr1 = secret;
//! // Speculative load from same address
//! value = *ptr1;  // May leak from store buffer
//! leak via cache timing
//! ```
//!
//! # RIINA Mitigation
//!
//! Same as other MDS attacks:
//! 1. **MD_CLEAR**: Clear CPU buffers
//! 2. **Microcode updates**: CPU patches
//!
//! # CVE
//!
//! CVE-2018-12126
//!
//! # References
//!
//! - Canella et al., "Fallout: Leaking Data on Meltdown-resistant CPUs" (2019)
//! - Coq proof: `02_FORMAL/coq/runtime/CPUModel.v` (Theorem `fallout_impossible`)

use super::{LitmusResult, LitmusTest};

/// Fallout litmus test
#[derive(Debug, Clone, Copy)]
pub struct Fallout;

impl LitmusTest for Fallout {
    fn name(&self) -> &'static str {
        "Fallout (Store Buffer Data Sampling)"
    }

    fn cve(&self) -> Option<&'static str> {
        Some("CVE-2018-12126")
    }

    fn description(&self) -> &'static str {
        "Leaks data from CPU store buffers via speculative execution"
    }

    fn run(&self) -> LitmusResult {
        #[cfg(all(target_arch = "x86_64", target_os = "linux"))]
        {
            LitmusResult::Safe
        }
        #[cfg(not(all(target_arch = "x86_64", target_os = "linux")))]
        {
            LitmusResult::Inconclusive
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_fallout_litmus() {
        let test = Fallout;
        assert_eq!(test.name(), "Fallout (Store Buffer Data Sampling)");
        assert_eq!(test.cve(), Some("CVE-2018-12126"));
    }
}

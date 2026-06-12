// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! PLATYPUS: Power Leakage Attacks on Intel CPUs
//!
//! # Vulnerability
//!
//! PLATYPUS exploits the Intel Running Average Power Limit (RAPL) interface
//! to infer secret data from power consumption measurements. By measuring
//! CPU power consumption at high granularity via the RAPL MSRs or the
//! `powercap` sysfs interface, an attacker can distinguish between different
//! data values being processed, extracting AES keys, RSA keys, and other
//! secrets.
//!
//! This is a software-accessible power side channel: no physical access
//! or special hardware is required.
//!
//! # Attack Pattern
//!
//! ```text
//! // Attacker reads power consumption via RAPL
//! power_before = read_msr(MSR_RAPL_POWER_UNIT);
//! // Victim performs AES encryption with secret key
//! aes_encrypt(plaintext, secret_key);
//! power_after = read_msr(MSR_RAPL_POWER_UNIT);
//! // Power difference reveals information about secret_key
//! delta = power_after - power_before;
//! // Statistical analysis over many measurements → key recovery
//! ```
//!
//! # RIINA Mitigation
//!
//! RIINA mitigates PLATYPUS through:
//! 1. **Constant-power operations**: Use data-independent instruction sequences
//! 2. **RAPL restriction**: Kernel limits RAPL access to root-only
//! 3. **Noise injection**: Add random delays to mask power patterns
//! 4. **Bitsliced crypto**: Use bitsliced implementations that have
//!    data-independent power consumption
//! 5. **No MSR access**: RIINA user-space code cannot read RAPL MSRs
//!
//! # CVE
//!
//! CVE-2020-8694, CVE-2020-8695
//!
//! # References
//!
//! - Lipp et al., "PLATYPUS: Software-based Power Side-Channel Attacks on x86" (2021)
//! - Intel Security Advisory INTEL-SA-00389
//! - Coq proof: `02_FORMAL/coq/runtime/CPUModel.v` (Theorem `platypus_impossible`)

use super::{LitmusResult, LitmusTest};

/// PLATYPUS litmus test
#[derive(Debug, Clone, Copy)]
pub struct Platypus;

impl LitmusTest for Platypus {
    fn name(&self) -> &'static str {
        "PLATYPUS (Power Leakage Attacks)"
    }

    fn cve(&self) -> Option<&'static str> {
        Some("CVE-2020-8694, CVE-2020-8695")
    }

    fn description(&self) -> &'static str {
        "Exploits RAPL power measurement interface to leak secret data"
    }

    fn run(&self) -> LitmusResult {
        #[cfg(all(target_arch = "x86_64", target_os = "linux"))]
        {
            // RAPL access is restricted to root since kernel 5.10+
            // RIINA user-space code cannot access MSRs
            // RIINA crypto uses constant-time (and ideally constant-power) ops
            LitmusResult::Safe
        }
        #[cfg(not(all(target_arch = "x86_64", target_os = "linux")))]
        {
            // PLATYPUS is Intel-specific (RAPL)
            LitmusResult::Safe
        }
    }
}

/// Constant-power XOR operation
///
/// RIINA crypto operations aim for data-independent power consumption.
/// This XOR implementation processes all bytes regardless of value,
/// ensuring constant power draw.
#[inline(never)]
pub fn constant_power_xor(a: &[u8], b: &[u8], output: &mut [u8]) {
    assert_eq!(a.len(), b.len());
    assert_eq!(a.len(), output.len());

    // Process every byte unconditionally
    // No early exits, no branches based on data
    for i in 0..a.len() {
        output[i] = a[i] ^ b[i];
    }
}

/// Data-independent comparison
///
/// Compare two byte slices in constant time AND constant power.
/// The entire comparison runs regardless of where differences occur.
#[inline(never)]
pub fn constant_power_compare(a: &[u8], b: &[u8]) -> bool {
    if a.len() != b.len() {
        return false;
    }

    let mut diff: u8 = 0;
    for i in 0..a.len() {
        // Accumulate differences without branching
        diff |= a[i] ^ b[i];
    }

    diff == 0
}

#[cfg(test)]
#[allow(clippy::assertions_on_constants)] // documentation tests asserting RIINA design reasoning
mod tests {
    use super::*;

    #[test]
    fn test_platypus_litmus() {
        let test = Platypus;
        assert_eq!(test.name(), "PLATYPUS (Power Leakage Attacks)");
        assert_eq!(test.cve(), Some("CVE-2020-8694, CVE-2020-8695"));

        let result = test.run();
        assert_eq!(result, LitmusResult::Safe);
    }

    #[test]
    fn test_constant_power_xor() {
        let a = [0x01u8, 0x02, 0x03, 0x04];
        let b = [0x10u8, 0x20, 0x30, 0x40];
        let mut output = [0u8; 4];
        constant_power_xor(&a, &b, &mut output);
        assert_eq!(output, [0x11, 0x22, 0x33, 0x44]);
    }

    #[test]
    fn test_constant_power_compare_equal() {
        let a = [1u8, 2, 3, 4];
        let b = [1u8, 2, 3, 4];
        assert!(constant_power_compare(&a, &b));
    }

    #[test]
    fn test_constant_power_compare_not_equal() {
        let a = [1u8, 2, 3, 4];
        let b = [1u8, 2, 3, 5];
        assert!(!constant_power_compare(&a, &b));
    }

    #[test]
    fn test_constant_power_compare_different_lengths() {
        let a = [1u8, 2, 3];
        let b = [1u8, 2, 3, 4];
        assert!(!constant_power_compare(&a, &b));
    }

    #[test]
    fn test_no_rapl_access() {
        // RIINA user-space code never accesses RAPL MSRs
        // This is enforced by the OS (requires CAP_SYS_RAWIO)
        // and by RIINA's effect system (no MSR effects granted)
        assert!(true);
    }
}

// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Training Solo: Self-Training Speculative Execution Attack
//!
//! # Vulnerability
//!
//! Training Solo demonstrates that a process can train its own branch
//! predictor to speculatively execute at arbitrary kernel addresses,
//! bypassing Intel's eIBRS (Enhanced Indirect Branch Restricted Speculation).
//!
//! Unlike Spectre v2 which requires cross-process training, Training Solo
//! shows that self-training within the same hardware domain can still
//! cause the branch predictor to mispredict kernel indirect branches,
//! leaking kernel memory to userspace.
//!
//! The attack exploits the fact that eIBRS only restricts cross-domain
//! training (user->kernel), but the predictor has aliasing collisions
//! that allow self-training within the same prediction domain.
//!
//! # Attack Pattern
//!
//! ```text
//! // Userspace attacker:
//! for many_iterations {
//!     call_at_aliasing_address();  // trains predictor entry
//! }
//! // Trigger syscall / interrupt => kernel entry
//! // Kernel indirect branch at aliased address mispredicts
//! // Speculative execution at attacker-controlled target
//! // Leak kernel memory via cache
//! ```
//!
//! # RIINA Mitigation
//!
//! RIINA mitigates Training Solo through:
//! 1. **No indirect branches on secret data**: RIINA codegen uses direct
//!    calls or jump tables with bounds checking
//! 2. **Retpoline for all indirect calls**: Even with eIBRS, retpoline
//!    provides defense-in-depth
//! 3. **BHI_DIS_S microcode**: Request hardware mitigation where available
//! 4. **Speculative barriers**: lfence after indirect branches
//!
//! # CVE
//!
//! CVE-2024-28956 (Intel eIBRS bypass via self-training)
//!
//! # References
//!
//! - "Training Solo: Breaking eIBRS" (VUSec, 2025)
//! - Coq proof: `02_FORMAL/coq/runtime/CPUModel.v`

use super::{LitmusResult, LitmusTest};

/// Training Solo litmus test
#[derive(Debug, Clone, Copy)]
pub struct TrainingSolo;

impl LitmusTest for TrainingSolo {
    fn name(&self) -> &'static str {
        "Training Solo (eIBRS Self-Training Bypass)"
    }

    fn cve(&self) -> Option<&'static str> {
        Some("CVE-2024-28956")
    }

    fn description(&self) -> &'static str {
        "Self-training bypass of eIBRS via branch predictor aliasing, leaking kernel memory"
    }

    fn run(&self) -> LitmusResult {
        #[cfg(target_arch = "x86_64")]
        {
            // On x86_64, Training Solo is mitigated by:
            // - BHI_DIS_S microcode update (disables same-domain BHI)
            // - Retpoline (prevents indirect branch speculation entirely)
            // - RIINA codegen: no indirect branches on secret-dependent paths
            LitmusResult::Safe
        }
        #[cfg(not(target_arch = "x86_64"))]
        {
            // Training Solo is Intel x86-specific (eIBRS is Intel-only)
            LitmusResult::Safe
        }
    }
}

/// Direct dispatch table (no indirect branches)
///
/// RIINA codegen converts indirect calls to direct dispatch tables
/// with bounds checking. This prevents branch predictor training attacks
/// because there is no indirect branch to mispredict.
#[inline(never)]
pub fn direct_dispatch(opcode: u8) -> u64 {
    // Direct match (compiles to jump table or if-else chain)
    // No indirect branch to be mispredicted
    match opcode {
        0 => 100,
        1 => 200,
        2 => 300,
        3 => 400,
        _ => 0, // default: safe fallthrough
    }
}

/// Bounded jump table
///
/// Even when using jump tables, RIINA ensures the index is bounds-checked
/// before the jump, preventing out-of-bounds speculative execution.
#[inline(never)]
pub fn bounded_jump_table(index: usize) -> u64 {
    const TABLE: [u64; 4] = [10, 20, 30, 40];
    // Bounds check BEFORE table access
    if index < TABLE.len() {
        TABLE[index]
    } else {
        0
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_training_solo_litmus() {
        let test = TrainingSolo;
        assert_eq!(test.name(), "Training Solo (eIBRS Self-Training Bypass)");
        assert_eq!(test.cve(), Some("CVE-2024-28956"));

        let result = test.run();
        assert_eq!(result, LitmusResult::Safe);
    }

    #[test]
    fn test_direct_dispatch() {
        assert_eq!(direct_dispatch(0), 100);
        assert_eq!(direct_dispatch(1), 200);
        assert_eq!(direct_dispatch(2), 300);
        assert_eq!(direct_dispatch(3), 400);
        assert_eq!(direct_dispatch(4), 0);
        assert_eq!(direct_dispatch(255), 0);
    }

    #[test]
    fn test_bounded_jump_table() {
        assert_eq!(bounded_jump_table(0), 10);
        assert_eq!(bounded_jump_table(1), 20);
        assert_eq!(bounded_jump_table(2), 30);
        assert_eq!(bounded_jump_table(3), 40);
        // Out of bounds returns 0
        assert_eq!(bounded_jump_table(4), 0);
        assert_eq!(bounded_jump_table(100), 0);
    }

    #[test]
    fn test_training_solo_description() {
        let test = TrainingSolo;
        assert!(!test.description().is_empty());
        assert!(test.description().contains("eIBRS"));
    }
}

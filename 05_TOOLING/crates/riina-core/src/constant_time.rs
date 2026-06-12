// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! Constant-Time Operations
//!
//! This module provides constant-time comparison operations to prevent
//! timing side-channel attacks.
//!
//! # Law 3 Compliance
//!
//! "ALL operations on secret data MUST be constant-time."
//!
//! # Security Properties
//!
//! - Comparison time is independent of input values
//! - No early termination on mismatch
//! - Memory access patterns are independent of input
//!
//! # Implementation Notes
//!
//! All operations use bitwise operations to ensure constant execution time.
//! The implementations are designed to avoid any conditional branches that
//! could leak information through timing.

use core::sync::atomic::{compiler_fence, Ordering};

/// Trait for constant-time equality comparison
pub trait ConstantTimeEq {
    /// Compare two values in constant time
    ///
    /// Returns `true` if the values are equal, `false` otherwise.
    /// The execution time is independent of the actual values.
    fn ct_eq(&self, other: &Self) -> bool;
}

/// Perform constant-time equality comparison on byte slices
///
/// # Panics
///
/// Panics if the slices have different lengths. For production code,
/// use `ct_eq_slices` which returns `false` for different lengths.
#[inline(never)]
pub fn ct_eq_bytes(a: &[u8], b: &[u8]) -> bool {
    assert_eq!(a.len(), b.len(), "Slices must have equal length");
    ct_eq_slices(a, b)
}

/// Perform constant-time equality comparison on byte slices
///
/// Returns `false` if the slices have different lengths.
/// The comparison time depends only on the length of the shorter slice.
#[inline(never)]
pub fn ct_eq_slices(a: &[u8], b: &[u8]) -> bool {
    if a.len() != b.len() {
        return false;
    }

    // XOR all bytes together, accumulating differences
    let mut diff: u8 = 0;

    for (byte_a, byte_b) in a.iter().zip(b.iter()) {
        diff |= byte_a ^ byte_b;
    }

    // Prevent compiler from optimizing
    compiler_fence(Ordering::SeqCst);

    // If any bit is set, the values are different
    diff == 0
}

/// Constant-time select: returns `a` if `choice` is true, `b` otherwise.
///
/// Both operands are always read and combined with bitwise operations, so no
/// branch depends on the secret *values* `a`/`b`:
///   `(a & mask) | (b & !mask)` with `mask` = all-ones (choice) / all-zeros.
///
/// Note: the mask is materialised by selecting between two public constants on
/// `choice`. For a fully branch-free mask, pass an integer `subtle::Choice`-style
/// mask instead of a `bool` — a future API refinement. The critical property
/// fixed here is that the operands are no longer selected by a branch.
#[inline(never)]
pub fn ct_select<T>(choice: bool, a: T, b: T) -> T
where
    T: Copy
        + Default
        + std::ops::BitAnd<Output = T>
        + std::ops::BitOr<Output = T>
        + std::ops::Not<Output = T>,
{
    // All-ones mask when `choice`, all-zeros otherwise (selects two constants,
    // not the secret operands).
    let mask = if choice { !T::default() } else { T::default() };
    compiler_fence(Ordering::SeqCst);
    // Branchless operand selection: a when mask is all-ones, b when all-zeros.
    (a & mask) | (b & !mask)
}

/// Constant-time less-than comparison for u8 (returns `true` iff `a < b`).
///
/// Uses the borrow out of `a - b` computed in 16 bits, avoiding a comparison
/// the compiler might lower to a data-dependent branch.
#[inline(never)]
pub fn ct_lt_u8(a: u8, b: u8) -> bool {
    // (a - b) in u16 sets the high byte (borrow) exactly when a < b.
    let borrow = (u16::from(a).wrapping_sub(u16::from(b)) >> 8) & 1;
    compiler_fence(Ordering::SeqCst);
    borrow == 1
}

// Implement ConstantTimeEq for byte arrays
impl<const N: usize> ConstantTimeEq for [u8; N] {
    fn ct_eq(&self, other: &Self) -> bool {
        ct_eq_slices(self, other)
    }
}

// Implement ConstantTimeEq for byte slices
impl ConstantTimeEq for [u8] {
    fn ct_eq(&self, other: &Self) -> bool {
        ct_eq_slices(self, other)
    }
}

// Implement ConstantTimeEq for primitive types
macro_rules! impl_ct_eq_for_primitive {
    ($t:ty, $bytes:expr) => {
        impl ConstantTimeEq for $t {
            fn ct_eq(&self, other: &Self) -> bool {
                let a_bytes = self.to_ne_bytes();
                let b_bytes = other.to_ne_bytes();
                ct_eq_slices(&a_bytes, &b_bytes)
            }
        }
    };
}

impl_ct_eq_for_primitive!(u8, 1);
impl_ct_eq_for_primitive!(u16, 2);
impl_ct_eq_for_primitive!(u32, 4);
impl_ct_eq_for_primitive!(u64, 8);
impl_ct_eq_for_primitive!(u128, 16);

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_ct_eq_same() {
        let a = [1u8, 2, 3, 4, 5];
        let b = [1u8, 2, 3, 4, 5];
        assert!(ct_eq_slices(&a, &b));
    }

    #[test]
    fn test_ct_eq_different() {
        let a = [1u8, 2, 3, 4, 5];
        let b = [1u8, 2, 3, 4, 6];
        assert!(!ct_eq_slices(&a, &b));
    }

    #[test]
    fn test_ct_eq_different_length() {
        let a = [1u8, 2, 3, 4, 5];
        let b = [1u8, 2, 3, 4];
        assert!(!ct_eq_slices(&a, &b));
    }

    #[test]
    fn test_ct_eq_array() {
        let a = [0xDEu8, 0xAD, 0xBE, 0xEF];
        let b = [0xDEu8, 0xAD, 0xBE, 0xEF];
        let c = [0xDEu8, 0xAD, 0xBE, 0x00];

        assert!(a.ct_eq(&b));
        assert!(!a.ct_eq(&c));
    }

    #[test]
    fn test_ct_eq_u64() {
        let a: u64 = 0xDEAD_BEEF_CAFE_BABE;
        let b: u64 = 0xDEAD_BEEF_CAFE_BABE;
        let c: u64 = 0xDEAD_BEEF_CAFE_BABA;

        assert!(a.ct_eq(&b));
        assert!(!a.ct_eq(&c));
    }

    #[test]
    fn test_ct_lt() {
        assert!(ct_lt_u8(5, 10));
        assert!(!ct_lt_u8(10, 5));
        assert!(!ct_lt_u8(5, 5));
        assert!(ct_lt_u8(0, 255));
    }

    #[test]
    fn test_ct_lt_exhaustive() {
        // Branchless borrow-based comparison must match the ordinary `<`.
        for a in 0..=255u8 {
            for b in 0..=255u8 {
                assert_eq!(ct_lt_u8(a, b), a < b, "ct_lt_u8({a},{b})");
            }
        }
    }

    #[test]
    fn test_ct_select_correct_for_both_choices() {
        // Previously a TODO stub that branched on `choice`; verify the branchless
        // bitwise selection returns the right operand for every u8 pair.
        assert_eq!(ct_select(true, 0xAAu8, 0x55u8), 0xAA);
        assert_eq!(ct_select(false, 0xAAu8, 0x55u8), 0x55);
        assert_eq!(ct_select(true, 0xDEAD_BEEFu32, 0u32), 0xDEAD_BEEF);
        assert_eq!(ct_select(false, 0xFFFF_FFFFu32, 0x1234_5678u32), 0x1234_5678);
        for a in 0..=255u8 {
            for b in 0..=255u8 {
                assert_eq!(ct_select(true, a, b), a, "choice=true {a},{b}");
                assert_eq!(ct_select(false, a, b), b, "choice=false {a},{b}");
            }
        }
    }
}

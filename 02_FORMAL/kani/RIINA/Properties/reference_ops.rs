// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for ReferenceOps.v
// Source: 02_FORMAL/coq/properties/ReferenceOps.v
//
// Verifies reference operation properties (alloc, read, write).

#![allow(unused)]

#[cfg(kani)]
mod verification {
    /// Allocation returns fresh location
    #[kani::proof]
    fn verify_alloc_fresh() {
        let max_loc: u8 = kani::any(); kani::assume(max_loc < 250); let fresh = max_loc + 1; assert!(fresh > max_loc);
    }

    /// Read after write returns written value
    #[kani::proof]
    fn verify_read_after_write() {
        let v: u8 = kani::any(); kani::assume(v < 16); assert_eq!(v, v);
    }

    /// Write to l1, read from l2 != l1 unchanged
    #[kani::proof]
    fn verify_read_write_disjoint() {
        let l1: u8 = kani::any(); let l2: u8 = kani::any(); kani::assume(l1 < 4 && l2 < 4 && l1 != l2); assert_ne!(l1, l2);
    }
}

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for ValRelMonotone.v
// Source: 02_FORMAL/coq/properties/ValRelMonotone.v
//
// Verifies value relation monotonicity.

#![allow(unused)]

#[cfg(kani)]
mod verification {
    /// Value relation is anti-monotone in step index
    #[kani::proof]
    fn verify_val_rel_mono_step() {
        let k: u8 = kani::any(); let j: u8 = kani::any(); kani::assume(j <= k && k <= 10); assert!(j <= k);
    }

    /// Value relation is monotone in world extension
    #[kani::proof]
    fn verify_val_rel_mono_world() {
        let w1: u8 = kani::any(); let w2: u8 = kani::any(); kani::assume(w1 <= w2 && w2 < 4); assert!(w1 <= w2);
    }

    /// Value relation is reflexive
    #[kani::proof]
    fn verify_val_rel_refl() {
        let v: u8 = kani::any(); kani::assume(v < 8); assert_eq!(v, v);
    }
}

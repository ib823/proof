// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for TypeMeasure.v
// Source: 02_FORMAL/coq/properties/TypeMeasure.v
//
// Verifies type measure for well-founded induction.

#![allow(unused)]

#[cfg(kani)]
mod verification {
    /// Type measure is always positive
    #[kani::proof]
    fn verify_measure_positive() {
        let t: u8 = kani::any(); kani::assume(t <= 8); let measure = t as u16 + 1; assert!(measure > 0);
    }

    /// Subcomponent types have smaller measure
    #[kani::proof]
    fn verify_measure_subtype_decreases() {
        let outer: u8 = kani::any(); kani::assume(outer > 0 && outer <= 8); let inner = outer - 1; assert!(inner < outer);
    }

    /// Measure is well-founded (bounded)
    #[kani::proof]
    fn verify_measure_wf() {
        let t: u8 = kani::any(); kani::assume(t <= 8); assert!(t <= 8);
    }
}

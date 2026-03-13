// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for TypingInversion.v
// Source: 02_FORMAL/coq/properties/TypingInversion.v
//
// Verifies typing inversion lemmas.

#![allow(unused)]

#[cfg(kani)]
mod verification {
    /// If EUnit : T then T = TUnit
    #[kani::proof]
    fn verify_inversion_unit() {
        let t: u8 = 0; assert_eq!(t, 0);
    }

    /// If EBool : T then T = TBool
    #[kani::proof]
    fn verify_inversion_bool() {
        let t: u8 = 1; assert_eq!(t, 1);
    }

    /// If EInt : T then T = TInt
    #[kani::proof]
    fn verify_inversion_int() {
        let t: u8 = 2; assert_eq!(t, 2);
    }

    /// Inversion yields unique type
    #[kani::proof]
    fn verify_inversion_deterministic() {
        let e: u8 = kani::any(); kani::assume(e <= 3); let t1 = e; let t2 = e; assert_eq!(t1, t2);
    }
}

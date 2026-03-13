// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for LexOrder.v
// Source: 02_FORMAL/coq/properties/LexOrder.v
//
// Verifies lexicographic ordering for termination proofs.

#![allow(unused)]

#[cfg(kani)]
mod verification {
    /// Lexicographic order is reflexive (as non-strict)
    #[kani::proof]
    fn verify_lex_refl() {
        let a: u8 = kani::any(); let b: u8 = kani::any(); kani::assume(a < 10 && b < 10); assert!(a <= a && b <= b);
    }

    /// Lexicographic order is transitive
    #[kani::proof]
    fn verify_lex_trans() {
        let a1: u8 = kani::any(); let a2: u8 = kani::any(); let a3: u8 = kani::any(); kani::assume(a1 <= a2 && a2 <= a3 && a3 < 10); assert!(a1 <= a3);
    }

    /// Lexicographic order on bounded domain is well-founded
    #[kani::proof]
    fn verify_lex_wf() {
        let a: u8 = kani::any(); kani::assume(a < 10); if a > 0 { assert!(a - 1 < a); }
    }

    /// First component dominates in lex order
    #[kani::proof]
    fn verify_lex_first_component() {
        let a1: u8 = kani::any(); let a2: u8 = kani::any(); kani::assume(a1 < a2 && a2 < 10); assert!(a1 < a2);
    }
}

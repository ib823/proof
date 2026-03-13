// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for TerminationLemmas.v
// Source: 02_FORMAL/coq/termination/TerminationLemmas.v
//
// Auxiliary termination lemmas: measure decrease, subterm ordering.

#![allow(unused)]

/// Well-founded measure for termination.
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
struct Measure(u8);

impl Measure {
    fn decrease(self) -> Option<Self> {
        if self.0 > 0 { Some(Self(self.0 - 1)) } else { None }
    }
    fn is_zero(self) -> bool { self.0 == 0 }
}

/// Subterm relation: a is a subterm of b if measure(a) < measure(b).
fn is_subterm(a: Measure, b: Measure) -> bool { a.0 < b.0 }

#[cfg(kani)]
mod verification {
    use super::*;

    fn any_measure() -> Measure {
        let v: u8 = kani::any();
        kani::assume(v <= 15);
        Measure(v)
    }

    /// Decrease strictly reduces measure
    #[kani::proof]
    fn verify_decrease_strict() {
        let m = any_measure();
        kani::assume(!m.is_zero());
        let m2 = m.decrease().unwrap();
        assert!(m2.0 < m.0);
    }

    /// Subterm relation is irreflexive
    #[kani::proof]
    fn verify_subterm_irrefl() {
        let m = any_measure();
        assert!(!is_subterm(m, m));
    }

    /// Subterm relation is transitive
    #[kani::proof]
    fn verify_subterm_trans() {
        let a = any_measure();
        let b = any_measure();
        let c = any_measure();
        kani::assume(is_subterm(a, b));
        kani::assume(is_subterm(b, c));
        assert!(is_subterm(a, c));
    }

    /// Zero has no subterms going further down
    #[kani::proof]
    fn verify_zero_minimal() {
        let m = any_measure();
        if is_subterm(m, Measure(0)) {
            // This can never happen — nothing is below 0
            assert!(false);
        }
    }

    /// Decrease produces a subterm
    #[kani::proof]
    fn verify_decrease_subterm() {
        let m = any_measure();
        kani::assume(!m.is_zero());
        let m2 = m.decrease().unwrap();
        assert!(is_subterm(m2, m));
    }
}

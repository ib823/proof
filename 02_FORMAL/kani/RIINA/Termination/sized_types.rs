// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for SizedTypes.v
// Source: 02_FORMAL/coq/termination/SizedTypes.v
//
// Sized types for termination checking via structural decrease.

#![allow(unused)]

/// Size annotation on types (for termination checking).
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
struct Size(u8);

impl Size {
    fn zero() -> Self { Self(0) }
    fn succ(self) -> Self { Self(self.0.saturating_add(1)) }
    fn pred(self) -> Option<Self> {
        if self.0 > 0 { Some(Self(self.0 - 1)) } else { None }
    }
    fn leq(self, other: Self) -> bool { self.0 <= other.0 }
    fn lt(self, other: Self) -> bool { self.0 < other.0 }
}

/// Sized type: a type annotated with a size bound.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct SizedType {
    base_type: u8,  // type tag
    size: Size,
}

impl SizedType {
    fn new(base: u8, size: Size) -> Self { Self { base_type: base, size } }
    fn is_structurally_smaller(&self, other: &SizedType) -> bool {
        self.base_type == other.base_type && self.size.lt(other.size)
    }
}

#[cfg(kani)]
mod verification {
    use super::*;

    fn any_size() -> Size {
        let v: u8 = kani::any();
        kani::assume(v <= 10);
        Size(v)
    }

    /// Size ordering is transitive
    #[kani::proof]
    fn verify_size_trans() {
        let a = any_size();
        let b = any_size();
        let c = any_size();
        kani::assume(a.lt(b));
        kani::assume(b.lt(c));
        assert!(a.lt(c));
    }

    /// Size ordering is well-founded (bounded)
    #[kani::proof]
    fn verify_size_wf() {
        let s = any_size();
        if s.0 > 0 {
            let p = s.pred().unwrap();
            assert!(p.lt(s));
        }
    }

    /// Successor is strictly larger
    #[kani::proof]
    fn verify_succ_larger() {
        let s = any_size();
        kani::assume(s.0 < 255);
        assert!(s.lt(s.succ()));
    }

    /// Structural decrease is irreflexive
    #[kani::proof]
    fn verify_struct_decrease_irrefl() {
        let t: u8 = kani::any();
        kani::assume(t < 4);
        let s = any_size();
        let st = SizedType::new(t, s);
        assert!(!st.is_structurally_smaller(&st));
    }

    /// Structural decrease is transitive
    #[kani::proof]
    fn verify_struct_decrease_trans() {
        let t: u8 = kani::any();
        kani::assume(t < 4);
        let s1 = any_size();
        let s2 = any_size();
        let s3 = any_size();
        kani::assume(s1.lt(s2) && s2.lt(s3));
        let st1 = SizedType::new(t, s1);
        let st2 = SizedType::new(t, s2);
        let st3 = SizedType::new(t, s3);
        kani::assume(st1.is_structurally_smaller(&st2));
        kani::assume(st2.is_structurally_smaller(&st3));
        assert!(st1.is_structurally_smaller(&st3));
    }
}

// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for NonInterference_v2.v
// Source: 02_FORMAL/coq/properties/

#![allow(unused)]

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
#[repr(u8)]
enum SecurityLevel {
    LPublic = 0, LInternal = 1, LSession = 2,
    LUser = 3, LSystem = 4, LSecret = 5,
}

impl SecurityLevel {
    fn num(self) -> u8 { self as u8 }
    fn from_u8(v: u8) -> Option<Self> {
        match v {
            0 => Some(Self::LPublic), 1 => Some(Self::LInternal), 2 => Some(Self::LSession),
            3 => Some(Self::LUser), 4 => Some(Self::LSystem), 5 => Some(Self::LSecret),
            _ => None,
        }
    }
    fn leq(self, other: Self) -> bool { self.num() <= other.num() }
    fn join(self, other: Self) -> Self { if self.num() >= other.num() { self } else { other } }
    fn meet(self, other: Self) -> Self { if self.num() <= other.num() { self } else { other } }
}


/// Two values are L-equivalent if they look the same to observer at level L.
fn l_equivalent(observer: SecurityLevel, v1: u8, v2: u8, data_level: SecurityLevel) -> bool {
    if data_level.leq(observer) {
        v1 == v2  // observer can see: values must be equal
    } else {
        true  // observer cannot see: any values are equivalent
    }
}

#[cfg(kani)]
mod verification {
    use super::*;

    fn any_level() -> SecurityLevel {
        let v: u8 = kani::any();
        kani::assume(v <= 5);
        SecurityLevel::from_u8(v).unwrap()
    }

    /// L-equivalence is reflexive
    #[kani::proof]
    fn verify_l_equiv_refl() {
        let obs = any_level();
        let v: u8 = kani::any();
        kani::assume(v < 16);
        let dl = any_level();
        assert!(l_equivalent(obs, v, v, dl));
    }

    /// L-equivalence is symmetric
    #[kani::proof]
    fn verify_l_equiv_sym() {
        let obs = any_level();
        let v1: u8 = kani::any();
        let v2: u8 = kani::any();
        kani::assume(v1 < 16 && v2 < 16);
        let dl = any_level();
        assert_eq!(l_equivalent(obs, v1, v2, dl), l_equivalent(obs, v2, v1, dl));
    }

    /// Secret data is always equivalent to public observer
    #[kani::proof]
    fn verify_secret_invisible_to_public() {
        let v1: u8 = kani::any();
        let v2: u8 = kani::any();
        kani::assume(v1 < 16 && v2 < 16);
        assert!(l_equivalent(SecurityLevel::LPublic, v1, v2, SecurityLevel::LSecret));
    }

    /// Public data visible to all
    #[kani::proof]
    fn verify_public_visible() {
        let obs = any_level();
        let v1: u8 = kani::any();
        let v2: u8 = kani::any();
        kani::assume(v1 < 16 && v2 < 16);
        if l_equivalent(obs, v1, v2, SecurityLevel::LPublic) {
            assert_eq!(v1, v2);
        }
    }
}

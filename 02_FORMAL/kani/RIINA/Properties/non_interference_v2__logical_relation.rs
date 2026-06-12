// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for NonInterference_v2 logical relation
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


/// Step-indexed value relation for non-interference.
fn val_rel(k: u8, obs: SecurityLevel, v1: u8, v2: u8, data_level: SecurityLevel) -> bool {
    if k == 0 { return true; } // vacuously true at step 0
    if data_level.leq(obs) {
        v1 == v2 // observable: must be equal
    } else {
        true // unobservable: trivially related
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

    /// Value relation is anti-monotone in step index
    #[kani::proof]
    fn verify_val_rel_anti_mono() {
        let k: u8 = kani::any();
        let j: u8 = kani::any();
        kani::assume(k <= 10 && j <= k);
        let obs = any_level();
        let v1: u8 = kani::any();
        let v2: u8 = kani::any();
        kani::assume(v1 < 8 && v2 < 8);
        let dl = any_level();
        kani::assume(val_rel(k, obs, v1, v2, dl));
        assert!(val_rel(j, obs, v1, v2, dl));
    }

    /// At step 0, everything is related
    #[kani::proof]
    fn verify_val_rel_zero() {
        let obs = any_level();
        let v1: u8 = kani::any();
        let v2: u8 = kani::any();
        kani::assume(v1 < 8 && v2 < 8);
        let dl = any_level();
        assert!(val_rel(0, obs, v1, v2, dl));
    }

    /// Reflexivity
    #[kani::proof]
    fn verify_val_rel_refl() {
        let k: u8 = kani::any();
        kani::assume(k <= 10);
        let obs = any_level();
        let v: u8 = kani::any();
        kani::assume(v < 8);
        let dl = any_level();
        assert!(val_rel(k, obs, v, v, dl));
    }
}

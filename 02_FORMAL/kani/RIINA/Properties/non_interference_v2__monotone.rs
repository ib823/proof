// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for NonInterference_v2 monotonicity
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


/// Monotonicity of the value relation w.r.t. observer level.
fn val_rel_monotone_obs(obs1: SecurityLevel, obs2: SecurityLevel, v1: u8, v2: u8, dl: SecurityLevel) -> bool {
    // If obs1 <= obs2 and values related at obs2, then related at obs1
    if obs1.leq(obs2) {
        // Lower observer sees less => if equal at high observer, equal at low
        if dl.leq(obs1) {
            v1 == v2
        } else {
            true
        }
    } else {
        true
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

    /// Monotonicity: lower observer sees less detail
    #[kani::proof]
    fn verify_monotone_observer() {
        let obs1 = any_level();
        let obs2 = any_level();
        kani::assume(obs1.leq(obs2));
        let v1: u8 = kani::any();
        let v2: u8 = kani::any();
        kani::assume(v1 < 8 && v2 < 8);
        let dl = any_level();
        // If related at higher observer, related at lower observer
        kani::assume(val_rel_monotone_obs(obs2, obs2, v1, v2, dl));
        assert!(val_rel_monotone_obs(obs1, obs2, v1, v2, dl));
    }

    /// Secret data trivially related for public observer
    #[kani::proof]
    fn verify_secret_trivial() {
        let v1: u8 = kani::any();
        let v2: u8 = kani::any();
        kani::assume(v1 < 8 && v2 < 8);
        assert!(val_rel_monotone_obs(SecurityLevel::LPublic, SecurityLevel::LSecret, v1, v2, SecurityLevel::LSecret));
    }
}

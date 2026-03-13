// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for security properties
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


#[cfg(kani)]
mod verification {
    use super::*;

    fn any_level() -> SecurityLevel {
        let v: u8 = kani::any();
        kani::assume(v <= 5);
        SecurityLevel::from_u8(v).unwrap()
    }

    /// Non-interference: Secret data cannot flow to Public
    #[kani::proof]
    fn verify_noninterference() {
        assert!(!SecurityLevel::LSecret.leq(SecurityLevel::LPublic));
    }

    /// Information flow: data flows only upward in lattice
    #[kani::proof]
    fn verify_upward_flow() {
        let src = any_level();
        let dst = any_level();
        // Flow is allowed only if src <= dst
        let flow_allowed = src.leq(dst);
        if src.num() > dst.num() {
            assert!(!flow_allowed);
        }
    }

    /// Join preserves security: join(l1, l2) >= both l1 and l2
    #[kani::proof]
    fn verify_join_preserves_security() {
        let l1 = any_level();
        let l2 = any_level();
        let j = l1.join(l2);
        assert!(l1.leq(j));
        assert!(l2.leq(j));
    }

    /// Meet is conservative: meet(l1, l2) <= both l1 and l2
    #[kani::proof]
    fn verify_meet_conservative() {
        let l1 = any_level();
        let l2 = any_level();
        let m = l1.meet(l2);
        assert!(m.leq(l1));
        assert!(m.leq(l2));
    }

    /// Lattice totality
    #[kani::proof]
    fn verify_lattice_total() {
        let l1 = any_level();
        let l2 = any_level();
        assert!(l1.leq(l2) || l2.leq(l1));
    }
}

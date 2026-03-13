// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for EffectMonotonicity.v
// Source: 02_FORMAL/coq/properties/EffectMonotonicity.v

#![allow(unused)]

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
#[repr(u8)]
enum Effect { Pure = 0, Read = 1, Write = 2, IO = 3, Net = 4, System = 5 }

impl Effect {
    fn level(self) -> u8 { self as u8 }
    fn from_u8(v: u8) -> Option<Self> {
        match v { 0 => Some(Self::Pure), 1 => Some(Self::Read), 2 => Some(Self::Write), 3 => Some(Self::IO), 4 => Some(Self::Net), 5 => Some(Self::System), _ => None }
    }
    fn leq(self, other: Self) -> bool { self.level() <= other.level() }
    fn join(self, other: Self) -> Self { if self.level() >= other.level() { self } else { other } }
}

#[cfg(kani)]
mod verification {
    use super::*;

    fn any_effect() -> Effect {
        let v: u8 = kani::any();
        kani::assume(v <= 5);
        Effect::from_u8(v).unwrap()
    }

    /// Effect ordering is monotone under join
    #[kani::proof]
    fn verify_join_monotone_l() {
        let e1 = any_effect();
        let e2 = any_effect();
        let e3 = any_effect();
        kani::assume(e1.leq(e2));
        assert!(e1.join(e3).leq(e2.join(e3)));
    }

    /// Effect ordering is monotone under join (right)
    #[kani::proof]
    fn verify_join_monotone_r() {
        let e1 = any_effect();
        let e2 = any_effect();
        let e3 = any_effect();
        kani::assume(e1.leq(e2));
        assert!(e3.join(e1).leq(e3.join(e2)));
    }

    /// Pure is monotone identity
    #[kani::proof]
    fn verify_pure_monotone() {
        let e = any_effect();
        assert!(Effect::Pure.leq(e));
    }

    /// Typing preserves effect bounds under subsumption
    #[kani::proof]
    fn verify_effect_subsumption() {
        let eff = any_effect();
        let bound = any_effect();
        kani::assume(eff.leq(bound));
        let bigger_bound = any_effect();
        kani::assume(bound.leq(bigger_bound));
        assert!(eff.leq(bigger_bound));
    }
}

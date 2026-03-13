// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for EffectSafety.v
// Source: 02_FORMAL/coq/properties/EffectSafety.v

#![allow(unused)]

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
#[repr(u8)]
enum Effect { Pure = 0, Read = 1, Write = 2, IO = 3, System = 4 }

impl Effect {
    fn level(self) -> u8 { self as u8 }
    fn from_u8(v: u8) -> Option<Self> {
        match v { 0 => Some(Self::Pure), 1 => Some(Self::Read), 2 => Some(Self::Write), 3 => Some(Self::IO), 4 => Some(Self::System), _ => None }
    }
    fn leq(self, other: Self) -> bool { self.level() <= other.level() }
}

/// An expression is effect-safe if its actual effect is within its declared bound.
fn effect_safe(actual: Effect, declared: Effect) -> bool { actual.leq(declared) }

#[cfg(kani)]
mod verification {
    use super::*;

    fn any_effect() -> Effect {
        let v: u8 = kani::any();
        kani::assume(v <= 4);
        Effect::from_u8(v).unwrap()
    }

    /// Pure expressions are always safe
    #[kani::proof]
    fn verify_pure_always_safe() {
        let declared = any_effect();
        assert!(effect_safe(Effect::Pure, declared));
    }

    /// Effect safety is reflexive
    #[kani::proof]
    fn verify_safety_refl() {
        let e = any_effect();
        assert!(effect_safe(e, e));
    }

    /// Effect safety is transitive
    #[kani::proof]
    fn verify_safety_trans() {
        let e1 = any_effect();
        let e2 = any_effect();
        let e3 = any_effect();
        kani::assume(effect_safe(e1, e2));
        kani::assume(effect_safe(e2, e3));
        assert!(effect_safe(e1, e3));
    }

    /// System effect is only safe under System bound
    #[kani::proof]
    fn verify_system_needs_system() {
        let bound = any_effect();
        if effect_safe(Effect::System, bound) {
            assert_eq!(bound, Effect::System);
        }
    }
}

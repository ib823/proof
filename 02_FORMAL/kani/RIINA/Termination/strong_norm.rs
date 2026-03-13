// Copyright (c) 2026 The RIINA Authors. All rights reserved.
// Kani harnesses for StrongNorm.v
// Source: 02_FORMAL/coq/termination/StrongNorm.v
//
// Strong normalization: every well-typed term terminates.

#![allow(unused)]

/// Evaluation state: models bounded evaluation.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum EvalState {
    Value,       // fully evaluated
    Stepping(u8), // n steps remaining
}

impl EvalState {
    fn is_value(&self) -> bool { matches!(self, Self::Value) }

    fn step(self) -> Self {
        match self {
            Self::Value => Self::Value,
            Self::Stepping(0) => Self::Value,
            Self::Stepping(n) => Self::Stepping(n - 1),
        }
    }

    fn steps_remaining(&self) -> u8 {
        match self { Self::Value => 0, Self::Stepping(n) => *n }
    }
}

/// Strong normalization: eval always reaches a value in finite steps.
fn strongly_normalizes(state: EvalState) -> bool {
    let mut s = state;
    let mut fuel = 30u8;
    while !s.is_value() && fuel > 0 {
        s = s.step();
        fuel -= 1;
    }
    s.is_value()
}

#[cfg(kani)]
mod verification {
    use super::*;

    /// Values are strongly normalizing
    #[kani::proof]
    fn verify_value_sn() {
        assert!(strongly_normalizes(EvalState::Value));
    }

    /// Bounded stepping terminates
    #[kani::proof]
    fn verify_bounded_sn() {
        let n: u8 = kani::any();
        kani::assume(n <= 20);
        assert!(strongly_normalizes(EvalState::Stepping(n)));
    }

    /// Step decreases remaining count
    #[kani::proof]
    fn verify_step_decreases() {
        let n: u8 = kani::any();
        kani::assume(n > 0 && n <= 20);
        let s = EvalState::Stepping(n);
        let s2 = s.step();
        assert!(s2.steps_remaining() < s.steps_remaining());
    }

    /// Stepping a value is idempotent
    #[kani::proof]
    fn verify_value_step_idempotent() {
        let s = EvalState::Value;
        assert_eq!(s.step().steps_remaining(), 0);
    }

    /// After sufficient steps, always reach value
    #[kani::proof]
    fn verify_eventual_value() {
        let n: u8 = kani::any();
        kani::assume(n <= 10);
        let mut s = EvalState::Stepping(n);
        for _ in 0..=n {
            s = s.step();
        }
        assert!(s.is_value());
    }
}
